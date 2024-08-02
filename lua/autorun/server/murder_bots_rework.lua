
// mu_loot
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print()
print("Murder bots addon is initializing.")
print()
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

include("murder_bot_profiles.lua")
include("murder_bot_chat.lua")
include("murder_bot_taunts.lua")
include("murder_bot_map_areas.lua")

util.AddNetworkString( "RequestAddBotsMU" )
util.AddNetworkString( "RequestKickBotsMU" )
util.AddNetworkString( "ClientDisplayInfoMU" )
util.AddNetworkString( "RequestMenuMU" )
util.AddNetworkString( "RequestAddCustomBotMU" )
--util.AddNetworkString( "SendMurdererData" )

local Meta = FindMetaTable("Player")
local murderer = nil
local murdererKnown = false
local muStarted = true

local secondsElapsed = 0

local secondsElapsedWOKill = 0

local DISABLEHIDING = 0
local WPM = 20

local muLoot = {}
timer.Create("MuBotLoot", 1, 0, function()
    muLoot = {}
    local z = 1
    for i,v in pairs(ents.GetAll()) do
        if v:GetClass() == "mu_loot" then
            z = z + 1
            muLoot[z] = v
        end
    end
end)

timer.Create("MuBotSecondsElapsed", 1, 0, function()
    if muStarted then
        secondsElapsed = secondsElapsed + 1
    else
        secondsElapsed = 0
    end

    if murderer != nil then
        if murderer:IsBot() then
            if murderer.target != nil then
                secondsElapsedWOKill=secondsElapsedWOKill+1
                else
                secondsElapsedWOKill=0
            end

            if secondsElapsedWOKill > 120 then
                murderer.target = murderer:Get2ndClosestPlayer(); // get the second closest because clearly the first closest isn't working
            end
        end
    end
end)

local function BooleanToString(val)
    if val then return "true" else return "false" end
end

function Meta:PrintBotData()
    local bot = self
    if bot:IsBot() then
        local t = bot.target
        if t == nil or not IsValid(bot.target) then t = "nil" else t=bot.target:Nick() end
        local data = {"nick= "..bot:Nick(),"accuracy= "..bot.accuracy,"personality= "..bot.personality,"target= "..t,"jump= "..BooleanToString(bot.jump),"crouch= "..BooleanToString(bot.crouch),"hidemode= "..BooleanToString(bot.hidemode),"noroam= "..BooleanToString(bot.noroam)}
        PrintTable(data)
    else
        ErrorNoHalt("PrintBotData was called on a non-bot! If you're reading this then you've made a very bad mistake!")
    end
end

function Meta:InitializeBotMU(profile)
    local bot = self
    local name = bot:Nick()
    bot.profile = profile
    bot.personality = profile.personality
    bot.accuracy = profile.accuracy
    bot.nav = ents.Create("murder_bots_nextbot") // create the nav
    bot.nav:SetOwner(bot) // set the owner so it doesnt ocllide
    bot.nav:Spawn() // spawn the nav into the world
    bot.target = nil // who the bot is shooting at or attacking with a melee
    bot.hidemode = false // determines if the bot is actively searching for a hiding spot
    bot.crouch = false // is the bot crouching?
    bot.jump = false // is the bot jumping?
    bot.roam = Vector(0,0,0) // the roam vector of the bot
    bot.use = 0 // when 0, the bot can interact with doors
    bot.touse = false
    bot.noroam = false
    bot.movePriority = 1; // 0 = hide, 1 = wander, 2 = flee murderer, -1 for nothing
    timer.Create("usetimer of bot "..bot:Nick(), 1, 0, function()
        if !IsValid(bot) then timer.Destroy("usertimer of bot "..name) return end
        bot.use = math.max(0,bot.use-1)
    end)
    bot.hidingspots = bot.nav:FindSpots({type='hiding',radius=99999})
end

function Meta:GetRoleId() // get the id of the player's role
    local bot = self
    if bot:HasWeapon("weapon_mu_knife") then
        return "murderer"
    elseif bot:HasWeapon("weapon_mu_magnum") then
        return "armed"
    else
        return "bystander"
    end
end

local function SetMurderer() // set the murderer variable
    for i,v in pairs(player.GetAll()) do
        if v:GetRoleId() == "murderer" then
            murderer = v
        end
    end
end

function Meta:BotSayMU(text) -- adds a typing delay for the bots, add cmd to make bot stop to type
    if self.chatting == nil then
        local t = string.len(text)
        t = tonumber(t)
        self.chatting = true
        timer.Simple(t/WPM, function()
            if self:Health() > 0 then
                self:Say(text)
            end
            self.chatting = nil
        end)
    end
