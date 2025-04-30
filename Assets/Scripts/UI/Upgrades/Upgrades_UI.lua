--!Type(UI)

--!SerializeField
local UIManagerModule = require("UIManagerModule")

--!Bind
local _UpgradesParent: VisualElement = nil

--!Bind
local _Title: UILabel = nil
--!Bind
local _Currency: UILabel = nil

function self:Awake()
    _Title:SetPrelocalizedText("Upgrades")
    _Currency:SetPrelocalizedText("0")
end

function UpdateUpgradesList()
    _UpgradesParent:Clear()

    for i = 1, 3 do
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
        _title:SetPrelocalizedText("Title")
        _upgradeDetails:Add(_title)

        local _description = UILabel.new();
        _description:AddToClassList("white-text")
        _description:AddToClassList("tiny-text")
        _description:SetPrelocalizedText("Description")
        _upgradeDetails:Add(_description)

        local _upgradeButton = VisualElement.new();
        _upgradeButton:AddToClassList("upgrade-button")
        _upgradeDetails:Add(_upgradeButton)

        local _buttonLabel = UILabel.new();
        _buttonLabel:AddToClassList("white-text")
        _buttonLabel:AddToClassList("tiny-text")
        _buttonLabel:SetPrelocalizedText("Upgrade")
        _upgradeButton:Add(_buttonLabel)

        -- Register a callback for when the button is pressed
        _upgradeButton:RegisterPressCallback(function()
            
        end)
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