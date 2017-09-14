local Card = require("hall.3DMahjongCard.Card")

local OuthandOperator = class("OuthandOperator")

local CARD_1_OFFSET_MY = 475
local CARD_2_OFFSET_MY = 590
local CARD_4_OFFSET_MY = 690
local CARD_5_OFFSET_MY = 805

local CARD_MY_MIDDLE = 3

local MY_CARD_SPACE_MATRIX = {{-13, -12, 0, 0, 0}, {0, -10, -8, 0, 0}, {0, 0, -5, -8, 0}, {0, 0, 0, -10, -12}, {0, 0, 0, 0, -13}}

local MY_CARD_POSITION_MATRIX
local MY_CARD_Y_OFFSET = 17

--left
local LEFT_SCALE_OFFSET = 59 / 60
local LEFT_X_OFFSET = 5
local LEFT_CARD_WIDTH = 60
local LEFT_CARD_HEIGHT = 48
local LEFT_Y_OFFSET = 19
local LEFT_ROW_X_OFFSET = 9

local LEFT_CARD_POSITION_MATRIX
--right
local RIGHT_SCALE_OFFSET = 59 / 60
local RIGHT_X_OFFSET = 5
local RIGHT_CARD_WIDTH = 60
local RIGHT_CARD_HEIGHT = 48
local RIGHT_Y_OFFSET = 19
local RIGHT_ROW_X_OFFSET = 9

local RIGHT_CARD_POSITION_MATRIX

--top
local CARD_1_OFFSET_TOP = 475
local CARD_2_OFFSET_TOP = 590
local CARD_4_OFFSET_TOP = 690
local CARD_5_OFFSET_TOP = 805

local CARD_TOP_MIDDLE = 3

local TOP_CARD_SPACE_MATRIX = {{-9, -9, 0, 0, 0}, {0, -8, -5, 0, 0}, {0, 0, -4, -5, 0}, {0, 0, 0, -8, -9}, {0, 0, 0, 0, -9}}

local TOP_CARD_POSITION_MATRIX
local TOP_CARD_Y_OFFSET = 18

function OuthandOperator:init()
	self:calPositionForCards()
end

function OuthandOperator:clearGameDatas(playerType, plane)
	plane:removeAllChildren()
end

function OuthandOperator:calPositionForCards()
	self:calPositionForMyCards()
	self:calPositionForLeftCards()
	self:calPositionForRightCards()
	self:calPositionForTopCards()
end

function OuthandOperator:calPositionForMyCards()
	if not MY_CARD_POSITION_MATRIX then
		--计算出牌区域所有牌的定位
		MY_CARD_POSITION_MATRIX = {}

		local oriX = 0
		local lastShape = 0
		local firstRowDict = {}
		local isOverMiddle = false
		for i = 1, 10 do
			local shape
			if i <= 2 then
				--todo
				shape = 1
			elseif i <= 4 then
				shape = 2
			elseif i <= 6 then
				shape = 3
			elseif i <= 8 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = MY_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_MY_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end
			firstRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		firstRowDict.totalWidth = oriX
		MY_CARD_POSITION_MATRIX[1] = firstRowDict

		-- local oriX = 0
		-- local lastShape = 0
		-- local secondRowDict = {}
		-- local isOverMiddle = false
		-- for i = 1, 10 do
		-- 	local shape
		-- 	if i <= 2 then
		-- 		--todo
		-- 		shape = 1
		-- 	elseif i <= 4 then
		-- 		shape = 2
		-- 	elseif i <= 6 then
		-- 		shape = 3
		-- 	elseif i <= 8 then
		-- 		shape = 4
		-- 	else
		-- 		shape = 5
		-- 	end

		-- 	local offsetX = 0
		-- 	if lastShape > 0 then
		-- 		--todo
		-- 		offsetX = MY_CARD_SPACE_MATRIX[lastShape][shape]
		-- 	end

		-- 	oriX = oriX + offsetX

		-- 	local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, 1)

		-- 	local dict = {}
		-- 	dict.shape = shape
		-- 	dict.x = oriX + card:getSize().width * card:getScale() / 2

		-- 	if isOverMiddle then
		-- 		--todo
		-- 		dict.order = 20 - i
		-- 	else
		-- 		dict.order = i
		-- 	end
		-- 	if shape == CARD_MY_MIDDLE then
		-- 		--todo
		-- 		isOverMiddle = true
		-- 		dict.order = 20
		-- 	end

		-- 	secondRowDict[i] = dict

		-- 	oriX = oriX + card:getSize().width * card:getScale()

		-- 	lastShape = shape
		-- end
		-- secondRowDict.totalWidth = oriX
		-- MY_CARD_POSITION_MATRIX[2] = secondRowDict

		local oriX = 0
		local lastShape = 0
		local secondRowDict = {}
		local isOverMiddle = false
		for i = 1, 13 do
			local shape
			if i <= 3 then
				--todo
				shape = 1
			elseif i <= 6 then
				shape = 2
			elseif i <= 7 then
				shape = 3
			elseif i <= 10 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = MY_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_MY_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end

			secondRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		secondRowDict.totalWidth = oriX
		MY_CARD_POSITION_MATRIX[2] = secondRowDict

		local oriX = 0
		local lastShape = 0
		local thirdRowDict = {}
		local isOverMiddle = false
		for i = 1, 16 do
			local shape
			if i <= 4 then
				--todo
				shape = 1
			elseif i <= 7 then
				shape = 2
			elseif i <= 9 then
				shape = 3
			elseif i <= 12 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = MY_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_MY_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end

			thirdRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		thirdRowDict.totalWidth = oriX
		MY_CARD_POSITION_MATRIX[3] = thirdRowDict
		MY_CARD_POSITION_MATRIX.totalWidth = oriX
	end
