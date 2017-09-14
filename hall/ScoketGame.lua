
local SocketService = class("SocketService")
-- local PING_TOOL = import("hall.GetPingValue")

local PacketParser = import("socket.PacketParser")

local PacketBuilder = import("socket.PacketBuilder")

local scheduler = require("framework.scheduler")

local clockUtils = require("hall.ClockUtils")

--socket相关
local socket_
local host_
local port_
local isChat_Msg

--protocol相关
local name_
local protocol_
local game_protocol
local game_handle
local parser_

--Handle相关
local _handle

--心跳相关
local HeartNum
local reconnect_num
local connectTimeTickScheduler

--socket类初始化
function SocketService:ctor(name, protocol, isChatMsg)

    isChat_Msg = isChatMsg
    name_ = name

    -- dump(name, "-----ScoketGame-----")
    -- dump(protocol, "-----ScoketGame-----")
    -- dump(isChat_Msg, "-----ScoketGame-----")

end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--socket相关

--建立Socket连接
function SocketService:connect(host, port, retryConnectWhenFailure)

    if self:isConnected() then
        return;
    end

    host_ = host or host_
    port_ = port or port_

    if not socket_ then

        print("创建新Socket实例----------------")
        socket_ = cc.net.SocketTCP.new(host_, port_)
        socket_:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self, self.onConnected))
        socket_:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self, self.onClose))
        socket_:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self, self.onData))
        socket_:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self, self.onClosed))

    else

        dump("Socket实例已经存在", "-----ScoketGame-----")

    end

    socket_:setName(name_):connect(host_, port_)

end

--获取socket对象
function SocketService:getSocketTCP()
    return socket_
end

--获取socket链接状态
function SocketService:isConnected()

    if socket_ then
        return socket_.isConnected
    end

    return false

end

--Sockey连接后
function SocketService:onConnected(evt)
    print("NEO [%d] onConnected. %s", evt.target.socketId_, evt.name)

    --停止所有旧的心跳检测
    self:unscheduleHeartBeat()

    --开始心跳检测
    self:scheduleHeartBeat(2)

    --调用Socket连接后处理方法
    self:onAfterConnected()

end 

--断开Socket连接
function SocketService:disconnect()

    --self:unscheduleHeartBeat()

    dump("", "-----断开Socket连接-----")
    
    parser_:reset()
    socket_:disconnect()
    socket_ = nil

end

--Socket断开
--这里有可能是服务器发过来的断开
function SocketService:onClose()
    print("onclose---------------------")
    --self:unscheduleHeartBeat()

    --调用Socket断开后的操作
    self:netClose()

end

--Socket已断开
function SocketService:onClosed(evt)
    --完全断开 --
    print("oncloseed------")
    --self:unscheduleHeartBeat()
end

--Socket重连
function SocketService:reConnect()

    cct.showLoadingTip()

    print("-----------reConnect---1-------------------")

    if not socket_ then
        return
    end

    print("-----------reConnect---2-------------------")
    -- print("reConnect",self.name_,self.socket_)
    ---self.socket_:close()

    -- parser_:reset()
    -- socket_ = nil

    --self:unscheduleHeartBeat()

    --断开Socket连接
    self:disconnect()

    --建立Socket连接
    self:connect()

    -- if self.socket_.isConnected then
    --  self.socket_:_onDisconnect()
    -- else
    --  self.socket_:_connectFailure()
    -- end

    --self:disconnect();
   
end

function SocketService:onAfterConnected()
    print("socket成功连接")
end


function SocketService:netClose()
    print("socket断开")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--protocol相关

--设置protocol
function SocketService:setProtocol(protocol, isHall)

    if protocol == nil then
        return
    end

    protocol_ = protocol
    parser_ = PacketParser.new(protocol.CONFIG.SERVER, name_, isChat_Msg)

    if not isHall then
        --todo
        game_protocol = protocol
    end
end

--获取protocol
function SocketService:getProtocol()

    return protocol_

end

--获取protocol
function SocketService:getGameProtocol()

    return game_protocol

end

--创建一个数据包
function SocketService:createPacketBuilder(cmd)

    if protocol_ ~= nil then
        return PacketBuilder.new(cmd, protocol_.CONFIG.CLIENT[cmd], name_, isChat_Msg)
    
    else

        bm.netdisConnect = false
        bm.notCheckReload = 0
        
        display_scene("app.scenes.MainScene")

    end
    
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--Handle相关

