--
-- Author: chenhaiquan
-- Date: 2017-02-14 18:06:21
--

local scheduler = require("framework.scheduler")
local transcribeSceneHandler = require("hall.roomPlay.transcribeScene_handler")
VideoScenedata = {}

local VideoScene=class("VideoScene",function()
        return cc.Node:create(); 
end)
    
function VideoScene:init_hide(rootNode)
    -- body
    local all_item = {"Panel_1","Panel_4"}
    for _,item_name in pairs(all_item) do
       local item =  rootNode:getChildByName(item_name)
       item:setVisible(false)
    end

end

function VideoScene:ctor(datatb,base_scene)
    self.rootNode            = cc.CSLoader:createNode("hall/room_vedioex.csb"):addTo(self)
   --  local Image_10 = self.rootNode:getChildByName("Image_10")
   -- Image_10:onClick(function () print("------------------")end)

    self.game_type = base_scene

    self:init_hide(self.rootNode)
    VideoScenedata = {}
    VideoScenedata.outcard_dict = {}
    VideoScenedata.peng = {}
    VideoScenedata.chi = {}
    VideoScenedata.fanggang = {}
    VideoScenedata.angang = {}
    VideoScenedata.minggang = {}
    VideoScenedata.fei = {}

    self.user_data_dict = {}

    if self.connectTimeTickScheduler then
        scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
        self.connectTimeTickScheduler = nil
    end

    transcribeSceneHandler = transcribeSceneHandler.new(self.game_type )

    self.recent_step = 1
    self.connectTimeTickScheduler = scheduler.scheduleGlobal(handler(self, self.update_step), 3)

    self.datatb = datatb
    self:set_userinfos(datatb)

    self.game_history = datatb["game_history"] or {}

    local step_mesg = self.rootNode:getChildByName("Text_12")
    step_mesg:setString("1/"..tostring(table.nums(self.game_history)))

    local caozuo = self.rootNode:getChildByName("caozuo")
    local Button_1 = caozuo:getChildByName("Button_1")
    Button_1:onClick(function ()
        -- body
        self:onExit()
    end)
end

function VideoScene:update_step_txt( ... )
    -- body
    local step_mesg = self.rootNode:getChildByName("Text_12")
    step_mesg:setString(tostring(self.recent_step - 0 ).."/"..tostring(table.nums(self.game_history)))
end

function VideoScene:update_step()
    -- body
    print("VideoScene:update_step()---------------self.recent_step-----------------",self.recent_step)
    local step_data = self.game_history[self.recent_step] or {}
    local deal_flag = transcribeSceneHandler:deal_handler(self.recent_step,step_data)

    self:update_step_txt()
    if deal_flag == true then
        self.recent_step = self.recent_step + 1
    end

    self:doafter_update()


    if self.recent_step >= table.nums(self.game_history) then
        self:show_result(self.datatb)
        return true
    end
end

