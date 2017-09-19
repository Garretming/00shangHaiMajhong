local Card = require("hall.3DMahjongCard.Card")

local InhandOperator = class("InhandOperator")

local selectedTag = 99

local NEW_CARD_TAG = 20
local MY_OUT_CARD_TAG

local PROG_END_POINT_TABLE
local PROG_SPACE = 10
local GANGCARD = "gang"

local cardTemp = nil

local CARD_1_OFFSET_MY = 300
local CARD_2_OFFSET_MY = 450
local CARD_3_OFFSET_MY = 600
local CARD_5_OFFSET_MY = 680
local CARD_6_OFFSET_MY = 830
local CARD_7_OFFSET_MY = 980

local CARD_MY_MIDDLE = 4

local MY_INHAND_CARD_SPACE_MATRIX = {{-19, 0, 0, 0, 0, 0, 0}, {-20, -13, 0, 0, 0, 0, 0}, {0, -13, -8, 0, 0, 0, 0}, {0, 0, -6, -3, 0, 0, 0}, {0, 0, 0, -6, -8, 0, 0}, {0, 0, 0, 0, -13, -13, 0}, {0, 0, 0, 0, 0, -20, -19}}
local MY_INHAND_SHOW_CARD_SPACE_MATRIX = {{-19, -20, 0, 0, 0, 0, 0}, {0, -13, -13, 0, 0, 0, 0}, {0, 0, -8, -6, 0, 0, 0}, {0, 0, 0, -3, -6, 0, 0}, {0, 0, 0, 0, -8, -13, 0}, {0, 0, 0, 0, 0, -13, -20}, {0, 0, 0, 0, 0, 0, -19}}

--left
local LEFT_SCALE_OFFSET = 51 / 52
local LEFT_X_OFFSET = 8
local LEFT_CARD_HEIGHT = 42
local LEFT_Y_OFFSET = 16

local LEFT_OPPOSIVE_SCALE_OFFSET = 89 / 90
local LEFT_OPPOSIVE_X_OFFSET = 8
local LEFT_OPPOSIVE_CARD_HEIGHT = 51
local LEFT_OPPOSIVE_Y_OFFSET = 26

local LEFT_POSITIONX_FIX = 10    --6月30号增加

-- local LEFT_XIE_1 = 3.2857
local LEFT_XIE_1 = 3.32
local LEFT_XIE_2 = 3.8

local LEFT_BOTTOM_Y
local LEFT_ORI_SCALE = 1
local LEFT_OPPOSIVE_SCALE = 1.2
--right
local RIGHT_SCALE_OFFSET = 51 / 52
local RIGHT_X_OFFSET = 7
local RIGHT_CARD_HEIGHT = 42
local RIGHT_Y_OFFSET = 16

local RIGHT_OPPOSIVE_SCALE_OFFSET = 89 / 90
local RIGHT_OPPOSIVE_X_OFFSET = 7
local RIGHT_OPPOSIVE_CARD_HEIGHT = 51
local RIGHT_OPPOSIVE_Y_OFFSET = 26

local RIGHT_XIE_1 = LEFT_XIE_2
local RIGHT_XIE_2 = LEFT_XIE_1
-- local RIGHT_XIE_1 = 3.77
-- local RIGHT_XIE_2 = 3.2727

local RIGHT_BOTTOM_Y
--top
local CARD_1_OFFSET_TOP = 450
local CARD_2_OFFSET_TOP = 600
local CARD_4_OFFSET_TOP = 680
local CARD_5_OFFSET_TOP = 830

local TOP_POSITIONY_FIX = 15
local TOP_POSITIONX_FIX = 20

CARD_TOP_OPPOSIVE_MIDDLE = 3
CARD_TOP_SHOW_MIDDLE = 3
CARD_TOP_SHANG_MIDDLE = 3
CARD_TOP_HIDE_MIDDLE = 3

local TOP_INHAND_OPPOSIVE_CARD_SPACE_MATRIX = {{-8, -8, 0, 0, 0}, {0, -8, -7, 0, 0}, {0, 0, -5, -7, 0}, {0, 0, 0, -8, -8}, {0, 0, 0, 0, -8}}
local TOP_INHAND_SHOW_CARD_SPACE_MATRIX = {{-7, -7, 0, 0, 0}, {0, -7, -6, 0, 0}, {0, 0, -3, -3, 0}, {0, 0, 0, -7, -7}, {0, 0, 0, 0, -7}}
local TOP_SHANG_SHOW_CARD_SPACE_MATRIX = {{-8, -8, 0, 0, 0}, {-8, -9, -8, 0, 0}, {0, -8, -3, -8, 0}, {0, 0, -8, -9, -8}, {0, 0, 0, -8, -8}}

function InhandOperator:init(playerType, plane)
	if not playerType then
		PROG_END_POINT_TABLE = {}

		PROG_END_POINT_TABLE[1] = cc.p(0, 0)
		PROG_END_POINT_TABLE[2] = cc.p(0, 0)
		PROG_END_POINT_TABLE[3] = cc.p(0, 0)
		PROG_END_POINT_TABLE[4] = cc.p(-20, 0)   --6月28号修改牌的尺寸
	else
		if playerType == CARD_PLAYERTYPE_LEFT then
			LEFT_BOTTOM_Y = plane:convertToWorldSpace(cc.p(0, 0)).y
		elseif playerType == CARD_PLAYERTYPE_RIGHT then
			RIGHT_BOTTOM_Y = plane:convertToWorldSpace(cc.p(0, 0)).y

		end
	end
    
	-- dump(playerType, "CARD_PLAYERTYPE_RIGHT")
    
	-- dump(RIGHT_BOTTOM_Y, "RIGHT_BOTTOM_Y")
end

function InhandOperator:clearGameDatas(playerType, plane)
	PROG_END_POINT_TABLE = {}

	PROG_END_POINT_TABLE[1] = cc.p(0, 0)
	PROG_END_POINT_TABLE[2] = cc.p(0, 0)
	PROG_END_POINT_TABLE[3] = cc.p(0, 0)
	PROG_END_POINT_TABLE[4] = cc.p(-20, 0)     --6月28号修改牌的尺寸

	plane:removeAllChildren()
end

function InhandOperator:movePosition(playerType, offsetCardCount, plane)
	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		local offsetX = 0
		for i=1,offsetCardCount do
			-- dump(i, "test crash")
			local cardNode = plane:getChildByTag(i)
			offsetX = offsetX + cardNode:getSize().width * cardNode:getScale()
		end
		for i=1,15 do
			local cardNode = plane:getChildByTag(i)
			if not cardNode then
				break
			end

			cardNode:runAction(cc.MoveTo:create(0.3, cc.p(cardNode:getPosition().x + offsetX, cardNode:getPosition().y)))
		end
	elseif playerType == CARD_PLAYERTYPE_LEFT then
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
	elseif playerType == CARD_PLAYERTYPE_TOP then
	end
end

