
local AgentScene = class("AgentScene")

function AgentScene:showScene(cardNum)

    cardNum = cardNum or 0

	if SCENENOW["scene"] then
		
		--释放之前的
        local s = SCENENOW["scene"]:getChildByName("AgentScene")
        if s then
            s:removeSelf()
        end

        --添加新场景
        if device.platform == "ios" then
            if isiOSVerify then
                s = cc.CSLoader:createNode("hall/BuyRoomCard/AgentScene.csb")
            else
                s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/BuyRoomCard/AgentScene.csb")
            end
        else
            s = cc.CSLoader:createNode("hall/BuyRoomCard/AgentScene.csb")
        end
        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end
        s:setName("AgentScene")
        SCENENOW["scene"]:addChild(s)

        --控件
        --背景
        local Panel_1 = s:getChildByName("Panel_1")
        Panel_1:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then

                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    -- self:removeScene()
                end

            end
        )

        --赠送房卡数
        local text_qingshurumima_9 = s:getChildByName("text_qingshurumima_9")
        -- text_qingshurumima_9:setString("请输入您的推荐人ID，即可领取房卡".. cardNum .. "张！免费福利大放送。")
        text_qingshurumima_9:setString("扫描代理二维码即可完成绑定")

        --数字
        local tbNumber = {}
        local numPos = 0
        local str = 1
        local function reFresh()
            for i = 1,6 do
                str = "num_box_"..tostring(i)
                local txt = s:getChildByName(str):getChildByName("Text_1")
                if tbNumber[i] then
                    txt:setString(tostring(tbNumber[i]))
                else
                    txt:setString("")
                end
            end
        end
        reFresh()

        --数字按钮
        local tbBtnNumbers = {}
        for i = 1,10 do
            if i < 10 then
                str = "btn_"..tostring(i)
            else
                str = "btn_0"
            end
            tbBtnNumbers[i] = s:getChildByName(str)
        end

        --按钮事件
        local function touchButtonEvent(sender, event)

            if event == TOUCH_EVENT_ENDED then
                if #tbNumber < 6 then
                    for i=1,10 do
                        if sender == tbBtnNumbers[i] then
                            numPos = numPos + 1
                            tbNumber[numPos] = i
                            if tbNumber[numPos] >= 10 then
                                tbNumber[numPos] = 0
                            end
                            reFresh()
                        end
                    end
                end
            end
            
        end

        --按钮注册
        for i = 1,10 do

            if tbBtnNumbers[i] then
                tbBtnNumbers[i]:addTouchEventListener(touchButtonEvent)
            end

        end

        --确定
        local btn_submit = s:getChildByName("btn_submit")
        btn_submit:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then

                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then

                    if #tbNumber == 6 then

                        local strCode = ""
                        for i = 1, 6 do
                            strCode = strCode..tostring(tbNumber[i])
                        end

                        dump(strCode, "-----strCode-----")

                        local table = {}
                        table["userId"] = USER_INFO["uid"]
                        table["agentId"] = strCode

                        cct.createHttRq({
                            url = HttpAddr .. "/userBindingAgent",
                            date = table,
                            type_= "POST",
                            requestMsg = "正在绑定代理",
                            callBack = function(data)

                                local responseData = data.netData
                                if responseData then
                                    responseData = json.decode(responseData)
                                    dump(responseData, "-----绑定代理-----")

                                    local returnCode = responseData.returnCode
                                    if returnCode == "0" then

                                        local data = responseData.data
                                        if data ~= nil then
                                            local agentId = data.agentId
                                            if agentId ~= nil then
                                                USER_INFO["agentId"] = agentId
                                            end

                                            local agentName = data.nickNme
                                            if agentName ~= nil then
                                                USER_INFO["agentName"] = agentName
                                            end

                                            require(GameScene_filePath):showAgent()
                                        end

                                        require(GameScene_filePath):queryRoomCardCount()

                                        require("hall.BuyRoomCard.AgentScene"):removeScene()
                                        
                                    elseif returnCode == "1" then

                                        local error = responseData.error
                                        if error and error ~= "" then
                                            require("hall.GameTips"):showTips("提示", "", 3, error)
                                        else
                                            require("hall.GameTips"):showTips("提示", "", 3, "未知错误，绑定失败")
                                        end

                                    else
                                        require("hall.GameTips"):showTips("提示", "", 3, "未知错误，绑定失败")

                                    end

                                end

                            end
                        })

                    else
                        require("hall.GameTips"):showTips("提示", "", 3, "请输入6位推荐人ID")

                    end

                end

            end
        )

        --删除
        local btn_del = s:getChildByName("btn_del")
        btn_del:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then

                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then

                    if numPos > 0 then
                        table.remove(tbNumber,numPos)
                        numPos = numPos - 1
                        reFresh()
                    end

                end

            end
        )

        --关闭
        local btn_exit = s:getChildByName("btn_exit")
        btn_exit:setVisible(false)
        btn_exit:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then

                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then

                    self:removeScene()

                    --显示房卡界面
                    -- require("hall.BuyRoomCard.BuyRoomCardScene"):showScene()

                end

            end
        )

	end

end

function AgentScene:removeScene()

	if SCENENOW["scene"] then
		
		--释放之前的
        local s = SCENENOW["scene"]:getChildByName("AgentScene")
        if s then
            s:removeSelf()
        end

	end

end

return AgentScene