--!Type(Client)

local FishingModule = require("FishingModule")

--!SerializeField
local tapEffect : GameObject = nil

local fishingSpotId = 0

function SetFishingSpotId(id)
    fishingSpotId = id
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    local spawnedEffect = Object.Instantiate(tapEffect, self.transform.position + Vector3.new(0, 0.5, 0))

    FishingModule.StartFishing(fishingSpotId)

    Timer.After(0.5, function()
        self:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
        self:GetComponent(AudioSource):Play()
    end)
end)