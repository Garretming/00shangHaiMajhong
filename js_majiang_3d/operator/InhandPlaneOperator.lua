
--获取牌定义类
local Card = require("js_majiang_3d.card.card")

--获取牌操作工具类
local cardUtils = require("js_majiang_3d.utils.cardUtils")

local InhandPlaneOperator = class("InhandPlaneOperator")

local SPLIT_NEWCARD = 25

local selectedTag = 99

local NEW_CARD_TAG = 20

local cardTemp = nil

--初始化自己区域(左下侧碰杠区)
function InhandPlaneOperator:init(playerType, plane)

	--移除操作区域上的所有牌
	plane:removeAllChildren()

	-- if playerType == CARD_PLAYERTYPE_MY then
	-- 	--todo
	-- 	plane:setSize(cc.size(0, plane:getSize().height))
	-- elseif playerType == CARD_PLAYERTYPE_LEFT then
	-- 	plane:setSize(cc.size(plane:getSize().width, 0))
	-- elseif playerType == CARD_PLAYERTYPE_RIGHT then
	-- 	plane:setSize(cc.size(plane:getSize().width, 0))
	-- elseif playerType == CARD_PLAYERTYPE_TOP then
	-- 	plane:setSize(cc.size(0, plane:getSize().height))
	-- end
	
end

--显示手牌
function InhandPlaneOperator:showCards(playerType, plane, cardDatas,tingSeq)

	dump("显示手牌", "-----showCards-----")

	--对传入牌进行排序
	table.sort(cardDatas)

	local cardsSeq = {}
	local laiziSeq = {}
	local caishenSeq = {}
	local baibanSeq = {}

	--挑出赖子，财神，白板（白板替身的情况下）
	for k,v in pairs(cardDatas) do

        if v == HHMJ_LAIZI then

			local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_LAIZI)

			table.insert(laiziSeq, 1, cardData)

		else

			local isCaishen = false
			for k1,v1 in pairs(JS_CAISHEN) do
				
				if v == v1 then
					isCaishen = true
				end

			end

			if isCaishen then

				local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
				table.insert(caishenSeq, 1, cardData)
				
			else

				if isbaibantishen == 1 then

					if v == 67 then
					
						local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
						table.insert(baibanSeq, cardData)

					else

						local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
						table.insert(cardsSeq, cardData)

					end
				
				else

					local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
					table.insert(cardsSeq, cardData)

				end

			end

		end

	end

	--获取财神牌值
	local caishenCard = JS_CAISHEN[1]

	--把白板插入到替换牌的位置上
	local xiaoYuCaiShenSeq = {}
	local daYuCaiShenSeq = {}
	local newCardsSeq = {}
	for k,v in pairs(cardsSeq) do
		if v.m_value < caishenCard then
			table.insert(xiaoYuCaiShenSeq, v)
		else
			table.insert(daYuCaiShenSeq, v)
		end
	end

	--插入小于财神的牌到新牌数组
	for k,v in pairs(xiaoYuCaiShenSeq) do
		table.insert(newCardsSeq, v)
	end

	--插入白板到新牌数组
	for k,v in pairs(baibanSeq) do
		table.insert(newCardsSeq, v)
	end

	--插入大于财神的牌到新牌数组
	for k,v in pairs(daYuCaiShenSeq) do
		table.insert(newCardsSeq, v)
	end

	--合拼赖子数组和手牌数组
	for i,v in ipairs(laiziSeq) do
		table.insert(newCardsSeq, 1, v)
	end

	--合拼财神数组和手牌数组
	for i,v in ipairs(caishenSeq) do
		table.insert(newCardsSeq, 1, v)
	end

	--使用3D麻将操作类显示手牌
	D3_OPERATOR:showCards(playerType, plane, newCardsSeq)

end



--旧显示手牌函数
-- function InhandPlaneOperator:showCards(playerType, plane, cardDatas, tingSeq)
-- 	plane:removeAllChildren()
    
-- 	if playerType == CARD_PLAYERTYPE_MY then
        
--         --癞子放到左侧
--         for k,v in pairs(cardDatas) do
-- 			if v == 65 then
-- 				table.remove(cardDatas,k)
-- 				table.insert(cardDatas,1,v)
-- 			end
-- 		end

-- 		local oriX = 0
-- 		local oriY = plane:getSize().height / 2

-- 		local function onTouchBegan(touch, event)
-- 		    if D3_CHUPAI == 1 then
-- 		    	--todo

