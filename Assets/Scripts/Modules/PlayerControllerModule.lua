--!Type(Module)

local modifyPlayerRequest = Event.new("Modify Player Request")
local modifyPlayer = Event.new("Modify Player")

carriesCannonBall = false

-- [Server Side]

function self:ServerAwake()
    --Modify Player Request
    modifyPlayerRequest:Connect(function(player: Player, speed)
        modifyPlayer:FireAllClients(player, speed)
    end)
end

-- [Client Side]

function self:ClientAwake()
    --Modify Player
    modifyPlayer:Connect(function(player, speed)
        players = client.players

        for i, p in ipairs(players) do
            if(p == player) then
                p.character.speed = speed
                return
            end
        end
    end)
end

function PlayEmote(name, looping)
    if(name == "fishing-cast") then
        client.localPlayer.character:PlayEmote(name, false, function()
            PlayEmote("fishing-idle", true)
        end)
    else
        client.localPlayer.character:PlayEmote(name, true)
    end
end

function CarryCannonBall()
    modifyPlayerRequest:FireServer(2.5) --change player speed

    carriesCannonBall = true
end

function CannonBallLeft()
    modifyPlayerRequest:FireServer(5.5) --change player speed

    carriesCannonBall = false
end