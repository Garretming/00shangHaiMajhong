

local tipView = class("tipView")

function tipView:addView(view, x, y, msg)

	msg = msg or ""

	if view then

		local s = view:getChildByName("tipView")
	    if s then
	        s:removeSelf()
	    end

	    s = cc.CSLoader:createNode("hall/view/tipView/tipViewLayer.csb")
    	s:setName("tipView")
    	s:setAnchorPoint(0, 1)
    	s:setPosition(x, y)
    	view:addChild(s)

    	local root_ly = s:getChildByName("root_ly")

    	local msg_tt = root_ly:getChildByName("msg_tt")
    	if msg ~= "" then
    		msg_tt:setString(msg)
    	end
		
	end

end

function tipView:removeView(view)

	if view then

		local s = view:getChildByName("tipView")
	    if s then
	        s:removeSelf()
	    end
		
	end

end

return tipView

