

local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local GameTips  = class("GameTips")

--title  提示文字
--code   处理标识
--bShowButton  0:不显示按钮；1：全部显示；2：显示取消；3：显示确定: 4: 全部隐藏
--msg    显示详情
--data   处理数据

--提示
function GameTips:showTips(title,code,bShowButton,msg,data,sure_func)

    require(NetworkLoadingView_filePath):removeView()

    if code == "agree_disbandGroup" or code == "cs_disbandGroup" or code == "cs_request_disbandGroup" or code == "cs_disbandGroup_success" or code == "kwx_disbandGroup" or code == "kwx_request_disbandGroup"
        or code == "disbandGroup" or code == "request_disbandGroup" or code == "disbandGroup_success" or code == "disbandGroup_fail" or code == "kwx_liangdao_remaid" 
        or code == "szkwx_disbandGroup" or code == "szkwx_request_disbandGroup" 
        or code == "xgkwx_disbandGroup" or code == "xgkwx_request_disbandGroup" 
        or code == "xykwx_disbandGroup" or code == "xykwx_request_disbandGroup" 
         or code == "HBMJ_disbandGroup" or code == "HBMJ_request_disbandGroup"  --@zC添加河北麻将
         
        then
        
        self:showDisbandTips(title,code,bShowButton,msg,data)
        return

    end

    if bShowButton then
        print("show button state:"..tostring(bShowButton))
    end
    bShowButton = bShowButton or 0
    msg = msg or ""
    data = data or ""

    if SCENENOW["scene"] then

        --释放之前的
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
            s:removeSelf()
        end

        s = cc.CSLoader:createNode(CommonTipsCsb_filePath)
        s:setName("layer_tips")