-- 		    	cardTemp = nil
-- 		    	local children = plane:getChildren()

-- 		    	for k,v in pairs(children) do
		        	
-- 				    --todo
-- 				    local locationInNode = v:convertToNodeSpace(touch:getLocation())

-- 					local s = v:getContentSize()
-- 					local rect = cc.rect(0, 0, s.width, s.height)
-- 					if cc.rectContainsPoint(rect, locationInNode) then
-- 						-- v:setOpacity(180)
-- 						cardTemp = v
-- 						self.cardOriPosition = cardTemp:getPosition()
-- 					end
				        	
-- 				end
-- 				if cardTemp then  --and cardTemp:getTag() ~= NEW_CARD_TAG 

-- 					ZZMJ_CONTROLLER:hideSameCard()
-- 					ZZMJ_CONTROLLER:hideTingHuPlane()
-- 					local  myhandcardnode = plane:getChildren()  --手牌不会为0
-- 		            for i,v in ipairs(myhandcardnode) do
-- 		            	v:setColor(cc.c3b(255,255,255))
-- 		            end
                    
--                     cardTemp:setColor(cc.c3b(250, 250, 0))
-- 					ZZMJ_CONTROLLER:showSameCard(cardTemp.m_value)

-- 					if tingSeq~={} and  tingSeq~=nil  then  --听队列存在时才遍历
-- 					  for k,v in pairs(tingSeq) do
-- 						if v.card == cardTemp.m_value then
-- 							--显示听得牌
-- 								-- --dump(v.tingHuCards,"显示听得牌1")
-- 							ZZMJ_CONTROLLER:showTingHuPlane(CARD_PLAYERTYPE_MY,v.tingHuCards)
-- 						break
-- 						end
-- 					  end
-- 					end
                    
-- 					if selectedTag == 99 then
-- 						--todoh
-- 						self.canMove = true
-- 					else
-- 						self.canMove = false
-- 					end
-- 					return true
-- 				else
-- 					return false
-- 				end
-- 		    end

-- 		    return false
-- 		end

-- 		local function onTouchMoved(touch, event)
-- 			if cardTemp then
-- 			    if self.canMove then
-- 			    	--todo
-- 			    	local posX = cardTemp:getPositionX()
-- 			    	local posY = cardTemp:getPositionY()
-- 			    	local delta = touch:getDelta()
-- 			    	cardTemp:setPosition(cc.p(posX + delta.x, posY + delta.y))
-- 			    end
-- 			end
-- 		end

-- 		local function onTouchEnded(touch, event)
-- 		   	if cardTemp then  	

-- 		   		local offsetY = cardTemp:getPosition().y - cardTemp:getSize().height / 2
-- 		   		if offsetY > plane:getSize().height then
-- 		   			--超出范围，出牌
-- 		   			ZZMJ_CONTROLLER:playCard(cardTemp.m_value)
-- 		   			cardTemp:removeFromParent()
-- 		   		else
-- 		   			local locationInNode = cardTemp:convertToNodeSpace(touch:getLocation())
-- 		   			local rect = cc.rect(0, 0, cardTemp:getContentSize().width, cardTemp:getContentSize().height)
-- 					if cc.rectContainsPoint(rect, locationInNode) then
-- 						if selectedTag == cardTemp:getTag() then
-- 						    --出牌
-- 							ZZMJ_CONTROLLER:playCard(cardTemp.m_value)
-- 						else
-- 							self:cancelSelectingCard(plane)

-- 							local p = cardTemp:getPosition()

-- 							if self.canMove then
-- 								--todo
-- 								p = self.cardOriPosition
-- 							end

-- 							cardTemp:setScale(1.2)
-- 							local offsetX = 0.1 * cardTemp:getSize().width

-- 							cardTemp:setPosition(cc.p(p.x + offsetX / 2, p.y + 30))

-- 							local tag = cardTemp:getTag()
-- 							selectedTag = tag
-- 							tag = tag + 1
-- 							local nextCard = plane:getChildByTag(tag)
-- 							while nextCard do
-- 								--todo
-- 								nextCard:setPosition(cc.p(nextCard:getPosition().x + offsetX, nextCard:getPosition().y))
  
-- 								tag = tag + 1
-- 								nextCard = plane:getChildByTag(tag)
-- 							end
-- 						end
-- 					else
-- 						self:cancelSelectingCard(plane)
-- 					end
		   			
-- 		   		end
-- 		   	end
-- 		end