function InhandOperator:clearHandCards(plane)
	for i=1,14 do
		local cardNode = plane:getChildByTag(i)
		if cardNode then
			--todo
			cardNode:removeFromParent()
		end
	end
	local cardNode = plane:getChildByTag(NEW_CARD_TAG)
	if cardNode then
		--todo
		cardNode:removeFromParent()
	end
end

function InhandOperator:createCard(playerType, cardType, cardDisplayType, value, plane, oriX_card, fromPlayerType)
	local oriX_worldspace = plane:convertToWorldSpace(cc.p(oriX_card, 0)).x

	local result

	if playerType == CARD_PLAYERTYPE_MY then
		--todo

		if cardDisplayType == CARD_DISPLAY_TYPE_SHOW then
			--todo
			local shape = CARD_MY_MIDDLE;
			if oriX_worldspace < CARD_1_OFFSET_MY then
				--todo
				shape = 1 
			elseif oriX_worldspace < CARD_2_OFFSET_MY then
				shape = 2
			elseif oriX_worldspace < CARD_3_OFFSET_MY then
				shape = 3
			elseif oriX_worldspace > CARD_7_OFFSET_MY then
				shape = 7
			elseif oriX_worldspace > CARD_6_OFFSET_MY then
				shape = 6
			elseif oriX_worldspace > CARD_5_OFFSET_MY then
				shape = 5
			end

			result = Card:new(playerType, cardType, cardDisplayType, shape, value, fromPlayerType)
		elseif cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then
			result = Card:new(playerType, cardType, cardDisplayType, 0, value, fromPlayerType)
		end
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		result = Card:new(playerType, cardType, cardDisplayType, 0, value, fromPlayerType)
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		result = Card:new(playerType, cardType, cardDisplayType, 0, value, fromPlayerType)
	else
		if cardDisplayType == CARD_DISPLAY_TYPE_SHOW then
			--todo
			local shape = CARD_TOP_SHOW_MIDDLE;
			if oriX_worldspace < CARD_1_OFFSET_TOP then
				--todo
				shape = 1 
			elseif oriX_worldspace < CARD_2_OFFSET_TOP then
				shape = 2
			elseif oriX_worldspace > CARD_5_OFFSET_TOP then
				shape = 5
			elseif oriX_worldspace > CARD_4_OFFSET_TOP then
				shape = 4
			end

			result = Card:new(playerType, cardType, cardDisplayType, shape, value, fromPlayerType)
		elseif cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then
			local shape = CARD_TOP_OPPOSIVE_MIDDLE;
			if oriX_worldspace < CARD_1_OFFSET_TOP then
				--todo
				shape = 1 
			elseif oriX_worldspace < CARD_2_OFFSET_TOP then
				shape = 2
			elseif oriX_worldspace > CARD_5_OFFSET_TOP then
				shape = 5
			elseif oriX_worldspace > CARD_4_OFFSET_TOP then
				shape = 4
			end

			result = Card:new(playerType, cardType, cardDisplayType, shape, value, fromPlayerType)
		elseif cardDisplayType == CARD_DISPLAY_TYPE_HIDE then
			local shape = CARD_TOP_HIDE_MIDDLE;
			if oriX_worldspace < CARD_1_OFFSET_TOP then
				--todo
				shape = 1 
			elseif oriX_worldspace < CARD_2_OFFSET_TOP then
				shape = 2
			elseif oriX_worldspace > CARD_5_OFFSET_TOP then
				shape = 5
			elseif oriX_worldspace > CARD_4_OFFSET_TOP then
				shape = 4
			end

			result = Card:new(playerType, cardType, cardDisplayType, shape, value, fromPlayerType)
		end
	end

	return result
end

