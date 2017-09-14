
local GameCommon  = class("GameCommon")

--获取本地游戏版本号
function GameCommon:getGameVersion(game)

    local strKey = game.."_current-version"
    print("get version key:"..strKey)
    local strVersion = cc.UserDefault:getInstance():getStringForKey(strKey,"")
    print("-----获取["..game.."] 版本号是：["..strVersion.."]")
    return strVersion
    
end

--退出组局
function GameCommon:gExitGroupGame(gameId)

    audio.stopMusic()
    audio.stopAllSounds()

    require("hall.VoiceRecord.VoiceRecordView"):removeView()

    require("app.HallUpdate"):enterHall()
    
end
--@zc 20170708 游戏中公用的动画弹窗效果函数
function GameCommon:commomButtonAnimation(showCsb)
    showCsb:setAnchorPoint(0.5,0.5)  
    if device.platform == "windows" then
       showCsb:setPosition(WinSize.width/2+160, WinSize.height/2 +30)--windows平台函数
    else
        showCsb:setPosition(WinSize.width/2, WinSize.height/2)
    end
    showCsb:setScale(0)
    local stSmall = cc.ScaleTo:create(0.2, 1.3)
    local stNormal = cc.ScaleTo:create(0.1, 1)
    local sq = cc.Sequence:create(stSmall, stNormal)
    showCsb:runAction(sq)
end
--退出大厅
function GameCommon:gExitGame()

    audio.stopMusic()
    audio.stopAllSounds()
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
        require("hall.GameSetting"):applyChangeUser()
    --     cc.Director:getInstance():purgeCachedData();
    --     --cc.Director:getInstance():endToLua();
    --     local luaj = require "cocos.cocos2d.luaj"
    --     local className =luaJniClass
      
    --     local ok,ret  = luaj.callStaticMethod(className,"exitGame")
    --     if not ok then
    --         print("exitGame luaj error:", ret)
    --     else
    --         print("exitGame PLATFORM_OS_ANDROID")
    --     end
    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
        require("hall.GameSetting"):applyChangeUser()
    --     local args = {}
    --     local luaoc = require "cocos.cocos2d.luaoc"
    --     local className = "CocosCaller"
    --     local ok,ret  = luaoc.callStaticMethod(className,"exitGame")
    --     if not ok then
    --         cc.Director:getInstance():resume()
    --         print("exitGame PLATFORM_OS_IPHONE failed")
    --     else
    --         print("exitGame PLATFORM_OS_IPHONE")
    --     end
    else
        cc.Director:getInstance():endToLua()
    end

    -- display.replaceScene(display.newScene("null"))

end

--显示游戏设置
function GameCommon:showSettings(flag, bChangeUser, bDismiss, sDisband, disbandCallback)

    require(Setting_filePath):showScene(flag, bChangeUser, bDismiss, sDisband, disbandCallback)

end

--登陆loading
function GameCommon:landLoading(flag,par)

    if bm.isConnectBytao then
        return;
    end

    par = par or SCENENOW["scene"]

    local layerLoading = par:getChildByName("layout_loading")
    if layerLoading == nil then

        layerLoading = cc.CSLoader:createNode("res/loading/loading.csb"):addTo(par)

        if gameTypeTTT and gameTypeTTT==7 then
            layerLoading:setScaleX(640/960)
            layerLoading:setScaleY(440/540)
        else
            --todo
            layerLoading:setScaleX(1)
            layerLoading:setScaleY(1)
        end
        layerLoading:setName("layout_loading")

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            layerLoading:setScale(0.75)
        end

    end

    if layerLoading then

        if flag == false then
            SCENENOW["scene"]:removeChildByName("layout_loading")
            print("GameCommon:landLoading false")
            return
        end

        layerLoading:setLocalZOrder(20000)
        layerLoading:setVisible(true)

        --进度条
        local progress = layerLoading:getChildByName("loading_bar")
        progress:setPercent(0)
        local txt_progress = layerLoading:getChildByName("txt_progress")
        txt_progress:setString(0)

    end

end

