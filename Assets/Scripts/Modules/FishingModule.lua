--!Type(Module)

local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")

local fishingAtSpot = 0

function StartFishing(spotId)
    print("Started fishing at spot " .. spotId)
    fishingAtSpot = spotId

    client.localPlayer.character:PlayEmote("fishing-cast", false, function()
        client.localPlayer.character:PlayEmote("fishing-idle", true)
    end)

    UIManagerModule.ShowFishingUI(true)
end

function StopFishing(fishCaught)
    client.localPlayer.character:PlayEmote("fishing-pull", false)

    UIManagerModule.ShowFishingUI(false)

    if(fishingAtSpot == 0) then return end

    FishingSpotsModule.RemoveObject(fishingAtSpot)
    fishingAtSpot = 0
    
    print("Fish caught")
end