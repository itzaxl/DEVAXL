--[[
    ██████╗ ██╗      ██████╗ ██╗  ██╗    ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗
    ██╔══██╗██║     ██╔═══██╗╚██╗██╔╝    ██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝
    ██████╔╝██║     ██║   ██║ ╚███╔╝     ███████╗██║     ██████╔╝██║██████╔╝   ██║
    ██╔══██╗██║     ██║   ██║ ██╔██╗     ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║
    ██████╔╝███████╗╚██████╔╝██╔╝ ██╗    ███████║╚██████╗██║  ██║██║██║        ██║
    ╚═════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═╝    ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝
    Blox Fruits Ultimate | Custom GUI | No Libraries | v5.0
--]]

-- ═══════════════════════════════════════════
--              SERVICES
-- ═══════════════════════════════════════════
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TeleportService  = game:GetService("TeleportService")
local HttpService      = game:GetService("HttpService")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")

local LP    = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Cam   = Workspace.CurrentCamera
local Remote= ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ═══════════════════════════════════════════
--         WORLD DETECTION
-- ═══════════════════════════════════════════
local PlaceId  = game.PlaceId
local IsWorld1 = PlaceId == 2753915549
local IsWorld2 = PlaceId == 4442272183
local IsWorld3 = PlaceId == 7449423635
local WorldName= IsWorld1 and "World 1" or IsWorld2 and "World 2" or IsWorld3 and "World 3" or "Unknown"

-- ═══════════════════════════════════════════
--            STATE / TOGGLES
-- ═══════════════════════════════════════════
local State = {
    AutoFarm       = false, AutoQuest      = false, AutoBoss       = false,
    AutoMastery    = false, AutoChest      = false, AutoFruit      = false,
    AutoMaterial   = false, AutoRaid       = false, AutoStats      = false,
    AutoHaki       = false, AutoKenHaki    = false, AutoArmorHaki  = false,
    InfJump        = false, NoClip         = false, FlyHack        = false,
    SpeedHack      = false, InfStamina     = false, AntiAFK        = true,
    KillAura       = false, HitboxExpand   = false, ReachHack      = false,
    AutoSkill      = false, AutoBlock      = false, AutoParry      = false,
    AutoDodge      = false, InstantKill    = false, AutoRespawn    = false,
    SilentAim      = false, FovCircle      = false, AntiBlind      = false,
    AntiFreeze     = false, Fullbright     = false, AutoSword      = false,
    AutoGun        = false, AutoCombo      = false, ServerHop      = false,
    ESP            = false, MobESP         = false, PlayerESP      = false,
    ChestESP       = false, FruitESP       = false,
    SpeedValue     = 16,    JumpValue      = 50,    FlySpeed       = 80,
    AuraRange      = 40,    HitboxValue    = 15,    FovValue       = 60,
    ServerHopHP    = 20,    FarmDelay      = 0.05,  GravMult       = 1,
    SelectedMob    = "Auto",SelectedBoss   = "Gorilla King",
    SelectedMat    = "None",StatType       = "Blox Fruit",
    KillCount      = 0,     QuestCount     = 0,     SessionStart   = os.time(),
}

-- ═══════════════════════════════════════════
--         UTILITY FUNCTIONS
-- ═══════════════════════════════════════════
local function GetChar() return LP.Character end
local function GetRoot()
    local c = GetChar(); return c and c:FindFirstChild("HumanoidRootPart")
end
local function GetHum()
    local c = GetChar(); return c and c:FindFirstChildOfClass("Humanoid")
end
local function IsAlive()
    local h = GetHum(); return h and h.Health > 0
end
local function Dist(a,b) return (a-b).Magnitude end
local function TP(cf)
    local r = GetRoot(); if r then r.CFrame = cf end
end
local function SafeCall(fn,...)
    local ok,e = pcall(fn,...); return ok
end
local function GetLevel()
    return LP.Data and LP.Data.Level and LP.Data.Level.Value or 0
end
local function GetBeli()
    return LP.Data and LP.Data.Beli and LP.Data.Beli.Value or 0
end
local function GetFragments()
    return LP.Data and LP.Data.Fragments and LP.Data.Fragments.Value or 0
end
local function GetNearestMob(range, name)
    range = range or 100
    local best, bestD = nil, range
    local root = GetRoot(); if not root then return nil end
    for _,obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
                if obj.Humanoid.Health > 0 then
                    if not name or obj.Name == name then
                        local d = Dist(root.Position, obj.HumanoidRootPart.Position)
                        if d < bestD then best=obj; bestD=d end
                    end
                end
            end
        end
    end
    return best
end
local function GetAllMobs(name)
    local t = {}
    for _,obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
                if obj.Humanoid.Health > 0 then
                    if not name or obj.Name == name then table.insert(t,obj) end
                end
            end
        end
    end
    return t
end

