--!Type(Module)

--!SerializeField
local cannonBallPrefab : GameObject = nil

local changePlayerStateRequest = Event.new("Change Player State Request")
local changePlayerState = Event.new("Change Player State")

carriesCannonBall = false

-- [Server Side]

function self:ServerAwake()
    --Change Player State Request
    changePlayerStateRequest:Connect(function(player: Player, targetPlayer, state)
        changePlayerState:FireAllClients(targetPlayer, state)
    end)
end

-- [Client Side]

function self:ClientAwake()
    --Change Player State
    changePlayerState:Connect(function(player, state)
        players = client.players

        for i, p in ipairs(players) do
            if(p == player) then
                ActivatePlayerState(player, state)
                return
            end
        end
    end)
end

function ChangePlayerState(player, state)
    changePlayerStateRequest:FireServer(player, state)
end

function ActivatePlayerState(player, state)
    if(state == "standard") then
        player.character.speed = 5.5

        playerTransform = player.character.transform
        for i = 0, playerTransform.childCount - 1 do
            local child = playerTransform:GetChild(i)
            
            if(child.name == "Cannon Ball(Clone)") then
                GameObject.Destroy(child.gameObject)
                return
            end
        end
    end

    if(state == "cannon ball") then
        player.character.speed = 2.5

        local cannonBall = Object.Instantiate(cannonBallPrefab, player.character.transform.position + Vector3.new(0, 5, 0))
        cannonBall.transform.parent = player.character.transform
    end

    if(state == "start fishing") then
        PlayEmote(player, "fishing-cast", false)
    end

    if(state == "finish fishing") then
        PlayEmote(player, "fishing-pull", false) 
    end
end

function PlayEmote(player, name, looping)
    if(name == "fishing-cast") then
        player.character:PlayEmote(name, looping, function()
            PlayEmote(player, "fishing-idle", true)
        end)
    else
        player.character:PlayEmote(name, looping)
    end
end

function CarryCannonBall()
    ChangePlayerState(client.localPlayer, "cannon ball")

    carriesCannonBall = true
end

function CannonBallLeft()
    ChangePlayerState(client.localPlayer, "standard")

    carriesCannonBall = false
end