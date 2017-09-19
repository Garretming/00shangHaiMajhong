local Card = class("Card", function ()
	return ccui.Button:create()
	end)

function Card:ctor(this, playerType, cardType, cardDisplayType, shape, cardData, fromplayerType)

	self.body = display.newSprite():addTo(self)

	self.ext = display.newSprite():addTo(self)

	self.arrow = display.newSprite():addTo(self)

	self:setCard(playerType, cardType, cardDisplayType, shape, cardData,fromplayerType)

end

function Card:compare(card1, card2)

	if card1 == nil then
		return 1
	end

	if card1.orderSeq > card2.orderSeq then
		--todo
		return 1

	elseif card1.orderSeq == card2.orderSeq then
		if card1.m_value > card2.m_value then
			--todo
			return 1
		elseif card1.m_value == card2.m_value then
			return 0
		else
			return -1
		end

	else
		return -1
	end
end

function Card:setCard(playerType, cardType, cardDisplayType, shape, cardData, fromplayerType)
	self.m_playerType = playerType
	self.m_cardType = cardType
	self.m_cardDisplayType = cardDisplayType
	self.m_shape = shape
	self.m_fromplayerType = fromplayerType

	if cardData then
		self.m_value = cardData.m_value
		self.orderSeq = cardData.orderSeq
		self.type = cardData.type
		self.fromplayerType = cardData.fromplayerType
	else
		self.m_value = 0
		self.orderSeq = 0
		self.type = CARDNODE_NORMAL
		self.fromplayerType = CARD_PLAYERTYPE_MY
	end

	self:initView()
end

function Card:setShape(shape)
	self.m_shape = shape

	self:initView()
end

