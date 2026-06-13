require('HelperFunctions')

local missionIds = {
    [16] = 1621,
    [17] = 1649
}

JobId = Player.Job.Id
local missionId = missionIds[JobId]

local function RestoreIntegrity()
    Eureka = HasStatus(STATUS_IDS.WISE_TO_THE_WORLD)
    while GetIntegrity() <= 3 and (GetGp() >= 300 or Eureka) do
        if (Eureka) then
            Echo("Using Wise to the World")
            Action(ACTIONS.WISE_TO_THE_WORLD)
        end

        if GetGp() >= 300 and GetIntegrity() < 4 then
            Echo("Using Solid Reason / Ageless Words")
            Action(ACTIONS.INTEGRITY_RESTORE)
            Eureka = HasStatus(STATUS_IDS.WISE_TO_THE_WORLD)
        end
    end
end

local function Opener()
    Echo("Starting opener")
    Action(ACTIONS.DUTY_ACTION_2)
    Wait(0.5)
    Action(ACTIONS.PRIMING_TOUCH)
    Action(ACTIONS.METICULOUS)
    Echo("Opener complete")
end

local function MaxQuality()
    Echo("Maximizing quality")
    Action(ACTIONS.DUTY_ACTION_2)
    if GetIntegrity() > 1 and GetCollectability() < 1000 then
        Echo("Using Meticulous Touch")
        Action(ACTIONS.METICULOUS)
    end

    if GetIntegrity() <= 3 then
        RestoreIntegrity()
    end
end

local function CollectNode()
    if (GetIntegrity() <= 3) then
        RestoreIntegrity()
    end
    Echo("Collecting node")
    Action(ACTIONS.COLLECT)
    Wait(1.5)
end



while true do
    while GetGp() < 985 do
        Echo("GP is too low, waiting...")
        Wait(5)
    end
    local repairGear = RepairGear()
    if (repairGear) then
        Echo("Repairing gear")
        Wait(10)
    end

    CurrentMission = GetCurrentMission()
    Wait(1)

    if not CurrentMission then
        StartMission(missionId)
        Wait(2)
        CurrentMission = GetCurrentMission()
    end
    Wait(0.2)

    if (CurrentMission and GetIntegrity() > 0) then
        if (GetCollectability() < 1000) then
            Opener()
        end

        while GetCollectability() < 1000 do
            MaxQuality()
        end

        while GetIntegrity() > 0 do
            CollectNode()
        end
        Wait(1)
        CurrentMission = SubmitReport()
        Wait(2)
        CurrentMission = AbandonMission()
    elseif CurrentMission then
        CurrentMission = SubmitReport()
    end
end
