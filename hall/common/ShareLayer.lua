local ShareLayer = class("ShareLayer")
--@zc 所有游戏的分享链接都在这里加载
 --require("hall.data.Config")
 local url_ = "https://fir.im/lezaiqizhong?"
function ShareLayer:showShareLayerInHall(title, url, imagePath, desc)
    url=url_
    local title_arr = LuaSplit(title, "，")
    local gameName = title_arr[1]
    local newName = title

    if device.platform == "ios" then
        -- imagePath = device.writablePath .. "hall/images/shareicon.png"
        if isiOSVerify then
            imagePath = iOSShareIcon_filePath
        else
            imagePath = cc.FileUtils:getInstance():getWritablePath() .. iOSShareIcon_filePath
        end
        
        dump(imagePath, "-----分享-----")
    end

    dump(newName, "-----分享-----")

    local scene = cc.CSLoader:createNode(ShareCsb_filePath):addTo(SCENENOW["scene"])
    scene:setName("shareLayer")
   -- require("hall.GameCommon"):commomButtonAnimation(scene)
    scene:setLocalZOrder(9999)

    if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
        scene:setScale(0.75)
    end

    local floor = scene:getChildByName("floor")
    local wx_bt = floor:getChildByName("wx_bt")
    local pyq_bt = floor:getChildByName("pyq_bt")

    floor.noScale=true
    floor:onClick(function()
        scene:removeFromParent()
    end)
        
    local function touchEvent(sender, event)
        if event == TOUCH_EVENT_CANCELED then
            sender:setScale(1.0)
        end

        if event == TOUCH_EVENT_ENDED then
            sender:setScale(1.0)
            require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")

            if sender == wx_bt then
                print("share wx")
                local args = {}
                args["channel"] = "wx"
                args["title"] = newName
                if url ~= nil then
                    --todo
                    -- args["url"] = url

                    args["url"] = url

                end
        
                if imagePath ~= nil then
                    --todo
                    args["imagePath"] = imagePath
                end
                args["desc"] = desc

                if device.platform=="android" then
                    local share_content = {}
                    table.insert(share_content,"wx")
                    table.insert(share_content,newName)
                    if url ~= nil then
                        table.insert(share_content,url)
                    else
                        table.insert(share_content,"")
                    end
                    if imagePath ~= nil then
                        table.insert(share_content,imagePath)
                    else
                        table.insert(share_content,"")
                    end
                    table.insert(share_content,desc)
                    cct.getDateForApp("share", share_content, "V")
                else
                    cct.getDateForApp("share", args, "V")
                end

                scene:removeFromParent()
                

            elseif sender == pyq_bt then
                print("share pyq")
                local args = {}
                args["channel"] = "pyq"
                args["title"] = newName
                if url ~= nil then
                    args["url"] = url
                end
                
                if imagePath ~= nil then
                    --todo
                    args["imagePath"] = imagePath
                end
                args["desc"] = desc

                if device.platform=="android" then
                    local share_content = {}
                    table.insert(share_content,"pyq")
                    table.insert(share_content,newName)
                    if url ~= nil then
                        table.insert(share_content,url)
                    else
                        table.insert(share_content,"")
                    end
                    if imagePath ~= nil then
                        table.insert(share_content,imagePath)
                    else
                        table.insert(share_content,"")
                    end
                    table.insert(share_content,desc)
                    cct.getDateForApp("share", share_content, "V")
                else
                    cct.getDateForApp("share", args, "V")
                end

                scene:removeFromParent()

            end
        end
    end

    wx_bt:addTouchEventListener(touchEvent)
    pyq_bt:addTouchEventListener(touchEvent)

end

