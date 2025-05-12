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

function AddText(text)
    local _label = UILabel.new()
    _label:AddToClassList("black-text")
    _label:AddToClassList("tiny-text")
    _label:AddToClassList("tutorial-text")
    _label:SetPrelocalizedText(text)
    _TutorialContent:Add(_label)
end

function AddImage(name)
    local _imageContainer = VisualElement.new()
    _imageContainer:AddToClassList("image-container")
    _TutorialContent:Add(_imageContainer)

    local _image = Image.new()
    _image:AddToClassList("image")
    _image:AddToClassList(name .. "-image")
    _imageContainer:Add(_image)
end

function CreateContent()
    AddImage("tutorial_1")
    AddText("Fish, fight and earn rewards!")
    AddImage("tutorial_2")
    AddText("Gather together and collect as many fish you can. Look out for the treasures as they will grant you gems used to buy upgrades for the whole room!")
    AddImage("tutorial_3")
    AddText("Fight off the Kraken at the end by firing cannons! Watch out for the tentacle slams!")
    AddImage("tutorial_4")
    AddText("At the end receive the real treasure for the fish you've collected. Collaborate with others to maximize the rewards!")
end

-- Register a callback for when the button is pressed
_ReturnButton:RegisterPressCallback(function()
    UIManagerModule.ClosePanel(self.gameObject)
    UIManagerModule.ShowHUD(true)
end)