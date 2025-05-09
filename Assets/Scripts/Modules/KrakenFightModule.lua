--!Type(Module)

local GameManagerModule = require("GameManagerModule")
local UIManagerModule = require("UIManagerModule")

local updateKrakenHealthUI = Event.new("Update Kraken Health UI")

krakenHealth = 0

-- [Server Side]

function SetKraken(playersNum)
    healthValue = Mathf.Ceil(playersNum / 3)

    krakenHealth = healthValue
    updateKrakenHealthUI:FireAllClients(krakenHealth)
end

function TentacleDefeated()
    krakenHealth -= 1
    updateKrakenHealthUI:FireAllClients(krakenHealth)

    print("Kraken health: " .. krakenHealth)

    if(krakenHealth == 0) then
        KrakenDead()
    end
end

function LoadKrakenHealth(player)
    updateKrakenHealthUI:FireClient(player, krakenHealth)
end

function KrakenDead()
    GameManagerModule.ChangePhase()
end

-- [Client Side]

function self:ClientAwake()
    --Update Kraken Health UI
    updateKrakenHealthUI:Connect(function(health)
        UIManagerModule.UpdateKrakenHealth(health)
    end)
end