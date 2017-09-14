

local ImageAlterView = class("ImageAlterView")

function ImageAlterView:showView()

	if SCENENOW["scene"] then

		local s = SCENENOW["scene"]:getChildByName("ImageAlterView")
	    if s then
	        s:removeSelf()
	    end

	    s = cc.CSLoader:createNode("hall/view/ImageAlterView/ImageAlterView.csb")
    	s:setName("ImageAlterView")
    	SCENENOW["scene"]:addChild(s)

    	local root_ly = s:getChildByName("root_ly")
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

                	self:removeView()

                end

            end
        )

        local image_iv = root_ly:getChildByName("image_iv")
    	image_iv:loadTexture("hall/image/common/alter.png")
		
	end

end

function ImageAlterView:removeView()

	local s = SCENENOW["scene"]:getChildByName("ImageAlterView")
    if s then
        s:removeSelf()
    end

end

return ImageAlterView