
--获取全局定义数据
require("js_majiang_3d.globle.ZZMJData")
require("js_majiang_3d.globle.ZZMJDefine")

--获取游戏界面操作类
local gamePlaneOperator = require("js_majiang_3d.operator.GamePlaneOperator")
-- local manyouPlaneOperator = require("js_majiang_3d.operator.ManyouPlaneOperator")

--获取协议
local PROTOCOL = import("js_majiang_3d.handle.ZZMJProtocol")

--获取前端发送协议操作类
local sendHandle = require("js_majiang_3d.handle.ZZMJSendHandle")

--获取接收到协议后的操作类
local receiveHandle = require("js_majiang_3d.handle.ZZMJReceiveHandle")

--获取文字聊天区域
local ZZMJ_face = require("hall.FaceUI.faceUI")

--获取3D麻将操作类
D3_OPERATOR = require("hall.3DMahjongCard.ShowOperator")
-- local CHILD_NAME_MANYOU_PLANE = "manyou_plane"

local CHILD_NAME_MENU_PLANE = "menu_plane"
local CHILD_NAME_MENU_BT = "menu_bt"
local CHILD_NAME_BT = ""
local CHILD_NAME_DISBAND_BT = "disband_bt"
local CHILD_NAME_SETTING_BT = "setting_bt"
local CHILD_NAME_CLOSE_ROOM_BT = "close_room_bt"
local CHILD_NAME_EXIT_BT = "exit_bt"
local CHILD_NAME_SHARE_BT = "share_bt"
local CHILD_NAME_RECORD_BT = "record_bt"
local CHILD_NAME_CHAT_BT = "chat_bt"
local CHILD_NAME_VOICE_BT = "voice_temp_bt"

local ZZMJScene = class("ZZMJScene", function()
	return display:newScene()
end)

local CHILD_NAME_ROOM_LB = "room_lb"

