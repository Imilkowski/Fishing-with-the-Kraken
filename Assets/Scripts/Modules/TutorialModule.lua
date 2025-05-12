--!Type(Module)

--!SerializeField
local arrowPrefab : GameObject = nil

--!SerializeField
local cannonBallCratesParent : Transform = nil
--!SerializeField
local cannonsParent : Transform = nil

fishing = true
cannons = true

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