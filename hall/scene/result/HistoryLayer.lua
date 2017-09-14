local HistoryLayer = class("HistoryLayer")

local history_cell
local myRecord_cell
local othersRecord_cell

local history_plane
local myRecord_plane

local isShow = false

local ts = require("hall.roomPlay.transcribe").new()

function HistoryLayer:showHistoryLayer()
	
	isShow = true

	local layout = cc.CSLoader:createNode(ResultCsb_filePath):addTo(SCENENOW["scene"])
--	require("hall.GameCommon"):commomButtonAnimation(layout)
	history_plane = layout:getChildByName("history_plane") --滚动开始的查看界面

	myRecord_plane = layout:getChildByName("myRecord_plane")  --玩家战绩显示
	local findOthersRecord_plane = layout:getChildByName("findOthersRecord_plane")  --查看他人回放背景
			findOthersRecord_plane:setVisible(false)
	local othersRecord_plane = layout:getChildByName("othersRecord_plane")  --战绩列表的背景
     		othersRecord_plane:setVisible(false)
     
	myRecord_plane:setVisible(false)
	findOthersRecord_plane:setVisible(false)
	othersRecord_plane:setVisible(false)

	local back_bt = layout:getChildByName("back_bt")  --返回
	local findOthersRecord_bt = layout:getChildByName("findOthersRecord_bt") --查看他人找回的控件
		  findOthersRecord_bt:setVisible(false)
	local commit_bt = findOthersRecord_plane:getChildByName("commit_bt") --确定
	local cancel_bt = findOthersRecord_plane:getChildByName("cancel_bt") --取消
	local othersRecord_close_bt = othersRecord_plane:getChildByName("othersRecord_close_bt") 

	local input_tf = findOthersRecord_plane:getChildByName("input_tf") --输入框

	--@zc 战绩回放添加点击事件
	--local button_showTips=layout:getChildByName("Button_1")

         
	findOthersRecord_plane.noScale = false
	findOthersRecord_plane:onClick(function()
		findOthersRecord_plane:setVisible(false)
	end)

	local function touchButtonEvent(sender, event)

        if event == TOUCH_EVENT_ENDED then

        	require("hall.GameCommon"):playEffectSound(HallButtonClickVoice_filePath)

            if sender == back_bt then  --点击返回的时候
            	if history_plane:isVisible() then  --滚动界面的显示
            		--todo
            		isShow = false --一个状态控制
            		layout:removeFromParent() --清除界面，内存不减少，专门用cs做的界面
            	else
            		history_plane:setVisible(true) --玩家信息界面显示
            		myRecord_plane:setVisible(false) --具体对战信息不显示
            	end

                
            elseif sender == findOthersRecord_bt then  --点击查看他人找回的控件
                findOthersRecord_plane:setVisible(false)

          --  elseif sender == button_showTips then

          --  require(CommonTips_filePath):showTips("提示", "", 3, "没有更多战绩数据")
            
            elseif sender == commit_bt then
            	if device.platform =="windows" then--查看设备
            		--todo
            		ts:getData() --test
            	end
            	
            	local inputStr = input_tf:getString()
            	if string.len(inputStr) == 0 then
            		--todo
            		return
            	end
            	local strs = string.split(inputStr, "-")
            	if table.getn(strs) ~= 2 then
            		--todos
            		return
            	end
            	dump(strs, "findRound")
            	
            	local params = {}
			    params["activityId"] = strs[1]
			    params["roundIndex"] = strs[2]
			    params["interfaceType"] = "J"
			    cct.createHttRq({
			        url=HttpAddr .. "/freeGame/queryFreeGameRound",
			        date= params,
			        type_="POST",
			        callBack = function(data)
			        	if not isShow then
			        		--todo
			        		return
			        	end

			            data_netData = json.decode(data["netData"])
			            dump(data_netData, "findRound")
			            if data_netData.returnCode == "0" then
			                --todo
			                local sData = data_netData.data
			                if sData ~= nil then
			                    --todo
			                    local rounds = {}
			                    table.insert(rounds, sData)
			                    findOthersRecord_plane:setVisible(false)
				            	self:showOthersRecords(othersRecord_cell, othersRecord_plane:getChildByName("othersRecord_scroll"), rounds)
				            	othersRecord_plane:setVisible(false)
			                end
			            end              
			        end
			    })
            elseif sender == cancel_bt then
            	print("cancel test")
            	findOthersRecord_plane:setVisible(false)
            elseif sender == othersRecord_close_bt then
            	othersRecord_plane:setVisible(false)
            end
        end
    end
    back_bt:addTouchEventListener(touchButtonEvent)
    findOthersRecord_bt:addTouchEventListener(touchButtonEvent)
    commit_bt:addTouchEventListener(touchButtonEvent)
    cancel_bt:addTouchEventListener(touchButtonEvent)
    othersRecord_close_bt:addTouchEventListener(touchButtonEvent)
   -- button_showTips:addTouchEventListener(touchButtonEvent)

    --cell
    history_cell = layout:getChildByName("history_cell")  --玩家列表
    myRecord_cell = layout:getChildByName("myRecord_cell") --分享和回放 玩家对战具体
    othersRecord_cell = layout:getChildByName("othersRecord_cell")

    self.history_cell_5 = layout:getChildByName("history_cell_5")

    local history_scroll = history_plane:getChildByName("history_scroll")

    local params = {}
    params["userId"] = USER_INFO["uid"]
    params["interfaceType"] = "J"
    cct.createHttRq({
        url=HttpAddr .. "/freeGame/queryActivitiesByUserId",
        date= params,
        type_="POST",
        callBack = function(data)
        	if not isShow then
        		--todo
        		return
        	end

            data_netData = json.decode(data["netData"])
            dump(url, "dfadsfdsfd")
            dump(data_netData)
          
            if data_netData.returnCode == "0" then
                --todo
                local sData = data_netData.data
                if sData ~= nil and table.getn(sData) > 0 then
                    --插入战绩
                    local histories = {}
                    for k,v in pairs(sData) do                  	
					-- --@zc 判断没有战绩回放的游戏 直接移除,查看level可以直接去数据库t_group_game表里找	
					 -- if v.level ~= 69 and v.level ~=70 and v.level ~=85 and v.level ~=86 
					 -- 	and v.level ~=65
					 --  then
					 -- 	
					 -- end
					 table.insert(histories, v)
					 end
                    self:showHistories(history_cell, history_scroll, histories)
                end
            end              
        end
    })
