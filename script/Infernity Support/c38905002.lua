--Enforcers, Together Forever!
local s,id=GetID()
function s.initial_effect(c)
    --Always treated as an "Infernity" card
    c:SetUniqueOnField(1,0,id)

    --Register activation of effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1, id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0 
               and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
    end
    local dc=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,dc,tp,LOCATION_DECK)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.DiscardHand(tp,nil,1,60,REASON_EFFECT+REASON_DISCARD)
    if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct then
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
