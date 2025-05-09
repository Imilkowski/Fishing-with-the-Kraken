--!Type(Client)

local GameManagerModule = require("GameManagerModule")

--!SerializeField
local shotEffect : ParticleSystem = nil
--!SerializeField
local tapEffect : GameObject = nil

--!SerializeField
local facingSpot : number = 0

local PlayerControllerModule = require("PlayerControllerModule")
local KrakenSpotsModule = require("KrakenSpotsModule")

function Fire()
    KrakenSpotsModule.AttackTentacle(facingSpot, GetDamageValue())
end

function GetDamageValue()
    cannonUpgrade = GameManagerModule.GetUpgrades()[3][3] - 1
    return 20 + (cannonUpgrade * 5)
end

function ShotEffect()
    shotEffect:Play()

    shotEffect:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
    shotEffect:GetComponent(AudioSource):Play()
end

function GetSpotId()
    return facingSpot
end

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    local spawnedEffect = Object.Instantiate(tapEffect, self.transform.position + Vector3.new(0, 1.25, 0))

    if(PlayerControllerModule.carriesCannonBall == false) then return end

    PlayerControllerModule.CannonBallLeft()
        
    Fire()
end)