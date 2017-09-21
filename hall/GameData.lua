
local GameData  = class("GameData")

--初始化游戏数据
  ttt =false
function GameData:InitData()

    --获取当前系统平台
    targetPlatform = cc.Application:getInstance():getTargetPlatform()

    --判断应用是否第一次打开
    isFirstBegin = cc.UserDefault:getInstance():getBoolForKey("isFirstBegin", true)
    if isFirstBegin then
        cc.UserDefault:getInstance():setBoolForKey("isFirstBegin", false)
    end
    
    --电脑端测试用户 -- UID = 100845  
    -- UID = 101072  
    UID = 101108 
    UID = 101109
    UID = 101110
    -- UID = 101111 
    

    

    --设置音量开关
    MUSIC_ON = cc.UserDefault:getInstance():getBoolForKey("music_on", true)
    SOUND_ON = cc.UserDefault:getInstance():getBoolForKey("sound_on", true)
    SHOCK_ON = cc.UserDefault:getInstance():getBoolForKey("shock_on", true)

    --设置音量大小和音效大小
    if isFirstBegin then
        cc.UserDefault:getInstance():setFloatForKey("MusicVolume", 1.0)
        cc.UserDefault:getInstance():setFloatForKey("EffectsVolume", 1.0)
    end
    self:setVolume()
   
end
    
