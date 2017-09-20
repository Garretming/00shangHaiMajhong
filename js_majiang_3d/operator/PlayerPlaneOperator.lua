
--获取江山麻将自己的牌定义类
local Card = require("js_majiang_3d.card.card")

--自己区域操作类
local inhandPlaneOperator = require("js_majiang_3d.operator.InhandPlaneOperator")

--左边区域操作类
local lefthandPlaneOperator = require("js_majiang_3d.operator.LefthandPlaneOperator")

local controlPlaneOperator = require("js_majiang_3d.operator.ControlPlaneOperator")

local outhandPlaneOperator = require("js_majiang_3d.operator.OuthandPlaneOperator")

--用户信息区域操作类
local userInfoPlaneOperator = require("js_majiang_3d.operator.UserInfoPlaneOperator")

--加漂区域操作类
local jiapiaoPlaneOperator = require("js_majiang_3d.operator.JiapiaoPlaneOperator")

local PlayerPlaneOperator = class("PlayerPlaneOperator")

local CHILD_NAME_INHANDPLANE = "inhand_plane"
local CHILD_NAME_LEFTHANDPLANE = "lefthand_plane"
local CHILD_NAME_OUTHANDPLANE = "outhand_plane"
local CHILD_NAME_CONTROL_PLANE = "control_plane"
local CHILD_NAME_CONTROL_IMG = "control_img"
local CHILD_NAME_PLAYERINFO_PLANE = "player_plane"
local CHILD_NAME_LG_PLANE = "lg_plane"
local CHILD_NAME_TING_HU_PLANE = "ting_hu_plane"

local CHILD_NAME_HUA_PLANE = "hua_plane"

local CHILD_NAME_JIAPIAO_PLANE = "jiapiao_plane"
local CHILD_NAME_PIAO_IMG = "piao_img"

local CHILD_NAME_PIAO_PLANE = "piao_plane"
local CHILD_NAME_PIAO_LB = "piao_lb"

local ShowSameCardArray = {}

local newCard = 0

function PlayerPlaneOperator:init(playerType, plane)
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
	local lefthandPlane = plane:getChildByName(CHILD_NAME_LEFTHANDPLANE)
	local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)
	local controlPlane = plane:getChildByName(CHILD_NAME_CONTROL_PLANE)
	local controlImg = plane:getChildByName(CHILD_NAME_CONTROL_IMG)
	local userInfoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)
	local lgPlane = plane:getChildByName(CHILD_NAME_LG_PLANE)
	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)

	local hua_plane = plane:getChildByName(CHILD_NAME_HUA_PLANE)

	local piao_plane = plane:getChildByName(CHILD_NAME_PIAO_PLANE)
	local jiapiao_plane = plane:getChildByName(CHILD_NAME_JIAPIAO_PLANE)
	local piao_img = plane:getChildByName(CHILD_NAME_PIAO_IMG)

	local huipai_box = plane:getChildByName("huipai_box")

	if piao_img then
		--todo
		piao_img:setVisible(false)
	end

	if piao_plane then
		--todo
		piao_plane:setVisible(false)
	end
	
	if jiapiao_plane then
		--todo
		jiapiao_plane:setVisible(false)

		jiapiaoPlaneOperator:init(jiapiao_plane)
	end

	if huipai_box then

		huipai_box:setVisible(false)
	end

	if hua_plane then
		hua_plane:setVisible(false)
	end

	inhandPlaneOperator:init(playerType, inhandPlane)
	lefthandPlaneOperator:init(playerType, lefthandPlane)
	outhandPlaneOperator:init(playerType, outhandPlane)
	controlPlaneOperator:init(playerType, controlImg, controlPlane, lgPlane, tingHuPlane)
	userInfoPlaneOperator:init(userInfoPlane)

	D3_OPERATOR:init(ZZMJ_CONTROLLER, playerType, inhandPlane, outhandPlane)
end

