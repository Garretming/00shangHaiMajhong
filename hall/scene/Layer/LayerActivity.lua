--活动
local l_LayerBase = require("hall.scene.Layer.LayerBase")
local activity = class("activity", l_LayerBase)

function activity:ctor()
    self.super.ctor(self)
    
	local root = cc.CSLoader:createNode("hall/scene/res/Layer/LayerActivity.csb")
	self:addChild(root)

	local bg = root:getChildByName("Panel")

    local closeBtn = ccui.Helper:seekWidgetByName(bg,"close_btn")
    closeBtn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            PlayMusicEffect()
        	self:removeLayer()
        end
    end)

    --抽奖按钮
    local zhuangpan_btn = ccui.Helper:seekWidgetByName(bg,"zhuangpan_btn")
    --大转盘
    local zhuangpan = ccui.Helper:seekWidgetByName(bg,"zhuangpan")

    local totalCount = 10  -- 转盘总奖项数  
    local roundCountMin = 5  -- 转动最小圈数  
    local roundCountMax = 8  -- 转动最大圈数  

    local singleAngle = 360 / totalCount  -- 所有奖项概率相同时 这样计算每个奖项占的角度 如果概率不同，可以使用table数组来处理  
    local offsetAngle = 5  -- 为了避免不必要的麻烦，在接近2个奖项的交界处，左右偏移n角度的位置，统统不停留 否则停在交界线上，很难解释清楚 这个值必须小于最小奖项所占角度的1/2  

    -- 设置随机数种子  正常情况下这应该在初始化时做  而不是在调用函数时  
    math.randomseed(os.time())   

    -- 默认随机奖项  
    if stopId == nil or stopId > totalCount then  
    stopId =  math.random(totalCount) -- 产生1-totalCount之间的整数  
    end  

    -- 转盘停止位置的最小角度 不同概率时，直接把之前的项相加即可  
    local angleMin = (stopId-1) * singleAngle  

    -- 转盘转动圈数 目前随机 正常情况下可加入力量元素 根据 移动距离*参数 计算转动圈数  
    local roundCount = math.random(roundCountMin, roundCountMax) -- 产生roundCountMin-roundCountMax之间的整数  

    -- 检查一下跳过角度是否合法 当前奖项角度-2*跳过角度 结果必须>0  TODO  
    -- 转动角度  
    local angleTotal = 360*roundCount + angleMin + math.random(offsetAngle, singleAngle-offsetAngle)  -- 避免掉offsetAngle角度的停留，防止停留在交界线上  
 
    -- 复位转盘  
    zhuangpan:setRotation(0)  


    zhuangpan_btn:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            PlayMusicEffect()
            -- 开始旋转动作  使用EaseExponentialOut(迅速加速，然后慢慢减速)  
            zhuangpan:runAction(cc.EaseExponentialOut:create(cc.RotateBy:create(3.0, angleTotal)))  
        end
    end)
end

return activity