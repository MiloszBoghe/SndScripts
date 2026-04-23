--|| Unlock all Mini Aetherytes Uldah, Limsa Lominsa, Gridania ||--
--|| Unlock all DoL and DoH Classes ||--
--|| Delete / Create Gearsets ||--
--|| Buy Mats in Goblet ||--

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--[[

--|| SND Plugin specific Script Settings ||--
- Set Plugin Conflicts: - TextAdvanced
                        - YesAlready

---------------------------------------------------------------------------------------
--|| Dependencies ||--
- Vnavmesh
- Lifestream
- CBT: - 'Commands'
        - '/equip'
---------------------------------------------------------------------------------------
--|| Requirements ||--
- Anough Gil for potential Teleports and Mats
- Action 'Teleport' unlocked
- Ul'dah, Limsa Lominsa and Gridania Main Aetheryte unlocked
- Finished Lvl. 10 Class Quest on at least any 1 Class to unlock other Class Quests

--]]
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Script Settings ||--
-- Set to 'true' or 'false' according to your needs

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Delete All existing Gearsets ||--
DeleteAllTheGearsets = false -- Enables/Disables Deletion of Gearsets

---------------------------------------------------------------------------------------
--|| Create Gearsets ||--
CreateAllTheGearsets = false -- Enables/Disables Creation of Gearsets

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
-- Choose Class you want a Gearset to be created for
GearsetCurrentClass = false -- Creates Gearset for current Class; Equip DoW/M Weapon by yourself before running the Script

GearsetWaver = false
GearsetMiner = false
GearsetGoldsmith = false
GearsetAlchemist = false
GearsetFisher = false
GearsetBlacksmith = false
GearsetArmorer = false
GearsetCulinarian = false
GearsetCarpenter = false
GearsetLeatherworker = false
GearsetBotanist = false

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Unlock Summerford Farms Aetheryte ||--
UnlockSummerfordFarmsAetherytes = false -- Enables/Disables Unlocking Summerford Farms Aetheryte

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Unlock Mini Aetherytes ||--
UnlockMiniAetherytes = false -- Enables/Disables Unlocking of Mini Aetherytes

-- Choose City you want Mini Aetherytes to be unlocked for
Uldah = true
Limsa = true
Gridania = true

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Unlock Classes ||--
UnlockClasses = true -- Enables/Disables Unlocking of Classes

-- Choose Class you want to unlock
--|| Ul'dah ||--
Weaver = false
Miner = false
Goldsmith = false
Alchemist = false

--|| Limsa ||--
Fisher = false
Blacksmith = false
Armorer = false
Culinarian = false

--|| Gridania ||--
Carpenter = false
Leatherworker = true
Botanist = false

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Buy Mats ||--
BuyMats = false -- Enables/Disables Buying of Mats

--|| Mats Amount ||--
-- Define the Amount of Mats you want to buy
MudstoneAmount = 5000
ElmLumberAmount = 5000

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Custom Functions ||--
function IsAetheryteUnlocked(AetheryteId)
    if Instances.Telepo:IsAetheryteUnlocked(AetheryteId) then
        return true
    elseif Instances.Telepo:IsAetheryteUnlocked(AetheryteId) == false then
        return false
    end
end

---------------------------------------------------------------------------------------
function UnlockMiniAetheryte()
    if Addons.GetAddon("TelepotTown").Ready == false then
        Target("Aethernet shard")
        Interact()
        yield('/waitaddon "TelepotTown" <maxwait.3>')
        if Addons.GetAddon("TelepotTown").Ready then
            CallbackAddon("TelepotTown", 'true 1')
        else
            WaitWhileCasting()
            if GetCharacterCondition(32) then
                repeat
                    if Addons.GetAddon("Talk").Ready then
                        SkipTalk()
                    end
                    Wait(0.0001)
                until GetCharacterCondition(32) == false
            end
        end
    end
end

---------------------------------------------------------------------------------------
function UnlockAetheryte(AtheryteId)
    if Instances.Telepo:IsAetheryteUnlocked(AtheryteId) == false then
        Target("aetheryte")
        Interact()
        WaitWhileCasting()
    end
end

