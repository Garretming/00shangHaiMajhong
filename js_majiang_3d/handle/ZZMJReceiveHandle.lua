
-- --加载麻将设置类（麻将公共方法类）
-- require("majiang.setting_help")

--加载框架初始化类
require("framework.init")

--获取游戏界面操作类
local gamePlaneOperator = require("js_majiang_3d.operator.GamePlaneOperator")
-- local manyouPlaneOperator = require("js_majiang_3d.operator.ManyouPlaneOperator")

local cardUtils = require("js_majiang_3d.utils.cardUtils")

--加载大厅请求处理
local hallHandle = require("hall.HallHandle")

local voiceUtils = require("js_majiang_3d.utils.VoiceUtils")

--大厅套接字请求类
local hallPa = require("hall.HALL_PROTOCOL")

--麻将套接字请求类
local PROTOCOL = import("js_majiang_3d.handle.ZZMJProtocol")
setmetatable(PROTOCOL, {
		__index=hallPa
	})

local sendHandle = require("js_majiang_3d.handle.ZZMJSendHandle")

--定义麻将游戏处理类
local ZZMJReceiveHandle = class("ZZMJReceiveHandle",hallHandle)

local aniUtils = require("js_majiang_3d.utils.AniUtils")

--定义登录超时时间
local LOGIN_OUT_TIMER = 20

--定义麻将游戏界面名称
local run_scene_name = "js_majiang_3d.gameScene"

--定义麻将操作
require("js_majiang_3d.globle.ZZMJDefine")

--扣除台费百分数
local percent_base = 0.20

local item_ly_list = {}

local liujuFlag = true

function ZZMJReceiveHandle:ctor()

	ZZMJReceiveHandle.super.ctor(self);

	--定义麻将游戏请求	
	local  func_ = {

		--用户自己退出成功
        [PROTOCOL.SVR_QUICK_SUC] = {handler(self, ZZMJReceiveHandle.SVR_QUICK_SUC)},
        --广播用户准备
        [PROTOCOL.SVR_USER_READY_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_USER_READY_BROADCAST)},
        --登陆房间广播
        [PROTOCOL.SVR_LOGIN_ROOM_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_LOGIN_ROOM_BROADCAST)},
        --广播玩家退出返回
        [PROTOCOL.SVR_QUIT_ROOM] = {handler(self, ZZMJReceiveHandle.SVR_QUIT_ROOM)},
        --发牌
        [PROTOCOL.SVR_SEND_USER_CARD] = {handler(self, ZZMJReceiveHandle.SVR_SEND_USER_CARD)},
        --开始选择缺一门
        [PROTOCOL.SVR_START_QUE_CHOICE] = {handler(self, ZZMJReceiveHandle.SVR_START_QUE_CHOICE)},
        --广播缺一门选择
        [PROTOCOL.SVR_BROADCAST_QUE] = {handler(self, ZZMJReceiveHandle.SVR_BROADCAST_QUE)},
        --当前抓牌用户广播
        [PROTOCOL.SVR_PLAYING_UID_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_PLAYING_UID_BROADCAST)},
        --广播用户出牌
        [PROTOCOL.SVR_SEND_MAJIANG_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_SEND_MAJIANG_BROADCAST)},
        --svr通知我抓的牌
        [PROTOCOL.SVR_OWN_CATCH_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_OWN_CATCH_BROADCAST)},
        --广播用户进行了什么操作
        [PROTOCOL.SVR_PLAYER_USER_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_PLAYER_USER_BROADCAST)},
        --广播胡
    	[PROTOCOL.SVR_HUPAI_BROADCAST]       = {handler(self, ZZMJReceiveHandle.SVR_HUPAI_BROADCAST)}, 
    	--结算
    	[PROTOCOL.SVR_ENDDING_BROADCAST] = {handler(self, ZZMJReceiveHandle.SVR_ENDDING_BROADCAST)}, 
    	--请求托管
    	[PROTOCOL.SVR_ROBOT] = {handler(self, ZZMJReceiveHandle.SVR_ROBOT)}, 
    	--出牌错误返回
    	-- [PROTOCOL.SVR_CHUPAI_ERROR] = {handler(self, ZZMJReceiveHandle.SVR_CHUPAI_ERROR)}, 
    	--海底牌 SVR_HAIDI_CARD
    	-- [PROTOCOL.SVR_HAIDI_CARD] = {handler(self, ZZMJReceiveHandle.SVR_HAIDI_CARD)}, 
    	--亮倒提示
    	-- [PROTOCOL.SVR_LIANGDAO_REMAID] = {handler(self, ZZMJReceiveHandle.SVR_LIANGDAO_REMAID)}, 
    	[PROTOCOL.SVR_MSG_FACE]={handler(self, ZZMJReceiveHandle.SVR_MSG_FACE)},
    	
    	[PROTOCOL.BROADCAST_USER_IP]={handler(self, ZZMJReceiveHandle.BROADCAST_USER_IP)},

    	-- [PROTOCOL.SVR_HUIPAI]={handler(self, ZZMJReceiveHandle.SVR_HUIPAI)},

    	-- [PROTOCOL.SVR_JIAPIAO]={handler(self, ZZMJReceiveHandle.SVR_JIAPIAO)},
    	-- [PROTOCOL.SVR_JIAPIAO_BROADCAST]={handler(self, ZZMJReceiveHandle.SVR_JIAPIAO_BROADCAST)},

    	--获取房间id结果
    	[PROTOCOL.SVR_GET_ROOM_OK]     = {handler(self, ZZMJReceiveHandle.SVR_GET_ROOM_OK)},
    	--登陆房间返回
        [PROTOCOL.SVR_LOGIN_ROOM]      = {handler(self, ZZMJReceiveHandle.SVR_LOGIN_ROOM)},
        --登陆错误
     	[PROTOCOL.SVR_ERROR]      = {handler(self, ZZMJReceiveHandle.SVR_ERROR)},
     	--用户重新登录普通房间的消息返回（4105(10进制s)）
     	[PROTOCOL.SVR_REGET_ROOM]      = {handler(self, ZZMJReceiveHandle.SVR_REGET_ROOM)},--重登
     	--服务器告知客户端可以进行的操作
     	[PROTOCOL.SVR_NORMAL_OPERATE]      = {handler(self, ZZMJReceiveHandle.SVR_NORMAL_OPERATE)},--广播可以进行的操作
     	--服务器告知客户端游戏结束
     	[PROTOCOL.SVR_GAME_OVER]      = {handler(self, ZZMJReceiveHandle.SVR_GAME_OVER)},
     	--广播刮风下雨（返回）杠
     	[PROTOCOL.SVR_GUFENG_XIAYU]      = {handler(self, ZZMJReceiveHandle.SVR_GUFENG_XIAYU)},

     	--用户聊天消息
     	[PROTOCOL.CHAT_MSG]      = {handler(self, ZZMJReceiveHandle.CHAT_MSG)},

     	--组局
     	--请求获取筹码返回
     	[PROTOCOL.SVR_GET_CHIP]     = {handler(self, ZZMJReceiveHandle.SVR_GET_CHIP)},
     	--请求兑换筹码返回
     	[PROTOCOL.SVR_CHANGE_CHIP]     = {handler(self, ZZMJReceiveHandle.SVR_CHANGE_CHIP)},
     	--组局时长
     	[PROTOCOL.SVR_GROUP_TIME]     = {handler(self, ZZMJReceiveHandle.SVR_GROUP_TIME)},
     	--组局排行榜
     	[PROTOCOL.SVR_GROUP_BILLBOARD]     = {handler(self, ZZMJReceiveHandle.SVR_GROUP_BILLBOARD)},
     	--组局历史记录
     	[PROTOCOL.SVR_GET_HISTORY]     = {handler(self, ZZMJReceiveHandle.SVR_GET_HISTORY)},
     	--漫游
     	-- [PROTOCOL.SVR_MANYOU] = {handler(self, ZZMJReceiveHandle.SVR_MANYOU)},

     	--没有此房间，解散房间失败
     	[PROTOCOL.G2H_CMD_DISSOLVE_FAILED]     = {handler(self, ZZMJReceiveHandle.G2H_CMD_DISSOLVE_FAILED)},
     	--广播桌子用户请求解散组局
     	[PROTOCOL.SERVER_BROADCAST_REQUEST_DISSOLVE_GROUP]     = {handler(self, ZZMJReceiveHandle.SERVER_BROADCAST_REQUEST_DISSOLVE_GROUP)},
     	--广播当前组局解散情况
     	[PROTOCOL.G2H_CMD_REFRESH_DISSOLVE_LIST]     = {handler(self, ZZMJReceiveHandle.G2H_CMD_REFRESH_DISSOLVE_LIST)},
     	--广播桌子用户成功解散组局
     	[PROTOCOL.SERVER_BROADCAST_DISSOLVE_GROUP]     = {handler(self, ZZMJReceiveHandle.SERVER_BROADCAST_DISSOLVE_GROUP)},
     	--广播桌子用户解散组局 ，解散组局失败
     	[PROTOCOL.SERVER_BROADCAST_FORBIT_DISSOLVE_GROUP]     = {handler(self, ZZMJReceiveHandle.SERVER_BROADCAST_FORBIT_DISSOLVE_GROUP)},

     	--换牌
     	--服务器告诉客户端，可以换牌
     	[PROTOCOL.SERVER_COMMAND_NEED_CHANGE_CARD]     = {handler(self, ZZMJReceiveHandle.SERVER_COMMAND_NEED_CHANGE_CARD)},
     	--//服务器广播换牌的结果 zsw
     	[PROTOCOL.SERVER_COMMAND_CHANGE_CARD_RESULT]     = {handler(self, ZZMJReceiveHandle.SERVER_COMMAND_CHANGE_CARD_RESULT)},
        
        --录音
        [PROTOCOL.SERVER_CMD_MESSAGE] = {handler(self, ZZMJReceiveHandle.SERVER_CMD_MESSAGE)},   
        --接收服务器发来的距离
        [PROTOCOL.SERVER_CMD_FORWARD_MESSAGE] = {handler(self, ZZMJReceiveHandle.SERVER_CMD_FORWARD_MESSAGE)},

     	--比赛场相关
     	--用户请求进入比赛场的返回值
     	[PROTOCOL.s2c_JOIN_MATCH_RETURN]     = {handler(self, ZZMJReceiveHandle.s2c_JOIN_MATCH_RETURN)},
     	--进入比赛失败
     	[PROTOCOL.s2c_JOIN_MATCH_FAIL]     = {handler(self, ZZMJReceiveHandle.s2c_JOIN_MATCH_FAIL)},
     	-- 进入比赛成功
		[PROTOCOL.s2c_JOIN_MATCH_SUCCESS]     = {handler(self, ZZMJReceiveHandle.s2c_JOIN_MATCH_SUCCESS)},
		--同时，已经报名的玩家会收到其他玩家进入的消息
     	[PROTOCOL.s2c_OTHER_PEOPLE_JOINT_IN]     = {handler(self, ZZMJReceiveHandle.s2c_OTHER_PEOPLE_JOINT_IN)},
     	--返回退出比赛结果
     	[PROTOCOL.s2c_QUIT_MATCH_RETURN]     = {handler(self, ZZMJReceiveHandle.s2c_QUIT_MATCH_RETURN)},
     	--比赛开始逻辑0x7104//牌局，开始发送其他玩家信息
     	[PROTOCOL.s2c_GAME_BEGIN_LOGIC]     = {handler(self, ZZMJReceiveHandle.s2c_GAME_BEGIN_LOGIC)},
     	--每轮打完之后 会给玩家发送比赛状态信息0x7106
     	[PROTOCOL.s2c_GAME_STATE_MSG]     = {handler(self, ZZMJReceiveHandle.s2c_GAME_STATE_MSG)},
     	-- 比赛的过程中会收到比赛的排名信息  0x7114
     	[PROTOCOL.s2c_PAI_MING_MSG]     = {handler(self, ZZMJReceiveHandle.s2c_PAI_MING_MSG)},
     	--发送用户重连回比赛开赛后的等待界面
     	-- [PROTOCOL.s2c_SVR_MATCH_WAIT]     = {handler(self, ZZMJReceiveHandle.s2c_SVR_MATCH_WAIT)},
     	--用户重新登录比赛场房间的消息返回
     	-- [PROTOCOL.s2c_SVR_REGET_MATCH_ROOM] = {handler(self, ZZMJReceiveHandle.s2c_SVR_REGET_MATCH_ROOM)},


        --补花
        [PROTOCOL.SERVER_BUHUA]     = {handler(self, ZZMJReceiveHandle.SERVER_BUHUA)},

        --亮倒        --报听
        [PROTOCOL.SVR_LIANGDAO]     = {handler(self, ZZMJReceiveHandle.SVR_LIANGDAO)},
    }
    table.merge(self.func_, func_)

end

local LocaArrayByPlayerType = {}
-- 亮倒（听牌）  数据没有用
function ZZMJReceiveHandle:SVR_LIANGDAO(pack)
	dump(pack, "-----广播玩家听牌 3009-----")
	-- 	--todo 通知界面   当前玩家是指定听牌玩家---显示听牌按钮 显示暗牌
	local seatId = ZZMJ_SEAT_TABLE[pack.UserId .. ""]
	local playerType = cardUtils:getPlayerType(seatId)

	if playerType  == CARD_PLAYERTYPE_MY then
	-- if pack.UserId == UID then
		--构建听牌数据
		local showTingBtnType = pack
		showTingBtnType["type"] = TING_TYPE_T  --操作类型
		gamePlaneOperator:showTingBtnAndBalcCards(showTingBtnType,playerType)
		
	 end

end

