--!Type(Module)

--!SerializeField
local _mainMusic: AudioShader = nil
--!SerializeField
local fishRewardMultiplier : number = 0
--!SerializeField
local bonusReward : number = 0

local phaseInfos = {
    Preparation = {"Preparation", 45, "Round starts soon!"}, --45
    Fishing = {"Fishing", 180, "Collect as many fish as you can for the village!"}, --180
    Kraken = {"Kraken", 180, "The Kraken's here to steal your catch! Load up the cannons and fight off the Kraken!"} --180
}

local CloudSaveModule = require("CloudSaveModule")
local UIManagerModule = require("UIManagerModule")
local FishingSpotsModule = require("FishingSpotsModule")
local FishingModule = require("FishingModule")
local KrakenSpotsModule = require("KrakenSpotsModule")
local KrakenFightModule = require("KrakenFightModule")
local TutorialModule = require("TutorialModule")

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

local showMessage = Event.new("Show Message")

local updateTutorialVersion = Event.new("Update Tutorial Version")

local localStorage = nil

maxUpgradeLevel = 5
currentMessageText = ""

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
                Gems = 0,
                FishCaught = 0
            },
            tutorialVersion = 0
        }

        updatePlayerInfoResponse:FireClient(player, players_storage[player])
        updateUpgrades:FireClient(player, upgrades)

        CloudSaveModule.LoadPlayerDataFromCloud(player)

        if(phase == "Kraken") then
            KrakenFightModule.LoadKrakenHealth(player)
        end

        print(player.name .. " connected to the server")
    end)

    --Untrack Player
    game.PlayerDisconnected:Connect(function(player)
        CloudSaveModule.SavePlayerDataToCloud(player, players_storage[player])
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

            if(fishCaughtAll % 100 == 0) then
                showMessage:FireAllClients("You've caught " .. fishCaughtAll .. " fish together! Keep going!")
            end
        end

        CloudSaveModule.SavePlayerDataToCloud(player, players_storage[player])
        updatePlayerInfoResponse:FireClient(player, players_storage[player])
    end)

    --Buy Upgrade
    buyUpgrade:Connect(function(player: Player, upgradeId)
        if(upgrades[upgradeId][3] < maxUpgradeLevel) then 
            if(players_storage[player].generalInfo["Gems"] >= upgrades[upgradeId][4]) then
                upgrades[upgradeId][3] += 1
                players_storage[player].generalInfo["Gems"] -= upgrades[upgradeId][4]
                
                CloudSaveModule.SavePlayerDataToCloud(player, players_storage[player])

                updatePlayerInfoResponse:FireClient(player, players_storage[player])
                updateUpgrades:FireAllClients(upgrades)
                showMessage:FireAllClients(player.name .. " upgraded " .. upgrades[upgradeId][1] .. " to level " .. upgrades[upgradeId][3])
            end
        end
    end)

    --Update Tutorial Version
    updateTutorialVersion:Connect(function(player: Player, version)
        players_storage[player].tutorialVersion = version
        CloudSaveModule.SavePlayerDataToCloud(player, players_storage[player])
    end)
end

function self:ServerStart()
    print("SERVER STARTED")

    GameLoopStart()
end

function self:ServerFixedUpdate()
    CheckPhase()
end

function LoadData(player, dataType, data)
    if(data == nil) then
        return
    end

    if(dataType == "Gems") then
        players_storage[player].generalInfo["Gems"] = data
    end

    if(dataType == "Tutorial") then
        players_storage[player].tutorialVersion = data
    end

    updatePlayerInfoResponse:FireClient(player, players_storage[player])
end

function GameLoopStart()
    print("PREPARATION STARTED")

    phaseStartTime = os.time(os.date("*t"))
    phase = "Preparation"
end

