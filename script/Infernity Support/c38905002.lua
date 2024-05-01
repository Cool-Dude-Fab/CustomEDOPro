--Discard Dispatch
local s,id=GetID()
function s.initial_effect(c)
    --Activate: Discard 1 card
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISCARD)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_DISCARD,nil,1,tp,LOCATION_HAND)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
    if #g>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
    end
end
