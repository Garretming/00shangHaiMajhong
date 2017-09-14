--@ms
--初始化应用信息
require("hall.data.AppMessage"):ctor()

--初始化config
require("hall.data.Config"):ctor()

--初始化http请求
require(Request_filePath):ctor()

--初始化Socket协议调用
--bm的设置
bm.PACKET_DATA_TYPE = import("socket.PACKET_DATA_TYPE")
bm.Logger = import("socket.Logger")
import("socket.functions").exportMethods(bm)
local HallServer = import(HallServer_filePath)

local hall_ip = ""
local hall_port = 4700
local phpLogined = 0

local hallScene = class("hallScene", function()
    return display.newScene("hallScene")
end)

--初始化
function hallScene:ctor()

    --初始化游戏数据
    require(GameData_filePath):InitData()

    --初始化游戏设置以及注册lua与原生交互方法
    require(GameSetting_filePath):InitData()

    --初始化当前Socket链接
    bm.SocketFirstConnectSuccess = false
    bm.netdisConnect = false
    bm.SchedulerPool = import("socket.SchedulerPool").new()
    bm.SocketService = require("socket.SocketService")
    bm.server = HallServer.new()

    --记录当前不在游戏中
    bm.isInGame = false

end

--进入
function hallScene:onEnter()

    --显示加载界面
    require("hall.GameCommon"):landLoading(true)
    require("hall.GameCommon"):setLoadingProgress(10)
    require("hall.GameCommon"):showLoadingTips("正为您准备游戏")

    --初始化用户数据
    self:initData()

end

--初始化用户数据
function hallScene:initData()

    require("hall.GameCommon"):showLoadingTips("进入大厅")

    --注册回调函数完成
    if (cc.PLATFORM_OS_ANDROID == targetPlatform) then

        cc.Director:getInstance():purgeCachedData();
        local luaj = require "cocos.cocos2d.luaj"
        local className = luaJniClass
        local ok,ret  = luaj.callStaticMethod(className,"autoLogin")
        if not ok then
            print("exitGame luaj error:", ret)
        else
            print("exitGame PLATFORM_OS_ANDROID")
        end

    elseif (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or (cc.PLATFORM_OS_MAC == targetPlatform) then

        local args = {}
        local luaoc = require "cocos.cocos2d.luaoc"
        local className = "CocosCaller"
        local ok,ret  = luaoc.callStaticMethod(className,"autoLogin")
        if not ok then
            cc.Director:getInstance():resume()
            print("exitGame PLATFORM_OS_IPHONE failed")
        else
            print("exitGame PLATFORM_OS_IPHONE")
        end

    else

        self:initFinished()

    end

end

--初始化完成
function hallScene:initFinished()

    --快速登录标志
    -- bm.isQuickLogin = "1"

    --获取用户数据
    require("hall.GameCommon"):showLoadingTips("获取用户信息")
    require(GameData_filePath):getUserInfo()

    --开启心跳检测,这里他们要求loginLayer隐藏的时候开始检测心跳。
    --loginLayer显示的时候不检测心跳包
    bm.checknetworking = true

    --检查当前是否存在登录界面，有则移除
    if SCENENOW["scene"] then
        local loginScene = SCENENOW["scene"]:getChildByName("loginLayer")
        if loginScene ~= nil then
            --todo
            loginScene:removeFromParent()
        end
    end

    require(Request_filePath):userLogin(USER_INFO["uid"])

end

--Socket登录游戏大厅
function hallScene:enterNormal()

    require("hall.GameCommon"):showLoadingTips("连接游戏服务器")
    require("hall.GameCommon"):setLoadingProgress(20)

    --进行大厅服务器Socket连接
    require(HallServer_filePath):connectSocket()

end

--游戏更新完成
function hallScene:gameUpdateFinished()

    dump("", "-----游戏更新完成-----")

    if require("hall.GameList"):isLastUpdate() then

        self:enterNormal()

    else

        local data = require("hall.GameList"):getCurrentUpdateGame()
        dump(data, "gameUpdateFinished")
        if data then
            self:checkGameVersion(data)
        else

        end

    end
end

--登录大厅成功
function hallScene:onNetLoginOK(pack)

end

function hallScene:onExit()
    
end

return hallScene
