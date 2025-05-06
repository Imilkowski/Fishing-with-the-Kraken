--!Type(Module)

--!SerializeField
local hudUI : HUD_UI = nil
--!SerializeField
local fishingUI : Fishing_UI = nil
--!SerializeField
local upgradesUI : Upgrades_UI = nil
--!SerializeField
local rewardsUI : Rewards_UI = nil

function self:ClientStart()
    ClosePanel(fishingUI)
    ClosePanel(upgradesUI)
    ClosePanel(rewardsUI)
end

function ClosePanel(panel)
    panel.gameObject:SetActive(false)
end

function SetPhaseInfo(startTime, currentPhaseInfo)
    hudUI.SetPhaseInfo(startTime, currentPhaseInfo)
end

function ShowHUD(show)
    hudUI.gameObject:SetActive(show)
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
    ShowHUD(not show)

    if(show) then
        upgradesUI.UpdateUpgradesList()
    end
end

function UpdateUpgrades()
    if(upgradesUI.gameObject.activeSelf) then
        upgradesUI.UpdateUpgradesList()
    end
end

function ShowRewards(allFishCaught, fishCaught, top10)
    rewardsUI.gameObject:SetActive(true)
    ShowHUD(false)

    rewardsUI.SetRewardsInfo(allFishCaught, fishCaught, top10)
end