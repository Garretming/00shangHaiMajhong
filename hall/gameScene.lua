
local gameScene = class("gameScene", function()
    return display.newScene("gameScene")
end)

local game_scroll
local time =0.3 --帧率
local num =6    -- 数量

function gameScene:ctor()
   
    --@zc 缓存
  -- display.addSpriteFrames("hall/images/Plist.plist", "hall/images/Plist.png")



   self.scene = require("hall.scene.Layer.LayerFunctionManager").new(self)

    if device.platform == "windows" then
        isShowErrorScene = true
        showDumpData = true
    else
        isShowErrorScene = true
        showDumpData = false

    end

    bm.isInGame = false
  
    local s
    if device.platform == "ios" then
        if isiOSVerify then
            s = cc.CSLoader:createNode(GameSceneCsb_filePath):addTo(self)
        else
            s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. GameSceneCsb_filePath):addTo(self)
        end
    else
        s = cc.CSLoader:createNode(GameSceneCsb_filePath):addTo(self)
    end

    self._scene = s

    local top_base = self._scene:getChildByName("top_base")
    --房卡区域
    local btn_add_score = top_base:getChildByName("fangka_ly")
    local add_9_gold = btn_add_score:getChildByName("buyCard_bt")
    local txt_score = btn_add_score:getChildByName("fangka_tt")
    txt_score:setString("")

    --积分区域
    local jifen_ly = top_base:getChildByName("jifen_ly")
    local jifen_tt = jifen_ly:getChildByName("jifen_tt")
    jifen_tt:setString("")

    --顶部按钮
    local btn_share = top_base:getChildByName("btn_share")
    local btn_help = top_base:getChildByName("btn_help")
    local btn_message = top_base:getChildByName("btn_message")
    local btn_record = top_base:getChildByName("btn_record")
    local btn_setting = top_base:getChildByName("btn_setting")
    local btn_shiming = top_base:getChildByName("btn_kefu")
    local btn_rankingList =top_base:getChildByName("btn_RankingList")
    local btn_daili=top_base:getChildByName("btn_daili")
    local btn_shop=top_base:getChildByName("btn_shop")
    local btn_activity=top_base:getChildByName("btn_activity")
    local btn_wentifankui=top_base:getChildByName("btn_program")

    --加入房间按钮
    local btn_join = self._scene:getChildByName("join_bt")

    --创建房间按钮
    local btn_create = self._scene:getChildByName("create_bt")
    local btn_2d = self._scene:getChildByName("btn_2d")
    local btn_puke = self._scene:getChildByName("btn_puke")

    --如果当前是上架模式，则隐藏房卡区域和分享按钮
    if isiOSVerify then
        btn_add_score:setVisible(false)
        jifen_ly:setVisible(false)
        btn_share:setVisible(false)
        btn_shiming:setVisible(false)
    end

    --点击事件事件
    local function touchEvent(sender, event)

        if event == TOUCH_EVENT_BEGAN then
            if sender ~= btn_add_score and sender ~= btn_join and sender ~= btn_create then 
                sender:setScale(0.8)
            end
        end

        if event == TOUCH_EVENT_CANCELED then
            sender:setScale(1.0)
        end

        if event == TOUCH_EVENT_ENDED then
            sender:setScale(1.0)
            require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)


            if sender == btn_setting then
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                --设置
                require("hall.GameCommon"):showSettings(true,true)
               
            elseif sender == add_9_gold then --@zc20170708 购买房卡
            -- self:showBuyCardScene()
            
            elseif sender == btn_2d then
              
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                if bm.notCheckReload == 1 then
                    dump("返回房间", "-----检查是否有存在组局-----")

                    cct.createHttRq({
                    url=HttpAddr .. "/viewReganizeHistory",
                    date={
                        userId = USER_INFO["uid"]
                    },
                    type_= "POST",
                    callBack = function(data)
                        
                        local data_netData = data.netData

                        if data_netData == nil then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --检查是否有未结束组局
                        local tbHistory = {}
                        data_netData = json.decode(data_netData)
                        for k,v in pairs(data_netData.data) do
                            if v.status == nil or v.status ~= "2" then
                                table.insert(tbHistory, v)
                            end
                        end
                        dump(tbHistory, "-----当前用户未结束的组局-----")

                        --如果没有组局历史
                        if #tbHistory == 0 then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --有未结束组局，进入最后一次加入的未结束组局
                        for k, v in pairs(tbHistory) do
                            if k == 1 then
                                require("hall.groudgamemanager"):join_freegame(USER_INFO["uid"], v["inviteCode"], v["activityId"], true, v["level"], true)
                                return
                            end
                        end

                    end
                })

                else
                    require(CreateGroup_filePath):CreateScene(3)

                end
            elseif sender == btn_puke then
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                if bm.notCheckReload == 1 then
                    dump("返回房间", "-----检查是否有存在组局-----")

                    cct.createHttRq({
                    url=HttpAddr .. "/viewReganizeHistory",
                    date={
                        userId = USER_INFO["uid"]
                    },
                    type_= "POST",
                    callBack = function(data)
                        
                        local data_netData = data.netData

                        if data_netData == nil then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --检查是否有未结束组局
                        local tbHistory = {}
                        data_netData = json.decode(data_netData)
                        for k,v in pairs(data_netData.data) do
                            if v.status == nil or v.status ~= "2" then
                                table.insert(tbHistory, v)
                            end
                        end
                        dump(tbHistory, "-----当前用户未结束的组局-----")

                        --如果没有组局历史
                        if #tbHistory == 0 then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --有未结束组局，进入最后一次加入的未结束组局
                        for k, v in pairs(tbHistory) do
                            if k == 1 then
                                require("hall.groudgamemanager"):join_freegame(USER_INFO["uid"], v["inviteCode"], v["activityId"], true, v["level"], true)
                                return
                            end
                        end

                    end
                })

                else
                    require(CreateGroup_filePath):CreateScene(1)

                end
            elseif sender == btn_create then 
                --创建组局(创建房间、返回房间)
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                if bm.notCheckReload == 1 then
                    dump("返回房间", "-----检查是否有存在组局-----")

                    cct.createHttRq({
                    url=HttpAddr .. "/viewReganizeHistory",
                    date={
                        userId = USER_INFO["uid"]
                    },
                    type_= "POST",
                    callBack = function(data)
                        
                        local data_netData = data.netData

                        if data_netData == nil then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --检查是否有未结束组局
                        local tbHistory = {}
                        data_netData = json.decode(data_netData)
                        for k,v in pairs(data_netData.data) do
                            if v.status == nil or v.status ~= "2" then
                                table.insert(tbHistory, v)
                            end
                        end
                        dump(tbHistory, "-----当前用户未结束的组局-----")

                        --如果没有组局历史
                        if #tbHistory == 0 then

                            bm.notCheckReload = 0
                            btn_create:loadTextures(CreateGroupButtonPic_filePath, nil, nil)

                            return

                        end

                        --有未结束组局，进入最后一次加入的未结束组局
                        for k, v in pairs(tbHistory) do
                            if k == 1 then
                                require("hall.groudgamemanager"):join_freegame(USER_INFO["uid"], v["inviteCode"], v["activityId"], true, v["level"], true)
                                return
                            end
                        end

                    end
                })

                else
                    require(CreateGroup_filePath):CreateScene(2)

                end

            elseif sender == btn_join then
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                if bm.notCheckReload == 1 then
                    require(CommonTips_filePath):showTips("提示", "", 3, "你当前有未结束的组局，不能加入其他房间")

                else
                    require(JoinGroup_filePath):showScene()
                end
            elseif sender == btn_rankingList then   --@zc20170708 牛人榜需要做成按钮点击模式
                 self:queryRankList()
                --local buyCardScene=cc.CSLoader:createNode(Text_csb):addTo(self)
            elseif sender == btn_share then 
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                --分享
                require(Share_filePath):showShareLayerInHall("【乐在棋中棋牌】", "http://download.doudougame.cn/app/index.html", "url", "全国人民都爱玩的麻将游戏，简单好玩，随时随地组局，亲们快快加入吧！猛戳下载！")
            
            elseif sender == btn_message then 
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
               
                require(CommonTips_filePath):showTips("消息", "", 3, "亲爱的玩家：                                   近来有不法分子在百度，搜狗，谷歌等浏览器和搜索网站宣传冒充乐在其中麻将的推广员，为了避免病毒植入你的电脑或者是手机，请大家注意防范，避免损失，如果有任何疑问，请联系客服或者代理deng853344533    jkr554943052  liuxian584520，同时有些玩家担心游戏有外挂，本游戏在此申明，本游戏绝无外挂，请大家放心的使用")

            elseif sender == btn_help then  --玩法介绍
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                require(Introduce_filePath):showScene()
            --@zc 201707010 代理页面 btn_shop
            elseif sender == btn_daili then  
                
                self:showDailiScene()
            elseif sender == btn_shop then
                self:showBuyCardScene()

            elseif sender == btn_activity then  
            
              self:showActivityScene()
            elseif sender == btn_record then
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                --战绩
                require(Result_filePath):showHistoryLayer()

            elseif sender == btn_shiming then  --btn_wentifankui
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3") 
                self:shiming()
            elseif sender == btn_wentifankui then
                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                --问题反馈
                self:wentifankui()

            end
        end
    end
 
    btn_setting:addTouchEventListener(touchEvent)
    btn_add_score:addTouchEventListener(touchEvent)
    add_9_gold:addTouchEventListener(touchEvent)
    btn_join:addTouchEventListener(touchEvent)--加入组局
    btn_create:addTouchEventListener(touchEvent)--创建组局
    btn_share:addTouchEventListener(touchEvent)
    btn_message:addTouchEventListener(touchEvent)
    btn_help:addTouchEventListener(touchEvent)
    btn_record:addTouchEventListener(touchEvent)
    btn_shiming:addTouchEventListener(touchEvent)
    btn_puke:addTouchEventListener(touchEvent)
    btn_2d:addTouchEventListener(touchEvent)
    btn_rankingList:addTouchEventListener(touchEvent)
    --@zc 20170710  滑动代理页面制作
    btn_daili:addTouchEventListener(touchEvent)
    btn_shop:addTouchEventListener(touchEvent)
    btn_activity:addTouchEventListener(touchEvent)
    btn_wentifankui:addTouchEventListener(touchEvent)
    --校验用户，成功返回hall的ip和port
    if s:getChildByName("layout_loading") then
        s:removeChildByName("layout_loading")
    end

    --获取游戏分类列表
    require(Request_filePath):getGameType()

    --获取游戏列表
    bm.isConnectBytao = false
    require(Request_filePath):getGameList()

    --获取组局配置
    require(Request_filePath):getCreateGroupGameConfig()

    --通知原生已进入大厅
    cct.getDateForApp("nowInHall", {}, "V")

    --检查当前用户是否绑定代理
    local table = {}
    table["type"] = "0"
    table["device"] = "1"
    table["userId"] = USER_INFO["uid"]
    table["interfaceType"] = "J"    
