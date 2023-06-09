local singleton = require("vendor.singleton")
local state = require("vendor.state")

local physicsService = singleton.new({
	name = "physicsService"
})

function physicsService:onSchedulerUpdate()
	
end

return physicsService