--        require("hall.GameCommon"):commomButtonAnimation(s)
        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

        SCENENOW["scene"]:addChild(s,99998)

        local layer = s:getChildByName("tips_back_1")

        --显示标题
        local txt = layer:getChildByName("txt_msg")
        if txt then
            txt:setString(title)
        end

        --显示内容
        local msg_tt = layer:getChildByName("msg_tt")
        msg_tt:setString(msg)
        if code == "request_disbandGroup" or code == "cs_request_disbandGroup" or code == "agree_disbandGroup" then
            msg_tt:setTextHorizontalAlignment(0)
        end

        local btnSubmit = layer:getChildByName("btn_submit")
        local btnCancel = layer:getChildByName("btn_cancel")
        local btn_sure =  layer:getChildByName("btn_sure")

        if bShowButton == 0 then
            btn_sure:setVisible(true)
            btnCancel:setVisible(false)
            btnSubmit:setVisible(false)
        else
            btn_sure:setVisible(false)
        end

        if bShowButton == 1 then
            --显示取消与确定

        elseif bShowButton == 2 then--只显示取消按钮

            btnSubmit:setVisible(false)

            btnCancel:setVisible(true)
           -- btnCancel:setPosition(cc.p(400.00, 137.00))

        elseif bShowButton == 3 then--只显示确定按钮

            btnSubmit:setVisible(true)
            btnSubmit:setPosition(cc.p(400.00, 45))

            btnCancel:setVisible(false)

        elseif bShowButton == 4 then--全不显示

            btnSubmit:setVisible(false)
            btnCancel:setVisible(false)

        end

        local function touchEvent(sender, event)

            --触摸开始
            if event == TOUCH_EVENT_BEGAN then

            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then

            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then

                require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)

                --现在去（确定）
                if sender == btnSubmit then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if sure_func then
                        sure_func()
                    end



                    if code then
                        --比赛奖励报名
                        if code == "GameAwardPool" then
                            self:HandleGameAwardPool()
                        elseif code == "change_money" then
                            require("hall.GameCommon"):gRecharge()
                        elseif code == "change_money2chips" then --兑换筹码之前
                            SCENENOW["scene"]:callBackTips("change_money2chips", 1)
                            require("hall.GameCommon"):gRecharge()
                            -- require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "reloadBull" then
                            --退出大厅游戏
                            require("hall.GameCommon"):gExitGame()
                        elseif code == "loginGameFailed" then
                            if USER_INFO["enter_mode"] == 0 then
                                require("hall.GameUpdate"):enterGame(USER_INFO["current_code"])
                            else
                                require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            end
                        elseif code == "kick_off" then
                            --请请出游戏后的操作
                            
                            -- if USER_INFO["enter_mode"] == 0 then
                            --     require("hall.GameCommon"):gExitGame()
                            -- else
                            --     require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            -- end

                            --返回到登录页
                            require("hall.LoginScene"):show()


                        elseif code == "change_chip" then
                            require("hall.GameCommon"):showChange(true)
                        elseif code == "network_disconnect" then
                            -- if USER_INFO["enter_mode"] > 0 then
                            --     require("ddz.PlayVideo"):stopVideo()
                            -- end
                            local next = require("src.app.scenes.MainScene").new()
                            SCENENOW["scene"] = next
                            SCENENOW["name"] = "app.scenes.MainScene"
                            display.replaceScene(next)

                        elseif code == "GameupdateError" then
                            --更新游戏出错处理
                            -- require("hall.GameUpdate"):updateGame(data.url, data.version, data.gid, data.code)

                        elseif code == "tohall" then

                            --移除录音按钮
                            require("hall.VoiceRecord.VoiceRecordView"):removeView()

                            --设置不需要检查重连
                            bm.notCheckReload = 1

                            require("hall.VoiceRecord.VoiceRecordView"):removeView()

                            --通知本地退出房间
                            require("hall.util.GameUtil"):LogoutRoom()

                            --离开房间
                            display_scene(GameScene_filePath)
                            audio.stopMusic()
                            
                        elseif code == "cs_disbandGroup" then
                            --申请解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end
                        elseif code == "cs_request_disbandGroup" then
                            --同意解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end
                        elseif code == "disbandGroup" then
                            --申请解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "request_disbandGroup" then
                            --同意解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "disbandGroup_fail" then
                            --解散组局失败

                        elseif code == "reloadGame" then
                            --重连游戏
                            require("hall.groudgamemanager"):join_freegame(USER_INFO["uid"],data["inviteCode"],data["activityId"],true)

                        elseif code == "updateGame" then
                            --更新游戏，当更新游戏出错时用
                            require("hall.groudgamemanager"):updateGameInJoinGame(data["url"], data["version"], data["gid"], data["code"])

                        end

                    end
                end

                --下次吧（取消）
                if sender == btnCancel then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if code then
                        --比赛奖励报名
                        if code == "reloadBull" then
                            --退出大厅游戏
                            require("hall.GameCommon"):gExitGame()
                        elseif code == "loginGameFailed" then
                            if USER_INFO["enter_mode"] == 0 then
                                require("hall.GameUpdate"):enterGame(USER_INFO["current_code"])
                            else
                                require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            end
                        elseif code == "kick_off" then

                            --被请出游戏后的操作

                            -- if USER_INFO["enter_mode"] == 0 then
                            --     require("hall.GameCommon"):gExitGame()
                            -- else
                            --     require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            -- end

                            --返回到登录页
                            require("hall.LoginScene"):show()


                        elseif code == "change_chip" then--退出组局
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "change_money2chips" then--退出组局
                            SCENENOW["scene"]:callBackTips("change_money2chips", 0)
                            -- require("ddz.ddzServer"):CLI_LOGOUT_ROOM()
                            -- require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "error" then
                            --退出大厅游戏
                            if USER_INFO["enter_mode"] == 0 then
                                require("hall.GameCommon"):gExitGame()
                            else
                                require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            end
                        elseif code == "network_disconnect" then
                            --退出大厅游戏
                            if USER_INFO["enter_mode"] == 0 then
                                require("hall.GameCommon"):gExitGame()
                            else
                                require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            end
                        elseif code == "cs_disbandGroup" then
                            --申请退出组局

                        elseif code == "cs_request_disbandGroup" then
                            --拒绝解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end
                        elseif code == "disbandGroup" then
                            --申请退出组局

                        elseif code == "request_disbandGroup" then
                            --拒绝解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        elseif code == "disbandGroup_fail" then
                            --解散组局失败

                        elseif code == "reloadGame" then
                            --重连游戏
                            require("hall.groudgamemanager"):exitFreeGame(USER_INFO["uid"],data["inviteCode"])

                        elseif code == "updateGame" then
                            --更新游戏，当更新游戏出错时用
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            
                        end

                    end
                elseif  sender == btn_sure then
                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end
                end
            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)
        btn_sure:addTouchEventListener(touchEvent)

        local layEffect = s:getChildByName("Panel_1")
        if layEffect then
            layEffect:setTouchEnabled(true)
            layEffect:addTouchEventListener(function(sender,event)
                if event==2 then
                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end
                    --比赛奖励报名
                    if code == "reloadBull" then
                        --退出大厅游戏
                        require("hall.GameCommon"):gExitGame()
                    elseif code == "loginGameFailed" then
                        if USER_INFO["enter_mode"] == 0 then
                            require("hall.GameUpdate"):enterGame(USER_INFO["current_code"])
                        else
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        end
                    elseif code == "kick_off" then
                        --退出大厅游戏
                        if USER_INFO["enter_mode"] == 0 then
                            require("hall.GameCommon"):gExitGame()
                        else
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        end
                    elseif code == "change_chip" then--退出组局
                        require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                    elseif code == "change_money2chips" then--退出组局
                        require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                    elseif code == "error" then
                        --退出大厅游戏
                        if USER_INFO["enter_mode"] == 0 then
                            require("hall.GameCommon"):gExitGame()
                        else
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        end
                    elseif code == "network_disconnect" then
                        --退出大厅游戏
                        if USER_INFO["enter_mode"] == 0 then
                            require("hall.GameCommon"):gExitGame()
                        else
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        end
                    end
                end
            end)

        end
    end
