--!Type(Module)

local GameManagerModule = require("GameManagerModule")

-- [Server Side]

function PrintErrorCode(errorCode)
    if(errorCode == not nil) then
        print(`The error code was {StorageError[errorCode]}`)
    end
end

function SavePlayerDataToCloud(player, storage)
    Storage.SetPlayerValue(player, "Gems", storage.generalInfo["Gems"], function(errorCode)
        PrintErrorCode(errorCode)
    end)

    print(player.name .. " saved Data to cloud")
end

function LoadPlayerDataFromCloud(player)
    generalinfo = {}

    Storage.GetPlayerValue(player, "Gems", function(gems)
        GameManagerModule.LoadData(player, "Gems", gems)
    end)

    print(player.name .. " loaded Data from cloud")
end