-- 		local listener1 = cc.EventListenerTouchOneByOne:create()
--    		listener1:setSwallowTouches(true)
-- 		listener1:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
-- 		listener1:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
-- 		listener1:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

-- 		local eventDispatcher = SCENENOW["scene"]:getEventDispatcher()
		    
-- 		--画牌部分
-- 		for i=1,table.getn(cardDatas) do
-- 			local data = cardDatas[i]
-- 		   	    local card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data)
-- 					card:setScale(card:getScale() * 1.1)
-- 					-- card:setAnchorPoint(cc.p(0, 0))
-- 					card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))

-- 					card:setTouchEnabled(false)

-- 					eventDispatcher:addEventListenerWithSceneGraphPriority(listener1:clone(), card)


-- 					card:setTag(i)

-- 					plane:addChild(card)

-- 					oriX = oriX + card:getSize().width * card:getScale()
-- 		end

-- 		local width = oriX + 81 * 1.1
-- 		plane:setSize(cc.size(width, plane:getSize().height))

-- 	elseif playerType == CARD_PLAYERTYPE_LEFT then
-- 		--todo
-- 		local oriX = plane:getSize().width / 2
-- 		local count = table.getn(cardDatas)
-- 		local totalHeight = count * 22 + 11 + 44
-- 		local oriY = totalHeight - 22

-- 		for i=1,count do
-- 			local data = cardDatas[i]

-- 			local card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data,false)

-- 			card:addTouchEventListener(function(sender, event)
-- 					--print("123")
-- 				end)

-- 			card:setPosition(cc.p(oriX, oriY))

-- 			card:setTag(i)

-- 			plane:addChild(card)

-- 			oriY = oriY - 22
-- 		end

-- 		plane:setSize(cc.size(plane:getSize().width, totalHeight))
-- 	elseif playerType == CARD_PLAYERTYPE_RIGHT then
-- 		local oriX = plane:getSize().width / 2
-- 		local oriY = 44 / 2
-- 		local count = table.getn(cardDatas)

-- 		for i=1,count do
-- 			local data = cardDatas[i]

-- 			local card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data,false)

-- 			card:setPosition(cc.p(oriX, oriY))

-- 			card:setLocalZOrder(20 - i)

-- 			card:setTag(i)

-- 			plane:addChild(card)

-- 			oriY = oriY + (44 - 22)
-- 		end

-- 		plane:setSize(cc.size(plane:getSize().width, oriY - 22 + 11 + 44))
-- 	elseif playerType == CARD_PLAYERTYPE_TOP then
-- 		local count = table.getn(cardDatas)
-- 		local totalWidth = count * 30 + 15 + 30
-- 		local oriX = totalWidth - 15
-- 		local oriY = plane:getSize().height / 2

-- 		for i=1,count do
-- 			local data = cardDatas[i]

-- 			local card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data,false)

-- 			card:setPosition(cc.p(oriX, oriY))

-- 			card:setTag(i)

-- 			plane:addChild(card)

-- 			oriX = oriX - 30
-- 		end

-- 		plane:setSize(cc.size(totalWidth, plane:getSize().height))
-- 	end
-- end


--旧胡牌时摊牌
-- function InhandPlaneOperator:showCardsForAll(playerType, plane, cardDatas, anke)
-- 	plane:removeAllChildren()

-- 	local cardsTemp = {}
-- 	for k,v in pairs(cardDatas) do
-- 		local isAnke = false
-- 		for m,n in pairs(anke) do
-- 			if v == n then
-- 				--todo
-- 				isAnke = true
-- 				break
-- 			end
-- 		end
-- 		if isAnke then
-- 			--todo
			
-- 			if playerType == CARD_PLAYERTYPE_MY then
-- 				--todo
-- 				table.insert(cardsTemp, 100 + v)
-- 			else
-- 				table.insert(cardsTemp, -1)
-- 			end
-- 		else
-- 			table.insert(cardsTemp, v)
-- 		end
-- 	end

-- 	table.sort(cardsTemp)

-- 	if playerType == CARD_PLAYERTYPE_MY then
-- 		--todo
-- 		local size = plane:getSize()
-- 		local oriX = 0

-- 		for i=1,table.getn(cardsTemp) do
-- 			local cardData = cardsTemp[i]

-- 			local card

-- 			if cardData > 100 then
-- 				--todo
-- 				card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData - 100)

-- 				card:setColor(cc.c3b(140, 140, 140))
-- 			else
-- 				card = Card:new(playerType, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_SHOW, cardData)
-- 			end