function InhandOperator:playCard(playerType, plane, card)
	local newCardNode = plane:getChildByTag(NEW_CARD_TAG)


	if playerType == CARD_PLAYERTYPE_MY then
		if newCardNode and selectedTag == NEW_CARD_TAG then
		--todo
			newCardNode:removeFromParent()
			selectedTag = 99
			return
		end

		local cardNode = plane:getChildByTag(selectedTag)

		if not cardNode then
			--todo

			if newCardNode and newCardNode.m_value == card.m_value then
				--todo
				newCardNode:removeFromParent()
			end

			selectedTag = 99
			return
		end

		if not newCardNode then
			--todo
			cardNode:removeFromParent()

			for i=selectedTag + 1,15 do
				cardNode = plane:getChildByTag(i)

				if not cardNode then
					--todo
					break
				end
				cardNode:setTag(i - 1)
				cardNode:runAction(cc.MoveTo:create(0.3, cc.p(cardNode:getPosition().x - cardNode:getSize().width * cardNode:getScale(), cardNode:getPosition().y)))
			end
		else
			--有新抓牌
			dump("test 0510 ---")

			--获取财神牌值
			local caishenCard
			if JS_CAISHEN then
				caishenCard = JS_CAISHEN[1]
			end

			dump(caishenCard, "-----caishenCard-----")

			--新牌牌值
			local newCardNode_value = newCardNode.m_value

			--插入位置
			local insertTag = 1
			for i=1,15 do
				local cardNodeTemp = plane:getChildByTag(i)

				dump(cardNodeTemp, "-----cardNodeTemp-----")

				--假如牌不存在，即这牌被打出
				if not cardNodeTemp then

					--判断当前是否为白板替身状态
					if isbaibantishen == 1 then

						if newCardNode_value == 67 then
							--新抓牌是白板，则不放在打出的牌的位置

							dump(newCardNode_value, "-----newCardNode_value1-----")

						else
							--新抓牌不是白板

							--记录插入位置为当前位
							insertTag = i

							--结束循环
							break

						end
					
					else

						dump("当前牌不存在", "-----cardNodeTemp-----")

						--记录插入位置为当前位
						insertTag = i

						--结束循环
						break

					end

				else

					--假如是白板替身
					if isbaibantishen == 1 then

						dump(newCardNode_value, "-----newCardNode_value2-----")

						--当前牌牌值
						local cardNodeTemp_value = cardNodeTemp.m_value

						if newCardNode_value == 67 then
							--新抓牌是白板

							dump("新抓牌是白板", "-----newCardNode_value2-----")

							--假如当前牌值大于财神牌值，则就是这个位置
							if cardNodeTemp_value > caishenCard then

								dump("当前牌牌值大于财神牌", "-----newCardNode_value3-----")

								--记录插入位置为当前位
								insertTag = i

								--结束循环
								break

							else

								dump("当前牌牌值小于等于财神牌", "-----newCardNode_value3-----")
								
							end

						else
							--新抓牌不是白板

							--判断新抓牌是否为财神
							if newCardNode_value == caishenCard then

								dump("记录插入位置为第一位", "-----当前新抓牌是否为财神-----")

								--记录插入位置为第一位
								insertTag = 1

								--结束循环
								break

							end

							--判断当前牌是否为白板
							if cardNodeTemp_value == 67 then

								dump("用财神牌牌值代替当前牌值", "-----当前牌牌值是白板-----")

								--是白板那把当前牌值用财神牌替换
								cardNodeTemp_value = caishenCard
							end

							if cardNodeTemp_value > newCardNode_value then

								dump("当前牌牌值大于或等于新抓牌牌值", "-----newCardNode_value4-----")

								if cardNodeTemp.type ~= 3 then

									dump("当前牌不是财神", "-----newCardNode_value4-----")

									--记录插入位置为当前位
									insertTag = i

									--结束循环
									break
									
								end

							else

								dump("当前牌牌值小于新抓牌牌值", "-----newCardNode_value4-----")
								
							end

						end

					end

				end

				--牌排序类型对比
				if Card:compare(cardNodeTemp, newCardNode) == 1 then

					if isbaibantishen == 1 then

						dump(Card:compare(cardNodeTemp, newCardNode), "-----Card:compare1-----")

						-- if newCardNode_value == 67 then
						-- 	--新抓牌是白板，则不放在打出的牌的位置

						-- else
						-- 	--新抓牌不是白板

						-- 	--记录插入位置为当前位
						-- 	insertTag = i

						-- 	--结束循环
						-- 	break

						-- end

					else

						dump(Card:compare(cardNodeTemp, newCardNode), "-----Card:compare2-----")
					
						--记录插入位置为当前位
						insertTag = i

						--结束循环
						break

					end

				end
			end

			local desPosition
			if insertTag == selectedTag or insertTag == selectedTag + 1 then
				--新牌直接跟出牌调换位置
				desPosition = cc.p(self.cardOriPosition.x, newCardNode:getSize().height * newCardNode:getScale() / 2)
				newCardNode:setTag(cardNode:getTag())
			elseif insertTag < selectedTag then
				local desNode = plane:getChildByTag(insertTag)
				desPosition = cc.p(desNode:getPosition().x, desNode:getSize().height * desNode:getScale() / 2)
				for i=selectedTag - 1,insertTag,-1 do
					local cardNodeTemp = plane:getChildByTag(i)
					cardNodeTemp:setTag(cardNodeTemp:getTag() + 1)
					cardNodeTemp:runAction(cc.MoveTo:create(0.3, cc.p(cardNodeTemp:getPosition().x + cardNodeTemp:getSize().width * cardNodeTemp:getScale(), cardNodeTemp:getSize().height * cardNodeTemp:getScale() / 2)))
				end
				newCardNode:setTag(insertTag)
			else
				local desNode = plane:getChildByTag(insertTag - 1)
				desPosition = cc.p(desNode:getPosition().x, desNode:getSize().height * desNode:getScale() / 2)
				for i=selectedTag + 1,insertTag - 1 do
					local cardNodeTemp = plane:getChildByTag(i)
					cardNodeTemp:setTag(cardNodeTemp:getTag() - 1)
					cardNodeTemp:runAction(cc.MoveTo:create(0.3, cc.p(cardNodeTemp:getPosition().x - cardNodeTemp:getSize().width * cardNodeTemp:getScale(), cardNodeTemp:getSize().height * cardNodeTemp:getScale() / 2)))
				end
				newCardNode:setTag(insertTag - 1)
			end

			cardNode:removeFromParent()
			local moveAc1 = cc.MoveTo:create(0.1, cc.p(newCardNode:getPosition().x, newCardNode:getSize().height * newCardNode:getScale() * 2))
			local moveAc2 = cc.MoveTo:create(0.2, cc.p(desPosition.x, newCardNode:getSize().height * newCardNode:getScale() * 2))
			local moveAc3 = cc.MoveTo:create(0.1, desPosition)
			local seqAc = cc.Sequence:create(moveAc1, moveAc2, moveAc3)

			newCardNode:runAction(seqAc)
		end

		selectedTag = 99
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		if newCardNode then
			--todo
			newCardNode:removeFromParent()
			return
		end

		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)
			if cardNode then
				--todo
				cardNode:removeFromParent()
				break
			end
		end
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		if newCardNode then
			--todo
			newCardNode:removeFromParent()
			return
		end

		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)
			if cardNode then
				--todo
				cardNode:removeFromParent()
				break
			end
		end
	elseif playerType == CARD_PLAYERTYPE_TOP then
		if newCardNode then
			--todo
			newCardNode:removeFromParent()
			return
		end

		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)
			if cardNode then
				--todo
				cardNode:removeFromParent()
				break
			end
		end
	end

end

function InhandOperator:removeCards(playerType, plane, removeCards, isRemoveNewCard)

	dump(removeCards, "-----InhandOperator:removeCards-----")

	local oriRemoveCount = table.getn(removeCards)

	if isRemoveNewCard then
		--todo
		local newCardNode = plane:getChildByTag(NEW_CARD_TAG)
		if playerType == CARD_PLAYERTYPE_MY then
			--todo
			if newCardNode and newCardNode.m_value == removeCards[table.getn(removeCards)] then
				--todo
				newCardNode:removeFromParent()
				table.remove(removeCards, table.getn(removeCards))
			end
		else
			if newCardNode then
				newCardNode:removeFromParent()
				table.remove(removeCards, table.getn(removeCards))
			end
		end
			
	end

	if not removeCards then
		--todo
		return
	end

	local removeCount = table.getn(removeCards)

	if removeCount == 0 then
		--todo
		return
	end

	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		local maxIndex = 15

		local cardTable = {}

		for i = 1, maxIndex do
			local cardNode = plane:getChildByTag(i)

			if not cardNode then
				--todo
				break
			end

			cardTable[i] = cardNode
		end

		if oriRemoveCount > 1 then
			--todo
			local newCardNode = plane:getChildByTag(NEW_CARD_TAG)

			if newCardNode then
				--todo
				--若没移除新牌
				removeCount = removeCount - 1
			end

			local removeIndex = 1
			local index = 1
			for i=1,table.getn(cardTable) do
				if removeIndex <= removeCount and cardTable[i].m_value == removeCards[removeIndex] then
					--todo
					cardTable[i]:removeFromParent()
					removeIndex = removeIndex + 1
				else
					cardTable[i]:setShape(cardTable[index + removeCount].m_shape)
					if newCardNode then
						--todo
						cardTable[i]:setPosition(cardTable[index + removeCount]:getPosition())
					else
						cardTable[i]:runAction(cc.MoveTo:create(0.3, cardTable[index + removeCount]:getPosition()))
					end
					

					cardTable[i]:setTag(index)
					index = index + 1
				end
			end

			if newCardNode then
				--相当于打出一张未移除的非新牌
				for i=1,15 do
					local cardNode = plane:getChildByTag(i)
					if cardNode and cardNode.m_value == removeCards[removeCount + 1] then
						--todo
						selectedTag = i
						self.cardOriPosition = cardNode:getPosition()
						break
					end
				end
				-- dump(selectedTag, "test 0510")

				self:playCard(playerType, plane, D3_CARDDATA:new(removeCards[removeCount + 1], 1, CARDNODE_TYPE_NORMAL))
			end
		else
			local newCardTemp = plane:getChildByTag(NEW_CARD_TAG)

			if newCardTemp then
				--todo
				--处理在非新牌中取牌补杠的情况
				--相当于打出一张未移除的非新牌
				for i=1,15 do
					local cardNode = plane:getChildByTag(i)
					if cardNode and cardNode.m_value == removeCards[1] then
						--todo
						selectedTag = i
						self.cardOriPosition = cardNode:getPosition()
						break
					end
				end

				self:playCard(playerType, plane, D3_CARDDATA:new(removeCards[1], 1, CARDNODE_TYPE_NORMAL))
			else
				--处理在非新牌中取牌补杠的情况
				for i=table.getn(cardTable),1,-1 do
					if cardTable[i].m_value == removeCards[1] then
						--todo
						cardTable[i]:removeFromParent()

						break
					else
						cardTable[i]:setShape(cardTable[i - 1].m_shape)
						cardTable[i]:runAction(cc.MoveTo:create(0.3, cardTable[i - 1]:getPosition()))

						cardTable[i]:setTag(i - 1)
					end
				end
			end
			
		end
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		local count = 0
		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)

			if cardNode then
				--todo
				cardNode:removeFromParent()
				count = count + 1
				if count == removeCount then
					--todo
					break
				end
			end
		end
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		local count = 0
		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)

			if cardNode then
				--todo
				cardNode:removeFromParent()
				count = count + 1
				if count == removeCount then
					--todo
					break
				end
			end
		end
	elseif playerType == CARD_PLAYERTYPE_TOP then
		local count = 0
		for i=15,1,-1 do
			local cardNode = plane:getChildByTag(i)

			if cardNode then
				--todo
				cardNode:removeFromParent()
				count = count + 1
				if count == removeCount then
					--todo
					break
				end
			end
		end
	end