end

--解散功能专用弹出框
function GameTips:showDisbandTips(title,code,bShowButton,msg,data,disband_callback)

    dump(msg, "-----解散功能专用弹出框-----")

    require(NetworkLoadingView_filePath):removeView()

    if bShowButton then
        print("show button state:"..tostring(bShowButton))
    end
    bShowButton = bShowButton or 0
    msg = msg or ""
    data = data or ""

    if SCENENOW["scene"] then

        --释放之前的
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
            s:removeSelf()
        end

        s = cc.CSLoader:createNode(DisbandTipsCsb_filePath)
        s:setName("layer_tips")

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

        SCENENOW["scene"]:addChild(s,99998)

        local layer = s:getChildByName("tips_back_1")

        local txt = layer:getChildByName("txt_msg")
        if txt then
             txt:setString(title)
        end

        local msg_tt = layer:getChildByName("msg_tt")
        msg_tt:setString(msg)
        if code == "request_disbandGroup" or code == "cs_request_disbandGroup" or code == "agree_disbandGroup" or code == "ddz_request_disbandGroup" or code == "wk_request_disbandGroup" or code == "niuniu_mp_request_disbandGroup" or code == "niuniu_qz_request_disbandGroup" or code == "niuniu_request_disbandGroup" then
            msg_tt:setTextHorizontalAlignment(0)
        end

        local btnSubmit = layer:getChildByName("btn_submit")

        local btnCancel = layer:getChildByName("btn_cancel")

        local btn_sure =  layer:getChildByName("btn_sure")

        if bShowButton == 0 then
            btn_sure:setVisible(true)
            btnCancel:setVisible(false)
            btnSubmit:setVisible(false)
        else
            btn_sure:setVisible(false)
        end

        if bShowButton == 1 then--全部显示

        elseif bShowButton == 2 then--只显示取消按钮

            btnSubmit:setVisible(false)

            btnCancel:setVisible(true)
            btnCancel:setPosition(cc.p(400.00, 137.00))

        elseif bShowButton == 3 then--只显示确定按钮

            btnSubmit:setVisible(true)
            btnSubmit:setPosition(cc.p(400.00, 137.00))

            btnCancel:setVisible(false)

        elseif bShowButton == 4 then
             btnSubmit:setVisible(false)
             btnCancel:setVisible(false)

        end

        

        local function touchEvent(sender, event)

            --触摸开始
            if event == TOUCH_EVENT_BEGAN then

            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then

            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then

                require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)

                --现在去（确定）
                if sender == btnSubmit then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if code then
                        if code == "kwx_liangdao_remaid" then
                            --todo
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:replyLiangdaoRemaid(true)
                            end

                             --@ms
                        elseif code == "new_disbandGroup" then
                            print("@@@-------my new _disbandfrou")
                           if  disband_callback then
                               disband_callback()
                           end
                        elseif code == "new_request_disbandGroup" then
                            if  disband_callback then
                                disband_callback(1)
                           end

                        elseif code == "cs_disbandGroup" then
                            --申请解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "cs_request_disbandGroup" then
                            --同意解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end
                        elseif code == "kwx_disbandGroup" then
                            --申请解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "kwx_request_disbandGroup" then
                            --同意解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "szkwx_disbandGroup" then
                            --申请解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "szkwx_request_disbandGroup" then
                            --同意解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "xgkwx_disbandGroup" then
                            --申请解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "xgkwx_request_disbandGroup" then

                            dump("xgkwx_request_disbandGroup", "xgkwx_request_disbandGroup")

                            --同意解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "xykwx_disbandGroup" then

                            dump("xykwx_disbandGroup", "xykwx_disbandGroup")

                            --申请解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "xykwx_request_disbandGroup" then
                            --同意解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        --@ｚｃ添加河北麻将
                         elseif code == "HBMJ_disbandGroup" then

                            --申请解散组局
                            if HBMJ_CONTROLLER then
                                --todo
                                HBMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end
                        elseif code == "HBMJ_request_disbandGroup" then
                            --同意解散组局
                            if HBMJ_CONTROLLER then
                                --todo
                                HBMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end
                         --@ｚｃ添加河北麻将

                         --@ms:晃晃麻将
                        elseif code == "HHMJ_disbandGroup" then
                            --申请解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "HHMJ_request_disbandGroup" then
                            --同意解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end



                        elseif code == "disbandGroup" then
                            --申请解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "request_disbandGroup" then
                            --同意解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "disbandGroup_fail" then
                            --解散组局失败


                        -- 牛牛解散相关
                        elseif code == "niuniu_disbandGroup" then
                            --申请解散组局
                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            
                            --@zc  抢庄牛牛
                        elseif code == "niuniu_qz_disbandGroup" then
                            --申请解散组局
                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_qz_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_qz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --@zc 明牌牛牛结算相关
                         elseif code == "niuniu_mp_disbandGroup" then
                            --申请解散组局
                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_mp_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_mp_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --斗地主相关
                        elseif code == "ddz_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----斗地主-----")

                            dump(bm.Room.UserInfo, "-----斗地主-----")

                            require("ddz.ddzServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "ddz_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("ddz.ddzServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "ddz_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])


                            --@zc20170720 陕西挖坑
                            elseif code == "wk_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----斗地主-----")

                            dump(bm.Room.UserInfo, "-----斗地主-----")

                            require("wk.wkServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "wk_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("wk.wkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "wk_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --@zc20170720 陕西挖坑

                        --跑得快申请解散
                        elseif code == "pdk_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----跑得快-----")

                            dump(bm.Room.UserInfo, "-----跑得快-----")

                            require("pdk.pdkServer"):C2G_CMD_DISSOLVE_ROOM()


                        elseif code == "pdk_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "pdk_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("pdk.pdkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                                                  --红中麻将相关
                        elseif code == "ZZMJ_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----推倒胡-----")

                            if ZZMJ_CONTROLLER then
                                --todo
                                ZZMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "ZZMJ_request_disbandGroup" then
                            --同意解散组局
                            if ZZMJ_CONTROLLER then
                                ZZMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end



                        --广东麻将相关
                        elseif code == "GDMJ_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----推倒胡-----")

                            if GDMJ_CONTROLLER then
                                --todo
                                GDMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "GDMJ_request_disbandGroup" then
                            --同意解散组局
                            if GDMJ_CONTROLLER then
                                GDMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end



                        -- 诈金花申请解散
                        elseif code == "zjh_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----跑得快-----")

                            dump(bm.Room.UserInfo, "-----跑得快-----")

                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_DISSOLVE_ROOM()


                        elseif code == "zjh_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "zjh_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----诈金花同意解散组局-----")

                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                        
                        end

                   



                    end

                end

                --下次吧（取消）
                if sender == btnCancel then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if code then
                        if code == "kwx_liangdao_remaid" then
                            --todo
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:replyLiangdaoRemaid(false)
                            end
                        --@ms
                        elseif code == "new_request_disbandGroup" then   
                            if  disband_callback then
                                disband_callback(0)
                            end

                         --红中麻将
                        elseif code == "ZZMJ_request_disbandGroup" then
                            if ZZMJ_CONTROLLER then
                                ZZMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end 
                            --广东麻将
                        elseif code == "GDMJ_request_disbandGroup" then
                            if GDMJ_CONTROLLER then
                                GDMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end 
                        elseif code == "cs_disbandGroup" then
                            --申请退出组局

                        elseif code == "cs_request_disbandGroup" then
                            --拒绝解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end
                        elseif code == "kwx_request_disbandGroup" then
                            --拒绝解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "szkwx_request_disbandGroup" then
                            --拒绝解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "xgkwx_request_disbandGroup" then

                            dump("xgkwx_request_disbandGroup", "xgkwx_request_disbandGroup")

                            --拒绝解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "xykwx_request_disbandGroup" then
                            --拒绝解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        --@ms晃晃麻将
                        elseif code == "HHMJ_request_disbandGroup" then
                            --拒绝解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end


                        elseif code == "disbandGroup" then
                            --申请退出组局

                        elseif code == "request_disbandGroup" then
                            --拒绝解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "disbandGroup_fail" then
                            --解散组局失败


                        --牛牛相关
                        elseif code == "niuniu_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                             --@zc 新版抢庄牛牛
                        elseif code == "niuniu_qz_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_qz_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_qz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --@zc 明牌牛牛的结算

                        elseif code == "niuniu_mp_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_mp_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_mp_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --斗地主相关
                        elseif code == "ddz_disbandGroup" then
                            --申请退出组局

                        elseif code == "ddz_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("ddz.ddzServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "ddz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])


                        --20170720  陕西挖坑解散房间配置
                        elseif code == "wk_disbandGroup" then
                            --申请退出组局

                        elseif code == "wk_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("wk.wkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "wk_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])


                        --跑得快相关
                        elseif code == "pdk_disbandGroup" then
                            --申请退出组局

                        elseif code == "pdk_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("pdk.pdkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "pdk_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --炸金花相关
                        elseif code == "zjh_disbandGroup" then
                            --申请退出组局

                        elseif code == "zjh_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----炸金花拒绝解散组局-----")
                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "zjh_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        end

                    end
                elseif  sender == btn_sure then
                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end
                end
            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)
        btn_sure:addTouchEventListener(touchEvent)

    end