-- 			card:setScale(card:getScale() * 1.1)

-- 			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))

-- 			plane:addChild(card)

-- 			oriX = oriX + (card:getSize().width - 1.5) * card:getScale()

-- 		end

-- 		plane:setSize(cc.size(oriX + 75 * 1.1, size.height))
-- 	elseif playerType == CARD_PLAYERTYPE_LEFT then
-- 		--print("gang lefthand test")
-- 		local size = plane:getSize()

-- 		local count = table.getn(cardsTemp)

-- 		for i=1,count do
-- 			local cardData = cardsTemp[i]

-- 			local card

-- 			if cardData ~= -1 then
-- 				--todo
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_SHOW, cardData)
-- 			else
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_HIDE, cardData)
-- 			end

-- 			card:setPosition(cc.p(size.width / 2, (count - i + 0.5) * 23 + 46))

-- 			plane:addChild(card)
-- 		end

-- 		plane:setSize(cc.size(plane:getSize().width, count * 23 + 46))
-- 	elseif playerType == CARD_PLAYERTYPE_RIGHT then
-- 		--todo
-- 		local size = plane:getSize()
-- 		local oriY = 0

-- 		for i=1,table.getn(cardsTemp) do
-- 			local cardData = cardsTemp[i]

-- 			local card

-- 			if cardData ~= -1 then
-- 				--todo
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_SHOW, cardData)
-- 			else
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_HIDE, cardData)
-- 			end

-- 			card:setPosition(cc.p(size.width / 2, oriY + 23 / 2))

-- 			card:setLocalZOrder(100 - plane:getChildrenCount())

-- 			plane:addChild(card)

-- 			oriY = oriY + 23
-- 		end

-- 		plane:setSize(cc.size(plane:getSize().width, oriY + 46))
-- 	elseif playerType == CARD_PLAYERTYPE_TOP then
-- 		local size = plane:getSize()

-- 		local count = table.getn(cardsTemp)

-- 		for i=1,count do
-- 			local cardData = cardsTemp[i]

-- 			local card

-- 			if cardData ~= -1 then
-- 				--todo
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_SHOW, cardData)
-- 			else
-- 				card = Card:new(playerType, CARD_TYPE_LEFTHAND, CARD_DISPLAY_TYPE_HIDE, cardData)
-- 			end

-- 			card:setPosition(cc.p((count - i + 0.5) * 27 + 27 * 1.5, size.height / 2))

-- 			plane:addChild(card)
-- 		end

-- 		plane:setSize(cc.size(count * 27 + 27 * 1.5, plane:getSize().height))
-- 	end
-- end


--新胡牌时摊牌
function InhandPlaneOperator:showCardsForAll(playerType, plane, cardDatas, anke,hucard)---显示所有的牌（胡牌的时候）

	--牌数组排序
	table.sort(cardDatas)

	local cardsSeq = {}
	local laiziSeq = {}
	local caishenSeq = {}

	local hucardData
	local hucard = hucard or 0

	--癞子放到左侧
	for k,v in pairs(cardDatas) do

        if v == HHMJ_LAIZI then

        	if v == hucard and (not hucardData) then  --胡牌单独展示
                hucardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_LAIZI)
            else
				local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_LAIZI)
				table.insert(laiziSeq, 1, cardData)
			end

		else

			local isCaishen = false
			for k1,v1 in pairs(JS_CAISHEN) do
				
				if v == v1 then
					isCaishen = true
				end

			end

			if isCaishen then

				if v == hucard and (not hucardData) then  --胡牌单独展示
	                hucardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
	            else
					local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
					table.insert(caishenSeq, 1, cardData)
				end
				
			else

				if v == hucard and (not hucardData) then  --胡牌单独展示
					hucardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
				else

					local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
					table.insert(cardsSeq, cardData)
				end

			end

		end

	end

	for i,v in ipairs(laiziSeq) do
		table.insert(cardsSeq, 1, v)
	end

	for i,v in ipairs(caishenSeq) do
		table.insert(cardsSeq, 1, v)
	end

	--使用3D麻将界面显示摊牌
	D3_OPERATOR:showCardsForAll( playerType, plane, {}, cardsSeq )

	--显示胡的牌
	D3_OPERATOR:getNewCard(playerType, plane, hucardData, true)


end

