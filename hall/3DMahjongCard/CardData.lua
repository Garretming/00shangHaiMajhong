local DCardData = class("DCardData")

function DCardData:ctor(this, value, orderSeq, type, fromplayerType)
	self.m_value = value
	self.orderSeq = orderSeq
	self.type = type
	self.fromplayerType = fromplayerType or 0
end

return DCardData