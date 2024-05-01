--Phantom Hand (Modified)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--Discard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.discardcon)
	e2:SetTarget(s.discardtg)
	e2:SetOperation(s.discardop)
	c:RegisterEffect(e2)
end

function s.discardcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xb),tp,LOCATION_MZONE,0,1,nil)
end

function s.discardtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISCARD,nil,1,tp,LOCATION_HAND)
end

function s.discardop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if #g>0 then
		local ct=Duel.DiscardHand(tp,aux.TRUE,1,#g,REASON_EFFECT+REASON_DISCARD)
		if ct==0 then
			Duel.Hint(HINT_MESSAGE, tp, "No cards were discarded.")
		end
	else
		Duel.Hint(HINT_MESSAGE, tp, "No discardable cards are available.")
	end
end
