
--获取牌定义类
local Card = require("js_majiang_3d.card.card")

--获取用户区域操作类
local playerPlaneOperator = require("js_majiang_3d.operator.PlayerPlaneOperator")
local centerPlaneOperator = require("js_majiang_3d.operator.CenterPlaneOperator")

local GamePlaneOperator = class("GamePlaneOperator")

local CHILD_NAME_MY_PLANE = "my_card_plane"
local CHILD_NAME_LEFT_PLANE = "left_card_plane"
local CHILD_NAME_RIGHT_PLANE = "right_card_plane"
local CHILD_NAME_TOP_PLANE = "top_card_plane"

local CHILD_NAME_BAIBAN_PLANE = "baiban_plane"
local CHILD_NAME_QIANGTOU_PLANE = "qiangtou_card_plane"
local CHILD_NAME_CENTER_PLANE = "center_plane"
local CHILD_NAME_CARD_POINTER = "card_pointer"
local CHILD_NAME_CARD_BOX = "card_bx"
local CHILD_NAME_REMAIN_CARDS_COUNT_LB = "remain_cards_count_lb"
local CHILD_NAME_REMARK_LB = "remark_lb"
local CHILD_NAME_READY_IMG = "ready_bar"

-- local schedulerID

function GamePlaneOperator:init()
	ZZMJ_REMAIN_CARDS_COUNT = ZZMJ_CARDS_LESS_INIT

	playerPlaneOperator:init(CARD_PLAYERTYPE_MY, self:getPlayerPlane(CARD_PLAYERTYPE_MY))
	playerPlaneOperator:init(CARD_PLAYERTYPE_LEFT, self:getPlayerPlane(CARD_PLAYERTYPE_LEFT))
	playerPlaneOperator:init(CARD_PLAYERTYPE_RIGHT, self:getPlayerPlane(CARD_PLAYERTYPE_RIGHT))
	playerPlaneOperator:init(CARD_PLAYERTYPE_TOP, self:getPlayerPlane(CARD_PLAYERTYPE_TOP))

	local centerPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CENTER_PLANE)
	centerPlaneOperator:init(centerPlane)

	local myPlane = self:getPlayerPlane(CARD_PLAYERTYPE_MY)
	myPlane.noScale = true
	myPlane:onClick(function()
			playerPlaneOperator:cancelSelectingCard(myPlane)
		end)

	ZZMJ_CARD_POINTER = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CARD_POINTER)
	ZZMJ_CARD_POINTER:setVisible(false)
	--隐藏墙头牌
	local qiangTouPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_QIANGTOU_PLANE)
	qiangTouPlane:setVisible(false)
      
	local remain_cards_count_plane = ZZMJ_GAME_PLANE:getChildByName("remain_cards_count_plane")
	local remain_cards_count_lb = remain_cards_count_plane:getChildByName("remain_cards_count_lb")

	local remain_rounds_count_plane = ZZMJ_GAME_PLANE:getChildByName("remain_rounds_count_plane")
	local remain_rounds_count_lb = remain_rounds_count_plane:getChildByName("remain_rounds_count_lb")
 	local total_rounds_count_lb = remain_rounds_count_plane:getChildByName("total_rounds_count_lb")

	remain_cards_count_lb:setString("0")
	remain_rounds_count_lb:setString("0")
    total_rounds_count_lb:setString("0")

	local card_bx = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CARD_BOX)
	card_bx:setVisible(false)

	local remark_lb = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_REMARK_LB)

	if USER_INFO["gameConfig"] then
		remark_lb:setString(tostring(USER_INFO["joinGameName"]) .. "：" .. USER_INFO["gameConfig"])
	else
		remark_lb:setString("正在读取组局信息")
	end
end

