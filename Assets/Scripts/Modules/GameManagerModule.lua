--!Type(Module)

--!SerializeField
local _mainMusic: AudioShader = nil
--!SerializeField
local fishRewardMultiplier : number = 0
--!SerializeField
local bonusReward : number = 0

local phaseInfos = {
    Preparation = {"Preparation", 5, "Fishing starts in:"}, --120
    Fishing = {"Fishing", 5, "Fishing ends in:"}, --180
    Kraken = {"Kraken", 0, "Defeat the Kraken"}
}

local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")
local FishingModule = require("FishingModule")
local KrakenSpotsModule = require("KrakenSpotsModule")
local KrakenFightModule = require("KrakenFightModule")

local trackPlayer = Event.new("Track Player")

local getPhaseInfo = Event.new("Get Phase Info")
local getPhaseInfoResponse = Event.new("Get Phase Info Response")

local startPreparationPhase = Event.new("Start Preparation Phase")
local startFishingPhase = Event.new("Start Fishing Phase")
local startKrakenPhase = Event.new("Start Kraken Phase")

local updatePlayerInfo = Event.new("Update Player Info")
local updatePlayerInfoResponse = Event.new("Update Player Info Response")

local buyUpgrade = Event.new("Buy Upgrade")
local updateUpgrades = Event.new("Update Upgrades")

local prepareRewards = Event.new("Prepare Rewards")
local showRewards = Event.new("Show Rewards")

local generalInfoLocal = {}

maxUpgradeLevel = 5

players_storage = {}
phaseStartTime = nil
phase = ""
fishCaughtAll = 0

upgrades = {}

--!SerializeField
local upgradesIcons : { Texture } = {}

-- [Server Side]

