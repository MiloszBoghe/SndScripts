require('HelperFunctions')

local function Opener()
    Action(ACTIONS.DUTY_ACTION_2)
    Action(ACTIONS.PRIMING_TOUCH)
    Action(ACTIONS.METICULOUS)
end

local function MaxQuality()
    Action(ACTIONS.DUTY_ACTION_2)
    local integrity = GetIntegrity()
    if (integrity > 1) then
        Echo("Using Meticulous Touch")
        Action(ACTIONS.METICULOUS)
    else
        Echo("Using Wise to the World")
        Action(ACTIONS.WISE_TO_THE_WORLD)
        Echo("Integrity is low, using Solid Reason")
        Action(ACTIONS.SOLID_REASON)
    end
end

local function CollectNode()
    local gp = GetGp()
    local integrity = GetIntegrity()

    if (integrity <= 3) then
        Echo("Using Wise to the World")
        Action(ACTIONS.WISE_TO_THE_WORLD)
        if (GetIntegrity() <= 3 and gp >= 300) then
            Echo("using Solid Reason")
            Action(ACTIONS.SOLID_REASON)
        end
    end
    Echo("Collecting node")
    Action(ACTIONS.COLLECT)
    Wait(1.5)
end

while true do
    local repairGear = RepairGear()
    if (repairGear) then
        Echo("Repairing gear")
        Wait(10)
    end

    CurrentMission = GetCurrentMission()
    Wait(1)

    if not CurrentMission then
        StartMission()
        Wait(2)
        CurrentMission = GetCurrentMission()
    end
    Wait(0.2)

    if (CurrentMission and GetIntegrity() > 0) then
        Opener()

        repeat
            MaxQuality()
            Wait(2)
        until GetCollectability() == 1000

        repeat
            CollectNode()
        until GetIntegrity() == 0
        Wait(2)
        CurrentMission = SubmitReport()
    elseif CurrentMission then
        CurrentMission = SubmitReport()
    end
end
