--!Type(Module)

local FishingModule = require("FishingModule")

--!SerializeField
local cannonBallPrefab : GameObject = nil
--!SerializeField
local stunnedEffectPrefab : GameObject = nil

--!SerializeField
local fishingRodOutfit : CharacterOutfit = nil

--!SerializeField
local sounds: { AudioClip } = nil

local changePlayerStateRequest = Event.new("Change Player State Request")
local changePlayerState = Event.new("Change Player State")

local addFishingRodRequest = Event.new("Add Fishing Rod Request")
local addFishingRod = Event.new("Add Fishing Rod")

carriesCannonBall = false
playerState = ""

-- [Server Side]

function self:ServerAwake()
    --Change Player State Request
    changePlayerStateRequest:Connect(function(player: Player, targetPlayer, state)
        changePlayerState:FireAllClients(targetPlayer, state)
    end)

    --Add Fishing Rod Request
    addFishingRodRequest:Connect(function(player: Player)
        addFishingRod:FireAllClients(player)
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

    --Add Fishing Rod
    addFishingRod:Connect(function(player)
        player.character:AddOutfit(fishingRodOutfit)
    end)
end

function self:ClientStart()
    for i, v in ipairs(client.players) do
        local status, result = pcall(function()
            v.character:AddOutfit(fishingRodOutfit)
        end)

        if not status then
            print("An error occurred: " .. result)
        end
    end
    
    addFishingRodRequest:FireServer(client.localPlayer)
end

function self:FixedUpdate()
    if(playerState == "fishing") then
        characterState = client.localPlayer.character.state
        if(characterState == 5) then
            FishingModule.CancelFishing(true)
        end
    end
end

function ChangePlayerState(player, state)
    changePlayerStateRequest:FireServer(player, state)
end

function ActivatePlayerState(player : Player, state)
    playerState = state

    if(state == "standard") then
        player.character.speed = 5.5

        RemoveCannonBall(player)
    end

    if(state == "cannon ball") then
        player.character.speed = 2.5

        local cannonBall = Object.Instantiate(cannonBallPrefab, player.character.transform.position + Vector3.new(0, 5, 0))
        cannonBall.transform.parent = player.character.transform
    end

    if(state == "start fishing") then
        PlayEmote(player, "fishing-cast", false)
        playerState = "fishing"
    end

    if(state == "finish fishing") then
        PlayEmote(player, "fishing-pull", false)
        playerState = "standard"
    end

    if(state == "stunned") then
        player.character.speed = 0

        PlayEmote(player, "emoji-dizzy", true)
        
        RemoveCannonBall(player)

        local stunnedEffect = Object.Instantiate(stunnedEffectPrefab, player.character.transform.position + Vector3.new(0, 4, 0))
        stunnedEffect.transform.parent = player.character.transform

        if(player == client.localPlayer) then
            PlaySoundEffect(2, false)
        end

        Timer.After(3, function()
            ChangePlayerState(player, "standard")
            GameObject.Destroy(stunnedEffect)
            PlayEmote(player, "idle", true)
        end)
    end
end

function RemoveCannonBall(player)
    playerTransform = player.character.transform
    for i = 0, playerTransform.childCount - 1 do
        local child = playerTransform:GetChild(i)
        
        if(child.name == "Cannon Ball(Clone)") then
            GameObject.Destroy(child.gameObject)
            return
        end
    end

    if(player == client.localPlayer) then
        carriesCannonBall = false
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

function PlaySoundEffect(soundId, loop)
    audioSource = self:GetComponent(AudioSource)
    audioSource.loop = loop
    audioSource.pitch = Random.Range(0.9, 1.1)
    audioSource.clip = sounds[soundId]
    audioSource:Play()
end

function StopSoundEffect()
    audioSource = self:GetComponent(AudioSource)
    audioSource.loop = false
    audioSource:Stop()
end