--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _ReturnButton: VisualElement = nil

--!Bind
local _Top10Line: VisualElement = nil

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

function self:Awake()
    _Title:SetPrelocalizedText("Kraken defeated!")
    _ReturnText:SetPrelocalizedText("Return to the Docks")

    _RewardLabel:SetPrelocalizedText("Your reward:")
end

function SetRewardsInfo(allFishCaught, fishCaught, reward, bonus)
    _Top10Line:Clear()

    if(bonus > 0) then
        local _bonusLabel = UILabel.new()
        _bonusLabel:AddToClassList("black-text")
        _bonusLabel:AddToClassList("tiny-text")
        _bonusLabel:SetPrelocalizedText("+ top 10% bonus: " .. bonus)
        _Top10Line:Add(_bonusLabel)

        local _goldIcon = Image.new()
        _goldIcon:AddToClassList("gold-icon")
        _Top10Line:Add(_goldIcon)
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