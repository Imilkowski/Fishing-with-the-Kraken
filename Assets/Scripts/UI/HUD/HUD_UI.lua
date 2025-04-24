--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _LeaderboardButton: VisualElement = nil

--!Bind
local _Currency: UILabel = nil
--!Bind
local _PhaseText: UILabel = nil
--!Bind
local _Countdown: UILabel = nil

local startTime = nil
local phaseInfo = nil

function self:Awake()
    _Currency:SetPrelocalizedText("0")
end

function self:Update()
    UpdateCountdown()
end

-- Register a callback for when the button is pressed
_LeaderboardButton:RegisterPressCallback(function()
    UIManagerModule.ShowLeaderboard()
end)

function SetPhaseInfo(st, cpi)
    startTime = st
    phaseInfo = cpi

    if(phaseInfo[1] == "Kraken") then
        _PhaseText:SetPrelocalizedText("")
    else
        _PhaseText:SetPrelocalizedText(phaseInfo[3])
    end
end

function UpdateCountdown()
    if(startTime == nil) then return end

    if(phaseInfo[1] == "Kraken") then
        _Countdown:SetPrelocalizedText("")
    else
        timeLeft = phaseInfo[2] - (os.time(os.date("*t")) - startTime)

        _Countdown:SetPrelocalizedText(FormatTime(timeLeft))
    end
end

function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    local parts = {}

    if h > 0 then
        table.insert(parts, h .. "h")
    end
    if m > 0 then
        table.insert(parts, m .. "m")
    end
    if s > 0 or (#parts == 0) then
        table.insert(parts, s .. "s")
    end

    return table.concat(parts, " ")
end