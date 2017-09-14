local Scene = class("Scene")

--当前界面
local createGroupCsb

--当前游戏的初始配置
local nowSelectGameConfig = {}

--记录最终提交的参数
local parameter = {}

--记录二级游戏列表按钮数组
local gameButton_arr

local area_arr = {}
local tab_arr = {}
local selectedTabIndex
local GroupStart_arr = {}
local GroupHeight_arr = {}

local gamelist_sv
local content_ly
local IsShow_
function Scene:CreateScene(isshow)

    nowSelectGameConfig = {}

    parameter = {}

    --获取界面
    createGroupCsb = cc.CSLoader:createNode(CreateGroupCsb_filePath)
--    require("hall.GameCommon"):commomButtonAnimation(createGroupCsb)
    SCENENOW["scene"]:addChild(createGroupCsb)

    --头部区域
    local top_base = createGroupCsb:getChildByName("top_base")

    --返回按钮
    back_bt = createGroupCsb:getChildByName("btn_back")
    back_bt:addTouchEventListener(
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

                createGroupCsb:removeSelf()

            end
        end
    )
    --用户昵称
    local strNick = require("hall.GameCommon"):formatNick(USER_INFO["nick"], 6)
    local lbNick = top_base:getChildByName("txt_nick")
    lbNick:setString(strNick)

    --用户id
    local userId = tostring(USER_INFO["uid"])
    local lbId = top_base:getChildByName("txt_nick_0")
    lbId:setString("ID: " .. userId)

    --房卡
    local btn_add_score = top_base:getChildByName("fangka_ly")
    local txt_score = btn_add_score:getChildByName("fangka_tt")
    if USER_INFO["cardCount"] ~= nil then
        txt_score:setString(tostring(USER_INFO["cardCount"]))
    else
        txt_score:setString("")
    end

    --积分
    local jifen_ly = top_base:getChildByName("jifen_ly")
    local jifen_tt = jifen_ly:getChildByName("jifen_tt")
    if USER_INFO["jifen"] ~= nil then
        jifen_tt:setString(tostring(USER_INFO["jifen"]))
    else
        jifen_tt:setString("")
    end

    if isiOSVerify then
        btn_add_score:setVisible(false)
        jifen_ly:setVisible(false)
    end

    --创建房间按钮
    local config_ly = createGroupCsb:getChildByName("config_ly")
    create_bt = config_ly:getChildByName("create_bt")
    create_bt:addTouchEventListener(
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

                if parameter["level"] == nil then
                    require(CommonTips_filePath):showTips("提示", "", 3, "请先选择游戏")
                    return
                end

                require(GroupSetting_filePath):create(1, 1, 1, parameter["level"], parameter)

            end
        end
    )

   if isshow == 1 then
       self:showZhiPaiGameList()
    else
     self:showMaJIangGameList()
   end
end


--@zc 显示所有麻将
function Scene:showMaJIangGameList()

     --@zc 麻将类的话显示湖南麻将
    if bm.groupGameConfig ~= nil then
        for k,v in pairs(bm.groupGameConfig) do
            if v.gameName =="长沙麻将"then
                self:showSecondGameList(v)
                break
            end
        end
    end

    dump(bm.gameList, "-----游戏列表-----")

    if createGroupCsb == nil then
        return
    end

    gamelist_sv = createGroupCsb:getChildByName("gamelist_sv")
    if gamelist_sv == nil then
        return
    end

    area_arr = {}
    tab_arr = {}
    tabButton_arr = {}
    selectedTabIndex = 1

    game_arr = {}
    selectedGameIndex = nil

    content_ly = gamelist_sv:getChildByName("content_ly")

    local typeCount = 0
    local gameCount = 0
    --@ZC 显示游戏列表   136   -47
    local setPos =40  
    if isiOSVerify then
        bm.gameList = {}

        local xuezhantable = {}
        xuezhantable["id"] = 1
        xuezhantable["code"] = "majiang"
        xuezhantable["gameId"] = 4
        xuezhantable["gameType"] = "麻将游戏"
        xuezhantable["isShow"] = 1
        xuezhantable["name"] = "血战麻将"
        xuezhantable["status"] = "2"
        xuezhantable["type"] = 2
        xuezhantable["version"] = "1.4.105"

        local gameArr = {}
        table.insert(gameArr, xuezhantable)

        local gameInfo = {}
        gameInfo["gameType"] = "麻将游戏"
        gameInfo["gameArr"] = gameArr
        table.insert(bm.gameList, gameInfo)

    end

    if bm.gameList ~= nil then
        for k,v in pairs(bm.gameList) do
            dump(bm.gameList,"当前的游戏列表是这就囧哥")
            typeCount = typeCount + 1
            local typeGameList = v["gameArr"]
            --显示当前分类下的游戏
            if typeGameList ~= nil then
    
                local a = 1
                for k,v in pairs(typeGameList) do

                    if v.isShow == 1 and v.gameType =="麻将类" then 
                       
                        gameCount = gameCount + 1
                        setPos = setPos-85
                        --添加游戏按钮
                        local tab_gameLayer = cc.CSLoader:createNode(CreateGroup_TabGame_Csb_filePath)
                        tab_gameLayer:setAnchorPoint(0.5,0.5)
                        tab_gameLayer:setPosition(130,setPos)
                       -- tab_gameLayer:setScale(1)
                        tab_gameLayer:setTag(1000)
                        content_ly:addChild(tab_gameLayer)
                        game_arr[v.id] = tab_gameLayer
                       
                        --显示游戏名称
                        local tab_gameLayer_content_ly = tab_gameLayer:getChildByName("content_ly")
                        tab_gameLayer_content_ly:setTouchEnabled(true)

                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                        --游戏名称
                        local gameName = v.name

                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                        tab_gameLayer_text_tt_n:setString(gameName)
                       -- tab_gameLayer_text_tt_n:setScale(1)
                        tab_gameLayer_text_tt_n:setVisible(false)

                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                        tab_gameLayer_text_tt_s:setString(gameName)
                       -- tab_gameLayer_text_tt_s:setScale(1)
                        tab_gameLayer_text_tt_s:setVisible(false)

                        local name_pic =tab_gameLayer_content_ly:getChildByName("Image_pic")

                        if name_pic==nil then
                          
                        end
                        if gameName ~=nil then
                        dump(gameName,"当前游戏的名字是++")
                            if gameName =="拼三张" then
                                name_pic:setTexture(Name_PicPath.."btn_pingsanzhang_1.png")

                             elseif gameName == "湖南麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hunanmajinag_1.png")
                            elseif gameName == "跑得快" then
                                name_pic:setTexture(Name_PicPath.."btn_paodekuai_1.png")
                            elseif gameName == "湖北麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hubeimajiang_1.png")
                            elseif gameName == "三公" then
                                name_pic:setTexture(Name_PicPath.."btn_sangong_1.png")
                            elseif gameName == "红中王" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhongwang_1.png")
                            elseif gameName == "红中麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhong_1.png")
                            elseif gameName == "斗牛" then
                                name_pic:setTexture(Name_PicPath.."niuniu_jd.png")
                            elseif gameName == "抢庄斗牛" then
                                name_pic:setTexture(Name_PicPath.."niuniu_qz.png")
                            elseif gameName == "明牌斗牛" then
                                name_pic:setTexture(Name_PicPath.."niuniu_mp.png")
                            elseif gameName == "斗地主" then
                                name_pic:setTexture(Name_PicPath.."btn_doudizhu_1.png")
                            elseif gameName == "3D红中" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhong_1.png")
                            elseif gameName == "扎金花" then
                                name_pic:setTexture(Name_PicPath.."btn_pingsanzhang_1.png")
                            elseif gameName == "四川麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_sichuanmajiang_1.png")
                            elseif gameName == "广东推倒胡" then
                                name_pic:setTexture(Name_PicPath.."btn_gdtuidaohu_1.png")
                            elseif gameName == "2D广东麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_2Dgdmajiang_1.png")
                            elseif gameName == "河北麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hebei_1.png")
                            elseif gameName == "赣州冲关" then
                                name_pic:setTexture(Name_PicPath.."btn_ganzhou_1.png")
                            elseif gameName == "陕西挖坑" then
                                name_pic:setTexture(Name_PicPath.."shanxiwaiken2.png")
                            elseif gameName == "南京麻将" then
                                name_pic:setTexture(Name_PicPath.."nanjingmajiang.png")  
                            elseif gameName == "潮汕" then
                                name_pic:setTexture(Name_PicPath.."shanshangmajiang2.png")  

                            elseif gameName == "浙江麻将" then
                                name_pic:setTexture(Name_PicPath.."zhejiangmajiang.png")  
                           
                            elseif gameName == "海南麻将" then
                                name_pic:setTexture(Name_PicPath.."hainanmajiang.png")  
                            
                            elseif gameName == "晃晃麻将" then
                                name_pic:setTexture(Name_PicPath.."huanghuangmajiang.png")  
                            end


                        end
                        --定义一个按钮  潮汕测试版
                        local gameButton = ccui.Button:create()
                        gameButton:setTouchEnabled(true)
                        gameButton:setAnchorPoint(0.5,0.5)
                        gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                        gameButton:setPosition(130,setPos)
                       -- gameButton:setScale(1)
                        gameButton:setTag(1001)
                        gameButton:addTouchEventListener(

                            function(sender,event)

                                if event == TOUCH_EVENT_BEGAN then

                                end

                                --触摸取消
                                if event == TOUCH_EVENT_CANCELED then

                                end

                                --触摸结束
                                if event == TOUCH_EVENT_ENDED then
                                    cc.SimpleAudioEngine:getInstance():playEffect("hall/scene/res/music/btn.mp3",false)

                                    if selectedGameIndex ~= nil then
                                        local tab_gameLayer_content_ly = game_arr[selectedGameIndex]:getChildByName("content_ly")

                                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                                        tab_gameLayer_text_tt_n:setVisible(false)

                                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                                        tab_gameLayer_text_tt_s:setVisible(false)
                                    end

                                    selectedGameIndex = v.id
                                    tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_s_filePath)
                                    tab_gameLayer_text_tt_n:setVisible(false)
                                    tab_gameLayer_text_tt_s:setVisible(false)

                                    parameter = {}

                                    local nowGameId = v.gameId
                                    dump(nowGameId, "-----nowGameId-----")
                                    if bm.groupGameConfig ~= nil then
                                        for k,v in pairs(bm.groupGameConfig) do
                                            --获取选中的游戏的组局配置
                                            if nowGameId == v.gameId then
                                                self:showSecondGameList(v)
                                                break
                                            end
                                        end
                                    end
                                    
                                end

                            end

                        )
                        content_ly:addChild(gameButton)

                        a = a + 1


                    end
                    
                end

            end

        end

        if not isiOSVerify then
            
            self:showTabGames(true)

        end

    end