---------------------------------------------------------------------------------------
function CheckOtherClassesUnlocked()
    if Quests.IsQuestComplete(288)          -- Gladiator
        or Quests.IsQuestComplete(314)      -- Marauder
        or Quests.IsQuestComplete(698)      -- Pugilist
        or Quests.IsQuestComplete(143)      -- Lancer
        or Quests.IsQuestComplete(147)      -- Conjurer
        or Quests.IsQuestComplete(457)      -- Arcanist
        or Quests.IsQuestComplete(67)       -- Archer
        or Quests.IsQuestComplete(349) then -- Thaumaturge
        return true
    else
        return false
    end
end

---------------------------------------------------------------------------------------
function CreateGearset()
    if Addons.GetAddon("GearSetList").Ready == false then
        OpenUI("Gearset")
    end
    CallbackAddon("GearSetList", 'true 1 -1')
    OpenUI("gearset")
end

---------------------------------------------------------------------------------------
function DeleteAllGearsets()
    if Addons.GetAddon("GearSetList").Ready == false then
        OpenUI("gearset")
        Wait(0.5)
    end
    if Addons.GetAddon("GearSetList").Ready then
        if Addons.GetAddon("GearSetList"):GetNode(1, 7, 5, 3).Text ~= "" then
            repeat
                GearSetNr = Addons.GetAddon("GearSetList"):GetNode(1, 7, 5, 3).Text
                StrNr = tonumber(GearSetNr) - 1
                CallbackAddon("GearSetList", "true 5 " .. StrNr .. "")
                -- Context Menu
                repeat
                    Wait(0.0001)
                until Addons.GetAddon("ContextMenu").Ready
                if Addons.GetAddon("ContextMenu").Ready then
                    SpecialNr = 31001
                    StringNumber = 0
                    if Addons.GetAddon("ContextMenu"):GetNode(1, 2, 3, 2, 3).Text == 'Delete Set' then
                        StringNumber = 0
                        StringFound = true
                    else
                        repeat
                            if Addons.GetAddon("ContextMenu"):GetNode(1, 2, SpecialNr, 2, 3).Text ~= 'Delete Set' then
                                StringNumber = StringNumber + 1
                                SpecialNr = SpecialNr + 1
                                StringFound = false
                            elseif Addons.GetAddon("ContextMenu"):GetNode(1, 2, SpecialNr, 2, 3).Text == 'Delete Set' then
                                StringNumber = StringNumber + 1
                                StringFound = true
                            end
                            --                        Wait(0.0001)
                        until StringFound
                    end
                    CallbackAddon("ContextMenu", "true 0 " .. StringNumber .. " 0u 0 0")
                end
                -- Error Toast
                if Addons.GetAddon("_TextError").Ready == false then
                    Error = false
                elseif Addons.GetAddon("_TextError").Ready and Addons.GetAddon("_TextError"):GetNode(1, 2).Text == 'Unable to delete gear set.' then
                    Error = true
                    CallbackAddon("GearSetList", "true 3")
                    repeat
                        Wait(0.0001)
                    until Addons.GetAddon("_TextError").Ready == false
                    if Addons.GetAddon("GearSetList").Ready == false then
                        OpenUI("Gearset")
                        Wait(0.5)
                    end
                    if Addons.GetAddon("GearSetList").Ready then
                        if Addons.GetAddon("GearSetList"):GetNode(1, 7, 5, 3).Text ~= "" then
                            NothingToDelete = false
                        else
                            NothingToDelete = true
                        end
                    end
                end
                if Error == false then
                    CallbackAddon("SelectYesno", "true 0")
                end
                Wait(0.0001)
            until NothingToDelete
            CallbackAddon("GearSetList", "true 3")
        else
            CallbackAddon("GearSetList", "true 3") --OpenUI("Gearset")
        end
    end
end

