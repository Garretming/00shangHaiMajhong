
local introduceScene = class("introduceScene")

local GroupStart_arr = {}
local GroupHeight_arr = {}

local gamelist_sv
local content_ly
 
function introduceScene:showScene()

    layout = cc.CSLoader:createNode(IntroduceCsb_filePath):addTo(SCENENOW["scene"])
    layout:setName("introduceScene")
--    require("hall.GameCommon"):commomButtonAnimation(layout)
    local floor = layout:getChildByName("floor")

    --@Levan调整关闭按钮层级
    local back_bt = layout:getChildByName("back_bt")
    local web_plane = floor:getChildByName("web_plane")

    local function touchButtonEvent(sender, event)
        if event == TOUCH_EVENT_ENDED then
            if sender == back_bt then
                self:removeScene()
            end
        end
    end

    back_bt:addTouchEventListener(touchButtonEvent)

    self:showGameList()

end

--生成游戏列表
function introduceScene:showGameList()

    dump(bm.gameList, "-----游戏列表-----")

    if layout == nil then
        return
    end

    gamelist_sv = layout:getChildByName("gamelist_sv")
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
    content_ly:setScale(0.8)

    local typeCount = 0
    local gameCount = 0
    --@zc 显示位置问题
    local setPos = 32

    if isiOSVerify then

        bm.gameInfoList = {}

        dump(bm.gameInfoList , "-----bmfoList-----")
        bm.gameInfoList["麻将游戏"] = {}
        local table = {}
        table["code"] = "majiang"
        table["gameId"] = 4
        table["gameType"] = "麻将游戏"
        table["isShow"] = 1
        table["name"] = "血战麻将"
        table["status"] = "2"
        table["type"] = 2
        table["version"] = "1.4.105"
        bm.gameInfoList["麻将游戏"][1] = table

    end

    if bm.gameInfoList ~= nil then
        
        for k,v in pairs(bm.gameInfoList) do

            dump(v, "-----bm.gameInfoList-----")

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

 --@zc只显示当前客户需要的几个游戏的玩法介绍

            -- --定义并添加分类区域
            -- local gametype_ly = ccui.Layout:create()
            -- gametype_ly:setName(tostring(k) .. "_type_ly")
            -- gametype_ly:setAnchorPoint(cc.p(0, 1))
            -- -- gametype_ly:setContentSize(cc.size(300, 78))
            -- gametype_ly:setPosition(0, GroupStart_arr[typeCount] * -1)
            -- gametype_ly:setClippingEnabled(true)
            -- gametype_ly:setColor(cc.c3b(47,47,47))

            -- content_ly:addChild(gametype_ly)

            -- --添加分类标签
            -- local tab_typeLayer = cc.CSLoader:createNode(CreateGroup_TabType_Csb_filePath)
            -- tab_typeLayer:setTouchEnabled(false)
            -- tab_typeLayer:setAnchorPoint(cc.p(0, 1))
            -- tab_typeLayer:setPosition(0, 0)
            -- tab_typeLayer:setLocalZOrder(1000)
            -- gametype_ly:addChild(tab_typeLayer)
            -- GroupHeight_arr[typeCount] = GroupHeight_arr[typeCount] + 88

            -- --显示分类名称
            -- local tab_typeLayer_content_ly = tab_typeLayer:getChildByName("content_ly")
            -- tab_typeLayer_content_ly:setTouchEnabled(false)

            -- --背景图片
            -- local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
            -- tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_n_filePath)
            -- tab_typeLayer_bg_iv:setTouchEnabled(false)

            -- local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
            -- tab_typeLayer_text_tt_n:setTouchEnabled(false)
            -- tab_typeLayer_text_tt_n:setString(tostring(v[1]["gameType"]))
            -- tab_typeLayer_text_tt_n:setTag(typeCount)

            -- area_arr[typeCount] = gametype_ly
            -- tab_arr[typeCount] = tab_typeLayer

            -- local tab_typeLayer_text_tt_s = tab_typeLayer_content_ly:getChildByName("text_tt_s")
            -- tab_typeLayer_text_tt_s:setTouchEnabled(false)
            -- tab_typeLayer_text_tt_s:setString(tostring(v[1]["gameType"]))
            

            -- local typeGameList = v
            -- dump(typeGameList, "------typeGameList------")
            -- local typeGameCount = 0
            -- if typeGameList ~= nil then
            --     for k,v in pairs(typeGameList) do
            --         if v.isShow == 1 then
            --             typeGameCount = typeGameCount + 1
            --         end
            --     end
            -- end

            -- local typeHeight = typeGameCount * 78 + 88
            -- tab_typeLayer:setPosition(cc.p(0, typeHeight))
            -- gametype_ly:setContentSize(cc.size(300, typeHeight))

            -- --定义一个按钮
            -- local typeButton = ccui.Button:create()
            -- typeButton:setTouchEnabled(true)
            -- typeButton:setAnchorPoint(cc.p(0.5, 0.5))
            -- typeButton:setTag(typeCount)
            -- typeButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
            -- typeButton:setPosition(cc.p(130, typeHeight - 40))
            -- typeButton:addTouchEventListener(

            --     function(sender,event)

            --         if event == TOUCH_EVENT_BEGAN then
            --             sender:setScale(0.9)
            --         end

            --         --触摸取消
            --         if event == TOUCH_EVENT_CANCELED then
            --             sender:setScale(1.0)
            --         end

            --         --触摸结束
            --         if event == TOUCH_EVENT_ENDED then
            --             sender:setScale(1.0)

            --             -- if selectedTabIndex ~= sender:getTag() then
            --             --     --todo
            --                 self:showTabGames(false, sender:getTag())
            --             -- end
            --         end

            --     end

            -- )
            -- gametype_ly:addChild(typeButton, 5000)
            -- tabButton_arr[typeCount] = typeButton

            -- --显示当前分类下的游戏
            local typeGameList = v
            if typeGameList ~= nil then
                
                local a = 1
                for k,v in pairs(typeGameList) do

                    if v.isShow == 1 then

                        gameCount = gameCount + 1
                        setPos =setPos -78
                        --添加游戏按钮
                        local tab_gameLayer = cc.CSLoader:createNode(CreateGroup_TabGame_Csb_filePath)
                        tab_gameLayer:setAnchorPoint(0.5,0.5)
                        tab_gameLayer:setPosition(130,setPos)
                        tab_gameLayer:setScale(1)
                        tab_gameLayer:setTag(1000)
                        content_ly:addChild(tab_gameLayer)
                        game_arr[v.gameId] = tab_gameLayer
                        

                        --显示游戏名称
                        local tab_gameLayer_content_ly = tab_gameLayer:getChildByName("content_ly")
                        tab_gameLayer_content_ly:setTouchEnabled(true)

                        local tab_gameLayer_bg_iv = tab_gameLayer_content_ly:getChildByName("bg_iv")
                        tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_n_filePath)

                        --游戏名称
                        local gameName = v.name
                        if v.name == "孝感卡五星" then
                           -- gameName = "卡五星"
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
                            gameName = "抢庄牛牛"
                        elseif v.name == "3D长沙麻将" then
                            gameName = "长沙麻将"
                        end

                        local tab_gameLayer_text_tt_n = tab_gameLayer_content_ly:getChildByName("text_tt_n")
                        tab_gameLayer_text_tt_n:setString(gameName)
                        --tab_gameLayer_text_tt_n:setScale(1.4)
                        tab_gameLayer_text_tt_n:setVisible(false)

                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                        tab_gameLayer_text_tt_s:setString(gameName)
                       -- tab_gameLayer_text_tt_s:setScale(1.4)
                        tab_gameLayer_text_tt_s:setVisible(false)
                        --@zc 复制

                        local name_pic =tab_gameLayer_content_ly:getChildByName("Image_pic")
                        dump(gameName)
                        if gameName ~=nil then
                            if gameName =="拼三张" then
                                name_pic:setTexture(Name_PicPath.."btn_pingsanzhang_1.png")
                             elseif gameName == "长沙麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hunanmajinag_1.png")
                            elseif gameName == "跑得快" then
                                name_pic:setTexture(Name_PicPath.."btn_paodekuai_1.png")
                            elseif gameName == "湖北麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hubeimajiang_1.png")
                            elseif gameName == "三公" then
                                name_pic:setTexture(Name_PicPath.."btn_sangong_1.png")
                            elseif gameName == "红中王" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhongwang_1.png")



                             elseif gameName == "抢庄牛牛" then
                                name_pic:setTexture(Name_PicPath.."qiangzhuangdouniu.png")
                             elseif gameName == "推锅斗牛" then
                                name_pic:setTexture(Name_PicPath.."tuigoudouniu2.png")
                             elseif gameName == "定庄斗牛" then
                                name_pic:setTexture(Name_PicPath.."dingzhuangdouniu.png")
                             elseif gameName == "轮庄斗牛" then
                                name_pic:setTexture(Name_PicPath.."lunzhuangdouniu.png")
                             elseif gameName == "通比斗牛" then
                                name_pic:setTexture(Name_PicPath.."txniuniu2.png")
                             elseif gameName == "牛牛坐庄" then
                                name_pic:setTexture(Name_PicPath.."niuniuzuozhuang.png")
                             elseif gameName == "襄阳卡五星" then
                                name_pic:setTexture(Name_PicPath.."xiangyangkawuxing1.png")
                            elseif gameName == "随州卡五星" then
                                name_pic:setTexture(Name_PicPath.."suizhuokawuxing2.png")
                            elseif gameName == "孝感卡五星" then
                                name_pic:setTexture(Name_PicPath.."xiaogankawuxing.png")
                            elseif gameName == "二人红中" then
                                name_pic:setTexture(Name_PicPath.."honhzhongmajiang11.png")
                            elseif gameName == "三人红中" then
                                name_pic:setTexture(Name_PicPath.."sanrenhonggz.png")
                           
                            elseif gameName == "襄阳卡五星" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhongwang_1.png")


                            elseif gameName == "红中麻将" then
                                name_pic:setTexture(Name_PicPath.."btn_hongzhong_1.png")
                            elseif gameName == "斗牛" then
                                name_pic:setTexture(Name_PicPath.."btn_douniu_1.png")
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
                            elseif gameName == "血战麻将" then
                                name_pic:setTexture(Name_PicPath.."xuezhanmajing.png")
                            elseif gameName == "挖坑" then
                                name_pic:setTexture(Name_PicPath.."shanxiwaiken2.png")
                            elseif gameName == "潮汕麻将" then
                                name_pic:setTexture(Name_PicPath.."shanshangmajiang2.png")
            
                            end
                        end

                        --定义一个按钮
                        local gameButton = ccui.Button:create()
                        gameButton:setTouchEnabled(true)
                        gameButton:setAnchorPoint(0.5, 0.5)
                        gameButton:loadTextures(CreateGroup_Tab_blank_filePath, nil, nil)
                        gameButton:setPosition(130,setPos)
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
                                        tab_gameLayer_text_tt_n:setVisible(false)

                                        local tab_gameLayer_text_tt_s = tab_gameLayer_content_ly:getChildByName("text_tt_s")
                                        tab_gameLayer_text_tt_s:setVisible(false)
                                    end

                                    selectedGameIndex = v.gameId
                                    tab_gameLayer_bg_iv:loadTexture(CreateGroup_TabGameBg_s_filePath)
                                    tab_gameLayer_text_tt_n:setVisible(false)
                                    tab_gameLayer_text_tt_s:setVisible(false)

                                    local gameId = v.gameId
                                    dump(gameId, "-----gameId-----")

                                    if device.platform =="windows" then
                                        return
                                    end

                                    if SCENENOW["scene"] then
                                        
                                        local layout = SCENENOW["scene"]:getChildByName("introduceScene")
                                        local floor = layout:getChildByName("floor")
                                        local web_plane = floor:getChildByName("web_plane")

                                        local planeSize = web_plane:getSize()
                                        local webView = ccexp.WebView:create()
                                        webView:setPosition(planeSize.width / 2, planeSize.height / 2)
                                        webView:setContentSize(planeSize.width - 20,  planeSize.height - 20)
                                        webView:setScalesPageToFit(true)
                                        web_plane:addChild(webView)

                                        -- 加载玩法
                                        local path
                                        if gameId == 11 then--跑得快 
                                            path = "hall/illustrate/pdk.html"

                                        elseif gameId == 13 then--推锅牛牛
                                            path = "hall/illustrate/tgnn.html"

                                        elseif gameId == 14 then--定庄牛牛
                                            path = "hall/illustrate/dznn.html"

                                        elseif gameId == 15 then--轮庄牛牛
                                            path = "hall/illustrate/lznn.html"

                                        elseif gameId == 16 then--通比牛牛
                                            path = "hall/illustrate/tbnn.html"

                                        elseif gameId == 17 then--牛牛坐庄
                                            path = "hall/illustrate/nnzz.html"

                                        elseif gameId == 1 then--斗地主
                                            path = "hall/illustrate/ddz.html"
                                         
                                        elseif gameId == 5 then--抢庄斗牛
                                            path = "hall/illustrate/dn.html"

                                        elseif gameId == 7 then--炸金花         
                                            path = "hall/illustrate/zjh.html"

                                        elseif gameId == 9 then--三公       
                                            path = "hall/illustrate/sg.html"

                                        elseif gameId == 81 then--红中王
                                            path = "hall/illustrate/hzw.html" 
                                        
                                        elseif gameId == 83 then--白板变
                                            path = "hall/illustrate/bbb.html" 

                                        elseif gameId == 88 then--长沙麻将
                                            path = "hall/illustrate/csmj.html"            
                                            
                                        elseif gameId == 44 then--随州卡五星
                                            path = "hall/illustrate/szkawuxing.html"

                                        elseif gameId == 46 then--推倒胡
                                            path = "hall/illustrate/bbb.html"

                                        elseif gameId == 47 then--襄阳卡五星
                                            path = "hall/illustrate/xykawuxing.html"

                                        elseif gameId == 50 then--卡五星
                                            path = "hall/illustrate/kwx.html"

                                        elseif gameId == 51 then--海南麻将
                                            path = "hall/illustrate/hnmj.html"
                                            
                                        elseif gameId == 52 then--营口麻将
                                            path = "hall/illustrate/yingkou.html"

                                        elseif gameId == 75 then--湘阴麻将
                                            path = "hall/illustrate/xy.html"

                                        elseif gameId == 77 then--赣州冲关
                                            path = "hall/illustrate/gzcg.html"

                                        elseif gameId == 78 then--宜宾麻将
                                            path = "hall/illustrate/ybmj.html"

                                        elseif gameId == 4 then--血战麻将
                                            path = "hall/illustrate/xzmj.html"

                                        elseif gameId == 40 then--长沙麻将
                                            path = "hall/illustrate/csmj.html" 

                                        elseif gameId == 41 then--红中麻将
                                            path = "hall/illustrate/hzmj.html"
                          
                                        elseif gameId == 43 then--广东麻将
                                            path = "hall/illustrate/gdmj.html"                                
                                        else
                                           path = "hall/illustrate/index.html"

                                        end


                                        if device.platform == "android" then
                                            path = "file:///" .. device.writablePath .. path
                                            webView:loadURL(path)
                                        else
                                            webView:loadFile(cc.FileUtils:getInstance():getWritablePath() .. path)
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

