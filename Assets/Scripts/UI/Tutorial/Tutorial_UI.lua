--!Type(UI)

local UIManagerModule = require("UIManagerModule")

--!SerializeField
local tutorialImages : { Texture } = nil
--!SerializeField
local tutorialDescriptions : { string } = nil

--!Bind
local _Title: UILabel = nil

--!Bind
local _TutorialImage: Image = nil
--!Bind
local _TutorialDescription: UILabel = nil

--!Bind
local _NextButton : UIButton = nil
--!Bind
local _NextButtonLabel: UILabel = nil

local tutorialId

function self:Awake()
    _Title:SetPrelocalizedText("Tutorial")
    ResetTutorial()
end

function ResetTutorial()
    tutorialId = 1
    _TutorialImage.image = tutorialImages[1];
    _TutorialDescription:SetPrelocalizedText(tutorialDescriptions[1])
    _NextButtonLabel:SetPrelocalizedText("Next")
end

function NextTutorial()
    tutorialId += 1

    if(tutorialId == #tutorialImages) then
        _NextButtonLabel:SetPrelocalizedText("Close")
    elseif(tutorialId > #tutorialImages) then
        ResetTutorial()
        UIManagerModule.ClosePanel(self.gameObject)
        UIManagerModule.ShowHUD(true)
    end

    _TutorialImage.image = tutorialImages[tutorialId];
    _TutorialDescription:SetPrelocalizedText(tutorialDescriptions[tutorialId])
end

-- Register a callback for when the button is pressed
_NextButton:RegisterPressCallback(function()
    NextTutorial()
end)