local signal = require("vendor.signal")

local MAX_RECORD_ALLOCATION = 15

local state = { }

state.type = "state"

state.interface = { }
state.prototype = { }

function state.prototype:setRecordingState(state)
	self._recording = state

	return self
end

function state.prototype:getRecord(count)
	if not count then
		return self._record
	end

	local record = {}

	for index = 1, count do
		record[index] = self._record[index]
	end

	return record
end

function state.prototype:set(value)
	local oldValue = self.value

	if self._recording then
		table.insert(self._record, 1, value)

		if #self._record > MAX_RECORD_ALLOCATION then
			self._record[#self._record] = nil
		end
	end

	self.value = value
	self.onChanged:invoke(oldValue, value)
end

function state.prototype:increment(value)
	self:set(self.value + value)

	return self
end

function state.prototype:decrement(value)
	self:set(self.value - value)

	return self
end

function state.prototype:concat(value)
	self:set(self.value .. value)

	return self
end

function state.prototype:update(transform)
	self:set(transform(self.value))

	return self
end

function state.prototype:get()
	return self.value
end

function state.prototype:observe(callbackFn)
	return self.onChanged:listen(callbackFn)
end

function state.prototype:toString()
	return string.format("%s<%s>", state.type, tostring(self.value))
end

function state.interface.new(value)
	local self = setmetatable({ value = value, _record = { value } }, {
		__type = state.type,
		__index = state.prototype,

		__tostring = function(object)
			return object:toString()
		end
	})

	self.onChanged = signal.new()

	return self
end

return state.interface