---取消选择中的牌
function InhandPlaneOperator:cancelSelectingCard(plane)
	if selectedTag == 99 then
		--todo
		return
	end

	--获取点选的牌
	local selectedCard = plane:getChildByTag(selectedTag)

	if selectedCard then
		--todo
		local oriY = plane:getSize().height / 2

		local position = selectedCard:getPosition()

		if position.y > oriY then
			--todo
			selectedCard:setScale(1.1)
			local offsetX = 0.1 * selectedCard:getSize().width
			selectedCard:setPosition(cc.p(selectedCard:getPosition().x - offsetX / 2, selectedCard:getSize().height * selectedCard:getScale() / 2))

			local tag = selectedCard:getTag()
			tag = tag + 1
			local nextCard = plane:getChildByTag(tag)
			while nextCard do
				--todo
				nextCard:setPosition(cc.p(nextCard:getPosition().x - offsetX, nextCard:getPosition().y))
                -- nextCard:setColor(cc.c3b(255,255,255))
                tag = tag + 1

                nextCard = plane:getChildByTag(tag)
               
            end

            selectedTag = 99
            D3_CHUPAI = 1
        end
        D3_CHUPAI = 1
    end
     D3_CHUPAI = 1
    
end


-- --旧取消选择中的牌
-- function InhandPlaneOperator:cancelSelectingCard(plane)
-- 	if selectedTag == 99 then
-- 		--todo
-- 		return
-- 	end

-- 	local selectedCard = plane:getChildByTag(selectedTag)

-- 	if selectedCard then
-- 		--todo
-- 		local oriY = plane:getSize().height / 2

-- 		local position = selectedCard:getPosition()

-- 		if position.y > oriY then
-- 			--todo
-- 			selectedCard:setScale(1.1)
-- 			local offsetX = 0.1 * selectedCard:getSize().width
-- 			selectedCard:setPosition(cc.p(selectedCard:getPosition().x - offsetX / 2, selectedCard:getSize().height * selectedCard:getScale() / 2))

-- 			local tag = selectedCard:getTag()
-- 			tag = tag + 1
-- 			local nextCard = plane:getChildByTag(tag)
-- 			while nextCard do
-- 				--todo
-- 				nextCard:setPosition(cc.p(nextCard:getPosition().x - offsetX, nextCard:getPosition().y))
--                 -- nextCard:setColor(cc.c3b(255,255,255))
-- 				tag = tag + 1

-- 				nextCard = plane:getChildByTag(tag)
-- 			end

-- 			selectedTag = 99
-- 		end
-- 	end
-- end


-- --旧摸牌
-- function InhandPlaneOperator:getNewCard(playerType, plane, value,tingSeq)
-- 	local displayType = CARD_DISPLAY_TYPE_OPPOSIVE
-- 	local seatId = ZZMJ_SEAT_TABLE_BY_TYPE[playerType .. ""]
-- 	-- local tingFlag = ZZMJ_GAMEINFO_TABLE[seatId .. ""].ting
-- 	-- if tingFlag == 1 and ZZMJ_ROOM.isBufenLiang ~= 1 then
-- 	-- 	--todo
-- 	-- 	displayType = CARD_DISPLAY_TYPE_SHOW
-- 	-- end
   

-- 	if playerType == CARD_PLAYERTYPE_MY then
-- 		--todo
-- 		local card = Card:new(playerType, CARD_TYPE_INHAND, displayType, value)
-- 		card:setTag(NEW_CARD_TAG)

-- 		-- card:addTouchEventListener(function(sender, event)
--   --               if event == TOUCH_EVENT_BEGAN then 
--   --               	ZZMJ_CONTROLLER:showSameCard(value)
--   --               	ZZMJ_CONTROLLER:hideTingHuPlane()
--   --               end
			
-- 		-- 		if event == TOUCH_EVENT_ENDED then
-- 		-- 			--todo
-- 		-- 			if sender:getTag() == NEW_CARD_TAG and D3_CHUPAI == 1 then
--   --                       ZZMJ_CONTROLLER:hideSameCard()
-- 		-- 				if tingSeq~={} and tingSeq~=nil then  --听队列存在时才遍历
-- 		-- 				  for k,v in pairs(tingSeq) do
-- 		-- 					if v.card == value then
-- 		-- 						--显示听得牌
-- 		-- 						ZZMJ_CONTROLLER:showTingHuPlane(CARD_PLAYERTYPE_MY,v.tingHuCards)
-- 		-- 					break
-- 		-- 					end
-- 		-- 				  end
-- 		-- 				end
						
-- 		-- 				ZZMJ_CONTROLLER:playCard(value)
-- 		-- 			end
-- 		-- 		end
-- 		-- 	end)