end
--@zc 20170724 胡牌之后播放龙动画
function gameScene:showDragonAnimation(now_scene)
    display.addSpriteFrames("hall/images/Long.plist", "hall/images/Long.png")
    local pic_num = 44
    local time =0.07
    local node_animation=cc.Node:create()
          node_animation:setPosition(display.cx-250,display.cy)
          now_scene:addChild(node_animation)
    local sprite =display.newSprite("#1.png")
    sprite:setPosition(cc.p(0, -12))
   -- sprite:setAnchorPoint(0.5,0.5)
    local frames = display.newFrames("%d.png", 1, pic_num)
    local animation = display.newAnimation(frames, time)
    sprite:playAnimationOnce(animation) 
    --sprite:playAnimationForever(animation) 
    node_animation:setScale(2.5)
    node_animation:addChild(sprite)
    require("hall.GameCommon"):playEffectSound("hall/long.mp3",false) 
    now_scene:retain()
  --  if now_scene then
       bm.SchedulerPool:delayCall(function()
           now_scene:removeChild(node_animation)
       end,3)
  --  end 
end

function gameScene:onEnter()
 
--@zc 粒子效果，桃花
   -- self:showDragonAnimation(self)
   local particle = cc.ParticleSystemQuad:create("hall/common/SUKURA.plist")
    particle:setPosition(cc.p(WinSize.width / 2 , WinSize.height / 2))--WinSize
    self:addChild(particle,9999999) 
    particle:setVisible(true)

    cc.Director:getInstance():getOpenGLView():setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.SHOW_ALL)

    audio.playMusic("hall/scene/res/common/music/hallbg.mp3", true)
    --显示棋牌室所属
    self:showAgent()

    --显示走马灯广播
    self:showBroadcast()
    --  --排行榜查询
    -- self:queryRankList()
    --显示公告
    self:showNotification()

    --查询房卡数量
    self:queryRoomCardCount()

    --弹出活动公告
   
       self:showActivityScene()
   
    local braodPlane = self._scene:getChildByName("Image_1"):getChildByName("braod_plane")
    require("hall.scene.hall.BraodComponent"):showBraod(braodPlane)

    -- --显示版本号
    -- local lbVersion = ccui.Text:create()
    -- lbVersion:setString("version:"..require("hall.GameData"):getGameVersion("hall"))
    -- lbVersion:setFontSize(18)

    --     -- local lbVersion = cc.Label:createWithTTF("version:"..require("hall.GameData"):getGameVersion("hall"), "MarkerFelt.ttf", 18)
    -- self._scene:addChild(lbVersion)
    -- lbVersion:setColor(cc.c3b(47,47,47))
    -- lbVersion:setPosition(cc.p(lbVersion:getContentSize().width/2,lbVersion:getContentSize().height/2))

    -- self:setScore()
    
    --用户昵称
    local strNick = require("hall.GameCommon"):formatNick(USER_INFO["nick"], 6)
    local top_base = self._scene:getChildByName("top_base")
    local lbNick = top_base:getChildByName("txt_nick")
    lbNick:setString(strNick)

    --用户id
    local userId = tostring(USER_INFO["uid"])
    local lbId = top_base:getChildByName("txt_nick_0")
    lbId:setString("ID: " .. userId)

    --用户头像
    local sp_head = top_base:getChildByName("sp_head")
    if sp_head then
        local user_inf = {}
        user_inf["uid"] = USER_INFO["uid"]
        user_inf["icon_url"] = USER_INFO["icon_url"]
        user_inf["sex"] = USER_INFO["sex"]
        user_inf["nick"] = USER_INFO["nick"]
        require("hall.GameCommon"):getUserHead(user_inf["icon_url"], user_inf["uid"], user_inf["sex"], sp_head, 95, true, USER_INFO["nick"])
    end

