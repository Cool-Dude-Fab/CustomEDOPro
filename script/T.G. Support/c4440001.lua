local s,id=GetID()
-- T.G. Scope Blaster
function c4440001.initial_effect(c)
    -- Synchro Summon
    c:EnableReviveLimit()
    Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_TUNER),1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,99)
    
    -- Destroy target when Special Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(4440001,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c4440001.descon)
    e1:SetTarget(c4440001.destg)
    e1:SetOperation(c4440001.desop)
    e1:SetCountLimit(1,4440001)
    c:RegisterEffect(e1)

    -- Protection for "T.G." Synchro Monsters
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4440001,1))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c4440001.reptg)
    e2:SetValue(c4440001.repval)
    e2:SetOperation(c4440001.repop)
    c:RegisterEffect(e2)

    -- Set "T.G." Spell/Trap when banished
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4440001,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c4440001.setcond)
    e3:SetTarget(c4440001.settg)
    e3:SetOperation(c4440001.setop)
    e3:SetCountLimit(1,4440001+100)
    c:RegisterEffect(e3)
end

-- Destroy target condition
function c4440001.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

-- Destroy target target
function c4440001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

-- Destroy target operation
function c4440001.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

-- Protection Replace
function c4440001.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4440001.repfilter,tp,LOCATION_GRAVE,0,1,nil)
        and Duel.CheckEvent(EVENT_DESTROYED, true) and Duel.IsChainNegatable(ev) end
    local g=Duel.GetMatchingGroup(c4440001.repfilter, tp, LOCATION_MZONE, 0, nil)
    return g:IsExists(c4440001.desfilter, 1, nil, e)
end

function c4440001.repval(e,c)
    return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO)
end

function c4440001.repfilter(c)
    return c:IsSetCard(0x27) and c:IsAbleToRemoveAsCost()
end

function c4440001.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c4440001.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_COST)
    end
end

-- Set Spell/Trap Condition
function c4440001.setcond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup()
end

-- Set Spell/Trap Target
function c4440001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4440001.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end

function c4440001.stfilter(c)
    return c:IsSetCard(0x27) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

-- Set Spell/Trap Operation
function c4440001.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c4440001.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g)
        Duel.ConfirmCards(1-tp,g)
    end
end