end

--解散功能专用弹出框新
function GameTips:showDisbandNewTips(title, code, bShowButton, msg, disband_callback)

    dump(msg, "-----解散功能专用弹出框-----")

    require(NetworkLoadingView_filePath):removeView()

    bShowButton = bShowButton or 0
    data = data or ""

    if SCENENOW["scene"] then

        --释放之前的
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
            s:removeSelf()
        end

        s = cc.CSLoader:createNode(NewDisbandTipsCsb_filePath)
        s:setName("layer_tips")

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

        SCENENOW["scene"]:addChild(s,99998)

        local layer = s:getChildByName("tips_back_1")

        --标题
        local txt = layer:getChildByName("txt_msg")
        txt:setString("解散房间")

        --申请解散者名称
        local msg_tt = layer:getChildByName("msg_tt")

        if msg ~= nil then
            
            local player_arr = {}
            for k,v in pairs(msg) do
                if v.state == "申请" then
                    msg_tt:setString(require(GameCommon_filePath):formatNick(v.playerName, 6))
                else
                    table.insert(player_arr, v)
                end
            end

            --显示其他玩家
            local player_ly = layer:getChildByName("player_ly")
            local x = 0
            local width = 500
            x = width / (#player_arr + 1)

            for k,v in pairs(player_arr) do

                local playerCsb = cc.CSLoader:createNode(DisbandPlayerCsb_filePath)
                playerCsb:setScale(1.2)
                local playerCsb_x = 0
                if #player_arr < 3 then
                    playerCsb_x = x * k - 20
                else
                    playerCsb_x = (x + 30) * k - 80
                end
                playerCsb:setPosition(playerCsb_x, -170)
                player_ly:addChild(playerCsb)

                local content_ly = playerCsb:getChildByName("content_ly")

                local head_iv = content_ly:getChildByName("head_iv")
                if v.icon == nil then
                    head_iv:loadTexture(DefaultHead_filePath)
                else
                    if v.icon == "" then
                        head_iv:loadTexture(DefaultHead_filePath)
                    else
                        require(GameCommon_filePath):getUserHead(v.icon, "", "", head_iv, 68, false, v.playerName)
                    end
                end

                local name_tt = content_ly:getChildByName("name_tt")
                name_tt:setString(require(GameCommon_filePath):formatNick(v.playerName, 4))

                local state_iv = content_ly:getChildByName("state_iv")
                if v.state == "同意" then
                    state_iv:loadTexture(NewDisbandTips_agree_filePath)
                end

            end
            
        end

        local btnSubmit = layer:getChildByName("btn_submit")
        local btnCancel = layer:getChildByName("btn_cancel")

        if bShowButton == 1 then--全部显示

        elseif bShowButton == 2 then--只显示取消按钮

            btnSubmit:setVisible(false)

            btnCancel:setVisible(true)
            btnCancel:setPosition(cc.p(400.00, 137.00))

        elseif bShowButton == 3 then--只显示确定按钮

            btnSubmit:setVisible(true)
            btnSubmit:setPosition(cc.p(400.00, 137.00))

            btnCancel:setVisible(false)

        elseif bShowButton == 4 then
             btnSubmit:setVisible(false)
             btnCancel:setVisible(false)

        end

        local function touchEvent(sender, event)

            --触摸开始
            if event == TOUCH_EVENT_BEGAN then

            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then

            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then

                require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)

                --现在去（确定）
                if sender == btnSubmit then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if code then
                        if code == "kwx_liangdao_remaid" then
                            --todo
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:replyLiangdaoRemaid(true)
                            end
                        --@ms
                        elseif code == "new_disbandGroup" then
                           if  disband_callback then
                               disband_callback()
                           end
                        elseif code == "new_request_disbandGroup" then
                            if  disband_callback then
                                disband_callback(1)
                           end


                        elseif code == "cs_disbandGroup" then
                            --申请解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "cs_request_disbandGroup" then
                            --同意解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end
                        elseif code == "kwx_disbandGroup" then
                            --申请解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "kwx_request_disbandGroup" then
                            --同意解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "szkwx_disbandGroup" then
                            --申请解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "szkwx_request_disbandGroup" then
                            --同意解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "xgkwx_disbandGroup" then
                            --申请解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "xgkwx_request_disbandGroup" then

                            dump("xgkwx_request_disbandGroup", "xgkwx_request_disbandGroup")

                            --同意解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        elseif code == "xykwx_disbandGroup" then

                            dump("xykwx_disbandGroup", "xykwx_disbandGroup")

                            --申请解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end


                         --@zc 添加河北麻将
                        elseif code == "HBMJ_disbandGroup" then

                            --申请解散组局
                            if HBMJ_CONTROLLER then
                                --todo
                                HBMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end
                        elseif code == "HBMJ_request_disbandGroup" then
                            --同意解散组局
                            if HBMJ_CONTROLLER then
                                --todo
                                HBMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end
                            
                        elseif code == "xykwx_request_disbandGroup" then
                            --同意解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end

                        --@ms晃晃
                        elseif code == "HHMJ_disbandGroup" then
                            --申请解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "HHMJ_request_disbandGroup" then
                            --同意解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end


                        elseif code == "disbandGroup" then
                            --申请解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "request_disbandGroup" then
                            --同意解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "disbandGroup_fail" then
                            --解散组局失败


                        -- 牛牛解散相关
                        elseif code == "niuniu_disbandGroup" then
                            --申请解散组局
                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                            --@zc 新版抢庄牛牛
                            elseif code == "niuniu_qz_disbandGroup" then
                            --申请解散组局
                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_qz_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_qz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --@zc 明牌牛牛结算

                         elseif code == "niuniu_mp_disbandGroup" then
                            --申请解散组局
                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "niuniu_mp_request_disbandGroup" then
                            --同意解散组局
                            dump("同意解散组局", "-----牛牛同意解散组局-----")

                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "niuniu_mp_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --斗地主相关
                        elseif code == "ddz_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----斗地主-----")

                            dump(bm.Room.UserInfo, "-----斗地主-----")

                            require("ddz.ddzServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "ddz_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("ddz.ddzServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "ddz_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])


                            --20170720 陕西挖坑解散房间 
                        elseif code == "wk_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----斗地主-----")

                            dump(bm.Room.UserInfo, "-----斗地主-----")

                            require("wk.wkServer"):C2G_CMD_DISSOLVE_ROOM()

                        elseif code == "wk_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("wk.wkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                        elseif code == "wk_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --跑得快申请解散
                        elseif code == "pdk_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----跑得快-----")

                            dump(bm.Room.UserInfo, "-----跑得快-----")

                            require("pdk.pdkServer"):C2G_CMD_DISSOLVE_ROOM()


                        elseif code == "pdk_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "pdk_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----斗地主同意解散组局-----")

                            require("pdk.pdkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)

                                                  --红中麻将相关
                        elseif code == "ZZMJ_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----推倒胡-----")

                            if ZZMJ_CONTROLLER then
                                --todo
                                ZZMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "ZZMJ_request_disbandGroup" then
                            --同意解散组局
                            if ZZMJ_CONTROLLER then
                                ZZMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end



                        --广东麻将相关
                        elseif code == "GDMJ_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----推倒胡-----")

                            if GDMJ_CONTROLLER then
                                --todo
                                GDMJ_CONTROLLER:C2G_CMD_DISSOLVE_ROOM()
                            end

                        elseif code == "GDMJ_request_disbandGroup" then
                            --同意解散组局
                            if GDMJ_CONTROLLER then
                                GDMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                            end



                        -- 诈金花申请解散
                        elseif code == "zjh_disbandGroup" then
                            --申请解散组局
                            dump("申请解散组局", "-----跑得快-----")

                            dump(bm.Room.UserInfo, "-----跑得快-----")

                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_DISSOLVE_ROOM()


                        elseif code == "zjh_disbandGroup_success" then
                            --解散组局成功

                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "zjh_request_disbandGroup" then
                            --同意解散组局

                            dump("同意解散组局", "-----诈金花同意解散组局-----")

                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(1)
                        
                        end



                    end

                end

                --下次吧（取消）
                if sender == btnCancel then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                    if code then
                        if code == "kwx_liangdao_remaid" then
                            --todo
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:replyLiangdaoRemaid(false)
                            end
                         --红中麻将
                        elseif code == "ZZMJ_request_disbandGroup" then
                            if ZZMJ_CONTROLLER then
                                ZZMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end 
                            --广东麻将
                        elseif code == "GDMJ_request_disbandGroup" then
                            if GDMJ_CONTROLLER then
                                GDMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end 
                        elseif code == "cs_disbandGroup" then
                            --申请退出组局

                        elseif code == "cs_request_disbandGroup" then
                            --拒绝解散组局
                            if CSMJ_CONTROLLER then
                                --todo
                                CSMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end
                        elseif code == "kwx_request_disbandGroup" then
                            --拒绝解散组局
                            if KWX_CONTROLLER then
                                --todo
                                KWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "szkwx_request_disbandGroup" then
                            --拒绝解散组局
                            if SZKWX_CONTROLLER then
                                --todo
                                SZKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "xgkwx_request_disbandGroup" then

                            dump("xgkwx_request_disbandGroup", "xgkwx_request_disbandGroup")

                            --拒绝解散组局
                            if XGKWX_CONTROLLER then
                                --todo
                                XGKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "xykwx_request_disbandGroup" then
                            --拒绝解散组局
                            if XYKWX_CONTROLLER then
                                --todo
                                XYKWX_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end
                        --@ms晃晃麻将

                        elseif code == "HHMJ_request_disbandGroup" then
                            --拒绝解散组局
                            if HHMJ_CONTROLLER then
                                --todo
                                HHMJ_CONTROLLER:C2G_CMD_REPLY_DISSOLVE_ROOM(0)
                            end

                        elseif code == "disbandGroup" then
                            --申请退出组局

                        elseif code == "request_disbandGroup" then
                            --拒绝解散组局
                            require("majiang.scenes.MajiangroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "disbandGroup_success" then
                            --解散组局成功
                            require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "cs_disbandGroup_success" then
                            --解散组局成功
                            -- require("majiang.ddzSettings"):setEndGroup(2)
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        elseif code == "disbandGroup_fail" then
                            --解散组局失败


                        --牛牛相关
                        elseif code == "niuniu_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu.niuniuNamal.NiuniuroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                             --@zc 新版抢庄牛牛
                       elseif code == "niuniu_qz_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_qz_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu_qz.niuniu_qzNamal.niuniu_qzroomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_qz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                        --@zc　明牌牛牛结算
                        elseif code == "niuniu_mp_disbandGroup" then
                            --申请退出组局

                        elseif code == "niuniu_mp_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----牛牛拒绝解散组局-----")
                            require("niuniu_mp.niuniu_mpNamal.niuniu_mproomServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "niuniu_mp_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --斗地主相关
                        elseif code == "ddz_disbandGroup" then
                            --申请退出组局

                        elseif code == "ddz_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("ddz.ddzServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "ddz_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])


                         --20170720 陕西麻将解散房间处理 

                        elseif code == "wk_disbandGroup" then
                            --申请退出组局

                        elseif code == "wk_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("wk.wkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "wk_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --跑得快相关
                        elseif code == "pdk_disbandGroup" then
                            --申请退出组局

                        elseif code == "pdk_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----斗地主拒绝解散组局-----")
                            require("pdk.pdkServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "pdk_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        --炸金花相关
                        elseif code == "zjh_disbandGroup" then
                            --申请退出组局

                        elseif code == "zjh_request_disbandGroup" then
                            --拒绝解散组局
                            dump("拒绝解散组局", "-----炸金花拒绝解散组局-----")
                            require("zhajinhua.ZhajinHuaServer"):C2G_CMD_REPLY_DISSOLVE_ROOM(0)

                        elseif code == "zjh_disbandGroup_success" then
                            --解散组局成功
                            require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])

                        end

                    end

                end

            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)

    end