end
--@zc 显示全部的纸牌类游戏
function Scene:showZhiPaiGameList()

    dump(bm.gameList, "-----游戏列表-----")
    
     --@zc 纸牌类的话显示斗地主
     if bm.groupGameConfig ~= nil then
        for k,v in pairs(bm.groupGameConfig) do
            if v.gameName =="斗地主"then
                self:showSecondGameList(v)
                break
            end
        end
    end
    if createGroupCsb == nil then
        return
    end

    gamelist_sv = createGroupCsb:getChildByName("gamelist_sv")
    if gamelist_sv == nil then
        return
    end

    area_arr = {}
    tab_arr = {}
    tabButton_arr = {}
    selectedTabIndex = 1

    game_arr = {}
    selectedGameIndex = nil

    content_ly = gamelist_sv:getChildByName("content_ly")

    local typeCount = 0
    local gameCount = 0
    --@ZC 显示游戏列表   136   -47
    local setPos =40  
    if isiOSVerify then

        bm.gameList = {}

        local xuezhantable = {}
        xuezhantable["id"] = 1
        xuezhantable["code"] = "majiang"
        xuezhantable["gameId"] = 4
        xuezhantable["gameType"] = "麻将游戏"
        xuezhantable["isShow"] = 1
        xuezhantable["name"] = "血战麻将"
        xuezhantable["status"] = "2"
        xuezhantable["type"] = 2
        xuezhantable["version"] = "1.4.105"

        local gameArr = {}
        table.insert(gameArr, xuezhantable)

        local gameInfo = {}
        gameInfo["gameType"] = "麻将游戏"
        gameInfo["gameArr"] = gameArr
        table.insert(bm.gameList, gameInfo)

    end

    if bm.gameList ~= nil then
        for k,v in pairs(bm.gameList) do

            typeCount = typeCount + 1

            -- if typeCount == 1 then
            --     GroupStart_arr[typeCount] = 0
            -- else
            --     GroupStart_arr[typeCount] = 0
            --     for k,v in pairs(GroupHeight_arr) do
            --         GroupStart_arr[typeCount] = GroupStart_arr[typeCount] + v
            --     end
            -- end

            -- GroupHeight_arr[typeCount] = 0

            local typeGameList = v["gameArr"]
        
            dump(typeGameList)
            --显示当前分类下的游戏
            if typeGameList ~= nil then
           
              dump(typeGameList)
                local a = 1
                for k,v in pairs(typeGameList) do

                    if v.isShow == 1 and v.gameType =="扑克类" then 
                       
                        gameCount = gameCount + 1
                        setPos = setPos-70
                        --添加游戏按钮
                        local tab_gameLayer = cc.CSLoader:createNode(CreateGroup_TabGame_Csb_filePath)
                        tab_gameLayer:setAnchorPoint(0.5,0.5)
                        tab_gameLayer:setPosition(130,setPos)
                       -- tab_gameLayer:setScale(1)
                        tab_gameLayer:setTag(1000)
                        content_ly:addChild(tab_gameLayer)
                        game_arr[v.id] = tab_gameLayer
                       
                        --显示游戏名称
                        local tab_gameLayer_content_ly = tab_gameLayer:getChildByName("content_ly")
                        tab_gameLayer_content_ly:setTouchEnabled(true)

                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                        --游戏名称
                        local gameName = v.name
                        if v.name == "孝感卡五星" then
                            gameName = "卡五星"
                        elseif v.name == "转转麻将" then
                            gameName = "红中麻将"
                        elseif v.name == "二人转转" then
                            gameName = "二人红中"
                        elseif v.name == "三人转转" then
                            gameName = "三人红中"
                        elseif v.name == "快速转转" then
                            gameName = "快速红中"
                        elseif v.name == "扎金花" then
                            gameName = "拼三张"
                        elseif v.name == "抢庄牛牛" then
                            gameName = "斗牛"
                        elseif v.name == "3D红中" then
                            gameName = "红中麻将"
                        end

                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                        tab_gameLayer_text_tt_n:setString(gameName)
                       -- tab_gameLayer_text_tt_n:setScale(1)
                        tab_gameLayer_text_tt_n:setVisible(true)

                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                        tab_gameLayer_text_tt_s:setString(gameName)
                       -- tab_gameLayer_text_tt_s:setScale(1)
                        tab_gameLayer_text_tt_s:setVisible(true)

                        --定义一个按钮
                        local gameButton = ccui.Button:create()
                        gameButton:setTouchEnabled(true)
                        gameButton:setAnchorPoint(0.5,0.5)
                        gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                        gameButton:setPosition(130,setPos)
                       -- gameButton:setScale(1)
                        gameButton:setTag(1001)
                        gameButton:addTouchEventListener(

                            function(sender,event)

                                if event == TOUCH_EVENT_BEGAN then

                                end

                                --触摸取消
                                if event == TOUCH_EVENT_CANCELED then

                                end

                                --触摸结束
                                if event == TOUCH_EVENT_ENDED then
                                    cc.SimpleAudioEngine:getInstance():playEffect("hall/scene/res/music/btn.mp3",false)

                                    if selectedGameIndex ~= nil then
                                        local tab_gameLayer_content_ly = game_arr[selectedGameIndex]:getChildByName("content_ly")

                                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                                        tab_gameLayer_text_tt_n:setVisible(true)

                                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                                        tab_gameLayer_text_tt_s:setVisible(false)
                                    end

                                    selectedGameIndex = v.id
                                    tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_s_filePath)
                                    tab_gameLayer_text_tt_n:setVisible(false)
                                    tab_gameLayer_text_tt_s:setVisible(true)

                                    parameter = {}

                                    local nowGameId = v.gameId
                                    dump(nowGameId, "-----nowGameId-----")
                                    if bm.groupGameConfig ~= nil then
                                        for k,v in pairs(bm.groupGameConfig) do
                                            --获取选中的游戏的组局配置
                                            if nowGameId == v.gameId then
                                                self:showSecondGameList(v)
                                                break
                                            end
                                        end
                                    end
                                    
                                end

                            end

                        )
                        content_ly:addChild(gameButton)

                        a = a + 1


                    end
                    
                end

            end

        end

        if not isiOSVerify then
            
            self:showTabGames(true)

        end

    end

