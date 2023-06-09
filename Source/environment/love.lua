local hook = require("vendor.hook")

return setmetatable({
    loadChildren = hook.new(false, function(_, path)
        local directoryObjects = love.filesystem.getDirectoryItems(path)

        for _, objectName in next, directoryObjects do
            local objectPath = path .. "." .. objectName

            if string.find(objectName, "Service") then
                require(objectPath)
            end
        end
    end)
}, { __index = love, __newindex = love })