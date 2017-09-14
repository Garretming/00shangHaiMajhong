

local PayChannelScene = class("PayChannelScene")

function PayChannelScene:showScene(userId,goodsId,amount)

	if SCENENOW["scene"] then
		
		--释放之前的
        local s = SCENENOW["scene"]:getChildByName("PayChannelScene")
        if s then
            s:removeSelf()
        end

        --添加新场景
        if device.platform == "ios" then
	        if isiOSVerify then
	            s = cc.CSLoader:createNode("hall/BuyRoomCard/PayChannelScene.csb")
	        else
	            s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/BuyRoomCard/PayChannelScene.csb")
	        end
	    else
	        s = cc.CSLoader:createNode("hall/BuyRoomCard/PayChannelScene.csb")
	    end
        s:setName("PayChannelScene")
        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end
        SCENENOW["scene"]:addChild(s)

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
                    self:removeScene()
                end

            end
        )

        --银联支付
        local up_ly = s:getChildByName("up_ly")
        up_ly:addTouchEventListener(
            function(sender,event)

            	--触摸开始
                if event == TOUCH_EVENT_BEGAN then
					sender:setScale(0.9)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
					sender:setScale(1.0)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)

                    self:payWithPing(userId, goodsId, amount, "U")

                end

            end
        )

        --微信支付
        local wx_ly = s:getChildByName("wx_ly")
        wx_ly:addTouchEventListener(
            function(sender,event)

            	--触摸开始
                if event == TOUCH_EVENT_BEGAN then
					sender:setScale(0.9)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
					sender:setScale(1.0)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)

                    self:payWithPing(userId, goodsId, amount, "W")

                end

            end
        )

        --支付宝支付
        local alipay_ly = s:getChildByName("alipay_ly")
        alipay_ly:addTouchEventListener(
            function(sender,event)

                --触摸开始
                if event == TOUCH_EVENT_BEGAN then
					sender:setScale(0.9)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
					sender:setScale(1.0)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:setScale(1.0)

                    self:payWithPing(userId, goodsId, amount, "P")

                end

            end
        )
    
    end

end

--ping++生成订单请求
function PayChannelScene:payWithPing(userId,goodsId,amount,payType)

	dump(userId, "-----购买房卡userId-----")
    dump(goodsId, "-----购买房卡goodsId-----")
    dump("1", "-----购买该房卡商品数量amount-----")
    dump(payType, "-----购买房卡payType-----")

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

    if not payType then
        require(CommonTips_filePath):showTips("提示", "", 3, "支付渠道异常，请稍后再试")
        return
    end

    local table = {}
    table["userId"] = userId
    table["goodsId"] = goodsId
    table["amount"] = "1"
    table["payType"] = payType
    table["interfaceType"] = "J"

    cct.createHttRq({
        url = HttpAddr .. "/pingpp/payOrder",
        date = table,
        type_= "GET",
        requestMsg = "正在创建订单",
        callBack = function(data)

            dump(data, "-----订单信息-----")

            local responseData = data.netData
            if responseData then
                responseData = json.decode(responseData)
                local returnCode = responseData.returnCode
                if returnCode == "0" then
                	local cacheData = responseData.data
	                if cacheData then
	                    dump(cacheData, "-----订单信息-----")

                        local payData = json.encode(cacheData)

                        local arr
	                    if device.platform == "ios" then
                            arr = {}
                            arr["data"] = payData
	                    	cct.getDateForApp("payWithPing", arr, "V")
	                    else
                            arr = {payData}
	                    	cct.getDateForApp("payWithPing", arr, "V")

                            require(NetworkLoadingView_filePath):showLoading("正在支付订单")
                            
	                    end

                        dump(arr, "-----支付信息-----")

	                else
		            	require(CommonTips_filePath):showTips("提示", "", 3, "订单信息异常，请稍后再试")
	                end
	            else
	            	require(CommonTips_filePath):showTips("提示", "", 3, "生成订单失败，请稍后再试")
                end
            end

        end
    })

end

--购买房卡成功
function PayChannelScene:payRoomCardSuccess()

    require("hall.GameTips"):showTips("购买房卡", "", 3, "购买成功")

    --更新用户房卡数量
    require(GameScene_filePath):queryRoomCardCount()

end

--购买房卡失败
function PayChannelScene:payRoomCardFail()

    require("hall.GameTips"):showTips("购买房卡", "", 3, "购买失败")

    --更新用户房卡数量
    require(GameScene_filePath):queryRoomCardCount()

end

--购买房卡取消
function PayChannelScene:payRoomCardCancel()

    require("hall.GameTips"):showTips("购买房卡", "", 3, "购买取消")

    --更新用户房卡数量
    require(GameScene_filePath):queryRoomCardCount()

end

--购买房卡支付控件失效
function PayChannelScene:payRoomCardInvalid()

    require("hall.GameTips"):showTips("购买房卡", "", 3, "支付控件不存在")

    --更新用户房卡数量
    require(GameScene_filePath):queryRoomCardCount()

end

function PayChannelScene:removeScene()

	if SCENENOW["scene"] then
		
		--释放之前的
        local s = SCENENOW["scene"]:getChildByName("PayChannelScene")
        if s then
            s:removeSelf()
        end

	end

end

return PayChannelScene