end
function Meta:IsLookingNearMU( target )
    local ply = self
    local targetVec = target:GetPos()
    --print(target:Nick(),ply:VisibleVec(target:EyePos()), ply:GetAimVector():Dot( ( targetVec - ply:GetPos() + Vector( 70 ) ):GetNormalized() )," | ",(ply:VisibleVec(target:EyePos()) and ply:GetAimVector():Dot( ( targetVec - ply:GetPos() + Vector( 70 ) ):GetNormalized() ) > 0.94))
    return (ply:VisibleVec(target:EyePos()) and ply:GetAimVector():Dot( ( targetVec - ply:GetPos() + Vector( 70 ) ):GetNormalized() ) > 0.90)
end

function Meta:ClosestLookMU(thresh) -- percentage
    local ply = self
    local highest = 0
    local _target = nil
    for i,target in pairs(player.GetAll()) do
        if target != ply then
            local targetVec = target:GetPos()
            local numb = ply:GetAimVector():Dot( ( targetVec - ply:GetPos() + Vector( 70 ) ):GetNormalized() )
            local look = (ply:VisibleVec(target:EyePos()) and numb > thresh)
            if look and numb > highest then
                highest = numb
                _target = target
            end
        end
    end
    if highest > thresh then
        return _target
    else
        return nil
    end
end
beginMurderSpree = true

hook.Add("OnStartRound", "MurderBotsStartRound", function()
    timer.Simple(8, function() muStarted=true; end)
    murdererKnown = false
    SetMurderer() // set the murderer variable
    beginMurderSpree = false 
    timer.Simple(5+(math.random(1, 100)/10), function()
        beginMurderSpree=true
    end)
    if GetConVar("murder_bot_remove_doors"):GetInt() == 1 then // remove any unnecessary doors
        for i, v in pairs(ents.GetAll()) do
            if string.find(v:GetClass(), "prop_door") != nil then
                v:Remove();
            end
        end
    end
    MUInitBotAreas()
end)

hook.Add("OnEndRound", "MurderBotsEndRound", function()
    murderer = nil
    murdererKnown = false
    muStarted = false 
    beginMurderSpree = false
end)

local DOORS = {}


timer.Create("MurderBotsOpenDoors", 1, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    for b, bot in pairs(player.GetBots()) do
        bot.touse = false
        if bot.lastPos == nil then return end
        for i, v in pairs(DOORS) do
            if bot:GetEyeTrace().Entity == v then
                bot.use = 2
                bot.touse = true
            --if (VecDist(bot:GetPos(),v:GetPos()) < 150) and (VecDist(bot.lastPos,bot:GetPos()) < 40) and (bot.toggle == false) then
                --v:Fire("Toggle","",0)
                --bot.toggle = true
            --end
            end
        end
    end
end)


timer.Create("MurderBotsSetLastPos", math.pi/2, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    for b, bot in pairs(player.GetBots()) do
        bot.lastPos = bot:GetPos()
        bot.toggle = false
        bot.crouch = false
        bot.jump = false
    end
end)