---------------------------------------------------------------------------------------
function QuestAccept(QuestNPC, NPCCoords, QuestId)
    if Quests.IsQuestAccepted(QuestId) == false and Quests.IsQuestComplete(QuestId) == false then
        Vnavmesh(NPCCoords, false)
        Target(QuestNPC)
        Interact()
        if GetCharacterCondition(32, true) then
            repeat
                if Addons.GetAddon("Talk").Ready then
                    SkipTalk()
                elseif Addons.GetAddon("SelectYesno").Ready then
                    CallbackAddon("SelectYesno", "true 0")
                elseif Addons.GetAddon("JournalAccept").Ready then
                    CallbackAddon("JournalAccept", "true 3 " .. QuestId .. "")
                elseif Addons.GetAddon("JournalResult").Ready then
                    CallbackAddon("JournalResult", "true 0 0")
                end
                Wait(0.0001)
            until GetCharacterCondition(32, false)
        elseif GetCharacterCondition(31, true) then
            repeat
                if Addons.GetAddon("Talk").Ready then
                    SkipTalk()
                end
                Wait(0.0001)
            until GetCharacterCondition(31, false)
        end
    end
end

---------------------------------------------------------------------------------------
function QuestProgress(QuestNPC, NPCCoords, QuestId)
    if Quests.IsQuestComplete(QuestId) == false then
        Vnavmesh(NPCCoords, false)
        Target(QuestNPC)
        Interact()
        if GetCharacterCondition(32, true) then
            repeat
                if Addons.GetAddon("Talk").Ready then
                    SkipTalk()
                elseif Addons.GetAddon("SelectYesno").Ready then
                    CallbackAddon("SelectYesno", "true 0")
                elseif Addons.GetAddon("JournalAccept").Ready then
                    CallbackAddon("JournalAccept", "true 3 " .. QuestId .. "")
                elseif Addons.GetAddon("JournalResult").Ready then
                    CallbackAddon("JournalResult", "true 0 0")
                end
                Wait(0.0001)
            until GetCharacterCondition(32, false)
        elseif GetCharacterCondition(31, true) then
            repeat
                if Addons.GetAddon("Talk").Ready then
                    SkipTalk()
                end
                Wait(0.0001)
            until GetCharacterCondition(31, false)
        end
    end
end

---------------------------------------------------------------------------------------
function WaitWhileZoneTransition()
    yield("/e this should be fine")
    repeat
        yield("/wait 0.001")
        yield("/e this?")
    until GetCharacterCondition(45, true) and GetCharacterCondition(51, true)
    repeat
        yield("/wait 0.001")
        yield("/e this??")
    until GetCharacterCondition(45, false) and GetCharacterCondition(51, false)
    if IPC.IsInstalled(vnavmesh) then
        repeat
            yield("/wait 0.001")
            yield("/e this???")
        until IPC.vnavmesh.IsReady()
    end
    WaitTillNotBusy()
end

---------------------------------------------------------------------------------------
function WaitWhileCasting()
    repeat
        yield("/wait 0.0001")
    until Player.Entity.IsCasting
    yield("/e casting true")
    repeat
        yield("/wait 0.0001")
    until Player.Entity.IsCasting == false
end

---------------------------------------------------------------------------------------
function OpenUI(Element)
    yield("/" .. Element .. "")
end

---------------------------------------------------------------------------------------
function CallbackAddon(Addon, AddonValues)
    repeat
        yield("/wait 0.0001")
    until Addons.GetAddon("" .. Addon .. "").Ready
    yield("/callback " .. Addon .. " " .. AddonValues .. "")
end

---------------------------------------------------------------------------------------
function SkipTalk()
    repeat
        yield("/wait 0.0001")
    until Addons.GetAddon("Talk").Ready
    repeat
        yield("/callback Talk true 0")
    until Addons.GetAddon("Talk").Ready == false
end

---------------------------------------------------------------------------------------
function Lifestream(Destination)
    IPC.Lifestream.Abort()
    WaitTillNotBusy()
    yield("/li " .. Destination)
    repeat
        Wait(0.001)
        if Addons.GetAddon("_TextError").Ready then
            if Addons.GetAddon("_TextError"):GetNode(1, 2).Text == 'Unable to teleport. You are not attuned to that Aethernet destination.' then
                yield("/e Aetheryte not unlocked. Cant teleport. Script stopped.")
                yield("/snd stop all")
            end
        end
    until IPC.Lifestream.IsBusy() == false
    WaitTillNotBusy()
end

---------------------------------------------------------------------------------------
function ReturnPlayerCoords()
    PosX = Player.Entity.Position.X
    PosY = Player.Entity.Position.Y
    PosZ = Player.Entity.Position.Z
    PosXCutoff = PosX - (PosX % 0.001)
    PosYCutoff = PosY - (PosY % 0.001)
    PosZCutoff = PosZ - (PosZ % 0.001)
    PosXYZ = PosXCutoff .. ' ' .. PosYCutoff .. ' ' .. PosZCutoff
    return PosXYZ
