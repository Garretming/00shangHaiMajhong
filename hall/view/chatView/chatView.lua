local chatView = class("chatView")

local CHILD_NAME_CHAT_BT = "chat_bt"
local CHILD_NAME_VOICE_BT = "voice_bt"
local CHILD_NAME_CHAT_PLANE = "chat_plane"

local FaceUI=require("hall.FaceUI.faceUI")
-- local sendHandle = require("szkawuxing.handle.SZKWXSendHandle")

function chatView:addView(sendHandle_addr)

	local s = SCENENOW["scene"]:getChildByName("chatView")
    if s then
        s:removeSelf()
    end

    local s
	if device.platform == "ios" then
		if isiOSVerify then
            s = cc.CSLoader:createNode("hall/view/chatView/chatView.csb")
        else
            s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/view/chatView/chatView.csb")
        end
    else
	   	s = cc.CSLoader:createNode("hall/view/chatView/chatView.csb")
	end

    s:setName("chatView")
    SCENENOW["scene"]:addChild(s)

    self.chat_plane = s:getChildByName(CHILD_NAME_CHAT_PLANE)
    self.voice_bt = self.chat_plane:getChildByName(CHILD_NAME_VOICE_BT)
    self.voice_bt:setColor(cc.c3b(130, 130, 130))

    self.chat_bt = self.chat_plane:getChildByName(CHILD_NAME_CHAT_BT)

--------------------------------------文字聊天模块--------------------------------------------------
    local face_node = FaceUI.new()

    if sendHandle_addr then
		local sendHandle = require(sendHandle_addr)  --sendHandle_addr 游戏的sendHandler文件的位置
		face_node:setHandle(sendHandle)
	end
	
    SCENENOW['scene']._scene:addChild(face_node, 9999)
    face_node:setName("faceUI")
    self.chat_bt:setVisible(true)

    local function onface_click(sender,event)
 		  local pos=sender:getPosition()

          if event == TOUCH_EVENT_ENDED then
         	 face_node:showTxtPanle(self.chat_bt:convertToWorldSpace(cc.p(0, self.chat_bt:getSize().height / 2)), 8)
          end
          end 
    self.chat_bt:addTouchEventListener(onface_click)

--------------------------------------实时语音聊天模块-----------------------------------------------
	self.voice_bt:addTouchEventListener(
	    function(sender,event)
           
	        --触摸开始
	        if event == TOUCH_EVENT_BEGAN then
	            sender:setScale(1.7)

	            dump("触摸开始", "-----录音按钮-----")

	            --暂停背景音乐
	            audio.pauseMusic()

	            -- ccexp.AudioEngine:stopAll()

	            -- cc.SimpleAudioEngine:getInstance():pauseAllEffects()

	            bm.isRecordingVoice = 1

	            require("hall.recordUtils.RecordUtils"):showRecordFrame(cc.p(480, 270), cc.size(264, 218), -1)

	        end

	        --触摸取消
	        if event == TOUCH_EVENT_CANCELED then
	            sender:setScale(2.2)

	            dump("触摸取消", "-----录音按钮-----")

	            require("hall.GameTips"):showTips("提示", "", 3, "录音取消")

	            --恢复背景音乐
	            audio.resumeMusic()

	            bm.isRecordingVoice = 0

	            require("hall.recordUtils.RecordUtils"):showRecordFrame(cc.p(480, 270), cc.size(264, 218), -3)

	        end

	        --触摸结束
	        if event == TOUCH_EVENT_ENDED then
	            sender:setScale(2.2)

	            dump("触摸结束", "-----录音按钮-----")

	            --恢复背景音乐
	            audio.resumeMusic()

	            bm.isRecordingVoice = 0

	            require("hall.recordUtils.RecordUtils"):showRecordFrame(cc.p(480, 270), cc.size(264, 218), -2)

	            -- -- 实时语音
	            -- local micState = require("hall.util.YaYaVoiceServerUtil"):getMicState()
	            -- if micState == 0 then
	            --     require("hall.util.YaYaVoiceServerUtil"):micUp()
	            -- else
	            --     require("hall.util.YaYaVoiceServerUtil"):micDown()
	            -- end

	        end  --END if event == TOUCH_EVENT_ENDED then

	    end --END function
	    )

end --END function

--设置语音按钮图片颜色（当前上下麦状态）
function chatView:setVoiceBtImg(flag)
    -- local img = "hall/view/chatView/image/record_bt.png"
    -- if flag == 1 then
    --     img = "hall/view/chatView/image/record_bt1.png"
    -- end
    -- self.voice_bt:loadTextureNormal(img)

    --改变麦按钮颜色
    local s = SCENENOW["scene"]:getChildByName("chatView")
    if s ~= nil then
        local chat_plane = s:getChildByName("chat_plane")
        if chat_plane ~= nil then
        	local voice_bt = chat_plane:getChildByName("voice_bt")
	    	if voice_bt ~= nil then
	    		if flag == 1 then
			        self.voice_bt:setColor(cc.c3b(255, 255, 255))
			    else
			    	self.voice_bt:setColor(cc.c3b(130, 130, 130))
			    end
	    	end
        end
    end

end

function chatView:hideView()
	self.chat_plane:setVisible(false)
end

return chatView