timer.Create("MurderBotsGetDoors", 2, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    DOORS = {}
    for b, v in pairs(ents.GetAll()) do
        if (v:GetClass() == "func_door") or (v:GetClass() == "prop_door_rotating") or (v:GetClass() =="func_door_rotating") then
            DOORS[#DOORS+1] = v
        end
    end
end)

function VecDist(v1,v2)
    return math.Dist(v1.x,v1.y,v2.x,v2.y)
end

local function addbot(prof)
    local profile = {}
    local _x = false
    if prof == nil then
        repeat
            profile = table.Random(bot_profiles_murder)
            local x = false 
            for i,v in pairs(player.GetAll()) do
                if v:Nick() == profile.name then
                    x = true
                    break
                end
            end
            _x = not x
        until _x == true
    else
        profile = prof
    end
    if profile.name != nil then
        local bot = player.CreateNextBot(profile.name)
        if bot != nil then
            bot:InitializeBotMU(profile)
        end
    else
        ErrorNoHalt("If you're reading this then you shouldn't be using the console to add bots. If you are deadset on using the console, then use murder_bot_quota #")
    end
end

net.Receive( "RequestAddBotsMU", function( len, ply )
    local n = net.ReadInt(32)
	if ply:IsSuperAdmin() then
        for i = 1, n do
            addbot()
        end
    end
end )

net.Receive( "RequestAddCustomBotMU", function( len, ply )
    local n = net.ReadTable()
	if ply:IsSuperAdmin() then
        local a = true
        for i,v in pairs(player.GetAll()) do
            if v:Nick() == n.name then a = false end
        end
        if a then
            addbot(n)
        else
            ply:ChatPrint("Attempt failed: You can't add a bot named exactly like a player currently in the game.")
        end
    end
end )
local function updateQuota()
    if gmod.GetGamemode().Name != "Murder" then return end
    local quota = GetConVar("murder_bot_quota"):GetInt()
    if quota > 0 then
        local bots = #player.GetBots()
        local plys = #player.GetAll()
        if quota < plys then // if there are more players than the quota
            // if there are any bots, remove 1 of them
            if bots > 0 then
                player.GetBots()[1]:Kick("Quota reached; kicking bot")
            end
        elseif quota > plys then // if there are less players than the quota
            // add a bot!
            addbot()
        end
    end
end
timer.Create("MurderBotUpdateQuota", 1, 0, updateQuota)

net.Receive( "RequestKickBotsMU", function( len, ply )
    local n = net.ReadInt(32)
    local plys = player.GetBots()
    if #player.GetBots() == 0 then return end
	if ply:IsSuperAdmin() then
        for i = 1, n do
            local bot = table.Random(plys)
            table.RemoveByValue(plys, bot)
            if bot != nil then
                bot:Kick("Kicked thru Murder Bot Menu")
            end
        end
    end
end )

hook.Add("PlayerDisconnected","MurderBotPlayerDisconnected",function(ply)
    if gmod.GetGamemode().Name != "Murder" then return end
    if ply:IsPlayer() and not ply:IsBot() then
        updateQuota()
    end
end)

hook.Add("PlayerInitialSpawn", "MurderBotInitSpawn", function(ply)
    if gmod.GetGamemode().Name != "Murder" then return end




    local n = ply:Nick()
    if ply:IsPlayer() and not ply:IsBot() then

        updateQuota()

    end
end)

hook.Add( "PlayerSpawn", "PlayerCollision", function(ply) if ply:IsBot() then ply:SetCollisionGroup(11) end end )

-- [[ BOT FUNCTIONALITY MODIFIERS ]]
if !ConVarExists("murder_bot_quota") then
    CreateConVar("murder_bot_quota", 0, 1, "fill however many total server slots at all times.. removes or adds bots if necessary")
end
if !ConVarExists("murder_bot_disable_hiding") then
    CreateConVar("murder_bot_disable_hiding", 1, 1, "set to 1 to disable the hiding functionality of bot personality 0.")
end
if !ConVarExists("murder_bot_nav_debug") then
    CreateConVar("murder_bot_nav_debug", 0, 1, "set to 1 to enable displaying of paths from bot navigators.")
end
if !ConVarExists("murder_bot_wpm") then
    CreateConVar("murder_bot_wpm", 20, 1, "Words Per Minute typing speed of bots")
end
if !ConVarExists("murder_bot_difficulty") then
    CreateConVar("murder_bot_difficulty", 25, 1, "Enter a # between 1 to 100 (or more if you're daring) to increase difficulty. Default is 25.")
end
if !ConVarExists("murder_bot_idle") then
    CreateConVar("murder_bot_idle", 0, 1, "Used for debugging. Makes all bots not move if set to 1.")
end
if !ConVarExists("murder_bot_remove_doors") then
    CreateConVar("murder_bot_remove_doors", 0, 1, "If doors keep getting in the way then set this to 1 to remove all doors on the map. Default 0.")
end
if !ConVarExists("murder_bot_nocollide") then
    CreateConVar("murder_bot_nocollide", 1, 1, "Enables/Disables the no collision of bots. Can prevent traffic jams. Default 1.")
end
concommand.Add("murder_bot_add", addbot)
concommand.Add("murder_bot_gennewnavmesh", function(ply)
    if ply:IsSuperAdmin() then
        ply:ConCommand("sv_cheats 1")
        ply:ConCommand("nav_mark_walkable")
        ply:ConCommand("nav_generate")
    end
end)
local DIFF = 25
timer.Create("ConVarUpdateMurderBots", 2, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end

    DISABLEHIDING = GetConVar("murder_bot_disable_hiding"):GetInt()
    WPM = math.abs(GetConVar("murder_bot_wpm"):GetInt())
    DIFF = math.abs(GetConVar("murder_bot_difficulty"):GetInt())
end)

--[[]]

hook.Add("PlayerSay", "MurderBotPlayerSay", function(ply,txt)
    if gmod.GetGamemode().Name != "Murder" then return end
    if ply:IsSuperAdmin() then
        if string.sub(txt, 0, 7) == "!addbot" then
            local n = tonumber(string.sub(txt,8))
            if n != nil then
                for i = 1, n do addbot() end
                return false
            end
        end
        if txt == "!addbot" then addbot() end
    end
    if string.lower(txt) == "!botmenu" then
        if game.MaxPlayers() > 1 then
            net.Start("RequestMenuMU")
            net.Send(ply)
            return false
        else
            ply:ChatPrint("You are not in a server! Bots require player slots!")
            Error("Attempt to access bot menu without being in server with more than 1 player slot")
            return false
        end
    end
end)

LERP = 0.0

function Meta:generateWanderPosMU()
    local ply = self
    local pos;
    repeat
        pos = self:GetPos()+Vector(math.random(-300,300),math.random(-300,300),math.random(-300,300))
    until util.IsInWorld(pos)
    return pos
end

function Meta:LookAtMU(pos, cmd, ler) -- goal is a Vector
    if (GetConVar("murder_bot_idle"):GetInt() == 1) then return end
	local ownpos = self:GetPos() -- or Vector(0,0,0)
    local xdiff = (pos.x - ownpos.x)
    local ydiff = pos.y - ownpos.y
    local zdiff = pos.z - ownpos.z
    local xydist = math.Distance(pos.x,pos.y,ownpos.x,ownpos.y)
    yaw = math.deg(math.atan2(ydiff,xdiff))
    pitch = math.deg(math.atan2(-zdiff,xydist))
    if ler == nil then ler = LERP end
    --if move == true then
        cmd:SetViewAngles(LerpAngle( ler, cmd:GetViewAngles(), Angle(pitch,yaw,0)))
    --end
    --if eyes == true then
        self:SetEyeAngles(LerpAngle( ler, self:EyeAngles(), Angle(pitch,yaw,0))) 
    --end
end

function Meta:FollowPathMU( -- returns if the bot is within stopatdist of the goal
    cmd, -- the bot's cmd
    goal, -- goal VECTOR of the path
    speed, -- the speed the bot should move at, can be negative
    turnspeed, -- the lerping factor which is a decimal 0 thu 1 whereas 1 is instant and 0 is no change
    stopatdist -- if the bot is a certain distance from "goal" ***AND has a valid line-of-sight to it***, then do not move the bot. (doesn't factor in height difference)
)
    --[[if goal == nil then return end
    if cmd == nil then return end
    if speed == nil then return end
    if turnspeed == nil then return end
    if spotatdist == nil then return end]]
    if (GetConVar("murder_bot_idle"):GetInt() == 1) then return end
    local nav = self.nav
    nav.PosGen = goal
    if nav.P == nil then return end
    --print(#nav.P:GetAllSegments())
    local bot = self
    local look = nav.P:GetAllSegments() -- get segments of path
    local targ = nil -- vector
    if look != nil then -- if there are segments
        if look[2] != nil then -- if there is a second segment
            targ = look[2] -- targ is set to the second segment
            --[[if look[3] != nil then
                if math.Dist(self:GetPos().x,self:GetPos().y,look[3].pos.y,look[3].pos.y) < 100 then
                    targ = look[3]
                end
            end]]
                --print(targ.type.." - "..bot:Nick())
            if targ.type == 0 then -- is the segment a normal walk segment
                targ = Vector(targ.pos.x,targ.pos.y,bot:GetPos().z) -- set to move towards the segment position
                if VecDist(targ,bot:GetPos()) < 10 then
                    if look[3] != nil then
                        targ = Vector(look[3].pos.x,look[3].pos.y,bot:GetPos().z)
                    end
                end
            elseif targ.type == 1 then -- is the segment NOT a normal walk segment (type 1 is fall)
                targ = look[4] -- try the 4th segment
                bot.jump = true
                bot.crouch = true
                if targ != nil then -- does the 4th segment exist
                    targ = Vector(targ.pos.x,targ.pos.y,bot:GetPos().z) -- the targ position 
                end
            else
                bot.jump = true
                bot.crouch = true
                targ = Vector(targ.pos.x,targ.pos.y,bot:GetPos().z)
            end
        else
            targ = Vector(goal.x,goal.y,bot:GetPos().z)
        end
    else
        targ = goal
    end
    if targ == nil or goal == NULL then print("ERROR 0") return end
    self:LookAtMU(targ,cmd,turnspeed)

    if (math.Dist(goal.x, goal.y, self:GetPos().x, self:GetPos().y) < stopatdist) and self:VisibleVec(goal+Vector(0,0,25)) then
        return true
    end
    cmd:SetForwardMove(speed)
    return false
end

local function getNearestBotDistance(vector, exempt)
    local x = 9999999999;
    for i,v in pairs(player.GetBots()) do
        if v != exempt then
        if v:GetPos():Distance(vector) < x then x = v:GetPos():Distance(vector) end
        end
    end
    return x;
end

local MAXDISTFORSPOTTAKEN = 120;

function Meta:MoveToHidingSpotMU(cmd, crouch) -- crouch cannot be nil if the bot should crouch
    if DISABLEHIDING == 0 then
        local hide = nil
        local d = 999999
        local spots = self.hidingspots
        for i,v in pairs(spots) do
            if hide == nil then
                hide = v.vector
            else
                if getNearestBotDistance(v.vector, self) > 120 then
                    if math.Distance(self:GetPos().x, self:GetPos().y, v.vector.x, v.vector.y) < d then
                        d = math.Distance(self:GetPos().x, self:GetPos().y, v.vector.x, v.vector.y)
                        hide = v.vector
                    end
                end
            end
        end
        if hide != nil then
            if(self:FollowPathMU(cmd,hide,1000,0.08,80) and crouch != nil) then -- if within rad and it's supposed to crouch
                cmd:SetButtons(IN_DUCK)
                cmd:SetForwardMove(0)
            end
        end
    end
end

timer.Create("MurderBotWandering", 1, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    for i,bot in pairs(player.GetBots()) do
        if bot.roamsecs == nil then
            bot.roamsecs = 0
        end
        bot.roamsecs = bot.roamsecs + 1
        if bot.roam != nil then
            if math.Dist(bot.roam.x,bot.roam.y,bot:GetPos().x,bot:GetPos().y) < 200 then
                bot.roam = bot:generateWanderPosMU()
                bot.roamsecs = 1
            end
        else
            bot.roam = bot:generateWanderPosMU()
            bot.roamsecs = 1
        end
        if bot.roamsecs >= 6 then
            bot.roam = bot:generateWanderPosMU()
            bot.roamsecs = 1

        end
    end
end)


function Meta:GetClosestPlayer()
    local d = 99999999
    local bot = nil
    for i,v in pairs(player.GetAll()) do
        if v != self then
            if v:Health() > 0 then
                if d > v:GetPos():Distance(self:GetPos()) then
                    bot = v
                    d = v:GetPos():Distance(self:GetPos())
                end
            end
        end
    end
    return bot
end

function Meta:Get2ndClosestPlayer()
    local closest = self:GetClosestPlayer();
    local d = 99999999
    local bot = nil
    for i,v in pairs(player.GetAll()) do
        if v != self then
            if v:Health() > 0 then
                if d > v:GetPos():Distance(self:GetPos()) then
                    if d < closest:GetPos():Distance(self:GetPos()) then
                        bot = v
                        d = v:GetPos():Distance(self:GetPos())
                    end
                end
            end
        end
    end
    return bot
end

function Meta:GetSeeingBots()
    local bot = self
    local n = 0
    for i, v in pairs(player.GetAll()) do
        if v:Health() > 0 and bot != v and v:Visible(bot) then
           n = n + 1
        end
    end
    return n
end

function Meta:IsAlive()
    --print("IsAlive Check for "..self:Nick()..": "..self:Team()..", "..self:Health()..", "..BooleanToString(self:Alive()) )
    return (self:Team() == 2 and self:Health() > 0 and self:Alive())
end

function Meta:GetRandomVisibleBot()
    local bot = self
    local bots = {}
    for i,v in pairs(player.GetBots()) do
        if v:Visible(bot) then
            table.insert(bots, v)
        end
    end
    if #bots == 0 then return nil end
    return bots[math.random(1, #bots)]
end

local function calcdiff(x)
    return math.min(math.max(((1/198)*(x-100)+0.6),0.01),1)
end


local GUNS = {}
timer.Create("MuBotGetGuns", 0.3, 0, function()
    GUNS = {}
    for i,v in pairs(ents.GetAll()) do
        if v:GetClass() == "weapon_mu_magnum" then
            if not v:GetOwner():IsValid() then
                table.insert(GUNS, v)
            end
        end
    end
end)
function Meta:FindGuns()
    local bot = self
    if bot:GetRoleId() != "murderer" then
        if not bot:HasWeapon("weapon_mu_magnum") then
            for i,v in ipairs(GUNS) do
                if IsValid(v) then
                    if v:Visible(bot) then
                        --bot.noroam = true
                        return v
                    end
                end
            end
        end
    end
    return nil
end


local Clues = {}
timer.Create("MuBotGetClues", 0.3, 0, function()
    Clues = {}
    for i,v in pairs(ents.GetAll()) do
        if v:GetClass() == "mu_loot" then
            table.insert(Clues, v)
        end
    end
end)
function Meta:FindClues()
    local bot = self
    if bot:GetRoleId() != "murderer" then
        if not bot:HasWeapon("mu_loot") then
            for i,v in ipairs(Clues) do
                if IsValid(v) then
                    if v:Visible(bot) then
                        --bot.noroam = true
                        return v
                    end
                end
            end
        end
    end
    return nil
end

--[[
    Meta:FollowPathMU( -- returns if the bot is within stopatdist of the goal
    cmd, -- the bot's cmd
    goal, -- goal VECTOR of the path
    speed, -- the speed the bot should move at, can be negative
    turnspeed, -- the lerping factor which is a decimal 0 thu 1 whereas 1 is instant and 0 is no change
    stopatdist -- if the bot is a certain distance from "goal" ***AND has a valid line-of-sight to it***, then do not move the bot. (doesn't factor in height difference)
)
]]
local function startcmd(bot,cmd)
    if gmod.GetGamemode().Name != "Murder" then return end
    local isMurderer = bot:GetRoleId() == "murderer"
    if isMurderer then murderer = bot end
    if IsValid(bot.nav) then
        bot.nav:SetPos(bot:GetPos())
    else
        bot.nav = nil;
        bot.nav = ents.Create("murder_bots_nextbot") // create the nav
        bot.nav:SetOwner(bot) // set the owner so it doesnt ocllide
        bot.nav:Spawn() // spawn the nav into the world
    end
    if bot.chatting then return end
    if !bot:IsBot() then return end
    cmd:ClearButtons()
    if math.random(1,5000) == 69 and not murdererKnown then
        local __t = {"funny","morose"}
        bot:MUBotTaunt(table.Random(__t))
    end
    if not isMurderer and murdererKnown then
        if bot:Visible(murderer) then
            if math.random(1,500) == 69 then
                local __t = {"help","scream"}
                bot:MUBotTaunt(table.Random(__t))
            end
        end
    end



    --bot:PrintBotData()
    bot.noroam = false
    bot.exposeKnife = false
    -- if isMurderer then bot:PrintBotData() end
    if #GUNS > 0 then
        local __g = bot:FindGuns()
        if __g != nil then

            bot.noroam = true
            bot:FollowPathMU(cmd, __g:GetPos(), bot:GetWalkSpeed(), 0.3, 1)
        end

    else

        if murdererKnown and DISABLEHIDING == 0 then
            if bot.personality >= -2 then
                bot.noroam = true
                bot:MoveToHidingSpotMU(cmd, true)
            end
        end
    end


    if not bot.noroam then
        if #Clues > 0 then
            local clue = bot:FindClues()
            if clue != nil then
                bot.noroam = true
                if bot:FollowPathMU(cmd, clue:GetPos(), bot:GetWalkSpeed(), 0.3, 80) then
                    cmd:SetForwardMove(10)
                    bot:LookAtMU(clue:GetPos()-Vector(0,0,180), cmd, 0.3)
                    bot.squirm = false
                    //bot.touse = true

                    clue:Use(bot, bot, 1, 1 )
                end
            end
        end
    end



    if isMurderer and beginMurderSpree then
        --bot:FollowPathMU( cmd, player.GetHumans()[1]:GetPos(), bot:GetWalkSpeed(), 0.3, 80 )
        if (murdererKnown) then
            bot.exposeKnife=true
            cmd:SetButtons(IN_ATTACK)
        end

        bot.noroam = true
        if (bot.target != null and IsValid(bot.target)) then
            if bot.target:IsAlive() then
                local spd = bot:GetWalkSpeed()
                if murdererKnown then spd = bot:GetRunSpeed() end
                if bot:FollowPathMU( cmd, bot.target:GetPos(), spd, 0.075, 160 ) then
                    if bot:FollowPathMU( cmd, bot.target:GetPos(), bot:GetRunSpeed(), 0.5, 70 ) then
                        cmd:SetButtons(IN_ATTACK)
                    end
                    -- input personality difference here!
                    
                    if bot.personality == 1 then
                        if bot:GetSeeingBots() <= 1 or murdererKnown or secondsElapsed > 180 then
                            bot.exposeKnife=true
                            cmd:SetButtons(IN_ATTACK)
                        end
                    elseif bot.personality == 2 then 
                        if bot:GetSeeingBots() <= 2 or murdererKnown or secondsElapsed > 180 then
                            bot.exposeKnife=true
                            cmd:SetButtons(IN_ATTACK)
                        end
                    elseif bot.personality == 3 then 
                        if bot:GetSeeingBots() <= 3 or murdererKnown or secondsElapsed > 180 then
                            bot.exposeKnife=true
                            cmd:SetButtons(IN_ATTACK)
                        end
                    elseif bot.personality == 0 then 
                        if bot:GetSeeingBots() <= 4 or murdererKnown or secondsElapsed > 180 then
                            bot.exposeKnife=true
                            cmd:SetButtons(IN_ATTACK)
                        end
                    else -- this should never happen
                        bot.exposeKnife=true
                        cmd:SetButtons(IN_ATTACK)
                    end
                    
                end
            else
                bot.noroam = false
                bot.target = nil
            end
        else
            bot.target = bot:GetClosestPlayer()
            --print("acquiring new target for "..bot:Nick())
        end
        if bot.exposeKnife or murdererKnown then
            bot:SelectWeapon("weapon_mu_knife")
            if bot:GetEyeTrace().Entity:IsPlayer() then
                cmd:SetButtons(IN_ATTACK)
            end
        else
            bot:SelectWeapon("weapon_mu_hands")
        end
    end

    if murderer == bot and cmd:GetButtons() == IN_ATTACK and murdererKnown then
        
        if (math.random(0, 1000) < 1) then
            bot:BotSayMU(mu_bot_gchat(bot.personality, "murderer", nil))
        end
    end

    if bot:HasWeapon("weapon_mu_magnum") then
        if murdererKnown and murderer != null then
            if bot:Visible(murderer) then
                --if bot:FollowPathMU( cmd, murderer:GetPos(), bot:GetWalkSpeed(), 0.4, 800 ) then
                    bot:LookAtMU(murderer:GetPos()-Vector(0,0,16)+(Vector(math.random(-16, 16),math.random(-16, 16),math.random(-16, 16))/bot.accuracy), cmd, calcdiff(DIFF)) -- lerp is 0.1 at default difficulty
                    bot:SelectWeapon("weapon_mu_magnum")
                    if (bot.lastshot == nil) then -- if they haven't shot before
                        cmd:SetButtons(IN_ATTACK)
                        bot.lastshot = CurTime()
                    elseif (bot.lastshot+2 < CurTime()) then -- if they have shot and then waited 4 seconds
                        cmd:SetButtons(IN_ATTACK)
                        bot.lastshot = CurTime()
                    else -- if they have both shot and have not waited 4 seconds
                        cmd:SetButtons(IN_RELOAD)
                    end
                    bot.squirm = false
                    cmd:SetForwardMove(0)
                    bot.noroam = true

                    if (math.random(0, 1000) < 1) then
                        bot:Say(mu_bot_gchat(bot.personality, "armed", nil))
                    end
                --end
            else
                bot:SelectWeapon("weapon_mu_hands")
                bot.noroam = false
            end
        end
    end
    
    if murderer != bot and murderer != nil then
        if not murdererKnown then
            if murderer:GetActiveWeapon() != nil and IsValid(murderer:GetActiveWeapon()) then
                if murderer:GetActiveWeapon():GetClass() == "weapon_mu_knife" or murderer:GetMurdererRevealed() then // get if the murderer is brandishing or has an evil presence being revealed
                    if bot:Visible(murderer) then
                        timer.Simple(2/(GetConVar("murder_bot_difficulty"):GetInt()/20), function()
                            if IsValid(bot) and IsValid(murderer) then
                                if murderer:Visible(bot) and bot:Health() > 0 and murderer != bot then
                                    local b = murderer:GetRandomVisibleBot()
                                    if b != nil then
                                        --b:BotSayMU(mu_bot_gchat(0, "murderer", nil))
                                        --string.format(string format, vararg formatParameters)
                                        local areaname = murderer:NearestAreaName()
                                        if (areaname != "nil") and murdererKnown == false then
                                            b:Say(string.format(string.format("The murderer, %s", murderer:GetBystanderName()..", is near %s!"),murderer:NearestAreaName()))
                                        elseif ((areaname == "nil") and murdererKnown == false)  then
                                            b:Say([[I've spotted the murderer, ]]..murderer:GetBystanderName())
                                        end
                                    end
                                    murdererKnown = true
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    if bot.squirm == true then
        bot:LookAtMU(bot:GetPos()+Vector(math.random(-100, 100), math.random(-100, 100)), cmd, 0.1) // pos, cmd, lerp
        bot.jump = true 
        bot.crouch = true
        --print("Squirming bot "..bot:Nick())
    end
    //if (bot.squirm) then cmd:SetButtons(IN_MOVELEFT); print("Squirming bot "..bot:Nick()); cmd:SetForwardMove(-50) end
    

    if bot.jump and bot.crouch then cmd:SetButtons(IN_JUMP, IN_DUCK); bot.jump = false; bot.crouch = false;
    else
    if bot.jump then cmd:SetButtons(IN_JUMP); bot.jump = false end
    if bot.crouch then cmd:SetButtons(IN_DUCK); bot.crouch = false end
    end
    if bot.touse then cmd:SetButtons(IN_USE) end
    if bot.movePriority == 1 and bot.roam != nil and (not isMurderer) and not bot.noroam then
        bot:FollowPathMU( cmd, bot.roam, 1000, 0.08, 200 )
    end 
end

--[[hook.Add( "PlayerCanPickupWeapon", "MurderBotsWeapon", function( ply, wep )
end)]]

hook.Add("PlayerSpawn", "MurderBotsSpawn", function(bot)
    if gmod.GetGamemode().Name != "Murder" then return end
    if bot:IsBot() then
        if bot.nav != nil then
            if bot.nav:IsValid() then
                bot.nav:Remove()
            end
            bot.nav = ents.Create("murder_bots_nextbot") // create the nav
            bot.nav:SetOwner(bot) // set the owner so it doesnt ocllide
            bot.nav:Spawn() // spawn the nav into the world
        else
            bot.nav = ents.Create("murder_bots_nextbot") // create the nav
            bot.nav:SetOwner(bot) // set the owner so it doesnt ocllide
            bot.nav:Spawn() // spawn the nav into the world
        end
    end
end)

hook.Add("StartCommand", "MurderBotStartCommand", startcmd)

--------------------------------------------
-- disguise checker!!

local knownMurdererName = "" -- known alias of the murderer
local knownLastCall = false

local function murdererDisguiseChangedCheck() -- check when the murderer changes their disguise
    if muStarted and murderer ~= nil then
        if murdererKnown and not knownLastCall then -- do the following if the murderer was just discovered:
            knownMurdererName = murderer:GetBystanderName()
            knownLastCall=true -- do not repeat this lest the murderer is unknown now
        end
        if knownMurdererName ~= "" and murdererKnown and knownLastCall then -- if the murderer WAS known
            if murderer:GetBystanderName() ~= knownMurdererName then
                murdererKnown = false
                knownLastCall = false
            end
        end
        if not murdererKnown then -- we dont know the murderer so disable
            knownLastCall = false
        end
    else -- if the murder match hasn't started, then:
        knownMurdererName = ""
    end
end

timer.Create("MUMurdererDisguiseChangedCheck", 1, 0, murdererDisguiseChangedCheck);

---
-----------------------------------------

local function formatStringWithName(x)
    return string.format(x, player.GetAll()[math.random(1,player.GetCount())]:Nick() )
end

timer.Create("MurderBotSillyChat", 20, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    --for i,v in pairs(player.GetBots()) do
    local v = table.Random(player.GetBots())
    if v != nil then
        if v:Health() > 0 then
            v:Say(formatStringWithName(mu_bot_gchat(v.personality, "silly", nil)))
        end
    end
end)
local _muticks = 0
timer.Create("MUBotsOpenDoors", 2, 0, function() -- get the bots to open doors when they are obstructed by one, or alternatively to squirm around when stuck on a bad navmesh
if gmod.GetGamemode().Name != "Murder" then return end
    _muticks = _muticks + 1
    // reassign target for murderer
    if (murderer != nil) then
        if (_muticks % 2 == 0) then
            if (murderer:IsBot()) then
                murderer.target = murderer:GetClosestPlayer()
            end
        end
    end

    for b, bot in pairs(player.GetBots()) do
        if bot.lastPos == nil then --[[ErrorNoHalt("bot.lastPos = nil")]] return end
        local door = false
        for i, v in pairs(DOORS) do
            if bot:GetEyeTrace().Entity == v then
                bot.use = 2
                bot.touse = true
                door = true
            --if (VecDist(bot:GetPos(),v:GetPos()) < 150) and (VecDist(bot.lastPos,bot:GetPos()) < 40) and (bot.toggle == false) then
                --v:Fire("Toggle","",0)
                --bot.toggle = true
            --end
            end
        end
        if not door and (bot.target == nil or bot:HasWeapon("weapon_mu_knife")) then -- if they're not stuck on a door them squirm around like a live fish above water until free (+ they can't have a target unless they're murderer)
            if bot:GetPos():Distance(bot.lastPos) < 50 then
                bot.squirm = true
            else
                bot.squirm = false
            end
        end
    end
end)

timer.Create("ClientDisplayInfoMurderBots", 1, 0, function()
    if gmod.GetGamemode().Name != "Murder" then return end
    local tab = {
        ["diff"] = GetConVar("murder_bot_difficulty"):GetInt(),
        ["hide"] = GetConVar("murder_bot_disable_hiding"):GetInt(),
        ["quota"] = GetConVar("murder_bot_quota"):GetInt(),
        ["removedoors"] = GetConVar("murder_bot_remove_doors"):GetInt(),
        ["nocollide"] = GetConVar("murder_bot_nocollide"):GetInt()
    }
    net.Start("ClientDisplayInfoMU")
    net.WriteTable(tab)
    net.Send(player.GetHumans())
    --[[if murderer != nil and IsValid(murderer) then
        net.Start("SendMurdererBotData")
        local items = {murderer:Nick()}
        net.WriteTable(items)
        net.Send(player.GetHumans())
    end]]
end)