-- ═══════════════════════════════════════════
--           GAME DATA
-- ═══════════════════════════════════════════
local MobData = {
    ["Bandit"]={L={1,9},QCF=CFrame.new(-1271,-3,-1272),MCF=CFrame.new(-1300,-2,-1300)},
    ["Monkey"]={L={10,14},QCF=CFrame.new(-1949,-2,-3282),MCF=CFrame.new(-1949,-2,-3282)},
    ["Gorilla"]={L={15,29},QCF=CFrame.new(-1949,-2,-3282),MCF=CFrame.new(-2013,-2,-3282)},
    ["Pirate"]={L={30,39},QCF=CFrame.new(-967,13,4034),MCF=CFrame.new(-967,13,4034)},
    ["Brute"]={L={40,59},QCF=CFrame.new(-1191,15,4235),MCF=CFrame.new(-1191,15,4235)},
    ["Desert Bandit"]={L={60,74},QCF=CFrame.new(924,-3,1121),MCF=CFrame.new(924,-3,1121)},
    ["Desert Officer"]={L={75,89},QCF=CFrame.new(1001,-3,1295),MCF=CFrame.new(1001,-3,1295)},
    ["Snow Bandit"]={L={90,99},QCF=CFrame.new(1268,274,-2244),MCF=CFrame.new(1268,274,-2244)},
    ["Snowman"]={L={100,119},QCF=CFrame.new(1268,274,-2244),MCF=CFrame.new(1268,274,-2244)},
    ["Chief Petty Officer"]={L={120,149},QCF=CFrame.new(1010,5,-2971),MCF=CFrame.new(1010,5,-2971)},
    ["Sky Bandit"]={L={150,174},QCF=CFrame.new(-5082,612,-4762),MCF=CFrame.new(-5082,612,-4762)},
    ["Dark Master"]={L={175,189},QCF=CFrame.new(-5082,612,-4762),MCF=CFrame.new(-5082,612,-4762)},
    ["Prisoner"]={L={190,209},QCF=CFrame.new(5261,-3,3768),MCF=CFrame.new(5261,-3,3768)},
    ["Dangerous Prisoner"]={L={210,249},QCF=CFrame.new(5261,-3,3768),MCF=CFrame.new(5261,-3,3768)},
    ["Toga Warrior"]={L={250,274},QCF=CFrame.new(-6516,-3,-1046),MCF=CFrame.new(-6516,-3,-1046)},
    ["Gladiator"]={L={275,299},QCF=CFrame.new(-6516,-3,-1046),MCF=CFrame.new(-6516,-3,-1046)},
    ["Military Soldier"]={L={300,324},QCF=CFrame.new(-5565,9,8327),MCF=CFrame.new(-5565,9,8327)},
    ["Military Spy"]={L={325,374},QCF=CFrame.new(-5806,78,8904),MCF=CFrame.new(-5806,78,8904)},
    ["Fishman Warrior"]={L={375,399},QCF=CFrame.new(60943,17,1744),MCF=CFrame.new(60943,17,1744)},
    ["Fishman Commando"]={L={400,449},QCF=CFrame.new(61760,18,1460),MCF=CFrame.new(61760,18,1460)},
    ["God's Guard"]={L={450,474},QCF=CFrame.new(-7759,5606,-1862),MCF=CFrame.new(-7759,5606,-1862)},
    ["Shanda"]={L={475,524},QCF=CFrame.new(-7906,5634,-1411),MCF=CFrame.new(-7906,5634,-1411)},
    ["Royal Squad"]={L={525,549},QCF=CFrame.new(-7906,5634,-1411),MCF=CFrame.new(-7906,5634,-1411)},
    ["Royal Soldier"]={L={550,624},QCF=CFrame.new(-7906,5634,-1411),MCF=CFrame.new(-7906,5634,-1411)},
    ["Galley Pirate"]={L={625,649},QCF=CFrame.new(5259,37,4050),MCF=CFrame.new(5551,78,3930)},
    ["Galley Captain"]={L={650,699},QCF=CFrame.new(5259,37,4050),MCF=CFrame.new(5441,42,4950)},
    ["Mercenary"]={L={750,799},QCF=CFrame.new(-986,72,1088),MCF=CFrame.new(-986,72,1088)},
    ["Vampire"]={L={1000,1049},QCF=CFrame.new(-6132,9,-1466),MCF=CFrame.new(-6132,9,-1466)},
    ["Lava Pirate"]={L={1050,1099},QCF=CFrame.new(-5158,14,-4654),MCF=CFrame.new(-5158,14,-4654)},
    ["Dragon Crew Warrior"]={L={1175,1249},QCF=CFrame.new(-3282,57,-4286),MCF=CFrame.new(-3282,57,-4286)},
    ["Snow Lurker"]={L={1325,1374},QCF=CFrame.new(1030,267,-5140),MCF=CFrame.new(1030,267,-5140)},
    ["Forest Pirate"]={L={1500,1574},QCF=CFrame.new(-10828,331,-9049),MCF=CFrame.new(-10828,331,-9049)},
    ["Mythological Pirate"]={L={1850,1924},QCF=CFrame.new(-13456,469,-7039),MCF=CFrame.new(-13456,469,-7039)},
    ["Chocolate Bar Battler"]={L={1925,1999},QCF=CFrame.new(582,25,-12550),MCF=CFrame.new(582,25,-12550)},
    ["Dough Militia"]={L={2000,2074},QCF=CFrame.new(582,25,-12550),MCF=CFrame.new(582,25,-12550)},
    ["Horned Warrior"]={L={2225,2299},QCF=CFrame.new(-4648,76,-13527),MCF=CFrame.new(-4648,76,-13527)},
    ["Order Soldier"]={L={3150,3224},QCF=CFrame.new(-13456,469,-7039),MCF=CFrame.new(-13456,469,-7039)},
    ["Order Officer"]={L={3225,3299},QCF=CFrame.new(-13456,469,-7039),MCF=CFrame.new(-13456,469,-7039)},
    ["Factory Staff"]={L={3550,3699},QCF=CFrame.new(-105,72,-670),MCF=CFrame.new(-105,72,-670)},
    ["Water Fighter"]={L={3700,3849},QCF=CFrame.new(-3331,239,-10553),MCF=CFrame.new(-3331,239,-10553)},
    ["Pistol Billionaire"]={L={3400,3549},QCF=CFrame.new(-185,84,6103),MCF=CFrame.new(-185,84,6103)},
}
local BossData = {
    ["Gorilla King"]={CF=CFrame.new(-1949,-2,-3282),Drop="Kilo Bag"},
    ["Bobby"]={CF=CFrame.new(-1271,-3,-1272),Drop="Katana"},
    ["Yeti"]={CF=CFrame.new(1192,274,-2025),Drop="Chilly Cloak"},
    ["Mr. 3"]={CF=CFrame.new(-6516,-3,-1046),Drop="Kilo Bag"},
    ["Wysper"]={CF=CFrame.new(-5082,612,-4762),Drop="Dark Dagger"},
    ["Thunder God"]={CF=CFrame.new(-5082,612,-4762),Drop="Thunder God Frag"},
    ["Cyborg"]={CF=CFrame.new(5261,-3,3768),Drop="Dark Blade"},
    ["Saber Expert"]={CF=CFrame.new(-6512,-3,1952),Drop="Saber"},
    ["Swan"]={CF=CFrame.new(-297,8,5765),Drop="Swan Glasses"},
    ["Awakened Ice Admiral"]={CF=CFrame.new(1030,267,-5140),Drop="Ice Admiral Coat"},
    ["Longma"]={CF=CFrame.new(-3282,57,-4286),Drop="Longma Items"},
    ["rip_indra"]={CF=CFrame.new(3601,8,3390),Drop="Indra Fragment"},
    ["Island Empress"]={CF=CFrame.new(-10828,331,-9049),Drop="Empress Items"},
    ["Cake Queen"]={CF=CFrame.new(582,25,-12550),Drop="Cake Crown"},
    ["Dough King"]={CF=CFrame.new(582,25,-12550),Drop="Pole v2"},
    ["Soul Reaper"]={CF=CFrame.new(-12862,27,-7068),Drop="Soul Items"},
    ["Leviathan"]={CF=CFrame.new(-4648,76,-13527),Drop="Leviathan Scale"},
}
local MatData = {
    ["Radioactive Material"]={Mob="Factory Staff",CF=CFrame.new(-105,72,-670)},
    ["Leather + Scrap Metal"]={Mob="Mercenary",CF=CFrame.new(-986,72,1088)},
    ["Magma Ore"]={Mob="Military Soldier",CF=CFrame.new(-5565,9,8327)},
    ["Fish Tail"]={Mob="Fishman Warrior",CF=CFrame.new(60943,17,1744)},
    ["Angel Wings"]={Mob="Royal Soldier",CF=CFrame.new(-7759,5606,-1862)},
    ["Mystic Droplet"]={Mob="Water Fighter",CF=CFrame.new(-3331,239,-10553)},
    ["Vampire Fang"]={Mob="Vampire",CF=CFrame.new(-6132,9,-1466)},
    ["Gunpowder"]={Mob="Pistol Billionaire",CF=CFrame.new(-185,84,6103)},
    ["Mini Tusk"]={Mob="Mythological Pirate",CF=CFrame.new(-13456,469,-7039)},
    ["Conjured Cocoa"]={Mob="Chocolate Bar Battler",CF=CFrame.new(582,25,-12550)},
    ["Dragon Scale"]={Mob="Dragon Crew Warrior",CF=CFrame.new(-3282,57,-4286)},
}
local IslandData = {
    ["Starter Island"]=CFrame.new(-1271,-3,-1272),
    ["Monkey Island"]=CFrame.new(-1949,-2,-3282),
    ["Pirate Village"]=CFrame.new(-967,13,4034),
    ["Desert"]=CFrame.new(924,-3,1121),
    ["Snow Island"]=CFrame.new(1268,274,-2244),
    ["Marine Base"]=CFrame.new(1010,5,-2971),
    ["Sky Island"]=CFrame.new(-5082,612,-4762),
    ["Prison"]=CFrame.new(5261,-3,3768),
    ["Colosseum"]=CFrame.new(-6516,-3,-1046),
    ["Magma Village"]=CFrame.new(-5565,9,8327),
    ["Underwater City"]=CFrame.new(60943,17,1744),
    ["Sky Island 2"]=CFrame.new(-7759,5606,-1862),
    ["Fountain City"]=CFrame.new(5259,37,4050),
    ["Port Town"]=CFrame.new(-297,8,5765),
    ["Dress Rosa"]=CFrame.new(-986,72,1088),
    ["Green Zone"]=CFrame.new(3601,8,3390),
    ["Punk Hazard"]=CFrame.new(584,14,5042),
    ["Thriller Bark"]=CFrame.new(-11467,8,-4901),
    ["Graveyard"]=CFrame.new(-6132,9,-1466),
    ["Hot Zone"]=CFrame.new(-5158,14,-4654),
    ["Wano"]=CFrame.new(-3282,57,-4286),
    ["Ice Castle"]=CFrame.new(1030,267,-5140),
    ["Floating Turtle"]=CFrame.new(-10828,331,-9049),
    ["Haunted Castle"]=CFrame.new(-12862,27,-7068),
    ["Sea of Treats"]=CFrame.new(582,25,-12550),
    ["Elf Island"]=CFrame.new(-4648,76,-13527),
    ["Cursed Ship"]=CFrame.new(-5085,1,-9698),
    ["Sea Castle"]=CFrame.new(1018,40,-10438),
    ["Factory"]=CFrame.new(-105,72,-670),
    ["Forgotten Island"]=CFrame.new(-3331,239,-10553),
}
local Codes = {
    "NOMOREHACK","BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS",
    "FIGHT4FRUIT","NOEXPLOITER","NOOB2ADMIN","CODESLIDE","ADMINHACKED","ADMINDARES",
    "fruitconcepts","krazydares","TRIPLEABUSE","SEATROLLING","24NOADMIN","REWARDFUN",
    "Chandler","NEWTROLL","KITT_RESET","Sub2CaptainMaui","kittgaming","Sub2Fer999",
    "Enyu_is_Pro","Magicbus","JCWK","Starcodeheo","Bluxxy","fudd10_v2",
    "SUB2GAMERROBOT_EXP1","Sub2NoobMaster123","Sub2UncleKizaru","Sub2Daigrock",
    "Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie","Fudd10","Bignews",
    "TheGreatAce","SECRET_ADMIN","SUB2GAMERROBOT_RESET1","SUB2OFFICIALNOOBIE",
    "AXIORE","BIGNEWS","BLUXXY","CHANDLER","ENYU_IS_PRO","FUDD10","FUDD10_V2",
    "KITTGAMING","MAGICBUS","STARCODEHEO","STRAWHATMAINE","SUB2CAPTAINMAUI",
    "SUB2DAIGROCK","SUB2FER999","SUB2NOOBMASTER123","SUB2UNCLEKIZARU","TANTAIGAMING",
    "THEGREATACE","1MLIKES","2MLIKES","3MLIKES","4MLIKES","5MLIKES","10MLIKES",
    "15MLIKES","20MLIKES","25MLIKES","30MLIKES","35MLIKES","40MLIKES","50MLIKES",
    "75MLIKES","100MLIKES","125MLIKES","150MLIKES","175MLIKES","200MLIKES",
    "250MLIKES","300MLIKES","350MLIKES","Sub2Gamer_Robot","Sub2KreekCraft",
    "Sub2RobloxPlayerHater","Sub2Notoriety","Sub2MahouTsukai","Sub2Pedro",
}

-- ═══════════════════════════════════════════
--         AUTO MOB SELECTOR
-- ═══════════════════════════════════════════
local function GetAutoMob()
    local lvl = GetLevel()
    local best,bestMax = nil,0
    for name,data in pairs(MobData) do
        if lvl >= data.L[1] and lvl <= data.L[2] then
            if data.L[2] > bestMax then best=name; bestMax=data.L[2] end
        end
    end
    return best
end

-- ═══════════════════════════════════════════
--     ANTI AFK + CHARACTER HOOKS
-- ═══════════════════════════════════════════
SafeCall(function()
    hookfunction(require(ReplicatedStorage.Effect.Container.Death),function()end)
    hookfunction(require(ReplicatedStorage.Effect.Container.Respawn),function()end)
end)
LP.Idled:Connect(function()
    if State.AntiAFK then
        local VU = game:GetService("VirtualUser")
        VU:Button2Down(Vector2.new(0,0),Cam.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0),Cam.CFrame)
    end
end)
LP.CharacterAdded:Connect(function(c)
    if State.AutoRespawn then task.wait(2) end
end)

-- ═══════════════════════════════════════════
--           FLY SYSTEM
-- ═══════════════════════════════════════════
local FlyActive = false
local function StartFly()
    if FlyActive then return end
    FlyActive = true
    local root = GetRoot(); if not root then FlyActive=false return end
    local bv = Instance.new("BodyVelocity",root)
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new()
    local bg = Instance.new("BodyGyro",root)
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    RunService.Heartbeat:Connect(function()
        if not State.FlyHack then
            if bv and bv.Parent then bv:Destroy() end
            if bg and bg.Parent then bg:Destroy() end
            FlyActive=false return
        end
        local cf = Cam.CFrame
        local d = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then d=d+cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then d=d-cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then d=d-cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then d=d+cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then d=d-Vector3.new(0,1,0) end
        bv.Velocity = d * State.FlySpeed
        bg.CFrame = cf
    end)
end