end

--显示弹出式公告弹框
function GameTips:showNotice(title,code,bShowButton,msg,data)

    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

    if bShowButton then
        print("show button state:"..tostring(bShowButton))
    end
    bShowButton = bShowButton or 0
    msg = msg or ""
    data = data or ""

    if SCENENOW["scene"] then

        --释放之前的
        local s = SCENENOW["scene"]:getChildByName("layer_tips")
        if s then
            s:removeSelf()
        end

        s = cc.CSLoader:createNode(CommonTipsCsb_filePath)
        --s:getChildByName("tips_back_1"):setTexture("hall/tips/tips_back.png")
        s:setName("layer_tips")

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

        SCENENOW["scene"]:addChild(s,99998)

        local layer = s:getChildByName("tips_back_1")
        local txt = layer:getChildByName("txt_msg")
        if txt then
             txt:setString(title)
        end

        local msg_tt = layer:getChildByName("msg_tt")
        msg_tt:setString(msg)

        local btnSubmit = layer:getChildByName("btn_submit")

        local btnCancel = layer:getChildByName("btn_cancel")

        local btn_sure =  layer:getChildByName("btn_sure")

        if bShowButton == 0 then
            btn_sure:setVisible(true)
            btnCancel:setVisible(false)
            btnSubmit:setVisible(false)
        else
            btn_sure:setVisible(false)
        end

        if bShowButton == 1 then--全部显示

        elseif bShowButton == 2 then--只显示取消按钮

            btnSubmit:setVisible(false)

            btnCancel:setVisible(true)
            btnCancel:setPosition(cc.p(400.00, 137.00))

            btn_sure:setVisible(false)

        elseif bShowButton == 3 then--只显示确定按钮

            btnSubmit:setVisible(true)
            btnSubmit:setPosition(cc.p(400.00, 137.00))

            btnCancel:setVisible(false)

            btn_sure:setVisible(false)

        elseif bShowButton == 4 then
             btnSubmit:setVisible(false)
             btnCancel:setVisible(false)
             btn_sure:setVisible(false)

        end

        local function touchEvent(sender, event)

            --触摸开始
            if event == TOUCH_EVENT_BEGAN then

            end

            --触摸取消
            if event == TOUCH_EVENT_CANCELED then

            end

            --触摸结束
            if event == TOUCH_EVENT_ENDED then

                require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)

                --现在去（确定）
                if sender == btnSubmit then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                end

                --下次吧（取消）
                if sender == btnCancel then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                end
                    
                if sender == btn_sure then

                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end

                end

            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)
        btn_sure:addTouchEventListener(touchEvent)

    end