end

function OuthandOperator:calPositionForLeftCards()
	if not LEFT_CARD_POSITION_MATRIX then
		--todo
		LEFT_CARD_POSITION_MATRIX = {}

		local card = Card:new(CARD_PLAYERTYPE_LEFT, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, 0, nil)
		local width = card:getSize().width * card:getScale()
		local height = card:getSize().height * card:getScale()
		local x_offset = LEFT_X_OFFSET * card:getScale()
		local y_offset = LEFT_Y_OFFSET * card:getScale()
		local row_x_offset = LEFT_ROW_X_OFFSET * card:getScale()
		
		for i=1,4 do

			local oriX = (i - 1) * (width - row_x_offset)
			local oriY = 0

			local rowDict = {}
			for j=1,10 do
				
				local scale = 1
				if i <= 3 and j >= 7 then
					--todo
					scale = LEFT_SCALE_OFFSET ^ (j - 6)
				end

				local dict = {}
				if i <=3 and j >= 7 then
					--todo
					dict.x = oriX + width / 2
				else
					dict.x = oriX + width * scale / 2
				end
				if i < 3 then
					--todo
					dict.x = dict.x + 4 * (3 - i)
				end
				dict.y = oriY + height * scale / 2
				dict.scale = scale
				dict.order = 20 - j + i * 100

				rowDict[j] = dict

				if i == 4 and j == 10 then
					--todo
					LEFT_CARD_POSITION_MATRIX.totalWidth = oriX + width * scale
				end

				oriX = oriX + x_offset * scale
				oriY = oriY + height * scale - y_offset * scale * LEFT_SCALE_OFFSET

			end

			LEFT_CARD_POSITION_MATRIX[i] = rowDict
		end

		
	end
end

function OuthandOperator:calPositionForRightCards()
	if not RIGHT_CARD_POSITION_MATRIX then
		--todo
		RIGHT_CARD_POSITION_MATRIX = {}

		local card = Card:new(CARD_PLAYERTYPE_RIGHT, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, 0, nil)
		local width = card:getSize().width * card:getScale()
		local height = card:getSize().height * card:getScale()
		local x_offset = RIGHT_X_OFFSET * card:getScale()
		local y_offset = RIGHT_Y_OFFSET * card:getScale()
		local row_x_offset = RIGHT_ROW_X_OFFSET * card:getScale()
		
		for i=1,4 do

			local oriX = (i - 1) * (width - row_x_offset)
			local oriY = 0

			local rowDict = {}
			for j=1,10 do
				
				local scale = 1
				if i >= 2 and j >= 7 then
					--todo
					scale = RIGHT_SCALE_OFFSET ^ (j - 6)
				end

				local dict = {}
				if i >= 2 and j >= 7 then
					--todo
					dict.x = oriX + width / 2
				else
					dict.x = oriX + width * scale / 2
				end
				if i > 2 then
					--todo
					dict.x = dict.x - 4 * (i - 2)
				end
				dict.y = oriY + height * scale / 2
				dict.scale = scale
				dict.order = 20 - j + (4 - i) * 100

				rowDict[j] = dict

				if i == 4 and j == 10 then
					--todo
					RIGHT_CARD_POSITION_MATRIX.totalWidth = oriX + width * scale
				end

				oriX = oriX - x_offset * scale
				oriY = oriY + height * scale - y_offset * scale * RIGHT_SCALE_OFFSET

			end

			RIGHT_CARD_POSITION_MATRIX[i] = rowDict
		end

		
	end
