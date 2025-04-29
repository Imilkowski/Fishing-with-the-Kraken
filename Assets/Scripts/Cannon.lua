--!Type(Client)

--!SerializeField
local shotEffect : ParticleSystem = nil

--!SerializeField
local facingSpot : number = 0

local PlayerControllerModule = require("PlayerControllerModule")
local KrakenSpotsModule = require("KrakenSpotsModule")

function Fire()
    KrakenSpotsModule.AttackTentacle(facingSpot, 100)
end

function ShotEffect()
    shotEffect:Play()
end

function GetSpotId()
    return facingSpot
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    if(PlayerControllerModule.carriesCannonBall == false) then return end

    PlayerControllerModule.CannonBallLeft()
        
    Fire()
end)