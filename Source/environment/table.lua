local hook = require("vendor.hook")

return setmetatable({
    removeValue = hook.new(table.remove, function(remove, source, item)
        for index, value in next, source do
            if value == item then
                return remove(source, index)
            end
        end
    end),

    clear = hook.new(false, function(_, source)
        for index in next, source do
            source[index] = nil
        end
    end),

    merge = hook.new(false, function(_, ...)
        local mergeResult = { }

        for _, tblContent in next, { ... } do
            for index, value in next, tblContent do
                mergeResult[index] = value
            end
        end

        return mergeResult
    end),

    unpack = hook.new(unpack, function (unpack, source)
        return unpack(source)
    end),

    clone = hook.new(false, function(_, source)
        local resolve = { }

        for index, value in next, source do
            resolve[index] = value
        end

        return resolve
    end)
}, { __index = table, __newindex = table })