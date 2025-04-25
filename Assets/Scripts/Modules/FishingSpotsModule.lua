--!Type(Module)

--!SerializeField
local fishPrefab : GameObject = nil

local spawnFishingObject = Event.new("Spawn Fishing Object")

local loadFishingSpots = Event.new("Load Fishing Spots")
local loadFishingSpotsResponse = Event.new("Load Fishing Spots Response")

local fishingTimer : Timer | nil = nil
fishingSpotsObjects = {}

-- [Server Side]

function self:ServerAwake()
    --Load Fishing Spots
    loadFishingSpots:Connect(function(player: Player)
        loadFishingSpotsResponse:FireClient(player, fishingSpotsObjects)
    end)
end

function StartFishingPhase()
    fishingTimer = Timer.Every(1, SpawnFishingObject)
end

function SpawnFishingObject()
    posId = math.random(1, self.transform.childCount)
    objectType = "fish"

    if(fishingSpotsObjects[posId] == nil) then
        spawnFishingObject:FireAllClients(posId, objectType)
        fishingSpotsObjects[posId] = objectType
    end

    --print("Spawned " .. objectType .. " on position ID " .. posId)
end

function StopFishingPhase()
    if (fishingTimer) then
        fishingTimer:Stop()
        fishingTimer = nil
    end
end

-- [Client Side]

function self:ClientAwake()
    --Spawn Fishing Object
    spawnFishingObject:Connect(function(posId, objectType)
        SpawnObject(posId, objectType)
    end)

    --Load Fishing Spots Response
    loadFishingSpotsResponse:Connect(function(fso)
        for k, v in pairs(fso) do
            SpawnObject(k, v)
        end
    end)
end

function LoadFishingSpots()
    loadFishingSpots:FireServer(client.localPlayer)
end

function SpawnObject(posId, objectType)
    fishingPoint = self.transform:GetChild(posId)

    local spawnedObject = Object.Instantiate(fishPrefab, fishingPoint.transform.position)
    spawnedObject.transform.parent = fishingPoint
end