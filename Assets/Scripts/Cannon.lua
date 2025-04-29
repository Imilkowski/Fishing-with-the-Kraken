--!Type(Client)

--!SerializeField
local facingSpot : number = 0

local PlayerControllerModule = require("PlayerControllerModule")
local KrakenSpotsModule = require("KrakenSpotsModule")

function Fire()
    KrakenSpotsModule.AttackTentacle(facingSpot, 100)
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    if(PlayerControllerModule.carriesCannonBall == false) then return end

    PlayerControllerModule.CannonBallLeft()
        
    Fire()
end)