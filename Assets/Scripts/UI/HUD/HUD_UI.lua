--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _TentaclesParent: VisualElement = nil
--!Bind
local _FishCaughtParent: VisualElement = nil
--!Bind
local _BottomParent: VisualElement = nil

--!Bind
local _Currency: UILabel = nil
--!Bind
local _PhaseText: UILabel = nil
--!Bind
local _Countdown: UILabel = nil
--!Bind
local _Message: UILabel = nil

local _FishCaught: UILabel = nil

local startTime = nil
local phaseInfo = nil

local messageTimer : Timer | nil = nil

function self:Awake()
    _Currency:SetPrelocalizedText("0")
    _Message:SetPrelocalizedText("")
end

function self:Update()
    UpdateCountdown()
end

function SetGems(amount)
    _Currency:SetPrelocalizedText(amount)
end

function SetFishCaught(amount)
    if(_FishCaught == nil) then return end

    _FishCaught:SetPrelocalizedText(amount)
end

function SetPhaseInfo(st, cpi)
    startTime = st
    phaseInfo = cpi

    _PhaseText:SetPrelocalizedText(phaseInfo[3])

    if(phaseInfo[1] == "Preparation") then
        ShowUpgradesButton(true)
    else
        ShowUpgradesButton(false)
    end

    if(phaseInfo[1] == "Fishing") then
        ShowFishCaught(true)
    else
        ShowFishCaught(false)
    end
end

function ShowFishCaught(show)
    _FishCaughtParent:Clear()

    if(show) then
        local _fishContainer = VisualElement.new();
        _fishContainer:AddToClassList("fish-container")
        _FishCaughtParent:Add(_fishContainer)

        _FishCaught = UILabel.new();
        _FishCaught:AddToClassList("white-text")
        _FishCaught:AddToClassList("medium-text")
        _FishCaught:SetPrelocalizedText("0")
        _fishContainer:Add(_FishCaught)

        local _fishIcon = Image.new()
        _fishIcon:AddToClassList("fish-icon")
        _fishContainer:Add(_fishIcon)
    end
end

function ShowUpgradesButton(show)
    _BottomParent:Clear()

    if(show) then
        local _upgradesButton = VisualElement.new();
        _upgradesButton:AddToClassList("upgrades-button")
        _BottomParent:Add(_upgradesButton)

        local _label = UILabel.new()
        _label:AddToClassList("white-text")
        _label:AddToClassList("small-text")
        _label:SetPrelocalizedText("Upgrades")
        _upgradesButton:Add(_label)

        -- Register a callback for when the button is pressed
        _upgradesButton:RegisterPressCallback(function()
            UIManagerModule.ShowUpgrades(true)
        end)
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

function UpdateKrakenHealth(health)
    _TentaclesParent:Clear()

    for i = 1, health do
        local _tentacleImage = Image.new();
        _tentacleImage:AddToClassList("tentacle-icon")
        _TentaclesParent:Add(_tentacleImage)
    end
end

function ShowMessage(text)
    _Message:SetPrelocalizedText(text)

    if (messageTimer) then
        messageTimer:Stop()
        messageTimer = nil
    end

    messageTimer = Timer.After(4, HideMessage)
end

function HideMessage()
    _Message:SetPrelocalizedText("")
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