function ZZMJScene:ctor()

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.SHOW_ALL)
    
    --设置协议
	bm.server:setProtocol(PROTOCOL)
    --设置当前游戏操作类
    bm.server:setHandle(receiveHandle.new())

    --获取和设置游戏界面
	self._scene = cc.CSLoader:createNode("js_majiang_3d/GameScene.csb"):addTo(self)
    -- self._scene:setScale(0.75)

    --显示游戏名称
    local gameName_ly = self._scene:getChildByName("remark")
    local gameName_tt = gameName_ly:getChildByName("Text_1")
    gameName_tt:setString(tostring(USER_INFO["joinGameName"]))

    --获取游戏区域
	ZZMJ_GAME_PLANE = self._scene:getChildByName("game_plane")

    --添加文字聊天区域和添加协议到控件中
    local ZZMJ_face_node = ZZMJ_face.new();
    ZZMJ_face_node:setHandle(sendHandle)
    self:addChild(ZZMJ_face_node, 9999)
    ZZMJ_face_node:setName("faceUI")

    --dump(ZZMJ_GAME_PLANE, "js_majiang_3d test")

    --获取游戏操作类
	ZZMJ_CONTROLLER = require("js_majiang_3d.GameController")
    
    --3D游戏桌面初始化
    D3_OPERATOR:init(ZZMJ_CONTROLLER, nil, nil, nil, ZZMJ_GAME_PLANE)
    --游戏界面操作类初始化
	gamePlaneOperator:init()

	-- ZZMJ_MANYOU_PLANE = self._scene:getChildByName(CHILD_NAME_MANYOU_PLANE)
	-- manyouPlaneOperator:init()   
    local close_room_bt = self._scene:getChildByName(CHILD_NAME_CLOSE_ROOM_BT)

    local device_info_plane = self._scene:getChildByName("device_info_plane")
    -- device_info_plane:setVisible(false)

    receiveHandle:getDeviceInfo()

    local menu_ly  = self._scene:getChildByName("menu_ly")
    local menu_plane = menu_ly:getChildByName(CHILD_NAME_MENU_PLANE) 
    local menu_bt = menu_ly:getChildByName(CHILD_NAME_MENU_BT)

	local setting_bt = menu_plane:getChildByName(CHILD_NAME_SETTING_BT)
    local disband_bt = menu_plane:getChildByName(CHILD_NAME_DISBAND_BT)
    
    local instruction_bt = menu_ly:getChildByName("instruction_bt")
    local remark_lb = ZZMJ_GAME_PLANE:getChildByName("remark_lb")
    local remark_img = ZZMJ_GAME_PLANE:getChildByName("remark_img")


    instruction_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
                sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
                sender:setScale(1)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                sender:setScale(1.0)
                if remark_lb:isVisible() then
                   remark_lb:setVisible(false)
                   remark_img:setVisible(false)
                   remark_lb:setPosition(cc.p(640,instruction_bt:getPositionY()))            
               else
                   remark_lb:setPosition(cc.p(640,instruction_bt:getPositionY()))
                   remark_img:setVisible(true)
                   remark_lb:setVisible(true)
               end
            end
        end
    )

    remark_img.noScale = true
    remark_img:addTouchEventListener(
        function(sender,event)

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                sender:setScale(1.0)
                if remark_lb:isVisible() then
                   remark_lb:setVisible(false)
                   remark_img:setVisible(false)
                   remark_lb:setPosition(cc.p(640,instruction_bt:getPositionY()))            
               else
                   remark_lb:setPosition(cc.p(640,instruction_bt:getPositionY()))
                   remark_img:setVisible(true)
                   remark_lb:setVisible(true)
               end
            end
        end
    )

    menu_plane:setVisible(false)
    menu_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
                sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
                sender:setScale(1)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                sender:setScale(1.0)
                
                if menu_plane:isVisible() then
                 menu_plane:setVisible(false)
                 menu_bt:setBrightStyle(0)
                else 
                 menu_plane:setVisible(true)
                 menu_bt:setBrightStyle(1)
                end
            end
        end
    )

    menu_plane:setTouchEnabled(true)
    menu_plane:addTouchEventListener(
        function(sender,event)

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                sender:setScale(1.0)
                
                if menu_plane:isVisible() then
                 menu_plane:setVisible(false)
                 menu_bt:setBrightStyle(0)
                end
            end
        end
    )

 
    disband_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
                sender:setScale(0.8)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
                sender:setScale(1.0)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                sender:setScale(1.0)

                self:disbandGroup()

            end
        end
    )
    

	setting_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
            	sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
            	sender:setScale(1.0)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
            	sender:setScale(1.0)

            	require("hall.GameCommon"):showSettings(true,false,true,true,function(sender, event)
            			--     --触摸开始
		                if event == TOUCH_EVENT_BEGAN then
		                    sender:setScale(0.9)
		                end

		                --触摸取消
		                if event == TOUCH_EVENT_CANCELED then
		                    sender:setScale(1.0)
		                end

		                --触摸结束
		                if event == TOUCH_EVENT_ENDED then
		                    sender:setScale(1.0)

		                    require("hall.GameCommon"):showSettings(false)

		                    self:disbandGroup()

		                end
            		end)

            end
        end
    )

	-- local group_owner = tonumber(USER_INFO["group_owner"])
	--只有房主才出现解散按钮
	-- if group_owner ~= USER_INFO["uid"] then
	-- 	close_room_bt:setVisible(false)
	-- end

	close_room_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
            	sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
            	sender:setScale(1.0)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
            	sender:setScale(1.0)

            	self:disbandGroup()

            end
        end
    )

    --返回按钮
	local exit_bt = menu_ly:getChildByName(CHILD_NAME_EXIT_BT)
	exit_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
            	sender:setScale(0.8)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
            	sender:setScale(1.0)
            end

            --触摸结束（检查当前组局状态）
            if event == TOUCH_EVENT_ENDED then
            	sender:setScale(1.0)

            	--dump(USER_INFO["activity_id"], "-----退出房间按钮，当前activityid-----")

            	cct.createHttRq({
		            url = HttpAddr .. "/freeGame/queryGroupGameStatus",
		            date = {
		            	activityId = USER_INFO["activity_id"],
		            	interfaceType = "j"
		            },
		            type_= "POST",
		            callBack = function(data)
		            	--dump(data, "检查当前组局状态")
		                local responseData = data.netData
		                responseData = json.decode(responseData)
		                local returnCode = responseData.returnCode
		                if returnCode == "0" then
		                	local data = tonumber(responseData.data)
		                	-- --dump(data, "检查当前组局状态")
		                	if data == 1 then
		                		--创建组局
		                		require("hall.GameTips"):showTips("提示", "tohall", 1, "你正在房间中，是否返回大厅？")

		                	elseif data == 2 then
		                		--开始组局
		                		require("hall.GameTips"):showTips("提示", "", 2, "游戏已经开始，不能返回大厅")
		                		
		                	elseif data == 0 then
		                		--结束组局
		                		require("hall.GameTips"):showTips("提示", "tohall", 1, "当前组局已结束，是否返回大厅？")

		                	end
		                else
		                	require("hall.GameTips"):showTips("提示", "", 2, "游戏数据异常，不能退出房间")
		                end

	         		end
	    		})

            end
        end
    )

    --邀请微信好友
    local share_bt = self._scene:getChildByName(CHILD_NAME_SHARE_BT)
    share_bt:setVisible(true)
    share_bt:addTouchEventListener(
        function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
            	sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
            	sender:setScale(1.0)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
            	sender:setScale(1.0)

            	require("hall.common.ShareLayer"):showShareLayer(tostring(USER_INFO["joinGameName"]) .. "，房号：" .. USER_INFO["invote_code"], "http://fir.im/168mja", "url", USER_INFO["gameConfig"])
            end
        end
    )

    local record_bt = menu_ly:getChildByName(CHILD_NAME_RECORD_BT)
    record_bt:setVisible(false)
    record_bt:addTouchEventListener(
    	function(sender,event)
            --触摸开始
            if event == TOUCH_EVENT_BEGAN then
            	sender:setScale(0.9)
            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then
            	sender:setScale(1.0)
            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
            	sender:setScale(1.0)

            	if device.platform ~= "windows" then
            		--todo
            		require("hall.recordUtils.RecordUtils"):showRecordFrame(cc.p(480, 270), cc.size(264, 218), USER_INFO["activity_id"])
            	end
            end
        end
    	)

    local chat_bt = menu_ly:getChildByName(CHILD_NAME_CHAT_BT)
    chat_bt:setVisible(false)
    local function onface_click(sender)
        -- local posx=sender:getPosition().x*0.75
        -- local posy=sender:getPosition().y*0.75 
        local posx=sender:getPosition().x
        local posy=sender:getPosition().y
        local pos = cc.p(posx,posy)
        -- if sender.id ==1 then
        --     ddz_face_node:showFacePanle(pos)
        -- else
            ZZMJ_face_node:showTxtPanle(pos, 8)
        -- end

        --print("click faceui")
        
    end
    chat_bt:onClick(onface_click)