-- ═══════════════════════════════════════════
--       GAME LOOPS
-- ═══════════════════════════════════════════
UserInputService.JumpRequest:Connect(function()
    if State.InfJump then
        local h=GetHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
RunService.Heartbeat:Connect(function()
    local h = GetHum()
    if h then
        if State.SpeedHack then h.WalkSpeed = State.SpeedValue end
        h.JumpPower = State.JumpValue
    end
    if State.NoClip then
        local c = GetChar()
        if c then for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end end
    end
    if State.GravMult ~= 1 then Workspace.Gravity = 196.2 * State.GravMult end
end)
RunService.Heartbeat:Connect(function()
    if not State.AutoFarm or not IsAlive() then return end
    local mobName = State.SelectedMob == "Auto" and GetAutoMob() or State.SelectedMob
    if not mobName then return end
    local data = MobData[mobName]; if not data then return end
    local mob = GetNearestMob(200, mobName)
    if mob and mob.PrimaryPart then
        local root = GetRoot(); if not root then return end
        if Dist(root.Position, mob.PrimaryPart.Position) > 8 then
            TP(mob.PrimaryPart.CFrame * CFrame.new(0,0,5))
        end
        SafeCall(function() Remote:InvokeServer("Attack", mob) end)
        if State.AutoSkill then
            for i=1,4 do SafeCall(function() Remote:InvokeServer("UseSkill",i,mob.PrimaryPart.CFrame) end) end
        end
    else
        TP(data.MCF)
    end
end)
RunService.Heartbeat:Connect(function()
    if not State.AutoBoss or not IsAlive() then return end
    local data = BossData[State.SelectedBoss]; if not data then return end
    local boss = GetNearestMob(500, State.SelectedBoss)
    if boss and boss.PrimaryPart then
        local root = GetRoot(); if not root then return end
        if Dist(root.Position, boss.PrimaryPart.Position) > 8 then
            TP(boss.PrimaryPart.CFrame * CFrame.new(0,0,5))
        end
        SafeCall(function() Remote:InvokeServer("Attack",boss) end)
        if State.AutoSkill then
            for i=1,4 do SafeCall(function() Remote:InvokeServer("UseSkill",i,boss.PrimaryPart.CFrame) end) end
        end
    else TP(data.CF) end
end)
RunService.Heartbeat:Connect(function()
    if not State.KillAura or not IsAlive() then return end
    local root = GetRoot(); if not root then return end
    for _,mob in pairs(GetAllMobs()) do
        if mob.PrimaryPart and Dist(root.Position,mob.PrimaryPart.Position) <= State.AuraRange then
            SafeCall(function() Remote:InvokeServer("Attack",mob) end)
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if not State.HitboxExpand then return end
    for _,mob in pairs(GetAllMobs()) do
        for _,p in pairs(mob:GetDescendants()) do
            if p:IsA("BasePart") then p.Size=Vector3.new(State.HitboxValue,State.HitboxValue,State.HitboxValue) end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if not State.AutoMaterial or not IsAlive() then return end
    if State.SelectedMat == "None" then return end
    local mat = MatData[State.SelectedMat]; if not mat then return end
    local mob = GetNearestMob(200, mat.Mob)
    if mob and mob.PrimaryPart then
        local root = GetRoot(); if not root then return end
        if Dist(root.Position, mob.PrimaryPart.Position) > 8 then
            TP(mob.PrimaryPart.CFrame * CFrame.new(0,0,5))
        end
        SafeCall(function() Remote:InvokeServer("Attack",mob) end)
    else TP(mat.CF) end
end)
task.spawn(function()
    while true do task.wait(1)
        if State.AutoHaki and IsAlive() then SafeCall(function() Remote:InvokeServer("Haki") end) end
        if State.AutoKenHaki and IsAlive() then SafeCall(function() Remote:InvokeServer("ActivateObservation") end) end
        if State.AutoArmorHaki and IsAlive() then SafeCall(function() Remote:InvokeServer("ActivateBuso") end) end
        if State.AutoStats then
            local pts = LP.Data and LP.Data.StatPoint and LP.Data.StatPoint.Value or 0
            if pts > 0 then SafeCall(function() Remote:InvokeServer("IncreaseStats",State.StatType,pts) end) end
        end
    end
end)
task.spawn(function()
    while true do task.wait(0.5)
        if State.AntiFreeze then local h=GetHum(); if h then h.PlatformStand=false end end
        if State.AntiBlind then
            for _,obj in pairs(LP.PlayerGui:GetDescendants()) do
                if obj:IsA("Frame") and obj.BackgroundColor3==Color3.new(0,0,0) and obj.BackgroundTransparency<0.3 then
                    obj.BackgroundTransparency=1
                end
            end
        end
        if State.Fullbright then
            Lighting.Brightness=2; Lighting.ClockTime=14
            Lighting.FogEnd=1e6; Lighting.GlobalShadows=false
        end
        if State.AutoBlock and IsAlive() then
            if GetNearestMob(35) then SafeCall(function() Remote:InvokeServer("Block") end) end
        end
        if State.AutoParry and IsAlive() then SafeCall(function() Remote:InvokeServer("Parry") end) end
    end
end)
task.spawn(function()
    while true do task.wait(5)
        if State.ServerHop and IsAlive() then
            local h=GetHum()
            if h and (h.Health/h.MaxHealth*100) <= State.ServerHopHP then
                SafeCall(function()
                    local d=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
                    for _,s in pairs(d.data) do
                        if s.id~=game.JobId and s.playing<s.maxPlayers then
                            TeleportService:TeleportToPlaceInstance(PlaceId,s.id,LP) return
                        end
                    end
                end)
            end
        end
    end
end)

-- ═══════════════════════════════════════════
--       FOV CIRCLE
-- ═══════════════════════════════════════════
local FovSG = Instance.new("ScreenGui",LP.PlayerGui)
FovSG.Name="FovCircleGui"; FovSG.ResetOnSpawn=false
local FovF = Instance.new("Frame",FovSG)
FovF.BackgroundTransparency=1; FovF.BorderSizePixel=0
FovF.Size=UDim2.new(0,4,0,4); FovF.AnchorPoint=Vector2.new(0.5,0.5)
local FovUI = Instance.new("UICorner",FovF); FovUI.CornerRadius=UDim.new(1,0)
local FovStroke = Instance.new("UIStroke",FovF)
FovStroke.Color=Color3.fromRGB(150,50,255); FovStroke.Thickness=2
RunService.RenderStepped:Connect(function()
    if State.FovCircle then
        local s = State.FovValue*5
        FovF.Size=UDim2.new(0,s,0,s)
        FovF.Position=UDim2.new(0.5,0,0.5,0)
        FovF.Visible=true
    else FovF.Visible=false end
end)

-- ═══════════════════════════════════════════
--       ESP SYSTEM
-- ═══════════════════════════════════════════
local ESPFolder = Instance.new("Folder",Workspace); ESPFolder.Name="ESP"
local function ClearESP() for _,v in pairs(ESPFolder:GetChildren()) do v:Destroy() end end
local function MakeESP(obj,color,text)
    local bb=Instance.new("BillboardGui",ESPFolder)
    bb.AlwaysOnTop=true; bb.Size=UDim2.new(0,160,0,44); bb.StudsOffset=Vector3.new(0,3.5,0)
    local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")) or obj
    if part then bb.Adornee=part end
    local bg=Instance.new("Frame",bb); bg.Size=UDim2.new(1,0,1,0)
    bg.BackgroundColor3=Color3.fromRGB(8,0,15); bg.BackgroundTransparency=0.35; bg.BorderSizePixel=0
    local corner=Instance.new("UICorner",bg); corner.CornerRadius=UDim.new(0,4)
    local stroke=Instance.new("UIStroke",bg); stroke.Color=color or Color3.fromRGB(150,50,255); stroke.Thickness=1
    local lbl=Instance.new("TextLabel",bg)
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Text=text; lbl.TextColor3=color or Color3.fromRGB(200,150,255)
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
    lbl.TextStrokeTransparency=0.5
end
task.spawn(function()
    while true do task.wait(0.5)
        if State.ESP then
            ClearESP()
            if State.MobESP then
                for _,mob in pairs(GetAllMobs()) do
                    local hp=mob.Humanoid.Health; local mhp=mob.Humanoid.MaxHealth
                    local pct=mhp>0 and math.floor(hp/mhp*100) or 0
                    MakeESP(mob,Color3.fromRGB(150,50,255),mob.Name.."\n❤ "..pct.."%")
                end
            end
            if State.PlayerESP then
                for _,plr in pairs(Players:GetPlayers()) do
                    if plr~=LP and plr.Character and plr.Character.PrimaryPart then
                        MakeESP(plr.Character,Color3.fromRGB(100,200,255),"👤 "..plr.Name)
                    end
                end
            end
            if State.FruitESP then
                for _,obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("fruit") then
                        local p=obj:IsA("Model") and obj.PrimaryPart or obj:IsA("BasePart") and obj
                        if p then MakeESP(obj,Color3.fromRGB(255,100,200),"🍎 "..obj.Name) end
                    end
                end
            end
            if State.ChestESP then
                for _,obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name:lower():find("chest") then
                        local p=obj:IsA("Model") and obj.PrimaryPart or obj:IsA("BasePart") and obj
                        if p then MakeESP(obj,Color3.fromRGB(255,215,0),"💰 Chest") end
                    end
                end
            end
        else ClearESP() end
    end
end)

-- ═══════════════════════════════════════════════════════════
--
--              ██████╗ ██╗   ██╗██╗
--             ██╔════╝ ██║   ██║██║
--             ██║  ███╗██║   ██║██║
--             ██║   ██║██║   ██║██║
--             ╚██████╔╝╚██████╔╝██║
--              ╚═════╝  ╚═════╝ ╚═╝
--       CUSTOM GUI - FULL FROM SCRATCH
-- ═══════════════════════════════════════════════════════════

-- ── Colours ──────────────────────────────────
local C = {
    Win      = Color3.fromRGB(8,  6,  14),
    TitleBar = Color3.fromRGB(14, 8,  26),
    TabBar   = Color3.fromRGB(11, 6,  20),
    TabBG    = Color3.fromRGB(18, 10, 32),
    TabHov   = Color3.fromRGB(28, 14, 50),
    TabSel   = Color3.fromRGB(35, 12, 65),
    Content  = Color3.fromRGB(13, 8,  22),
    Section  = Color3.fromRGB(20, 12, 35),
    Element  = Color3.fromRGB(24, 14, 42),
    ElemHov  = Color3.fromRGB(34, 18, 60),
    Purple   = Color3.fromRGB(140, 50, 240),
    Purple2  = Color3.fromRGB(180, 90, 255),
    PurpleDim= Color3.fromRGB(90,  35, 160),
    Text     = Color3.fromRGB(230, 220, 255),
    TextDim  = Color3.fromRGB(140, 120, 180),
    TextOff  = Color3.fromRGB(80,  70,  110),
    ON       = Color3.fromRGB(120, 40,  210),
    ONknob   = Color3.fromRGB(200, 160, 255),
    OFF      = Color3.fromRGB(45,  30,  70),
    OFFknob  = Color3.fromRGB(110, 90,  140),
    SliderFG = Color3.fromRGB(140, 50,  240),
    SliderBG = Color3.fromRGB(35,  20,  60),
    DropBG   = Color3.fromRGB(16,  9,   28),
    Border   = Color3.fromRGB(100, 30,  180),
    Border2  = Color3.fromRGB(60,  20,  110),
    Notif    = Color3.fromRGB(16,  8,   28),
}

-- ── Helpers ───────────────────────────────────
local function New(cls, props, parent)
    local o = Instance.new(cls)
    if parent then o.Parent = parent end
    for k,v in pairs(props) do o[k] = v end
    return o
end
local function Tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad), props):Play()
end
local function MakeDraggable(win, handle)
    local drag, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; dragStart=i.Position; startPos=win.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then dragInput=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and i==dragInput then
            local d=i.Position-dragStart
            win.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

