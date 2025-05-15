--!Type(UI)

--!SerializeField
local fishIcon : Texture = nil
--!SerializeField
local gemIcon : Texture = nil
--!SerializeField
local damageIcon : Texture = nil

--!Bind
local _Value: UILabel = nil
--!Bind
local _Icon: Image = nil

function self:Start()
    Timer.Every(0.025, function()
        self.transform.position += Vector3.new(0, 0.025, 0)
    end)

    Timer.After(2, function()
        GameObject.Destroy(self.gameObject)
    end)
end

function SetText(value, type)
    if(type == "Fish") then
        _Value:SetPrelocalizedText("+" .. value)
        _Icon.image = fishIcon
    elseif(type == "Gems") then
        _Value:SetPrelocalizedText("+" .. value)
        _Icon.image = gemIcon
    elseif(type == "Damage") then
        _Value:SetPrelocalizedText(value)
        _Icon.image = damageIcon
        self:GetComponent(AudioSource).enabled = false
    end
end