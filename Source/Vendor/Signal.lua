local Connection = require("Vendor.Connection")

local Signal = { }

Signal.Type = "Signal"

Signal.Interface = { }
Signal.Prototype = { }

function Signal.Prototype:Once(callbackFn)
    local connection

    connection = self:Connect(function(...)
        connection:Disconnect()

        callbackFn(...)
    end)
end

function Signal.Prototype:Connect(callbackFn)
    return Connection.new(callbackFn, function(connectionObject)
        table.remove(self._connections, connectionObject)
    end, function(connectionObject)
        table.insert(self._connections, connectionObject)
    end)
end

function Signal.Prototype:Wait()
    local currentCoroutine = coroutine.running()

    self:Once(function(...)
        coroutine.resume(currentCoroutine, ...)
    end)

    return coroutine.yield()
end

function Signal.Prototype:GetConnections()
    return self._connections
end

function Signal.Prototype:DisconnectAll()
    for _, connection in next, self._connections do
        connection:Disconnect()
    end

    table.clear(self._connections)
end

function Signal.Prototype:Destroy()
    self:DisconnectAll()

    setmetatable(self, { __mode = "kv" })
end

function Signal.Prototype:Invoke(...)
    for _, connection in next, self._connections do
        coroutine.spawn(connection.Invoke, connection, ...)
    end
end

function Signal.Prototype:ToString()
    return string.format("%s<#%d connections>", Signal.Type, #self._connections)
end

function Signal.Interface.new()
    return setmetatable({
        _connections = { }
    }, {
        __index = Signal.Prototype,
        __type = Signal.Type,

        __tostring = function(self)
            return self:ToString()
        end
    })
end

return Signal.Interface