-- ── Notification System ────────────────────────
local NotifSG = New("ScreenGui",{Name="BloxNotif",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},LP.PlayerGui)
local function Notify(title, msg, dur)
    dur = dur or 3
    local NF = New("Frame",{
        Size=UDim2.new(0,280,0,0), Position=UDim2.new(1,-295,1,-10),
        AnchorPoint=Vector2.new(0,1),
        BackgroundColor3=C.Notif, BorderSizePixel=0,
        AutomaticSize=Enum.AutomaticSize.Y,
        ClipsDescendants=true,
    },NotifSG)
    New("UICorner",{CornerRadius=UDim.new(0,8)},NF)
    New("UIStroke",{Color=C.Purple,Thickness=1.5},NF)
    local inner = New("Frame",{Size=UDim2.new(1,0,0,0),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y,BorderSizePixel=0},NF)
    New("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)},inner)
    New("UIPadding",{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10)},inner)
    local bar = New("Frame",{Size=UDim2.new(1,0,0,2),BackgroundColor3=C.Purple,BorderSizePixel=0},NF)
    New("UICorner",{CornerRadius=UDim.new(0,2)},bar)
    New("TextLabel",{
        Size=UDim2.new(1,0,0,18),BackgroundTransparency=1,
        Text=title,TextColor3=C.Purple2,
        Font=Enum.Font.GothamBold,TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left
    },inner)
    New("TextLabel",{
        Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundTransparency=1,
        Text=msg,TextColor3=C.TextDim,
        Font=Enum.Font.Gotham,TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextWrapped=true
    },inner)
    local prog = New("Frame",{
        Size=UDim2.new(1,0,0,2),Position=UDim2.new(0,0,1,-2),
        BackgroundColor3=C.Purple,BorderSizePixel=0
    },NF)
    New("UICorner",{CornerRadius=UDim.new(0,2)},prog)
    NF.Position = UDim2.new(1,10,1,-10)
    Tween(NF,{Position=UDim2.new(1,-295,1,-10)},0.3)
    Tween(prog,{Size=UDim2.new(0,0,0,2)},dur)
    task.delay(dur+0.1, function()
        Tween(NF,{Position=UDim2.new(1,10,1,-10)},0.25)
        task.wait(0.3); NF:Destroy()
    end)
end

-- ── MAIN SCREEN GUI ────────────────────────────
local SG = New("ScreenGui",{
    Name="BloxScript",ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling
})
pcall(function() SG.Parent=LP.PlayerGui end)
if not SG.Parent then SG.Parent=game:GetService("CoreGui") end

-- ── Window Frame ───────────────────────────────
local WIN = New("Frame",{
    Name="Window",
    Size=UDim2.new(0,600,0,420),
    Position=UDim2.new(0.5,-300,0.5,-210),
    BackgroundColor3=C.Win,
    BorderSizePixel=0,
    ClipsDescendants=false,
},SG)
New("UICorner",{CornerRadius=UDim.new(0,10)},WIN)
New("UIStroke",{Color=C.Border,Thickness=1.5,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},WIN)

-- Shadow
local Shadow = New("ImageLabel",{
    Size=UDim2.new(1,40,1,40),Position=UDim2.new(0,-20,0,-20),
    BackgroundTransparency=1,
    Image="rbxassetid://5028857084",
    ImageColor3=Color3.fromRGB(60,0,120),
    ImageTransparency=0.7,
    ScaleType=Enum.ScaleType.Slice,
    SliceCenter=Rect.new(24,24,276,276),
    ZIndex=0,
},WIN)

-- ── Title Bar ──────────────────────────────────
local TitleBar = New("Frame",{
    Name="TitleBar",Size=UDim2.new(1,0,0,40),
    BackgroundColor3=C.TitleBar,BorderSizePixel=0,
    ClipsDescendants=true,
},WIN)
New("UICorner",{CornerRadius=UDim.new(0,10)},TitleBar)
-- Fix bottom corners of title bar
New("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),BackgroundColor3=C.TitleBar,BorderSizePixel=0},TitleBar)
New("UIStroke",{Color=C.Border2,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},TitleBar)

-- Logo dot
local LogoDot = New("Frame",{
    Size=UDim2.new(0,8,0,8),Position=UDim2.new(0,14,0.5,-4),
    BackgroundColor3=C.Purple,BorderSizePixel=0,
},TitleBar)
New("UICorner",{CornerRadius=UDim.new(1,0)},LogoDot)
New("UIGradient",{Color=ColorSequence.new(C.Purple2,C.Purple)},LogoDot)

New("TextLabel",{
    Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,28,0,0),
    BackgroundTransparency=1,
    Text="BLOX SCRIPT",
    TextColor3=C.Purple2,Font=Enum.Font.GothamBold,TextSize=14,
    TextXAlignment=Enum.TextXAlignment.Left,
},TitleBar)

-- Subtitle
New("TextLabel",{
    Size=UDim2.new(0,200,1,0),Position=UDim2.new(0,130,0,0),
    BackgroundTransparency=1,
    Text="v5.0 | "..WorldName,
    TextColor3=C.PurpleDim,Font=Enum.Font.Gotham,TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left,
},TitleBar)

-- Close Button
local CloseBtn = New("TextButton",{
    Size=UDim2.new(0,26,0,24),Position=UDim2.new(1,-34,0.5,-12),
    BackgroundColor3=Color3.fromRGB(140,30,50),BorderSizePixel=0,
    Text="✕",TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=13,
    AutoButtonColor=false,
},TitleBar)
New("UICorner",{CornerRadius=UDim.new(0,6)},CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() SG.Enabled=false end)
CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn,{BackgroundColor3=Color3.fromRGB(200,50,70)}) end)
CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn,{BackgroundColor3=Color3.fromRGB(140,30,50)}) end)

-- Minimize Button
local MinBtn = New("TextButton",{
    Size=UDim2.new(0,26,0,24),Position=UDim2.new(1,-64,0.5,-12),
    BackgroundColor3=C.Element,BorderSizePixel=0,
    Text="─",TextColor3=C.TextDim,Font=Enum.Font.GothamBold,TextSize=14,
    AutoButtonColor=false,
},TitleBar)
New("UICorner",{CornerRadius=UDim.new(0,6)},MinBtn)
New("UIStroke",{Color=C.Border2,Thickness=1},MinBtn)
local minimized = false
local ContentContainer
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if ContentContainer then
        ContentContainer.Visible = not minimized
        Tween(WIN,{Size=minimized and UDim2.new(0,600,0,40) or UDim2.new(0,600,0,420)},0.2)
        MinBtn.Text = minimized and "□" or "─"
    end
end)
MinBtn.MouseEnter:Connect(function() Tween(MinBtn,{BackgroundColor3=C.ElemHov}) end)
MinBtn.MouseLeave:Connect(function() Tween(MinBtn,{BackgroundColor3=C.Element}) end)

MakeDraggable(WIN, TitleBar)

-- ── Content Container ──────────────────────────
ContentContainer = New("Frame",{
    Size=UDim2.new(1,0,1,-40),Position=UDim2.new(0,0,0,40),
    BackgroundTransparency=1,BorderSizePixel=0,
},WIN)

-- ── Tab Bar (Left Side) ────────────────────────
local TabBar = New("Frame",{
    Size=UDim2.new(0,130,1,0),
    BackgroundColor3=C.TabBar,BorderSizePixel=0,
},ContentContainer)
New("UICorner",{CornerRadius=UDim.new(0,0)},TabBar)
-- bottom-left corner round only
local TabBarBL = New("Frame",{
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),
    BackgroundColor3=C.TabBar,BorderSizePixel=0,
},TabBar)
New("UIStroke",{Color=C.Border2,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},TabBar)

-- Tab scroll
local TabScroll = New("ScrollingFrame",{
    Size=UDim2.new(1,0,1,-8),Position=UDim2.new(0,0,0,8),
    BackgroundTransparency=1,BorderSizePixel=0,
    ScrollBarThickness=2,ScrollBarImageColor3=C.Purple,
    ScrollBarImageTransparency=0.4,
    CanvasSize=UDim2.new(0,0,0,0),
},TabBar)
local TabList = New("UIListLayout",{Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder},TabScroll)
New("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,4)},TabScroll)
TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize=UDim2.new(0,0,0,TabList.AbsoluteContentSize.Y+8)
end)

-- ── Content Area ───────────────────────────────
local ContentArea = New("Frame",{
    Size=UDim2.new(1,-130,1,0),Position=UDim2.new(0,130,0,0),
    BackgroundColor3=C.Content,BorderSizePixel=0,
},ContentContainer)
New("UICorner",{CornerRadius=UDim.new(0,0)},ContentArea)
-- bottom-right corner round
New("Frame",{
    Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),
    BackgroundColor3=C.Content,BorderSizePixel=0,
},ContentArea)

-- ── Tab / Section / Element Builders ───────────
local AllTabs     = {}
local AllTabBtns  = {}
local ActiveTab   = nil

local function SelectTab(frame, btn)
    for _,f in pairs(AllTabs) do f.Visible=false end
    for _,b in pairs(AllTabBtns) do
        b.BackgroundColor3=C.TabBG
        b.TextColor3=C.TextOff
        local s=b:FindFirstChildOfClass("UIStroke"); if s then s.Color=C.Border2 end
        local dot=b:FindFirstChild("Dot"); if dot then dot.Visible=false end
    end
    frame.Visible=true
    btn.BackgroundColor3=C.TabSel
    btn.TextColor3=C.Purple2
    local s=btn:FindFirstChildOfClass("UIStroke"); if s then s.Color=C.Purple end
    local dot=btn:FindFirstChild("Dot"); if dot then dot.Visible=true end
    ActiveTab=frame
end

