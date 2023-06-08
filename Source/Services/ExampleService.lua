local Singleton = require("Vendor.Singleton")
local Framework = require("Vendor.Framework")

local ExampleService = Singleton.new({
    Name = "ExampleService"
})

function ExampleService:Start()
    self.SchedulerService.Render:Connect(function(...)
        love.graphics.print("Hello World!", 400, 300)
    end)
end

function ExampleService:Init()
    self.SchedulerService = Framework:GetService("SchedulerService")
end