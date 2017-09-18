require("hall.3DMahjongCard.Define")

D3_CARDDATA = require("hall.3DMahjongCard.CardData")

local ShowOperator = class("ShowOperator")

local inhandOperator = require("hall.3DMahjongCard.InhandOperator")
local outhandOperator = require("hall.3DMahjongCard.OuthandOperator")

D3_OUTHAND_ARR = {}
D3_HIGHLIGHT_OUT_CARDS = {}

D3_LATEST_OUT_CARD = nil
D3_WAIT_OPRATE_CARD = nil

local D3_POINTER

function ShowOperator:init(controller, playerType, inhandPlane, outhandPlane, floor)

	if not playerType then

		inhandOperator:init()
		outhandOperator:init()

		D3_CONTROLLER = controller

		D3_HIGHLIGHT_OUT_CARDS = {}

		D3_POINTER = ccui.Button:create()
		D3_POINTER:loadTextureNormal("hall/3DMahjongCard/image/target_bt.png")
		D3_POINTER:loadTextureDisabled("hall/3DMahjongCard/image/target_bt.png")

		floor:addChild(D3_POINTER)
		D3_POINTER:setTouchEnabled(false)
		D3_POINTER:setPosition(cc.p(0, 0))
		D3_POINTER:setLocalZOrder(5000)

		D3_POINTER:setVisible(false)

		-- dump(D3_POINTER, "test 0421 pointer")
	else
		inhandOperator:init(playerType, inhandPlane)
		outhandOperator:init(playerType, outhandPlane)

		D3_OUTHAND_ARR[playerType] = outhandPlane
	end

	D3_LATEST_OUT_CARD = nil
	D3_WAIT_OPRATE_CARD = nil
end



function ShowOperator:clearGameDatas(playerType, inhandPlane, outhandPlane)
	inhandOperator:clearGameDatas(playerType, inhandPlane)
	outhandOperator:clearGameDatas(playerType, outhandPlane)

	D3_LATEST_OUT_CARD = nil
	D3_WAIT_OPRATE_CARD = nil

	D3_HIGHLIGHT_OUT_CARDS = {}

	if D3_POINTER then
		--todo
		D3_POINTER:stopAllActions()
		D3_POINTER:setVisible(false)
	end
end

function ShowOperator:removeWaitingCard()
	if D3_WAIT_OPRATE_CARD and D3_WAIT_OPRATE_CARD:getParent() then
		--todo

		for i,v in ipairs(D3_HIGHLIGHT_OUT_CARDS) do
			if v == D3_WAIT_OPRATE_CARD then
				--todo
				table.remove(D3_HIGHLIGHT_OUT_CARDS, i)
			end
		end

		D3_WAIT_OPRATE_CARD:removeFromParent()

		D3_WAIT_OPRATE_CARD = nil
	
		D3_POINTER:stopAllActions()
		D3_POINTER:setVisible(false)
		
	end
end

function ShowOperator:revertOutCardPosition()
	inhandOperator:revertOutCardPosition()
end

function ShowOperator:cancelSelectingCard(plane)
	inhandOperator:cancelSelectingCard(plane)
end

function ShowOperator:removeCards(playerType, plane, removeCards, isRemoveNewCard)
	inhandOperator:removeCards(playerType, plane, removeCards, isRemoveNewCard)
end

function ShowOperator:showCards(playerType, plane, cardDatas, isNoNewCard, tingMode, tingSeq, ifAutoGetNewCard,blackCards)
	local t14thCard = nil
    

	dump(cardDatas,"cardDatas----------显示欧派数据------------")
	print(ifAutoGetNewCard,tingMode)
    if ifAutoGetNewCard  then

	    if not tingMode then
	          
	        local cardnum = table.getn(cardDatas)

	    	if cardnum%3 == 2 then
				t14thCard = cardDatas[cardnum]
				table.remove(cardDatas, cardnum)
			end

			inhandOperator:showCards(playerType, plane, cardDatas, isNoNewCard,blackCards)

			if t14thCard then
				self:getNewCard(playerType, plane, t14thCard, false)
			end

		else
			inhandOperator:showTingCards(plane, cardDatas, tingSeq, tingMode)
		end

	else

		if table.getn(cardDatas) == 14 then
			t14thCard = cardDatas[14]
			table.remove(cardDatas, 14)
		end

		inhandOperator:showCards(playerType, plane, cardDatas, isNoNewCard)

		if t14thCard then
			self:getNewCard(playerType, plane, t14thCard, false)
		end

	end


end

function ShowOperator:showCardsForAll( playerType, plane, anCards, showCards, isNoNewCard, untouchable)
	-- body
	inhandOperator:showCardsForAll(playerType, plane, anCards, showCards, isNoNewCard, untouchable)
end

function ShowOperator:redrawOuthandCards( playerType, plane, cards )
	plane:removeAllChildren()

	-- dump(cards, "test 0323")
	for i,v in ipairs(cards) do
		outhandOperator:playCard(playerType, v, plane)
	end
