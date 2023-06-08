local love = setmetatable({ }, { __index = love, __newindex = love })

function love.loadChildren(path)
	local directoryObjects = love.filesystem.getDirectoryItems(path)

	for _, objectName in next, directoryObjects do
		local objectPath = path .. "." .. string.sub(objectName, 1, #objectName - 4)

		if string.find(objectName, "Service") then
			require(objectPath)
		end
	end
end

return love