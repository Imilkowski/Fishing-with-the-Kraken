--!Type(Client)

local FishingModule = require("FishingModule")

local fishingSpotId = 0

function SetFishingSpotId(id)
    fishingSpotId = id
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    FishingModule.StartFishing(fishingSpotId)
end)