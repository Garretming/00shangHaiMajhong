
ResultEffectLayout = class("ResultEffectLayout")

local scale = 1.1
local cardspace 
-- = 74.6 *scale
local boxwidth = 171.00*scale
local boxheight = 110.0*scale

local screenWidth = 1280
local screenHeight = 720

function ResultEffectLayout:reset_niaocard_data(cards_tbl,zhongcard)
    -- body
    self.layout = cc.CSLoader:createNode("js_majiang_3d/result_effect.csb")
    -- self.layout:setScale(0.75)
    local zhong_tbl = {}
    zhongcard = zhongcard or {}
    for _,card in pairs(zhongcard)do
        zhong_tbl[card] = 1
    end

    self.result_effect_bg = self.layout:getChildByName("result_effect_bg")
    self.result_effect_item = self.layout:getChildByName("result_effect_item")

    local cards_num = table.nums(cards_tbl)
    local cards_num_half = math.modf(cards_num / 2)   --几对牌
    local cards_num_less = cards_num % 2

    local effect_base_w_cm

    if cards_num<=8 then
        effect_base_w_cm = cards_num
    else
        effect_base_w_cm = 8
    end
    
    local weitiaoX = 15
    local weitiaoY = 20

    --设置黑框大小，没毛病
    local effect_base_w = boxwidth/2 *effect_base_w_cm
          cardspace = boxwidth/2
    local effect_base_h = boxheight*(math.floor(cards_num/8.01)+1)
    self.result_effect_bg:setContentSize(cc.size(effect_base_w,effect_base_h))
    self.result_effect_bg:setPosition(635+ weitiaoX,360+ weitiaoY)
  
  
    -- local x_cards_num_change = {[0]=0,[1]=40,[2]=65,[3]=49,[4]=73,[5]=60,[6]=78}
    -- local x_cards_num_change_cm = x_cards_num_change[cards_num] or 78
    --74.6为牌的间隔
    local x = screenWidth/2 - effect_base_w/2 + weitiaoX
    -- - x_cards_num_change_cm
    -- - (480 - 411.56)
    local y = screenHeight/2 + effect_base_h/2

    local lineNum = math.floor(cards_num/8.01) +1


    if cards_num_less == 0 then  --偶数  个
        x = x - (cards_num_less)*cardspace
    else                         --奇数  个
        x = x + cardspace/2
        x = x - (cards_num_less-0.5)*cardspace
    end
     
    local x_store = x
    
    local time_deley = 0
    for i,card_value in pairs(cards_tbl) do
          local result_effect_item = self.result_effect_item:clone() 
          result_effect_item:setScale(scale)   
          
          local iLine =math.floor(i/8.01)

          x_store = x + (i%8.01-1)*cardspace
          y =  screenHeight/2 + effect_base_h/2 - effect_base_h/lineNum*iLine + weitiaoY

          result_effect_item:setPosition(cc.p(x_store,y))

        if card_value ~= nil and card_value ~= 0 then
            local image_tx = "js_majiang_3d/image/card/" .. card_value .. ".png"
            local result_effect_card = result_effect_item:getChildByName("result_effect_card")
            local result_effect_center = result_effect_item:getChildByName("result_effect_center")
            local result_effect_base = result_effect_item:getChildByName("result_effect_base")

            local result_effect_value = result_effect_card:getChildByName("result_effect_value")
            result_effect_value:loadTexture(image_tx)

            self.layout:addChild(result_effect_item)

            result_effect_card:setVisible(false)
            result_effect_center:setVisible(false)

            local action2 = cc.Sequence:create(cc.DelayTime:create(time_deley + 0.3),cc.Hide:create())
            result_effect_base:runAction(action2)


            local result_effect_center_x = result_effect_center:getPositionX()
            local result_effect_center_y = result_effect_center:getPositionY()
            local action_move_up = cc.MoveTo:create(0.1,cc.p(result_effect_center_x,result_effect_center_y+50))
            local action_move_down = cc.MoveTo:create(0.1,cc.p(result_effect_center_x,result_effect_center_y))

            local action3 = cc.Sequence:create(cc.DelayTime:create(time_deley +0.3),cc.Show:create(),action_move_up,action_move_down,cc.DelayTime:create(0.05),cc.Hide:create())
            result_effect_center:runAction(action3)

            local action4 = cc.Sequence:create(cc.DelayTime:create(time_deley + 0.5),cc.Show:create())
            result_effect_card:runAction(action4)


            time_deley = time_deley + 0.5

            if zhong_tbl[card_value] == 1 then
              result_effect_card:setColor(cc.c3b(250,250,0))
            end
        end
    end

    self.layout:setName("zhuaniaoLayout")
    SCENENOW["scene"]:addChild(self.layout)

    return time_deley
end

return ResultEffectLayout