--设置handle
function SocketService:setHandle(handle, isHall)

    if handle == nil then
        return
    end
    
    _handle = handle

    if not isHall then
        --todo
        game_handle = handle
    end
end

--获取handle
function SocketService:getHandle()

    return _handle

end

function SocketService:getGameHandle()

    return game_handle

end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--数据相关

--发送数据包
function SocketService:send(data)

    --if self.socket_ then

    --   --if not self:isConnected() then
    --  --  --todo
    --  --  -- print("info: socke is not connect",self.name_)
 --  --           self:reConnect()
 --         --   return;
 --    else

 --        self:connect()
 --        return;
    -- end

  if self:isConnected() == true then
        if type(data) == "string" then
            socket_:send(data)
        else
            socket_:send(data:getPack())
        end
   -- else
   --      self:connect()
  end

end

--接收到服务端返回的数据
function SocketService:onData(evt)

    local buf = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
    buf:writeBuf(evt.data)
    buf:setPos(1)

    local success, packets = parser_:read(buf)

    local isDump = true
    local protocol_str = "当前所在：" .. tostring(USER_INFO["joinGameName"]) .. "，当前协议下的协议号："
    if parser_.config_ ~= nil then
        for k,v in pairs(parser_.config_) do
            protocol_str = protocol_str .. string.format("%#x", tostring(k)) .. "，"
        end
    end

    if packets ~= nil then

        if type(sData) == "string" then

            protocol_str = protocol_str .. "协议解析出错，packets：" .. packets

        else

            if #packets > 0 then
                for k,v in pairs(packets) do
                    protocol_str = protocol_str .. "当前解析协议号：" .. string.format("%#x", tostring(v.cmd)) .. "，"

                    if string.format("%#x", tostring(v.cmd)) == "0x110" then
                        isDump = false
                    end

                end
            else
                protocol_str = protocol_str .. "没有数据，解析出空数组"

            end

        end
        
    else
        protocol_str = protocol_str .. "没有解析出数据"

    end

    if isDumpProtocol_str then

        if isDump then
            dump(protocol_str, "-----协议解析输出-----")
        end
        
    end

    if not success or packets == nil then

        -- error("数据解析异常，" .. protocol_str)

        dump("数据解析异常，" .. protocol_str, "-----协议解析输出-----")

        print("数据解析异常，" .. protocol_str .. "-----协议解析输出-----")

        if device.platform == "windows" then
            
            error("数据解析异常，" .. protocol_str)

        else
            
            local gameList = require(GameList_filePath):getList()
            if gameList ~= nil and #gameList > 0 then
                require("hall.groudgamemanager"):requestGroupStatusInHallScene()
            else
                require("hall.GameCommon"):landLoading(false)
                display_scene("hall.hallScene", 1)
            end

        end

    else

        if #packets > 0 then

            for i, v in ipairs(packets) do

                if v.cmd ~= 272 and isShowNetLog then
                    print("NEO[====PACK====][%x][%s]\n==>%s", v.cmd, table.keyof(protocol_, v.cmd), json.encode(v))
                end

                if v.cmd == 0x110 then
                    ----------------------------
                    -- print("################# RECEIVE HEART BEAT ################")
                    -- if PING_TOOL ~= nil then
                    --  PING_TOOL:getTimeStampOfRecvHeart()
                    -- end
                    ----------------------------

                    --接收心跳包
                    HeartNum = HeartNum + 1;

                    clockUtils:receive()

                else

                    --接收到操作

                    --移除所有加载圈
                    if SCENENOW["scene"]:getChildByName("loading") then
                        SCENENOW["scene"]:removeChildByName("loading")
                    end
                    
                    _handle:callFunc(v)

                end

            end

        else

            print("数据解析异常，" .. protocol_str .. "-----协议解析输出-----")

            -- local gameList = require(GameList_filePath):getList()
            -- if gameList ~= nil and #gameList > 0 then
            --     require("hall.groudgamemanager"):requestGroupStatusInHallScene()
            -- else
            --     require("hall.GameCommon"):landLoading(false)
            --     display_scene("hall.hallScene", 1)
            -- end

        end

    end

