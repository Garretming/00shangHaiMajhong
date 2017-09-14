
local Request = class("Request")

requireNum = 0

function Request:ctor()

    dump("初始化请求文件", "-----Request-----")

    cct = cct or {}

    --重载网络请求方法
    cct.createHttRq = function(parm)

        local url = parm.url;
        dump(url, "-----请求链接-----")
        local interfaceName = parm.interfaceName or ""
        local date = parm.date or {}
        local callBack = parm.callBack 
        local type_ = parm.type_ or "POST"
        local arg = parm.arg or {}
        local requestMsg = parm.requestMsg   -- or "拼命加载中"
        if requestMsg and requestMsg ~= ""  then
            require(NetworkLoadingView_filePath):showLoading(requestMsg)
        end

        local function reqCallback(event)

            local request = event.request

            if event.name ~= "progress" then
                dump(event.name, "-----event.name-----")
            end

            --判断请求是否为失败
            if event.name == "failed" then

                if requireNum == 3 then

                    requireNum = 0

                    if interfaceName == "getUserInfo4GameServer" then
                        require(CommonTips_filePath):showTips("提示", "", 3, "网络异常，请重新登录")
                        require(LoginScene_filePath):show()
                    else
                        require(CommonTips_filePath):showTips("提示", "", 3, "网络异常，请稍候再试")
                    end

                    return

                end

                bm.SchedulerPool:delayCall(function()

                    requireNum = requireNum + 1

                    --重新进行当前请求
                    cct.createHttRq(parm)

                end, 3)

                return

            end
         
            --判断请求是否已经结束
            local ok = (event.name == "completed")
            if not ok then
                return
            end
         
            --请求结束，根据请求码进行操作
            local code = request:getResponseStatusCode()
            if code ~= 200 then
                -- 没有返回 200 响应代码

                dump(code, "-----ResponseStatusCode-----")

                if requireNum == 3 then

                    requireNum = 0

                    if interfaceName == "getUserInfo4GameServer" then
                        require(CommonTips_filePath):showTips("提示", "", 3, "网络异常，请重新登录")
                        require(LoginScene_filePath):show()
                    else
                        require(CommonTips_filePath):showTips("提示", "", 3, "网络异常，请稍候再试")
                    end

                    return

                end

                bm.SchedulerPool:delayCall(function()

                    requireNum = requireNum + 1

                    --重新进行当前请求
                    cct.createHttRq(parm)

                end, 3)

                return

            end

            --请求正常

            --重置重新请求计数
            requireNum = 0

            --隐藏加载圈
            require(NetworkLoadingView_filePath):removeView()
         
            --返回服务端返回内容
            local response = request:getResponseString()
            arg.net = event
            arg.netData = response
            callBack(arg)

        end

        --get请求则拼接请求链接
        if type_ == "GET" then

            local str = "?"
            for k,v in pairs(date) do
                str = str .. k.. "=" .. v .. "&"
            end
            url = url .. str

        end

        --创建请求
        local request = network.createHTTPRequest(reqCallback, url, type_)
        request:addRequestHeader('Content-Type:application/x-www-form-urlencoded')

        --post请求则传递入参
        if type_ == "POST" then
            for k,v in pairs(date) do
                request:addPOSTValue(k, v)
            end
        end

        --设置超时时间
        request:setTimeout(10)

        --开始请求。当请求完成时会调用reqCallback
        request:start()

    end

    cct.showLoading = function()
     -- require(NetworkLoadingView_filePath):showLoading("拼命加载中")
    end


    cct.showLoadingTip = function(msg)
        -- require(NetworkLoadingView_filePath):showLoading("拼命加载中")
    end

end