end

--生成游戏列表
function Scene:showGameList(num)

  dump(bm.groupGameConfig)
    dump(bm.gameList, "-----游戏列表-----")
    --@zc 纸牌类的话显示斗地主
     if bm.groupGameConfig ~= nil and num ==1 then
        for k,v in pairs(bm.groupGameConfig) do
            if v.gameName =="斗地主"then
                self:showSecondGameList(v)
                break
            end
        end
    end

    --@zc 3D类的话显示红中王麻将
    if bm.groupGameConfig ~= nil and num==2 then
        for k,v in pairs(bm.groupGameConfig) do
            if v.gameName =="转转麻将"then
                self:showSecondGameList(v)
                break
            end
        end
    end
    --@zc 麻将类的话显示湖南麻将
    if bm.groupGameConfig ~= nil and num ==3 then
        for k,v in pairs(bm.groupGameConfig) do
            if v.gameName =="红中王"then
                self:showSecondGameList(v)
                break
            end
        end
    end
    if createGroupCsb == nil then
        return
    end

    gamelist_sv = createGroupCsb:getChildByName("gamelist_sv")
    if gamelist_sv == nil then
        return
    end

    area_arr = {}
    tab_arr = {}
    tabButton_arr = {}
    selectedTabIndex = 1

    game_arr = {}
    selectedGameIndex = nil

    content_ly = gamelist_sv:getChildByName("content_ly")
    local typeCount = 0
    local gameCount = 0

    if isiOSVerify then

        bm.gameList = {}

        --@zhj数组细分
        local xuezhantable = {}
        xuezhantable["id"] = 1
        xuezhantable["code"] = "majiang"
        xuezhantable["gameId"] = 4
        xuezhantable["gameType"] = "麻将游戏"
        xuezhantable["isShow"] = 1
        xuezhantable["name"] = "血战麻将"
        xuezhantable["status"] = "2"
        xuezhantable["type"] = 2
        xuezhantable["version"] = "1.4.105"

        local gameArr = {}
        table.insert(gameArr, xuezhantable)

        local gameInfo = {}
        gameInfo["gameType"] = "麻将游戏"
        gameInfo["gameArr"] = gameArr
        table.insert(bm.gameList, gameInfo)

    end

    if bm.gameList ~= nil then
        for k,v in pairs(bm.gameList) do
            typeCount = typeCount + 1
            
            if typeCount == 1 then
                GroupStart_arr[typeCount] = 0
            else
                GroupStart_arr[typeCount] = 0
                for k,v in pairs(GroupHeight_arr) do
                    GroupStart_arr[typeCount] = GroupStart_arr[typeCount] + v
                end
            end

            GroupHeight_arr[typeCount] = 0

            --定义并添加分类区域
            local gametype_ly = ccui.Layout:create()
            gametype_ly:setName(tostring(k) .. "_type_ly")
            gametype_ly:setAnchorPoint(cc.p(0, 1))
            -- gametype_ly:setContentSize(cc.size(300, 78))
            gametype_ly:setPosition(0, GroupStart_arr[typeCount] * -1)
            gametype_ly:setClippingEnabled(true)
            gametype_ly:setColor(cc.c3b(47,47,47))

            content_ly:addChild(gametype_ly)

            --添加分类标签 
            local tab_typeLayer = cc.CSLoader:createNode(CreateGroup_TabType_Csb_filePath)
            tab_typeLayer:setTouchEnabled(false)
            tab_typeLayer:setAnchorPoint(cc.p(0, 1))
            tab_typeLayer:setPosition(0, 0)
            tab_typeLayer:setLocalZOrder(1000)
            gametype_ly:addChild(tab_typeLayer)
            GroupHeight_arr[typeCount] = GroupHeight_arr[typeCount] + 88

            --显示分类名称
            local tab_typeLayer_content_ly = tab_typeLayer:getChildByName("content_ly")
            tab_typeLayer_content_ly:setTouchEnabled(false)

            --分类背景图片
            local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
            tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_n_filePath)
            tab_typeLayer_bg_iv:setTouchEnabled(false)

            --zc@  20170711  显示文字图片 按钮点击之前的


            local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
            tab_typeLayer_text_tt_n:setTouchEnabled(false)
            tab_typeLayer_text_tt_n:setString(tostring(v["gameType"]))
            tab_typeLayer_text_tt_n:setTag(typeCount)

            area_arr[typeCount] = gametype_ly
            tab_arr[typeCount] = tab_typeLayer

            local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
            tab_typeLayer_text_tt_s:setTouchEnabled(false)
            tab_typeLayer_text_tt_s:setString(tostring(v["gameType"]))


            local typeGameList = v["gameArr"]
            dump(typeGameList, "------typeGameList------")
            local typeGameCount = 0
            if typeGameList ~= nil then
                for k,v in pairs(typeGameList) do
                    if v.isShow == 1 then
                        typeGameCount = typeGameCount + 1
                    end
                end
            end

            local typeHeight = typeGameCount * 78 + 88
            tab_typeLayer:setPosition(cc.p(0, typeHeight))
            gametype_ly:setContentSize(cc.size(300, typeHeight))

            --定义一个按钮
            local typeButton = ccui.Button:create()
            typeButton:setTouchEnabled(true)
            typeButton:setAnchorPoint(cc.p(0.5, 0.5))
            typeButton:setTag(typeCount)
            typeButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
            typeButton:setPosition(cc.p(130, typeHeight - 40))
            typeButton:addTouchEventListener(

                function(sender,event)

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

                        -- if selectedTabIndex ~= sender:getTag() then
                        --     --todo
                            self:showTabGames(false, sender:getTag())
                        -- end
                    end

                end

            )
            gametype_ly:addChild(typeButton, 5000)
            tabButton_arr[typeCount] = typeButton

            --显示当前分类下的游戏
            if typeGameList ~= nil then
                
                local a = 1
                for k,v in pairs(typeGameList) do

                    if v.isShow == 1 then

                        gameCount = gameCount + 1

                        --添加游戏按钮
                        local tab_gameLayer = cc.CSLoader:createNode(CreateGroup_TabGame_Csb_filePath)
                        tab_gameLayer:setAnchorPoint(cc.p(0, 1))
                        tab_gameLayer:setPosition(10, typeHeight - 85 - (a - 1) * 78)
                        tab_gameLayer:setScale(0.9)
                        tab_gameLayer:setTag(1000)
                        gametype_ly:addChild(tab_gameLayer)
                        game_arr[v.id] = tab_gameLayer
                        GroupHeight_arr[typeCount] = GroupHeight_arr[typeCount] + 78

                        --显示游戏名称
                        local tab_gameLayer_content_ly = tab_gameLayer:getChildByName("content_ly")
                        tab_gameLayer_content_ly:setTouchEnabled(false)

                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                        --游戏名称
                        local gameName = v.name
                        if v.name == "孝感卡五星" then
                            gameName = "卡五星"
                        elseif v.name == "转转麻将" then
                            gameName = "红中麻将"
                        elseif v.name == "二人转转" then
                            gameName = "二人红中"
                        elseif v.name == "三人转转" then
                            gameName = "三人红中"
                        elseif v.name == "快速转转" then
                            gameName = "快速红中"
                        elseif v.name == "诈金花" then
                            gameName = "拼三张"
                        elseif v.name == "抢庄牛牛" then
                            gameName = "斗牛"
                        elseif v.name == "扎金花" then
                            gameName = "拼三张"
                        elseif v.name == "3D红中" then
                            gameName = "红中麻将"
                        end

                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                        tab_gameLayer_text_tt_n:setString(gameName)
                        tab_gameLayer_text_tt_n:setScale(1.2)
                        tab_gameLayer_text_tt_n:setVisible(true)

                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                        tab_gameLayer_text_tt_s:setString(gameName)
                        tab_gameLayer_text_tt_s:setScale(1.2)
                        tab_gameLayer_text_tt_s:setVisible(false)

                        --定义一个按钮
                        local gameButton = ccui.Button:create()
                        gameButton:setTouchEnabled(true)
                        gameButton:setAnchorPoint(cc.p(0.5, 0.5))
                        gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                        gameButton:setPosition(cc.p(128, typeHeight - 120 - (a - 1) * 78))
                        gameButton:setScale(0.9)
                        gameButton:setTag(1001)
                        gameButton:addTouchEventListener(

                            function(sender,event)

                                if event == TOUCH_EVENT_BEGAN then

                                end

                                --触摸取消
                                if event == TOUCH_EVENT_CANCELED then

                                end

                                --触摸结束
                                if event == TOUCH_EVENT_ENDED then

                                    if selectedGameIndex ~= nil then
                                        local tab_gameLayer_content_ly = game_arr[selectedGameIndex]:getChildByName("content_ly")

                                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                                        tab_gameLayer_text_tt_n:setVisible(true)

                                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                                        tab_gameLayer_text_tt_s:setVisible(false)
                                    end

                                    selectedGameIndex = v.id
                                    tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_s_filePath)
                                    tab_gameLayer_text_tt_n:setVisible(false)
                                    tab_gameLayer_text_tt_s:setVisible(true)

                                    parameter = {}

                                    local nowGameId = v.gameId
                                    dump(nowGameId, "-----nowGameId-----")
                                    if bm.groupGameConfig ~= nil then
                                        for k,v in pairs(bm.groupGameConfig) do
                                            --获取选中的游戏的组局配置
                                            if nowGameId == v.gameId then
                                                self:showSecondGameList(v)
                                                break
                                            end
                                        end
                                    end
                                    
                                end

                            end

                        )
                        gametype_ly:addChild(gameButton)
                        a = a + 1
                    end   
                end
            end
        end
        if not isiOSVerify then
            self:showTabGames(true,IsShow_)

        end

    end

