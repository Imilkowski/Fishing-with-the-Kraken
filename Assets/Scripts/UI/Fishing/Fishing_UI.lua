--!Type(UI)

local UIManagerModule = require("UIManagerModule")
local FishingModule = require("FishingModule")

--!Bind
local _PullButton: VisualElement = nil

--!Bind
local _CatchArea: VisualElement = nil
--!Bind
local _Progress: VisualElement = nil

--!Bind
local _Fish: Image = nil

--!Bind
local _PullLabel: UILabel = nil

local catchAreaDistance = 0
local ca_Velocity = 0

local fishDistance = 0

local catchProgress = 0

function self:Awake()
    _PullLabel:SetPrelocalizedText("Pull")
end

function ResetProperties()
    catchAreaDistance = 0
    ca_Velocity = 0
    catchProgress = 0
end

function self:FixedUpdate()
    MoveFish()
    MoveCatchArea()

    CheckCatch()
    Progress()
end

function MoveFish()
    fishDistance = SampleFishMotion(Time.time) * 260
    _Fish.style.left = fishDistance
end

function SampleFishMotion(time)
    value = 0.3 * math.sin(time * 1.0)
        + 0.2 * math.sin(time * 2.3 + 1.0)
        + 0.1 * math.sin(time * 3.7 + 2.5)

    value = (value + 0.6) / 1.2  -- adjust depending on max range
    return math.clamp(value, 0, 1)
end

function MoveCatchArea()
    catchAreaDistance += ca_Velocity

    if(catchAreaDistance < 0) then
        catchAreaDistance = 0
        ca_Velocity = -ca_Velocity / 4
    elseif(catchAreaDistance > 200) then
        catchAreaDistance = 200
        ca_Velocity = 0
    end

    _CatchArea.style.left = catchAreaDistance

    ca_Velocity -= 0.175
end

function Pull()
    if(ca_Velocity < 0) then
        ca_Velocity = 0
    end

    ca_Velocity += 3
end

function CheckCatch()
    if(fishDistance - catchAreaDistance > 84) then --too much to the right
        catchProgress -= 0.3
        catchProgress = math.clamp(catchProgress, 0, 100)
        return 
    end
    if(fishDistance - catchAreaDistance < -16) then --too much to the left
        catchProgress -= 0.3
        catchProgress = math.clamp(catchProgress, 0, 100)
        return 
    end

    catchProgress += 0.5
    catchProgress = math.clamp(catchProgress, 0, 100)
end

function Progress()
    _Progress.style.width = catchProgress * 3 --300px

    if(catchProgress == 100) then 
        FishCaught()
    end
end

function FishCaught()
    FishingModule.StopFishing(true)
end

-- Register a callback for when the button is pressed
_PullButton:RegisterPressCallback(function()
    Pull()
end)