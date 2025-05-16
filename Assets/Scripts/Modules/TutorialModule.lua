--!Type(Module)

local PlayerControllerModule = require("PlayerControllerModule")

--!SerializeField
local tutorialVersion : number = 0

--!SerializeField
local arrowPrefab : GameObject = nil
--!SerializeField
local headArrowPrefab : GameObject = nil

--!SerializeField
local cannonBallCratesParent : Transform = nil
--!SerializeField
local cannonsParent : Transform = nil

local headArrow : Transform = nil

fishing = true
cannons = true

function self:ClientStart()
    headArrow = Object.Instantiate(headArrowPrefab, client.localPlayer.character.transform.position + Vector3.new(0, 5, 0)).transform
    headArrow.parent = client.localPlayer.character.transform
end

function self:ClientFixedUpdate()
    if(headArrow == nil) then return end

    if(self.transform.childCount == 0 or PlayerControllerModule.playerState == "cannon ball") then
        headArrow.gameObject:SetActive(false)
        return 
    end

    headArrow.gameObject:SetActive(true)

    local arrow = self.transform:GetChild(0)
    headArrow:LookAt(arrow.position)
end

function GetTutorialVersion()
    return tutorialVersion
end

function ResetTutorial()
    fishing = true
    cannons = true
end

function ClearArrows()
    for i = 0, self.transform.childCount - 1 do
        local arrow = self.transform:GetChild(i)
        
        GameObject.Destroy(arrow.gameObject)
    end
end

function SpawnArrow(pos)
    local spawnedArrow = Object.Instantiate(arrowPrefab, pos)
    spawnedArrow.transform.rotation = Quaternion.Euler(0, 90, 0)
    spawnedArrow.transform.parent = self.transform

    return spawnedArrow
end

function HighlightCannonBallCrates()
    ClearArrows()

    Timer.After(0.1, function()
        for i = 0, cannonBallCratesParent.childCount - 1 do
            local crate = cannonBallCratesParent:GetChild(i)
            
            SpawnArrow(crate.transform.position + Vector3.new(0, 2, 0))
        end
    end)
end

function HighlightCannons()
    ClearArrows()

    Timer.After(0.1, function()
        for i = 0, cannonsParent.childCount - 1 do
            local cannon = cannonsParent:GetChild(i)
            
            SpawnArrow(cannon.transform.position + Vector3.new(0, 2, 0))
        end
    end)
end