local function AddTab(icon, name)
    -- Tab button
    local btn = New("TextButton",{
        Size=UDim2.new(1,0,0,34),
        BackgroundColor3=C.TabBG,
        BorderSizePixel=0,
        Text=icon.." "..name,
        TextColor3=C.TextOff,
        Font=Enum.Font.Gotham,TextSize=12,
        AutoButtonColor=false,
        TextXAlignment=Enum.TextXAlignment.Left,
    },TabScroll)
    New("UICorner",{CornerRadius=UDim.new(0,7)},btn)
    New("UIStroke",{Color=C.Border2,Thickness=1},btn)
    New("UIPadding",{PaddingLeft=UDim.new(0,10)},btn)
    local dot = New("Frame",{
        Name="Dot",Size=UDim2.new(0,4,0,4),
        Position=UDim2.new(1,-10,0.5,-2),
        BackgroundColor3=C.Purple2,BorderSizePixel=0,Visible=false,
    },btn)
    New("UICorner",{CornerRadius=UDim.new(1,0)},dot)
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3~=C.TabSel then Tween(btn,{BackgroundColor3=C.TabHov}) end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3~=C.TabSel then Tween(btn,{BackgroundColor3=C.TabBG}) end
    end)
    -- Tab content (scrollable)
    local page = New("ScrollingFrame",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,BorderSizePixel=0,
        ScrollBarThickness=3,
        ScrollBarImageColor3=C.Purple,
        ScrollBarImageTransparency=0.3,
        CanvasSize=UDim2.new(0,0,0,0),
        Visible=false,
    },ContentArea)
    local pageLayout = New("UIListLayout",{
        Padding=UDim.new(0,8),
        SortOrder=Enum.SortOrder.LayoutOrder,
    },page)
    New("UIPadding",{
        PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,14),
        PaddingTop=UDim.new(0,10),PaddingBottom=UDim.new(0,10),
    },page)
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize=UDim2.new(0,0,0,pageLayout.AbsoluteContentSize.Y+20)
    end)
    table.insert(AllTabs, page)
    table.insert(AllTabBtns, btn)
    btn.MouseButton1Click:Connect(function() SelectTab(page,btn) end)
    if #AllTabs==1 then SelectTab(page,btn) end

    -- ── Section ────────────────────────────────
    local T = {}
    function T:Section(title)
        local S = {}
        local secFrame = New("Frame",{
            Size=UDim2.new(1,0,0,0),
            BackgroundColor3=C.Section,
            BorderSizePixel=0,
            AutomaticSize=Enum.AutomaticSize.Y,
            ClipsDescendants=false,
        },page)
        New("UICorner",{CornerRadius=UDim.new(0,8)},secFrame)
        New("UIStroke",{Color=C.Border2,Thickness=1},secFrame)
        -- Section title
        local hdr = New("Frame",{
            Size=UDim2.new(1,0,0,30),
            BackgroundColor3=C.TitleBar,BorderSizePixel=0,
        },secFrame)
        New("UICorner",{CornerRadius=UDim.new(0,8)},hdr)
        New("Frame",{Size=UDim2.new(1,0,0,10),Position=UDim2.new(0,0,1,-10),BackgroundColor3=C.TitleBar,BorderSizePixel=0},hdr)
        local hdrLine = New("Frame",{
            Size=UDim2.new(0,3,0,16),Position=UDim2.new(0,10,0.5,-8),
            BackgroundColor3=C.Purple,BorderSizePixel=0,
        },hdr)
        New("UICorner",{CornerRadius=UDim.new(1,0)},hdrLine)
        New("UIGradient",{
            Color=ColorSequence.new(C.Purple2,C.PurpleDim),
            Rotation=90,
        },hdrLine)
        New("TextLabel",{
            Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,20,0,0),
            BackgroundTransparency=1,
            Text=title:upper(),
            TextColor3=C.TextDim,Font=Enum.Font.GothamBold,TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left,
            LetterSpacingOffset=2,
        },hdr)
        -- inner content
        local inner = New("Frame",{
            Size=UDim2.new(1,0,0,0),
            Position=UDim2.new(0,0,0,30),
            BackgroundTransparency=1,BorderSizePixel=0,
            AutomaticSize=Enum.AutomaticSize.Y,
        },secFrame)
        local innerList = New("UIListLayout",{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},inner)
        New("UIPadding",{
            PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),
            PaddingTop=UDim.new(0,6),PaddingBottom=UDim.new(0,8),
        },inner)

        local function ElemBase(h)
            local f = New("Frame",{
                Size=UDim2.new(1,0,0,h or 36),
                BackgroundColor3=C.Element,BorderSizePixel=0,
            },inner)
            New("UICorner",{CornerRadius=UDim.new(0,7)},f)
            New("UIStroke",{Color=C.Border2,Thickness=1},f)
            return f
        end

        -- ── BUTTON ────────────────────────────
        function S:Button(cfg)
            local f = ElemBase(36)
            local ripple = New("Frame",{
                Size=UDim2.new(0,0,0,0),
                AnchorPoint=Vector2.new(0.5,0.5),
                Position=UDim2.new(0.5,0,0.5,0),
                BackgroundColor3=C.Purple,
                BackgroundTransparency=0.7,
                BorderSizePixel=0,
                ZIndex=2,
            },f)
            New("UICorner",{CornerRadius=UDim.new(1,0)},ripple)
            New("TextLabel",{
                Size=UDim2.new(1,-20,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text=cfg.Title or "Button",
                TextColor3=C.Text,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,
            },f)
            -- Right arrow indicator
            New("TextLabel",{
                Size=UDim2.new(0,20,1,0),Position=UDim2.new(1,-24,0,0),
                BackgroundTransparency=1,
                Text="›",TextColor3=C.PurpleDim,
                Font=Enum.Font.GothamBold,TextSize=16,ZIndex=3,
            },f)
            if cfg.Description then
                f.Size = UDim2.new(1,0,0,46)
                New("TextLabel",{
                    Size=UDim2.new(1,-20,0,14),Position=UDim2.new(0,12,0,22),
                    BackgroundTransparency=1,
                    Text=cfg.Description,TextColor3=C.TextOff,
                    Font=Enum.Font.Gotham,TextSize=10,
                    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,
                },f)
            end
            local btn = New("TextButton",{
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text="",ZIndex=4,AutoButtonColor=false,
            },f)
            btn.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.ElemHov}) end)
            btn.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Element}) end)
            btn.MouseButton1Click:Connect(function()
                Tween(f,{BackgroundColor3=Color3.fromRGB(50,20,90)})
                task.delay(0.12,function() Tween(f,{BackgroundColor3=C.Element}) end)
                if cfg.Callback then SafeCall(cfg.Callback) end
            end)
        end

        -- ── TOGGLE ────────────────────────────
        function S:Toggle(cfg)
            local val = cfg.Default or false
            local f = ElemBase(38)
            New("TextLabel",{
                Size=UDim2.new(1,-56,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text=cfg.Title or "Toggle",
                TextColor3=val and C.Text or C.TextDim,
                Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            },f)
            -- Track
            local track = New("Frame",{
                Size=UDim2.new(0,42,0,22),
                Position=UDim2.new(1,-52,0.5,-11),
                BackgroundColor3=val and C.ON or C.OFF,BorderSizePixel=0,
            },f)
            New("UICorner",{CornerRadius=UDim.new(1,0)},track)
            New("UIStroke",{Color=val and C.Purple or C.Border2,Thickness=1},track)
            -- Knob
            local knob = New("Frame",{
                Size=UDim2.new(0,18,0,18),
                Position=val and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),
                BackgroundColor3=val and C.ONknob or C.OFFknob,BorderSizePixel=0,
            },track)
            New("UICorner",{CornerRadius=UDim.new(1,0)},knob)
            local shadow2 = New("UIStroke",{Color=Color3.fromRGB(0,0,0),Transparency=0.6,Thickness=1},knob)

            local lbl = f:FindFirstChildOfClass("TextLabel")
            local trkStroke = track:FindFirstChildOfClass("UIStroke")

            local btn = New("TextButton",{
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
                Text="",AutoButtonColor=false,ZIndex=3,
            },f)
            local function SetVal(v)
                val=v
                Tween(track,{BackgroundColor3=v and C.ON or C.OFF})
                if trkStroke then Tween(trkStroke,{Color=v and C.Purple or C.Border2}) end
                Tween(knob,{Position=v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9),BackgroundColor3=v and C.ONknob or C.OFFknob})
                if lbl then lbl.TextColor3 = v and C.Text or C.TextDim end
                Tween(f,{BackgroundColor3=v and Color3.fromRGB(28,16,50) or C.Element})
            end
            btn.MouseButton1Click:Connect(function()
                SetVal(not val)
                if cfg.Callback then SafeCall(cfg.Callback,val) end
            end)
            btn.MouseEnter:Connect(function() if not val then Tween(f,{BackgroundColor3=C.ElemHov}) end end)
            btn.MouseLeave:Connect(function() if not val then Tween(f,{BackgroundColor3=C.Element}) end end)
            return {Get=function() return val end,Set=function(v) SetVal(v); if cfg.Callback then SafeCall(cfg.Callback,v) end end}
        end

        -- ── SLIDER ─────────────────────────────
        function S:Slider(cfg)
            local min,max = cfg.Min or 0, cfg.Max or 100
            local val = cfg.Default or min
            local f = ElemBase(52)
            local title = New("TextLabel",{
                Size=UDim2.new(1,-70,0,22),Position=UDim2.new(0,12,0,4),
                BackgroundTransparency=1,
                Text=cfg.Title or "Slider",
                TextColor3=C.Text,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            },f)
            local valLbl = New("TextLabel",{
                Size=UDim2.new(0,60,0,22),Position=UDim2.new(1,-68,0,4),
                BackgroundTransparency=1,
                Text=tostring(val),
                TextColor3=C.Purple2,Font=Enum.Font.GothamBold,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Right,
            },f)
            -- Track
            local track = New("Frame",{
                Size=UDim2.new(1,-24,0,6),Position=UDim2.new(0,12,0,34),
                BackgroundColor3=C.SliderBG,BorderSizePixel=0,
            },f)
            New("UICorner",{CornerRadius=UDim.new(1,0)},track)
            New("UIStroke",{Color=C.Border2,Thickness=1},track)
            -- Fill
            local fill = New("Frame",{
                Size=UDim2.new((val-min)/(max-min),0,1,0),
                BackgroundColor3=C.SliderFG,BorderSizePixel=0,
            },track)
            New("UICorner",{CornerRadius=UDim.new(1,0)},fill)
            New("UIGradient",{
                Color=ColorSequence.new(C.Purple2,C.Purple),
                Rotation=0,
            },fill)
            -- Knob
            local knob = New("Frame",{
                Size=UDim2.new(0,16,0,16),
                Position=UDim2.new((val-min)/(max-min),0,0.5,-8),
                BackgroundColor3=Color3.fromRGB(220,180,255),BorderSizePixel=0,
                ZIndex=5,
            },track)
            New("UICorner",{CornerRadius=UDim.new(1,0)},knob)
            New("UIStroke",{Color=C.Purple,Thickness=2},knob)

            local sliding=false
            local function Update(inputX)
                local rel=math.clamp((inputX-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                if cfg.Int ~= false then val=math.floor(min+(max-min)*rel)
                else val=math.floor((min+(max-min)*rel)*100)/100 end
                fill.Size=UDim2.new(rel,0,1,0)
                knob.Position=UDim2.new(rel,0,0.5,-8)
                valLbl.Text=tostring(val)
                if cfg.Callback then SafeCall(cfg.Callback,val) end
            end
            track.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=true; Update(i.Position.X) end
            end)
            track.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then Update(i.Position.X) end
            end)
            f.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.ElemHov}) end)
            f.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Element}) end)
            return {Get=function() return val end}
        end

        -- ── DROPDOWN ───────────────────────────
        function S:Dropdown(cfg)
            local selected = cfg.Default or (cfg.Options and cfg.Options[1]) or "Select"
            local open = false
            local f = ElemBase(38)
            f.ClipsDescendants = false
            New("TextLabel",{
                Size=UDim2.new(0.5,0,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text=cfg.Title or "Dropdown",
                TextColor3=C.Text,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=2,
            },f)
            local selLbl = New("TextLabel",{
                Size=UDim2.new(0.5,-8,1,0),Position=UDim2.new(0.5,0,0,0),
                BackgroundTransparency=1,
                Text=selected.." ▾",
                TextColor3=C.Purple,Font=Enum.Font.Gotham,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Right,ZIndex=2,
            },f)
            -- Dropdown list
            local dropW = Instance.new("Frame")
            dropW.Size=UDim2.new(1,0,0,0)
            dropW.Position=UDim2.new(0,0,1,4)
            dropW.BackgroundColor3=C.DropBG
            dropW.BorderSizePixel=0
            dropW.ClipsDescendants=true
            dropW.ZIndex=20
            New("UICorner",{CornerRadius=UDim.new(0,7)},dropW)
            New("UIStroke",{Color=C.Purple,Thickness=1},dropW)
            dropW.Parent=f

            local dropList = New("Frame",{
                Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1,BorderSizePixel=0,
            },dropW)
            local dropLayout = New("UIListLayout",{Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder},dropList)
            New("UIPadding",{PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,4)},dropList)

            local optCount = cfg.Options and #cfg.Options or 0
            local optHeight = math.min(optCount*30+12, 180)

            for _,opt in ipairs(cfg.Options or {}) do
                local ob = New("TextButton",{
                    Size=UDim2.new(1,0,0,28),
                    BackgroundColor3=C.Element,BorderSizePixel=0,
                    Text=opt,TextColor3=C.Text,
                    Font=Enum.Font.Gotham,TextSize=12,
                    AutoButtonColor=false,ZIndex=21,
                },dropList)
                New("UICorner",{CornerRadius=UDim.new(0,5)},ob)
                ob.MouseEnter:Connect(function() Tween(ob,{BackgroundColor3=C.ElemHov,TextColor3=C.Purple2}) end)
                ob.MouseLeave:Connect(function() Tween(ob,{BackgroundColor3=C.Element,TextColor3=C.Text}) end)
                ob.MouseButton1Click:Connect(function()
                    selected=opt; selLbl.Text=opt.." ▾"
                    open=false; Tween(dropW,{Size=UDim2.new(1,0,0,0)})
                    if cfg.Callback then SafeCall(cfg.Callback,opt) end
                end)
            end

            local togBtn = New("TextButton",{
                Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=5,AutoButtonColor=false,
            },f)
            togBtn.MouseButton1Click:Connect(function()
                open=not open
                Tween(dropW,{Size=open and UDim2.new(1,0,0,optHeight) or UDim2.new(1,0,0,0)})
                selLbl.Text=selected..(open and " ▴" or " ▾")
            end)
            f.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.ElemHov}) end)
            f.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Element}) end)
            return {Get=function() return selected end}
        end

        -- ── LABEL ──────────────────────────────
        function S:Label(text, color)
            local f = New("Frame",{
                Size=UDim2.new(1,0,0,24),
                BackgroundTransparency=1,BorderSizePixel=0,
            },inner)
            New("TextLabel",{
                Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text="• "..text,
                TextColor3=color or C.TextDim,
                Font=Enum.Font.Gotham,TextSize=12,
                TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
            },f)
        end

        -- ── INPUT ──────────────────────────────
        function S:Input(cfg)
            local f = ElemBase(38)
            New("TextLabel",{
                Size=UDim2.new(0,100,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text=cfg.Title or "Input",
                TextColor3=C.Text,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            },f)
            local box = New("TextBox",{
                Size=UDim2.new(1,-120,0,24),Position=UDim2.new(0,108,0.5,-12),
                BackgroundColor3=C.DropBG,BorderSizePixel=0,
                Text=cfg.Default or "",
                PlaceholderText=cfg.Placeholder or "Type here...",
                TextColor3=C.Text,PlaceholderColor3=C.TextOff,
                Font=Enum.Font.Gotham,TextSize=12,
                ClearTextOnFocus=false,ZIndex=3,
            },f)
            New("UICorner",{CornerRadius=UDim.new(0,5)},box)
            New("UIStroke",{Color=C.Border2,Thickness=1},box)
            New("UIPadding",{PaddingLeft=UDim.new(0,6)},box)
            box.Focused:Connect(function() Tween(box:FindFirstChildOfClass("UIStroke"),{Color=C.Purple}) end)
            box.FocusLost:Connect(function(enter)
                Tween(box:FindFirstChildOfClass("UIStroke"),{Color=C.Border2})
                if enter and cfg.Callback then SafeCall(cfg.Callback,box.Text) end
            end)
            f.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.ElemHov}) end)
            f.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Element}) end)
            return {Get=function() return box.Text end}
        end

        -- ── COLOR PICKER ───────────────────────
        function S:ColorPicker(cfg)
            local val = cfg.Default or Color3.fromRGB(150,50,255)
            local f = ElemBase(38)
            New("TextLabel",{
                Size=UDim2.new(1,-70,1,0),Position=UDim2.new(0,12,0,0),
                BackgroundTransparency=1,
                Text=cfg.Title or "Color",
                TextColor3=C.Text,Font=Enum.Font.Gotham,TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left,
            },f)
            local swatch = New("Frame",{
                Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-38,0.5,-13),
                BackgroundColor3=val,BorderSizePixel=0,ZIndex=3,
            },f)
            New("UICorner",{CornerRadius=UDim.new(0,6)},swatch)
            New("UIStroke",{Color=C.Purple,Thickness=1.5},swatch)
            -- Simple hue slider for color picking
            local open=false
            local picker = New("Frame",{
                Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,4),
                BackgroundColor3=C.DropBG,BorderSizePixel=0,
                ClipsDescendants=true,ZIndex=20,
            },f)
            New("UICorner",{CornerRadius=UDim.new(0,7)},picker)
            New("UIStroke",{Color=C.Purple,Thickness=1},picker)
            -- Hue bar
            local hueBar = New("Frame",{
                Size=UDim2.new(1,-16,0,20),Position=UDim2.new(0,8,0,10),
                BackgroundColor3=Color3.new(1,0,0),BorderSizePixel=0,ZIndex=21,
            },picker)
            New("UICorner",{CornerRadius=UDim.new(0,4)},hueBar)
            New("UIGradient",{
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),
                    ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
                    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,0)),
                }),
            },hueBar)
            local hue=0
            local hueKnob = New("Frame",{
                Size=UDim2.new(0,14,0,14),Position=UDim2.new(0,-7,0.5,-7),
                BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=22,
            },hueBar)
            New("UICorner",{CornerRadius=UDim.new(1,0)},hueKnob)
            New("UIStroke",{Color=Color3.new(0,0,0),Thickness=1},hueKnob)
            local sliding2=false
            hueBar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then
                    sliding2=true
                    hue=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                    hueKnob.Position=UDim2.new(hue,-7,0.5,-7)
                    val=Color3.fromHSV(hue,1,1)
                    swatch.BackgroundColor3=val
                    if cfg.Callback then SafeCall(cfg.Callback,val) end
                end
            end)
            hueBar.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding2=false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding2 and i.UserInputType==Enum.UserInputType.MouseMovement then
                    hue=math.clamp((i.Position.X-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,1)
                    hueKnob.Position=UDim2.new(hue,-7,0.5,-7)
                    val=Color3.fromHSV(hue,1,1)
                    swatch.BackgroundColor3=val
                    if cfg.Callback then SafeCall(cfg.Callback,val) end
                end
            end)
            local swatchBtn = New("TextButton",{
                Size=UDim2.new(0,26,0,26),Position=UDim2.new(1,-38,0.5,-13),
                BackgroundTransparency=1,Text="",ZIndex=4,AutoButtonColor=false,
            },f)
            swatchBtn.MouseButton1Click:Connect(function()
                open=not open
                Tween(picker,{Size=open and UDim2.new(1,0,0,44) or UDim2.new(1,0,0,0)})
            end)
            f.MouseEnter:Connect(function() Tween(f,{BackgroundColor3=C.ElemHov}) end)
            f.MouseLeave:Connect(function() Tween(f,{BackgroundColor3=C.Element}) end)
            return {Get=function() return val end}
        end

        return S
    end -- end Section

    return T