end

function HistoryLayer:testData()
	local datas = {}
	local history = {}
	history["num"] = "1"
	history["roomName"] = "testRoom"
	history["time"] = "08-29 11:21"
	
	local players = {}
	local player1 = {}
	player1["name"] = "zh"
	player1["score"] = "80"
	table.insert(players, player1)
	local player2 = {}
	player2["name"] = "zh"
	player2["score"] = "80"
	table.insert(players, player2)
	local player3 = {}
	player3["name"] = "zh"
	player3["score"] = "80"
	table.insert(players, player3)
	local player4 = {}
	player4["name"] = "zh"
	player4["score"] = "80"
	table.insert(players, player4)

	history["players"] = players

	local records = {}
	local record = {}
	record["time"] = "08-30 01:41"
	record["results"] = {"80","80","80","80"}

	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)

	history["records"] = records


	table.insert(datas, history)
	table.insert(datas, history)
	table.insert(datas, history)
	table.insert(datas, history)
	table.insert(datas, history)

	return datas
end

function HistoryLayer:testData1()
	local records = {}
	local record = {}
	record["time"] = "08-30 01:41"
	record["players"] = {"zh","xc","cv","vb"}

	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)
	table.insert(records, record)

	return records
end

function HistoryLayer:showHistories(templateCell, plane, datas)

	
    dump(datas, "-----showHistories-----")

	plane:setInnerContainerSize(cc.size(plane:getSize().width,(templateCell:getSize().height + 5) * table.getn(datas)))
       
	table.foreach(datas, function(i, v) 

		-- dump(data, "-----data-----")
		dump(v.name, "-----name-----")
 

		local data = json.decode(v["content"])

		if data then
			--todo
			dump(data, "-----data-----")

			local playerCount = table.getn(data["userinfos"])

			local cell

			if playerCount == 5 then
				--todo
				cell = self.history_cell_5:clone()
			else
				cell = templateCell:clone()
			end
			-- cell:setTouchEnabled(true)
           	local bg_iv = cell:getChildByName("bg_iv")
			local num_lb = cell:getChildByName("num_lb")
			local roomName_lb = cell:getChildByName("roomName_lb")
			local time_lb = cell:getChildByName("time_lb")
			local player1_lb = cell:getChildByName("player1_lb")
			local player2_lb = cell:getChildByName("player2_lb")
			local player3_lb = cell:getChildByName("player3_lb")
			local player4_lb = cell:getChildByName("player4_lb")
			local score1_lb = cell:getChildByName("score1_lb")
			local score2_lb = cell:getChildByName("score2_lb")
			local score3_lb = cell:getChildByName("score3_lb")
			local score4_lb = cell:getChildByName("score4_lb")
			local roomName_yx=cell:getChildByName("roomName_yx") --当前游戏的名称

			player1_lb:setString("")
			player2_lb:setString("")
			player3_lb:setString("")
			player4_lb:setString("")
			score1_lb:setString("")
			score2_lb:setString("")
			score3_lb:setString("")
			score4_lb:setString("")
            
			num_lb:setString(i .. "")
			--local num=loadstring("return 0x"..data["roomNum"])()
			roomName_lb:setString(data["roomNum"])
			--@ zc更改显示名字
			local datayx
			if v["name"] =="3D二人转转" then --or v["name"] =="3D三人转转" or v["name"] =="3D转转麻将" then
				datayx = "二人红中"
			elseif v["name"] =="3D三人转转" then
				datayx = "三人红中"
			elseif v["name"] =="3D转转麻将" then
				datayx = "红中麻将"
			else
				datayx = v["name"]
			end

            if datayx ~= nil then
				roomName_yx:setString(tostring(datayx))
			else
				roomName_yx:setString("")
			end
			
			local time_str = os.date("%Y-%m-%d %H:%M:%S",data["gameTime"])
			if time_str ~= nil then
				time_lb:setString("" .. time_str)
			else
				time_lb:setString("")
			end

			dump(data["userinfos"], "-----战绩，用户信息-----")

			--@ms
			local oriScore = 0
			if datayx =="斗地主" then
				oriScore = 20000 
			elseif  datayx=="跑得快" or datayx=="二人红中"or datayx=="三人红中"or datayx=="红中麻将" or datayx=="长沙麻将" then
				oriScore = 2000
			end

			if data["userinfos"][1] then
				--todo
				--data["userinfos"][4]
				local nickName =  require("hall.GameCommon"):formatNick(data["userinfos"][1]["nickName"], 6)
				player1_lb:setString(nickName)
				score1_lb:setString(data["userinfos"][1]["score"]-oriScore)

			end

			if data["userinfos"][2] then

				local nickName =  require("hall.GameCommon"):formatNick(data["userinfos"][2]["nickName"], 6)
				player2_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][2]["nickName"], 6))
				score2_lb:setString(data["userinfos"][2]["score"] - oriScore)
			end
			
			if data["userinfos"][3] then
				--todo
				local nickName =  require("hall.GameCommon"):formatNick(data["userinfos"][3]["nickName"], 6)
				player3_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][3]["nickName"], 6))
				score3_lb:setString(data["userinfos"][3]["score"]-oriScore)
		
			end
		
			if data["userinfos"][4] then
				--todo
				local nickName =  require("hall.GameCommon"):formatNick(data["userinfos"][4]["nickName"], 6)
				player4_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][4]["nickName"], 6))
				score4_lb:setString(data["userinfos"][4]["score"]-oriScore)
			
			end
			
			if playerCount == 5 then
				--todo
				local player5_lb = cell:getChildByName("player5_lb")
				local score5_lb = cell:getChildByName("score5_lb")
				player5_lb:setString("")
				score5_lb:setString("")

				if data["userinfos"][5] then
					--todo
					local nickName =  require("hall.GameCommon"):formatNick(data["userinfos"][5]["nickName"], 6)
					player5_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][5]["nickName"], 8))
					score5_lb:setString(data["userinfos"][5]["score"]-oriScore)
			
				end
			end
		
			 cell:setPosition(0, plane:getInnerContainerSize().height - cell:getSize().height / 2  - (5 + cell:getSize().height) * (i-1) + 60)      
	       	 plane:getInnerContainer():addChild(cell)

		    cell.noScale = true 
		    print("ddddcqdascdacs")
		    bg_iv:setTouchEnabled(false)
		    bg_iv:setTag(i)
		    bg_iv:addTouchEventListener(
		        function(sender,event)

		            if event == TOUCH_EVENT_BEGAN then
		                sender:setScale(1.0)

		                
		            end

		            --触摸取消
		            if event == TOUCH_EVENT_CANCELED then
		                sender:setScale(1.0)
		            end

		            --触摸结束
		            if event == TOUCH_EVENT_ENDED then
		                sender:setScale(1.0)

		                local params = {}
					    params["activityId"] = datas[sender:getTag()]["activityId"]
					    params["interfaceType"] = "J"
					    cct.createHttRq({
					        url = HttpAddr .. "/freeGame/querRoundsByActivityId",
					        date = params,
					        type_ = "POST",
					        callBack = function(data)

					        	dump(data, "-----bg_iv-----")

					        	if not isShow then
					        		--todo
					        		return
					        	end
					         if playerCount == 5 then
					        		return
					          else
					        		
					            data_netData = json.decode(data["netData"])
					            if data_netData.returnCode == "0" then
					                --todo     
					                local sData = data_netData.data
					                
					                if sData ~= nil and table.getn(sData) > 0 then   
					                    --todo
					                    if history_plane ~= nil then
					                    	history_plane:setVisible(false)
					                    end
					                    
					                    if myRecord_plane ~= nil  then
					                    	if myRecord_cell ~= nil then
					                    		myRecord_plane:setVisible(true)
					                    		self:showMyRecords(myRecord_cell, myRecord_plane:getChildByName("myRecord_top"), myRecord_plane:getChildByName("myRecord_scroll"), sData)
					                    	end
					                    end
										
					                end
					            end  
					          end            
					        end
					    })

		            end

		        end
		    )

		 --    cell:onClick(

		 --    	function(sender)

			-- 		dump(sender:getTag(), "history tag")

			-- 		local params = {}
			-- 	    params["activityId"] = datas[sender:getTag()]["activityId"]
			-- 	    params["interfaceType"] = "J"
			-- 	    cct.createHttRq({
			-- 	        url=HttpAddr .. "/freeGame/querRoundsByActivityId",
			-- 	        date= params,
			-- 	        type_="POST",
			-- 	        callBack = function(data)
			-- 	        	if not isShow then
			-- 	        		--todo
			-- 	        		return
			-- 	        	end
			-- 	            data_netData = json.decode(data["netData"])
			-- 	            if data_netData.returnCode == "0" then
			-- 	                --todo     
			-- 	                local sData = data_netData.data
				                
			-- 	                if sData ~= nil and table.getn(sData) > 0 then   
			-- 	                    --todo

			-- 	                    history_plane:setVisible(false)
			-- 						myRecord_plane:setVisible(true)
			-- 						self:showMyRecords(myRecord_cell, myRecord_plane:getChildByName("myRecord_top"), myRecord_plane:getChildByName("myRecord_scroll"), sData)
			-- 	                end
			-- 	            end              
			-- 	        end
			-- 	    })

			-- 	end
			-- )

		end

		
		end)
             
    
	
