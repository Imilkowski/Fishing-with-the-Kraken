--!Type(Module)

local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")
local PlayerControllerModule = require("PlayerControllerModule")
local GameManagerModule = require("GameManagerModule")

local fishingAtSpot = 0

function StartFishing(spotId)
    --print("Started fishing at spot " .. spotId)
    fishingAtSpot = spotId
    
    PlayerControllerModule.ChangePlayerState(client.localPlayer, "start fishing")
    PlayerControllerModule.PlaySoundEffect(1, true)

    UIManagerModule.ShowFishingUI(true)
end

function StopFishing(fishCaught)
    PlayerControllerModule.ChangePlayerState(client.localPlayer, "finish fishing")
    PlayerControllerModule.StopSoundEffect()

    UIManagerModule.ShowFishingUI(false)

    if(fishingAtSpot == 0) then return end

    FishingSpotsModule.SpawnNotification(fishingAtSpot)
    FishingSpotsModule.RemoveObject(fishingAtSpot)
    fishingAtSpot = 0
    
    GameManagerModule.AddFish(1)
end

function CancelFishing(walkedAway)
    if(fishingAtSpot == 0) then return end

    if(not walkedAway) then
        PlayerControllerModule.ChangePlayerState(client.localPlayer, "finish fishing")
    end
    PlayerControllerModule.StopSoundEffect()

    UIManagerModule.ShowFishingUI(false)

    fishingAtSpot = 0
end