end

function OuthandOperator:calPositionForTopCards()
	if not TOP_CARD_POSITION_MATRIX then
		--计算出牌区域所有牌的定位
		TOP_CARD_POSITION_MATRIX = {}

		local oriX = 0
		local lastShape = 0
		local firstRowDict = {}
		local isOverMiddle = false
		for i = 1, 10 do
			local shape
			if i <= 2 then
				--todo
				shape = 1
			elseif i <= 4 then
				shape = 2
			elseif i <= 6 then
				shape = 3
			elseif i <= 8 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = TOP_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_TOP, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_TOP_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end
			firstRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		firstRowDict.totalWidth = oriX
		TOP_CARD_POSITION_MATRIX[1] = firstRowDict

		local oriX = 0
		local lastShape = 0
		local secondRowDict = {}
		local isOverMiddle = false
		for i = 1, 13 do
			local shape
			if i <= 3 then
				--todo
				shape = 1
			elseif i <= 6 then
				shape = 2
			elseif i <= 7 then
				shape = 3
			elseif i <= 10 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = TOP_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_TOP, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_TOP_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end

			secondRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		secondRowDict.totalWidth = oriX
		TOP_CARD_POSITION_MATRIX[2] = secondRowDict

		local oriX = 0
		local lastShape = 0
		local thirdRowDict = {}
		local isOverMiddle = false
		for i = 1, 16 do
			local shape
			if i <= 4 then
				--todo
				shape = 1
			elseif i <= 7 then
				shape = 2
			elseif i <= 9 then
				shape = 3
			elseif i <= 12 then
				shape = 4
			else
				shape = 5
			end

			local offsetX = 0
			if lastShape > 0 then
				--todo
				offsetX = TOP_CARD_SPACE_MATRIX[lastShape][shape]
			end

			oriX = oriX + offsetX

			local card = Card:new(CARD_PLAYERTYPE_TOP, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, shape, nil)

			local dict = {}
			dict.shape = shape
			dict.x = oriX + card:getSize().width * card:getScale() / 2

			if isOverMiddle then
				--todo
				dict.order = 20 - i
			else
				dict.order = i
			end
			if shape == CARD_MY_MIDDLE then
				--todo
				isOverMiddle = true
				dict.order = 20
			end

			thirdRowDict[i] = dict

			oriX = oriX + card:getSize().width * card:getScale()

			lastShape = shape
		end
		thirdRowDict.totalWidth = oriX
		TOP_CARD_POSITION_MATRIX[3] = thirdRowDict
		TOP_CARD_POSITION_MATRIX.totalWidth = oriX
	end
end