function PlayerPlaneOperator:clearGameDatas(playerType, plane)
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
	local lefthandPlane = plane:getChildByName(CHILD_NAME_LEFTHANDPLANE)
	local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)
	local userInfoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)
	local controlPlane = plane:getChildByName(CHILD_NAME_CONTROL_PLANE)
	local lgPlane = plane:getChildByName(CHILD_NAME_LG_PLANE)
	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)
	local hua_plane = plane:getChildByName(CHILD_NAME_HUA_PLANE)
	local piao_plane = plane:getChildByName(CHILD_NAME_PIAO_PLANE)
	local jiapiao_plane = plane:getChildByName(CHILD_NAME_JIAPIAO_PLANE)
	local piao_img = plane:getChildByName(CHILD_NAME_PIAO_IMG)

	if piao_img then
		--todo
		piao_img:setVisible(false)
	end

	if piao_plane then
		--todo
		piao_plane:setVisible(false)
	end
	
	if jiapiao_plane then
		--todo
		jiapiao_plane:setVisible(false)
	end

	if huipai_box then

		huipai_box:setVisible(false)
	end

	if hua_plane then
		hua_plane:setVisible(false)
	end

	inhandPlaneOperator:init(playerType, inhandPlane)
	lefthandPlaneOperator:init(playerType, lefthandPlane)
	outhandPlaneOperator:init(playerType, outhandPlane)
	controlPlaneOperator:clearGameDatas(controlPlane, lgPlane, tingHuPlane)
	userInfoPlaneOperator:clearGameDatas(userInfoPlane)

	D3_OPERATOR:clearGameDatas(playerType, inhandPlane, outhandPlane)
end

function PlayerPlaneOperator:reLocate(playerType, plane)
	-- local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
	-- local lefthandPlane = plane:getChildByName(CHILD_NAME_LEFTHANDPLANE)

	-- if playerType == CARD_PLAYERTYPE_MY then
	-- 	--todo
	-- 	local x = (plane:getSize().width - lefthandPlane:getSize().width - inhandPlane:getSize().width) / 2 + lefthandPlane:getSize().width

	-- 	inhandPlane:setPosition(cc.p(x, inhandPlane:getPosition().y))

	-- 	local controlPlane = plane:getChildByName(CHILD_NAME_CONTROL_PLANE)
		
	-- 	local size = inhandPlane:getSize()
	-- 	local position = inhandPlane:getPosition()

	-- 	local x = position.x + size.width - 75 - controlPlane:getSize().width

	-- 	controlPlane:setPosition(cc.p(x, controlPlane:getPosition().y))
	-- elseif playerType == CARD_PLAYERTYPE_LEFT then
	-- 	local y = plane:getSize().height - lefthandPlane:getSize().height - (plane:getSize().height - lefthandPlane:getSize().height - inhandPlane:getSize().height) / 2

	-- 	inhandPlane:setPosition(cc.p(inhandPlane:getPosition().x, y))
	-- elseif playerType == CARD_PLAYERTYPE_RIGHT then
	-- 	local y = (plane:getSize().height - lefthandPlane:getSize().height - inhandPlane:getSize().height) / 2 + lefthandPlane:getSize().height

	-- 	inhandPlane:setPosition(cc.p(inhandPlane:getPosition().x, y))

	-- elseif playerType == CARD_PLAYERTYPE_TOP then
	-- 	local x = plane:getSize().width - lefthandPlane:getSize().width - (plane:getSize().width - lefthandPlane:getSize().width - inhandPlane:getSize().width - 170) / 2

	-- 	inhandPlane:setPosition(cc.p(x, inhandPlane:getPosition().y))
	-- end
end

--显示牌，现在只有开场发牌时起作用
function PlayerPlaneOperator:showCards(playerType, plane,tingSeq)

	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	local seatId = ZZMJ_SEAT_TABLE_BY_TYPE[playerType .. ""]

	local cards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand

	-- local tingFlag = ZZMJ_GAMEINFO_TABLE[seatId .. ""].ting
	-- local anke = ZZMJ_GAMEINFO_TABLE[seatId .. ""].anke

	-- if tingFlag ~= 1 or ZZMJ_ROOM.isBufenLiang == 1 then
	-- 	--todo
		inhandPlaneOperator:showCards(playerType, inhandPlane, cards, tingSeq)
	-- else
	-- 	inhandPlaneOperator:showCardsForAll(playerType, inhandPlane, cards, anke)
	-- end

	

	self:reLocate(playerType, plane)
	