function CheckPhase()
    if(phaseStartTime == nil) then return end

    timeLeft = phaseInfos[phase][2] - (os.time(os.date("*t")) - phaseStartTime)

    if(timeLeft <= 0) then
        ChangePhase()
    end

    if(timeLeft == 30 and phase == "Kraken") then
        ShowMessage("Hurry up, the time's ticking!")
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
        print("PREPARATION STARTED")

        phase = "Preparation"
        startPreparationPhase:FireAllClients(phaseStartTime, phase)

        ResetUpgrades()

        local delay = 0
        local krakenDefeated = false
        if(KrakenFightModule.krakenHealth <= 0) then
            delay = 3
            krakenDefeated = true
        end

        KrakenFightModule.ResetKrakenHealth()

        Timer.After(delay, function()
            KrakenSpotsModule.StopKrakenPhase()
            
            GiveOutRewards(krakenDefeated)

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
    local topPlayers = {}

    for k, v in pairs(players_storage) do
        data[v.player] = v.generalInfo["FishCaught"]
    end

    local totalPlayers = 0
    for _ in pairs(data) do
        totalPlayers = totalPlayers + 1
    end

    if(totalPlayers == 1) then return topPlayers end

    local topCount = math.max(1, math.floor(totalPlayers * 0.1))  -- At least 1

    local sortedPlayers = {}
    for player, fishCount in pairs(data) do
        table.insert(sortedPlayers, {player = player, fishCount = fishCount})
    end

    table.sort(sortedPlayers, function(a, b)
        return a.fishCount > b.fishCount
    end)

    for i = 1, topCount do
        table.insert(topPlayers, sortedPlayers[i].player)
    end

    return topPlayers
end

function GiveOutRewards(krakenDefeated : boolean)
    topPlayers = FindTopPlayers()

    for k, v in pairs(players_storage) do
        reward = math.floor(v.generalInfo["FishCaught"] * fishRewardMultiplier)

        if(not krakenDefeated) then
            reward *= 0.5
        end

        reward = Mathf.Ceil(reward)

        bonus = 0
        for i = 1, #topPlayers do
            if(topPlayers[i] == v.player) then
                bonus = bonusReward
            end
        end

        prepareRewards:FireClient(v.player, krakenDefeated, fishCaughtAll, v.generalInfo["FishCaught"], reward, bonus)
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

        print("Sent " .. amount .. " Gold to " .. player.name .. " , Gold remaining: : ", response.gold)
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

function ShowMessage(messageText)
    if(messageText == currentMessageText) then return end

    currentMessageText = messageText
    showMessage:FireAllClients(messageText)
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
            TutorialModule.HighlightCannonBallCrates()
        end
    end)

    --Start Preparation Phase
    startPreparationPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)

        TutorialModule.ResetTutorial()
        TutorialModule.ClearArrows()
    end)

    --Start Fishing Phase
    startFishingPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)
    end)

    --Start Kraken Phase
    startKrakenPhase:Connect(function(st, p)
        UpdatePhaseInfo(st, p)

        FishingModule.CancelFishing(false)
        TutorialModule.HighlightCannonBallCrates()
    end)

    --Update Player Info Response
    updatePlayerInfoResponse:Connect(function(storage)
        localStorage = storage
        UIManagerModule.UpdatePlayerInfo(localStorage.generalInfo)
    end)

    --Update Upgrades
    updateUpgrades:Connect(function(upgr)
        upgrades = upgr
        UIManagerModule.UpdateUpgrades()
    end)

    --Prepare Rewards
    prepareRewards:Connect(function(krakenDefeated, allFishCaught, fishCaught, r, b)
        UIManagerModule.PrepareRewards(krakenDefeated, allFishCaught, fishCaught, r, b)
    end)

    --Show Rewards
    showRewards:Connect(function(prizePoolAvailable)
        UIManagerModule.ShowRewards(prizePoolAvailable)
    end)

    --Show Message
    showMessage:Connect(function(messageText)
        UIManagerModule.ShowMessage(messageText)
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
    return localStorage.generalInfo
end

function GetTutorialVersion()
    return localStorage.tutorialVersion
end

function SetTutorialVersion(version)
    localStorage.tutorialVersion = version
    updateTutorialVersion:FireServer(version)
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