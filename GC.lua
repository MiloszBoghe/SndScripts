local STOP_AT_CHARACTER = "Shiden Satana"
local LOGIN_TIMEOUT_SEC = 5

-- change this to whatever you named the script in snd to stop only this script on fail
-- i defaulted it to "all" which just stops ALL scripts so if you run multiple scripts at the same time , change it :P
local SCRIPT_NAME = "all" 

local function Echo(msg)
    yield("/echo " .. tostring(msg))
end

local function Wait(seconds)
    yield("/wait " .. tostring(seconds))
end

local function CurrentCharacter()
    return Player.Entity.Name
end

function WaitWhileZoneTransition()
    repeat
        yield("/wait 0.001")
    until GetCharacterCondition(45, true) and GetCharacterCondition(51, true)
    repeat
        yield("/wait 0.001")
    until GetCharacterCondition(45, false) and GetCharacterCondition(51, false)
    if IPC.IsInstalled(vnavmesh) then
        repeat
            yield("/wait 0.001")
        until IPC.vnavmesh.IsReady()
    end
    WaitTillNotBusy()
end

local function GoToGC()
    yield("/li gc")
end


local function DoGrandCompanyTurnin()
    -- =========================================================
    -- TODO: Step 3 goes here
    -- Do the daily miner hand-in for the requested ore.
    -- Return true on success, false on failure.
    -- =========================================================
    return true
end

local function AlertAndStop()
    -- =========================================================
    -- TODO: Step 6 goes here
    -- Example placeholder alarm:
    -- yield('/echo <se.6> TURN-IN FAILED: ' .. reason)
    -- =========================================================
    yield("/echo failed turn in <se.11> <se.11> <se.11>")
    yield("/snd stop " .. SCRIPT_NAME)
end

local function SwitchToNextCharacter()
    yield("/k+")
end

---------------------------------------------------------------------------------------

local function RunOnce()
    local name = CurrentCharacter()
    Echo("Running GC loop for " .. tostring(name))

    GoToGC()

    WaitWhileZoneTransition() 

    -- 3) TODO turnins
    local ok = DoGrandCompanyTurnin()
    if not ok then
        AlertAndStop()
    end

    -- 4) Stop on last char
    if name == STOP_AT_CHARACTER then
        Echo("Reached stop character: " .. name)
        return false
    end

    SwitchToNextCharacter()

    -- 5) Wait for next login
    WaitWhileZoneTransition() 

    return true
end

while true do
    local continueLoop = RunOnce()
    if not continueLoop then
        break
    end
end

Echo("Character rotation finished.")