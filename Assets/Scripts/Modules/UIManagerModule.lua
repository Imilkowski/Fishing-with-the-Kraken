--!Type(Module)

--!SerializeField
local hudUI : HUD_UI = nil
--!SerializeField
local fishingUI : Fishing_UI = nil
--!SerializeField
local upgradesUI : Upgrades_UI = nil

function self:ClientStart()
    ClosePanel(fishingUI)
    ClosePanel(upgradesUI)
end

function ClosePanel(panel)
    panel.gameObject:SetActive(false)
end

function SetPhaseInfo(startTime, currentPhaseInfo)
    hudUI.SetPhaseInfo(startTime, currentPhaseInfo)
end

function ShowFishingUI(show)
    fishingUI.ResetProperties()
    fishingUI.gameObject:SetActive(show)
end

function UpdateKrakenHealth(health)
    hudUI.UpdateKrakenHealth(health)
end

function UpdatePlayerInfo(generalInfo)
    hudUI.SetGems(generalInfo["Gems"])
    hudUI.SetFishCaught(generalInfo["FishCaught"])
end

function ShowUpgrades(show)
    upgradesUI.gameObject:SetActive(show)

    if(show) then
        upgradesUI.UpdateUpgradesList()
    end
end

function UpdateUpgrades()
    if(upgradesUI.gameObject.activeSelf) then
        upgradesUI.UpdateUpgradesList()
    end
end