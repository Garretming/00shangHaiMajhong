local CenterPlaneOperator = class("CenterPlaneOperator")

local CHILD_NAME_TIMER_LB = "timer_lb"
local CHILD_NAME_INDICATOR_PLANE = "indicator_plane"
local CHILD_NAME_INDICATOR_IMG = "indicator_img_1"
local CHILD_NAME_ALARM_CLOCK_IMG = "alarm_clock"
local CHILD_NAME_TIME_IMG = "time"
-- local scheduler_pool

local PLAY_CARD_TIME_MAX = 20
local CONTROL_TIME_MAX = 5

local timer_value = 20

-- local timer_id

-- local turn_timer_id

function CenterPlaneOperator:init(plane)
	plane:setVisible(false)
	
	local timer_lb = plane:getChildByName(CHILD_NAME_TIMER_LB)
	timer_lb:setString("00")
     
    local indicator_plane = plane:getChildByName(CHILD_NAME_INDICATOR_PLANE)
	local indicator_img = indicator_plane:getChildByName(CHILD_NAME_INDICATOR_IMG)
	indicator_img:loadTexture("")
	for _,v in pairs(indicator_plane:getChildren()) do
    	v:setVisible(false)
    end
	timer_lb:stopAllActions()
	indicator_img:stopAllActions()

	indicator_img:setVisible(false)
	-- if not scheduler_pool then
	-- 	--todo
	-- 	scheduler_pool = import("socket.SchedulerPool").new()
	-- end
	
	-- self:stopTimer()
end

function CenterPlaneOperator:clearGameDatas(plane)
	local timer_lb = plane:getChildByName(CHILD_NAME_TIMER_LB)
	timer_lb:setString("00")
    
    local indicator_plane = plane:getChildByName(CHILD_NAME_INDICATOR_PLANE)
	local indicator_img = indicator_plane:getChildByName(CHILD_NAME_INDICATOR_IMG)
	indicator_img:loadTexture("")
	for _,v in pairs(indicator_plane:getChildren()) do
    	v:setVisible(false)
    end

	timer_lb:stopAllActions()
	indicator_img:stopAllActions()

	indicator_img:setVisible(false)
	-- self:stopTimer()
end

function CenterPlaneOperator:changeTurn(playerType, plane)

	local indicator_plane = plane:getChildByName(CHILD_NAME_INDICATOR_PLANE)
    for _,v in pairs(indicator_plane:getChildren()) do
    	v:setVisible(false)
    end
    CHILD_NAME_INDICATOR_IMG = "indicator_img_"..playerType
	local indicator_img = indicator_plane:getChildByName(CHILD_NAME_INDICATOR_IMG)
    indicator_img:setVisible(true)
     
	local myplane = (plane:getParent()):getChildByName("my_card_plane")
	local alarm_clock = myplane:getChildByName(CHILD_NAME_ALARM_CLOCK_IMG)
	local time = alarm_clock:getChildByName(CHILD_NAME_TIME_IMG)

    if playerType == CARD_PLAYERTYPE_MY then


		local showTimerAc = cc.CallFunc:create(function()

		time:setString(timer_value .. "")
        
		-- local shake = cc.shake:create(15, false, ccg(15, 10), 1)
     
  --       alarm_clock:runAction(shake)

		if timer_value == 0 then
			time:stopAllActions()
			alarm_clock:setVisible(false)
		end
		end)

	local seqAc = cc.Sequence:create(cc.DelayTime:create(1), showTimerAc)
	-- if  timer_value < 20  then
	-- 	alarm_clock:setVisible(true)
	-- 	alarm_clock:runAction(cc.RepeatForever:create(seqAc))
	-- end
    
	end

end

function CenterPlaneOperator:beginPlayCard(playerType, plane)
	-- self:stopTimer()
     
    
	self:changeTurn(playerType, plane)

	local timer_lb = plane:getChildByName(CHILD_NAME_TIMER_LB)

	if not timer_lb then
		--todo
		return
	end
    
    local indicator_plane = plane:getChildByName(CHILD_NAME_INDICATOR_PLANE)
    for _,v in pairs(indicator_plane:getChildren()) do
    	v:setVisible(false)
    end
    CHILD_NAME_INDICATOR_IMG = "indicator_img_"..playerType

	local turn_img = indicator_plane:getChildByName(CHILD_NAME_INDICATOR_IMG)
    turn_img:setVisible(true)

	timer_lb:stopAllActions()
	turn_img:stopAllActions()

	timer_value = PLAY_CARD_TIME_MAX

	timer_lb:setString(timer_value .. "")

	local showTimerAc = cc.CallFunc:create(function()
			timer_value = timer_value - 1
			if timer_value<10 then
				timer_lb:setString("0"..timer_value)
			else
				timer_lb:setString(timer_value .. "")
			end
            timer_lb:setScale(1)
			-- if timer_value < 10 and timer_value > 0 then
			-- 	timer_lb:setString(timer_value .. "")
			-- 	timer_lb:scaleTo(0.8, 3)
			-- end

			if timer_value == 0 then
			-- 	require("js_majiang_3d.operator.GamePlaneOperator"):showNetworkImg(playerType,true)
				timer_lb:stopAllActions()
			end
		end)
	local seqAc = cc.Sequence:create(cc.DelayTime:create(1), showTimerAc)
	
	timer_lb:runAction(cc.RepeatForever:create(seqAc))
	timer_lb:addTouchEventListener(
	function(sender,event)
	--触摸开始
	if event == TOUCH_EVENT_ENDED then
	    require("hall.GameCommon"):show_instruction()
	end
	end)


	local showTurnAc = cc.CallFunc:create(function()
			if turn_img:isVisible() then
				--todo
				turn_img:setVisible(false)
			else
				turn_img:setVisible(true)
			end

			-- if timer_value == 0 then
			-- 	--todo
			-- 	turn_img:setVisible(true)
			-- 	turn_img:stopAllActions()
			-- end
		end)

	seqAc = cc.Sequence:create(cc.DelayTime:create(0.5), showTurnAc)
	
	-- turn_img:runAction(cc.RepeatForever:create(seqAc))
end

-- function CenterPlaneOperator:stopTimer()
-- 	if timer_id then
-- 		--todo
-- 		scheduler_pool:clear(timer_id)

-- 		timer_id = nil
-- 	end

-- 	if turn_timer_id then
-- 		--todo
-- 		scheduler_pool:clear(turn_timer_id)

-- 		turn_timer_id = nil
-- 	end
-- end

--旋转座位标志
function CenterPlaneOperator:rotateTimer(zhuang_index,plane)

	--重置标志器指向
	local location_plane = plane:getChildByName("location_plane")
	-- local indicator_img = indicator_plane:getChildByName(CHILD_NAME_INDICATOR_IMG)
     
    
    --dump(zhuang_index,"庄家位置")
	--进行旋转（把东指向庄）
	for playerType = 1,4 do 	
    local location_img = location_plane:getChildByName("location_img_"..playerType)
   	      location_img:loadTexture("js_majiang_3d/image/clock/"..zhuang_index.."_"..playerType..".png")
	end
end

return CenterPlaneOperator