end


-----显示操作按钮
function PlayerPlaneOperator:showControlPlane(plane, controlType)
	
	local controlPlane = plane:getChildByName(CHILD_NAME_CONTROL_PLANE)
	print("显示操作按钮界面2")
	if controlPlane then
		--todo
		controlPlaneOperator:showPlane(controlPlane, controlType)

		local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

		if inhandPlane then
			--todo
			local size = inhandPlane:getSize()
			local position = inhandPlane:getPosition()

			local x = position.x + size.width - 75 - controlPlane:getSize().width

			controlPlane:setPosition(cc.p(x, controlPlane:getPosition().y))
		end
	end
	
end

function PlayerPlaneOperator:hideControlPlane(plane)
	local controlPlane = plane:getChildByName(CHILD_NAME_CONTROL_PLANE)

	if controlPlane then
		--todo
		controlPlane:setVisible(false)
	end
end

function PlayerPlaneOperator:cancelSelectingCard(plane)
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	if inhandPlane then
		--todo
		inhandPlaneOperator:cancelSelectingCard(inhandPlane)
	end
end

function PlayerPlaneOperator:getNewCard(playerType, plane, value,tingSeq)
	

	dump("显示获取牌---")
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
   
    -- TINGSEQ=tingSeq
 --    newCard = value
 --    local cardData = D3_CARDDATA:new(value, 1, CARDNODE_TYPE_NORMAL)
 --    if value == HHMJ_LAIZI then
 --    	cardData = D3_CARDDATA:new(value, 0, CARDNODE_TYPE_LAIZI)
 --    end
    
	-- D3_OPERATOR:getNewCard(playerType, inhandPlane, cardData, false)

	if inhandPlane then
		--todo
		inhandPlaneOperator:getNewCard(playerType, inhandPlane, value,tingSeq)
	end

end

--移除牌
function PlayerPlaneOperator:removeCards(playerType, plane, value, isRemoveNewCard)

	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
	local inhandOperator = require("hall.3DMahjongCard.InhandOperator")
	if inhandPlane then
		inhandOperator:removeCards(playerType, inhandPlane, value, isRemoveNewCard)
	end

end

--旧打牌
-- function PlayerPlaneOperator:playCard(playerType, plane, tag, value)
-- 	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

-- 	if inhandPlane then
-- 		--todo
-- 		local seatId = ZZMJ_SEAT_TABLE_BY_TYPE[playerType .. ""]
-- 		inhandPlaneOperator:playCard(playerType, inhandPlane)
-- 		self:showCards(playerType, plane)
		
-- 	end

-- 		--todo
-- 		local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)

-- 		if outhandPlane then
-- 			--todo
-- 			outhandPlaneOperator:playCard(playerType, value, outhandPlane)
-- 		end

-- 	self:reLocate(playerType, plane)
-- end


--新打牌
function PlayerPlaneOperator:playCard(playerType, plane, tag, value)---玩牌
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
	local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)

	-- if value == HHMJ_LAIZI then
	-- 	cardData = D3_CARDDATA:new(value, 0, CARDNODE_TYPE_LAIZI)
	-- else

	local cardData = D3_CARDDATA:new(value, 1, CARDNODE_TYPE_NORMAL)

	-- end
	ZZMJ_CURRENT_CARDNODE = cardData
	dump(ZZMJ_CURRENT_CARDNODE, "ZZMJ_CURRENT_CARDNODEplayCard")
    D3_OPERATOR:playCard(playerType, inhandPlane, outhandPlane, cardData)
    
end