--伸缩列表
function introduceScene:showTabGames(isInit, clickTag)
    if isInit then
        --todo
        selectedTabIndex = 1

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
                tab_typeLayer_text_tt_s:setVisible(false)

            else
                v:setSize(v:getSize().width, GroupHeight_arr[i])

                --设置选中状态
                local tab_typeLayer_content_ly = tab_arr[i]:getChildByName("content_ly")

                local tab_typeLayer_bg_iv = tab_typeLayer_content_ly:getChildByName("bg_iv")
                tab_typeLayer_bg_iv:loadTexture(CreateGroup_TabTypeBg_n_filePath)

                local tab_typeLayer_text_tt_n = tab_typeLayer_content_ly:getChildByName("text_tt_n")
                tab_typeLayer_text_tt_n:setVisible(false)

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

            content_ly:setPosition(0, totalHeight)
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
            
        content_ly:setPosition(0, totalHeight)
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

function introduceScene:openOrCloseTabGames(isOpen, index)

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
        tab_typeLayer_text_tt_n:setVisible(false)

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
        tab_typeLayer_text_tt_s:setVisible(false)

    end

end

function introduceScene:removeScene()

    local s = SCENENOW["scene"]:getChildByName("introduceScene")
    if s then
        s:removeSelf()
    end

end

return introduceScene