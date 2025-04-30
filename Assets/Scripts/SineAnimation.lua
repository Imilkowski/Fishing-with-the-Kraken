--!Type(Client)

--!SerializeField
local targetTransform: Transform = nil
--!SerializeField
local speed:number = 1.0
--!SerializeField
local amplitude:number = 1.0
--!SerializeField
local randomTimeOffset:boolean = true
--!SerializeField
local positionAnimation:boolean = false

local startScale = targetTransform.localScale
local startPosition = targetTransform.position
local timeOffset = 0.0

function self:Start()
    if randomTimeOffset then
        timeOffset = Random.Range(0.0, 1.0)
    end
end

function self:Update()
    local animationScale = Mathf.Sin(Time.time * speed + timeOffset)

    if(positionAnimation) then
        targetTransform.position = Vector3.new(startPosition.x, startPosition.y + (amplitude * animationScale), startPosition.z)
    else
        targetTransform.localScale = startScale * amplitude * animationScale
    end
end