end
--@zc 20170718  问题反馈页面
function gameScene:wentifankui()
    local wenti=cc.CSLoader:createNode(wenti_CsbPath):addTo(self)
    local btn_tijiao=wenti:getChildByName("btn_tijiao")
    local btn_closed=wenti:getChildByName("btn_closed")
    local input_text=wenti:getChildByName("wenti_bg"):getChildByName("wenti_inputText")
    local player_input =nil
    function onBtnClick(sender,event)
                --触摸开始
                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(0.9)
                end
                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end
                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                   if sender == btn_closed then  
                      wenti:removeSelf()
                   elseif sender == btn_tijiao then
                         player_input=input_text:getString()   --存储当前玩家输入的问题信息，这里接受，传到后台  TODO
                         print(player_input)
                      if player_input=="" then
                         require(CommonTips_filePath):showTips("提示", "", 3, "您当前没有输入任何内容")
                      else
                         require(CommonTips_filePath):showTips("提示", "", 3, "谢谢您的宝贵意见，我们将在最快的时间内与您联系")
                         wenti:removeSelf()
                      end
                   end
                end
    end
    btn_tijiao:addTouchEventListener(onBtnClick)
    btn_closed:addTouchEventListener(onBtnClick)

end
--@zc 20170718 实名认证页面
function gameScene:shiming()
    local shimingScene= cc.CSLoader:createNode(shiming_CsbPath):addTo(self)
    local player_name =nil --用来存储名字，和后台对接
    local player_idCard =nil 
    local nameInput_bg=shimingScene:getChildByName("text_name"):getChildByName("nameInput_bg")
    local name_input=nameInput_bg:getChildByName("name_TextField")
    local idCareInput_bg=shimingScene:getChildByName("text_idCard"):getChildByName("idCardInput_bg")
    local idCard_input=idCareInput_bg:getChildByName("idcard_TextField")

    --获取按钮，并且注册点击事件
    local btn_closed=shimingScene:getChildByName("btn_closed")
    local btn_shimingrenzheng=shimingScene:getChildByName("btn_shimingrenzheng")

    function onBtnClick(sender,event)
                --触摸开始
                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(0.9)
                end
                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end
                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                   if sender == btn_closed then
                       shimingScene:removeSelf()

                    elseif sender ==btn_shimingrenzheng  then --判断当前玩家有没有输入信息，并且记录
                    local b=#idCard_input:getString()
                    local a= string.byte(b)
                    print("9999999999999999999999999999")
                    print(b)
                        if name_input ==nil or idCard_input ==nil then   --显示当前没有输入任何内容
                           require(CommonTips_filePath):showTips("错误提示", "", 3, "输入有误，请重新输入")
                        elseif b ~=18 then
                           require(CommonTips_filePath):showTips("错误提示", "", 3, "身份证号码输入有误")
                           idCard_input:setString(" ")
                           name_input:setString(" ")
                        else
                        player_name=name_input:getString()
                        player_idCard=idCard_input:getString()
                        require(CommonTips_filePath):showTips("消息", "", 3, "恭喜你验证成功，祝您游戏愉快")
                        shimingScene:removeSelf()

                        end
                   end
                end
    end
    btn_closed:addTouchEventListener(onBtnClick)
    btn_shimingrenzheng:addTouchEventListener(onBtnClick)
end
--@zc 20170708 购买房卡场景
function gameScene:showBuyCardScene()
    local buyCardScene=cc.CSLoader:createNode(Buy_Card_CsbPath):addTo(self)
    buyCardScene:setScale(0)
    buyCardScene:scaleTo(0.3, 1)