--旧操作
-- function PlayerPlaneOperator:control(playerType, plane, progCards, controlType,tingSeq,fromplayerType)
-- 	local lefthandPlane = plane:getChildByName(CHILD_NAME_LEFTHANDPLANE)
-- 	local controlImg = plane:getChildByName(CHILD_NAME_CONTROL_IMG)

-- 	controlPlaneOperator:showImage(controlImg, controlType)

-- 	if lefthandPlane then
-- 		--todo
-- 		-- if controlType == CONTROL_TYPE_GANG then
-- 		-- 	--todo
-- 		-- 	local cardDatas = {}
-- 		-- 	for i=1,3 do
-- 		-- 		local cardData = {}
-- 		-- 		cardData["value"] = 6

-- 		-- 		table.insert(cardDatas, cardData)
-- 		-- 	end

-- 		-- 	lefthandPlaneOperator:addCards(playerType, lefthandPlane, cardDatas)
-- 		-- end

-- 		lefthandPlaneOperator:addProg(playerType, lefthandPlane, progCards, controlType,fromplayerType)

-- 		self:showCards(playerType, plane, tingSeq)
		
-- 	end

-- 	self:reLocate(playerType, plane)
-- end


function PlayerPlaneOperator:control(playerType, plane, progCards, controlType,tingSeq,removeCards,fromplayerType,reloginFlage)
	
    -- TINGSEQ=tingSeq

	local controlImg = plane:getChildByName(CHILD_NAME_CONTROL_IMG)
	controlPlaneOperator:showImage(controlImg, controlType)

	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	local progCardDatas = {}
	for i,v in pairs(progCards) do
		local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL, fromplayerType)
		table.insert(progCardDatas, cardData)
	end
    
    
    --重连且补杠且玩家为自己的情况下
   if reloginFlage== true and (controlType == GANG_TYPE_BU or controlType == GANG_TYPE_AN) and  playerType==CARD_PLAYERTYPE_MY then      
	    local inhandOperator = require("hall.3DMahjongCard.InhandOperator")
	    if  removeCards[1] == newCard then 
	    	inhandOperator:removeCards(playerType, inhandPlane, removeCards, true)
	    else 
	    	inhandOperator:removeCards(playerType, inhandPlane, removeCards, false)
		end

		self:showCards(playerType,plane)
  
        if controlType == GANG_TYPE_AN then
			inhandOperator:addCards(playerType, inhandPlane, progCardDatas)
			inhandOperator:addGangCard(playerType, inhandPlane, progCardDatas[1], true)
        elseif  controlType == GANG_TYPE_BU then
	   	 	inhandOperator:addGangCard(playerType, inhandPlane, progCardDatas[1], false)
		end
		
	else
		D3_OPERATOR:control(playerType, inhandPlane, progCardDatas, controlType, removeCards)
	end
end

function PlayerPlaneOperator:showPlayerInfo(userInfo, plane)
	local infoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)
	userInfoPlaneOperator:showInfo(userInfo, infoPlane)

	return infoPlane
end

function PlayerPlaneOperator:showZhuang(plane)
	local infoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)

	userInfoPlaneOperator:showZhuang(true, infoPlane)
end


--旧重绘
-- function PlayerPlaneOperator:redrawGameInfo(playerType, plane, data)
-- 	local progCards = {}

-- 	if data.gCount > 0 then
-- 		--todo
-- 		local controlCards = data.gCards
-- 		for i=1,data.gCount do
-- 			local controlCard = controlCards[i]
-- 			local gCard = {}
-- 			gCard.cards = {}
-- 			local gType
-- 			if controlCard.isAg > 0 then
-- 				--todo
-- 				gType = GANG_TYPE_AN
-- 			else
-- 				gType = GANG_TYPE_PG
-- 			end

-- 			gCard.type = gType

-- 			for i=1,4 do
-- 				table.insert(gCard.cards, controlCard.card)
-- 			end

-- 			table.insert(progCards, gCard)
-- 		end
-- 	end

