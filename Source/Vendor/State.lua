local Signal = require("Vendor.Signal")

local MAX_RECORD_ALLOCATION = 15

local State = { }

State.Type = "State"

State.Interface = { }
State.Prototype = { }

function State.Prototype:SetRecordingState(state)
	self._recording = state

	return self
end

function State.Prototype:GetRecord(count)
	if not count then
		return self._record
	end

	local record = {}

	for index = 1, count do
		record[index] = self._record[index]
	end

	return record
end

function State.Prototype:Set(value)
	local oldValue = self.Value

	if self._recording then
		table.insert(self._record, 1, value)

		if #self._record > MAX_RECORD_ALLOCATION then
			self._record[#self._record] = nil
		end
	end

	self.Value = value
	self.Changed:Invoke(oldValue, value)
end

function State.Prototype:Increment(value)
	self:Set(self.Value + value)

	return self
end

function State.Prototype:Decrement(value)
	self:Set(self.Value - value)

	return self
end

function State.Prototype:Concat(value)
	self:Set(self.Value .. value)

	return self
end

function State.Prototype:Update(transform)
	self:Set(transform(self.Value))

	return self
end

function State.Prototype:Get()
	return self.Value
end

function State.Prototype:Observe(callbackFn)
	return self.Changed:Connect(callbackFn)
end

function State.Prototype:ToString()
	return string.format("%s<%s>", State.Type, tostring(self.Value))
end

function State.Interface.new(value)
	local self = setmetatable({ Value = value, _record = { value } }, {
		__type = State.Type,
		__index = State.Prototype,
		__tostring = function(object)
			return object:ToString()
		end
	})

	self.Changed = Signal.new()

	return self
end

return State.Interface