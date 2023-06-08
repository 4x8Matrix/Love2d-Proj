local Singleton = { }

Singleton.Type = "Singleton"

Singleton.Interface = { }
Singleton.Instances = { }
Singleton.Prototype = { }

function Singleton.Prototype:InvokeLifecycle(methodName, ...)
    if not self[methodName] then
        return
    end

    return self[methodName](self, ...)
end

function Singleton.Prototype:ToString()
    return string.format("%s<\"%s\">", Singleton.Type, self.Name)
end

function Singleton.Interface.new(source)
    local self = setmetatable(source, {
        __index = Singleton.Prototype,
        __type = Singleton.Type,

        __tostring = function(self)
            return self:ToString()
        end
    })

    if source.Internal then
        source.Internal.Service = source
    end

    Singleton.Instances[source.Name] = self

    return Singleton.Instances[source.Name]
end

function Singleton.Interface.fetchAll()
    return Singleton.Instances
end

function Singleton.Interface.fetch(serviceName)
    return Singleton.Instances[serviceName]
end

return Singleton.Interface