
local ModelView = class("ModelView")

function ModelView:addView(view)

	local s = view:getChildByName("ModelView")
    if s then
        s:removeSelf()
    end

    s = cc.CSLoader:createNode("hall/view/modelView/model_Layer.csb")
    s:setName("ModelView")
    s:setAnchorPoint(0,1)

    local Image_1 = s:getChildByName("Image_1")
    local x = 0
    Image_1:runAction(cc.RepeatForever:create(

    	cc.Sequence:create(cc.DelayTime:create(0.15),cc.CallFunc:create(function()

        	if x == 0 then
        		Image_1:loadTexture("hall/view/modelView/image/1.png")
        	elseif x == 1 then
        		Image_1:loadTexture("hall/view/modelView/image/2.png")
        	elseif x == 2 then
        		Image_1:loadTexture("hall/view/modelView/image/3.png")
        	elseif x == 3 then
        		Image_1:loadTexture("hall/view/modelView/image/4.png")
        	elseif x == 4 then
        		Image_1:loadTexture("hall/view/modelView/image/5.png")
        	elseif x == 5 then
        		Image_1:loadTexture("hall/view/modelView/image/6.png")
        	elseif x == 6 then
        		Image_1:loadTexture("hall/view/modelView/image/7.png")
        	elseif x == 7 then
        		Image_1:loadTexture("hall/view/modelView/image/0.png")
        	end

        	x = x + 1

        	if x == 8 then
        		x = 0
        	end

        end))

    ))

    view:addChild(s, 100)

    dump("展示", "-----ModelView-----")

end

function ModelView:removeView(view)

	local s = view:getChildByName("ModelView")
    if s then
        s:removeSelf()
        dump("移除", "-----ModelView-----")
    end

end

return ModelView