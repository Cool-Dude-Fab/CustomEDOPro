--Magic Mallet Reimagined
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    --Activate from hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(s.handcon)
    c:RegisterEffect(e2)

    --Add from deck to hand
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(s.thcon)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,e:GetHandler()) and
               Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,LOCATION_HAND,0,1,63,nil)
    if #g==0 then return end
    local ct=Duel.SendtoGrave(g,REASON_EFFECT)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,ct,e,tp)
        if #sg>0 then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

function s.spfilter(c,level,e,tp)
    return c:IsSetCard(0xb) and c:IsLevel(level) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsReason(REASON_RETURN)
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thfilter(c)
    return c:IsSetCard(0xb) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

function s.handcon(e)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xb),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