--加载过程中提示
function GameCommon:showLoadingTips(str)

    if bm.isConnectBytao then
        return;
    end

    if not SCENENOW["scene"] then
        return;
    end

    local layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    if layerLoading then
        local txt = layerLoading:getChildByName("lb_tips")
        if txt then
            txt:setString(str)
            txt:setColor(cc.c3b(255,255,255))
        else
            print("can't match Text_1")
        end
    else
        self:landLoading(true)
        layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
        if layerLoading then
            local txt = layerLoading:getChildByName("lb_tips")
            if txt then
                txt:setString(str)
                txt:setColor(cc.c3b(0xff,0xff,0xff))
            else
                print("can't match Text_1")
            end
        else
            print("can't match layout_loading")
        end
    end
end

--显示更新进度
function GameCommon:setLoadingProgress(progress)
    -- body
    local layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    if layerLoading then
        if progress < 0 then
            progress = 0
        end
        local spLoading = layerLoading:getChildByName("loading_bar")
        if spLoading then
            if spLoading:isVisible() == false then
                spLoading:setVisible(true)
            end
            spLoading:setPercent(progress)
        end
        local txt_progress = layerLoading:getChildByName("txt_progress")
        txt_progress:setString(tostring(progress).."%")
    end
end

--默认更新进度条
function GameCommon:DefaultProgress()
    -- body
    local layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    if layerLoading then
        local spLoading = layerLoading:getChildByName("loading_bar")
        if spLoading then
            local progress = 0
            local seq = cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function ( ... )
                -- body
                progress = progress + 9.8
                self:setLoadingProgress(progress)
            end))
            local rep = cc.Repeat:create(seq,10)
            spLoading:runAction(rep)
        end
    end
end

--检查图片格式
function GameCommon:getUrlPicture(url)
    -- body
    if url == "" or url == nil then
        return ""
    end
    dump(url,"getUrlPicture")
    local strLower = string.lower(url)
    if string.find(strLower,".jpg") == nil and string.find(strLower,".png") == nil then
        return self:getUnformatPic(url)
    end
    local strUrl = string.reverse(url)
    local nPos = string.find(strUrl,"/")
    local strPic = string.sub(strUrl,1,nPos-1)
    strPic = string.reverse(strPic)
    print("getUrlPicture:",strPic)
    return strPic
end

--获取非格式化图片名称
function GameCommon:getUnformatPic(url)
    local strUrl = string.reverse(url)
    local nPos = string.find(strUrl,"/")
    strUrl = string.sub(strUrl,nPos+1,string.len(strUrl))
    nPos = string.find(strUrl,"/")
    local strPic = string.sub(strUrl,1,nPos-1)
    strPic = string.reverse(strPic)
    print("getUnformatPic:",strPic)
    return strPic..".jpg"
end

function GameCommon:setDefaultHead(head,uid,sex,size,isCircle)

    isCircle = isCircle or false
    if isCircle then
        self:setCirleHead(head, "", size, uid, sex, "", "")
    end
    
end

function GameCommon:setCirleHead(head, strIco, size, uid, sex, url, nick)
    
    local clipnode = cc.ClippingNode:create()
    clipnode:setInverted(false)
    clipnode:setAlphaThreshold(100)

    local stencil = cc.Node:create()
    clipnode:setStencil(stencil)

    local spStnecil = display.newSprite(Stnecil_filePath)
    spStnecil:setScale(size/spStnecil:getContentSize().width)
    stencil:addChild(spStnecil)

    local content
    file,fileErr = io.open(strIco)
    if fileErr == nil then
        local x = file:seek("end")
        if x > 0 then
            content = display.newSprite(strIco)
        else
            content = display.newSprite(DefaultHead_filePath)
        end
    else
        content = display.newSprite(DefaultHead_filePath)
    end
    -- local content = display.newSprite(strIco)
    content:setScaleX(size/content:getContentSize().width)
    content:setScaleY(size/content:getContentSize().height)
    clipnode:addChild(content)

    clipnode:setPosition(clipnode:getContentSize().width/2,clipnode:getContentSize().height/2)
    head:addChild(clipnode)

    head:setTexture("")

    local layerTouch = ccui.Layout:create()
    layerTouch:setAnchorPoint(cc.p(0.5,0.5))
    layerTouch:setTouchEnabled(true)
    layerTouch:addTouchEventListener(
        function(sender,event)
            if event == 2  then
                self:showPlayerInfoForGetHead(url,uid,sex,nick)
            end
    end)
    layerTouch:setContentSize(cc.size(size,size))
    head:addChild(layerTouch)

