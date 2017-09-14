
local groupJoin = class("groupJoin")

function groupJoin:showScene()

	-- -- 获取组局创建配置数据
 --    if bm.groupGameConfig == nil then
 --        return
 --    end
    
 --    -- local xzConfig = bm.groupGameConfig[1]
 --    local xzConfig
 --    if #bm.groupGameConfig > 0 then
 --        for k,v in pairs(bm.groupGameConfig) do
 --            --获取选中的游戏的组局配置
 --            if USER_INFO["enter_mode"] == v.gameId then
 --                xzConfig = v
 --                break
 --            end
 --        end
 --    end
    
 --    if xzConfig == nil then
 --        return
 --    end

 --    --记录当前游戏对应的等级
 --    local level = xzConfig.level

    local level = 0

    self:removeScene()

    local layerEnter
    if layerEnter == nil then
        layerEnter = cc.CSLoader:createNode(JoinGroupCsb_filePath):addTo(SCENENOW["scene"])
--        require("hall.GameCommon"):commomButtonAnimation(layerEnter)
        layerEnter:setName("enter_room")
    end

    local tbNumber = {}
    local numPos = 0
    local str = 1
    local function reFresh()
        dump(tbNumber, "tbNumber")
        for i = 1,6 do
            str = "num_box_"..tostring(i)
            local txt = layerEnter:getChildByName(str):getChildByName("Text_1")
            if tbNumber[i] then
                txt:setString(tostring(tbNumber[i]))
            else
                txt:setString("")
            end
        end
    end
    reFresh()

    local Panel_1 = layerEnter:getChildByName("Panel_1")
    Panel_1:addTouchEventListener(
        function(sender,event)

            --触摸结束
            if event == TOUCH_EVENT_ENDED then

                self:removeScene()

            end

        end
    )

    --按钮
    local tbBtnNumbers = {}
    for i = 1,10 do
        if i < 10 then
            str = "btn_"..tostring(i)
        else
            str = "btn_0"
        end
        tbBtnNumbers[i] = layerEnter:getChildByName(str)
    end

    local btn_submit = layerEnter:getChildByName("btn_submit")
    local btn_del = layerEnter:getChildByName("btn_del")
    local btn_exit = layerEnter:getChildByName("btn_exit")

    -- --设置确定按钮状态
    -- local function setSubmit(flag)
    --     if btn_submit then
    --         btn_submit:setEnabled(flag)
    --         if flag == false then
    --             btn_submit:loadTextureNormal("hall/common/small_disable_bt_n.png")
    --             -- btn_submit:setColor(cc.c3b(125,125,125))
    --         else
    --             btn_submit:loadTextureNormal("hall/common/setting_yellow_bt.png")
    --             -- btn_submit:setColor(cc.c3b(255,255,255))
    --         end
    --     end
    -- end
    -- setSubmit(false)

    --按钮事件
    local function touchButtonEvent(sender, event)
        if event == TOUCH_EVENT_ENDED then
            if #tbNumber < 6 then
                --@zc 测试添加按鈕點声音
                cc.SimpleAudioEngine:getInstance():playEffect("hall/Audio_Button_Click.mp3", false)
                for i=1,10 do
                    if sender == tbBtnNumbers[i] then
                        numPos = numPos + 1
                        tbNumber[numPos] = i
                        if tbNumber[numPos] >= 10 then
                            tbNumber[numPos] = 0
                        end
                        reFresh()
                        if #tbNumber == 6 then
                            --setSubmit(true)
                            local strCode = ""
                            for i = 1, 6 do
                                strCode = strCode..tostring(tbNumber[i])
                            end
                            print("inviteCode:",strCode)
                            require("hall.groudgamemanager"):join_freegame(USER_INFO["uid"], strCode, "", false, level, false)
                        end
                    end
                end
            end

            --重输
            if sender == btn_submit then

                tbNumber = {}
                numPos = 0
                reFresh()

            end

            --删除
            if sender == btn_del then
                if numPos > 0 then
                    table.remove(tbNumber,numPos)
                    numPos = numPos - 1
                    reFresh()
                    -- setSubmit(false)
                end
            end

            if sender == btn_exit then
                self:removeScene()
            end

        end
    end

    --按钮注册
    for i = 1,10 do
        if tbBtnNumbers[i] then
            tbBtnNumbers[i]:addTouchEventListener(touchButtonEvent)
        end
    end

    --重输，删除
    btn_submit:addTouchEventListener(touchButtonEvent)
    btn_del:addTouchEventListener(touchButtonEvent)
    btn_exit:addTouchEventListener(touchButtonEvent)

end

function groupJoin:removeScene()

	local s = SCENENOW["scene"]:getChildByName("enter_room")
    if s then
        s:removeSelf()
    end
	
end

return groupJoin