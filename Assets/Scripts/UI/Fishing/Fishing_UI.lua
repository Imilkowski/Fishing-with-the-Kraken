--!Type(UI)

--!Bind
local _PullButton: VisualElement = nil

--!Bind
local _CatchArea: VisualElement = nil

--!Bind
local _PullLabel: UILabel = nil

local catchAreaDistance = 0
local velocity = 0

function self:Awake()
    _PullLabel:SetPrelocalizedText("Pull")
end

function self:FixedUpdate()
    catchAreaDistance += velocity

    if(catchAreaDistance < 0) then
        catchAreaDistance = 0
        velocity = -velocity / 4
    elseif(catchAreaDistance > 200) then
        catchAreaDistance = 200
        velocity = 0
    end

    _CatchArea.style.left = catchAreaDistance

    velocity -= 0.175
end

function Pull()
    if(velocity < 0) then
        velocity = 0
    end

    velocity += 4
end

-- Register a callback for when the button is pressed
_PullButton:RegisterPressCallback(function()
    Pull()
end)