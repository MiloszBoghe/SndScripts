require("HelperFunctions")

local premiumSaddle = true
local SLOT_COUNT = 35

local function GetItemBySlot(inventoryType, slot)
    return Inventory.GetInventoryItemBySlot(inventoryType, slot)
end

local function StoreItems()
    local itemsToStore = {}
    local saddlesToUse

    if premiumSaddle then
        saddlesToUse = ALL_SADDLE
    else
        saddlesToUse = NORMAL_SADDLEBAG
    end
    for _, inventoryType in pairs(ALL_INVENTORY) do
        local container = Inventory.GetInventoryContainer(inventoryType)
        Echo(tostring(inventoryType) .. ": " .. container.FreeSlots .. " free slots")
        if container then
            for slot = 0, SLOT_COUNT - 1 do
                local item = GetItemBySlot(inventoryType, slot)
                if item and not item.IsEmpty and item.Count == 99 and SALVAGE_ITEM_IDS[item.ItemId] then
                    itemsToStore[#itemsToStore + 1] = item
                    Echo("Item added to store later -> itemId: " .. item.ItemId .. "itemCount: " .. item.Count)
                end
            end
        end
    end

    OpenSaddleBag()

    for _, inventoryType in pairs(saddlesToUse) do
        local container = Inventory.GetInventoryContainer(inventoryType)
        Echo(tostring(inventoryType) .. ": " .. container.FreeSlots .. " free slots")
        for i = #itemsToStore, 1, -1 do
            local item = itemsToStore[i]
            if container and container.FreeSlots > 0 then
                item:MoveItemSlot(inventoryType)
                Echo("Moved item " .. item.ItemId .. " to " .. tostring(inventoryType))
                table.remove(itemsToStore, i)
                Wait(0.3)
            end
        end
        if tostring(inventoryType) == "PremiumSaddleBag2: 4101" and container.FreeSlots == 0 then
            Echo("Not enough space in saddlebags to store all items! Remaining items")
            yield("/snd stop all")
        end
    end
end

repeat
    repeat
        Wait(0.1)
    until Addons.GetAddon("Trade").Ready
    Echo("Trade is open, waiting for it to close...")

    repeat
        Wait(0.1)
    until not Addons.GetAddon("Trade").Ready
    Echo("Trade is closed, waiting for confirmation trading is done...")

    local waitTime = 0

    while waitTime < 10 do
        if Addons.GetAddon("Trade").Ready then
            waitTime = 0
        end

        Wait(0.1)
        waitTime = waitTime + 0.1
    end
    Echo("Confirmed trading is done, storing items...")
    StoreItems()
    CloseSaddleBag()

    Echo("Finished storing items, restarting...")
until false
