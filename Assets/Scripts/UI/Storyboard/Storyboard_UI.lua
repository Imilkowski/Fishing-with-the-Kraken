--!Type(UI)

local GameManagerModule = require("GameManagerModule")
local UIManagerModule = require("UIManagerModule")
local TutorialModule = require("TutorialModule")

--!SerializeField
local storyboard : { Texture } = {}

--!Bind
local _TutorialImage: Image = nil

--!Bind
local _ContinueLabel: UILabel = nil

local currentImage = 1

function self:Awake()
    _TutorialImage.image = storyboard[currentImage]
    _ContinueLabel:SetPrelocalizedText("Click to continue")
end

function NextImage()
    currentImage += 1

    if(currentImage > #storyboard) then
        UIManagerModule.ClosePanel(self.gameObject)

        local tutorialVersion = TutorialModule.GetTutorialVersion()
        if(tutorialVersion > GameManagerModule.GetTutorialVersion()) then
            GameManagerModule.SetTutorialVersion(tutorialVersion)
            UIManagerModule.ShowTutorial(true)
        else
            UIManagerModule.ShowHUD(true)
        end

        return
    end

    _TutorialImage.image = storyboard[currentImage]
end

-- Register a callback for when the button is pressed
_TutorialImage:RegisterPressCallback(function()
    NextImage()
end)