end

function ZZMJScene:onEnter()

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.SHOW_ALL)
    

    -- require("js_majiang_3d.result_effect_layout"):reset_niaocard_data({1,2,3,4,5,6,7,8,9,10
    --     9,10,11,12,13,14,
    --     9,10,11,12,13,14,
    --     -- 9,10,11,12,13,14,
    --     -- 9,10,11,12,13,14,
                                                          -- } ,{1,2})
    local function getDeviceInfo() 
        
       if tolua.isnull(ZZMJ_GAME_PLANE)  then
           return
       end

       local device_info_plane = (ZZMJ_GAME_PLANE:getParent()):getChildByName("device_info_plane")
       local wifi_level        = device_info_plane:getChildByName("wifi_level")
       local battery_level     = device_info_plane:getChildByName("battery_level")
       local time              = device_info_plane:getChildByName("time")
       
       local wifi_level_num = 4  --00 -- 04
       if PINT_TIME~=nil then
          dump(PINT_TIME, "PINT_TIME")
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

    local scheduler=cc.Director:getInstance():getScheduler()
    scheduler:scheduleScriptFunc(getDeviceInfo,30,false)

    local room_lb_plane = self._scene:getChildByName("room_lb_plane")
	local room_lb = room_lb_plane:getChildByName(CHILD_NAME_ROOM_LB)
	room_lb:setString(USER_INFO["invote_code"])

	-- --dump(tableIdReload, "tableIdReload test")
    
    sendHandle:LoginGame(USER_INFO["GroupLevel"])

	if tableIdReload == 0 then --非重登
        -- if require("hall.gameSettings"):getGameMode() == "group" then
        --             --todo
        --             --dump(tableIdReload, "tableIdReload test group")
            
        -- else
        --     display_scene("majiang/gameScenes")
        -- end

    else
        -- local pack_data = {}
        -- pack_data.tid = tableIdReload

        -- receiveHandle:SVR_GET_ROOM_OK(pack_data)
        tableIdReload = 0
    end
    

    
    -- require("js_majiang_3d.RoundEndingLayer"):show(self:testEnding())
    -- require("js_majiang_3d.operator.GamePlaneOperator"):beginPlayCard(CARD_PLAYERTYPE_MY)
    -- self:showLeaderLayer()