--设置墙头牌
function GamePlaneOperator:showQiangTou(show, fanCardValue, caiShenCards)
	
	if ZZMJ_GAME_PLANE ~= nil then

		local qiangTouPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_QIANGTOU_PLANE)
		--隐藏墙头牌
		if show == true then
			show = false
		end
		qiangTouPlane:setVisible(show)
		qiangTouPlane:setSize(153.00, 33.00)

		if fanCardValue ~= nil then
			local card_iv = qiangTouPlane:getChildByName("card_iv")
			card_iv:loadTexture("js_majiang_3d/image/card/" .. fanCardValue .. ".png")
		end

		local caishen_ly = qiangTouPlane:getChildByName("caishen_ly")
		if caishen_ly ~= nil then
			caishen_ly:removeAllChildren()
		end

		if caiShenCards ~= nil then
			if caishen_ly ~= nil then

				local oriX = 0
				local oriY = -9

				local cardlength = 0

				dump(caiShenCards, "-----财神牌-----")

				JS_CAISHEN = caiShenCards

				for k,v in pairs(caiShenCards) do

					local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, v)
					local size = card:getSize()
					local scale = 0.35
					card:setScale(scale)
					card:setPosition(cc.p(oriX + size.width * scale / 2, oriY))

					cardlength = cardlength + size.width * scale

					caishen_ly:addChild(card)
			     
					card:setTag(0)
					card:setEnabled(false)

					oriX = oriX + size.width * scale + 2

				end

				qiangTouPlane:setSize(70.00 + cardlength, 33.00)

			end
		end

	end
	
end

--设置显示白板替身标志
function GamePlaneOperator:showBaiBanTip(flag)

	local baiBanPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_BAIBAN_PLANE)
	baiBanPlane:setVisible(flag)

end

function GamePlaneOperator:showCenterPlane()
	local centerPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CENTER_PLANE)
	centerPlane:setVisible(true)
end

function GamePlaneOperator:clearGameDatas()
	ZZMJ_REMAIN_CARDS_COUNT = ZZMJ_CARDS_LESS_INIT

	ZZMJ_CURRENT_CARDNODE = nil

	playerPlaneOperator:clearGameDatas(CARD_PLAYERTYPE_MY, self:getPlayerPlane(CARD_PLAYERTYPE_MY))
	playerPlaneOperator:clearGameDatas(CARD_PLAYERTYPE_LEFT, self:getPlayerPlane(CARD_PLAYERTYPE_LEFT))
	playerPlaneOperator:clearGameDatas(CARD_PLAYERTYPE_RIGHT, self:getPlayerPlane(CARD_PLAYERTYPE_RIGHT))
	playerPlaneOperator:clearGameDatas(CARD_PLAYERTYPE_TOP, self:getPlayerPlane(CARD_PLAYERTYPE_TOP))

	local centerPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CENTER_PLANE)
	centerPlaneOperator:clearGameDatas(centerPlane)

	local card_bx = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CARD_BOX)
	card_bx:setVisible(false)

	ZZMJ_CARD_POINTER:setPosition(cc.p(-20, -20))

	-- local scheduler = cc.Director:getInstance():getScheduler()

	-- if schedulerID then
	-- 	--todo
	-- 	scheduler:unscheduleScriptEntry(schedulerID)
	-- 	schedulerID = nil
	-- end
end

function GamePlaneOperator:removePlayer(playerType)
	playerPlaneOperator:clearGameDatas(playerType, self:getPlayerPlane(playerType))
end

function GamePlaneOperator:getPlayerPlane(playerType)
	local plane
	if playerType == CARD_PLAYERTYPE_MY then
		--todo
		plane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_MY_PLANE)
	elseif playerType == CARD_PLAYERTYPE_LEFT then
		plane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_LEFT_PLANE)
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		plane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_RIGHT_PLANE)
	elseif playerType == CARD_PLAYERTYPE_TOP then
		plane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_TOP_PLANE)
	end

	-- --dump(plane, "plane test")
	return plane
end

