local connection = { }

connection.type = "connection"

connection.interface = { }
connection.prototype = { }

function connection.prototype:disconnect()
	self.Connected = false

	self._disconnectFn(self)
end

function connection.prototype:reconnect()
	self.Connected = true

	self._reconnectFn(self)
end

function connection.prototype:invoke(...)
	if not self.Connected then
		return
	end

	return coroutine.resume(self._routine, ...)
end

function connection.prototype:toString()
	return string.format("%s<%s>", connection.type, tostring(self._callbackFn))
end

function connection.interface.new(callbackFn, disconnectFn, reconnectFn)
	local self = setmetatable({
		Connected = true,

		_callbackFn = callbackFn,

		_reconnectFn = reconnectFn,
		_disconnectFn = disconnectFn
	}, {
		__index = connection.prototype,
		__type = connection.type,

		__tostring = function(self)
			return self:toString()
		end
	})

	self:reconnect()

	self._routine = coroutine.create(function(...)
		local args = { ... }

		while true do
			args = { coroutine.yield(self._callbackFn(table.unpack(args))) }
		end
	end)

	return self
end

return connection.interface