--!Type(Module)

--!SerializeField
local phaseInfos = {
    Preparation = {"Preparation", 180, "Fishing starts in:"},
    Fishing = {"Fishing", 300, "Kraken appears in:"},
    Kraken = {"Kraken"}
}

local UIManagerModule = require("UIManagerModule")

local trackPlayer = Event.new("Track Player")

local getPhaseInfo = Event.new("Get Phase Info")
local getPhaseInfoResponse = Event.new("Get Phase Info Response")

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
    end)

    --Untrack Player
    game.PlayerDisconnected:Connect(function(player)
        --CloudSaveModule.SavePlayerDataToCloud(player, players_storage[player])
        players_storage[player] = nil
    end)

    --Get Phase Start Time
    getPhaseInfo:Connect(function(player: Player)
        getPhaseInfoResponse:FireClient(player, phaseStartTime, phase)
    end)
end

function self:ServerStart()
    print("SERVER STARTED")

    GameLoopStart()
end

function GameLoopStart()
    print("GAME STARTED")

    phaseStartTime = os.time(os.date("*t"))
    phase = "Preparation"
end



-- [Client Side]



currentPhaseInfo = nil

function self:ClientAwake()
    trackPlayer:FireServer(client.localPlayer)

    --Get Phase Start Time Response
    getPhaseInfoResponse:Connect(function(st, p)
        phaseStartTime = st
        currentPhaseInfo = phaseInfos[p]
        UIManagerModule.SetPhaseInfo(st, currentPhaseInfo)
    end)
end

function self:ClientStart()
    getPhaseInfo:FireServer(client.localPlayer)
end

function GetPhaseInfo()
    return currentPhaseInfo
end