--获取用户数据
function GameData:getUserInfo()
    
    
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then

        local args = {}
        local sigs = "()I"
        local luaj = require "cocos.cocos2d.luaj"
        local className = luaJniClass

        local ok,ret  = luaj.callStaticMethod(className,"getUserID",args,sigs)
        if not ok then
            print("luaj error:", ret)
            return
        else
            USER_INFO["uid"] = ret
            print("getUserInfo uid:"..ret)
            UID = USER_INFO["uid"]
        end

        sigs = "()Ljava/lang/String;"
        ok,ret  = luaj.callStaticMethod(className,"getNickName",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            USER_INFO["nick"] = ret
        end

        ok,ret  = luaj.callStaticMethod(className,"getToken",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            token = ret
            print("getUserInfo nick:"..ret)
        end

        --用户类型
        sigs = "()Ljava/lang/String;"
        ok,ret  = luaj.callStaticMethod(className,"getUserType",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            USER_INFO["type"] = ret
        end

    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then
        
        --iOS平台
        if bm.isQuickLogin == "1" then

            local uid_arr = {}
            table.insert(uid_arr, 10096)
            table.insert(uid_arr, 10097)
            table.insert(uid_arr, 10098)
            table.insert(uid_arr, 10099)
            table.insert(uid_arr, 10100)
            table.insert(uid_arr, 10101)
            table.insert(uid_arr, 10102)
            table.insert(uid_arr, 10103)
            table.insert(uid_arr, 10104)
            table.insert(uid_arr, 10105)

            table.insert(uid_arr, 10106)
            table.insert(uid_arr, 10107)
            table.insert(uid_arr, 10108)
            table.insert(uid_arr, 10109)
            table.insert(uid_arr, 10110)
            table.insert(uid_arr, 10111)
            table.insert(uid_arr, 10112)
            table.insert(uid_arr, 10113)
            table.insert(uid_arr, 10114)
            table.insert(uid_arr, 10115)

            math.randomseed(tostring(os.time()):reverse():sub(1, 6))
            local num = math.random(20)

            UID = uid_arr[num]

            USER_INFO["uid"] = UID
            USER_INFO["nick"] = tostring(UID)
            USER_INFO["type"] = "P"

        else

            local args = {}
            local luaoc = require "cocos.cocos2d.luaoc"
            local className = "CocosCaller"

            local ok,ret  = luaoc.callStaticMethod(className,"getUserID")
            if not ok then
                cc.Director:getInstance():resume()
            else
                USER_INFO["uid"] = ret
                UID = USER_INFO["uid"]
            end

            ok,ret  = luaoc.callStaticMethod(className,"getNickName")
            if not ok then
                cc.Director:getInstance():resume()
            else
                USER_INFO["nick"] = ret
            end

            ok,ret  = luaoc.callStaticMethod(className,"getToken")
            if not ok then
                cc.Director:getInstance():resume()
            else
                token = ret
            end

            --用户类型
            ok,ret  = luaoc.callStaticMethod(className,"getUserType")
            if not ok then
                cc.Director:getInstance():resume()
            else
                USER_INFO["type"] = ret
            end

        end
        
    else

        --其他平台
        if bm.isQuickLogin == "1" then

            local uid_arr = {}
            table.insert(uid_arr, 10096)
            table.insert(uid_arr, 10097)
            table.insert(uid_arr, 10098)
            table.insert(uid_arr, 10099)
            table.insert(uid_arr, 10100)
            table.insert(uid_arr, 10101)
            table.insert(uid_arr, 10102)
            table.insert(uid_arr, 10103)
            table.insert(uid_arr, 10104)
            table.insert(uid_arr, 10105)

            table.insert(uid_arr, 10106)
            table.insert(uid_arr, 10107)
            table.insert(uid_arr, 10108)
            table.insert(uid_arr, 10109)
            table.insert(uid_arr, 10110)
            table.insert(uid_arr, 10111)
            table.insert(uid_arr, 10112)
            table.insert(uid_arr, 10113)
            table.insert(uid_arr, 10114)
            table.insert(uid_arr, 10115)

            math.randomseed(tostring(os.time()):reverse():sub(1, 6))
            local num = math.random(20)

            UID = uid_arr[num]

            USER_INFO["uid"] = UID
            USER_INFO["nick"] = tostring(UID)
            USER_INFO["type"] = "P"

        else

            USER_INFO["uid"] = UID
            USER_INFO["nick"] = tostring(UID)
            USER_INFO["type"] = "P"

        end

    end

end

--获取用户地理位置信息
function GameData:getLocation()

    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then

        local args = {}
        local sigs = "()Ljava/lang/String;"
        local luaj = require "cocos.cocos2d.luaj"
        local className = luaJniClass

        ok,ret  = luaj.callStaticMethod(className,"getLongitude",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            USER_INFO["Longitude"] = ret
        end

        ok,ret  = luaj.callStaticMethod(className,"getLatitude",args,sigs)
        if not ok then
            print("luaj error:", ret)
        else
            USER_INFO["Latitude"] = ret
        end

    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then

        USER_INFO["Latitude"] = cct.getDataForApp("getLatitude", {}, "string")
        USER_INFO["Longitude"] = cct.getDataForApp("getLongitude", {}, "string")

    else

        USER_INFO["Longitude"] = "113"
        USER_INFO["Latitude"] = "23"

    end
    
end

--设置音量大小和音效大小
function GameData:setVolume()

    local audioEngine = cc.SimpleAudioEngine:getInstance()
    local MusicVolume = cc.UserDefault:getInstance():getFloatForKey("MusicVolume")  
    local EffectsVolume = cc.UserDefault:getInstance():getFloatForKey("EffectsVolume")
    audioEngine:setMusicVolume(MusicVolume)
    audioEngine:setEffectsVolume(EffectsVolume)
  
end

--获取本地游戏版本号
function GameData:getGameVersion(game)

    local strKey = game .. "_current-version"
    local strVersion = cc.UserDefault:getInstance():getStringForKey(strKey,"")
    return strVersion
    
end

--比较本地版本
function GameData:compareLocalVersion(version,game)
    -- body
    if version == nil then
        return 0
    end


    local lVersion = self:getGameVersion(game)
    local tbLocal = {}
    local tbRemote = {}

    local tem,nPos = string.find(lVersion,"%.")
    for i = 1, string.len(lVersion) do
        local strPic = string.sub(lVersion,1,nPos-1)
        table.insert(tbLocal,strPic)
        lVersion = string.sub(lVersion,nPos+1,string.len(lVersion))
        tem,nPos = string.find(lVersion,"%.")
        if tem == nil then
            table.insert(tbLocal,lVersion)
            break
        end
    end

    lVersion = version
    local tem,nPos = string.find(lVersion,"%.")
    for i = 1, string.len(lVersion) do
        local strPic = string.sub(lVersion,1,nPos-1)
        table.insert(tbRemote,strPic)
        lVersion = string.sub(lVersion,nPos+1,string.len(lVersion))
        tem,nPos = string.find(lVersion,"%.")
        if tem == nil then
            table.insert(tbRemote,lVersion)
            break
        end
    end

    if #tbLocal == 0 then
        return 1
    end

    for i = 1,#tbRemote do
        local subLocal = tonumber(tbLocal[i])
        local subRemote = tonumber(tbRemote[i])
        print("subLocal:"..subLocal.."   subRemote:"..subRemote)
        if subRemote > subLocal then
            print("new version["..game.."]")
            return 1
        end
    end

    return 0
end

return GameData