end

function GameTips:showTipsUpdate(title,url,version,gid,code,see)

    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()
    
    -- body
    print("show tips")
    see = see or 1
    if SCENENOW["scene"] then
        local s = cc.CSLoader:createNode(CommonTipsCsb_filePath)
        s:setName("layer_tips")

        if cc.Director:getInstance():getOpenGLView():getDesignResolutionSize().width == 960 then
            s:setScale(0.75)
        end

        SCENENOW["scene"]:addChild(s,99999)
        local layer = s:getChildByName("tips_back_1")
        local txt = layer:getChildByName("txt_msg")
        if txt then
            txt:setString(title)
        end

        local btnSubmit = layer:getChildByName("btn_submit")
        local btnCancel = layer:getChildByName("btn_cancel")
        local btn_sure =  layer:getChildByName("btn_sure")
        btn_sure:setVisible(false)

        local function touchEvent(sender, event)
            if event == TOUCH_EVENT_ENDED then
                require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)
                if sender == btnSubmit then
                    if SCENENOW["scene"]:getChildByName("layer_tips") then
                        SCENENOW["scene"]:removeChildByName("layer_tips")
                    end
                    if see > 0 then
                        require("hall.GameUpdate"):updateGame(url,version,gid,code)
                    else
                        require("hall.GameUpdate"):updteGameUnsee(url,version,gid,code)
                    end
                end
                if sender == btnCancel then
                    -- if isGroup then
                    if require("hall.gameSettings"):getGameMode() == "group" then
                        require("hall.GameCommon"):gExitGroupGame(USER_INFO["enter_mode"])
                    else
                        require("hall.GameCommon"):gExitGame();
                    end
                end
            end
        end

        btnSubmit:addTouchEventListener(touchEvent)
        btnCancel:addTouchEventListener(touchEvent)
    end
