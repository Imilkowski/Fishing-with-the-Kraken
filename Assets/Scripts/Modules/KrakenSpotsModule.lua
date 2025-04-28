--!Type(Module)

--!SerializeField
local tentaclePrefab : GameObject = nil
--!SerializeField
local spawnRate : number = 0 
--!SerializeField
local tentaclesMaxCount : number = 0 

local spawnTentacle = Event.new("Spawn Tentacle")

local loadKrakenSpots = Event.new("Load Kraken Spots")
local loadKrakenSpotsResponse = Event.new("Load Kraken Spots Response")

local destroySpotTentacle = Event.new("Destroy Spot Tentacle")
local destroySpotTentacleResponse = Event.new("Destroy Spot Tentacle Response")

local clearKrakenSpots = Event.new("Clear Kraken Spots")

local tentacleTimer : Timer | nil = nil
spotsTentacles = {}
tentaclesCount = 0

-- [Server Side]

function self:ServerAwake()
    --Load Kraken Spots
    loadKrakenSpots:Connect(function(player: Player)
        loadKrakenSpotsResponse:FireClient(player, spotsTentacles)
    end)

    --Destroy Spot Tentacle
    destroySpotTentacle:Connect(function(player: Player, spotId)
        spotsTentacles[spotId] = nil
        tentaclesCount -= 1
        destroySpotTentacleResponse:FireAllClients(spotId)
    end)
end

function StartKrakenPhase()
    tentacleTimer = Timer.Every(spawnRate, SpawnTentacleRequest)
end

function SpawnTentacleRequest()
    if(tentaclesCount >= tentaclesMaxCount) then return end

    spotId = math.random(0, self.transform.childCount - 1)
    health = 100

    if(spotsTentacles[spotId] == nil) then
        spawnTentacle:FireAllClients(spotId)
        spotsTentacles[spotId] = health
        tentaclesCount += 1
    end

    --print("Spawned " .. objectType .. " on position ID " .. spotId)
end

function StopKrakenPhase()
    if (tentacleTimer) then
        tentacleTimer:Stop()
        tentacleTimer = nil
    end

    spotsTentacles = {}
    clearKrakenSpots:FireAllClients()
end

-- [Client Side]

function self:ClientAwake()
    --Spawn Tentacle
    spawnTentacle:Connect(function(spotId)
        SpawnTentacle(spotId)
    end)

    --Load Kraken Spots Response
    loadKrakenSpotsResponse:Connect(function(st)
        for k, v in pairs(st) do
            SpawnTentacle(k)
        end
    end)

    --Destroy Spot Tentacle Response
    destroySpotTentacleResponse:Connect(function(spotId)
        DestroyTentacle(spotId)
    end)

    --Clear Kraken Spots
    clearKrakenSpots:Connect(function()
        local parentTransform = self.transform
        for i = 0, parentTransform.childCount - 1 do
            local ks = parentTransform:GetChild(i)
            
            if(ks.childCount > 0) then
                GameObject.Destroy(ks:GetChild(0).gameObject)
            end
        end
    end)
end

function LoadKrakenSpots()
    loadKrakenSpots:FireServer(client.localPlayer)
end

function SpawnTentacle(spotId)
    krakenPoint = self.transform:GetChild(spotId)

    local spawnedObject = Object.Instantiate(tentaclePrefab, krakenPoint.transform.position)
    spawnedObject.transform.rotation = krakenPoint.rotation
    spawnedObject.transform.parent = krakenPoint
end

function RemoveTentacle(spotId)
    destroySpotTentacle:FireServer(spotId)
end

function DestroyTentacle(spotId)
    local status, result = pcall(function()
        krakenPoint = self.transform:GetChild(spotId)
        object = krakenPoint:GetChild(0).gameObject
    
        GameObject.Destroy(object)
    end)
    
    if not status then
        print("An error occurred in KrakenSpotsModule: " .. result)
    end
end