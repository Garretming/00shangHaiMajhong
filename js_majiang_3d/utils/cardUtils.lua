
--获取全局定义数据类
local ZZMJData = require("js_majiang_3d.globle.ZZMJData")

local CardUtils = class("CardUtils")

--通过uid插入牌
function CardUtils:insertCardsByUid(uid, newCard)
	--todo
	local cards = ZZMJData:getCards(uid)
	
	self:insertCardsByUid(cards, newCard)
end

--插入牌
function CardUtils:insertCards(cards, newCard)
	if cards and table.getn(cards) > 0 then
		--todo
		local newValue = newCard

		local insertIndex = 1;
		local j = table.getn(cards)
		for i = 1, j do
			local index = math.floor((i + j) / 2)

			--dump(index, "cards test")

			if cards[index] < newValue then
				--todo
				i = index + 1
				insertIndex = i
			elseif cards[index] > newValue then
				j = index - 1
				insertIndex = j
			else
				insertIndex = index + 1
				break
			end
		end

		table.insert(cards, insertIndex, newCard)
	end
end

--获取用户位置
function CardUtils:getPlayerType(seatId)
    local other_index = seatId - ZZMJ_MY_USERINFO.seat_id

    -- --dump(other_index, "playerType test")

	local playerType = CARD_PLAYERTYPE_MY

 	if  PLAYERNUM == 4 then

	    if other_index < 0 then
	       other_index = other_index + 4
	    end

	    if other_index == 1 then
	    	playerType = CARD_PLAYERTYPE_RIGHT
	    elseif other_index == 2 then
	    	playerType = CARD_PLAYERTYPE_TOP
	    elseif other_index == 3 then
	    	playerType = CARD_PLAYERTYPE_LEFT
	    end

	elseif  PLAYERNUM == 2 then 

	    if other_index < 0 then
	      other_index = other_index + 2
	    end

	    if other_index == 1 then
	    	playerType = CARD_PLAYERTYPE_TOP
	    end


	elseif  PLAYERNUM == 3 then 
		
	    if other_index < 0 then
	      other_index = other_index + 3
	    end

	    if other_index == 1 then
	    	playerType = CARD_PLAYERTYPE_RIGHT
	    elseif other_index == 2 then
	    	playerType = CARD_PLAYERTYPE_LEFT
	    end

	end 

    return playerType
end

--获取操作牌数组
-- status 1：出牌 2：摸牌 3：重连
function CardUtils:getControlTable(handle, handleCard, status, ableGangCards)

	local result = {}
	result["type"] = handle
	result["value"] = handleCard

	-- if ableGangCards then
	-- 	local ableGangCards = {ableGangCards[1], ableGangCards[5]}
 --  	end

	if status == 1 then
		--todo

		local gangCards = {}
		if bit.band(handle, CONTROL_TYPE_GANG) > 0 then
			--todo
			table.insert(gangCards, handleCard)
		end
		result["gangCards"] = gangCards

	elseif status == 2 then

		local gangCards = {}
		for k,v in pairs(ableGangCards) do
			if v > 0 then
				--todo
				table.insert(gangCards, v)
			-- else
			-- 	break
			end
		end
		result["gangCards"] = gangCards

	elseif status == 3 then

		local gangCards = {}
		local m = false
		for k,v in pairs(ableGangCards) do
			if v > 0 then
				--todo
				table.insert(gangCards, v)
				m = true
			-- else
			-- 	break
			end
		end

		if not m then
			--todo
			if bit.band(handle, CONTROL_TYPE_GANG) > 0 then
				--todo
				table.insert(gangCards, handleCard)
			end
		end

		result["gangCards"] = gangCards
	end

	return result
	
end