--接收服务器返回的组局信息
function ZZMJReceiveHandle:SERVER_CMD_MESSAGE(pack)

    dump(pack, "-----接收服务器返回的组局信息-----")

    if bm.isInGame == false then
        return
    end
    
    local msg = json.decode(pack.msg)
    dump(msg, "-----NiuniuroomHandle 接收服务器返回的组局信息-----")
    if msg ~= nil then
        local msgType = msg.msgType
        if msgType ~= nil and msgType ~= "" then

            if device.platform == "ios" then

                if msgType == "voice" then
                    dump("voice", "-----接收服务器返回的组局信息-----")

                    require("hall.view.voicePlayView.voicePlayView"):showView(msg.uid, msg.voiceTime)

                    --通知本地播放录音
                    local arr = {}
                    arr["url"] = msg.url
                    cct.getDateForApp("playVoice", arr, "V")

                elseif msgType == "video" then
                    dump("video", "-----接收服务器返回的组局信息-----")

                    local arr = {}
                    arr["url"] = msg.url
                    cct.getDateForApp("playVideo", arr, "V")

                end

            else

                if msgType == "voice" then
                    dump("voice", "-----接收服务器返回的组局信息-----")

                    require("hall.view.voicePlayView.voicePlayView"):showView(msg.uid, msg.voiceTime)

                    --通知本地播放录音

                    local data = {}
                    data["url"] = msg.url
                    
                    local arr = {}
                    table.insert(arr, json.encode(data))
                    cct.getDateForApp("playVoice", arr, "V")

                elseif msgType == "video" then
                    dump("video", "-----接收服务器返回的组局信息-----")
                    
                    local data = {}
                    data["url"] = msg.url
                    
                    local arr = {}
                    table.insert(arr, json.encode(data))
                    cct.getDateForApp("playVideo", arr, "V")

                end
            
            end

        end
    end
    
end

--接收服务器发来的距离数据
function ZZMJReceiveHandle:SERVER_CMD_FORWARD_MESSAGE(pack)

    dump(pack,"-------接收服务器发来的距离数据---------")   

    local msgList = pack.msgList
    --存放距离数据的数组

    for k,v in pairs(msgList) do
    	if v ~= nil and v ~= "" then
    		local msg = json.decode(v)
            if msg ~= nil then
                if msg.uid ~= nil then
                    if ZZMJ_SEAT_TABLE and next(ZZMJ_SEAT_TABLE)~=nil then
                    local playerType = cardUtils:getPlayerType(ZZMJ_SEAT_TABLE[msg.uid.. ""])
                    LocaArrayByPlayerType[playerType] = {[1] = tonumber(msg.longitude) ,[2] = tonumber(msg.latitude)}
                    end
                    require("hall.view.userInfoView.userInfoView"):upDateUserInfo(msg.uid,msg)

                end
            end
    	end
    end
    
    if #LocaArrayByPlayerType>PLAYERNUM-1 then 
       if ZZMJ_GAME_STATUS ~= 1 then
         gamePlaneOperator:showDistance(LocaArrayByPlayerType,true)
       else
         gamePlaneOperator:showDistance(LocaArrayByPlayerType,false)
       end 
       LocaArrayByPlayerType ={}
    end

end

--显示手机信息
function ZZMJReceiveHandle:getDeviceInfo()

    dump("", "-----显示手机信息-----")

    if tolua.isnull(ZZMJ_GAME_PLANE)  then
       return
    end

    local device_info_plane = (ZZMJ_GAME_PLANE:getParent()):getChildByName("device_info_plane")
    local wifi_level        = device_info_plane:getChildByName("wifi_level")
    local battery_level     = device_info_plane:getChildByName("battery_level")
    local time              = device_info_plane:getChildByName("time")
    
    wifi_level_num = 0
    if PINT_TIME~=nil then
      
        local ping = PINT_TIME
        if tonumber(ping)<=120 then
            wifi_level_num = 4
        elseif tonumber(ping)>120 and tonumber(ping)<=200 then
            wifi_level_num = 3
        elseif tonumber(ping)>200 and tonumber(ping)<=300 then
            wifi_level_num = 2
        elseif tonumber(ping)>300 and tonumber(ping)<=500 then
            wifi_level_num = 1
        elseif tonumber(ping)>500 then
            wifi_level_num = 0
        end   
    end
    wifi_level:setTexture("js_majiang_3d/image/wifi_0"..wifi_level_num..".png")

    local battery_level_degree = 100
    battery_level:setPercent(battery_level_degree) 

    local time_txt = os.date("%H:%M")
    time:setString(time_txt)

end

--会牌协议
function ZZMJReceiveHandle:SVR_HUIPAI(pack)

    dump(pack, "-----会牌协议-----")

	HUIPAI=pack.PrivateHuipai or {}
    local PublicHuipai=pack.Huipai
    table.insert(HUIPAI,PublicHuipai)
    
    gamePlaneOperator:HuiPai(CARD_PLAYERTYPE_MY,pack.Huipai)

end

--加注协议
function ZZMJReceiveHandle:SVR_JIAPIAO(pack)

    dump(pack, "-----加注协议-----")

	local scenes  = SCENENOW['scene']

	if SCENENOW["name"] ~= run_scene_name then
		return
	end

	scenes:hideCloseRoomButton()
	scenes:ShowSettingButton()
	scenes:hideShareButton()

	gamePlaneOperator:showCenterPlane()

	gamePlaneOperator:showJiapiaoPlane(true)

end

--加注协议
function ZZMJReceiveHandle:SVR_JIAPIAO_BROADCAST(pack)
	local playerType = cardUtils:getPlayerType(pack.seatId)
	gamePlaneOperator:showPiaoImg(playerType, pack.jiapiao, true)
	gamePlaneOperator:showPiaoPlane(playerType, pack.jiapiao, true)
end

--广播用户IP
function ZZMJReceiveHandle:BROADCAST_USER_IP(pack)

    dump(pack, "-----广播用户IP-----")

	local playeripdata = pack.playeripdata or {}
    local new_ip_table={}
    for _,ip_data in pairs(playeripdata) do
        local ip_ = ip_data.ip or ""
        local uid_ = ip_data.uid or 0
        if uid_ ~= 0 then
            local seatId = ZZMJ_SEAT_TABLE[uid_ .. ""]
            new_ip_table[uid_..""] = ip_
            if seatId then
    	        if ZZMJ_USERINFO_TABLE[seatId .. ""] then
    	            ZZMJ_USERINFO_TABLE[seatId .. ""].ip = ip_
    	        end
	        end
        end
    end

	local myIp = ""

    if ZZMJ_MY_USERINFO.seat_id and ZZMJ_USERINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""] then
    	--todo
    	myIp = ZZMJ_USERINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].ip
    end


    local ipTable = {}
    for k,v in pairs(ZZMJ_USERINFO_TABLE) do
    	if v.ip and v.ip ~= myIp then
    		--todo
    		if not ipTable[v.ip] then
    			--todo
    			ipTable[v.ip] = {}
    		end
    		table.insert(ipTable[v.ip], v.nick)
    	end
    end

    local msg = ""
    for k,v in pairs(ipTable) do
    	if table.getn(v) > 1 then
    		--todo
    		for i=1,table.getn(v) do
    			msg = msg .. v[i] .. " "
    		end
    	end
    end

    if msg ~= "" then
    	require("hall.GameCommon"):showAlert(false, "提示：" .. msg .. "ip地址相同，谨防作弊", 300)
    	require("hall.GameCommon"):showAlert(true, "提示：" .. msg .. "ip地址相同，谨防作弊", 300)
    end
                
    local ip = new_ip_table[USER_INFO["uid"] .. ""] or ""
    sendHandle:CLIENT_CMD_FORWARD_MESSAGE(ip)

end

--表情协议
function ZZMJReceiveHandle:SVR_MSG_FACE(pack)

    dump(pack, "-----表情协议-----")

	if SCENENOW["name"] == run_scene_name then
		local seatId = ZZMJ_SEAT_TABLE[pack.uid .. ""]
		local sex = ZZMJ_USERINFO_TABLE[seatId .. ""].sex
		local playerType = cardUtils:getPlayerType(seatId)

		local isLeft = false
		if playerType == CARD_PLAYERTYPE_RIGHT then
			--todo
			isLeft = true
		end

		local node_head = gamePlaneOperator:getHeadNode(playerType)


        SCENENOW["scene"]:SVR_MSG_FACE(pack.uid, pack.type, sex, node_head, isLeft)
    end

end

--海底牌
function ZZMJReceiveHandle:SVR_HAIDI_CARD(pack)

    dump(pack, "-----海底牌-----")

	ZZMJ_REMAIN_CARDS_COUNT = 0
	gamePlaneOperator:showRemainCardsCount()
	manyouPlaneOperator:show(pack.card, pack.uid)

end

--不能点炮提醒
function ZZMJReceiveHandle:SVR_LIANGDAO_REMAID(pack)

    dump(pack, "-----不能点炮提醒-----")

	ZZMJ_ROOM.dianpao_card = pack.card

	local desc = "不能点炮，请重新出牌\n\n"

	desc = desc .. "接炮的玩家："

	for k,v in pairs(pack.winSeats) do
		desc = desc .. ZZMJ_USERINFO_TABLE[v .. ""].nick .. "  "
	end

	require("hall.GameCommon"):showAlert(true, desc, 300)

	D3_CHUPAI = 1

end

--出牌错误返回
function ZZMJReceiveHandle:SVR_CHUPAI_ERROR(pack)

    dump(pack, "-----出牌错误返回-----")

	local errorCode = pack.errorCode

	if errorCode == 1 then
		--todo
		D3_CHUPAI = 1
	elseif errorCode == 2 then
		D3_CHUPAI = 1
		require("hall.GameCommon"):showAlert(true, "正在等待自己或者其他玩家操作", 200)
	elseif errorCode == 3 then
		D3_CHUPAI = 0
	elseif errorCode == 4 then
		D3_CHUPAI = 1
	end


end

--获取玩家显示的位置号 0自己，1左边玩家，2对家，3右边玩家
function ZZMJReceiveHandle:getIndex(uid)

	if tonumber(uid) == tonumber(USER_INFO["uid"]) then
		return 0
	end
	local other_seat  = ZZMJ_ROOM.User[uid]
	--dump( ZZMJ_ROOM.User, " ZZMJ_ROOM.User")

	--print(other_seat,bm.User.Seat,"2")
	local other_index = other_seat - bm.User.Seat
	if other_index < 0 then
		other_index = other_index + 4
	end
	--print(other_index,"3")
	   
	if other_index == 1 then
    	other_index = 3
    elseif other_index == 3 then
    	other_index = 1 
    end

	return other_index

end

--漫游
function ZZMJReceiveHandle:SVR_MANYOU(pack)

    dump(pack, "-----漫游-----")

	manyouPlaneOperator:show()

end

--显示倒计时器
function ZZMJReceiveHandle:showTimer(uid,time)

	local scenes = SCENENOW['scene']

	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	--设置显示计时器
	scenes:show_timer_visible(true)

	--初始化计时器
	scenes:init_clock()

	if ZZMJ_ROOM.timerid then
		bm.SchedulerPool:clear(ZZMJ_ROOM.timerid)
	end

	local index = self:getIndex(uid)
	scenes:show_timer_index(index)
	ZZMJ_ROOM.timer   = time
	self.timecount_ = 0 
	ZZMJ_ROOM.timerid = nil

	ZZMJ_ROOM.timerid = bm.SchedulerPool:loopCall(function()

		self.timecount_ = self.timecount_ + 1

		if ZZMJ_ROOM.timer and self.timecount_ % 5 == 0 then
			ZZMJ_ROOM.timer  = ZZMJ_ROOM.timer - 1
		end

		if ZZMJ_ROOM.timer and ZZMJ_ROOM.timer >= 0 and ZZMJ_ROOM.timer <= 9 then
			local scenes  = SCENENOW['scene']
			if SCENENOW['name'] == run_scene_name and scenes.show_timer_num then
				--显示时间数字
				scenes:show_timer_num(ZZMJ_ROOM.timer)
				--
				scenes:showClock(index,ZZMJ_ROOM.timer,true)
			end
		end
		
		return true

	end,0.2)

end

--清理界面
function ZZMJReceiveHandle:clearUserView(index)

	dump(index, "-----清理界面-----")

	-- local index   = self:getIndex(uid)
	local scenes  = SCENENOW['scene']

	if SCENENOW["name"] ~= run_scene_name then
		return
	end

	if index == 0 then
		local node = scenes._scene:getChildByName("layer_card"):getChildByName("owncard")
		if node then
			node:removeSelf()
		end

		local node = scenes:getChildByName("play_info")
		if node then
			node:removeSelf()
		end

		
	else
		local node = scenes._scene:getChildByName("layer_card"):getChildByName("othercard"..index)
		if node then
			node:removeSelf()
		end

		local node = scenes:getChildByName("play_info"..index)
		if node then
			node:removeSelf()
		end
	end

	local node = scenes:getChildByName("cardout"..index)
	if node then
		node:removeSelf()
	end

	if ZZMJ_ROOM.timerid then
		bm.SchedulerPool:clear(ZZMJ_ROOM.timerid)
	end  

	local node = scenes:getChildByName("timer") 
	if node then
		node:removeSelf()
	end

	local node = scenes:getChildByName("zhuang") 
	if node then
		node:removeSelf()
	end

	local node = scenes:getChildByName("has_xuan_que") 
	if node then
		node:removeSelf()
	end

	local node    = scenes:getChildByName("user"..index)
	if node ~= nil then
		node:removeSelf()
	end

	scenes:show_tuoguan_layout(false)
	scenes:set_left_card_num_visible(false)

	bm.palying = false

end
-------------------------------------------------------------------------------------------------------------------

--协议相关

--麻将游戏加载请求方法
function ZZMJReceiveHandle:callFunc(pack)

	if self.func_[pack.cmd] and self.func_[pack.cmd][1] then
        self.func_[pack.cmd][1](pack)
    end

end
-------------------------------------------------------------------------------------------------------------------

