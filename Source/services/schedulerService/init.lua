local singleton = require("vendor.singleton")
local state = require("vendor.state")
local signal = require("vendor.signal")

local schedulerService = singleton.new({
	name = "schedulerService",

	targetFPS = state.new(60),
	deltaTime = state.new(0),

	onHeartbeat = signal.new(),
	onLoveEvent = signal.new(),

	_yieldingRoutines = { },
	_spawnedRoutines = { }
})

function schedulerService:_blockThreadFor(target)
	local clockSnapshot = os.clock()

	while os.clock() - clockSnapshot < target do end

	return os.clock() - clockSnapshot
end

function schedulerService:_resumeAwaitingRoutines(deltaTime)
	for routine, infomation in next, self._yieldingRoutines do
		local clockSnapshot = os.clock() - infomation[1]

		if clockSnapshot > infomation[2] then
			coroutine.resume(routine, clockSnapshot, deltaTime)

			self._yieldingRoutines[routine] = nil
		end
	end
end

function schedulerService:_resumeSpawnedRoutines()
	for routine, parameters in next, self._spawnedRoutines do
		self._spawnedRoutines[routine] = nil

		coroutine.resume(routine, table.unpack(parameters))
	end
end

function schedulerService:_readLove2dPolledEvents()
	love.event.pump()

	local eventMessageIterator = love.event.poll()
	local eventMessages = { eventMessageIterator() }

	while #eventMessages ~= 0 do
		self.onLoveEvent:invoke(table.unpack(eventMessages))

		eventMessages = { eventMessageIterator() }
	end
end

function schedulerService:onEvent(targetEventName, callbackFn)
	return self.onLoveEvent:listen(function(eventName, ...)
		if eventName ~= targetEventName then
			return
		end

		callbackFn(...)
	end)
end

function schedulerService:yieldFor(int)
	self._yieldingRoutines[coroutine.running()] = { os.clock(), int }

	return coroutine.yield()
end

function schedulerService:resumeIn(int, callbackFn, ...)
	return self:spawn(function(...)
		self:yieldFor(int)

		callbackFn(...)
	end, ...)
end

function schedulerService:spawn(callbackFn, ...)
	local routine = coroutine.create(callbackFn)

	self._spawnedRoutines[routine] = { ... }

	return routine
end

function schedulerService:init()
	self.inputService = singleton.getInstance("inputService")
	self.renderService = singleton.getInstance("renderService")
	self.physicsService = singleton.getInstance("physicsService")

	function love.run()
		local frameAlphaValue = 1

		return function()
			self:_readLove2dPolledEvents()

			self.inputService:onSchedulerUpdate(self.deltaTime.value)
			self.renderService:onSchedulerUpdate(self.deltaTime.value)
			self.physicsService:onSchedulerUpdate(self.deltaTime.value)

			self:_resumeSpawnedRoutines()
			self.onHeartbeat:invoke(self.deltaTime.value)

			if frameAlphaValue == 1 then
				frameAlphaValue = 2

				self:_resumeAwaitingRoutines(self.deltaTime.value)
			else
				frameAlphaValue = 1
			end

			self.deltaTime.value = self:_blockThreadFor(1 / self.targetFPS.value)
		end
	end
end

return schedulerService