end

function GameCommon:getUserHead(url,uid,sex,sp,size,isCircle,nick)
    -- body
    isCircle = isCircle or false
    sex = sex or 0
    local file = nil
    local fileErr = nil
    local spHead = nil
    
    --链接空，载入默认头像
    local strHead = self:getUrlPicture(url)
    if strHead == nil or strHead == "" then
        self:setDefaultHead(sp,uid,sex,size,isCircle)
        return
    end
    sp:retain();
    --先在本地获取
    local imgFullPath = device.writablePath..strHead
    file,fileErr = io.open(imgFullPath)
    if fileErr == nil then

        local x = file:seek("end")
        if x > 0 then
            spHead = display.newSprite(imgFullPath)
            cc.Director:getInstance():getTextureCache():reloadTexture(imgFullPath)
        else
            spHead = display.newSprite(DefaultHead_filePath)
        end

        if not isCircle then
            sp:loadTexture(imgFullPath)
            sp:setContentSize(cc.size(size,size))
            sp:setTouchEnabled(true)
            sp:addTouchEventListener(

                function(sender,event)

                    --触摸结束
                    if event == TOUCH_EVENT_ENDED then
                        self:showPlayerInfoForGetHead(url,uid,sex,nick)
                    end

                end

            )

        else
            -- self:setCirleHead(sp,imgFullPath,size)
            self:setCirleHead(sp, imgFullPath, size, uid, sex, url, nick)
        end

    else

        local function onRequestFinished(event,filename)
            -- body    
            local ok = (event.name == "completed")
            print("onRequestFinished")
            local request = event.request
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                print(request:getErrorCode(), request:getErrorMessage())
                return
            end

            local code = request:getResponseStatusCode()
            if code ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                print(code)
                return
            end

            -- 请求成功，显示服务端返回的内容
            local response = request:getResponseString()
            print(response)
            
            --保存下载数据到本地文件，如果不成功，重试30次。
            local times = 1
            print("savedata:"..filename)
            while (not request:saveResponseData(filename)) and times < 30 do
                times = times + 1
            end
            local isOvertime = (times == 30) --是否超时

            cc.Director:getInstance():getTextureCache():reloadTexture(imgFullPath)
        
                if not isCircle then
                    sp:loadTexture(imgFullPath)
                    sp:setContentSize(cc.size(size,size))
                    sp:setTouchEnabled(true)
                    sp:addTouchEventListener(

                        function(sender,event)

                            --触摸结束
                            if event == TOUCH_EVENT_ENDED then
                                self:showPlayerInfoForGetHead(url,uid,sex,nick)
                            end

                        end

                    )

                else
                    -- self:setCirleHead(sp,imgFullPath,size)
                    self:setCirleHead(sp, imgFullPath, size, uid, sex, url, nick)
                end
    
        end

        local request = network.createHTTPRequest(function (event)
            -- body
            if event.name == "completed" then
                onRequestFinished(event,imgFullPath)
            end
        end,url,"GET")
        request:start()

    end
end

