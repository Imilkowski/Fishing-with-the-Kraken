--!Type(Client)

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