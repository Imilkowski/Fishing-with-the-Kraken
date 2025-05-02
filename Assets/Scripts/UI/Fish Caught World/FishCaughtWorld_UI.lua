--!Type(UI)

--!Bind
local _FishCaught: UILabel = nil

function SetFishCaught(amount)
    _FishCaught:SetPrelocalizedText(amount)
end