function Card:initView()

	self:loadTextureNormal("hall/3DMahjongCard/image/p_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. "_" .. self.m_shape .. ".png")
	self:loadTextureDisabled("hall/3DMahjongCard/image/p_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. "_" .. self.m_shape .. ".png")

	if self.m_value == 0 then
		return
	end

	local vvv=  {
		self.m_playerType,
		self.m_cardType,
		self.m_cardDisplayType,
		self.m_shape,
		self.m_fromplayerType
	}
	-- dump(vvv,"ansnsnssnsnsndndn------------------")

	if self.m_playerType == CARD_PLAYERTYPE_MY then
		-- dump(CARD_PLAYERTYPE_MY,"zhheheheeheheh-------------1111")
		self.body:setTexture("hall/3DMahjongCard/image/" .. self.m_value .. "_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. ".png")

		if self.m_cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then

			self.body:setPosition(cc.p(42, 51.5))

		elseif self.m_cardDisplayType == CARD_DISPLAY_TYPE_SHOW then

			if self.m_cardType == CARD_TYPE_INHAND then

				local r = 0

				if self.m_shape == 1 then
					r = 8
					self.body:setPosition(cc.p(self:getSize().width / 2 - 3, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 2 then
					r = 6
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 3 then
					r = 4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 5 then
					r = -4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 6 then
					r = -6
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 7 then
					r = -8
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				else
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				end

				self.body:setRotationSkewX(r)

			elseif self.m_cardType == CARD_TYPE_OUTHAND then
				local r = 0

				if self.m_shape == 1 then

					r = 6
					self.body:setPosition(cc.p(self:getSize().width / 2 - 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 2 then
					r = 4
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 4 then
					r = -4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 5 then
					r = -6
					self.body:setPosition(cc.p(self:getSize().width / 2 + 1, self:getSize().height - self.body:getContentSize().height / 2))
				else
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				end

				self.body:setRotationSkewX(r)

			end

			--碰杠牌指向
			if self.m_fromplayerType then
				-- self:addArrow(self.body)
				self:showArrow(self.m_fromplayerType)
			end

		end




	elseif self.m_playerType == CARD_PLAYERTYPE_LEFT then   --碰杠区 1

	-- dump(CARD_PLAYERTYPE_LEFT,"zhheheheeheheh-------------333333311")

		if self.m_cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then

			self.body:setVisible(false)
		elseif self.m_cardDisplayType == CARD_DISPLAY_TYPE_SHOW then
			self.body:setVisible(true)
			--   m_playerType  玩家位置    m_cardType 玩家牌位置 
			self.body:setTexture("hall/3DMahjongCard/image/" .. self.m_value .. "_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. ".png")
			self.body:setPosition(cc.p(self:getSize().width / 2 + 2, self:getSize().height - self.body:getContentSize().height / 2 + 1))
		     
		     --碰杠牌指向
			if self.m_fromplayerType then
				-- local arrow =
				-- self:addArrow(self.body)
				self:showArrow(self.m_fromplayerType)
				-- arrow:rotateBy(0,-90)
			end		
		end

	elseif self.m_playerType == CARD_PLAYERTYPE_RIGHT then
	-- dump(CARD_PLAYERTYPE_RIGHT,"zhheheheeheheh-------------333333311")

		if self.m_cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then

			self.body:setVisible(false)
		elseif self.m_cardDisplayType == CARD_DISPLAY_TYPE_SHOW then
			self.body:setVisible(true)

			self.body:setTexture("hall/3DMahjongCard/image/" .. self.m_value .. "_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. ".png")
			self.body:setPosition(cc.p(self:getSize().width / 2 + 1, self:getSize().height - self.body:getContentSize().height / 2))
			
			--碰杠牌指向
			if self.m_fromplayerType then
				-- local arrow =
				-- self:addArrow(self.body)
				self:showArrow(self.m_fromplayerType)
				-- arrow:rotateBy(0,90)
			end
		end

	elseif self.m_playerType == CARD_PLAYERTYPE_TOP then
		if self.m_cardDisplayType == CARD_DISPLAY_TYPE_OPPOSIVE then
			self.body:setVisible(false)

		elseif self.m_cardDisplayType == CARD_DISPLAY_TYPE_SHOW then

			self.body:setVisible(true)
			self.body:setTexture("hall/3DMahjongCard/image/" .. self.m_value .. "_" .. self.m_playerType .. "_" .. self.m_cardType .. "_" .. self.m_cardDisplayType .. ".png")
			
			if self.m_cardType == CARD_TYPE_INHAND then
				--todo
				local r = 0

				if self.m_shape == 1 then
					--todo
					r = 6
					self.body:setPosition(cc.p(self:getSize().width / 2 - 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 2 then
					r = 4
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 4 then
					r = -4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 5 then
					r = -6
					self.body:setPosition(cc.p(self:getSize().width / 2 + 1, self:getSize().height - self.body:getContentSize().height / 2))
				else
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				end

				self.body:setRotationSkewX(r)

				
			elseif self.m_cardType == CARD_TYPE_OUTHAND then
				self.body:setScale(1.2)     --6月28日修改  
				
				local r = 0

				if self.m_shape == 1 then

					r = 6
					self.body:setPosition(cc.p(self:getSize().width / 2 - 2, self:getSize().height - self.body:getContentSize().height / 2 - 3))
				
				elseif self.m_shape == 2 then
					r = 4
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2 - 3))
				
				elseif self.m_shape == 4 then
					r = -4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2 - 3))
				elseif self.m_shape == 5 then
					r = -6
					self.body:setPosition(cc.p(self:getSize().width / 2 + 1, self:getSize().height - self.body:getContentSize().height / 2 -3 ))
				else
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2 -3 ))
				end

				self.body:setRotationSkewX(r)


			elseif self.m_cardType == CARD_TYPE_LEFTHAND then
				local r = 0

				if self.m_shape == 1 then
					--todo
					r = 6
					self.body:setPosition(cc.p(self:getSize().width / 2 - 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 2 then
					r = 4
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 4 then
					r = -4
					self.body:setPosition(cc.p(self:getSize().width / 2, self:getSize().height - self.body:getContentSize().height / 2))
				elseif self.m_shape == 5 then
					r = -6
					self.body:setPosition(cc.p(self:getSize().width / 2 + 1, self:getSize().height - self.body:getContentSize().height / 2))
				else
					self.body:setPosition(cc.p(self:getSize().width / 2 - 1, self:getSize().height - self.body:getContentSize().height / 2))
				end

				self.body:setRotationSkewX(r)
			end

			             --碰杠牌指向
			if self.m_fromplayerType then
				-- local arrow = 
				-- self:addArrow(self.body)
				self:showArrow(self.m_fromplayerType)
				-- arrow:rotateBy(0, -180)
			end
		end
	end

	self:setColor(cc.c3b(255, 255, 255))

	if self.m_cardDisplayType ~= CARD_DISPLAY_TYPE_HIDE then
		--todo
		if self.type > CARDNODE_TYPE_NORMAL then
			--todo
			self:showExt()

			self:setColor(cc.c3b(150, 150, 255))
		else
			self.ext:setVisible(false)
		end
	else
		self.body:setVisible(false)
		self.ext:setVisible(false)
	end

	--显示操作指向
	-- if self.fromplayerType == 0 then
		self.arrow:setVisible(false)
	
		if self.m_fromplayerType then
			--todo
			self:showArrow(self.m_fromplayerType)
		elseif self.fromplayerType and self.fromplayerType > 0 then
			self:showArrow(self.fromplayerType)
		end
	-- else
		
	
	-- end

end

function Card:showExt()
	self.ext:setVisible(true)
	self.ext:setTexture("hall/3DMahjongCard/image/ext_" .. self.type .. ".png")

	self.ext:setPosition(cc.p(self:getSize().width - self.ext:getContentSize().width / 2, self:getSize().height - self.ext:getContentSize().height / 2))
end


-- function Card:addArrow(node,SkewXr)

-- 	-- local arrow = cc.Sprite:create("hall/3DMahjongCard/image/jiantou_4.png")
-- 	-- arrow:setPosition(cc.p(self:getSize().width/2,self:getSize().height/2))
-- 	-- arrow:setScale(1)
-- 	-- arrow:setName("arrow")
-- 	-- node:addChild(arrow)

-- 	-- local rotation = 180
-- 	-- if self.m_fromplayerType == CARD_PLAYERTYPE_TOP then 
-- 	-- 	rotation = 0  
-- 	-- elseif self.m_fromplayerType == CARD_PLAYERTYPE_LEFT then 
-- 	-- 	rotation = -90  
-- 	-- elseif self.m_fromplayerType == CARD_PLAYERTYPE_RIGHT then 
-- 	-- 	rotation = 90  
-- 	-- end

-- 	-- arrow:setRotation(rotation)

-- 	-- return arrow

-- 	-- local arrow_pic = "hall/3DMahjongCard/image/jiantou_"..self.m_fromplayerType..".png"
    
--     -- local isShowArrow = ISSHOWARROW or false

--     -- if not isShowArrow then
--     -- 	return
--     -- end
    
--     local SkewXr =  SkewXr or 0
--     local node = node or self.body
--     local arrow = cc.Sprite:create("hall/3DMahjongCard/image/jiantou_"..self.m_fromplayerType..".png")
-- 	arrow:setPosition(cc.p(self:getSize().width/2,self:getSize().height/2))

-- 	local minSize = self:getSize().width
-- 	if minSize > self:getSize().height then
-- 		minSize = self:getSize().height
-- 	end

-- 	arrow:setScale((minSize - 10) / arrow:getContentSize().width)
-- 	arrow:setName("arrow")
-- 	arrow:setRotationSkewX(SkewXr)
-- 	node:addChild(arrow)

-- 	-- local rotation = 180
-- 	-- if self.m_fromplayerType == CARD_PLAYERTYPE_TOP then 
-- 	-- 	rotation = 0  
-- 	-- elseif self.m_fromplayerType == CARD_PLAYERTYPE_LEFT then 
-- 	-- 	rotation = -90  
-- 	-- elseif self.m_fromplayerType == CARD_PLAYERTYPE_RIGHT then 
-- 	-- 	rotation = 90  
-- 	-- end

-- 	-- arrow:setRotation(rotation)

-- 	return arrow
-- end

function Card:addArrow(node,SkewXr)
    
    -- local isShowArrow = ISSHOWARROW or false
    -- if not isShowArrow then
    -- 	return
    -- end
    
 --    local SkewXr =  SkewXr or 0
 --    local node = node or self.body
 --    local arrow = cc.Sprite:create("hn_majiang/3DMahjongCard/image/jiantou_"..self.m_fromplayerType..".png")
	
 --    if self.m_playerType == CARD_PLAYERTYPE_MY then
 --    	arrow:setPosition(cc.p(self:getSize().width/2,self:getSize().height+14))
	-- elseif self.m_playerType == CARD_PLAYERTYPE_LEFT then
 --    	arrow:setPosition(cc.p(self:getSize().width+8,0))
	-- elseif self.m_playerType == CARD_PLAYERTYPE_RIGHT then
 --    	arrow:setPosition(cc.p(-8,0))
	-- elseif self.m_playerType == CARD_PLAYERTYPE_TOP then
 --    	arrow:setPosition(cc.p(self:getSize().width/2,-18))
 --    end

	-- local minSize = self:getSize().width
	-- if minSize > self:getSize().height then
	-- 	minSize = self:getSize().height
	-- end

	-- arrow:setScale((minSize - 20) / arrow:getContentSize().width)
	-- arrow:setName("arrow")
	-- arrow:setRotationSkewX(SkewXr)
	-- node:addChild(arrow)

	-- return arrow
end

function Card:showArrow(fromplayerType)
	if fromplayerType and fromplayerType > 0 then
		-- self.arrow:setVisible(true)
		-- self.arrow:setTexture("hall/3DMahjongCard/image/arrow_" .. fromplayerType .. ".png")

		-- self.arrow:setPosition(cc.p(self:getSize().width / 2, self:getSize().height / 2 + 10))

		self.arrow:setVisible(true)
		self.arrow:setTexture("hall/3DMahjongCard/image/arrow_" .. fromplayerType .. ".png")

		self.arrow:setPosition(cc.p(self:getSize().width - self.arrow:getContentSize().width / 2 - 10, self:getSize().height - self.ext:getContentSize().height / 2))

	else
		self.arrow:setVisible(false)
	end

	
end

return Card