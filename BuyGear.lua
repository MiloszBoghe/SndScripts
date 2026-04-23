require("HelperFunctions")
import("System.Numerics")

-- The numbers are the row in the shop, they are used for the callback function in BuyItems, not the item ID.

-- Select "Purchase Tools" on the vendor menu before buying this section.
local toolsToBuy = {
    16, -- Titanium Gold Pickaxe
    17, -- Titanium Gold Maul
}

-- Select "Purchase Fieldcraft/Tradecraft Gear" on the vendor menu before buying this section.
local gearToBuy = {
    1, -- Rroneek Serge Hat of Gathering
    3, -- Gomphotherium Doublet of Gathering
    5, -- Gomphotherium Halfgloves of Gathering
    7, -- Rroneek Serge Trousers of Gathering
    9, -- Gomphotherium Boots of Gathering
}

local LivingMemoryZoneId = 1192
local DESTINATION = "Leynode Mnemo"
local VENDOR_NAME = "Vendor Unit"
local shopPosition = Vector3(23.765, 53.200, 801.173)
local TIMEOUT = 5

-- INPUT THE NUMBER OF SETS YOU WANT TO BUY HERE
local targetCount = 2

local function Main()
    if GetZoneID() ~= LivingMemoryZoneId then
        yield("/li " .. DESTINATION)
        Wait(5)
        repeat
            Wait(0.1)
        until not IsBusy() and GetZoneID() == LivingMemoryZoneId
    end
    PathfindAndMoveTo(shopPosition.X, shopPosition.Y, shopPosition.Z, false)
    repeat
        Wait(0.1)
    until not IsBusy()

    TargetVendor(VENDOR_NAME, TIMEOUT, 0.3)
    Interact("SelectIconString", TIMEOUT, 0.5)
    BuyItems(toolsToBuy, targetCount, 1)

    Wait(1)

    TargetVendor(VENDOR_NAME, TIMEOUT, 0.3)
    Interact("SelectIconString", TIMEOUT, 0.5)
    BuyItems(gearToBuy, targetCount, 5)

    Echo("Finished.")
end

Main()
