--!Type(Client)

local FishingModule = require("FishingModule")
local TutorialModule = require("TutorialModule")

--!SerializeField
local tapEffect : GameObject = nil

local fishingSpotId = 0

local tutorialArrow = nil

function self:OnDestroy()
    if(tutorialArrow == nil) then return end

    GameObject.Destroy(tutorialArrow)
end

function SetFishingSpotId(id)
    fishingSpotId = id
end

function SetTutorialArrow(arrow)
    tutorialArrow = arrow
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    local spawnedEffect = Object.Instantiate(tapEffect, self.transform.position + Vector3.new(0, 0.5, 0))

    FishingModule.StartFishing(fishingSpotId)

    Timer.After(0.5, function()
        self:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
        self:GetComponent(AudioSource):Play()
    end)

    TutorialModule.fishing = false
    TutorialModule.ClearArrows()
end)