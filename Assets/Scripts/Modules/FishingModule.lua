--!Type(Module)

local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")
local PlayerControllerModule = require("PlayerControllerModule")
local GameManagerModule = require("GameManagerModule")

local fishingAtSpot = 0

function StartFishing(spotId)
    print("Started fishing at spot " .. spotId)
    fishingAtSpot = spotId
    
    PlayerControllerModule.ChangePlayerState(client.localPlayer, "start fishing")

    UIManagerModule.ShowFishingUI(true)
end

function StopFishing(fishCaught)
    PlayerControllerModule.ChangePlayerState(client.localPlayer, "finish fishing")

    UIManagerModule.ShowFishingUI(false)

    if(fishingAtSpot == 0) then return end

    FishingSpotsModule.RemoveObject(fishingAtSpot)
    fishingAtSpot = 0
    
    GameManagerModule.AddFish(1)
end