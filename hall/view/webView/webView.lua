
local webView = class("webView")

function webView:showView(url,action)

	if SCENENOW["scene"] then

		local s = SCENENOW["scene"]:getChildByName("webView")
	    if s then
	        s:removeSelf()
	    end

	    s = cc.CSLoader:createNode("hall/view/webView/webViewLayer.csb")
    	s:setName("webView")
    	SCENENOW["scene"]:addChild(s)

    	local bg_ly = s:getChildByName("Panel_1")
    	bg_ly:setTouchEnabled(true)
    	bg_ly:addTouchEventListener(
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

    	local root_ly = s:getChildByName("floor")
    	root_ly:setTouchEnabled(true)
    	root_ly:addTouchEventListener(
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

        local back_bt = root_ly:getChildByName("back_bt")
        back_bt:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                    
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    
                    self:removeView()

                    if action == "buyCard" and SCENENOW["name"] == GameScene_filePath then
                        require(GameScene_filePath):queryRoomCardCount()
                    end

                end

            end
        )

        local title_iv = root_ly:getChildByName("Image_2")
        title_iv:loadTexture("hall/image/tip/text_goumaifangka.png")

        local web_plane = root_ly:getChildByName("web_plane")
        if device.platform ~="windows" then
            local planeSize = web_plane:getSize()
            local webView = ccexp.WebView:create()
            webView:setPosition(planeSize.width / 2, planeSize.height / 2)
            webView:setContentSize(planeSize.width - 20,  planeSize.height - 20)
            webView:loadURL(url)
            webView:setScalesPageToFit(true)
            web_plane:addChild(webView)
        end
		
	end

end

function webView:removeView()

	local s = SCENENOW["scene"]:getChildByName("webView")
    if s then
        s:removeSelf()
    end

end

return webView