--!Type(Module)

--!SerializeField
local phaseInfos = {
    Preparation = {"Preparation", 5, "Fishing starts in:"}, --180
    Fishing = {"Fishing", 5, "Fishing ends in:"}, --300
    Kraken = {"Kraken", 0, "Defeat the Kraken"}
}

local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")
local KrakenSpotsModule = require("KrakenSpotsModule")
local KrakenFightModule = require("KrakenFightModule")

local trackPlayer = Event.new("Track Player")

local getPhaseInfo = Event.new("Get Phase Info")
local getPhaseInfoResponse = Event.new("Get Phase Info Response")

local startPreparationPhase = Event.new("Start Preparation Phase")
local startFishingPhase = Event.new("Start Fishing Phase")
local startKrakenPhase = Event.new("Start Kraken Phase")

players_storage = {}
phaseStartTime = nil
phase = ""

-- [Server Side]

function self:ServerAwake()
    --Track Player
    trackPlayer:Connect(function(player: Player)
        players_storage[player] = {
            player = player,
            generalInfo = {
                Gems = 0,
                MostFishCaught = 0,
                MostDamageDelt = 0,
            },
        }

        print(player.name .. " connected to the server")
    end)

    --Untrack Player
    game.PlayerDisconnected:Connect(function(player)
        players_storage[player] = nil
        print(player.name .. " disconnected from the server")
    end)

    --Get Phase Info
    getPhaseInfo:Connect(function(player: Player, onJoin)
        getPhaseInfoResponse:FireClient(player, phaseStartTime, phase, onJoin)
    end)
end

function self:ServerStart()
    print("SERVER STARTED")

    GameLoopStart()
end

function GameLoopStart()
    print("PREPARATION STARTED")

    phaseStartTime = os.time(os.date("*t"))
    phase = "Preparation"
end

function self:ServerFixedUpdate()
    CheckPhase()
end

function CheckPhase()
    if(phaseStartTime == nil) then return end
    if(phase == "Kraken") then return end

    timeLeft = phaseInfos[phase][2] - (os.time(os.date("*t")) - phaseStartTime)

    if(timeLeft <= 0) then
        ChangePhase()
    end
end

function ChangePhase()
    phaseStartTime = os.time(os.date("*t"))

    if(phase == "Preparation") then
        print("FISHING STARTED")

        phase = "Fishing"
        startFishingPhase:FireAllClients(phaseStartTime, phase)

        FishingSpotsModule.StartFishingPhase()
    elseif(phase == "Fishing") then
        print("KRAKEN STARTED")

        phase = "Kraken"
        startKrakenPhase:FireAllClients(phaseStartTime, phase)

        KrakenFightModule.SetKraken()
        FishingSpotsModule.StopFishingPhase()
        KrakenSpotsModule.StartKrakenPhase()
    elseif(phase == "Kraken") then
        print("PREPARATION STARTED")

        phase = "Preparation"
        startPreparationPhase:FireAllClients(phaseStartTime, phase)

        KrakenSpotsModule.StopKrakenPhase()
    end
end



-- [Client Side]



currentPhaseInfo = nil

function self:ClientAwake()
    trackPlayer:FireServer(client.localPlayer)

    --Get Phase Start Time Response
    getPhaseInfoResponse:Connect(function(st, p, onJoin)
        UpdatePhaseInfo(st, p)

        if(not onJoin) then return end

        if(currentPhaseInfo[1] == "Fishing") then
            FishingSpotsModule.LoadFishingSpots()
        end

        if(currentPhaseInfo[1] == "Kraken") then
            KrakenSpotsModule.LoadKrakenSpots()
        end
    end)

    --Start Preparation Phase
    startPreparationPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)
    end)

    --Start Fishing Phase
    startFishingPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)
    end)

    --Start Kraken Phase
    startKrakenPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)
    end)
end

function self:ClientStart()
    getPhaseInfo:FireServer(client.localPlayer, true)
end

function GetPhaseInfo()
    return currentPhaseInfo
end

function UpdatePhaseInfo(st, p)
    phaseStartTime = st
    currentPhaseInfo = phaseInfos[p]
    UIManagerModule.SetPhaseInfo(st, currentPhaseInfo)
end