end

---------------------------------------------------------------------------------------
-- Required for VNavmesh Vector3 (coords) to work
import("System.Numerics")

---------------------------------------------------------------------------------------
function Vnavmesh(Vector3Pos, fly)
    CurrentZoneId = GetZoneID()
    -- separating the Vector3 Coords into separate strings
    local sub1 = string.gsub(tostring(Vector3Pos), "[<>]", "")
    local str = sub1
    local delim = ":"
    local result = str:sub(1, str:find(delim, 1, true) - 1)
    local iterator = string.gmatch(result, "([^,]+)")
    local StrPosX = iterator()
    local StrPosY = iterator()
    local StrPosZ = iterator()
    StrPosX = string.gsub(StrPosX, ",", ".")
    StrPosY = string.gsub(StrPosY, ",", ".")
    StrPosZ = string.gsub(StrPosZ, ",", ".")
    --vnavmesh part
    IPC.vnavmesh.Stop()
    repeat
        Wait(0.001)
    until IPC.vnavmesh.IsReady()
    WaitTillNotBusy()
    if fly then
        IPC.vnavmesh.PathfindAndMoveTo(Vector3Pos, true)
    elseif fly == false then
        IPC.vnavmesh.PathfindAndMoveTo(Vector3Pos, false)
    end
    repeat
        Wait(0.001)
    until IPC.vnavmesh.PathfindInProgress() == false
    -- Use Sprint if greater than Minimal Distance to Vector3 coords
    repeat
        ReturnPlayerCoords()
        MinDistance = 2
        if (PosXCutoff >= StrPosX + MinDistance or PosXCutoff <= StrPosX - MinDistance) and (PosZCutoff >= StrPosZ + MinDistance or PosZCutoff <= StrPosZ - MinDistance) then
            DistanceGreateEnough = true
        elseif (PosXCutoff <= StrPosX + MinDistance or PosXCutoff >= StrPosX - MinDistance) and (PosZCutoff <= StrPosZ + MinDistance or PosZCutoff >= StrPosZ - MinDistance) then
            DistanceGreateEnough = false
        end
        if DistanceGreateEnough and GetCharacterCondition(4, false) and Player.IsMoving and Actions.GetActionInfo(3).SpellCooldown == 0 then
            UseAction("Sprint")
        end
        Wait(0.001)
    until IPC.vnavmesh.IsRunning() == false or GetZoneID() ~= CurrentZoneId
end

---------------------------------------------------------------------------------------
function GetZoneID()
    return Svc.ClientState.TerritoryType
end

---------------------------------------------------------------------------------------
function UseAction(ActionName)
    yield("/ac " .. ActionName .. " ")
end

---------------------------------------------------------------------------------------
function GetCharacterCondition(index, expected)
    if index and expected ~= nil then
        return Svc.Condition[index] == expected
    elseif index then
        return Svc.Condition[index]
    else
        return Svc.Condition
    end
end

---------------------------------------------------------------------------------------
function Wait(time)
    yield("/wait " .. time)
end

---------------------------------------------------------------------------------------
function WaitTillNotBusy()
    repeat
        yield("/wait 0.0001")
    until Player.IsBusy == false
end

---------------------------------------------------------------------------------------
function Target(entity)
    if Entity.Target then
        if Entity.Target.Name ~= entity then
            repeat
                yield("/target " .. entity .. "")
            until Entity.Target.Name == entity
        end
    elseif Entity.Target ~= true then
        repeat
            yield("/target " .. entity .. "")
        until Entity.Target.Name == entity
    end
end

---------------------------------------------------------------------------------------
function Interact()
    yield("/interact")
end

