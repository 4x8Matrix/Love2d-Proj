local singleton = require("vendor.singleton")
local state = require("vendor.state")

local entrypointService = singleton.new({
	name = "entrypointService",

	isLoaded = state.new(false)
})

function entrypointService:initialiseEnvironment()
	_VERSION = string.format("%s - %s", _VERSION, love.getVersion())

	love = require("environment.love")
	table = require("environment.table")
end

function entrypointService:invokeServiceLifecycle(methodName, ...)
	local serviceInstances = singleton.getInstances()

	table.sort(serviceInstances, function(service0, service1)
		if not service1.priority then
			return false
		end

		if not service0.priority then
			return true
		end

		return service0.priority > service1.priority
	end)

	for _, singletonObject in next, serviceInstances do
		if singletonObject[methodName] then
			singletonObject[methodName](singletonObject, ...)
		end
	end
end

function entrypointService:startGame()
	self:initialiseEnvironment()

	love.loadChildren("services")
	love.loadChildren("components")

	coroutine.wrap(function()
		self:invokeServiceLifecycle("init")
		self:invokeServiceLifecycle("start")

		self.isLoaded:set(true)
	end)()
end

return entrypointService