--进出房间相关
--用户进入房间
function ZZMJReceiveHandle:SVR_LOGIN_ROOM_BROADCAST(pack)
     
	dump(pack ,"-----用户进入房间-----")

	if pack ~= nil then
		self:showPlayer(pack)

		local uid_arr = {}

		for k,v in pairs(ZZMJ_USERINFO_TABLE) do
			table.insert(uid_arr, v.uid)
		end

		require("hall.GameSetting"):setPlayerUid(uid_arr)
	end

end

--处理进入房间
function ZZMJReceiveHandle:SVR_GET_ROOM_OK(pack_data)

    dump(pack_data, "-----处理进入房间-----")

	--print("---------------------------SVR_GET_ROOM_OK----------------------------------")
	--dump(pack_data)
	--print("denglusuccess table id is ",pack_data['tid'],bm.isGroup,USER_INFO["activity_id"])

	--print("group test")
	-- if not bm.isGroup  then
    if require("hall.gameSettings"):getGameMode() ~= "group" then
		--todo
		local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_ROOM_GROUP)
        :setParameter("tableid", pack_data['tid'])
        :setParameter("nUserId", USER_INFO["uid"])
        :setParameter("strkey", "")
        :setParameter("strinfo", USER_INFO["user_info"])
        :setParameter("iflag", 2)
        :setParameter("version", 1)
        :setParameter("activity_id","")
        :build()
    	bm.server:send(pack)
    	--print("sending----------------1001............")
	else
		--print("group test ok")

		local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_ROOM_GROUP)
        :setParameter("tableid", pack_data['tid'])
        :setParameter("nUserId", USER_INFO["uid"])
        :setParameter("strkey", json.encode("kadlelala"))
        :setParameter("strinfo", USER_INFO["user_info"])
      	:setParameter("iflag", 2)
        :setParameter("version", 1)
        :setParameter("activity_id", USER_INFO["activity_id"])
        :build()
    	bm.server:send(pack)
    	--print("sending----------------1001............")
	end
end

--登录房间成功  1007
function ZZMJReceiveHandle:SVR_LOGIN_ROOM(pack)

    dump(pack, "-----登录房间成功-----")
    

	SCENENOW['scene']:removeChildByName("loading")
	if SCENENOW['name'] ~= run_scene_name then
		return
	end	
	--garret 隐藏墙头牌
	gamePlaneOperator:showQiangTou(false)


    isBuHuaIng = false
    
    PLAYERNUM = 4
	ZZMJ_GAME_STATUS = 0

	ZZMJ_USERINFO_TABLE = {}
	
	--dump(pack, "-----登录房间成功-----")

	ZZMJ_GROUP_ENDING_DATA = nil

	bm.User = {}
	ZZMJ_MY_USERINFO.seat_id = pack.seat_id
	ZZMJ_MY_USERINFO.coins      = pack.gold

	-- ZZMJ_ROOM = {}
	-- ZZMJ_ROOM.User      = {}	
 --    ZZMJ_ROOM.UserInfo  = {}
 --    ZZMJ_ROOM.seat_uid  = {}
	-- ZZMJ_ROOM.Card      = {}
	-- ZZMJ_ROOM.Gang      = {}
	ZZMJ_ROOM.base      = pack.base

	-- ZZMJ_ROOM.tuoguan_ing = 0
	--bm.display_scenes("majiang.scenes.MajiangroomScenes")

	-- SCENENOW["scene"]:removeSelf()
	-- SCENENOW["scene"] = nil;

	-- local sc = require("js_majiang_3d.gameScene"):new()
	-- SCENENOW["scene"] = sc
 --    --SCENENOW["scene"]:retain();
 --    SCENENOW["name"]  = "majiang.scenes.MajiangroomScenes";
	-- display.replaceScene(sc)

	-- local scenes = sc

    --显示白板替身
    isbaibantishen = pack.isbaibantishen
    if isbaibantishen == 1 then
        gamePlaneOperator:showBaiBanTip(true)
    else
        gamePlaneOperator:showBaiBanTip(false)
    end

	--绘制自己的信息
	ZZMJ_MY_USERINFO.photoUrl = USER_INFO["icon_url"]
	ZZMJ_MY_USERINFO.nick = USER_INFO["nick"]
	ZZMJ_MY_USERINFO.coins = pack["gold"]
	ZZMJ_MY_USERINFO.uid = USER_INFO["uid"]
	ZZMJ_MY_USERINFO.sex = USER_INFO["sex"]
	ZZMJ_SEAT_TABLE_BY_TYPE[CARD_PLAYERTYPE_MY .. ""] = pack.seat_id
	ZZMJ_SEAT_TABLE[USER_INFO["uid"] .. ""] = pack.seat_id
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""] = {}

	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].photoUrl = USER_INFO["icon_url"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].uid = USER_INFO["uid"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].nick = USER_INFO["nick"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].coins = pack["gold"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].sex = USER_INFO["sex"]


	--dump(ZZMJ_GAME_PLANE, "js_majiang_3d test")
	local infoPlane = gamePlaneOperator:showPlayerInfo(CARD_PLAYERTYPE_MY, ZZMJ_MY_USERINFO)
	local point = cc.p(infoPlane:getAnchorPoint().x * infoPlane:getSize().width, infoPlane:getAnchorPoint().y * infoPlane:getSize().height)

	ZZMJ_ROOM.positionTable[USER_INFO["uid"] .. ""] = infoPlane:convertToWorldSpace(point)
	local position = ZZMJ_ROOM.positionTable[USER_INFO["uid"] .. ""] 
    require("hall.view.voicePlayView.voicePlayView"):updateUserPosition(tonumber(USER_INFO["uid"]),position)
    

    --设置自己已准备
    gamePlaneOperator:setReadyStatus(CARD_PLAYERTYPE_MY)
	

	--绘制其他玩家
	if pack.user_mount > 0  then
		for i,v in pairs(pack.users_info) do
			--dump(pack, "player test")
			ZZMJReceiveHandle:showPlayer(v)
		end
	end

	SCENENOW["scene"]:ShowRecordButton()

	local uid_arr = {}

	for k,v in pairs(ZZMJ_USERINFO_TABLE) do
		table.insert(uid_arr, v.uid)
	end

	require("hall.GameSetting"):setPlayerUid(uid_arr)

	--绘制其他元素
	-- scenes:set_basescole_txt(ZZMJ_ROOM.base)

	-- if bm.isGroup  then --
 --    if require("hall.gameSettings"):getGameMode() == "group" then
	-- 	USER_INFO["base_chip"] = ZZMJ_ROOM.base;

	-- else
	-- 	SCENENOW["scene"]:gameReady();
	-- end

	voiceUtils:playBackgroundMusic()

	sendHandle:readyNow()

	SCENENOW["scene"]:ShowChatButton()

end

--登陆错误
function ZZMJReceiveHandle:SVR_ERROR(pack)
	
	dump(pack, "-----登陆错误-----")

	local errcode = "error"
	local showBtn = 2
	if pack["type"] == 9 then
		errcode = "change_money"
		showBtn = 1
	end
	require("hall.GameTips"):showTips(tbErrorCode[pack["type"]],errcode,showBtn)

end


---------------------------------------------------重连--------------------------------------------------------
--用户重登房间   1009
function ZZMJReceiveHandle:SVR_REGET_ROOM(pack)

	dump(pack, "-----重连房间成功-----")

	ZZMJ_GROUP_ENDING_DATA = nil

    --移除loading
	SCENENOW['scene']:removeChildByName("loading")
    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

	local scenes  = SCENENOW['scene']
	if SCENENOW['name'] ~= run_scene_name then
		return
	end	

    isBuHuaIng = false
    
    --获取设备信息
    self:getDeviceInfo()

    --设置当前游戏状态为进行中
	ZZMJ_GAME_STATUS = 1

    --记录玩家数量
	PLAYERNUM = pack.nPlayerCount+1

    --隐藏解散房间按钮
	scenes:hideCloseRoomButton()
    --显示设置按钮
	scenes:ShowSettingButton()
    --隐藏分享按钮
	scenes:hideShareButton()
    --显示录音按钮
	scenes:ShowRecordButton()
    --显示文字聊天按钮
	scenes:ShowChatButton()

    --清楚所有桌面游戏数据
	gamePlaneOperator:clearGameDatas()

    --显示中间指向区域
	gamePlaneOperator:showCenterPlane()

    --显示墙头牌
    gamePlaneOperator:showQiangTou(true, pack.qiangTouCard, pack.caiShenCards)

    --显示白板替身
    isbaibantishen = pack.isbaibantishen
    if isbaibantishen == 1 then
        gamePlaneOperator:showBaiBanTip(true)
    else
        gamePlaneOperator:showBaiBanTip(false)
    end

    --记录剩余牌数
	ZZMJ_REMAIN_CARDS_COUNT = pack.card_less

    --记录自己的位置
	ZZMJ_MY_USERINFO.seat_id = pack.seat_id

    --记录自己的筹码数
	ZZMJ_MY_USERINFO.coins      = pack.gold

    --获取听牌序列
    local tingSeq = pack.tingCards
    TINGSEQ = tingSeq

------------------------------------------------绘制杂项信息-----------------------------------------
	--记录自己的信息
    --头像
	ZZMJ_MY_USERINFO.photoUrl = USER_INFO["icon_url"]
    --名称
	ZZMJ_MY_USERINFO.nick = USER_INFO["nick"]
    --筹码
	ZZMJ_MY_USERINFO.coins = pack["gold"]
    --uid
	ZZMJ_MY_USERINFO.uid = USER_INFO["uid"]
    --性别
	ZZMJ_MY_USERINFO.sex = USER_INFO["sex"]

    --自己的位置
	ZZMJ_SEAT_TABLE_BY_TYPE[CARD_PLAYERTYPE_MY .. ""] = pack.seat_id
	ZZMJ_SEAT_TABLE[USER_INFO["uid"] .. ""] = pack.seat_id

	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""] = {}
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].photoUrl = USER_INFO["icon_url"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].uid = USER_INFO["uid"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].nick = USER_INFO["nick"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].coins = pack["gold"]
	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].sex = USER_INFO["sex"]

    --显示自己用户信息
	local infoPlane = gamePlaneOperator:showPlayerInfo(CARD_PLAYERTYPE_MY, ZZMJ_MY_USERINFO)

    --记录自己的位置的点坐标位置，用做效果显示
	local point = cc.p(infoPlane:getAnchorPoint().x * infoPlane:getSize().width, infoPlane:getAnchorPoint().y * infoPlane:getSize().height)
	ZZMJ_ROOM.positionTable[USER_INFO["uid"] .. ""] = infoPlane:convertToWorldSpace(point)

    --设置自己语音播放标志显示位置
    local position = ZZMJ_ROOM.positionTable[USER_INFO["uid"] .. ""] 
    require("hall.view.voicePlayView.voicePlayView"):updateUserPosition(tonumber(USER_INFO["uid"]),position)

	--绘制其他玩家
	if pack.nPlayerCount > 0  then
		for i,v in pairs(pack.users_info) do
			ZZMJReceiveHandle:showPlayer(v)
		end
	end

    --记录房间所有用户的用户id
	local uid_arr = {}
	for k,v in pairs(ZZMJ_USERINFO_TABLE) do
		table.insert(uid_arr, v.uid)
	end
	require("hall.GameSetting"):setPlayerUid(uid_arr)

    --播放背景音乐
	voiceUtils:playBackgroundMusic()

    --记录庄家UID（通过庄家位置转换得到）
	ZZMJ_ZHUANG_UID = ZZMJ_USERINFO_TABLE[pack.m_nBankSeatId .. ""].uid
    --显示庄家
	local zhuangPlayerType = cardUtils:getPlayerType(pack.m_nBankSeatId)
	gamePlaneOperator:showZhuang(zhuangPlayerType)

    --准备
    if require("hall.gameSettings"):getGameMode() == "group" then
		USER_INFO["base_chip"] = ZZMJ_ROOM.base
	else
		SCENENOW["scene"]:gameReady()
	end

-----------------------------------------绘制其他玩家手牌-----------------------------------------------
	
	if pack.nPlayerCount > 0  then

		for i,v in pairs(pack.users_info) do

            --定义用户的游戏信息实体
			local gameInfo = {}
            --定义自己的碰杠牌数组
			gameInfo.porg = {}
            --定义用户手牌数组
			gameInfo.hand = {}

            --记录用户手牌，因为不知实际值，根据手牌张数，全设置为0
			for i=1,pack.users_info[i].countHandCards do
				table.insert(gameInfo.hand, 0)
			end

            --定义用户出牌数组
			gameInfo.out = {}

            --记录用户花牌
            if pack.users_info[i].hCount > 0 then
                gameInfo.hua = pack.users_info[i].hCards
            else
                gameInfo.hua = {}
            end

            --通过SeatID保存用户信息
			ZZMJ_GAMEINFO_TABLE[pack.users_info[i].seat_id .. ""] = gameInfo

            --获取用户位置并绘制
			local playerType = cardUtils:getPlayerType(pack.users_info[i].seat_id)
			gamePlaneOperator:redrawGameInfo(playerType, pack.users_info[i])

		end

	end