function GamePlaneOperator:playCard(playerType, tag, value)
	playerPlaneOperator:playCard(playerType, self:getPlayerPlane(playerType), tag, value)

	-- local card_bx = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CARD_BOX)

	-- card_bx:setVisible(true)

	-- card_bx:removeAllChildren()

	-- local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_INHAND, CARD_DISPLAY_TYPE_OPPOSIVE, value)

	-- local size = card:getSize()

	-- local scale = (card_bx:getSize().height - 20) / size.height

	-- card:setScale(scale)

	-- card:setPosition(cc.p(card_bx:getSize().width / 2, card_bx:getSize().height / 2))

	-- card_bx:addChild(card)

	-- local wait = cc.DelayTime:create(1)
	-- local hide = cc.Hide:create()

	-- local seqAction = cc.Sequence:create(wait, hide)

	-- card_bx:runAction(seqAction)


	-- local scheduler = cc.Director:getInstance():getScheduler()  

	-- schedulerID = scheduler:scheduleScriptFunc(function()  
		   
	-- 	   card_bx:setVisible(false)

	-- 	   scheduler:unscheduleScriptEntry(schedulerID)

	-- 	   schedulerID = nil
	-- 	end, 1, false)
end


----@garret  处理相应的游戏打牌操作
function GamePlaneOperator:control(playerType, progCards, controlType, tingSeq,removeCards,fromplayerType,reloginFlage)

	ZZMJ_CARD_POINTER:stopAllActions()
	ZZMJ_CARD_POINTER:setVisible(false)
    
	ZZMJ_CURRENT_CARDNODE = nil

	playerPlaneOperator:control(playerType, self:getPlayerPlane(playerType), progCards,controlType,tingSeq,removeCards,fromplayerType,reloginFlage)
	self:beginPlayCard(playerType)
	
end



function GamePlaneOperator:showPlayerInfo(playerType, userInfo)
	return playerPlaneOperator:showPlayerInfo(userInfo, self:getPlayerPlane(playerType))
end

function GamePlaneOperator:showZhuang(playerType)
	playerPlaneOperator:showZhuang(self:getPlayerPlane(playerType))
end
--显示听牌数据
function GamePlaneOperator:showCards(playerType,tingSeq)
	playerPlaneOperator:showCards(playerType, self:getPlayerPlane(playerType),tingSeq)
end

function GamePlaneOperator:getNewCard(playerType, value,tingSeq)--摸一张牌
	playerPlaneOperator:getNewCard(playerType, self:getPlayerPlane(playerType), value,tingSeq)
	-- playerPlaneOperator:hideControlPlane(self:getPlayerPlane(CARD_PLAYERTYPE_MY))
	self:beginPlayCard(playerType)
end

--移除牌
function GamePlaneOperator:removeCards(playerType, value, isRemoveNewCard)
	playerPlaneOperator:removeCards(playerType, self:getPlayerPlane(playerType), value, isRemoveNewCard)
end


---显示操作按钮界面
function GamePlaneOperator:showControlPlane(controlTable)
	
	ZZMJ_CONTROL_TABLE = controlTable --操作具体数据

	local controlType = controlTable["type"]


	print("显示操作按钮界面1")
	if controlType == CONTROL_TYPE_NONE then
		--todo
		return
	end

	--设置等待操作
	D3_CHUPAI = 2

	playerPlaneOperator:showControlPlane(self:getPlayerPlane(CARD_PLAYERTYPE_MY), controlType)

end



function GamePlaneOperator:hideControlPlane()
	playerPlaneOperator:hideControlPlane(self:getPlayerPlane(CARD_PLAYERTYPE_MY))
end

function GamePlaneOperator:showRemainCardsCount()
	local remain_cards_count_plane = ZZMJ_GAME_PLANE:getChildByName("remain_cards_count_plane")
	local remain_cards_count_lb = remain_cards_count_plane:getChildByName("remain_cards_count_lb")


	local remain_rounds_count_plane = ZZMJ_GAME_PLANE:getChildByName("remain_rounds_count_plane")
	local remain_rounds_count_lb = remain_rounds_count_plane:getChildByName("remain_rounds_count_lb")
 	local total_rounds_count_lb = remain_rounds_count_plane:getChildByName("total_rounds_count_lb")


    local remark_lb = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_REMARK_LB)
    
	if remain_cards_count_lb then

		local content = ZZMJ_REMAIN_CARDS_COUNT	
		remain_cards_count_lb:setString(content)

		if ZZMJ_ROUND then

			if USER_INFO["gameConfig"] then
				remark_lb:setString(tostring(USER_INFO["joinGameName"]) .. "第"..ZZMJ_ROUND.."/"..USER_INFO["gameConfig"])
			end	
            remain_rounds_count_lb:setString(ZZMJ_ROUND)
		    total_rounds_count_lb:setString(ZZMJ_TOTAL_ROUNDS)
		end


	end
