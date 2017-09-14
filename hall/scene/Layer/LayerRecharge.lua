--充值DLG
local l_LayerBase = require("hall.scene.Layer.LayerBase")
local LayerRecharge = class("LayerRecharge", l_LayerBase)

function LayerRecharge:ctor()
    self.super.ctor(self)
    
	local root = cc.CSLoader:createNode("hall/scene/res/Layer/LayerRecharge.csb")
	self:addChild(root)

	local bg = root:getChildByName("Panel")

    local closeBtn = ccui.Helper:seekWidgetByName(bg,"close_btn")
    closeBtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            PlayMusicEffect()
        	self:removeLayer()
        end
    end)
end

return LayerRecharge