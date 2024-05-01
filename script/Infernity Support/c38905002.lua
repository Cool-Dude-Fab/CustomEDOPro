--Enforcers, Together Forever!
local s,id=GetID()
function s.initial_effect(c)
    --Always treated as an "Infernity" card
    c:SetUniqueOnField(1,0,id)

    --Discard and Special Summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
        and Duel.IsPlayerCanDiscardHand(tp)
    end
    local dc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local d=Duel.DiscardHand(tp,nil,1,dc,REASON_DISCARD+REASON_EFFECT)
    e:SetLabel(d)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,d,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ct=e:GetLabel()
    if ct>0 then
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<ct then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
        if #g>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end

function s.spfilter(c,e,tp)
    return c:IsSetCard(0xb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