-- 		local size = plane:getSize()

-- 		card:setScale(card:getScale() * 1.1)
-- 		card:setPosition(cc.p(size.width - card:getSize().width / 2 * card:getScale(), card:getSize().height * card:getScale() / 2))
--         card:setTouchEnabled(false)
-- 		plane:addChild(card)
		
-- 	elseif playerType == CARD_PLAYERTYPE_LEFT then
-- 		local card = Card:new(playerType, CARD_TYPE_INHAND, displayType, value)
-- 		card:setTag(NEW_CARD_TAG)

-- 		local size = plane:getSize()

-- 		card:setPosition(cc.p(size.width / 2, card:getSize().height / 2))

-- 		plane:addChild(card)
-- 	elseif playerType == CARD_PLAYERTYPE_RIGHT then
-- 		local card = Card:new(playerType, CARD_TYPE_INHAND, displayType, value)
-- 		card:setTag(NEW_CARD_TAG)

-- 		local size = plane:getSize()

-- 		card:setPosition(cc.p(size.width / 2, size.height - card:getSize().height / 2))

-- 		plane:addChild(card)
-- 	elseif playerType == CARD_PLAYERTYPE_TOP then
-- 		local card = Card:new(playerType, CARD_TYPE_INHAND, displayType, value)
-- 		card:setTag(NEW_CARD_TAG)

-- 		local size = plane:getSize()

-- 		card:setPosition(cc.p(30 / 2, size.height / 2))

-- 		plane:addChild(card)
-- 	end	
-- end


--新摸牌
function InhandPlaneOperator:getNewCard(playerType, plane, value,tingSeq)

	local cardData
	if value == HHMJ_LAIZI then
		cardData = D3_CARDDATA:new(value, 0, CARDNODE_TYPE_LAIZI)

	elseif value == JS_CAISHEN then
		cardData = D3_CARDDATA:new(value, 0, CARDNODE_TYPE_CAISHEN)

	else

		local isCaishen = false
		for k1,v1 in pairs(JS_CAISHEN) do
			
			if value == v1 then
				isCaishen = true
			end

		end

		if isCaishen then

			cardData = D3_CARDDATA:new(value, 0, CARDNODE_TYPE_CAISHEN)
			
		else

			cardData = D3_CARDDATA:new(value, 1, CARDNODE_TYPE_NORMAL)

		end

		
	end

	--通过3D麻将界面添加一张新牌
	D3_OPERATOR:getNewCard(playerType, plane, cardData, false)

end

--设置当前点选了牌
function InhandPlaneOperator:playCard(playerType, plane)
	-- if not tag then
	-- 	--todo
	-- 	tag = NEW_CARD_TAG
	-- end

	-- local card = plane:getChildByTag(tag)

	-- if not card then
	-- 	--todo
	-- 	return
	-- end

	-- self:showCards(playerType, plane)

	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		selectedTag = 99
	end
end

-- function InhandPlaneOperator:showTingCards(plane, cards, tingSeq)
-- 	plane:removeAllChildren()

-- 	selectedTag = 99

-- 	local oriX = 0
-- 	local oriY = plane:getSize().height / 2

-- 		for i=1,table.getn(cards) do
-- 			local data = cards[i]

-- 			local isTing = false

-- 			for k,v in pairs(tingSeq) do
-- 				if data == v.card then
-- 					--todo
-- 					isTing = true
-- 					break
-- 				end
-- 			end

-- 			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data)
-- 			card:setScale(card:getScale() * 1.1)
-- 			card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))
-- 			card:setTag(i)

-- 			if isTing then
-- 				--todo
-- 				card:setTouchEnabled(true)

