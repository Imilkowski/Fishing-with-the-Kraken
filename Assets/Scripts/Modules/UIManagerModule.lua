--!Type(Module)

--!SerializeField
local hudUI : HUD_UI = nil
--!SerializeField
local fishingUI : Fishing_UI = nil

function self:ClientStart()
    --ClosePanel(inventoryUI)
end

function ClosePanel(panel)
    panel.gameObject:SetActive(false)
end

function SetPhaseInfo(startTime, currentPhaseInfo)
    hudUI.SetPhaseInfo(startTime, currentPhaseInfo)
end

function ShowLeaderboard()
    -- show = not inventoryUI.gameObject.activeSelf

    -- inventoryUI.gameObject:SetActive(show)

    -- if(show) then
    --     inventoryUI.UpdateItemsList(SaveModule.players_storage[client.localPlayer].inventory)
    -- end
end

function ShowFishingUI(show)
    fishingUI.gameObject:SetActive(show)
end