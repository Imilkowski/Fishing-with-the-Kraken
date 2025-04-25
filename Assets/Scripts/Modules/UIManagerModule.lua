--!Type(Module)

--!SerializeField
local hudUI : HUD_UI = nil
--!SerializeField
local fishingUI : Fishing_UI = nil

function self:ClientStart()
    ClosePanel(fishingUI)
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

function ShowLeaderboard()
    -- show = not inventoryUI.gameObject.activeSelf

    -- inventoryUI.gameObject:SetActive(show)

    -- if(show) then
    --     inventoryUI.UpdateItemsList(SaveModule.players_storage[client.localPlayer].inventory)
    -- end
end