---------------------------------------------------------------------------------------
function BuyItem_KeepStockAmount(Addon, AddonValuesP1, AddonValuesP2, ItemId, StockAmount)
    repeat
        yield("/wait 0.0001")
    until Addons.GetAddon("" .. Addon .. "").Ready
    if Inventory.GetItemCount(ItemId) < StockAmount then
        repeat
            if tonumber(StockAmount) - tonumber(Inventory.GetItemCount(ItemId)) > 999 then
                BuyAmount = 999
            elseif tonumber(StockAmount) - tonumber(Inventory.GetItemCount(ItemId)) <= 999 then
                BuyAmount = tonumber(StockAmount) - Inventory.GetItemCount(ItemId)
            end
            if Inventory.GetItemCount(ItemId) < StockAmount then
                yield("/callback " .. Addon .. " " .. AddonValuesP1 .. " " .. BuyAmount .. " " .. AddonValuesP2 .. "")
                yield("/callback SelectYesno true 0")
            end
            yield("/wait 0.0001")
        until Inventory.GetItemCount(ItemId) >= StockAmount
    end
end

---------------------------------------------------------------------------------------
function EquipRecommendedGear()
    if Addons.GetAddon("Character").Ready == false then
        OpenUI("character")
    end
    CallbackAddon("Character", "true 12")
    Wait(2)
    CallbackAddon("RecommendEquip", "true 0")
    CallbackAddon("Character", "true -1")
end

---------------------------------------------------------------------------------------
function BuyItem_KeepStockAmount(Addon, AddonValuesP1, AddonValuesP2, ItemId, StockAmount)
    repeat
        yield("/wait 0.0001")
    until Addons.GetAddon("" .. Addon .. "").Ready
    if Inventory.GetItemCount(ItemId) < StockAmount then
        repeat
            if tonumber(StockAmount) - tonumber(Inventory.GetItemCount(ItemId)) > 999 then
                BuyAmount = 999
            elseif tonumber(StockAmount) - tonumber(Inventory.GetItemCount(ItemId)) <= 999 then
                BuyAmount = tonumber(StockAmount) - Inventory.GetItemCount(ItemId)
            end
            if Inventory.GetItemCount(ItemId) < StockAmount then
                yield("/callback " .. Addon .. " " .. AddonValuesP1 .. " " .. BuyAmount .. " " .. AddonValuesP2 .. "")
                yield("/callback SelectYesno true 0")
            end
            yield("/wait 0.0001")
        until Inventory.GetItemCount(ItemId) >= StockAmount
    end
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Aetheryte Id ||--
UldahAetheryteId = 9
LimsaAetheryteId = 8
GridaniaAetheryteId = 2
SumerfordFarmsAetheryteId = 52

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Script ||--

--|| Unlock Mini Aetherytes ||--
--|| Ul'dah ||--

