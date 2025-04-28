--!Type(Client)

local PlayerControllerModule = require("PlayerControllerModule")

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    if(PlayerControllerModule.carriesCannonBall == false) then return end

    PlayerControllerModule.CannonBallLeft()
        
    print("Loaded a cannon")
end)