--执行操作
function CardUtils:processControl(seatId, handle, value)

	--定义操作牌数组
	local progCards = {}

	--定义需移除的牌数组
	local removeCards = {}

	if bit.band(handle, CONTROL_TYPE_GANG) > 0 then
		--杠操作

		if bit.band(handle, GANG_TYPE_BU) > 0 then
			--补杠

			--操作数组添加四张操作牌
			for i=1,4 do
				table.insert(progCards, value)
			end

			--需移除的牌数组添加一张操作牌
			table.insert(removeCards, value)

		else
			--非补杠

			for i=1,3 do

				--操作数组添加三张操作牌
				table.insert(progCards, value)

				--需移除的牌数组添加三张操作牌
				table.insert(removeCards, value)

			end

			--操作数组再添加一张操作牌
			table.insert(progCards, value)

			if bit.band(handle, GANG_TYPE_AN) > 0 then
				--假如是暗杠

				--需移除的牌数组再添加一张操作牌
				table.insert(removeCards, value)

			end

		end
		
	elseif bit.band(handle, CONTROL_TYPE_PENG) > 0 then
		--碰

		for i=1,2 do

			--操作数组添加两张操作牌
			table.insert(progCards, value)

			--需移除的牌数组添加两张操作牌
			table.insert(removeCards, value)

		end

		--操作数组再添加一张操作牌
		table.insert(progCards, value)

	elseif bit.band(handle, CHI_TYPE_LEFT) > 0 then
		--左吃

		--白板替身的情况下
		if isbaibantishen == 1 then

			dump(value, "-----当前操作牌左吃-----")

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value, value + 2 do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组

					if i == caishenCard then
						--假如关联牌牌值是财神，则添加白板
						table.insert(removeCards, 67)
					else
						table.insert(removeCards, i)
					end

				end

				--操作数组添加三张操作牌
				if i == caishenCard then
					--假如关联牌牌值是财神，则添加白板
					table.insert(progCards, 67)
				else
					table.insert(progCards, i)
				end

			end

		else

			for i = value, value + 2 do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组
					table.insert(removeCards, i)
				end

				--操作数组添加三张操作牌
				table.insert(progCards, i)

			end

		end

	elseif bit.band(handle, CHI_TYPE_MIDDLE) > 0 then
		--中吃

		--白板变的情况下
		if isbaibantishen == 1 then

			dump(value, "-----当前操作牌中吃-----")

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value - 1, value + 1 do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组

					if i == caishenCard then
						--假如关联牌牌值是财神，则添加白板
						table.insert(removeCards, 67)
					else
						table.insert(removeCards, i)
					end

				end

				--操作数组添加三张操作牌
				if i == caishenCard then
					--假如关联牌牌值是财神，则添加白板
					table.insert(progCards, 67)
				else
					table.insert(progCards, i)
				end

			end

		else

			for i = value - 1, value + 1 do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组
					table.insert(removeCards, i)
				end

				--操作数组添加三张操作牌
				table.insert(progCards, i)

			end

		end

	elseif bit.band(handle, CHI_TYPE_RIGHT) > 0 then
		--右吃

		--白板变的情况下
		if isbaibantishen == 1 then

			dump(value, "-----当前操作牌右吃-----")

			--获取财神牌值
			local caishenCard = JS_CAISHEN[1]
			
			--假如操作牌是白板
			if value == 67 then
				value = caishenCard
			end

			for i = value - 2, value do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组
					
					if i == caishenCard then
						--假如关联牌牌值是财神，则添加白板
						table.insert(removeCards, 67)
					else
						table.insert(removeCards, i)
					end
					
				end

				--操作数组添加三张操作牌
				if i == caishenCard then
					--假如关联牌牌值是财神，则添加白板
					table.insert(progCards, 67)
				else
					table.insert(progCards, i)
				end

			end

		else

			for i = value - 2, value do

				if value ~= i then
					--添加另外两张关联牌到需移除的牌数组
					table.insert(removeCards, i)
				end

				--操作数组添加三张操作牌
				table.insert(progCards, i)

			end

		end

	end

	--从用户手牌中移除需要移除的牌
	self:removeCards(seatId, removeCards)

	--返回操作牌数组和需移除的牌数组
	return progCards, removeCards

end

--移除牌
function CardUtils:removeCards(seatId, removeCards)

	local oriCards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand

	local count = table.getn(oriCards)
	local removeCount = table.getn(removeCards)

	local removeIndex = 1

	local removeIndexs = {}
	for i=1,count do
		if oriCards[i] == removeCards[removeIndex] or oriCards[i] == 0 then
			--todo
			table.insert(removeIndexs, i)
			removeIndex = removeIndex + 1

			if removeIndex > removeCount then
				--todo
				break
			end
		end
	end

	for i=table.getn(removeIndexs),1,-1 do
		table.remove(oriCards, removeIndexs[i])
	end

end

function CardUtils:playCard(seatId, value)

	--获取用户手牌
	local oriCards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand

	local tag = nil
	for i=1,table.getn(oriCards) do
		if oriCards[i] == 0 or oriCards[i] == value then
			--todo
			tag = i
			table.remove(oriCards, i)
			return tag
		end
	end

	return tag
end

--获取新牌
function CardUtils:getNewCard(seatId, value)
	--dump(seatId, "getNewCard seatId test")
	--dump(ZZMJ_GAMEINFO_TABLE, "getNewCard ZZMJ_GAMEINFO_TABLE test")

	local oriCards = ZZMJ_GAMEINFO_TABLE[seatId .. ""].hand

	-- self:insertCards(oriCards, value)

	table.insert(oriCards, value)
	table.sort(oriCards)

	--dump(oriCards, "sort cards test")
end

-- function CardUtils:GetMaxLenString(s, maxLen)

-- 	local function GetUTFLenWithCount(s, count)  
-- 	    local sTable = StringToTable(s)  
	  
-- 	    local len = 0  
-- 	    local charLen = 0  
-- 	    local isLimited = (count >= 0)  
	  
-- 	    for i=1,#sTable do  
-- 	        local utfCharLen = string.len(sTable[i])  
-- 	        if utfCharLen > 1 then -- 长度大于1的就认为是中文  
-- 	            charLen = 2  
-- 	        else  
-- 	            charLen = 1  
-- 	        end  
	  
-- 	        len = len + utfCharLen  
	  
-- 	        if isLimited then  
-- 	            count = count - charLen  
-- 	            if count <= 0 then  
-- 	                break  
-- 	            end  
-- 	        end  
-- 	    end  
	  
-- 	    return len  
-- 	end 

-- 	local function GetUTFLen(s)  
-- 	    local sTable = StringToTable(s)  
	  
-- 	    local len = 0  
-- 	    local charLen = 0  
	  
-- 	    for i=1,#sTable do  
-- 	        local utfCharLen = string.len(sTable[i])  
-- 	        if utfCharLen > 1 then -- 长度大于1的就认为是中文  
-- 	            charLen = 2  
-- 	        else  
-- 	            charLen = 1  
-- 	        end  
	  
-- 	        len = len + charLen  
-- 	    end  
	  
-- 	    return len  
-- 	end  

--     local len = GetUTFLen(s)  
--     local maxLen=maxLen or 10
--     local dstString = s  
--     -- 超长，裁剪，加...  
--     if len > maxLen then  
--         dstString = string.sub(s, 1, GetUTFLenWithCount(s, maxLen))  
--         dstString = dstString..".."  
--     end  
-- end


return CardUtils