end

function GameTips:widthSingle(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
   local lenInByte = #inputstr
   local width = 0
   local huanhangCount = 0
   local i = 1
    while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;

        if curByte == string.byte("\n") then
            --todo
            huanhangCount = huanhangCount + 1
        end

        if curByte>0 and curByte<=127 then
            byteCount = 1                                               --1字节字符
        elseif curByte>=192 and curByte<223 then
            byteCount = 2                                               --双字节字符
        elseif curByte>=224 and curByte<239 then
            byteCount = 3                                               --汉字
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                               --4字节字符
        end
         
        local char = string.sub(inputstr, i, i+byteCount-1)

        i = i + byteCount                                              -- 重置下一字节的索引
        width = width + 1                                             -- 字符的个数（长度）
    end
    return width, huanhangCount
end

function GameTips:showTipsScroll(title, content)
    require("hall.NetworkLoadingView.NetworkLoadingView"):removeView()

    if SCENENOW["scene"] then
        local s = cc.CSLoader:createNode(ScrollTipsCsb_filePath)

        local floor = s:getChildByName("floor")

        local bg_img = floor:getChildByName("bg_img")

        local title_lb = bg_img:getChildByName("title_lb")
        title_lb:setString(title)

        local scroll_v = bg_img:getChildByName("scroll_v")
        local content_lb = scroll_v:getChildByName("content_lb")

        content_lb:setString(content)

        local wordCount, huanhangCount = self:widthSingle(content)

        local height = 30 * (wordCount / 21 + huanhangCount)

        local scroll_height = scroll_v:getContentSize().height

        local x = content_lb:getPosition().x

        content_lb:setSize(cc.size(content_lb:getContentSize().width, height))

        if height > scroll_height then
            --todo
            content_lb:setPosition(cc.p(x, height - 30))

            scroll_v:setInnerContainerSize(cc.size(scroll_v:getContentSize().width, height))
        else
            content_lb:setPosition(cc.p(x, scroll_height - 30))
        end

        local function touchEvent(sender, event)
            if event == TOUCH_EVENT_ENDED then
                if sender == floor then
                    s:removeFromParent()
                end
            end
        end

        floor:addTouchEventListener(touchEvent)
        bg_img:addTouchEventListener(touchEvent)

        SCENENOW["scene"]:addChild(s, 10000)
    end
end


--处理比赛奖励报名
function GameTips:HandleGameAwardPool()
    -- body
end

--处理兑换宝贝币
function GameTips:ChangeMoney()
    -- body
end

return GameTips