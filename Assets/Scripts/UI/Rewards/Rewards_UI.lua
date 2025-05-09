--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _ReturnButton: VisualElement = nil

--!Bind
local _Top10Line: VisualElement = nil
--!Bind
local _TotalRewardLine: VisualElement = nil
--!Bind
local _FishCaught_2Line: VisualElement = nil

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

local allFishCaught
local fishCaught
local reward
local bonus

function self:Awake()
    _Title:SetPrelocalizedText("Kraken defeated!")
    _ReturnText:SetPrelocalizedText("Return to the Docks")

    _RewardLabel:SetPrelocalizedText("Your reward:")
end

function PrepareRewardInfo(afc, fc, r, b)
    allFishCaught = afc
    fishCaught = fc
    reward = r
    bonus = b
end

function SetRewardsInfo(prizePoolAvailable)
    _Top10Line:Clear()
    _TotalRewardLine:Clear()
    _FishCaught_2Line:Clear()

    if(prizePoolAvailable) then
        local _rewardLabel = UILabel.new()
        _rewardLabel:AddToClassList("white-text")
        _rewardLabel:AddToClassList("big-text")
        _rewardLabel:SetPrelocalizedText(reward + bonus)
        _TotalRewardLine:Add(_rewardLabel)

        local _goldIcon = Image.new()
        _goldIcon:AddToClassList("gold-big-icon")
        _TotalRewardLine:Add(_goldIcon)
        
        local _fishCaughtLabel = UILabel.new()
        _fishCaughtLabel:AddToClassList("black-text")
        _fishCaughtLabel:AddToClassList("tiny-text")
        _fishCaughtLabel:SetPrelocalizedText("Fish caught: " .. fishCaught)
        _FishCaught_2Line:Add(_fishCaughtLabel)

        local _goldIcon = Image.new()
        _goldIcon:AddToClassList("gold-icon")
        _FishCaught_2Line:Add(_goldIcon)

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
    else
        local _infoLabel = UILabel.new()
        _infoLabel:AddToClassList("black-text")
        _infoLabel:AddToClassList("small-text")
        _infoLabel:SetPrelocalizedText("Prize Pool Depleted")
        _TotalRewardLine:Add(_infoLabel)
    end

    _FishCaught:SetPrelocalizedText("Fish caught: " .. allFishCaught)

    _Contribution:SetPrelocalizedText("Your contribution: " .. fishCaught)
end

-- Register a callback for when the button is pressed
_ReturnButton:RegisterPressCallback(function()
    UIManagerModule.ClosePanel(self.gameObject)
    UIManagerModule.ShowHUD(true)
end)