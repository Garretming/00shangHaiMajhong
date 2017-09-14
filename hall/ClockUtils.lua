local ClockUtils = class("ClockUtils")

PINT_TIME = 0

local sendCount = 0
local receiveCount = 0
local latestSendTime = os.clock()

function ClockUtils:start()
	PINT_TIME = 0
	sendCount = 0
	receiveCount = 0
	latestSendTime = os.clock()

	-- dump(latestSendTime, "test 0420")
end

function ClockUtils:send()
	sendCount = sendCount + 1

	latestSendTime = os.clock()

	if sendCount - receiveCount > 1 then
		--todo
		PINT_TIME = 2000
	end

	-- dump(PINT_TIME, "test 0420 ping ms")
end

function ClockUtils:receive()
	receiveCount = receiveCount + 1

	if sendCount - receiveCount > 0 then
		--todo
		PINT_TIME = 2000
	else
		local currentClock = os.clock()

		-- dump(currentClock, "test 0420")

		local offset = currentClock - latestSendTime

		if offset < 0 then
			--todo
			offset = offset + 60
		end

		PINT_TIME = offset * 1000
	end

	-- dump(PINT_TIME, "test 0420 ping ms")
end

return ClockUtils