------------------------------------------绘制自己的手牌和操作-----------------------------------------------

    --获取手牌并排序
	local myCards = pack.handCards
    table.sort(myCards)

    --定义自己的游戏信息实体
	local myGameInfo = {}
    --定义自己的碰杠牌数组
	myGameInfo.porg = {}
    --定义自己的手牌数组
	myGameInfo.hand = myCards
    --定义自己的出牌数组
	myGameInfo.out = {}

    --记录自己的花牌
    if pack.hCount > 0 then
        myGameInfo.hua = pack.hCards
    else
        myGameInfo.hua = {}
    end

    --通过自己的座位ID记录自己的游戏数据
	ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""] = myGameInfo

    --在听状态的话创建听牌数组 
	if pack.tingHuCount > 0 then
		ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].ting = 1
		ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].tingHuCards = pack.tingHuCards
	end

    -------------------------------------------新抓的牌移到右侧及绘制手牌----------------------------------

    dump(pack.handCount, "-----pack.handCount-----")

    if pack.handCount % 3 == 2 then     --手牌数量对3取余数为2

        --当前为可以出牌状态
        D3_CHUPAI = 1 

        local newCard

        if isbaibantishen == 1 then
            --白板替身的情况下

            --判断财神牌是不是白板
            local isbaibanCaishen = false
            for k,v in pairs(JS_CAISHEN) do
                if v == 67 then
                    isbaibanCaishen = true
                end
            end

            if isbaibanCaishen then
                --白板是财神，则白板可以作为刚摸的牌移出
                newCard = myCards[#myCards]

            else
                --假如白板不是财神，是替身，则拿手牌数组的第一张牌作为新抓牌
                newCard = myCards[1]

            end

        else
            --不是白板替身，则直接拿最后一张牌作为新拿的牌
            newCard = myCards[#myCards]

        end

        local isGrep = false
        
        --从手牌数组中移除最后一张牌
        for k,v in pairs(myCards) do
            if v == newCard then
                --todo
                table.remove(myCards, k)
                isGrep = true
                break
            end
        end


		dump(myCards,"myCards")
        -- 重绘自己的桌面信息
        gamePlaneOperator:redrawGameInfo(CARD_PLAYERTYPE_MY, pack)

        --把移除的牌作为新抓的牌添加到自己的区域
        if isGrep then

            -- cardUtils:getNewCard(ZZMJ_MY_USERINFO.seat_id, newCard, pack.tingCards)

            cardUtils:getNewCard(ZZMJ_MY_USERINFO.seat_id, newCard)
            gamePlaneOperator:getNewCard(CARD_PLAYERTYPE_MY, newCard, pack.tingCards)

        end
        
    else

        --当前不是自己出牌，显示自己的游戏信息
        gamePlaneOperator:redrawGameInfo(CARD_PLAYERTYPE_MY, pack)

    end

    --获取碰杠吃胡操作数组
	local controlTable = {}
	controlTable = cardUtils:getControlTable(pack.handle, pack.handleCard, 1)

    dump(controlTable, "-----重连controlTable-----")

	--显示碰杠吃胡操作界面
	print("6666666666666665")
	gamePlaneOperator:showControlPlane(controlTable)

-----------------------------------------------------------------------------------------------
	
    --重连后自己有操作的情况下，调整指针指向
    if pack.handle ~= 0 then

   		gamePlaneOperator:beginPlayCard(cardUtils:getPlayerType(pack.currentPlayerId-1))

    	-- local playerTypeT = cardUtils:getPlayerType(pack.currentPlayerId-1)
	    -- local removeResult = gamePlaneOperator:removeLatestOutCard(playerTypeT, pack.handleCard)
	    -- if removeResult then  --如果这张牌存在,就打出去
	    --     gamePlaneOperator:playCard(playerTypeT, 0, pack.handleCard)
	    -- end

        --当前为等待操作状态
	    D3_CHUPAI = 2

	else

		gamePlaneOperator:beginPlayCard(cardUtils:getPlayerType(pack.currentPlayerId))

	end

    --旋转计时器
    gamePlaneOperator:rotateTimer(zhuangPlayerType)

    --清楚所有准备标志
    gamePlaneOperator:clearAllReadyStatus() 

    D3_WAIT_OPRATE_CARD = 1

end
----------------------------------------------------------------------------------------------------------------


--显示其他玩家
function ZZMJReceiveHandle:showPlayer(pack)

	local scenes = SCENENOW['scene'] 
	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	--新加入用户的用户信息
	local v = pack

	--保存用户座位与id映射
	ZZMJ_SEAT_TABLE[v.uid .. ""] = pack.seat_id
	-- ZZMJ_USERINFO_TABLE[pack.seat_id] = pack 

	if not ZZMJ_USERINFO_TABLE[pack.seat_id .. ""] then
		--todo
		ZZMJ_USERINFO_TABLE[pack.seat_id .. ""] = {}
	end

	ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].uid = pack.uid
	
    local playerType = cardUtils:getPlayerType(pack.seat_id)
    ZZMJ_SEAT_TABLE_BY_TYPE[playerType .. ""] = pack.seat_id

    --设置用户已经准备
    if ZZMJ_GAME_STATUS == 0 and pack.if_ready==1 then
		gamePlaneOperator:setReadyStatus(playerType)
	end

    --dump(ZZMJ_SEAT_TABLE_BY_TYPE, "ZZMJ_SEAT_TABLE_BY_TYPE test")

    --获取用户信息
    local info = json.decode(pack.user_info)

    local nick_name 
    local user_gold
    local icon_url
    local sex_num
    if not info then
    	nick_name = pack.nick
    	user_gold = pack.user_gold 
    	icon_url = pack.icon_url
    	sex_num = pack.sex

    else
    	nick_name = pack.nick or info.nickName 
    	user_gold = pack.user_gold or info.money 
    	icon_url = pack.icon_url or pack.smallHeadPhoto or info.photoUrl 
    	sex_num = pack.sex or info.sex

    end

    --dump(info, "info test")
    --dump(sex_num, "sex_num test")

    ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].nick = nick_name
    ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].coins = user_gold
    ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].photoUrl = icon_url
    ZZMJ_USERINFO_TABLE[pack.seat_id .. ""].sex = sex_num

    local userInfo = {}
    userInfo["photoUrl"] = icon_url
    userInfo["nick"] = nick_name
    userInfo["coins"] = user_gold
    userInfo["uid"] = pack.uid
    userInfo["sex"] = sex_num

   	-- scenes:show_otherplayer_info(other_index,icon_url,nick_name,user_gold,sex_num,v.uid)

   	-- --dump(playerType, "playerType test 11")
   	local infoPlane = gamePlaneOperator:showPlayerInfo(playerType, userInfo)
   	local point = cc.p(infoPlane:getAnchorPoint().x * infoPlane:getSize().width, infoPlane:getAnchorPoint().y * infoPlane:getSize().height)

   	ZZMJ_ROOM.positionTable[pack.uid .. ""] = infoPlane:convertToWorldSpace(point)
    local position = ZZMJ_ROOM.positionTable[pack.uid .. ""] 
    require("hall.view.voicePlayView.voicePlayView"):updateUserPosition(tonumber(pack.uid),position)
end

--用户退出房间
function ZZMJReceiveHandle:SVR_QUIT_ROOM(pack)

	dump(pack,"-----用户退出房间-----")

	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	local uid = pack.uid
	local seatId = ZZMJ_SEAT_TABLE[uid .. ""]

	if not seatId then
		--todo
		return
	end

	table.remove(ZZMJ_SEAT_TABLE, uid .. "")
	table.remove(ZZMJ_USERINFO_TABLE, seatId .. "")
	table.remove(ZZMJ_GAMEINFO_TABLE, seatId .. "")

	local playerType = cardUtils:getPlayerType(seatId)
	table.remove(ZZMJ_SEAT_TABLE_BY_TYPE, playerType .. "")

	if ZZMJ_GAME_STATUS == 0 then
		--todo
		gamePlaneOperator:removePlayer(playerType)
	else
		gamePlaneOperator:showNetworkImg(playerType, true)
	end
	

	local uid_arr = {}

	for k,v in pairs(ZZMJ_USERINFO_TABLE) do
		table.insert(uid_arr, v.uid)
	end

	require("hall.GameSetting"):setPlayerUid(uid_arr)
end

--用户退出游戏成功
function ZZMJReceiveHandle:SVR_QUICK_SUC(pack)

	dump(pack,"-----玩家退出游戏成功-----")

	audio.stopMusic(true)

end

--用户准备相关
--广播用户准备
function ZZMJReceiveHandle:SVR_USER_READY_BROADCAST(pack)

    dump(pack, "-----广播用户准备-----")
    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

    local seatId = ZZMJ_SEAT_TABLE[pack.uid .. ""]
	local playerType = cardUtils:getPlayerType(seatId)
   
    gamePlaneOperator:setReadyStatus(playerType)

end
------------------------------------------------------------------------------------------------------

--用户操作相关
--服务器告知客户端可以进行的操作   3005
function ZZMJReceiveHandle:SVR_NORMAL_OPERATE(pack)

	dump(pack, "-----服务器告知客户端可以进行的操作-----")
	-- print("服务器告知客户端可以进行的操作controlTable" .. controlTable)
	local controlTable = cardUtils:getControlTable(pack.handle, pack.card, 1)
	gamePlaneOperator:showControlPlane(controlTable)

end

--广播用户进行了什么操作   4005
function ZZMJReceiveHandle:SVR_PLAYER_USER_BROADCAST(pack)
	
	dump(pack,"-----广播用户进行了什么操作-----")

	local scenes = SCENENOW['scene']
	if SCENENOW["name"] ~= run_scene_name then
		return
	end

    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

    --获取广播用户进行的操作
	local handle = pack.handle

    --获取触发操作的牌值
	local value = bit.band(pack.card, 0xFF)

    --获取触发操作的用户的位置
    local seatId = ZZMJ_SEAT_TABLE[pack.uid .. ""]
    local playerType = cardUtils:getPlayerType(seatId)

    --获取听牌序列
	local tingSeq = pack.tingCards
    TINGSEQ = tingSeq

    --显示听牌提示区域
    if pack.tingCount > 0 then
        for k,v in pairs(pack.tingCards) do
            if playerType == CARD_PLAYERTYPE_MY then
                gamePlaneOperator:showTingHuPlane(playerType, v.tingHuCards)--显示听牌提示牌
				--@garret 显示听牌按钮

				-- print("444444444222")
				-- local showTingBtnType = {}
				-- showTingBtnType["type"] = TING_TYPE_T  --操作类型
				-- showTingBtnType["value"] = v.card --听牌要丢弃的牌
				-- gamePlaneOperator:showControlPlane(showTingBtnType)
            end
        end
    end
          
    -- gamePlaneOperator:showCards(CARD_PLAYERTYPE_MY)
	local progCards, removeCards = cardUtils:processControl(seatId, handle, value)

    local reloginFlage = false

    --牌的来源玩家
    local fromplayerType = cardUtils:getPlayerType(pack.lid)

    --等待操作牌
    if D3_WAIT_OPRATE_CARD == 1 then

        --记录正在重连
        reloginFlage = true

        if fromplayerType ~= playerType then

            D3_WAIT_OPRATE_CARD = gamePlaneOperator:removeLatestOutCard(fromplayerType,value)
            dump(D3_WAIT_OPRATE_CARD,"D3_WAIT_OPRATE_CARD")

        else

            D3_WAIT_OPRATE_CARD = nil

        end

    end

    --5个参数
	gamePlaneOperator:control(playerType, progCards, handle, tingSeq, removeCards,fromplayerType,reloginFlage)

	--播放音效
	voiceUtils:playControlSound(seatId, handle)

	if playerType == CARD_PLAYERTYPE_MY then 
        D3_CHUPAI = 1

	else 
        gamePlaneOperator:hideControlPlane(playerType) --取消其他玩家的操作

	end

end
---------------------------------------------------------------------------------------------------------------

--托管相关
--广播用户托管
function ZZMJReceiveHandle:SVR_ROBOT(pack)

	dump(pack,"-----广播用户托管-----")

	local scenes = SCENENOW['scene']
	if SCENENOW["name"] ~= run_scene_name then
		return
	end

	if pack.uid == USER_INFO["uid"] then
		local scenes  = SCENENOW['scene']
		if  pack.kind  == 1 then
			ZZMJ_ROOM.tuoguan_ing = 1
			-- scenes:show_tuoguan_layout(true)
		else
			ZZMJ_ROOM.tuoguan_ing = 0
			-- scenes:show_tuoguan_layout(false)
		end
	end

end
-------------------------------------------------------------------------------------------------------------------

--发牌相关
--发牌协议    
function ZZMJReceiveHandle:SVR_SEND_USER_CARD(pack)

	dump(pack, "-----发牌协议-----")

    --获取场景
	local scenes  = SCENENOW['scene']
	if SCENENOW['name'] ~= run_scene_name then
		return
	end	

    isBuHuaIng = false
    
    --移除准备标志
    gamePlaneOperator:clearAllReadyStatus()

    --移除漂标志
	gamePlaneOperator:clearPiaoImg()

    --移除桌面游戏数据
	gamePlaneOperator:clearGameDatas()

    --设置当前游戏状态为进行中
	ZZMJ_GAME_STATUS = 1

    --隐藏解散房间按钮
	scenes:hideCloseRoomButton()
    --显示设置按钮
	scenes:ShowSettingButton()
    --隐藏分享按钮
	scenes:hideShareButton()

    --显示指向区域
	gamePlaneOperator:showCenterPlane()

	-- if table.getn(ZZMJ_SEAT_TABLE_BY_TYPE) < 4 then
	-- 	--todo
	-- 	return
	-- end

    --记录当前正在进行游戏
	bm.palying = true
	bm.isRun = true

	ZZMJ_ENDING_DATA = nil

	--记录庄家的座位
	bm.zuan_seat = pack.seat
    --获取庄家所在界面位置
	zhuangPlayerType = cardUtils:getPlayerType(bm.zuan_seat)
    --旋转计时器
	gamePlaneOperator:rotateTimer(zhuangPlayerType)
	
    --设置当前游戏开始
	-- if bm.isGroup then
    if require("hall.gameSettings"):getGameMode() == "group" then
        --todo
        ZZMJ_STATE = 2
    end
	--scenes:set_basescole_txt_visible(false)

	--隐藏解散房间按钮
	-- scenes:hidendisband()

	--隐藏用户准备标志
	-- scenes:hideAllSelect()

	--显示设置按钮
	-- scenes:ShowSettingButton()

	--开始游戏时需要移动其他玩家的信息显示位置

	--移动自己
	-- scenes:hide_self_info()

	--移动其他用户
	-- scenes:hide_otherplayer_info(1)--false表示隐藏
	-- scenes:hide_otherplayer_info(2)--false表示隐藏
	-- scenes:hide_otherplayer_info(3)--false表示隐藏

	--骰子动画
	-- aniUtils:shuaiZi(pack.shai)

    --显示墙头牌  --y
    gamePlaneOperator:showQiangTou(true, pack.qiangTouCard, pack.caiShenCards)

    --发牌
	self:SchedulerSendCard(pack)
	-- bm.SchedulerPool:delayCall(ZZMJReceiveHandle.SchedulerSendCard,2,pack)