-- 	if data.pCount > 0 then
-- 		--todo
-- 		local controlCards = data.pCards
-- 		for i=1,data.pCount do
-- 			local controlCard = controlCards[i]
-- 			local pCard = {}
-- 			pCard.cards = {}
-- 			pCard.type = CONTROL_TYPE_PENG

-- 			for i=1,3 do
-- 				table.insert(pCard.cards, controlCard)
-- 			end

-- 			table.insert(progCards, pCard)
-- 		end
-- 	end

-- 	local p = nil
-- 	local cs = nil
-- 	-- for i=1,data.cCount do
-- 	-- 	if i % 3 == 1 then
-- 	-- 		--todo
-- 	-- 		p = {}
-- 	-- 		p.type = CONTROL_TYPE_CHI
-- 	-- 		cs = {}
-- 	-- 		p.cards = cs
-- 	-- 		table.insert(cs, data.cCards[i])
-- 	-- 	elseif i % 3 == 0 then
-- 	-- 		table.insert(cs, data.cCards[i])

-- 	-- 		table.insert(progCards, p)
-- 	-- 	else
-- 	-- 		table.insert(cs, data.cCards[i])
-- 	-- 	end
-- 	-- end

-- 	local lefthandPlane = plane:getChildByName(CHILD_NAME_LEFTHANDPLANE)

-- 	if lefthandPlane then
-- 		--todo
-- 		lefthandPlaneOperator:redraw(playerType, lefthandPlane, progCards)
-- 	end

-- 	self:showCards(playerType, plane, data.tingCards)

-- 	local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)

-- 	if outhandPlane then
-- 		--todo
-- 		outhandPlaneOperator:redraw(playerType, outhandPlane, data.outCards)
-- 	end
    
--     if playerType == CARD_PLAYERTYPE_MY then
-- 		if ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].ting==1 then
-- 			self:showTingHuPlane(plane, data.tingHuCards)
-- 		end
-- 	end


-- 	-- if playerType == CARD_PLAYERTYPE_MY then
-- 		--todo
-- 		-- local tingFlag = ZZMJ_GAMEINFO_TABLE[data.seat_id .. ""].ting

-- 		-- if tingFlag == 1 then
-- 		-- 	--todo
-- 		-- 	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)
-- 		-- 	if tingHuPlane then
-- 		-- 		--todo
-- 		-- 		controlPlaneOperator:showTingHuPlane(tingHuPlane, data.tingHuCards)
-- 		-- 	end
-- 		-- end
-- 	-- end
-- end

