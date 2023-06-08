local Framework = require("Vendor.Framework")

_G.table = require("Globals.Table")
_G.coroutine = require("Globals.Coroutine")
_G.love = require("Globals.Love")

love.loadChildren("Services")

Framework:InvokeLifecycle("Init")

Framework:GetService("SchedulerService").PostRender:Once(function()
    Framework:InvokeLifecycle("Start")
end)