if UnlockMiniAetherytes then
    if Uldah then
        if GetZoneID() ~= 130 then
            Lifestream("Ul'dah")
        end
        --|| Adventurers' Guild ||--
        Vnavmesh(Vector3(63.278, 3.999, -119.046), false)
        UnlockMiniAetheryte()

        --|| Sapphire Avenue Exchange ||--
        Vnavmesh(Vector3(95.988, 3.999, -103.811), false)
        WaitWhileZoneTransition()
        Vnavmesh(Vector3(132.681, 3.999, -32.808), false)
        UnlockMiniAetheryte()

        --|| Weavers' Guild ||--
        Vnavmesh(Vector3(91.991, 11.999, 55.458), false)
        UnlockMiniAetheryte()

        --|| Miners' Guild ||--
        Vnavmesh(Vector3(32.035, 11.999, 109.67), false)
        UnlockMiniAetheryte()

        --|| Goldsmiths' Guild ||--
        Vnavmesh(Vector3(-19.612, 13.999, 75.62), false)
        UnlockMiniAetheryte()

        --|| The Chamber of Rule ||--
        Vnavmesh(Vector3(4.199, 29.999, -22.291), false)
        UnlockMiniAetheryte()

        --|| Alchemists' Guild ||--
        Vnavmesh(Vector3(-99.285, 40.758, 84.075), false)
        UnlockMiniAetheryte()

        --|| Gladiators' Guild ||--
        Lifestream("Goldsmiths' Guild")
        Vnavmesh(Vector3(-51.465, 9.999, 8.969), false)
        UnlockMiniAetheryte()

        --|| Thaumaturges' Guild ||--
        Vnavmesh(Vector3(-114.139, 8.226, 9.286), false)
        WaitWhileZoneTransition()
        Vnavmesh(Vector3(-154.999, 14.005, 69.419), false)
        UnlockMiniAetheryte()
    end

    if Limsa then
        if GetZoneID() ~= 129 then
            Lifestream("Limsa")
        end

        --|| Hawkers' Alley ||--
        Vnavmesh(Vector3(-211.958, 15.998, 49.641), false)
        UnlockMiniAetheryte()

        --|| Arcanists' Guild ||--
        Vnavmesh(Vector3(-333.275, 11.999, 53.127), false)
        UnlockMiniAetheryte()

        --|| Fishermen's Guild ||--
        Lifestream("Hawkers' Alley")
        Vnavmesh(Vector3(-181.325, 3.999, 181.401), false)
        UnlockMiniAetheryte()

        --|| The Aftcastle ||--
        Lifestream("Limsa")
        Vnavmesh(Vector3(-91.413, 22.634, 118.045), false)
        WaitWhileZoneTransition()
        Vnavmesh(Vector3(14.371, 39.999, 71.964), false)
        UnlockMiniAetheryte()

        --|| Culinarians' Guild ||--
        Lifestream("Limsa")
        Vnavmesh(Vector3(-84.412, 18.231, -28.925), false)
        WaitWhileZoneTransition()
        Vnavmesh(Vector3(-59.163, 42.021, -130.205), false)
        UnlockMiniAetheryte()

        --|| Marauders' Guild ||--
        Vnavmesh(Vector3(-2.635, 44.089, -215.757), false)
        UnlockMiniAetheryte()
    end

    if Gridania then
        if GetZoneID() ~= 132 then
            Lifestream("Gridania")
        end

        --|| Archers' Guild ||--
        Vnavmesh(Vector3(164.21, -2.334, 85.784), false)
        UnlockMiniAetheryte()

        --|| Leatherworkers' Guild & Shaded Bower ||--
        Vnavmesh(Vector3(102.842, 5.431, 12.373), false)
        WaitWhileZoneTransition()
        Vnavmesh(Vector3(103.664, 8.769, -110.129), false)
        UnlockMiniAetheryte()

        --|| Lancers' Guild ||--
        Vnavmesh(Vector3(133.65, 13.327, -98.268), false)
        Vnavmesh(Vector3(123.787, 11.597, -229.768), false)
        UnlockMiniAetheryte()

        --|| Mih Khetto's Amphitheatre ||--
        Vnavmesh(Vector3(-71.145, 7.217, -138.458), false)
        UnlockMiniAetheryte()

        --|| Botanists' Guild ||--
        Vnavmesh(Vector3(-308.218, 7.06, -176.601), false)
        UnlockMiniAetheryte()

        --|| Conjurers' Guild ||--
        Vnavmesh(Vector3(-146.414, 3.999, -14.959), false)
        UnlockMiniAetheryte()
    end
end

--|| Unlock Summerford Farms Aetheryte ||--
if UnlockSummerfordFarmsAetherytes then
    Lifestream("Zephyr")
    WaitWhileZoneTransition()
    yield("/e Unlocking Summerford Farms Aetheryte")
    if GetZoneID() == 134 then
        Vnavmesh(Vector3(221.304, 113.099, -256.532), false)
    end
    UnlockAetheryte(52)
end


