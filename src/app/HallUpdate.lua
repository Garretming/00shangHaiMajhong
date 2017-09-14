

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local HallUpdate  = class("GameUpdate")

local timerOut=10
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
--获取remote更新版本
function HallUpdate:queryVersion(type)
    -- body
     local code = codr or "hall";
     --local h
     cct.httpReq2({

            url=HttpAddr.."/version/queryVersion",
            data={
                type=tostring(type)
            },
           
            callBack=function(data)

                local data=data.data;

                --scheduler.unscheduleGlobal(h)
                --local data = data["data"]

                dump(data,"请求大厅版本")
                if not data then
                    --todo
                    self:showLoadingTips("请求大厅版本异常")
                    self:queryVersion(type);
                    return;
                    --self:enterHall()
                else
             
                    local url = data["updateUrl"]
                    local ver = data["version"]
                    -- ver = "0"
                    -- url = "http://120.25.216.48:8080/testUpdate/game/hall.zip"
                    print("updateUrl",url)
                   
                    self:updateGame(url,ver,gid,code)
                    return
                end

            end

        
        })
   

end

--返回大厅
function HallUpdate:enterHall()
    -- body
    display_scene(GameScene_filePath, 1)
end


function HallUpdate:enterHall2()
    display_scene("hall.hallScene",1)
end

--更新
function HallUpdate:updateGame(url,version,gid,code)
    -- body
    --本地校验版本号
    if self:checkVersion(code,version) == false then
        self:enterHall2(code)
        return;
    end
    local frameTimeCount = 0
    pathToSave = cc.FileUtils:getInstance():getWritablePath()

    self:showLoadingTips("正在更新大厅")
    self:setLoadingProgress(0)

    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            print("no new version")
            self:enterHall2(code)
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then --网络错误更新失败
            print("network error ")
            self:showLoadingTips("网络异常下载更新失败") --exit game
            if nil ~= assetsManager then
                assetsManager:release()
                assetsManager = nil
                print("release assets manager")
            end
            self:queryVersion(2)
        else
            self:showLoadingTips("更新出错")

            if nil ~= assetsManager then
                assetsManager:release()
                assetsManager = nil
                print("release assets manager")
            end
            self:queryVersion(2)
        end

        print("onError:%d",errorCode)
    end

    local function onProgress( percent )
        self:setLoadingProgress(percent)
    end

    local function onSuccess()
        print("update success")
        local strKey = code .. "_current-version"
        cc.UserDefault:getInstance():setStringForKey(strKey,version)
        require("app.MyApp"):run();
        --self:enterHall(code)
    end

    local function getAssetsManager()
        if nil == assetsManager then
            print(url)
            print(version)
            assetsManager = cc.AssetsManager:new(url,version,pathToSave)
            -- assetsManager = cc.AssetsManager:new(strFile,strVersion,pathToSave)
            assetsManager:retain()
            assetsManager:setDelegate(onError, cc.ASSETSMANAGER_PROTOCOL_ERROR )
            assetsManager:setDelegate(onProgress, cc.ASSETSMANAGER_PROTOCOL_PROGRESS)
            assetsManager:setDelegate(onSuccess, cc.ASSETSMANAGER_PROTOCOL_SUCCESS )
            assetsManager:setConnectionTimeout(3)
        end

        return assetsManager
    end

    local function onNodeEvent(msgName)
        if nil ~= assetsManager then
            assetsManager:release()
            assetsManager = nil
            print("release assets manager")
        end
    end

    print("scene name[%s]",SCENENOW["name"])
    SCENENOW["scene"]:registerScriptHandler(onNodeEvent)

    local bUpdated = false
    local function update(dt)
        frameTimeCount = frameTimeCount + dt

        if frameTimeCount >= 1.5 and bUpdated == false then
            getAssetsManager():update()
            print("update assets")
            bUpdated = true
        end
    end
    SCENENOW["scene"]:scheduleUpdateWithPriorityLua(update,0)
end

--登陆loading
function HallUpdate:landLoading(flag)

    local layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    if layerLoading == nil then
        layerLoading = cc.CSLoader:createNode("res/loading/loading.csb"):addTo(SCENENOW["scene"])

        if gameTypeTTT and gameTypeTTT==7 then
            layerLoading:setScaleX(640/960)
            layerLoading:setScaleY(440/540)
        else
            --todo
            layerLoading:setScaleX(1)
            layerLoading:setScaleY(1)
        end
        -- layerLoading = cc.CSLoader:createNode("hall/LayerGameLoading.csb"):addTo(SCENENOW["scene"])
        layerLoading:setName("layout_loading")
    end

    if layerLoading then
        if flag == false then
            -- layerLoading:setVisible(false)
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
function HallUpdate:showLoadingTips(str)
    -- body
    -- print("GameCommon:showLoadingTips")
    -- if not SCENENOW["scene"] then
    --     --todo
    --     return;
    -- end
    -- local layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    -- if layerLoading then
    --     local txt = layerLoading:getChildByName("lb_tips")
    --     if txt then
    --         txt:setString(str)
    --         txt:setColor(cc.c3b(0xff,0xff,0xff))
    --     else
    --         print("can't match Text_1")
    --     end
    -- else
    --     self:landLoading(true)
    --     layerLoading = SCENENOW["scene"]:getChildByName("layout_loading")
    --     if layerLoading then
    --         local txt = layerLoading:getChildByName("lb_tips")
    --         if txt then
    --             txt:setString(str)
    --             txt:setColor(cc.c3b(0xff,0xff,0xff))
    --         else
    --             print("can't match Text_1")
    --         end
    --     else
    --         print("can't match layout_loading")
    --     end
    -- end
