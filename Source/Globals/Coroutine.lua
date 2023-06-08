local coroutine = setmetatable({
    _yieldingRoutines = { }
}, { __index = coroutine })

function coroutine.process()
    for routine, timeData in next, coroutine._yieldingRoutines do
        if os.clock() - timeData[2] > timeData[1] then
            coroutine._yieldingRoutines[routine] = nil

            coroutine.resume(routine)
        end
    end
end

function coroutine.wait(int)
    local activeRoutine = coroutine.running()

    coroutine._yieldingRoutines[activeRoutine] = { int, os.clock() }
end

function coroutine.spawn(callbackFn, ...)
    local routine = coroutine.create(callbackFn)

    coroutine.resume(routine, ...)

    return routine
end

function coroutine.delay(int, callbackFn)
    coroutine.spawn(function()
        coroutine.wait(int)

        callbackFn()
    end)
end

return coroutine