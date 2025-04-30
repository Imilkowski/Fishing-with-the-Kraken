--!Type(UI)

--!SerializeField
local UIManagerModule = require("UIManagerModule")
local GameManagerModule = require("GameManagerModule")

--!Bind
local _UpgradesParent: VisualElement = nil

--!Bind
local _Title: UILabel = nil
--!Bind
local _Currency: UILabel = nil

function self:Awake()
    _Title:SetPrelocalizedText("Upgrades")
    _Currency:SetPrelocalizedText("-")
end

function UpdateUpgradesList()
    generalInfo = GameManagerModule.GetGeneralInfoLocal()
    _Currency:SetPrelocalizedText(generalInfo["Gems"])

    upgrades = GameManagerModule.GetUpgrades()

    _UpgradesParent:Clear()

    for i, v in ipairs(upgrades) do
        local _upgradeContainer = VisualElement.new();
        _upgradeContainer:AddToClassList("upgrade-container")
        _UpgradesParent:Add(_upgradeContainer)

        local _upgradeImage = Image.new();
        _upgradeImage:AddToClassList("upgrade-icon")
        _upgradeContainer:Add(_upgradeImage)

        local _upgradeDetails = VisualElement.new();
        _upgradeDetails:AddToClassList("upgrade-details")
        _upgradeContainer:Add(_upgradeDetails)

        local _title = UILabel.new();
        _title:AddToClassList("white-text")
        _title:AddToClassList("small-text")
        _title:SetPrelocalizedText(upgrades[i][1] .. " Lvl." .. upgrades[i][3])
        _upgradeDetails:Add(_title)

        local _description = UILabel.new();
        _description:AddToClassList("black-text")
        _description:AddToClassList("tiny-text")
        _description:SetPrelocalizedText(upgrades[i][2])
        _upgradeDetails:Add(_description)

        local _upgradeButton = VisualElement.new();
        _upgradeButton:AddToClassList("upgrade-button")
        _upgradeDetails:Add(_upgradeButton)

        local _buttonLabel = UILabel.new();
        _buttonLabel:AddToClassList("white-text")
        _buttonLabel:AddToClassList("tiny-text")
        _buttonLabel:SetPrelocalizedText("Upgrade")
        _upgradeButton:Add(_buttonLabel)

        if(upgrades[i][3] < GameManagerModule.maxUpgradeLevel) then
            local _gemsContainer = VisualElement.new();
            _gemsContainer:AddToClassList("button-currency-container")
            _upgradeButton:Add(_gemsContainer)
    
            local _gemsLabel = UILabel.new();
            _gemsLabel:AddToClassList("white-text")
            _gemsLabel:AddToClassList("tiny-text")
            _gemsLabel:SetPrelocalizedText(upgrades[i][4])
            _gemsContainer:Add(_gemsLabel)
    
            local _gemIcon = Image.new();
            _gemIcon:AddToClassList("button-gem-icon")
            _gemsContainer:Add(_gemIcon)

            if(generalInfo["Gems"] >= upgrades[i][4]) then
                -- Register a callback for when the button is pressed
                _upgradeButton:RegisterPressCallback(function()
                    GameManagerModule.BuyUpgrade(i)
                end)
            else
                _upgradeButton:RemoveFromClassList("upgrade-button")
                _upgradeButton:AddToClassList("inactive-button")
            end
        else
            _upgradeButton:RemoveFromClassList("upgrade-button")
            _upgradeButton:AddToClassList("inactive-button")

            _buttonLabel:SetPrelocalizedText("Max Level")
        end
    end

    local _returnButton = VisualElement.new();
    _returnButton:AddToClassList("return-button")
    _UpgradesParent:Add(_returnButton)

    local _buttonLabel = UILabel.new();
    _buttonLabel:AddToClassList("white-text")
    _buttonLabel:AddToClassList("small-text")
    _buttonLabel:SetPrelocalizedText("Return")
    _returnButton:Add(_buttonLabel)

    -- Register a callback for when the button is pressed
    _returnButton:RegisterPressCallback(function()
        UIManagerModule.ClosePanel(self.gameObject)
    end)
end