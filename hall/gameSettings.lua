

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local gameSettings  = class("gameSettings")

local tbDDZErrorCode = {
    [0] = "成功创建新连接",
    [1] = "重连成功",
    [2] = "成功踢其他玩家",
    [3] = "玩家密匙错误",
    [4] = "数据库连接错误",
    [5] = "无此房间",
    [6] = "玩家登录房间错误",
    [7] = "无房间分配",
    [8] = "没有空桌子",
    [9] = "玩家余额不足",
    [10] = "游戏策略错误",
    [11] = "未知错误",
    [12] = "黑名单",
    [13] = "玩家请求准备",
    [14] = "添加黑名单错误",
    [15] = "您当前不能进低分场",
    [16] = "等级不够",
    [17] = "等级太高",
    [18] = "经验不够",
    [19] = "经验太多",
    [20] = "比赛中退赛马上有报名错误",
    [21] = "比赛场金币不足",
    [22] = "比赛场钻石不足",
}

local gameData = {}
local gameMode = {"free","match","group"}

function gameSettings:reset()
    -- body
    gameData = {}
end

--设置游戏模式
--free 自由场
--match 比赛场
--group 组局
function gameSettings:setGameMode( mode )
    -- body
    if gameData == nil then
        gameData = {}
    end
    if mode == "group" then
        isGroup=true
        require("hall.GameData"):getGroupInfo()
    end
    gameData["gameMode"] = mode
    print("setGameMode",self:getGameMode())
end
function gameSettings:getGameMode()
    -- body
    local mode = "group"
    return mode
end


return gameSettings