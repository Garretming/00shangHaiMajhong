local ZZMJController = class("ZZMJController")
--请求服务器操作牌
function ZZMJController:control(controlType, value)


	if D3_CHUPAI == 2 then
		D3_CHUPAI = 1
	end
	
	-- require("js_majiang_3d.globle.ZZMJDefine")
	-- if bit.band(controlType, TING_TYPE_T) > 0 then
	-- 	require("js_majiang_3d.handle.ZZMJSendHandle"):sendTingCard(value)
	-- else
	-- 	require("js_majiang_3d.handle.ZZMJSendHandle"):requestHandle(controlType, value)
	-- end

	dump( bit.band(controlType, TING_TYPE_T),"------走到这了")
	if  bit.band(controlType, TING_TYPE_T) > 0 then
		require("js_majiang_3d.handle.ZZMJSendHandle"):requestTingHandle(controlType, value)
	else
		require("js_majiang_3d.handle.ZZMJSendHandle"):requestHandle(controlType, value)
	end
	

end




function ZZMJController:showSameCard(value)
    require("js_majiang_3d.operator.GamePlaneOperator"):showSameCard(value)
end

function ZZMJController:hideSameCard()
	require("js_majiang_3d.operator.GamePlaneOperator"):hideSameCard()
end


function ZZMJController:acceptManyou(isAccept)
	if isAccept then
		--todo
		require("js_majiang_3d.handle.ZZMJSendHandle"):requestHandle(0x2000, 0)
	else
		require("js_majiang_3d.handle.ZZMJSendHandle"):requestHandle(0, 0)
	end
end

function ZZMJController:playCard(value)
	dump(value, "playCard OUtcard")

	D3_CHUPAI = 0
    
    -- self:hideSameCard()
	self:hideControlPlane()
	require("js_majiang_3d.operator.GamePlaneOperator"):didSelectOutCard(value)
	
	require("js_majiang_3d.handle.ZZMJSendHandle"):sendCard(value)
end

--请求解散房间
function ZZMJController:C2G_CMD_DISSOLVE_ROOM()
    require("js_majiang_3d.handle.ZZMJSendHandle"):C2G_CMD_DISSOLVE_ROOM()
end

--回复请求解散房间
function ZZMJController:C2G_CMD_REPLY_DISSOLVE_ROOM(agree)
    require("js_majiang_3d.handle.ZZMJSendHandle"):C2G_CMD_REPLY_DISSOLVE_ROOM(agree)
end

function ZZMJController:showTingCards(tingSeq)
	require("js_majiang_3d.operator.GamePlaneOperator"):showTingCards(tingSeq)
end

function ZZMJController:hideTingHuPlane()
	require("js_majiang_3d.operator.GamePlaneOperator"):hideTingHuPlane()
end

function ZZMJController:showTingHuPlane(playerType, tingHuCards)
	require("js_majiang_3d.operator.GamePlaneOperator"):showTingHuPlane(playerType, tingHuCards)
end

function ZZMJController:replyLiangdaoRemaid(confirm)
	if confirm then
		--todo
		require("js_majiang_3d.handle.ZZMJSendHandle"):CLIENT_REPLY_LIANGDAO_REMAID(ZZMJ_ROOM.dianpao_card)
	else
		-- require("js_majiang_3d.handle.ZZMJSendHandle"):CLIENT_REPLY_LIANGDAO_REMAID(0)
		D3_CHUPAI = 1
	end
end

function ZZMJController:showLgSelectBox(lgCards)
	require("js_majiang_3d.operator.GamePlaneOperator"):showLgSelectBox(lgCards)
end

function ZZMJController:requestLiang(card)
	require("js_majiang_3d.handle.ZZMJSendHandle"):CLI_REQUEST_LIANG(card)
end

function ZZMJController:requestLiangGang()
	require("js_majiang_3d.handle.ZZMJSendHandle"):CLI_REQUEST_LIANG_GANG(ZZMJ_LG_CARDS)
end

function ZZMJController:requestJiapiao(piao)
	require("js_majiang_3d.handle.ZZMJSendHandle"):CLI_REQUEST_JIAPIAO(piao)
end

function ZZMJController:clearGameDatas()
	require("js_majiang_3d.operator.GamePlaneOperator"):clearGameDatas()
end

function ZZMJController:hideControlPlane()
	require("js_majiang_3d.operator.GamePlaneOperator"):hideControlPlane()
end

-- function ZZMJController:didSelectOutCard(card)
-- 	-- require("js_majiang_3d.operator.GamePlaneOperator"):hideSameCard()
--  --    require("js_majiang_3d.operator.GamePlaneOperator"):showSameCard(card)
-- 	require("js_majiang_3d.operator.GamePlaneOperator"):didSelectOutCard(card)
-- end

function ZZMJController:didSelectOutCard(card)
	ZZMJ_CONTROLLER:hideTingHuPlane()
	if TINGSEQ ~= nil and TINGSEQ ~= {} then  --听队列存在时才遍历
		for k,v in pairs(TINGSEQ) do
			if v.card == card then
			    --显示听得牌
				-- dump(v.tingHuCards,"显示听得牌1")
				ZZMJ_CONTROLLER:showTingHuPlane(CARD_PLAYERTYPE_MY, v.tingHuCards)
				break---是否要取消break
			end
		end
	-- else 
		-- HHMJ_CONTROLLER:hideTingHuPlane()
	end

	-- require("hh_majiang.operator.GamePlaneOperator"):didSelectOutCard(card)

end


--@garret 显示听牌  明暗牌
-- function ZZMJController:showTingBtnAndBalcCards( value )
-- 	require("js_majiang_3d.operator.GamePlaneOperator"):showTingSelectCards(value)
-- end

return ZZMJController