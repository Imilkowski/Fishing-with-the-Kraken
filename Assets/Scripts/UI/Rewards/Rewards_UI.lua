--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _ReturnButton: VisualElement = nil

--!Bind
local _Title: UILabel = nil
--!Bind
local _ReturnText: UILabel = nil

--!Bind
local _FishCaught: UILabel = nil
--!Bind
local _Contribution: UILabel = nil

--!Bind
local _RewardLabel: UILabel = nil

--!Bind
local _TotalReward: UILabel = nil

--!Bind
local _FishCaught_2: UILabel = nil
--!Bind
local _Top10: UILabel = nil

function self:Awake()
    _Title:SetPrelocalizedText("Kraken defeated!")
    _ReturnText:SetPrelocalizedText("Return to the Docks")

    _RewardLabel:SetPrelocalizedText("Your reward:")
end

function SetRewardsInfo(allFishCaught, fishCaught, reward, bonus)
    if(bonus > 0) then
        _Top10:SetPrelocalizedText("+ top 10% bonus: " .. bonus)
    else
        _Top10:SetPrelocalizedText("x")
    end

    _FishCaught:SetPrelocalizedText("Fish caught: " .. allFishCaught)

    _Contribution:SetPrelocalizedText("Your contribution: " .. fishCaught)

    _TotalReward:SetPrelocalizedText("" .. reward + bonus)

    _FishCaught_2:SetPrelocalizedText("Fish caught: " .. fishCaught)
end

-- Register a callback for when the button is pressed
_ReturnButton:RegisterPressCallback(function()
    UIManagerModule.ClosePanel(self.gameObject)
    UIManagerModule.ShowHUD(true)
end)