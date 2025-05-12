--!Type(Client)

local GameManagerModule = require("GameManagerModule")
local PlayerControllerModule = require("PlayerControllerModule")
local TutorialModule = require("TutorialModule")

--!SerializeField
local tapEffect : GameObject = nil

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    local spawnedEffect = Object.Instantiate(tapEffect, self.transform.position + Vector3.new(0, 1.25, 0))

    phaseInfo = GameManagerModule.GetPhaseInfo()

    if(phaseInfo[1] ~= "Kraken") then return end
    if(PlayerControllerModule.carriesCannonBall) then return end

    PlayerControllerModule.CarryCannonBall()

    self:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
    self:GetComponent(AudioSource):Play()

    if(TutorialModule.cannons) then
        TutorialModule.HighlightCannons()
    end
end)