end

----------------------------------------------------------------------------------------------------------------------------------------------------------
--心跳相关

--创建心跳包持续发送
function SocketService:scheduleHeartBeat(time)

    HeartNum = 0
    reconnect_num = 0

    --发送心跳包
    connectTimeTickScheduler = scheduler.scheduleGlobal(

        function()

            -- self:send(PacketBuilder.new():buildHeart());

            if  bm.checknetworking ~= false then

                ----------------------------------------------
                -- if PING_TOOL ~= nil then
                --  PING_TOOL:getTimeStampOfSendHeart()
                -- end
                ----------------------------------------------

                --发送心跳包
                self:send(self:buildHeart())

                clockUtils:send()

            end

        end

    , time)

    --开始检查心跳是否超时
    self:startHeart()

end

--创建心跳包
function SocketService:buildHeart()

    local buf = cc.utils.ByteArray.new(cc.utils.ByteArray.ENDIAN_BIG)
    --写包头，包体长度先写0
    buf:writeInt(15)--包体长度
    buf:writeStringBytes("BY")-- 魔数
    buf:writeUShort(1)-- 版本号
    buf:writeInt(0x110)                    -- 命令字
    buf:writeUShort(0)                            -- gameid
    buf:writeUShort(0)                            -- 业务id
    buf:writeByte(0)                              --平台ID
    buf:writeByte(0)                              --平台ID

     --修改包体长度
    buf:setPos(1)
    buf:writeInt(buf:getLen()-4)
    buf:setPos(buf:getLen() + 1)

    buf = require("src.socket.Encrypt"):EncryptBuffer(buf)

    return buf
end

function SocketService:startHeart()

    --移除旧的心跳检测函数
    if check_networking_scheduler then
        scheduler.unscheduleGlobal(check_networking_scheduler)
    end

    --self.connecting = true

    check_networking_scheduler = scheduler.scheduleGlobal(

        function()

            --scheduler.performWithDelayGlobal(function()
            -- if self.HeartNum<4 then --断线
            --  --todo
            --  self:reConnect()
            -- else
            --  self.HeartNum=0
            --  self:startHeart()
            -- print(self.HeartNum)
            print("-----self.HeartNum-----", HeartNum, bm.checknetworking)

            if  bm.checknetworking ~= false then

                if HeartNum > 0 then

                    HeartNum = 0
                    --self:startHeart()

                    reconnect_num = 0

                    -- if SCENENOW["scene"]:getChildByName("loading") then
                    --     SCENENOW["scene"]:removeChildByName("loading")
                    -- end

                else 

                    --断线
                    -- print("----reConnect-now-------------------")
                    -- if self.reconnect_num > 3 then
                    --     --self.reconnect_num  = 0 --考虑到网络要是忽然好了，还是给重登的机会
                    --     require("hall.GameTips"):showTips("提示", "", 3, "网络异常，请重新登录!")
                    -- else
                    --     self.reconnect_num = self.reconnect_num + 1
                    
                        HeartNum = 0

                                   
                    --重连

                    --游戏中重连
                    if  bm.isInGame == true then  
                        
                        reconnect_num = reconnect_num + 1

                        if reconnect_num < 2 then 

                            self:reConnect()   

                        else                 

                            local function relogin()
                                print("请求重连")
                                reconnect_num = 0    --重置请求重连次数
                                self:reConnect()    
                                require(NetworkLoadingView_filePath):showLoading("拼命加载中")
                            end

                            local callfunc = cc.CallFunc:create(function() 
                                require("hall.GameTips"):showTips("提示", "", 3, "网络异常，是否重连？",_,relogin)
                            end) 

                            RELOGIN_TIMER = callfunc
                            SCENENOW["scene"]:runAction(RELOGIN_TIMER)
                            
                        end

                    else                  
                            self:reConnect()   
                    end
                end

            end

            print("check networking-----")

        end, 6)

    clockUtils:start()

end

--移除心跳检测
function SocketService:unscheduleHeartBeat()
    print("unschduleHeartBeat----------------------")

    HeartNum = 0

    --移除心跳包发送
    if self.connectTimeTickScheduler then
        scheduler.unscheduleGlobal(connectTimeTickScheduler)
    end
    
end

return SocketService