end
function HistoryLayer:showMyRecords(templateCell, myRecord_top, plane, datas)

	plane:removeAllChildren()
	if table.getn(datas) == 0 then
		--todo
		return
	end

	dump(datas,"<<<<<<<<<<<<<<<<<<<<<<post")
	local player1_lb = myRecord_top:getChildByName("player1_lb")
	local player2_lb = myRecord_top:getChildByName("player2_lb")
	local player3_lb = myRecord_top:getChildByName("player3_lb")
	local player4_lb = myRecord_top:getChildByName("player4_lb")

	player1_lb:setString("")
	player2_lb:setString("")
	player3_lb:setString("")
	player4_lb:setString("")
			
	--显示当前自己的战绩结果
	local userinfos = json.decode(datas[1]["content"])["userinfos"]
	dump(userinfos, "rounds content")
	if userinfos[1] then
		--todo
		player1_lb:setString(require("hall.GameCommon"):formatNick(userinfos[1]["nickName"], 3))

	end
	if userinfos[2] then
		--todo
		player2_lb:setString(require("hall.GameCommon"):formatNick(userinfos[2]["nickName"], 3))
	end
	if userinfos[3] then
		--todo
		player3_lb:setString(require("hall.GameCommon"):formatNick(userinfos[3]["nickName"], 3))
	end
	if userinfos[4] then
		--todo
		player4_lb:setString(require("hall.GameCommon"):formatNick(userinfos[4]["nickName"], 3))
	end

	plane:setInnerContainerSize(cc.size(plane:getSize().width, templateCell:getSize().height * table.getn(datas)))
	table.foreach(datas, function(i, v) 
		local data = json.decode(v["content"])
		local cell = templateCell:clone()
		local num_lb = cell:getChildByName("num_lb")
		local othersRecord_cell_bg = cell:getChildByName("othersRecord_cell_bg")
		local time_lb = cell:getChildByName("time_lb")
		local score1_lb = cell:getChildByName("score1_lb")
		local score2_lb = cell:getChildByName("score2_lb")
		local score3_lb = cell:getChildByName("score3_lb")
		local score4_lb = cell:getChildByName("score4_lb")
       
		score1_lb:setString("")
		score2_lb:setString("")
		score3_lb:setString("")
		score4_lb:setString("")

		num_lb:setString("" .. i)
		if i % 2 == 0 then
			--todo
			othersRecord_cell_bg:setVisible(false)
		else
			othersRecord_cell_bg:setVisible(true)
		end
		dump(v["endTime"], "gameTime test")

		time_lb:setString("")
		local time_str = os.date("%m-%d %H:%M",v["endTime"] / 1000)
		if time_str ~= nil then
			time_lb:setString(time_str)
		end

		if data["userinfos"][1] then
			--todo
			score1_lb:setString(data["userinfos"][1]["score"])
		end

		if data["userinfos"][2] then
			--todo
			score2_lb:setString(data["userinfos"][2]["score"])
		end
		
		if data["userinfos"][3] then
			--todo
			score3_lb:setString(data["userinfos"][3]["score"])
		end

		if data["userinfos"][4] then
			--todo
			score4_lb:setString(data["userinfos"][4]["score"])
		end
		
		
		
		cell:setPosition(plane:getSize().width /2, plane:getInnerContainerSize().height - cell:getSize().height / 2 - cell:getSize().height * (i-1))

    	plane:getInnerContainer():addChild(cell)

    	local replay_bt = cell:getChildByName("replay_bt")
    	replay_bt:setTag(i)

    	replay_bt:addTouchEventListener(function(sender, event)
    			if event == TOUCH_EVENT_ENDED then
    				--todo
    				local index = sender:getTag()
    				local roundIndex = datas[index]["roundIndex"]
    				local activityId = datas[index]["activityId"]
    				ts:getData(activityId, roundIndex)
    			end
    		end)

    	local share_bt = cell:getChildByName("share_bt")
		share_bt:setTag(i)


		share_bt:addTouchEventListener(function(sender, event)
    			if event == TOUCH_EVENT_ENDED then
    				--todo
    				local index = sender:getTag()
    				local roundIndex = datas[index]["roundIndex"]
    				local activityId = datas[index]["activityId"]

    				require(Share_filePath):showShareLayerInHall("【乐趣世界】", "http://fir.im/168mja", "url", "这是我的战局邀请码 " .. activityId .. "-" .. roundIndex);
    			end
    		end)
		
		end)
		
