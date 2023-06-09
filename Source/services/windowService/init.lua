local singleton = require("vendor.singleton")
local state = require("vendor.state")
local vector2 = require("vendor.vector2")

local windowService = singleton.new({
	name = "windowService",

	isFocused = state.new(false),

	windowTitle = state.new(false),
	windowIcon = state.new(false),

	windowSize = state.new(vector2.new(0, 0)),
	windowSettings = state.new({ })
})

function windowService:_applyWindowChanges()
	love.window.setMode(
		self.windowSize.value.x,
		self.windowSize.value.y,

		self.windowSettings.value
	)
end

function windowService:setWindowIcon(iconPath)
	self.windowIcon:set(iconPath)
end

function windowService:setWindowTitle(titleMessage)
	self.windowTitle:set(titleMessage)
end

function windowService:setWindowSize(sizeVector)
	self.windowSize:set(sizeVector)
end

function windowService:setWindowSettings(settings)
	self.windowSettings:update(function(state)
		return table.merge(state, settings)
	end)
end

function windowService:init()
	love.window.setDisplaySleepEnabled(false)

	self:setWindowSize(vector2.new(1280, 720))
	self:setWindowSettings({
		fullscreen = false,
		fullscreentype = "desktop",

		vsync = 1,
		msaa = 2,
		stencil = true,
		depth = 0,

		resizable = false,
		borderless = false,
		centered = true,
	})
end

function windowService:start()
	self.windowTitle:observe(function()
		love.window.setTitle(self.windowTitle.value)
	end)

	self.windowIcon:observe(function()
		if not self.windowIcon.value then
			return
		end

		love.window.setIcon(
			love.image.newImageData(self.windowIcon.value)
		)
	end)

	self.windowSettings:observe(function()
		self:_applyWindowChanges()
	end)

	self.windowSize:observe(function()
		self:_applyWindowChanges()
	end)

	if self.windowTitle.value then
		love.window.setTitle(self.windowTitle.value)
	end

	if self.windowIcon.value then
		love.window.setIcon(
			love.image.newImageData(self.windowIcon.value)
		)
	end

	self:_applyWindowChanges()
end

return windowService