end


--摊牌
function InhandOperator:showCardsForAll(playerType, plane, anCards, showCards, isNoNewCard, untouchable)
	self:clearHandCards(plane)

	local cardsTemp = {}

	for i,v in ipairs(showCards) do
		table.insert(cardsTemp, v)
	end	
    
	for i,v in ipairs(anCards) do
		v.m_value = v.m_value + 200
		table.insert(cardsTemp, v)
	end

	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		local size = plane:getSize()
		local oriX = size.width

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, oriX)

		if not isNoNewCard then
			oriX = oriX - card:getSize().width * card:getScale() - 15
		end

		local lastShape = 0

		-- dump(cardsTemp, "cardsTemp print")

		local isOverMiddle = false

		for i=table.getn(cardsTemp),1,-1 do
			local cardData = cardsTemp[i]

			local card

			if cardData.m_value > 180 then

				cardData.m_value = cardData.m_value - 200
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX)
				
				card:setColor(cc.c3b(140, 140, 140))
			else
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX)
			end

			card:setTag(i)

			if isOverMiddle then
				--todo
				card:setLocalZOrder(i)
			else
				card:setLocalZOrder(200 - i)
			end

			-- dump(oriX, "oriX print")

            if untouchable then
				card:setTouchEnabled(true)
				card:addTouchEventListener(function(sender, event)

					if event == TOUCH_EVENT_BEGAN then
						return
					end

				end)

			else
				card:setTouchEnabled(false)
			end
	
			local offset

			if lastShape == 0 then
				--todo
				offset = 0
			else
				offset = MY_INHAND_CARD_SPACE_MATRIX[lastShape][card.m_shape]
			end

			if card.m_shape >= CARD_MY_MIDDLE then
				--todo
				if card.m_shape == CARD_MY_MIDDLE then
					--todo
					isOverMiddle = true
					card:setLocalZOrder(200)
				end
				
			end

			card:setPosition(cc.p(oriX - card:getSize().width * card:getScale() / 2 - offset, card:getSize().height * card:getScale() / 2))

			plane:addChild(card)

			oriX = oriX - card:getSize().width * card:getScale() - offset

			lastShape = card.m_shape
		end

		-- plane:setSize(cc.size(oriX, size.height))
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		print("gang lefthand test")
		local size = plane:getSize()

		local count = table.getn(cardsTemp)

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, 0)

		local oriY = LEFT_CARD_HEIGHT * LEFT_ORI_SCALE - LEFT_Y_OFFSET * LEFT_ORI_SCALE + 15

		local oriX = oriY / LEFT_XIE_1
		
		local scale = (card:getSize().width * LEFT_ORI_SCALE + oriY / LEFT_XIE_2 - oriY / LEFT_XIE_1) / (card:getSize().width * LEFT_ORI_SCALE) * LEFT_ORI_SCALE

		for i=table.getn(cardsTemp),1,-1 do
			local cardData = cardsTemp[i]

			local card

			if cardData.m_value < 180 then
				--todo
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0)
			else
				card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_HIDE, 0, cardData)
			end

			card:setTag(i)
			card:setLocalZOrder(i)

			card:setScale(scale)

			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2 - LEFT_POSITIONX_FIX , oriY + card:getSize().height * card:getScale() / 2))

			plane:addChild(card)

			scale = card:getScale() * LEFT_SCALE_OFFSET

			oriX = oriX + LEFT_X_OFFSET * card:getScale()
			oriY = oriY + LEFT_CARD_HEIGHT * card:getScale() - LEFT_Y_OFFSET * scale
		end

		-- plane:setSize(cc.size(plane:getSize().width, oriY))
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		--todo
		local size = plane:getSize()
		
		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, 0)
		local width = card:getSize().width * card:getScale()

		local oriY = size.height
		local scale = (width * LEFT_ORI_SCALE - (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_2 + (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_1) / (width * LEFT_ORI_SCALE) / RIGHT_SCALE_OFFSET * LEFT_ORI_SCALE

		oriY = oriY - card:getSize().height * scale
		local oriX = 0 - oriY / RIGHT_XIE_1

		for i=table.getn(cardsTemp),1,-1 do
			local cardData = cardsTemp[i]

			local card

			if cardData.m_value < 180 then
				--todo
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0)
			else
				card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_HIDE, 0, cardData)
			end

			card:setScale(scale)

			card:setTag(i)

			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, oriY + card:getSize().height * card:getScale() / 2))

			card:setLocalZOrder(200 - i)
			plane:addChild(card)

			scale = card:getScale() / RIGHT_SCALE_OFFSET

			oriX = oriX + RIGHT_X_OFFSET * card:getScale()
			oriY = oriY - RIGHT_CARD_HEIGHT * scale + RIGHT_Y_OFFSET * card:getScale()
		end

		-- plane:setSize(cc.size(plane:getSize().width, oriY + (RIGHT_CARD_HEIGHT - RIGHT_Y_OFFSET) * lastScale))
	elseif playerType == CARD_PLAYERTYPE_TOP then
		local oriX = 0

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, oriX)

		oriX = oriX + card:getSize().width * card:getScale() + 15

		local lastShape = 0

		local isOverMiddle = false

		-- dump(cardsTemp, "test 0428")

		for i=table.getn(cardsTemp),1,-1 do
			local cardData = cardsTemp[i]

			local card

			if cardData.m_value > 180 then
				--todo
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_HIDE, cardData, plane, oriX)
			else
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX)
			end

			if isOverMiddle then
				--todo
				card:setLocalZOrder(i)
			else
				
				card:setLocalZOrder(200 - i)
			end

			card:setTag(i)

			-- dump(oriX, "oriX print")

			card:setTouchEnabled(false)
			
			local offset

			if lastShape == 0 then
				--todo
				offset = 0
			else
				offset = TOP_INHAND_SHOW_CARD_SPACE_MATRIX[lastShape][card.m_shape]
			end

			if card.m_shape >= CARD_TOP_SHOW_MIDDLE then
				--todo
				

				if card.m_shape == CARD_TOP_SHOW_MIDDLE then
					--todo
					isOverMiddle = true
					card:setLocalZOrder(200)
				end
			end
            
            --6月28日修改牌尺寸
			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2 + offset - TOP_POSITIONX_FIX , card:getSize().height * card:getScale() / 2-TOP_POSITIONY_FIX))

			plane:addChild(card)

			oriX = oriX + card:getSize().width * card:getScale() + offset

			lastShape = card.m_shape
		end

		-- plane:setSize(cc.size(oriX, size.height))
	end