end

function ShowOperator:getNewCard(playerType, plane, value, isShow)
	inhandOperator:getNewCard(playerType, plane, value, isShow)

	D3_WAIT_OPRATE_CARD = nil
end

function ShowOperator:playCard( playerType, inhandPlane, outhandPlane, card )
	inhandOperator:playCard(playerType, inhandPlane, card)
	local outCardNode = outhandOperator:playCard(playerType, card, outhandPlane)

	self:showSelectedCards(card.m_value)

	local p = outhandPlane:convertToWorldSpace(outCardNode:getPosition())

	-- dump(D3_POINTER, "test 0421 pointer")

	D3_POINTER:setVisible(true)

	D3_POINTER:stopAllActions()

	D3_POINTER:setPosition(cc.p(p.x, p.y + 40))

	-- dump(p, "test 0421 pointer")
	
	local seqAction = cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(p.x, p.y + 30)), cc.MoveTo:create(0.5, cc.p(p.x, p.y + 50)))

	D3_POINTER:runAction(cc.RepeatForever:create(seqAction))
end

function ShowOperator:playCardForOuthand( playerType, outhandPlane, card, color )
	local outCardNode = outhandOperator:playCard(playerType, card, outhandPlane)

	if color then
		--todo
		outCardNode:setColor(color)
	end
end

--广播用户进行了什么操作
function ShowOperator:control(playerType, plane, progCards, controlType, removeCards, fromplayerType)

	if controlType == GANG_TYPE_BU then
		--todo
		inhandOperator:removeCards(playerType, plane, removeCards, true)
		inhandOperator:addGangCard(playerType, plane, progCards[1], false, fromplayerType)

		return
	end

	dump(removeCards, "-----ShowOperator:control1-----")

	if table.getn(removeCards) == 4 and controlType ~= GANG_TYPE_AN then
		--todo
		table.remove(removeCards, 4)
	end

	dump(removeCards, "-----ShowOperator:control2-----")
	dump(GANG_TYPE_AN, "-----ShowOperator:control GANG_TYPE_AN-----")
	dump(controlType, "-----ShowOperator:control-----")

	if controlType ~= GANG_TYPE_AN then
		inhandOperator:removeCards(playerType, plane, removeCards)
	else
		inhandOperator:removeCards(playerType, plane, removeCards, true)
	end
	
	inhandOperator:addProg(playerType, plane, progCards, controlType, fromplayerType)

	local offsetCardCount = 3 - table.getn(removeCards)

	if offsetCardCount ~= 1 then
		--todo
		offsetCardCount = 0
	end

	inhandOperator:movePosition(playerType, offsetCardCount, plane)

	if D3_WAIT_OPRATE_CARD and D3_WAIT_OPRATE_CARD:getParent() then
		--todo

		for i,v in ipairs(D3_HIGHLIGHT_OUT_CARDS) do
			if v == D3_WAIT_OPRATE_CARD then
				--todo
				table.remove(D3_HIGHLIGHT_OUT_CARDS, i)
			end
		end

		D3_WAIT_OPRATE_CARD:removeFromParent()

		D3_WAIT_OPRATE_CARD = nil

		
		D3_POINTER:stopAllActions()
		D3_POINTER:setVisible(false)
		
	end
end

function ShowOperator:redraw(playerType, inhandPlane, outhandPlane, progCards, handCards, outCards)
	-- dump(handCards, "test 0401 " .. playerType)

	inhandPlane:removeAllChildren()
	inhandOperator:redrawProgCards(playerType, inhandPlane, progCards)

	local t14thCard = nil
	if table.getn(handCards) == 14 then
		--todo
		t14thCard = handCards[14]
		table.remove(handCards, 14)
	end

	inhandOperator:showCards(playerType, inhandPlane, handCards)

	if t14thCard then
		--todo
		self:getNewCard(playerType, inhandPlane, t14thCard, false)
	end
	
	self:redrawOuthandCards(playerType, outhandPlane, outCards)
end

function ShowOperator:revertHighlightOutCards()
	for i,v in ipairs(D3_HIGHLIGHT_OUT_CARDS) do
		if v then
			--todo
			v:setColor(cc.c3b(255, 255, 255))
		end
	end
end

function ShowOperator:showSelectedCards(cardValue)
	self:revertHighlightOutCards()

	D3_HIGHLIGHT_OUT_CARDS = {}
	for i,v in ipairs(D3_OUTHAND_ARR) do
		if v then
			--todo
			local children = v:getChildren()
			for i1,v1 in ipairs(children) do
				if v1.m_value == cardValue then
					--todo
					v1:setColor(cc.c3b(255, 255, 150))
					table.insert(D3_HIGHLIGHT_OUT_CARDS, v1)
				end
			end
		end
	end
end

D3_SHOW_OPERATOR = ShowOperator

return ShowOperator