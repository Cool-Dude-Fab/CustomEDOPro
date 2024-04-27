local SET_TG=0x27
local s,id=GetID()
-- T.G. Blade Blaster
function c10000007.initial_effect(c)
    -- Synchro Summon
    c:EnableReviveLimit()
    aux.AddSynchroProcedure(c,nil,1,1,aux.NonTuner(nil),1,99)
    
    -- Destroy target when Special Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10000007,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e1:SetCondition(c10000007.descon)
    e1:SetTarget(c10000007.destg)
    e1:SetOperation(c10000007.desop)
    e1:SetCountLimit(1,10000007)
    c:RegisterEffect(e1)

    -- Protect "T.G." Synchro Monsters
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(10000007,1))
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c10000007.reptg)
    e2:SetValue(c10000007.repval)
    e2:SetOperation(c10000007.repop)
    c:RegisterEffect(e2)

    -- Set "T.G." Spell/Trap
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10000007,2))
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c10000007.setcond)
    e3:SetTarget(c10000007.settg)
    e3:SetOperation(c10000007.setop)
    e3:SetCountLimit(1,10000007+100)
    c:RegisterEffect(e3)
end

-- Destroy target
function c10000007.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function c10000007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c10000007.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

-- Replacement effect
function c10000007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReason(REASON_EFFECT)
        and Duel.IsExistingMatchingCard(c10000007.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end

function c10000007.repval(e,c)
    return c:IsOnField() and c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO)
end

function c10000007.repfilter(c)
    return c:IsSetCard(0x27) and c:IsAbleToRemove()
end

function c10000007.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c10000007.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end

-- Set "T.G." Spell/Trap
function c10000007.setcond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsFaceup()
end

function c10000007.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c10000007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end

function c10000007.filter(c)
    return c:IsSetCard(0x27) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

function c10000007.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c10000007.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g)
        Duel.ConfirmCards(1-tp,g)
    end
end