end

--发牌
function ZZMJReceiveHandle:SchedulerSendCard(pack)

    dump(pack, "-----发牌-----")

    --初始化用户手牌数组
	ZZMJReceiveHandle:initCardForUser(pack)

    --显示用户手牌
	for i = 0, PLAYERNUM - 1 do
		ZZMJReceiveHandle:showPlayerCards(i)
	end

	--显示庄家
	-- ZZMJReceiveHandle:showZhuang(pack.seat)
	local playerType = cardUtils:getPlayerType(pack.seat)
	ZZMJ_ZHUANG_UID = ZZMJ_USERINFO_TABLE[pack.seat .. ""].uid
	gamePlaneOperator:showZhuang(playerType)

end

--初始化用户手牌数组
function ZZMJReceiveHandle:initCardForUser(pack)

    dump(pack, "-----牌库初始化-----")

    --初始化用户手牌
	for i=0, PLAYERNUM - 1 do
		local gameInfo = {}
		gameInfo.porg = {}
		gameInfo.hand = {0,0,0,0,0,0,0,0,0,0,0,0,0}
		gameInfo.out = {}
		gameInfo.ting = 0
        gameInfo.hua = {}
		-- ZZMJ_ROOM.Gang[i]         = {}

		ZZMJ_GAMEINFO_TABLE[i .. ""] = gameInfo
	end

    --获取自己手牌
	local myCards = pack.cards
    --对自己手牌进行排序
	table.sort(myCards)
    --记录自己的牌
	ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].hand = myCards	--0号玩家的手牌

	--dump(ZZMJ_GAMEINFO_TABLE, "cards test ")

end

--显示玩家的牌
function ZZMJReceiveHandle:showPlayerCards(seatId)

    dump(seatId, "-----牌库初始化-----")

	local playerType = cardUtils:getPlayerType(seatId)
	gamePlaneOperator:showCards(playerType)

end

--显示庄家
-- function ZZMJReceiveHandle:showZhuang(seat)

-- 	local uid = USER_INFO["uid"]

-- 	if seat ~= bm.User.Seat then
-- 		uid = ZZMJ_ROOM.seat_uid[seat]
-- 	end

-- 	local index = self:getIndex(uid)
-- 	local scenes = SCENENOW['scene']
-- 	if SCENENOW['name'] ~= run_scene_name then
-- 		return
-- 	end
	
-- 	scenes:show_widget_tip(index,true,"zuan_tip")
-- end
----------------------------------------------------------------------------------------------------------------

--换牌相关
--服务器告诉客户端，可以换牌
function ZZMJReceiveHandle:SERVER_COMMAND_NEED_CHANGE_CARD(pack)

	dump(pack, "-----可以换牌-----")

	local scenes = SCENENOW['scene'] 

	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	ZZMJ_ROOM.change_card_over = false
	--dump(pack, "SERVER_COMMAND_NEED_CHANGE_CARD")
	ZZMJ_ROOM.cardHuan={};
	bm.huanCardsStart = true

	scenes:show_Text_18(true)

	local txtTimer = display.newBMFontLabel({
	    text = 10,
	    font = "majiang/image/num2.fnt",
	})
	scenes._scene:getChildByName("layer_card"):addChild(txtTimer, 100000)
	txtTimer:setPositionX(487)
	txtTimer:setPositionY(185)

	--换牌倒计时
	local timer = 10 
	local ac = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
			timer=timer-1
			txtTimer:setString(timer)
			if timer==0 then

				txtTimer:stopAllActions();
				txtTimer:removeFromParent();

				scenes:show_Text_18(false)

			end
		end)))
	txtTimer:runAction(ac)

end

--服务器广播换牌的结果
function ZZMJReceiveHandle:SERVER_COMMAND_CHANGE_CARD_RESULT(pack)

	dump(pack, "-----服务器广播换牌的结果-----")

	local scenes  = SCENENOW['scene']

	if SCENENOW['name'] ~= run_scene_name then
		return
	end
	
	scenes:show_Text_18(false)

	ZZMJ_ROOM.change_card_over = true
	--ZZMJ_ROOM.cardHuan = ZZMJ_ROOM.cardHuan or {} -- 可能存在没有换的状况

	local old_hand_card = ZZMJ_ROOM.Card[0]['hand']
	--dump(old_hand_card,"old_hand_card") 
	if pack.mount > 0 then
		--0号玩家的手牌
		ZZMJ_ROOM.Card[0]['hand'] = pack.cards	
		self:drawHandCard(0)
	end

	--dump(ZZMJ_ROOM.Card[0]['hand'],"-----当前用户换牌后的新手牌-----") 

	ZZMJ_ROOM.Card[0]['hand'] = MajiangcardHandle:sortCards(ZZMJ_ROOM.Card[0]['hand'])

	local gang_num  = 0
	local scenes = SCENENOW['scene']
	local card_node = scenes._scene:getChildByName("layer_card"):getChildByName("owncard")
	if card_node  then card_node:removeSelf() end
	card_node = display.newNode()
	card_node:addTo(scenes._scene:getChildByName("layer_card"))
	card_node:setName("owncard")
	card_node:setLocalZOrder(50)

	local s_point  = 119.00
	local y_ponit  = 44.00

	local start = 119.00
	local pi    = 1

	local time_index  = 1
	for i,v in pairs(ZZMJ_ROOM.Card[0]['hand']) do 

		local tmp = Majiangcard.new()
		tmp:setCard(v)
		tmp:setMyHandCard()
		-- tmp:setScale(0.8,0.8383)
		-- tmp:dark()
		local find_index = table.indexof(old_hand_card,v)
		if find_index == false then
			-- tmp:pos(start+(pi-1)*(74*0.8 - 6),y_ponit + 40)
			tmp:pos(start + (pi-1) * 54, y_ponit + 40)
			tmp:moveBy(1, 0, -40)
		else
			table.remove(old_hand_card,find_index)
			-- tmp:pos(start+(pi-1)*(74*0.8 - 6),y_ponit)
			tmp:pos(start+(pi-1) * 54, y_ponit)
		end

		tmp:setName(i)
		tmp:addTo(card_node)
		--huase[tmp.cardVariety_] = huase[tmp.cardVariety_] + 1
		pi = pi + 1

	end

	SCENENOW['scene']._scene:getChildByName("Button_11"):hide()
	SCENENOW['scene']._scene:getChildByName("Button_11_0"):hide()

	bm.huanCardsStart = false

end
----------------------------------------------------------------------------------------------------------------------------------

--选缺相关
--开始选择缺门
function  ZZMJReceiveHandle:SVR_START_QUE_CHOICE(pack)

	dump(pack,"-----开始选择缺门-----")

	local scenes  = SCENENOW['scene']


	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	scenes:show_other_xuanqueing(true)
	scenes:show_choosing_que(true)	

end

--广播缺一门  通知用户选缺选了哪一门,这时游戏还没有开始，
function ZZMJReceiveHandle:SVR_BROADCAST_QUE(pack)

	dump(pack,"-----广播缺一门-----")

	bm.User.Que = nil
	ZZMJ_ROOM.Que = true

	for i,v in pairs(pack.content) do
		self:hasChoiceQue(v.uid,v.que)
	end

end

--设置已经选缺
function ZZMJReceiveHandle:hasChoiceQue(uid,que)

	dump(uid,"-----设置已经选缺-----")

	local scenes  = SCENENOW['scene']
	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	if uid == USER_INFO["uid"] then
		--print("uid------------------que",que)
		bm.User.Que = que
	end

	local index  = self:getIndex(uid)
	local str = CARD_PATH_MANAGER:get_que_tip(que)
	scenes:show_widget_tip(index,true,"que_tip",str,cc.rect(0,0,36,36),1.0)
	
	scenes:show_other_xuanqueing_index(index,false)

	--que是0，1,2万筒条

	scenes:show_hasselect(index,true)
	if scenes:check_all_select() == true then
		scenes:showwaitingotherchoose(false)

		scenes:show_hasselect(0,false)  --隐藏所有的已选“筒”，“条”
		scenes:show_hasselect(1,false)
		scenes:show_hasselect(2,false)
		scenes:show_hasselect(3,false)
	end

	scenes:hideAllSelect()

end
----------------------------------------------------------------------------------------------------------------

--抓牌相关
--广播抓牌用户   4006
function ZZMJReceiveHandle:SVR_PLAYING_UID_BROADCAST(pack)
	
	dump(pack, "-----广播抓牌用户-----")

	local scenes  = SCENENOW['scene']
	if SCENENOW['name'] ~= run_scene_name then
		return
	end
    
    -- gamePlaneOperator:putCard()

	local playerType = cardUtils:getPlayerType(ZZMJ_SEAT_TABLE[pack.uid .. ""])
	local seatId = ZZMJ_SEAT_TABLE[pack.uid .. ""]

	if playerType ~= CARD_PLAYERTYPE_MY then
		cardUtils:getNewCard(seatId, 0)
		gamePlaneOperator:getNewCard(playerType, 0)
	end

	ZZMJ_REMAIN_CARDS_COUNT = pack.simplNum
	gamePlaneOperator:showRemainCardsCount()

end

--通知我抓的牌   3002
function ZZMJReceiveHandle:SVR_OWN_CATCH_BROADCAST(pack)

	dump(pack,"-----通知我抓的牌-----")
	
    if isBuHuaIng then  --是否补花牌中

        bm.SchedulerPool:delayCall(function ()
             
            local scenes = SCENENOW['scene']

            if SCENENOW['name'] ~= run_scene_name then
                return
            end
           
            -- gamePlaneOperator:putCard()

            --显示剩余牌数
            ZZMJ_REMAIN_CARDS_COUNT = ZZMJ_REMAIN_CARDS_COUNT - 1
            gamePlaneOperator:showRemainCardsCount()

            --刷新手牌以显示听牌队列
            local tingSeq = pack.tingCards
            TINGSEQ = tingSeq

			dump(pack,"TINGSEQ刷新手牌以显示听牌队列111")
			dump(JS_TING_REMOVE,"3009数据")
			dump(TINGSEQ,"3002数据")

            local value = bit.band(pack.card, 0xFF)

            -- gamePlaneOperator:showCards(CARD_PLAYERTYPE_MY)--刷新手牌

            cardUtils:getNewCard(ZZMJ_MY_USERINFO.seat_id, value)

            gamePlaneOperator:getNewCard(CARD_PLAYERTYPE_MY,value,tingSeq)

            local controlTable = cardUtils:getControlTable(pack.handle, pack.card, 2, pack.cards)
			dump(controlTable.type,"controlTable.type-----抓后续操作1")

			

			local dd = {
				CONTROL_TYPE_HU,
				CONTROL_TYPE_PENG,
				CONTROL_TYPE_GANG,
				CONTROL_TYPE_CHI,
				CONTROL_TYPE_TING,
				CONTROL_TYPE_CAIPIAO
			}
			dump(dd,"相应的操作类型")

            if pack.tingCount > 0 then
             -- --todo
             controlTable.type = bit.bor(controlTable.type, CONTROL_TYPE_TING)
			dump(controlTable.type,"controlTable.type-----抓后续操作1")
             controlTable.tingSeq = pack.tingCards
             controlTable.gangSeq = pack.lgCards
            end

            if controlTable.type == CONTROL_TYPE_NONE or controlTable.type == CONTROL_TYPE_TING then
                D3_CHUPAI = 1
            else
                D3_CHUPAI = 2
            end

            gamePlaneOperator:showControlPlane(controlTable)

            isBuHuaIng = false

        end, 2)
    
    else

        local scenes = SCENENOW['scene']

        if SCENENOW['name'] ~= run_scene_name then
            return
        end
       
        -- gamePlaneOperator:putCard()

        --显示剩余牌数
        ZZMJ_REMAIN_CARDS_COUNT = ZZMJ_REMAIN_CARDS_COUNT - 1
        gamePlaneOperator:showRemainCardsCount()
		dump(pack,"TINGSEQ刷新手牌以显示听牌队列2221")
		dump(JS_TING_REMOVE,"3009数据")
		dump(TINGSEQ,"3002数据")
        --刷新手牌以显示听牌队列
        local tingSeq = pack.tingCards
        TINGSEQ = tingSeq  --全局的听牌数据
        local value = bit.band(pack.card, 0xFF)

        gamePlaneOperator:showCards(CARD_PLAYERTYPE_MY)

        cardUtils:getNewCard(ZZMJ_MY_USERINFO.seat_id, value)

        gamePlaneOperator:getNewCard(CARD_PLAYERTYPE_MY,value,tingSeq)

        local controlTable = cardUtils:getControlTable(pack.handle, pack.card, 2, pack.cards)


		--显示亮杠数据
        if pack.tingCount > 0 then  
         -- --todo
         controlTable.type = bit.bor(controlTable.type, CONTROL_TYPE_TING)
         controlTable.tingSeq = pack.tingCards
         controlTable.gangSeq = pack.lgCards
        end

		
        if controlTable.type == CONTROL_TYPE_NONE or controlTable.type == CONTROL_TYPE_TING then
            D3_CHUPAI = 1  -- 0 不能出牌 2 必须等待操作 1 可以出牌
        else
            D3_CHUPAI = 2
        end

        gamePlaneOperator:showControlPlane(controlTable)

    end

end

