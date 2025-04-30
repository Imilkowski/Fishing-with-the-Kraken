--!Type(Client)

local PlayerControllerModule = require("PlayerControllerModule")

--!SerializeField
local attackOrigin : Transform = nil
--!SerializeField
local attackRadius : number = 0

local animator : Animator

local health = 0

function self:Awake()
    animator = self:GetComponent(Animator)
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
    randomAnimationId = math.random(1, 2)
    
    if(randomAnimationId == 1) then
        animator:Play("SlapL1")
    elseif(randomAnimationId == 2) then
        animator:Play("SlapR1")
    end

    Timer.After(1, function()
        local distanceToPlayer = Vector3.Distance(client.localPlayer.character.transform.position, attackOrigin.position)

        if(distanceToPlayer <= attackRadius) then
            PlayerControllerModule.ChangePlayerState(client.localPlayer, "stunned")
        end
    end)
end