function GameCommon:setDefaultPlayerHead(head,user_info,size)
    isCircle = isCircle or false
    local userid = math.abs(user_info["uid"])
    if user_info["sex"] == 0 then
        user_info["sex"] = user_info["sex"] + 1
    end
    local strIco = ""
    if user_info["sex"] == 1 or user_info["sex"] == "1" then--男
        local index = math.mod(userid,4) + 1
        print("setDefaultPlayerHead",tostring(sex),tostring(index))
        strIco = "hall/heads/boy-"..tostring(index)..".png"
    elseif user_info["sex"] == 2 or user_info["sex"] == "2" then--女
        local index = math.mod(userid,7) + 1
        print("setDefaultPlayerHead",tostring(sex),tostring(index))
        strIco = "hall/heads/girl-"..tostring(index)..".png"
    end
    -- head:setTexture(strIco)
    user_info["icon_url"] = strIco
    print("setDefaultPlayerHead",tostring(user_info["sex"]),tostring(user_info["icon_url"]))
    self:setHead(head,user_info,size)
end

function GameCommon:setHead(head,user_info,size,touchabled)

    if head == nil then
        return
    end

    head:setTexture("")
    
    if head:getChildByName("head_img") then
        head:getChildByName("head_img"):removeSelf()
    end
    if head:getChildByName("head_touch") then
        head:getChildByName("head_touch"):removeSelf()
    end
    -- if head:getChildByName("head_vip") then
    --     head:getChildByName("head_vip"):removeSelf()
    -- end

    local show_info = touchabled or 1
    local clipnode = cc.ClippingNode:create()
    clipnode:setInverted(false)
    clipnode:setAlphaThreshold(100)

    local stencil = cc.Node:create()
    clipnode:setStencil(stencil)
    local spStnecil = display.newSprite(DefaultHead_filePath)
    spStnecil:setScale(size/spStnecil:getContentSize().width)
    stencil:addChild(spStnecil)

    local content = display.newSprite(user_info["icon_url"])
    content:setScaleX(size/content:getContentSize().width)
    content:setScaleY(size/content:getContentSize().height)
    clipnode:addChild(content)

    clipnode:setPosition(clipnode:getContentSize().width/2,clipnode:getContentSize().height/2)
    head:addChild(clipnode)
    head:setScale(1)
    clipnode:setName("head_img")

    local layerTouch = ccui.Layout:create()
    layerTouch:setAnchorPoint(cc.p(0.5,0.5))

    local spHeadMask = display.newSprite(HeadFrame_filePath)
    spHeadMask:setAnchorPoint(cc.p(0.5,0.5))
    local s = size/(spHeadMask:getContentSize().width-20)
    spHeadMask:setScale(s)
    
    spHeadMask:setPosition(spHeadMask:getContentSize().width/2, spHeadMask:getContentSize().height/2)
  
    layerTouch:addChild(spHeadMask)
    -- layerTouch:ssize(spHeadMask:getWidth(),spHeadMask:getHeight())

    if show_info == 1 then
        layerTouch:setTouchEnabled(true)
        layerTouch:addTouchEventListener(function(sender,event)
                if event == 2  then
                    print("head touch")
                    self:showPlayerInfo(user_info)
                end
            end)
    end
    layerTouch:setContentSize(spHeadMask:getContentSize())
    --layerTouch:setPosition(head:getPositionX(), head:getPositionY())
    clipnode:setName("head_touch")
    head:addChild(layerTouch)
    head:setTexture("")

end