end

function GamePlaneOperator:beginPlayCard(playerType)
	local centerPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CENTER_PLANE)

	if centerPlane then
		--todo
		centerPlaneOperator:beginPlayCard(playerType, centerPlane)
	end
   
    for playerType = 1,4 do 
    	playerPlaneOperator:beginPlayCard(self:getPlayerPlane(playerType),false)
    end

	playerPlaneOperator:beginPlayCard(self:getPlayerPlane(playerType),true)
end

function GamePlaneOperator:redrawGameInfo(playerType, data)
	playerPlaneOperator:redrawGameInfo(playerType, self:getPlayerPlane(playerType), data)
end
--显示听牌数据
function GamePlaneOperator:showTingCards(tingSeq)
	playerPlaneOperator:showTingCards(self:getPlayerPlane(CARD_PLAYERTYPE_MY), tingSeq)
end

function GamePlaneOperator:removeLatestOutCard(playerType, card)
	-- SZKWX_CURRENT_CARDNODE:removeFromParent() 
	return playerPlaneOperator:removeLatestOutCard(self:getPlayerPlane(playerType), card)	
end

-- function GamePlaneOperator:didSelectOutCard(card)
-- 	playerPlaneOperator:didSelectOutCard(self:getPlayerPlane(CARD_PLAYERTYPE_MY), card)
-- end

function GamePlaneOperator:showLgSelectBox(lgCards)
	playerPlaneOperator:showLgSelectBox(self:getPlayerPlane(CARD_PLAYERTYPE_MY), lgCards)
end

function GamePlaneOperator:showTingHuPlane(playerType, tingHuCards)
	playerPlaneOperator:showTingHuPlane(self:getPlayerPlane(playerType), tingHuCards)
end

function GamePlaneOperator:hideTingHuPlane()
	playerPlaneOperator:hideTingHuPlane(self:getPlayerPlane(CARD_PLAYERTYPE_MY))
end

--显示花牌
function GamePlaneOperator:showHuaCard(playerType, hCards)
	playerPlaneOperator:showHuaCard(self:getPlayerPlane(playerType), hCards)
end

--隐藏花牌区域
function GamePlaneOperator:hideHuaCard(playerType)
	playerPlaneOperator:hideHuaCard(self:getPlayerPlane(playerType))
end

function GamePlaneOperator:playHuaCard(playerType,value)
	playerPlaneOperator:playHuaCard(playerType,self:getPlayerPlane(playerType),value)
end

function GamePlaneOperator:buHua(playerType)
    playerPlaneOperator:buHua(self:getPlayerPlane(playerType))
end

function GamePlaneOperator:showCaiPiao(playerType)
    -- playerPlaneOperator:showCaiPiao(self:getPlayerPlane(playerType))
end

function GamePlaneOperator:showCardsForHu(playerType, cardDatas,hucard)
	playerPlaneOperator:showCardsForHu(playerType, self:getPlayerPlane(playerType), cardDatas,hucard)
end

function GamePlaneOperator:getHeadNode(playerType)
	return playerPlaneOperator:getHeadNode(self:getPlayerPlane(playerType))
end

function GamePlaneOperator:showNetworkImg(playerType, flag)
	playerPlaneOperator:showNetworkImg(self:getPlayerPlane(playerType), flag)
end

function GamePlaneOperator:showJiapiaoPlane(flag)
	playerPlaneOperator:showJiapiaoPlane(self:getPlayerPlane(CARD_PLAYERTYPE_MY), flag)
