---@meta

----------------------------------------------------------------
-- SomethingNeedDoing / FFXIV LuaLS stub file
-- Built from the public Wrappers/*.cs files plus in-game API screenshots.
----------------------------------------------------------------

---@alias ActionType integer
---@enum InventoryType
InventoryType = {
    Inventory1 = 0,
    Inventory2 = 1,
    Inventory3 = 2,
    Inventory4 = 3,
    SaddleBag1 = 4,
    SaddleBag2 = 5,
    PremiumSaddleBag1 = 6,
    PremiumSaddleBag2 = 7,
}
---@alias ObjectKind integer
---@alias NodeType integer
---@alias FateState integer
---@alias FateRule integer
---@alias OceanFishingStatus integer
---@alias GrandCompany integer

----------------------------------------------------------------
-- Wrapper classes from Wrappers/*.cs
----------------------------------------------------------------

---@class ActionWrapper
---@field AdjustedActionId integer
---@field RecastTimeElapsed number
---@field RealRecastTimeElapsed number
---@field RecastTime number
---@field RealRecastTime number
---@field SpellCooldown number
---@field RealSpellCooldown number
local ActionWrapper = {}

---@return integer
function ActionWrapper:GetActionStatus() end

---@class AtkValueWrapper
---@field ValueString string
local AtkValueWrapper = {}

---@class NodeWrapper
---@field Id integer
---@field IsVisible boolean
---@field Text string
---@field NodeType NodeType
local NodeWrapper = {}

---@class AddonWrapper
---@field Exists boolean
---@field Ready boolean
---@field AtkValues AtkValueWrapper[]
---@field Nodes NodeWrapper[]
local AddonWrapper = {}

---@param index integer
---@return AtkValueWrapper
function AddonWrapper:GetAtkValue(index) end

---@param ... integer
---@return NodeWrapper
function AddonWrapper:GetNode(...) end

---@class AddonsNamespace
---@type AddonsNamespace
Addons = nil

---@param name string
---@return AddonWrapper
function Addons.GetAddon(name) end

---@class StatusWrapper
---@field StatusId integer
---@field Param integer
---@field RemainingTime number
---@field SourceObject EntityWrapper
local StatusWrapper = {}

---@class BuddyMemberWrapper
---@field EntityId integer
---@field CurrentHealth integer
---@field MaxHealth integer
---@field DataId integer
---@field Synced integer
---@field Status StatusWrapper[]
local BuddyMemberWrapper = {}

---@class CompanionInfoWrapper
---@field TimeLeft number
---@field BardingHead integer
---@field BardingChest integer
---@field BardingFeet integer
---@field CurrentXP integer
---@field Rank integer
---@field Stars integer
---@field SkillPoints integer
---@field DefenderLevel integer
---@field AttackerLevel integer
---@field HealerLevel integer
---@field ActiveCommand integer
---@field FavoriteFeed integer
---@field CurrentColorStainId integer
---@field Mounted boolean
---@field Name string
local CompanionInfoWrapper = {}

---@param buddyEquipId integer
---@return boolean
function CompanionInfoWrapper:IsBuddyEquipUnlocked(buddyEquipId) end

---@class PetInfoWrapper
---@field Order integer
---@field Stance integer
local PetInfoWrapper = {}

---@class BuddyWrapper
---@field BuddyMember BuddyMemberWrapper[]
---@field CompanionInfo CompanionInfoWrapper
---@field PetInfo PetInfoWrapper
local BuddyWrapper = {}

---@class Vector3
---@field X number
---@field Y number
---@field Z number
local Vector3Type = {}

---@param x number
---@param y number
---@param z number
---@return Vector3
function Vector3(x, y, z) end

---@class EntityWrapper
---@field Type ObjectKind
---@field Name string
---@field Position Vector3
---@field DistanceTo number
---@field ContentId integer
---@field AccountId integer
---@field CurrentWorld integer
---@field HomeWorld integer
---@field CurrentHp integer
---@field MaxHp integer
---@field HealthPercent number
---@field CurrentMp integer
---@field MaxMp integer
---@field Target EntityWrapper|nil
---@field IsCasting boolean
---@field IsTargetable boolean
---@field IsCastInterruptible boolean
---@field IsInCombat boolean
---@field HuntRank integer
---@field IsMounted boolean
---@field Status StatusWrapper[]|nil
---@field FateId integer
local EntityWrapper = {}

function EntityWrapper:SetAsTarget() end
function EntityWrapper:SetAsFocusTarget() end
function EntityWrapper:ClearTarget() end
function EntityWrapper:Interact() end

---@class EntityNamespace
---@field Target EntityWrapper|nil
---@field FocusTarget EntityWrapper|nil
local EntityNamespace = {}

---@type EntityNamespace
Entity = nil

---@class FateWrapper
---@field Id integer
---@field Exists boolean
---@field InFate boolean
---@field State FateState
---@field StartTimeEpoch integer
---@field Duration number
---@field Name string
---@field HandInCount number
---@field Location Vector3
---@field Progress number
---@field IsBonus boolean
---@field Radius number
---@field Rule FateRule
---@field Level integer
---@field MaxLevel integer
---@field FATEChain integer
---@field EventItem integer
---@field IconId integer
---@field DistanceToPlayer number
local FateWrapper = {}

---@class FreeCompanyWrapper
---@field GrandCompany GrandCompany
---@field Rank integer
---@field OnlineMemebers integer
---@field TotalMembers integer
---@field Name string
---@field Id integer
local FreeCompanyWrapper = {}

---@class JobWrapper
---@field Id integer
---@field Name string
---@field Abbreviation string
---@field IsCrafter boolean
---@field IsGatherer boolean
---@field IsMeleeDPS boolean
---@field IsRangedDPS boolean
---@field IsMagicDPS boolean
---@field IsHealer boolean
---@field IsTank boolean
---@field IsDPS boolean
---@field IsDiscipleOfWar boolean
---@field IsDiscipleOfMagic boolean
---@field IsBlu boolean
---@field IsLimited boolean
---@field Level integer
local JobWrapper = {}

---@class LimitBreakWrapper
---@field CurrentUnits integer
---@field BarUnits integer
---@field BarCount integer
local LimitBreakWrapper = {}

---@class OceanFishingWrapper
---@field CurrentRoute integer
---@field TimeOfDay integer
---@field Status OceanFishingStatus
---@field CurrentZone integer
---@field TimeLeft number
---@field TimeOffset integer
---@field WeatherId integer
---@field SpectralCurrentActive boolean
---@field Mission1Type integer
---@field Mission2Type integer
---@field Mission3Type integer
---@field Mission1Goal integer
---@field Mission2Goal integer
---@field Mission3Goal integer
---@field Mission1Progress integer
---@field Mission2Progress integer
---@field Mission3Progress integer
---@field Points integer
---@field Score integer
---@field TotalScore integer
local OceanFishingWrapper = {}

----------------------------------------------------------------
-- Extra wrappers inferred from in-game API screenshots
----------------------------------------------------------------

---@class InventoryItemWrapper
---@field ItemId integer
---@field BaseItemId integer
---@field Count integer
---@field SpiritbondOrCollectability number
---@field Condition number
---@field GlamourId integer
---@field IsHighQuality boolean
---@field IsCollectable boolean
---@field IsEmpty boolean
---@field LinkedItem InventoryItemWrapper|nil
---@field Container InventoryType
---@field Slot integer
---@field ArmouryContainer InventoryType
local InventoryItemWrapper = {}

function InventoryItemWrapper:Use() end
function InventoryItemWrapper:Desynth() end

---@param destinationContainer InventoryType
function InventoryItemWrapper:MoveItemSlot(destinationContainer) end

function InventoryItemWrapper:LowerQuality() end
function InventoryItemWrapper:Discard() end

---@param quantity integer
function InventoryItemWrapper:SplitItem(quantity) end

---@class InventoryContainerWrapper
---@field Count integer
---@field FreeSlots integer
---@field Items InventoryItemWrapper[]
local InventoryContainerWrapper = {}

---@class GearsetWrapper
local GearsetWrapper = {}

---@class BingoWrapper
local BingoWrapper = {}

----------------------------------------------------------------
-- Globals seen in the SND in-game API browser
----------------------------------------------------------------

---@type LimitBreakWrapper
LimitBreak = nil

---@class PlayerNamespace
---@field GrandCompany integer
---@field GCRankMaelstrom integer
---@field GCRankImmortalFlames integer
---@field GCRankTwinAdders integer
---@field FishingBait integer
---@field IsBusy boolean
---@field IsMoving boolean
---@field Entity EntityWrapper
---@field Job JobWrapper
local PlayerNamespace = {}

---@param classJobId integer
---@return JobWrapper
function PlayerNamespace:GetJob(classJobId) end

---@param id integer
---@return GearsetWrapper
function PlayerNamespace:GetGearset(id) end

---@type PlayerNamespace
Player = nil

---@type EntityWrapper
Target = nil

---@type EntityWrapper
FocusTarget = nil

----------------------------------------------------------------
-- Global functions seen in the SND in-game API browser
----------------------------------------------------------------

---@param actionID integer
---@param actionType? ActionType
function ExecuteAction(actionID, actionType) end

---@param actionID integer
function ExecuteGeneralAction(actionID) end

---@param aetheryteId integer
function Teleport(aetheryteId) end

function CancelCast() end

---@param actionType ActionType
---@param actionId integer
---@return integer
function GetActionStatus(actionType, actionId) end

---@param actionId integer
---@return ActionWrapper
function GetActionInfo(actionId) end

---@param msg any
function Log(msg) end

---@param msg any
function LogDebug(msg) end

---@param msg any
function LogVerbose(msg) end

---@param content string
function Run(content) end

---@param index integer
---@return EntityWrapper
function GetPartyMember(index) end

---@param index integer
---@return EntityWrapper
function GetAllianceMember(index) end

---@param name string
---@return EntityWrapper
function GetEntityByName(name) end

---@param container InventoryType
---@return InventoryContainerWrapper
function GetInventoryContainer(container) end

---@param container InventoryType
---@param slot integer
---@return InventoryItemWrapper
function GetInventoryItemBySlot(container, slot) end

---@param itemId integer
---@return integer
function GetItemCount(itemId) end

---@param itemId integer
---@return integer
function GetHqItemCount(itemId) end

---@param itemId integer
---@param minimumCollectability integer
---@return integer
function GetCollectableItemCount(itemId, minimumCollectability) end

---@return integer
function GetFreeInventorySlots() end

---@param itemId integer
---@return InventoryItemWrapper
function GetInventoryItem(itemId) end

---@param durability? integer
---@return InventoryItemWrapper[]
function GetItemsInNeedOfRepairs(durability) end

---@return InventoryItemWrapper[]
function GetSpiritbondedItems() end

---@param classJobId integer
---@return JobWrapper
function GetJob(classJobId) end

---@param id integer
---@return GearsetWrapper
function GetGearset(id) end


----------------------------------------------------------------
-- Additional namespaces / globals from SND screenshots
----------------------------------------------------------------

---@class TelepoNamespace
local TelepoNamespace = {}

---@param aetheryteId integer
---@return boolean
function TelepoNamespace:IsAetheryteUnlocked(aetheryteId) end

---@class InstancesNamespace
---@field Telepo TelepoNamespace
---@type InstancesNamespace
Instances = nil

---@class QuestsNamespace
---@type QuestsNamespace
Quests = nil

---@param questId integer
---@return boolean
function Quests.IsQuestComplete(questId) end

---@param questId integer
---@return boolean
function Quests.IsQuestAccepted(questId) end

---@class IPCPluginNamespace
local IPCPluginNamespace = {}

---@return boolean
function IPCPluginNamespace.IsReady() end

---@return boolean
function IPCPluginNamespace.IsBusy() end

function IPCPluginNamespace.Abort() end
function IPCPluginNamespace.Stop() end

---@param position Vector3
---@param fly boolean
function IPCPluginNamespace.PathfindAndMoveTo(position, fly) end

---@return boolean
function IPCPluginNamespace.PathfindInProgress() end

---@return boolean
function IPCPluginNamespace.IsRunning() end

---@class IPCNamespace
---@field InventoryTools IPCPluginNamespace
---@field ARDiscard IPCPluginNamespace
---@field Artisan IPCPluginNamespace
---@field AutoDuty IPCPluginNamespace
---@field AutoHook IPCPluginNamespace
---@field AutoRetainer IPCPluginNamespace
---@field BossMod IPCPluginNamespace
---@field Automaton IPCPluginNamespace
---@field Deliveroo IPCPluginNamespace
---@field Dropbox IPCPluginNamespace
---@field Lifestream IPCPluginNamespace
---@field vnavmesh IPCPluginNamespace
---@field PandorasBox IPCPluginNamespace
---@field Questionable IPCPluginNamespace
---@field TextAdvance IPCPluginNamespace
---@field Tippy IPCPluginNamespace
---@field visland IPCPluginNamespace
---@field WrathCombo IPCPluginNamespace
---@field YesAlready IPCPluginNamespace
---@type IPCNamespace
IPC = nil

---@param name string
---@return boolean
function IPC.IsInstalled(name) end

---@return any
function IPC.GetAvailablePlugins() end

---@param content string
function yield(content) end

---@type string
vnavmesh = "vnavmesh"

---@param name string
function import(name) end

---@class ActionsNamespace
---@type ActionsNamespace
Actions = nil

---@param actionId integer
---@return ActionWrapper
function Actions.GetActionInfo(actionId) end

---@param actionType ActionType
---@param actionId integer
---@return integer
function Actions.GetActionStatus(actionType, actionId) end

---@class InventoryNamespace
---@type InventoryNamespace
Inventory = nil

---@param itemId integer
---@return integer
function Inventory.GetItemCount(itemId) end

---@param itemId integer
---@return integer
function Inventory.GetHqItemCount(itemId) end

---@param itemId integer
---@param minimumCollectability integer
---@return integer
function Inventory.GetCollectableItemCount(itemId, minimumCollectability) end

---@param itemId integer
---@return InventoryItemWrapper
function Inventory.GetInventoryItem(itemId) end

---@param container InventoryType
---@return InventoryContainerWrapper
function Inventory.GetInventoryContainer(container) end

---@param container InventoryType
---@param slot integer
---@return InventoryItemWrapper
function Inventory.GetInventoryItemBySlot(container, slot) end

---@return integer
function Inventory.GetFreeInventorySlots() end

---@class ClientStateNamespace
---@field TerritoryType integer
local ClientStateNamespace = {}

---@class SvcNamespace
---@field ClientState ClientStateNamespace
---@field Condition table<integer, boolean>
---@type SvcNamespace
Svc = nil
