--!Type(Module)

local GameManagerModule = require("GameManagerModule")

krakenHealth = 0

-- [Server Side]

function SetKraken()
    krakenHealth = 3
end

function TentacleDefeated()
    krakenHealth -= 1

    print("Kraken health: " .. krakenHealth)

    if(krakenHealth == 0) then
        KrakenDead()
    end
end

function KrakenDead()
    GameManagerModule.ChangePhase()
end

-- [Client Side]