--    require("hall.GameCommon"):commomButtonAnimation(buyCardScene)
    local image_bg=buyCardScene:getChildByName("Panel_bg"):getChildByName("Image_bg")
    local btn_closed=image_bg:getChildByName("btn_closed")
    local button_closed=buyCardScene:getChildByName("Panel_bg"):getChildByName("button_closed")
          button_closed:addTouchEventListener(
            function(sender,event)
                --触摸开始
                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(0.9)
                end
                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end
                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)
                    buyCardScene:removeSelf()
                end
            end
            )
end
--@zc 20170710 诚招代理场景页面
function gameScene:showDailiScene()
    local dailiScene=cc.CSLoader:createNode(Activity_DailiCsbPath):addTo(self)
    dailiScene:setScale(0)
    dailiScene:scaleTo(0.3, 1)
    local acitivity_num=3 --@zc20170710 当前活动的图片的总数量
    local now_num=3  --@zc20170710 当前是那一张活动图片
    local Panel_1=dailiScene:getChildByName("Panel_1")
    local buttons=Panel_1:getChildByName("Buttons")
    local activity_base=Panel_1:getChildByName("activity")
    local activity_oldPos=activity_base:getPosition()
    local InputMessage=Panel_1:getChildByName("ScrollView_message"):getChildByName("TextField_message")
    local node_animation=self._scene:getChildByName("playerAnimation")
    local boolIsFinish =true
      --获取按钮组
    local btn_closed=buttons:getChildByName("btn_closed")
    local btn_left=buttons:getChildByName("btn_left")
    local btn_right=buttons:getChildByName("btn_right")
    local btn_sure=buttons:getChildByName("btn_sure")

    local function touchEvent(sender, event)
         if event == TOUCH_EVENT_BEGAN then
                sender:setScale(1.5)
        end

        if event == TOUCH_EVENT_CANCELED then
            sender:setScale(2.0)
        end

        if event == TOUCH_EVENT_ENDED then
            sender:setScale(2.0)
            if sender == btn_closed then
                dailiScene:removeSelf() 
            end

            elseif sender == btn_left then
                if now_num <acitivity_num then
                activity_base:moveTo(0.12,activity_oldPos.x -1280,activity_oldPos.y )
                activity_oldPos.x=activity_oldPos.x-1280
                now_num=now_num +1
                end
        
           elseif sender == btn_right then
                if  now_num >1 then
                activity_base:moveTo(0.12,activity_oldPos.x +1280,activity_oldPos.y )
                activity_oldPos.x=activity_oldPos.x+1280
                now_num=now_num -1
                end
            elseif sender == btn_sure then
                local playerInputMessage=InputMessage:getString()
                self:getPlayerInputMessage(playerInputMessage)
                InputMessage:setString("")
            end
        end

    --点击事件
    btn_closed:addTouchEventListener(touchEvent)
    btn_left:addTouchEventListener(touchEvent)
    btn_right:addTouchEventListener(touchEvent)
    btn_sure:addTouchEventListener(touchEvent)
end

--@zc 20170710 记录玩家在活动面板的写入联系方式   这里暂时实现方法拿到输入信息，到时候与后台对接
function gameScene:getPlayerInputMessage(message)
    if message =="" or message==nil then
        require(CommonTips_filePath):showTips("消息", "", 3, "您当前没有输入任何内容")
        else
        require(CommonTips_filePath):showTips("消息", "", 3, "感谢您的支持，我们将会24小时之内与您联系")  
    end
end
--@zc 20170708 活动场景弹窗
function gameScene:showActivityScene()

    local activityScene=cc.CSLoader:createNode(Activity_CsbPath):addTo(SCENENOW["scene"])
   -- require("hall.GameCommon"):commomButtonAnimation(activityScene)
   activityScene:setScale(0)
   activityScene:scaleTo(0.3, 1)
    local activity_image=activityScene:getChildByName("Panel_10"):getChildByName("activity_image")
    local btn_closed=activity_image:getChildByName("btn_closed")
          btn_closed:addTouchEventListener(
            function(sender,event)
                --触摸开始
                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(0.9)
                end
                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end
                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)
                    activityScene:removeSelf()
                end
            end
            )
end
--显示棋牌室所属
function gameScene:showAgent()

    if SCENENOW["name"] then

        if isiOSVerify then
            
            local logo_tt = SCENENOW["scene"]._scene:getChildByName("logo_tt")
            if logo_tt ~= nil then
                logo_tt:setString("乐在棋中")
            end

            local agent_tt = SCENENOW["scene"]._scene:getChildByName("agent_tt")
            if agent_tt ~= nil then
                agent_tt:setString("")
            end

        else

            local logo_tt = SCENENOW["scene"]._scene:getChildByName("logo_tt")
            if logo_tt ~= nil then
                if USER_INFO["agentName"] ~= nil and USER_INFO["agentName"] ~= "" then
                    logo_tt:setString(USER_INFO["agentName"])
                else
                    logo_tt:setString("乐在棋中")
                end
            end

            local agent_tt = SCENENOW["scene"]._scene:getChildByName("agent_tt")
            if agent_tt ~= nil then
                if USER_INFO["agentId"] ~= nil and USER_INFO["agentId"] ~= "" then
                    agent_tt:setString("ID:" .. USER_INFO["agentId"])
                else
                    agent_tt:setString("")
                end
            end

        end

    end

end

--显示走马灯广播
function gameScene:showBroadcast()

    if not isiOSVerify then
        
        local params = {}
        params["type"] = "2"
        cct.createHttRq({
            url = HttpAddr .. "/baseData/queryAnnouncements",
            date = params,
            type_="POST",
            requestMsg = "",
            callBack = function(data)
                data_netData = json.decode(data["netData"])
                if data_netData.returnCode == "0" then
                    --todo
                    local sData = data_netData.data
                    dump(sData, "-----查询走马灯-----")
                    if table.getn(sData) > 0 then
                        --todo
                        if table.getn(sData[1]) > 0 then
                            --todo
                            dump(sData[1][1]["content"], "-----查询走马灯-----")
                            require("hall.scene.hall.BraodComponent"):setDefaultBraodMessage(sData[1][1]["content"])
                        end
                    end
                end              
            end
        })
        
    end