-- 				card:addTouchEventListener(function(sender, event)

				

-- 				if event == TOUCH_EVENT_ENDED then
-- 					--todo
-- 					--print("card value")
-- 					--dump(sender.m_value, "card value") 
-- 					--dump(sender:getAnchorPoint())

					
-- 					if selectedTag == sender:getTag() then
-- 						    --出牌
-- 						    -- ZZMJ_CONTROLLER:hideTingHuPlane()
-- 						 --    for k,v in pairs(tingSeq) do
-- 							-- 	if v.card == sender.m_value then
-- 							-- 		--todo
-- 							-- 		local tingHuCards = v.tingHuCards
-- 							-- 		ZZMJ_CONTROLLER:showTingHuPlane(tingHuCards)

-- 							-- 		ZZMJ_CONTROLLER:requestLiang(tingHuCards)
-- 							-- 		ZZMJ_CONTROLLER:playCard(sender.m_value)	
-- 							-- 		break
-- 							-- 	end
-- 							-- end
-- 							--dump(sender.m_value, "liang card test")
-- 							ZZMJ_CONTROLLER:requestLiang(sender.m_value)
-- 							-- ZZMJ_CONTROLLER:playCard(sender.m_value)	
							
-- 						else
-- 							self:cancelSelectingCard(plane)

-- 							local p = sender:getPosition()

-- 							sender:setScale(1.2)
-- 							local offsetX = 0.1 * sender:getSize().width

-- 							sender:setPosition(cc.p(p.x + offsetX / 2, p.y + 30))

-- 							local tag = sender:getTag()
-- 							selectedTag = tag
-- 							tag = tag + 1
-- 							local nextCard = plane:getChildByTag(tag)
-- 							while nextCard do
-- 								--todo
-- 								nextCard:setPosition(cc.p(nextCard:getPosition().x + offsetX, nextCard:getPosition().y))

-- 								tag = tag + 1
-- 								nextCard = plane:getChildByTag(tag)
-- 							end

-- 							for k,v in pairs(tingSeq) do
-- 								if v.card == sender.m_value then
-- 									--todo
-- 									local tingHuCards = v.tingHuCards
-- 									ZZMJ_CONTROLLER:showTingHuPlane(CARD_PLAYERTYPE_MY, tingHuCards)

-- 									break
-- 								end
-- 							end
-- 						end
-- 				end

-- 				end)
-- 			else
-- 				card:setTouchEnabled(false)
-- 				card:setColor(cc.c3b(150, 150, 150))
-- 			end

-- 			card:setTag(i)

-- 			plane:addChild(card)

-- 			oriX = oriX + card:getSize().width * card:getScale()
-- 		end

-- 		local width = oriX
-- 		plane:setSize(cc.size(width, plane:getSize().height))
-- end


--@garret 显示听牌 暗牌
function InhandPlaneOperator:showTingSelectCards(playerType,plane, cardDatas, tingSeq)
	dump("显示手牌", "-----showCards-----")

	--对传入牌进行排序
	table.sort(cardDatas)

	local cardsSeq = {}
	local laiziSeq = {}
	local caishenSeq = {}
	local baibanSeq = {}
	--听牌数据
	local newTingSeq = {}


	--挑出赖子，财神，白板（白板替身的情况下）
	for k,v in pairs(cardDatas) do

        if v == HHMJ_LAIZI then

			local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_LAIZI)

			table.insert(laiziSeq, 1, cardData)

		else

			local isCaishen = false
			for k1,v1 in pairs(JS_CAISHEN) do
				
				if v == v1 then
					isCaishen = true
				end

			end

			if isCaishen then

				local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
				table.insert(caishenSeq, 1, cardData)
				
			else

				if isbaibantishen == 1 then

					if v == 67 then
					
						local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
						table.insert(baibanSeq, cardData)

					else

						local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
						table.insert(cardsSeq, cardData)

					end
				
				else

					local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
					table.insert(cardsSeq, cardData)

				end

			end


			---听牌数据 s
			local isTing = false

			for k,v in pairs(tingSeq) do
				if data == v.card then
					--todo
					isTing = true
					break
				end
			end
			--加到听牌数据中
			if isTing then
				local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
				table.insert(newTingSeq, 1, cardData)
			end




		end

	end

	--获取财神牌值
	local caishenCard = JS_CAISHEN[1]

	--把白板插入到替换牌的位置上
	local xiaoYuCaiShenSeq = {}
	local daYuCaiShenSeq = {}
	local newCardsSeq = {}
	for k,v in pairs(cardsSeq) do
		if v.m_value < caishenCard then
			table.insert(xiaoYuCaiShenSeq, v)
		else
			table.insert(daYuCaiShenSeq, v)
		end
	end

	--插入小于财神的牌到新牌数组
	for k,v in pairs(xiaoYuCaiShenSeq) do
		table.insert(newCardsSeq, v)
	end

	--插入白板到新牌数组
	for k,v in pairs(baibanSeq) do
		table.insert(newCardsSeq, v)
	end

	--插入大于财神的牌到新牌数组
	for k,v in pairs(daYuCaiShenSeq) do
		table.insert(newCardsSeq, v)
	end

	--合拼赖子数组和手牌数组
	for i,v in ipairs(laiziSeq) do
		table.insert(newCardsSeq, 1, v)
	end

	--合拼财神数组和手牌数组
	for i,v in ipairs(caishenSeq) do
		table.insert(newCardsSeq, 1, v)
	end

	--组合听牌数据到总数据中
	for i,v in ipairs(newTingSeq) do
		table.insert(newCardsSeq, 1, v)
	end
	
	--使用3D麻将操作类显示手牌
	D3_OPERATOR:showCards(playerType, plane, newCardsSeq)







