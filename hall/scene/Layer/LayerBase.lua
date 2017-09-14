--LayerBase

local l_LayerFunctionManager = require("hall.scene.Layer.LayerFunctionManager")

local LayerBase = class("LayerBase", function()
    return display.newLayer("LayerBase")
end)

function LayerBase:ctor()
    self:setAnchorPoint(0.5,0.5)
    self:setPosition(cc.p(WinSize.width / 2 , WinSize.height / 2))

    self:setScale(0)
    local stSmall = cc.ScaleTo:create(0.2, 1.1)
    local stNormal = cc.ScaleTo:create(0.1, 1)
    local sq = cc.Sequence:create(stSmall, stNormal)
    self:runAction(sq)
end

--属性
function LayerBase:ScreenLayout(rootNode)
    local director = cc.Director:getInstance()
    local view = director:getOpenGLView()
    local framesize = view:getVisibleSize()
    rootNode:setContentSize(framesize)
    ccui.Helper:doLayout(rootNode)
end

--隐藏图层
function LayerBase:removeLayer()
    local stSmall = cc.ScaleTo:create(0.1, 1.1)
    local stNormal = cc.ScaleTo:create(0.2, 0)
    local sq = cc.Sequence:create(stSmall, stNormal)
    self:runAction(sq)
    
    cc.UserDefault:getInstance():setBoolForKey("isActivity",false)
    performWithDelay(self,function()  
            l_LayerFunctionManager:CloseCurFunctionUI()
    end,0.3)
end

return LayerBase