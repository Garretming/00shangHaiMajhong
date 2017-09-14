
local BuyRoomCardScene = class("BuyRoomCardScene")

local s
local root_ly
local alter_ly
local content_sv
local content_ly

function BuyRoomCardScene:showScene(isShowAgent)

    isShowAgent = isShowAgent or false

	if SCENENOW["scene"] then
		
		--释放之前的
        s = SCENENOW["scene"]:getChildByName("BuyRoomCardScene")
        if s then
            s:removeSelf()
        end

        --添加新场景
        if device.platform == "ios" then
            if isiOSVerify then
                s = cc.CSLoader:createNode("hall/BuyRoomCard/BuyRoomCardScene.csb")
            else
                s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/BuyRoomCard/BuyRoomCardScene.csb")
            end
        else
            s = cc.CSLoader:createNode("hall/BuyRoomCard/BuyRoomCardScene.csb")
        end
        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end
        s:setName("BuyRoomCardScene")

        if isShowAgent then
        
        else

            SCENENOW["scene"]:addChild(s)

        end

        --初始化控件
        root_ly = s:getChildByName("root_ly")

        local Panel_2 = root_ly:getChildByName("Panel_2")
        Panel_2:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then

                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    self:removeScene()
                end

            end
        )

        alter_ly = root_ly:getChildByName("alter_ly")

        content_sv = alter_ly:getChildByName("content_sv")

        content_ly = content_sv:getChildByName("content_ly")

        --查询房卡信息
        self:queryGoods()

	end

end