function VideoScene:doafter_update()
    -- body
   if VideoScenedata.maker then
        local player = {"Panel_head_0","Panel_head_1","Panel_head_2","Panel_head_3"}
        local player_item = {"Image_3","Text_1","gold","sp_clock","zuan_tip"}
        for index = 1,4 do
             local player =  self.rootNode:getChildByName(player[index])
             print( player.uid,"-------player.uid---------" )
             if player.uid == VideoScenedata.maker then
                local zuan_tip = player:getChildByName(player_item[5])
                zuan_tip:setVisible(true)
             end
        end
        VideoScenedata.maker = nil
   end

   if VideoScenedata.handcard then
        --画玩家手牌
        local Panel_18_shoupai =  self.rootNode:getChildByName("Panel_18_shoupai")
        Panel_18_shoupai:removeAllChildren()

        local userinfos = self.datatb["userinfos"] or {}
        for index,user_data in pairs(userinfos) do
            local uid =  user_data.uid
            uid = tonumber(uid)
            print("uid---------------------",uid)
            local handcard = VideoScenedata.handcard[tonumber(uid)] or {}
            local peng =  VideoScenedata.peng[tonumber(uid)] or {}
            local fei = VideoScenedata.fei[tonumber(uid)] or {}
            local chi =  VideoScenedata.chi[tonumber(uid)] or {}
            local fanggang =  VideoScenedata.fanggang[tonumber(uid)] or {}
            local angang =  VideoScenedata.angang[tonumber(uid)] or {}
            local minggang =  VideoScenedata.minggang[tonumber(uid)] or {}

           -- angang = {101}
           -- dump(handcard,"handcard")
            local pos = cc.p(0,0)

            local card_image = nil
            if index == 1 then
                card_image = self.rootNode:getChildByName("Image_2")
                 pos = cc.p(247.33,27.75)
            elseif index == 2 then
                 card_image = self.rootNode:getChildByName("Image_1")
                 pos = cc.p(823.74,100.85) 

            elseif index == 3 then
                 card_image = self.rootNode:getChildByName("Image_2")
                  pos = cc.p(742.60,487.52)

            elseif index == 4 then
                 card_image = self.rootNode:getChildByName("Image3")
                  pos = cc.p(139.17,464.08) 
            end

            local tbl_pengorgang = {}
            --合并吃
            for _,card_value in pairs(chi) do
                table.insert(tbl_pengorgang,card_value)
            end

            --合并飞
            for _,card_tbl in pairs(fei) do
                local fei_card = card_tbl[1] 
                local laizi_card = card_tbl[2] 
                table.insert(tbl_pengorgang,fei_card)
                table.insert(tbl_pengorgang,fei_card)
                table.insert(tbl_pengorgang,laizi_card)

            end
            
            for _,card_value in pairs(peng) do --合并碰
                table.insert(tbl_pengorgang,card_value)
                table.insert(tbl_pengorgang,card_value)
                table.insert(tbl_pengorgang,card_value)
            end
            for _,card_val in pairs(fanggang) do--合并放杠
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
            end
            
            for _,card_val in pairs(minggang) do--合并明杠
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
                table.insert(tbl_pengorgang,card_val)
            end


            local handcard_num = table.nums(tbl_pengorgang)
            for _,card_value in pairs(tbl_pengorgang) do
                local card = card_image:clone()
                local Image_texture = card:getChildByName("Image_texture")

                local tex = self:get_card_path(card_value)
                Image_texture:loadTexture(tex)
                card:setPosition(cc.p(pos.x,pos.y))
                Panel_18_shoupai:addChild(card)

                if index == 1 then
                     pos.x = pos.x + 28
                elseif index == 2 then
                     pos.y = pos.y + 25
                     card:setLocalZOrder(handcard_num)
                elseif index == 3 then
                    pos.x = pos.x - 28
                elseif index == 4 then
                     pos.y = pos.y - 25
                end
                handcard_num = handcard_num - 1
            end

            --暗杠
            local handcard_num = table.nums(angang)
            for _,card_value in pairs(angang) do

                for angang_index = 1,4 do
                    if angang_index < 4 then
                        local card = card_image:clone()
                        local Image_texture = card:getChildByName("Image_texture")
                        local tex = self:get_card_path(card_value)
                        Image_texture:loadTexture(tex)
                        card:setPosition(cc.p(pos.x,pos.y))
                        Panel_18_shoupai:addChild(card)

                        if index == 1 then
                             pos.x = pos.x + 28
                        elseif index == 2 then
                             pos.y = pos.y + 25
                             card:setLocalZOrder(handcard_num)
                        elseif index == 3 then
                            pos.x = pos.x - 28
                        elseif index == 4 then
                             pos.y = pos.y - 25
                        end
                        handcard_num = handcard_num - 1
                    else
                        local card = ccui.ImageView:create()
                        
                        local tem_pos = cc.p(pos.x,pos.y)
                        if index == 1 then
                             card:loadTexture("hall/majiangCard/top_back_card01.png")
                             tem_pos.x = tem_pos.x - 2*28
                             tem_pos.y = tem_pos.y + 10
                        elseif index == 2 then
                             tem_pos.y = tem_pos.y - 2*25 + 10
                            -- card:setLocalZOrder(handcard_num)
                             card:loadTexture("hall/majiangCard/lr_back_card01.png")
                             
                        elseif index == 3 then
                            tem_pos.x = tem_pos.x + 2 * 28
                            tem_pos.y = tem_pos.y + 10
                             card:loadTexture("hall/majiangCard/top_back_card01.png")

                        elseif index == 4 then
                            tem_pos.y = tem_pos.y + 2 * 25 + 10
                            card:loadTexture("hall/majiangCard/lr_back_card01.png")
                        end
                         card:setPosition(cc.p(tem_pos.x,tem_pos.y))
                        Panel_18_shoupai:addChild(card)
                    end

                end

            end


            if index == 1 then
                 pos.x = pos.x + 28
            elseif index == 2 then
                 pos.y = pos.y + 25
            elseif index == 3 then
                pos.x = pos.x - 28
            elseif index == 4 then
                 pos.y = pos.y - 25
            end

            --handcard = {}
            local zhuacard_tbl = VideoScenedata.zhuacard or {}
            local zhuacard_value = zhuacard_tbl[uid]
            local continue_flag = false

            local handcard_num = table.nums(handcard)
            table.sort(handcard,function(v1,v2) return v1< v2 end)
            for _,card_value in pairs(handcard) do
                if continue_flag == false and card_value == zhuacard_value then
                    continue_flag = true
                else

                    local card = card_image:clone()
                    local Image_texture = card:getChildByName("Image_texture")

                    local tex = self:get_card_path(card_value)
                    Image_texture:loadTexture(tex)
                    self:get_jing_card(Image_texture,card_value)

                    card:setPosition(cc.p(pos.x,pos.y))
                    Panel_18_shoupai:addChild(card)

                    if index == 1 then
                         pos.x = pos.x + 28
                    elseif index == 2 then
                         pos.y = pos.y + 25
                         card:setLocalZOrder(handcard_num)
                    elseif index == 3 then
                        pos.x = pos.x - 28
                    elseif index == 4 then
                         pos.y = pos.y - 25
                    end
                    handcard_num = handcard_num - 1
                end
            end


            if index == 1 then
                 pos.x = pos.x + 28
            elseif index == 2 then
                 pos.y = pos.y + 25
            elseif index == 3 then
                pos.x = pos.x - 28
            elseif index == 4 then
                 pos.y = pos.y - 25
            end


            if zhuacard_value then
                local card = card_image:clone()
                local Image_texture = card:getChildByName("Image_texture")

                local tex = self:get_card_path(zhuacard_value)
                Image_texture:loadTexture(tex)
                card:setPosition(cc.p(pos.x,pos.y))
                Panel_18_shoupai:addChild(card)

            end
        end
   end


   self:update_operator()

   self:update_coutcard()

   self:update_upjingcard()
