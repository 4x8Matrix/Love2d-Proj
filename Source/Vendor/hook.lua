local hook = { }

hook.type = "Hook"

hook.interface = { }
hook.prototype = { }

function hook.prototype:toString()
	return string.format("%s<\"%s\">", hook.type, tostring(self._global))
end

function hook.prototype:execute(...)
	return self._callbackFn(self._global, ...)
end

function hook.interface.new(global, callbackFn)
	return setmetatable({ _global = global, _callbackFn = callbackFn }, {
		__index = hook.prototype,
		__type = hook.type,

		__tostring = function(self)
			return self:toString()
		end,

		__call = function(self, ...)
			return self:execute(...)
		end
	})
end

return hook.interface