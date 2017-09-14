
local PROTOCOL = import(HallProtocol_filePath)

local HallHandle = require(HallHandle_filePath)

local ServerBase = require(ServerBase_filePath)
local HallServer = class("HallServer", ServerBase)

local RELOGIN_TIMER

--初始化
function HallServer:ctor()
    HallServer.super.ctor(self, "HallServer", PROTOCOL)
end

--建立Socket连接（连接大厅服务器）
function HallServer:connectSocket()

    local ip = hall_ip
    -- ip = "game." .. hall_ip

    dump(ip, "-----建立Socket连接-----")

    if bm.server:isConnected() then
        bm.server:disconnect()
    end

    bm.server:connect(ip, hall_port, 0)
    
end

--Socket连接成功
function HallServer:onAfterConnected()

    dump("", "-----Socket连接成功-----")
    

    if  RELOGIN_TIMER then
        SCENENOW["scene"]:stopAllActions()
        RELOGIN_TIMER = nil
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
           s:removeSelf()
        end
    end

    if bm.SocketFirstConnectSuccess == false then
        bm.SocketFirstConnectSuccess = true
    end

    local tbl = self:getProtocol() or {}
    local protocol_name = tbl.HALL_PROTOCOL_EX or ""
    dump(protocol_name, "-----protocol_name-----")
    dump(PROTOCOL.HALL_PROTOCOL_EX, "-----PROTOCOL.HALL_PROTOCOL_EX-----")

    -- if protocol_name ~= PROTOCOL.HALL_PROTOCOL_EX then

    --     dump("protocol_name不是HALL_PROTOCOL_EX", "-----Socket连接成功-----")

    --     bm.server.oldProtoacal = self:getGameProtocol()
    --     bm.server.oldHandle = self:getHandle()

    -- else

    --     dump("protocol_name是HALL_PROTOCOL_EX", "-----Socket连接成功-----")

    --     bm.server.oldProtoacal = self:getProtocol()
    --     bm.server.oldHandle = self:getHandle()

    -- end

    --记录游戏Protocol和Handle
    bm.server.oldProtoacal = self:getGameProtocol()
    bm.server.oldHandle = self:getGameHandle()

    --设置大厅Socket协议和对应处理方法
    bm.server:setProtocol(PROTOCOL, true)
    bm.server:setHandle(HallHandle.new(), true)
    
    self:LoginHall();

    if bm.netdisConnect then

        --require("hall.GameTips"):showTips("提示","",4,"重新连接成功")

        --设置当前没在更新
        require("hall.GameUpdate"):setUpdateStatus(0)
        return

    end

    require("hall.GameCommon"):setLoadingProgress(60)
    require("hall.GameCommon"):showLoadingTips("登录大厅")

    
    -- if SCENENOW["name"] == "hall.hallScene" then
    --     --SCENENOW["scene"]:onConnected()
    -- else
    --     require("app.HallUpdate"):landLoading(true)
    --     require("app.HallUpdate"):queryVersion(2)
    -- end
    

end

--登录游戏大厅
function HallServer:LoginHall()

    dump("-----Socket登录大厅---116-----", "-----HallServer-----")
    local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN)
        :setParameter("uid", UID)
        :setParameter("storeId", 1)
        :setParameter("kind", 1)
        :setParameter("userInfo", USER_INFO["user_info"])       
        :build()
    bm.server:send(pack)

end

--登录游戏
function HallServer:loginGame(level)

    local pack = bm.server:createPacketBuilder(PROTOCOL.CLI_LOGIN_GAME)
                    :setParameter("Level",  level)
                    :setParameter("Chip", 10)
                    :setParameter("Sid", 1)
                    :setParameter("activity_id", "")
                    :build()
    bm.server:send(pack)

end

--网络断开
function HallServer:netClose()

    if bm.SocketFirstConnectSuccess then
        
        bm.netdisConnect = true

        dump(bm.netdisConnect, "-----HallServer-----netClose-----")

        -- if  SCENENOW["name"]=="hall.hallScene" or SCENENOW["name"]=="hall.gameScene" then
        --     --todo
        --     return;
        -- end

        if not SCENENOW["scene"]:getChildByName("loading") then
            --todo
            --self:connect()
            -- if self.socket_.isConnected then
            --      self.socket_:_onDisconnect()
            -- else
            --      self.socket_:_connectFailure()
            -- end
            
            -- cct.showLoadingTip()
           
        end

    else

        self:connectSocket()

    end
    
end

--发送组局信息
function HallServer:SendGameMsg(level,msg)

    dump(level, "-----当前组局level-----")
    dump(msg, "-----发送组局信息-----")

    local pack = bm.server:createPacketBuilder(PROTOCOL.CLIENT_CMD_FORWARD_MESSAGE)
                    :setParameter("level", level)
                    :setParameter("msg", msg)
                    :build()
    bm.server:send(pack)

end

return HallServer