end


function InhandOperator:revertOutCardPosition()
	if cardTemp and self.oriSelectedPosition then
		--todo
		selectedTag = 99
		cardTemp:setPosition(self.oriSelectedPosition)
	end
end


function InhandOperator:showCards(playerType, plane, cardDatas, isNoNewCard,blackCarrds)

	self:clearHandCards(plane)
    
	if playerType == CARD_PLAYERTYPE_MY then
		selectedTag = 99

		local oriX = plane:getSize().width
		local oriY = plane:getSize().height / 2

		local isTing = 0 or tingFlag

		self.moving = false

		local function onTouchBegan(touch, event)

			dump(D3_CHUPAI, "test if can touch")

		    if D3_CHUPAI == 1 and not self.moving then
		    	--todo
		    	cardTemp = nil
		    	local children = plane:getChildren()
		    	for k,v in pairs(children) do
		        	
				    --todo
				    local locationInNode = v:convertToNodeSpace(touch:getLocation())

					local s = v:getContentSize()
					local rect = cc.rect(0, 0, s.width, s.height)
					if cc.rectContainsPoint(rect, locationInNode) then
						cardTemp = v
						self.cardOriPosition = cardTemp:getPosition()
					end
				        	
				end

				if cardTemp and (not tolua.isnull(cardTemp)) and cardTemp:getTag() > 0 then
					
					self.moving = true 

					if cardTemp.m_value > 80 then    --牌值大于80，即为花牌
						return false
					end

					if selectedTag == 99 then
						--todo
						self.canMove = true

						self.oriSelectedPosition = cardTemp:getPosition()
					else
						if selectedTag ~= cardTemp:getTag() then
							--todo
							self.oriSelectedPosition = cardTemp:getPosition()
						end

						self.canMove = false
					end

					D3_CONTROLLER:didSelectOutCard(cardTemp.m_value)

					return true
				else
					return false
				end
		    end

		    return false
		end

		local function onTouchCancell(touch, event)
			if cardTemp then
				self.moving = false
				-- self:cancelSelectingCard(plane)
			end
		end

		local function onTouchMoved(touch, event)
		    if cardTemp and self.canMove and  (not tolua.isnull(cardTemp)) then
		    	self.moving = true

		    	local posX = cardTemp:getPositionX()
		    	local posY = cardTemp:getPositionY()
		    	local delta = touch:getDelta()
		    	cardTemp:setPosition(cc.p(posX + delta.x, posY + delta.y))
		    end
		end

		local function onTouchEnded(touch, event)
		   	if cardTemp and (not tolua.isnull(cardTemp)) then
		   		
		   		self.moving = false

		   		local offsetY = cardTemp:getPosition().y - cardTemp:getSize().height / 2
		   		if offsetY > plane:getSize().height then
		   			--超出范围，出牌
		   			selectedTag = cardTemp:getTag()
		   			D3_CONTROLLER:playCard(cardTemp.m_value)
		   			-- cardTemp:removeFromParent()
		   		else

		   			-- cardTemp:setPosition(self.oriSelectedPosition)

		   			-- return

		   			local locationInNode = cardTemp:convertToNodeSpace(touch:getLocation())
		   			local rect = cc.rect(0, 0, cardTemp:getContentSize().width, cardTemp:getContentSize().height)
					if cc.rectContainsPoint(rect, locationInNode) then
						if selectedTag == cardTemp:getTag() then
						    --出牌
							D3_CONTROLLER:playCard(cardTemp.m_value)
						else
							cardTemp:setColor(cc.c3b(255,255,255))
							self:cancelSelectingCard(plane)
							if cardTemp.m_value == HHMJ_LAIZI then
								cardTemp:setColor(cc.c3b(255, 255, 0))
			       				cardTemp:setOpacity(230)
							end

							local p = cardTemp:getPosition()

							if self.canMove then
								--todo
								p = self.cardOriPosition
							end

							cardTemp:setPosition(cc.p(p.x, p.y + 30))

							local tag = cardTemp:getTag()
							selectedTag = tag

							

							D3_SHOW_OPERATOR:showSelectedCards(cardTemp.m_value)
						end
					else
						cardTemp:setColor(cc.c3b(255,255,255))
						if cardTemp.m_value == HHMJ_LAIZI then
							cardTemp:setColor(cc.c3b(255, 255, 0))
			       			cardTemp:setOpacity(230)
						end
						self:cancelSelectingCard(plane)
					end
		   			
		   		end
		   	end
		end

		local listener1 = cc.EventListenerTouchOneByOne:create()
   		listener1:setSwallowTouches(true)
		listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
		listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		listener1:registerScriptHandler(onTouchCancell,cc.Handler.EVENT_TOUCH_CANCELLED )

		local eventDispatcher = SCENENOW["scene"]:getEventDispatcher()

		eventDispatcher:addEventListenerWithSceneGraphPriority(listener1:clone(), plane)
		    
		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, nil, plane, 0)

		local cardWidth = card:getSize().width * card:getScale()

		if not isNoNewCard then
			--todo
			oriX = oriX - cardWidth - 15
		end

		for i=table.getn(cardDatas), 1, -1 do
			local data = cardDatas[i]

			card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data, plane, 0)

			card:setPosition(cc.p(oriX - card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))

			card:setTouchEnabled(false)

			-- eventDispatcher:addEventListenerWithSceneGraphPriority(listener1:clone(), card)

			if cardDatas[i] == HHMJ_LAIZI then
				card:setColor(cc.c3b(255, 255, 0))
			    card:setOpacity(230)
			end
			-- --显示听弃牌
			dump(JS_TING_REMOVE,"-- --JS_TING_REMOVE-----------------显示听弃牌")
			-- print("cardDatas[i]--".. data)

			
			if JS_TING_REMOVE ~= nil  then
				for m,n in pairs(JS_TING_REMOVE) do
			-- print("cardDatas[i]-data.m_value,n-".. data.m_value,n)
					if data.m_value == n then
						card:setColor(cc.c3b(150, 150, 150))
					end
				end
				
			end
			

			card:setTag(i)

			plane:addChild(card)

			oriX = oriX - cardWidth
		end
		-- plane:setSize(cc.size(width, plane:getSize().height))
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		--todo
		local size = plane:getSize()

		local count = table.getn(cardDatas)

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, nil, plane, 0)

		local oriY = LEFT_OPPOSIVE_CARD_HEIGHT * LEFT_OPPOSIVE_SCALE - LEFT_OPPOSIVE_Y_OFFSET * LEFT_OPPOSIVE_SCALE + 15

		local oriX = oriY / LEFT_XIE_1
		
		-- local scale = (card:getSize().width * LEFT_OPPOSIVE_SCALE + oriY / LEFT_XIE_2 - oriY / LEFT_XIE_1) / (card:getSize().width * LEFT_OPPOSIVE_SCALE) * LEFT_OPPOSIVE_SCALE
		-- local scale = (card:getSize().width * LEFT_OPPOSIVE_SCALE + oriY / LEFT_XIE_2 - oriY / LEFT_XIE_1) / (card:getSize().width * LEFT_OPPOSIVE_SCALE) * 1

		for i=1, count do
			local cardData = cardDatas[i]

			local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, cardData, plane, 0)

			card:setLocalZOrder(200 - i)

			local scale = (card:getSize().width * LEFT_OPPOSIVE_SCALE + oriY / LEFT_XIE_2 - oriY / LEFT_XIE_1) / (card:getSize().width * LEFT_OPPOSIVE_SCALE) * LEFT_OPPOSIVE_SCALE

			card:setScale(scale)

			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2 - LEFT_POSITIONX_FIX, oriY + card:getSize().height * card:getScale() / 2))

			plane:addChild(card)

			card:setTag(i)

			-- scale = scale * LEFT_OPPOSIVE_SCALE_OFFSET

			oriX = oriX + LEFT_OPPOSIVE_X_OFFSET * card:getScale()
			oriY = oriY + LEFT_OPPOSIVE_CARD_HEIGHT * card:getScale() - (LEFT_OPPOSIVE_Y_OFFSET * card:getScale() * LEFT_OPPOSIVE_SCALE_OFFSET)
		end

		-- plane:setSize(cc.size(plane:getSize().width, oriY))
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		local size = plane:getSize()
		
		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, nil, plane, 0)
		local width = card:getSize().width * card:getScale()
		local height = card:getSize().height * card:getScale()

		local oriY = size.height
		-- local scale = (width * LEFT_OPPOSIVE_SCALE - (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_2 + (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_1) / (width * LEFT_OPPOSIVE_SCALE) / RIGHT_OPPOSIVE_SCALE_OFFSET * LEFT_OPPOSIVE_SCALE

		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, cardData, plane, 0)

			local relativeY = oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y
			local scale = (RIGHT_XIE_1 * RIGHT_XIE_2 * width * LEFT_OPPOSIVE_SCALE - RIGHT_XIE_1 * relativeY + RIGHT_XIE_2 * relativeY) / (RIGHT_XIE_1 * RIGHT_XIE_2 * width * LEFT_OPPOSIVE_SCALE + RIGHT_XIE_2 * height - RIGHT_XIE_1 * height) * LEFT_OPPOSIVE_SCALE
			oriY = oriY - card:getSize().height * scale
			local oriX = 0 - oriY / RIGHT_XIE_1

			card:setScale(scale)

			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, oriY + card:getSize().height * card:getScale() / 2))

	
			card:setTag(i)

			card:setLocalZOrder(i)

			plane:addChild(card)

			-- scale = scale / RIGHT_OPPOSIVE_SCALE_OFFSET

			-- oriX = oriX + RIGHT_OPPOSIVE_X_OFFSET * card:getScale()
			-- oriY = oriY - RIGHT_OPPOSIVE_CARD_HEIGHT * scale + RIGHT_OPPOSIVE_Y_OFFSET * card:getScale()
			oriY = oriY + RIGHT_OPPOSIVE_Y_OFFSET * card:getScale()
		end
	elseif playerType == CARD_PLAYERTYPE_TOP then
		local oriX = 0

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, nil, plane, oriX)

		oriX = oriX + card:getSize().width * card:getScale() + 10 + 20      --6月28号修改牌的尺寸

		local lastShape = 0

		local isOverMiddle = false

		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, cardData, plane, oriX)

			if isOverMiddle then
				--todo
				card:setLocalZOrder(200 - i)
			else
				card:setLocalZOrder(i)
			end

			card:setTag(i)

			-- dump(oriX, "oriX print")

			card:setTouchEnabled(false)
			
			local offset

			if lastShape == 0 then
				--todo
				offset = 0
			else
				offset = TOP_INHAND_OPPOSIVE_CARD_SPACE_MATRIX[lastShape][card.m_shape]
			end

			if card.m_shape >= CARD_TOP_OPPOSIVE_MIDDLE then
				--todo
				isOverMiddle = true

				if card.m_shape == CARD_TOP_OPPOSIVE_MIDDLE then
					card:setLocalZOrder(200)
				end
			end
           
            --6月28日修改牌尺寸添加了“-10”
			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2 + offset - TOP_POSITIONX_FIX , card:getSize().height * card:getScale()/2-TOP_POSITIONY_FIX))

			plane:addChild(card)

			oriX = oriX + card:getSize().width * card:getScale() + offset

			lastShape = card.m_shape
		end

		-- plane:setSize(cc.size(oriX, size.height))
	end