function OuthandOperator:playCard(playerType, cardValue, plane)

	local cardCount = plane:getChildrenCount()
	local index = cardCount + 1

	if playerType == CARD_PLAYERTYPE_MY then
		--todo

		plane:setSize(cc.size(MY_CARD_POSITION_MATRIX.totalWidth, plane:getSize().height))

		local row
		local col

		if index <= 10 then
			--todo
			row = 1
			col = index
		elseif index - 10 <= 13 then
			row = 2
			col = index - 10
		else
			row = 3
			col = index - 10 - 13
		end
		local dict = MY_CARD_POSITION_MATRIX[row][col]

		local cardNode = Card:new(CARD_PLAYERTYPE_MY, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, dict.shape, cardValue)

		local x = (MY_CARD_POSITION_MATRIX.totalWidth - MY_CARD_POSITION_MATRIX[row].totalWidth) / 2 + dict.x
		local y = plane:getSize().height - (row * cardNode:getSize().height * cardNode:getScale() - (row - 1) * MY_CARD_Y_OFFSET) + cardNode:getSize().height * cardNode:getScale() / 2
		cardNode:setPosition(x, y)

		cardNode:setLocalZOrder(row * 100 + dict.order)

		plane:addChild(cardNode)

		   -- local worldPoint = cardNode:convertToWorldSpace(cc.p(0, 0))
		   -- SZKWX_CARD_POINTER:setPosition(cc.p(worldPoint.x + cardNode:getSize().width / 2, worldPoint.y + cardNode:getSize().height + SZKWX_CARD_POINTER:getSize().height / 4))
		   -- SZKWX_CARD_POINTER:setVisible(true)

		D3_LATEST_OUT_CARD = cardNode
		D3_WAIT_OPRATE_CARD = cardNode

		return cardNode
	elseif playerType == CARD_PLAYERTYPE_LEFT then

		local size = plane:getSize()

		local row
		local col

		if index <= 5 then
			--todo
			row = 4
			col = 3 + (5 - index) + 1
		elseif index - 5 <= 10 then
			row = 3
			col = 10 - (index - 5) + 1
		elseif index - 5 - 10 <= 10 then
			row = 2
			col = 10 - (index - 5 - 10) + 1
		else
			row = 1
			col = 10 - (index - 5 - 10 - 10) + 1
		end

		local cardNode = Card:new(CARD_PLAYERTYPE_LEFT, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, 0, cardValue)

		local dict = LEFT_CARD_POSITION_MATRIX[row][col]
		
		local x = size.width - (LEFT_CARD_POSITION_MATRIX.totalWidth - dict.x)
		local y = dict.y
		cardNode:setScale(dict.scale)
		cardNode:setLocalZOrder(dict.order)
		cardNode:setPosition(cc.p(x-25, y-25))  --6月28日修改牌尺寸

		plane:addChild(cardNode)

		   -- local worldPoint = cardNode:convertToWorldSpace(cc.p(0, 0))
		   -- SZKWX_CARD_POINTER:setPosition(cc.p(worldPoint.x + cardNode:getSize().width / 2, worldPoint.y + cardNode:getSize().height + SZKWX_CARD_POINTER:getSize().height / 4))
		   -- SZKWX_CARD_POINTER:setVisible(true)

		   D3_LATEST_OUT_CARD = cardNode
		   D3_WAIT_OPRATE_CARD = cardNode

		   return cardNode
	elseif playerType == CARD_PLAYERTYPE_RIGHT then
		local row
		local col

		if index <= 5 then
			--todo
			row = 1
			col = 3 + index
		elseif index - 5 <= 10 then
			row = 2
			col = index - 5
		elseif index - 5 - 10 <= 10 then
			row = 3
			col = index - 5 - 10
		else
			row = 4
			col = index - 5 - 10 - 10
		end

		local cardNode = Card:new(CARD_PLAYERTYPE_RIGHT, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, 0, cardValue)

		local dict = RIGHT_CARD_POSITION_MATRIX[row][col]
		
		local x = dict.x
		local y = dict.y
		cardNode:setScale(dict.scale)
		cardNode:setLocalZOrder(dict.order)
		cardNode:setPosition(cc.p(x+5, y-28))  --6月28日修改牌尺寸

		plane:addChild(cardNode)

		D3_LATEST_OUT_CARD = cardNode
		D3_WAIT_OPRATE_CARD = cardNode

		return cardNode
	elseif playerType == CARD_PLAYERTYPE_TOP then   

		plane:setSize(cc.size(TOP_CARD_POSITION_MATRIX.totalWidth, plane:getSize().height))

		local row
		local col

		local dict

		if index <= 10 then
			--todo
			row = 1
			col = index

			dict = TOP_CARD_POSITION_MATRIX[row][10 + 1 - col]
		elseif index - 10 <= 13 then
			row = 2
			col = index - 10

			dict = TOP_CARD_POSITION_MATRIX[row][13 + 1 - col]
		else
			row = 3
			col = index - 10 - 13

			dict = TOP_CARD_POSITION_MATRIX[row][16 + 1 - col]
		end

		local cardNode = Card:new(CARD_PLAYERTYPE_TOP, CARD_TYPE_OUTHAND, CARD_DISPLAY_TYPE_SHOW, dict.shape, cardValue)

		local x = (TOP_CARD_POSITION_MATRIX.totalWidth - TOP_CARD_POSITION_MATRIX[row].totalWidth) / 2 + dict.x
		local y = (cardNode:getSize().height * cardNode:getScale() - TOP_CARD_Y_OFFSET) * (row - 1) + cardNode:getSize().height * cardNode:getScale() / 2 
		cardNode:setPosition(x, y - 30)       --6月28日修改牌尺寸
		cardNode:setLocalZOrder((4 - row) * 100 + dict.order)

		plane:addChild(cardNode)

		D3_LATEST_OUT_CARD = cardNode
		D3_WAIT_OPRATE_CARD = cardNode

		return cardNode
	end

	return nil
end

return OuthandOperator