end

--查询房卡数量
function gameScene:queryRoomCardCount()

    if SCENENOW["name"] == GameScene_filePath  then

        --房卡区域
        local top_base = SCENENOW["scene"]._scene:getChildByName("top_base")
        local btn_add_score = top_base:getChildByName("fangka_ly")
        local txt_score = btn_add_score:getChildByName("fangka_tt")

        --积分区域
        local jifen_ly = top_base:getChildByName("jifen_ly")
        local jifen_tt = jifen_ly:getChildByName("jifen_tt")

        local params = {}
        params["userId"] = USER_INFO["uid"]
        params["interfaceType"] = "J"
        cct.createHttRq({
            url=HttpAddr .. "/roomCard/queryRoomCardCount",
            date= params,
            type_="POST",
            requestMsg = "",
            callBack = function(data)
                dump(data, "-----查询房卡数量-----")
                data_netData = json.decode(data["netData"])
                if data_netData.returnCode == "0" then
                    local sData = data_netData.data
                    if sData ~= nil then

                        if txt_score ~= nil then
                            if sData.cardCount ~= nil then
                                USER_INFO["cardCount"] = sData.cardCount
                                txt_score:setString(tostring(USER_INFO["cardCount"]))
                            end
                        end
                        
                        if jifen_tt ~= nil then
                            if sData.points ~= nil then
                                USER_INFO["jifen"] = sData.points
                                jifen_tt:setString(tostring(USER_INFO["jifen"]))
                            end
                        end
                        
                    end
                end
                            
            end
        })
    end

end

