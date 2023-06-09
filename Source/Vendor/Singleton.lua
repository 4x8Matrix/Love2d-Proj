local singleton = { }

singleton.type = "singleton"

singleton.interface = { }
singleton.instances = { }
singleton.prototype = { }

function singleton.prototype:toString()
	return string.format("%s<\"%s\">", singleton.type, self.name)
end

function singleton.interface.getInstances()
	return table.clone(singleton.instances)
end

function singleton.interface.getInstance(name)
	return singleton.instances[name]
end

function singleton.interface.new(source)
	local self = setmetatable(source, {
		__index = singleton.prototype,
		__type = singleton.type,

		__tostring = function(self)
			return self:toString()
		end
	})

	singleton.instances[source.name] = self

	return singleton.instances[source.name]
end

return singleton.interface