function GameCommon:setPlayerHead(user_info,sp,size)

    local file = nil
    local fileErr = nil
    local spHead = nil
    --链接空，载入默认头像
    sp:retain();

    local strHead = self:getUrlPicture(user_info["icon_url"])
    if strHead == nil or strHead == "" then
        self:setDefaultPlayerHead(sp,user_info,size)
        return
    end
    --先在本地获取
    local imgFullPath = device.writablePath..strHead
    file,fileErr = io.open(imgFullPath)
    if fileErr == nil then

        local x = file:seek("end")
        if x > 0 then
            spHead = display.newSprite(imgFullPath)
        else
            spHead = display.newSprite(DefaultHead_filePath)
            imgFullPath = DefaultHead_filePath
        end

        spHead = display.newSprite(imgFullPath)
        cc.Director:getInstance():getTextureCache():reloadTexture(imgFullPath)
        
        user_info["icon_url"] = imgFullPath

        self:setHead(sp,user_info,size)

    else
        local function onRequestFinished(event,filename)
            -- body    
            local ok = (event.name == "completed")
            print("onRequestFinished")
            local request = event.request
            if not ok then
                -- 请求失败，显示错误代码和错误消息
                print(request:getErrorCode(), request:getErrorMessage())
                return
            end

            local code = request:getResponseStatusCode()
            if code ~= 200 then
                -- 请求结束，但没有返回 200 响应代码
                print(code)
                return
            end


            -- 请求成功，显示服务端返回的内容
            local response = request:getResponseString()
            print(response)
            
            --保存下载数据到本地文件，如果不成功，重试30次。
            local times = 1
            print("savedata:"..filename)
            while (not request:saveResponseData(filename)) and times < 30 do
                times = times + 1
            end
            local isOvertime = (times == 30) --是否超时

            cc.Director:getInstance():getTextureCache():reloadTexture(imgFullPath)
            --sp:performWithDelay(function()
                user_info["icon_url"] = imgFullPath
                self:setHead(sp,user_info,size)
            --end, 0.1)
        end

        local request = network.createHTTPRequest(function (event)
            -- body
            if event.name == "completed" then
                onRequestFinished(event,imgFullPath)
            end
        end,user_info["icon_url"],"GET")
        request:start()
    end
end

--设置头像
function GameCommon:setUserHead(head_info)
    -- body
    -- local spHead = display.newSprite(file)

    if head_info["sp"] == nil then
        return
    end
    if head_info["sp"]:getChildByName("head_img") then
        head_info["sp"]:getChildByName("head_img"):removeSelf()
    end
    if head_info["sp"]:getChildByName("head_touch") then
        head_info["sp"]:getChildByName("head_touch"):removeSelf()
    end
    if head_info["sp"]:getChildByName("head_vip") then
        head_info["sp"]:getChildByName("head_vip"):removeSelf()
    end
    local show_info = head_info["touchable"] or 0
    local size = head_info["size"] or 80
    local clipnode = nil
    if head_info["use_sharp"] and head_info["use_sharp"] == 1 then
        clipnode = cc.ClippingNode:create()
        clipnode:setInverted(false)
        clipnode:setAlphaThreshold(100)

        local stencil = cc.Node:create()
        clipnode:setStencil(stencil)
        local spStnecil = display.newSprite(DefaultHead_filePath)
        spStnecil:setScale(size/spStnecil:getContentSize().width)
        stencil:addChild(spStnecil)

        local content = display.newSprite(head_info["url"])
        content:setScaleX(size/content:getContentSize().width)
        content:setScaleY(size/content:getContentSize().height)
        clipnode:addChild(content)

        clipnode:setPosition(clipnode:getContentSize().width/2,clipnode:getContentSize().height/2)
    else
        clipnode = display.newSprite(head_info["url"])
        clipnode:setScaleX(size/clipnode:getContentSize().width)
        clipnode:setScaleY(size/clipnode:getContentSize().height)
    end
    clipnode:setName("head_img")
    head_info["sp"]:addChild(clipnode)

    local layerTouch = ccui.Layout:create()
    layerTouch:setAnchorPoint(cc.p(0.5,0.5))
    layerTouch:setName("head_touch")

    local spHeadMask = display.newSprite(HeadFrame_filePath)
    local s = size/(spHeadMask:getContentSize().width-25)
    spHeadMask:setScale(s)
    spHeadMask:setAnchorPoint(cc.p(0.5,0.5))
    spHeadMask:setPosition(spHeadMask:getContentSize().width/2, spHeadMask:getContentSize().height/2)
    layerTouch:addChild(spHeadMask)

    if show_info == 1 then
        layerTouch:setTouchEnabled(true)
        layerTouch:addTouchEventListener(function(sender,event)
                if event == 2  then
                    print("head touch")
                    self:showPlayerInfo(head_info["uid"])
                    --require("hall.GameTips"):showTips("玩家详情")
                end
            end)
    end
    layerTouch:setContentSize(spHeadMask:getContentSize())
    layerTouch:setPosition(clipnode:getPosition())
    head_info["sp"]:addChild(layerTouch)

    -- if head_info["vip"] then
    --     local sp_vip = display.newSprite("hall/common/main_vip_tb01.png")
    --     sp_vip:setPosition(-size/2+10,-size/2+10)
    --     head_info["sp"]:addChild(sp_vip)
    --     sp_vip:setName("head_vip")
    -- end

    head_info["sp"]:setTexture("")