end

function GamePlaneOperator:showPiaoImg(playerType, piao, flag)
	playerPlaneOperator:showPiaoImg(self:getPlayerPlane(playerType), piao, flag)
end

function GamePlaneOperator:showPiaoPlane(playerType, piao, flag)
	playerPlaneOperator:showPiaoPlane(self:getPlayerPlane(playerType), piao, flag)
end

function GamePlaneOperator:clearPiaoImg()
	self:showPiaoImg(CARD_PLAYERTYPE_MY, 0, false)
	self:showPiaoImg(CARD_PLAYERTYPE_LEFT, 0, false)
	self:showPiaoImg(CARD_PLAYERTYPE_RIGHT, 0, false)
	self:showPiaoImg(CARD_PLAYERTYPE_TOP, 0, false)
end

function GamePlaneOperator:HuiPai(playerType,huipai)
	playerPlaneOperator:HuiPai(self:getPlayerPlane(playerType),huipai)
end

--旋转中央方向指示器
function GamePlaneOperator:rotateTimer(zhuang_index)
local centerPlane = ZZMJ_GAME_PLANE:getChildByName(CHILD_NAME_CENTER_PLANE)

	centerPlaneOperator:rotateTimer(zhuang_index,centerPlane)
end
--[[
	@brief:设置玩家准备状态
	@param:_playerType 座位id
	@author:Jhao.
]]
function GamePlaneOperator:setReadyStatus(playerType)
	local panel = self:getPlayerPlane(playerType)
	if panel == nil then return end

	local ready_img = panel:getChildByName(CHILD_NAME_READY_IMG)
	if ready_img ~= nil then 
		ready_img:setVisible(true)	 
	end
	-- --dump(playerType,"看看是否执行到这了")
end

--[[
	@brief:清除所有玩家的准备状态
	@author:Jhao.
]]
function GamePlaneOperator:clearAllReadyStatus()
	local tbPlayerType = {CARD_PLAYERTYPE_MY,
							CARD_PLAYERTYPE_LEFT,
							CARD_PLAYERTYPE_RIGHT,
							CARD_PLAYERTYPE_TOP,}

	for key, playerType in pairs(tbPlayerType) do
		local panel = self:getPlayerPlane(playerType)
		local ready_img = panel:getChildByName(CHILD_NAME_READY_IMG)
		if ready_img ~= nil then ready_img:setVisible(false) end
	end
end

--显示与点击的牌相同的已出的牌
function GamePlaneOperator:showSameCard(value)
    for playerType = 1,4 do 
    	playerPlaneOperator:showSameCard(self:getPlayerPlane(playerType),value)
    end
end

function GamePlaneOperator:hideSameCard()
    playerPlaneOperator:hideSameCard()
end


function GamePlaneOperator:putCard()
    playerPlaneOperator:putCard()
end