end

function VideoScene:update_operator()
    -- body

   if VideoScenedata.operor then
       local operatorname = {"Panel_15_0","Panel_15_1","Panel_15_2","Panel_15_3"}
       local op_name_dict = {  ["fei"] = "majong_guo_6",
                               ["ti"] = "majong_guo_5",
                               ["hu"] = "majong_guo_4",
                               ["gang"]= "majong_guo_3",
                               ["peng"]= "majong_guo_2",
                               ["guo"]= "majong_guo_1",
                               ["chi"]= "majong_guo_0"
        }
        local op_name_tex_src_dict = {
                       ["fei"] = "hall/roomPlay/majong_fei_bt_d.png",
                       ["ti"] = "hall/roomPlay/majong_ti_bt_d.png",
                       ["hu"] = "hall/roomPlay/majong_hu_bt_d.png",
                       ["gang"]= "hall/roomPlay/majong_gang_bt_d.png",
                       ["peng"]= "hall/roomPlay/majong_peng_bt_d.png",
                       ["guo"]= "hall/roomPlay/majong_guo_bt_d.png",
                       ["chi"]= "hall/roomPlay/majong_chi_bt_d.png"
        }


        local op_name_tex_dict = {
                               ["hu"] = "hall/roomPlay/majong_hu_bt_n.png",
                               ["gang"]= "hall/roomPlay/majong_gang_bt_n.png",
                               ["peng"]= "hall/roomPlay/majong_peng_bt_p.png",
                               ["guo"]= "hall/roomPlay/majong_guo_bt_n.png",
                               ["chi"]= "hall/roomPlay/majong_chi_bt_n.png",
                               ["fei"]= "hall/roomPlay/majong_fei_bt_p.png",
                               ["ti"]= "hall/roomPlay/majong_ti_bt_p.png"

        }
       --reset
       for index = 1,4 do
            local image_op = self.rootNode:getChildByName(operatorname[index])
            for _name,image_name in pairs(op_name_dict) do
                local child = image_op:getChildByName(image_name)
                if child  ~= nil then
                    child:setTexture(op_name_tex_src_dict[_name])
                end
            end

       end

       for index = 1,4 do
           local image_op = self.rootNode:getChildByName(operatorname[index])
           local uid = image_op.uid
           local op_name_ = VideoScenedata.operor[tonumber(uid)]


           if op_name_ ~= nil then
               VideoScenedata.operor[tonumber(uid)] = nil

               local image_name = op_name_dict[op_name_]
               local child = image_op:getChildByName(image_name)
               child:setTexture(op_name_tex_dict[op_name_])
           end
       end


   end

