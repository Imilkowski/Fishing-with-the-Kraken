--!Type(UI)

local UIManagerModule = require("UIManagerModule")

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
        UIManagerModule.ShowHUD(true)
        return
    end

    _TutorialImage.image = storyboard[currentImage]
end

-- Register a callback for when the button is pressed
_TutorialImage:RegisterPressCallback(function()
    NextImage()
end)