--重绘游戏信息
function PlayerPlaneOperator:redrawGameInfo(playerType, plane, data)

	--操作牌数组
	local progCards = {}

	--杠牌
	if data.gCount > 0 then

		local controlCards = data.gCards---杠牌的值（除了普通的杠之外，还包括赖子杠）

		for i=1,data.gCount do

			local controlCard = controlCards[i]
			local gCard = {}
			gCard.cards = {}
			local gType
			if controlCard.isAg > 0 then
				--todo
				gType = GANG_TYPE_AN
			else
				gType = GANG_TYPE_PG
			end

			gCard.type = gType

			if controlCard.card == HHMJ_LAIZI then

				table.insert(gCard.cards,controlCard.card)
				table.insert(progCards, gCard)

 			else		

 				local isCaishen = false
				for k1,v1 in pairs(JS_CAISHEN) do
					
					if controlCard.card == v1 then
						isCaishen = true
					end

				end

				if isCaishen then

					table.insert(gCard.cards,controlCard.card)
					table.insert(progCards, gCard)
					
				else

					for i=1,4 do
	 					local cardData = D3_CARDDATA:new(controlCard.card, 1, CARDNODE_TYPE_NORMAL)
						table.insert(gCard.cards, cardData)
					end
					table.insert(progCards, gCard)

				end

			end

		end

	end

	--碰牌
	if data.pCount > 0 then
		dump(value, desciption, nesting)
		local controlCards = data.pCards
		for i=1,data.pCount do
			local controlCard = controlCards[i]
			local pCard = {}
			pCard.cards = {}
			pCard.type = CONTROL_TYPE_PENG

			for i=1,3 do
				local cardData = D3_CARDDATA:new(controlCard, 1, CARDNODE_TYPE_NORMAL)
				table.insert(pCard.cards, cardData)
			end
			table.insert(progCards, pCard)
		end
	end

	--吃牌
	local p = nil
	local cs = nil
	for i=1,data.cCount do
		if i % 3 == 1 then
			--todo
			p = {}
			p.type = CONTROL_TYPE_CHI
			cs = {}
			p.cards = cs
			table.insert(cs, D3_CARDDATA:new(data.cCards[i], 1, CARDNODE_TYPE_NORMAL))
		elseif i % 3 == 0 then
			table.insert(cs, D3_CARDDATA:new(data.cCards[i], 1, CARDNODE_TYPE_NORMAL))

			table.insert(progCards, p)
		else
			table.insert(cs, D3_CARDDATA:new(data.cCards[i], 1, CARDNODE_TYPE_NORMAL))
		end
	end

	--获取手牌区域
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	--根据用户类型获取seatid
	local seatId = ZZMJ_SEAT_TABLE_BY_TYPE[playerType .. ""]

	--获取出牌区域
	local outhandPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)

	--获取出牌数组
	local outCards = {}
	for i,v in ipairs(data.outCards) do
		if v.outcardtype == 0 then
		local cardData = D3_CARDDATA:new(v.card, 1, CARDNODE_TYPE_NORMAL)
		--兼容了红中的出牌数组
		table.insert(outCards, cardData)
	    end
	end

	--对手牌进行排序
	table.sort(ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand)

	--处理赖子
	local cardsSeq = {}
	local laiziSeq = {}
	local caishenSeq = {}
	local baibanSeq = {}

	dump(isbaibantishen, "-----isbaibantishen-----")

	--癞子财神放到左侧，挑出白板（白板替身时）
	for k,v in pairs(ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand) do

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

				-- local cardData = D3_CARDDATA:new(v, 0, CARDNODE_TYPE_CAISHEN)
				local cardData = D3_CARDDATA:new(v, 1, CARDNODE_TYPE_NORMAL)
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
	--合拼赖子数组和手牌数组
	for i,v in ipairs(laiziSeq) do
		table.insert(newCardsSeq, v)
	end

	--合拼财神数组和手牌数组
	for i,v in ipairs(caishenSeq) do
		table.insert(newCardsSeq, v)
	end

	--插入大于财神的牌到新牌数组
	for k,v in pairs(daYuCaiShenSeq) do
		table.insert(newCardsSeq, v)
	end

	
    
    --通过3D桌面绘制玩家区域信息
	D3_OPERATOR:redraw(playerType, inhandPlane, outhandPlane, progCards, newCardsSeq, outCards)

 --    if playerType == CARD_PLAYERTYPE_MY then
 --    	TINGSEQ = data.tingCards
    	
	-- 	if ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].ting==1 then
	-- 		self:showTingHuPlane(plane, data.tingHuCards)
	-- 	end
	-- end

	--假如当前用户是自己，并且可听，则显示听牌提醒区域
	if playerType == CARD_PLAYERTYPE_MY and data.tingCards ~= nil and data.tingCards ~= {} then

		TINGSEQ = data.tingCards

		for k,v in pairs(data.tingCards) do
			self:showTingHuPlane(plane, v.tingHuCards)		
		end

	end

	--显示花牌
	dump(data.hCards, "-----用户花牌-----")
	if data.hCount > 0 then
		self:showHuaCard(plane, data.hCards)
	end

end

function PlayerPlaneOperator:showTingCards(plane, tingSeq)
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
    

	local seatId = ZZMJ_MY_USERINFO.seat_id

	local cards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand


	inhandPlaneOperator:showTingCards(inhandPlane, cards, tingSeq)

end

