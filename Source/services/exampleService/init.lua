local singleton = require("vendor.singleton")

local exampleService = singleton.new({
	name = "exampleService",
})

function exampleService:init()
	self.renderService = singleton.getInstance("renderService")
end

function exampleService:start()
	self.renderService.onRender:listen(function()
		love.graphics.print("Hello World!", 400, 300)
	end)
end

return exampleService