--用户登录
function Request:userLogin(uid)

    cct.createHttRq({
        url = HttpAddr .. "/playerUser/getUserInfo4GameServer",
        interfaceName = "getUserInfo4GameServer",
        requestMsg = "",
        date={
            userId = USER_INFO["uid"]
        },
        requestMsg = "",
        callBack = function(data)

            local responseData = json.decode(data.netData)
            dump(responseData,"-----请求登录验证返回-----")

            --登录失败,弹出登录界面
            if responseData == nil then
                require(CommonTips_filePath):showTips("提示", "", 3, "登录失败")
                require(LoginScene_filePath):show()
            end

            if responseData["returnCode"] == "0" then

                if responseData["data"]["mtKey"] == nil then
                    require(CommonTips_filePath):showTips("提示", "", 3, "登录验证失败")
                    require(LoginScene_filePath):show()
                    return
                end

                --获取用户个人信息
                local data = responseData["data"]["playerProfile"]

                --假如返回数据为空
                if data == nil then
                    require("hall.GameTips"):showTips("提示", "", 3, "登录失败，用户数据异常")
                    require(LoginScene_filePath):show()
                    return
                end

                --记录用户信息
                USER_INFO["nick"] = data["nickName"]
                USER_INFO["sex"] = tonumber(data["sex"]) or 1
                USER_INFO["icon_url"] = data["photoUrl"] or ""

                local tbData = {}
                tbData["level"] = data["level"]
                tbData["nickName"] = data["nickName"]
                tbData["photoUrl"] = data["photoUrl"]
                tbData["sex"] = data["sex"]
                tbData["money"] = data["coinAmount"]
                USER_INFO["user_info"] = json.encode(tbData)
                USER_INFO["phone"] = data["phone"]

                --绑定代理
                USER_INFO["agentId"] = data["agentId"]
                USER_INFO["agentName"] = data["agentName"]

                dump(USER_INFO["agentId"], "-----agentId-----")
                dump(USER_INFO["agentName"], "-----agentName-----")

                --登录成功，设置当前进度为20%
                require("hall.GameCommon"):setLoadingProgress(20)
                require("hall.GameCommon"):showLoadingTips("连接游戏服务器")

                --获取并记录大厅服务器信息
                local hall = responseData["data"]["hall"]
                hall_ip = hall["ip"]
                hall_port = hall["port"]

                --进行大厅服务器Socket连接
                require(HallServer_filePath):connectSocket()

            else

                if responseData["error"] ~= nil and responseData["error"] ~= "" then
                    require(CommonTips_filePath):showTips("提示", "", 3, responseData["error"])
                else
                    require(CommonTips_filePath):showTips("提示", "", 3, "登录失败，未知错误")
                end
                
                require(LoginScene_filePath):show()

            end

        end,
        type="POST"
    })
    
    return true

end

--获取游戏列表
function Request:getGameList()

    dump("", "-----获取游戏列表-----")

    local params = {}
    params["platform"] = "1"
    cct.createHttRq({
        url = HttpAddr .. "/game/hallLoading",
        date = params,
        type_="POST",
        requestMsg = "",
        callBack = function(data)
            local responseData = data.netData
            if responseData then
                local responseData = json.decode(responseData)
                dump(responseData, "-----获取游戏列表返回-----")

                --添加游戏列表到本地
                
                require(GameList_filePath):loadGameList(responseData["data"])

                bm.gameInfoList = {}
                local gameListdata = responseData["data"]
                for k,v in pairs(gameListdata) do

                    if v["gameType"] == nil then
                        v["gameType"] = "棋牌类"
                    end

                    if bm.gameInfoList[v["gameType"]] == nil then
                        bm.gameInfoList[v["gameType"]] = {}
                    end

                    if v.gameId ~= 84 and v.gameId ~= 42 and v.gameId ~= 46 then
                        table.insert(bm.gameInfoList[v["gameType"]], v)
                    end

                end

                --获取玩家组局状态(检查用户游戏状态，进行重连)
                dump("", "-----获取游戏列表成功，检查重连-----")
                require("hall.groudgamemanager"):requestGroupStatus()

            end       
        end
    })

end

--获取游戏列表
function Request:getGameType()

    if isiOSVerify then
        return
    end

    dump("", "-----获取游戏分类列表-----")

    local params = {}
    cct.createHttRq({
        url = HttpAddr .. "/game/queryGameType",
        date = params,
        type_="POST",
        requestMsg = "",
        callBack = function(data)
            local responseData = data.netData
            if responseData then
                local responseData = json.decode(responseData)
                dump(responseData, "-----获取游戏分类列表返回-----")

                bm.gameList = {}

                local list = {}
                local index = 2
                local gameListdata = responseData["data"]
                for k,v in pairs(gameListdata) do

                    if v["gameType"] == nil then
                        v["gameType"] = "棋牌类"
                    end

                    if list[v["gameType"]] == nil then
                        list[v["gameType"]] = {}
                    end

                    table.insert(list[v["gameType"]], v)

                end

                for k,v in pairs(list) do

                    if k == "热门类" then
                        local gameInfo = {}
                        gameInfo["gameType"] = k
                        gameInfo["gameArr"] = v
                        table.insert(bm.gameList, gameInfo)
                        break
                    end

                end

                for k,v in pairs(list) do

                    if k ~= "热门类" then
                        local gameInfo = {}
                        gameInfo["gameType"] = k
                        gameInfo["gameArr"] = v
                        table.insert(bm.gameList, gameInfo)
                    end

                end

                dump(bm.gameList, "-----bm.gameList-----")

            end       
        end
    })

end

--获取组局配置
function Request:getCreateGroupGameConfig()

    dump("", "-----获取组局配置-----")

    cct.createHttRq({
        url = HttpAddr .. "/game/queryGameConfig",
        date = {
            
        },
        type_= "GET",
        requestMsg = "",
        callBack = function(data)
            local responseData = data.netData
            if responseData then
                responseData = json.decode(responseData)
                local cacheData = responseData.data
                if cacheData then
                    local content = cacheData.content
                    if content then
                        local decodeData = json.decode(content)
                        bm.groupGameConfig = decodeData
                        dump(bm.groupGameConfig, "-----获取组局配置返回-----")
                    end
                end
            end
        end
    })

end

return Request