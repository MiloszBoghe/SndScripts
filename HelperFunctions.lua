local SHOP = "Shop"

function OpenSaddleBag()
    if not Addons.GetAddon("InventoryBuddy").Ready then
        yield("/saddlebag")
    end
end

function CloseSaddleBag()
    if Addons.GetAddon("InventoryBuddy").Ready then
        yield("/saddlebag")
    end
end

function GetZoneID()
    return Svc.ClientState.TerritoryType
end

function IsBusy()
    -- 45 = Loading/Between Areas, 25 = Occupied, 2 = Transitioning
    return IsPlayerCasting() or IPC.vnavmesh.IsRunning() or Svc.Condition[45] or Svc.Condition[25] or Svc.Condition[2] or
        not IsPlayerAvailable()
end

function PathIsRunning()
    return IPC.vnavmesh.IsRunning()
end

function Echo(message)
    yield("/echo " .. tostring(message))
end

function Wait(seconds)
    yield("/wait " .. tostring(seconds))
end

function Target(entity)
    if Entity.Target then
        if Entity.Target.Name ~= entity then
            repeat            
                yield("/target "..entity.."")
            until Entity.Target.Name == entity
        elseif Entity.Target.Name == entity then
        end
    elseif Entity.Target ~= true then
        repeat            
            yield("/target "..entity.."")
        until Entity.Target.Name == entity
    end
end

function TargetVendor(vendorName, timeoutSeconds, interactDelay)
    local elapsed = 0

    while elapsed < timeoutSeconds do
        yield("/target " .. vendorName)
        Wait(interactDelay)

        if Entity.Target and Entity.Target.Name == vendorName then
            return true
        end

        elapsed = elapsed + interactDelay
    end

    if not Entity.Target or Entity.Target.Name ~= vendorName then
        Echo("Failed to target " .. vendorName)
        Stop()
    end
    return Entity.Target and Entity.Target.Name == vendorName
end

function Interact(addonName, timeoutSeconds, interactDelay)
    local elapsed = 0

    while elapsed < timeoutSeconds do
        if Addons.GetAddon(addonName).Ready then
            return true
        end

        Echo("Interacting with vendor...")
        yield("/interact")
        Wait(interactDelay)
        elapsed = elapsed + interactDelay
    end

    if not Addons.GetAddon(addonName).Ready then
        Echo("Failed to interact with vendor")
        Stop()
    end
    return Addons.GetAddon(addonName).Ready
end

function PathtoTarget()
    if Entity.Target and Entity.Target.Name then
        PathfindAndMoveTo(Entity.Target.Position.X, Entity.Target.Position.Y, Entity.Target.Position.Z, false)
    end
end

function PathfindAndMoveTo(x, y, z, tralse)
    import("System.Numerics")
    IPCUPCWEALLPC = Vector3(x, y, z)
    IPC.vnavmesh.PathfindAndMoveTo(IPCUPCWEALLPC, tralse)
    while IPC.vnavmesh.PathfindInProgress() do
        yield("/wait 0.1")
    end
    while IPC.vnavmesh.IsRunning() do
        yield("/wait 0.1")
    end
end

function WaitWhileZoneTransition()
    repeat
        yield("/wait 0.001")
    until GetCharacterCondition(45, true) and GetCharacterCondition(51, true)
    repeat
        yield("/wait 0.001")
    until GetCharacterCondition(45, false) and GetCharacterCondition(51, false)
    if IPC.IsInstalled(vnavmesh) == true then
        repeat
            yield("/wait 0.001")
        until IPC.vnavmesh.IsReady() == true
    end
    WaitTillNotBusy()
end

function WaitTillNotBusy()
    repeat
        yield("/wait 0.0001")
    until Player.IsBusy == false
end

function GetCharacterCondition(index, expected)
    if index and expected ~= nil then
        return Svc.Condition[index] == expected
    elseif index then
        return Svc.Condition[index]
    else
        return Svc.Condition
    end
