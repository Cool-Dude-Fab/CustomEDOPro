--Magic Mallet Reimagined
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)  -- Updated category for special summon
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
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
        -- Special summon from Deck 1 "Infernity" monster whose level is equal to the number of cards sent to the GY
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