-- function PlayerPlaneOperator:didSelectOutCard(plane,card)
--   	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)
-- 	if tingHuPlane then
-- 		controlPlaneOperator:didSelectOutCard(tingHuPlane, card)
-- 	end
-- end

function PlayerPlaneOperator:removeLatestOutCard(plane, card)
	local outPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)

	if outPlane then
		--todo
		return outhandPlaneOperator:removeLatestOutCard(outPlane, card)
	end

	return false
end

function PlayerPlaneOperator:showLgSelectBox(plane, lgCards)
	local lgPlane = plane:getChildByName(CHILD_NAME_LG_PLANE)

	if lgPlane then
		--todo
		controlPlaneOperator:showLgSelectBox(lgPlane, lgCards)

		local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

		local size = inhandPlane:getSize()
		local position = inhandPlane:getPosition()

		local x = position.x + size.width - 75 - lgPlane:getSize().width

		lgPlane:setPosition(cc.p(x, lgPlane:getPosition().y))
	end
end

--显示听胡牌区域
function PlayerPlaneOperator:showTingHuPlane(plane, tingHuCards)
	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)
	if tingHuPlane then
		controlPlaneOperator:showTingHuPlane(tingHuPlane, tingHuCards)
	end
end

--隐藏听胡牌区域
function PlayerPlaneOperator:hideTingHuPlane(plane)
	local tingHuPlane = plane:getChildByName(CHILD_NAME_TING_HU_PLANE)
	-- local tingFlag = ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].ting
	if tingHuPlane then
		--todo
		tingHuPlane:setVisible(false)
	end
end

--显示花牌
function PlayerPlaneOperator:showHuaCard(plane, hCards)

	local hua_plane = plane:getChildByName(CHILD_NAME_HUA_PLANE)
	if hua_plane ~= nil then

		local card_ly = hua_plane:getChildByName("card_ly")
		if card_ly ~= nil then

			hua_plane:setVisible(true)

			card_ly:removeAllChildren()

			local oriX = 0
			local oriY = -10

			local cardlength = 0

		    table.sort(hCards)
		    dump(hCards, "-----用户花牌-----")

		    for k,v in pairs(hCards) do

				local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
				local size = card:getSize()
				local scale = 0.4
				card:setScale(scale)
				card:setPosition(cc.p(oriX + size.width * scale / 2, oriY))

				cardlength = cardlength + 30

				card_ly:addChild(card)
		     
				card:setTag(0)
				card:setEnabled(false)

				oriX = oriX + size.width * scale

			end

			hua_plane:setSize(cc.size(cardlength + 80, hua_plane:getSize().height))

		end

	end

end

--隐藏花牌区域
function PlayerPlaneOperator:hideHuaCard(plane)

	local hua_plane = plane:getChildByName(CHILD_NAME_HUA_PLANE)
	if hua_plane ~= nil then
		hua_plane:setVisible(false)
	end

end

function PlayerPlaneOperator:showCardsForHu(playerType, plane, cardDatas,hucard)
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	if inhandPlane then
		--todo
		inhandPlaneOperator:showCardsForAll(playerType, inhandPlane, cardDatas, {},hucard)
	end
end

function PlayerPlaneOperator:playHuaCard(playerType,plane,value)
     
    local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)
    if inhandPlane then
		inhandPlaneOperator:playCard(playerType, inhandPlane)
		self:showCards(playerType, plane)
	end

	self:reLocate(playerType, plane)
	
end

--补花动画
function PlayerPlaneOperator:buHua(plane)
    local controlImg = plane:getChildByName(CHILD_NAME_CONTROL_IMG)
    local controlType = CONTROL_TYPE_BUHUA
	controlPlaneOperator:showImage(controlImg, controlType)
end

--财飘动画
function PlayerPlaneOperator:showCaiPiao(plane)
    local controlImg = plane:getChildByName(CHILD_NAME_CONTROL_IMG)
    local controlType = CONTROL_TYPE_CAIPIAO
	controlPlaneOperator:showImage(controlImg, controlType)
end

