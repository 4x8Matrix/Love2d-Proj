local Framework = require("Vendor.Framework")
local Singleton = require("Vendor.Singleton")
local Signal = require("Vendor.Signal")
local State = require("Vendor.State")

local SchedulerService = Singleton.new({
    Name = "SchedulerService",

    Internal = { },

    TargetFPS = State.new(60),

    Update = Signal.new(),

    PreRender = Signal.new(),
    Render = Signal.new(),
    PostRender = Signal.new()
})

function SchedulerService.Internal:UpdateLove2dEventPoll()
    love.event.pump()

    self.Service.Update:Invoke(self.DeltaTime or 0)
end

function SchedulerService.Internal:UpdateLove2dGraphicsLib()
    self.Service.PreRender:Invoke(self.DeltaTime or 0)

    love.graphics.origin()
    love.graphics.clear(love.graphics.getBackgroundColor())

    self.Service.Render:Invoke(self.DeltaTime or 0)

    love.graphics.present()

    self.Service.PostRender:Invoke(self.DeltaTime or 0)
end

function SchedulerService:Init()
    function love.run()
        local snapshot = os.clock()

        self.Internal.DeltaTime = 1 / self.TargetFPS:Get()

        Framework:InvokeLifecycle("Start")

        return function()
            self.Internal:UpdateLove2dEventPoll()
            self.Internal:UpdateLove2dGraphicsLib()

            love.timer.sleep(1 / self.TargetFPS:Get())

            local newSnapshot = os.clock()

            self.Internal.DeltaTime = newSnapshot - snapshot
            snapshot = newSnapshot
        end
    end
end

return SchedulerService