end

function InhandOperator:cancelSelectingCard(plane)
	if selectedTag == 99 then
		--todo
		return
	end

	-- SZKWX_CONTROLLER:hideTingHuPlane()

	local selectedCard = plane:getChildByTag(selectedTag)

	if selectedCard then
		selectedCard:setPosition(cc.p(selectedCard:getPosition().x, selectedCard:getSize().height * selectedCard:getScale() / 2))
		selectedTag = 99
	end

	D3_SHOW_OPERATOR:revertHighlightOutCards()
end

function InhandOperator:getNewCard(playerType, plane, value, isShow)
	local displayType

	if isShow then
		--todo
		displayType = CARD_DISPLAY_TYPE_SHOW
	else
		displayType = CARD_DISPLAY_TYPE_OPPOSIVE
	end

	if playerType == CARD_PLAYERTYPE_MY then

		local size = plane:getSize()

		local card = self:createCard(playerType, CARD_TYPE_INHAND, displayType, value, plane, size.width)
		card:setTag(NEW_CARD_TAG)
		if value == HHMJ_LAIZI then
			card:setColor(cc.c3b(255, 255, 0))
			card:setOpacity(230)
		end

		card:setTouchEnabled(false)

		card:setPosition(cc.p(size.width - card:getSize().width / 2 * card:getScale(), card:getSize().height * card:getScale() / 2))

		plane:addChild(card)
		
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		local card = self:createCard(playerType, CARD_TYPE_INHAND, displayType, value, plane, 0)

		if isShow then
			--todo
			card:setScale(LEFT_ORI_SCALE)
		else
			card:setScale(LEFT_OPPOSIVE_SCALE)
		end
		

		card:setTag(NEW_CARD_TAG)
		card:setLocalZOrder(200)

		card:setPosition(cc.p(card:getSize().width * card:getScale() / 2 - LEFT_POSITIONX_FIX, card:getSize().height / 2))

		plane:addChild(card)
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		local size = plane:getSize()
		
		-- local cardTemp = plane:getChildByTag(1)

		local card = self:createCard(playerType, CARD_TYPE_INHAND, displayType, value, plane, 0)
		local width = card:getSize().width * card:getScale()

		local oriY = size.height + 15

		-- if cardTemp then
		-- 	--todo
		-- 	oriY = oriY - cardTemp:getSize().height * cardTemp:getScale()
		-- else
		-- 	oriY = oriY - 30
		-- end

		local scale

		if isShow then
			--todo
			scale = (width * LEFT_ORI_SCALE - (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_2 + (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_1) / (width * LEFT_ORI_SCALE) / RIGHT_OPPOSIVE_SCALE_OFFSET * LEFT_ORI_SCALE
		else
			scale = (width * LEFT_OPPOSIVE_SCALE - (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_2 + (oriY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_1) / (width * LEFT_OPPOSIVE_SCALE) / RIGHT_OPPOSIVE_SCALE_OFFSET * LEFT_OPPOSIVE_SCALE
		end

		oriY = oriY - (card:getSize().height - RIGHT_Y_OFFSET) * scale
		local oriX = 0 - oriY / RIGHT_XIE_1

		card:setTag(NEW_CARD_TAG)
		card:setLocalZOrder(0)
		card:setScale(scale)
		card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, oriY + card:getSize().height * card:getScale() / 2))

		plane:addChild(card)
	elseif playerType == CARD_PLAYERTYPE_TOP then
		local card = self:createCard(playerType, CARD_TYPE_INHAND, displayType, value, plane, 0)

		card:setPosition(cc.p(card:getSize().width * card:getScale() / 2 - TOP_POSITIONX_FIX + 5, card:getSize().height * card:getScale() / 2 - TOP_POSITIONY_FIX))

		card:setTag(NEW_CARD_TAG)

		plane:addChild(card)
	end
	
end

function InhandOperator:showTingCards(plane, cards, tingSeq, tingMode)
	self:clearHandCards(plane)

	selectedTag = 99
  
	local oriX = PROG_END_POINT_TABLE[1].x +50
	local oriY = plane:getSize().height / 2

		for i=1,table.getn(cards) do
			local data = cards[i]

			local isTing = false
             
			for k,v in pairs(tingSeq) do
				if data.m_value == v.card then
					--todo
					isTing = true
					break
				end
			end

			local card = self:createCard(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data, plane, 0)
			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))
			card:setTag(i)

			if isTing then
				--todo

				if tingMode == "liang"  then
					card:setTouchEnabled(true)
				elseif tingMode == "reverse" then
					card:setTouchEnabled(false)
                end

				card:addTouchEventListener(function(sender, event)

				if event == TOUCH_EVENT_ENDED then
					
					if selectedTag == sender:getTag() then
						
							
					else
							self:cancelSelectingCard(plane)

							local p = sender:getPosition()

							sender:setPosition(cc.p(p.x, p.y + 30))

							local tag = sender:getTag()
							selectedTag = tag

							D3_CONTROLLER:didSelectOutCard(sender.m_value)

							for k,v in pairs(tingSeq) do
								if v.card == sender.m_value then
									--todo
									D3_CONTROLLER:showComponentSelectBox(v)

									break
								end
							end
					end

				end

				end)
			else

				card:addTouchEventListener(function(sender, event)

				if event == TOUCH_EVENT_BEGAN then
					return
				end

				end)
	
				if tingMode == "liang"  then

					card:setTouchEnabled(true)
					card:setColor(cc.c3b(150, 150, 150))

				elseif tingMode == "reverse" then

                    card:setTouchEnabled(false)
					card:setColor(cc.c3b(255, 255, 255))

				end
			end

			card:setTag(i)

			plane:addChild(card)

			oriX = oriX + card:getSize().width * card:getScale()
		end
