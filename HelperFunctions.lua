local SHOP = "Shop"

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