function PlayerPlaneOperator:getHeadNode(plane)
	local infoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)

	return userInfoPlaneOperator:getHeadNode(infoPlane)
end

function PlayerPlaneOperator:showNetworkImg(plane, flag)
	local infoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)

	userInfoPlaneOperator:showNetworkImg(infoPlane, flag)
end

function PlayerPlaneOperator:showJiapiaoPlane(plane, flag)
	local jiapiaoPlane = plane:getChildByName(CHILD_NAME_JIAPIAO_PLANE)

	jiapiaoPlane:setVisible(flag)
end

function PlayerPlaneOperator:showPiaoImg(plane, piao, flag)
	local piaoImg = plane:getChildByName(CHILD_NAME_PIAO_IMG)

	piaoImg:setVisible(flag)

	if flag then
		--todo

		local imgPath = "majong_bujia_bt_p.png"
		if piao == 1 then
			imgPath = "majong_jiagang_bt_p.png"
		elseif piao == 2 then
			imgPath = "majong_jiaerpiao_bt_p.png"
		end

		piaoImg:loadTexture("js_majiang_3d/image/" .. imgPath)
	end
end

function PlayerPlaneOperator:showPiaoPlane(plane, piao, flag)
	local piaoPlane = plane:getChildByName(CHILD_NAME_PIAO_PLANE)
	local piaoLb = piaoPlane:getChildByName(CHILD_NAME_PIAO_LB)

	piaoPlane:setVisible(flag)

	if flag then
		--todo

		local txt = "不加"
		if piao == 1 then
			txt = "加钢"
		elseif piao == 2 then
			txt = "加二飘"
		end

		piaoLb:setString(txt)
	end
end

--显示公共会牌
function PlayerPlaneOperator:HuiPai(plane,huipai)
    
 --    local huipai_box=plane:getChildByName("huipai_box")
 --    huipai_box:setVisible(true)
 --    huipai_box:removeAllChildren()
 --    local value = huipai
 --    local card = card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, value)
	-- local size = card:getSize()
	-- local scale = (huipai_box:getSize().height - 20) / size.height
	-- card:setScale(scale)
	-- card:setPosition(cc.p(huipai_box:getSize().width / 2, huipai_box:getSize().height / 2))
 --    huipai_box:addChild(card)
end

function PlayerPlaneOperator:showSameCard(plane,value)
   	local outPlane = plane:getChildByName(CHILD_NAME_OUTHANDPLANE)
	if outPlane then
		local outcardnodes = outPlane:getChildren()
		if next(outcardnodes)~=nil then
			for i,v in pairs(outcardnodes) do
		    if v.m_value == value then
		       v:setColor(cc.c3b(255,255,0))
		       table.insert(ShowSameCardArray,v)      
			end
			end
	    end	
	end
end

function PlayerPlaneOperator:hideSameCard()

	if next(ShowSameCardArray)~=nil then
		for i,v in pairs(ShowSameCardArray) do
			v:setColor(cc.c3b(255,255,255))
		end
	end
	ShowSameCardArray = {}

end

function PlayerPlaneOperator:beginPlayCard(plane,flag)
	local infoPlane = plane:getChildByName(CHILD_NAME_PLAYERINFO_PLANE)
    userInfoPlaneOperator:beginPlayCard(infoPlane,flag)
end


function PlayerPlaneOperator:putCard()
    outhandPlaneOperator:putCard()
end


--@garret  显示听牌-- 暗牌
function PlayerPlaneOperator:showTingSelectCards(plane,tingSeq,playerType)

	--获取shoupai区域
	local inhandPlane = plane:getChildByName(CHILD_NAME_INHANDPLANE)

	--获取自己的手牌
	local seatId = ZZMJ_MY_USERINFO.seat_id

	
	local cards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand
	
	if inhandPlane then
		--todo
		-- inhandPlaneOperator:showCards(playerType,inhandPlane,cards,tingSeq)
		inhandPlaneOperator:showTingSelectCards(playerType,inhandPlane,cards,tingSeq)
	end


end


return PlayerPlaneOperator