end

function IsPlayerAvailable()
    return Player.Available
end

-- IsPlayerCasting()
--
-- Player.Entity.IsCasting wrapper, use to check if player is casting (e.g. using spells,)
function IsPlayerCasting()
    return Player.Entity and Player.Entity.IsCasting
end

function WaitForAddon(addonName, timeoutSeconds)
    local elapsed = 0
    local step = 0.1

    while elapsed < timeoutSeconds do
        if Addons.GetAddon(addonName).Ready then
            return true
        end

        Wait(step)
        elapsed = elapsed + step
    end

    return Addons.GetAddon(addonName).Ready
end

function BuyItems(items, defaultTargetCount, selection)
    yield("/callback SelectIconString true " .. selection)

    if not WaitForAddon(SHOP, 3) then
        Echo("Failed to open shop")
        return false
    end

    for _ = 1, defaultTargetCount do
        for _, itemRow in ipairs(items) do
            yield("/callback " .. SHOP .. " true 0 " .. itemRow .. " 1")
            Wait(0.4)
        end
    end

    yield("/callback Shop true -1")
end

function Stop()
    yield("/snd stop all")
end

function GetFullStatusList()
    local player = Svc.Objects.LocalPlayer
    if not player then
        yield("/echo Player is nil")
        return
    end

    local statuses = player.StatusList
    if not statuses then
        yield("/echo StatusList is nil")
        return
    end

    --for i = 0, 29 do
    for i = 0, statuses.Length - 1 do
        local status = statuses[i]
        if status and status.StatusId ~= 0 then
            yield(string.format("/echo [%d] ID: %d  Time: %.2f", i, status.StatusId, status.RemainingTime or 0))
        end
    end
end

function GetStatusTimeRemaining(statusID)
    local player = Svc.Objects.LocalPlayer
    if not player then
        yield("/echo Player is nil")
        return 0
    end

    local statuses = player.StatusList
    if not statuses then
        yield("/echo StatusList is nil")
        return 0
    end

    --for i = 0, 29 do -- max 30 statuses
    for i = 0, statuses.Length - 1 do
        local status = statuses[i]
        if status and status.StatusId == statusID then
            return status.RemainingTime or 0
        end
    end
    return 0
end

function HasStatus(statusID)
    local player = Svc.Objects.LocalPlayer
    if not player then
        yield("/echo Player is nil")
        return 0
    end

    local statuses = player.StatusList
    if not statuses then
        yield("/echo StatusList is nil")
        return 0
    end

    --for i = 0, 29 do -- max 30 statuses
    for i = 0, statuses.Length - 1 do
        local status = statuses[i]
        if status and status.StatusId == statusID then
            return true
        end
    end
    return false
end

ALL_INVENTORY = {
    InventoryType.Inventory1,
    InventoryType.Inventory2,
    InventoryType.Inventory3,
    InventoryType.Inventory4,
}

NORMAL_SADDLEBAG = {
    InventoryType.SaddleBag1,
    InventoryType.SaddleBag2,
}

PREMIUM_SADDLEBAG = {
    InventoryType.PremiumSaddleBag1,
    InventoryType.PremiumSaddleBag2,
}

ALL_SADDLE = {
    InventoryType.SaddleBag1,
    InventoryType.SaddleBag2,
    InventoryType.PremiumSaddleBag1,
    InventoryType.PremiumSaddleBag2,
}

SALVAGE_ITEM_IDS = {
    [22500] = "Salvaged Ring",
    [22501] = "Salvaged Bracelet",
    [22502] = "Salvaged Earring",
    [22503] = "Salvaged Necklace",
    [22504] = "Extravagant Salvaged Ring",
    [22505] = "Extravagant Salvaged Bracelet",
    [22506] = "Extravagant Salvaged Earring",
    [22507] = "Extravagant Salvaged Necklace",
}

STATUS_IDS = {
    ROAD_TO_90 = 1411,
}