end

function InhandOperator:addProg(playerType, plane, progCards, controlType, fromplayerType)

	if bit.band(controlType, GANG_TYPE_BU) > 0 then  --补杠

	    local floorCard = plane:getChildByName(progCards[1].m_value .. GANGCARD)
		
		if not floorCard then     
			self:addGangCard(playerType, plane, progCards[1], false)
		else 
			local fromplayerType = floorCard.m_fromplayerType
			self:addGangCard(playerType, plane, progCards[1], false,fromplayerType)
		end

	else
		self:addCards(playerType, plane, progCards, fromplayerType)

		if bit.band(controlType, CONTROL_TYPE_GANG) > 0 then
			--todo
			if bit.band(controlType, GANG_TYPE_AN) > 0 then    --暗杠
				--todo
				self:addGangCard(playerType, plane, progCards[1], true)
			else                                                  --明杠
				self:addGangCard(playerType, plane, progCards[1], false, fromplayerType)
			end
		
		end
	end
	
end



function InhandOperator:addGangCard(playerType, plane, card, isAg, fromplayerType)
	local floorCard = plane:getChildByName(card.m_value .. GANGCARD)

	if not floorCard then
		--todo
		return
	end

	local showType
	if isAg then
		--todo
		showType = CARD_DISPLAY_TYPE_HIDE
	else
		showType = CARD_DISPLAY_TYPE_SHOW
	end

	local cardNode = Card:new(playerType, CARD_TYPE_INHAND, showType, floorCard.m_shape, card, fromplayerType)
	cardNode:setScale(floorCard:getScale())

	cardNode:setTouchEnabled(false)

	local p = floorCard:getPosition()

	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		local offsetX = 0

		if cardNode.m_shape == 1 then
			--todo
			offsetX = -9
		elseif cardNode.m_shape == 2 then
			offsetX = -9
		elseif cardNode.m_shape == 3 then
			offsetX = -6
		elseif cardNode.m_shape == 5 then
			offsetX = 6
		elseif cardNode.m_shape == 6 then
			offsetX = 9
		elseif cardNode.m_shape == 7 then
			offsetX = 9
		end

		cardNode:setPosition(cc.p(p.x + offsetX, p.y + 23))
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		cardNode:setPosition(cc.p(p.x + 5 * cardNode:getScale(), p.y + LEFT_Y_OFFSET * cardNode:getScale()))
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		cardNode:setPosition(cc.p(p.x - 5 * cardNode:getScale(), p.y + RIGHT_Y_OFFSET * cardNode:getScale()))
	elseif playerType == CARD_PLAYERTYPE_TOP then
		local offsetX = 0

		if cardNode.m_shape == 1 then
			--todo
			offsetX = -3
		elseif cardNode.m_shape == 2 then
			offsetX = -3
		elseif cardNode.m_shape == 4 then
			offsetX = 3
		elseif cardNode.m_shape == 5 then
			offsetX = 3
		end

		cardNode:setPosition(cc.p(p.x + offsetX, p.y + 18))
	end

	cardNode:setLocalZOrder(1000)
	plane:addChild(cardNode)
