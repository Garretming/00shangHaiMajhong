require("framework.init")

--导入套接字请求处理
local PROTOCOL = import(HallProtocol_filePath)

--定义大厅请求处理类
local HallHandle = class("HallHandle")

function HallHandle:ctor()

    self.func_ = {
        --当前玩家被服务器断网
        [PROTOCOL.SVR_CLOSE_NET] = {handler(self, HallHandle.SVR_CLOSE_NET)},
        --当前玩家被踢下线
        [PROTOCOL.SVR_KICK_OFF] = {handler(self, HallHandle.SVR_KICK_OFF)},
        --服务器返回进入游戏
        [PROTOCOL.SVR_LOGIN_GAME] = {handler(self, HallHandle.SVR_LOGIN_GAME)},  --210
        --登录成功
        [PROTOCOL.SVR_LOGIN_OK] = {handler(self, HallHandle.SVR_LOGIN_OK)}, 
        --围观重连
        [PROTOCOL.SVR_LOGINLOOK_OK] = {handler(self, HallHandle.SVR_LOGINLOOK_OK)}, 
    }

end

--协议数据返回
function HallHandle:callFunc(pack)

    if self.func_[pack.cmd] and self.func_[pack.cmd][1] then
        self.func_[pack.cmd][1](pack)
    end

end

--大厅Socket连接成功
function HallHandle:SVR_LOGIN_OK(pack)

    dump(pack, "-----大厅Socket连接成功-----")

    if pack then

        if pack["Ver"] == 1 then

            print("", "-----Socket返回登录成功，进入大厅-----", bm.netdisConnect)

            if bm.netdisConnect then

                --网络重连成功，请求组局历史记录，重连游戏
                bm.netdisConnect = false
                bm.notCheckReload = 0
                bm.isConnectBytao = true

                if bm.isInGame then

                    if SCENENOW["name"] == GameScene_filePath or SCENENOW["name"] == "hall.hallScene" then
                        display_scene(GameScene_filePath, 1)
                    else
                        require("hall.groudgamemanager"):reConnectGroupStatus(handler(self, self.reConnetGame))
                    end
                
                else

                    local gameList = require(GameList_filePath):getList()
                    if gameList ~= nil and #gameList > 0 then
                        require("hall.groudgamemanager"):requestGroupStatusInHallScene()
                    else
                        require("hall.GameCommon"):landLoading(false)

                        if SCENENOW["name"] ~= GameScene_filePath then
                            display_scene(GameScene_filePath, 1)
                        end
                        
                    end

                end
                
            else

                --第一次连接大厅，进入大厅界面
                require("hall.GameCommon"):landLoading(false)
                require("hall.GameCommon"):setLoadingProgress(100)
                display_scene(GameScene_filePath, 1)
                
            end

        end

    end

end

--服务器返回进入游戏
--重连之后才会有的操作
--直接发送1001
function HallHandle:SVR_LOGIN_GAME(pack)

    dump(pack, "-----服务器返回进入游戏  重连113返回-----")

    print("reconnectSVR_LOGIN_GAME", pack.Tid)
    local sendpack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_ROOM_GROUP)
                                :setParameter("tableid", pack.Tid)
                                :setParameter("nUserId", USER_INFO["uid"])
                                :setParameter("strkey", json.encode("kadlelala"))
                                :setParameter("strinfo", USER_INFO["user_info"])
                                :setParameter("iflag", 2)
                                :setParameter("version", 1)
                                :setParameter("activity_id", USER_INFO["activity_id"])
                                :build()
    
    bm.server:setProtocol(bm.server.oldProtoacal)
    bm.server:setHandle(bm.server.oldHandle)

    bm.server:send(sendpack)

    -- cct.showLoading()

    dump("", "-----重连发送1001-----")

end

--围观重连
function HallHandle:SVR_LOGINLOOK_OK(pack)
    local reloadTable = pack["Tid"]
    tableIdReload = reloadTable
    if reloadTable > 0 then
        require("hall.GameList"):setReloadTable(reloadTable)
        require("hall.GameList"):setReloginMode(pack["on_look_user"])
        require("hall.HallHttpNet"):requestReloadGame()
    else
        require("hall.GameCommon"):landLoading(false)
        require("hall.GameCommon"):setLoadingProgress(100)
        display_scene("hall.gameScene",1)
    end
end

--重连到游戏
function HallHandle:reConnetGame(activityId, level)

    --移除所有加载进度条
    require("hall.GameCommon"):landLoading(false)

    --移除所有加载圈
    if SCENENOW["scene"]:getChildByName("loading") then
        SCENENOW["scene"]:removeChildByName("loading")
    end
    
    print("-----重连到游戏,发送113-----", activityId, level)
    local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_GAME)
        :setParameter("Level", level)
        :setParameter("Chip", 1)
        :setParameter("Sid", 1)
        :setParameter("activity_id", activityId)       
        :build()
    bm.server:send(pack)

    USER_INFO["activity_id"] = activityId

end

--客户端socket被断
function HallHandle:SVR_CLOSE_NET(pack)
    require("hall.GameTips"):showTips("提示", "network_disconnect", 1, "网络异常，请检查网络")
end

--客户端被踢
function HallHandle:SVR_KICK_OFF(pack)

    require("hall.GameTips"):showTips("提示", "", 3, "您被请出游戏")

    --显示登录页
    require("hall.LoginScene"):show()

end

return HallHandle