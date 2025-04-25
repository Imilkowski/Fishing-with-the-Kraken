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
    spotId = math.random(1, self.transform.childCount)
    objectType = "fish"

    if(fishingSpotsObjects[spotId] == nil) then
        spawnFishingObject:FireAllClients(spotId, objectType)
        fishingSpotsObjects[spotId] = objectType
    end

    --print("Spawned " .. objectType .. " on position ID " .. spotId)
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
    spawnFishingObject:Connect(function(spotId, objectType)
        SpawnObject(spotId, objectType)
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

function SpawnObject(spotId, objectType)
    fishingPoint = self.transform:GetChild(spotId)

    local spawnedObject = Object.Instantiate(fishPrefab, fishingPoint.transform.position)
    spawnedObject.transform.parent = fishingPoint
    spawnedObject:GetComponent(Fish).SetFishingSpotId(spotId)
end