end

function InhandOperator:addCards(playerType, plane, cardDatas, fromplayerType)
	if table.getn(cardDatas) < 3 then
		--todo
		return
	end

	if table.getn(cardDatas) == 4 then
		--todo
		table.remove(cardDatas, 4)
	end

	local isSame
	if cardDatas[1].m_value == cardDatas[2].m_value then
		--todo
		isSame = true
	else
		isSame = false
	end
	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		local size = plane:getSize()
		local oriX = PROG_END_POINT_TABLE[playerType].x + PROG_SPACE

		local lastShape = 0

		local isOverMiddle = false

		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			local card
            
            if i == 2 then
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX, fromplayerType)
            else
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX)
            end

			if isOverMiddle then
				--todo
				card:setLocalZOrder(200 - i)
			else
				card:setLocalZOrder(i)
			end

			-- dump(oriX, "oriX print")

			card:setTouchEnabled(false)
			
			local offset

			if lastShape == 0 then
				--todo
				offset = 0
			else
				offset = MY_INHAND_SHOW_CARD_SPACE_MATRIX[lastShape][card.m_shape]
			end

			if card.m_shape >= CARD_MY_MIDDLE then
				--todo
				isOverMiddle = true

				if card.m_shape == CARD_MY_MIDDLE then
					card:setLocalZOrder(200)
				end
			end

			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2 + offset, card:getSize().height * card:getScale() / 2))

			plane:addChild(card)

			oriX = oriX + card:getSize().width * card:getScale() + offset

			lastShape = card.m_shape

			if i == 2 and isSame then
				--todo
				card:setName(cardData.m_value .. GANGCARD)
			end
		end

		PROG_END_POINT_TABLE[playerType] = cc.p(oriX, 0)
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		local size = plane:getSize()
		local progY = size.height - PROG_SPACE - PROG_END_POINT_TABLE[playerType].y

		-- dump(PROG_END_POINT_TABLE[playerType].y, "test 0405")

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, 0)

		local scale = (card:getSize().width * LEFT_ORI_SCALE + progY / LEFT_XIE_2 - progY / LEFT_XIE_1) / (card:getSize().width * LEFT_ORI_SCALE) / LEFT_SCALE_OFFSET

		progY = progY - card:getSize().height * scale
		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			local card 
              
            if i == 2 then
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0, fromplayerType)
            else
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0)
            end

			card:setScale(scale)

			card:setPosition(cc.p(progY / LEFT_XIE_1 + card:getSize().width * scale / 2, progY + card:getSize().height * scale / 2))

			plane:addChild(card)

			if i == 2 and isSame then
				--todo
				card:setName(cardData.m_value .. GANGCARD)
			end

			scale = scale / LEFT_SCALE_OFFSET

			progY = progY - card:getSize().height * scale + LEFT_Y_OFFSET * card:getScale()
		end

		PROG_END_POINT_TABLE[playerType].y = size.height - (progY + card:getSize().height * scale)

		-- dump(PROG_END_POINT_TABLE[playerType].y, "test 0405")

	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		--todo
		local progY = PROG_SPACE + PROG_END_POINT_TABLE[playerType].y

		local card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, nil, plane, 0)
		local width = card:getSize().width * card:getScale()

		local scale = (width * LEFT_ORI_SCALE - (progY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_2 + (progY + RIGHT_BOTTOM_Y - LEFT_BOTTOM_Y) / RIGHT_XIE_1) / (width * LEFT_ORI_SCALE) * LEFT_ORI_SCALE

		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			local card 
           
            if i == 2 then
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0, fromplayerType)
            else
				card = self:createCard(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, 0)
            end

			card:setScale(scale)

			card:setPosition(cc.p(0 - progY / RIGHT_XIE_1 + card:getSize().width * scale / 2, progY + card:getSize().height * scale / 2))

			card:setLocalZOrder(200 - i + (500 - math.floor(progY)))

			plane:addChild(card)

			if i == 2 and isSame then
				--todo
				card:setName(cardData.m_value .. GANGCARD)
			end

			progY = progY + card:getSize().height * scale - RIGHT_Y_OFFSET * scale

			scale = scale * RIGHT_SCALE_OFFSET
		end

		PROG_END_POINT_TABLE[playerType].y = progY

	elseif playerType == CARD_PLAYERTYPE_TOP then
		local size = plane:getSize()
		local oriX = size.width - PROG_END_POINT_TABLE[playerType].x - PROG_SPACE

		local lastShape = 0

		local isOverMiddle = false

		for i=1,table.getn(cardDatas) do
			local cardData = cardDatas[i]

			local card
           
            if i == 2 then
				card = self:createCard(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX, fromplayerType)
            else
				card = self:createCard(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_SHOW, cardData, plane, oriX)
            end

			if isOverMiddle then
				--todo
				card:setLocalZOrder(200 - i)
			else
				card:setLocalZOrder(i)
			end

			-- dump(oriX, "oriX print")

			card:setTouchEnabled(false)
			
			local offset

			if lastShape == 0 then
				--todo
				offset = 0
			else
				offset = TOP_SHANG_SHOW_CARD_SPACE_MATRIX[lastShape][card.m_shape]
			end

			if card.m_shape <= CARD_TOP_SHANG_MIDDLE then
				--todo
				isOverMiddle = true

				if card.m_shape == CARD_TOP_SHANG_MIDDLE then
					card:setLocalZOrder(200)
				end
			end
            
            --6月28号
			card:setPosition(cc.p(oriX - card:getSize().width * card:getScale() / 2 - offset, card:getSize().height * card:getScale() / 2-TOP_POSITIONY_FIX))

			plane:addChild(card)

			oriX = oriX - card:getSize().width * card:getScale() - offset

			lastShape = card.m_shape

			if i == 2 and isSame then
				--todo
				card:setName(cardData.m_value .. GANGCARD)
			end
		end

		PROG_END_POINT_TABLE[playerType] = cc.p(size.width - oriX, 0)
	end
end

function InhandOperator:redrawProgCards(playerType, plane, progCards)
	local count = table.getn(progCards)

	for i=1,count do
		self:addProg(playerType, plane, progCards[i].cards, progCards[i].type, progCards[i].fromPlayerType)
	end
end

return InhandOperator