function GamePlaneOperator:showDistance(LocaArrayByPlayerType,flag)

	if ZZMJ_GAME_PLANE ~= nil then
		
		if ZZMJ_GAME_PLANE:getParent() ~= nil then
			
			local distance_bt = ZZMJ_GAME_PLANE:getParent():getChildByName("menu_ly"):getChildByName("menu_plane"):getChildByName("distance_bt")
		   	distance_bt:setVisible(true)
		   	distance_bt:addTouchEventListener(
		    function(sender,event)
		        --触摸开始
		        if event == TOUCH_EVENT_ENDED then
		            self:showDistanceAgain()
		        end
		        
		    end)

		    local function getDistance(latitude,longitude,b_latitude,b_longitude,lb)
		       if  (latitude == 0 or latitude == nil) or (b_latitude == 0 or b_latitude == nil)  then   --距离数据不存在
		           lb:setString("距离未知")
		       else
		            local s = require("hall.util.LocationUtil"):getDistance(latitude, longitude, b_latitude, b_longitude)
		            if s >= 0 then

		                if s < 1000 then
		                    lb:setString(tostring(s) .. "米")
		                else
		                    s = s / 1000
		                    s = math.floor(s)
		                    lb:setString(tostring(s) .. "公里")
		                end     
		            end
		       end
		    end

		    local distance = (ZZMJ_GAME_PLANE:getChildByName("my_card_plane")):getChildByName("distance")
		    local left_top_lb = distance:getChildByName("left_top_lb")
		    local left_right_lb = distance:getChildByName("left_right_lb")
		    local right_top_lb = distance:getChildByName("right_top_lb")
		    
		    local flag = flag or false
		    distance:setVisible(flag)
		    distance:performWithDelay(function() distance:setVisible(false) end,3)

		   	local  left = LocaArrayByPlayerType[2] or {0,0}
		   	local  right = LocaArrayByPlayerType[3] or {0,0}
		   	local  top =  LocaArrayByPlayerType[4] or {0,0}

		    if PLAYERNUM == 4 then 
		        
		       -- [1]是longitude,[2]是latitude
		       local left_right_txt = getDistance(left[2],  left[1],  right[2], right[1],  left_right_lb)
		       local left_top_txt   = getDistance(left[2],  left[1],  top[2],   top[1],    left_top_lb)
		       local right_top_txt  = getDistance(right[2], right[1], top[2],   top[1],    right_top_lb)

		    elseif  PLAYERNUM == 3 then 

		       local left_right_txt = getDistance(left[2],  left[1],  right[2], right[1],  left_right_lb)

		    end

		end

	end

end

function GamePlaneOperator:showDistanceAgain()
	local distance = (ZZMJ_GAME_PLANE:getChildByName("my_card_plane")):getChildByName("distance")
	distance:setVisible(true)
    distance:performWithDelay(function() distance:setVisible(false) end,3)
end

---接3d选择听牌
function GamePlaneOperator:didSelectOutCard(card)
    -- playerPlaneOperator:didSelectOutCard(card)

    ZZMJ_CONTROLLER:didSelectOutCard(card)

end
--@garret 显示手牌中暗牌
function GamePlaneOperator:showTingBtnAndBalcCards( value ,playerType)
	
-- 0x01-0x09代表一万到九万，0x11-0x19代表一筒到九筒，0x21-0x29代表一条到九条，0x31、0x32、0x33、0x34分别代表东南西北，0x41、0x42、0x43分别代表白板、红中、发财，0x51、0x52、0x53、0x54、0x55、0x56、0x57、0x58分别代表花牌的春夏秋冬梅兰竹菊
	local cardSum = value.cardSum  --可能的组合数
	local  cardValue = value.LiangDate
	--丢牌
	local tingSeq = {}
	--有丢牌数据
	if cardSum > 0 then
		-- for k,v in pairs(cardValue) do
		-- 	-- dump(v.huCards,"huCardsahfsdfsdjiofsdjiojioffoaijsdjioafsdioj00-------------")
		-- 	local leaveNum= table.getn(v.huCards)

		-- 	if leaveNum == 1 then
		-- 		table.insert( tingSeq, v.OpCard)
		-- 	end

		-- end	
	
		for k,v in pairs(cardValue) do
			local ishad = false
			for m,n in pairs(tingSeq) do 
				if v.OpCard == n then
					ishad  = true
				end
			end
			if ishad == false then
				table.insert(tingSeq,v.OpCard)
			end

		end

	end

	dump(tingSeq,"tingSeq----暗牌")
	local lltt = table.getn(tingSeq)

	--有丢牌数据才显示听牌按钮  并且不存在杠胡等操作
	-- value.tingSeq = tingSeq
	if  lltt > 0 then
		--保存
		JS_TING_REMOVE = tingSeq
		isTingFF = 1
		-- self:showControlPlane(value,isTingFF) --显示听按钮
		-- playerPlaneOperator:showTingSelectCards(self:getPlayerPlane(CARD_PLAYERTYPE_MY),tingSeq,playerType)
	end

	
	
end



return GamePlaneOperator