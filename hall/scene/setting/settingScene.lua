
local settingScene = class("settingScene")

function settingScene:showScene(flag, bChangeUser, bDismiss, sDisband, disbandCallback)

	dump(bDismiss, "-----settingScene-----")

	dismiss = bDismiss or false
    change_user = bChangeUser or false
    showDisband = sDisband or false

    if SCENENOW["scene"] ~= nil then

    	if flag == false then
		    self:removeScene()
		    return
		end

    	local layout = cc.CSLoader:createNode(SettingCsb_filePath):addTo(SCENENOW["scene"])
	    layout:setLocalZOrder(10000)
	    
--	 	require("hall.GameCommon"):commomButtonAnimation(layout)
	   
	    layout:setName("layout_settings")
	    if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            layout:setScale(0.75)
        end

	    local floor = layout:getChildByName("floor")
	    floor.noScale = true
	    -- floor:onClick(
	    --     function()
	    --         self:showSettings(false)
	    --     end
	    -- )

	    --关闭按钮
	    local close_bt = floor:getChildByName("close_bt")

	    --音效滑条
	    local sound_slide = floor:getChildByName("sound_slide")
	    --音效开关
	    local sound_bt = floor:getChildByName("sound_bt")

	    --音量滑条
	    local music_slide = floor:getChildByName("music_slide")
	    --音量开关
	    local music_bt = floor:getChildByName("music_bt")

	    --退出登录按钮
	    local logout_bt = floor:getChildByName("logout_bt")

	    local audioEngine = cc.SimpleAudioEngine:getInstance()

	    --解散组局按钮
	    if showDisband then

	        local Text_5 = logout_bt:getChildByName("Text_5")
	        Text_5:setString("解散房间")
	        logout_bt:addTouchEventListener(
	            disbandCallback
	        )
	        
	    end
	    
	    local Music = cc.UserDefault:getInstance():getIntegerForKey("Music")  
        local Sound= cc.UserDefault:getInstance():getIntegerForKey("Sound")    
         music_slide:setPercent(Music)   
	     sound_slide:setPercent(Sound)	      	      
	    --按钮事件
	    local function touchButtonEvent(sender, event)

	        if event == TOUCH_EVENT_ENDED then

	            if sender == close_bt then                    
	                local MusicVolume=audioEngine:getMusicVolume()
	                local EffectsVolume=audioEngine:getEffectsVolume()
	                cc.UserDefault:getInstance():setFloatForKey("MusicVolume", MusicVolume)
	                cc.UserDefault:getInstance():setFloatForKey("EffectsVolume", EffectsVolume)
	                cc.UserDefault:getInstance():flush()
                    local Music=music_slide:getPercent()
                    local Sound=sound_slide:getPercent()
                    cc.UserDefault:getInstance():setIntegerForKey("Music", Music)
	                cc.UserDefault:getInstance():setIntegerForKey("Sound", Sound)
                    layout:removeFromParent()    
                     
	            end

	            --打开音乐
	            if sender == music_bt then
	            
	                if audioEngine:getMusicVolume() == 0 then          
	                    audioEngine:setMusicVolume(1.0)
	                    music_slide:setPercent(100)                  
	                else
	                	print("dazhaohuang",event)
	                    audioEngine:setMusicVolume(0.0)
	                    music_slide:setPercent(5)
	     
	                end 

	            elseif sender == sound_bt then
                   
	                if audioEngine:getEffectsVolume() == 0.0 then
	                    --todo

	                    audioEngine:setEffectsVolume(1.0)
	                    sound_slide:setPercent(100)	                     
	                    
	                else
	                    audioEngine:setEffectsVolume(0.0)
	                    sound_slide:setPercent(5)
	                   
	                end

	            elseif sender == logout_bt then
                        
	                require(LoginScene_filePath):show()

	                self:removeScene()

	            end

	        end

	    end
	    close_bt:addTouchEventListener(touchButtonEvent)
	    if not showDisband then
	    	logout_bt:addTouchEventListener(touchButtonEvent)
	    end

	    --滑条
	    local function sliderChanged(sender,eventType)
	        if eventType == ccui.SliderEventType.percentChanged then
	            local amount = sender:getPercent()
	            local audioEngine = cc.SimpleAudioEngine:getInstance()
	            -- amount = math.modf(amount/20)*20
	            if sender == music_slide then
	                --todo
	                audioEngine:setMusicVolume(amount / 100)
	                if amount == 0 then
	                    --todo
	                 
	                    music_bt:setColor(cc.c3b(125,125,125))
	                else

	                    music_bt:setColor(cc.c3b(255,255,255))
	                end
	            elseif sender == sound_slide then
	                audioEngine:setEffectsVolume(amount / 100)
	                if amount == 0 then
	                    --todo
	                    sound_bt:setColor(cc.c3b(125,125,125))
	                else
	                    sound_bt:setColor(cc.c3b(255,255,255))
	                end
	            end
	           
	        end
	    end
 
	    -- if device.platform ~= "windows" then

	        -- sound_slide:setPercent(audioEngine:getEffectsVolume() * 100)
	      

	        if audioEngine:getMusicVolume() == 0.0 then
	            --todo
	            music_bt:setColor(cc.c3b(125,125,125))
	        else
	            music_bt:setColor(cc.c3b(255,255,255))
	        end

	        if audioEngine:getEffectsVolume() == 0.0 then
	            --todo
	            sound_bt:setColor(cc.c3b(125,125,125))
	        else
	            sound_bt:setColor(cc.c3b(255,255,255))
	        end
	    
	        music_bt:addTouchEventListener(touchButtonEvent)
	        sound_bt:addTouchEventListener(touchButtonEvent)
	        sound_slide:addEventListener(sliderChanged)
	        music_slide:addEventListener(sliderChanged)

	    -- end

    end

end

function settingScene:removeScene()

	local s = SCENENOW["scene"]:getChildByName("layout_settings")
    if s then
        s:removeSelf()
    end
	
end

return settingScene