local table_remove = table.remove

local table = setmetatable({ }, { __index = table })

function table.remove(source, item)
    for index, value in next, source do
        if value == item then
            table_remove(source, index)

            return
        end
    end
end

function table.clear(source)
    for index, value in next, source do
        source[index] = nil
    end
end

function table.clone(source, isDeepClone)
    local resolve = { }

    for index, value in next, source do
        resolve[index] = value

        if isDeepClone and type(value) == "table" then
            local metatable = getmetatable(value)

            if type(metatable) == "string" then
                metatable = nil
            end

            resolve[index] = table.clone(value, true)

            if metatable ~= nil then
                setmetatable(resolve[index], metatable)
            end
        end
    end

    return resolve
end

return table