end

--伸缩列表
function Scene:showTabGames(isInit, clickTag)

    if isInit then
        --todo
        selectedTabIndex = clickTag

        local totalHeight = 0

        for i,v in ipairs(GroupHeight_arr) do
            if i ~= selectedTabIndex then
                --todo
                totalHeight = totalHeight + 88
            else
                totalHeight = totalHeight + v
            end
        end

        -- totalHeight = totalHeight + 20

        -- if totalHeight < gamelist_sv:getContentSize().height then
        --         --todo
        --         totalHeight = gamelist_sv:getContentSize().height
        --     end

        -- content_ly:setPosition(0, totalHeight)
        -- gamelist_sv:setInnerContainerSize(cc.size(290.00, totalHeight))

        local h = 0
        for i,v in ipairs(area_arr) do
            if i ~= selectedTabIndex then
                --todo
                v:setSize(v:getSize().width, 88)

                tab_arr[i]:setPosition(cc.p(0, 88))
                tabButton_arr[i]:setPosition(cc.p(130, 48))

                --设置未选中状态
                local tab_typeLayer_content_ly = tab_arr[i]:getChildByName("content_ly")

                local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
                tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_s_filePath)

                local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
                tab_typeLayer_text_tt_n:setVisible(false)

                local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
                tab_typeLayer_text_tt_s:setVisible(true)

            else
                v:setSize(v:getSize().width, GroupHeight_arr[i])

                --设置选中状态
                local tab_typeLayer_content_ly = tab_arr[i]:getChildByName("content_ly")

                local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
                tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_n_filePath)

                local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
                tab_typeLayer_text_tt_n:setVisible(true)

                local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
                tab_typeLayer_text_tt_s:setVisible(false)

            end

            v:setPosition(cc.p(v:getPosition().x, - h))

            h = h + v:getSize().height
        end
    else
        if selectedTabIndex == clickTag then
            --todo
            local totalHeight = 0

            for i,v in ipairs(GroupHeight_arr) do
                totalHeight = totalHeight + 88
            end

            totalHeight = totalHeight + 20

            if totalHeight < gamelist_sv:getContentSize().height then
                --todo
                totalHeight = gamelist_sv:getContentSize().height
            end

          --  content_ly:setPosition(0, totalHeight)
            gamelist_sv:setInnerContainerSize(cc.size(290.00, totalHeight))
            
            self:openOrCloseTabGames(false, selectedTabIndex)

            local offsetY_arr = {}
            for i,v in ipairs(area_arr) do
                table.insert(offsetY_arr, 0)
            end

            for i,v in ipairs(area_arr) do
                if i > selectedTabIndex then
                    --todo
                    offsetY_arr[i] = offsetY_arr[i] + (GroupHeight_arr[selectedTabIndex] - 88)
                end
            end

            for i,v in ipairs(area_arr) do
                v:runAction(cc.MoveTo:create(0.2, cc.p(0, v:getPosition().y + offsetY_arr[i])))
            end

            selectedTabIndex = 999

            return
        end
        local totalHeight = 0

        for i,v in ipairs(GroupHeight_arr) do
            if i ~= clickTag then
                --todo
                totalHeight = totalHeight + 88
            else
                totalHeight = totalHeight + v
            end
        end

        totalHeight = totalHeight + 20

        if totalHeight < gamelist_sv:getContentSize().height then
                --todo
                totalHeight = gamelist_sv:getContentSize().height
            end
            
       -- content_ly:setPosition(0, totalHeight)
        gamelist_sv:setInnerContainerSize(cc.size(290.00, totalHeight))
        
        self:openOrCloseTabGames(true, clickTag)

        if selectedTabIndex ~= 999 then
            --todo
            self:openOrCloseTabGames(false, selectedTabIndex)
        end
        

        local offsetY_arr = {}
        for i,v in ipairs(area_arr) do
            table.insert(offsetY_arr, 0)
        end

        for i,v in ipairs(area_arr) do
            if i > selectedTabIndex then
                --todo
                offsetY_arr[i] = offsetY_arr[i] + (GroupHeight_arr[selectedTabIndex] - 88)
            end
            if i > clickTag then
                --todo
                offsetY_arr[i] = offsetY_arr[i] - (GroupHeight_arr[clickTag] - 88)
            end
        end

        for i,v in ipairs(area_arr) do
            v:runAction(cc.MoveTo:create(0.2, cc.p(0, v:getPosition().y + offsetY_arr[i])))
        end

        selectedTabIndex = clickTag
    end