end

function VideoScene:update_coutcard()
    -- body
    if VideoScenedata.outcard_dict == nil then
        return
    end

    local Panel_21_da =  self.rootNode:getChildByName("Panel_21_da")
    Panel_21_da:removeAllChildren()

    local userinfos = self.datatb["userinfos"] or {}
    for index,user_data in pairs(userinfos) do
        local uid =  user_data.uid
        uid = tonumber(uid)
            local outcard_dict = VideoScenedata.outcard_dict[tonumber(uid)] or {}
            --table.sort(outcard_dict,function(v1,v2) return v1 < v2 end)
           -- dump(outcard_dict,"outcard_dict")
            local pos = cc.p(0,0)
            --outcard_dict = {101,101,101,101,101,101,101,101,101,101,101,101,101,101,101,101,101,101,101,101}
            local card_image = nil
            if index == 1 then
                card_image = self.rootNode:getChildByName("Image_2")
                 pos = cc.p(330,184.58)
            elseif index == 2 then
                 card_image = self.rootNode:getChildByName("Image_1")
                 pos = cc.p(682.08,165.18) 

            elseif index == 3 then
                 card_image = self.rootNode:getChildByName("Image_2")
                  pos = cc.p(634.29,387.74)

            elseif index == 4 then
                 card_image = self.rootNode:getChildByName("Image3")
                  pos = cc.p(286.47,412.07) 
            end

            local outcard_dict_num = table.nums(outcard_dict)
            local _num = 0
            for _,card_value in pairs(outcard_dict) do
                local card = card_image:clone()
                local Image_texture = card:getChildByName("Image_texture")

                local tex = self:get_card_path(card_value)
                Image_texture:loadTexture(tex)
               
                Panel_21_da:addChild(card)
                local tem_pos = cc.p(0,0)
                if index == 1 then
                    tem_pos.x = pos.x + 28 * (_num%10)
                    tem_pos.y = pos.y - math.modf(_num/10) * 35

                elseif index == 2 then
                    tem_pos.y = pos.y + 25 * (_num%10)
                    tem_pos.x = pos.x + math.modf(_num/10) * 37

                     card:setLocalZOrder(outcard_dict_num)
                elseif index == 3 then
                    tem_pos.x = pos.x - 28 * (_num%10)
                    tem_pos.y = pos.y+ math.modf(_num/10) * 35
                    card:setLocalZOrder(outcard_dict_num)
                elseif index == 4 then
                     tem_pos.y = pos.y - 25 * (_num%10)
                     tem_pos.x = pos.x - math.modf(_num/10) * 37
                end 
                card:setPosition(cc.p(tem_pos.x,tem_pos.y))
                outcard_dict_num = outcard_dict_num - 1

                 _num =   _num + 1
            end
    end