end

--玩家详情
function GameCommon:showPlayerInfo(user_info)

    dump(user_info, "-----showPlayerInfo-----")

    if user_info == nil then
        return
    end

    if user_info.uid == nil then
        return
    end

    if user_info.uid == "" then
        return
    end

    if nick == nil then
        nick = uid
    end

    local userInfo = {}
    userInfo["isShowInGame"] = bm.isInGame
    userInfo["nickName"] = tostring(user_info.uid)
    userInfo["uid"] = user_info.uid
    userInfo["location_arr"] = {}

    require("hall.view.userInfoView.userInfoView"):showView(user_info.icon_url, userInfo)

end

--玩家详情(新)
function GameCommon:showPlayerInfoForGetHead(icon_url, uid, sex_num, nick)

    dump(icon_url, "-----玩家详情(新)-----")
    dump(uid, "-----玩家详情(新)-----")
    dump(sex_num, "-----玩家详情(新)-----")

    if uid == nil then
        return
    end

    if uid == "" then
        return
    end

    if nick == nil then
        nick = uid
    end

    local userInfo = {}
    userInfo["isShowInGame"] = bm.isInGame
    userInfo["nickName"] = nick
    userInfo["uid"] = uid
    userInfo["location_arr"] = {}

    require("hall.view.userInfoView.userInfoView"):showView(icon_url, userInfo)

end

--格式化金币
function GameCommon:formatGold(gold)

    if not gold then
        printError("error formatGold gold is null")
    end

    gold = tonumber(gold)

    if( gold < 10000) then
        return gold
    else
        local w = math.modf(gold/10000)
        local lest = math.modf(gold%10000/1000)

        return w.."."..lest.."w"
    end

end

--格式化系统字体金币
function GameCommon:formatGoldSys(gold)

    if not gold then
        printError("error formatGold gold is null")
    end

    gold = tonumber(gold)

    if( gold < 10000) then
        return gold
    else
        local w = math.modf(gold/10000)
        local lest = math.modf(gold%10000/1000)

        return w.."万"
    end

end

--格式化昵称
function GameCommon:formatNickToLaction(str,size)

    local width = 0
    local size = size or 3
    local char_count = 0
    local pos = 1
    local lenInByte = #str

    if lenInByte < 10 then
        return str
    else
        local nick = ""
        for i=1,lenInByte do
            local curByte = string.byte(str, pos)

            if curByte == nil then
                return str
            end
            
            local byteCount = 1;
            if curByte>0 and curByte<=127 then
                byteCount = 1
            elseif curByte>=192 and curByte<223 then
                byteCount = 2
            elseif curByte>=224 and curByte<239 then
                byteCount = 3
            elseif curByte>=240 and curByte<=247 then
                byteCount = 4
            end
             
            local char = string.sub(str, pos, pos+byteCount-1)
            nick = nick .. char
            char_count = char_count + 1
            pos = pos + byteCount
            if char_count >= size then
                return nick .. ".."
            end
        end
    end

end

--格式化昵称
function GameCommon:formatNick(str,size)
    -- body
    local width = 0
    local size = size or 4
    local char_count = 0
    local pos = 1
          --@linson
    local lenInByte = 0
    if str~=nil then
        lenInByte = #str
    else
        str=""
        lenInByte=0
    end

    if lenInByte < 10 then
        return str
    else
        local nick = ""
        for i=1,lenInByte do
            local curByte = string.byte(str, pos)

            if curByte == nil then
                return str
            end

            local byteCount = 1;
            if curByte>0 and curByte<=127 then
                byteCount = 1
            elseif curByte>=192 and curByte<=223 then
                byteCount = 2
            elseif curByte>=224 and curByte<=239 then
                byteCount = 3
            elseif curByte>=240 and curByte<=247 then
                byteCount = 4
            end
            
            local char = string.sub(str, pos, pos + byteCount - 1)
            nick = nick .. char
            char_count = char_count + 1
            pos = pos + byteCount
            if char_count >= size then
                return nick .. "..."
            end

        end
    end