function ShareLayer:showShareLayer(title, url, imagePath, desc)
    url=url_
    local title_arr = LuaSplit(title, "，")
    local gameName = title_arr[1]
    local newName = title

    if device.platform == "ios" then
        -- imagePath = device.writablePath .. "hall/images/shareicon.png"
        if isiOSVerify then
            imagePath = iOSShareIcon_filePath
        else
            imagePath = cc.FileUtils:getInstance():getWritablePath() .. iOSShareIcon_filePath
        end
        
        dump(imagePath, "-----分享-----")
    end

    dump(newName, "-----分享-----")

    local scene = cc.CSLoader:createNode(ShareCsb_filePath):addTo(SCENENOW["scene"])
    scene:setName("shareLayer")
    scene:setLocalZOrder(9999)
    if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
        scene:setScale(0.75)
    end

    local floor = scene:getChildByName("floor")
    local wx_bt = floor:getChildByName("wx_bt")
    local pyq_bt = floor:getChildByName("pyq_bt")

    floor.noScale=true
    floor:onClick(function()
        scene:removeFromParent()
    end)
        
    local function touchEvent(sender, event)
        if event == TOUCH_EVENT_CANCELED then
            sender:setScale(1.0)
        end

        if event == TOUCH_EVENT_ENDED then
            sender:setScale(1.0)
            require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")

            if sender == wx_bt then
                print("share wx")
                local args = {}
                args["channel"] = "wx"
                args["title"] = newName

                if url ~= nil then
                    args["url"] = url.. USER_INFO["invote_code"] .. "&activityId=" .. USER_INFO["activity_id"] .. "&level=" .. USER_INFO["GroupLevel"]
                end

                if imagePath ~= nil then
                    --todo
                    args["imagePath"] = imagePath
                end
                args["desc"] = desc

                if device.platform=="android" then
                    local share_content = {}
                    table.insert(share_content,"wx")
                    table.insert(share_content,newName)
                    if url ~= nil then
                        table.insert(share_content, url .. USER_INFO["invote_code"] .. "&activityId=" .. USER_INFO["activity_id"] .. "&level=" .. USER_INFO["GroupLevel"])
                    else
                        table.insert(share_content,"")
                    end
                    if imagePath ~= nil then
                        table.insert(share_content,imagePath)
                    else
                        table.insert(share_content,"")
                    end
                    table.insert(share_content,desc)
                    cct.getDateForApp("share", share_content, "V")
                else
                    cct.getDateForApp("share", args, "V")
                end

                scene:removeFromParent()
                

            elseif sender == pyq_bt then
                print("share pyq")
                local args = {}
                args["channel"] = "pyq"
                args["title"] = newName

                if url ~= nil then
                    args["url"] = url .. USER_INFO["invote_code"] .. "&activityId=" .. USER_INFO["activity_id"] .. "&level=" .. USER_INFO["GroupLevel"]
                end
                
                if imagePath ~= nil then
                    --todo
                    args["imagePath"] = imagePath
                end

                args["desc"] = desc

                if device.platform=="android" then
                    local share_content = {}
                    table.insert(share_content,"pyq")
                    table.insert(share_content,newName)

                    if url ~= nil then
                        table.insert(share_content, url .. USER_INFO["invote_code"] .. "&activityId=" .. USER_INFO["activity_id"] .. "&level=" .. USER_INFO["GroupLevel"])
                    else
                        table.insert(share_content,"")
                    end

                    if imagePath ~= nil then
                        table.insert(share_content,imagePath)
                    else
                        table.insert(share_content,"")
                    end

                    table.insert(share_content,desc)

                    cct.getDateForApp("share", share_content, "V")

                else
                    cct.getDateForApp("share", args, "V")
                end

                scene:removeFromParent()

            end
        end
    end

    wx_bt:addTouchEventListener(touchEvent)
    pyq_bt:addTouchEventListener(touchEvent)
    
end

function ShareLayer:shareGroupResultForIOS()

    local scene = cc.CSLoader:createNode(ShareCsb_filePath):addTo(SCENENOW["scene"])
    scene:setName("shareLayer")
    scene:setLocalZOrder(9999)
    if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
        scene:setScale(0.75)
    end

    local floor = scene:getChildByName("floor")
    local wx_bt = floor:getChildByName("wx_bt")
    local pyq_bt = floor:getChildByName("pyq_bt")

    floor.noScale=true
    floor:onClick(function()
        scene:removeFromParent()
    end)
        
    local function touchEvent(sender, event)
        if event == TOUCH_EVENT_CANCELED then
            sender:setScale(1.0)
        end

        if event == TOUCH_EVENT_ENDED then
            sender:setScale(1.0)
            require("hall.GameCommon"):playEffectSound("hall/Audio_Button_Click.mp3")

            if sender == wx_bt then
                print("share wx")
                local args = {}
                args["channel"] = "wx"
                args["title"] = "我的战果"
                if url ~= nil then
                    --todo
                    args["url"] = url
                end
        
                args["desc"] = "快来一起玩吧"

                print("luaCall 截屏",png_name)
                local function afterCaptured(succeed,sp_png)
                    if succeed then
                        print("截屏success",sp_png)
                        args["imagePath"] = sp_png
                        cct.getDateForApp("shareGroupResult", args, "V")
                    end
                end
                cc.utils:captureScreen(afterCaptured,"gameScreen.png")

                scene:removeFromParent()
                

            elseif sender == pyq_bt then
                print("share pyq")
                local args = {}
                args["channel"] = "pyq"
                args["title"] = "我的战果"
                if url ~= nil then
                    --todo
                    args["url"] = url
                end
        
                args["desc"] = "快来一起玩吧"

                print("luaCall 截屏",png_name)
                local function afterCaptured(succeed,sp_png)
                    if succeed then
                        print("截屏success",sp_png)
                        args["imagePath"] = sp_png
                        cct.getDateForApp("shareGroupResult", args, "V")
                    end
                end
                cc.utils:captureScreen(afterCaptured,"gameScreen.png")

                scene:removeFromParent()
            end
        end
    end

    wx_bt:addTouchEventListener(touchEvent)
    pyq_bt:addTouchEventListener(touchEvent)

    
end

function hideShareLayer()
    singleton:removeFromParent()
end

--按照传入的分隔符，切割字符串
function LuaSplit(str, split_char)  
    if str == "" or str == nil then   
        return {};  
    end  
    local split_len = string.len(split_char)  
    local sub_str_tab = {};  
    local i = 0;  
    local j = 0;  
    while true do  
        j = string.find(str, split_char,i+split_len);--从目标串str第i+split_len个字符开始搜索指定串  
        if string.len(str) == i then   
            break;  
        end  
  
  
        if j == nil then  
            table.insert(sub_str_tab,string.sub(str,i));  
            break;  
        end;  
  
  
        table.insert(sub_str_tab,string.sub(str,i,j-1));  
        i = j+split_len;  
    end  
    return sub_str_tab;  
end
    
return ShareLayer