end


function VideoScene:update_upjingcard()
    -- body
    
    if self.rootNode:getChildByName("jing1") == nil then
        local tbl = VideoScenedata.game_up_jing_card_list or {}
        local myTeCard = self.rootNode:getChildByName("myTeCard")
        for _index,card_value in pairs(tbl) do
            local upcard1 = myTeCard:clone()
            upcard1:setScale(0.5)

            local Image_14 = upcard1:getChildByName("Image_14")
            local tex = self:get_card_path(card_value)
            Image_14:loadTexture(tex)

            self.rootNode:addChild(upcard1)
            upcard1:setName("jing"..tostring(_index))
            upcard1:setPosition(cc.p(122.20 + (_index - 1) * 20,498.56))

            self:get_jing_card(Image_14,card_value)
        end

    end

end


function VideoScene:get_card_path( card_value )
    -- body
    local card_type = math.modf(card_value / 100)
    local value = math.modf(card_value % 100)
    -- 赣州的风牌
    --     401,401,401,401,    #东
    --     402,402,402,402,    #南
    --     403,403,403,403,    #西
    --     404,404,404,404,    #北
    --     411,411,411,411,    #中
    --     412,412,412,412,    #发
    --     413,413,413,413     #白

    local tb = {
            [1] = "wan",
            [2] = "tong",
            [3] = "tiao",
            [4] = "feng"
    }
    if card_type == 1 or card_type == 2 or card_type == 3 then
        if card_type == 3 then
            value = value + 32
        end

        if card_type == 2 then
            value = value + 16
        end

        return "hall/majiangCard/" ..tb[card_type] .. "/"..value..".png"

    elseif card_type == 4 then 
        local dict = {[401] = "97",[402] = "113",[403] = "129",[404] = "145",
                      [411] = "65_1", [412] = "81", [413] = "50"
        }

        return "hall/majiangCard/" ..tb[card_type] .. "/"..dict[tonumber(card_value)]..".png"
    else
        return ""
    end
end

--设置玩家头像信息
function VideoScene:set_userinfos( datatb )
    -- body
    local userinfos = datatb["userinfos"] or {}
    local player = {"Panel_head_0","Panel_head_1","Panel_head_2","Panel_head_3"}
    local player_item = {"Image_3","Text_1","gold","sp_clock","zuan_tip"}
    local operatorname = {"Panel_15_0","Panel_15_1","Panel_15_2","Panel_15_3"}

    table.sort(userinfos,function (user_data1,user_data2)
        return user_data1.seat_id < user_data2.seat_id
    end)

    for index,user_data in pairs(userinfos) do
        local player =  self.rootNode:getChildByName(player[index])
        player.uid = user_data.uid

        self.rootNode:getChildByName(operatorname[index]).uid = user_data.uid


        local head = player:getChildByName(player_item[1])
        local name = player:getChildByName(player_item[2])
        local gold = player:getChildByName(player_item[3])
        local sp_clock = player:getChildByName(player_item[4])
        local zuan_tip = player:getChildByName(player_item[5])
        sp_clock:setVisible(false)
        zuan_tip:setVisible(false)

        name:setString(user_data["nickName"] or "")
        gold:setString(user_data["chips"] or "")

        self.user_data_dict[tonumber(user_data.uid)] = user_data["nickName"] or ""

        if head then
            local user_inf = {}
            user_inf["uid"] = user_data.uid
            user_inf["icon_url"] =user_data.photoUrl
            user_inf["sex"] = user_data.sex
            user_inf["nick"] = user_data.nickName
            require("hall.GameCommon"):setPlayerHead(user_inf,head,70*0.77)
        end
    end