function BuyRoomCardScene:queryGoods()

    local table = {}
    table["type"] = "0"
    table["device"] = "1"
    table["userId"] = USER_INFO["uid"]
    table["interfaceType"] = "J"

	cct.createHttRq({
        url = HttpAddr .. "/goods/queryGoodsList",
        date = table,
        type_= "GET",
        callBack = function(data)

            local responseData = data.netData
            if responseData then
                responseData = json.decode(responseData)
                local cacheData = responseData.data
                if cacheData then
                	dump(cacheData, "-----房卡商品列表-----")

                    local isBindAgent = cacheData.isBindAgent
                    if isBindAgent == 0 then
                        
                        local bindAgentSendCard = cacheData.bindAgentSendCard
                        if not bindAgentSendCard then
                            bindAgentSendCard = 0
                        end

                        require("hall.BuyRoomCard.AgentScene"):showScene(bindAgentSendCard)

                    end

                    local list = cacheData.list
                    if list then
                        if #list > 0 then

                            for k,v in pairs(list) do

                                local buycardLayer
                                if device.platform == "ios" then
                                    if isiOSVerify then
                                        buycardLayer = cc.CSLoader:createNode("hall/BuyRoomCard/buycardLayer_lequ.csb")
                                    else
                                        buycardLayer = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/BuyRoomCard/buycardLayer_lequ.csb")
                                    end
                                else
                                    buycardLayer = cc.CSLoader:createNode("hall/BuyRoomCard/buycardLayer_lequ.csb")
                                end
                                -- buycardLayer:setTouchEnabled(false)
                                buycardLayer:setPosition(224 * (k - 1) + 5, -294)
                                if content_ly ~= nil then
                                    content_ly:addChild(buycardLayer)
                                end

                                local cell_content_ly = buycardLayer:getChildByName("content_ly")
                                cell_content_ly:setTouchEnabled(false)

                                --商品名
                                local goodName_tt = cell_content_ly:getChildByName("goodName_tt")
                                if v.name then
                                    goodName_tt:setString("  " .. tostring(v.name))
                                end

                                --折扣
                                local discount_ly = cell_content_ly:getChildByName("discount_ly")
                                local discount_tt = discount_ly:getChildByName("discount_tt")
                                if v.remark ~= nil and v.remark ~= "" and tonumber(v.remark) > 0 then
                                    discount_ly:setVisible(true)
                                    discount_tt:setString(v.remark)
                                else
                                    discount_ly:setVisible(false)
                                end

                                local good_iv = cell_content_ly:getChildByName("good_iv")
                                good_iv:setTouchEnabled(true)
                                if v.amount then
                                    local amount = tonumber(v.amount)
                                    if amount > 0 and amount < 10 then
                                        good_iv:loadTexture("hall/image/hall/buyroomcard/buy_fangka_small.png")
                                    elseif amount > 9 and amount < 20 then
                                        good_iv:loadTexture("hall/image/hall/buyroomcard/buy_fangka_middle.png")
                                    else
                                        good_iv:loadTexture("hall/image/hall/buyroomcard/buy_fangka_big.png")
                                    end
                                end

                                good_iv:addTouchEventListener(
                                    function(sender,event)

                                        --触摸结束
                                        if event == TOUCH_EVENT_ENDED then

                                            require("hall.BuyRoomCard.PayChannelScene"):showScene(USER_INFO["uid"], v.goodsId, v.amount)

                                        end

                                    end
                                )

                                local buy_ly = cell_content_ly:getChildByName("buy_ly")
                                buy_ly:setTouchEnabled(false)
                                local goodPrice_tt = buy_ly:getChildByName("goodPrice_tt")
                                if v.price then
                                    local price = v.price * 0.01
                                    goodPrice_tt:setString(tostring(price))
                                end

                                -- good_iv:addTouchEventListener(
                                --     function(sender,event)

                                --         if event == TOUCH_EVENT_BEGAN then
                                --             sender:setScale(0.9)
                                --         end

                                --         --触摸取消
                                --         if event == TOUCH_EVENT_CANCELED then
                                --             sender:setScale(1.0)
                                --         end

                                --         --触摸结束
                                --         if event == TOUCH_EVENT_ENDED then
                                --             sender:setScale(1.0)

                                --             -- self:BuyCard(USER_INFO["uid"], v.goodsId, v.amount)

                                --             require("hall.BuyRoomCard.PayChannelScene"):showScene(USER_INFO["uid"], v.goodsId, v.amount)

                                --         end

                                --     end
                                -- )

                            end

                            --设置滚动
                            content_sv:setCascadeOpacityEnabled(true)
                            content_sv:setInnerContainerSize(cc.size(224 * #list + 5, 294))
                            -- if count > 2 then
                            --     content_sv:setPosition(0, 30 * count)
                            -- end

                        end
                    end
                    
                end
            end
        end
    })

end

--购买房卡(易宝)
function BuyRoomCardScene:BuyCard(userId,goodsId,amount)

    dump(userId, "-----购买房卡userId-----")
    dump(goodsId, "-----购买房卡goodsId-----")
    dump(amount, "-----购买房卡amount-----")

    if not userId then
        require(CommonTips_filePath):showTips("提示", "", 3, "账号异常，请重新登录再试")
        return
    end

    if not goodsId then
        require(CommonTips_filePath):showTips("提示", "", 3, "商品异常，请稍后再试")
        return
    end

    if not amount then
        require(CommonTips_filePath):showTips("提示", "", 3, "商品异常，请稍后再试")
        return
    end

    local table = {}
    table["userId"] = userId
    table["goodsId"] = goodsId
    table["amount"] = "1"
    table["interfaceType"] = "J"

    cct.createHttRq({
        url = HttpAddr .. "/yeepay/payOrder",
        date = table,
        type_= "GET",
        requestMsg = "正在创建订单",
        callBack = function(data)

            local responseData = data.netData
            if responseData then
                responseData = json.decode(responseData)
                local cacheData = responseData.data
                if cacheData then
                    dump(cacheData, "-----订单信息-----")

                    local payUrl = cacheData.payUrl
                    if payUrl then
                        --把支付链接传给webview
                        require("hall.view.webView.webView"):showView(payUrl,"buyCard")
                    end
                    
                end
            end
        end
    })

end

function BuyRoomCardScene:removeScene()

	if SCENENOW["scene"] then
		
		--释放之前的
        local s = SCENENOW["scene"]:getChildByName("BuyRoomCardScene")
        if s then
            s:removeSelf()
        end

	end
	
end

return BuyRoomCardScene