function self:ServerAwake()
    ResetUpgrades()

    --Track Player
    trackPlayer:Connect(function(player: Player)
        players_storage[player] = {
            player = player,
            generalInfo = {
                Gems = 999,
                FishCaught = 0
            },
        }

        updatePlayerInfoResponse:FireClient(player, players_storage[player].generalInfo)
        updateUpgrades:FireClient(player, upgrades)

        if(phase == "Kraken") then
            KrakenFightModule.LoadKrakenHealth(player)
        end

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

    --Update Player Info
    updatePlayerInfo:Connect(function(player: Player, gems, fish)
        if(gems ~= 0) then
            players_storage[player].generalInfo["Gems"] += gems
        end

        if(fish ~= 0) then
            players_storage[player].generalInfo["FishCaught"] += fish
            fishCaughtAll += fish
        end

        updatePlayerInfoResponse:FireClient(player, players_storage[player].generalInfo)
    end)

    --Buy Upgrade
    buyUpgrade:Connect(function(player: Player, upgradeId)
        if(upgrades[upgradeId][3] < maxUpgradeLevel) then 
            if(players_storage[player].generalInfo["Gems"] >= upgrades[upgradeId][4]) then
                upgrades[upgradeId][3] += 1
                players_storage[player].generalInfo["Gems"] -= upgrades[upgradeId][4]
            end
        end

        updatePlayerInfoResponse:FireClient(player, players_storage[player].generalInfo)
        updateUpgrades:FireAllClients(upgrades)
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

        fishCaughtAll = 0

        FishingSpotsModule.StartFishingPhase()
    elseif(phase == "Fishing") then
        print("KRAKEN STARTED")

        phase = "Kraken"
        startKrakenPhase:FireAllClients(phaseStartTime, phase)

        KrakenFightModule.SetKraken(game.playerCount)
        FishingSpotsModule.StopFishingPhase()
        KrakenSpotsModule.StartKrakenPhase()
    elseif(phase == "Kraken") then
        ResetUpgrades()

        Timer.After(3, function()
            print("PREPARATION STARTED")

            phase = "Preparation"
            GiveOutRewards()
            startPreparationPhase:FireAllClients(phaseStartTime, phase)
    
            KrakenSpotsModule.StopKrakenPhase()

            Timer.After(3, function()
                fishCaughtAll = 0

                for k, v in pairs(players_storage) do
                    v.generalInfo["FishCaught"] = 0
                end
            end)
        end)
    end
end

function FindTopPlayers()
    data = {}

    for k, v in pairs(players_storage) do
        data[v.player] = v.generalInfo["FishCaught"]
    end

    local totalPlayers = 0
    for _ in pairs(data) do
        totalPlayers = totalPlayers + 1
    end

    local topCount = math.max(1, math.floor(totalPlayers * 0.1))  -- At least 1

    local sortedPlayers = {}
    for player, fishCount in pairs(data) do
        table.insert(sortedPlayers, {player = player, fishCount = fishCount})
    end

    table.sort(sortedPlayers, function(a, b)
        return a.fishCount > b.fishCount
    end)

    local topPlayers = {}
    for i = 1, topCount do
        table.insert(topPlayers, sortedPlayers[i].player)
    end

    return topPlayers
end

function GiveOutRewards()
    topPlayers = FindTopPlayers()

    for k, v in pairs(players_storage) do
        reward = math.floor(fishCaughtAll * fishRewardMultiplier)

        bonus = 0
        for i = 1, #topPlayers do
            if(topPlayers[i] == v.player) then
                bonus = bonusReward
            end
        end

        prepareRewards:FireClient(v.player, fishCaughtAll, v.generalInfo["FishCaught"], reward, bonus)
        TransferGold(v.player, reward + bonus)
    end
end

function TransferGold(player, amount)
    Wallet.TransferGoldToPlayer(player, amount, function(response, err)
        if err ~= WalletError.None then
            showRewards:FireClient(player, false)

            error("Error while transferring gold: " .. WalletError[err])
            return
        end

        showRewards:FireClient(player, true)

        print("Sent " .. amount .. " Gold, Gold remaining: : ", response.gold)
    end)
end

function ResetUpgrades()
    upgrades = { --name, description, level, base cost,
        {"Fishing Rod", "Faster fishing", 1, 25},
        {"Bait", "Fish appear faster", 1, 20},
        {"Cannons", "More damage delt", 1, 15}
    }

    updateUpgrades:FireAllClients(upgrades)
end



-- [Client Side]



currentPhaseInfo = nil

function self:ClientAwake()
    trackPlayer:FireServer(client.localPlayer)

    Audio:PlayMusic(_mainMusic, 0.15, true, true) -- Play the main music

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

        FishingModule.CancelFishing(false)
    end)

    --Update Player Info Response
    updatePlayerInfoResponse:Connect(function(generalInfo)
        generalInfoLocal = generalInfo
        UIManagerModule.UpdatePlayerInfo(generalInfoLocal)
    end)

    --Update Upgrades
    updateUpgrades:Connect(function(upgr)
        upgrades = upgr
        UIManagerModule.UpdateUpgrades()
    end)

    --Prepare Rewards
    prepareRewards:Connect(function(allFishCaught, fishCaught, r, b)
        UIManagerModule.PrepareRewards(allFishCaught, fishCaught, r, b)
    end)

    --Show Rewards
    showRewards:Connect(function(prizePoolAvailable)
        UIManagerModule.ShowRewards(prizePoolAvailable)
    end)
end

function self:ClientStart()
    getPhaseInfo:FireServer(client.localPlayer, true)
end

function GetPhaseInfo()
    return currentPhaseInfo
end

function GetUpgrades()
    return upgrades, upgradesIcons
end

function UpdatePhaseInfo(st, p)
    phaseStartTime = st
    currentPhaseInfo = phaseInfos[p]
    UIManagerModule.SetPhaseInfo(st, currentPhaseInfo)
end

function GetGeneralInfoLocal()
    return generalInfoLocal
end

function BuyUpgrade(upgradeId)
    buyUpgrade:FireServer(upgradeId)
end

function AddFish(amount)
    updatePlayerInfo:FireServer(0, amount)
end

function AddGems(amount)
    updatePlayerInfo:FireServer(amount, 0)
end