end

function VideoScene:onExit()
    if self.connectTimeTickScheduler then
        scheduler.unscheduleGlobal(self.connectTimeTickScheduler)
        self.connectTimeTickScheduler = nil
    end

    -- isRun=false
    self:removeFromParent()
end
function VideoScene:get_hu_style( hu_style)
      if hu_style == "pphqqr" then
        return "碰碰胡全求人"
    end
    
    if hu_style ==  "xiaohu" then--#小胡
        return "平胡"
    end

    if hu_style ==  "pph" then--#大胡  碰碰胡
        return "碰碰胡"
    end

    if hu_style ==  "jjh" then--#将将胡
        return "将将胡"
    end

    if hu_style == "qys" then--#清一色
        return "清一色"
    end

    if hu_style ==  "qxd" then--#七小队
        return "七小对"
    end

    if hu_style ==  "hqd" then--#豪华七小对
        return "豪华七小对"
    end

    if hu_style ==  "shqd" then--#双豪华七小对
        return "双豪华七小对"
    end

    if hu_style == "haidi" then--#海底
        return "海底"
    end

    if hu_style ==  "haidipao" then--#海底炮
        return "海底炮"
    end

    if hu_style ==  "gskh" then--#杠上开花
        return "杠上开花"
    end

    if hu_style ==  "qgh" then--#抢杠胡
        return "抢杠胡"
    end

    if hu_style ==  "gsp" then--#杠上炮
        return "杠上炮"
    end
	return ""