end -- end AddTab

-- ═══════════════════════════════════════════════════════
--                      TABS
-- ═══════════════════════════════════════════════════════

-- ──────────────────────────
-- TAB 1 : AUTO FARM
-- ──────────────────────────
local T1 = AddTab("⚔","Farm")

local MobNames = {"Auto"}
for k in pairs(MobData) do table.insert(MobNames,k) end
table.sort(MobNames,function(a,b)
    if a=="Auto" then return true end
    if b=="Auto" then return false end
    local da,db = MobData[a],MobData[b]
    return (da and da.L[1] or 0) < (db and db.L[1] or 0)
end)

local FarmSec = T1:Section("Farm Settings")
FarmSec:Dropdown({Title="Select Monster",Options=MobNames,Default="Auto",
    Callback=function(v) State.SelectedMob=v end})
local farmToggle = FarmSec:Toggle({Title="Auto Farm",Default=false,
    Callback=function(v) State.AutoFarm=v
        if v then Notify("⚔ Auto Farm","Farming: "..(State.SelectedMob=="Auto" and (GetAutoMob() or "Auto") or State.SelectedMob),3) end
    end})
FarmSec:Toggle({Title="Auto Quest",Default=false,
    Callback=function(v) State.AutoQuest=v
        if v then
            task.spawn(function()
                while State.AutoQuest do
                    local mob = State.SelectedMob=="Auto" and GetAutoMob() or State.SelectedMob
                    if mob then
                        local d=MobData[mob]
                        if d then TP(d.QCF); task.wait(0.5)
                            SafeCall(function() Remote:InvokeServer("StartQuest",mob) end)
                        end
                    end
                    task.wait(2)
                end
            end)
        end
    end})
FarmSec:Toggle({Title="Auto Mastery",Default=false,Callback=function(v) State.AutoMastery=v end})
FarmSec:Toggle({Title="Auto Skills",Default=false,Callback=function(v) State.AutoSkill=v end})
FarmSec:Slider({Title="Farm Speed",Min=0.01,Max=1,Default=0.05,Int=false,
    Callback=function(v) State.FarmDelay=v end})

local FarmAdv = T1:Section("Advanced")
FarmAdv:Toggle({Title="Kill Aura",Default=false,
    Callback=function(v) State.KillAura=v
        if v then Notify("💀 Kill Aura","Range: "..State.AuraRange,2) end
    end})
FarmAdv:Slider({Title="Aura Range",Min=10,Max=250,Default=40,
    Callback=function(v) State.AuraRange=v end})
FarmAdv:Toggle({Title="Hitbox Expander",Default=false,
    Callback=function(v) State.HitboxExpand=v end})
FarmAdv:Slider({Title="Hitbox Size",Min=5,Max=120,Default=15,
    Callback=function(v) State.HitboxValue=v end})
FarmAdv:Toggle({Title="Instant Kill",Default=false,
    Callback=function(v) State.InstantKill=v
        if v then task.spawn(function()
            while State.InstantKill do
                local mob=GetNearestMob(60)
                if mob then for i=1,10 do SafeCall(function() Remote:InvokeServer("Attack",mob) end) end end
                task.wait(0.1)
            end
        end) end
    end})
