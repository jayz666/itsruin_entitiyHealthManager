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

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local props = config.props

Citizen.CreateThread(function()
    local propHash = {}
    for i = 1, #props do
        propHash[GetHashKey(props[i])] = true
    end

    while true do
        Citizen.Wait(100)

        for v in EnumerateObjects() do
            local modelHash = GetEntityModel(v)

            if propHash[modelHash] then
                FreezeEntityPosition(v, true)
                SetEntityCanBeDamaged(v, false)
            end
        end
    end
end)