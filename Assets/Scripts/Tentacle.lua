--!Type(Client)

local PlayerControllerModule = require("PlayerControllerModule")

--!SerializeField
local collectedNotification : GameObject = nil

--!SerializeField
local attackOrigin : Transform = nil
--!SerializeField
local attackRadius : number = 0

--!SerializeField
local sounds: { AudioClip } = nil

local animator : Animator

local health = 0

local rising = true

function self:Awake()
    animator = self:GetComponent(Animator)
end

function self:Start()
    self:GetComponent(AudioSource).pitch = Random.Range(0.9, 1.1)
    self:GetComponent(AudioSource):PlayOneShot(sounds[1])

    Timer.After(2, function()
        rising = false
    end)
end

function ChangeHealth(value)
    health = value

    if(health <= 0) then
        Die()
    end
end

function Die()
    animator:Play("Retreat")

    Timer.After(2, function()
        GameObject.Destroy(self.gameObject)
    end)
end

function Attack()
    if(rising) then return end

    randomAnimationId = math.random(1, 2)
    
    if(randomAnimationId == 1) then
        animator:Play("SlapL1")
    elseif(randomAnimationId == 2) then
        animator:Play("SlapR1")
    end

    Timer.After(0.75, function()
        self:GetComponent(AudioSource).pitch = Random.Range(0.8, 1.2)
        self:GetComponent(AudioSource):PlayOneShot(sounds[2])
    end)

    Timer.After(1, function()
        local distanceToPlayer = Vector3.Distance(client.localPlayer.character.transform.position, attackOrigin.position)

        if(distanceToPlayer <= attackRadius) then
            PlayerControllerModule.ChangePlayerState(client.localPlayer, "stunned")
        end
    end)
end

function SpawnNotification(damage)
    local spawnedNotification = Object.Instantiate(collectedNotification, self.transform.position + Vector3.new(0, 5, -2.5))
    spawnedNotification.transform.rotation = Quaternion.Euler(45, 0, 0)
    spawnedNotification:GetComponent(CollectedNotification_UI).SetText(damage, "Damage")
end