FarmAdv:Toggle({Title="Reach Hack",Default=false,
    Callback=function(v) State.ReachHack=v end})
FarmAdv:Toggle({Title="Auto Block",Default=false,
    Callback=function(v) State.AutoBlock=v end})
FarmAdv:Toggle({Title="Auto Parry",Default=false,
    Callback=function(v) State.AutoParry=v end})
FarmAdv:Toggle({Title="Auto Respawn",Default=false,
    Callback=function(v) State.AutoRespawn=v end})
FarmAdv:Toggle({Title="Server Hop (Low HP)",Default=false,
    Callback=function(v) State.ServerHop=v end})
FarmAdv:Slider({Title="Hop HP %",Min=5,Max=50,Default=20,
    Callback=function(v) State.ServerHopHP=v end})

-- ──────────────────────────
-- TAB 2 : AUTO BOSS
-- ──────────────────────────
local T2 = AddTab("👑","Boss")
local BossNames = {}
for k in pairs(BossData) do table.insert(BossNames,k) end
table.sort(BossNames)
local BossSec = T2:Section("Boss Settings")
BossSec:Dropdown({Title="Select Boss",Options=BossNames,Default="Gorilla King",
    Callback=function(v) State.SelectedBoss=v
        Notify("👑 Boss","Selected: "..v.."\nDrop: "..(BossData[v] and BossData[v].Drop or "?"),3)
    end})
BossSec:Toggle({Title="Auto Boss",Default=false,
    Callback=function(v) State.AutoBoss=v
        if v then Notify("👑 Auto Boss","Farming: "..State.SelectedBoss,3) end
    end})
BossSec:Button({Title="Teleport to Boss",
    Callback=function()
        local d=BossData[State.SelectedBoss]
        if d then TP(d.CF); Notify("🚀 TP","→ "..State.SelectedBoss,2) end
    end})

local BossInfoSec = T2:Section("Boss List")
for name,data in pairs(BossData) do
    BossInfoSec:Label(name.." | Drop: "..data.Drop)
end

-- ──────────────────────────
-- TAB 3 : PLAYER
-- ──────────────────────────
local T3 = AddTab("🧍","Player")
local MoveSec = T3:Section("Movement")
MoveSec:Toggle({Title="Infinite Jump",Default=false,Callback=function(v) State.InfJump=v end})
MoveSec:Toggle({Title="No Clip",Default=false,
    Callback=function(v) State.NoClip=v; Notify("👻 NoClip",v and "ON" or "OFF",2) end})
MoveSec:Toggle({Title="Fly Hack",Default=false,
    Callback=function(v)
        State.FlyHack=v
        if v then StartFly(); Notify("✈ Fly","WASD + Space/Ctrl",3) end
    end})
MoveSec:Slider({Title="Fly Speed",Min=10,Max=500,Default=80,
    Callback=function(v) State.FlySpeed=v end})
MoveSec:Toggle({Title="Speed Hack",Default=false,Callback=function(v) State.SpeedHack=v end})
MoveSec:Slider({Title="Walk Speed",Min=16,Max=500,Default=16,
    Callback=function(v)
        State.SpeedValue=v; State.SpeedHack=(v~=16)
        local h=GetHum(); if h then h.WalkSpeed=v end
    end})
MoveSec:Slider({Title="Jump Power",Min=50,Max=1000,Default=50,
    Callback=function(v)
        State.JumpValue=v; local h=GetHum(); if h then h.JumpPower=v end
    end})
MoveSec:Slider({Title="Gravity",Min=0,Max=5,Default=1,Int=false,
    Callback=function(v) State.GravMult=v; Workspace.Gravity=196.2*v end})

local ProtectSec = T3:Section("Protection")
ProtectSec:Toggle({Title="Infinite Stamina",Default=false,Callback=function(v) State.InfStamina=v end})
ProtectSec:Toggle({Title="Anti AFK",Default=true,Callback=function(v) State.AntiAFK=v end})
ProtectSec:Toggle({Title="Anti Blind",Default=false,Callback=function(v) State.AntiBlind=v end})
ProtectSec:Toggle({Title="Anti Freeze",Default=false,Callback=function(v) State.AntiFreeze=v end})
ProtectSec:Button({Title="Show Stats",Callback=function()
    Notify("📊 Stats","Level: "..GetLevel().."\nBeli: "..GetBeli().."\nFragments: "..GetFragments().."\nWorld: "..WorldName,5)
end})
ProtectSec:Button({Title="Show Session",Callback=function()
    local t=os.time()-State.SessionStart
    Notify("⏱ Session",string.format("Time: %dm %ds\nKills: %d\nQuests: %d",math.floor(t/60),t%60,State.KillCount,State.QuestCount),4)
end})

-- ──────────────────────────
-- TAB 4 : TELEPORT
-- ──────────────────────────
local T4 = AddTab("🗺","Teleport")
local IslandNames = {}
for k in pairs(IslandData) do table.insert(IslandNames,k) end
table.sort(IslandNames)
local IslandSec = T4:Section("Islands")
IslandSec:Dropdown({Title="Island",Options=IslandNames,Default="Starter Island",
    Callback=function(v)
        local cf=IslandData[v]
        if cf then TP(cf); Notify("🗺 TP","→ "..v,2) end
    end})
IslandSec:Button({Title="Teleport to Spawn",Callback=function()
    local sp=Workspace:FindFirstChild("SpawnLocation")
    TP(sp and sp.CFrame+Vector3.new(0,5,0) or CFrame.new(0,5,0))
    Notify("🏠 Spawn","Teleported to spawn!",2)
end})

local BossTpSec = T4:Section("Boss Teleport")
for name,data in pairs(BossData) do
    BossTpSec:Button({Title="→ "..name,Callback=function()
        TP(data.CF); Notify("👑 TP","→ "..name,2)
    end})
end

local PlayerTpSec = T4:Section("Player Teleport")
PlayerTpSec:Button({Title="TP to Nearest Player",Callback=function()
    local root=GetRoot(); if not root then return end
    local best,bestD=nil,math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character and plr.Character.PrimaryPart then
            local d=Dist(root.Position,plr.Character.PrimaryPart.Position)
            if d<bestD then best=plr; bestD=d end
        end
    end
    if best then
        TP(best.Character.PrimaryPart.CFrame*CFrame.new(0,0,5))
        Notify("🚀 TP","→ "..best.Name,2)
    end
end})

-- ──────────────────────────
-- TAB 5 : MATERIALS
-- ──────────────────────────
local T5 = AddTab("⚗","Materials")
local MatNames = {"None"}
for k in pairs(MatData) do table.insert(MatNames,k) end
table.sort(MatNames)
local MatSec = T5:Section("Material Farm")
MatSec:Dropdown({Title="Material",Options=MatNames,Default="None",
    Callback=function(v) State.SelectedMat=v
        if v~="None" then
            Notify("⚗ Material","Farming: "..v.."\nFrom: "..(MatData[v] and MatData[v].Mob or "?"),3)
        end
    end})
MatSec:Toggle({Title="Auto Farm Material",Default=false,
    Callback=function(v) State.AutoMaterial=v end})
MatSec:Button({Title="TP to Material Mob",Callback=function()
    if State.SelectedMat=="None" then Notify("⚠","Select material first!",2) return end
    local m=MatData[State.SelectedMat]
    if m then TP(m.CF); Notify("🚀 TP","→ "..m.Mob,2) end
end})

local MatInfoSec = T5:Section("Material Sources")
for mat,data in pairs(MatData) do
    MatInfoSec:Label(mat.." → "..data.Mob)
end

-- ──────────────────────────
-- TAB 6 : HAKI
-- ──────────────────────────
local T6 = AddTab("💎","Haki")
local HakiSec = T6:Section("Haki Training")
HakiSec:Toggle({Title="Auto Haki",Default=false,Callback=function(v) State.AutoHaki=v end})
HakiSec:Toggle({Title="Auto Ken Haki (Observation)",Default=false,Callback=function(v) State.AutoKenHaki=v end})
HakiSec:Toggle({Title="Auto Armor Haki (Buso)",Default=false,Callback=function(v) State.AutoArmorHaki=v end})
HakiSec:Button({Title="Activate All Haki",Callback=function()
    SafeCall(function() Remote:InvokeServer("Haki") end)
    SafeCall(function() Remote:InvokeServer("ActivateObservation") end)
    SafeCall(function() Remote:InvokeServer("ActivateBuso") end)
    Notify("💎 Haki","All haki activated!",2)
end})

local StatSec = T6:Section("Stats")
local statTypes = {"Melee","Defense","Sword","Gun","Blox Fruit"}
StatSec:Dropdown({Title="Stat Type",Options=statTypes,Default="Blox Fruit",
    Callback=function(v) State.StatType=v end})
StatSec:Toggle({Title="Auto Distribute Stats",Default=false,Callback=function(v) State.AutoStats=v end})
StatSec:Button({Title="Distribute All Now",Callback=function()
    local pts=LP.Data and LP.Data.StatPoint and LP.Data.StatPoint.Value or 0
    if pts>0 then
        SafeCall(function() Remote:InvokeServer("IncreaseStats",State.StatType,pts) end)
        Notify("📊 Stats","Distributed "..pts.." → "..State.StatType,3)
    else Notify("📊 Stats","No stat points!",2) end
end})
StatSec:Button({Title="Reset Stats",Callback=function()
    SafeCall(function() Remote:InvokeServer("ResetStats") end)
    Notify("🔄 Stats","Stats reset!",2)
end})

-- ──────────────────────────
-- TAB 7 : ESP
-- ──────────────────────────
local T7 = AddTab("👁","ESP")
local ESPSec = T7:Section("ESP Settings")
ESPSec:Toggle({Title="Master ESP",Default=false,
    Callback=function(v)
        State.ESP=v
        if not v then ClearESP() end
    end})
ESPSec:Toggle({Title="Mob ESP",Default=false,
    Callback=function(v) State.MobESP=v; if v then State.ESP=true end end})
ESPSec:Toggle({Title="Player ESP",Default=false,
    Callback=function(v) State.PlayerESP=v; if v then State.ESP=true end end})
ESPSec:Toggle({Title="Chest ESP",Default=false,
    Callback=function(v) State.ChestESP=v; if v then State.ESP=true end end})
ESPSec:Toggle({Title="Fruit ESP",Default=false,
    Callback=function(v) State.FruitESP=v; if v then State.ESP=true end end})
ESPSec:Button({Title="Clear ESP",Callback=function() ClearESP(); Notify("🗑 ESP","Cleared!",2) end})

local AimSec = T7:Section("Aim Assist")
AimSec:Toggle({Title="Silent Aim",Default=false,
    Callback=function(v) State.SilentAim=v; Notify("🎯 Silent Aim",v and "ON" or "OFF",2) end})
