--
-- Author: chenhaiquan
-- Date: 2017-02-15 11:57:21
--

local transcribeSceneHandler=class("transcribeSceneHandler")

--从前往后的顺序，从队列里删除另一个队列里存在的值
function remove_tbl_value( src_tbl,remove_tbl )
	-- body
	for _,cards_value in pairs(remove_tbl) do
		local item_index = 1
		while item_index <= #src_tbl do
			local temp_card = src_tbl[item_index]
			if tonumber(cards_value) == temp_card then
				table.remove(src_tbl, item_index)
				break;
			else
				item_index = item_index + 1
			end
		end
	end
end
--反序，从队列里删除另一个队列里存在的值
function remove_tbl_lastvalue( src_tbl,remove_tbl )
	-- body
	for _,cards_value in pairs(remove_tbl) do
		local item_index = #src_tbl
		while item_index > 0 do
			local temp_card = src_tbl[item_index]
			if tonumber(cards_value) == temp_card then
				table.remove(src_tbl, item_index)
				break;
			else
				item_index = item_index - 1
			end
		end
	end
end


local handler_dict = {}

handler_dict["ZIMO_OPCODE"] = 1--#自摸
handler_dict["HU_OPCODE"] = 2--#胡牌
handler_dict["FANG_GANG_OPCODE"] = 4--#自己抓到3张相同的牌，其他玩家打出1张相同牌
handler_dict["AN_GANG_OPCODE"] = 8--#自己抓到4张相同的牌
handler_dict["MING_GANG_OPCODE"] = 16--#自己碰牌后，自己又摸到相同的牌
handler_dict["GANG_OPCODE"] = 32--#开杠拿（2张牌）
handler_dict["PENG_OPCODE"] = 64--#碰牌
handler_dict["CHI_OPCODE"] = 128--#吃牌
handler_dict["HAIDI_OPCODE"] = 256--#海底
handler_dict["TOUCH_OPCODE"] = 512--#摸牌
handler_dict["OUT_CARD_OPCODE"] = 1024--#出牌
handler_dict["GANG_CHOOSE_OPCODE"] = 2048--#杠牌选择
handler_dict["LICENSING_OPCODE"] = 4096--#发牌操作
handler_dict["MAKER_OPCODE"] = 8192--#庄操作  --不处理这个了
handler_dict["ZHANIAO_OPCODE"] = 16384--#扎鸟操作
handler_dict["CHOOSE_JING_OPCODE"] = 65536 -- 宜宾麻将上是飞，冲关上是精牌

function transcribeSceneHandler:ctor(game_type)		
	self.handler_dict = {
			[1] = handler(self,self.ZIMO_OPCODE),
			[2] = handler(self,self.HU_OPCODE),
			[4] = handler(self,self.FANG_GANG_OPCODE),
			[8] = handler(self,self.AN_GANG_OPCODE),

			[16] = handler(self,self.MING_GANG_OPCODE),
			[32] = handler(self,self.GANG_OPCODE),
			[64] = handler(self,self.PENG_OPCODE),
			[128] = handler(self,self.CHI_OPCODE),

			[256] = handler(self,self.HAIDI_OPCODE),
			[512] = handler(self,self.TOUCH_OPCODE),
			[1024] = handler(self,self.OUT_CARD_OPCODE),
			[2048] = handler(self,self.GANG_CHOOSE_OPCODE),

			[4096] = handler(self,self.LICENSING_OPCODE),
			[8192] = handler(self,self.MAKER_OPCODE),
			[16384] = handler(self,self.ZHANIAO_OPCODE),
		}
	if "湘阴麻将" == game_type then

	elseif "赣州冲关" == game_type then
		self.handler_dict[65536] = handler(self,self.CHOOSE_JING_OPCODE)

	elseif "宜宾麻将" == game_type then
		self.handler_dict[65536] = handler(self,self.Fei_OPCODE)

		self.handler_dict[256] = handler(self,self.beijing_OPCODE)--本金
		self.handler_dict[16384] = handler(self,self.laizi_OPCODE) --癞子
		-- TI_OPCODE = 131072--#提操作（提取碰中的癞子）
		self.handler_dict[131072] = handler(self,self.ti_OPCODE)  
	end
