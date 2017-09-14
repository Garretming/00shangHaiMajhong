--LayerFunctionManager
local LayerFunctionManager = class("LayerFunctionManager")

function LayerFunctionManager:ctor(scene)
    self.scene = scene
end

function LayerFunctionManager:CloseCurFunctionUI()
    if self.CurFuntionUI ~= nil then
        self.CurFuntionUI:setVisible(false)
        self.CurFuntionUI:removeSelf()
        self.CurFuntionUI = nil
    end
end

--打开支付界面
function LayerFunctionManager:ShowRechargeUI()
    self:CloseCurFunctionUI()

    if self.CurFuntionUI == nil then
        self.CurFuntionUI = require("hall.scene.Layer.LayerRecharge").new()
        self.scene:addChild(self.CurFuntionUI,999)
    end
    self.CurFuntionUI:setVisible(true)
end

--打开活动界面
function LayerFunctionManager:ShowActivityUI()
    self:CloseCurFunctionUI()
    
    if self.CurFuntionUI == nil then
        self.CurFuntionUI = require("hall.scene.Layer.LayerActivity").new()
        self.scene:addChild(self.CurFuntionUI,999)
    end
    self.CurFuntionUI:setVisible(true)
end

--打开创建房间界面
function LayerFunctionManager:ShowRoomCreateUI()
    self:CloseCurFunctionUI()
    
    if self.CurFuntionUI == nil then
        self.CurFuntionUI = require("hall.scene.Layer.LayerRoomCreate").new()
        self.scene:addChild(self.CurFuntionUI,999)
    end
    self.CurFuntionUI:setVisible(true)
end

return LayerFunctionManager