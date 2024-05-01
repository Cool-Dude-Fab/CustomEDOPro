--Infernity Resurgence
local s,id=GetID()
function s.initial_effect(c)
    --Continuous Trap Card
    c:SetUniqueOnField(1,0,id)

    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --Special Summon "Infernity" monsters
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1, id)
    e2:SetCost(s.spcost)
    e2:SetTarget(s.sptarget)
    e2:SetOperation(s.spoperation)
    c:RegisterEffect(e2)
end

function s.costfilter(c)
    return c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
    local rt=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xb)
    local disc=Duel.DiscardHand(tp, s.costfilter, 1, rt, REASON_COST+REASON_DISCARD)
    e:SetLabel(disc)
end

function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=e:GetLabel()
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
           and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,ct,nil,e,tp)
    end
    local ct=e:GetLabel()
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_DECK)
end

function s.spoperation(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0xb) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