end
--#自摸
function transcribeSceneHandler:ZIMO_OPCODE(data)
	dump(data,"ZIMO_OPCODE")
	local uid = data[1]
	local card_value = data[2]

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(uid)] = "hu"
end

function transcribeSceneHandler:HU_OPCODE(data)
	local hu_uid = data[1]
	local dest_uid = data[2]

	local hu_card_value = data[3]

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(hu_uid)] = "hu"

	VideoScenedata.zhuacard[hu_uid] = hu_card_value
end

--放杠
function transcribeSceneHandler:FANG_GANG_OPCODE(data)
	--别人打一张，我手上有3张，然后我杠
	local fang_uid = data[1]
	fang_uid = tonumber(fang_uid)
	local dest_uid = data[2]
	local card_value =  data[3]

	VideoScenedata.outcard_dict[dest_uid] = VideoScenedata.outcard_dict[dest_uid] or {}
	remove_tbl_lastvalue(VideoScenedata.outcard_dict[dest_uid],{card_value})
	remove_tbl_lastvalue(VideoScenedata.handcard[fang_uid],{card_value,card_value,card_value,card_value})

	VideoScenedata.fanggang[fang_uid] =  VideoScenedata.fanggang[fang_uid] or {}
	table.insert(VideoScenedata.fanggang[fang_uid],card_value)

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(fang_uid)] = "gang"

	if VideoScenedata.zhuacard[fang_uid] ~= nil then
		VideoScenedata.zhuacard[fang_uid] = nil
	end

end

--自己摸四张相同的
function transcribeSceneHandler:AN_GANG_OPCODE(data)
	local uid = data[1]
	local card_value = data[2]

	if VideoScenedata.zhuacard[tonumber(uid)] ~= nil then
		VideoScenedata.zhuacard[tonumber(uid)]  = nil
	end

	remove_tbl_lastvalue(VideoScenedata.handcard[uid],{card_value,card_value,card_value,card_value})

	VideoScenedata.angang[tonumber(uid)] = VideoScenedata.angang[tonumber(uid)] or {}

	table.insert(VideoScenedata.angang[uid],card_value)


	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(uid)] = "gang"

end


-- [16] = handler(self,self.MING_GANG_OPCODE),
-- [32] = handler(self,self.GANG_OPCODE),
-- [64] = handler(self,self.PENG_OPCODE),
-- [128] = handler(self,self.CHI_OPCODE),
function transcribeSceneHandler:MING_GANG_OPCODE(data)
	dump(data,"MING_GANG_OPCODE")
	local minggang_uid = data[1]
	local minggang_card_value = data[2]

	--明杠需要做两件事，在碰牌列表里删掉原先碰的牌
	--再插入到碰的牌到明杠队列。
	remove_tbl_value(VideoScenedata.handcard[tonumber(minggang_uid)],{minggang_card_value})
	remove_tbl_value(VideoScenedata.peng[tonumber(minggang_uid)],{minggang_card_value})
	if VideoScenedata.zhuacard[tonumber(minggang_uid)] ~= nil then
		VideoScenedata.zhuacard[tonumber(minggang_uid)]  = nil
	end

	VideoScenedata.minggang[tonumber(minggang_uid)] = VideoScenedata.minggang[tonumber(minggang_uid)] or {}
	table.insert(VideoScenedata.minggang[tonumber(minggang_uid)],minggang_card_value)

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(minggang_uid)] = "gang"
end

