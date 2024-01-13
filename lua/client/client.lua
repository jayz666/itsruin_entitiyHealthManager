-- Utility for enumerating entities in a safer and more efficient manner
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

-- Main script logic for object management
Citizen.CreateThread(function()
    -- Ensure config.props is available and valid
    local props = config and config.props or {}
    if #props == 0 then
        print("Warning: No props defined in config")
        return
    end

    -- Preparing hash table for efficient lookup
    local propHash = {}
    for i = 1, #props do
        propHash[GetHashKey(props[i])] = true
    end

    while true do
        Citizen.Wait(100) -- Consider making this configurable

        for v in EnumerateObjects() do
            local modelHash = GetEntityModel(v)
            if propHash[modelHash] then
                FreezeEntityPosition(v, true)
                SetEntityCanBeDamaged(v, false)
            end
        end
    end
end)


            if propHash[modelHash] then
                FreezeEntityPosition(v, true)
                SetEntityCanBeDamaged(v, false)
            end
        end
    end
end)
