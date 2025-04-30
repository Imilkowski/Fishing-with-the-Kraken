--!Type(Client)

local FishingSpotsModule = require("FishingSpotsModule")
local GameManagerModule = require("GameManagerModule")

--!SerializeField
local gemsContained : number = 0

local fishingSpotId = 0

function SetFishingSpotId(id)
    fishingSpotId = id
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    FishingSpotsModule.RemoveObject(fishingSpotId)

    GameManagerModule.AddGems(gemsContained)
end)