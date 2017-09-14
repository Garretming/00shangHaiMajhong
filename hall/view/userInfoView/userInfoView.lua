
local userInfoView = class("userInfoView")

local userInfo_arr = {}

function userInfoView:showView(url, userInfo)

	if userInfo == nil then
		return
	end

    if userInfo_arr[userInfo["uid"]] == nil then
        userInfo_arr[userInfo["uid"]] = userInfo
    end

    userInfo = userInfo_arr[userInfo["uid"]]
    --dump(userInfo, "-----showView-----")

	if SCENENOW["scene"] then

		local s = SCENENOW["scene"]:getChildByName("userInfoView")
	    if s then
	        s:removeSelf()
	    end

	    if bm.isInGame then
            if device.platform == "ios" then
                if isiOSVerify then
                    s = cc.CSLoader:createNode("hall/view/userInfoView/userInfoView_game_Layer_168.csb")
                else
                    s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/view/userInfoView/userInfoView_game_Layer_168.csb")
                end
            else
                s = cc.CSLoader:createNode("hall/view/userInfoView/userInfoView_game_Layer_168.csb")
            end

            s:setZOrder(999)
	    else
            if device.platform == "ios" then
                if isiOSVerify then
                    s = cc.CSLoader:createNode("hall/view/userInfoView/userInfoView_nomal_Layer_168.csb")
                else
                    s = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/view/userInfoView/userInfoView_nomal_Layer_168.csb")
                end
            else
                s = cc.CSLoader:createNode("hall/view/userInfoView/userInfoView_nomal_Layer_168.csb")
            end
	    end

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

    	s:setName("userInfoView")
    	SCENENOW["scene"]:addChild(s)

    	local bg_ly = s:getChildByName("Panel_1")
    	bg_ly:setTouchEnabled(true)
    	bg_ly:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                	
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    self:removeView()
                end

            end
        )

    	local root_ly = s:getChildByName("root_ly")
    	root_ly:setTouchEnabled(true)
    	root_ly:addTouchEventListener(
            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                	
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then

                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    self:removeView()
                end

            end
        )

        local head_ly = root_ly:getChildByName("head_ly")
        require("hall.view.headView.headView"):addView(head_ly, 80, -76, 80, 80, url)

        local name_tt = root_ly:getChildByName("name_tt")
        if userInfo["nickName"] then
        	name_tt:setString(userInfo["nickName"])
        end

        local id_tt = root_ly:getChildByName("id_tt")
        if userInfo["uid"] then
        	id_tt:setString("ID:" .. userInfo["uid"])
        end

        local ip_tt = root_ly:getChildByName("ip_tt")
        if ip_tt ~= nil then
            if userInfo["ip"] then
                ip_tt:setString("IP:" .. userInfo["ip"])
            else
                ip_tt:setString("")
            end
        end

        --在游戏中显示
        if bm.isInGame then

            local distance_sv = root_ly:getChildByName("distance_sv")

            if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then

                distance_sv:setPosition(distance_sv:getPosition().x, distance_sv:getPosition().y - 10)
                distance_sv:setContentSize(330.00, 85)

                --添加互动表情
                require("hall.view.animView.animView"):addView(root_ly, 60, 180,userInfo["uid"])

                local Image_15 = root_ly:getChildByName("Image_15")
                Image_15:setScaleY(0.5)
                Image_15:setPosition(Image_15:getPosition().x, Image_15:getPosition().y + 50)

            end

            local content_ly = distance_sv:getChildByName("content_ly")

            --获取房间中的玩家地理位置
            local location_arr = {}
            for k,v in pairs(userInfo_arr) do
                if v.invote_code == USER_INFO["invote_code"] then
                    table.insert(location_arr, v)
                end
            end
            -- --dump(location_arr, "-----用户信息控件-----")

            if #location_arr > 0 then

                dump(location_arr, "-----用户信息控件-----")
                
                local count = 0
                local isCompare_arr = {}
                for k,v in pairs(location_arr) do
                        
                    --获取当前用户的id
                    local uid = v["uid"]
                    table.insert(isCompare_arr, uid)

                    if uid ~= USER_INFO["uid"] then
                    

                    --获取当前用户的经纬度
                    local latitude = v["latitude"]
                    if latitude == nil then
                        latitude = ""
                    end
                    if latitude == "" then
                        latitude = "0"
                    end
                    latitude = tonumber(latitude)

                    local longitude = v["longitude"]
                    if longitude == nil then
                        longitude = ""
                    end
                    if longitude == "" then
                        longitude = "0"
                    end
                    longitude = tonumber(longitude)

                    local nickName

                    if uid == USER_INFO["uid"] then
                        nickName = "我"
                    else
                        nickName = require("hall.GameCommon"):formatNickToLaction(v["nickName"])

                    end

                    if latitude ~= 0 and longitude ~= 0 then

                        --dump("用户有经纬度信息", "----------")

                        for a,b in pairs(location_arr) do

                            local b_uid = b["uid"]

                            local b_latitude = b["latitude"]
                            if b_latitude == nil then
                                b_latitude = ""
                            end
                            if b_latitude == "" then
                                b_latitude = "0"
                            end
                            b_latitude = tonumber(b_latitude)

                            local b_longitude = b["longitude"]
                            if b_longitude == nil then
                                b_longitude = ""
                            end
                            if b_longitude == "" then
                                b_longitude = "0"
                            end
                            b_longitude = tonumber(b_longitude)

                            local b_nickName
                            if b_uid == USER_INFO["uid"] then
                                b_nickName = "我"
                            else
                                b_nickName = require("hall.GameCommon"):formatNickToLaction(b["nickName"])
                            end

                            --判断当前用户之前是否已经比较
                            local isCompare = 0
                            for q,w in pairs(isCompare_arr) do
                                if w == b_uid then
                                    isCompare = 1
                                end
                            end

                            --当前用户未进行比较
                            if isCompare == 0 then

                                if b_uid ~= USER_INFO["uid"] then

                                    --dump(b_uid, "-----b_uid  1-----")

                                    local distanceLayer
                                    if device.platform == "ios" then
                                        distanceLayer = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/view/userInfoView/distanceLayer.csb")
                                    else
                                        distanceLayer = cc.CSLoader:createNode("hall/view/userInfoView/distanceLayer.csb")
                                    end
                                    distanceLayer:setScale(0.9)

                                    if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then
                                        distanceLayer:setPosition(10, 40 * count * -1 - 90)
                                    else
                                        distanceLayer:setPosition(10, 40 * count * -1 - 20)
                                    end

                                    -- distanceLayer:setPosition(10, 40 * count * -1 - 20)

                                    local root_ly = distanceLayer:getChildByName("root_ly")
                                    local distance_tt = root_ly:getChildByName("distance_tt")

                                    if b_latitude ~= 0 and b_longitude ~= 0 then
                                        local s = require("hall.util.LocationUtil"):getDistance(latitude, longitude, b_latitude, b_longitude)
                                        if s >= 0 then

                                            content_ly:addChild(distanceLayer)
                                            count = count + 1

                                            if s < 1000 then
                                                distance_tt:setString(nickName .. "与" .. b_nickName .. "相距" .. tostring(s) .. "米")
                                            else
                                                s = s / 1000
                                                s = math.floor(s)
                                                distance_tt:setString(nickName .. "与" .. b_nickName .. "相距" .. tostring(s) .. "千米")
                                            end
                                            
                                        end
                                    end

                                else

                                    --dump(b_uid, "-----b_uid  2-----")

                                end

                            else

                                --dump("当前用户已比较", "-----isCompare_arr-----")

                            end

                        end

                    else

                        --dump("用户无经纬度信息", "----------")

                        local distanceLayer
                        if device.platform == "ios" then
                            distanceLayer = cc.CSLoader:createNode(cc.FileUtils:getInstance():getWritablePath() .. "hall/view/userInfoView/distanceLayer.csb")
                        else
                            distanceLayer = cc.CSLoader:createNode("hall/view/userInfoView/distanceLayer.csb")
                        end
                        distanceLayer:setScale(0.9)
                        content_ly:addChild(distanceLayer)

                        if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then
                            distanceLayer:setPosition(10, 60 * count * -1 - 80)
                        else
                            distanceLayer:setPosition(10, 60 * count * -1 - 20)
                        end

                        -- distanceLayer:setPosition(10, 60 * count * -1 - 20)

                        count = count + 1

                        local root_ly = distanceLayer:getChildByName("root_ly")
                        local distance_tt = root_ly:getChildByName("distance_tt")
                        distance_tt:setString(nickName .. "位置未知")

                    end


                    end
                    
                end

                distance_sv:setCascadeOpacityEnabled(true)
                if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then
                    if count < 2 then
                        distance_sv:setInnerContainerSize(cc.size(283, 30 * count))
                    else
                        distance_sv:setInnerContainerSize(cc.size(283, 30 * count + 50))
                    end
                else
                    distance_sv:setInnerContainerSize(cc.size(283, 30 * count))
                end

                if count > 2 then
                    if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then
                        content_ly:setPosition(0, 60 * count + 45)
                    else
                        content_ly:setPosition(0, 60 * count)
                    end
                else
                    if isShowAnimView and userInfo["uid"] ~= USER_INFO["uid"] then
                        content_ly:setPosition(0, 60 * count + 110)
                    end
                end

            end

        end

        -- --dump(require("hall.util.LocationUtil"):getDistance(29.490295, 106.486654, 29.615467, 106.581515), "-----经纬度计算-----")
		
	end

end

function userInfoView:upDateUserInfo(uid, info)

    userInfo_arr[uid] = info

    --dump(userInfo_arr, "-----userInfoView 当前缓存的用户数据-----")

end

function userInfoView:removeView()

	local s = SCENENOW["scene"]:getChildByName("userInfoView")
    if s then
        s:removeSelf()
    end

end

return userInfoView