end

--自动裁剪label内容
function GameCommon:formatLabelStr(str, lb, maxWidth)
    lb:setString("a")
    local widthByByte = lb:getContentSize().width
    dump(maxWidth, "maxWidth")
    dump(widthByByte, "widthByByte")

    local totalBytes = maxWidth / widthByByte - 3

    if totalBytes <= 0 then
        --todo
        lb:setString("...")
        return
    end

    local length = string.len(str)

    local tBytes = 0
    local dealStr = ""
    local isOver = false
    for i=1,length do
        local b = string.byte(str, i)

        if b > 255 then
            --todo
            if tBytes + 2 > totalBytes then
                --todo
                if i == 1 then
                    --todo
                    isOver = true
                    break
                else
                    dealStr = string.sub(str, 1, i - 1)
                    isOver = true
                    break
                end
            elseif tBytes + 2 == totalBytes then
                dealStr = string.sub(str, 1, i)
                if i ~= length then
                    --todo
                    isOver = true
                end
                break
            else
                tBytes = tBytes + 2
            end
        else
            if tBytes + 1 > totalBytes then
                --todo
                if i == 1 then
                    --todo
                    isOver = true
                    break
                else
                    dealStr = string.sub(str, 1, i - 1)
                    isOver = true
                    break
                end
            elseif tBytes + 1 == totalBytes then
                dealStr = string.sub(str, 1, i)
                if i ~= length then
                    --todo
                    isOver = true
                end
                break
            else
                tBytes = tBytes + 1
            end
        end
    end

    if not isOver then
        --todo
        lb:setString(str)
    else
        lb:setString(dealStr .. "...")
    end

    
end

--获取svid
function GameCommon:getSvid(tid)

    local id = bit.brshift(tid,16)
    return id
    
end

--播放游戏音效
function GameCommon:playEffectSound(filename,flag)

    if SOUND_ON == true then
        local bRepeat = true
        if flag then
            bRepeat = flag
        else
            bRepeat = false
        end
        -- cc.SimpleAudioEngine:getInstance():setEffectsVolume(0.5)
        dump(cc.SimpleAudioEngine:getInstance():getEffectsVolume(), "effect volume --")
        -- cc.SimpleAudioEngine:getInstance():playEffect(filename,bRepeat)
        require("hall.VoiceUtil"):playEffect(filename,bRepeat)
    end

end

--播放游戏音效
function GameCommon:playEffectMusic(filename,flag)

    if MUSIC_ON == true then
        local bRepeat = true
        if flag then
            bRepeat = flag
        else
            bRepeat = false
        end
        cc.SimpleAudioEngine:getInstance():playMusic(filename,bRepeat)
        
    end

end

