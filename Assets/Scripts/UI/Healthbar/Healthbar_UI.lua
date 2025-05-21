--!Type(UI)

--!Bind
local _HealthBar: VisualElement = nil

function SetHealthbar(health, maxHealth)
    _HealthBar.style.width = (health / maxHealth) * 300 --300px
end