end
function VideoScene:show_result( pack )
  -- body
  -- local Panel_20_te = self.rootNode:getChildByName("Panel_20_te")
  -- local item_childens = Panel_20_te:getChildren()
  -- print("item_childens",item_childens,"------nums-----------",table.nums(item_childens))
  -- if table.nums(item_childens) ~= 0 then
  --   return
  -- end


  local group_game_result = pack["group_game_result"] or {}

  local account_data = group_game_result["account_data"] or {}

  local result_item = self.rootNode:getChildByName("Panel_2")
  local Panel_1 = self.rootNode:getChildByName("Panel_1")
  print("Panel_1:isVisible()---------------------",Panel_1:isVisible())
  if Panel_1:isVisible() == true then
     return
  end

    local hu_contet = {}
    for account_id,content in pairs(account_data) do
        local account_id = tonumber(account_id)
        local account_hu_conbination_list = content["account_hu_conbination_list"] or {}
        account_hu_conbination_list = account_hu_conbination_list[1] or {}
        -- dump(account_hu_conbination_list,"account_hu_conbination_list")

        local txt_temp = ""
        if account_hu_conbination_list[1] == 0 then
            txt_temp = "  自摸"
        end

        local hu_com = account_hu_conbination_list[2] or {}

        for _,hu_style in pairs(hu_com) do
            hu_style = self:get_hu_style(hu_style)
            txt_temp = txt_temp .. hu_style.." "
        end

        hu_contet[account_id] = txt_temp
    end



  Panel_1:setVisible(true)
  Panel_1:onClick(function( ... )
      -- body
      local Panel_1 = self.rootNode:getChildByName("Panel_1")
      Panel_1:setVisible(false)
      self:onExit()
  end)

  local ListView_1 =Panel_1:getChildByName("ListView_1")

  local icon_name = {"score2","name"}
  local data_name = {"account_change_chip","account_name"}



  local item_start_pos = cc.p(41.80,380.20)
  local item_base_h = 89
  for _uid,uid_data in pairs(account_data) do
        _uid = tonumber(_uid)
        local item_image = result_item:clone()
        ListView_1:addChild(item_image,10000)
        -- item_image:setName("item_image"..tostring())
       -- item_image:setPosition(cc.p(item_start_pos.x,item_start_pos.y))
        item_start_pos.y = item_start_pos.y - item_base_h

        --分数
        local icon = item_image:getChildByName("score2")
        local account_change_chip = uid_data["account_change_chip"] or 0
        icon:setString(account_change_chip)

        local icon = item_image:getChildByName("name")
        local account_name  = self.user_data_dict[_uid] or ""
        icon:setString(account_name)

        local icon = item_image:getChildByName("score")
        icon:setVisible(false)

        local account_last_ming_gang_list = uid_data["account_last_ming_gang_list"] or {}
        local account_last_fang_gang_dict = uid_data["account_last_fang_gang_dict"] or {}
        local account_last_peng_list = uid_data["account_last_peng_list"] or {}
        local account_last_chi_list = uid_data["account_last_chi_list"] or {}
        local account_last_an_gang_list = uid_data["account_last_an_gang_list"] or {}
        local account_handcard = uid_data["account_handcard"] or {}
        local account_last_fei_dict =  uid_data["account_last_fei_dict"] or {}

        local account_hu_conbination_list = uid_data["account_hu_conbination_list"] or {}
         -- account_last_ming_gang_list =  {101}
         -- account_last_fang_gang_dict =  {102}
         -- account_last_peng_list =  {103}
         -- account_last_chi_list =  {104,05,106}
         -- account_last_an_gang_list =  {107}
         -- account_handcard =  {108,109}

        local pos = cc.p(64.55,34.91)
        local card_width = 29.00

        for card_str,laizi_list in pairs(account_last_fei_dict) do
            for index_card = 1,2 do 
                local card_icon = self:get_result_card(tonumber(card_str),pos)
                   if card_icon ~= nil then
                    item_image:addChild(card_icon)
                    pos.x = pos.x + card_width
                   end
            end

            for _,card_value in pairs(laizi_list) do
                local card_icon = self:get_result_card(tonumber(card_value),pos)
               if card_icon ~= nil then
                item_image:addChild(card_icon)
                pos.x = pos.x + card_width
               end
            end
        end


        for _,card_value in pairs(account_last_ming_gang_list) do
            for index = 1,4 do
               local card_icon = self:get_result_card(card_value,pos)
               if card_icon ~= nil then
                item_image:addChild(card_icon)
                pos.x = pos.x + card_width
               end

            end
        end
        print("pos--------index------",pos.x,"-----",pos.y)
        for _,card_value_lst in pairs(account_last_fang_gang_dict) do
            for _,card_value in pairs(card_value_lst) do
                for index = 1,4 do
                   local card_icon = self:get_result_card(card_value,pos)
                   if card_icon ~= nil then
                    item_image:addChild(card_icon)
                    pos.x = pos.x + card_width
                   end
                end
            end
        end
        print("pos--------index------",pos.x,"-----",pos.y)
        for _,card_value in pairs(account_last_peng_list) do
            for index = 1,3 do
               local card_icon = self:get_result_card(card_value,pos)
               if card_icon ~= nil then
                item_image:addChild(card_icon)
                pos.x = pos.x + card_width
               end

            end
        end
        print("pos--------index------",pos.x,"-----",pos.y)
        for _,card_value_lst in pairs(account_last_chi_list) do
           for _,card_value in pairs(card_value_lst) do
               local card_icon = self:get_result_card(card_value,pos)
               if card_icon ~= nil then
                item_image:addChild(card_icon)
                pos.x = pos.x + card_width
               end
           end
        end
        print("pos--------index------",pos.x,"-----",pos.y)
        for _,card_value in pairs(account_last_an_gang_list) do
            for index = 1,4 do
                local card_icon
                if index == 2 then
                    card_icon = ccui.ImageView:create()

                    card_icon:loadTexture("hall/majiangCard/top_back_card01.png")
                     card_icon:setPosition(cc.p(pos.x,pos.y))
                else

                    card_icon = self:get_result_card(card_value,pos)
                end
                print("pos--------index------",index,pos.x,"-----",pos.y)
                if card_icon ~= nil then
                item_image:addChild(card_icon)
                pos.x = pos.x + card_width
                end
            end
        end
        pos.x = pos.x + card_width

        for _,card_value in pairs(account_handcard) do
           local card_icon = self:get_result_card(card_value,pos)
           if card_icon ~= nil then
            item_image:addChild(card_icon)
            pos.x = pos.x + card_width
           end
        end


        local des_txt = ""

        if table.nums(account_last_ming_gang_list) > 0 then
            des_txt = des_txt .. "明杠x"..tostring(table.nums(account_last_ming_gang_list))
        end

        if table.nums(account_last_an_gang_list) > 0 then
            des_txt = des_txt .. "暗杠x"..tostring(table.nums(account_last_an_gang_list))
        end
        
        if table.nums(account_last_fang_gang_dict) > 0 then
            des_txt = des_txt .. "放杠x"..tostring(table.nums(account_last_fang_gang_dict))
        end 
        des_txt = des_txt .. hu_contet[tonumber(_uid)]


        local des = item_image:getChildByName("des")
        des:setString(des_txt)
        print("------------------------des_txt------------------------",des_txt)

        --break;
        local hu_icon = item_image:getChildByName("Image_8")
        account_hu_conbination_list =  account_hu_conbination_list[1] or {}
        account_hu_conbination_list = account_hu_conbination_list[1]
        if account_hu_conbination_list ~= nil then
            hu_icon:setVisible(true)
        else
            hu_icon:setVisible(false)
        end

        local zuan_icon = item_image:getChildByName("zuan")
        if tonumber(_uid) == tonumber(VideoScenedata.maker) then
            zuan_icon:setVisible(true)
        else
             zuan_icon:setVisible(false)
        end

  end

     --游戏名字
    local game_type = self.game_type or ""
    local Text_9_0 = Panel_1:getChildByName("Text_9_0")
    Text_9_0:setString(game_type)

    --Text_9 房间号
    local Text_9 = Panel_1:getChildByName("Text_9")
     Text_9:setString("")

    --游戏config
    local Text_9_0_0 = Panel_1:getChildByName("Text_9_0_0")
    Text_9_0_0:setString("")

    --游戏时间
    local Text_9_0_0_0 = Panel_1:getChildByName("Text_9_0_0_0")
    Text_9_0_0_0:setString("")
        
end

function VideoScene:get_result_card( card_value,pos )
    -- body
    local Image_4 = self.rootNode:getChildByName("Image_4")
    local card = Image_4:clone()
    local Image_texture = card:getChildByName("Image_14")

    local tex = self:get_card_path(card_value)
    Image_texture:loadTexture(tex)
    card:setPosition(cc.p(pos.x,pos.y))

    return card
end

function VideoScene:get_jing_card( card_icon,card_value)
    -- body
    local find_flag = false
    local tbl = VideoScenedata.game_up_jing_card_list  or {}
    for _,card_value_tem in pairs(tbl) do
        if card_value == card_value_tem then
            find_flag = true
            break;
        end
    end

    if find_flag == true then
        local jing = ccui.ImageView:create()
        jing:loadTexture("hall/roomPlay/lai.png")
        card_icon:addChild(jing)
        jing:setPosition(cc.p(50,58))
    end
end

return VideoScene