--显示数字
function GameCommon:showNums(num,color,isBack)
    -- body
    -- display.addSpriteFrames("hall/nums.plist", "hall/nums.png")
    isBack = isBack or false
    -- print("showNums:"..tostring(num))
    local spLayer = cc.Layer:create()
    num = num or 0
    local str = tostring(num)
    local len = string.len(num)
    local x = 0
    local y = 0
    local width = 0
    local height = 0
    if len < 1 then
        return nil
    end
    if isBack then
        if len == 1 then
            local left = display.newSprite("hall/no/num_bg_left.png"):addTo(spLayer)
            x = x + left:getContentSize().width/2
            width = width + left:getContentSize().width
            height = left:getContentSize().height
            left:setPosition(cc.p(x,y))
            x = x + left:getContentSize().width/2
            local right = display.newSprite("hall/no/num_bg_right.png"):addTo(spLayer)
            x = x + right:getContentSize().width/2
            width = width + right:getContentSize().width
            right:setPosition(cc.p(x,y))
            x = x + right:getContentSize().width/2
            local txt = self:getNum(str,color)
            txt:setScale(0.8)
            right:addChild(txt)
            txt:setPosition(cc.p(right:getContentSize().width/2,right:getContentSize().height/2))
            spLayer:setContentSize(cc.size(width,height))
        else
            for i=1,len do
                -- print(string.byte(str,i))
                local ch = string.char(string.byte(str,i))
                    if i == 1 then
                        local left = display.newSprite("hall/no/num_bg_left.png"):addTo(spLayer)
                        x = x + left:getContentSize().width/2
                        width = width + left:getContentSize().width
                        height = left:getContentSize().height
                        left:setPosition(cc.p(x,y))
                        x = x + left:getContentSize().width/2
                        local txt = self:getNum(ch,color)
                        txt:setScale(0.8)
                        left:addChild(txt)
                        txt:setPosition(cc.p(left:getContentSize().width/2,left:getContentSize().height/2))
                        spLayer:setContentSize(cc.size(width,height))
                    elseif i == len then
                        local right = display.newSprite("hall/no/num_bg_right.png"):addTo(spLayer)
                        x = x + right:getContentSize().width/2
                        width = width + right:getContentSize().width
                        right:setPosition(cc.p(x,y))
                        x = x + right:getContentSize().width/2
                        local txt = self:getNum(ch,color)
                        txt:setScale(0.8)
                        right:addChild(txt)
                        txt:setPosition(cc.p(right:getContentSize().width/2,right:getContentSize().height/2))
                        spLayer:setContentSize(cc.size(width,height))
                    else
                        local center = display.newSprite("hall/no/num_bg_center.png"):addTo(spLayer)
                        x = x + center:getContentSize().width/2
                        width = width + center:getContentSize().width
                        center:setPosition(cc.p(x,y))
                        x = x + center:getContentSize().width/2
                        local txt = self:getNum(ch,color)
                        txt:setScale(0.8)
                        center:addChild(txt)
                        txt:setPosition(cc.p(center:getContentSize().width/2,center:getContentSize().height/2))
                        spLayer:setContentSize(cc.size(width,height))
                    end
            end
        end
    else
        for i=1,len do
            -- print(string.byte(str,i))
            local ch = string.char(string.byte(str,i))
            local txt = self:getNum(ch,color)
            spLayer:addChild(txt)
            -- x = x - txt:getContentSize().width/2
            -- print("showNums x:"..tostring(x))
            txt:setPosition(cc.p(x,y))
            x = x + txt:getContentSize().width
            width = width + txt:getContentSize().width
            spLayer:setContentSize(cc.size(width,height))
        end
    end
    -- spLayer:setCascadeColorEnabled(true)
    spLayer:setCascadeOpacityEnabled(true)
    return spLayer
end

function GameCommon:getNum(str,color)
    -- body
    -- local spLayer = cc.Layer:create()
    color = color or cc.c3b(125,125,125)
    -- print("getNum:"..str)
    local spBack = display.newSprite("hall/no/mask"..str..".png")
    spBack:setColor(color)
    local spNum = display.newSprite("hall/no/"..str..".png")
    spBack:addChild(spNum)
    spNum:setPosition(cc.p(spBack:getContentSize().width/2,spBack:getContentSize().height/2))
    spBack:setCascadeOpacityEnabled(true)
    return spBack
end

--显示提示框
function GameCommon:showAlert(flag, msg, maxBodyWidth)

    if flag == false then
        SCENENOW["scene"]:removeChildByName("layer_tips")
        return
    end

    require(CommonTips_filePath):showTips("提示", "", 3, msg)
    
end

--兑换筹码界面
function GameCommon:showChange(flag,sef)

end

--请求兑换筹码
function GameCommon:changeChip(value)

end

--请求历史记录
function GameCommon:getHistory()

end

--显示历史记录
function GameCommon:showHistory(flag)
    
end

--历史项目
function GameCommon:addHistoryItem(gameNo,playerlist,scale)

end

function GameCommon:gRecharge()

end

return GameCommon
