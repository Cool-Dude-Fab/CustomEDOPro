--Infernity Continual Call
local s,id=GetID()
function s.initial_effect(c)
    --Continuous Trap
    c:SetUniqueOnField(1,0,id)
    
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --Special Summon "Infernity" monster
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1, id)
    e2:SetCondition(s.condition)
    e2:SetCost(s.cost)
    e2:SetTarget(s.target)
    e2:SetOperation(s.operation)
    c:RegisterEffect(e2)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()~=tp
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=Duel.GetOperatedGroup():GetCount()
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0 and 
               Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,ct,e,tp)
    end
    local ct=Duel.GetOperatedGroup():GetCount()
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetOperatedGroup():GetCount()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or ct==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,ct,e,tp)
    if #sg>0 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