--玩家开杠
function transcribeSceneHandler:GANG_OPCODE(data)
	local kaigang_uid = data[1]
	local gang_type = data[2]
	local gang_card_value = data[3]

	if VideoScenedata.zhuacard[tonumber(kaigang_uid)] ~= nil then
		VideoScenedata.zhuacard[tonumber(kaigang_uid)]  = nil
	end
	remove_tbl_value(VideoScenedata.handcard[tonumber(kaigang_uid)],{gang_card_value,gang_card_value,gang_card_value,gang_card_value})
	if gang_type == 0 then -- 暗杠
		VideoScenedata.angang[tonumber(kaigang_uid)] = VideoScenedata.angang[tonumber(kaigang_uid)] or {}
		table.insert(VideoScenedata.angang[tonumber(kaigang_uid)],gang_card_value)
	else
		VideoScenedata.fanggang[tonumber(kaigang_uid)] = VideoScenedata.fanggang[tonumber(kaigang_uid)] or {}
		table.insert(VideoScenedata.fanggang[tonumber(kaigang_uid)],gang_card_value)
	end

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(kaigang_uid)] = "gang"

end

--碰
function transcribeSceneHandler:PENG_OPCODE(data)
	local peng_uid = data[1]
	peng_uid = tonumber(peng_uid)
	local peng_dest_uid = data[2]
	local peng_card_value = data[3]
	local handcard = VideoScenedata.handcard[tonumber(peng_uid)] or {}

	remove_tbl_value(VideoScenedata.handcard[tonumber(peng_uid)],{peng_card_value,peng_card_value})
	remove_tbl_lastvalue(VideoScenedata.outcard_dict[peng_dest_uid],{peng_card_value})

	VideoScenedata.peng[peng_uid] = VideoScenedata.peng[peng_uid] or {}
	table.insert(VideoScenedata.peng[peng_uid],peng_card_value)


	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(peng_uid)] = "peng"
end

--吃牌
function transcribeSceneHandler:CHI_OPCODE(data)
	local chi_ip = data[1]
	local chu_pai_id = data[2]

	local chi_pai_list = data[3]
	local chi_pai = data[4]

	local remove_tbl = {}
	for _,card_value in pairs(chi_pai_list) do
		if chi_pai ~= card_value then 
			table.insert(remove_tbl,card_value)
		end
	end

	remove_tbl_value( VideoScenedata.outcard_dict[tonumber(chu_pai_id)],{chi_pai})

	remove_tbl_value(VideoScenedata.handcard[tonumber(chi_ip)],remove_tbl)

	VideoScenedata.chi[tonumber(chi_ip)] = VideoScenedata.chi[tonumber(chi_ip)] or {}
	for _,card_value in pairs(chi_pai_list) do
		table.insert(VideoScenedata.chi[tonumber(chi_ip)],card_value)
	end

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi"}
	VideoScenedata.operor[tonumber(chi_ip)] = "chi"
end



-- [256] = handler(self,self.HAIDI_OPCODE),
-- [512] = handler(self,self.TOUCH_OPCODE),
-- [1024] = handler(self,self.OUT_CARD_OPCODE),
-- [2048] = handler(self,self.GANG_CHOOSE_OPCODE),
function transcribeSceneHandler:HAIDI_OPCODE(data)
	dump(data,"HAIDI_OPCODE")
end

--#摸牌
function transcribeSceneHandler:TOUCH_OPCODE(data)
	dump(data,"TOUCH_OPCODE摸牌")
	VideoScenedata.zhuacard = {}
	--for 
	local uid = data[1]
	local card_value = data[2]
	VideoScenedata.zhuacard[tonumber(uid)] = tonumber(card_value)
	--end
	table.insert(VideoScenedata.handcard[tonumber(uid)],card_value)
end