end

function Scene:openOrCloseTabGames(isOpen, index)
    dump(area_arr[index])
    local game_ly = area_arr[index]

    if isOpen then
        --todo
        game_ly:setContentSize(cc.size(game_ly:getContentSize().width, GroupHeight_arr[index]))

        local count = 0
        for i,v in ipairs(game_ly:getChildren()) do
            if v:getTag() < 1000 then
                --todo
                v:setPosition(cc.p(0, GroupHeight_arr[index]))
                tabButton_arr[index]:setPosition(cc.p(130, GroupHeight_arr[index] - 40))
            else
                if v:getTag() ~= 1001 then
                    v:runAction(cc.MoveTo:create(0.3, cc.p(10, GroupHeight_arr[index] - 88 - count * 78)))
                    count = count + 1
                end
            end
        end

        --设置未选中状态
        local tab_typeLayer_content_ly = tab_arr[index]:getChildByName("content_ly")

        local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
        tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_n_filePath)

        local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
        tab_typeLayer_text_tt_n:setVisible(true)

        local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
        tab_typeLayer_text_tt_s:setVisible(false)

    else
        game_ly:setContentSize(cc.size(game_ly:getContentSize().width, 88))

        for i,v in ipairs(game_ly:getChildren()) do
            if v:getTag() < 1000 then
                --todo
                v:setPosition(cc.p(0, 88))
                tabButton_arr[index]:setPosition(cc.p(130, 48))
            else
                if v:getTag() ~= 1001 then
                    v:runAction(cc.MoveTo:create(0.3, cc.p(10, 88)))
                end
            end
        end

        --设置选中状态
        local tab_typeLayer_content_ly = tab_arr[index]:getChildByName("content_ly")

        local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
        tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_s_filePath)

        local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
        tab_typeLayer_text_tt_n:setVisible(false)

        local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
        tab_typeLayer_text_tt_s:setVisible(true)

    end

end

