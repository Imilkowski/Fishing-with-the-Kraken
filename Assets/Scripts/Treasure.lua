--!Type(Client)

local FishingSpotsModule = require("FishingSpotsModule")
local GameManagerModule = require("GameManagerModule")

--!SerializeField
local tapEffect : GameObject = nil
--!SerializeField
local collectedNotification : GameObject = nil

--!SerializeField
local gemsContained : number = 0

local fishingSpotId = 0

local tutorialArrow = nil

local tapped = false

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

function SpawnNotification()
    local spawnedNotification = Object.Instantiate(collectedNotification, self.transform.position + Vector3.new(0, 1, 0))
    spawnedNotification.transform.rotation = Quaternion.Euler(45, 0, 0)
    spawnedNotification:GetComponent(CollectedNotification_UI).SetText(gemsContained, "Gems")
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    if(tapped == true) then return end
    tapped = true

    local spawnedEffect = Object.Instantiate(tapEffect, self.transform.position + Vector3.new(0, 0.5, 0))

    SpawnNotification()
    
    FishingSpotsModule.RemoveObject(fishingSpotId)

    GameManagerModule.AddGems(gemsContained)

    self:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
    self:GetComponent(AudioSource):Play()
end)