--出牌
function transcribeSceneHandler:OUT_CARD_OPCODE(data)
	local chu_uid = data[1]
	chu_uid = tonumber(chu_uid)
	local out_card_value = data[2]
	out_card_value = tonumber(out_card_value)

	if VideoScenedata.zhuacard then
		VideoScenedata.zhuacard[tonumber(chu_uid)] = nil

		--插入一张打出的牌
		VideoScenedata.outcard_dict[chu_uid] = VideoScenedata.outcard_dict[chu_uid] or {}
		table.insert(VideoScenedata.outcard_dict[chu_uid] ,out_card_value)

		--删除我出的这张手牌
		remove_tbl_value( VideoScenedata.handcard[tonumber(chu_uid)],{out_card_value} )

	end

end

function transcribeSceneHandler:GANG_CHOOSE_OPCODE(data)
end


-- [4096] = handler(self,self.LICENSING_OPCODE),
-- [8192] = handler(self,self.MAKER_OPCODE),
-- [16384] = handler(self,self.ZHANIAO_OPCODE),
function transcribeSceneHandler:LICENSING_OPCODE(data)
	dump(data,"LICENSING_OPCODE")
	VideoScenedata.handcard = {}
	for _uid,uid_card_tbl in pairs(data) do
		VideoScenedata.handcard[tonumber(_uid)] = uid_card_tbl
	end
end

function transcribeSceneHandler:MAKER_OPCODE(data)
	dump(data,"dataMAKER_OPCODE")
	VideoScenedata.maker = data
end

function transcribeSceneHandler:ZHANIAO_OPCODE(data)


end


--赣州冲关
function transcribeSceneHandler:CHOOSE_JING_OPCODE(data)
	-- body
	local game_up_jing_card_list = data["game_up_jing_card_list"] or {}
	local game_down_jing_card_list = data["game_up_jing_card_list"]

	VideoScenedata.game_up_jing_card_list = game_up_jing_card_list
end

-- 宜宾麻将
function transcribeSceneHandler:Fei_OPCODE(data)
	local fei_uid = data[1]--哪个人飞，
	local des_uid = data[2]--飞了谁
	local fei_card = data[3]
	local laizi_card = data[4]

	remove_tbl_value(VideoScenedata.handcard[tonumber(fei_uid)],{fei_card,laizi_card})
	remove_tbl_lastvalue(VideoScenedata.outcard_dict[des_uid],{fei_card})


	VideoScenedata.fei[fei_uid] = VideoScenedata.fei[fei_uid] or {}
	table.insert(VideoScenedata.fei[fei_uid],{fei_card,laizi_card})

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi","fei"}
	VideoScenedata.operor[tonumber(fei_uid)] = "fei"
end

function transcribeSceneHandler:ti_OPCODE(data)
	-- body
	local ti_uid = data[1]--哪个人ti，
	local ti_card = data[3]

	remove_tbl_value( VideoScenedata.handcard[tonumber(ti_uid)],{ti_card} )

	for _index,tabl_card in pairs(VideoScenedata.fei[ti_uid]) do
		if tabl_card[1] == ti_card then
			table.remove(VideoScenedata.fei[ti_uid],_index)
			break
		end
	end
	VideoScenedata.peng[ti_uid] = VideoScenedata.peng[ti_uid] or {}
	table.insert(VideoScenedata.peng[ti_uid],ti_card)

	VideoScenedata.operor = {}
	local op_name = {"hu","gang","peng","guo","chi","fei","ti"}
	VideoScenedata.operor[tonumber(ti_uid)] = "ti"
end

function transcribeSceneHandler:beijing_OPCODE(data)
	-- body
end

function transcribeSceneHandler:laizi_OPCODE( data )
	-- body
	VideoScenedata.game_up_jing_card_list = data or {}
end



function transcribeSceneHandler:deal_handler(recent_step,step_data)
	local deal_flag = false
	for _handler,data in pairs(step_data) do

		if self.handler_dict[tonumber(_handler)] ~= nil then
			self.handler_dict[tonumber(_handler)](data)
			deal_flag = true
			break
		else
			print("------无法处理这步操作---------recent_step--------------",recent_step)
		end

	end
	return deal_flag
end



return transcribeSceneHandler