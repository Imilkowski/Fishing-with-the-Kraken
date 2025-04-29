--!Type(Module)

local KrakenFightModule = require("KrakenFightModule")

--!SerializeField
local tentaclePrefab : GameObject = nil
--!SerializeField
local spawnRate : number = 0 
--!SerializeField
local tentaclesMaxCount : number = 0 

local spawnTentacle = Event.new("Spawn Tentacle")

local loadKrakenSpots = Event.new("Load Kraken Spots")
local loadKrakenSpotsResponse = Event.new("Load Kraken Spots Response")

local clearKrakenSpots = Event.new("Clear Kraken Spots")

local attackTentacle = Event.new("Attack Tentacle")
local tentacleHealthResponse = Event.new("Tentacle Health Response")

local tentacleTimer : Timer | nil = nil
spotsTentacles = {}
tentaclesCount = 0

-- [Server Side]

function self:ServerAwake()
    --Load Kraken Spots
    loadKrakenSpots:Connect(function(player: Player)
        loadKrakenSpotsResponse:FireClient(player, spotsTentacles)
    end)

    --Attack Tentacle
    attackTentacle:Connect(function(player: Player, spotId, damage)
        if(spotsTentacles[spotId] == nil) then return end

        spotsTentacles[spotId] -= damage

        tentacleHealthResponse:FireAllClients(spotId, spotsTentacles[spotId])

        if(spotsTentacles[spotId] <= 0) then
            spotsTentacles[spotId] = nil

            KrakenFightModule.TentacleDefeated()

            Timer.After(2, function()
                tentaclesCount -= 1
            end)
        end
    end)
end

function StartKrakenPhase()
    tentacleTimer = Timer.Every(spawnRate, SpawnTentacleRequest)
end

function SpawnTentacleRequest()
    if(tentaclesCount >= tentaclesMaxCount) then return end
    if(tentaclesCount >= KrakenFightModule.krakenHealth) then return end

    spotId = math.random(0, self.transform.childCount - 1)
    health = math.random(100, 150)

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

    Timer.After(2, function()
        clearKrakenSpots:FireAllClients()
    end)
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

    --Tentacle Health Response
    tentacleHealthResponse:Connect(function(spotId, health)
        DamageTentacle(spotId, health)
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

function DamageTentacle(spotId, health)
    local status, result = pcall(function()
        krakenPoint = self.transform:GetChild(spotId)
        tentacle = krakenPoint:GetChild(0):GetComponent(Tentacle)
    
        tentacle.ChangeHealth(health)
    end)
    
    if not status then
        print("An error occurred in KrakenSpotsModule: " .. result)
    end
end

function AttackTentacle(spotId, damage)
    attackTentacle:FireServer(spotId, damage)
end