AimSec:Toggle({Title="FOV Circle",Default=false,Callback=function(v) State.FovCircle=v end})
AimSec:Slider({Title="FOV Size",Min=20,Max=400,Default=60,
    Callback=function(v) State.FovValue=v end})

-- ──────────────────────────
-- TAB 8 : VISUAL
-- ──────────────────────────
local T8 = AddTab("🎨","Visual")
local VisSec = T8:Section("Visuals")
VisSec:Toggle({Title="Fullbright",Default=false,
    Callback=function(v)
        State.Fullbright=v
        if v then
            Lighting.Brightness=2; Lighting.ClockTime=14
            Lighting.FogEnd=1e6; Lighting.GlobalShadows=false
        else
            Lighting.Brightness=1; Lighting.ClockTime=14.5
            Lighting.FogEnd=100000; Lighting.GlobalShadows=true
        end
    end})
VisSec:Button({Title="FPS Boost",Callback=function()
    settings().Rendering.QualityLevel="Level01"
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime=NumberRange.new(0)
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then v.Enabled=false
        elseif v:IsA("BasePart") then v.Material=Enum.Material.Plastic; v.Reflectance=0 end
    end
    Notify("⚡ FPS","Boost applied!",3)
end})
VisSec:Button({Title="Add Purple Trail",Callback=function()
    local root=GetRoot(); if not root then return end
    local a0=Instance.new("Attachment",root); a0.Position=Vector3.new(0,-2,0)
    local a1=Instance.new("Attachment",root); a1.Position=Vector3.new(0,-3,0)
    local tr=Instance.new("Trail",root)
    tr.Color=ColorSequence.new(C.Purple2,C.Purple)
    tr.LightEmission=0.6; tr.Lifetime=0.5
    tr.Transparency=NumberSequence.new(0,1)
    tr.Attachment0=a0; tr.Attachment1=a1
    Notify("✨ Trail","Purple trail added!",2)
end})
VisSec:Button({Title="Add Glow",Callback=function()
    local char=GetChar(); if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local l=Instance.new("PointLight",p)
            l.Color=C.Purple; l.Range=15; l.Brightness=2
        end
    end
    Notify("🌟 Glow","Purple glow added!",2)
end})
VisSec:Button({Title="Remove Effects",Callback=function()
    local char=GetChar(); if not char then return end
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("PointLight") or v:IsA("Trail") or (v:IsA("Attachment") and v.Parent:IsA("BasePart")) then
            v:Destroy()
        end
    end
    Notify("🗑 Effects","Removed!",2)
end})

local CamSec = T8:Section("Camera")
CamSec:Slider({Title="Field of View",Min=50,Max=120,Default=70,
    Callback=function(v) Cam.FieldOfView=v end})
CamSec:Button({Title="Reset FOV",Callback=function()
    Cam.FieldOfView=70; Notify("📷 FOV","Reset to 70",2)
end})

-- ──────────────────────────
-- TAB 9 : PVP
-- ──────────────────────────
local T9 = AddTab("🗡","PvP")
local PvpSec = T9:Section("PvP Tools")
PvpSec:Toggle({Title="Kill Aura",Default=false,
    Callback=function(v) State.KillAura=v end})
PvpSec:Toggle({Title="Hitbox Expander",Default=false,
    Callback=function(v) State.HitboxExpand=v end})
PvpSec:Toggle({Title="Silent Aim",Default=false,
    Callback=function(v) State.SilentAim=v end})
PvpSec:Toggle({Title="FOV Circle",Default=false,
    Callback=function(v) State.FovCircle=v end})
PvpSec:Slider({Title="Aura Range",Min=10,Max=200,Default=40,
    Callback=function(v) State.AuraRange=v end})
PvpSec:Slider({Title="Hitbox Size",Min=5,Max=100,Default=15,
    Callback=function(v) State.HitboxValue=v end})
PvpSec:Button({Title="TP Behind Nearest Player",Callback=function()
    local root=GetRoot(); if not root then return end
    local best,bestD=nil,math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character and plr.Character.PrimaryPart then
            local d=Dist(root.Position,plr.Character.PrimaryPart.Position)
            if d<bestD then best=plr; bestD=d end
        end
    end
    if best then
        TP(best.Character.PrimaryPart.CFrame*CFrame.new(0,0,-3))
        Notify("🗡 PvP","Behind "..best.Name,2)
    end
end})
PvpSec:Button({Title="Reach Hack ON",Callback=function()
    State.ReachHack=true
    task.spawn(function()
        while State.ReachHack do
            local mob=GetNearestMob(State.AuraRange*2)
            if mob then SafeCall(function() Remote:InvokeServer("Attack",mob,50) end) end
            task.wait(0.1)
        end
    end)
    Notify("↔ Reach","Reach hack ON!",2)
end})
PvpSec:Button({Title="Reach Hack OFF",Callback=function()
    State.ReachHack=false; Notify("↔ Reach","Reach hack OFF!",2)
end})

-- ──────────────────────────
-- TAB 10 : MISC
-- ──────────────────────────
local T10 = AddTab("🔧","Misc")
local CodeSec = T10:Section("Codes")
CodeSec:Button({Title="Redeem All Codes ("..#Codes..")",Callback=function()
    Notify("🎁 Codes","Redeeming "..#Codes.." codes...",3)
    task.spawn(function()
        local ok=0
        for _,code in ipairs(Codes) do
            SafeCall(function()
                local r=ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Redeem"):InvokeServer(code)
                if r then ok=ok+1 end
            end)
            task.wait(0.1)
        end
        Notify("✅ Codes","Done! "..ok.." codes redeemed!",4)
    end)
end})

local ServerSec = T10:Section("Server")
ServerSec:Button({Title="Server Hop",Callback=function()
    Notify("🔀 Hop","Searching server...",2)
    task.spawn(function()
        SafeCall(function()
            local d=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
            for _,s in pairs(d.data) do
                if s.id~=game.JobId and s.playing<s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(PlaceId,s.id,LP) return
                end
            end
            Notify("⚠ Hop","No servers found!",3)
        end)
    end)
end})
ServerSec:Button({Title="Rejoin",Callback=function()
    TeleportService:Teleport(PlaceId,LP)
end})
ServerSec:Button({Title="Copy Job ID",Callback=function()
    SafeCall(function() setclipboard(game.JobId) end)
    Notify("📋 Copied","Job ID: "..game.JobId:sub(1,12).."...",2)
end})
ServerSec:Label("Server: "..tostring(game.JobId):sub(1,18).."...")
ServerSec:Label("Players: "..#Players:GetPlayers().."/"..game.MaxPlayers)

local AutoSec = T10:Section("Full Automation")
AutoSec:Button({Title="▶ Start All",Callback=function()
    State.AutoFarm=true; State.AutoQuest=true; State.AutoStats=true
    State.AutoHaki=true; State.AutoMastery=true; State.AntiAFK=true
    State.AutoRespawn=true
    Notify("🤖 Automation","All systems started!",4)
end})
AutoSec:Button({Title="■ Stop All",Callback=function()
    State.AutoFarm=false; State.AutoQuest=false; State.AutoBoss=false
    State.AutoStats=false; State.AutoHaki=false; State.AutoMastery=false
    State.AutoMaterial=false; State.AutoSkill=false; State.KillAura=false
    State.HitboxExpand=false; State.ServerHop=false
    Notify("🛑 Stopped","All automation stopped!",3)
end})

-- ──────────────────────────
-- TAB 11 : SETTINGS
-- ──────────────────────────
local T11 = AddTab("⚙","Settings")
local HotkeysSec = T11:Section("Hotkeys")
HotkeysSec:Label("INSERT → Toggle GUI")
HotkeysSec:Label("F1 → Auto Farm ON/OFF")
HotkeysSec:Label("F2 → Auto Boss ON/OFF")
HotkeysSec:Label("F3 → ESP ON/OFF")
HotkeysSec:Label("F4 → Fly ON/OFF")
HotkeysSec:Label("[ ] → Speed ± 10")

local AboutSec = T11:Section("About")
AboutSec:Label("Blox Script v5.0 | Custom GUI")
AboutSec:Label("No external libraries")
AboutSec:Label("World: "..WorldName)
AboutSec:Label("PlaceID: "..tostring(PlaceId))
AboutSec:Label("Mobs: "..#MobNames.." | Bosses: "..#BossNames)
AboutSec:Label("Islands: "..#IslandNames.." | Codes: "..#Codes)
AboutSec:Button({Title="Discord",Callback=function()
    SafeCall(function() setclipboard("discord.gg/bloxscript") end)
    Notify("💬 Discord","discord.gg/bloxscript copied!",3)
end})

-- ═══════════════════════════════════════════
--       KEYBINDS
-- ═══════════════════════════════════════════
UserInputService.InputBegan:Connect(function(inp, proc)
    if proc then return end
    if inp.KeyCode==Enum.KeyCode.Insert then
        SG.Enabled = not SG.Enabled
    elseif inp.KeyCode==Enum.KeyCode.F1 then
        State.AutoFarm = not State.AutoFarm
        Notify("⌨ F1","Auto Farm: "..(State.AutoFarm and "ON" or "OFF"),2)
    elseif inp.KeyCode==Enum.KeyCode.F2 then
        State.AutoBoss = not State.AutoBoss
        Notify("⌨ F2","Auto Boss: "..(State.AutoBoss and "ON" or "OFF"),2)
    elseif inp.KeyCode==Enum.KeyCode.F3 then
        State.ESP = not State.ESP; State.MobESP=State.ESP
        if not State.ESP then ClearESP() end
        Notify("⌨ F3","ESP: "..(State.ESP and "ON" or "OFF"),2)
    elseif inp.KeyCode==Enum.KeyCode.F4 then
        State.FlyHack = not State.FlyHack
        if State.FlyHack then StartFly() end
        Notify("⌨ F4","Fly: "..(State.FlyHack and "ON" or "OFF"),2)
    elseif inp.KeyCode==Enum.KeyCode.RightBracket then
        State.SpeedValue=math.min(State.SpeedValue+10,500); State.SpeedHack=true
        local h=GetHum(); if h then h.WalkSpeed=State.SpeedValue end
    elseif inp.KeyCode==Enum.KeyCode.LeftBracket then
        State.SpeedValue=math.max(State.SpeedValue-10,16)
        State.SpeedHack=State.SpeedValue~=16
        local h=GetHum(); if h then h.WalkSpeed=State.SpeedValue end
    end
end)

-- ═══════════════════════════════════════════
--         STARTUP
-- ═══════════════════════════════════════════
task.spawn(function()
    task.wait(1)
    Notify("✅ Loaded","Blox Script v5.0\nWorld: "..WorldName.."\nLevel: "..GetLevel().."\nPress F1 to farm!",5)
end)

print("╔══════════════════════════════╗")
print("║  Blox Script v5.0  Loaded   ║")
print("║  World: "..WorldName.."          ║")
print("║  INSERT to toggle GUI        ║")
print("╚══════════════════════════════╝")
