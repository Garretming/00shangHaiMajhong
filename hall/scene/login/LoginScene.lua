local loginInstance = loginInstance or nil

local LoginScene = class("LoginScene", function() 
	return display.newScene("LoginScene")
end)

function LoginScene:ctor()

	self.scene = cc.CSLoader:createNode(LoginSceneCsb_filePath)

    self.Image_1 = self.scene:getChildByName("Image_1")

	 --微信登陆按钮
    self.login_bt = self.scene:getChildByName("login_bt")
    if isiOSVerify then

        self.login_bt:setVisible(false)
        -- self.login_bt:setPosition(self.login_bt:getPosition().x + 200, self.login_bt:getPosition().y)

        --快速登陆按钮
        local button = ccui.Button:create()
        button:setTouchEnabled(true)
        button:setAnchorPoint(0.5,0.5)
        button:setPosition(self.login_bt:getPosition().x, self.login_bt:getPosition().y)
        button:loadTextures("hall/scene/res/lequ/image/login/fast_bt_n.png", "hall/scene/res/lequ/image/login/fast_bt_c.png", nil)
        button:addTo(self.scene)
        button:addTouchEventListener(

            function(sender,event)

                --触摸结束
                if event == TOUCH_EVENT_ENDED then

                    bm.isQuickLogin = "1"

                    require("hall.hallScene"):initFinished()

                end

            end

        )

    end

	self.check_bx = self.scene:getChildByName("check_bx")

	self.agreement_bt = self.scene:getChildByName("agreement_bt")

	self:initListeners()

end

function LoginScene:onEnter()

end

function LoginScene:show()

    --开启心跳检测,这里他们要求loginLayer隐藏的时候开始检测心跳。
    --loginLayer显示的时候不检测心跳包
    bm.checknetworking = false
    local loginLayer = SCENENOW["scene"]:getChildByName("loginLayer")

    if loginLayer then
        --todo
        loginLayer:removeFromParent()
    end

    --todo
    loginInstance = LoginScene:new()
    loginInstance.scene:setName("loginLayer")
    loginInstance.scene:setLocalZOrder(90000)
    if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
        loginInstance.scene:setScale(0.75)
    end
    SCENENOW["scene"]:addChild(loginInstance.scene)

    --设置当前不是快速登陆
    bm.isQuickLogin = "0"

    require(NetworkLoadingView_filePath):removeView()

end

function LoginScene:initListeners()

    --防触摸穿透
    local Image_1 = self.Image_1
    Image_1:setTouchEnabled(true)
    Image_1:addTouchEventListener(
        function(sender,event)

            if event == TOUCH_EVENT_BEGAN then

            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then

            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then
                
            end

        end
    )

    local login_bt_t = self.login_bt
    login_bt_t:setTouchEnabled(true)
    local check_bx_t = self.check_bx
    check_bx_t:setSelectedState(true)
    local agreement_bt_t = self.agreement_bt

    local function touchButtonEvent(sender, event)

        if event == TOUCH_EVENT_ENDED then
            
            if sender == login_bt_t then

                login_bt_t:setTouchEnabled(false)

                if device.platform == "windows" then
                    
                    require("hall.hallScene"):initFinished()
                
                else

                    local sigs = {}
                    cct.getDateForApp("wxLogin",{},"V")

                end

            end

            if sender == agreement_bt_t then
                -- local am_msg = "                                                                     游戏用户协议"
                -- require("hall.GameCommon"):showAgreement(true, am_msg)
            end
            
        end
    end

    self.login_bt:addTouchEventListener(touchButtonEvent)
    self.agreement_bt:addTouchEventListener(touchButtonEvent)

    self.check_bx:addEventListener(

        function(sender, eventType)

            if eventType == 0 then
                login_bt_t:setTouchEnabled(true)
                check_bx_t:setSelectedState(true)

            else
                login_bt_t:setTouchEnabled(false)
                check_bx_t:setSelectedState(false)

            end

        end
    )

end

function LoginScene:init()

    dump("", "-----登录界面初始化-----")

    local login_bt = self.scene:getChildByName("login_bt")
    local check_bx = self.scene:getChildByName("check_bx")

    login_bt:setColor(cc.c3b(255, 255, 255))
    login_bt:setEnabled(true)
    check_bx:setEnabled(true)

end

function LoginScene:onExit()

end

return LoginScene