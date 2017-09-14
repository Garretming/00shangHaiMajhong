local animView = class("animView")

local gift_arr

local audioEngine =cc.SimpleAudioEngine:getInstance()

local spriteFrame = cc.SpriteFrameCache:getInstance( )  
spriteFrame:addSpriteFrames("hall/view/animView/image/animate.plist" ) 

function animView:addView(view, x, y, uid_to)

	if view then

		local s = view:getChildByName("animView")
	    if s then
	        s:removeSelf()
	    end

	    if gift_arr == nil then
	    	self:InitData()
	    end

	    s = cc.CSLoader:createNode("hall/view/animView/animViewLayer.csb")
    	s:setName("animView")
    	s:setAnchorPoint(0, 1)
    	s:setPosition(x, y)
    	view:addChild(s)

    	local title_tt = s:getChildByName("title_tt")

    	local content_sv = s:getChildByName("content_sv")
    	local content_ly = content_sv:getChildByName("content_ly")
        

        local function touchEvent(sender, event)
            if event == TOUCH_EVENT_BEGAN then
               sender:setScale(0.9)
            end

            if event == TOUCH_EVENT_CANCELED then
               sender:setScale(1.0)
            end

            if event == TOUCH_EVENT_ENDED then
               sender:setScale(1.0)
               local expressionType = sender:getTag() or 1
               local expression_table = {}
                     expression_table["uid_from"] = USER_INFO["uid"]
                     expression_table["uid_to"] = uid_to or 1
                     expression_table["expressionType"] = expressionType
                     expression_table["msgType"] = "expression"
                     
               local currentGameLevel = USER_INFO["GroupLevel"] or 40
                     dump(USER_INFO["uid"], "发送人的UID")
                     dump(currentGameLevel,"发送的游戏level")                  
               local msg = json.encode(expression_table)
               local pack = bm.server:createPacketBuilder(0x166)      --CLIENT_CMD_SEND_MSG_TO_SERVER 协议 
                            :setParameter("level",currentGameLevel)
                            :setParameter("msg", msg)
                            :build()

                bm.server:send(pack)
                local s = SCENENOW["scene"]:getChildByName("userInfoView")
                if s then
                    s:removeSelf()
                end

            end
        end


    	if #gift_arr > 0 then
    		
    		for k,v in pairs(gift_arr) do

    			local button = ccui.Button:create()
                button:setTouchEnabled(true)
                button:setAnchorPoint(cc.p(0.5, 0.5))
                button:setPosition((k - 1) * 80 + 40, -40)
                button:loadTextures(v["giftPicPath"], nil, nil)
                content_ly:addChild(button)
                button:setTag(k)

                button:addTouchEventListener(touchEvent)
    		end

    		content_sv:setCascadeOpacityEnabled(true)
            content_sv:setInnerContainerSize(cc.size(#gift_arr * 80 + 20, 100))
            if #gift_arr > 6 then
                content_ly:setPosition(0, 100)
            end

    	end
		
	end

end

local isPlaying = false -- 播放标识

--通过位置播放交互动画
function animView:ShowAnimationByPosition(playA_x, playA_y, playB_x, playB_y, expressionType)
   local  playA_x = playA_x or 0
   local  playA_y = playA_y or 0

   local  playB_x = playB_x or 0
   local  playB_y = playB_y or 0
   local  expressionType =  expressionType or 1
                      
   if not gift_arr or not(next(gift_arr)) or isPlaying then
       self:InitData()
   end

   local  animTable =  gift_arr[expressionType]
          dump(animTable, "animTable")
   local  animSprite = cc.Sprite:createWithSpriteFrameName(animTable["animStartPic"])
          -- animSprite:setScale(1.15)
   SCENENOW["scene"]:addChild(animSprite,999)

          -- dump(playA_x,"玩家A坐标")
          -- dump(playA_y,"玩家A坐标")

          -- dump(playB_x,"玩家B坐标")
          -- dump(playB_y,"玩家B坐标")
    animSprite:setPosition(playA_x,playA_y)
    if (playA_x < playB_x and animTable["direction"]~="right") or ( playA_x > playB_x and animTable["direction"]=="right") then   
        animSprite:setFlipX(true)
    end
  
   local  Action
   local  throwTime
   

   --飞行动画
   if animTable["playStyle"]=="set" then
      Action = cc.CallFunc:create(function() 
        animSprite:setPosition(playB_x,playB_y) 
      end)

   else
   
      local  fixTime = math.random(1700,2200)
             throwTime = math.sqrt((playA_x - playB_x)^2+(playA_y - playB_y)^2)/fixTime

      local randomActionChoose = math.random(1,2)    --随机选择动作
      local ActionJump = cc.JumpTo:create(throwTime, cc.p(playB_x, playB_y), 50, 1) 
      
      -----------------
      local radian = math.random(50,70)*3.14159/180
      local height = math.random(30,50)
      local q1x = playA_x+(playB_x - playA_x)/4
      local q1 = cc.p(q1x,height + playA_y+math.cos(radian)*q1x)

      local q2x = playA_x+(playB_x - playA_x)/1.6
      local q2 = cc.p(q2x,height + playA_y+math.cos(radian)*q2x)
      local ActionBezier = cc.BezierTo:create(throwTime,{q1, q2,cc.p(playB_x, playB_y)})

      Action = select(randomActionChoose,ActionJump,ActionBezier)  
   end
     
   --扔动画的额外动画
   local SpawnAction 
   if animTable["playStyle"]=="throw" then
     local rotateAc =  cc.RotateTo:create(throwTime, math.random(2,4)*360)
      SpawnAction = cc.Spawn:create(Action,rotateAc)
   else
      SpawnAction = Action
   end
   
   --执行帧动画
   local  callFunc = cc.CallFunc:create(function()
          -- animSprite:setScale(1.05)

          animSprite:setPosition(playB_x,playB_y)
          OnAction(animSprite,animTable)
          audioEngine:playEffect("hall/view/animView/image/effectSound/"..animTable["giftName"]..".mp3",false)
   end)
   
   if animTable["giftName"] == "dog" then
       audioEngine:playEffect("hall/view/animView/image/effectSound/dog2.mp3",false)
   end
   --动画序列
   local  seq = cc.Sequence:create(SpawnAction,cc.DelayTime:create(0.3),callFunc)
   animSprite:runAction(seq)


   --玫瑰单独的特效
   if   animTable["giftName"] == "rose"  then   
       local  animSprite = cc.Sprite:createWithSpriteFrameName("effect_guang.png") 
       SCENENOW["scene"]:addChild(animSprite,998)
               animSprite:setVisible(false)
               animSprite:setPosition(playB_x,playB_y)
               -- animSprite:setAnchorPoint(0.5,0.5)
               -- animSprite:setScale(1)
               
       local  callFunc1 = cc.CallFunc:create(function() 
                    animSprite:setVisible(true)
                end)
       local  callFunc2 = cc.CallFunc:create(function() 
                    animSprite:removeFromParent()
                end)
       local  rotateAc = cc.RotateBy:create(animTable["DelayPerUnit"]*animTable["animNum"],360)
       local  seq = cc.Sequence:create(cc.DelayTime:create(throwTime+0.3),callFunc1,rotateAc,callFunc2)
          animSprite:runAction(seq)
   end



end


--播放帧动画
function OnAction(animSprite,animTable)  
        
       if not isPlaying then  
            
             isPlaying = true

            local beginNum = animTable["beginNum"] or 1
            local endNum = animTable["animNum"]
            local DelayPerUnit = animTable["DelayPerUnit"] or 0.15 
            
             --///////////////动画开始//////////////////////   
            local animation = cc.Animation:create()  
            for i=beginNum, endNum do  
           
            ----------单张图片加载方式，不推荐-------------------
            --     local frameName = animTable["animResPath"]..i..".png"  
            --     local CCRect=cc.rect(0, 0, 300,300)
            --     local spriteFrame = cc.SpriteFrame:create(frameName,CCRect) 
            
            --------------plist加载方式-------------------
                local spriteFrame = spriteFrame:getSpriteFrame(animTable["giftName"]..i..".png")  
                animation:addSpriteFrame(spriteFrame) 

            end  
            ------------------------------------------------------------------------------
             if animTable["animEndPic"] then 
                 local spriteFrame = spriteFrame:getSpriteFrame(animTable["animEndPic"])      
                 animation:addSpriteFrame(spriteFrame) 
             end


           animation:setDelayPerUnit(DelayPerUnit)          --设置两个帧播放时间                    
           animation:setRestoreOriginalFrame(false)    --动画执行后还原初始状态           

            local  callFunc2 = cc.CallFunc:create(function() 
                dump("释放动画对象")    
                animSprite:removeFromParent()
            end)


            local  action =cc.Animate:create(animation) 
            local  seq  =  cc.Sequence:create(action,cc.DelayTime:create(0.7),callFunc2)               
            animSprite:runAction(seq)                                                    
            --//////////////////动画结束///////////////////  

            isPlaying = false  
       else  
            dump("暂停播放动画")
            animSprite:stopAllActions()  
            animSprite:removeFromParent()                                                                                                
            isPlaying = false  
       end  
end 

--通过用户ID播放交互动画
function animView:ShowAnimationByUid(uid_a, uid_b, animTable)

end

function animView:InitData()

	gift_arr = {}

    local boom = {}   --1
    boom["giftName"] = "boom"
    boom["giftPicPath"] = "hall/view/animView/image/list/" .. "boom" .. ".png"
    boom["animResPath"] = "hall/view/animView/image/boom/"
    boom["animStartPic"] = "boom.png"
    boom["animEndPic"] = "eyes.png"
    boom["animNum"] = 6           --图片数量
    boom["DelayPerUnit"] = 0.17   --帧间隔，不设的话则为0.15
    boom["playStyle"] = "throw"   --第一帧图片播放方式
    boom["direction"] = "left"    --图片朝向
    table.insert(gift_arr, boom)

    local chicken = {}
    chicken["giftName"] = "chicken"
    chicken["giftPicPath"] = "hall/view/animView/image/list/" .. "chicken" .. ".png"
    chicken["animResPath"] = "hall/view/animView/image/chicken/"
    chicken["animStartPic"] = "hand.png"
    chicken["animEndPic"] = "chicken.png"
    chicken["animNum"] = 9
    chicken["DelayPerUnit"] = 0.2
    chicken["playStyle"] = "set"
    chicken["direction"] = "left" 

    table.insert(gift_arr, chicken)

    local dog = {}
    dog["giftName"] = "dog"
    dog["giftPicPath"] = "hall/view/animView/image/list/" .. "dog" .. ".png"
    dog["animResPath"] = "hall/view/animView/image/dog/"
    dog["animStartPic"] = "dog.png"
    dog["animEndPic"] = "eyes.png"
    dog["animNum"] = 4
    dog["DelayPerUnit"] = 0.27
    dog["playStyle"] = "jump"
    dog["direction"] = "left" 

    table.insert(gift_arr, dog)

    local rose = {}
    rose["giftName"] = "rose"
    rose["giftPicPath"] = "hall/view/animView/image/list/" .. "rose" .. ".png"
    rose["animResPath"] = "hall/view/animView/image/rose/"
    rose["animStartPic"] = "rose.png"
    rose["animEndPic"] = "effect_star.png"
    rose["animNum"] = 11
    rose["DelayPerUnit"] = 0.15
    rose["playStyle"] = "fly"
    rose["direction"] = "left" 

    table.insert(gift_arr, rose)

    local egg = {}
    egg["giftName"] = "egg"
    egg["giftPicPath"] = "hall/view/animView/image/list/" .. "egg" .. ".png"
    egg["animResPath"] = "hall/view/animView/image/egg/"
    egg["animStartPic"] = "egg.png"
    egg["animEndPic"] = "eyes.png"
    egg["animNum"] = 5
    egg["DelayPerUnit"] = 0.3
    egg["playStyle"] = "throw"
    egg["direction"] = "left" 

    table.insert(gift_arr, egg)

    local tomato = {}
    tomato["giftName"] = "tomato"
    tomato["giftPicPath"] = "hall/view/animView/image/list/" .. "tomato" .. ".png"
    tomato["animResPath"] = "hall/view/animView/image/tomato/"
    tomato["animStartPic"] = "tomato.png"
    tomato["animEndPic"] = "eyes.png"
    tomato["animNum"] = 3
    tomato["DelayPerUnit"] = 0.25
    tomato["playStyle"] = "throw" 
    tomato["direction"] = "left"

    table.insert(gift_arr, tomato)

    local water = {}
    water["giftName"] = "water"
    water["giftPicPath"] = "hall/view/animView/image/list/" .. "water" .. ".png"
    water["animResPath"] = "hall/view/animView/image/water/"
    water["animStartPic"] = "water1.png"
    water["animEndPic"] = "eyes.png"
    water["animNum"] = 13
    water["DelayPerUnit"] = 0.15
    water["playStyle"] = "set" 
    water["direction"] = "right" 

    table.insert(gift_arr, water)

end

function animView:removeView(view)

	if view then

		local s = view:getChildByName("animView")
	    if s then
	        s:removeSelf()
	    end
		
	end

end

return animView