---------------------------------------------------------------------------------------------------------------
--广播用户出牌
function ZZMJReceiveHandle:SVR_SEND_MAJIANG_BROADCAST(pack)
	
	dump(pack, "-----广播用户出牌-----")

    --获取场景
	local scenes = SCENENOW['scene']
	if SCENENOW['name'] ~= run_scene_name then
		return
	end

    --去掉loading
    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

    --获取电量wifi信息
    self:getDeviceInfo()
  
	local value = bit.band(pack.card, 0xFF)

    --获取该牌可触发的操作
	local handleResult = cardUtils:getControlTable(pack.handle, value, 1)

	if pack.uid ~= USER_INFO["uid"] then
        --假如不是自己出牌，则显示该牌触发的操作界面
		gamePlaneOperator:showControlPlane(handleResult)
	else
        --假如是自己出牌，把自己出牌状态重置
		D3_CHUPAI = 0
	end

    --获取出牌用户位置
	local seatId = ZZMJ_SEAT_TABLE[pack.uid .. ""]
	local playerType = cardUtils:getPlayerType(seatId)
    gamePlaneOperator:showNetworkImg(playerType, false)

	local tag = cardUtils:playCard(seatId, value)
	gamePlaneOperator:playCard(playerType, tag, value)

    --显示财飘动画
    local isCaishen = false
    for k1,v1 in pairs(JS_CAISHEN) do
        
        if pack.card == v1 then
            isCaishen = true
        end

    end

    if isCaishen then
        
        if playerType == CARD_PLAYERTYPE_MY then
            --自己财飘
            gamePlaneOperator:showCaiPiao(CARD_PLAYERTYPE_MY)

        else
            --他人财飘
            gamePlaneOperator:showCaiPiao(playerType)

        end

        voiceUtils:playControlSound(seatId, CAIPIAO_TYPE_B)

    else

        voiceUtils:playCardSound(seatId, pack.card)

    end

end
---------------------------------------------------------------------------------------------------------------
--游戏广播相关
--广播结束游戏 没用
function ZZMJReceiveHandle:SVR_GAME_OVER(pack)

	dump(pack, "-----广播结束游戏 没用-----")

	-- require("hall.recordUtils.RecordUtils"):closeRecordFrame()
	-- ZZMJ_GAME_STATUS = 0

	-- if ZZMJ_ENDING_DATA then
	-- 	--todo
	-- 	if ZZMJ_ROUND == ZZMJ_TOTAL_ROUNDS then
	-- 		--todo
	-- 		require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, true)
	-- 	else
	-- 		require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, false)
	-- 	end
	-- end	

	-- local callAc = cc.CallFunc:create(function()
	-- 		--todo
	-- 		if ZZMJ_ENDING_DATA then
	-- 			--todo
	-- 			if ZZMJ_ROUND == ZZMJ_TOTAL_ROUNDS then
	-- 				--todo
	-- 				require("js_majiang_3d.RoundEndingLayer"):show(ZZMJ_ENDING_DATA, true)
	-- 			else
	-- 				require("js_majiang_3d.RoundEndingLayer"):show(ZZMJ_ENDING_DATA, false)
	-- 			end
	-- 		end	

	-- 		gamePlaneOperator:clearGameDatas()
	-- 	end)
	-- local seqAc = cc.Sequence:create(cc.DelayTime:create(3), callAc)
	
	-- SCENENOW["scene"]:runAction(seqAc)

end

---------------------------------------------------------------------------------------------------------------

--胡牌
--胡牌协议 4013
function ZZMJReceiveHandle:SVR_HUPAI_BROADCAST(pack)

	dump(pack,"-----胡牌协议-----")

	require("hall.recordUtils.RecordUtils"):closeRecordFrame()
	ZZMJ_GAME_STATUS = 0

    for i,v in pairs(pack.hucontent) do 

    local seatId = ZZMJ_SEAT_TABLE[pack.hucontent[i].uid .. ""]
    local playerType = cardUtils:getPlayerType(seatId)
          gamePlaneOperator:showCardsForHu(playerType, pack.hucontent[i].remainCards,pack.hucontent[i].card)
	end
    liujuFlag = false


	-- if ZZMJ_ENDING_DATA then
	-- 	--todo
	-- 	if ZZMJ_ROUND == ZZMJ_TOTAL_ROUNDS then
	-- 		--todo
	-- 		require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, true)
	-- 	else
	-- 		require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, false)
	-- 	end
	-- end	

	-- local scenes  = SCENENOW['scene']
	-- local paoid = nil 
	-- for i ,v in pairs(pack.content) do
	-- 	local  index  = self:getIndex(v.uid)
		
	-- 	local hu_type = v.htype
	-- 	if v.htype == 1 then --平胡
	-- 	  --print("--------------v.pao_content---------------")
	-- 	  paoid   = v.pao_content[1].paoid
	-- 	end

	-- 	self:show_zimo_tip(index,hu_type)
	-- 	self:drawPlayerHupaiCard(v.uid,v.card,v.htype)


	-- 	--播放自摸声音
	-- 	if index == 0 then
	-- 		local sound_path = sound_path_manager:GET_GANG_PENG_SOUND(USER_INFO["sex"],1)
	-- 		--require("hall.GameCommon"):playEffectSound(sound_path,false)
	-- 		cc.SimpleAudioEngine:getInstance():playEffect(sound_path,false)

	-- 		scenes:setGameState(5)
	-- 		-- if require("hall.gameSettings"):getGameMode() == "match" then
	-- 		-- 	require("majiang.MatchSetting"):showMatchWait(true,"majiang")
	-- 		-- end
	-- 	else
	-- 		local otherinfo = ZZMJ_ROOM.UserInfo[v.uid]
	-- 		if otherinfo ~= nil then
	-- 			local sound_path = sound_path_manager:GET_GANG_PENG_SOUND(otherinfo.sex,1)
	-- 			--require("hall.GameCommon"):playEffectSound(sound_path,false)
	-- 			cc.SimpleAudioEngine:getInstance():playEffect(sound_path,false)
	-- 		end
	-- 	end
	-- end

	-- ----print(paodi,"paoid")

	-- --显示放炮玩家
	-- if paoid ~= nil then
	-- 	local config = {
	-- 		[0] = {['x'] = 480,['y'] = 200},
	-- 		[1] = {['x'] = 220,['y'] = 306},
	-- 		[2] = {['x'] = 480,['y'] = 410},
	-- 		[3] = {['x'] = 710,['y'] = 306}	
	-- 		-- [0] = {['x'] = 480,['y'] = 300},
	-- 		-- [1] = {['x'] = 480,['y'] = 300},
	-- 		-- [2] = {['x'] = 480,['y'] = 300},
	-- 		-- [3] = {['x'] = 480,['y'] = 300}	
	-- 	}

	-- 	local index   = self:getIndex(paoid)
	-- 	local fangpao = CARD_PATH_MANAGER:get_card_path("fangpao")
	-- 	local object  = display.newSprite(fangpao)
	-- 	object:addTo(scenes)
	-- 	object:setLocalZOrder(2001)
	-- 	object:pos(config[index]['x'],config[index]['y'])
	-- 	bm.SchedulerPool:delayCall(function ()
	-- 		if tolua.isnull(object) == false then
	-- 			object:removeSelf()
	-- 		end
	-- 	end,3)
	-- end

	-- ZZMJ_ROOM.last = "otherhand"
	-- self:showLastEvent()

end

--显示自摸
function ZZMJReceiveHandle:show_zimo_tip(index,hu_type)

	dump(index,"-----显示自摸-----")
	dump(hu_type,"-----显示自摸-----")

	local config = {
		[0] = {['x'] = 480,['y'] = 185},
		[1] = {['x'] = 320,['y'] = 306},
		[2] = {['x'] = 480,['y'] = 380},
		[3] = {['x'] = 610,['y'] = 306}	
		}

	local scenes  = SCENENOW['scene']

	if SCENENOW["name"]~= run_scene_name then
		return
	end
	
	local object    = scenes:getChildByName("hashu"..index)
	if object then
		object:removeSelf()
	end

	local pos_x,pos_y = scenes:gettimerpos()
	if hu_type == 1 then
		local path_hu = CARD_PATH_MANAGER:get_card_path("path_hu")
	 	local object  = display.newSprite(path_hu)
		object:addTo(scenes)
		object:pos(config[index]['x'],config[index]['y'])

		 if index == 0 then
		 	show_zimo_effect(scenes,pos_x,pos_y,hu_type)
		 end
	end

	if hu_type == 2 then
		 local path_zimo = CARD_PATH_MANAGER:get_card_path("path_zimo")
		 local object  = display.newSprite(path_zimo)
		 object:addTo(scenes)
		 object:pos(config[index]['x'],config[index]['y'])

		 if index == 0 then
		 	show_zimo_effect(scenes,pos_x,pos_y,hu_type)
		 end
	end

end

------------------------------------------------------------------------------------------------------------------
--红中游戏结束时协议顺序   胡了4013---4008    (最后一局)4008---5100     (解散组局) 5100
--结算相关
--结算协议  4008
function ZZMJReceiveHandle:SVR_ENDDING_BROADCAST(pack)

	dump(pack,"----一盘结束，进行结算-----")

    --隐藏墙头牌显示
    gamePlaneOperator:showQiangTou(false)
    
    --一盘结算数据
	ZZMJ_ENDING_DATA = pack
    
    --流局与否判断
	ZZMJ_ENDING_DATA['type'] = 0
	if liujuFlag == false then ZZMJ_ENDING_DATA['type'] = 1 end   --liujuFlag == true  为流局
    
 --    --延迟显示结算页
 --    SCENENOW["scene"]:performWithDelay(function()

 --        if ZZMJ_ENDING_DATA then

 --            --判断当前是否已经为最后一轮
 --    		if ZZMJ_ROUND == ZZMJ_TOTAL_ROUNDS then
 --    			require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, true)

 --    		else
 --    			require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, false)

 --    		end

 --    	end

 --        require("js_majiang_3d.RoundEndingLayer"):setIsShow(true)

	-- end, 2)

    if ZZMJ_ENDING_DATA then

        --判断当前是否已经为最后一轮
        if ZZMJ_ROUND == ZZMJ_TOTAL_ROUNDS then
            require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, true)

        else
            require("js_majiang_3d.RoundEndingLayer"):showZhuaniao(ZZMJ_ENDING_DATA, false)

        end

    end

    require("js_majiang_3d.RoundEndingLayer"):setIsShow(true)

    -- --更新用户筹码
    -- SCENENOW["scene"]:performWithDelay(function()

    --     for i,v in ipairs(pack.players) do

    --         --根据uid或者seatid
    --         local seatid = ZZMJ_SEAT_TABLE[v.uid .. ""]
    --         --根据seatid获取用户信息
    --         local userInfo = ZZMJ_USERINFO_TABLE[seatid .. ""]
    --         --获取用户当前筹码
    --         userInfo.coins = pack.players[i].coins

    --         --获取用户位置
    --         local playerType = cardUtils:getPlayerType(seatid)
    --         --更新用户筹码
    --         gamePlaneOperator:showPlayerInfo(playerType, userInfo)

    --     end
        
    -- end, 4)

    for i,v in ipairs(pack.players) do

        --根据uid或者seatid
        local seatid = ZZMJ_SEAT_TABLE[v.uid .. ""]
        --根据seatid获取用户信息
        local userInfo = ZZMJ_USERINFO_TABLE[seatid .. ""]
        --获取用户当前筹码
        userInfo.coins = pack.players[i].coins

        --获取用户位置
        local playerType = cardUtils:getPlayerType(seatid)
        --更新用户筹码
        gamePlaneOperator:showPlayerInfo(playerType, userInfo)

    end

end

-------------------------------------------------------------------------------------------------------------------

--组局相关
--请求获取筹码返回
function ZZMJReceiveHandle:SVR_GET_CHIP(pack)

    dump(pack, "-----请求获取筹码返回-----")

	-- if bm.isGroup then
    if require("hall.gameSettings"):getGameMode() == "group" then
		--todo
		require("majiang.gameScene"):onNetGetChip(pack)
	end

end

--请求兑换筹码返回
function ZZMJReceiveHandle:SVR_CHANGE_CHIP(pack)
	
	dump(pack, "-----请求兑换筹码返回------")
	-- if bm.isGroup  then
    if require("hall.gameSettings"):getGameMode() == "group" then
			
		require("majiang.gameScene"):onChipSuccess(pack)
	end

end

--组局时长
function ZZMJReceiveHandle:SVR_GROUP_TIME(pack)

	dump(pack, "-----组局时长-----")

	--  加入当前游戏模式是组局 if bm.isGroup then
    if require("hall.gameSettings"):getGameMode() == "group" then

    	--记录当前局数
		ZZMJ_ROUND = pack.round + 1

		--记录总局数
		ZZMJ_TOTAL_ROUNDS = pack.round_total

    end

end

--组局排行榜（一局结算之后返回的数据）    正常情况下解散才走这边  0x5100
function ZZMJReceiveHandle:SVR_GROUP_BILLBOARD(pack)

    dump(pack, "-----组局排行榜-----")

    if pack then
        
        local disaband_flag = false
        if  ZZMJ_ROUND <=1  then
             disaband_flag =true
        end 

    	ZZMJ_GROUP_ENDING_DATA = pack

        -- if bm.isGroup then
    	if require("hall.gameSettings"):getGameMode() == "group" then

    		local isShow = require("js_majiang_3d.RoundEndingLayer"):isShow()
    		if not isShow then
    			if ZZMJ_ROUND ~= ZZMJ_TOTAL_ROUNDS then  --最后一局的话只执行4008
    			require("js_majiang_3d.GroupEndingLayer"):showGroupResult(ZZMJ_GROUP_ENDING_DATA,disaband_flag)
    			end
    		end

            -- require("majiang.gameScene"):onNetBillboard(pack)
        end
    end

end

