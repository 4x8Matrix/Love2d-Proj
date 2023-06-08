local Connection = { }

Connection.Type = "Connection"

Connection.Interface = { }
Connection.Prototype = { }

function Connection.Prototype:Disconnect()
    self.Connected = false

    self._disconnectFn(self)
end

function Connection.Prototype:Reconnect()
    self.Connected = true

    self._reconnectFn(self)
end

function Connection.Prototype:Destroy()
    self.Connected = false

    self._disconnectFn(self)

    setmetatable(self, { __mode = "kv" })
end

function Connection.Prototype:Invoke(...)
    if not self.Connected then
        return
    end

    return self._callbackFn(...)
end

function Connection.Prototype:ToString()
    return string.format("%s<%s>", Connection.Type, tostring(self._callbackFn))
end

function Connection.Interface.new(callbackFn, disconnectFn, reconnectFn)
    local self = setmetatable({
        Connected = true,

        _callbackFn = callbackFn,

        _reconnectFn = reconnectFn,
        _disconnectFn = disconnectFn
    }, {
        __index = Connection.Prototype,
        __type = Connection.Type,

        __tostring = function(self)
            return self:ToString()
        end
    })

    self:Reconnect()

    return self
end

return Connection.Interface