--!Type(Module)

local UIManagerModule = require("UIManagerModule")

function StartFishing(spotId)
    print("Started fishing at spot " .. spotId)

    client.localPlayer.character:PlayEmote("fishing-cast", false)
    UIManagerModule.ShowFishingUI(true)
end