--查询排行榜
function gameScene:queryRankList()

    local rankcount = 10

    local table = {}
    table["userId"] = USER_INFO["uid"]
    table["rankcount"] = rankcount
    table["interfaceType"] = "J"

    cct.createHttRq({
        url = HttpAddr .. "/freeGame/queryTotalGroupRank",
        date = table,
        type_= "GET",
        requestMsg = "",
        callBack = function(data)

            local responseData = data.netData
            if responseData then
                responseData = json.decode(responseData)
                local cacheData = responseData.data
                if cacheData then

                    --排行榜
                    local rankList = cacheData.rankList
                    if rankList then
                        if #rankList > 0 then
                            dump(rankList, "-----排行榜数据-----")

                            --local list_ly = SCENENOW["scene"]._scene:getChildByName("list_ly")

                            local rankingList_tipsScene=cc.CSLoader:createNode(RankListCsb_filePath):addTo(self) --@zc加载重新自己制作的场景
                          --  require("hall.GameCommon"):commomButtonAnimation(rankingList_tipsScene)
                            local list_ly=rankingList_tipsScene:getChildByName("bg_image")
                            local btn_closed=list_ly:getChildByName("btn_closed")
                            btn_closed:addTouchEventListener(
                                        function(sender,event)
                                            --触摸开始
                                            if event == TOUCH_EVENT_BEGAN then
                                                sender:setScale(0.9)
                                            end
                                            --触摸取消
                                            if event == TOUCH_EVENT_CANCELED then
                                                sender:setScale(1.0)
                                            end
                                            --触摸结束
                                            if event == TOUCH_EVENT_ENDED then
                                                sender:setScale(1.0)
                                                rankingList_tipsScene:removeSelf()
                                            end
                                        end
                                    )
                            if list_ly ~= nil then
                                
                                local list_sv = list_ly:getChildByName("list_sv")
                                local content_ly = list_sv:getChildByName("content_ly")

                                for k,v in pairs(rankList) do
                                    
                                    local rankCell = cc.CSLoader:createNode(RankCellCsb_filePath)
                                    rankCell:setPosition(0, k * 90.00 * -1)
                                    rankCell:setScale(0.9)
                                    content_ly:addChild(rankCell)

                                    local rankCell_content_ly = rankCell:getChildByName("content_ly")
                                    rankCell_content_ly:setTouchEnabled(false)

                                    local rank_tt = rankCell_content_ly:getChildByName("rank_tt")
                                   rank_tt:setString(tostring(k))

                                    --@zc 这里是修改图片资源
                                    local Image_crown =rankCell_content_ly:getChildByName("Image_crown")
                                    Image_crown:setVisible(false)
                                    if k==1 then
                                        rank_tt:setVisible(false)
                                        Image_crown:setVisible(true)
                                        Image_crown:loadTexture("hall/scene/res/168/image/rank/match_info_item_first.png")

                                    elseif k ==2 then
                                        rank_tt:setVisible(false)
                                        Image_crown:setVisible(true)
                                        Image_crown:loadTexture("hall/scene/res/168/image/rank/match_info_item_second.png")

                                    elseif k==3 then
                                        rank_tt:setVisible(false)
                                        Image_crown:setVisible(true)
                                        Image_crown:loadTexture("hall/scene/res/168/image/rank/match_info_item_three.png")
                                    end
                                     rank_tt:setString(tostring(k))
                                    local head_iv = rankCell_content_ly:getChildByName("head_iv")
                                    if v["smallIcon"] ~= nil and v["smallIcon"] ~= "" and v["nickName"] ~= nil and v["nickName"] ~= "" then
                                        require("hall.GameCommon"):getUserHead(v["smallIcon"], "", "", head_iv, 46, false, v["nickName"])
                                    else
                                        head_iv:loadTexture(DefaultHead_filePath)
                                    end

                                    local name_tt = rankCell_content_ly:getChildByName("name_tt")
                                    if v["nickName"] ~= nil and v["nickName"] ~= "" then
                                        name_tt:setString(require("hall.GameCommon"):formatNickToLaction(tostring(v["nickName"]), 5))
                                    else
                                        name_tt:setString("")
                                    end

                                    local total_tt = rankCell_content_ly:getChildByName("total_tt")
                                    if v["total"] ~= nil then
                                        total_tt:setString(tostring("战绩分：" .. v["total"]))
                                    else
                                        total_tt:setString("")
                                    end

                                end

                                list_sv:setCascadeOpacityEnabled(true)
                                list_sv:setInnerContainerSize(cc.size(684.00, 66 * #rankList + 20))
                                if #rankList > 6 then
                                    content_ly:setPosition(0, 66 * #rankList + 20)
                                end
                                
                            end

                        end
                    end
                    
                end
            end
        end
    })

end

--查询公告与客服信息
function gameScene:showNotification()
    
    local params = {}
    cct.createHttRq({
        url=HttpAddr .. "/baseData/queryAnnouncements",
        date= params,
        type_="POST",
        requestMsg = "",
        callBack = function(data)
            data_netData = json.decode(data["netData"])
            if data_netData.returnCode == "0" then
                local sData = data_netData.data
                dump(sData, "-----查询公告与客服信息-----")

                if table.getn(sData) > 0 then

                    --客服
                    if table.getn(sData[1]) > 0 then
                        --todo
                        if sData[1][1]["content"] and sData[1][1]["content"] ~= "" then
                            dump(sData[1][1]["content"], "-----客服信息-----")
                            
                            bm.kefuMessage = sData[1][1]["content"]

                        end
                    end
                    

                    --公告
                    if table.getn(sData[3]) > 0 then
                        --todo
                        if sData[3][1]["content"] and sData[3][1]["content"] ~= "" then
                            dump(sData[3][1]["content"], "-----公告-----")
                            --  ScrollView_1
                    
                            if SCENENOW["scene"]._scene then 
                                local notice_ly = SCENENOW["scene"]._scene:getChildByName("notice_ly")

                                if notice_ly then 

                                    local notice_tt = notice_ly:getChildByName("ScrollView_1"):getChildByName("notice_tt")
                                    notice_tt:setString(tostring(sData[3][1]["content"]))
                                end 
                            end

                        end
                    end

                end
            end              
        end
    })

end

--显示游戏列表
function gameScene:showGameList()

    if SCENENOW["scene"] == nil then
        return
    end

    if SCENENOW["scene"]._scene == nil then
        return
    end

    require(NetworkLoadingView_filePath):removeView()

    --更多游戏(废弃)
    -- local morecontent_sv = SCENENOW["scene"]._scene:getChildByName("content_sv")
    -- morecontent_sv:setVisible(false)

    if game_scroll == nil then
        return
    else
        game_scroll:removeAllChildren()
    end

    --获取本地记录的显示到外面的游戏
    backgameList = require(GameList_filePath):getList()
    local gameList = cc.UserDefault:getInstance():getStringForKey("showOutGame")
    dump(gameList, "-----显示游戏列表gameList-----")
    if gameList == nil or gameList == "" then

        gameList = {}
        for k,v in pairs(backgameList) do
            if v[7] == 1 then
                table.insert(gameList, v)
            end
        end
        cc.UserDefault:getInstance():setStringForKey("showOutGame", json.encode(gameList))

    else

        gameList = json.decode(gameList)

    end

    --更多游戏
    local moregameList = {}
    for k,v in pairs(backgameList) do
        if v[7] == 1 then
            v[7] = 0
        end
        table.insert(moregameList, v)
    end

    table.insert(moregameList, {7, "hh_majaing", "晃晃麻将", "1.0.0", 0, 0, 0, 1})
    table.insert(moregameList, {55, "hh_majaing", "晃晃麻将", "1.0.0", 0, 0, 0, 1})
    table.insert(moregameList, {100, "hh_majaing", "公安晃晃", "1.0.0", 0, 0, 0, 1})
    table.insert(moregameList, {101, "hh_majaing", "湖南麻将", "1.0.0", 0, 0, 0, 1})
    table.insert(moregameList, {102, "hh_majaing", "宜宾麻将", "1.0.0", 0, 0, 0, 1})
    table.insert(moregameList, {103, "hh_majaing", "宜宾麻将", "1.0.0", 0, 0, 0, 1})

    dump(gameList, "-----显示游戏列表gameList-----")
    dump(moregameList, "-----显示游戏列表moregameList-----")

    --游戏列表
    if gameList ~= nil and #gameList > 0 then

        --定义内容显示区域
        local content_ly = ccui.Layout:create()
        content_ly:setName("content_ly")
        content_ly:setAnchorPoint(cc.p(0,1))
        content_ly:setPosition(0, 0)
        content_ly:setContentSize(cc.size(0, 0))
        content_ly:setTouchEnabled(false)

        game_scroll:addChild(content_ly)

        if isiOSVerify then
        
            --定义一个按钮
            local button = ccui.Button:create()
            button:setTouchEnabled(true)
            button:setAnchorPoint(cc.p(0.5, 0.5))
            button:setPosition(74, -96)
            button:setName("layout_game"..tostring(4))
            button:loadTextures("hall/image/hall/moregame/main_xuezhan_bt.png", nil, nil)
            content_ly:addChild(button)
            local function touchEvent(sender, event)
                if event == TOUCH_EVENT_ENDED then
                    require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                    if sender == button then

                        self:selectGame(4, majiang)
                        
                    end
                end
            end
            button:addTouchEventListener(touchEvent)

        else

            local i = 1
            table.foreach(gameList, 

                function(k, v)

                    local gameId = tonumber(v[1])

                    -- if gameId == 4 then

                        --定义一个按钮
                        local button = ccui.Button:create()
                        button:setTouchEnabled(true)
                        button:setAnchorPoint(cc.p(0.5, 0.5))

                        local x = 0
                        local y = 0
                        local a = k - 1
                        x = ((a % 3) * 167 + 74)

                        y = 197 * math.floor(a / 3) * -1 -96.00

                        button:setPosition(x, y)
                        button:setName("layout_game"..tostring(v[1]))
                        button:setScale(-1,1)
                        
                        if gameId == 1 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_doudizhu_bt.png", nil, nil)
                        elseif gameId == 4 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_xuezhan_bt.png", nil, nil)
                        elseif gameId == 40 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_changsha_bt.png", nil, nil)
                        elseif gameId == 41 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_hongzhong_bt.png", nil, nil)
                        elseif gameId == 42 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_kawuxing_bt.png", nil, nil)
                        elseif gameId == 50 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_kawuxing_bt.png", nil, nil)
                        elseif gameId == 5 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_douniu_bt.png", nil, nil)
                        elseif gameId == 6 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_dezhoupuke_bt.png", nil, nil)
                        elseif gameId == 43 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_guangdongg_bt.png", nil, nil)
                        elseif gameId == 44 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_suizhoukawuxing_bt.png", nil, nil)
                        elseif gameId == 45 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_xueliu_bt.png", nil, nil)
                        elseif gameId == 46 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_tuidaohu_bt.png", nil, nil)
                        elseif gameId == 47 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_xiangyangkawuxing_bt.png", nil, nil)
                        elseif gameId == 11 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_paodekuai_bt.png", nil, nil)
                        elseif gameId == 8 then
                            button:loadTextures(MoreGameButtons_filePath .. "phz_bt.png", nil, nil)
                        elseif gameId == 9 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_sangong_bt.png", nil, nil)
                        elseif gameId == 7 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_zhajinhua_bt.png", nil, nil)
                        elseif gameId == 77 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_ganzhouchongguan_bt.png", nil, nil)
                        elseif gameId == 55 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_huanghuang_bt", nil, nil)
                        elseif gameId == 100 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_gonganhuanghuang_bt", nil, nil)
                        elseif gameId == 101 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_hainanmajiang_bt", nil, nil)
                        elseif gameId == 102 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_yibinxuezhan_bt", nil, nil)
                        elseif gameId == 103 then
                            button:loadTextures(MoreGameButtons_filePath .. "main_jiazimajiang_bt", nil, nil)
                        end

                        content_ly:addChild(button)

                        --检查本地版本号
                        local bShowMash = 0
                        if v[4] ~= "-1" and needUpdate == true then
                            if v[2] ~= nil then
                                if require("hall.GameData"):getGameVersion(v[2]) == "" then
                                    --本地没有游戏
                                    bShowMash = 1
                                elseif require("hall.GameData"):compareLocalVersion(v[4],v[2]) > 0 then
                                    --本地游戏版本低
                                    bShowMash = 2
                                end
                            end
                        end

                        --显示新版本标签
                        if bShowMash > 0 then
                            local spMash = display.newSprite("hall/hall/new.png")
                            if spMash then
                                button:addChild(spMash)
                                spMash:setAnchorPoint(cc.p(0,0))
                                spMash:setPosition(cc.p(75, 115))
                                spMash:setName("spMash")
                            end
                        end

                        local spLoading = cc.ProgressTimer:create(cc.Sprite:create("hall/hall/loading_bg.png"))
                        button:addChild(spLoading)
                        spLoading:setVisible(false)
                        spLoading:setName("loading")
                        spLoading:setPosition(75,100)
                        spLoading:setScale(0.8)

                        local function touchEvent(sender, event)
                            if event == TOUCH_EVENT_ENDED then
                                require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")
                                if sender == button then

                                    if needUpdate then
                                        dump("", "-----点击按钮，检查更新游戏-----")
                                        self:updateGame(v[1],v[2],v[3])
                                    else
                                        dump("", "-----点击按钮，选择游戏-----")
                                        self:selectGame(v[1], v[2])
                                    end
                                    
                                end
                            end
                        end
                        button:addTouchEventListener(touchEvent)

                        local action_back = cc.ScaleTo:create(0.5, 1, 1)
                        button:runAction(cc.Sequence:create(action, action_back))

                    -- end
                    
                end
            )

        end

    end

    --更多游戏
    if moregameList ~= nil and #moregameList > 0 then

        --更多游戏布局
        local more_ly = SCENENOW["scene"]._scene:getChildByName("more_ly")
        more_ly:setVisible(false)

        local back_bt = more_ly:getChildByName("back_bt")
        back_bt:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(1.0)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)

                    more_ly:setVisible(false)

                    self:showGameList()

                end

            end
        )

        local more_button = ccui.Button:create()
        more_button:setTouchEnabled(true)
        more_button:setAnchorPoint(cc.p(0.5, 0.5))
        more_button:setPosition(405.00, -293.00)
        more_button:loadTextures(MoreGameButtons_filePath .. "main_more_game_bt.png", nil, nil)
        more_button:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                    sender:setScale(1.0)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:setScale(1.0)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)

                    if require("hall.GameUpdate"):getUpdateStatus() ~= 0 then
                        require(CommonTips_filePath):showTips("提示", "", 3, "正在更新游戏！")
                        return
                    end

                    more_ly:setVisible(true)

                end

            end
        )
        if not isiOSVerify then
            game_scroll:addChild(more_button)
        end

        local content_sv = more_ly:getChildByName("content_sv")
        local morecontent_ly = content_sv:getChildByName("morecontent_ly")
        morecontent_ly:removeAllChildren()
        local x = 0
        local y = 0
        local a = 0
        table.foreach(moregameList, 

            function(k, v)

                local gameId = tonumber(v[1])

                --定义一个按钮
                local button = ccui.Button:create()
                button:setTouchEnabled(true)
                button:setAnchorPoint(cc.p(0.5, 0.5))
                button:setTag(gameId)

                x = 167 * math.floor(a / 2) + 74
                y = -197 * (a % 2) - 96.00

                button:setPosition(x, y)

                if v[8] == 1 then
                    morecontent_ly:addChild(button)
                    a = a + 1
                end

                local pic = ""
                
                if gameId == 1 then
                    pic = MoreGameButtons_filePath .. "main_doudizhu_bt"
                elseif gameId == 4 then
                    pic = MoreGameButtons_filePath .. "main_xuezhan_bt"
                elseif gameId == 5 then
                    pic = MoreGameButtons_filePath .. "main_douniu_bt"
                elseif gameId == 6 then
                    pic = MoreGameButtons_filePath .. "main_dezhoupuke_bt"
                elseif gameId == 7 then
                    pic = MoreGameButtons_filePath .. "main_zhajinhua_bt"
                elseif gameId == 8 then
                    pic = MoreGameButtons_filePath .. "phz_bt"
                elseif gameId == 9 then
                    pic = MoreGameButtons_filePath .. "main_sangong_bt"
                elseif gameId == 11 then
                    pic = MoreGameButtons_filePath .. "main_paodekuai_bt"
                elseif gameId == 40 then
                    pic = MoreGameButtons_filePath .. "main_changsha_bt"
                elseif gameId == 41 then
                    pic = MoreGameButtons_filePath .. "main_hongzhong_bt"
                elseif gameId == 42 then
                    pic = MoreGameButtons_filePath .. "main_kawuxing_bt"
                elseif gameId == 50 then
                    pic = MoreGameButtons_filePath .. "main_kawuxing_bt"
                elseif gameId == 43 then
                    pic = MoreGameButtons_filePath .. "main_guangdongg_bt"
                elseif gameId == 44 then
                    pic = MoreGameButtons_filePath .. "main_suizhoukawuxing_bt"
                elseif gameId == 45 then
                    pic = MoreGameButtons_filePath .. "main_xueliu_bt"
                elseif gameId == 46 then
                    pic = MoreGameButtons_filePath .. "main_tuidaohu_bt"
                elseif gameId == 47 then
                    pic = MoreGameButtons_filePath .. "main_xiangyangkawuxing_bt"
                elseif gameId == 77 then
                    pic = MoreGameButtons_filePath .. "main_ganzhouchongguan_bt"
                elseif gameId == 55 then
                    pic = MoreGameButtons_filePath .. "main_huanghuang_bt"
                elseif gameId == 100 then
                    pic = MoreGameButtons_filePath .. "main_gonganhuanghuang_bt"
                elseif gameId == 101 then
                    pic = MoreGameButtons_filePath .. "main_hainanmajiang_bt"
                elseif gameId == 102 then
                    pic = MoreGameButtons_filePath .. "main_yibinxuezhan_bt"
                elseif gameId == 103 then
                    pic = MoreGameButtons_filePath .. "main_jiazimajiang_bt"
                end

                button:setName(pic)

                if v[7] == 1 then
                    pic = pic .. "1.png"
                else
                    pic = pic .. ".png"
                end

                button:loadTextures(pic, nil, nil)

                button:addTouchEventListener(
                    function(sender,event)

                        if event == TOUCH_EVENT_BEGAN then
                            sender:setScale(1.0)
                            require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")

                        end

                        --触摸取消
                        if event == TOUCH_EVENT_CANCELED then
                            sender:setScale(1.0)
                        end

                        --触摸结束
                        if event == TOUCH_EVENT_ENDED then
                            sender:setScale(1.0)

                            if require("hall.GameUpdate"):getUpdateStatus() ~= 0 then
                                require(CommonTips_filePath):showTips("提示", "", 3, "正在更新游戏！")
                                return
                            end

                            if gameId == 7 or gameId == 55 or gameId == 100 or gameId == 101 or gameId == 102 or gameId == 103 then
                                require(CommonTips_filePath):showTips("提示", "", 3, "即将到来，敬请期待！")
                                return
                            end

                            --获取点击的游戏Id
                            local gameId = tonumber(sender:getTag())
                            dump(gameId, "-----当前点击的游戏Id-----")

                            local gameName = sender:getName()
                            dump(gameName, "-----当前点击的游戏名称-----")

                            --获取当前显示到外面的游戏个数
                            local nowShowGameCount = 0
                            for k,v in pairs(moregameList) do
                                if v[7] == 1 then
                                    nowShowGameCount = nowShowGameCount + 1
                                end
                            end
                            dump(nowShowGameCount, "-----当前显示的游戏个数-----")

                             --判断当前点击的游戏是否已经添加显示
                            local isShow = 0
                            for k,v in pairs(moregameList) do

                                if v[1] == gameId then

                                    if v[7] == 1 then

                                        isShow = 1

                                        --设置当前游戏没选择
                                        v[7] = 0
                                        sender:loadTextures(gameName .. ".png", nil, nil)

                                        --更新显示在外面的游戏记录
                                        local newGameList = {}
                                        for k,v in pairs(moregameList) do
                                            if v[7] == 1 then
                                                table.insert(newGameList, v)
                                            end
                                        end
                                        cc.UserDefault:getInstance():setStringForKey("showOutGame", json.encode(newGameList))

                                    end

                                end

                            end

                            --当前点击的游戏没有选择
                            if isShow == 0 then

                                dump(isShow, "-----当前点击的游戏没有选择-----")

                                if nowShowGameCount == 5 then

                                    --当前已经选择三款游戏
                                    require(CommonTips_filePath):showTips("提示", "", 3, "最多选择五款游戏")

                                else
                                    --当前未选满五款游戏，把点击的游戏设为选中
                                    sender:loadTextures(gameName .. "1.png", nil, nil)
                                    for k,v in pairs(moregameList) do

                                        if v[1] == gameId then

                                            --设置当前游戏选择
                                            v[7] = 1

                                            --更新显示在外面的游戏记录
                                            local newGameList = {}
                                            for k,v in pairs(moregameList) do
                                                if v[7] == 1 then
                                                    table.insert(newGameList, v)
                                                end
                                            end
                                            cc.UserDefault:getInstance():setStringForKey("showOutGame", json.encode(newGameList))

                                        end

                                    end

                                end
                                
                            end

                        end

                    end
                )
                
            end

        )
        content_sv:setInnerContainerSize(cc.size(x + 74, 405))

    end
    
end

--检查更新游戏
function gameScene:updateGame(id,code,name)

    print("-----大厅更新游戏:".. code .." 状态:" .. require("hall.GameUpdate"):getUpdateStatus())

    if require("hall.GameUpdate"):getUpdateStatus() == 0 then
        require("hall.GameUpdate"):queryVersion(id,code,1,name)
    else
        require(CommonTips_filePath):showTips("提示", "", 3, "正在更新游戏！")
    end
    
end

--设置当前游戏
function gameScene:selectGame(gid, code)

    if require("hall.GameUpdate"):getUpdateStatus() ~= 0 then
        require(CommonTips_filePath):showTips("提示", "", 3, "正在更新游戏！")
        return
    end

    USER_INFO["enter_mode"] = gid
    USER_INFO["enter_code"] = code

end

--离开大厅
function gameScene:onExit()
    
end

return gameScene
