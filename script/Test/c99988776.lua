-- Enemy Negation
local SET_TEST=0x3220
local s,id=GetID()
function s.initial_effect
    c:SetType(EFFECT_TYPE_QUICK_O)
    c:SetCode(EVENT_FREE_CHAIN)
    c:SetProperty(EFFECT_FLAG_CARD_TARGET)
    c:SetRange(LOCATION_HAND+LOCATION_SZONE)
    c:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    c:SetCondition(c99999998.condition)
    c:SetTarget(c99999998.target)
    c:SetOperation(c99999998.operation)
end
s.listed_series={SET_TEST}

-- Activation condition (Can always activate)
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return true
end

-- Target Function: Target 1 face-up monster your opponent controls
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

-- Operation Function: Negate the effects of the targeted monster
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