end

function ZZMJScene:get_player_ip( uid )
    -- body
    local ip_ = ""
    
    local seatId = ZZMJ_SEAT_TABLE[uid .. ""]

    if seatId then
        --todo

        if ZZMJ_USERINFO_TABLE[seatId .. ""] and ZZMJ_USERINFO_TABLE[seatId .. ""].ip then
            --todo
            ip_ = ZZMJ_USERINFO_TABLE[seatId .. ""].ip
        end
    end

    return ip_
end

function ZZMJScene:showLeaderLayer()
    local menu_ly = self._scene:getChildByName("menu_ly")
    local record_bt = menu_ly:getChildByName(CHILD_NAME_RECORD_BT)
    require("hall.leader.LeaderLayer"):showLeaderLayer(record_bt:getPosition())
end

function ZZMJScene:ShowChatButton()
    local menu_ly = self._scene:getChildByName("menu_ly")
    local chat_bt = menu_ly:getChildByName(CHILD_NAME_CHAT_BT)
    chat_bt:setVisible(true)
end

function ZZMJScene:ShowRecordButton()
    local menu_ly = self._scene:getChildByName("menu_ly")
	local record_bt = menu_ly:getChildByName(CHILD_NAME_RECORD_BT)
    record_bt:setVisible(false)

    local voice_temp_bt = menu_ly:getChildByName(CHILD_NAME_VOICE_BT)
    -- require("hall.VoiceRecord.VoiceRecordView"):showView(voice_temp_bt:getPosition().x*0.75, voice_temp_bt:getPosition().y*0.75, -1)
    require("hall.VoiceRecord.VoiceRecordView"):showView(voice_temp_bt:getPosition().x, voice_temp_bt:getPosition().y, -1)

    self:showLeaderLayer()
end

--获取用户播放录音位置
function ZZMJScene:getPosforSeat(uid)
    return ZZMJ_ROOM.positionTable[uid .. ""]
end

--显示设置按钮（弃用）
function ZZMJScene:ShowSettingButton()
	-- local setting_bt = self._scene:getChildByName(CHILD_NAME_SETTING_BT)

	-- setting_bt:setVisible(true)
end


-------------------------游戏未开始前的解散房间和分享按钮------------------------
function ZZMJScene:hideCloseRoomButton()
	local close_room_bt = self._scene:getChildByName(CHILD_NAME_CLOSE_ROOM_BT)
	close_room_bt:setVisible(false)
end

function ZZMJScene:hideShareButton()
	local share_bt = self._scene:getChildByName(CHILD_NAME_SHARE_BT)
	share_bt:setVisible(false)
end
----------------------------------------------------------------------------------
--解散房间
function ZZMJScene:disbandGroup()

	--查询用户当前的游戏状态来判断当前通过怎样的方式来解散组局
	cct.createHttRq({
        url = HttpAddr .. "/freeGame/queryGroupGameStatus",
        date = {
        	activityId = USER_INFO["activity_id"],
        	interfaceType = "j"
        },
        type_= "POST",
        callBack = function(data)
            local responseData = data.netData
            responseData = json.decode(responseData)
            local returnCode = responseData.returnCode
            if returnCode == "0" then
            	local data = tonumber(responseData.data)
            	--dump(data, "检查当前组局状态")
            	if data == 1 then
            		--创建组局
					require("hall.GameTips"):showDisbandTips("解散房间", "ZZMJ_disbandGroup", 1, "当前解散房间不需扣除房卡，是否解散？")

            	elseif data == 2 then
            		--开始组局
            		require("hall.GameTips"):showDisbandTips("解散房间", "ZZMJ_disbandGroup", 1, "当前已经扣除房卡，是否申请解散房间？")
            		
            	elseif data == 0 then
            		--结束组局
            		require("hall.GameTips"):showTips("提示", "tohall", 1, "当前组局已结束，是否返回大厅？")

            	end
            else
            		
            end

 		end
	})

end

--聊天
function ZZMJScene:SVR_MSG_FACE(uid, type, sex, node_head, isLeft)
    local s = self:getChildByName("faceUI")
    
    if tonumber(sex) >= 0 then
        s:showGetFace(uid, type, tonumber(sex), node_head, isLeft)
    end
end

return ZZMJScene