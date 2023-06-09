local Connection = require("vendor.connection")

local signal = { }

signal.type = "signal"

signal.interface = { }
signal.prototype = { }

function signal.prototype:once(callbackFn)
	local connection

	connection = self:listen(function(...)
		connection:Disconnect()

		callbackFn(...)
	end)
end

function signal.prototype:listen(callbackFn)
	return Connection.new(callbackFn, function(connectionObject)
		table.removeValue(self._connections, connectionObject)
	end, function(connectionObject)
		table.insert(self._connections, connectionObject)
	end)
end

function signal.prototype:yield()
	local currentCoroutine = coroutine.running()

	self:once(function(...)
		coroutine.resume(currentCoroutine, ...)
	end)

	return coroutine.yield()
end

function signal.prototype:getConnections()
	return self._connections
end

function signal.prototype:disconnectAll()
	for _, connection in next, self._connections do
		connection:Disconnect()
	end

	table.clear(self._connections)
end

function signal.prototype:invoke(...)
	for _, connection in next, self._connections do
		connection:invoke(...)
	end
end

function signal.prototype:toString()
	return string.format("%s<#%d connections>", signal.type, #self._connections)
end

function signal.interface.new()
	return setmetatable({
		_connections = { }
	}, {
		__index = signal.prototype,
		__type = signal.type,

		__tostring = function(self)
			return self:toString()
		end
	})
end

return signal.interface