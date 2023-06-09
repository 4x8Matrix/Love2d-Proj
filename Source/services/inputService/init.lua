local singleton = require("vendor.singleton")
local state = require("vendor.state")
local signal = require("vendor.signal")
local vector2 = require("vendor.vector2")

local inputService = singleton.new({
	name = "inputService",

	keyButtonStates = state.new({ }),
	mouseButtonStates = state.new({ }),

	onKeyboardInputPressed = signal.new(),
	onKeyboardInputReleased = signal.new(),

	onMouseInputPressed = signal.new(),
	onMouseInputReleased = signal.new()
})

function inputService:isKeyDown(key)
	return self.keyButtonStates.value[key]
end

function inputService:isMouseButtonDown(button)
	return self.mouseButtonStates.value[button]
end

function inputService:init()
	self.schedulerService = singleton.getInstance("schedulerService")
end

function inputService:start()
	self.schedulerService:onEvent("keypressed", function(key)
		self.onKeyboardInputPressed:invoke(key)

		self.keyButtonStates:update(function(state)
			state[key] = true

			return state
		end)
	end)

	self.schedulerService:onEvent("keyreleased", function(key)
		self.onKeyboardInputReleased:invoke(key)

		self.keyButtonStates:update(function(state)
			state[key] = nil

			return state
		end)
	end)

	self.schedulerService:onEvent("mousepressed", function(x, y, mouseButton, isScreen)
		if isScreen then
			return
		end

		self.onMouseInputPressed:invoke(vector2.new(x, y), mouseButton)

		self.mouseButtonStates:update(function(state)
			state[mouseButton] = true

			return state
		end)
	end)

	self.schedulerService:onEvent("mousereleased", function(x, y, mouseButton, isScreen)
		if isScreen then
			return
		end

		self.onMouseInputReleased:invoke(vector2.new(x, y), mouseButton)

		self.mouseButtonStates:update(function(state)
			state[mouseButton] = nil

			return state
		end)
	end)
end

function inputService:onSchedulerUpdate()
	
end

return inputService