end

function HistoryLayer:showOthersRecords(templateCell, plane, datas)

	plane:removeAllChildren()
	plane:setInnerContainerSize(cc.size(plane:getSize().width, templateCell:getSize().height * table.getn(datas)))
	table.foreach(datas, function(i, v) 
		local data = json.decode(v["content"])
		local cell = templateCell:clone()
		local num_lb = cell:getChildByName("num_lb")
		local othersRecord_cell_bg = cell:getChildByName("othersRecord_cell_bg")
		local time_lb = cell:getChildByName("time_lb")
		local player1_lb = cell:getChildByName("player1_lb")
		local player2_lb = cell:getChildByName("player2_lb")
		local player3_lb = cell:getChildByName("player3_lb")
		local player4_lb = cell:getChildByName("player4_lb")

		player1_lb:setString("")
		player2_lb:setString("")
		player3_lb:setString("")
		player4_lb:setString("")

		num_lb:setString("" .. i)
		if i % 2 == 0 then
			--todo
			othersRecord_cell_bg:setVisible(false)
		else
			othersRecord_cell_bg:setVisible(true)
		end

		time_lb:setString("")
		local time_str = os.date("%m-%d %H:%M",v["endTime"] / 1000)
		if time_str ~= nil then
			time_lb:setString(time_str)
		end

		if data["userinfos"][1] then
			--todo
			player1_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][1]["nickName"], 4))
		end
		
		if data["userinfos"][2] then
			--todo
			player2_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][2]["nickName"], 4))
		end
		if data["userinfos"][3] then
			--todo
			player3_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][3]["nickName"], 4))
		end
		if data["userinfos"][4] then
			--todo
			player4_lb:setString(require("hall.GameCommon"):formatNick(data["userinfos"][4]["nickName"], 4))
		end
		
		cell:setPosition(plane:getSize().width / 2, plane:getInnerContainerSize().height - cell:getSize().height / 2 - cell:getSize().height * (i-0.56))

		local replay_bt = cell:getChildByName("replay_bt")
    	replay_bt:setTag(i)

    	replay_bt:addTouchEventListener(function(sender, event)
    			if event == TOUCH_EVENT_ENDED then
    				--todo
    				local index = sender:getTag()
    				local roundIndex = datas[index]["roundIndex"]
    				local activityId = datas[index]["activityId"]
    				ts:getData(activityId, roundIndex)
    				--require("hall.transcribe.transcribe"):new(activityId, roundIndex)
    			end
    		end)

    	plane:getInnerContainer():addChild(cell)

		end)
end

return HistoryLayer