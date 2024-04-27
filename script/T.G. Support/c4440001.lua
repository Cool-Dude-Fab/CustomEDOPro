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

    -- Tribute and Special Summon from GY
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4440001,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetCountLimit(1,4440001+100)
    e2:SetCondition(c4440001.spcon)
    e2:SetCost(c4440001.spcost)
    e2:SetTarget(c4440001.sptg)
    e2:SetOperation(c4440001.spop)
    c:RegisterEffect(e2)

    -- Set "T.G." Spell/Trap when banished
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4440001,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetTarget(c4440001.settg)
    e3:SetOperation(c4440001.setop)
    e3:SetCountLimit(1,4440001+200)
    c:RegisterEffect(e3)
end

-- Special Summon Condition
function c4440001.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

-- Destroy Target
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

-- Tribute and Special Summon condition
function c4440001.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()~=tp
end

-- Tribute cost
function c4440001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end

-- Special Summon target
function c4440001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c4440001.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c4440001.spfilter(c,e,tp)
    return c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()<=10 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- Special Summon operation
function c4440001.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c4440001.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
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