end


function HallUpdate:showTips(title,code,call)
    code=code or 0
    if SCENENOW["scene"] then
        --释放之前的
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
            s:removeSelf()
        end
        s = cc.CSLoader:createNode("res/Tips/LayerTips.csb")
        --s:getChildByName("tips_back_1"):setTexture("hall/tips/tips_back.png")
        s:setName("layer_tips")
        SCENENOW["scene"]:addChild(s,99999)
        local layer = s:getChildByName("tips_back_1")
        local txt = layer:getChildByName("txt_msg")
        print(tolua.type(txt),"crollname")


        if txt then
            txt:setString(title)

            local label = cc.Label:createWithTTF(title,"res/fonts/fzcy.ttf",30)
            label:setMaxLineWidth(400)
            label:setAnchorPoint(cc.p(0.5,1))
            label:setColor(cc.c3b(22,107,178))
            label:setName("txt_msg")
            layer:addChild(label)
            label:setPosition(txt:getPosition())
            txt:removeSelf()
        end


        local lbTitle = layer:getChildByName("txt_title")
        if lbTitle then
            lbTitle:enableOutline(cc.c4b(58,35,10,255),1)
        end

        local btnSubmit = layer:getChildByName("btn_submit")
        local btnCancel = layer:getChildByName("btn_cancel")
        local btn_sure =  layer:getChildByName("btn_sure")

        if code==0 then
            --todo
            btn_sure:setVisible(true)
            btnCancel:setVisible(false)
            btnSubmit:setVisible(false)
        else
            btn_sure:setVisible(false)
            btnCancel:setVisible(true)
            btnSubmit:setVisible(true)
        end
        


        local function touchEvent(sender,eventType)
            if eventType==2 then
                --todo
                SCENENOW["scene"]:getChildByName("layer_tips"):removeSelf()
                if sender==btn_sure then
                    --todo
                    
                elseif sender==btnCancel then
                    --todo
                    if call then
                        --todo
                         call("canle")
                    end
                   
                elseif sender==btnSubmit then
                    if call then
                        call("submit")
                    end
                end
            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)
        btn_sure:addTouchEventListener(touchEvent)

    end

end

--显示更新进度
function HallUpdate:setLoadingProgress(progress)
    -- body
    if progress < 0 then
        return
    end
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
function HallUpdate:DefaultProgress()
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


--
-- function HallUpdate:gExitGame()
--     --断开连接
--     cc.Director:getInstance():endToLua()
--     if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
--         cc.Director:getInstance():endToLua()
--     elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
--         require("hall.GameSetting"):applyChangeUser()
--     else
--         cc.Director:getInstance():endToLua()
--     end
-- end

-- --推出组局
-- function HallUpdate:gExitGroupGame(gameId)
--     cc.Director:getInstance():endToLua()
--     if (cc.PLATFORM_OS_ANDROID == targetPlatform) then
--         cc.Director:getInstance():endToLua()
--     elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
--         require("hall.GameSetting"):applyChangeUser()
--     else
--         cc.Director:getInstance():endToLua()
--     end
-- end

--校验版本号
function HallUpdate:checkVersion(code,version)
    -- body
    local strKey = code .. "_current-version"
    local localVersion = cc.UserDefault:getInstance():getStringForKey(strKey,"")
    local tbRemote = {}
    local tbLocal = {}

    print("local ver:",localVersion,"remote ver:",version)

    strKey = localVersion
    if strKey == "" then
        tbLocal[1] = 0
    else
        tbLocal = string.split(localVersion,".")
        for i = 1, #tbLocal do
            tbLocal[i] = tonumber(tbLocal[i])
        end
    end
    dump(tbLocal,"tbLocal")


    tbRemote = string.split(version,".")
    for i = 1, #tbRemote do
        tbRemote[i] = tonumber(tbRemote[i])
    end
    dump(tbRemote,"tbRemote")

    for i = 1, #tbLocal do
    
        if tbLocal[i] > tbRemote[i] then
            return false
        end
        if i == #tbRemote then
            if tbLocal[i] == tbRemote[i] then
                return false
            end
        end
    end
    return true
end

return HallUpdate