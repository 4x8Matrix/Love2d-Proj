local singleton = require("vendor.singleton")
local signal = require("vendor.signal")

local renderService = singleton.new({
	name = "renderService",

	onRender = signal.new(),
	onPostRender = signal.new()
})

function renderService:onSchedulerUpdate()
	if not love.graphics.isActive() then
		return
	end

	love.graphics.origin()
	love.graphics.clear(love.graphics.getBackgroundColor())

	self.onRender:invoke()

	love.graphics.present()

	self.onPostRender:invoke()
end

return renderService