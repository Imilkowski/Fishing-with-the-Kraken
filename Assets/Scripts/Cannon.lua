--!Type(Client)

local PlayerControllerModule = require("PlayerControllerModule")

-- Connect to the Tapped event
self.gameObject:GetComponent(TapHandler).Tapped:Connect(function()
    if(PlayerControllerModule.carriesCannonBall == true) then 
        PlayerControllerModule.CannonBallLeft()
        
        print("Loaded a cannon")
    else 
        print("Requires a cannon ball")
    end
end)