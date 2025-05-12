--!Type(UI)

local UIManagerModule = require("UIManagerModule")

--!Bind
local _TutorialContent: VisualElement = nil
--!Bind
local _ReturnButton: VisualElement = nil

--!Bind
local _Title: UILabel = nil
--!Bind
local _ReturnText: UILabel = nil

function self:Awake()
    _Title:SetPrelocalizedText("About the game")
    _ReturnText:SetPrelocalizedText("Let's fish!")

    CreateContent()
end

function CreateContent()
    for i = 0, 20 do
        local _label = UILabel.new()
        _label:AddToClassList("white-text")
        _label:AddToClassList("small-text")
        _label:SetPrelocalizedText("This is a random text")
        _TutorialContent:Add(_label)
    end
end

-- Register a callback for when the button is pressed
_ReturnButton:RegisterPressCallback(function()
    UIManagerModule.ClosePanel(self.gameObject)
    UIManagerModule.ShowHUD(true)
end)