--CreateRoom
local l_LayerBase = require("hall.scene.Layer.LayerBase")
local LayerRoomCreate = class("LayerRoomCreate", l_LayerBase)

local btn_list_ok = "hall/scene/res/168/image/group/create/btn_list_ok.png"
local btn_list_no = "hall/scene/res/168/image/group/create/btn_list_no.png"

function LayerRoomCreate:ctor()
    self.super.ctor(self)
    
	local root = cc.CSLoader:createNode("hall/scene/res/168/group/create/LayerRoomCreate.csb")
	self:addChild(root)

    local bg = root:getChildByName("Panel_")

    --关闭
    ccui.Helper:seekWidgetByName(bg,"btn_close"):addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            PlayMusicEffect()
            self:removeLayer()
        end
    end)


    --生成游戏列表
    self:showGameList(bg)
    
end

function LayerRoomCreate:showGameList(bg)

    local select_btn = nil
    --获取准备数组
    local gameList_ = {}
    for key,var in pairs(bm.gameList) do
        if var.gameType == "麻将类" or var.gameType == "3D类" or var.gameType == "扑克类" then
            for k,v in pairs(var.gameArr) do
                table.insert(gameList_,v)
            end
        end
    end

    local btn_list = ccui.Helper:seekWidgetByName(bg,"gamelist_sv")
    btn_list:setInnerContainerSize(cc.size(290.00, #gameList_ * 80 + 35))
    local btn_layout = ccui.Helper:seekWidgetByName(btn_list,"content_ly")

    for k,v in pairs(gameList_) do
        local button = ccui.Button:create()
        button:loadTextures(btn_list_no,btn_list_no,nil)
        btn_layout:addChild(button)
        button:setPosition(cc.p(135,(-k * 80 + 35) + (#gameList_ * 80 + 35) / 2))

        button:addTouchEventListener(

            function(sender,event)

                if event == TOUCH_EVENT_BEGAN then
                    sender:scale(0.8)
                end

                --触摸取消
                if event == TOUCH_EVENT_CANCELED then
                    sender:scale(1)
                end

                --触摸结束
                if event == TOUCH_EVENT_ENDED then
                    sender:scale(1)

                    if not select_btn then
                        select_btn = sender
                        sender:loadTextures(btn_list_ok,btn_list_ok,nil)
                    else
                        if select_btn ~= sender then
                            sender:loadTextures(btn_list_ok,btn_list_ok,nil)
                            select_btn:loadTextures(btn_list_no,btn_list_no,nil)
                        end
                    end
                    
                    select_btn = sender


                end

            end

        )
    end

end

return LayerRoomCreate