function Stop()
    yield("/snd stop all")
end

--region AddOn handling
function IsAddonReady(addonName)
    return Addons.GetAddon(addonName).Ready
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

function GetNodeText(addon, ...)
    if (IsAddonReady(addon)) then
        return Addons.GetAddon(addon):GetNode(...).Text
    else
        return nil
    end
end

--endregion


--region CosmicExploration

function GetCurrentMission()
    if not IsAddonReady("WKSMissionInfomation") then
        yield("/callback WKSHud true 11")
        yield("/wait 0.5")
    end
    return GetNodeText("WKSMissionInfomation", 1, 3)
end

function StartMission(missionId)
    Echo("Starting mission")
    if (not CurrentMission) then
        if not IsAddonReady("WKSMission") then
            yield("/callback WKSHud true 11")
            yield("/wait 0.5")
        end
        yield("/callback WKSMission true 13 " .. missionId)
        Wait(0.5)
    end
end

function SubmitReport()
    if not IsAddonReady("WKSMissionInfomation") then
        yield("/callback WKSHud true 11")
        yield("/wait 0.5")
    end

    yield("/callback WKSMissionInfomation true 11 1")
    return nil
end

function AbandonMission()
    if not IsAddonReady("WKSMissionInfomation") then
        yield("/callback WKSHud true 11")
        yield("/wait 0.2")
    end

    yield("/callback WKSMissionInfomation true 12 1")
    yield("/wait 0.2")
    return nil
end

--endregion


--region Player / Character

STATUS_IDS = {
    ROAD_TO_90 = 1411,
    WISE_TO_THE_WORLD = 2765
}

function IsPlayerAvailable()
    return Player.Available
end

function IsPlayerCasting()
    return Player.Entity and Player.Entity.IsCasting
end

function IsPlayerOccupied()
    return Svc.Condition[25]
end

function ExecutingGatherAction()
    return Svc.Condition[42]
end

function IsBusy()
    -- 45 = Loading/Between Areas, 25 = Occupied, 2 = Transitioning
    return IsPlayerCasting() or IPC.vnavmesh.IsRunning() or Svc.Condition[45] or IsPlayerOccupied() or Svc.Condition[2] or
        Player.IsBusy or not IsPlayerAvailable()
end

function WaitTillNotBusy()
    repeat
        yield("/wait 0.1")
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

--endregion


--region Echo, Wait, GetZoneId
function Echo(message)
    yield("/echo " .. tostring(message))
end

function Wait(seconds)
    yield("/wait " .. tostring(seconds))
end

function GetZoneID()
    return Svc.ClientState.TerritoryType
end

--endregion


--region Saddlebag and inventory stuff
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

function NeedsRepair(repairThreshold)
    local repairList = Inventory.GetItemsInNeedOfRepairs(repairThreshold)
    local needsRepair = repairList.Count > 0
    return needsRepair
end

function RepairGear()
    if Inventory.GetItemCount(33916) > 0 then
        if NeedsRepair(10) then
            if not Addons.GetAddon("Repair").Ready then
                local repairActionId = 6
                Actions.ExecuteGeneralAction(repairActionId)
                Wait(0.1)
            end
            yield("/callback Repair true 0")
            return true
        else
            return false
        end
    end
end

--Example for BuyItems

--local gearToBuy = {
--    1, -- Rroneek Serge Hat of Gathering
--    3, -- Gomphotherium Doublet of Gathering
--    5, -- Gomphotherium Halfgloves of Gathering
--    7, -- Rroneek Serge Trousers of Gathering
--    9, -- Gomphotherium Boots of Gathering
--}

-- defaultTargetCount = 5

--selection is the index of the shop menu.
-- function to be called after interacting with the vendor
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

-- endregion


--region Target, Interact and movement functions

function Target(entity)
    if Entity.Target then
        if Entity.Target.Name ~= entity then
            repeat
                yield("/target " .. entity .. "")
            until Entity.Target.Name == entity
        elseif Entity.Target.Name == entity then
        end
    elseif Entity.Target ~= true then
        repeat
            yield("/target " .. entity .. "")
        until Entity.Target.Name == entity
    end
end

function LockOn()
    if Entity.Target then
        Echo("Test")
        yield("/lockon")
    end
end

function AutoMove()
    yield("/automove")
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

function YieldInteract()
    yield("/interact")
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
        yield("/wait 0.1")
    until not IsBusy()
end

function PathtoTarget()
    if Entity.Target and Entity.Target.Name then
        PathfindAndMoveTo(Entity.Target.Position.X, Entity.Target.Position.Y, Entity.Target.Position.Z, false)
    end
end

-- endregion


--region Gathering
function Action(action)
    yield("/ac " .. action)
    repeat
        Wait(0.1)
    until not ExecutingGatherAction()
    Wait(0.2)
end

function GetCollectability()
    return tonumber(GetNodeText("GatheringMasterpiece", 1, 37, 42, 47)) or 0
end

function GetIntegrity()
    return tonumber(GetNodeText("GatheringMasterpiece", 1, 73, 119, 126)) or 0
end

function GetGp()
    return tonumber(GetNodeText("_ParameterWidget", 1, 4, 3)) or 0
end

ACTIONS = {
    METICULOUS = "Meticulous Prospector",
    PRIMING_TOUCH = "Priming Touch",
    INTEGRITY_RESTORE = JobId == 16 and "Solid Reason" or "Ageless Words",
    WISE_TO_THE_WORLD = "Wise to the World",
    DUTY_ACTION_2 = "Duty Action II",
    COLLECT = "Collect",
}

--endregion
