--!Type(Module)

--!SerializeField
local fishPrefab : GameObject = nil
--!SerializeField
local treasurePrefab : GameObject = nil
--!SerializeField
local treasureChance : number = 0
--!SerializeField
local spawnRate : number = 0 

local spawnFishingObject = Event.new("Spawn Fishing Object")

local loadFishingSpots = Event.new("Load Fishing Spots")
local loadFishingSpotsResponse = Event.new("Load Fishing Spots Response")

local destroySpotObject = Event.new("Destroy Spot Object")
local destroySpotObjectResponse = Event.new("Destroy Spot Object Response")

local clearFishingSpots = Event.new("Clear Fishing Spots")

local fishingTimer : Timer | nil = nil
fishingSpotsObjects = {}

-- [Server Side]

function self:ServerAwake()
    --Load Fishing Spots
    loadFishingSpots:Connect(function(player: Player)
        loadFishingSpotsResponse:FireClient(player, fishingSpotsObjects)
    end)

    --Destroy Spot Object
    destroySpotObject:Connect(function(player: Player, spotId)
        fishingSpotsObjects[spotId] = nil
        destroySpotObjectResponse:FireAllClients(spotId)
    end)
end

function StartFishingPhase()
    fishingTimer = Timer.Every(spawnRate, SpawnFishingObject)
end

function SpawnFishingObject()
    spotId = math.random(0, self.transform.childCount - 1)

    objectType = "fish"
    tc = math.random(0, treasureChance)
    if(tc == treasureChance) then
        objectType = "treasure"
    end

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

    fishingSpotsObjects = {}
    clearFishingSpots:FireAllClients()
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

    --Destroy Spot Object Response
    destroySpotObjectResponse:Connect(function(spotId)
        DestroySpotObject(spotId)
    end)

    --Clear Fishing Spots
    clearFishingSpots:Connect(function()
        local parentTransform = self.transform
        for i = 0, parentTransform.childCount - 1 do
            local fs = parentTransform:GetChild(i)
            
            if(fs.childCount > 0) then
                GameObject.Destroy(fs:GetChild(0).gameObject)
            end
        end
    end)
end

function LoadFishingSpots()
    loadFishingSpots:FireServer(client.localPlayer)
end

function SpawnObject(spotId, objectType)
    fishingPoint = self.transform:GetChild(spotId)

    if(objectType == "fish") then
        local spawnedObject = Object.Instantiate(fishPrefab, fishingPoint.transform.position)
        spawnedObject.transform.parent = fishingPoint
        spawnedObject:GetComponent(Fish).SetFishingSpotId(spotId)
    elseif(objectType == "treasure") then
        local spawnedObject = Object.Instantiate(treasurePrefab, fishingPoint.transform.position)
        spawnedObject.transform.parent = fishingPoint
        spawnedObject.transform.rotation = Quaternion.Euler(0, math.random(0, 360), 0)
        spawnedObject:GetComponent(Treasure).SetFishingSpotId(spotId)
    end
end

function RemoveObject(spotId)
    destroySpotObject:FireServer(spotId)
end

function DestroySpotObject(spotId)
    local status, result = pcall(function()
        fishingPoint = self.transform:GetChild(spotId)
        object = fishingPoint:GetChild(0).gameObject
    
        GameObject.Destroy(object)
    end)
    
    if not status then
        print("An error occurred in FishingSpotsModule: " .. result)
    end
end