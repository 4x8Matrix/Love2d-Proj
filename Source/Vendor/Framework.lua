local Singleton = require("Vendor.Singleton")

local Framework = { }

Framework.Interface = { }

function Framework.Interface:GetService(serviceName)
    return Singleton.fetch(serviceName)
end

function Framework.Interface:InvokeLifecycle(methodName, ...)
    for _, singletonObject in next, Singleton.fetchAll() do
        singletonObject:InvokeLifecycle(methodName)
    end
end

return Framework.Interface