--组局历史记录
function ZZMJReceiveHandle:SVR_GET_HISTORY(pack)

	dump(pack, "-----组局历史记录-----")

    if pack then
        -- if bm.isGroup then
    	if require("hall.gameSettings"):getGameMode() == "group" then
            require("majiang.gameScene"):onNetHistory(pack)
        end
    end

end
-----------------------------------------------------------------------------------------------------------------------------

--组局解散相关
--没有此房间，解散房间失败
function ZZMJReceiveHandle:G2H_CMD_DISSOLVE_FAILED(pack)

	dump("", "没有此房间，解散房间失败")

	require("hall.GameTips"):showTips("解散房间失败","disbandGroup_fail",2)

end

--广播桌子用户请求解散组局
function ZZMJReceiveHandle:SERVER_BROADCAST_REQUEST_DISSOLVE_GROUP(pack)

	-- dump("", "广播桌子用户请求解散组局")

	-- require("hall.GameTips"):showTips("确认解散房间","cs_request_disbandGroup",1)
end

--广播桌子用户成功解散组局
function ZZMJReceiveHandle:SERVER_BROADCAST_DISSOLVE_GROUP(pack)

	dump("", "广播桌子用户成功解散组局")

	-- require("hall.GameTips"):showTips("解散房间成功","cs_disbandGroup_success",3)

	-- ZZMJ_ROUND = ZZMJ_TOTAL_ROUNDS

	if SCENENOW["scene"]:getChildByName("layer_tips") then
        SCENENOW["scene"]:removeChildByName("layer_tips")
    end

    if require("js_majiang_3d.RoundEndingLayer"):isShow() then
    	--todo
    	require("js_majiang_3d.RoundEndingLayer"):hide()
    	if ZZMJ_ENDING_DATA then
    		--todo
    		require("js_majiang_3d.RoundEndingLayer"):show(ZZMJ_ENDING_DATA, true)
    	end
    	
    end

end

--广播桌子用户解散组局 ，解散组局失败
function ZZMJReceiveHandle:SERVER_BROADCAST_FORBIT_DISSOLVE_GROUP(pack)

	dump("", "广播桌子用户解散组局 ，解散组局失败")

	require("hall.GameTips"):showTips("解散房间失败", "disbandGroup_fail", 2, "用户拒绝解散房间")

end

--广播当前组局解散情况
-- function ZZMJReceiveHandle:G2H_CMD_REFRESH_DISSOLVE_LIST(pack)

-- 	--dump(pack, "-----广播当前组局解散情况-----")
-- 	--dump(bm.Room, "-----广播当前房间情况-----")

-- 	local applyId = pack.applyId
-- 	local agreeNum = pack.agreeNum
-- 	local agreeMember_arr = pack.agreeMember_arr

-- 	local disband_table = {}

-- 	--申请解散者信息
-- 	local applyer_info = {}
-- 	if applyId == USER_INFO["uid"] then
--         local player_table = {}
--         player_table["playerName"] = "我"
--         player_table["state"] = "申请"
--         table.insert(disband_table, player_table)
-- 		-- showMsg = "您申请解散房间，请等待其他玩家同意（超过5分钟未做选择，则默认同意）" .. "\n"
-- 	else
--         local player_table = {}
-- 		local seatId = ZZMJ_SEAT_TABLE[applyId .. ""]
-- 		if seatId then
-- 			--todo
-- 			local userInfo = ZZMJ_USERINFO_TABLE[seatId .. ""]

-- 			if userInfo then
-- 				--todo
-- 				local nickName = userInfo.nick

--                 player_table["playerName"] = nickName
--                 player_table["state"] = "申请"
--                 table.insert(disband_table, player_table)

-- 				-- showMsg = "玩家【" .. nickName .. "】申请解散房间，请等待其他玩家同意（超过5分钟未做选择，则默认同意）" .. "\n"
-- 			end

-- 		end
		
-- 	end
	
-- 	local isMyAgree = 0
-- 	if applyId ~= USER_INFO["uid"] then
-- 		--假如申请者不是自己，添加自己的选择情况
-- 		if agreeNum > 0 then
-- 			for k,v in pairs(agreeMember_arr) do
-- 				if v == USER_INFO["uid"] then
-- 					isMyAgree = 1
-- 					break
-- 				end
-- 			end
-- 		end

--         local player_table = {}
--         player_table["playerName"] = "我"

--         if isMyAgree == 1 then
--             player_table["state"] = "同意"
--         else
--             player_table["state"] = "等待选择"
--         end

--         player_table["icon"] = USER_INFO["icon_url"]

--         table.insert(disband_table, player_table)

-- 		-- if isMyAgree == 1 then
-- 		-- 	showMsg = showMsg .. "  【我】已同意" .. "\n"
-- 		-- else
-- 		-- 	showMsg = showMsg .. "  【我】等待选择" .. "\n"
-- 		-- end

-- 	end

-- 	--显示其他人情况
-- 		if ZZMJ_USERINFO_TABLE then
-- 			for k,v in pairs(ZZMJ_USERINFO_TABLE) do
-- 				local uid = v.uid
-- 				--排除掉申请者，申请者不需要显示到这里
-- 				if uid ~= applyId and uid ~= USER_INFO["uid"] then

-- 					--记录当前用户是否已经同意
-- 					local isAgree = 0
-- 					if agreeNum > 0 then
-- 						for k,v in pairs(agreeMember_arr) do
-- 							if uid == v then
-- 								--当前用户已经同意
-- 								isAgree = 1
-- 								break
-- 							end
-- 						end
-- 					end

--                     local player_table = {}

-- 					local nickName = v.nick
-- 					if nickName ~= nil then

--                         player_table["playerName"] = nickName

--                         if isAgree == 1 then
--                             player_table["state"] = "同意"
--                         else
--                             player_table["state"] = "等待选择"
--                         end

--                         player_table["icon"] = v.photoUrl

--                         table.insert(disband_table, player_table)

-- 						-- if isAgree == 1 then
-- 						-- 	showMsg = showMsg .. "  【" .. nickName .. "】已同意" .. "\n"
-- 						-- else
-- 						-- 	showMsg = showMsg .. "  【" .. nickName .. "】等待选择" .. "\n"
-- 						-- end

-- 					end

-- 				end
-- 			end
-- 		end

-- 	if applyId == USER_INFO["uid"] then
-- 		--假如申请者是自己，则直接显示其他用户的选择情况
-- 		require("hall.GameTips"):showDisbandNewTips("提示", "agree_disbandGroup", 4, disband_table)
-- 	else
-- 		--申请者不是自己，根据自己的同意情况进行界面显示
-- 		if isMyAgree == 1 then
-- 			require("hall.GameTips"):showDisbandNewTips("提示", "agree_disbandGroup", 4, disband_table)
-- 		else
-- 			require("hall.GameTips"):showDisbandNewTips("提示", "ZZMJ_request_disbandGroup", 1, disband_table)
-- 		end
-- 	end

-- end

function ZZMJReceiveHandle:G2H_CMD_REFRESH_DISSOLVE_LIST(pack)

    dump(pack, "-----广播当前组局解散情况-----")
    dump(bm.Room, "-----广播当前房间情况-----")

    local applyId = pack.applyId
    local agreeNum = pack.agreeNum
    local agreeMember_arr = pack.agreeMember_arr

    local showMsg = ""

    --申请解散者信息
    local applyer_info = {}
    if applyId == USER_INFO["uid"] then
        showMsg = "您申请解散房间，请等待其他玩家同意（超过5分钟未做选择，则默认同意）" .. "\n"
    else
        local player_table = {}
        local seatId = ZZMJ_SEAT_TABLE[applyId .. ""]
        if seatId then
            --todo
            local userInfo = ZZMJ_USERINFO_TABLE[seatId .. ""]

            if userInfo then

                local nickName = userInfo.nick
                showMsg = "玩家【" .. nickName .. "】申请解散房间，请等待其他玩家同意（超过5分钟未做选择，则默认同意）" .. "\n"

            end

        end
        
    end
    
    local isMyAgree = 0
    if applyId ~= USER_INFO["uid"] then

        --假如申请者不是自己，添加自己的选择情况
        if agreeNum > 0 then
            for k,v in pairs(agreeMember_arr) do
                if v == USER_INFO["uid"] then
                    isMyAgree = 1
                    break
                end
            end
        end

        if isMyAgree == 1 then
            showMsg = showMsg .. "  【我】已同意" .. "\n"
        else
            showMsg = showMsg .. "  【我】等待选择" .. "\n"
        end

    end

    --显示其他人情况
    if ZZMJ_USERINFO_TABLE then

        for k,v in pairs(ZZMJ_USERINFO_TABLE) do
            local uid = v.uid
            --排除掉申请者，申请者不需要显示到这里
            if uid ~= applyId and uid ~= USER_INFO["uid"] then

                --记录当前用户是否已经同意
                local isAgree = 0
                if agreeNum > 0 then
                    for k,v in pairs(agreeMember_arr) do
                        if uid == v then
                            --当前用户已经同意
                            isAgree = 1
                            break
                        end
                    end
                end

                local player_table = {}

                local nickName = v.nick
                if nickName ~= nil then

                    if isAgree == 1 then
                        showMsg = showMsg .. "  【" .. nickName .. "】已同意" .. "\n"
                    else
                        showMsg = showMsg .. "  【" .. nickName .. "】等待选择" .. "\n"
                    end

                end

            end
        end
    end

    if applyId == USER_INFO["uid"] then
        --假如申请者是自己，则直接显示其他用户的选择情况
        require("hall.GameTips"):showDisbandTips("提示", "agree_disbandGroup", 4, showMsg)
    else
        --申请者不是自己，根据自己的同意情况进行界面显示
        if isMyAgree == 1 then
            require("hall.GameTips"):showDisbandTips("提示", "agree_disbandGroup", 4, showMsg)
        else
            require("hall.GameTips"):showDisbandTips("提示", "ZZMJ_request_disbandGroup", 1, showMsg)
        end
    end
    
end

---------------------------------------------------------------------------------------------------------------
--聊天相关
--收到聊天消息
function ZZMJReceiveHandle:CHAT_MSG(pack)
	--dump(pack, "================CHAT_MSG========================")
	local scenes         = SCENENOW['scene'] 

	if SCENENOW['name'] ~= run_scene_name then
		return
	end

	local config = {[0]={['x'] = 480,['y'] = 200,},
					[1]={['x'] = 300,['y'] = 250,},--左
					[2]={['x'] = 480,['y'] = 450,},--上
					[3]={['x'] = 750,['y'] = 300,},--右
	}

	local msg = pack.msg or "nothing to get"
	local index = self:getIndex(pack.uid or USER_INFO["uid"])

	local niu_txt = scenes:getChildByName("chat_msg"..tostring(index))
	if niu_txt ~= nil then niu_txt:removeSelf() end

	local params =
    {
        text = msg,
        font = "res/fonts/fzcy.ttf",
        size = 25,
        color = cc.c3b(255,0,0), 
        align = cc.TEXT_ALIGNMENT_CENTER,
        valign = cc.VERTICAL_TEXT_ALIGNMENT_TOP,
    }
    niu_txt =  display.newTTFLabel(params)
    niu_txt:enableShadow(cc.c4b(255,0,0,255), cc.size(1,0))
    scenes:addChild(niu_txt, "3000", "chat_msg"..tostring(index))
    niu_txt:setPositionX(config[index].x)
    niu_txt:setPositionY(config[index].y)

    local action_deley = cc.DelayTime:create(0.5)
    local action_move = cc.MoveBy:create(0.5,cc.p(0,-80))
    local action_reself = cc.RemoveSelf:create()
    local action_seq = cc.Sequence:create(action_deley,action_move,action_reself)
    niu_txt:runAction(action_seq)
end
---------------------------------------------------------------------------------------------------------------
--比赛相关
function ZZMJReceiveHandle:s2c_JOIN_MATCH_RETURN(pack)
	--print("===recieve====0x211====================")
	--dump(pack)
	--print("UID------------------", USER_INFO["uid"])
    USER_INFO["match_id"] = pack["Matched"]
	local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_ROOM_GROUP)
    :setParameter("tableid", pack.Matched)
    :setParameter("nUserId", USER_INFO["uid"])
    :setParameter("strkey", json.encode("kadlelala"))
    :setParameter("strinfo", USER_INFO["user_info"])
    :setParameter("iflag", 1)
    :setParameter("version", 1)
    :setParameter("activity_id","")
    :build()
	bm.server:send(pack)
	--print("sending ------------------1001-------------")
end

function ZZMJReceiveHandle:s2c_JOIN_MATCH_FAIL(pack)
	--print("0x7109==========return==========")
	--dump(pack)
	USER_INFO["match_fee"] = 0
    require("majiang.MatchSetting"):setJoinMatch(false)
end

function ZZMJReceiveHandle:s2c_JOIN_MATCH_SUCCESS(pack)
	--print("0x7101==========return==========")
	--dump(pack)

	--重设玩家的金币数，这个是扣除了报名费
	USER_INFO["gold"] = pack.Score
	local scenes         = SCENENOW['scene'] 

	if SCENENOW['name'] =="majiang.MJselectChip"  then
		scenes:goldUpdate()
	end
	 require("majiang.MatchSetting"):setJoinMatch(true)


    if USER_INFO["match_fee"] then
        if USER_INFO["match_fee"] > 0 then
            bMatchJoin = true
            require("majiang.MatchSetting"):showMatchSignup(true,pack["MatchUserCount"],pack["totalCount"],pack["Costformatch"],"majiang",USER_INFO["curr_match_level"])
        end
    end

    USER_INFO["match_fee"] = pack["Costformatch"]

    --进入比赛模式
    --进入比赛模式
    require("hall.GameData"):enterMatch(4)
end

function ZZMJReceiveHandle:s2c_OTHER_PEOPLE_JOINT_IN(pack)
	--print("0x7103==========return==========")
	--dump(pack)
	require("majiang.MatchSetting"):setJoinMatch(true)
	require("majiang.MatchSetting"):joinMatch(pack.Usercount,pack.Totalcount)