--生成二级游戏列表
function Scene:showSecondGameList(gameConfig)

    if createGroupCsb == nil then
        return
    end

    parameter = {}

    local gameConfigArr = {}
    table.insert(gameConfigArr, gameConfig)

    local otherGameArr = gameConfig.otherGame
    if otherGameArr ~= nil then
        for k,v in pairs(otherGameArr) do
            table.insert(gameConfigArr, v)
        end
    end

    if #gameConfigArr == 0 then
        return
    end

    local config_ly = createGroupCsb:getChildByName("config_ly")
    if config_ly == nil then
        return
    end

    local gametypelist_sv = config_ly:getChildByName("gametypelist_sv")
    -- gametypelist_sv:setTouchEnabled(false)

    local content_ly = gametypelist_sv:getChildByName("content_ly")
    content_ly:removeAllChildren()

    --初始化游戏按钮数组
    gameButton_arr = {}
    for k,v in pairs(gameConfigArr) do
        
        local tab_ItemLayer = cc.CSLoader:createNode(CreateGroup_TabItem_Csb_filePath)
        tab_ItemLayer:setPosition(137.00 * (k - 1), -70.00)
        content_ly:addChild(tab_ItemLayer)
        gameButton_arr[k] = tab_ItemLayer

        --定义一个按钮
        local gameButton = ccui.Button:create()
        gameButton:setTouchEnabled(true)
        gameButton:setAnchorPoint(cc.p(0.5, 0.5))
        gameButton:loadTextures(CreateGroup_TabItemBg_blank_filePath, nil, nil)
        gameButton:setPosition(cc.p(137.00 * (k - 1) + 68, -28.00))
        content_ly:addChild(gameButton)

        --显示游戏名称布局
        local tab_ItemLayer_content_ly = tab_ItemLayer:getChildByName("content_ly")
        tab_ItemLayer_content_ly:setTouchEnabled(false)

        --背景图片
        local tab_ItemLayer_bg_iv = tab_ItemLayer_content_ly:getChildByName("bg_iv")
        tab_ItemLayer_bg_iv:loadTexture(CreateGroup_TabItemBg_n_filePath)

        --游戏名称
        local gameName = v.gameName
        if v.gameName == "孝感卡五星" then
            gameName = "卡五星"
        elseif v.gameName == "转转麻将" then
            gameName = "红中麻将"
        elseif v.gameName == "二人转转" then
            gameName = "二人红中"
        elseif v.gameName == "三人转转" then
            gameName = "三人红中"
        elseif v.gameName == "快速转转" then
            gameName = "快速红中"
        elseif v.gameName == "诈金花" then
            gameName = "炸金花"
        end

        local tab_ItemLayer_text_tt_n = tab_ItemLayer_content_ly:getChildByName("text_tt_n")
        tab_ItemLayer_text_tt_n:setString(gameName)
        tab_ItemLayer_text_tt_n:setVisible(true)

        local tab_ItemLayer_text_tt_s = tab_ItemLayer_content_ly:getChildByName("text_tt_s")
        tab_ItemLayer_text_tt_s:setString(gameName)
        tab_ItemLayer_text_tt_s:setVisible(false)

        --选中标记
        local tab_ItemLayer_mark_iv = tab_ItemLayer_content_ly:getChildByName("mark_iv")
        tab_ItemLayer_mark_iv:setVisible(false)

        --游戏按钮点击事件
        gameButton:addTouchEventListener(

            function(sender,event)

                if event == TOUCH_EVENT_ENDED then

                    for k,v in pairs(gameButton_arr) do
                        
                        local tab_ItemLayer = v

                        --显示游戏名称布局
                        local tab_ItemLayer_content_ly = tab_ItemLayer:getChildByName("content_ly")
                        tab_ItemLayer_content_ly:setTouchEnabled(true)

                        --背景图片
                        local tab_ItemLayer_bg_iv = tab_ItemLayer_content_ly:getChildByName("bg_iv")
                        tab_ItemLayer_bg_iv:loadTexture(CreateGroup_TabItemBg_n_filePath)

                        --游戏名称
                        local tab_ItemLayer_text_tt_n = tab_ItemLayer_content_ly:getChildByName("text_tt_n")
                        tab_ItemLayer_text_tt_n:setVisible(true)

                        local tab_ItemLayer_text_tt_s = tab_ItemLayer_content_ly:getChildByName("text_tt_s")
                        tab_ItemLayer_text_tt_s:setVisible(false)

                        --选中标记
                        local tab_ItemLayer_mark_iv = tab_ItemLayer_content_ly:getChildByName("mark_iv")
                        tab_ItemLayer_mark_iv:setVisible(false)

                    end

                    --标记选中
                    tab_ItemLayer_bg_iv:loadTexture(CreateGroup_TabItemBg_s_filePath)
                    tab_ItemLayer_text_tt_n:setVisible(false)
                    tab_ItemLayer_text_tt_s:setVisible(true)
                    tab_ItemLayer_mark_iv:setVisible(true)

                    --记录当前游戏的游戏id
                    parameter["gameId"] = v.gameId

                    --记录当前游戏对应的等级
                    parameter["level"] = v.level

                    --记录当前游戏对应的底注
                    parameter["diZhu"] = v.diZhu

                    --记录当前游戏对应的筹码
                    parameter["chouMa"] = v.chouMa

                    nowSelectGameConfig = v

                    self:showConfigView(true)

                end

            end

        )

        --显示当前游戏分类的第一个游戏配置
        if k == 1 then

            --标记选中
            tab_ItemLayer_bg_iv:loadTexture(CreateGroup_TabItemBg_s_filePath)
            tab_ItemLayer_text_tt_n:setVisible(false)
            tab_ItemLayer_text_tt_s:setVisible(true)
            tab_ItemLayer_mark_iv:setVisible(true)

            --记录当前游戏的游戏id
            parameter["gameId"] = v.gameId

            --记录当前游戏对应的等级
            parameter["level"] = v.level

            --记录当前游戏对应的底注
            parameter["diZhu"] = v.diZhu

            --记录当前游戏对应的筹码
            parameter["chouMa"] = v.chouMa
            
            nowSelectGameConfig = v

            self:showConfigView(true)

        end

    end

    -- content_ly:setPosition(0, 0)
    gametypelist_sv:setInnerContainerSize(cc.size(137.00 * #gameConfigArr, 0))

end

--生成配置界面
function Scene:showConfigView(isFirst)

    -- dump(nowSelectGameConfig, "-----当前游戏配置情况-----")

    if createGroupCsb == nil then
        return
    end

    local config_ly = createGroupCsb:getChildByName("config_ly")
    if config_ly == nil then
        return
    end
    local config_sv = config_ly:getChildByName("config_sv")

    isFirst = isFirst or false

    --定义选项区域
    local content_ly = config_sv:getChildByName("content_ly")
    content_ly:removeAllChildren()

    --记录每组分类高度数组
    local groupHeight_arr = {}

    --获取当前游戏配置
    local gameConfig = nowSelectGameConfig.gameConfig
    if #gameConfig > 0 then

        -- dump(gameConfig, "------配置分类-----")
        print("999999999999999999999999")
        dump(nowSelectGameConfig)
        print("999999999999999999999999")
        for gameConfig_p,v in pairs(gameConfig) do
           
            --添加配置分类显示区域
            local class_ly = ccui.Layout:create()
            class_ly:setAnchorPoint(cc.p(0,1))
            class_ly:setContentSize(cc.size(0, 0))
            class_ly:setTouchEnabled(false) 
            content_ly:addChild(class_ly)

            --定义配置分类显示区域高度
            local class_ly_height = 0

            --获取配置分类名
            local configShowName = v.configShowName

            groupHeight_arr[gameConfig_p] = {} 

            --添加配置分类标题
            local ConfigShowName_Csb = cc.CSLoader:createNode(CreateGroup_ConfigShowName_Csb_filePath)
            ConfigShowName_Csb:setPosition(0,-30)  --这里是小标题（局数，包房...）显示的位置
            class_ly:addChild(ConfigShowName_Csb)

            local configShowName_tt = ConfigShowName_Csb:getChildByName("configShowName_tt")
            configShowName_tt:setString(configShowName)

            --获取配置选项组
            local configGroup = v.configGroup
            dump(configGroup,"当前的游戏具体配置是")
            if #configGroup > 0 then

                for configGroup_p,v in pairs(configGroup) do

                    local group_ly = ccui.Layout:create()
                    group_ly:setAnchorPoint(cc.p(0,1))
                    group_ly:setContentSize(cc.size(0, 0))
                    group_ly:setTouchEnabled(false)
                    class_ly:addChild(group_ly)

                    local config = v.config
                    -- dump(config, "------配置组名,用作key-----")

                    local isCheckBox = v.isCheckBox
                    -- dump(isCheckBox, "------是否多选-----")

                    local configOption = v.configOption
                    -- dump(configOption, "------配置选项-----")
                    dump(configOption,"当前游戏的具体选项是")
                    print(#configOption)
                    if #configOption > 0 then

                        --根据选项数计算显示区域行高
                        local line = #configOption / 3  --除以3是每行最多排三个，根据line来排列行数
                      --  if line >  math.floor(line) then  -- 返回小于line的最大整数
                            line = math.floor(line) + 1
                      --  end
                        -- dump(line, "------line-----")

                        local group_ly_height = 60 * line

                        groupHeight_arr[gameConfig_p][configGroup_p] = group_ly_height
                      

                        group_ly:setPosition(0, (class_ly_height * -1)-15)
                        local a=group_ly:getPosition()
                        print("----------------------------------")
                        dump(a,"weihzi")
                        print("----------------------------------")
                        class_ly_height = class_ly_height + group_ly_height

                        if isCheckBox == 0 then
                            dump(configOption,"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
                            for configOption_p,v in pairs(configOption) do

                                --定义单选项
                                local circle_select = cc.CSLoader:createNode(CreateGroup_CircleSelect_Csb_filePath)
                                group_ly:addChild(circle_select)

                                local select_ly = circle_select:getChildByName("select_ly")
                                select_ly:setTouchEnabled(false)
                                select_ly:setAnchorPoint(cc.p(0,1))
                                select_ly:setScale(0.9)

                                --按顺序排列显示选项
                                local x = 0
                                local y = 0
                                local a = configOption_p - 1
                                if a % 3 == 0 then
                                    x = (select_ly:getContentSize().width + 0) * 0 + 40
                                elseif a % 3 == 1 then
                                    x = (select_ly:getContentSize().width + 0) * 1 + 40
                                elseif a % 3 == 2 then
                                    x = (select_ly:getContentSize().width + 0) * 2 + 40
                                end
                                y = ((select_ly:getContentSize().height + 20) * math.floor(a / 3) * -1)
                                select_ly:setPosition(x, y)
                                local b=select_ly:getPosition()
                                print("88888888888888888888888888888888888")
                                dump(b,"danqgiand e ")
                                print("88888888888888888888888888888888888")
                                --定义一个按钮
                                local gameButton = ccui.Button:create()
                                gameButton:setTouchEnabled(true)
                                gameButton:setAnchorPoint(cc.p(0.5, 0.5))
                                gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                                gameButton:setPosition(x + 75, y - 30)
                                gameButton:setScale(0.7)
                                group_ly:addChild(gameButton)
                                
                                --设置选项显示内容 
                                local select_im = select_ly:getChildByName("select_im")
                                local Image_34 = select_ly:getChildByName("Image_34")
                                Image_34:setScale(0.7)
                                local select_tt_1 = select_ly:getChildByName("select_tt_1")
                                select_tt_1:setString(v.optionName)
                                --select_tt_1:setColor(cc.c3b(115,120,48))
                                -- select_tt_1:setColor(cc.c3b(149,65,5))

                                local select_tt_2 = select_ly:getChildByName("select_tt_2")
                                select_tt_2:setString("")
                                --select_tt_2:setColor(cc.c3b(115,120,48))
                               --  select_tt_2:setColor(cc.c3b(149,65,5))
                                if not isiOSVerify then
                                    if config == "round" then
                                        if v.cardCount ~= nil then
                                            if v.aaCardCount ~= nil then
                                                select_tt_2:setString("（包房 X" .. v.cardCount .. ")".."\n".."（AA X"..v.aaCardCount.. ")")
                                            else
                                                select_tt_2:setString("（包房 X" .. v.cardCount .. ")")
                                            end
                                        end
                                    end
                                end

                                if v.isDefualt == 1 then
                                    --记录默认值到控件  勾
                                    select_im:loadTexture(CreateGroup_ConfigCheck_G_filePath)--CreateGroup_ConfigRadio_s_filePath)
                                    select_im:setScale(0.7)
                                    --记录默认上传参数
                                    local select = {}
                                    select["optionName"] = v.optionName
                                    select["optionValue"] = v.optionValue

                                    parameter[config] = select

                                else --框
                                    select_im:loadTexture(CreateGroup_ConfigCheck_K_filePath)
                                    select_im:setScale(0.7)
                                end

                                --选项点击事件
                                gameButton:addTouchEventListener(

                                    function(sender,event)
                                        --触摸开始
                                        if event == TOUCH_EVENT_BEGAN then

                                        end

                                        --触摸取消
                                        if event == TOUCH_EVENT_CANCELED then

                                        end

                                        --触摸结束
                                        if event == TOUCH_EVENT_ENDED then

                                            --重置当前选项组的选中清空
                                            local configOption = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption
                                            for k,v in pairs(configOption) do
                                                v.isDefualt = 0
                                            end

                                            --更新配置
                                            nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt = 1

                                            --更新关联项
                                            local relateConfigArr = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].relateConfigArr
                                            local newisDefualt = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt
                                            self:updateRelateConfig(relateConfigArr, newisDefualt)

                                            self:showConfigView()


                                        end
                                    end

                                )
                            
                            end

                        else

                            --添加默认值到提交参数
                            local select = {}
                            select["optionName"] = ""
                            select["optionValue"] = ""

                            for configOption_p,v in pairs(configOption) do

                                --定义选择项
                                local tick_select = cc.CSLoader:createNode(CreateGroup_TickSelect_Csb_filePath)
                                group_ly:addChild(tick_select)

                                local select_ly = tick_select:getChildByName("select_ly")
                                select_ly:setTouchEnabled(false)
                                select_ly:setAnchorPoint(cc.p(0,1))
                                select_ly:setScale(0.9)


                                local x = 0
                                local y = 0
                                local a = configOption_p - 1
                                if a % 3 == 0 then
                                    x = (select_ly:getContentSize().width + 0) * 0 + 38
                                elseif a % 3 == 1 then

                                --@Levan 抢庄 名牌牛牛 (垃圾代码)
                                    if nowSelectGameConfig["gameId"] == 516 or nowSelectGameConfig["gameId"] == 515 then 
                                        x = (select_ly:getContentSize().width + 0) * 1 + 240
                                    else
                                        x = (select_ly:getContentSize().width + 0) * 1 + 38
                                    end

                                elseif a % 3 == 2 then
                                    x = (select_ly:getContentSize().width + 0) * 2 + 38
                                end
                                y = (select_ly:getContentSize().height + 20) * math.floor(a / 3) * -1
                                select_ly:setPosition(x, y)

                                --定义一个按钮
                                local gameButton = ccui.Button:create()
                                gameButton:setTouchEnabled(true)
                                gameButton:setAnchorPoint(cc.p(0.5, 0.5))
                                gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                                gameButton:setPosition(x + 75, y - 30)
                                gameButton:setScale(0.7)
                                group_ly:addChild(gameButton)
                                
                                local select_im = select_ly:getChildByName("select_im")
                                local Image_1 = select_ly:getChildByName("Image_1")
                                Image_1:setScale(0.7)
                                local select_tt_1 = select_ly:getChildByName("select_tt_1")
                                select_tt_1:setString(v.optionName)
                               -- select_tt_1:setColor(cc.c3b(115, 120, 48))

                                --添加默认选项
                                if v.isDefualt == 1 then

                                    select_im:loadTexture(CreateGroup_ConfigCheck_G_filePath)
                                    select_im:setScale(0.7)

                                    select["optionName"] = select["optionName"] .. v.optionName .. " "
                                    select["optionValue"] = select["optionValue"] .. v.optionValue .. ","

                                else
                                    select_im:loadTexture(CreateGroup_ConfigCheck_K_filePath)
                                    select_im:setScale(0.7)
                                end

                                --选项点击事件
                                gameButton:addTouchEventListener(

                                    function(sender,event)
                                        --触摸开始
                                        if event == TOUCH_EVENT_BEGAN then

                                        end

                                        --触摸取消
                                        if event == TOUCH_EVENT_CANCELED then

                                        end

                                        --触摸结束
                                        if event == TOUCH_EVENT_ENDED then

                                            --更新配置
                                            local isDefualt = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt
                                            if isDefualt == 1 then
                                                nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt = 0
                                            else
                                                nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt = 1
                                            end

                                            --更新关联项
                                            local relateConfigArr = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].relateConfigArr
                                            local newisDefualt = nowSelectGameConfig.gameConfig[gameConfig_p].configGroup[configGroup_p].configOption[configOption_p].isDefualt
                                            self:updateRelateConfig(relateConfigArr, newisDefualt)

                                            self:showConfigView()

                                        end
                                    end

                                )
                            
                            end
                            --添加默认项
                            select["optionName"] = string.sub(select["optionName"], 1, string.len(select["optionName"]) - 1)
                            select["optionValue"] = string.sub(select["optionValue"], 1, string.len(select["optionValue"]) - 1)
                            parameter[config] = select

                        end
                        
                    end

                end
            end

            dump(groupHeight_arr, "-----groupHeight_arr-----")

            local class_y = 0
            if gameConfig_p > 1 then
                for a,b in pairs(groupHeight_arr) do
                    if a < gameConfig_p then
                        for c,d in pairs(b) do
                            class_y = class_y + d
                        end
                    end
                end
            end
            class_ly:setPosition(60, class_y * -1)

        end
        
        local allHeight = 0
        for a,b in pairs(groupHeight_arr) do
            for c,d in pairs(b) do
                allHeight = allHeight + d
            end
        end

        if allHeight > 335.00 then
            content_ly:setPosition(0, allHeight)
        else
            content_ly:setPosition(0, 445.00)  --更改配置列表显示高度
        end

        if isFirst then
            --设置内容显示区域大小  708
            config_sv:setInnerContainerSize(cc.size(1050.00, allHeight))
        end

        dump(parameter, "-----默认配置-----")

    end

end

--更新关联项
function Scene:updateRelateConfig(relateConfigArr, require)

    dump(relateConfigArr, "-----选项关联项组-----")
    dump(require, "-----关联要求-----")

    if relateConfigArr ~= nil then
                                                
        for k,v in pairs(relateConfigArr) do

            dump(v, "-----选项关联项组-----")
            
            --关联项所在位置
            local relateConfigArrShowNamePosition = v.relateConfigArrShowNamePosition
            local relateConfigPosition = v.relateConfigPosition
            local relateConfigOptionPosition = v.relateConfigOptionPosition

            --关联项是否为多选
            local relateConfigisCheckBox = v.relateConfigisCheckBox

            --关联项触发条件
            local relateRequire = v.relateRequire

            if relateRequire == require then

                --关联操作是否为设置默认值
                local relateHandleIsSetDefualt = v.relateHandleIsSetDefualt
                
                --关联项触发操作
                local relateHandle = v.relateHandle

                --进行关联操作
                if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition] ~= nil then
                    if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition] ~= nil then
                        if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition] ~= nil then

                            --假如当前关联选项组是单选
                            if relateConfigisCheckBox == 0 then

                                if relateHandleIsSetDefualt == 1 then

                                    --判断当前选项组是否已经有选中值
                                    local ishasdefual = 0
                                    local configOption = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption
                                    if configOption ~= nil then
                                        for k,v in pairs(configOption) do
                                            if v.isDefualt == 1 then
                                                ishasdefual = 1
                                            end
                                        end
                                    end

                                    --当前没有选中值，设置默认值
                                    if ishasdefual == 0 then
                                        
                                        if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt ~= relateHandle then
                                
                                            if relateHandle == 0 then
                                                nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 0
                                            
                                            elseif relateHandle == 1 then
                                                nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 1
                                            
                                            end

                                            --更新关联项的关联项
                                            local newRelateConfigArr = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].relateConfigArr
                                            local newRelateisDefualt = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt
                                            self:updateRelateConfig(newRelateConfigArr, newRelateisDefualt)

                                        end
                                        
                                    end

                                else

                                    --重置当前选项组的选中项
                                    local configOption = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption
                                    if configOption ~= nil then
                                        for k,v in pairs(configOption) do
                                            v.isDefualt = 0
                                        end
                                    end

                                    if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt ~= relateHandle then
                                
                                        if relateHandle == 0 then
                                            nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 0
                                        
                                        elseif relateHandle == 1 then
                                            nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 1
                                        
                                        end

                                        --更新关联项的关联项
                                        local newRelateConfigArr = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].relateConfigArr
                                        local newRelateisDefualt = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt
                                        self:updateRelateConfig(newRelateConfigArr, newRelateisDefualt)

                                    end

                                end

                            else

                                if nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt ~= relateHandle then
                                
                                    if relateHandle == 0 then
                                        nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 0
                                    
                                    elseif relateHandle == 1 then
                                        nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt = 1
                                    
                                    end

                                    --更新关联项的关联项
                                    local newRelateConfigArr = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].relateConfigArr
                                    local newRelateisDefualt = nowSelectGameConfig.gameConfig[relateConfigArrShowNamePosition].configGroup[relateConfigPosition].configOption[relateConfigOptionPosition].isDefualt
                                    self:updateRelateConfig(newRelateConfigArr, newRelateisDefualt)

                                end
                                
                            end

                        end

                    end

                end

            end

        end

    end

end

--拷贝table
function Scene:deepCopy(newTble, oldTbl)

    if oldTbl == nil then  
        return  
    end  

    for key,value in pairs(oldTbl) do  
        if type(value) == "table" then  
            newTble[key] = {}  
            self:deepCopy(newTble[key], value)  
        elseif type(value) == "userdata" then  
            newTble[key] = value  
        elseif type(value) == "thread" then  
            newTble[key] = value  
        else  
            newTble[key] = value  
        end  
    end
  
end

--按照传入的分隔符，切割字符串
function LuaSplit(str, split_char)  
    if str == "" or str == nil then   
        return {};  
    end  
    local split_len = string.len(split_char)  
    local sub_str_tab = {};  
    local i = 0;  
    local j = 0;  
    while true do  
        j = string.find(str, split_char,i+split_len);--从目标串str第i+split_len个字符开始搜索指定串  
        if string.len(str) == i then   
            break;  
        end  
  
  
        if j == nil then  
            table.insert(sub_str_tab,string.sub(str,i));  
            break;  
        end;  
  
  
        table.insert(sub_str_tab,string.sub(str,i,j-1));  
        i = j+split_len;  
    end  
    return sub_str_tab;  
end

return Scene