------------------------------------------------------------------------------------


	-- plane:removeAllChildren()

	-- selectedTag = 99
	
	-- local oriX = 0
	-- local oriY = plane:getSize().height / 2

	-- 	for i=1,table.getn(cards) do
	-- 		local data = cards[i]

	-- 		local isTing = false

	-- 		for k,v in pairs(tingSeq) do
	-- 			if data == v.card then
	-- 				--todo
	-- 				isTing = true
	-- 				break
	-- 			end
	-- 		end

	-- 		local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, data)
	-- 		card:setScale(card:getScale() * 1.1)
	-- 		card:setPosition(cc.p(oriX + card:getSize().width * card:getScale() / 2, card:getSize().height * card:getScale() / 2))
	-- 		card:setTag(i)

	-- 		if isTing then
	-- 			--todo
	-- 			card:setTouchEnabled(true)
	-- 			card:addTouchEventListener(function(sender, event)

				

	-- 			if event == TOUCH_EVENT_ENDED then
	-- 				--todo
	-- 				--print("card value")
	-- 				--dump(sender.m_value, "card value") 
	-- 				--dump(sender:getAnchorPoint())

					
	-- 				if selectedTag == sender:getTag() then
	-- 					    --出牌
	-- 					    -- ZZMJ_CONTROLLER:hideTingHuPlane()
	-- 					 --    for k,v in pairs(tingSeq) do
	-- 						-- 	if v.card == sender.m_value then
	-- 						-- 		--todo
	-- 						-- 		local tingHuCards = v.tingHuCards
	-- 						-- 		ZZMJ_CONTROLLER:showTingHuPlane(tingHuCards)

	-- 						-- 		ZZMJ_CONTROLLER:requestLiang(tingHuCards)
	-- 						-- 		ZZMJ_CONTROLLER:playCard(sender.m_value)	
	-- 						-- 		break
	-- 						-- 	end
	-- 						-- end
	-- 						-- dump(sender.m_value, "liang card test")
	-- 						ZZMJ_CONTROLLER:requestLiang(sender.m_value)
	-- 						-- ZZMJ_CONTROLLER:playCard(sender.m_value)	
							
	-- 					else
	-- 						self:cancelSelectingCard(plane)

	-- 						local p = sender:getPosition()

	-- 						sender:setScale(1.2)
	-- 						local offsetX = 0.1 * sender:getSize().width

	-- 						sender:setPosition(cc.p(p.x + offsetX / 2, p.y + 30))

	-- 						local tag = sender:getTag()
	-- 						selectedTag = tag
	-- 						tag = tag + 1
	-- 						local nextCard = plane:getChildByTag(tag)
	-- 						while nextCard do
	-- 							--todo
	-- 							nextCard:setPosition(cc.p(nextCard:getPosition().x + offsetX, nextCard:getPosition().y))

	-- 							tag = tag + 1
	-- 							nextCard = plane:getChildByTag(tag)
	-- 						end

	-- 						for k,v in pairs(tingSeq) do
	-- 							if v.card == sender.m_value then
	-- 								--todo
	-- 								local tingHuCards = v.tingHuCards
	-- 								ZZMJ_CONTROLLER:showTingHuPlane(CARD_PLAYERTYPE_MY, tingHuCards)

	-- 								break
	-- 							end
	-- 						end
	-- 					end
	-- 			end

	-- 			end)
	-- 		else
	-- 			card:setTouchEnabled(false)
	-- 			card:setColor(cc.c3b(150, 150, 150))
	-- 		end

	-- 		card:setTag(i)

	-- 		plane:addChild(card)

	-- 		oriX = oriX + card:getSize().width * card:getScale()
	-- 	end

	-- 	local width = oriX
	-- 	plane:setSize(cc.size(width, plane:getSize().height))

	-- 	--使用3D麻将操作类显示手牌
	-- 	D3_OPERATOR:showCards(playerType, plane, newCardsSeq)
end

return InhandPlaneOperator