--!Type(Client)

local GameManagerModule = require("GameManagerModule")
local PlayerControllerModule = require("PlayerControllerModule")

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    phaseInfo = GameManagerModule.GetPhaseInfo()

    if(phaseInfo[1] ~= "Kraken") then return end
    if(PlayerControllerModule.carriesCannonBall) then return end

    PlayerControllerModule.CarryCannonBall()
end)