if UnlockClasses then
    if Weaver then
        Lifestream("Weavers' Guild")
        QuestAccept("Maronne", Vector3(137.78, 7.591, 98.012), 534)
        QuestAccept("Maronne", Vector3(137.78, 7.591, 98.012), 534)
        QuestProgress("Redolent Rose", Vector3(152.305, 6.192, 99.244), 534)
    end

    if Miner then
        Lifestream("Miners' Guild")
        QuestAccept("Linette", Vector3(0.746, 7.59, 154.746), 597)
        QuestAccept("Linette", Vector3(0.746, 7.59, 154.746), 597)
        QuestProgress("Adalberta", Vector3(-16.883, 6.199, 157.407), 597)
    end

    if Goldsmith then
        Lifestream("Goldsmiths' Guild")
        QuestAccept("Jemime", Vector3(-34.457, 13.534, 100.156), 608)
        QuestAccept("Jemime", Vector3(-34.457, 13.534, 100.156), 608)
        QuestProgress("Serendipity", Vector3(-26.65, 12.199, 108.515), 608)
    end

    if Alchemist then
        Lifestream("Alchemists' Guild")
        QuestAccept("Deitrich", Vector3(-114.589, 41.56, 121.958), 575)
        QuestAccept("Deitrich", Vector3(-114.589, 41.56, 121.958), 575)
        QuestProgress("Severian", Vector3(-99.241, 40.2, 122.801), 575)
    end

    if Fisher then
        Lifestream("Fishermen's Guild")
        QuestAccept("N'nmulika", Vector3(-168.089, 4.549, 153.547), 1107)
        QuestAccept("N'nmulika", Vector3(-168.089, 4.549, 153.547), 1107)
        QuestProgress("Sisipu", Vector3(-168.262, 4.407, 165.46), 1107)
    end

    if Blacksmith then
        Lifestream("The Aftcastle")
        QuestAccept("Randwulf", Vector3(-49.333, 42.8, 191.492), 291)
        QuestAccept("Randwulf", Vector3(-49.333, 42.8, 191.492), 291)
        QuestProgress("Brithael", Vector3(-28.567, 44.49, 185.293), 291)
    end

    if Armorer then
        Lifestream("The Aftcastle")
        QuestAccept("G'wahnako", Vector3(-48.546, 42.8, 190.851), 273)
        QuestAccept("G'wahnako", Vector3(-48.546, 42.8, 190.851), 273)
        QuestProgress("H'naanza", Vector3(-33.409, 41.499, 206.971), 273)
    end

    if Culinarian then
        Lifestream("The Aftcastle")
        QuestAccept("Charlys", Vector3(-63.183, 42.3, -160.612), 271)
        QuestAccept("Charlys", Vector3(-63.183, 42.3, -160.612), 271)
        QuestProgress("Lyngsath", Vector3(-55.366, 42.3, -155.636), 271)
    end

    if Carpenter then
        Lifestream("Gridania")
        Vnavmesh(Vector3(4.881, -1.816, 19.607), false)
        QuestAccept("Corgg", Vector3(-17.068, -3.25, 45.696), 138)
        QuestAccept("Corgg", Vector3(-17.068, -3.25, 45.696), 138)
        QuestProgress("Beatin", Vector3(-41.093, -3.25, 57.016), 138)
    end

    if Leatherworker then
        Lifestream("Leatherworkers")
        Vnavmesh(Vector3(52.885, 8.001, -137.143), false)
        QuestAccept("Randall", Vector3(61.823, 7.999, -145.448), 133)
        QuestAccept("Randall", Vector3(61.823, 7.999, -145.448), 133)
        QuestProgress("Geva", Vector3(70.282, 7.999, -164.433), 133)
    end

    if Botanist then
        Lifestream("Botanists' Guild")
        QuestAccept("Leonceault", Vector3(-238.078, 7.999, -146.104), 133)
        QuestAccept("Leonceault", Vector3(-238.078, 7.999, -146.104), 133)
        QuestProgress("Fufucha", Vector3(-235.204, 6.197, -168.78), 133)
    end
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Delete All Gearsets ||--
if DeleteAllTheGearsets then
    DeleteAllGearsets()
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Create Gearsets ||--
if CreateAllTheGearsets then
    ---------------------------------------------------------------------------------------
    --|| Current Class ||--
    if GearsetCurrentClass then
        EquipRecommendedGear()
        CreateGearset()
    end

    ---------------------------------------------------------------------------------------
    --|| Weaver ||--
    if GearsetWaver and Quests.IsQuestComplete(534) and Inventory.GetItemCount(2442) >= 1 then
        repeat
            yield("/equip 2442")
            Wait(1)
        until Player.Job.Name == 'weaver'
        if Player.Job.Name == 'weaver' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Miner ||--
    if GearsetMiner and Quests.IsQuestComplete(597) and Inventory.GetItemCount(2519) >= 1 then
        repeat
            yield("/equip 2519")
            Wait(1)
        until Player.Job.Name == 'miner'
        if Player.Job.Name == 'miner' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Goldsmith ||--
    if GearsetGoldsmith and Quests.IsQuestComplete(608) and Inventory.GetItemCount(2391) >= 1 then
        repeat
            yield("/equip 2391")
            Wait(1)
        until Player.Job.Name == 'goldsmith'
        if Player.Job.Name == 'goldsmith' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Alchemist ||--
    if GearsetAlchemist and Quests.IsQuestComplete(575) and Inventory.GetItemCount(2467) >= 1 then
        repeat
            yield("/equip 2467")
            Wait(1)
        until Player.Job.Name == 'alchemist'
        if Player.Job.Name == 'alchemist' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Fisher ||--
    if GearsetFisher and Quests.IsQuestComplete(1107) and Inventory.GetItemCount(2571) >= 1 then
        repeat
            yield("/equip 2571")
            Wait(1)
        until Player.Job.Name == 'fisher'
        if Player.Job.Name == 'fisher' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Blacksmith ||--
    if GearsetBlacksmith and Quests.IsQuestComplete(291) and Inventory.GetItemCount(2340) >= 1 then
        repeat
            yield("/equip 2340")
            Wait(1)
        until Player.Job.Name == 'blacksmith'
        if Player.Job.Name == 'blacksmith' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Armorer ||--
    if GearsetArmorer and Quests.IsQuestComplete(273) and Inventory.GetItemCount(2366) >= 1 then
        repeat
            yield("/equip 2366")
            Wait(1)
        until Player.Job.Name == 'armorer'
        if Player.Job.Name == 'armorer' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Culinarian ||--
    if GearsetCulinarian and Quests.IsQuestComplete(271) and Inventory.GetItemCount(2493) >= 1 then
        repeat
            yield("/equip 2493")
            Wait(1)
        until Player.Job.Name == 'culinarian'
        if Player.Job.Name == 'culinarian' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Carpenter ||--
    if GearsetCarpenter and Quests.IsQuestComplete(138) and Inventory.GetItemCount(2314) >= 1 then
        repeat
            yield("/equip 2314")
            Wait(1)
        until Player.Job.Name == 'carpenter'
        if Player.Job.Name == 'carpenter' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Leatherworker ||--
    if GearsetLeatherworker and Quests.IsQuestComplete(105) and Inventory.GetItemCount(2416) >= 1 then
        repeat
            yield("/equip 2416")
            Wait(1)
        until Player.Job.Name == 'leatherworker'
        if Player.Job.Name == 'leatherworker' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
    --|| Botanist ||--
    if GearsetBotanist and Quests.IsQuestComplete(3) and Inventory.GetItemCount(2545) >= 1 then
        repeat
            yield("/equip 2545")
            Wait(1)
        until Player.Job.Name == 'botanist'
        if Player.Job.Name == 'botanist' then
            EquipRecommendedGear()
            CreateGearset()
        end
    end

    ---------------------------------------------------------------------------------------
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| Buy Mats in Housing District ||--
if BuyMats and IsAetheryteUnlocked(UldahAetheryteId) then
    --|| Port to Western Thanalan ||--
    if GetZoneID() ~= 140 then
        Lifestream("Gate of the Sultana (Western Thanalan)")
    end

    --|| Walk into Goblet ||--
    Vnavmesh(Vector3(316.637, 67.160, 236.700), false)
    CallbackAddon("SelectString", 'true 1')
    CallbackAddon("HousingSelectBlock", 'true 0')
    CallbackAddon("SelectYesno", 'true 0')

    --|| Walk to Material Supplier ||--
    WaitWhileZoneTransition()
    Target("Aethernet Shard")
    yield("/lockon")
    yield("/automove")
    repeat
        Wait(1)
    until Player.IsMoving == false
    yield("/automove")

    Lifestream("Goblet Exchange")

    Target("Material Supplier")
    yield("/lockon")
    yield("/automove")
    repeat
        Interact()
        Wait(0.1)
    until Player.IsMoving == false or Addons.GetAddon("SelectIconString").Ready
    yield("/automove")

    --|| Buy Mats, Material Supplier ||--
    CallbackAddon("SelectIconString", 'true 0')

    -- Mudstone, 5229 x
    BuyItem_KeepStockAmount("Shop", "true 0 0", "0", 5229, MudstoneAmount)

    -- Elm Lumber 5367 x
    BuyItem_KeepStockAmount("Shop", "true 0 6", "0", 5367, ElmLumberAmount)

    CallbackAddon("Shop", 'true -1')

    ---------------------------------------------------------------------------------------
end

---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--|| End ||--
yield("/e Finished.")