end

function ZZMJReceiveHandle:s2c_QUIT_MATCH_RETURN(pack)
	--print(" 0x7110==========return==========")
	--dump(pack)
	-- require("majiang.MatchSetting"):setJoinMatch(false)

    if pack then
        local flag = pack["Flag"]
        -- 成功退赛
        if flag == 1 or flag == 2 then
            --退回报名费
			local scenes         = SCENENOW['scene'] 
            USER_INFO["gold"] = USER_INFO["gold"] + pack["nCostForMatch"]
			if SCENENOW['name'] =="majiang.MJselectChip"  then
				scenes:goldUpdate()
			end
            
            require("majiang.MatchSetting"):setJoinMatch(false)
            MajiangroomServer:quickRoom()

            local layer_sign = scenes:getChildByName("layer_sign")

            if layer_sign then
                local txt = layer_sign:getChildByName("layout_join"):getChildByName("txt_playercount")
                if txt then
                    local str = "退赛成功"
                    txt:setString(str)
                end
            end
            USER_INFO["match_fee"] = 0
            bMatchJoin = false


        else
            --失败原因
            --print("match logout failed,error type:"..pack["Errortype"])
            require("majiang.MatchSetting"):setJoinMatch(true)
        end

    end
end

function ZZMJReceiveHandle:s2c_GAME_BEGIN_LOGIC(pack)
	--print("0x7104==========return==========")
	--dump(pack)
	
	bm.User={}
	bm.User.Seat      = pack.seat_id
	bm.User.Golf      = pack.gold or pack.Matchpoint
	bm.User.Pque      = nil

	ZZMJ_ROOM={}
	ZZMJ_ROOM.User      = {}	
    ZZMJ_ROOM.UserInfo  = {}
    ZZMJ_ROOM.seat_uid  = {}
	ZZMJ_ROOM.Card      = {}
	ZZMJ_ROOM.Gang      = {}
	ZZMJ_ROOM.base      = pack.base 

	ZZMJ_ROOM.tuoguan_ing = 0

	--bm.display_scenes("majiang.scenes.MajiangroomScenes")

	SCENENOW["scene"]:removeSelf()
	SCENENOW["scene"]=nil;

	local sc=require("majiang.scenes.MajiangroomScenes").new()
	SCENENOW["scene"] = sc
    --SCENENOW["scene"]:retain();
    SCENENOW["name"]  = "majiang.scenes.MajiangroomScenes";
	display.replaceScene(sc)
	local scenes   = sc

	--绘制自己的信息
	scenes:set_ower_info(USER_INFO["icon_url"],USER_INFO["nick"],pack["Matchpoint"],USER_INFO["sex"])

	--绘制其他玩家
	if pack.Usercount > 0  then
		for i,v in pairs(pack.other_players) do
			ZZMJReceiveHandle:showPlayer(v)
		end
	end

	--绘制其他内容
	scenes:set_basescole_txt(ZZMJ_ROOM.base) 

	-- if bm.isGroup  then --
    if require("hall.gameSettings"):getGameMode() == "group" then
		USER_INFO["base_chip"]=ZZMJ_ROOM.base;
		require("majiang.gameScene"):showTimer(bm.GroupTimer)

		require("majiang.gameScene"):checkChip(scenes)

	else
		SCENENOW["scene"]:gameReady();
		
	end
	majiangGameMode = 2
	require("hall.gameSettings"):setGameMode("match")
	require("majiang.MatchSetting"):setCurrentRound(pack["Round"],pack["Sheaves"])
	voiceUtils:playBackgroundMusic()

    if scenes:getChildByName("match_win") then
        scenes:removeChildByName("match_win")
    end
    if scenes:getChildByName("match_lose") then
        scenes:removeChildByName("match_lose")
    end
    if scenes:getChildByName("match_wait") then
        scenes:removeChildByName("match_wait")
    end
    if scenes:getChildByName("match_result") then
        scenes:removeChildByName("match_result")
    end

end

function ZZMJReceiveHandle:s2c_PAI_MING_MSG(pack)
	--print("0x7114==========return==========")
	--dump(pack)
end

function ZZMJReceiveHandle:s2c_SVR_MATCH_WAIT(pack)
	--print("0x7113==========return==========")
	--dump(pack)
	SCENENOW["scene"]:removeSelf()
	SCENENOW["scene"]=nil;

	local sc=require("majiang.scenes.MajiangroomScenes").new()
	SCENENOW["scene"] = sc
    --SCENENOW["scene"]:retain();
    SCENENOW["name"]  = "majiang.scenes.MajiangroomScenes";
	display.replaceScene(sc)
	local scenes   = sc
	if tolua.isnull(scenes) == false then
	    USER_INFO["match_gold"] = pack["Matchpoint"]
		scenes:set_ower_info(USER_INFO["icon_url"],USER_INFO["nick"],pack["Matchpoint"],USER_INFO["sex"])
	    require("majiang.HallHttpNet"):MatchloadBattles(4)
	    require("majiang.MatchSetting"):setMatchState(1)
	end

	if pack["table_count"]>0 then
        require("majiang.MatchSetting"):showMatchWait(true,"majiang")
        return
    end
end

function ZZMJReceiveHandle:s2c_GAME_STATE_MSG(pack)
	--print("0x7106==========return==========")
	--dump(pack)
	local scenes         = SCENENOW['scene'] 

	if SCENENOW['name'] ~= run_scene_name then
		return
	end
	if pack == nil then
		return
	end

    if pack["Tablecount"]>0 then
        require("majiang.MatchSetting"):showMatchWait(true,"majiang")
        return
    end

	local status = pack["Status"]
    if status==0 then --晋级
        if USER_INFO["match_rank"] == nil then
            USER_INFO["match_rank"] = 0
        end
        if USER_INFO["match_rank"] == 0 then
            USER_INFO["match_rank"] = pack["Maxnumber"]
        end
        -- self:showMatchWin(pack["Rank"],USER_INFO["match_rank"],currentRound)
        if pack["Tablecount"] == 0 then
            require("majiang.MatchSetting"):showMatchWin(pack["Rank"],USER_INFO["match_rank"],require("majiang.MatchSetting"):getCurrentRank(),"majiang")
        end
    elseif status==1 then --淘汰后显示结果
        require("majiang.MatchSetting"):setMatchResult(pack["Rank"],pack["Maxnumber"],pack["Strtime"],"majiang",require("majiang.MatchSetting"):getIncentive(pack["Level"],pack["Rank"]))
        require("majiang.MatchSetting"):showMatchLose(pack["Rank"],pack["Maxnumber"],require("majiang.MatchSetting"):getCurrentRank(),"majiang")
        bMatchStatus = 2
        local sp = display.newSprite():addTo(scenes)
        sp:performWithDelay(function()
            require("majiang.MatchSetting"):showMatchResult()
        end,5)
        audio.stopMusic(true)
    elseif status==2 then --赢了显示结果
    	audio.stopMusic(true)

        bMatchStatus = 2
        
        require("majiang.MatchSetting"):setMatchResult(pack["Rank"],pack["Maxnumber"],pack["Strtime"],"majiang",require("majiang.MatchSetting"):getIncentive(pack["Level"],pack["Rank"]))
		require("majiang.MatchSetting"):showMatchResult()	
	end     
end

function ZZMJReceiveHandle:s2c_SVR_REGET_MATCH_ROOM(pack)
	
	----dump(pack)
	--重新调用1009部分的功能
	self:SVR_REGET_ROOM(pack)
	majiangGameMode = 2
	require("hall.gameSettings"):setGameMode("match")
	data_manager:set_game_mode(2)
	
	-- --print("recieve msg ----------7112--------------------------")
 --    --print("pack.m_nMatchRank--------------",pack.m_nMatchRank)--当前排名
 --    --print("pack.m_nPoint--------------",pack.m_nPoint)--当前积分
 --    --print("pack.m_strUserInfo--------------",pack.m_strUserInfo)--用户信息
    --pack.m_nplayecount

	--for index,user_data in pairs(pack.other_point) do
		-- --print("index.............",index)
		-- --print("user_data.m_userid--------------",user_data.m_userid)
		-- --print("user_data.m_nMatchRank--------------",user_data.m_nMatchRank)
		-- --print("user_data.m_nPoint--------------",user_data.m_nMatchRank)
	--end

	-- --print("index............over")
 --    --print("pack.m_nLevel--------------",pack.m_nLevel)
    USER_INFO["curr_match_level"] = pack.m_nLevel
    USER_INFO["match_fee"] = 100

    -- --print("pack.m_nSheaves--------------",pack.m_nSheaves)--第几局`
    -- --print("pack.m_nRound--------------",pack.m_nRound)--第几轮
    -- require("majiang.MatchSetting"):setCurrentRound(pack["m_nRound"],pack["m_nSheaves"])

    -- --print("pack.m_nLowPoint--------------",pack.m_nLowPoint)
    -- --print("pack.m_nNuber--------------",pack.m_nNuber)
    -- --print("pack.m_nCurrentCount--------------",pack.m_nCurrentCount)
    -- --print("pack.m_nstr--------------",pack.m_nstr)
    -- --print("pack.m_nFinalplayTimesInTable--------------",pack.m_nFinalplayTimesInTable)

    --require("majiang.HallHttpNet"):MatchloadBattles(4)

    data_manager:match_game_http(pack.m_nLevel)
    require("majiang.HallHttpNet"):requestIncentive(pack.m_nLevel)

 --    if pack.pHuSeatId == 1 then
	-- 	require("majiang.MatchSetting"):showMatchWait(true,"majiang")
	-- end
end
---------------------------------------------------------------------------------------------------------------

--补花
function ZZMJReceiveHandle:SERVER_BUHUA(pack)

    dump(pack, "-----补花-----")

    local seatId = pack.seatId
    local playerType = cardUtils:getPlayerType(seatId)
    local huapai = pack.huaList
    local bupai = pack.cardsList

    --显示花牌
    if pack.huaSize > 0 then
        gamePlaneOperator:showHuaCard(playerType, pack.huaList)
    end
    
    --替换掉手牌
    -- if pack.cardsSize > 0 then
    
        -- for k,v in pairs(pack.cardsList) do
        --     if playerType ~= CARD_PLAYERTYPE_MY then
        --         cardUtils:getNewCard(pack.seatId, 0)
        --         gamePlaneOperator:getNewCard(playerType, 0)
        --     else
        --         cardUtils:getNewCard(pack.seatId, v)
        --         gamePlaneOperator:getNewCard(CARD_PLAYERTYPE_MY, v, TINGSEQ)
        --     end
        -- end

        if playerType  == CARD_PLAYERTYPE_MY then
            --自己补花

            local handcard = ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].hand
            dump(handcard, "-----用户".. USER_INFO["uid"] .. "原始手牌-----")
            dump(ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].hand, "-----用户".. USER_INFO["uid"] .. "原始手牌-----")
            if #bupai > 0 then      --开场多张花牌

                ZZMJ_GAMEINFO_TABLE[seatId .. ""].hua = huapai

                local i = 1
                for k,v in pairs(handcard) do    --找到手牌中花牌进行替换
                    if v > 80 then         --手牌
                        gamePlaneOperator:playHuaCard(CARD_PLAYERTYPE_MY, v)
                        handcard[k] = bupai[i]
                        i = i + 1
                    end
                end

                dump(handcard, "-----用户".. USER_INFO["uid"] .. "补花后手牌-----")
                dump(ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].hand, "-----用户".. USER_INFO["uid"] .. "补花后手牌-----")

                --显示补花动画
                gamePlaneOperator:buHua(CARD_PLAYERTYPE_MY)

                gamePlaneOperator:showCards(playerType)

                voiceUtils:playControlSound(seatId, BUHUA_TYPE_B)

            elseif #bupai == 0 and #huapai > 0  then  --没有补牌但有花牌时（平时摸到花牌补花）

                local newHua
                if #ZZMJ_GAMEINFO_TABLE[seatId .. ""].hua == 0 then
                    newHua = huapai[1]

                else

                    for k,v in pairs(huapai) do
                        local isNewHua = true
                        for k1,v1 in pairs(ZZMJ_GAMEINFO_TABLE[seatId .. ""].hua) do
                            if v == v1 then
                                isNewHua = false
                            end
                        end
                        if isNewHua then
                            newHua = v
                        end
                    end

                end

                local value = bit.band(newHua, 0xFF)
                dump(value, "-----新添加一张花牌-----")
                gamePlaneOperator:getNewCard(playerType, value)

                isBuHuaIng = true

                bm.SchedulerPool:delayCall(function()

                    --移除花牌
                    gamePlaneOperator:removeCards(playerType, {}, true)

                    for i,v1 in pairs(huapai) do
                        gamePlaneOperator:playHuaCard(CARD_PLAYERTYPE_MY, v1)
                    end
                    
                    --显示补花动画
                    gamePlaneOperator:buHua(CARD_PLAYERTYPE_MY)

                    gamePlaneOperator:showCards(playerType)

                    voiceUtils:playControlSound(seatId, BUHUA_TYPE_B)

                end, 1)

                dump(ZZMJ_GAMEINFO_TABLE[ZZMJ_MY_USERINFO.seat_id .. ""].hand, "-----用户".. USER_INFO["uid"] .. "补花后手牌-----")

            end

        else
            --他人补花

            for i,v1 in pairs(huapai) do
                gamePlaneOperator:playHuaCard(playerType, v1)
            end

            --显示补花动画
            gamePlaneOperator:buHua(playerType)

            dump(playerType, "------他人补花-----")

            gamePlaneOperator:showCards(playerType)

            voiceUtils:playControlSound(seatId, BUHUA_TYPE_B)

        end

    -- end

    -- gamePlaneOperator:showCards(playerType)

    -- voiceUtils:playControlSound(seatId, BUHUA_TYPE_B)

end

return ZZMJReceiveHandle