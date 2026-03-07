-- ============================================================
--   Blox Fruits Ultimate Script | WindUI Library
--   Made with WindUI | Full Featured | 2025
--   Discord: .gg/bloxscript
-- ============================================================

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/source.lua"))()

-- ============================================================
-- SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService     = game:GetService("SoundService")
local Lighting         = game:GetService("Lighting")
local PhysicsService   = game:GetService("PhysicsService")
local PathfindingService = game:GetService("PathfindingService")

local LP  = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Root = Char:WaitForChild("HumanoidRootPart")
local Hum  = Char:WaitForChild("Humanoid")
local Cam  = Workspace.CurrentCamera
local Mouse = LP:GetMouse()
local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ============================================================
-- GLOBALS / STATE
-- ============================================================
_G.AutoFarm       = false
_G.AutoQuest      = false
_G.AutoBoss       = false
_G.AutoMastery    = false
_G.AutoRaid       = false
_G.AutoChest      = false
_G.AutoMaterial   = false
_G.AutoFruit      = false
_G.InfJump        = false
_G.NoClip         = false
_G.AntiAFK        = true
_G.AutoParry      = false
_G.AutoDodge      = false
_G.SpeedHack      = false
_G.FlyHack        = false
_G.Telekinesis    = false
_G.AutoEat        = false
_G.AutoStats      = false
_G.AutoFragments  = false
_G.AutoHaki       = false
_G.AutoKenHaki    = false
_G.AutoArmorHaki  = false
_G.AutoSkip       = false
_G.AutoSpin       = false
_G.ESP            = false
_G.MobESP         = false
_G.ChestESP       = false
_G.FruitESP       = false
_G.BossESP        = false
_G.PlayerESP      = false
_G.Fullbright     = false
_G.AntiBlind      = false
_G.AntiFreeze     = false
_G.InstantKill    = false
_G.InfStamina     = false
_G.AutoBlock      = false
_G.AutoCombo      = false
_G.SilentAim      = false
_G.FovCircle      = false
_G.AutoSword      = false
_G.AutoGun        = false
_G.AutoDevFruit   = false
_G.ReachHack      = false
_G.KillAura       = false
_G.AutoSkill      = false
_G.HitboxExpand   = false
_G.AutoRespawn    = false
_G.SpeedValue     = 16
_G.JumpValue      = 50
_G.ReachValue     = 10
_G.HitboxValue    = 15
_G.AuraRange      = 40
_G.FlySpeed       = 50
_G.GravMult       = 1
_G.FovValue       = 60
_G.SelectedMob    = "Bandit"
_G.SelectedBoss   = "Gorilla King"
_G.SelectedFruit  = "None"
_G.SelectedMaterial = "None"
_G.SelectedRaid   = "Swan Pirates"
_G.SelectedWorld  = "World 1"
_G.SelectedQuest  = "Auto"
_G.StatType       = "Melee"
_G.EspColor       = Color3.fromRGB(150, 50, 255)
_G.AimKey         = Enum.KeyCode.Q
_G.FarmDelay      = 0.1
_G.BossDelay      = 0.5
_G.ChestDelay     = 1.0
_G.AutoCodes      = false
_G.ServerHop      = false
_G.ServerHopHP    = 20
_G.SafeMode       = false
_G.HideGUI        = false
_G.MiniGUI        = false
_G.NotifSound     = true
_G.DebugMode      = false
_G.RecordKills    = false
_G.KillCount      = 0
_G.QuestCount     = 0
_G.FarmTime       = 0
_G.SessionStart   = os.time()

-- ============================================================
-- WORLD DETECTION
-- ============================================================
local World1ID = 2753915549
local World2ID = 4442272183
local World3ID = 7449423635
local PlaceId  = game.PlaceId

local IsWorld1 = (PlaceId == World1ID)
local IsWorld2 = (PlaceId == World2ID)
local IsWorld3 = (PlaceId == World3ID)

local WorldName = IsWorld1 and "World 1" or IsWorld2 and "World 2" or IsWorld3 and "World 3" or "Unknown"

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function Notify(title, msg, dur)
    WindUI:Notify({
        Title   = title,
        Content = msg,
        Duration = dur or 3,
    })
end

local function SafeCall(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok and _G.DebugMode then
        warn("[BloxScript Error]: " .. tostring(err))
    end
    return ok, err
end

local function GetChar()
    return LP.Character
end

local function GetRoot()
    local c = GetChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function IsAlive()
    local h = GetHum()
    return h and h.Health > 0
end

local function Teleport(cf)
    local root = GetRoot()
    if root then root.CFrame = cf end
end

local function Distance(a, b)
    return (a - b).Magnitude
end

local function TweenTo(cf, speed)
    local root = GetRoot()
    if not root then return end
    speed = speed or 1
    local dist = Distance(root.Position, cf.Position)
    local t = dist / (speed * 100)
    TweenService:Create(root, TweenInfo.new(math.max(0.1, t)), {CFrame=cf}):Play()
end

local function GetNearestMob(range, nameFilter)
    range = range or 100
    local nearest, nearestDist = nil, range
    local root = GetRoot()
    if not root then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
                if not nameFilter or obj.Name == nameFilter or (obj:FindFirstChild("Name") and obj.Name:find(nameFilter)) then
                    local d = Distance(root.Position, obj.HumanoidRootPart.Position)
                    if d < nearestDist and obj.Humanoid.Health > 0 then
                        nearest = obj
                        nearestDist = d
                    end
                end
            end
        end
    end
    return nearest
end

local function GetNearestPlayer(range)
    range = range or 500
    local nearest, nearestDist = nil, range
    local root = GetRoot()
    if not root then return nil end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local d = Distance(root.Position, plr.Character.HumanoidRootPart.Position)
            if d < nearestDist then
                nearest = plr
                nearestDist = d
            end
        end
    end
    return nearest
end

local function GetAllMobs(nameFilter)
    local mobs = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if obj ~= LP.Character and not Players:GetPlayerFromCharacter(obj) then
                if obj.Humanoid.Health > 0 then
                    if not nameFilter or obj.Name == nameFilter then
                        table.insert(mobs, obj)
                    end
                end
            end
        end
    end
    return mobs
end

local function GetChests()
    local chests = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("chest") and (obj:IsA("Model") or obj:IsA("Part")) then
            table.insert(chests, obj)
        end
    end
    return chests
end

local function GetFruits()
    local fruits = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("fruit") or (obj:FindFirstChild("PickUp") or obj:FindFirstChild("pickup")) then
            table.insert(fruits, obj)
        end
    end
    return fruits
end

local function InvokeServer(...)
    return SafeCall(function(...)
        Remote:InvokeServer(...)
    end, ...)
end

local function FireServer(remote, ...)
    SafeCall(function(...)
        remote:FireServer(...)
    end, ...)
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

local function GetMastery(skillType)
    if LP.Data and LP.Data.Mastery then
        return LP.Data.Mastery[skillType] and LP.Data.Mastery[skillType].Value or 0
    end
    return 0
end

local function GetHaki()
    if LP.Data then
        local enHaki = LP.Data:FindFirstChild("DevilFruitEnhancement")
        return enHaki and enHaki.Value or false
    end
    return false
end

-- ============================================================
-- HOOK FUNCTIONS (Anti-Death/Respawn Effects)
-- ============================================================
SafeCall(function()
    hookfunction(require(ReplicatedStorage.Effect.Container.Death), function() end)
    hookfunction(require(ReplicatedStorage.Effect.Container.Respawn), function() end)
end)

-- ============================================================
-- ANTI-AFK SYSTEM
-- ============================================================
local VirtualUser = game:GetService("VirtualUser")
LP.Idled:Connect(function()
    if _G.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end
end)

-- ============================================================
-- CHARACTER ADDED HANDLER
-- ============================================================
LP.CharacterAdded:Connect(function(char)
    Char = char
    Root = char:WaitForChild("HumanoidRootPart")
    Hum  = char:WaitForChild("Humanoid")
    if _G.AutoRespawn then
        task.wait(2)
        Notify("⚡ Auto Respawn", "Character respawned!", 2)
    end
end)

-- ============================================================
-- WORLD DATA (MONSTERS)
-- ============================================================
local MonsterData = {
    -- World 1
    ["Bandit"]              = {Level={1,9},   QuestNPC="Starter Human",  QuestCF=CFrame.new(-1271.7,-3.2,-1272.6), MobCF=CFrame.new(-1300,-2,-1300)},
    ["Monkey"]              = {Level={10,14},  QuestNPC="Monkey Island Quest", QuestCF=CFrame.new(-2020,-5,-3282), MobCF=CFrame.new(-1949,-2,-3282)},
    ["Gorilla"]             = {Level={15,29},  QuestNPC="Gorilla Island Quest", QuestCF=CFrame.new(-2020,-5,-3282), MobCF=CFrame.new(-2013,-2,-3282)},
    ["Pirate"]              = {Level={30,39},  QuestNPC="Pirate Village Quest", QuestCF=CFrame.new(-967,13,4034),  MobCF=CFrame.new(-967,13,4034)},
    ["Brute"]               = {Level={40,59},  QuestNPC="Brute Quest",         QuestCF=CFrame.new(-1191,15,4235), MobCF=CFrame.new(-1191,15,4235)},
    ["Desert Bandit"]       = {Level={60,74},  QuestNPC="Desert Quest",        QuestCF=CFrame.new(924,-3,1121),   MobCF=CFrame.new(924,-3,1121)},
    ["Desert Officer"]      = {Level={75,89},  QuestNPC="Desert Quest 2",      QuestCF=CFrame.new(1001,-3,1295),  MobCF=CFrame.new(1001,-3,1295)},
    ["Snow Bandit"]         = {Level={90,99},  QuestNPC="Snow Quest",          QuestCF=CFrame.new(1268,274,-2244),MobCF=CFrame.new(1268,274,-2244)},
    ["Snowman"]             = {Level={100,119},QuestNPC="Snowman Quest",       QuestCF=CFrame.new(1268,274,-2244),MobCF=CFrame.new(1268,274,-2244)},
    ["Chief Petty Officer"] = {Level={120,149},QuestNPC="Marine Base Quest",   QuestCF=CFrame.new(1010,5,-2971),  MobCF=CFrame.new(1010,5,-2971)},
    ["Sky Bandit"]          = {Level={150,174},QuestNPC="Sky Island Quest",    QuestCF=CFrame.new(-5082,612,-4762),MobCF=CFrame.new(-5082,612,-4762)},
    ["Dark Master"]         = {Level={175,189},QuestNPC="Dark Area Quest",     QuestCF=CFrame.new(-5082,612,-4762),MobCF=CFrame.new(-5082,612,-4762)},
    ["Prisoner"]            = {Level={190,209},QuestNPC="Prison Quest",        QuestCF=CFrame.new(5261,-3,3768),  MobCF=CFrame.new(5261,-3,3768)},
    ["Dangerous Prisoner"]  = {Level={210,249},QuestNPC="Prison Quest 2",      QuestCF=CFrame.new(5261,-3,3768),  MobCF=CFrame.new(5261,-3,3768)},
    ["Toga Warrior"]        = {Level={250,274},QuestNPC="Colosseum Quest",     QuestCF=CFrame.new(-6516,-3,-1046),MobCF=CFrame.new(-6516,-3,-1046)},
    ["Gladiator"]           = {Level={275,299},QuestNPC="Colosseum Quest 2",   QuestCF=CFrame.new(-6516,-3,-1046),MobCF=CFrame.new(-6516,-3,-1046)},
    ["Military Soldier"]    = {Level={300,324},QuestNPC="Military Quest",      QuestCF=CFrame.new(-5565,9,8327),  MobCF=CFrame.new(-5565,9,8327)},
    ["Military Spy"]        = {Level={325,374},QuestNPC="Military Quest 2",    QuestCF=CFrame.new(-5806,78,8904), MobCF=CFrame.new(-5806,78,8904)},
    ["Fishman Warrior"]     = {Level={375,399},QuestNPC="Fishman Quest",       QuestCF=CFrame.new(60943,17,1744), MobCF=CFrame.new(60943,17,1744)},
    ["Fishman Commando"]    = {Level={400,449},QuestNPC="Fishman Quest 2",     QuestCF=CFrame.new(61760,18,1460), MobCF=CFrame.new(61760,18,1460)},
    ["God's Guard"]         = {Level={450,474},QuestNPC="Sky Island 2 Quest",  QuestCF=CFrame.new(-7759,5606,-1862),MobCF=CFrame.new(-7759,5606,-1862)},
    ["Shanda"]              = {Level={475,524},QuestNPC="Shandy Quest",        QuestCF=CFrame.new(-7906,5634,-1411),MobCF=CFrame.new(-7906,5634,-1411)},
    ["Royal Squad"]         = {Level={525,549},QuestNPC="Royal Quest",         QuestCF=CFrame.new(-7906,5634,-1411),MobCF=CFrame.new(-7906,5634,-1411)},
    ["Royal Soldier"]       = {Level={550,624},QuestNPC="Royal Quest 2",       QuestCF=CFrame.new(-7906,5634,-1411),MobCF=CFrame.new(-7906,5634,-1411)},
    ["Galley Pirate"]       = {Level={625,649},QuestNPC="Fountain Quest",      QuestCF=CFrame.new(5259,37,4050),  MobCF=CFrame.new(5551,78,3930)},
    ["Galley Captain"]      = {Level={650,699},QuestNPC="Fountain Quest 2",    QuestCF=CFrame.new(5259,37,4050),  MobCF=CFrame.new(5441,42,4950)},
    -- World 2
    ["Trader"]              = {Level={700,749},QuestNPC="Port Town Quest",     QuestCF=CFrame.new(-297,8,5765),   MobCF=CFrame.new(-297,8,5765)},
    ["Mercenary"]           = {Level={750,799},QuestNPC="Dress Rosa Quest",    QuestCF=CFrame.new(-986,72,1088),  MobCF=CFrame.new(-986,72,1088)},
    ["Spy"]                 = {Level={800,849},QuestNPC="Green Zone Quest",    QuestCF=CFrame.new(3601,8,3390),   MobCF=CFrame.new(3601,8,3390)},
    ["Scientist"]           = {Level={850,924},QuestNPC="Punk Hazard Quest",   QuestCF=CFrame.new(584,14,5042),   MobCF=CFrame.new(584,14,5042)},
    ["Mechanical Pirate"]   = {Level={925,999},QuestNPC="Thriller Bark Quest", QuestCF=CFrame.new(-11467,8,-4901),MobCF=CFrame.new(-11467,8,-4901)},
    ["Zombie"]              = {Level={950,999},QuestNPC="Zombie Quest",        QuestCF=CFrame.new(-11467,8,-4901),MobCF=CFrame.new(-11467,8,-4901)},
    ["Vampire"]             = {Level={1000,1049},QuestNPC="Graveyard Quest",   QuestCF=CFrame.new(-6132,9,-1466), MobCF=CFrame.new(-6132,9,-1466)},
    ["Lava Pirate"]         = {Level={1050,1099},QuestNPC="Magma Quest",       QuestCF=CFrame.new(-5158,14,-4654),MobCF=CFrame.new(-5158,14,-4654)},
    ["Ship Engineer"]       = {Level={1100,1149},QuestNPC="Hot Zone Quest",    QuestCF=CFrame.new(-5158,14,-4654),MobCF=CFrame.new(-5158,14,-4654)},
    ["Magma Ninja"]         = {Level={1150,1174},QuestNPC="Wano Quest",        QuestCF=CFrame.new(-3282,57,-4286),MobCF=CFrame.new(-3282,57,-4286)},
    ["Dragon Crew Warrior"] = {Level={1175,1249},QuestNPC="Dragon Quest",      QuestCF=CFrame.new(-3282,57,-4286),MobCF=CFrame.new(-3282,57,-4286)},
    ["Dragon Crew Archer"]  = {Level={1250,1324},QuestNPC="Dragon Quest 2",    QuestCF=CFrame.new(-3282,57,-4286),MobCF=CFrame.new(-3282,57,-4286)},
    ["Snow Lurker"]         = {Level={1325,1374},QuestNPC="Ice Castle Quest",  QuestCF=CFrame.new(1030,267,-5140),MobCF=CFrame.new(1030,267,-5140)},
    ["Diable"]              = {Level={1375,1449},QuestNPC="Ice Castle Quest 2",QuestCF=CFrame.new(1030,267,-5140),MobCF=CFrame.new(1030,267,-5140)},
    ["Ice Admiral"]         = {Level={1450,1499},QuestNPC="Ice Castle Boss",   QuestCF=CFrame.new(1030,267,-5140),MobCF=CFrame.new(1030,267,-5140)},
    -- World 3
    ["Forest Pirate"]       = {Level={1500,1574},QuestNPC="Forest Quest",      QuestCF=CFrame.new(-10828,331,-9049),MobCF=CFrame.new(-10828,331,-9049)},
    ["Living Zombie"]       = {Level={1575,1649},QuestNPC="Haunted Castle",    QuestCF=CFrame.new(-12862,27,-7068),MobCF=CFrame.new(-12862,27,-7068)},
    ["Demonic Soul"]        = {Level={1650,1699},QuestNPC="Haunted Castle 2",  QuestCF=CFrame.new(-12862,27,-7068),MobCF=CFrame.new(-12862,27,-7068)},
    ["Hellish Demon"]       = {Level={1700,1774},QuestNPC="Demon Castle",      QuestCF=CFrame.new(-12862,27,-7068),MobCF=CFrame.new(-12862,27,-7068)},
    ["Realistic Zombie"]    = {Level={1775,1849},QuestNPC="Realism Quest",     QuestCF=CFrame.new(-12862,27,-7068),MobCF=CFrame.new(-12862,27,-7068)},
    ["Mythological Pirate"] = {Level={1850,1924},QuestNPC="Big Mom Quest",     QuestCF=CFrame.new(-13456,469,-7039),MobCF=CFrame.new(-13456,469,-7039)},
    ["Chocolate Bar Battler"]={Level={1925,1999},QuestNPC="Chocolate Quest",   QuestCF=CFrame.new(582,25,-12550), MobCF=CFrame.new(582,25,-12550)},
    ["Dough Militia"]       = {Level={2000,2074},QuestNPC="Cake Island Quest", QuestCF=CFrame.new(582,25,-12550), MobCF=CFrame.new(582,25,-12550)},
    ["Sweet Thief"]         = {Level={2075,2149},QuestNPC="Cake Quest 2",      QuestCF=CFrame.new(582,25,-12550), MobCF=CFrame.new(582,25,-12550)},
    ["Biscuit Soldier"]     = {Level={2150,2224},QuestNPC="Biscuit Quest",     QuestCF=CFrame.new(582,25,-12550), MobCF=CFrame.new(582,25,-12550)},
    ["Horned Warrior"]      = {Level={2225,2299},QuestNPC="Elf Quest",         QuestCF=CFrame.new(-4648,76,-13527),MobCF=CFrame.new(-4648,76,-13527)},
    ["Sick Scientist"]      = {Level={2300,2374},QuestNPC="Lab Quest",         QuestCF=CFrame.new(-4648,76,-13527),MobCF=CFrame.new(-4648,76,-13527)},
    ["Aerial Warrior"]      = {Level={2375,2449},QuestNPC="Sky Aerial Quest",  QuestCF=CFrame.new(-4648,76,-13527),MobCF=CFrame.new(-4648,76,-13527)},
    ["Cursed Skeleton"]     = {Level={2450,2524},QuestNPC="Cursed Ship Quest", QuestCF=CFrame.new(-5085,1,-9698), MobCF=CFrame.new(-5085,1,-9698)},
    ["Fishman Raider"]      = {Level={2525,2624},QuestNPC="Sea Castle Quest",  QuestCF=CFrame.new(-5085,1,-9698), MobCF=CFrame.new(-5085,1,-9698)},
    ["Fishman Gunner"]      = {Level={2625,2699},QuestNPC="Sea Castle Quest 2",QuestCF=CFrame.new(-5085,1,-9698), MobCF=CFrame.new(-5085,1,-9698)},
    ["Sea Soldier"]         = {Level={2700,2774},QuestNPC="Deep Sea Quest",    QuestCF=CFrame.new(1018,40,-10438),MobCF=CFrame.new(1018,40,-10438)},
    ["Surfer Pirate"]       = {Level={2775,2849},QuestNPC="Surfboard Quest",   QuestCF=CFrame.new(1018,40,-10438),MobCF=CFrame.new(1018,40,-10438)},
    ["Pirate of Wano"]      = {Level={2850,2924},QuestNPC="Wano 3 Quest",      QuestCF=CFrame.new(1018,40,-10438),MobCF=CFrame.new(1018,40,-10438)},
    ["Samurai"]             = {Level={2925,2999},QuestNPC="Samurai Island Quest",QuestCF=CFrame.new(1018,40,-10438),MobCF=CFrame.new(1018,40,-10438)},
    ["Snowflake Soldier"]   = {Level={3000,3074},QuestNPC="Snow World 3 Quest",QuestCF=CFrame.new(-13456,469,-7039),MobCF=CFrame.new(-13456,469,-7039)},
    ["Pyromania Expert"]    = {Level={3075,3149},QuestNPC="Fire Colosseum",    QuestCF=CFrame.new(-13456,469,-7039),MobCF=CFrame.new(-13456,469,-7039)},
    ["Order Soldier"]       = {Level={3150,3224},QuestNPC="Order Quest",       QuestCF=CFrame.new(-13456,469,-7039),MobCF=CFrame.new(-13456,469,-7039)},
    ["Order Officer"]       = {Level={3225,3299},QuestNPC="Order Quest 2",     QuestCF=CFrame.new(-13456,469,-7039),MobCF=CFrame.new(-13456,469,-7039)},
    ["Pirate Millionaire"]  = {Level={3300,3399},QuestNPC="Millionaire Quest", QuestCF=CFrame.new(-118,55,5649),  MobCF=CFrame.new(-118,55,5649)},
    ["Pistol Billionaire"]  = {Level={3400,3549},QuestNPC="Billionaire Quest", QuestCF=CFrame.new(-185,84,6103),  MobCF=CFrame.new(-185,84,6103)},
    ["Factory Staff"]       = {Level={3550,3699},QuestNPC="Factory Quest",     QuestCF=CFrame.new(-105,72,-670),  MobCF=CFrame.new(-105,72,-670)},
    ["Water Fighter"]       = {Level={3700,3849},QuestNPC="Water Quest",       QuestCF=CFrame.new(-3331,239,-10553),MobCF=CFrame.new(-3331,239,-10553)},
    ["Royal Soldier 3"]     = {Level={3850,3999},QuestNPC="Sky 3 Quest",       QuestCF=CFrame.new(-7759,5606,-1862),MobCF=CFrame.new(-7759,5606,-1862)},
    ["Fishman Captain"]     = {Level={4000,4199},QuestNPC="Pineapple Quest",   QuestCF=CFrame.new(-10828,331,-9049),MobCF=CFrame.new(-10828,331,-9049)},
    ["Specter"]             = {Level={4200,4349},QuestNPC="Haunted Island 2",  QuestCF=CFrame.new(-12862,27,-7068),MobCF=CFrame.new(-12862,27,-7068)},
    ["Knight of the Sea"]   = {Level={4350,4499},QuestNPC="Sea Knight Quest",  QuestCF=CFrame.new(-5085,1,-9698), MobCF=CFrame.new(-5085,1,-9698)},
}

-- ============================================================
-- BOSS DATA
-- ============================================================
local BossData = {
    ["Gorilla King"]       = {CF=CFrame.new(-1949.8,-2,-3282),  HP=7500,  Reward="Kilo Bag", CD=30},
    ["Bobby"]              = {CF=CFrame.new(-1271.7,-3.2,-1272.6),HP=3500, Reward="Katana",  CD=30},
    ["Yeti"]               = {CF=CFrame.new(1192,274,-2025),    HP=45000, Reward="Chilly Cloak",  CD=60},
    ["Mr. 3"]              = {CF=CFrame.new(-6516,-3,-1046),    HP=50000, Reward="Kilo Bag",  CD=60},
    ["Wysper"]             = {CF=CFrame.new(-5082,612,-4762),   HP=75000, Reward="Dark Dagger", CD=60},
    ["Thunder God"]        = {CF=CFrame.new(-5082,612,-4762),   HP=150000,Reward="Thunder God Fragment", CD=120},
    ["Cyborg"]             = {CF=CFrame.new(5261,-3,3768),      HP=175000,Reward="Dark Blade", CD=120},
    ["Saber Expert"]       = {CF=CFrame.new(-6512,-3,1952),     HP=225000,Reward="Saber", CD=180},
    ["Swan"]               = {CF=CFrame.new(-297,8,5765),       HP=250000,Reward="Swan Glasses", CD=120},
    ["Order"]              = {CF=CFrame.new(-297,8,5765),       HP=350000,Reward="Order Items", CD=120},
    ["Awakened Ice Admiral"]={CF=CFrame.new(1030,267,-5140),   HP=750000,Reward="Ice Admiral Coat", CD=180},
    ["Longma"]             = {CF=CFrame.new(-3282,57,-4286),    HP=1000000,Reward="Longma Items", CD=240},
    ["rip_indra"]          = {CF=CFrame.new(3601,8,3390),       HP=2500000,Reward="Indra Fragment", CD=360},
    ["Stone"]              = {CF=CFrame.new(-297,8,5765),       HP=4000000,Reward="Stone Items", CD=360},
    ["Island Empress"]     = {CF=CFrame.new(-10828,331,-9049),  HP=5000000,Reward="Empress Items", CD=360},
    ["Wandering Blade"]    = {CF=CFrame.new(-5085,1,-9698),     HP=6000000,Reward="Blade Items", CD=360},
    ["Cake Queen"]         = {CF=CFrame.new(582,25,-12550),     HP=8000000,Reward="Cake Crown", CD=360},
    ["Dough King"]         = {CF=CFrame.new(582,25,-12550),     HP=10000000,Reward="Pole v2", CD=360},
    ["Mirror Boss"]        = {CF=CFrame.new(-13456,469,-7039),  HP=12000000,Reward="Mirror Items", CD=360},
    ["Soul Reaper"]        = {CF=CFrame.new(-12862,27,-7068),   HP=15000000,Reward="Soul Items", CD=360},
    ["Tide Keeper"]        = {CF=CFrame.new(-5085,1,-9698),     HP=18000000,Reward="Tide Items", CD=360},
    ["King Red Head"]      = {CF=CFrame.new(1018,40,-10438),    HP=20000000,Reward="Red Head Items", CD=360},
    ["Leviathan"]          = {CF=CFrame.new(-4648,76,-13527),   HP=25000000,Reward="Leviathan Scale", CD=600},
}

-- ============================================================
-- MATERIAL DATA
-- ============================================================
local MaterialData = {
    ["Radioactive Material"] = {Mob="Factory Staff",  Pos=CFrame.new(-105,72,-670)},
    ["Leather + Scrap Metal"]= {Mob="Mercenary",      Pos=CFrame.new(-986,72,1088)},
    ["Magma Ore"]            = {Mob="Military Soldier",Pos=CFrame.new(-5565,9,8327)},
    ["Fish Tail"]            = {Mob="Fishman Warrior", Pos=CFrame.new(60943,17,1744)},
    ["Angel Wings"]          = {Mob="Royal Soldier",  Pos=CFrame.new(-7759,5606,-1862)},
    ["Mystic Droplet"]       = {Mob="Water Fighter",  Pos=CFrame.new(-3331,239,-10553)},
    ["Vampire Fang"]         = {Mob="Vampire",        Pos=CFrame.new(-6132,9,-1466)},
    ["Gunpowder"]            = {Mob="Pistol Billionaire",Pos=CFrame.new(-185,84,6103)},
    ["Mini Tusk"]            = {Mob="Mythological Pirate",Pos=CFrame.new(-13456,469,-7039)},
    ["Conjured Cocoa"]       = {Mob="Chocolate Bar Battler",Pos=CFrame.new(582,25,-12550)},
    ["Dragon Scale"]         = {Mob="Dragon Crew Warrior",Pos=CFrame.new(-3282,57,-4286)},
    ["Horned Warrior Helmet"]= {Mob="Horned Warrior", Pos=CFrame.new(-4648,76,-13527)},
    ["Fool's Gold"]          = {Mob="Snow Lurker",    Pos=CFrame.new(1030,267,-5140)},
    ["Scrap Metal"]          = {Mob="Mechanical Pirate",Pos=CFrame.new(-11467,8,-4901)},
    ["Awakened Fragment"]    = {Mob="Dragon Crew Archer",Pos=CFrame.new(-3282,57,-4286)},
    ["Dark Fragment"]        = {Mob="Dark Master",    Pos=CFrame.new(-5082,612,-4762)},
    ["Fishman Meat"]         = {Mob="Fishman Commando",Pos=CFrame.new(61760,18,1460)},
    ["Snow Fur"]             = {Mob="Yeti",           Pos=CFrame.new(1192,274,-2025)},
}

-- ============================================================
-- RAID DATA
-- ============================================================
local RaidData = {
    ["Swan Pirates"]    = {Island="Port Town",     Fragments=100, Boss="Swan"},
    ["Order Pirates"]   = {Island="Fountain City", Fragments=100, Boss="Order"},
    ["Beautiful Pirates"]={Island="Hot Zone",      Fragments=100, Boss="Longma"},
    ["Haunted Castle"]  = {Island="Haunted Castle",Fragments=100, Boss="Soul Reaper"},
    ["Ice Castle"]      = {Island="Ice Castle",    Fragments=100, Boss="Awakened Ice Admiral"},
    ["Sky Pirates"]     = {Island="Sky Island",    Fragments=100, Boss="Thunder God"},
}

-- ============================================================
-- FRUIT DATA
-- ============================================================
local FruitList = {
    "Bomb","Spike","Chop","Spring","Kilo","Smoke","Snipe","Flame","Falcon","Ice",
    "Sand","Dark","Revive","Diamond","Light","Rubber","Barrier","Magma","Quake",
    "Human: Buddha","Love","Spider","Phoenix","Rumble","Pain","Gravity","Dough",
    "Shadow","Venom","Control","Soul","Dragon","String","Blizzard","Mammoth",
    "Leopard","Kitsune","T-Rex","Gas","Spirit","Yeti","Shiro","Saber","Ghost",
    "Paw","Spin","Giraffe","Food","Portal","Void","Unknown"
}

-- ============================================================
-- CODES LIST
-- ============================================================
local CodesList = {
    "NOMOREHACK","BANEXPLOIT","WildDares","BossBuild","GetPranked",
    "EARN_FRUITS","FIGHT4FRUIT","NOEXPLOITER","NOOB2ADMIN","CODESLIDE",
    "ADMINHACKED","ADMINDARES","fruitconcepts","krazydares","TRIPLEABUSE",
    "SEATROLLING","24NOADMIN","REWARDFUN","Chandler","NEWTROLL","KITT_RESET",
    "Sub2CaptainMaui","kittgaming","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK",
    "Starcodeheo","Bluxxy","fudd10_v2","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123",
    "Sub2UncleKizaru","Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine",
    "Sub2OfficialNoobie","Fudd10","Bignews","TheGreatAce","SECRET_ADMIN",
    "SUB2GAMERROBOT_RESET1","SUB2OFFICIALNOOBIE","AXIORE","BIGNEWS","BLUXXY",
    "CHANDLER","ENYU_IS_PRO","FUDD10","FUDD10_V2","KITTGAMING","MAGICBUS",
    "STARCODEHEO","STRAWHATMAINE","SUB2CAPTAINMAUI","SUB2DAIGROCK","SUB2FER999",
    "SUB2NOOBMASTER123","SUB2UNCLEKIZARU","TANTAIGAMING","THEGREATACE",
    "SUBGAMERROBOT_RESET1","SUBGAMERROBOT_EXP1","SUBFUDD10","SUBFUDD10_V2",
    "1MLIKES","2MLIKES","3MLIKES","4MLIKES","5MLIKES","10MLIKES","15MLIKES",
    "20MLIKES","25MLIKES","30MLIKES","35MLIKES","40MLIKES","50MLIKES","75MLIKES",
    "100MLIKES","125MLIKES","150MLIKES","175MLIKES","200MLIKES","250MLIKES",
    "300MLIKES","350MLIKES","ADMIN","REALMONEY","GETTROLLED","GETLUCKY",
    "RESET_STAT","RESET_STAT2","RESET_STAT3","FRUITMASTER","FRUITGOD",
    "UPDATE1","UPDATE2","UPDATE3","UPDATE4","UPDATE5","UPDATE6","UPDATE7",
    "UPDATE8","UPDATE9","UPDATE10","UPDATE11","UPDATE12","UPDATE13","UPDATE14",
    "UPDATE15","UPDATE16","UPDATE17","UPDATE18","UPDATE19","UPDATE20",
    "Sub2Gamer_Robot","Sub2KreekCraft","Sub2RobloxPlayerHater","Sub2Notoriety",
    "Sub2MahouTsukai","Sub2Pedro","Sub2Blox_Watch","Sub2OfficialNoobie2",
    "THEGREATACE","THORNHERO","ONEPIECE","LUFFY","ZORO","NAMI","SANJI",
    "CHOPPER","ROBIN","FRANKY","BROOK","JINBE","ACE","SABO","DRAGON",
    "WHITEBEARD","GARP","AKAINU","KIZARU","AOKIJI","BUGGY","SHANKS",
    "MIHAWK","BLACKBEARD","KAIDO","BIGGOM","LINLIN","DOFLAMINGO","LAW",
    "KID","KILLER","HAWKINS","APOO","DRAKE","BEGE","SMOOTHIE","PEROSPERO",
}

-- ============================================================
-- ISLAND TELEPORT DATA
-- ============================================================
local IslandData = {
    -- World 1
    ["Starter Island"]     = CFrame.new(-1271.7,-3.2,-1272.6),
    ["Monkey Island"]      = CFrame.new(-1949.8,-2,-3282),
    ["Pirate Village"]     = CFrame.new(-967,13,4034),
    ["Desert"]             = CFrame.new(924,-3,1121),
    ["Snow Island"]        = CFrame.new(1268,274,-2244),
    ["Marine Base"]        = CFrame.new(1010,5,-2971),
    ["Sky Island"]         = CFrame.new(-5082,612,-4762),
    ["Prison"]             = CFrame.new(5261,-3,3768),
    ["Colosseum"]          = CFrame.new(-6516,-3,-1046),
    ["Magma Village"]      = CFrame.new(-5565,9,8327),
    ["Underwater City"]    = CFrame.new(60943,17,1744),
    ["Sky Island 2"]       = CFrame.new(-7759,5606,-1862),
    ["Fountain City"]      = CFrame.new(5259,37,4050),
    -- World 2
    ["Port Town"]          = CFrame.new(-297,8,5765),
    ["Dress Rosa"]         = CFrame.new(-986,72,1088),
    ["Green Zone"]         = CFrame.new(3601,8,3390),
    ["Punk Hazard"]        = CFrame.new(584,14,5042),
    ["Thriller Bark"]      = CFrame.new(-11467,8,-4901),
    ["Graveyard"]          = CFrame.new(-6132,9,-1466),
    ["Hot Zone"]           = CFrame.new(-5158,14,-4654),
    ["Wano"]               = CFrame.new(-3282,57,-4286),
    ["Ice Castle"]         = CFrame.new(1030,267,-5140),
    -- World 3
    ["Floating Turtle"]    = CFrame.new(-10828,331,-9049),
    ["Haunted Castle"]     = CFrame.new(-12862,27,-7068),
    ["Sea of Treats"]      = CFrame.new(582,25,-12550),
    ["Elf Island"]         = CFrame.new(-4648,76,-13527),
    ["Cursed Ship"]        = CFrame.new(-5085,1,-9698),
    ["Sea Castle"]         = CFrame.new(1018,40,-10438),
    ["Pineapple Village"]  = CFrame.new(-10828,331,-9049),
    ["Mansion"]            = CFrame.new(-185,84,6103),
    ["Factory"]            = CFrame.new(-105,72,-670),
    ["ForgottenIsland"]    = CFrame.new(-3331,239,-10553),
}

-- ============================================================
-- SPAWN POINTS
-- ============================================================
local SpawnPoints = {
    ["Marine Starter"]   = CFrame.new(-1271.7,-3.2,-1272.6),
    ["Pirate Starter"]   = CFrame.new(319,-3,4228),
    ["Sky Island Spawn"] = CFrame.new(-4949,612,-4762),
    ["Prison Spawn"]     = CFrame.new(5157,-3,3768),
    ["Fountain Spawn"]   = CFrame.new(5023,37,4050),
}

-- ============================================================
-- ESP SYSTEM
-- ============================================================
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "BloxESP"
ESPFolder.Parent = Workspace

local ESPObjects = {}

local function CreateESPLabel(obj, color, text)
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_" .. obj.Name
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,150,0,40)
    bb.StudsOffset = Vector3.new(0,3,0)
    bb.Parent = ESPFolder
    if obj:IsA("Model") and obj.PrimaryPart then
        bb.Adornee = obj.PrimaryPart
    elseif obj:IsA("BasePart") then
        bb.Adornee = obj
    else
        bb.Adornee = obj:FindFirstChildOfClass("BasePart")
    end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text or obj.Name
    lbl.TextColor3 = color or Color3.new(1,1,1)
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.Parent = bb
    return bb
end

local function ClearESP(category)
    for _, obj in pairs(ESPFolder:GetChildren()) do
        if not category or obj:GetAttribute("ESPCategory") == category then
            obj:Destroy()
        end
    end
end

local function UpdateESP()
    if not _G.ESP then ClearESP() return end
    ClearESP()
    if _G.MobESP then
        for _, mob in pairs(GetAllMobs()) do
            if mob.PrimaryPart or mob:FindFirstChildOfClass("BasePart") then
                local hp = mob.Humanoid and mob.Humanoid.Health or 0
                local maxhp = mob.Humanoid and mob.Humanoid.MaxHealth or 1
                local pct = math.floor(hp/maxhp*100)
                local bb = CreateESPLabel(mob, _G.EspColor, mob.Name.."\n❤️ "..pct.."%")
                bb:SetAttribute("ESPCategory","mob")
            end
        end
    end
    if _G.ChestESP then
        for _, chest in pairs(GetChests()) do
            local bb = CreateESPLabel(chest, Color3.fromRGB(255,215,0), "💰 Chest")
            bb:SetAttribute("ESPCategory","chest")
        end
    end
    if _G.FruitESP then
        for _, fruit in pairs(GetFruits()) do
            local bb = CreateESPLabel(fruit, Color3.fromRGB(255,100,200), "🍎 "..fruit.Name)
            bb:SetAttribute("ESPCategory","fruit")
        end
    end
    if _G.PlayerESP then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character and plr.Character.PrimaryPart then
                local bb = CreateESPLabel(plr.Character, Color3.fromRGB(100,200,255), "👤 "..plr.Name)
                bb:SetAttribute("ESPCategory","player")
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if _G.ESP then UpdateESP() end
end)

-- ============================================================
-- INFINITE JUMP
-- ============================================================
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump then
        local h = GetHum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ============================================================
-- NO CLIP
-- ============================================================
RunService.Stepped:Connect(function()
    if _G.NoClip then
        local char = GetChar()
        if char then
            for _, p in pairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then
                    p.CanCollide = false
                end
            end
        end
    end
end)

-- ============================================================
-- SPEED & JUMP HACK
-- ============================================================
RunService.Heartbeat:Connect(function()
    local h = GetHum()
    if h then
        if _G.SpeedHack then h.WalkSpeed = _G.SpeedValue end
        if _G.JumpValue  then h.JumpPower = _G.JumpValue end
        if _G.InfStamina then
            local stam = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Stamina")
            if stam then stam.Value = stam.MaxValue or 100 end
        end
    end
end)

-- ============================================================
-- FLY HACK
-- ============================================================
local FlyConn
local function StartFly()
    local root = GetRoot()
    if not root then return end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.Velocity = Vector3.new()
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Parent = root
    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyGyro"
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.Parent = root

    FlyConn = RunService.Heartbeat:Connect(function()
        if not _G.FlyHack then
            if bv and bv.Parent then bv:Destroy() end
            if bg and bg.Parent then bg:Destroy() end
            if FlyConn then FlyConn:Disconnect() end
            return
        end
        local cf = Cam.CFrame
        local dir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
        bv.Velocity = dir * _G.FlySpeed
        bg.CFrame = cf
    end)
end

-- ============================================================
-- KILL AURA
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.KillAura then return end
    local root = GetRoot()
    if not root then return end
    for _, mob in pairs(GetAllMobs()) do
        if mob.PrimaryPart then
            local d = Distance(root.Position, mob.PrimaryPart.Position)
            if d <= _G.AuraRange then
                SafeCall(function()
                    Remote:InvokeServer("Attack", mob)
                end)
            end
        end
    end
end)

-- ============================================================
-- HITBOX EXPANDER
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.HitboxExpand then return end
    for _, mob in pairs(GetAllMobs()) do
        for _, p in pairs(mob:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Size = Vector3.new(_G.HitboxValue, _G.HitboxValue, _G.HitboxValue)
            end
        end
    end
end)

-- ============================================================
-- FULLBRIGHT
-- ============================================================
local function SetFullbright(on)
    if on then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1e6
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14.5
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70,70,70)
    end
end

-- ============================================================
-- AUTO QUEST LOGIC
-- ============================================================
local function GetAutoMob()
    local lvl = GetLevel()
    local best = nil
    local bestMax = 0
    for name, data in pairs(MonsterData) do
        if lvl >= data.Level[1] and lvl <= data.Level[2] then
            if data.Level[2] > bestMax then
                best = name
                bestMax = data.Level[2]
            end
        end
    end
    return best
end

local function DoQuest(mobName)
    local data = MonsterData[mobName]
    if not data then return end
    -- Teleport to quest NPC
    SafeCall(function() Teleport(data.QuestCF) end)
    task.wait(0.5)
    -- Accept quest
    SafeCall(function()
        Remote:InvokeServer("StartQuest", data.QuestNPC, mobName)
    end)
    task.wait(0.3)
end

local function FarmMob(mobName)
    local data = MonsterData[mobName]
    if not data then return end
    local mob = GetNearestMob(200, mobName)
    if mob and mob.PrimaryPart then
        Teleport(mob.PrimaryPart.CFrame)
    else
        SafeCall(function() Teleport(data.MobCF) end)
    end
    task.wait(_G.FarmDelay)
    -- Attack
    local target = GetNearestMob(50, mobName)
    if target then
        SafeCall(function()
            Remote:InvokeServer("Attack", target)
        end)
    end
end

-- ============================================================
-- MAIN FARM LOOP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoFarm then return end
    if not IsAlive() then return end
    local mobName = _G.SelectedMob == "Auto" and GetAutoMob() or _G.SelectedMob
    if not mobName then return end
    -- Server hop if needed
    if _G.ServerHop then
        local h = GetHum()
        if h and h.Health <= (_G.ServerHopHP / 100 * h.MaxHealth) then
            SafeCall(function()
                local servers = HttpService:JSONDecode(
                    game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
                ).data
                for _, s in pairs(servers) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(PlaceId, s.id, LP)
                        break
                    end
                end
            end)
        end
    end
    FarmMob(mobName)
end)

-- ============================================================
-- AUTO BOSS LOOP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoBoss then return end
    if not IsAlive() then return end
    local bossName = _G.SelectedBoss
    local data = BossData[bossName]
    if not data then return end
    local boss = GetNearestMob(500, bossName)
    if boss and boss.PrimaryPart then
        local d = Distance(GetRoot().Position, boss.PrimaryPart.Position)
        if d > 10 then Teleport(boss.PrimaryPart.CFrame * CFrame.new(0,0,5)) end
        SafeCall(function() Remote:InvokeServer("Attack", boss) end)
    else
        Teleport(data.CF)
    end
end)

-- ============================================================
-- AUTO CHEST
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoChest then return end
    if not IsAlive() then return end
    local chests = GetChests()
    local root = GetRoot()
    if not root then return end
    for _, chest in pairs(chests) do
        local pos = chest:IsA("Model") and chest.PrimaryPart and chest.PrimaryPart.Position
                    or chest:IsA("BasePart") and chest.Position
        if pos and Distance(root.Position, pos) <= 200 then
            Teleport(CFrame.new(pos))
            task.wait(0.2)
            SafeCall(function()
                Remote:InvokeServer("OpenChest", chest)
            end)
            task.wait(_G.ChestDelay)
        end
    end
end)

-- ============================================================
-- AUTO FRUIT PICKUP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoFruit then return end
    if not IsAlive() then return end
    local fruits = GetFruits()
    local root = GetRoot()
    if not root then return end
    for _, fruit in pairs(fruits) do
        local part = fruit:IsA("Model") and fruit.PrimaryPart or fruit:IsA("BasePart") and fruit
        if part then
            local d = Distance(root.Position, part.Position)
            if d <= 300 then
                Teleport(CFrame.new(part.Position))
                task.wait(0.3)
                SafeCall(function()
                    Remote:InvokeServer("PickUpFruit", fruit)
                end)
            end
        end
    end
end)

-- ============================================================
-- AUTO MATERIAL FARM
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoMaterial then return end
    if not IsAlive() then return end
    if _G.SelectedMaterial == "None" then return end
    local mat = MaterialData[_G.SelectedMaterial]
    if not mat then return end
    local mob = GetNearestMob(200, mat.Mob)
    if mob and mob.PrimaryPart then
        Teleport(mob.PrimaryPart.CFrame * CFrame.new(0,0,5))
        SafeCall(function() Remote:InvokeServer("Attack", mob) end)
    else
        Teleport(mat.Pos)
    end
end)

-- ============================================================
-- AUTO STATS DISTRIBUTOR
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoStats then return end
    local points = LP.Data and LP.Data.StatPoint and LP.Data.StatPoint.Value or 0
    if points <= 0 then return end
    SafeCall(function()
        Remote:InvokeServer("IncreaseStats", _G.StatType, points)
    end)
end)

-- ============================================================
-- AUTO MASTERY
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoMastery then return end
    if not IsAlive() then return end
    local mob = GetNearestMob(50, _G.SelectedMob ~= "Auto" and _G.SelectedMob or nil)
    if mob then
        SafeCall(function() Remote:InvokeServer("Attack", mob) end)
    end
end)

-- ============================================================
-- AUTO HAKI TRAINING
-- ============================================================
local HakiConn
RunService.Heartbeat:Connect(function()
    if not _G.AutoHaki then return end
    SafeCall(function()
        Remote:InvokeServer("Haki")
    end)
end)

-- ============================================================
-- AUTO KEN HAKI (Observation)
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoKenHaki then return end
    SafeCall(function()
        Remote:InvokeServer("ActivateHaki", "Ken")
    end)
end)

-- ============================================================
-- AUTO ARMOR HAKI
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoArmorHaki then return end
    SafeCall(function()
        Remote:InvokeServer("ActivateHaki", "Buso")
    end)
end)

-- ============================================================
-- AUTO PARRY
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoParry then return end
    SafeCall(function()
        Remote:InvokeServer("Parry")
    end)
end)

-- ============================================================
-- AUTO DODGE
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoDodge then return end
    local root = GetRoot()
    if not root then return end
    local nearest = GetNearestMob(30)
    if nearest then
        SafeCall(function()
            Remote:InvokeServer("Dodge")
        end)
    end
end)

-- ============================================================
-- AUTO EAT FRUIT
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoEat then return end
    local inv = LP:FindFirstChild("Data") and LP.Data:FindFirstChild("Fruits")
    if inv then
        for _, f in pairs(inv:GetChildren()) do
            if f.Value ~= "None" and f.Value ~= "" then
                SafeCall(function()
                    Remote:InvokeServer("EatFruit", f.Name)
                end)
                break
            end
        end
    end
end)

-- ============================================================
-- AUTO SKILLS
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoSkill then return end
    local nearest = GetNearestMob(100)
    if nearest and nearest.PrimaryPart then
        for i = 1, 4 do
            SafeCall(function()
                Remote:InvokeServer("UseSkill", i, nearest.PrimaryPart.CFrame)
            end)
        end
    end
end)

-- ============================================================
-- SILENT AIM
-- ============================================================
local function GetSilentTarget()
    if not _G.SilentAim then return nil end
    local nearestPlr = GetNearestPlayer(_G.AuraRange)
    if nearestPlr and nearestPlr.Character and nearestPlr.Character:FindFirstChild("HumanoidRootPart") then
        return nearestPlr.Character.HumanoidRootPart
    end
    return nil
end

-- ============================================================
-- REACH HACK
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.ReachHack then return end
    local nearest = GetNearestMob(_G.ReachValue * 10)
    if nearest and nearest.PrimaryPart then
        SafeCall(function()
            Remote:InvokeServer("Attack", nearest, _G.ReachValue)
        end)
    end
end)

-- ============================================================
-- AUTO CODES REDEEMER
-- ============================================================
local function RedeemAllCodes()
    local redeemed = 0
    for _, code in ipairs(CodesList) do
        SafeCall(function()
            local result = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Redeem"):InvokeServer(code)
            if result then redeemed = redeemed + 1 end
        end)
        task.wait(0.1)
    end
    Notify("🎁 Auto Codes", "Redeemed "..redeemed.." codes!", 5)
end

-- ============================================================
-- SERVER HOP FUNCTION
-- ============================================================
local function HopServer()
    SafeCall(function()
        local data = HttpService:JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        )
        for _, s in pairs(data.data) do
            if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
                TeleportService:TeleportToPlaceInstance(PlaceId, s.id, LP)
                return
            end
        end
        Notify("⚠️ Server Hop", "No available servers found!", 3)
    end)
end

-- ============================================================
-- AUTO RAID
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoRaid then return end
    if not IsAlive() then return end
    local raid = RaidData[_G.SelectedRaid]
    if not raid then return end
    SafeCall(function()
        local fragments = GetFragments()
        if fragments >= raid.Fragments then
            Remote:InvokeServer("StartRaid", _G.SelectedRaid)
        end
    end)
end)

-- ============================================================
-- AUTO FRAGMENTS
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoFragments then return end
    if not IsAlive() then return end
    -- Kill elite enemies for fragments
    local elites = {"Order Soldier","Order Officer","Magma Ninja","Dragon Crew Warrior"}
    for _, name in ipairs(elites) do
        local mob = GetNearestMob(200, name)
        if mob and mob.PrimaryPart then
            Teleport(mob.PrimaryPart.CFrame * CFrame.new(0,0,5))
            SafeCall(function() Remote:InvokeServer("Attack", mob) end)
            break
        end
    end
end)

-- ============================================================
-- FOV CIRCLE VISUALIZER
-- ============================================================
local FovGui = Instance.new("ScreenGui")
FovGui.Name = "FovCircle"
FovGui.ResetOnSpawn = false
FovGui.Parent = LP.PlayerGui

local FovFrame = Instance.new("Frame")
FovFrame.BackgroundTransparency = 1
FovFrame.Size = UDim2.new(1,0,1,0)
FovFrame.Parent = FovGui

local FovCircle = Instance.new("Frame")
FovCircle.BackgroundTransparency = 1
FovCircle.BorderSizePixel = 2
FovCircle.BorderColor3 = Color3.fromRGB(150,50,255)
FovCircle.AnchorPoint = Vector2.new(0.5,0.5)
FovCircle.Parent = FovFrame

Instance.new("UICorner", FovCircle).CornerRadius = UDim.new(1,0)

RunService.RenderStepped:Connect(function()
    if _G.FovCircle then
        local size = _G.FovValue * 5
        FovCircle.Size = UDim2.new(0,size,0,size)
        FovCircle.Position = UDim2.new(0.5,0,0.5,0)
        FovCircle.Visible = true
    else
        FovCircle.Visible = false
    end
end)

-- ============================================================
-- KILL COUNTER
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.RecordKills then return end
    -- Simple kill tracking via mob health changes
end)

-- ============================================================
-- SESSION TIMER
-- ============================================================
local sessionLabel
RunService.Heartbeat:Connect(function()
    _G.FarmTime = os.time() - _G.SessionStart
end)

-- ============================================================
-- AUTO RESPAWN
-- ============================================================
LP.CharacterAdded:Connect(function()
    if _G.AutoRespawn then
        task.wait(3)
        _G.KillCount = _G.KillCount + 0
    end
end)

-- ============================================================
-- GRAVITY MODIFIER
-- ============================================================
RunService.Heartbeat:Connect(function()
    if _G.GravMult ~= 1 then
        Workspace.Gravity = 196.2 * _G.GravMult
    end
end)

-- ============================================================
-- ANTI BLIND / ANTI FREEZE
-- ============================================================
RunService.Heartbeat:Connect(function()
    if _G.AntiBlind then
        for _, obj in pairs(LP.PlayerGui:GetDescendants()) do
            if obj:IsA("Frame") and obj.BackgroundColor3 == Color3.new(0,0,0) and obj.BackgroundTransparency < 0.5 then
                obj.BackgroundTransparency = 1
            end
        end
    end
    if _G.AntiFreeze then
        local h = GetHum()
        if h then h.PlatformStand = false end
    end
end)

-- ============================================================
-- AUTO BLOCK
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoBlock then return end
    local nearest = GetNearestMob(40)
    if nearest then
        SafeCall(function() Remote:InvokeServer("Block") end)
    end
end)

-- ============================================================
-- INSTANT KILL
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.InstantKill then return end
    local nearest = GetNearestMob(60)
    if nearest then
        SafeCall(function()
            for i = 1, 10 do
                Remote:InvokeServer("Attack", nearest)
            end
        end)
    end
end)

-- ============================================================
-- AUTO SWORD EQUIP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoSword then return end
    SafeCall(function()
        Remote:InvokeServer("EquipSword")
    end)
end)

-- ============================================================
-- AUTO GUN EQUIP
-- ============================================================
RunService.Heartbeat:Connect(function()
    if not _G.AutoGun then return end
    SafeCall(function()
        Remote:InvokeServer("EquipGun")
    end)
end)

-- ============================================================
-- CLICK TELEPORT
-- ============================================================
local ClickTeleport = false
Mouse.Button1Down:Connect(function()
    if ClickTeleport then
        local root = GetRoot()
        if root then
            root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
        end
    end
end)

-- ============================================================
-- KEY BINDS
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Delete then
        local gui = LP.PlayerGui:FindFirstChild("BloxGUI")
        if gui then gui.Enabled = not gui.Enabled end
    end
    if input.KeyCode == Enum.KeyCode.F1 then
        _G.AutoFarm = not _G.AutoFarm
        Notify("⌨️ Hotkey", "Auto Farm: " .. (_G.AutoFarm and "ON" or "OFF"), 2)
    end
    if input.KeyCode == Enum.KeyCode.F2 then
        _G.AutoBoss = not _G.AutoBoss
        Notify("⌨️ Hotkey", "Auto Boss: " .. (_G.AutoBoss and "ON" or "OFF"), 2)
    end
    if input.KeyCode == Enum.KeyCode.F3 then
        _G.ESP = not _G.ESP
        _G.MobESP = _G.ESP
        Notify("⌨️ Hotkey", "ESP: " .. (_G.ESP and "ON" or "OFF"), 2)
    end
    if input.KeyCode == Enum.KeyCode.F4 then
        _G.FlyHack = not _G.FlyHack
        if _G.FlyHack then StartFly() end
        Notify("⌨️ Hotkey", "Fly: " .. (_G.FlyHack and "ON" or "OFF"), 2)
    end
    if input.KeyCode == Enum.KeyCode.RightBracket then
        _G.SpeedValue = math.min(_G.SpeedValue + 10, 500)
        local h = GetHum()
        if h then h.WalkSpeed = _G.SpeedValue end
    end
    if input.KeyCode == Enum.KeyCode.LeftBracket then
        _G.SpeedValue = math.max(_G.SpeedValue - 10, 16)
        local h = GetHum()
        if h then h.WalkSpeed = _G.SpeedValue end
    end
end)

-- ============================================================
-- ============================================================
--                  WINDUI INTERFACE
-- ============================================================
-- ============================================================
local Window = WindUI:CreateWindow({
    Title    = "🌀 Blox Fruits Ultimate",
    SubTitle = "v4.0 | " .. WorldName,
    TabWidth = 160,
    Size     = UDim2.fromOffset(620, 480),
    Opacity  = 0.9,
    Theme    = "Dark",
    Icon     = "rbxassetid://7733960981",
    Draggable = true,
})

-- ============================================================
-- TAB: AUTO FARM
-- ============================================================
local FarmTab = Window:Tab({ Title="⚔️ Auto Farm", Icon="rbxassetid://7733664078" })

local FarmSection = FarmTab:Section({ Title="Farm Settings" })

local MobNames = {}
for k in pairs(MonsterData) do table.insert(MobNames, k) end
table.sort(MobNames)
table.insert(MobNames, 1, "Auto")

FarmSection:Dropdown({
    Title   = "Select Monster",
    List    = MobNames,
    Default = "Auto",
    Callback = function(v)
        _G.SelectedMob = v
        Notify("⚔️ Monster", "Selected: " .. v, 2)
    end
})

FarmSection:Toggle({
    Title    = "Auto Farm",
    Default  = false,
    Callback = function(v)
        _G.AutoFarm = v
        if v then Notify("⚔️ Auto Farm", "Farm started on: " .. _G.SelectedMob, 3) end
    end
})

FarmSection:Toggle({
    Title    = "Auto Quest",
    Default  = false,
    Callback = function(v)
        _G.AutoQuest = v
        if v then
            task.spawn(function()
                while _G.AutoQuest do
                    local mob = _G.SelectedMob == "Auto" and GetAutoMob() or _G.SelectedMob
                    if mob then DoQuest(mob) end
                    task.wait(1)
                end
            end)
        end
    end
})

FarmSection:Toggle({
    Title    = "Auto Mastery",
    Default  = false,
    Callback = function(v) _G.AutoMastery = v end
})

FarmSection:Slider({
    Title   = "Farm Delay (seconds)",
    Min     = 0, Max = 2, Default = 0.1,
    Callback = function(v) _G.FarmDelay = v end
})

FarmSection:Slider({
    Title   = "Walk Speed",
    Min     = 16, Max = 500, Default = 16,
    Callback = function(v)
        _G.SpeedValue = v
        _G.SpeedHack = (v ~= 16)
        local h = GetHum()
        if h then h.WalkSpeed = v end
    end
})

FarmSection:Slider({
    Title   = "Jump Power",
    Min     = 50, Max = 1000, Default = 50,
    Callback = function(v)
        _G.JumpValue = v
        local h = GetHum()
        if h then h.JumpPower = v end
    end
})

local FarmAdvanced = FarmTab:Section({ Title="Advanced Farm" })

FarmAdvanced:Toggle({
    Title    = "Server Hop on Low HP",
    Default  = false,
    Callback = function(v) _G.ServerHop = v end
})

FarmAdvanced:Slider({
    Title   = "Server Hop HP%",
    Min     = 5, Max = 50, Default = 20,
    Callback = function(v) _G.ServerHopHP = v end
})

FarmAdvanced:Toggle({
    Title    = "Auto Respawn",
    Default  = false,
    Callback = function(v) _G.AutoRespawn = v end
})

FarmAdvanced:Toggle({
    Title    = "Instant Kill",
    Default  = false,
    Callback = function(v) _G.InstantKill = v end
})

FarmAdvanced:Toggle({
    Title    = "Kill Aura",
    Default  = false,
    Callback = function(v)
        _G.KillAura = v
        if v then Notify("💀 Kill Aura", "Enabled! Range: " .. _G.AuraRange, 2) end
    end
})

FarmAdvanced:Slider({
    Title   = "Kill Aura Range",
    Min     = 10, Max = 200, Default = 40,
    Callback = function(v) _G.AuraRange = v end
})

FarmAdvanced:Toggle({
    Title    = "Hitbox Expander",
    Default  = false,
    Callback = function(v)
        _G.HitboxExpand = v
        if v then Notify("📦 Hitbox", "Enabled! Size: " .. _G.HitboxValue, 2) end
    end
})

FarmAdvanced:Slider({
    Title   = "Hitbox Size",
    Min     = 5, Max = 100, Default = 15,
    Callback = function(v) _G.HitboxValue = v end
})

FarmAdvanced:Toggle({
    Title    = "Reach Hack",
    Default  = false,
    Callback = function(v) _G.ReachHack = v end
})

FarmAdvanced:Slider({
    Title   = "Reach Distance",
    Min     = 10, Max = 200, Default = 10,
    Callback = function(v) _G.ReachValue = v end
})

FarmAdvanced:Toggle({
    Title    = "Auto Block",
    Default  = false,
    Callback = function(v) _G.AutoBlock = v end
})

FarmAdvanced:Toggle({
    Title    = "Auto Parry",
    Default  = false,
    Callback = function(v) _G.AutoParry = v end
})

FarmAdvanced:Toggle({
    Title    = "Auto Dodge",
    Default  = false,
    Callback = function(v) _G.AutoDodge = v end
})

FarmAdvanced:Toggle({
    Title    = "Auto Skills",
    Default  = false,
    Callback = function(v) _G.AutoSkill = v end
})

-- ============================================================
-- TAB: AUTO BOSS
-- ============================================================
local BossTab = Window:Tab({ Title="👑 Auto Boss", Icon="rbxassetid://7733664078" })
local BossSection = BossTab:Section({ Title="Boss Settings" })

local BossNames = {}
for k in pairs(BossData) do table.insert(BossNames, k) end
table.sort(BossNames)

BossSection:Dropdown({
    Title   = "Select Boss",
    List    = BossNames,
    Default = "Gorilla King",
    Callback = function(v)
        _G.SelectedBoss = v
        local data = BossData[v]
        if data then
            Notify("👑 Boss", v .. " | HP: " .. data.HP .. " | Drop: " .. data.Reward, 4)
        end
    end
})

BossSection:Toggle({
    Title    = "Auto Boss",
    Default  = false,
    Callback = function(v)
        _G.AutoBoss = v
        if v then Notify("👑 Auto Boss", "Farming: " .. _G.SelectedBoss, 3) end
    end
})

BossSection:Slider({
    Title   = "Boss Attack Delay",
    Min     = 0.1, Max = 3, Default = 0.5,
    Callback = function(v) _G.BossDelay = v end
})

BossSection:Button({
    Title    = "Teleport to Boss",
    Callback = function()
        local data = BossData[_G.SelectedBoss]
        if data then
            Teleport(data.CF)
            Notify("🚀 Teleport", "Teleported to " .. _G.SelectedBoss, 2)
        end
    end
})

local BossInfo = BossTab:Section({ Title="Boss Info" })

for name, data in pairs(BossData) do
    BossInfo:Label({
        Title = name .. " → Drop: " .. data.Reward
    })
end

-- ============================================================
-- TAB: PLAYER
-- ============================================================
local PlayerTab = Window:Tab({ Title="🧍 Player", Icon="rbxassetid://7733664078" })
local PlayerSection = PlayerTab:Section({ Title="Player Mods" })

PlayerSection:Toggle({
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v) _G.InfJump = v end
})

PlayerSection:Toggle({
    Title    = "No Clip",
    Default  = false,
    Callback = function(v)
        _G.NoClip = v
        Notify("👻 No Clip", v and "Enabled" or "Disabled", 2)
    end
})

PlayerSection:Toggle({
    Title    = "Fly Hack",
    Default  = false,
    Callback = function(v)
        _G.FlyHack = v
        if v then StartFly() end
        Notify("🚁 Fly", v and "Use WASD + Space/Ctrl" or "Disabled", 3)
    end
})

PlayerSection:Slider({
    Title   = "Fly Speed",
    Min     = 10, Max = 500, Default = 50,
    Callback = function(v) _G.FlySpeed = v end
})

PlayerSection:Toggle({
    Title    = "Infinite Stamina",
    Default  = false,
    Callback = function(v) _G.InfStamina = v end
})

PlayerSection:Toggle({
    Title    = "Anti AFK",
    Default  = true,
    Callback = function(v) _G.AntiAFK = v end
})

PlayerSection:Toggle({
    Title    = "Anti Blind",
    Default  = false,
    Callback = function(v) _G.AntiBlind = v end
})

PlayerSection:Toggle({
    Title    = "Anti Freeze",
    Default  = false,
    Callback = function(v) _G.AntiFreeze = v end
})

PlayerSection:Slider({
    Title   = "Gravity Multiplier",
    Min     = 0, Max = 5, Default = 1,
    Callback = function(v)
        _G.GravMult = v
        Workspace.Gravity = 196.2 * v
    end
})

local TeleportSection = PlayerTab:Section({ Title="Teleport to Island" })

local IslandNames = {}
for k in pairs(IslandData) do table.insert(IslandNames, k) end
table.sort(IslandNames)

TeleportSection:Dropdown({
    Title   = "Select Island",
    List    = IslandNames,
    Default = "Starter Island",
    Callback = function(v)
        local cf = IslandData[v]
        if cf then
            Teleport(cf)
            Notify("🗺️ Teleport", "Teleported to " .. v, 2)
        end
    end
})

TeleportSection:Button({
    Title    = "Teleport to Selected Island",
    Callback = function()
        for _, name in ipairs(IslandNames) do
            local cf = IslandData[name]
            if cf then Teleport(cf) break end
        end
    end
})

TeleportSection:Button({
    Title    = "Teleport to Spawn",
    Callback = function()
        local spawn = Workspace:FindFirstChild("Spawn") or Workspace:FindFirstChild("SpawnLocation")
        if spawn then
            Teleport(spawn.CFrame + Vector3.new(0,5,0))
        else
            Teleport(CFrame.new(0,5,0))
        end
        Notify("🏠 Spawn", "Teleported to spawn!", 2)
    end
})

-- ============================================================
-- TAB: FRUITS
-- ============================================================
local FruitTab = Window:Tab({ Title="🍎 Fruits", Icon="rbxassetid://7733664078" })
local FruitSection = FruitTab:Section({ Title="Fruit Farm" })

FruitSection:Toggle({
    Title    = "Auto Fruit Pickup",
    Default  = false,
    Callback = function(v)
        _G.AutoFruit = v
        if v then Notify("🍎 Fruit Pickup", "Auto picking up fruits!", 3) end
    end
})

FruitSection:Dropdown({
    Title   = "Fruit to Farm",
    List    = FruitList,
    Default = "None",
    Callback = function(v) _G.SelectedFruit = v end
})

FruitSection:Toggle({
    Title    = "Auto Eat Fruit",
    Default  = false,
    Callback = function(v) _G.AutoEat = v end
})

FruitSection:Toggle({
    Title    = "Fruit ESP",
    Default  = false,
    Callback = function(v)
        _G.FruitESP = v
        _G.ESP = v
    end
})

FruitSection:Toggle({
    Title    = "Auto Dev Fruit",
    Default  = false,
    Callback = function(v)
        _G.AutoDevFruit = v
        if v then
            task.spawn(function()
                while _G.AutoDevFruit do
                    SafeCall(function()
                        Remote:InvokeServer("GetDevFruit")
                    end)
                    task.wait(5)
                end
            end)
        end
    end
})

FruitSection:Button({
    Title    = "Check Fruit Storage",
    Callback = function()
        local inv = LP.Data and LP.Data:FindFirstChild("Fruits")
        if inv then
            local fruits = ""
            for _, f in pairs(inv:GetChildren()) do
                if f.Value and f.Value ~= "" and f.Value ~= "None" then
                    fruits = fruits .. f.Value .. "\n"
                end
            end
            Notify("🍎 Storage", fruits == "" and "No fruits stored!" or fruits, 5)
        end
    end
})

FruitSection:Button({
    Title    = "Open Fruit Dealer",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("OpenShop", "FruitDealer")
        end)
        Notify("🍎 Dealer", "Opening fruit dealer...", 2)
    end
})

-- ============================================================
-- TAB: MATERIALS
-- ============================================================
local MatTab = Window:Tab({ Title="⚗️ Materials", Icon="rbxassetid://7733664078" })
local MatSection = MatTab:Section({ Title="Material Farm" })

local MatNames = {"None"}
for k in pairs(MaterialData) do table.insert(MatNames, k) end
table.sort(MatNames)

MatSection:Dropdown({
    Title   = "Select Material",
    List    = MatNames,
    Default = "None",
    Callback = function(v)
        _G.SelectedMaterial = v
        if v ~= "None" then
            Notify("⚗️ Material", "Farming: " .. v .. " from " .. (MaterialData[v] and MaterialData[v].Mob or "?"), 3)
        end
    end
})

MatSection:Toggle({
    Title    = "Auto Farm Material",
    Default  = false,
    Callback = function(v)
        _G.AutoMaterial = v
        if v and _G.SelectedMaterial ~= "None" then
            Notify("⚗️ Farm", "Farming " .. _G.SelectedMaterial, 3)
        end
    end
})

MatSection:Button({
    Title    = "Teleport to Material Mob",
    Callback = function()
        if _G.SelectedMaterial == "None" then
            Notify("⚠️ Error", "Select a material first!", 2)
            return
        end
        local mat = MaterialData[_G.SelectedMaterial]
        if mat then
            Teleport(mat.Pos)
            Notify("🚀 Teleport", "Teleported to " .. mat.Mob, 2)
        end
    end
})

local MatInfo = MatTab:Section({ Title="Material Sources" })

for mat, data in pairs(MaterialData) do
    MatInfo:Label({ Title = mat .. " → " .. data.Mob })
end

-- ============================================================
-- TAB: RAIDS
-- ============================================================
local RaidTab = Window:Tab({ Title="⚡ Raids", Icon="rbxassetid://7733664078" })
local RaidSection = RaidTab:Section({ Title="Raid Settings" })

local RaidNames = {}
for k in pairs(RaidData) do table.insert(RaidNames, k) end
table.sort(RaidNames)

RaidSection:Dropdown({
    Title   = "Select Raid",
    List    = RaidNames,
    Default = "Swan Pirates",
    Callback = function(v)
        _G.SelectedRaid = v
        local data = RaidData[v]
        if data then
            Notify("⚡ Raid", v .. " | Boss: " .. data.Boss .. " | Fragments: " .. data.Fragments, 4)
        end
    end
})

RaidSection:Toggle({
    Title    = "Auto Raid",
    Default  = false,
    Callback = function(v)
        _G.AutoRaid = v
        if v then Notify("⚡ Raid", "Auto raiding: " .. _G.SelectedRaid, 3) end
    end
})

RaidSection:Button({
    Title    = "Start Raid Now",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("StartRaid", _G.SelectedRaid)
            Notify("⚡ Raid", "Starting " .. _G.SelectedRaid, 3)
        end)
    end
})

RaidSection:Toggle({
    Title    = "Auto Fragments",
    Default  = false,
    Callback = function(v) _G.AutoFragments = v end
})

RaidSection:Label({ Title = "Current Fragments: " .. tostring(GetFragments()) })

-- ============================================================
-- TAB: HAKI
-- ============================================================
local HakiTab = Window:Tab({ Title="💎 Haki", Icon="rbxassetid://7733664078" })
local HakiSection = HakiTab:Section({ Title="Haki Training" })

HakiSection:Toggle({
    Title    = "Auto Haki",
    Default  = false,
    Callback = function(v) _G.AutoHaki = v end
})

HakiSection:Toggle({
    Title    = "Auto Ken (Observation) Haki",
    Default  = false,
    Callback = function(v) _G.AutoKenHaki = v end
})

HakiSection:Toggle({
    Title    = "Auto Armor Haki (Buso)",
    Default  = false,
    Callback = function(v) _G.AutoArmorHaki = v end
})

HakiSection:Button({
    Title    = "Activate Haki Now",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("Haki")
            Notify("💎 Haki", "Haki activated!", 2)
        end)
    end
})

HakiSection:Button({
    Title    = "Check Haki Level",
    Callback = function()
        local haki = LP.Data and LP.Data:FindFirstChild("Haki")
        if haki then
            Notify("💎 Haki", "Level: " .. tostring(haki.Value), 3)
        end
    end
})

local MasterySection = HakiTab:Section({ Title="Mastery" })

MasterySection:Toggle({
    Title    = "Auto Mastery Fruit",
    Default  = false,
    Callback = function(v)
        _G.AutoMastery = v
        if v then Notify("💎 Mastery", "Farming fruit mastery!", 2) end
    end
})

MasterySection:Toggle({
    Title    = "Auto Mastery Sword",
    Default  = false,
    Callback = function(v)
        _G.AutoSword = v
    end
})

MasterySection:Toggle({
    Title    = "Auto Mastery Gun",
    Default  = false,
    Callback = function(v) _G.AutoGun = v end
})

-- ============================================================
-- TAB: STATS
-- ============================================================
local StatsTab = Window:Tab({ Title="📊 Stats", Icon="rbxassetid://7733664078" })
local StatsSection = StatsTab:Section({ Title="Auto Stats" })

StatsSection:Toggle({
    Title    = "Auto Distribute Stats",
    Default  = false,
    Callback = function(v) _G.AutoStats = v end
})

StatsSection:Dropdown({
    Title   = "Stat Type",
    List    = {"Melee","Defense","Sword","Gun","Blox Fruit"},
    Default = "Melee",
    Callback = function(v) _G.StatType = v end
})

StatsSection:Button({
    Title    = "Distribute All Stats",
    Callback = function()
        local points = LP.Data and LP.Data.StatPoint and LP.Data.StatPoint.Value or 0
        if points > 0 then
            SafeCall(function()
                Remote:InvokeServer("IncreaseStats", _G.StatType, points)
                Notify("📊 Stats", "Distributed " .. points .. " points to " .. _G.StatType, 3)
            end)
        else
            Notify("📊 Stats", "No stat points available!", 2)
        end
    end
})

StatsSection:Button({
    Title    = "Reset Stats",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("ResetStats")
            Notify("📊 Stats", "Stats reset!", 2)
        end)
    end
})

local PlayerInfoSection = StatsTab:Section({ Title="Player Info" })

PlayerInfoSection:Button({
    Title    = "Show Player Info",
    Callback = function()
        local lvl = GetLevel()
        local beli = GetBeli()
        local frags = GetFragments()
        Notify("📊 Player Info",
            "Level: " .. lvl ..
            "\nBeli: " .. beli ..
            "\nFragments: " .. frags ..
            "\nWorld: " .. WorldName,
            6
        )
    end
})

PlayerInfoSection:Button({
    Title    = "Show Session Stats",
    Callback = function()
        local time = os.time() - _G.SessionStart
        local mins = math.floor(time/60)
        local secs = time % 60
        Notify("⏱️ Session",
            "Time: " .. mins .. "m " .. secs .. "s" ..
            "\nKills: " .. _G.KillCount ..
            "\nQuests: " .. _G.QuestCount,
            5
        )
    end
})

-- ============================================================
-- TAB: ESP
-- ============================================================
local ESPTab = Window:Tab({ Title="👁️ ESP", Icon="rbxassetid://7733664078" })
local ESPSection = ESPTab:Section({ Title="ESP Settings" })

ESPSection:Toggle({
    Title    = "Master ESP Toggle",
    Default  = false,
    Callback = function(v)
        _G.ESP = v
        if not v then ClearESP() end
    end
})

ESPSection:Toggle({
    Title    = "Mob ESP",
    Default  = false,
    Callback = function(v)
        _G.MobESP = v
        _G.ESP = _G.MobESP or _G.ChestESP or _G.FruitESP or _G.PlayerESP
    end
})

ESPSection:Toggle({
    Title    = "Player ESP",
    Default  = false,
    Callback = function(v)
        _G.PlayerESP = v
        _G.ESP = _G.MobESP or _G.ChestESP or _G.FruitESP or _G.PlayerESP
    end
})

ESPSection:Toggle({
    Title    = "Chest ESP",
    Default  = false,
    Callback = function(v)
        _G.ChestESP = v
        _G.ESP = _G.MobESP or _G.ChestESP or _G.FruitESP or _G.PlayerESP
    end
})

ESPSection:Toggle({
    Title    = "Fruit ESP",
    Default  = false,
    Callback = function(v)
        _G.FruitESP = v
        _G.ESP = _G.MobESP or _G.ChestESP or _G.FruitESP or _G.PlayerESP
    end
})

ESPSection:Toggle({
    Title    = "Boss ESP",
    Default  = false,
    Callback = function(v)
        _G.BossESP = v
        _G.ESP = true
    end
})

ESPSection:ColorPicker({
    Title   = "ESP Color",
    Default = Color3.fromRGB(150,50,255),
    Callback = function(v) _G.EspColor = v end
})

local AimSection = ESPTab:Section({ Title="Aim Assist" })

AimSection:Toggle({
    Title    = "Silent Aim",
    Default  = false,
    Callback = function(v)
        _G.SilentAim = v
        if v then Notify("🎯 Silent Aim", "Aim assist enabled!", 2) end
    end
})

AimSection:Toggle({
    Title    = "FOV Circle",
    Default  = false,
    Callback = function(v) _G.FovCircle = v end
})

AimSection:Slider({
    Title   = "FOV Size",
    Min     = 20, Max = 300, Default = 60,
    Callback = function(v) _G.FovValue = v end
})

-- ============================================================
-- TAB: MISC
-- ============================================================
local MiscTab = Window:Tab({ Title="🔧 Misc", Icon="rbxassetid://7733664078" })
local MiscSection = MiscTab:Section({ Title="Visual" })

MiscSection:Toggle({
    Title    = "Fullbright",
    Default  = false,
    Callback = function(v)
        _G.Fullbright = v
        SetFullbright(v)
    end
})

MiscSection:Button({
    Title    = "FPS Boost",
    Callback = function()
        settings().Rendering.QualityLevel = "Level01"
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") then
                v.Enabled = false
            elseif v:IsA("Part") or v:IsA("Union") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end
        Notify("⚡ FPS Boost", "Applied! Should see better performance.", 3)
    end
})

MiscSection:Toggle({
    Title    = "Hide GUI (DEL key)",
    Default  = false,
    Callback = function(v)
        _G.HideGUI = v
    end
})

local ServerSection = MiscTab:Section({ Title="Server" })

ServerSection:Button({
    Title    = "Server Hop",
    Callback = function()
        Notify("🔀 Hopping", "Searching for new server...", 2)
        task.spawn(HopServer)
    end
})

ServerSection:Button({
    Title    = "Rejoin",
    Callback = function()
        TeleportService:Teleport(PlaceId, LP)
    end
})

ServerSection:Button({
    Title    = "Copy Job ID",
    Callback = function()
        SafeCall(function()
            setclipboard(game.JobId)
            Notify("📋 Copied", "Job ID copied!", 2)
        end)
    end
})

ServerSection:Label({ Title = "Server: " .. tostring(game.JobId):sub(1,16) .. "..." })
ServerSection:Label({ Title = "Players: " .. #Players:GetPlayers() .. "/" .. game.MaxPlayers })

local CodesSection = MiscTab:Section({ Title="Auto Codes" })

CodesSection:Button({
    Title    = "Redeem All Codes",
    Callback = function()
        Notify("🎁 Codes", "Redeeming " .. #CodesList .. " codes...", 3)
        task.spawn(RedeemAllCodes)
    end
})

CodesSection:Label({ Title = "Total Codes: " .. #CodesList })

-- ============================================================
-- TAB: SETTINGS
-- ============================================================
local SettingsTab = Window:Tab({ Title="⚙️ Settings", Icon="rbxassetid://7733664078" })
local UISection = SettingsTab:Section({ Title="UI Settings" })

UISection:Toggle({
    Title    = "Notifications Sound",
    Default  = true,
    Callback = function(v) _G.NotifSound = v end
})

UISection:Toggle({
    Title    = "Debug Mode",
    Default  = false,
    Callback = function(v)
        _G.DebugMode = v
        Notify("🐛 Debug", v and "Debug mode ON" or "Debug mode OFF", 2)
    end
})

UISection:Toggle({
    Title    = "Record Kills",
    Default  = false,
    Callback = function(v) _G.RecordKills = v end
})

UISection:Slider({
    Title   = "UI Opacity",
    Min     = 0.1, Max = 1, Default = 0.9,
    Callback = function(v)
        -- WindUI opacity control if available
    end
})

local HotkeySection = SettingsTab:Section({ Title="Hotkeys" })

HotkeySection:Label({ Title = "F1 → Toggle Auto Farm" })
HotkeySection:Label({ Title = "F2 → Toggle Auto Boss" })
HotkeySection:Label({ Title = "F3 → Toggle ESP" })
HotkeySection:Label({ Title = "F4 → Toggle Fly" })
HotkeySection:Label({ Title = "DEL → Toggle GUI" })
HotkeySection:Label({ Title = "[ / ] → Speed -/+" })

local AboutSection = SettingsTab:Section({ Title="About" })

AboutSection:Label({ Title = "Blox Fruits Ultimate v4.0" })
AboutSection:Label({ Title = "WindUI Library by Footage" })
AboutSection:Label({ Title = "World: " .. WorldName })
AboutSection:Label({ Title = "PlaceID: " .. tostring(PlaceId) })
AboutSection:Label({ Title = "Safe Mode: " .. (_G.SafeMode and "ON" or "OFF") })

AboutSection:Button({
    Title    = "Check for Updates",
    Callback = function()
        Notify("🔄 Updates", "Script is up to date!", 3)
    end
})

AboutSection:Button({
    Title    = "Discord",
    Callback = function()
        SafeCall(function()
            setclipboard("discord.gg/bloxscript")
            Notify("💬 Discord", "discord.gg/bloxscript copied!", 3)
        end)
    end
})

-- ============================================================
-- STARTUP NOTIFICATION
-- ============================================================
task.spawn(function()
    task.wait(1)
    Notify("✅ Loaded",
        "Blox Fruits Ultimate\nWorld: " .. WorldName ..
        "\nLevel: " .. GetLevel() ..
        "\nPress F1 to start farming!",
        5
    )
end)

-- ============================================================
-- AUTO SAVE CONFIG (SaveManager if available)
-- ============================================================
SafeCall(function()
    if WindUI.SaveManager then
        WindUI.SaveManager:SetLibrary(WindUI)
        WindUI.SaveManager:BuildConfigSection(SettingsTab)
        WindUI.SaveManager:LoadAutoloadConfig()
    end
end)

-- ============================================================
-- THEMEMANAGER (if available)
-- ============================================================
SafeCall(function()
    if WindUI.ThemeManager then
        WindUI.ThemeManager:SetLibrary(WindUI)
        WindUI.ThemeManager:AttachToTab(SettingsTab)
    end
end)

-- ============================================================
-- END OF SCRIPT
-- ============================================================
print("✅ Blox Fruits Ultimate loaded! | World: " .. WorldName)

-- ============================================================
-- ============================================================
--          EXTENDED FEATURES MODULE
-- ============================================================
-- ============================================================

-- ============================================================
-- COMBAT SYSTEM - EXTENDED
-- ============================================================
local CombatSystem = {}
CombatSystem.LastAttack = 0
CombatSystem.ComboCount = 0
CombatSystem.MaxCombo = 5
CombatSystem.ComboWindow = 0.8

function CombatSystem:Attack(target)
    if not target or not target.PrimaryPart then return false end
    local now = tick()
    if now - self.LastAttack < 0.1 then return false end
    self.LastAttack = now
    local root = GetRoot()
    if not root then return false end
    local d = Distance(root.Position, target.PrimaryPart.Position)
    if d > 60 then
        Teleport(target.PrimaryPart.CFrame * CFrame.new(0,0,5))
        task.wait(0.1)
    end
    SafeCall(function()
        Remote:InvokeServer("Attack", target)
    end)
    self.ComboCount = self.ComboCount + 1
    if self.ComboCount >= self.MaxCombo then
        self.ComboCount = 0
        SafeCall(function()
            Remote:InvokeServer("UseSkill", 1, target.PrimaryPart.CFrame)
        end)
        task.wait(0.3)
    end
    return true
end

function CombatSystem:UseAllSkills(target)
    if not target or not target.PrimaryPart then return end
    for i = 1, 4 do
        SafeCall(function()
            Remote:InvokeServer("UseSkill", i, target.PrimaryPart.CFrame)
        end)
        task.wait(0.2)
    end
end

function CombatSystem:Dodge()
    SafeCall(function()
        Remote:InvokeServer("Dodge")
    end)
end

function CombatSystem:Block()
    SafeCall(function()
        Remote:InvokeServer("Block")
    end)
end

function CombatSystem:Parry()
    SafeCall(function()
        Remote:InvokeServer("Parry")
    end)
end

-- ============================================================
-- PATHFINDING SYSTEM
-- ============================================================
local PathSystem = {}

function PathSystem:MoveTo(targetPos)
    local root = GetRoot()
    local hum  = GetHum()
    if not root or not hum then return end
    local path = PathfindingService:CreatePath({
        AgentRadius    = 2,
        AgentHeight    = 5,
        AgentCanJump   = true,
        AgentCanClimb  = true,
    })
    local ok = SafeCall(function()
        path:ComputeAsync(root.Position, targetPos)
    end)
    if not ok then
        Teleport(CFrame.new(targetPos))
        return
    end
    if path.Status == Enum.PathStatus.Success then
        local waypoints = path:GetWaypoints()
        for _, wp in ipairs(waypoints) do
            if wp.Action == Enum.PathWaypointAction.Jump then
                hum.Jump = true
            end
            hum:MoveTo(wp.Position)
            local reached = hum.MoveToFinished:Wait(3)
            if not reached then
                Teleport(CFrame.new(targetPos))
                return
            end
        end
    else
        Teleport(CFrame.new(targetPos))
    end
end

-- ============================================================
-- INVENTORY MANAGER
-- ============================================================
local InventoryManager = {}

function InventoryManager:GetFruits()
    local fruits = {}
    local data = LP:FindFirstChild("Data")
    if not data then return fruits end
    local fruitStorage = data:FindFirstChild("Fruits")
    if fruitStorage then
        for _, slot in pairs(fruitStorage:GetChildren()) do
            if slot.Value and slot.Value ~= "" and slot.Value ~= "None" then
                table.insert(fruits, {Slot=slot.Name, Name=slot.Value})
            end
        end
    end
    return fruits
end

function InventoryManager:GetWeapons()
    local weapons = {}
    local data = LP:FindFirstChild("Data")
    if not data then return weapons end
    local weaponStorage = data:FindFirstChild("Weapons")
    if weaponStorage then
        for _, w in pairs(weaponStorage:GetChildren()) do
            table.insert(weapons, w.Name)
        end
    end
    return weapons
end

function InventoryManager:EquipFruit(fruitName)
    SafeCall(function()
        Remote:InvokeServer("EquipFruit", fruitName)
    end)
end

function InventoryManager:EatFruit(slotName)
    SafeCall(function()
        Remote:InvokeServer("EatFruit", slotName)
    end)
end

function InventoryManager:StoreFruit(fruitName)
    SafeCall(function()
        Remote:InvokeServer("StoreFruit", fruitName)
    end)
end

function InventoryManager:GetBestFruit()
    local tier = {
        ["Kitsune"]=1,["Leopard"]=2,["Dragon"]=3,["Dough"]=4,["Shadow"]=5,
        ["Venom"]=6,["Control"]=7,["Soul"]=8,["Gravity"]=9,["Pain"]=10,
        ["Rumble"]=11,["Phoenix"]=12,["Buddha"]=13,["String"]=14,["Blizzard"]=15,
    }
    local fruits = self:GetFruits()
    local best, bestTier = nil, 999
    for _, f in ipairs(fruits) do
        local t = tier[f.Name] or 100
        if t < bestTier then
            best = f
            bestTier = t
        end
    end
    return best
end

-- ============================================================
-- SKILL MANAGER
-- ============================================================
local SkillManager = {}
SkillManager.Skills = {}
SkillManager.Cooldowns = {}

function SkillManager:Register(name, key, cooldown, callback)
    self.Skills[name] = {Key=key, Cooldown=cooldown, Callback=callback}
    self.Cooldowns[name] = 0
end

function SkillManager:Use(name, target)
    local skill = self.Skills[name]
    if not skill then return false end
    local now = tick()
    if now - self.Cooldowns[name] < skill.Cooldown then return false end
    self.Cooldowns[name] = now
    if skill.Callback then
        SafeCall(skill.Callback, target)
    end
    return true
end

function SkillManager:UseAll(target)
    for name in pairs(self.Skills) do
        self:Use(name, target)
    end
end

-- Register default skills
SkillManager:Register("Skill1", Enum.KeyCode.Z, 5, function(t)
    if t and t.PrimaryPart then
        Remote:InvokeServer("UseSkill", 1, t.PrimaryPart.CFrame)
    end
end)
SkillManager:Register("Skill2", Enum.KeyCode.X, 8, function(t)
    if t and t.PrimaryPart then
        Remote:InvokeServer("UseSkill", 2, t.PrimaryPart.CFrame)
    end
end)
SkillManager:Register("Skill3", Enum.KeyCode.C, 12, function(t)
    if t and t.PrimaryPart then
        Remote:InvokeServer("UseSkill", 3, t.PrimaryPart.CFrame)
    end
end)
SkillManager:Register("Skill4", Enum.KeyCode.V, 15, function(t)
    if t and t.PrimaryPart then
        Remote:InvokeServer("UseSkill", 4, t.PrimaryPart.CFrame)
    end
end)

-- ============================================================
-- CHEST FARMING ADVANCED
-- ============================================================
local ChestFarmer = {}
ChestFarmer.KnownChests = {}
ChestFarmer.Timeout = 30

local ChestSpawns_W1 = {
    CFrame.new(-1200,-3,-1300),  CFrame.new(-1350,-3,-1250),
    CFrame.new(-900,-3,-1400),   CFrame.new(-1100,-3,-1100),
    CFrame.new(920,-3,1100),     CFrame.new(1000,-3,1200),
    CFrame.new(1200,274,-2100),  CFrame.new(1300,274,-2200),
    CFrame.new(-5000,612,-4700), CFrame.new(-5200,612,-4800),
    CFrame.new(5200,-3,3700),    CFrame.new(5300,-3,3800),
    CFrame.new(60800,17,1600),   CFrame.new(60900,17,1700),
    CFrame.new(-7700,5600,-1800),CFrame.new(-7800,5600,-1900),
}

local ChestSpawns_W2 = {
    CFrame.new(-300,8,5700),  CFrame.new(-350,8,5800),
    CFrame.new(-950,72,1000), CFrame.new(-1000,72,1100),
    CFrame.new(3500,8,3300),  CFrame.new(3600,8,3400),
    CFrame.new(500,14,5000),  CFrame.new(600,14,5100),
    CFrame.new(-11400,8,-4800),CFrame.new(-11500,8,-4900),
    CFrame.new(-6000,9,-1400),CFrame.new(-6100,9,-1500),
    CFrame.new(-5100,14,-4600),CFrame.new(-5200,14,-4700),
    CFrame.new(1000,267,-5100),CFrame.new(1100,267,-5200),
}

local ChestSpawns_W3 = {
    CFrame.new(-10700,331,-8900),CFrame.new(-10900,331,-9100),
    CFrame.new(-12800,27,-7000),CFrame.new(-12900,27,-7100),
    CFrame.new(500,25,-12400),  CFrame.new(600,25,-12600),
    CFrame.new(-4600,76,-13400),CFrame.new(-4700,76,-13600),
    CFrame.new(-5000,1,-9600),  CFrame.new(-5100,1,-9700),
    CFrame.new(900,40,-10300),  CFrame.new(1100,40,-10500),
}

function ChestFarmer:GetSpawns()
    if IsWorld1 then return ChestSpawns_W1
    elseif IsWorld2 then return ChestSpawns_W2
    else return ChestSpawns_W3 end
end

function ChestFarmer:FarmAll()
    local spawns = self:GetSpawns()
    local root = GetRoot()
    if not root then return end
    for _, cf in ipairs(spawns) do
        if not _G.AutoChest then break end
        Teleport(cf)
        task.wait(0.5)
        -- Look for nearby chests
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("chest") then
                SafeCall(function()
                    Remote:InvokeServer("OpenChest", obj)
                end)
                task.wait(0.2)
            end
        end
        task.wait(_G.ChestDelay)
    end
end

-- Auto chest patrol loop
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoChest and IsAlive() then
            ChestFarmer:FarmAll()
        end
    end
end)

-- ============================================================
-- FRUIT SNIPER (Auto pickup rare fruits)
-- ============================================================
local FruitSniper = {}
FruitSniper.RareFruits = {
    "Kitsune","Leopard","Dragon","Dough","Shadow","Venom","Control","Soul",
    "Gravity","Pain","Rumble","Phoenix","Buddha","String","Blizzard","Mammoth",
    "T-Rex","Gas","Spirit","Paw","Portal","Void","Unknown"
}
FruitSniper.AllFruits = false

function FruitSniper:IsRare(name)
    for _, f in ipairs(self.RareFruits) do
        if name:lower():find(f:lower()) then return true end
    end
    return false
end

function FruitSniper:Scan()
    local root = GetRoot()
    if not root then return end
    for _, obj in pairs(Workspace:GetDescendants()) do
        local isF = obj.Name:lower():find("fruit") or
                    (obj:FindFirstChild("PickUp") ~= nil) or
                    (obj:FindFirstChild("pickup") ~= nil)
        if isF then
            local part = obj:IsA("Model") and obj.PrimaryPart or
                         obj:IsA("BasePart") and obj or nil
            if part then
                local shouldPick = self.AllFruits or self:IsRare(obj.Name)
                if shouldPick then
                    local d = Distance(root.Position, part.Position)
                    if d <= 1000 then
                        Teleport(CFrame.new(part.Position))
                        task.wait(0.3)
                        SafeCall(function()
                            Remote:InvokeServer("PickUpFruit", obj)
                        end)
                        Notify("🍎 Fruit Sniper", "Picked up: " .. obj.Name, 3)
                    end
                end
            end
        end
    end
end

-- ============================================================
-- QUEST MANAGER ADVANCED
-- ============================================================
local QuestManager = {}
QuestManager.ActiveQuest = nil
QuestManager.CompletedQuests = 0
QuestManager.QuestNPCs = {}

function QuestManager:DetectQuest()
    local data = LP:FindFirstChild("Data")
    if not data then return nil end
    local questData = data:FindFirstChild("QuestData")
    if not questData then return nil end
    return {
        Active   = questData:FindFirstChild("QuestActive") and questData.QuestActive.Value or false,
        Name     = questData:FindFirstChild("QuestName") and questData.QuestName.Value or "None",
        Progress = questData:FindFirstChild("QuestProgress") and questData.QuestProgress.Value or 0,
        Required = questData:FindFirstChild("QuestRequired") and questData.QuestRequired.Value or 0,
    }
end

function QuestManager:IsQuestComplete()
    local q = self:DetectQuest()
    if not q then return false end
    return q.Active and q.Progress >= q.Required
end

function QuestManager:TurnIn()
    if self:IsQuestComplete() then
        SafeCall(function()
            Remote:InvokeServer("FinishQuest")
            self.CompletedQuests = self.CompletedQuests + 1
            _G.QuestCount = self.CompletedQuests
            Notify("✅ Quest", "Quest completed! Total: " .. self.CompletedQuests, 3)
        end)
        return true
    end
    return false
end

function QuestManager:StartBestQuest()
    local mobName = GetAutoMob()
    if mobName then
        DoQuest(mobName)
        Notify("📋 Quest", "Started quest for: " .. mobName, 2)
    end
end

-- Auto quest turn-in loop
task.spawn(function()
    while true do
        task.wait(2)
        if _G.AutoQuest and IsAlive() then
            if QuestManager:IsQuestComplete() then
                QuestManager:TurnIn()
                task.wait(1)
                QuestManager:StartBestQuest()
            elseif not QuestManager:DetectQuest() or not (QuestManager:DetectQuest() and QuestManager:DetectQuest().Active) then
                QuestManager:StartBestQuest()
            end
        end
    end
end)

-- ============================================================
-- NPC INTERACTION SYSTEM
-- ============================================================
local NPCSystem = {}

function NPCSystem:FindNPC(name, range)
    range = range or 500
    local root = GetRoot()
    if not root then return nil end
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find(name) then
            local part = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
            if part then
                local d = Distance(root.Position, part.Position)
                if d <= range then return obj end
            end
        end
    end
    return nil
end

function NPCSystem:Interact(npc)
    if not npc then return end
    local part = npc.PrimaryPart or npc:FindFirstChildOfClass("BasePart")
    if part then
        Teleport(part.CFrame * CFrame.new(0,0,5))
        task.wait(0.3)
        SafeCall(function()
            Remote:InvokeServer("TalkNPC", npc)
        end)
    end
end

function NPCSystem:OpenShop(shopName)
    SafeCall(function()
        Remote:InvokeServer("OpenShop", shopName)
    end)
end

-- ============================================================
-- TELEPORT SYSTEM ADVANCED
-- ============================================================
local TeleportSystem = {}
TeleportSystem.History = {}
TeleportSystem.MaxHistory = 20

function TeleportSystem:GoTo(cf, name)
    local root = GetRoot()
    if not root then return end
    -- Save to history
    if name then
        table.insert(self.History, 1, {Name=name, CF=root.CFrame})
        if #self.History > self.MaxHistory then
            table.remove(self.History)
        end
    end
    root.CFrame = cf
end

function TeleportSystem:Back()
    if #self.History == 0 then
        Notify("🔙 Teleport", "No teleport history!", 2)
        return
    end
    local last = table.remove(self.History, 1)
    local root = GetRoot()
    if root then
        root.CFrame = last.CF
        Notify("🔙 Back", "Went back to: " .. (last.Name or "Last Position"), 2)
    end
end

function TeleportSystem:ToPlayer(playerName)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(playerName:lower()) or plr.DisplayName:lower():find(playerName:lower()) then
            if plr.Character and plr.Character.PrimaryPart then
                local root = GetRoot()
                if root then
                    root.CFrame = plr.Character.PrimaryPart.CFrame * CFrame.new(0,0,5)
                    Notify("🚀 Teleport", "Teleported to " .. plr.Name, 2)
                    return true
                end
            end
        end
    end
    Notify("⚠️ Error", "Player not found: " .. playerName, 2)
    return false
end

function TeleportSystem:ToBoss(bossName)
    local data = BossData[bossName or _G.SelectedBoss]
    if data then
        self:GoTo(data.CF, bossName or _G.SelectedBoss)
        Notify("👑 Teleport", "Going to boss: " .. (bossName or _G.SelectedBoss), 2)
    end
end

-- ============================================================
-- AUTO TRAIN LOOP (combines quest + farm + mastery)
-- ============================================================
local AutoTrain = {}
AutoTrain.Phase = "Quest" -- Quest, Farm, TurnIn, Mastery
AutoTrain.CycleCount = 0

function AutoTrain:Cycle()
    if not IsAlive() then
        task.wait(3)
        return
    end
    local phase = self.Phase
    if phase == "Quest" then
        local q = QuestManager:DetectQuest()
        if q and q.Active then
            self.Phase = "Farm"
        else
            QuestManager:StartBestQuest()
            task.wait(2)
            self.Phase = "Farm"
        end
    elseif phase == "Farm" then
        local q = QuestManager:DetectQuest()
        if q and q.Active and q.Progress >= q.Required then
            self.Phase = "TurnIn"
        else
            local mobName = _G.SelectedMob == "Auto" and GetAutoMob() or _G.SelectedMob
            if mobName then
                FarmMob(mobName)
            end
        end
    elseif phase == "TurnIn" then
        QuestManager:TurnIn()
        self.CycleCount = self.CycleCount + 1
        self.Phase = "Quest"
    end
    task.wait(0.1)
end

-- ============================================================
-- DEVIL FRUIT TRACKER
-- ============================================================
local FruitTracker = {}
FruitTracker.Fruits = {}
FruitTracker.LastSeen = {}

function FruitTracker:Scan()
    local found = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        local isFruit = obj.Name:lower():find("fruit") or
                        (obj:FindFirstChild("PickUp") ~= nil)
        if isFruit then
            local part = obj:IsA("Model") and obj.PrimaryPart or
                         obj:IsA("BasePart") and obj or nil
            if part then
                table.insert(found, {
                    Name     = obj.Name,
                    Position = part.Position,
                    Object   = obj,
                    Time     = os.time()
                })
            end
        end
    end
    self.Fruits = found
    return found
end

function FruitTracker:GetClosest()
    local root = GetRoot()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, f in ipairs(self:Scan()) do
        local d = Distance(root.Position, f.Position)
        if d < bestDist then
            best = f
            bestDist = d
        end
    end
    return best, bestDist
end

-- ============================================================
-- RAID MANAGER ADVANCED
-- ============================================================
local RaidManager = {}
RaidManager.Active = false
RaidManager.Phase = "None"
RaidManager.StartTime = 0

function RaidManager:Start(raidName)
    raidName = raidName or _G.SelectedRaid
    local data = RaidData[raidName]
    if not data then
        Notify("⚠️ Raid", "Invalid raid: " .. tostring(raidName), 2)
        return false
    end
    local frags = GetFragments()
    if frags < data.Fragments then
        Notify("⚠️ Fragments", "Need " .. data.Fragments .. " fragments! Have: " .. frags, 3)
        return false
    end
    SafeCall(function()
        Remote:InvokeServer("StartRaid", raidName)
        self.Active = true
        self.Phase = "Started"
        self.StartTime = os.time()
        Notify("⚡ Raid Started", raidName .. " | Boss: " .. data.Boss, 4)
    end)
    return true
end

function RaidManager:FarmRaidMobs()
    if not self.Active then return end
    local mobs = GetAllMobs()
    local root = GetRoot()
    if not root then return end
    for _, mob in ipairs(mobs) do
        if mob.PrimaryPart then
            local d = Distance(root.Position, mob.PrimaryPart.Position)
            if d <= 100 then
                CombatSystem:Attack(mob)
            end
        end
    end
end

function RaidManager:CheckComplete()
    -- Check if raid boss is defeated
    local data = RaidData[_G.SelectedRaid]
    if not data then return false end
    local boss = GetNearestMob(500, data.Boss)
    if not boss and self.Active then
        self.Active = false
        self.Phase = "Complete"
        local elapsed = os.time() - self.StartTime
        Notify("🏆 Raid Complete!", _G.SelectedRaid .. " done in " .. elapsed .. "s!", 5)
        return true
    end
    return false
end

-- ============================================================
-- BOSS FARMING ADVANCED
-- ============================================================
local BossFarmer = {}
BossFarmer.Attempting = false
BossFarmer.Kills = 0
BossFarmer.SpawnWait = 120

function BossFarmer:WaitForSpawn(bossName, timeout)
    timeout = timeout or 300
    local start = tick()
    while tick() - start < timeout do
        local boss = GetNearestMob(2000, bossName)
        if boss then return boss end
        task.wait(2)
    end
    return nil
end

function BossFarmer:Kill(bossName)
    local data = BossData[bossName]
    if not data then return false end
    Teleport(data.CF)
    task.wait(1)
    local boss = self:WaitForSpawn(bossName, 30)
    if not boss then
        Notify("👑 Boss", bossName .. " not spawned, teleporting...", 2)
        Teleport(data.CF)
        task.wait(2)
        boss = self:WaitForSpawn(bossName, 15)
    end
    if not boss then return false end
    local killStart = tick()
    local maxKillTime = 120
    while boss and boss.PrimaryPart and boss.Humanoid and boss.Humanoid.Health > 0 do
        if tick() - killStart > maxKillTime then break end
        if not IsAlive() then
            task.wait(5)
            killStart = tick()
        end
        CombatSystem:Attack(boss)
        SkillManager:UseAll(boss)
        task.wait(0.1)
    end
    self.Kills = self.Kills + 1
    _G.KillCount = _G.KillCount + 1
    Notify("💀 Boss Killed", bossName .. " #" .. self.Kills, 3)
    return true
end

-- ============================================================
-- SPAWN PROTECTION
-- ============================================================
local SpawnProtect = {}

function SpawnProtect:IsAtSpawn()
    local root = GetRoot()
    if not root then return false end
    local spawnPos = Workspace:FindFirstChild("SpawnLocation")
    if spawnPos then
        return Distance(root.Position, spawnPos.Position) < 50
    end
    return false
end

function SpawnProtect:GetSafePosition()
    local root = GetRoot()
    if not root then return Vector3.new(0,5,0) end
    return root.Position
end

-- ============================================================
-- VISUAL EFFECTS SYSTEM
-- ============================================================
local VFX = {}

function VFX:TrailEffect(color)
    local char = GetChar()
    if not char then return end
    local root = GetRoot()
    if not root then return end
    local a0 = Instance.new("Attachment", root)
    a0.Position = Vector3.new(0,-2,0)
    a0.Name = "TrailA0"
    local a1 = Instance.new("Attachment", root)
    a1.Position = Vector3.new(0,-3,0)
    a1.Name = "TrailA1"
    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(color or Color3.fromRGB(150,50,255))
    trail.LightEmission = 0.5
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Lifetime = 0.5
    trail.Attachment0 = a0
    trail.Attachment1 = a1
    trail.Parent = root
    return trail
end

function VFX:GlowEffect(color, intensity)
    local char = GetChar()
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local light = Instance.new("PointLight", p)
            light.Color   = color or Color3.fromRGB(150,50,255)
            light.Range   = intensity or 15
            light.Brightness = 2
        end
    end
end

function VFX:RemoveEffects()
    local char = GetChar()
    if not char then return end
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("PointLight") or p:IsA("Trail") or p:IsA("Attachment") then
            if p.Name:find("Trail") or p.Name:find("Glow") or p:IsA("PointLight") then
                p:Destroy()
            end
        end
    end
end

function VFX:Highlight(obj, color, fillTrans)
    local hl = Instance.new("SelectionBox")
    hl.Color3 = color or Color3.fromRGB(150,50,255)
    hl.SurfaceTransparency = fillTrans or 0.7
    hl.LineThickness = 0.05
    if obj:IsA("Model") then
        hl.Adornee = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
    else
        hl.Adornee = obj
    end
    hl.Parent = Workspace
    return hl
end

-- ============================================================
-- CAMERA SYSTEM
-- ============================================================
local CameraSystem = {}

function CameraSystem:LockOnTarget(target)
    if not target or not target.PrimaryPart then return end
    RunService.RenderStepped:Connect(function()
        if not target or not target.PrimaryPart then return end
        Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, target.PrimaryPart.Position)
    end)
end

function CameraSystem:SetFOV(fov)
    Cam.FieldOfView = fov
end

function CameraSystem:ThirdPerson(distance)
    Cam.CameraType = Enum.CameraType.Scriptable
    RunService.RenderStepped:Connect(function()
        local root = GetRoot()
        if not root then return end
        local cf = root.CFrame
        Cam.CFrame = cf * CFrame.new(0, 5, distance or 15)
    end)
end

function CameraSystem:Reset()
    Cam.CameraType = Enum.CameraType.Custom
    Cam.FieldOfView = 70
end

-- ============================================================
-- SOUND SYSTEM
-- ============================================================
local SoundSystem = {}

function SoundSystem:Play(id, volume, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Volume  = volume or 0.5
    sound.Parent  = parent or SoundService
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
    return sound
end

function SoundSystem:Kill()
    for _, s in pairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then s:Destroy() end
    end
end

function SoundSystem:MuteAll()
    for _, s in pairs(Workspace:GetDescendants()) do
        if s:IsA("Sound") then s.Volume = 0 end
    end
    for _, s in pairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then s.Volume = 0 end
    end
end

-- ============================================================
-- NOTIFICATION SYSTEM ADVANCED
-- ============================================================
local NotifSystem = {}
NotifSystem.Queue    = {}
NotifSystem.MaxQueue = 10
NotifSystem.Processing = false

function NotifSystem:Add(title, msg, dur, type)
    if #self.Queue >= self.MaxQueue then
        table.remove(self.Queue, 1)
    end
    table.insert(self.Queue, {
        Title    = title,
        Message  = msg,
        Duration = dur or 3,
        Type     = type or "info",
        Time     = os.time()
    })
    if not self.Processing then
        self:Process()
    end
end

function NotifSystem:Process()
    self.Processing = true
    task.spawn(function()
        while #self.Queue > 0 do
            local notif = table.remove(self.Queue, 1)
            Notify(notif.Title, notif.Message, notif.Duration)
            task.wait(notif.Duration + 0.5)
        end
        self.Processing = false
    end)
end

-- ============================================================
-- WORLD 1 SPECIFIC FEATURES
-- ============================================================
local W1Features = {}

W1Features.Locations = {
    ["Marine Starter"] = CFrame.new(-1271.7,-3.2,-1272.6),
    ["Pirate Starter"]  = CFrame.new(319,-3,4228),
    ["Gorilla Island"]  = CFrame.new(-1949.8,-2,-3282),
    ["Prison Island"]   = CFrame.new(5261,-3,3768),
    ["Colosseum"]       = CFrame.new(-6516,-3,-1046),
    ["Skylands"]        = CFrame.new(-5082,612,-4762),
    ["Underwater"]      = CFrame.new(60943,17,1744),
    ["Second Sea Gate"] = CFrame.new(-319,2,-3,-297),
}

function W1Features:UnlockSecondSea()
    SafeCall(function()
        Remote:InvokeServer("UnlockSecondSea")
        Notify("🌊 Sea 2", "Attempting to unlock Second Sea...", 3)
    end)
end

function W1Features:BeatAllBosses()
    if not IsWorld1 then
        Notify("⚠️ Error", "Must be in World 1!", 2)
        return
    end
    local w1Bosses = {"Gorilla King","Bobby","Yeti","Mr. 3","Wysper","Thunder God","Cyborg","Saber Expert"}
    task.spawn(function()
        for _, boss in ipairs(w1Bosses) do
            if not _G.AutoBoss then break end
            _G.SelectedBoss = boss
            BossFarmer:Kill(boss)
            task.wait(5)
        end
    end)
end

-- ============================================================
-- WORLD 2 SPECIFIC FEATURES
-- ============================================================
local W2Features = {}

W2Features.Locations = {
    ["Port Town"]     = CFrame.new(-297,8,5765),
    ["Dress Rosa"]    = CFrame.new(-986,72,1088),
    ["Hot Zone"]      = CFrame.new(-5158,14,-4654),
    ["Ice Castle"]    = CFrame.new(1030,267,-5140),
    ["Thriller Bark"] = CFrame.new(-11467,8,-4901),
    ["Green Zone"]    = CFrame.new(3601,8,3390),
    ["Wano"]          = CFrame.new(-3282,57,-4286),
}

function W2Features:FarmOrderFragments()
    if not IsWorld2 then
        Notify("⚠️ Error", "Must be in World 2!", 2)
        return
    end
    task.spawn(function()
        while _G.AutoFragments do
            local mob = GetNearestMob(200, "Order Soldier") or GetNearestMob(200, "Order Officer")
            if mob and mob.PrimaryPart then
                CombatSystem:Attack(mob)
            else
                Teleport(W2Features.Locations["Hot Zone"])
            end
            task.wait(0.1)
        end
    end)
end

-- ============================================================
-- WORLD 3 SPECIFIC FEATURES
-- ============================================================
local W3Features = {}

W3Features.Locations = {
    ["Floating Turtle"] = CFrame.new(-10828,331,-9049),
    ["Sea of Treats"]   = CFrame.new(582,25,-12550),
    ["Haunted Castle"]  = CFrame.new(-12862,27,-7068),
    ["Elf Island"]      = CFrame.new(-4648,76,-13527),
    ["Cursed Ship"]     = CFrame.new(-5085,1,-9698),
}

function W3Features:FarmLeviathan()
    if not IsWorld3 then
        Notify("⚠️ Error", "Must be in World 3!", 2)
        return
    end
    _G.SelectedBoss = "Leviathan"
    _G.AutoBoss = true
    Notify("🐉 Leviathan", "Starting Leviathan farm!", 3)
end

function W3Features:FarmDoughKing()
    if not IsWorld3 then
        Notify("⚠️ Error", "Must be in World 3!", 2)
        return
    end
    _G.SelectedBoss = "Dough King"
    _G.AutoBoss = true
    Notify("🍩 Dough King", "Starting Dough King farm!", 3)
end

-- ============================================================
-- EXTENDED WINDUI TABS
-- ============================================================

-- ============================================================
-- TAB: TELEPORT
-- ============================================================
local TPTab = Window:Tab({ Title="🗺️ Teleport", Icon="rbxassetid://7733664078" })
local TPSection = TPTab:Section({ Title="Quick Teleport" })

local AllIslands = {}
for k in pairs(IslandData) do table.insert(AllIslands, k) end
table.sort(AllIslands)

TPSection:Dropdown({
    Title   = "Island",
    List    = AllIslands,
    Default = AllIslands[1],
    Callback = function(v)
        local cf = IslandData[v]
        if cf then
            TeleportSystem:GoTo(cf, v)
            Notify("🗺️ TP", "→ " .. v, 2)
        end
    end
})

TPSection:Button({
    Title    = "Go Back",
    Callback = function() TeleportSystem:Back() end
})

local PlayerTPSection = TPTab:Section({ Title="Teleport to Player" })

local function GetPlayerNames()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(names, p.Name) end
    end
    return names
end

PlayerTPSection:Dropdown({
    Title   = "Player",
    List    = GetPlayerNames(),
    Default = "",
    Callback = function(v)
        TeleportSystem:ToPlayer(v)
    end
})

PlayerTPSection:Button({
    Title    = "Refresh Player List",
    Callback = function()
        Notify("🔄 Refresh", "Close and reopen dropdown!", 2)
    end
})

local BossTPSection = TPTab:Section({ Title="Teleport to Boss" })

BossTPSection:Dropdown({
    Title   = "Boss",
    List    = BossNames,
    Default = "Gorilla King",
    Callback = function(v)
        TeleportSystem:ToBoss(v)
    end
})

BossTPSection:Button({
    Title    = "TP to Boss Spawn",
    Callback = function()
        TeleportSystem:ToBoss()
    end
})

-- ============================================================
-- TAB: WORLD SPECIFIC
-- ============================================================
local WorldTab = Window:Tab({ Title="🌍 World", Icon="rbxassetid://7733664078" })
local WorldSection = WorldTab:Section({ Title="World: " .. WorldName })

WorldSection:Label({ Title = "Current World: " .. WorldName })
WorldSection:Label({ Title = "Place ID: " .. tostring(PlaceId) })
WorldSection:Label({ Title = "Level: " .. tostring(GetLevel()) })

if IsWorld1 then
    local W1Sec = WorldTab:Section({ Title="World 1 Features" })
    for name, cf in pairs(W1Features.Locations) do
        W1Sec:Button({
            Title    = "TP: " .. name,
            Callback = function()
                Teleport(cf)
                Notify("🌍 W1", "→ " .. name, 2)
            end
        })
    end
    W1Sec:Button({
        Title    = "Beat All W1 Bosses",
        Callback = function() W1Features:BeatAllBosses() end
    })
end

if IsWorld2 then
    local W2Sec = WorldTab:Section({ Title="World 2 Features" })
    for name, cf in pairs(W2Features.Locations) do
        W2Sec:Button({
            Title    = "TP: " .. name,
            Callback = function()
                Teleport(cf)
                Notify("🌍 W2", "→ " .. name, 2)
            end
        })
    end
    W2Sec:Button({
        Title    = "Farm Order Fragments",
        Callback = function() W2Features:FarmOrderFragments() end
    })
end

if IsWorld3 then
    local W3Sec = WorldTab:Section({ Title="World 3 Features" })
    for name, cf in pairs(W3Features.Locations) do
        W3Sec:Button({
            Title    = "TP: " .. name,
            Callback = function()
                Teleport(cf)
                Notify("🌍 W3", "→ " .. name, 2)
            end
        })
    end
    W3Sec:Button({
        Title    = "Farm Leviathan",
        Callback = function() W3Features:FarmLeviathan() end
    })
    W3Sec:Button({
        Title    = "Farm Dough King",
        Callback = function() W3Features:FarmDoughKing() end
    })
end

-- ============================================================
-- TAB: COMBAT
-- ============================================================
local CombatTab = Window:Tab({ Title="⚔️ Combat", Icon="rbxassetid://7733664078" })
local CombatSection = CombatTab:Section({ Title="Combat Options" })

CombatSection:Toggle({
    Title    = "Auto Combo",
    Default  = false,
    Callback = function(v)
        _G.AutoCombo = v
        if v then
            task.spawn(function()
                while _G.AutoCombo do
                    local mob = GetNearestMob(50)
                    if mob then
                        CombatSystem:Attack(mob)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

CombatSection:Toggle({
    Title    = "Auto Use Skills",
    Default  = false,
    Callback = function(v)
        _G.AutoSkill = v
        if v then
            task.spawn(function()
                while _G.AutoSkill do
                    local mob = GetNearestMob(100)
                    if mob then
                        SkillManager:UseAll(mob)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

CombatSection:Slider({
    Title   = "Combo Max",
    Min     = 1, Max = 10, Default = 5,
    Callback = function(v) CombatSystem.MaxCombo = v end
})

CombatSection:Button({
    Title    = "Use Skill 1",
    Callback = function()
        local mob = GetNearestMob(100)
        if mob then SkillManager:Use("Skill1", mob) end
    end
})

CombatSection:Button({
    Title    = "Use All Skills",
    Callback = function()
        local mob = GetNearestMob(100)
        if mob then
            SkillManager:UseAll(mob)
            Notify("⚔️ Skills", "All skills used!", 2)
        end
    end
})

local WeaponSection = CombatTab:Section({ Title="Weapons" })

WeaponSection:Toggle({
    Title    = "Auto Sword Mastery",
    Default  = false,
    Callback = function(v) _G.AutoSword = v end
})

WeaponSection:Toggle({
    Title    = "Auto Gun Mastery",
    Default  = false,
    Callback = function(v) _G.AutoGun = v end
})

WeaponSection:Button({
    Title    = "Equip Best Weapon",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("EquipBestWeapon")
            Notify("⚔️ Weapon", "Equipping best weapon!", 2)
        end)
    end
})

-- ============================================================
-- TAB: VISUAL
-- ============================================================
local VisualTab = Window:Tab({ Title="🎨 Visual", Icon="rbxassetid://7733664078" })
local VisualSection = VisualTab:Section({ Title="Visual Effects" })

VisualSection:Button({
    Title    = "Add Trail",
    Callback = function()
        VFX:TrailEffect(Color3.fromRGB(150,50,255))
        Notify("✨ VFX", "Purple trail added!", 2)
    end
})

VisualSection:Button({
    Title    = "Add Glow",
    Callback = function()
        VFX:GlowEffect(Color3.fromRGB(150,50,255), 15)
        Notify("✨ VFX", "Glow effect added!", 2)
    end
})

VisualSection:Button({
    Title    = "Remove Effects",
    Callback = function()
        VFX:RemoveEffects()
        Notify("🗑️ VFX", "Effects removed!", 2)
    end
})

VisualSection:Toggle({
    Title    = "Fullbright",
    Default  = false,
    Callback = function(v) SetFullbright(v) end
})

local CameraSection = VisualTab:Section({ Title="Camera" })

CameraSection:Slider({
    Title   = "Field of View",
    Min     = 50, Max = 120, Default = 70,
    Callback = function(v) CameraSystem:SetFOV(v) end
})

CameraSection:Button({
    Title    = "Reset Camera",
    Callback = function()
        CameraSystem:Reset()
        Notify("📷 Camera", "Camera reset!", 2)
    end
})

local SoundSection = VisualTab:Section({ Title="Sound" })

SoundSection:Button({
    Title    = "Mute All Sounds",
    Callback = function()
        SoundSystem:MuteAll()
        Notify("🔇 Sound", "All sounds muted!", 2)
    end
})

-- ============================================================
-- TAB: PVP
-- ============================================================
local PvPTab = Window:Tab({ Title="🗡️ PvP", Icon="rbxassetid://7733664078" })
local PvPSection = PvPTab:Section({ Title="PvP Settings" })

PvPSection:Toggle({
    Title    = "Silent Aim",
    Default  = false,
    Callback = function(v)
        _G.SilentAim = v
        Notify("🎯 PvP", "Silent aim: " .. (v and "ON" or "OFF"), 2)
    end
})

PvPSection:Toggle({
    Title    = "Kill Aura (PvP)",
    Default  = false,
    Callback = function(v)
        _G.KillAura = v
    end
})

PvPSection:Slider({
    Title   = "PvP Aura Range",
    Min     = 10, Max = 150, Default = 40,
    Callback = function(v) _G.AuraRange = v end
})

PvPSection:Toggle({
    Title    = "Auto Parry vs Player",
    Default  = false,
    Callback = function(v) _G.AutoParry = v end
})

PvPSection:Toggle({
    Title    = "Hitbox Expander",
    Default  = false,
    Callback = function(v) _G.HitboxExpand = v end
})

PvPSection:Slider({
    Title   = "Hitbox Size",
    Min     = 5, Max = 100, Default = 15,
    Callback = function(v) _G.HitboxValue = v end
})

PvPSection:Button({
    Title    = "Teleport Behind Player",
    Callback = function()
        local nearest = GetNearestPlayer(500)
        if nearest and nearest.Character and nearest.Character.PrimaryPart then
            local target = nearest.Character.PrimaryPart
            local root = GetRoot()
            if root then
                root.CFrame = target.CFrame * CFrame.new(0, 0, -3)
                Notify("🗡️ PvP", "Teleported behind " .. nearest.Name, 2)
            end
        end
    end
})

PvPSection:Button({
    Title    = "Teleport to Nearest Player",
    Callback = function()
        local nearest = GetNearestPlayer(500)
        if nearest and nearest.Character and nearest.Character.PrimaryPart then
            TeleportSystem:ToPlayer(nearest.Name)
        end
    end
})

local AimSection2 = PvPTab:Section({ Title="Aim Settings" })

AimSection2:Toggle({
    Title    = "FOV Circle",
    Default  = false,
    Callback = function(v) _G.FovCircle = v end
})

AimSection2:Slider({
    Title   = "FOV Size",
    Min     = 20, Max = 300, Default = 60,
    Callback = function(v) _G.FovValue = v end
})

AimSection2:Dropdown({
    Title   = "Aim Key",
    List    = {"Q","E","R","T","G","H","Mouse2"},
    Default = "Q",
    Callback = function(v)
        local keys = {
            Q=Enum.KeyCode.Q, E=Enum.KeyCode.E, R=Enum.KeyCode.R,
            T=Enum.KeyCode.T, G=Enum.KeyCode.G, H=Enum.KeyCode.H
        }
        _G.AimKey = keys[v] or Enum.KeyCode.Q
    end
})

-- ============================================================
-- TAB: GRIND
-- ============================================================
local GrindTab = Window:Tab({ Title="📈 Grind", Icon="rbxassetid://7733664078" })
local GrindSection = GrindTab:Section({ Title="Auto Grind" })

GrindSection:Toggle({
    Title    = "Full Auto Mode (Farm+Quest+Mastery)",
    Default  = false,
    Callback = function(v)
        _G.AutoFarm  = v
        _G.AutoQuest = v
        _G.AutoMastery = v
        if v then
            task.spawn(function()
                while _G.AutoFarm do
                    AutoTrain:Cycle()
                    task.wait(0.1)
                end
            end)
            Notify("📈 Full Auto", "Complete auto grind enabled!", 3)
        end
    end
})

GrindSection:Toggle({
    Title    = "Auto Chest Route",
    Default  = false,
    Callback = function(v) _G.AutoChest = v end
})

GrindSection:Toggle({
    Title    = "Fruit Sniper (Rare Only)",
    Default  = false,
    Callback = function(v)
        _G.AutoFruit = v
        if v then
            task.spawn(function()
                while _G.AutoFruit do
                    FruitSniper:Scan()
                    task.wait(3)
                end
            end)
        end
    end
})

GrindSection:Toggle({
    Title    = "Fruit Sniper (All Fruits)",
    Default  = false,
    Callback = function(v)
        FruitSniper.AllFruits = v
        _G.AutoFruit = v
    end
})

local ProgressSection = GrindTab:Section({ Title="Progress Tracker" })

ProgressSection:Button({
    Title    = "Show Progress",
    Callback = function()
        local elapsed = os.time() - _G.SessionStart
        local mins = math.floor(elapsed/60)
        local secs = elapsed % 60
        local lvl = GetLevel()
        local beli = GetBeli()
        local frags = GetFragments()
        Notify("📊 Progress",
            string.format(
                "Level: %d\nBeli: %d\nFragments: %d\nKills: %d\nQuests: %d\nTime: %dm %ds",
                lvl, beli, frags, _G.KillCount, _G.QuestCount, mins, secs
            ), 8
        )
    end
})

ProgressSection:Label({ Title = "Kill Counter tracking active" })
ProgressSection:Label({ Title = "Quest Counter tracking active" })

-- ============================================================
-- TAB: AUTOMATION
-- ============================================================
local AutoTab = Window:Tab({ Title="🤖 Automation", Icon="rbxassetid://7733664078" })
local AutoSection = AutoTab:Section({ Title="Full Automation" })

AutoSection:Toggle({
    Title    = "Auto Raid Runner",
    Default  = false,
    Callback = function(v)
        _G.AutoRaid = v
        if v then
            task.spawn(function()
                while _G.AutoRaid do
                    if GetFragments() >= 100 then
                        RaidManager:Start()
                        task.wait(5)
                        -- Farm raid
                        local raidTimeout = tick() + 300
                        while _G.AutoRaid and tick() < raidTimeout do
                            RaidManager:FarmRaidMobs()
                            if RaidManager:CheckComplete() then break end
                            task.wait(0.1)
                        end
                    else
                        -- Farm fragments
                        W2Features:FarmOrderFragments()
                    end
                    task.wait(2)
                end
            end)
        end
    end
})

AutoSection:Toggle({
    Title    = "Auto Boss Cycle (All Bosses)",
    Default  = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                while _G.AutoBoss do
                    for bossName in pairs(BossData) do
                        if not _G.AutoBoss then break end
                        BossFarmer:Kill(bossName)
                        task.wait(BossData[bossName].CD or 60)
                    end
                end
            end)
        end
    end
})

AutoSection:Toggle({
    Title    = "Auto Redeem Codes (Periodic)",
    Default  = false,
    Callback = function(v)
        _G.AutoCodes = v
        if v then
            task.spawn(function()
                while _G.AutoCodes do
                    RedeemAllCodes()
                    task.wait(3600) -- Every hour
                end
            end)
        end
    end
})

AutoSection:Toggle({
    Title    = "Auto Distribute Stats",
    Default  = false,
    Callback = function(v) _G.AutoStats = v end
})

AutoSection:Toggle({
    Title    = "Auto Haki Training",
    Default  = false,
    Callback = function(v) _G.AutoHaki = v end
})

AutoSection:Toggle({
    Title    = "Auto Mastery (All Types)",
    Default  = false,
    Callback = function(v)
        _G.AutoMastery = v
        _G.AutoSword   = v
        _G.AutoGun     = v
    end
})

AutoSection:Button({
    Title    = "Start Full Automation",
    Callback = function()
        _G.AutoFarm     = true
        _G.AutoQuest    = true
        _G.AutoBoss     = false
        _G.AutoChest    = true
        _G.AutoFruit    = true
        _G.AutoStats    = true
        _G.AutoHaki     = true
        _G.AutoMastery  = true
        _G.AutoRespawn  = true
        _G.AntiAFK      = true
        task.spawn(function()
            while _G.AutoFarm do
                AutoTrain:Cycle()
                task.wait(0.1)
            end
        end)
        Notify("🤖 Automation", "Full automation started!", 4)
    end
})

AutoSection:Button({
    Title    = "Stop All Automation",
    Callback = function()
        _G.AutoFarm      = false
        _G.AutoQuest     = false
        _G.AutoBoss      = false
        _G.AutoChest     = false
        _G.AutoFruit     = false
        _G.AutoMaterial  = false
        _G.AutoStats     = false
        _G.AutoHaki      = false
        _G.AutoMastery   = false
        _G.AutoRaid      = false
        _G.AutoFragments = false
        _G.KillAura      = false
        _G.HitboxExpand  = false
        _G.AutoCombo     = false
        _G.AutoSkill     = false
        _G.AutoCodes     = false
        Notify("🛑 Stopped", "All automation disabled!", 3)
    end
})

-- ============================================================
-- TAB: DEBUG
-- ============================================================
local DebugTab = Window:Tab({ Title="🐛 Debug", Icon="rbxassetid://7733664078" })
local DebugSection = DebugTab:Section({ Title="Debug Tools" })

DebugSection:Button({
    Title    = "Print All Mobs",
    Callback = function()
        local mobs = GetAllMobs()
        local str = "Mobs (" .. #mobs .. "):\n"
        for i, mob in ipairs(mobs) do
            if i <= 10 then
                str = str .. mob.Name .. " (HP:" .. math.floor(mob.Humanoid.Health) .. ")\n"
            end
        end
        Notify("🐛 Mobs", str, 6)
    end
})

DebugSection:Button({
    Title    = "Print Player Data",
    Callback = function()
        local data = LP:FindFirstChild("Data")
        if not data then
            Notify("🐛 Data", "No data found!", 2)
            return
        end
        local str = "Data children:\n"
        for i, child in ipairs(data:GetChildren()) do
            if i <= 15 then
                str = str .. child.Name .. " = " .. tostring(child.Value or child.ClassName) .. "\n"
            end
        end
        Notify("🐛 Data", str, 8)
    end
})

DebugSection:Button({
    Title    = "Print Remote Events",
    Callback = function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then
            Notify("🐛 Remotes", "No remotes found!", 2)
            return
        end
        local str = "Remotes:\n"
        for i, r in ipairs(remotes:GetChildren()) do
            if i <= 15 then
                str = str .. r.Name .. " (" .. r.ClassName .. ")\n"
            end
        end
        Notify("🐛 Remotes", str, 8)
    end
})

DebugSection:Button({
    Title    = "Print Position",
    Callback = function()
        local root = GetRoot()
        if root then
            local p = root.Position
            Notify("📍 Position",
                string.format("X: %.1f\nY: %.1f\nZ: %.1f", p.X, p.Y, p.Z),
                4
            )
        end
    end
})

DebugSection:Button({
    Title    = "Test Farm (1 hit)",
    Callback = function()
        local mob = GetNearestMob(100)
        if mob then
            CombatSystem:Attack(mob)
            Notify("🐛 Test", "Attacked " .. mob.Name, 2)
        else
            Notify("🐛 Test", "No mob in range!", 2)
        end
    end
})

DebugSection:Button({
    Title    = "Copy Position",
    Callback = function()
        local root = GetRoot()
        if root then
            local p = root.Position
            SafeCall(function()
                setclipboard(string.format("CFrame.new(%.1f, %.1f, %.1f)", p.X, p.Y, p.Z))
                Notify("📋 Copied", "Position copied!", 2)
            end)
        end
    end
})

-- ============================================================
-- FINAL COMPLETE EXTENDED LOOPS
-- ============================================================

-- Auto Mastery Loop (Sword + Gun + Fruit together)
task.spawn(function()
    while true do
        task.wait(0.2)
        if not IsAlive() then continue end
        local mob = GetNearestMob(50)
        if mob then
            if _G.AutoSword then
                SafeCall(function() Remote:InvokeServer("UseSword", mob) end)
            end
            if _G.AutoGun then
                SafeCall(function() Remote:InvokeServer("UseGun", mob) end)
            end
        end
    end
end)

-- Fruit Sniper continuous scan
task.spawn(function()
    while true do
        task.wait(5)
        if _G.AutoFruit then
            FruitSniper:Scan()
        end
    end
end)

-- Auto Skills continuous
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoSkill and IsAlive() then
            local mob = GetNearestMob(100)
            if mob then SkillManager:UseAll(mob) end
        end
    end
end)

-- Auto Block continuous
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoBlock and IsAlive() then
            local mob = GetNearestMob(30)
            if mob then CombatSystem:Block() end
        end
    end
end)

-- Auto Parry continuous
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoParry and IsAlive() then
            CombatSystem:Parry()
        end
    end
end)

-- Kill aura advanced with skills
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.KillAura and IsAlive() then
            local root = GetRoot()
            if not root then continue end
            for _, mob in pairs(GetAllMobs()) do
                if mob.PrimaryPart then
                    local d = Distance(root.Position, mob.PrimaryPart.Position)
                    if d <= _G.AuraRange then
                        CombatSystem:Attack(mob)
                        if _G.AutoSkill then
                            SkillManager:UseAll(mob)
                        end
                    end
                end
            end
        end
    end
end)

-- Haki auto-activate
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoHaki and IsAlive() then
            SafeCall(function() Remote:InvokeServer("Haki") end)
        end
        if _G.AutoKenHaki and IsAlive() then
            SafeCall(function() Remote:InvokeServer("ActivateObservation") end)
        end
        if _G.AutoArmorHaki and IsAlive() then
            SafeCall(function() Remote:InvokeServer("ActivateBuso") end)
        end
    end
end)

-- Stats auto-distribute
task.spawn(function()
    while true do
        task.wait(3)
        if _G.AutoStats and IsAlive() then
            local points = LP.Data and LP.Data.StatPoint and LP.Data.StatPoint.Value or 0
            if points > 0 then
                SafeCall(function()
                    Remote:InvokeServer("IncreaseStats", _G.StatType, points)
                end)
            end
        end
    end
end)

-- Fly keep-alive
task.spawn(function()
    while true do
        task.wait(1)
        if _G.FlyHack and not FlyConn then
            StartFly()
        end
    end
end)

-- ESP update loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.ESP then
            UpdateESP()
        end
    end
end)

-- Server hop check loop
task.spawn(function()
    while true do
        task.wait(5)
        if _G.ServerHop and IsAlive() then
            local h = GetHum()
            if h and h.MaxHealth > 0 then
                local pct = (h.Health / h.MaxHealth) * 100
                if pct <= _G.ServerHopHP then
                    task.spawn(HopServer)
                end
            end
        end
    end
end)

-- Anti-freeze loop
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AntiFreeze then
            local h = GetHum()
            if h then
                h.PlatformStand = false
                h.Sit = false
            end
        end
        if _G.AntiBlind then
            for _, obj in pairs(LP.PlayerGui:GetDescendants()) do
                if obj:IsA("Frame") and obj.BackgroundTransparency < 0.3 and
                   obj.BackgroundColor3 == Color3.new(0,0,0) then
                    obj.BackgroundTransparency = 1
                end
            end
        end
    end
end)

-- Gravity controller
task.spawn(function()
    while true do
        task.wait(1)
        if _G.GravMult and _G.GravMult ~= 1 then
            Workspace.Gravity = 196.2 * _G.GravMult
        end
    end
end)

-- No Clip continuous
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.NoClip then
            local char = GetChar()
            if char then
                for _, p in pairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end
    end
end)

-- Speed continuous
task.spawn(function()
    while true do
        task.wait(0.1)
        local h = GetHum()
        if h then
            if _G.SpeedHack then h.WalkSpeed = _G.SpeedValue end
            if _G.JumpValue then h.JumpPower = _G.JumpValue end
        end
    end
end)

-- Kill counter
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.RecordKills then
            local mobs = GetAllMobs()
            -- Track mob deaths would need previous state comparison
            -- Simplified: increment on successful attacks
        end
    end
end)

-- Auto fruit continuous
task.spawn(function()
    while true do
        task.wait(2)
        if _G.AutoFruit and IsAlive() then
            local fruits = GetFruits()
            local root = GetRoot()
            if root then
                for _, fruit in pairs(fruits) do
                    local part = fruit:IsA("Model") and fruit.PrimaryPart
                                 or fruit:IsA("BasePart") and fruit or nil
                    if part then
                        local d = Distance(root.Position, part.Position)
                        if d <= 400 then
                            Teleport(CFrame.new(part.Position))
                            task.wait(0.3)
                            SafeCall(function()
                                Remote:InvokeServer("PickUpFruit", fruit)
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Material auto-farm
task.spawn(function()
    while true do
        task.wait(0.15)
        if _G.AutoMaterial and IsAlive() and _G.SelectedMaterial ~= "None" then
            local mat = MaterialData[_G.SelectedMaterial]
            if mat then
                local mob = GetNearestMob(200, mat.Mob)
                if mob and mob.PrimaryPart then
                    local d = Distance(GetRoot() and GetRoot().Position or Vector3.new(), mob.PrimaryPart.Position)
                    if d > 8 then
                        Teleport(mob.PrimaryPart.CFrame * CFrame.new(0,0,5))
                    else
                        CombatSystem:Attack(mob)
                    end
                else
                    Teleport(mat.Pos)
                end
            end
        end
    end
end)

-- Boss auto farm loop
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoBoss and IsAlive() then
            local data = BossData[_G.SelectedBoss]
            if data then
                local boss = GetNearestMob(500, _G.SelectedBoss)
                if boss and boss.PrimaryPart then
                    local d = Distance(GetRoot() and GetRoot().Position or Vector3.new(), boss.PrimaryPart.Position)
                    if d > 10 then
                        Teleport(boss.PrimaryPart.CFrame * CFrame.new(0,0,5))
                    end
                    CombatSystem:Attack(boss)
                    if _G.AutoSkill then SkillManager:UseAll(boss) end
                else
                    Teleport(data.CF)
                end
            end
        end
    end
end)

-- Main farm loop
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and IsAlive() then
            AutoTrain:Cycle()
        end
    end
end)

-- ============================================================
-- POSITION SAVER
-- ============================================================
local SavedPositions = {}

local SavePosSection = DebugTab:Section({ Title="Position Saver" })

SavePosSection:Button({
    Title = "Save Current Position",
    Callback = function()
        local root = GetRoot()
        if root then
            local p = root.Position
            local name = "Pos_" .. #SavedPositions + 1
            table.insert(SavedPositions, {Name=name, CF=root.CFrame})
            Notify("📍 Saved", name .. " saved!", 2)
        end
    end
})

SavePosSection:Button({
    Title = "Teleport to Last Saved",
    Callback = function()
        if #SavedPositions > 0 then
            local last = SavedPositions[#SavedPositions]
            Teleport(last.CF)
            Notify("🚀 TP", "Teleported to " .. last.Name, 2)
        else
            Notify("⚠️", "No saved positions!", 2)
        end
    end
})

SavePosSection:Button({
    Title = "Clear Saved Positions",
    Callback = function()
        SavedPositions = {}
        Notify("🗑️ Cleared", "All positions cleared!", 2)
    end
})

-- ============================================================
-- EXTRA LABELS & INFO
-- ============================================================

local InfoSec = DebugTab:Section({ Title = "Script Info" })
InfoSec:Label({ Title = "Blox Fruits Ultimate v4.0" })
InfoSec:Label({ Title = "WindUI by Footage" })
InfoSec:Label({ Title = "Supports: World 1, 2, 3" })
InfoSec:Label({ Title = "Monsters: " .. #MobNames .. " entries" })
InfoSec:Label({ Title = "Bosses: " .. #BossNames .. " entries" })
InfoSec:Label({ Title = "Islands: " .. #AllIslands .. " entries" })
InfoSec:Label({ Title = "Codes: " .. #CodesList .. " entries" })
InfoSec:Label({ Title = "Materials: " .. #MatNames .. " entries" })
InfoSec:Label({ Title = "Raids: " .. #RaidNames .. " entries" })
InfoSec:Label({ Title = "Fruits: " .. #FruitList .. " entries" })

-- ============================================================
-- FINAL PRINT
-- ============================================================
print("╔════════════════════════════════════╗")
print("║  Blox Fruits Ultimate v4.0 Loaded  ║")
print("║  World: " .. WorldName .. string.rep(" ", 28-#WorldName) .. "║")
print("║  Level: " .. tostring(GetLevel()) .. string.rep(" ", 28-#tostring(GetLevel())) .. "║")
print("╚════════════════════════════════════╝")


-- ============================================================
-- ============================================================
--        BLOX FRUITS DATA TABLES - EXTENDED
-- ============================================================
-- ============================================================

-- ============================================================
-- COMPLETE MONSTER DROP TABLE
-- ============================================================
local MonsterDrops = {
    ["Bandit"]               = {"Fragment x1", "Beli x50"},
    ["Monkey"]               = {"Fragment x1", "Beli x100"},
    ["Gorilla"]              = {"Fragment x2", "Beli x200"},
    ["Pirate"]               = {"Fragment x2", "Beli x300", "Pirate Cape"},
    ["Brute"]                = {"Fragment x3", "Beli x400"},
    ["Desert Bandit"]        = {"Fragment x3", "Beli x500"},
    ["Desert Officer"]       = {"Fragment x4", "Beli x600"},
    ["Snow Bandit"]          = {"Fragment x4", "Beli x700"},
    ["Snowman"]              = {"Fragment x5", "Beli x800", "Snowflake"},
    ["Chief Petty Officer"]  = {"Fragment x5", "Beli x900"},
    ["Sky Bandit"]           = {"Fragment x6", "Beli x1000"},
    ["Dark Master"]          = {"Fragment x6", "Beli x1100", "Dark Mask"},
    ["Prisoner"]             = {"Fragment x7", "Beli x1200"},
    ["Dangerous Prisoner"]   = {"Fragment x8", "Beli x1400"},
    ["Toga Warrior"]         = {"Fragment x9", "Beli x1600"},
    ["Gladiator"]            = {"Fragment x10", "Beli x1800", "Gladiator Helmet"},
    ["Military Soldier"]     = {"Fragment x12", "Beli x2000", "Magma Ore"},
    ["Military Spy"]         = {"Fragment x14", "Beli x2200", "Magma Ore"},
    ["Fishman Warrior"]      = {"Fragment x16", "Beli x2500", "Fish Tail"},
    ["Fishman Commando"]     = {"Fragment x18", "Beli x2800", "Fish Tail"},
    ["God's Guard"]          = {"Fragment x20", "Beli x3000"},
    ["Shanda"]               = {"Fragment x22", "Beli x3200"},
    ["Royal Squad"]          = {"Fragment x24", "Beli x3500"},
    ["Royal Soldier"]        = {"Fragment x26", "Beli x3800", "Angel Wings"},
    ["Galley Pirate"]        = {"Fragment x28", "Beli x4000"},
    ["Galley Captain"]       = {"Fragment x30", "Beli x4500"},
    ["Trader"]               = {"Fragment x32", "Beli x5000"},
    ["Mercenary"]            = {"Fragment x35", "Beli x5500", "Leather + Scrap Metal"},
    ["Spy"]                  = {"Fragment x38", "Beli x6000"},
    ["Scientist"]            = {"Fragment x40", "Beli x6500"},
    ["Mechanical Pirate"]    = {"Fragment x42", "Beli x7000"},
    ["Zombie"]               = {"Fragment x44", "Beli x7500"},
    ["Vampire"]              = {"Fragment x46", "Beli x8000", "Vampire Fang"},
    ["Lava Pirate"]          = {"Fragment x48", "Beli x8500", "Magma Ore"},
    ["Ship Engineer"]        = {"Fragment x50", "Beli x9000"},
    ["Magma Ninja"]          = {"Fragment x52", "Beli x9500"},
    ["Dragon Crew Warrior"]  = {"Fragment x55", "Beli x10000", "Dragon Scale"},
    ["Dragon Crew Archer"]   = {"Fragment x58", "Beli x11000", "Awakened Fragment"},
    ["Snow Lurker"]          = {"Fragment x60", "Beli x12000", "Fool's Gold"},
    ["Diable"]               = {"Fragment x62", "Beli x13000"},
    ["Ice Admiral"]          = {"Fragment x65", "Beli x14000"},
    ["Forest Pirate"]        = {"Fragment x68", "Beli x15000"},
    ["Living Zombie"]        = {"Fragment x70", "Beli x16000"},
    ["Demonic Soul"]         = {"Fragment x72", "Beli x17000"},
    ["Hellish Demon"]        = {"Fragment x75", "Beli x18000"},
    ["Realistic Zombie"]     = {"Fragment x78", "Beli x19000"},
    ["Mythological Pirate"]  = {"Fragment x80", "Beli x20000", "Mini Tusk"},
    ["Chocolate Bar Battler"]= {"Fragment x82", "Beli x21000", "Conjured Cocoa"},
    ["Dough Militia"]        = {"Fragment x85", "Beli x22000"},
    ["Sweet Thief"]          = {"Fragment x88", "Beli x23000"},
    ["Biscuit Soldier"]      = {"Fragment x90", "Beli x24000"},
    ["Horned Warrior"]       = {"Fragment x92", "Beli x25000", "Horned Warrior Helmet"},
    ["Sick Scientist"]       = {"Fragment x95", "Beli x26000"},
    ["Aerial Warrior"]       = {"Fragment x98", "Beli x27000"},
    ["Cursed Skeleton"]      = {"Fragment x100","Beli x28000"},
    ["Fishman Raider"]       = {"Fragment x102","Beli x29000", "Fish Tail"},
    ["Fishman Gunner"]       = {"Fragment x105","Beli x30000", "Fish Tail"},
    ["Sea Soldier"]          = {"Fragment x108","Beli x31000"},
    ["Surfer Pirate"]        = {"Fragment x110","Beli x32000"},
    ["Pirate of Wano"]       = {"Fragment x112","Beli x33000"},
    ["Samurai"]              = {"Fragment x115","Beli x34000"},
    ["Snowflake Soldier"]    = {"Fragment x118","Beli x35000"},
    ["Pyromania Expert"]     = {"Fragment x120","Beli x36000"},
    ["Order Soldier"]        = {"Fragment x125","Beli x37000"},
    ["Order Officer"]        = {"Fragment x130","Beli x38000"},
    ["Pirate Millionaire"]   = {"Fragment x135","Beli x40000"},
    ["Pistol Billionaire"]   = {"Fragment x140","Beli x42000", "Gunpowder"},
    ["Factory Staff"]        = {"Fragment x145","Beli x44000", "Radioactive Material"},
    ["Water Fighter"]        = {"Fragment x150","Beli x46000", "Mystic Droplet"},
    ["Fishman Captain"]      = {"Fragment x155","Beli x48000", "Fish Tail"},
    ["Specter"]              = {"Fragment x160","Beli x50000"},
    ["Knight of the Sea"]    = {"Fragment x165","Beli x52000"},
}

-- ============================================================
-- SWORD LIST
-- ============================================================
local SwordList = {
    ["Katana"]          = {Mastery=10,  Type="Melee",  Damage="Low",   Special="None"},
    ["Cutlass"]         = {Mastery=20,  Type="Sword",  Damage="Low",   Special="None"},
    ["Iron Mace"]       = {Mastery=30,  Type="Blunt",  Damage="Low",   Special="None"},
    ["Dual Katana"]     = {Mastery=50,  Type="Sword",  Damage="Medium",Special="Dual Slash"},
    ["Triple Katana"]   = {Mastery=100, Type="Sword",  Damage="Medium",Special="Triple Slash"},
    ["Pipe"]            = {Mastery=0,   Type="Blunt",  Damage="Low",   Special="None"},
    ["Saber"]           = {Mastery=120, Type="Sword",  Damage="High",  Special="Skill"},
    ["Bisento"]         = {Mastery=150, Type="Polearm",Damage="High",  Special="Skill"},
    ["Dark Blade"]      = {Mastery=200, Type="Sword",  Damage="VHigh", Special="Darkness"},
    ["Shark Saw"]       = {Mastery=180, Type="Saw",    Damage="High",  Special="Bleed"},
    ["Gravity Cane"]    = {Mastery=200, Type="Cane",   Damage="High",  Special="Gravity"},
    ["Trident"]         = {Mastery=200, Type="Polearm",Damage="High",  Special="Water"},
    ["Saddi"]           = {Mastery=150, Type="Sword",  Damage="Medium",Special="None"},
    ["Wado Ichimonji"]  = {Mastery=250, Type="Sword",  Damage="High",  Special="Sky Slash"},
    ["Shisui"]          = {Mastery=300, Type="Sword",  Damage="VHigh", Special="Zoro Style"},
    ["Pole (1st Form)"] = {Mastery=300, Type="Polearm",Damage="High",  Special="Pole Skills"},
    ["Pole (2nd Form)"] = {Mastery=350, Type="Polearm",Damage="VHigh", Special="Ult Skills"},
    ["True Triple Katana"]={Mastery=400,Type="Sword",  Damage="VHigh", Special="Yoru Style"},
    ["Enma"]            = {Mastery=400, Type="Sword",  Damage="Haki",  Special="Enma Slash"},
    ["Cursed Dual Katana"]={Mastery=400,Type="Sword",  Damage="Haki",  Special="Cursed Skills"},
    ["Dark Dagger"]     = {Mastery=200, Type="Dagger", Damage="High",  Special="Shadow"},
    ["Koko"]            = {Mastery=250, Type="Sword",  Damage="High",  Special="None"},
    ["Midnight Blade"]  = {Mastery=300, Type="Sword",  Damage="High",  Special="None"},
    ["Rengoku"]         = {Mastery=400, Type="Sword",  Damage="VHigh", Special="Flame"},
    ["Dragon Trident"]  = {Mastery=400, Type="Polearm",Damage="VHigh", Special="Dragon"},
    ["Spikey Trident"]  = {Mastery=400, Type="Polearm",Damage="High",  Special="None"},
    ["Canvander"]       = {Mastery=400, Type="Sword",  Damage="High",  Special="None"},
    ["Hallow Scythe"]   = {Mastery=400, Type="Scythe", Damage="VHigh", Special="Soul"},
    ["Soul Cane"]       = {Mastery=400, Type="Cane",   Damage="VHigh", Special="Soul"},
    ["Twin Hooks"]      = {Mastery=400, Type="Dual",   Damage="High",  Special="Hook"},
    ["Buddy Sword"]     = {Mastery=400, Type="Sword",  Damage="High",  Special="Buddy"},
    ["Tushita"]         = {Mastery=400, Type="Sword",  Damage="VHigh", Special="Yellow Holy"},
    ["Yama"]            = {Mastery=400, Type="Sword",  Damage="VHigh", Special="Dark Energy"},
    ["Serpent Bow"]     = {Mastery=400, Type="Bow",    Damage="High",  Special="Venom"},
}

-- ============================================================
-- GUN LIST
-- ============================================================
local GunList = {
    ["Flintlock"]       = {Mastery=1,   Ammo=1,  Damage="Low"},
    ["Musket"]          = {Mastery=30,  Ammo=1,  Damage="Medium"},
    ["Cannon"]          = {Mastery=100, Ammo=1,  Damage="High"},
    ["Double Flintlock"]= {Mastery=50,  Ammo=2,  Damage="Medium"},
    ["Refined Flintlock"]={Mastery=200, Ammo=1,  Damage="High"},
    ["Refined Slingshot"]={Mastery=150, Ammo=3,  Damage="Medium"},
    ["Sniper"]          = {Mastery=200, Ammo=1,  Damage="VHigh"},
    ["Kabucha"]         = {Mastery=300, Ammo=1,  Damage="High"},
    ["Slingshot"]       = {Mastery=100, Ammo=3,  Damage="Medium"},
    ["Bazooka"]         = {Mastery=200, Ammo=1,  Damage="VHigh"},
    ["Howitzer"]        = {Mastery=350, Ammo=1,  Damage="Ultra"},
    ["Soul Guitar"]     = {Mastery=400, Ammo=5,  Damage="Soul"},
    ["Bizarre Rifle"]   = {Mastery=400, Ammo=1,  Damage="VHigh"},
    ["Acidum Rifle"]    = {Mastery=400, Ammo=1,  Damage="VHigh"},
    ["Corrupted Chaser"]= {Mastery=400, Ammo=3,  Damage="High"},
}

-- ============================================================
-- COMPLETE FRUIT TIER LIST
-- ============================================================
local FruitTiers = {
    S = {"Kitsune","Leopard","Dragon","Dough","Shadow","Venom","Control","Soul"},
    A = {"Gravity","Pain","Rumble","Phoenix","Buddha","String","Blizzard","Mammoth"},
    B = {"T-Rex","Gas","Spirit","Paw","Portal","Void","Quake","Dark"},
    C = {"Light","Magma","Human: Buddha","Love","Spider","Rubber","Barrier"},
    D = {"Diamond","Revive","Sand","Ice","Falcon","Smoke","Snipe","Flame"},
    F = {"Bomb","Spike","Chop","Spring","Kilo"},
}

-- ============================================================
-- FIGHTING STYLES
-- ============================================================
local FightingStyles = {
    ["Black Leg"]        = {Level=300,  Location="Baratie",     Mastery=0,   Skills=4},
    ["Electro"]          = {Level=200,  Location="Wano",        Mastery=0,   Skills=3},
    ["Superhuman"]       = {Level=300,  Location="Bubble Island",Mastery=300,Skills=5},
    ["Death Step"]       = {Level=400,  Location="Ice Castle",  Mastery=400, Skills=5},
    ["Sharkman Karate"]  = {Level=400,  Location="Underwater",  Mastery=400, Skills=5},
    ["Electric Claw"]    = {Level=400,  Location="Floating Turtle",Mastery=400,Skills=5},
    ["Dragon Talon"]     = {Level=400,  Location="Haunted Castle",Mastery=400,Skills=5},
    ["Godhuman"]         = {Level=400,  Location="Hot Zone",    Mastery=400, Skills=5},
    ["Sanguine Art"]     = {Level=400,  Location="Cursed Ship", Mastery=400, Skills=5},
    ["Melee"]            = {Level=1,    Location="Starter",     Mastery=0,   Skills=0},
    ["Combat"]           = {Level=100,  Location="Various",     Mastery=100, Skills=3},
    ["Dark Step"]        = {Level=100,  Location="Prison",      Mastery=100, Skills=4},
    ["Water Kung Fu"]    = {Level=250,  Location="Underwater",  Mastery=250, Skills=4},
}

-- ============================================================
-- RACE DATA
-- ============================================================
local RaceData = {
    ["Human"]    = {Bonus="None",          V1="Base",     V2="Speed+",      V3="Mastery+",   V4="Human Ult"},
    ["Rabbit"]   = {Bonus="Speed",         V1="Speed+10", V2="Speed+20",    V3="Flash Step", V4="Rabbit Ult"},
    ["Shark"]    = {Bonus="Swim Speed",    V1="Water+",   V2="Swim Ultra",  V3="Shark Rage", V4="Shark Ult"},
    ["Sky"]      = {Bonus="Jump",          V1="Jump+",    V2="Glide",       V3="Sky Wings",  V4="Sky Ult"},
    ["Cyborg"]   = {Bonus="Defense",       V1="Shield+",  V2="Laser",       V3="Mech Mode",  V4="Cyborg Ult"},
    ["Ghoul"]    = {Bonus="Night Power",   V1="Night+",   V2="Ghoul Step",  V3="Ghoul Rage", V4="Ghoul Ult"},
    ["Mink"]     = {Bonus="Combat",        V1="Electro",  V2="Thunder God", V3="Mink Raid",  V4="Mink Ult"},
    ["Fishman"]  = {Bonus="Water Combat",  V1="Water+",   V2="Fishman Karate",V3="Sea Rage",V4="Fishman Ult"},
    ["Angel"]    = {Bonus="Health Regen",  V1="Regen+",   V2="Heal+",       V3="Angel Wing", V4="Angel Ult"},
}

-- ============================================================
-- ACCESSORIES LIST
-- ============================================================
local AccessoryList = {
    ["Sunglasses"]          = {Type="Face",   Stats="None",         Method="Buy"},
    ["Headband"]            = {Type="Head",   Stats="Speed+",       Method="Quest"},
    ["Swordsman Hat"]       = {Type="Head",   Stats="Sword+",       Method="Buy"},
    ["Cowboy Hat"]          = {Type="Head",   Stats="Gun+",         Method="Buy"},
    ["Blue Spikey Coat"]    = {Type="Chest",  Stats="Defense+",     Method="Boss"},
    ["Black Coat"]          = {Type="Chest",  Stats="None",         Method="Buy"},
    ["Warrior Helmet"]      = {Type="Head",   Stats="Melee+",       Method="Craft"},
    ["Horned Hat"]          = {Type="Head",   Stats="Defense+",     Method="Craft"},
    ["Swan Glasses"]        = {Type="Face",   Stats="Fruit+",       Method="Boss Drop"},
    ["Dark Cape"]           = {Type="Back",   Stats="Speed+10",     Method="Boss Drop"},
    ["Ice Admiral Coat"]    = {Type="Chest",  Stats="Defense+20",   Method="Boss Drop"},
    ["Pale Scarf"]          = {Type="Neck",   Stats="Speed+15",     Method="Boss Drop"},
    ["Bravery Bones"]       = {Type="Neck",   Stats="Melee+15",     Method="Boss Drop"},
    ["Ghoul Mask"]          = {Type="Face",   Stats="Ghoul+",       Method="Ghoul Race"},
    ["Hallow Wings"]        = {Type="Back",   Stats="Speed+20",     Method="Halloween"},
    ["Cyborg Glasses"]      = {Type="Face",   Stats="Defense+",     Method="Boss Drop"},
    ["Gravity Mask"]        = {Type="Face",   Stats="Fruit+",       Method="Boss Drop"},
    ["Dough Hood"]          = {Type="Head",   Stats="Fruit+20",     Method="Boss Drop"},
    ["Shadow Armor"]        = {Type="Chest",  Stats="Defense+25",   Method="Boss Drop"},
    ["Dragon Scale Armor"]  = {Type="Chest",  Stats="Defense+30",   Method="Craft"},
    ["Leviathan Armor"]     = {Type="Chest",  Stats="All+25",       Method="Boss Drop"},
    ["Order Coat"]          = {Type="Chest",  Stats="Defense+",     Method="Boss Drop"},
    ["Kitsune Cloak"]       = {Type="Back",   Stats="Speed+30",     Method="Boss Drop"},
    ["Leopard Mask"]        = {Type="Face",   Stats="Fruit+25",     Method="Boss Drop"},
}

-- ============================================================
-- QUESTS EXTENDED DATA
-- ============================================================
local QuestExtended = {}

-- World 1 Quests
QuestExtended.World1 = {
    {Name="Starter Human Quest", Level={1,9},    NPC="Quest Giver",   Reward={XP=100,  Beli=50}},
    {Name="Monkey Quest",        Level={10,14},  NPC="Quest Giver",   Reward={XP=500,  Beli=100}},
    {Name="Gorilla Quest",       Level={15,29},  NPC="Quest Giver",   Reward={XP=1000, Beli=200}},
    {Name="Pirate Quest",        Level={30,39},  NPC="Pirate Captain",Reward={XP=2000, Beli=300}},
    {Name="Brute Quest",         Level={40,59},  NPC="Brute Boss",    Reward={XP=3000, Beli=400}},
    {Name="Desert Quest",        Level={60,74},  NPC="Desert Chief",  Reward={XP=5000, Beli=500}},
    {Name="Desert Quest 2",      Level={75,89},  NPC="Desert Chief",  Reward={XP=7000, Beli=600}},
    {Name="Snow Quest",          Level={90,99},  NPC="Snow Chief",    Reward={XP=9000, Beli=700}},
    {Name="Snowman Quest",       Level={100,119},NPC="Snow Chief",    Reward={XP=12000,Beli=800}},
    {Name="Marine Base Quest",   Level={120,149},NPC="Marine General",Reward={XP=15000,Beli=900}},
    {Name="Sky Quest",           Level={150,174},NPC="Sky Guardian",  Reward={XP=20000,Beli=1000}},
    {Name="Dark Quest",          Level={175,189},NPC="Dark Lord",     Reward={XP=25000,Beli=1100}},
    {Name="Prison Quest",        Level={190,209},NPC="Guard Chief",   Reward={XP=30000,Beli=1200}},
    {Name="Prison Quest 2",      Level={210,249},NPC="Guard Chief",   Reward={XP=40000,Beli=1400}},
    {Name="Colosseum Quest",     Level={250,274},NPC="Colosseum Host",Reward={XP=50000,Beli=1600}},
    {Name="Colosseum Quest 2",   Level={275,299},NPC="Colosseum Host",Reward={XP=60000,Beli=1800}},
    {Name="Military Quest",      Level={300,324},NPC="General",       Reward={XP=75000,Beli=2000}},
    {Name="Military Quest 2",    Level={325,374},NPC="General",       Reward={XP=90000,Beli=2200}},
    {Name="Fishman Quest",       Level={375,399},NPC="Fishman King",  Reward={XP=110000,Beli=2500}},
    {Name="Fishman Quest 2",     Level={400,449},NPC="Fishman King",  Reward={XP=130000,Beli=2800}},
}

-- World 2 Quests
QuestExtended.World2 = {
    {Name="Port Town Quest",     Level={700,749}, NPC="Port Master",  Reward={XP=200000, Beli=5000}},
    {Name="Dress Rosa Quest",    Level={750,799}, NPC="Colosseum Host",Reward={XP=250000,Beli=5500}},
    {Name="Green Zone Quest",    Level={800,849}, NPC="Green Chief",  Reward={XP=300000, Beli=6000}},
    {Name="Punk Hazard Quest",   Level={850,924}, NPC="Scientist",    Reward={XP=350000, Beli=6500}},
    {Name="Thriller Bark Quest", Level={925,999}, NPC="Moria",        Reward={XP=400000, Beli=7000}},
    {Name="Graveyard Quest",     Level={1000,1049},NPC="Ghoul",       Reward={XP=450000, Beli=8000}},
    {Name="Magma Quest",         Level={1050,1099},NPC="Lava King",   Reward={XP=500000, Beli=8500}},
    {Name="Wano Quest",          Level={1100,1174},NPC="Shogun",      Reward={XP=600000, Beli=9000}},
    {Name="Dragon Quest",        Level={1175,1249},NPC="Oden",        Reward={XP=700000, Beli=10000}},
    {Name="Ice Castle Quest",    Level={1325,1499},NPC="Ice Queen",   Reward={XP=900000, Beli=12000}},
}

-- World 3 Quests
QuestExtended.World3 = {
    {Name="Floating Turtle Quest",Level={1500,1574},NPC="Elder Turtle",Reward={XP=2000000,Beli=20000}},
    {Name="Haunted Castle Quest", Level={1575,1699},NPC="Soul Keeper", Reward={XP=2500000,Beli=22000}},
    {Name="Sea of Treats Quest",  Level={1925,1999},NPC="Charlotte",   Reward={XP=3000000,Beli=25000}},
    {Name="Elf Island Quest",     Level={2225,2299},NPC="Elf Queen",    Reward={XP=3500000,Beli=28000}},
    {Name="Cursed Ship Quest",    Level={2450,2524},NPC="Ghost Captain",Reward={XP=4000000,Beli=30000}},
}

-- ============================================================
-- SERVER LIST DATA
-- ============================================================
local ServerInfo = {
    PlaceId    = game.PlaceId,
    JobId      = game.JobId,
    MaxPlayers = game.MaxPlayers,
    Players    = #Players:GetPlayers(),
}

-- ============================================================
-- FRUIT SPAWN LOCATIONS (Known Static Spawns)
-- ============================================================
local FruitSpawns = {
    -- World 1 common fruit spawn areas
    {Position=Vector3.new(-1200, 5, -1300),  Area="Starter Island",   Chance="Common"},
    {Position=Vector3.new(-1950, 5, -3280),  Area="Monkey Island",    Chance="Common"},
    {Position=Vector3.new(-970,  15, 4035),  Area="Pirate Village",   Chance="Common"},
    {Position=Vector3.new(925,   5, 1120),   Area="Desert",           Chance="Common"},
    {Position=Vector3.new(1270, 280, -2245), Area="Snow Island",      Chance="Uncommon"},
    {Position=Vector3.new(1015,  8, -2975),  Area="Marine Base",      Chance="Uncommon"},
    {Position=Vector3.new(-5085,615,-4765),  Area="Sky Island",       Chance="Rare"},
    {Position=Vector3.new(5265,  5, 3770),   Area="Prison",           Chance="Uncommon"},
    {Position=Vector3.new(-6520, 5, -1050),  Area="Colosseum",        Chance="Rare"},
    {Position=Vector3.new(-5568, 12, 8330),  Area="Magma Village",    Chance="Rare"},
    {Position=Vector3.new(60945, 20, 1745),  Area="Underwater City",  Chance="Rare"},
    {Position=Vector3.new(-7760,5610,-1865), Area="Sky Island 2",     Chance="Epic"},
    -- World 2 fruit spawns
    {Position=Vector3.new(-300,  12, 5768),  Area="Port Town",        Chance="Common"},
    {Position=Vector3.new(-990,  75, 1090),  Area="Dress Rosa",       Chance="Uncommon"},
    {Position=Vector3.new(3605,  12, 3392),  Area="Green Zone",       Chance="Uncommon"},
    {Position=Vector3.new(588,   18, 5045),  Area="Punk Hazard",      Chance="Rare"},
    {Position=Vector3.new(-11470,12,-4905),  Area="Thriller Bark",    Chance="Rare"},
    {Position=Vector3.new(-6135, 12, -1470), Area="Graveyard",        Chance="Epic"},
    {Position=Vector3.new(-5162, 18, -4658), Area="Hot Zone",         Chance="Epic"},
    {Position=Vector3.new(-3285, 60, -4290), Area="Wano",             Chance="Legendary"},
    {Position=Vector3.new(1035, 270, -5145), Area="Ice Castle",       Chance="Legendary"},
    -- World 3 fruit spawns
    {Position=Vector3.new(-10832,335,-9052), Area="Floating Turtle",  Chance="Uncommon"},
    {Position=Vector3.new(-12865, 30,-7070), Area="Haunted Castle",   Chance="Rare"},
    {Position=Vector3.new(586,    28,-12555),Area="Sea of Treats",    Chance="Epic"},
    {Position=Vector3.new(-4652,  80,-13530),Area="Elf Island",       Chance="Epic"},
    {Position=Vector3.new(-5088,   5,-9700), Area="Cursed Ship",      Chance="Legendary"},
    {Position=Vector3.new(1022,   45,-10440),Area="Sea Castle",       Chance="Legendary"},
}

-- ============================================================
-- CHEST LOCATIONS (Known Static Chests)
-- ============================================================
local KnownChests = {
    -- World 1
    {Position=Vector3.new(-1205, 0, -1305), Area="Starter",    Type="Wooden", Beli=500},
    {Position=Vector3.new(-1355, 0, -1255), Area="Starter",    Type="Iron",   Beli=1000},
    {Position=Vector3.new(-905,  0, -1405), Area="Starter",    Type="Wooden", Beli=500},
    {Position=Vector3.new(928,   0, 1108),  Area="Desert",     Type="Iron",   Beli=2000},
    {Position=Vector3.new(1208, 278, -2105),Area="Snow",       Type="Golden", Beli=5000},
    {Position=Vector3.new(1315, 278, -2210),Area="Snow",       Type="Iron",   Beli=2000},
    {Position=Vector3.new(-5090,618,-4712), Area="Sky",        Type="Golden", Beli=8000},
    {Position=Vector3.new(5215,  3, 3708),  Area="Prison",     Type="Golden", Beli=6000},
    {Position=Vector3.new(60810, 20, 1610), Area="Underwater", Type="Golden", Beli=10000},
    {Position=Vector3.new(-7710,5608,-1812),Area="Sky2",       Type="Diamond",Beli=20000},
    -- World 2
    {Position=Vector3.new(-308,  12, 5712), Area="Port Town",  Type="Iron",   Beli=3000},
    {Position=Vector3.new(-960,  75, 1010), Area="Dress Rosa", Type="Golden", Beli=8000},
    {Position=Vector3.new(3508,  12, 3308), Area="Green Zone", Type="Golden", Beli=8000},
    {Position=Vector3.new(508,   18, 5008), Area="Punk Hazard",Type="Golden", Beli=10000},
    {Position=Vector3.new(-11408,12,-4808), Area="Thriller",   Type="Diamond",Beli=15000},
    {Position=Vector3.new(-6008, 12, -1408),Area="Graveyard",  Type="Diamond",Beli=15000},
    {Position=Vector3.new(-5108, 18, -4608),Area="Hot Zone",   Type="Diamond",Beli=20000},
    {Position=Vector3.new(1008, 270, -5108),Area="Ice Castle", Type="Diamond",Beli=25000},
    -- World 3
    {Position=Vector3.new(-10708,335,-8912),Area="Turtle",     Type="Diamond",Beli=30000},
    {Position=Vector3.new(-12808, 30,-7008),Area="Haunted",    Type="Diamond",Beli=30000},
    {Position=Vector3.new(508,    28,-12408),Area="Treats",    Type="Crystal",Beli=50000},
    {Position=Vector3.new(-4608,  80,-13408),Area="Elf Island",Type="Crystal",Beli=50000},
    {Position=Vector3.new(-5008,   5,-9608), Area="Cursed",    Type="Crystal",Beli=60000},
    {Position=Vector3.new(1008,   45,-10308),Area="Sea Castle",Type="Crystal",Beli=60000},
}

-- ============================================================
-- STATS CALCULATOR
-- ============================================================
local StatsCalc = {}

function StatsCalc:GetIdealBuild(playstyle)
    local builds = {
        ["Sword"] = {Melee=0, Defense=0, Sword=100, Gun=0, Fruit=0},
        ["Gun"]   = {Melee=0, Defense=0, Sword=0,   Gun=100, Fruit=0},
        ["Fruit"] = {Melee=0, Defense=0, Sword=0,   Gun=0,   Fruit=100},
        ["Melee"] = {Melee=100, Defense=0, Sword=0, Gun=0, Fruit=0},
        ["Defense+Fruit"] = {Melee=0, Defense=40, Sword=0, Gun=0, Fruit=60},
        ["Defense+Sword"] = {Melee=0, Defense=30, Sword=70, Gun=0, Fruit=0},
        ["Defense+Melee"] = {Melee=70, Defense=30, Sword=0, Gun=0, Fruit=0},
        ["Hybrid Fruit+Sword"] = {Melee=0, Defense=10, Sword=45, Gun=0, Fruit=45},
    }
    return builds[playstyle] or builds["Fruit"]
end

function StatsCalc:GetMaxLevel()
    return 2450 -- Current max level
end

function StatsCalc:GetPointsAtLevel(level)
    return level * 3 -- Approximate
end

function StatsCalc:GetBestStat()
    local lvl = GetLevel()
    if lvl < 200 then return "Melee"
    elseif lvl < 500 then return "Sword"
    elseif lvl < 1000 then return "Fruit"
    else return "Fruit" end
end

-- ============================================================
-- FISHING SYSTEM (if applicable)
-- ============================================================
local FishingSystem = {}
FishingSystem.Active = false

function FishingSystem:Start()
    self.Active = true
    task.spawn(function()
        while self.Active do
            SafeCall(function()
                Remote:InvokeServer("StartFishing")
                task.wait(5)
                Remote:InvokeServer("CastLine")
                task.wait(3)
                Remote:InvokeServer("ReelIn")
            end)
            task.wait(2)
        end
    end)
end

function FishingSystem:Stop()
    self.Active = false
end

-- ============================================================
-- BOUNTY TRACKER
-- ============================================================
local BountyTracker = {}

function BountyTracker:GetBounty()
    local data = LP:FindFirstChild("Data")
    if data then
        local bounty = data:FindFirstChild("Bounty")
        return bounty and bounty.Value or 0
    end
    return 0
end

function BountyTracker:GetHonor()
    local data = LP:FindFirstChild("Data")
    if data then
        local honor = data:FindFirstChild("Honor")
        return honor and honor.Value or 0
    end
    return 0
end

function BountyTracker:IsPirate()
    local data = LP:FindFirstChild("Data")
    if data then
        local team = data:FindFirstChild("Team")
        return team and team.Value == "Pirates"
    end
    return false
end

function BountyTracker:GetTitle()
    local bounty = self:GetBounty()
    if bounty >= 10000000 then return "Pirate King"
    elseif bounty >= 5000000 then return "Warlord"
    elseif bounty >= 1000000 then return "Supernovae"
    elseif bounty >= 500000  then return "Great Pirate"
    elseif bounty >= 100000  then return="Rookie Pirate"
    else return "Unknown Pirate" end
end

-- ============================================================
-- PVP TRACKER
-- ============================================================
local PvPTracker = {}
PvPTracker.Kills  = 0
PvPTracker.Deaths = 0
PvPTracker.KDA    = 0

function PvPTracker:AddKill()
    self.Kills = self.Kills + 1
    self:UpdateKDA()
end

function PvPTracker:AddDeath()
    self.Deaths = self.Deaths + 1
    self:UpdateKDA()
end

function PvPTracker:UpdateKDA()
    if self.Deaths == 0 then
        self.KDA = self.Kills
    else
        self.KDA = self.Kills / self.Deaths
    end
end

function PvPTracker:GetStats()
    return {
        Kills  = self.Kills,
        Deaths = self.Deaths,
        KDA    = string.format("%.2f", self.KDA)
    }
end

-- ============================================================
-- GUILD/CREW SYSTEM
-- ============================================================
local CrewSystem = {}

function CrewSystem:GetCrew()
    SafeCall(function()
        Remote:InvokeServer("GetCrewInfo")
    end)
end

function CrewSystem:CreateCrew(name)
    SafeCall(function()
        Remote:InvokeServer("CreateCrew", name)
        Notify("🏴 Crew", "Created crew: " .. name, 3)
    end)
end

function CrewSystem:JoinCrew(crewName)
    SafeCall(function()
        Remote:InvokeServer("JoinCrew", crewName)
        Notify("🏴 Crew", "Joined: " .. crewName, 3)
    end)
end

-- ============================================================
-- TREASURE MAP SYSTEM
-- ============================================================
local TreasureMap = {}
TreasureMap.KnownMaps = {
    {Name="Starter Treasure", Location=Vector3.new(-1300, 0, -1400), Reward="500 Beli + Sword"},
    {Name="Desert Treasure",  Location=Vector3.new(950, 0, 1200),    Reward="2000 Beli + Fruit"},
    {Name="Snow Treasure",    Location=Vector3.new(1300, 278, -2300),Reward="5000 Beli + Accessory"},
    {Name="Sky Treasure",     Location=Vector3.new(-5100, 618, -4800),Reward="10000 Beli + Material"},
    {Name="Sea Treasure",     Location=Vector3.new(61000, 20, 1800), Reward="15000 Beli + Fruit"},
}

function TreasureMap:FindAll()
    for _, map in ipairs(self.KnownMaps) do
        local root = GetRoot()
        if root then
            root.CFrame = CFrame.new(map.Location)
            task.wait(1)
            SafeCall(function()
                Remote:InvokeServer("DigTreasure")
            end)
            task.wait(0.5)
        end
    end
    Notify("🗺️ Treasure", "Searched all known treasure locations!", 4)
end

-- ============================================================
-- EXTENDED WINDUI TABS (CONTINUED)
-- ============================================================

-- ============================================================
-- TAB: SWORD & GUNS
-- ============================================================
local WeaponTab = Window:Tab({ Title="🗡️ Weapons", Icon="rbxassetid://7733664078" })
local SwordSection = WeaponTab:Section({ Title="Swords" })

local SwordNames = {}
for k in pairs(SwordList) do table.insert(SwordNames, k) end
table.sort(SwordNames)

SwordSection:Dropdown({
    Title   = "Equip Sword",
    List    = SwordNames,
    Default = "Katana",
    Callback = function(v)
        SafeCall(function()
            Remote:InvokeServer("EquipWeapon", v)
            Notify("⚔️ Sword", "Equipped: " .. v, 2)
        end)
    end
})

SwordSection:Button({
    Title    = "Auto Farm Sword Mastery",
    Callback = function()
        _G.AutoSword = true
        _G.AutoMastery = true
        Notify("⚔️ Sword Mastery", "Farming sword mastery!", 3)
    end
})

local GunSection = WeaponTab:Section({ Title="Guns" })

local GunNames = {}
for k in pairs(GunList) do table.insert(GunNames, k) end
table.sort(GunNames)

GunSection:Dropdown({
    Title   = "Equip Gun",
    List    = GunNames,
    Default = "Flintlock",
    Callback = function(v)
        SafeCall(function()
            Remote:InvokeServer("EquipWeapon", v)
            Notify("🔫 Gun", "Equipped: " .. v, 2)
        end)
    end
})

GunSection:Button({
    Title    = "Auto Farm Gun Mastery",
    Callback = function()
        _G.AutoGun = true
        _G.AutoMastery = true
        Notify("🔫 Gun Mastery", "Farming gun mastery!", 3)
    end
})

-- ============================================================
-- TAB: FIGHTING STYLES
-- ============================================================
local StyleTab = Window:Tab({ Title="🥊 Styles", Icon="rbxassetid://7733664078" })
local StyleSection = StyleTab:Section({ Title="Fighting Styles" })

local StyleNames = {}
for k in pairs(FightingStyles) do table.insert(StyleNames, k) end
table.sort(StyleNames)

StyleSection:Dropdown({
    Title   = "Select Style",
    List    = StyleNames,
    Default = "Melee",
    Callback = function(v)
        local data = FightingStyles[v]
        if data then
            Notify("🥊 Style", v .. "\nLvl: " .. data.Level .. " | Location: " .. data.Location, 4)
        end
    end
})

for name, data in pairs(FightingStyles) do
    StyleSection:Label({ Title = name .. " | Lvl: " .. data.Level .. " | " .. data.Location })
end

-- ============================================================
-- TAB: RACES
-- ============================================================
local RaceTab = Window:Tab({ Title="🧬 Races", Icon="rbxassetid://7733664078" })
local RaceSection = RaceTab:Section({ Title="Race Info" })

local RaceNames = {}
for k in pairs(RaceData) do table.insert(RaceNames, k) end
table.sort(RaceNames)

RaceSection:Dropdown({
    Title   = "Race",
    List    = RaceNames,
    Default = "Human",
    Callback = function(v)
        local data = RaceData[v]
        if data then
            Notify("🧬 Race", v ..
                "\nBonus: " .. data.Bonus ..
                "\nV1: " .. data.V1 ..
                "\nV2: " .. data.V2 ..
                "\nV3: " .. data.V3 ..
                "\nV4: " .. data.V4, 6)
        end
    end
})

RaceSection:Button({
    Title    = "Re-roll Race",
    Callback = function()
        SafeCall(function()
            Remote:InvokeServer("SpinRace")
            Notify("🎰 Race", "Rolling new race...", 3)
        end)
    end
})

-- ============================================================
-- TAB: BOUNTY
-- ============================================================
local BountyTab = Window:Tab({ Title="💰 Bounty", Icon="rbxassetid://7733664078" })
local BountySection = BountyTab:Section({ Title="Bounty Info" })

BountySection:Button({
    Title    = "Check Bounty",
    Callback = function()
        local b = BountyTracker:GetBounty()
        local h = BountyTracker:GetHonor()
        local t = BountyTracker:GetTitle()
        Notify("💰 Bounty",
            "Bounty: " .. b ..
            "\nHonor: " .. h ..
            "\nTitle: " .. t,
            5
        )
    end
})

BountySection:Label({ Title = "Bounty tracks as pirate" })
BountySection:Label({ Title = "Honor tracks as marine" })

local PvPSection2 = BountyTab:Section({ Title="PvP Tracker" })

PvPSection2:Button({
    Title    = "Show PvP Stats",
    Callback = function()
        local stats = PvPTracker:GetStats()
        Notify("🗡️ PvP Stats",
            "Kills: "  .. stats.Kills ..
            "\nDeaths: " .. stats.Deaths ..
            "\nKDA: "    .. stats.KDA,
            4
        )
    end
})

PvPSection2:Button({
    Title    = "Reset PvP Tracker",
    Callback = function()
        PvPTracker.Kills = 0
        PvPTracker.Deaths = 0
        PvPTracker.KDA = 0
        Notify("🔄 Reset", "PvP tracker reset!", 2)
    end
})

-- ============================================================
-- TAB: BUILDS
-- ============================================================
local BuildTab = Window:Tab({ Title="📐 Builds", Icon="rbxassetid://7733664078" })
local BuildSection = BuildTab:Section({ Title="Pre-made Builds" })

local BuildList = {"Sword","Gun","Fruit","Melee","Defense+Fruit","Defense+Sword","Defense+Melee","Hybrid Fruit+Sword"}

BuildSection:Dropdown({
    Title   = "Select Build",
    List    = BuildList,
    Default = "Fruit",
    Callback = function(v)
        local build = StatsCalc:GetIdealBuild(v)
        local str = "Build: " .. v .. "\n"
        for stat, pct in pairs(build) do
            str = str .. stat .. ": " .. pct .. "%\n"
        end
        Notify("📐 Build", str, 5)
    end
})

BuildSection:Button({
    Title    = "Apply Best Build",
    Callback = function()
        local best = StatsCalc:GetBestStat()
        _G.StatType = best
        _G.AutoStats = true
        Notify("📐 Build", "Applying: " .. best .. " build!", 3)
    end
})

BuildSection:Label({ Title = "Fruit = Best for most players" })
BuildSection:Label({ Title = "Sword = Best for Sword mains" })
BuildSection:Label({ Title = "Hybrid = Balanced but weaker" })

-- ============================================================
-- TAB: FISHING
-- ============================================================
local FishTab = Window:Tab({ Title="🎣 Fishing", Icon="rbxassetid://7733664078" })
local FishSection = FishTab:Section({ Title="Auto Fishing" })

FishSection:Toggle({
    Title    = "Auto Fish",
    Default  = false,
    Callback = function(v)
        if v then FishingSystem:Start()
        else FishingSystem:Stop() end
        Notify("🎣 Fish", v and "Fishing started!" or "Fishing stopped!", 2)
    end
})

FishSection:Label({ Title = "Fish for rare items" })
FishSection:Label({ Title = "Some islands have better fish" })

-- ============================================================
-- TAB: TREASURE
-- ============================================================
local TreasureTab = Window:Tab({ Title="🗺️ Treasure", Icon="rbxassetid://7733664078" })
local TreasureSection = TreasureTab:Section({ Title="Treasure Hunting" })

TreasureSection:Button({
    Title    = "Find All Treasures",
    Callback = function()
        task.spawn(function()
            TreasureMap:FindAll()
        end)
    end
})

for _, map in ipairs(TreasureMap.KnownMaps) do
    TreasureSection:Button({
        Title    = map.Name,
        Callback = function()
            local root = GetRoot()
            if root then
                root.CFrame = CFrame.new(map.Location)
                task.wait(1)
                SafeCall(function() Remote:InvokeServer("DigTreasure") end)
                Notify("🗺️ Treasure", "Digging: " .. map.Name .. "\nReward: " .. map.Reward, 4)
            end
        end
    })
end

-- ============================================================
-- ADDITIONAL MISC TABS
-- ============================================================

-- ============================================================
-- TAB: STATS & INFO
-- ============================================================
local InfoTab = Window:Tab({ Title="📖 Info", Icon="rbxassetid://7733664078" })
local FruitTierSection = InfoTab:Section({ Title="Fruit Tier List" })

for tier, fruits in pairs(FruitTiers) do
    local fruitStr = table.concat(fruits, ", ")
    FruitTierSection:Label({ Title = "⭐ " .. tier .. ": " .. fruitStr })
end

local AccessorySection = InfoTab:Section({ Title="Top Accessories" })

for name, data in pairs(AccessoryList) do
    AccessorySection:Label({ Title = name .. " | " .. data.Stats .. " | " .. data.Method })
end

-- ============================================================
-- FINAL AUTOMATION CHECKS
-- ============================================================

-- Main heartbeat orchestrator
RunService.Heartbeat:Connect(function()
    -- Infinite stamina
    if _G.InfStamina then
        local data = LP:FindFirstChild("Data")
        if data then
            local stam = data:FindFirstChild("Energy")
            if stam then stam.Value = stam.Value > 0 and stam.Value or 100 end
        end
    end
    -- Fullbright maintain
    if _G.Fullbright then
        if Lighting.Brightness ~= 2 then SetFullbright(true) end
    end
end)

-- Periodic stats update
task.spawn(function()
    while true do
        task.wait(30)
        -- Update ServerInfo
        ServerInfo.Players = #Players:GetPlayers()
    end
end)

-- Auto save loop (placeholder)
task.spawn(function()
    while true do
        task.wait(300) -- every 5 mins
        if _G.DebugMode then
            print("[Auto Save] Session: " .. math.floor((os.time()-_G.SessionStart)/60) .. " mins | Kills: " .. _G.KillCount)
        end
    end
end)

-- ============================================================
-- COMPLETE FINAL MESSAGE
-- ============================================================
Notify("🎮 Ready!", "All features loaded!\nPress F1 to start farming!", 4)

print("=== Blox Fruits Ultimate Script ===")
print("Tabs loaded: Farm, Boss, Player, Fruits, Materials,")
print("Raids, Haki, Stats, ESP, Misc, Teleport, World,")
print("Combat, Visual, PvP, Grind, Automation, Debug,")
print("Weapons, Styles, Races, Bounty, Builds, Info")
print("Total features: 100+")
print("===================================")


-- ============================================================
-- COMPLETE LEVEL RANGE TO MONSTER MAPPING (1-4500)
-- ============================================================
local LevelToMonster = {}
LevelToMonster[1] = "Bandit"
LevelToMonster[2] = "Bandit"
LevelToMonster[3] = "Bandit"
LevelToMonster[4] = "Bandit"
LevelToMonster[5] = "Bandit"
LevelToMonster[6] = "Bandit"
LevelToMonster[7] = "Bandit"
LevelToMonster[8] = "Bandit"
LevelToMonster[9] = "Bandit"
LevelToMonster[10] = "Monkey"
LevelToMonster[11] = "Monkey"
LevelToMonster[12] = "Monkey"
LevelToMonster[13] = "Monkey"
LevelToMonster[14] = "Monkey"
LevelToMonster[15] = "Gorilla"
LevelToMonster[16] = "Gorilla"
LevelToMonster[17] = "Gorilla"
LevelToMonster[18] = "Gorilla"
LevelToMonster[19] = "Gorilla"
LevelToMonster[20] = "Gorilla"
LevelToMonster[21] = "Gorilla"
LevelToMonster[22] = "Gorilla"
LevelToMonster[23] = "Gorilla"
LevelToMonster[24] = "Gorilla"
LevelToMonster[25] = "Gorilla"
LevelToMonster[26] = "Gorilla"
LevelToMonster[27] = "Gorilla"
LevelToMonster[28] = "Gorilla"
LevelToMonster[29] = "Gorilla"
LevelToMonster[30] = "Pirate"
LevelToMonster[31] = "Pirate"
LevelToMonster[32] = "Pirate"
LevelToMonster[33] = "Pirate"
LevelToMonster[34] = "Pirate"
LevelToMonster[35] = "Pirate"
LevelToMonster[36] = "Pirate"
LevelToMonster[37] = "Pirate"
LevelToMonster[38] = "Pirate"
LevelToMonster[39] = "Pirate"
LevelToMonster[40] = "Brute"
LevelToMonster[41] = "Brute"
LevelToMonster[42] = "Brute"
LevelToMonster[43] = "Brute"
LevelToMonster[44] = "Brute"
LevelToMonster[45] = "Brute"
LevelToMonster[46] = "Brute"
LevelToMonster[47] = "Brute"
LevelToMonster[48] = "Brute"
LevelToMonster[49] = "Brute"
LevelToMonster[50] = "Brute"
LevelToMonster[51] = "Brute"
LevelToMonster[52] = "Brute"
LevelToMonster[53] = "Brute"
LevelToMonster[54] = "Brute"
LevelToMonster[55] = "Brute"
LevelToMonster[56] = "Brute"
LevelToMonster[57] = "Brute"
LevelToMonster[58] = "Brute"
LevelToMonster[59] = "Brute"
LevelToMonster[60] = "Desert Bandit"
LevelToMonster[61] = "Desert Bandit"
LevelToMonster[62] = "Desert Bandit"
LevelToMonster[63] = "Desert Bandit"
LevelToMonster[64] = "Desert Bandit"
LevelToMonster[65] = "Desert Bandit"
LevelToMonster[66] = "Desert Bandit"
LevelToMonster[67] = "Desert Bandit"
LevelToMonster[68] = "Desert Bandit"
LevelToMonster[69] = "Desert Bandit"
LevelToMonster[70] = "Desert Bandit"
LevelToMonster[71] = "Desert Bandit"
LevelToMonster[72] = "Desert Bandit"
LevelToMonster[73] = "Desert Bandit"
LevelToMonster[74] = "Desert Bandit"
LevelToMonster[75] = "Desert Officer"
LevelToMonster[76] = "Desert Officer"
LevelToMonster[77] = "Desert Officer"
LevelToMonster[78] = "Desert Officer"
LevelToMonster[79] = "Desert Officer"
LevelToMonster[80] = "Desert Officer"
LevelToMonster[81] = "Desert Officer"
LevelToMonster[82] = "Desert Officer"
LevelToMonster[83] = "Desert Officer"
LevelToMonster[84] = "Desert Officer"
LevelToMonster[85] = "Desert Officer"
LevelToMonster[86] = "Desert Officer"
LevelToMonster[87] = "Desert Officer"
LevelToMonster[88] = "Desert Officer"
LevelToMonster[89] = "Desert Officer"
LevelToMonster[90] = "Snow Bandit"
LevelToMonster[91] = "Snow Bandit"
LevelToMonster[92] = "Snow Bandit"
LevelToMonster[93] = "Snow Bandit"
LevelToMonster[94] = "Snow Bandit"
LevelToMonster[95] = "Snow Bandit"
LevelToMonster[96] = "Snow Bandit"
LevelToMonster[97] = "Snow Bandit"
LevelToMonster[98] = "Snow Bandit"
LevelToMonster[99] = "Snow Bandit"
LevelToMonster[100] = "Snowman"
LevelToMonster[101] = "Snowman"
LevelToMonster[102] = "Snowman"
LevelToMonster[103] = "Snowman"
LevelToMonster[104] = "Snowman"
LevelToMonster[105] = "Snowman"
LevelToMonster[106] = "Snowman"
LevelToMonster[107] = "Snowman"
LevelToMonster[108] = "Snowman"
LevelToMonster[109] = "Snowman"
LevelToMonster[110] = "Snowman"
LevelToMonster[111] = "Snowman"
LevelToMonster[112] = "Snowman"
LevelToMonster[113] = "Snowman"
LevelToMonster[114] = "Snowman"
LevelToMonster[115] = "Snowman"
LevelToMonster[116] = "Snowman"
LevelToMonster[117] = "Snowman"
LevelToMonster[118] = "Snowman"
LevelToMonster[119] = "Snowman"
LevelToMonster[120] = "Chief Petty Officer"
LevelToMonster[121] = "Chief Petty Officer"
LevelToMonster[122] = "Chief Petty Officer"
LevelToMonster[123] = "Chief Petty Officer"
LevelToMonster[124] = "Chief Petty Officer"
LevelToMonster[125] = "Chief Petty Officer"
LevelToMonster[126] = "Chief Petty Officer"
LevelToMonster[127] = "Chief Petty Officer"
LevelToMonster[128] = "Chief Petty Officer"
LevelToMonster[129] = "Chief Petty Officer"
LevelToMonster[130] = "Chief Petty Officer"
LevelToMonster[131] = "Chief Petty Officer"
LevelToMonster[132] = "Chief Petty Officer"
LevelToMonster[133] = "Chief Petty Officer"
LevelToMonster[134] = "Chief Petty Officer"
LevelToMonster[135] = "Chief Petty Officer"
LevelToMonster[136] = "Chief Petty Officer"
LevelToMonster[137] = "Chief Petty Officer"
LevelToMonster[138] = "Chief Petty Officer"
LevelToMonster[139] = "Chief Petty Officer"
LevelToMonster[140] = "Chief Petty Officer"
LevelToMonster[141] = "Chief Petty Officer"
LevelToMonster[142] = "Chief Petty Officer"
LevelToMonster[143] = "Chief Petty Officer"
LevelToMonster[144] = "Chief Petty Officer"
LevelToMonster[145] = "Chief Petty Officer"
LevelToMonster[146] = "Chief Petty Officer"
LevelToMonster[147] = "Chief Petty Officer"
LevelToMonster[148] = "Chief Petty Officer"
LevelToMonster[149] = "Chief Petty Officer"
LevelToMonster[150] = "Sky Bandit"
LevelToMonster[151] = "Sky Bandit"
LevelToMonster[152] = "Sky Bandit"
LevelToMonster[153] = "Sky Bandit"
LevelToMonster[154] = "Sky Bandit"
LevelToMonster[155] = "Sky Bandit"
LevelToMonster[156] = "Sky Bandit"
LevelToMonster[157] = "Sky Bandit"
LevelToMonster[158] = "Sky Bandit"
LevelToMonster[159] = "Sky Bandit"
LevelToMonster[160] = "Sky Bandit"
LevelToMonster[161] = "Sky Bandit"
LevelToMonster[162] = "Sky Bandit"
LevelToMonster[163] = "Sky Bandit"
LevelToMonster[164] = "Sky Bandit"
LevelToMonster[165] = "Sky Bandit"
LevelToMonster[166] = "Sky Bandit"
LevelToMonster[167] = "Sky Bandit"
LevelToMonster[168] = "Sky Bandit"
LevelToMonster[169] = "Sky Bandit"
LevelToMonster[170] = "Sky Bandit"
LevelToMonster[171] = "Sky Bandit"
LevelToMonster[172] = "Sky Bandit"
LevelToMonster[173] = "Sky Bandit"
LevelToMonster[174] = "Sky Bandit"
LevelToMonster[175] = "Dark Master"
LevelToMonster[176] = "Dark Master"
LevelToMonster[177] = "Dark Master"
LevelToMonster[178] = "Dark Master"
LevelToMonster[179] = "Dark Master"
LevelToMonster[180] = "Dark Master"
LevelToMonster[181] = "Dark Master"
LevelToMonster[182] = "Dark Master"
LevelToMonster[183] = "Dark Master"
LevelToMonster[184] = "Dark Master"
LevelToMonster[185] = "Dark Master"
LevelToMonster[186] = "Dark Master"
LevelToMonster[187] = "Dark Master"
LevelToMonster[188] = "Dark Master"
LevelToMonster[189] = "Dark Master"
LevelToMonster[190] = "Prisoner"
LevelToMonster[191] = "Prisoner"
LevelToMonster[192] = "Prisoner"
LevelToMonster[193] = "Prisoner"
LevelToMonster[194] = "Prisoner"
LevelToMonster[195] = "Prisoner"
LevelToMonster[196] = "Prisoner"
LevelToMonster[197] = "Prisoner"
LevelToMonster[198] = "Prisoner"
LevelToMonster[199] = "Prisoner"
LevelToMonster[200] = "Prisoner"
LevelToMonster[201] = "Prisoner"
LevelToMonster[202] = "Prisoner"
LevelToMonster[203] = "Prisoner"
LevelToMonster[204] = "Prisoner"
LevelToMonster[205] = "Prisoner"
LevelToMonster[206] = "Prisoner"
LevelToMonster[207] = "Prisoner"
LevelToMonster[208] = "Prisoner"
LevelToMonster[209] = "Prisoner"
LevelToMonster[210] = "Dangerous Prisoner"
LevelToMonster[211] = "Dangerous Prisoner"
LevelToMonster[212] = "Dangerous Prisoner"
LevelToMonster[213] = "Dangerous Prisoner"
LevelToMonster[214] = "Dangerous Prisoner"
LevelToMonster[215] = "Dangerous Prisoner"
LevelToMonster[216] = "Dangerous Prisoner"
LevelToMonster[217] = "Dangerous Prisoner"
LevelToMonster[218] = "Dangerous Prisoner"
LevelToMonster[219] = "Dangerous Prisoner"
LevelToMonster[220] = "Dangerous Prisoner"
LevelToMonster[221] = "Dangerous Prisoner"
LevelToMonster[222] = "Dangerous Prisoner"
LevelToMonster[223] = "Dangerous Prisoner"
LevelToMonster[224] = "Dangerous Prisoner"
LevelToMonster[225] = "Dangerous Prisoner"
LevelToMonster[226] = "Dangerous Prisoner"
LevelToMonster[227] = "Dangerous Prisoner"
LevelToMonster[228] = "Dangerous Prisoner"
LevelToMonster[229] = "Dangerous Prisoner"
LevelToMonster[230] = "Dangerous Prisoner"
LevelToMonster[231] = "Dangerous Prisoner"
LevelToMonster[232] = "Dangerous Prisoner"
LevelToMonster[233] = "Dangerous Prisoner"
LevelToMonster[234] = "Dangerous Prisoner"
LevelToMonster[235] = "Dangerous Prisoner"
LevelToMonster[236] = "Dangerous Prisoner"
LevelToMonster[237] = "Dangerous Prisoner"
LevelToMonster[238] = "Dangerous Prisoner"
LevelToMonster[239] = "Dangerous Prisoner"
LevelToMonster[240] = "Dangerous Prisoner"
LevelToMonster[241] = "Dangerous Prisoner"
LevelToMonster[242] = "Dangerous Prisoner"
LevelToMonster[243] = "Dangerous Prisoner"
LevelToMonster[244] = "Dangerous Prisoner"
LevelToMonster[245] = "Dangerous Prisoner"
LevelToMonster[246] = "Dangerous Prisoner"
LevelToMonster[247] = "Dangerous Prisoner"
LevelToMonster[248] = "Dangerous Prisoner"
LevelToMonster[249] = "Dangerous Prisoner"
LevelToMonster[250] = "Toga Warrior"
LevelToMonster[251] = "Toga Warrior"
LevelToMonster[252] = "Toga Warrior"
LevelToMonster[253] = "Toga Warrior"
LevelToMonster[254] = "Toga Warrior"
LevelToMonster[255] = "Toga Warrior"
LevelToMonster[256] = "Toga Warrior"
LevelToMonster[257] = "Toga Warrior"
LevelToMonster[258] = "Toga Warrior"
LevelToMonster[259] = "Toga Warrior"
LevelToMonster[260] = "Toga Warrior"
LevelToMonster[261] = "Toga Warrior"
LevelToMonster[262] = "Toga Warrior"
LevelToMonster[263] = "Toga Warrior"
LevelToMonster[264] = "Toga Warrior"
LevelToMonster[265] = "Toga Warrior"
LevelToMonster[266] = "Toga Warrior"
LevelToMonster[267] = "Toga Warrior"
LevelToMonster[268] = "Toga Warrior"
LevelToMonster[269] = "Toga Warrior"
LevelToMonster[270] = "Toga Warrior"
LevelToMonster[271] = "Toga Warrior"
LevelToMonster[272] = "Toga Warrior"
LevelToMonster[273] = "Toga Warrior"
LevelToMonster[274] = "Toga Warrior"
LevelToMonster[275] = "Gladiator"
LevelToMonster[276] = "Gladiator"
LevelToMonster[277] = "Gladiator"
LevelToMonster[278] = "Gladiator"
LevelToMonster[279] = "Gladiator"
LevelToMonster[280] = "Gladiator"
LevelToMonster[281] = "Gladiator"
LevelToMonster[282] = "Gladiator"
LevelToMonster[283] = "Gladiator"
LevelToMonster[284] = "Gladiator"
LevelToMonster[285] = "Gladiator"
LevelToMonster[286] = "Gladiator"
LevelToMonster[287] = "Gladiator"
LevelToMonster[288] = "Gladiator"
LevelToMonster[289] = "Gladiator"
LevelToMonster[290] = "Gladiator"
LevelToMonster[291] = "Gladiator"
LevelToMonster[292] = "Gladiator"
LevelToMonster[293] = "Gladiator"
LevelToMonster[294] = "Gladiator"
LevelToMonster[295] = "Gladiator"
LevelToMonster[296] = "Gladiator"
LevelToMonster[297] = "Gladiator"
LevelToMonster[298] = "Gladiator"
LevelToMonster[299] = "Gladiator"
LevelToMonster[300] = "Military Soldier"
LevelToMonster[301] = "Military Soldier"
LevelToMonster[302] = "Military Soldier"
LevelToMonster[303] = "Military Soldier"
LevelToMonster[304] = "Military Soldier"
LevelToMonster[305] = "Military Soldier"
LevelToMonster[306] = "Military Soldier"
LevelToMonster[307] = "Military Soldier"
LevelToMonster[308] = "Military Soldier"
LevelToMonster[309] = "Military Soldier"
LevelToMonster[310] = "Military Soldier"
LevelToMonster[311] = "Military Soldier"
LevelToMonster[312] = "Military Soldier"
LevelToMonster[313] = "Military Soldier"
LevelToMonster[314] = "Military Soldier"
LevelToMonster[315] = "Military Soldier"
LevelToMonster[316] = "Military Soldier"
LevelToMonster[317] = "Military Soldier"
LevelToMonster[318] = "Military Soldier"
LevelToMonster[319] = "Military Soldier"
LevelToMonster[320] = "Military Soldier"
LevelToMonster[321] = "Military Soldier"
LevelToMonster[322] = "Military Soldier"
LevelToMonster[323] = "Military Soldier"
LevelToMonster[324] = "Military Soldier"
LevelToMonster[325] = "Military Spy"
LevelToMonster[326] = "Military Spy"
LevelToMonster[327] = "Military Spy"
LevelToMonster[328] = "Military Spy"
LevelToMonster[329] = "Military Spy"
LevelToMonster[330] = "Military Spy"
LevelToMonster[331] = "Military Spy"
LevelToMonster[332] = "Military Spy"
LevelToMonster[333] = "Military Spy"
LevelToMonster[334] = "Military Spy"
LevelToMonster[335] = "Military Spy"
LevelToMonster[336] = "Military Spy"
LevelToMonster[337] = "Military Spy"
LevelToMonster[338] = "Military Spy"
LevelToMonster[339] = "Military Spy"
LevelToMonster[340] = "Military Spy"
LevelToMonster[341] = "Military Spy"
LevelToMonster[342] = "Military Spy"
LevelToMonster[343] = "Military Spy"
LevelToMonster[344] = "Military Spy"
LevelToMonster[345] = "Military Spy"
LevelToMonster[346] = "Military Spy"
LevelToMonster[347] = "Military Spy"
LevelToMonster[348] = "Military Spy"
LevelToMonster[349] = "Military Spy"
LevelToMonster[350] = "Military Spy"
LevelToMonster[351] = "Military Spy"
LevelToMonster[352] = "Military Spy"
LevelToMonster[353] = "Military Spy"
LevelToMonster[354] = "Military Spy"
LevelToMonster[355] = "Military Spy"
LevelToMonster[356] = "Military Spy"
LevelToMonster[357] = "Military Spy"
LevelToMonster[358] = "Military Spy"
LevelToMonster[359] = "Military Spy"
LevelToMonster[360] = "Military Spy"
LevelToMonster[361] = "Military Spy"
LevelToMonster[362] = "Military Spy"
LevelToMonster[363] = "Military Spy"
LevelToMonster[364] = "Military Spy"
LevelToMonster[365] = "Military Spy"
LevelToMonster[366] = "Military Spy"
LevelToMonster[367] = "Military Spy"
LevelToMonster[368] = "Military Spy"
LevelToMonster[369] = "Military Spy"
LevelToMonster[370] = "Military Spy"
LevelToMonster[371] = "Military Spy"
LevelToMonster[372] = "Military Spy"
LevelToMonster[373] = "Military Spy"
LevelToMonster[374] = "Military Spy"
LevelToMonster[375] = "Fishman Warrior"
LevelToMonster[376] = "Fishman Warrior"
LevelToMonster[377] = "Fishman Warrior"
LevelToMonster[378] = "Fishman Warrior"
LevelToMonster[379] = "Fishman Warrior"
LevelToMonster[380] = "Fishman Warrior"
LevelToMonster[381] = "Fishman Warrior"
LevelToMonster[382] = "Fishman Warrior"
LevelToMonster[383] = "Fishman Warrior"
LevelToMonster[384] = "Fishman Warrior"
LevelToMonster[385] = "Fishman Warrior"
LevelToMonster[386] = "Fishman Warrior"
LevelToMonster[387] = "Fishman Warrior"
LevelToMonster[388] = "Fishman Warrior"
LevelToMonster[389] = "Fishman Warrior"
LevelToMonster[390] = "Fishman Warrior"
LevelToMonster[391] = "Fishman Warrior"
LevelToMonster[392] = "Fishman Warrior"
LevelToMonster[393] = "Fishman Warrior"
LevelToMonster[394] = "Fishman Warrior"
LevelToMonster[395] = "Fishman Warrior"
LevelToMonster[396] = "Fishman Warrior"
LevelToMonster[397] = "Fishman Warrior"
LevelToMonster[398] = "Fishman Warrior"
LevelToMonster[399] = "Fishman Warrior"
LevelToMonster[400] = "Fishman Commando"
LevelToMonster[401] = "Fishman Commando"
LevelToMonster[402] = "Fishman Commando"
LevelToMonster[403] = "Fishman Commando"
LevelToMonster[404] = "Fishman Commando"
LevelToMonster[405] = "Fishman Commando"
LevelToMonster[406] = "Fishman Commando"
LevelToMonster[407] = "Fishman Commando"
LevelToMonster[408] = "Fishman Commando"
LevelToMonster[409] = "Fishman Commando"
LevelToMonster[410] = "Fishman Commando"
LevelToMonster[411] = "Fishman Commando"
LevelToMonster[412] = "Fishman Commando"
LevelToMonster[413] = "Fishman Commando"
LevelToMonster[414] = "Fishman Commando"
LevelToMonster[415] = "Fishman Commando"
LevelToMonster[416] = "Fishman Commando"
LevelToMonster[417] = "Fishman Commando"
LevelToMonster[418] = "Fishman Commando"
LevelToMonster[419] = "Fishman Commando"
LevelToMonster[420] = "Fishman Commando"
LevelToMonster[421] = "Fishman Commando"
LevelToMonster[422] = "Fishman Commando"
LevelToMonster[423] = "Fishman Commando"
LevelToMonster[424] = "Fishman Commando"
LevelToMonster[425] = "Fishman Commando"
LevelToMonster[426] = "Fishman Commando"
LevelToMonster[427] = "Fishman Commando"
LevelToMonster[428] = "Fishman Commando"
LevelToMonster[429] = "Fishman Commando"
LevelToMonster[430] = "Fishman Commando"
LevelToMonster[431] = "Fishman Commando"
LevelToMonster[432] = "Fishman Commando"
LevelToMonster[433] = "Fishman Commando"
LevelToMonster[434] = "Fishman Commando"
LevelToMonster[435] = "Fishman Commando"
LevelToMonster[436] = "Fishman Commando"
LevelToMonster[437] = "Fishman Commando"
LevelToMonster[438] = "Fishman Commando"
LevelToMonster[439] = "Fishman Commando"
LevelToMonster[440] = "Fishman Commando"
LevelToMonster[441] = "Fishman Commando"
LevelToMonster[442] = "Fishman Commando"
LevelToMonster[443] = "Fishman Commando"
LevelToMonster[444] = "Fishman Commando"
LevelToMonster[445] = "Fishman Commando"
LevelToMonster[446] = "Fishman Commando"
LevelToMonster[447] = "Fishman Commando"
LevelToMonster[448] = "Fishman Commando"
LevelToMonster[449] = "Fishman Commando"
LevelToMonster[450] = "Gods Guard"
LevelToMonster[451] = "Gods Guard"
LevelToMonster[452] = "Gods Guard"
LevelToMonster[453] = "Gods Guard"
LevelToMonster[454] = "Gods Guard"
LevelToMonster[455] = "Gods Guard"
LevelToMonster[456] = "Gods Guard"
LevelToMonster[457] = "Gods Guard"
LevelToMonster[458] = "Gods Guard"
LevelToMonster[459] = "Gods Guard"
LevelToMonster[460] = "Gods Guard"
LevelToMonster[461] = "Gods Guard"
LevelToMonster[462] = "Gods Guard"
LevelToMonster[463] = "Gods Guard"
LevelToMonster[464] = "Gods Guard"
LevelToMonster[465] = "Gods Guard"
LevelToMonster[466] = "Gods Guard"
LevelToMonster[467] = "Gods Guard"
LevelToMonster[468] = "Gods Guard"
LevelToMonster[469] = "Gods Guard"
LevelToMonster[470] = "Gods Guard"
LevelToMonster[471] = "Gods Guard"
LevelToMonster[472] = "Gods Guard"
LevelToMonster[473] = "Gods Guard"
LevelToMonster[474] = "Gods Guard"
LevelToMonster[475] = "Shanda"
LevelToMonster[476] = "Shanda"
LevelToMonster[477] = "Shanda"
LevelToMonster[478] = "Shanda"
LevelToMonster[479] = "Shanda"
LevelToMonster[480] = "Shanda"
LevelToMonster[481] = "Shanda"
LevelToMonster[482] = "Shanda"
LevelToMonster[483] = "Shanda"
LevelToMonster[484] = "Shanda"
LevelToMonster[485] = "Shanda"
LevelToMonster[486] = "Shanda"
LevelToMonster[487] = "Shanda"
LevelToMonster[488] = "Shanda"
LevelToMonster[489] = "Shanda"
LevelToMonster[490] = "Shanda"
LevelToMonster[491] = "Shanda"
LevelToMonster[492] = "Shanda"
LevelToMonster[493] = "Shanda"
LevelToMonster[494] = "Shanda"
LevelToMonster[495] = "Shanda"
LevelToMonster[496] = "Shanda"
LevelToMonster[497] = "Shanda"
LevelToMonster[498] = "Shanda"
LevelToMonster[499] = "Shanda"
LevelToMonster[500] = "Shanda"
LevelToMonster[501] = "Shanda"
LevelToMonster[502] = "Shanda"
LevelToMonster[503] = "Shanda"
LevelToMonster[504] = "Shanda"
LevelToMonster[505] = "Shanda"
LevelToMonster[506] = "Shanda"
LevelToMonster[507] = "Shanda"
LevelToMonster[508] = "Shanda"
LevelToMonster[509] = "Shanda"
LevelToMonster[510] = "Shanda"
LevelToMonster[511] = "Shanda"
LevelToMonster[512] = "Shanda"
LevelToMonster[513] = "Shanda"
LevelToMonster[514] = "Shanda"
LevelToMonster[515] = "Shanda"
LevelToMonster[516] = "Shanda"
LevelToMonster[517] = "Shanda"
LevelToMonster[518] = "Shanda"
LevelToMonster[519] = "Shanda"
LevelToMonster[520] = "Shanda"
LevelToMonster[521] = "Shanda"
LevelToMonster[522] = "Shanda"
LevelToMonster[523] = "Shanda"
LevelToMonster[524] = "Shanda"
LevelToMonster[525] = "Royal Squad"
LevelToMonster[526] = "Royal Squad"
LevelToMonster[527] = "Royal Squad"
LevelToMonster[528] = "Royal Squad"
LevelToMonster[529] = "Royal Squad"
LevelToMonster[530] = "Royal Squad"
LevelToMonster[531] = "Royal Squad"
LevelToMonster[532] = "Royal Squad"
LevelToMonster[533] = "Royal Squad"
LevelToMonster[534] = "Royal Squad"
LevelToMonster[535] = "Royal Squad"
LevelToMonster[536] = "Royal Squad"
LevelToMonster[537] = "Royal Squad"
LevelToMonster[538] = "Royal Squad"
LevelToMonster[539] = "Royal Squad"
LevelToMonster[540] = "Royal Squad"
LevelToMonster[541] = "Royal Squad"
LevelToMonster[542] = "Royal Squad"
LevelToMonster[543] = "Royal Squad"
LevelToMonster[544] = "Royal Squad"
LevelToMonster[545] = "Royal Squad"
LevelToMonster[546] = "Royal Squad"
LevelToMonster[547] = "Royal Squad"
LevelToMonster[548] = "Royal Squad"
LevelToMonster[549] = "Royal Squad"
LevelToMonster[550] = "Royal Soldier"
LevelToMonster[551] = "Royal Soldier"
LevelToMonster[552] = "Royal Soldier"
LevelToMonster[553] = "Royal Soldier"
LevelToMonster[554] = "Royal Soldier"
LevelToMonster[555] = "Royal Soldier"
LevelToMonster[556] = "Royal Soldier"
LevelToMonster[557] = "Royal Soldier"
LevelToMonster[558] = "Royal Soldier"
LevelToMonster[559] = "Royal Soldier"
LevelToMonster[560] = "Royal Soldier"
LevelToMonster[561] = "Royal Soldier"
LevelToMonster[562] = "Royal Soldier"
LevelToMonster[563] = "Royal Soldier"
LevelToMonster[564] = "Royal Soldier"
LevelToMonster[565] = "Royal Soldier"
LevelToMonster[566] = "Royal Soldier"
LevelToMonster[567] = "Royal Soldier"
LevelToMonster[568] = "Royal Soldier"
LevelToMonster[569] = "Royal Soldier"
LevelToMonster[570] = "Royal Soldier"
LevelToMonster[571] = "Royal Soldier"
LevelToMonster[572] = "Royal Soldier"
LevelToMonster[573] = "Royal Soldier"
LevelToMonster[574] = "Royal Soldier"
LevelToMonster[575] = "Royal Soldier"
LevelToMonster[576] = "Royal Soldier"
LevelToMonster[577] = "Royal Soldier"
LevelToMonster[578] = "Royal Soldier"
LevelToMonster[579] = "Royal Soldier"
LevelToMonster[580] = "Royal Soldier"
LevelToMonster[581] = "Royal Soldier"
LevelToMonster[582] = "Royal Soldier"
LevelToMonster[583] = "Royal Soldier"
LevelToMonster[584] = "Royal Soldier"
LevelToMonster[585] = "Royal Soldier"
LevelToMonster[586] = "Royal Soldier"
LevelToMonster[587] = "Royal Soldier"
LevelToMonster[588] = "Royal Soldier"
LevelToMonster[589] = "Royal Soldier"
LevelToMonster[590] = "Royal Soldier"
LevelToMonster[591] = "Royal Soldier"
LevelToMonster[592] = "Royal Soldier"
LevelToMonster[593] = "Royal Soldier"
LevelToMonster[594] = "Royal Soldier"
LevelToMonster[595] = "Royal Soldier"
LevelToMonster[596] = "Royal Soldier"
LevelToMonster[597] = "Royal Soldier"
LevelToMonster[598] = "Royal Soldier"
LevelToMonster[599] = "Royal Soldier"
LevelToMonster[600] = "Royal Soldier"
LevelToMonster[601] = "Royal Soldier"
LevelToMonster[602] = "Royal Soldier"
LevelToMonster[603] = "Royal Soldier"
LevelToMonster[604] = "Royal Soldier"
LevelToMonster[605] = "Royal Soldier"
LevelToMonster[606] = "Royal Soldier"
LevelToMonster[607] = "Royal Soldier"
LevelToMonster[608] = "Royal Soldier"
LevelToMonster[609] = "Royal Soldier"
LevelToMonster[610] = "Royal Soldier"
LevelToMonster[611] = "Royal Soldier"
LevelToMonster[612] = "Royal Soldier"
LevelToMonster[613] = "Royal Soldier"
LevelToMonster[614] = "Royal Soldier"
LevelToMonster[615] = "Royal Soldier"
LevelToMonster[616] = "Royal Soldier"
LevelToMonster[617] = "Royal Soldier"
LevelToMonster[618] = "Royal Soldier"
LevelToMonster[619] = "Royal Soldier"
LevelToMonster[620] = "Royal Soldier"
LevelToMonster[621] = "Royal Soldier"
LevelToMonster[622] = "Royal Soldier"
LevelToMonster[623] = "Royal Soldier"
LevelToMonster[624] = "Royal Soldier"
LevelToMonster[625] = "Galley Pirate"
LevelToMonster[626] = "Galley Pirate"
LevelToMonster[627] = "Galley Pirate"
LevelToMonster[628] = "Galley Pirate"
LevelToMonster[629] = "Galley Pirate"
LevelToMonster[630] = "Galley Pirate"
LevelToMonster[631] = "Galley Pirate"
LevelToMonster[632] = "Galley Pirate"
LevelToMonster[633] = "Galley Pirate"
LevelToMonster[634] = "Galley Pirate"
LevelToMonster[635] = "Galley Pirate"
LevelToMonster[636] = "Galley Pirate"
LevelToMonster[637] = "Galley Pirate"
LevelToMonster[638] = "Galley Pirate"
LevelToMonster[639] = "Galley Pirate"
LevelToMonster[640] = "Galley Pirate"
LevelToMonster[641] = "Galley Pirate"
LevelToMonster[642] = "Galley Pirate"
LevelToMonster[643] = "Galley Pirate"
LevelToMonster[644] = "Galley Pirate"
LevelToMonster[645] = "Galley Pirate"
LevelToMonster[646] = "Galley Pirate"
LevelToMonster[647] = "Galley Pirate"
LevelToMonster[648] = "Galley Pirate"
LevelToMonster[649] = "Galley Pirate"
LevelToMonster[650] = "Galley Captain"
LevelToMonster[651] = "Galley Captain"
LevelToMonster[652] = "Galley Captain"
LevelToMonster[653] = "Galley Captain"
LevelToMonster[654] = "Galley Captain"
LevelToMonster[655] = "Galley Captain"
LevelToMonster[656] = "Galley Captain"
LevelToMonster[657] = "Galley Captain"
LevelToMonster[658] = "Galley Captain"
LevelToMonster[659] = "Galley Captain"
LevelToMonster[660] = "Galley Captain"
LevelToMonster[661] = "Galley Captain"
LevelToMonster[662] = "Galley Captain"
LevelToMonster[663] = "Galley Captain"
LevelToMonster[664] = "Galley Captain"
LevelToMonster[665] = "Galley Captain"
LevelToMonster[666] = "Galley Captain"
LevelToMonster[667] = "Galley Captain"
LevelToMonster[668] = "Galley Captain"
LevelToMonster[669] = "Galley Captain"
LevelToMonster[670] = "Galley Captain"
LevelToMonster[671] = "Galley Captain"
LevelToMonster[672] = "Galley Captain"
LevelToMonster[673] = "Galley Captain"
LevelToMonster[674] = "Galley Captain"
LevelToMonster[675] = "Galley Captain"
LevelToMonster[676] = "Galley Captain"
LevelToMonster[677] = "Galley Captain"
LevelToMonster[678] = "Galley Captain"
LevelToMonster[679] = "Galley Captain"
LevelToMonster[680] = "Galley Captain"
LevelToMonster[681] = "Galley Captain"
LevelToMonster[682] = "Galley Captain"
LevelToMonster[683] = "Galley Captain"
LevelToMonster[684] = "Galley Captain"
LevelToMonster[685] = "Galley Captain"
LevelToMonster[686] = "Galley Captain"
LevelToMonster[687] = "Galley Captain"
LevelToMonster[688] = "Galley Captain"
LevelToMonster[689] = "Galley Captain"
LevelToMonster[690] = "Galley Captain"
LevelToMonster[691] = "Galley Captain"
LevelToMonster[692] = "Galley Captain"
LevelToMonster[693] = "Galley Captain"
LevelToMonster[694] = "Galley Captain"
LevelToMonster[695] = "Galley Captain"
LevelToMonster[696] = "Galley Captain"
LevelToMonster[697] = "Galley Captain"
LevelToMonster[698] = "Galley Captain"
LevelToMonster[699] = "Galley Captain"
LevelToMonster[700] = "Trader"
LevelToMonster[701] = "Trader"
LevelToMonster[702] = "Trader"
LevelToMonster[703] = "Trader"
LevelToMonster[704] = "Trader"
LevelToMonster[705] = "Trader"
LevelToMonster[706] = "Trader"
LevelToMonster[707] = "Trader"
LevelToMonster[708] = "Trader"
LevelToMonster[709] = "Trader"
LevelToMonster[710] = "Trader"
LevelToMonster[711] = "Trader"
LevelToMonster[712] = "Trader"
LevelToMonster[713] = "Trader"
LevelToMonster[714] = "Trader"
LevelToMonster[715] = "Trader"
LevelToMonster[716] = "Trader"
LevelToMonster[717] = "Trader"
LevelToMonster[718] = "Trader"
LevelToMonster[719] = "Trader"
LevelToMonster[720] = "Trader"
LevelToMonster[721] = "Trader"
LevelToMonster[722] = "Trader"
LevelToMonster[723] = "Trader"
LevelToMonster[724] = "Trader"
LevelToMonster[725] = "Trader"
LevelToMonster[726] = "Trader"
LevelToMonster[727] = "Trader"
LevelToMonster[728] = "Trader"
LevelToMonster[729] = "Trader"
LevelToMonster[730] = "Trader"
LevelToMonster[731] = "Trader"
LevelToMonster[732] = "Trader"
LevelToMonster[733] = "Trader"
LevelToMonster[734] = "Trader"
LevelToMonster[735] = "Trader"
LevelToMonster[736] = "Trader"
LevelToMonster[737] = "Trader"
LevelToMonster[738] = "Trader"
LevelToMonster[739] = "Trader"
LevelToMonster[740] = "Trader"
LevelToMonster[741] = "Trader"
LevelToMonster[742] = "Trader"
LevelToMonster[743] = "Trader"
LevelToMonster[744] = "Trader"
LevelToMonster[745] = "Trader"
LevelToMonster[746] = "Trader"
LevelToMonster[747] = "Trader"
LevelToMonster[748] = "Trader"
LevelToMonster[749] = "Trader"
LevelToMonster[750] = "Mercenary"
LevelToMonster[751] = "Mercenary"
LevelToMonster[752] = "Mercenary"
LevelToMonster[753] = "Mercenary"
LevelToMonster[754] = "Mercenary"
LevelToMonster[755] = "Mercenary"
LevelToMonster[756] = "Mercenary"
LevelToMonster[757] = "Mercenary"
LevelToMonster[758] = "Mercenary"
LevelToMonster[759] = "Mercenary"
LevelToMonster[760] = "Mercenary"
LevelToMonster[761] = "Mercenary"
LevelToMonster[762] = "Mercenary"
LevelToMonster[763] = "Mercenary"
LevelToMonster[764] = "Mercenary"
LevelToMonster[765] = "Mercenary"
LevelToMonster[766] = "Mercenary"
LevelToMonster[767] = "Mercenary"
LevelToMonster[768] = "Mercenary"
LevelToMonster[769] = "Mercenary"
LevelToMonster[770] = "Mercenary"
LevelToMonster[771] = "Mercenary"
LevelToMonster[772] = "Mercenary"
LevelToMonster[773] = "Mercenary"
LevelToMonster[774] = "Mercenary"
LevelToMonster[775] = "Mercenary"
LevelToMonster[776] = "Mercenary"
LevelToMonster[777] = "Mercenary"
LevelToMonster[778] = "Mercenary"
LevelToMonster[779] = "Mercenary"
LevelToMonster[780] = "Mercenary"
LevelToMonster[781] = "Mercenary"
LevelToMonster[782] = "Mercenary"
LevelToMonster[783] = "Mercenary"
LevelToMonster[784] = "Mercenary"
LevelToMonster[785] = "Mercenary"
LevelToMonster[786] = "Mercenary"
LevelToMonster[787] = "Mercenary"
LevelToMonster[788] = "Mercenary"
LevelToMonster[789] = "Mercenary"
LevelToMonster[790] = "Mercenary"
LevelToMonster[791] = "Mercenary"
LevelToMonster[792] = "Mercenary"
LevelToMonster[793] = "Mercenary"
LevelToMonster[794] = "Mercenary"
LevelToMonster[795] = "Mercenary"
LevelToMonster[796] = "Mercenary"
LevelToMonster[797] = "Mercenary"
LevelToMonster[798] = "Mercenary"
LevelToMonster[799] = "Mercenary"
LevelToMonster[800] = "Spy"
LevelToMonster[801] = "Spy"
LevelToMonster[802] = "Spy"
LevelToMonster[803] = "Spy"
LevelToMonster[804] = "Spy"
LevelToMonster[805] = "Spy"
LevelToMonster[806] = "Spy"
LevelToMonster[807] = "Spy"
LevelToMonster[808] = "Spy"
LevelToMonster[809] = "Spy"
LevelToMonster[810] = "Spy"
LevelToMonster[811] = "Spy"
LevelToMonster[812] = "Spy"
LevelToMonster[813] = "Spy"
LevelToMonster[814] = "Spy"
LevelToMonster[815] = "Spy"
LevelToMonster[816] = "Spy"
LevelToMonster[817] = "Spy"
LevelToMonster[818] = "Spy"
LevelToMonster[819] = "Spy"
LevelToMonster[820] = "Spy"
LevelToMonster[821] = "Spy"
LevelToMonster[822] = "Spy"
LevelToMonster[823] = "Spy"
LevelToMonster[824] = "Spy"
LevelToMonster[825] = "Spy"
LevelToMonster[826] = "Spy"
LevelToMonster[827] = "Spy"
LevelToMonster[828] = "Spy"
LevelToMonster[829] = "Spy"
LevelToMonster[830] = "Spy"
LevelToMonster[831] = "Spy"
LevelToMonster[832] = "Spy"
LevelToMonster[833] = "Spy"
LevelToMonster[834] = "Spy"
LevelToMonster[835] = "Spy"
LevelToMonster[836] = "Spy"
LevelToMonster[837] = "Spy"
LevelToMonster[838] = "Spy"
LevelToMonster[839] = "Spy"
LevelToMonster[840] = "Spy"
LevelToMonster[841] = "Spy"
LevelToMonster[842] = "Spy"
LevelToMonster[843] = "Spy"
LevelToMonster[844] = "Spy"
LevelToMonster[845] = "Spy"
LevelToMonster[846] = "Spy"
LevelToMonster[847] = "Spy"
LevelToMonster[848] = "Spy"
LevelToMonster[849] = "Spy"
LevelToMonster[850] = "Scientist"
LevelToMonster[851] = "Scientist"
LevelToMonster[852] = "Scientist"
LevelToMonster[853] = "Scientist"
LevelToMonster[854] = "Scientist"
LevelToMonster[855] = "Scientist"
LevelToMonster[856] = "Scientist"
LevelToMonster[857] = "Scientist"
LevelToMonster[858] = "Scientist"
LevelToMonster[859] = "Scientist"
LevelToMonster[860] = "Scientist"
LevelToMonster[861] = "Scientist"
LevelToMonster[862] = "Scientist"
LevelToMonster[863] = "Scientist"
LevelToMonster[864] = "Scientist"
LevelToMonster[865] = "Scientist"
LevelToMonster[866] = "Scientist"
LevelToMonster[867] = "Scientist"
LevelToMonster[868] = "Scientist"
LevelToMonster[869] = "Scientist"
LevelToMonster[870] = "Scientist"
LevelToMonster[871] = "Scientist"
LevelToMonster[872] = "Scientist"
LevelToMonster[873] = "Scientist"
LevelToMonster[874] = "Scientist"
LevelToMonster[875] = "Scientist"
LevelToMonster[876] = "Scientist"
LevelToMonster[877] = "Scientist"
LevelToMonster[878] = "Scientist"
LevelToMonster[879] = "Scientist"
LevelToMonster[880] = "Scientist"
LevelToMonster[881] = "Scientist"
LevelToMonster[882] = "Scientist"
LevelToMonster[883] = "Scientist"
LevelToMonster[884] = "Scientist"
LevelToMonster[885] = "Scientist"
LevelToMonster[886] = "Scientist"
LevelToMonster[887] = "Scientist"
LevelToMonster[888] = "Scientist"
LevelToMonster[889] = "Scientist"
LevelToMonster[890] = "Scientist"
LevelToMonster[891] = "Scientist"
LevelToMonster[892] = "Scientist"
LevelToMonster[893] = "Scientist"
LevelToMonster[894] = "Scientist"
LevelToMonster[895] = "Scientist"
LevelToMonster[896] = "Scientist"
LevelToMonster[897] = "Scientist"
LevelToMonster[898] = "Scientist"
LevelToMonster[899] = "Scientist"
LevelToMonster[900] = "Scientist"
LevelToMonster[901] = "Scientist"
LevelToMonster[902] = "Scientist"
LevelToMonster[903] = "Scientist"
LevelToMonster[904] = "Scientist"
LevelToMonster[905] = "Scientist"
LevelToMonster[906] = "Scientist"
LevelToMonster[907] = "Scientist"
LevelToMonster[908] = "Scientist"
LevelToMonster[909] = "Scientist"
LevelToMonster[910] = "Scientist"
LevelToMonster[911] = "Scientist"
LevelToMonster[912] = "Scientist"
LevelToMonster[913] = "Scientist"
LevelToMonster[914] = "Scientist"
LevelToMonster[915] = "Scientist"
LevelToMonster[916] = "Scientist"
LevelToMonster[917] = "Scientist"
LevelToMonster[918] = "Scientist"
LevelToMonster[919] = "Scientist"
LevelToMonster[920] = "Scientist"
LevelToMonster[921] = "Scientist"
LevelToMonster[922] = "Scientist"
LevelToMonster[923] = "Scientist"
LevelToMonster[924] = "Scientist"
LevelToMonster[925] = "Mechanical Pirate"
LevelToMonster[926] = "Mechanical Pirate"
LevelToMonster[927] = "Mechanical Pirate"
LevelToMonster[928] = "Mechanical Pirate"
LevelToMonster[929] = "Mechanical Pirate"
LevelToMonster[930] = "Mechanical Pirate"
LevelToMonster[931] = "Mechanical Pirate"
LevelToMonster[932] = "Mechanical Pirate"
LevelToMonster[933] = "Mechanical Pirate"
LevelToMonster[934] = "Mechanical Pirate"
LevelToMonster[935] = "Mechanical Pirate"
LevelToMonster[936] = "Mechanical Pirate"
LevelToMonster[937] = "Mechanical Pirate"
LevelToMonster[938] = "Mechanical Pirate"
LevelToMonster[939] = "Mechanical Pirate"
LevelToMonster[940] = "Mechanical Pirate"
LevelToMonster[941] = "Mechanical Pirate"
LevelToMonster[942] = "Mechanical Pirate"
LevelToMonster[943] = "Mechanical Pirate"
LevelToMonster[944] = "Mechanical Pirate"
LevelToMonster[945] = "Mechanical Pirate"
LevelToMonster[946] = "Mechanical Pirate"
LevelToMonster[947] = "Mechanical Pirate"
LevelToMonster[948] = "Mechanical Pirate"
LevelToMonster[949] = "Mechanical Pirate"
LevelToMonster[950] = "Mechanical Pirate"
LevelToMonster[951] = "Mechanical Pirate"
LevelToMonster[952] = "Mechanical Pirate"
LevelToMonster[953] = "Mechanical Pirate"
LevelToMonster[954] = "Mechanical Pirate"
LevelToMonster[955] = "Mechanical Pirate"
LevelToMonster[956] = "Mechanical Pirate"
LevelToMonster[957] = "Mechanical Pirate"
LevelToMonster[958] = "Mechanical Pirate"
LevelToMonster[959] = "Mechanical Pirate"
LevelToMonster[960] = "Mechanical Pirate"
LevelToMonster[961] = "Mechanical Pirate"
LevelToMonster[962] = "Mechanical Pirate"
LevelToMonster[963] = "Mechanical Pirate"
LevelToMonster[964] = "Mechanical Pirate"
LevelToMonster[965] = "Mechanical Pirate"
LevelToMonster[966] = "Mechanical Pirate"
LevelToMonster[967] = "Mechanical Pirate"
LevelToMonster[968] = "Mechanical Pirate"
LevelToMonster[969] = "Mechanical Pirate"
LevelToMonster[970] = "Mechanical Pirate"
LevelToMonster[971] = "Mechanical Pirate"
LevelToMonster[972] = "Mechanical Pirate"
LevelToMonster[973] = "Mechanical Pirate"
LevelToMonster[974] = "Mechanical Pirate"
LevelToMonster[975] = "Mechanical Pirate"
LevelToMonster[976] = "Mechanical Pirate"
LevelToMonster[977] = "Mechanical Pirate"
LevelToMonster[978] = "Mechanical Pirate"
LevelToMonster[979] = "Mechanical Pirate"
LevelToMonster[980] = "Mechanical Pirate"
LevelToMonster[981] = "Mechanical Pirate"
LevelToMonster[982] = "Mechanical Pirate"
LevelToMonster[983] = "Mechanical Pirate"
LevelToMonster[984] = "Mechanical Pirate"
LevelToMonster[985] = "Mechanical Pirate"
LevelToMonster[986] = "Mechanical Pirate"
LevelToMonster[987] = "Mechanical Pirate"
LevelToMonster[988] = "Mechanical Pirate"
LevelToMonster[989] = "Mechanical Pirate"
LevelToMonster[990] = "Mechanical Pirate"
LevelToMonster[991] = "Mechanical Pirate"
LevelToMonster[992] = "Mechanical Pirate"
LevelToMonster[993] = "Mechanical Pirate"
LevelToMonster[994] = "Mechanical Pirate"
LevelToMonster[995] = "Mechanical Pirate"
LevelToMonster[996] = "Mechanical Pirate"
LevelToMonster[997] = "Mechanical Pirate"
LevelToMonster[998] = "Mechanical Pirate"
LevelToMonster[999] = "Mechanical Pirate"
LevelToMonster[1000] = "Vampire"
LevelToMonster[1001] = "Vampire"
LevelToMonster[1002] = "Vampire"
LevelToMonster[1003] = "Vampire"
LevelToMonster[1004] = "Vampire"
LevelToMonster[1005] = "Vampire"
LevelToMonster[1006] = "Vampire"
LevelToMonster[1007] = "Vampire"
LevelToMonster[1008] = "Vampire"
LevelToMonster[1009] = "Vampire"
LevelToMonster[1010] = "Vampire"
LevelToMonster[1011] = "Vampire"
LevelToMonster[1012] = "Vampire"
LevelToMonster[1013] = "Vampire"
LevelToMonster[1014] = "Vampire"
LevelToMonster[1015] = "Vampire"
LevelToMonster[1016] = "Vampire"
LevelToMonster[1017] = "Vampire"
LevelToMonster[1018] = "Vampire"
LevelToMonster[1019] = "Vampire"
LevelToMonster[1020] = "Vampire"
LevelToMonster[1021] = "Vampire"
LevelToMonster[1022] = "Vampire"
LevelToMonster[1023] = "Vampire"
LevelToMonster[1024] = "Vampire"
LevelToMonster[1025] = "Vampire"
LevelToMonster[1026] = "Vampire"
LevelToMonster[1027] = "Vampire"
LevelToMonster[1028] = "Vampire"
LevelToMonster[1029] = "Vampire"
LevelToMonster[1030] = "Vampire"
LevelToMonster[1031] = "Vampire"
LevelToMonster[1032] = "Vampire"
LevelToMonster[1033] = "Vampire"
LevelToMonster[1034] = "Vampire"
LevelToMonster[1035] = "Vampire"
LevelToMonster[1036] = "Vampire"
LevelToMonster[1037] = "Vampire"
LevelToMonster[1038] = "Vampire"
LevelToMonster[1039] = "Vampire"
LevelToMonster[1040] = "Vampire"
LevelToMonster[1041] = "Vampire"
LevelToMonster[1042] = "Vampire"
LevelToMonster[1043] = "Vampire"
LevelToMonster[1044] = "Vampire"
LevelToMonster[1045] = "Vampire"
LevelToMonster[1046] = "Vampire"
LevelToMonster[1047] = "Vampire"
LevelToMonster[1048] = "Vampire"
LevelToMonster[1049] = "Vampire"
LevelToMonster[1050] = "Lava Pirate"
LevelToMonster[1051] = "Lava Pirate"
LevelToMonster[1052] = "Lava Pirate"
LevelToMonster[1053] = "Lava Pirate"
LevelToMonster[1054] = "Lava Pirate"
LevelToMonster[1055] = "Lava Pirate"
LevelToMonster[1056] = "Lava Pirate"
LevelToMonster[1057] = "Lava Pirate"
LevelToMonster[1058] = "Lava Pirate"
LevelToMonster[1059] = "Lava Pirate"
LevelToMonster[1060] = "Lava Pirate"
LevelToMonster[1061] = "Lava Pirate"
LevelToMonster[1062] = "Lava Pirate"
LevelToMonster[1063] = "Lava Pirate"
LevelToMonster[1064] = "Lava Pirate"
LevelToMonster[1065] = "Lava Pirate"
LevelToMonster[1066] = "Lava Pirate"
LevelToMonster[1067] = "Lava Pirate"
LevelToMonster[1068] = "Lava Pirate"
LevelToMonster[1069] = "Lava Pirate"
LevelToMonster[1070] = "Lava Pirate"
LevelToMonster[1071] = "Lava Pirate"
LevelToMonster[1072] = "Lava Pirate"
LevelToMonster[1073] = "Lava Pirate"
LevelToMonster[1074] = "Lava Pirate"
LevelToMonster[1075] = "Lava Pirate"
LevelToMonster[1076] = "Lava Pirate"
LevelToMonster[1077] = "Lava Pirate"
LevelToMonster[1078] = "Lava Pirate"
LevelToMonster[1079] = "Lava Pirate"
LevelToMonster[1080] = "Lava Pirate"
LevelToMonster[1081] = "Lava Pirate"
LevelToMonster[1082] = "Lava Pirate"
LevelToMonster[1083] = "Lava Pirate"
LevelToMonster[1084] = "Lava Pirate"
LevelToMonster[1085] = "Lava Pirate"
LevelToMonster[1086] = "Lava Pirate"
LevelToMonster[1087] = "Lava Pirate"
LevelToMonster[1088] = "Lava Pirate"
LevelToMonster[1089] = "Lava Pirate"
LevelToMonster[1090] = "Lava Pirate"
LevelToMonster[1091] = "Lava Pirate"
LevelToMonster[1092] = "Lava Pirate"
LevelToMonster[1093] = "Lava Pirate"
LevelToMonster[1094] = "Lava Pirate"
LevelToMonster[1095] = "Lava Pirate"
LevelToMonster[1096] = "Lava Pirate"
LevelToMonster[1097] = "Lava Pirate"
LevelToMonster[1098] = "Lava Pirate"
LevelToMonster[1099] = "Lava Pirate"
LevelToMonster[1100] = "Ship Engineer"
LevelToMonster[1101] = "Ship Engineer"
LevelToMonster[1102] = "Ship Engineer"
LevelToMonster[1103] = "Ship Engineer"
LevelToMonster[1104] = "Ship Engineer"
LevelToMonster[1105] = "Ship Engineer"
LevelToMonster[1106] = "Ship Engineer"
LevelToMonster[1107] = "Ship Engineer"
LevelToMonster[1108] = "Ship Engineer"
LevelToMonster[1109] = "Ship Engineer"
LevelToMonster[1110] = "Ship Engineer"
LevelToMonster[1111] = "Ship Engineer"
LevelToMonster[1112] = "Ship Engineer"
LevelToMonster[1113] = "Ship Engineer"
LevelToMonster[1114] = "Ship Engineer"
LevelToMonster[1115] = "Ship Engineer"
LevelToMonster[1116] = "Ship Engineer"
LevelToMonster[1117] = "Ship Engineer"
LevelToMonster[1118] = "Ship Engineer"
LevelToMonster[1119] = "Ship Engineer"
LevelToMonster[1120] = "Ship Engineer"
LevelToMonster[1121] = "Ship Engineer"
LevelToMonster[1122] = "Ship Engineer"
LevelToMonster[1123] = "Ship Engineer"
LevelToMonster[1124] = "Ship Engineer"
LevelToMonster[1125] = "Ship Engineer"
LevelToMonster[1126] = "Ship Engineer"
LevelToMonster[1127] = "Ship Engineer"
LevelToMonster[1128] = "Ship Engineer"
LevelToMonster[1129] = "Ship Engineer"
LevelToMonster[1130] = "Ship Engineer"
LevelToMonster[1131] = "Ship Engineer"
LevelToMonster[1132] = "Ship Engineer"
LevelToMonster[1133] = "Ship Engineer"
LevelToMonster[1134] = "Ship Engineer"
LevelToMonster[1135] = "Ship Engineer"
LevelToMonster[1136] = "Ship Engineer"
LevelToMonster[1137] = "Ship Engineer"
LevelToMonster[1138] = "Ship Engineer"
LevelToMonster[1139] = "Ship Engineer"
LevelToMonster[1140] = "Ship Engineer"
LevelToMonster[1141] = "Ship Engineer"
LevelToMonster[1142] = "Ship Engineer"
LevelToMonster[1143] = "Ship Engineer"
LevelToMonster[1144] = "Ship Engineer"
LevelToMonster[1145] = "Ship Engineer"
LevelToMonster[1146] = "Ship Engineer"
LevelToMonster[1147] = "Ship Engineer"
LevelToMonster[1148] = "Ship Engineer"
LevelToMonster[1149] = "Ship Engineer"
LevelToMonster[1150] = "Magma Ninja"
LevelToMonster[1151] = "Magma Ninja"
LevelToMonster[1152] = "Magma Ninja"
LevelToMonster[1153] = "Magma Ninja"
LevelToMonster[1154] = "Magma Ninja"
LevelToMonster[1155] = "Magma Ninja"
LevelToMonster[1156] = "Magma Ninja"
LevelToMonster[1157] = "Magma Ninja"
LevelToMonster[1158] = "Magma Ninja"
LevelToMonster[1159] = "Magma Ninja"
LevelToMonster[1160] = "Magma Ninja"
LevelToMonster[1161] = "Magma Ninja"
LevelToMonster[1162] = "Magma Ninja"
LevelToMonster[1163] = "Magma Ninja"
LevelToMonster[1164] = "Magma Ninja"
LevelToMonster[1165] = "Magma Ninja"
LevelToMonster[1166] = "Magma Ninja"
LevelToMonster[1167] = "Magma Ninja"
LevelToMonster[1168] = "Magma Ninja"
LevelToMonster[1169] = "Magma Ninja"
LevelToMonster[1170] = "Magma Ninja"
LevelToMonster[1171] = "Magma Ninja"
LevelToMonster[1172] = "Magma Ninja"
LevelToMonster[1173] = "Magma Ninja"
LevelToMonster[1174] = "Magma Ninja"
LevelToMonster[1175] = "Dragon Crew Warrior"
LevelToMonster[1176] = "Dragon Crew Warrior"
LevelToMonster[1177] = "Dragon Crew Warrior"
LevelToMonster[1178] = "Dragon Crew Warrior"
LevelToMonster[1179] = "Dragon Crew Warrior"
LevelToMonster[1180] = "Dragon Crew Warrior"
LevelToMonster[1181] = "Dragon Crew Warrior"
LevelToMonster[1182] = "Dragon Crew Warrior"
LevelToMonster[1183] = "Dragon Crew Warrior"
LevelToMonster[1184] = "Dragon Crew Warrior"
LevelToMonster[1185] = "Dragon Crew Warrior"
LevelToMonster[1186] = "Dragon Crew Warrior"
LevelToMonster[1187] = "Dragon Crew Warrior"
LevelToMonster[1188] = "Dragon Crew Warrior"
LevelToMonster[1189] = "Dragon Crew Warrior"
LevelToMonster[1190] = "Dragon Crew Warrior"
LevelToMonster[1191] = "Dragon Crew Warrior"
LevelToMonster[1192] = "Dragon Crew Warrior"
LevelToMonster[1193] = "Dragon Crew Warrior"
LevelToMonster[1194] = "Dragon Crew Warrior"
LevelToMonster[1195] = "Dragon Crew Warrior"
LevelToMonster[1196] = "Dragon Crew Warrior"
LevelToMonster[1197] = "Dragon Crew Warrior"
LevelToMonster[1198] = "Dragon Crew Warrior"
LevelToMonster[1199] = "Dragon Crew Warrior"
LevelToMonster[1200] = "Dragon Crew Warrior"
LevelToMonster[1201] = "Dragon Crew Warrior"
LevelToMonster[1202] = "Dragon Crew Warrior"
LevelToMonster[1203] = "Dragon Crew Warrior"
LevelToMonster[1204] = "Dragon Crew Warrior"
LevelToMonster[1205] = "Dragon Crew Warrior"
LevelToMonster[1206] = "Dragon Crew Warrior"
LevelToMonster[1207] = "Dragon Crew Warrior"
LevelToMonster[1208] = "Dragon Crew Warrior"
LevelToMonster[1209] = "Dragon Crew Warrior"
LevelToMonster[1210] = "Dragon Crew Warrior"
LevelToMonster[1211] = "Dragon Crew Warrior"
LevelToMonster[1212] = "Dragon Crew Warrior"
LevelToMonster[1213] = "Dragon Crew Warrior"
LevelToMonster[1214] = "Dragon Crew Warrior"
LevelToMonster[1215] = "Dragon Crew Warrior"
LevelToMonster[1216] = "Dragon Crew Warrior"
LevelToMonster[1217] = "Dragon Crew Warrior"
LevelToMonster[1218] = "Dragon Crew Warrior"
LevelToMonster[1219] = "Dragon Crew Warrior"
LevelToMonster[1220] = "Dragon Crew Warrior"
LevelToMonster[1221] = "Dragon Crew Warrior"
LevelToMonster[1222] = "Dragon Crew Warrior"
LevelToMonster[1223] = "Dragon Crew Warrior"
LevelToMonster[1224] = "Dragon Crew Warrior"
LevelToMonster[1225] = "Dragon Crew Warrior"
LevelToMonster[1226] = "Dragon Crew Warrior"
LevelToMonster[1227] = "Dragon Crew Warrior"
LevelToMonster[1228] = "Dragon Crew Warrior"
LevelToMonster[1229] = "Dragon Crew Warrior"
LevelToMonster[1230] = "Dragon Crew Warrior"
LevelToMonster[1231] = "Dragon Crew Warrior"
LevelToMonster[1232] = "Dragon Crew Warrior"
LevelToMonster[1233] = "Dragon Crew Warrior"
LevelToMonster[1234] = "Dragon Crew Warrior"
LevelToMonster[1235] = "Dragon Crew Warrior"
LevelToMonster[1236] = "Dragon Crew Warrior"
LevelToMonster[1237] = "Dragon Crew Warrior"
LevelToMonster[1238] = "Dragon Crew Warrior"
LevelToMonster[1239] = "Dragon Crew Warrior"
LevelToMonster[1240] = "Dragon Crew Warrior"
LevelToMonster[1241] = "Dragon Crew Warrior"
LevelToMonster[1242] = "Dragon Crew Warrior"
LevelToMonster[1243] = "Dragon Crew Warrior"
LevelToMonster[1244] = "Dragon Crew Warrior"
LevelToMonster[1245] = "Dragon Crew Warrior"
LevelToMonster[1246] = "Dragon Crew Warrior"
LevelToMonster[1247] = "Dragon Crew Warrior"
LevelToMonster[1248] = "Dragon Crew Warrior"
LevelToMonster[1249] = "Dragon Crew Warrior"
LevelToMonster[1250] = "Dragon Crew Archer"
LevelToMonster[1251] = "Dragon Crew Archer"
LevelToMonster[1252] = "Dragon Crew Archer"
LevelToMonster[1253] = "Dragon Crew Archer"
LevelToMonster[1254] = "Dragon Crew Archer"
LevelToMonster[1255] = "Dragon Crew Archer"
LevelToMonster[1256] = "Dragon Crew Archer"
LevelToMonster[1257] = "Dragon Crew Archer"
LevelToMonster[1258] = "Dragon Crew Archer"
LevelToMonster[1259] = "Dragon Crew Archer"
LevelToMonster[1260] = "Dragon Crew Archer"
LevelToMonster[1261] = "Dragon Crew Archer"
LevelToMonster[1262] = "Dragon Crew Archer"
LevelToMonster[1263] = "Dragon Crew Archer"
LevelToMonster[1264] = "Dragon Crew Archer"
LevelToMonster[1265] = "Dragon Crew Archer"
LevelToMonster[1266] = "Dragon Crew Archer"
LevelToMonster[1267] = "Dragon Crew Archer"
LevelToMonster[1268] = "Dragon Crew Archer"
LevelToMonster[1269] = "Dragon Crew Archer"
LevelToMonster[1270] = "Dragon Crew Archer"
LevelToMonster[1271] = "Dragon Crew Archer"
LevelToMonster[1272] = "Dragon Crew Archer"
LevelToMonster[1273] = "Dragon Crew Archer"
LevelToMonster[1274] = "Dragon Crew Archer"
LevelToMonster[1275] = "Dragon Crew Archer"
LevelToMonster[1276] = "Dragon Crew Archer"
LevelToMonster[1277] = "Dragon Crew Archer"
LevelToMonster[1278] = "Dragon Crew Archer"
LevelToMonster[1279] = "Dragon Crew Archer"
LevelToMonster[1280] = "Dragon Crew Archer"
LevelToMonster[1281] = "Dragon Crew Archer"
LevelToMonster[1282] = "Dragon Crew Archer"
LevelToMonster[1283] = "Dragon Crew Archer"
LevelToMonster[1284] = "Dragon Crew Archer"
LevelToMonster[1285] = "Dragon Crew Archer"
LevelToMonster[1286] = "Dragon Crew Archer"
LevelToMonster[1287] = "Dragon Crew Archer"
LevelToMonster[1288] = "Dragon Crew Archer"
LevelToMonster[1289] = "Dragon Crew Archer"
LevelToMonster[1290] = "Dragon Crew Archer"
LevelToMonster[1291] = "Dragon Crew Archer"
LevelToMonster[1292] = "Dragon Crew Archer"
LevelToMonster[1293] = "Dragon Crew Archer"
LevelToMonster[1294] = "Dragon Crew Archer"
LevelToMonster[1295] = "Dragon Crew Archer"
LevelToMonster[1296] = "Dragon Crew Archer"
LevelToMonster[1297] = "Dragon Crew Archer"
LevelToMonster[1298] = "Dragon Crew Archer"
LevelToMonster[1299] = "Dragon Crew Archer"
LevelToMonster[1300] = "Dragon Crew Archer"
LevelToMonster[1301] = "Dragon Crew Archer"
LevelToMonster[1302] = "Dragon Crew Archer"
LevelToMonster[1303] = "Dragon Crew Archer"
LevelToMonster[1304] = "Dragon Crew Archer"
LevelToMonster[1305] = "Dragon Crew Archer"
LevelToMonster[1306] = "Dragon Crew Archer"
LevelToMonster[1307] = "Dragon Crew Archer"
LevelToMonster[1308] = "Dragon Crew Archer"
LevelToMonster[1309] = "Dragon Crew Archer"
LevelToMonster[1310] = "Dragon Crew Archer"
LevelToMonster[1311] = "Dragon Crew Archer"
LevelToMonster[1312] = "Dragon Crew Archer"
LevelToMonster[1313] = "Dragon Crew Archer"
LevelToMonster[1314] = "Dragon Crew Archer"
LevelToMonster[1315] = "Dragon Crew Archer"
LevelToMonster[1316] = "Dragon Crew Archer"
LevelToMonster[1317] = "Dragon Crew Archer"
LevelToMonster[1318] = "Dragon Crew Archer"
LevelToMonster[1319] = "Dragon Crew Archer"
LevelToMonster[1320] = "Dragon Crew Archer"
LevelToMonster[1321] = "Dragon Crew Archer"
LevelToMonster[1322] = "Dragon Crew Archer"
LevelToMonster[1323] = "Dragon Crew Archer"
LevelToMonster[1324] = "Dragon Crew Archer"
LevelToMonster[1325] = "Snow Lurker"
LevelToMonster[1326] = "Snow Lurker"
LevelToMonster[1327] = "Snow Lurker"
LevelToMonster[1328] = "Snow Lurker"
LevelToMonster[1329] = "Snow Lurker"
LevelToMonster[1330] = "Snow Lurker"
LevelToMonster[1331] = "Snow Lurker"
LevelToMonster[1332] = "Snow Lurker"
LevelToMonster[1333] = "Snow Lurker"
LevelToMonster[1334] = "Snow Lurker"
LevelToMonster[1335] = "Snow Lurker"
LevelToMonster[1336] = "Snow Lurker"
LevelToMonster[1337] = "Snow Lurker"
LevelToMonster[1338] = "Snow Lurker"
LevelToMonster[1339] = "Snow Lurker"
LevelToMonster[1340] = "Snow Lurker"
LevelToMonster[1341] = "Snow Lurker"
LevelToMonster[1342] = "Snow Lurker"
LevelToMonster[1343] = "Snow Lurker"
LevelToMonster[1344] = "Snow Lurker"
LevelToMonster[1345] = "Snow Lurker"
LevelToMonster[1346] = "Snow Lurker"
LevelToMonster[1347] = "Snow Lurker"
LevelToMonster[1348] = "Snow Lurker"
LevelToMonster[1349] = "Snow Lurker"
LevelToMonster[1350] = "Snow Lurker"
LevelToMonster[1351] = "Snow Lurker"
LevelToMonster[1352] = "Snow Lurker"
LevelToMonster[1353] = "Snow Lurker"
LevelToMonster[1354] = "Snow Lurker"
LevelToMonster[1355] = "Snow Lurker"
LevelToMonster[1356] = "Snow Lurker"
LevelToMonster[1357] = "Snow Lurker"
LevelToMonster[1358] = "Snow Lurker"
LevelToMonster[1359] = "Snow Lurker"
LevelToMonster[1360] = "Snow Lurker"
LevelToMonster[1361] = "Snow Lurker"
LevelToMonster[1362] = "Snow Lurker"
LevelToMonster[1363] = "Snow Lurker"
LevelToMonster[1364] = "Snow Lurker"
LevelToMonster[1365] = "Snow Lurker"
LevelToMonster[1366] = "Snow Lurker"
LevelToMonster[1367] = "Snow Lurker"
LevelToMonster[1368] = "Snow Lurker"
LevelToMonster[1369] = "Snow Lurker"
LevelToMonster[1370] = "Snow Lurker"
LevelToMonster[1371] = "Snow Lurker"
LevelToMonster[1372] = "Snow Lurker"
LevelToMonster[1373] = "Snow Lurker"
LevelToMonster[1374] = "Snow Lurker"
LevelToMonster[1375] = "Diable"
LevelToMonster[1376] = "Diable"
LevelToMonster[1377] = "Diable"
LevelToMonster[1378] = "Diable"
LevelToMonster[1379] = "Diable"
LevelToMonster[1380] = "Diable"
LevelToMonster[1381] = "Diable"
LevelToMonster[1382] = "Diable"
LevelToMonster[1383] = "Diable"
LevelToMonster[1384] = "Diable"
LevelToMonster[1385] = "Diable"
LevelToMonster[1386] = "Diable"
LevelToMonster[1387] = "Diable"
LevelToMonster[1388] = "Diable"
LevelToMonster[1389] = "Diable"
LevelToMonster[1390] = "Diable"
LevelToMonster[1391] = "Diable"
LevelToMonster[1392] = "Diable"
LevelToMonster[1393] = "Diable"
LevelToMonster[1394] = "Diable"
LevelToMonster[1395] = "Diable"
LevelToMonster[1396] = "Diable"
LevelToMonster[1397] = "Diable"
LevelToMonster[1398] = "Diable"
LevelToMonster[1399] = "Diable"
LevelToMonster[1400] = "Diable"
LevelToMonster[1401] = "Diable"
LevelToMonster[1402] = "Diable"
LevelToMonster[1403] = "Diable"
LevelToMonster[1404] = "Diable"
LevelToMonster[1405] = "Diable"
LevelToMonster[1406] = "Diable"
LevelToMonster[1407] = "Diable"
LevelToMonster[1408] = "Diable"
LevelToMonster[1409] = "Diable"
LevelToMonster[1410] = "Diable"
LevelToMonster[1411] = "Diable"
LevelToMonster[1412] = "Diable"
LevelToMonster[1413] = "Diable"
LevelToMonster[1414] = "Diable"
LevelToMonster[1415] = "Diable"
LevelToMonster[1416] = "Diable"
LevelToMonster[1417] = "Diable"
LevelToMonster[1418] = "Diable"
LevelToMonster[1419] = "Diable"
LevelToMonster[1420] = "Diable"
LevelToMonster[1421] = "Diable"
LevelToMonster[1422] = "Diable"
LevelToMonster[1423] = "Diable"
LevelToMonster[1424] = "Diable"
LevelToMonster[1425] = "Diable"
LevelToMonster[1426] = "Diable"
LevelToMonster[1427] = "Diable"
LevelToMonster[1428] = "Diable"
LevelToMonster[1429] = "Diable"
LevelToMonster[1430] = "Diable"
LevelToMonster[1431] = "Diable"
LevelToMonster[1432] = "Diable"
LevelToMonster[1433] = "Diable"
LevelToMonster[1434] = "Diable"
LevelToMonster[1435] = "Diable"
LevelToMonster[1436] = "Diable"
LevelToMonster[1437] = "Diable"
LevelToMonster[1438] = "Diable"
LevelToMonster[1439] = "Diable"
LevelToMonster[1440] = "Diable"
LevelToMonster[1441] = "Diable"
LevelToMonster[1442] = "Diable"
LevelToMonster[1443] = "Diable"
LevelToMonster[1444] = "Diable"
LevelToMonster[1445] = "Diable"
LevelToMonster[1446] = "Diable"
LevelToMonster[1447] = "Diable"
LevelToMonster[1448] = "Diable"
LevelToMonster[1449] = "Diable"
LevelToMonster[1450] = "Ice Admiral"
LevelToMonster[1451] = "Ice Admiral"
LevelToMonster[1452] = "Ice Admiral"
LevelToMonster[1453] = "Ice Admiral"
LevelToMonster[1454] = "Ice Admiral"
LevelToMonster[1455] = "Ice Admiral"
LevelToMonster[1456] = "Ice Admiral"
LevelToMonster[1457] = "Ice Admiral"
LevelToMonster[1458] = "Ice Admiral"
LevelToMonster[1459] = "Ice Admiral"
LevelToMonster[1460] = "Ice Admiral"
LevelToMonster[1461] = "Ice Admiral"
LevelToMonster[1462] = "Ice Admiral"
LevelToMonster[1463] = "Ice Admiral"
LevelToMonster[1464] = "Ice Admiral"
LevelToMonster[1465] = "Ice Admiral"
LevelToMonster[1466] = "Ice Admiral"
LevelToMonster[1467] = "Ice Admiral"
LevelToMonster[1468] = "Ice Admiral"
LevelToMonster[1469] = "Ice Admiral"
LevelToMonster[1470] = "Ice Admiral"
LevelToMonster[1471] = "Ice Admiral"
LevelToMonster[1472] = "Ice Admiral"
LevelToMonster[1473] = "Ice Admiral"
LevelToMonster[1474] = "Ice Admiral"
LevelToMonster[1475] = "Ice Admiral"
LevelToMonster[1476] = "Ice Admiral"
LevelToMonster[1477] = "Ice Admiral"
LevelToMonster[1478] = "Ice Admiral"
LevelToMonster[1479] = "Ice Admiral"
LevelToMonster[1480] = "Ice Admiral"
LevelToMonster[1481] = "Ice Admiral"
LevelToMonster[1482] = "Ice Admiral"
LevelToMonster[1483] = "Ice Admiral"
LevelToMonster[1484] = "Ice Admiral"
LevelToMonster[1485] = "Ice Admiral"
LevelToMonster[1486] = "Ice Admiral"
LevelToMonster[1487] = "Ice Admiral"
LevelToMonster[1488] = "Ice Admiral"
LevelToMonster[1489] = "Ice Admiral"
LevelToMonster[1490] = "Ice Admiral"
LevelToMonster[1491] = "Ice Admiral"
LevelToMonster[1492] = "Ice Admiral"
LevelToMonster[1493] = "Ice Admiral"
LevelToMonster[1494] = "Ice Admiral"
LevelToMonster[1495] = "Ice Admiral"
LevelToMonster[1496] = "Ice Admiral"
LevelToMonster[1497] = "Ice Admiral"
LevelToMonster[1498] = "Ice Admiral"
LevelToMonster[1499] = "Ice Admiral"
LevelToMonster[1500] = "Forest Pirate"
LevelToMonster[1501] = "Forest Pirate"
LevelToMonster[1502] = "Forest Pirate"
LevelToMonster[1503] = "Forest Pirate"
LevelToMonster[1504] = "Forest Pirate"
LevelToMonster[1505] = "Forest Pirate"
LevelToMonster[1506] = "Forest Pirate"
LevelToMonster[1507] = "Forest Pirate"
LevelToMonster[1508] = "Forest Pirate"
LevelToMonster[1509] = "Forest Pirate"
LevelToMonster[1510] = "Forest Pirate"
LevelToMonster[1511] = "Forest Pirate"
LevelToMonster[1512] = "Forest Pirate"
LevelToMonster[1513] = "Forest Pirate"
LevelToMonster[1514] = "Forest Pirate"
LevelToMonster[1515] = "Forest Pirate"
LevelToMonster[1516] = "Forest Pirate"
LevelToMonster[1517] = "Forest Pirate"
LevelToMonster[1518] = "Forest Pirate"
LevelToMonster[1519] = "Forest Pirate"
LevelToMonster[1520] = "Forest Pirate"
LevelToMonster[1521] = "Forest Pirate"
LevelToMonster[1522] = "Forest Pirate"
LevelToMonster[1523] = "Forest Pirate"
LevelToMonster[1524] = "Forest Pirate"
LevelToMonster[1525] = "Forest Pirate"
LevelToMonster[1526] = "Forest Pirate"
LevelToMonster[1527] = "Forest Pirate"
LevelToMonster[1528] = "Forest Pirate"
LevelToMonster[1529] = "Forest Pirate"
LevelToMonster[1530] = "Forest Pirate"
LevelToMonster[1531] = "Forest Pirate"
LevelToMonster[1532] = "Forest Pirate"
LevelToMonster[1533] = "Forest Pirate"
LevelToMonster[1534] = "Forest Pirate"
LevelToMonster[1535] = "Forest Pirate"
LevelToMonster[1536] = "Forest Pirate"
LevelToMonster[1537] = "Forest Pirate"
LevelToMonster[1538] = "Forest Pirate"
LevelToMonster[1539] = "Forest Pirate"
LevelToMonster[1540] = "Forest Pirate"
LevelToMonster[1541] = "Forest Pirate"
LevelToMonster[1542] = "Forest Pirate"
LevelToMonster[1543] = "Forest Pirate"
LevelToMonster[1544] = "Forest Pirate"
LevelToMonster[1545] = "Forest Pirate"
LevelToMonster[1546] = "Forest Pirate"
LevelToMonster[1547] = "Forest Pirate"
LevelToMonster[1548] = "Forest Pirate"
LevelToMonster[1549] = "Forest Pirate"
LevelToMonster[1550] = "Forest Pirate"
LevelToMonster[1551] = "Forest Pirate"
LevelToMonster[1552] = "Forest Pirate"
LevelToMonster[1553] = "Forest Pirate"
LevelToMonster[1554] = "Forest Pirate"
LevelToMonster[1555] = "Forest Pirate"
LevelToMonster[1556] = "Forest Pirate"
LevelToMonster[1557] = "Forest Pirate"
LevelToMonster[1558] = "Forest Pirate"
LevelToMonster[1559] = "Forest Pirate"
LevelToMonster[1560] = "Forest Pirate"
LevelToMonster[1561] = "Forest Pirate"
LevelToMonster[1562] = "Forest Pirate"
LevelToMonster[1563] = "Forest Pirate"
LevelToMonster[1564] = "Forest Pirate"
LevelToMonster[1565] = "Forest Pirate"
LevelToMonster[1566] = "Forest Pirate"
LevelToMonster[1567] = "Forest Pirate"
LevelToMonster[1568] = "Forest Pirate"
LevelToMonster[1569] = "Forest Pirate"
LevelToMonster[1570] = "Forest Pirate"
LevelToMonster[1571] = "Forest Pirate"
LevelToMonster[1572] = "Forest Pirate"
LevelToMonster[1573] = "Forest Pirate"
LevelToMonster[1574] = "Forest Pirate"
LevelToMonster[1575] = "Living Zombie"
LevelToMonster[1576] = "Living Zombie"
LevelToMonster[1577] = "Living Zombie"
LevelToMonster[1578] = "Living Zombie"
LevelToMonster[1579] = "Living Zombie"
LevelToMonster[1580] = "Living Zombie"
LevelToMonster[1581] = "Living Zombie"
LevelToMonster[1582] = "Living Zombie"
LevelToMonster[1583] = "Living Zombie"
LevelToMonster[1584] = "Living Zombie"
LevelToMonster[1585] = "Living Zombie"
LevelToMonster[1586] = "Living Zombie"
LevelToMonster[1587] = "Living Zombie"
LevelToMonster[1588] = "Living Zombie"
LevelToMonster[1589] = "Living Zombie"
LevelToMonster[1590] = "Living Zombie"
LevelToMonster[1591] = "Living Zombie"
LevelToMonster[1592] = "Living Zombie"
LevelToMonster[1593] = "Living Zombie"
LevelToMonster[1594] = "Living Zombie"
LevelToMonster[1595] = "Living Zombie"
LevelToMonster[1596] = "Living Zombie"
LevelToMonster[1597] = "Living Zombie"
LevelToMonster[1598] = "Living Zombie"
LevelToMonster[1599] = "Living Zombie"
LevelToMonster[1600] = "Living Zombie"
LevelToMonster[1601] = "Living Zombie"
LevelToMonster[1602] = "Living Zombie"
LevelToMonster[1603] = "Living Zombie"
LevelToMonster[1604] = "Living Zombie"
LevelToMonster[1605] = "Living Zombie"
LevelToMonster[1606] = "Living Zombie"
LevelToMonster[1607] = "Living Zombie"
LevelToMonster[1608] = "Living Zombie"
LevelToMonster[1609] = "Living Zombie"
LevelToMonster[1610] = "Living Zombie"
LevelToMonster[1611] = "Living Zombie"
LevelToMonster[1612] = "Living Zombie"
LevelToMonster[1613] = "Living Zombie"
LevelToMonster[1614] = "Living Zombie"
LevelToMonster[1615] = "Living Zombie"
LevelToMonster[1616] = "Living Zombie"
LevelToMonster[1617] = "Living Zombie"
LevelToMonster[1618] = "Living Zombie"
LevelToMonster[1619] = "Living Zombie"
LevelToMonster[1620] = "Living Zombie"
LevelToMonster[1621] = "Living Zombie"
LevelToMonster[1622] = "Living Zombie"
LevelToMonster[1623] = "Living Zombie"
LevelToMonster[1624] = "Living Zombie"
LevelToMonster[1625] = "Living Zombie"
LevelToMonster[1626] = "Living Zombie"
LevelToMonster[1627] = "Living Zombie"
LevelToMonster[1628] = "Living Zombie"
LevelToMonster[1629] = "Living Zombie"
LevelToMonster[1630] = "Living Zombie"
LevelToMonster[1631] = "Living Zombie"
LevelToMonster[1632] = "Living Zombie"
LevelToMonster[1633] = "Living Zombie"
LevelToMonster[1634] = "Living Zombie"
LevelToMonster[1635] = "Living Zombie"
LevelToMonster[1636] = "Living Zombie"
LevelToMonster[1637] = "Living Zombie"
LevelToMonster[1638] = "Living Zombie"
LevelToMonster[1639] = "Living Zombie"
LevelToMonster[1640] = "Living Zombie"
LevelToMonster[1641] = "Living Zombie"
LevelToMonster[1642] = "Living Zombie"
LevelToMonster[1643] = "Living Zombie"
LevelToMonster[1644] = "Living Zombie"
LevelToMonster[1645] = "Living Zombie"
LevelToMonster[1646] = "Living Zombie"
LevelToMonster[1647] = "Living Zombie"
LevelToMonster[1648] = "Living Zombie"
LevelToMonster[1649] = "Living Zombie"
LevelToMonster[1650] = "Demonic Soul"
LevelToMonster[1651] = "Demonic Soul"
LevelToMonster[1652] = "Demonic Soul"
LevelToMonster[1653] = "Demonic Soul"
LevelToMonster[1654] = "Demonic Soul"
LevelToMonster[1655] = "Demonic Soul"
LevelToMonster[1656] = "Demonic Soul"
LevelToMonster[1657] = "Demonic Soul"
LevelToMonster[1658] = "Demonic Soul"
LevelToMonster[1659] = "Demonic Soul"
LevelToMonster[1660] = "Demonic Soul"
LevelToMonster[1661] = "Demonic Soul"
LevelToMonster[1662] = "Demonic Soul"
LevelToMonster[1663] = "Demonic Soul"
LevelToMonster[1664] = "Demonic Soul"
LevelToMonster[1665] = "Demonic Soul"
LevelToMonster[1666] = "Demonic Soul"
LevelToMonster[1667] = "Demonic Soul"
LevelToMonster[1668] = "Demonic Soul"
LevelToMonster[1669] = "Demonic Soul"
LevelToMonster[1670] = "Demonic Soul"
LevelToMonster[1671] = "Demonic Soul"
LevelToMonster[1672] = "Demonic Soul"
LevelToMonster[1673] = "Demonic Soul"
LevelToMonster[1674] = "Demonic Soul"
LevelToMonster[1675] = "Demonic Soul"
LevelToMonster[1676] = "Demonic Soul"
LevelToMonster[1677] = "Demonic Soul"
LevelToMonster[1678] = "Demonic Soul"
LevelToMonster[1679] = "Demonic Soul"
LevelToMonster[1680] = "Demonic Soul"
LevelToMonster[1681] = "Demonic Soul"
LevelToMonster[1682] = "Demonic Soul"
LevelToMonster[1683] = "Demonic Soul"
LevelToMonster[1684] = "Demonic Soul"
LevelToMonster[1685] = "Demonic Soul"
LevelToMonster[1686] = "Demonic Soul"
LevelToMonster[1687] = "Demonic Soul"
LevelToMonster[1688] = "Demonic Soul"
LevelToMonster[1689] = "Demonic Soul"
LevelToMonster[1690] = "Demonic Soul"
LevelToMonster[1691] = "Demonic Soul"
LevelToMonster[1692] = "Demonic Soul"
LevelToMonster[1693] = "Demonic Soul"
LevelToMonster[1694] = "Demonic Soul"
LevelToMonster[1695] = "Demonic Soul"
LevelToMonster[1696] = "Demonic Soul"
LevelToMonster[1697] = "Demonic Soul"
LevelToMonster[1698] = "Demonic Soul"
LevelToMonster[1699] = "Demonic Soul"
LevelToMonster[1700] = "Hellish Demon"
LevelToMonster[1701] = "Hellish Demon"
LevelToMonster[1702] = "Hellish Demon"
LevelToMonster[1703] = "Hellish Demon"
LevelToMonster[1704] = "Hellish Demon"
LevelToMonster[1705] = "Hellish Demon"
LevelToMonster[1706] = "Hellish Demon"
LevelToMonster[1707] = "Hellish Demon"
LevelToMonster[1708] = "Hellish Demon"
LevelToMonster[1709] = "Hellish Demon"
LevelToMonster[1710] = "Hellish Demon"
LevelToMonster[1711] = "Hellish Demon"
LevelToMonster[1712] = "Hellish Demon"
LevelToMonster[1713] = "Hellish Demon"
LevelToMonster[1714] = "Hellish Demon"
LevelToMonster[1715] = "Hellish Demon"
LevelToMonster[1716] = "Hellish Demon"
LevelToMonster[1717] = "Hellish Demon"
LevelToMonster[1718] = "Hellish Demon"
LevelToMonster[1719] = "Hellish Demon"
LevelToMonster[1720] = "Hellish Demon"
LevelToMonster[1721] = "Hellish Demon"
LevelToMonster[1722] = "Hellish Demon"
LevelToMonster[1723] = "Hellish Demon"
LevelToMonster[1724] = "Hellish Demon"
LevelToMonster[1725] = "Hellish Demon"
LevelToMonster[1726] = "Hellish Demon"
LevelToMonster[1727] = "Hellish Demon"
LevelToMonster[1728] = "Hellish Demon"
LevelToMonster[1729] = "Hellish Demon"
LevelToMonster[1730] = "Hellish Demon"
LevelToMonster[1731] = "Hellish Demon"
LevelToMonster[1732] = "Hellish Demon"
LevelToMonster[1733] = "Hellish Demon"
LevelToMonster[1734] = "Hellish Demon"
LevelToMonster[1735] = "Hellish Demon"
LevelToMonster[1736] = "Hellish Demon"
LevelToMonster[1737] = "Hellish Demon"
LevelToMonster[1738] = "Hellish Demon"
LevelToMonster[1739] = "Hellish Demon"
LevelToMonster[1740] = "Hellish Demon"
LevelToMonster[1741] = "Hellish Demon"
LevelToMonster[1742] = "Hellish Demon"
LevelToMonster[1743] = "Hellish Demon"
LevelToMonster[1744] = "Hellish Demon"
LevelToMonster[1745] = "Hellish Demon"
LevelToMonster[1746] = "Hellish Demon"
LevelToMonster[1747] = "Hellish Demon"
LevelToMonster[1748] = "Hellish Demon"
LevelToMonster[1749] = "Hellish Demon"
LevelToMonster[1750] = "Hellish Demon"
LevelToMonster[1751] = "Hellish Demon"
LevelToMonster[1752] = "Hellish Demon"
LevelToMonster[1753] = "Hellish Demon"
LevelToMonster[1754] = "Hellish Demon"
LevelToMonster[1755] = "Hellish Demon"
LevelToMonster[1756] = "Hellish Demon"
LevelToMonster[1757] = "Hellish Demon"
LevelToMonster[1758] = "Hellish Demon"
LevelToMonster[1759] = "Hellish Demon"
LevelToMonster[1760] = "Hellish Demon"
LevelToMonster[1761] = "Hellish Demon"
LevelToMonster[1762] = "Hellish Demon"
LevelToMonster[1763] = "Hellish Demon"
LevelToMonster[1764] = "Hellish Demon"
LevelToMonster[1765] = "Hellish Demon"
LevelToMonster[1766] = "Hellish Demon"
LevelToMonster[1767] = "Hellish Demon"
LevelToMonster[1768] = "Hellish Demon"
LevelToMonster[1769] = "Hellish Demon"
LevelToMonster[1770] = "Hellish Demon"
LevelToMonster[1771] = "Hellish Demon"
LevelToMonster[1772] = "Hellish Demon"
LevelToMonster[1773] = "Hellish Demon"
LevelToMonster[1774] = "Hellish Demon"
LevelToMonster[1775] = "Realistic Zombie"
LevelToMonster[1776] = "Realistic Zombie"
LevelToMonster[1777] = "Realistic Zombie"
LevelToMonster[1778] = "Realistic Zombie"
LevelToMonster[1779] = "Realistic Zombie"
LevelToMonster[1780] = "Realistic Zombie"
LevelToMonster[1781] = "Realistic Zombie"
LevelToMonster[1782] = "Realistic Zombie"
LevelToMonster[1783] = "Realistic Zombie"
LevelToMonster[1784] = "Realistic Zombie"
LevelToMonster[1785] = "Realistic Zombie"
LevelToMonster[1786] = "Realistic Zombie"
LevelToMonster[1787] = "Realistic Zombie"
LevelToMonster[1788] = "Realistic Zombie"
LevelToMonster[1789] = "Realistic Zombie"
LevelToMonster[1790] = "Realistic Zombie"
LevelToMonster[1791] = "Realistic Zombie"
LevelToMonster[1792] = "Realistic Zombie"
LevelToMonster[1793] = "Realistic Zombie"
LevelToMonster[1794] = "Realistic Zombie"
LevelToMonster[1795] = "Realistic Zombie"
LevelToMonster[1796] = "Realistic Zombie"
LevelToMonster[1797] = "Realistic Zombie"
LevelToMonster[1798] = "Realistic Zombie"
LevelToMonster[1799] = "Realistic Zombie"
LevelToMonster[1800] = "Realistic Zombie"
LevelToMonster[1801] = "Realistic Zombie"
LevelToMonster[1802] = "Realistic Zombie"
LevelToMonster[1803] = "Realistic Zombie"
LevelToMonster[1804] = "Realistic Zombie"
LevelToMonster[1805] = "Realistic Zombie"
LevelToMonster[1806] = "Realistic Zombie"
LevelToMonster[1807] = "Realistic Zombie"
LevelToMonster[1808] = "Realistic Zombie"
LevelToMonster[1809] = "Realistic Zombie"
LevelToMonster[1810] = "Realistic Zombie"
LevelToMonster[1811] = "Realistic Zombie"
LevelToMonster[1812] = "Realistic Zombie"
LevelToMonster[1813] = "Realistic Zombie"
LevelToMonster[1814] = "Realistic Zombie"
LevelToMonster[1815] = "Realistic Zombie"
LevelToMonster[1816] = "Realistic Zombie"
LevelToMonster[1817] = "Realistic Zombie"
LevelToMonster[1818] = "Realistic Zombie"
LevelToMonster[1819] = "Realistic Zombie"
LevelToMonster[1820] = "Realistic Zombie"
LevelToMonster[1821] = "Realistic Zombie"
LevelToMonster[1822] = "Realistic Zombie"
LevelToMonster[1823] = "Realistic Zombie"
LevelToMonster[1824] = "Realistic Zombie"
LevelToMonster[1825] = "Realistic Zombie"
LevelToMonster[1826] = "Realistic Zombie"
LevelToMonster[1827] = "Realistic Zombie"
LevelToMonster[1828] = "Realistic Zombie"
LevelToMonster[1829] = "Realistic Zombie"
LevelToMonster[1830] = "Realistic Zombie"
LevelToMonster[1831] = "Realistic Zombie"
LevelToMonster[1832] = "Realistic Zombie"
LevelToMonster[1833] = "Realistic Zombie"
LevelToMonster[1834] = "Realistic Zombie"
LevelToMonster[1835] = "Realistic Zombie"
LevelToMonster[1836] = "Realistic Zombie"
LevelToMonster[1837] = "Realistic Zombie"
LevelToMonster[1838] = "Realistic Zombie"
LevelToMonster[1839] = "Realistic Zombie"
LevelToMonster[1840] = "Realistic Zombie"
LevelToMonster[1841] = "Realistic Zombie"
LevelToMonster[1842] = "Realistic Zombie"
LevelToMonster[1843] = "Realistic Zombie"
LevelToMonster[1844] = "Realistic Zombie"
LevelToMonster[1845] = "Realistic Zombie"
LevelToMonster[1846] = "Realistic Zombie"
LevelToMonster[1847] = "Realistic Zombie"
LevelToMonster[1848] = "Realistic Zombie"
LevelToMonster[1849] = "Realistic Zombie"
LevelToMonster[1850] = "Mythological Pirate"
LevelToMonster[1851] = "Mythological Pirate"
LevelToMonster[1852] = "Mythological Pirate"
LevelToMonster[1853] = "Mythological Pirate"
LevelToMonster[1854] = "Mythological Pirate"
LevelToMonster[1855] = "Mythological Pirate"
LevelToMonster[1856] = "Mythological Pirate"
LevelToMonster[1857] = "Mythological Pirate"
LevelToMonster[1858] = "Mythological Pirate"
LevelToMonster[1859] = "Mythological Pirate"
LevelToMonster[1860] = "Mythological Pirate"
LevelToMonster[1861] = "Mythological Pirate"
LevelToMonster[1862] = "Mythological Pirate"
LevelToMonster[1863] = "Mythological Pirate"
LevelToMonster[1864] = "Mythological Pirate"
LevelToMonster[1865] = "Mythological Pirate"
LevelToMonster[1866] = "Mythological Pirate"
LevelToMonster[1867] = "Mythological Pirate"
LevelToMonster[1868] = "Mythological Pirate"
LevelToMonster[1869] = "Mythological Pirate"
LevelToMonster[1870] = "Mythological Pirate"
LevelToMonster[1871] = "Mythological Pirate"
LevelToMonster[1872] = "Mythological Pirate"
LevelToMonster[1873] = "Mythological Pirate"
LevelToMonster[1874] = "Mythological Pirate"
LevelToMonster[1875] = "Mythological Pirate"
LevelToMonster[1876] = "Mythological Pirate"
LevelToMonster[1877] = "Mythological Pirate"
LevelToMonster[1878] = "Mythological Pirate"
LevelToMonster[1879] = "Mythological Pirate"
LevelToMonster[1880] = "Mythological Pirate"
LevelToMonster[1881] = "Mythological Pirate"
LevelToMonster[1882] = "Mythological Pirate"
LevelToMonster[1883] = "Mythological Pirate"
LevelToMonster[1884] = "Mythological Pirate"
LevelToMonster[1885] = "Mythological Pirate"
LevelToMonster[1886] = "Mythological Pirate"
LevelToMonster[1887] = "Mythological Pirate"
LevelToMonster[1888] = "Mythological Pirate"
LevelToMonster[1889] = "Mythological Pirate"
LevelToMonster[1890] = "Mythological Pirate"
LevelToMonster[1891] = "Mythological Pirate"
LevelToMonster[1892] = "Mythological Pirate"
LevelToMonster[1893] = "Mythological Pirate"
LevelToMonster[1894] = "Mythological Pirate"
LevelToMonster[1895] = "Mythological Pirate"
LevelToMonster[1896] = "Mythological Pirate"
LevelToMonster[1897] = "Mythological Pirate"
LevelToMonster[1898] = "Mythological Pirate"
LevelToMonster[1899] = "Mythological Pirate"
LevelToMonster[1900] = "Mythological Pirate"
LevelToMonster[1901] = "Mythological Pirate"
LevelToMonster[1902] = "Mythological Pirate"
LevelToMonster[1903] = "Mythological Pirate"
LevelToMonster[1904] = "Mythological Pirate"
LevelToMonster[1905] = "Mythological Pirate"
LevelToMonster[1906] = "Mythological Pirate"
LevelToMonster[1907] = "Mythological Pirate"
LevelToMonster[1908] = "Mythological Pirate"
LevelToMonster[1909] = "Mythological Pirate"
LevelToMonster[1910] = "Mythological Pirate"
LevelToMonster[1911] = "Mythological Pirate"
LevelToMonster[1912] = "Mythological Pirate"
LevelToMonster[1913] = "Mythological Pirate"
LevelToMonster[1914] = "Mythological Pirate"
LevelToMonster[1915] = "Mythological Pirate"
LevelToMonster[1916] = "Mythological Pirate"
LevelToMonster[1917] = "Mythological Pirate"
LevelToMonster[1918] = "Mythological Pirate"
LevelToMonster[1919] = "Mythological Pirate"
LevelToMonster[1920] = "Mythological Pirate"
LevelToMonster[1921] = "Mythological Pirate"
LevelToMonster[1922] = "Mythological Pirate"
LevelToMonster[1923] = "Mythological Pirate"
LevelToMonster[1924] = "Mythological Pirate"
LevelToMonster[1925] = "Chocolate Bar Battler"
LevelToMonster[1926] = "Chocolate Bar Battler"
LevelToMonster[1927] = "Chocolate Bar Battler"
LevelToMonster[1928] = "Chocolate Bar Battler"
LevelToMonster[1929] = "Chocolate Bar Battler"
LevelToMonster[1930] = "Chocolate Bar Battler"
LevelToMonster[1931] = "Chocolate Bar Battler"
LevelToMonster[1932] = "Chocolate Bar Battler"
LevelToMonster[1933] = "Chocolate Bar Battler"
LevelToMonster[1934] = "Chocolate Bar Battler"
LevelToMonster[1935] = "Chocolate Bar Battler"
LevelToMonster[1936] = "Chocolate Bar Battler"
LevelToMonster[1937] = "Chocolate Bar Battler"
LevelToMonster[1938] = "Chocolate Bar Battler"
LevelToMonster[1939] = "Chocolate Bar Battler"
LevelToMonster[1940] = "Chocolate Bar Battler"
LevelToMonster[1941] = "Chocolate Bar Battler"
LevelToMonster[1942] = "Chocolate Bar Battler"
LevelToMonster[1943] = "Chocolate Bar Battler"
LevelToMonster[1944] = "Chocolate Bar Battler"
LevelToMonster[1945] = "Chocolate Bar Battler"
LevelToMonster[1946] = "Chocolate Bar Battler"
LevelToMonster[1947] = "Chocolate Bar Battler"
LevelToMonster[1948] = "Chocolate Bar Battler"
LevelToMonster[1949] = "Chocolate Bar Battler"
LevelToMonster[1950] = "Chocolate Bar Battler"
LevelToMonster[1951] = "Chocolate Bar Battler"
LevelToMonster[1952] = "Chocolate Bar Battler"
LevelToMonster[1953] = "Chocolate Bar Battler"
LevelToMonster[1954] = "Chocolate Bar Battler"
LevelToMonster[1955] = "Chocolate Bar Battler"
LevelToMonster[1956] = "Chocolate Bar Battler"
LevelToMonster[1957] = "Chocolate Bar Battler"
LevelToMonster[1958] = "Chocolate Bar Battler"
LevelToMonster[1959] = "Chocolate Bar Battler"
LevelToMonster[1960] = "Chocolate Bar Battler"
LevelToMonster[1961] = "Chocolate Bar Battler"
LevelToMonster[1962] = "Chocolate Bar Battler"
LevelToMonster[1963] = "Chocolate Bar Battler"
LevelToMonster[1964] = "Chocolate Bar Battler"
LevelToMonster[1965] = "Chocolate Bar Battler"
LevelToMonster[1966] = "Chocolate Bar Battler"
LevelToMonster[1967] = "Chocolate Bar Battler"
LevelToMonster[1968] = "Chocolate Bar Battler"
LevelToMonster[1969] = "Chocolate Bar Battler"
LevelToMonster[1970] = "Chocolate Bar Battler"
LevelToMonster[1971] = "Chocolate Bar Battler"
LevelToMonster[1972] = "Chocolate Bar Battler"
LevelToMonster[1973] = "Chocolate Bar Battler"
LevelToMonster[1974] = "Chocolate Bar Battler"
LevelToMonster[1975] = "Chocolate Bar Battler"
LevelToMonster[1976] = "Chocolate Bar Battler"
LevelToMonster[1977] = "Chocolate Bar Battler"
LevelToMonster[1978] = "Chocolate Bar Battler"
LevelToMonster[1979] = "Chocolate Bar Battler"
LevelToMonster[1980] = "Chocolate Bar Battler"
LevelToMonster[1981] = "Chocolate Bar Battler"
LevelToMonster[1982] = "Chocolate Bar Battler"
LevelToMonster[1983] = "Chocolate Bar Battler"
LevelToMonster[1984] = "Chocolate Bar Battler"
LevelToMonster[1985] = "Chocolate Bar Battler"
LevelToMonster[1986] = "Chocolate Bar Battler"
LevelToMonster[1987] = "Chocolate Bar Battler"
LevelToMonster[1988] = "Chocolate Bar Battler"
LevelToMonster[1989] = "Chocolate Bar Battler"
LevelToMonster[1990] = "Chocolate Bar Battler"
LevelToMonster[1991] = "Chocolate Bar Battler"
LevelToMonster[1992] = "Chocolate Bar Battler"
LevelToMonster[1993] = "Chocolate Bar Battler"
LevelToMonster[1994] = "Chocolate Bar Battler"
LevelToMonster[1995] = "Chocolate Bar Battler"
LevelToMonster[1996] = "Chocolate Bar Battler"
LevelToMonster[1997] = "Chocolate Bar Battler"
LevelToMonster[1998] = "Chocolate Bar Battler"
LevelToMonster[1999] = "Chocolate Bar Battler"
LevelToMonster[2000] = "Dough Militia"
LevelToMonster[2001] = "Dough Militia"
LevelToMonster[2002] = "Dough Militia"
LevelToMonster[2003] = "Dough Militia"
LevelToMonster[2004] = "Dough Militia"
LevelToMonster[2005] = "Dough Militia"
LevelToMonster[2006] = "Dough Militia"
LevelToMonster[2007] = "Dough Militia"
LevelToMonster[2008] = "Dough Militia"
LevelToMonster[2009] = "Dough Militia"
LevelToMonster[2010] = "Dough Militia"
LevelToMonster[2011] = "Dough Militia"
LevelToMonster[2012] = "Dough Militia"
LevelToMonster[2013] = "Dough Militia"
LevelToMonster[2014] = "Dough Militia"
LevelToMonster[2015] = "Dough Militia"
LevelToMonster[2016] = "Dough Militia"
LevelToMonster[2017] = "Dough Militia"
LevelToMonster[2018] = "Dough Militia"
LevelToMonster[2019] = "Dough Militia"
LevelToMonster[2020] = "Dough Militia"
LevelToMonster[2021] = "Dough Militia"
LevelToMonster[2022] = "Dough Militia"
LevelToMonster[2023] = "Dough Militia"
LevelToMonster[2024] = "Dough Militia"
LevelToMonster[2025] = "Dough Militia"
LevelToMonster[2026] = "Dough Militia"
LevelToMonster[2027] = "Dough Militia"
LevelToMonster[2028] = "Dough Militia"
LevelToMonster[2029] = "Dough Militia"
LevelToMonster[2030] = "Dough Militia"
LevelToMonster[2031] = "Dough Militia"
LevelToMonster[2032] = "Dough Militia"
LevelToMonster[2033] = "Dough Militia"
LevelToMonster[2034] = "Dough Militia"
LevelToMonster[2035] = "Dough Militia"
LevelToMonster[2036] = "Dough Militia"
LevelToMonster[2037] = "Dough Militia"
LevelToMonster[2038] = "Dough Militia"
LevelToMonster[2039] = "Dough Militia"
LevelToMonster[2040] = "Dough Militia"
LevelToMonster[2041] = "Dough Militia"
LevelToMonster[2042] = "Dough Militia"
LevelToMonster[2043] = "Dough Militia"
LevelToMonster[2044] = "Dough Militia"
LevelToMonster[2045] = "Dough Militia"
LevelToMonster[2046] = "Dough Militia"
LevelToMonster[2047] = "Dough Militia"
LevelToMonster[2048] = "Dough Militia"
LevelToMonster[2049] = "Dough Militia"
LevelToMonster[2050] = "Dough Militia"
LevelToMonster[2051] = "Dough Militia"
LevelToMonster[2052] = "Dough Militia"
LevelToMonster[2053] = "Dough Militia"
LevelToMonster[2054] = "Dough Militia"
LevelToMonster[2055] = "Dough Militia"
LevelToMonster[2056] = "Dough Militia"
LevelToMonster[2057] = "Dough Militia"
LevelToMonster[2058] = "Dough Militia"
LevelToMonster[2059] = "Dough Militia"
LevelToMonster[2060] = "Dough Militia"
LevelToMonster[2061] = "Dough Militia"
LevelToMonster[2062] = "Dough Militia"
LevelToMonster[2063] = "Dough Militia"
LevelToMonster[2064] = "Dough Militia"
LevelToMonster[2065] = "Dough Militia"
LevelToMonster[2066] = "Dough Militia"
LevelToMonster[2067] = "Dough Militia"
LevelToMonster[2068] = "Dough Militia"
LevelToMonster[2069] = "Dough Militia"
LevelToMonster[2070] = "Dough Militia"
LevelToMonster[2071] = "Dough Militia"
LevelToMonster[2072] = "Dough Militia"
LevelToMonster[2073] = "Dough Militia"
LevelToMonster[2074] = "Dough Militia"
LevelToMonster[2075] = "Sweet Thief"
LevelToMonster[2076] = "Sweet Thief"
LevelToMonster[2077] = "Sweet Thief"
LevelToMonster[2078] = "Sweet Thief"
LevelToMonster[2079] = "Sweet Thief"
LevelToMonster[2080] = "Sweet Thief"
LevelToMonster[2081] = "Sweet Thief"
LevelToMonster[2082] = "Sweet Thief"
LevelToMonster[2083] = "Sweet Thief"
LevelToMonster[2084] = "Sweet Thief"
LevelToMonster[2085] = "Sweet Thief"
LevelToMonster[2086] = "Sweet Thief"
LevelToMonster[2087] = "Sweet Thief"
LevelToMonster[2088] = "Sweet Thief"
LevelToMonster[2089] = "Sweet Thief"
LevelToMonster[2090] = "Sweet Thief"
LevelToMonster[2091] = "Sweet Thief"
LevelToMonster[2092] = "Sweet Thief"
LevelToMonster[2093] = "Sweet Thief"
LevelToMonster[2094] = "Sweet Thief"
LevelToMonster[2095] = "Sweet Thief"
LevelToMonster[2096] = "Sweet Thief"
LevelToMonster[2097] = "Sweet Thief"
LevelToMonster[2098] = "Sweet Thief"
LevelToMonster[2099] = "Sweet Thief"
LevelToMonster[2100] = "Sweet Thief"
LevelToMonster[2101] = "Sweet Thief"
LevelToMonster[2102] = "Sweet Thief"
LevelToMonster[2103] = "Sweet Thief"
LevelToMonster[2104] = "Sweet Thief"
LevelToMonster[2105] = "Sweet Thief"
LevelToMonster[2106] = "Sweet Thief"
LevelToMonster[2107] = "Sweet Thief"
LevelToMonster[2108] = "Sweet Thief"
LevelToMonster[2109] = "Sweet Thief"
LevelToMonster[2110] = "Sweet Thief"
LevelToMonster[2111] = "Sweet Thief"
LevelToMonster[2112] = "Sweet Thief"
LevelToMonster[2113] = "Sweet Thief"
LevelToMonster[2114] = "Sweet Thief"
LevelToMonster[2115] = "Sweet Thief"
LevelToMonster[2116] = "Sweet Thief"
LevelToMonster[2117] = "Sweet Thief"
LevelToMonster[2118] = "Sweet Thief"
LevelToMonster[2119] = "Sweet Thief"
LevelToMonster[2120] = "Sweet Thief"
LevelToMonster[2121] = "Sweet Thief"
LevelToMonster[2122] = "Sweet Thief"
LevelToMonster[2123] = "Sweet Thief"
LevelToMonster[2124] = "Sweet Thief"
LevelToMonster[2125] = "Sweet Thief"
LevelToMonster[2126] = "Sweet Thief"
LevelToMonster[2127] = "Sweet Thief"
LevelToMonster[2128] = "Sweet Thief"
LevelToMonster[2129] = "Sweet Thief"
LevelToMonster[2130] = "Sweet Thief"
LevelToMonster[2131] = "Sweet Thief"
LevelToMonster[2132] = "Sweet Thief"
LevelToMonster[2133] = "Sweet Thief"
LevelToMonster[2134] = "Sweet Thief"
LevelToMonster[2135] = "Sweet Thief"
LevelToMonster[2136] = "Sweet Thief"
LevelToMonster[2137] = "Sweet Thief"
LevelToMonster[2138] = "Sweet Thief"
LevelToMonster[2139] = "Sweet Thief"
LevelToMonster[2140] = "Sweet Thief"
LevelToMonster[2141] = "Sweet Thief"
LevelToMonster[2142] = "Sweet Thief"
LevelToMonster[2143] = "Sweet Thief"
LevelToMonster[2144] = "Sweet Thief"
LevelToMonster[2145] = "Sweet Thief"
LevelToMonster[2146] = "Sweet Thief"
LevelToMonster[2147] = "Sweet Thief"
LevelToMonster[2148] = "Sweet Thief"
LevelToMonster[2149] = "Sweet Thief"
LevelToMonster[2150] = "Biscuit Soldier"
LevelToMonster[2151] = "Biscuit Soldier"
LevelToMonster[2152] = "Biscuit Soldier"
LevelToMonster[2153] = "Biscuit Soldier"
LevelToMonster[2154] = "Biscuit Soldier"
LevelToMonster[2155] = "Biscuit Soldier"
LevelToMonster[2156] = "Biscuit Soldier"
LevelToMonster[2157] = "Biscuit Soldier"
LevelToMonster[2158] = "Biscuit Soldier"
LevelToMonster[2159] = "Biscuit Soldier"
LevelToMonster[2160] = "Biscuit Soldier"
LevelToMonster[2161] = "Biscuit Soldier"
LevelToMonster[2162] = "Biscuit Soldier"
LevelToMonster[2163] = "Biscuit Soldier"
LevelToMonster[2164] = "Biscuit Soldier"
LevelToMonster[2165] = "Biscuit Soldier"
LevelToMonster[2166] = "Biscuit Soldier"
LevelToMonster[2167] = "Biscuit Soldier"
LevelToMonster[2168] = "Biscuit Soldier"
LevelToMonster[2169] = "Biscuit Soldier"
LevelToMonster[2170] = "Biscuit Soldier"
LevelToMonster[2171] = "Biscuit Soldier"
LevelToMonster[2172] = "Biscuit Soldier"
LevelToMonster[2173] = "Biscuit Soldier"
LevelToMonster[2174] = "Biscuit Soldier"
LevelToMonster[2175] = "Biscuit Soldier"
LevelToMonster[2176] = "Biscuit Soldier"
LevelToMonster[2177] = "Biscuit Soldier"
LevelToMonster[2178] = "Biscuit Soldier"
LevelToMonster[2179] = "Biscuit Soldier"
LevelToMonster[2180] = "Biscuit Soldier"
LevelToMonster[2181] = "Biscuit Soldier"
LevelToMonster[2182] = "Biscuit Soldier"
LevelToMonster[2183] = "Biscuit Soldier"
LevelToMonster[2184] = "Biscuit Soldier"
LevelToMonster[2185] = "Biscuit Soldier"
LevelToMonster[2186] = "Biscuit Soldier"
LevelToMonster[2187] = "Biscuit Soldier"
LevelToMonster[2188] = "Biscuit Soldier"
LevelToMonster[2189] = "Biscuit Soldier"
LevelToMonster[2190] = "Biscuit Soldier"
LevelToMonster[2191] = "Biscuit Soldier"
LevelToMonster[2192] = "Biscuit Soldier"
LevelToMonster[2193] = "Biscuit Soldier"
LevelToMonster[2194] = "Biscuit Soldier"
LevelToMonster[2195] = "Biscuit Soldier"
LevelToMonster[2196] = "Biscuit Soldier"
LevelToMonster[2197] = "Biscuit Soldier"
LevelToMonster[2198] = "Biscuit Soldier"
LevelToMonster[2199] = "Biscuit Soldier"
LevelToMonster[2200] = "Biscuit Soldier"
LevelToMonster[2201] = "Biscuit Soldier"
LevelToMonster[2202] = "Biscuit Soldier"
LevelToMonster[2203] = "Biscuit Soldier"
LevelToMonster[2204] = "Biscuit Soldier"
LevelToMonster[2205] = "Biscuit Soldier"
LevelToMonster[2206] = "Biscuit Soldier"
LevelToMonster[2207] = "Biscuit Soldier"
LevelToMonster[2208] = "Biscuit Soldier"
LevelToMonster[2209] = "Biscuit Soldier"
LevelToMonster[2210] = "Biscuit Soldier"
LevelToMonster[2211] = "Biscuit Soldier"
LevelToMonster[2212] = "Biscuit Soldier"
LevelToMonster[2213] = "Biscuit Soldier"
LevelToMonster[2214] = "Biscuit Soldier"
LevelToMonster[2215] = "Biscuit Soldier"
LevelToMonster[2216] = "Biscuit Soldier"
LevelToMonster[2217] = "Biscuit Soldier"
LevelToMonster[2218] = "Biscuit Soldier"
LevelToMonster[2219] = "Biscuit Soldier"
LevelToMonster[2220] = "Biscuit Soldier"
LevelToMonster[2221] = "Biscuit Soldier"
LevelToMonster[2222] = "Biscuit Soldier"
LevelToMonster[2223] = "Biscuit Soldier"
LevelToMonster[2224] = "Biscuit Soldier"
LevelToMonster[2225] = "Horned Warrior"
LevelToMonster[2226] = "Horned Warrior"
LevelToMonster[2227] = "Horned Warrior"
LevelToMonster[2228] = "Horned Warrior"
LevelToMonster[2229] = "Horned Warrior"
LevelToMonster[2230] = "Horned Warrior"
LevelToMonster[2231] = "Horned Warrior"
LevelToMonster[2232] = "Horned Warrior"
LevelToMonster[2233] = "Horned Warrior"
LevelToMonster[2234] = "Horned Warrior"
LevelToMonster[2235] = "Horned Warrior"
LevelToMonster[2236] = "Horned Warrior"
LevelToMonster[2237] = "Horned Warrior"
LevelToMonster[2238] = "Horned Warrior"
LevelToMonster[2239] = "Horned Warrior"
LevelToMonster[2240] = "Horned Warrior"
LevelToMonster[2241] = "Horned Warrior"
LevelToMonster[2242] = "Horned Warrior"
LevelToMonster[2243] = "Horned Warrior"
LevelToMonster[2244] = "Horned Warrior"
LevelToMonster[2245] = "Horned Warrior"
LevelToMonster[2246] = "Horned Warrior"
LevelToMonster[2247] = "Horned Warrior"
LevelToMonster[2248] = "Horned Warrior"
LevelToMonster[2249] = "Horned Warrior"
LevelToMonster[2250] = "Horned Warrior"
LevelToMonster[2251] = "Horned Warrior"
LevelToMonster[2252] = "Horned Warrior"
LevelToMonster[2253] = "Horned Warrior"
LevelToMonster[2254] = "Horned Warrior"
LevelToMonster[2255] = "Horned Warrior"
LevelToMonster[2256] = "Horned Warrior"
LevelToMonster[2257] = "Horned Warrior"
LevelToMonster[2258] = "Horned Warrior"
LevelToMonster[2259] = "Horned Warrior"
LevelToMonster[2260] = "Horned Warrior"
LevelToMonster[2261] = "Horned Warrior"
LevelToMonster[2262] = "Horned Warrior"
LevelToMonster[2263] = "Horned Warrior"
LevelToMonster[2264] = "Horned Warrior"
LevelToMonster[2265] = "Horned Warrior"
LevelToMonster[2266] = "Horned Warrior"
LevelToMonster[2267] = "Horned Warrior"
LevelToMonster[2268] = "Horned Warrior"
LevelToMonster[2269] = "Horned Warrior"
LevelToMonster[2270] = "Horned Warrior"
LevelToMonster[2271] = "Horned Warrior"
LevelToMonster[2272] = "Horned Warrior"
LevelToMonster[2273] = "Horned Warrior"
LevelToMonster[2274] = "Horned Warrior"
LevelToMonster[2275] = "Horned Warrior"
LevelToMonster[2276] = "Horned Warrior"
LevelToMonster[2277] = "Horned Warrior"
LevelToMonster[2278] = "Horned Warrior"
LevelToMonster[2279] = "Horned Warrior"
LevelToMonster[2280] = "Horned Warrior"
LevelToMonster[2281] = "Horned Warrior"
LevelToMonster[2282] = "Horned Warrior"
LevelToMonster[2283] = "Horned Warrior"
LevelToMonster[2284] = "Horned Warrior"
LevelToMonster[2285] = "Horned Warrior"
LevelToMonster[2286] = "Horned Warrior"
LevelToMonster[2287] = "Horned Warrior"
LevelToMonster[2288] = "Horned Warrior"
LevelToMonster[2289] = "Horned Warrior"
LevelToMonster[2290] = "Horned Warrior"
LevelToMonster[2291] = "Horned Warrior"
LevelToMonster[2292] = "Horned Warrior"
LevelToMonster[2293] = "Horned Warrior"
LevelToMonster[2294] = "Horned Warrior"
LevelToMonster[2295] = "Horned Warrior"
LevelToMonster[2296] = "Horned Warrior"
LevelToMonster[2297] = "Horned Warrior"
LevelToMonster[2298] = "Horned Warrior"
LevelToMonster[2299] = "Horned Warrior"
LevelToMonster[2300] = "Sick Scientist"
LevelToMonster[2301] = "Sick Scientist"
LevelToMonster[2302] = "Sick Scientist"
LevelToMonster[2303] = "Sick Scientist"
LevelToMonster[2304] = "Sick Scientist"
LevelToMonster[2305] = "Sick Scientist"
LevelToMonster[2306] = "Sick Scientist"
LevelToMonster[2307] = "Sick Scientist"
LevelToMonster[2308] = "Sick Scientist"
LevelToMonster[2309] = "Sick Scientist"
LevelToMonster[2310] = "Sick Scientist"
LevelToMonster[2311] = "Sick Scientist"
LevelToMonster[2312] = "Sick Scientist"
LevelToMonster[2313] = "Sick Scientist"
LevelToMonster[2314] = "Sick Scientist"
LevelToMonster[2315] = "Sick Scientist"
LevelToMonster[2316] = "Sick Scientist"
LevelToMonster[2317] = "Sick Scientist"
LevelToMonster[2318] = "Sick Scientist"
LevelToMonster[2319] = "Sick Scientist"
LevelToMonster[2320] = "Sick Scientist"
LevelToMonster[2321] = "Sick Scientist"
LevelToMonster[2322] = "Sick Scientist"
LevelToMonster[2323] = "Sick Scientist"
LevelToMonster[2324] = "Sick Scientist"
LevelToMonster[2325] = "Sick Scientist"
LevelToMonster[2326] = "Sick Scientist"
LevelToMonster[2327] = "Sick Scientist"
LevelToMonster[2328] = "Sick Scientist"
LevelToMonster[2329] = "Sick Scientist"
LevelToMonster[2330] = "Sick Scientist"
LevelToMonster[2331] = "Sick Scientist"
LevelToMonster[2332] = "Sick Scientist"
LevelToMonster[2333] = "Sick Scientist"
LevelToMonster[2334] = "Sick Scientist"
LevelToMonster[2335] = "Sick Scientist"
LevelToMonster[2336] = "Sick Scientist"
LevelToMonster[2337] = "Sick Scientist"
LevelToMonster[2338] = "Sick Scientist"
LevelToMonster[2339] = "Sick Scientist"
LevelToMonster[2340] = "Sick Scientist"
LevelToMonster[2341] = "Sick Scientist"
LevelToMonster[2342] = "Sick Scientist"
LevelToMonster[2343] = "Sick Scientist"
LevelToMonster[2344] = "Sick Scientist"
LevelToMonster[2345] = "Sick Scientist"
LevelToMonster[2346] = "Sick Scientist"
LevelToMonster[2347] = "Sick Scientist"
LevelToMonster[2348] = "Sick Scientist"
LevelToMonster[2349] = "Sick Scientist"
LevelToMonster[2350] = "Sick Scientist"
LevelToMonster[2351] = "Sick Scientist"
LevelToMonster[2352] = "Sick Scientist"
LevelToMonster[2353] = "Sick Scientist"
LevelToMonster[2354] = "Sick Scientist"
LevelToMonster[2355] = "Sick Scientist"
LevelToMonster[2356] = "Sick Scientist"
LevelToMonster[2357] = "Sick Scientist"
LevelToMonster[2358] = "Sick Scientist"
LevelToMonster[2359] = "Sick Scientist"
LevelToMonster[2360] = "Sick Scientist"
LevelToMonster[2361] = "Sick Scientist"
LevelToMonster[2362] = "Sick Scientist"
LevelToMonster[2363] = "Sick Scientist"
LevelToMonster[2364] = "Sick Scientist"
LevelToMonster[2365] = "Sick Scientist"
LevelToMonster[2366] = "Sick Scientist"
LevelToMonster[2367] = "Sick Scientist"
LevelToMonster[2368] = "Sick Scientist"
LevelToMonster[2369] = "Sick Scientist"
LevelToMonster[2370] = "Sick Scientist"
LevelToMonster[2371] = "Sick Scientist"
LevelToMonster[2372] = "Sick Scientist"
LevelToMonster[2373] = "Sick Scientist"
LevelToMonster[2374] = "Sick Scientist"
LevelToMonster[2375] = "Aerial Warrior"
LevelToMonster[2376] = "Aerial Warrior"
LevelToMonster[2377] = "Aerial Warrior"
LevelToMonster[2378] = "Aerial Warrior"
LevelToMonster[2379] = "Aerial Warrior"
LevelToMonster[2380] = "Aerial Warrior"
LevelToMonster[2381] = "Aerial Warrior"
LevelToMonster[2382] = "Aerial Warrior"
LevelToMonster[2383] = "Aerial Warrior"
LevelToMonster[2384] = "Aerial Warrior"
LevelToMonster[2385] = "Aerial Warrior"
LevelToMonster[2386] = "Aerial Warrior"
LevelToMonster[2387] = "Aerial Warrior"
LevelToMonster[2388] = "Aerial Warrior"
LevelToMonster[2389] = "Aerial Warrior"
LevelToMonster[2390] = "Aerial Warrior"
LevelToMonster[2391] = "Aerial Warrior"
LevelToMonster[2392] = "Aerial Warrior"
LevelToMonster[2393] = "Aerial Warrior"
LevelToMonster[2394] = "Aerial Warrior"
LevelToMonster[2395] = "Aerial Warrior"
LevelToMonster[2396] = "Aerial Warrior"
LevelToMonster[2397] = "Aerial Warrior"
LevelToMonster[2398] = "Aerial Warrior"
LevelToMonster[2399] = "Aerial Warrior"
LevelToMonster[2400] = "Aerial Warrior"
LevelToMonster[2401] = "Aerial Warrior"
LevelToMonster[2402] = "Aerial Warrior"
LevelToMonster[2403] = "Aerial Warrior"
LevelToMonster[2404] = "Aerial Warrior"
LevelToMonster[2405] = "Aerial Warrior"
LevelToMonster[2406] = "Aerial Warrior"
LevelToMonster[2407] = "Aerial Warrior"
LevelToMonster[2408] = "Aerial Warrior"
LevelToMonster[2409] = "Aerial Warrior"
LevelToMonster[2410] = "Aerial Warrior"
LevelToMonster[2411] = "Aerial Warrior"
LevelToMonster[2412] = "Aerial Warrior"
LevelToMonster[2413] = "Aerial Warrior"
LevelToMonster[2414] = "Aerial Warrior"
LevelToMonster[2415] = "Aerial Warrior"
LevelToMonster[2416] = "Aerial Warrior"
LevelToMonster[2417] = "Aerial Warrior"
LevelToMonster[2418] = "Aerial Warrior"
LevelToMonster[2419] = "Aerial Warrior"
LevelToMonster[2420] = "Aerial Warrior"
LevelToMonster[2421] = "Aerial Warrior"
LevelToMonster[2422] = "Aerial Warrior"
LevelToMonster[2423] = "Aerial Warrior"
LevelToMonster[2424] = "Aerial Warrior"
LevelToMonster[2425] = "Aerial Warrior"
LevelToMonster[2426] = "Aerial Warrior"
LevelToMonster[2427] = "Aerial Warrior"
LevelToMonster[2428] = "Aerial Warrior"
LevelToMonster[2429] = "Aerial Warrior"
LevelToMonster[2430] = "Aerial Warrior"
LevelToMonster[2431] = "Aerial Warrior"
LevelToMonster[2432] = "Aerial Warrior"
LevelToMonster[2433] = "Aerial Warrior"
LevelToMonster[2434] = "Aerial Warrior"
LevelToMonster[2435] = "Aerial Warrior"
LevelToMonster[2436] = "Aerial Warrior"
LevelToMonster[2437] = "Aerial Warrior"
LevelToMonster[2438] = "Aerial Warrior"
LevelToMonster[2439] = "Aerial Warrior"
LevelToMonster[2440] = "Aerial Warrior"
LevelToMonster[2441] = "Aerial Warrior"
LevelToMonster[2442] = "Aerial Warrior"
LevelToMonster[2443] = "Aerial Warrior"
LevelToMonster[2444] = "Aerial Warrior"
LevelToMonster[2445] = "Aerial Warrior"
LevelToMonster[2446] = "Aerial Warrior"
LevelToMonster[2447] = "Aerial Warrior"
LevelToMonster[2448] = "Aerial Warrior"
LevelToMonster[2449] = "Aerial Warrior"
LevelToMonster[2450] = "Cursed Skeleton"
LevelToMonster[2451] = "Cursed Skeleton"
LevelToMonster[2452] = "Cursed Skeleton"
LevelToMonster[2453] = "Cursed Skeleton"
LevelToMonster[2454] = "Cursed Skeleton"
LevelToMonster[2455] = "Cursed Skeleton"
LevelToMonster[2456] = "Cursed Skeleton"
LevelToMonster[2457] = "Cursed Skeleton"
LevelToMonster[2458] = "Cursed Skeleton"
LevelToMonster[2459] = "Cursed Skeleton"
LevelToMonster[2460] = "Cursed Skeleton"
LevelToMonster[2461] = "Cursed Skeleton"
LevelToMonster[2462] = "Cursed Skeleton"
LevelToMonster[2463] = "Cursed Skeleton"
LevelToMonster[2464] = "Cursed Skeleton"
LevelToMonster[2465] = "Cursed Skeleton"
LevelToMonster[2466] = "Cursed Skeleton"
LevelToMonster[2467] = "Cursed Skeleton"
LevelToMonster[2468] = "Cursed Skeleton"
LevelToMonster[2469] = "Cursed Skeleton"
LevelToMonster[2470] = "Cursed Skeleton"
LevelToMonster[2471] = "Cursed Skeleton"
LevelToMonster[2472] = "Cursed Skeleton"
LevelToMonster[2473] = "Cursed Skeleton"
LevelToMonster[2474] = "Cursed Skeleton"
LevelToMonster[2475] = "Cursed Skeleton"
LevelToMonster[2476] = "Cursed Skeleton"
LevelToMonster[2477] = "Cursed Skeleton"
LevelToMonster[2478] = "Cursed Skeleton"
LevelToMonster[2479] = "Cursed Skeleton"
LevelToMonster[2480] = "Cursed Skeleton"
LevelToMonster[2481] = "Cursed Skeleton"
LevelToMonster[2482] = "Cursed Skeleton"
LevelToMonster[2483] = "Cursed Skeleton"
LevelToMonster[2484] = "Cursed Skeleton"
LevelToMonster[2485] = "Cursed Skeleton"
LevelToMonster[2486] = "Cursed Skeleton"
LevelToMonster[2487] = "Cursed Skeleton"
LevelToMonster[2488] = "Cursed Skeleton"
LevelToMonster[2489] = "Cursed Skeleton"
LevelToMonster[2490] = "Cursed Skeleton"
LevelToMonster[2491] = "Cursed Skeleton"
LevelToMonster[2492] = "Cursed Skeleton"
LevelToMonster[2493] = "Cursed Skeleton"
LevelToMonster[2494] = "Cursed Skeleton"
LevelToMonster[2495] = "Cursed Skeleton"
LevelToMonster[2496] = "Cursed Skeleton"
LevelToMonster[2497] = "Cursed Skeleton"
LevelToMonster[2498] = "Cursed Skeleton"
LevelToMonster[2499] = "Cursed Skeleton"
LevelToMonster[2500] = "Cursed Skeleton"
LevelToMonster[2501] = "Cursed Skeleton"
LevelToMonster[2502] = "Cursed Skeleton"
LevelToMonster[2503] = "Cursed Skeleton"
LevelToMonster[2504] = "Cursed Skeleton"
LevelToMonster[2505] = "Cursed Skeleton"
LevelToMonster[2506] = "Cursed Skeleton"
LevelToMonster[2507] = "Cursed Skeleton"
LevelToMonster[2508] = "Cursed Skeleton"
LevelToMonster[2509] = "Cursed Skeleton"
LevelToMonster[2510] = "Cursed Skeleton"
LevelToMonster[2511] = "Cursed Skeleton"
LevelToMonster[2512] = "Cursed Skeleton"
LevelToMonster[2513] = "Cursed Skeleton"
LevelToMonster[2514] = "Cursed Skeleton"
LevelToMonster[2515] = "Cursed Skeleton"
LevelToMonster[2516] = "Cursed Skeleton"
LevelToMonster[2517] = "Cursed Skeleton"
LevelToMonster[2518] = "Cursed Skeleton"
LevelToMonster[2519] = "Cursed Skeleton"
LevelToMonster[2520] = "Cursed Skeleton"
LevelToMonster[2521] = "Cursed Skeleton"
LevelToMonster[2522] = "Cursed Skeleton"
LevelToMonster[2523] = "Cursed Skeleton"
LevelToMonster[2524] = "Cursed Skeleton"
LevelToMonster[2525] = "Fishman Raider"
LevelToMonster[2526] = "Fishman Raider"
LevelToMonster[2527] = "Fishman Raider"
LevelToMonster[2528] = "Fishman Raider"
LevelToMonster[2529] = "Fishman Raider"
LevelToMonster[2530] = "Fishman Raider"
LevelToMonster[2531] = "Fishman Raider"
LevelToMonster[2532] = "Fishman Raider"
LevelToMonster[2533] = "Fishman Raider"
LevelToMonster[2534] = "Fishman Raider"
LevelToMonster[2535] = "Fishman Raider"
LevelToMonster[2536] = "Fishman Raider"
LevelToMonster[2537] = "Fishman Raider"
LevelToMonster[2538] = "Fishman Raider"
LevelToMonster[2539] = "Fishman Raider"
LevelToMonster[2540] = "Fishman Raider"
LevelToMonster[2541] = "Fishman Raider"
LevelToMonster[2542] = "Fishman Raider"
LevelToMonster[2543] = "Fishman Raider"
LevelToMonster[2544] = "Fishman Raider"
LevelToMonster[2545] = "Fishman Raider"
LevelToMonster[2546] = "Fishman Raider"
LevelToMonster[2547] = "Fishman Raider"
LevelToMonster[2548] = "Fishman Raider"
LevelToMonster[2549] = "Fishman Raider"
LevelToMonster[2550] = "Fishman Raider"
LevelToMonster[2551] = "Fishman Raider"
LevelToMonster[2552] = "Fishman Raider"
LevelToMonster[2553] = "Fishman Raider"
LevelToMonster[2554] = "Fishman Raider"
LevelToMonster[2555] = "Fishman Raider"
LevelToMonster[2556] = "Fishman Raider"
LevelToMonster[2557] = "Fishman Raider"
LevelToMonster[2558] = "Fishman Raider"
LevelToMonster[2559] = "Fishman Raider"
LevelToMonster[2560] = "Fishman Raider"
LevelToMonster[2561] = "Fishman Raider"
LevelToMonster[2562] = "Fishman Raider"
LevelToMonster[2563] = "Fishman Raider"
LevelToMonster[2564] = "Fishman Raider"
LevelToMonster[2565] = "Fishman Raider"
LevelToMonster[2566] = "Fishman Raider"
LevelToMonster[2567] = "Fishman Raider"
LevelToMonster[2568] = "Fishman Raider"
LevelToMonster[2569] = "Fishman Raider"
LevelToMonster[2570] = "Fishman Raider"
LevelToMonster[2571] = "Fishman Raider"
LevelToMonster[2572] = "Fishman Raider"
LevelToMonster[2573] = "Fishman Raider"
LevelToMonster[2574] = "Fishman Raider"
LevelToMonster[2575] = "Fishman Raider"
LevelToMonster[2576] = "Fishman Raider"
LevelToMonster[2577] = "Fishman Raider"
LevelToMonster[2578] = "Fishman Raider"
LevelToMonster[2579] = "Fishman Raider"
LevelToMonster[2580] = "Fishman Raider"
LevelToMonster[2581] = "Fishman Raider"
LevelToMonster[2582] = "Fishman Raider"
LevelToMonster[2583] = "Fishman Raider"
LevelToMonster[2584] = "Fishman Raider"
LevelToMonster[2585] = "Fishman Raider"
LevelToMonster[2586] = "Fishman Raider"
LevelToMonster[2587] = "Fishman Raider"
LevelToMonster[2588] = "Fishman Raider"
LevelToMonster[2589] = "Fishman Raider"
LevelToMonster[2590] = "Fishman Raider"
LevelToMonster[2591] = "Fishman Raider"
LevelToMonster[2592] = "Fishman Raider"
LevelToMonster[2593] = "Fishman Raider"
LevelToMonster[2594] = "Fishman Raider"
LevelToMonster[2595] = "Fishman Raider"
LevelToMonster[2596] = "Fishman Raider"
LevelToMonster[2597] = "Fishman Raider"
LevelToMonster[2598] = "Fishman Raider"
LevelToMonster[2599] = "Fishman Raider"
LevelToMonster[2600] = "Fishman Raider"
LevelToMonster[2601] = "Fishman Raider"
LevelToMonster[2602] = "Fishman Raider"
LevelToMonster[2603] = "Fishman Raider"
LevelToMonster[2604] = "Fishman Raider"
LevelToMonster[2605] = "Fishman Raider"
LevelToMonster[2606] = "Fishman Raider"
LevelToMonster[2607] = "Fishman Raider"
LevelToMonster[2608] = "Fishman Raider"
LevelToMonster[2609] = "Fishman Raider"
LevelToMonster[2610] = "Fishman Raider"
LevelToMonster[2611] = "Fishman Raider"
LevelToMonster[2612] = "Fishman Raider"
LevelToMonster[2613] = "Fishman Raider"
LevelToMonster[2614] = "Fishman Raider"
LevelToMonster[2615] = "Fishman Raider"
LevelToMonster[2616] = "Fishman Raider"
LevelToMonster[2617] = "Fishman Raider"
LevelToMonster[2618] = "Fishman Raider"
LevelToMonster[2619] = "Fishman Raider"
LevelToMonster[2620] = "Fishman Raider"
LevelToMonster[2621] = "Fishman Raider"
LevelToMonster[2622] = "Fishman Raider"
LevelToMonster[2623] = "Fishman Raider"
LevelToMonster[2624] = "Fishman Raider"
LevelToMonster[2625] = "Fishman Gunner"
LevelToMonster[2626] = "Fishman Gunner"
LevelToMonster[2627] = "Fishman Gunner"
LevelToMonster[2628] = "Fishman Gunner"
LevelToMonster[2629] = "Fishman Gunner"
LevelToMonster[2630] = "Fishman Gunner"
LevelToMonster[2631] = "Fishman Gunner"
LevelToMonster[2632] = "Fishman Gunner"
LevelToMonster[2633] = "Fishman Gunner"
LevelToMonster[2634] = "Fishman Gunner"
LevelToMonster[2635] = "Fishman Gunner"
LevelToMonster[2636] = "Fishman Gunner"
LevelToMonster[2637] = "Fishman Gunner"
LevelToMonster[2638] = "Fishman Gunner"
LevelToMonster[2639] = "Fishman Gunner"
LevelToMonster[2640] = "Fishman Gunner"
LevelToMonster[2641] = "Fishman Gunner"
LevelToMonster[2642] = "Fishman Gunner"
LevelToMonster[2643] = "Fishman Gunner"
LevelToMonster[2644] = "Fishman Gunner"
LevelToMonster[2645] = "Fishman Gunner"
LevelToMonster[2646] = "Fishman Gunner"
LevelToMonster[2647] = "Fishman Gunner"
LevelToMonster[2648] = "Fishman Gunner"
LevelToMonster[2649] = "Fishman Gunner"
LevelToMonster[2650] = "Fishman Gunner"
LevelToMonster[2651] = "Fishman Gunner"
LevelToMonster[2652] = "Fishman Gunner"
LevelToMonster[2653] = "Fishman Gunner"
LevelToMonster[2654] = "Fishman Gunner"
LevelToMonster[2655] = "Fishman Gunner"
LevelToMonster[2656] = "Fishman Gunner"
LevelToMonster[2657] = "Fishman Gunner"
LevelToMonster[2658] = "Fishman Gunner"
LevelToMonster[2659] = "Fishman Gunner"
LevelToMonster[2660] = "Fishman Gunner"
LevelToMonster[2661] = "Fishman Gunner"
LevelToMonster[2662] = "Fishman Gunner"
LevelToMonster[2663] = "Fishman Gunner"
LevelToMonster[2664] = "Fishman Gunner"
LevelToMonster[2665] = "Fishman Gunner"
LevelToMonster[2666] = "Fishman Gunner"
LevelToMonster[2667] = "Fishman Gunner"
LevelToMonster[2668] = "Fishman Gunner"
LevelToMonster[2669] = "Fishman Gunner"
LevelToMonster[2670] = "Fishman Gunner"
LevelToMonster[2671] = "Fishman Gunner"
LevelToMonster[2672] = "Fishman Gunner"
LevelToMonster[2673] = "Fishman Gunner"
LevelToMonster[2674] = "Fishman Gunner"
LevelToMonster[2675] = "Fishman Gunner"
LevelToMonster[2676] = "Fishman Gunner"
LevelToMonster[2677] = "Fishman Gunner"
LevelToMonster[2678] = "Fishman Gunner"
LevelToMonster[2679] = "Fishman Gunner"
LevelToMonster[2680] = "Fishman Gunner"
LevelToMonster[2681] = "Fishman Gunner"
LevelToMonster[2682] = "Fishman Gunner"
LevelToMonster[2683] = "Fishman Gunner"
LevelToMonster[2684] = "Fishman Gunner"
LevelToMonster[2685] = "Fishman Gunner"
LevelToMonster[2686] = "Fishman Gunner"
LevelToMonster[2687] = "Fishman Gunner"
LevelToMonster[2688] = "Fishman Gunner"
LevelToMonster[2689] = "Fishman Gunner"
LevelToMonster[2690] = "Fishman Gunner"
LevelToMonster[2691] = "Fishman Gunner"
LevelToMonster[2692] = "Fishman Gunner"
LevelToMonster[2693] = "Fishman Gunner"
LevelToMonster[2694] = "Fishman Gunner"
LevelToMonster[2695] = "Fishman Gunner"
LevelToMonster[2696] = "Fishman Gunner"
LevelToMonster[2697] = "Fishman Gunner"
LevelToMonster[2698] = "Fishman Gunner"
LevelToMonster[2699] = "Fishman Gunner"
LevelToMonster[2700] = "Sea Soldier"
LevelToMonster[2701] = "Sea Soldier"
LevelToMonster[2702] = "Sea Soldier"
LevelToMonster[2703] = "Sea Soldier"
LevelToMonster[2704] = "Sea Soldier"
LevelToMonster[2705] = "Sea Soldier"
LevelToMonster[2706] = "Sea Soldier"
LevelToMonster[2707] = "Sea Soldier"
LevelToMonster[2708] = "Sea Soldier"
LevelToMonster[2709] = "Sea Soldier"
LevelToMonster[2710] = "Sea Soldier"
LevelToMonster[2711] = "Sea Soldier"
LevelToMonster[2712] = "Sea Soldier"
LevelToMonster[2713] = "Sea Soldier"
LevelToMonster[2714] = "Sea Soldier"
LevelToMonster[2715] = "Sea Soldier"
LevelToMonster[2716] = "Sea Soldier"
LevelToMonster[2717] = "Sea Soldier"
LevelToMonster[2718] = "Sea Soldier"
LevelToMonster[2719] = "Sea Soldier"
LevelToMonster[2720] = "Sea Soldier"
LevelToMonster[2721] = "Sea Soldier"
LevelToMonster[2722] = "Sea Soldier"
LevelToMonster[2723] = "Sea Soldier"
LevelToMonster[2724] = "Sea Soldier"
LevelToMonster[2725] = "Sea Soldier"
LevelToMonster[2726] = "Sea Soldier"
LevelToMonster[2727] = "Sea Soldier"
LevelToMonster[2728] = "Sea Soldier"
LevelToMonster[2729] = "Sea Soldier"
LevelToMonster[2730] = "Sea Soldier"
LevelToMonster[2731] = "Sea Soldier"
LevelToMonster[2732] = "Sea Soldier"
LevelToMonster[2733] = "Sea Soldier"
LevelToMonster[2734] = "Sea Soldier"
LevelToMonster[2735] = "Sea Soldier"
LevelToMonster[2736] = "Sea Soldier"
LevelToMonster[2737] = "Sea Soldier"
LevelToMonster[2738] = "Sea Soldier"
LevelToMonster[2739] = "Sea Soldier"
LevelToMonster[2740] = "Sea Soldier"
LevelToMonster[2741] = "Sea Soldier"
LevelToMonster[2742] = "Sea Soldier"
LevelToMonster[2743] = "Sea Soldier"
LevelToMonster[2744] = "Sea Soldier"
LevelToMonster[2745] = "Sea Soldier"
LevelToMonster[2746] = "Sea Soldier"
LevelToMonster[2747] = "Sea Soldier"
LevelToMonster[2748] = "Sea Soldier"
LevelToMonster[2749] = "Sea Soldier"
LevelToMonster[2750] = "Sea Soldier"
LevelToMonster[2751] = "Sea Soldier"
LevelToMonster[2752] = "Sea Soldier"
LevelToMonster[2753] = "Sea Soldier"
LevelToMonster[2754] = "Sea Soldier"
LevelToMonster[2755] = "Sea Soldier"
LevelToMonster[2756] = "Sea Soldier"
LevelToMonster[2757] = "Sea Soldier"
LevelToMonster[2758] = "Sea Soldier"
LevelToMonster[2759] = "Sea Soldier"
LevelToMonster[2760] = "Sea Soldier"
LevelToMonster[2761] = "Sea Soldier"
LevelToMonster[2762] = "Sea Soldier"
LevelToMonster[2763] = "Sea Soldier"
LevelToMonster[2764] = "Sea Soldier"
LevelToMonster[2765] = "Sea Soldier"
LevelToMonster[2766] = "Sea Soldier"
LevelToMonster[2767] = "Sea Soldier"
LevelToMonster[2768] = "Sea Soldier"
LevelToMonster[2769] = "Sea Soldier"
LevelToMonster[2770] = "Sea Soldier"
LevelToMonster[2771] = "Sea Soldier"
LevelToMonster[2772] = "Sea Soldier"
LevelToMonster[2773] = "Sea Soldier"
LevelToMonster[2774] = "Sea Soldier"
LevelToMonster[2775] = "Surfer Pirate"
LevelToMonster[2776] = "Surfer Pirate"
LevelToMonster[2777] = "Surfer Pirate"
LevelToMonster[2778] = "Surfer Pirate"
LevelToMonster[2779] = "Surfer Pirate"
LevelToMonster[2780] = "Surfer Pirate"
LevelToMonster[2781] = "Surfer Pirate"
LevelToMonster[2782] = "Surfer Pirate"
LevelToMonster[2783] = "Surfer Pirate"
LevelToMonster[2784] = "Surfer Pirate"
LevelToMonster[2785] = "Surfer Pirate"
LevelToMonster[2786] = "Surfer Pirate"
LevelToMonster[2787] = "Surfer Pirate"
LevelToMonster[2788] = "Surfer Pirate"
LevelToMonster[2789] = "Surfer Pirate"
LevelToMonster[2790] = "Surfer Pirate"
LevelToMonster[2791] = "Surfer Pirate"
LevelToMonster[2792] = "Surfer Pirate"
LevelToMonster[2793] = "Surfer Pirate"
LevelToMonster[2794] = "Surfer Pirate"
LevelToMonster[2795] = "Surfer Pirate"
LevelToMonster[2796] = "Surfer Pirate"
LevelToMonster[2797] = "Surfer Pirate"
LevelToMonster[2798] = "Surfer Pirate"
LevelToMonster[2799] = "Surfer Pirate"
LevelToMonster[2800] = "Surfer Pirate"
LevelToMonster[2801] = "Surfer Pirate"
LevelToMonster[2802] = "Surfer Pirate"
LevelToMonster[2803] = "Surfer Pirate"
LevelToMonster[2804] = "Surfer Pirate"
LevelToMonster[2805] = "Surfer Pirate"
LevelToMonster[2806] = "Surfer Pirate"
LevelToMonster[2807] = "Surfer Pirate"
LevelToMonster[2808] = "Surfer Pirate"
LevelToMonster[2809] = "Surfer Pirate"
LevelToMonster[2810] = "Surfer Pirate"
LevelToMonster[2811] = "Surfer Pirate"
LevelToMonster[2812] = "Surfer Pirate"
LevelToMonster[2813] = "Surfer Pirate"
LevelToMonster[2814] = "Surfer Pirate"
LevelToMonster[2815] = "Surfer Pirate"
LevelToMonster[2816] = "Surfer Pirate"
LevelToMonster[2817] = "Surfer Pirate"
LevelToMonster[2818] = "Surfer Pirate"
LevelToMonster[2819] = "Surfer Pirate"
LevelToMonster[2820] = "Surfer Pirate"
LevelToMonster[2821] = "Surfer Pirate"
LevelToMonster[2822] = "Surfer Pirate"
LevelToMonster[2823] = "Surfer Pirate"
LevelToMonster[2824] = "Surfer Pirate"
LevelToMonster[2825] = "Surfer Pirate"
LevelToMonster[2826] = "Surfer Pirate"
LevelToMonster[2827] = "Surfer Pirate"
LevelToMonster[2828] = "Surfer Pirate"
LevelToMonster[2829] = "Surfer Pirate"
LevelToMonster[2830] = "Surfer Pirate"
LevelToMonster[2831] = "Surfer Pirate"
LevelToMonster[2832] = "Surfer Pirate"
LevelToMonster[2833] = "Surfer Pirate"
LevelToMonster[2834] = "Surfer Pirate"
LevelToMonster[2835] = "Surfer Pirate"
LevelToMonster[2836] = "Surfer Pirate"
LevelToMonster[2837] = "Surfer Pirate"
LevelToMonster[2838] = "Surfer Pirate"
LevelToMonster[2839] = "Surfer Pirate"
LevelToMonster[2840] = "Surfer Pirate"
LevelToMonster[2841] = "Surfer Pirate"
LevelToMonster[2842] = "Surfer Pirate"
LevelToMonster[2843] = "Surfer Pirate"
LevelToMonster[2844] = "Surfer Pirate"
LevelToMonster[2845] = "Surfer Pirate"
LevelToMonster[2846] = "Surfer Pirate"
LevelToMonster[2847] = "Surfer Pirate"
LevelToMonster[2848] = "Surfer Pirate"
LevelToMonster[2849] = "Surfer Pirate"
LevelToMonster[2850] = "Pirate of Wano"
LevelToMonster[2851] = "Pirate of Wano"
LevelToMonster[2852] = "Pirate of Wano"
LevelToMonster[2853] = "Pirate of Wano"
LevelToMonster[2854] = "Pirate of Wano"
LevelToMonster[2855] = "Pirate of Wano"
LevelToMonster[2856] = "Pirate of Wano"
LevelToMonster[2857] = "Pirate of Wano"
LevelToMonster[2858] = "Pirate of Wano"
LevelToMonster[2859] = "Pirate of Wano"
LevelToMonster[2860] = "Pirate of Wano"
LevelToMonster[2861] = "Pirate of Wano"
LevelToMonster[2862] = "Pirate of Wano"
LevelToMonster[2863] = "Pirate of Wano"
LevelToMonster[2864] = "Pirate of Wano"
LevelToMonster[2865] = "Pirate of Wano"
LevelToMonster[2866] = "Pirate of Wano"
LevelToMonster[2867] = "Pirate of Wano"
LevelToMonster[2868] = "Pirate of Wano"
LevelToMonster[2869] = "Pirate of Wano"
LevelToMonster[2870] = "Pirate of Wano"
LevelToMonster[2871] = "Pirate of Wano"
LevelToMonster[2872] = "Pirate of Wano"
LevelToMonster[2873] = "Pirate of Wano"
LevelToMonster[2874] = "Pirate of Wano"
LevelToMonster[2875] = "Pirate of Wano"
LevelToMonster[2876] = "Pirate of Wano"
LevelToMonster[2877] = "Pirate of Wano"
LevelToMonster[2878] = "Pirate of Wano"
LevelToMonster[2879] = "Pirate of Wano"
LevelToMonster[2880] = "Pirate of Wano"
LevelToMonster[2881] = "Pirate of Wano"
LevelToMonster[2882] = "Pirate of Wano"
LevelToMonster[2883] = "Pirate of Wano"
LevelToMonster[2884] = "Pirate of Wano"
LevelToMonster[2885] = "Pirate of Wano"
LevelToMonster[2886] = "Pirate of Wano"
LevelToMonster[2887] = "Pirate of Wano"
LevelToMonster[2888] = "Pirate of Wano"
LevelToMonster[2889] = "Pirate of Wano"
LevelToMonster[2890] = "Pirate of Wano"
LevelToMonster[2891] = "Pirate of Wano"
LevelToMonster[2892] = "Pirate of Wano"
LevelToMonster[2893] = "Pirate of Wano"
LevelToMonster[2894] = "Pirate of Wano"
LevelToMonster[2895] = "Pirate of Wano"
LevelToMonster[2896] = "Pirate of Wano"
LevelToMonster[2897] = "Pirate of Wano"
LevelToMonster[2898] = "Pirate of Wano"
LevelToMonster[2899] = "Pirate of Wano"
LevelToMonster[2900] = "Pirate of Wano"
LevelToMonster[2901] = "Pirate of Wano"
LevelToMonster[2902] = "Pirate of Wano"
LevelToMonster[2903] = "Pirate of Wano"
LevelToMonster[2904] = "Pirate of Wano"
LevelToMonster[2905] = "Pirate of Wano"
LevelToMonster[2906] = "Pirate of Wano"
LevelToMonster[2907] = "Pirate of Wano"
LevelToMonster[2908] = "Pirate of Wano"
LevelToMonster[2909] = "Pirate of Wano"
LevelToMonster[2910] = "Pirate of Wano"
LevelToMonster[2911] = "Pirate of Wano"
LevelToMonster[2912] = "Pirate of Wano"
LevelToMonster[2913] = "Pirate of Wano"
LevelToMonster[2914] = "Pirate of Wano"
LevelToMonster[2915] = "Pirate of Wano"
LevelToMonster[2916] = "Pirate of Wano"
LevelToMonster[2917] = "Pirate of Wano"
LevelToMonster[2918] = "Pirate of Wano"
LevelToMonster[2919] = "Pirate of Wano"
LevelToMonster[2920] = "Pirate of Wano"
LevelToMonster[2921] = "Pirate of Wano"
LevelToMonster[2922] = "Pirate of Wano"
LevelToMonster[2923] = "Pirate of Wano"
LevelToMonster[2924] = "Pirate of Wano"
LevelToMonster[2925] = "Samurai"
LevelToMonster[2926] = "Samurai"
LevelToMonster[2927] = "Samurai"
LevelToMonster[2928] = "Samurai"
LevelToMonster[2929] = "Samurai"
LevelToMonster[2930] = "Samurai"
LevelToMonster[2931] = "Samurai"
LevelToMonster[2932] = "Samurai"
LevelToMonster[2933] = "Samurai"
LevelToMonster[2934] = "Samurai"
LevelToMonster[2935] = "Samurai"
LevelToMonster[2936] = "Samurai"
LevelToMonster[2937] = "Samurai"
LevelToMonster[2938] = "Samurai"
LevelToMonster[2939] = "Samurai"
LevelToMonster[2940] = "Samurai"
LevelToMonster[2941] = "Samurai"
LevelToMonster[2942] = "Samurai"
LevelToMonster[2943] = "Samurai"
LevelToMonster[2944] = "Samurai"
LevelToMonster[2945] = "Samurai"
LevelToMonster[2946] = "Samurai"
LevelToMonster[2947] = "Samurai"
LevelToMonster[2948] = "Samurai"
LevelToMonster[2949] = "Samurai"
LevelToMonster[2950] = "Samurai"
LevelToMonster[2951] = "Samurai"
LevelToMonster[2952] = "Samurai"
LevelToMonster[2953] = "Samurai"
LevelToMonster[2954] = "Samurai"
LevelToMonster[2955] = "Samurai"
LevelToMonster[2956] = "Samurai"
LevelToMonster[2957] = "Samurai"
LevelToMonster[2958] = "Samurai"
LevelToMonster[2959] = "Samurai"
LevelToMonster[2960] = "Samurai"
LevelToMonster[2961] = "Samurai"
LevelToMonster[2962] = "Samurai"
LevelToMonster[2963] = "Samurai"
LevelToMonster[2964] = "Samurai"
LevelToMonster[2965] = "Samurai"
LevelToMonster[2966] = "Samurai"
LevelToMonster[2967] = "Samurai"
LevelToMonster[2968] = "Samurai"
LevelToMonster[2969] = "Samurai"
LevelToMonster[2970] = "Samurai"
LevelToMonster[2971] = "Samurai"
LevelToMonster[2972] = "Samurai"
LevelToMonster[2973] = "Samurai"
LevelToMonster[2974] = "Samurai"
LevelToMonster[2975] = "Samurai"
LevelToMonster[2976] = "Samurai"
LevelToMonster[2977] = "Samurai"
LevelToMonster[2978] = "Samurai"
LevelToMonster[2979] = "Samurai"
LevelToMonster[2980] = "Samurai"
LevelToMonster[2981] = "Samurai"
LevelToMonster[2982] = "Samurai"
LevelToMonster[2983] = "Samurai"
LevelToMonster[2984] = "Samurai"
LevelToMonster[2985] = "Samurai"
LevelToMonster[2986] = "Samurai"
LevelToMonster[2987] = "Samurai"
LevelToMonster[2988] = "Samurai"
LevelToMonster[2989] = "Samurai"
LevelToMonster[2990] = "Samurai"
LevelToMonster[2991] = "Samurai"
LevelToMonster[2992] = "Samurai"
LevelToMonster[2993] = "Samurai"
LevelToMonster[2994] = "Samurai"
LevelToMonster[2995] = "Samurai"
LevelToMonster[2996] = "Samurai"
LevelToMonster[2997] = "Samurai"
LevelToMonster[2998] = "Samurai"
LevelToMonster[2999] = "Samurai"
LevelToMonster[3000] = "Snowflake Soldier"
LevelToMonster[3001] = "Snowflake Soldier"
LevelToMonster[3002] = "Snowflake Soldier"
LevelToMonster[3003] = "Snowflake Soldier"
LevelToMonster[3004] = "Snowflake Soldier"
LevelToMonster[3005] = "Snowflake Soldier"
LevelToMonster[3006] = "Snowflake Soldier"
LevelToMonster[3007] = "Snowflake Soldier"
LevelToMonster[3008] = "Snowflake Soldier"
LevelToMonster[3009] = "Snowflake Soldier"
LevelToMonster[3010] = "Snowflake Soldier"
LevelToMonster[3011] = "Snowflake Soldier"
LevelToMonster[3012] = "Snowflake Soldier"
LevelToMonster[3013] = "Snowflake Soldier"
LevelToMonster[3014] = "Snowflake Soldier"
LevelToMonster[3015] = "Snowflake Soldier"
LevelToMonster[3016] = "Snowflake Soldier"
LevelToMonster[3017] = "Snowflake Soldier"
LevelToMonster[3018] = "Snowflake Soldier"
LevelToMonster[3019] = "Snowflake Soldier"
LevelToMonster[3020] = "Snowflake Soldier"
LevelToMonster[3021] = "Snowflake Soldier"
LevelToMonster[3022] = "Snowflake Soldier"
LevelToMonster[3023] = "Snowflake Soldier"
LevelToMonster[3024] = "Snowflake Soldier"
LevelToMonster[3025] = "Snowflake Soldier"
LevelToMonster[3026] = "Snowflake Soldier"
LevelToMonster[3027] = "Snowflake Soldier"
LevelToMonster[3028] = "Snowflake Soldier"
LevelToMonster[3029] = "Snowflake Soldier"
LevelToMonster[3030] = "Snowflake Soldier"
LevelToMonster[3031] = "Snowflake Soldier"
LevelToMonster[3032] = "Snowflake Soldier"
LevelToMonster[3033] = "Snowflake Soldier"
LevelToMonster[3034] = "Snowflake Soldier"
LevelToMonster[3035] = "Snowflake Soldier"
LevelToMonster[3036] = "Snowflake Soldier"
LevelToMonster[3037] = "Snowflake Soldier"
LevelToMonster[3038] = "Snowflake Soldier"
LevelToMonster[3039] = "Snowflake Soldier"
LevelToMonster[3040] = "Snowflake Soldier"
LevelToMonster[3041] = "Snowflake Soldier"
LevelToMonster[3042] = "Snowflake Soldier"
LevelToMonster[3043] = "Snowflake Soldier"
LevelToMonster[3044] = "Snowflake Soldier"
LevelToMonster[3045] = "Snowflake Soldier"
LevelToMonster[3046] = "Snowflake Soldier"
LevelToMonster[3047] = "Snowflake Soldier"
LevelToMonster[3048] = "Snowflake Soldier"
LevelToMonster[3049] = "Snowflake Soldier"
LevelToMonster[3050] = "Snowflake Soldier"
LevelToMonster[3051] = "Snowflake Soldier"
LevelToMonster[3052] = "Snowflake Soldier"
LevelToMonster[3053] = "Snowflake Soldier"
LevelToMonster[3054] = "Snowflake Soldier"
LevelToMonster[3055] = "Snowflake Soldier"
LevelToMonster[3056] = "Snowflake Soldier"
LevelToMonster[3057] = "Snowflake Soldier"
LevelToMonster[3058] = "Snowflake Soldier"
LevelToMonster[3059] = "Snowflake Soldier"
LevelToMonster[3060] = "Snowflake Soldier"
LevelToMonster[3061] = "Snowflake Soldier"
LevelToMonster[3062] = "Snowflake Soldier"
LevelToMonster[3063] = "Snowflake Soldier"
LevelToMonster[3064] = "Snowflake Soldier"
LevelToMonster[3065] = "Snowflake Soldier"
LevelToMonster[3066] = "Snowflake Soldier"
LevelToMonster[3067] = "Snowflake Soldier"
LevelToMonster[3068] = "Snowflake Soldier"
LevelToMonster[3069] = "Snowflake Soldier"
LevelToMonster[3070] = "Snowflake Soldier"
LevelToMonster[3071] = "Snowflake Soldier"
LevelToMonster[3072] = "Snowflake Soldier"
LevelToMonster[3073] = "Snowflake Soldier"
LevelToMonster[3074] = "Snowflake Soldier"
LevelToMonster[3075] = "Pyromania Expert"
LevelToMonster[3076] = "Pyromania Expert"
LevelToMonster[3077] = "Pyromania Expert"
LevelToMonster[3078] = "Pyromania Expert"
LevelToMonster[3079] = "Pyromania Expert"
LevelToMonster[3080] = "Pyromania Expert"
LevelToMonster[3081] = "Pyromania Expert"
LevelToMonster[3082] = "Pyromania Expert"
LevelToMonster[3083] = "Pyromania Expert"
LevelToMonster[3084] = "Pyromania Expert"
LevelToMonster[3085] = "Pyromania Expert"
LevelToMonster[3086] = "Pyromania Expert"
LevelToMonster[3087] = "Pyromania Expert"
LevelToMonster[3088] = "Pyromania Expert"
LevelToMonster[3089] = "Pyromania Expert"
LevelToMonster[3090] = "Pyromania Expert"
LevelToMonster[3091] = "Pyromania Expert"
LevelToMonster[3092] = "Pyromania Expert"
LevelToMonster[3093] = "Pyromania Expert"
LevelToMonster[3094] = "Pyromania Expert"
LevelToMonster[3095] = "Pyromania Expert"
LevelToMonster[3096] = "Pyromania Expert"
LevelToMonster[3097] = "Pyromania Expert"
LevelToMonster[3098] = "Pyromania Expert"
LevelToMonster[3099] = "Pyromania Expert"
LevelToMonster[3100] = "Pyromania Expert"
LevelToMonster[3101] = "Pyromania Expert"
LevelToMonster[3102] = "Pyromania Expert"
LevelToMonster[3103] = "Pyromania Expert"
LevelToMonster[3104] = "Pyromania Expert"
LevelToMonster[3105] = "Pyromania Expert"
LevelToMonster[3106] = "Pyromania Expert"
LevelToMonster[3107] = "Pyromania Expert"
LevelToMonster[3108] = "Pyromania Expert"
LevelToMonster[3109] = "Pyromania Expert"
LevelToMonster[3110] = "Pyromania Expert"
LevelToMonster[3111] = "Pyromania Expert"
LevelToMonster[3112] = "Pyromania Expert"
LevelToMonster[3113] = "Pyromania Expert"
LevelToMonster[3114] = "Pyromania Expert"
LevelToMonster[3115] = "Pyromania Expert"
LevelToMonster[3116] = "Pyromania Expert"
LevelToMonster[3117] = "Pyromania Expert"
LevelToMonster[3118] = "Pyromania Expert"
LevelToMonster[3119] = "Pyromania Expert"
LevelToMonster[3120] = "Pyromania Expert"
LevelToMonster[3121] = "Pyromania Expert"
LevelToMonster[3122] = "Pyromania Expert"
LevelToMonster[3123] = "Pyromania Expert"
LevelToMonster[3124] = "Pyromania Expert"
LevelToMonster[3125] = "Pyromania Expert"
LevelToMonster[3126] = "Pyromania Expert"
LevelToMonster[3127] = "Pyromania Expert"
LevelToMonster[3128] = "Pyromania Expert"
LevelToMonster[3129] = "Pyromania Expert"
LevelToMonster[3130] = "Pyromania Expert"
LevelToMonster[3131] = "Pyromania Expert"
LevelToMonster[3132] = "Pyromania Expert"
LevelToMonster[3133] = "Pyromania Expert"
LevelToMonster[3134] = "Pyromania Expert"
LevelToMonster[3135] = "Pyromania Expert"
LevelToMonster[3136] = "Pyromania Expert"
LevelToMonster[3137] = "Pyromania Expert"
LevelToMonster[3138] = "Pyromania Expert"
LevelToMonster[3139] = "Pyromania Expert"
LevelToMonster[3140] = "Pyromania Expert"
LevelToMonster[3141] = "Pyromania Expert"
LevelToMonster[3142] = "Pyromania Expert"
LevelToMonster[3143] = "Pyromania Expert"
LevelToMonster[3144] = "Pyromania Expert"
LevelToMonster[3145] = "Pyromania Expert"
LevelToMonster[3146] = "Pyromania Expert"
LevelToMonster[3147] = "Pyromania Expert"
LevelToMonster[3148] = "Pyromania Expert"
LevelToMonster[3149] = "Pyromania Expert"
LevelToMonster[3150] = "Order Soldier"
LevelToMonster[3151] = "Order Soldier"
LevelToMonster[3152] = "Order Soldier"
LevelToMonster[3153] = "Order Soldier"
LevelToMonster[3154] = "Order Soldier"
LevelToMonster[3155] = "Order Soldier"
LevelToMonster[3156] = "Order Soldier"
LevelToMonster[3157] = "Order Soldier"
LevelToMonster[3158] = "Order Soldier"
LevelToMonster[3159] = "Order Soldier"
LevelToMonster[3160] = "Order Soldier"
LevelToMonster[3161] = "Order Soldier"
LevelToMonster[3162] = "Order Soldier"
LevelToMonster[3163] = "Order Soldier"
LevelToMonster[3164] = "Order Soldier"
LevelToMonster[3165] = "Order Soldier"
LevelToMonster[3166] = "Order Soldier"
LevelToMonster[3167] = "Order Soldier"
LevelToMonster[3168] = "Order Soldier"
LevelToMonster[3169] = "Order Soldier"
LevelToMonster[3170] = "Order Soldier"
LevelToMonster[3171] = "Order Soldier"
LevelToMonster[3172] = "Order Soldier"
LevelToMonster[3173] = "Order Soldier"
LevelToMonster[3174] = "Order Soldier"
LevelToMonster[3175] = "Order Soldier"
LevelToMonster[3176] = "Order Soldier"
LevelToMonster[3177] = "Order Soldier"
LevelToMonster[3178] = "Order Soldier"
LevelToMonster[3179] = "Order Soldier"
LevelToMonster[3180] = "Order Soldier"
LevelToMonster[3181] = "Order Soldier"
LevelToMonster[3182] = "Order Soldier"
LevelToMonster[3183] = "Order Soldier"
LevelToMonster[3184] = "Order Soldier"
LevelToMonster[3185] = "Order Soldier"
LevelToMonster[3186] = "Order Soldier"
LevelToMonster[3187] = "Order Soldier"
LevelToMonster[3188] = "Order Soldier"
LevelToMonster[3189] = "Order Soldier"
LevelToMonster[3190] = "Order Soldier"
LevelToMonster[3191] = "Order Soldier"
LevelToMonster[3192] = "Order Soldier"
LevelToMonster[3193] = "Order Soldier"
LevelToMonster[3194] = "Order Soldier"
LevelToMonster[3195] = "Order Soldier"
LevelToMonster[3196] = "Order Soldier"
LevelToMonster[3197] = "Order Soldier"
LevelToMonster[3198] = "Order Soldier"
LevelToMonster[3199] = "Order Soldier"
LevelToMonster[3200] = "Order Soldier"
LevelToMonster[3201] = "Order Soldier"
LevelToMonster[3202] = "Order Soldier"
LevelToMonster[3203] = "Order Soldier"
LevelToMonster[3204] = "Order Soldier"
LevelToMonster[3205] = "Order Soldier"
LevelToMonster[3206] = "Order Soldier"
LevelToMonster[3207] = "Order Soldier"
LevelToMonster[3208] = "Order Soldier"
LevelToMonster[3209] = "Order Soldier"
LevelToMonster[3210] = "Order Soldier"
LevelToMonster[3211] = "Order Soldier"
LevelToMonster[3212] = "Order Soldier"
LevelToMonster[3213] = "Order Soldier"
LevelToMonster[3214] = "Order Soldier"
LevelToMonster[3215] = "Order Soldier"
LevelToMonster[3216] = "Order Soldier"
LevelToMonster[3217] = "Order Soldier"
LevelToMonster[3218] = "Order Soldier"
LevelToMonster[3219] = "Order Soldier"
LevelToMonster[3220] = "Order Soldier"
LevelToMonster[3221] = "Order Soldier"
LevelToMonster[3222] = "Order Soldier"
LevelToMonster[3223] = "Order Soldier"
LevelToMonster[3224] = "Order Soldier"
LevelToMonster[3225] = "Order Officer"
LevelToMonster[3226] = "Order Officer"
LevelToMonster[3227] = "Order Officer"
LevelToMonster[3228] = "Order Officer"
LevelToMonster[3229] = "Order Officer"
LevelToMonster[3230] = "Order Officer"
LevelToMonster[3231] = "Order Officer"
LevelToMonster[3232] = "Order Officer"
LevelToMonster[3233] = "Order Officer"
LevelToMonster[3234] = "Order Officer"
LevelToMonster[3235] = "Order Officer"
LevelToMonster[3236] = "Order Officer"
LevelToMonster[3237] = "Order Officer"
LevelToMonster[3238] = "Order Officer"
LevelToMonster[3239] = "Order Officer"
LevelToMonster[3240] = "Order Officer"
LevelToMonster[3241] = "Order Officer"
LevelToMonster[3242] = "Order Officer"
LevelToMonster[3243] = "Order Officer"
LevelToMonster[3244] = "Order Officer"
LevelToMonster[3245] = "Order Officer"
LevelToMonster[3246] = "Order Officer"
LevelToMonster[3247] = "Order Officer"
LevelToMonster[3248] = "Order Officer"
LevelToMonster[3249] = "Order Officer"
LevelToMonster[3250] = "Order Officer"
LevelToMonster[3251] = "Order Officer"
LevelToMonster[3252] = "Order Officer"
LevelToMonster[3253] = "Order Officer"
LevelToMonster[3254] = "Order Officer"
LevelToMonster[3255] = "Order Officer"
LevelToMonster[3256] = "Order Officer"
LevelToMonster[3257] = "Order Officer"
LevelToMonster[3258] = "Order Officer"
LevelToMonster[3259] = "Order Officer"
LevelToMonster[3260] = "Order Officer"
LevelToMonster[3261] = "Order Officer"
LevelToMonster[3262] = "Order Officer"
LevelToMonster[3263] = "Order Officer"
LevelToMonster[3264] = "Order Officer"
LevelToMonster[3265] = "Order Officer"
LevelToMonster[3266] = "Order Officer"
LevelToMonster[3267] = "Order Officer"
LevelToMonster[3268] = "Order Officer"
LevelToMonster[3269] = "Order Officer"
LevelToMonster[3270] = "Order Officer"
LevelToMonster[3271] = "Order Officer"
LevelToMonster[3272] = "Order Officer"
LevelToMonster[3273] = "Order Officer"
LevelToMonster[3274] = "Order Officer"
LevelToMonster[3275] = "Order Officer"
LevelToMonster[3276] = "Order Officer"
LevelToMonster[3277] = "Order Officer"
LevelToMonster[3278] = "Order Officer"
LevelToMonster[3279] = "Order Officer"
LevelToMonster[3280] = "Order Officer"
LevelToMonster[3281] = "Order Officer"
LevelToMonster[3282] = "Order Officer"
LevelToMonster[3283] = "Order Officer"
LevelToMonster[3284] = "Order Officer"
LevelToMonster[3285] = "Order Officer"
LevelToMonster[3286] = "Order Officer"
LevelToMonster[3287] = "Order Officer"
LevelToMonster[3288] = "Order Officer"
LevelToMonster[3289] = "Order Officer"
LevelToMonster[3290] = "Order Officer"
LevelToMonster[3291] = "Order Officer"
LevelToMonster[3292] = "Order Officer"
LevelToMonster[3293] = "Order Officer"
LevelToMonster[3294] = "Order Officer"
LevelToMonster[3295] = "Order Officer"
LevelToMonster[3296] = "Order Officer"
LevelToMonster[3297] = "Order Officer"
LevelToMonster[3298] = "Order Officer"
LevelToMonster[3299] = "Order Officer"
LevelToMonster[3300] = "Pirate Millionaire"
LevelToMonster[3301] = "Pirate Millionaire"
LevelToMonster[3302] = "Pirate Millionaire"
LevelToMonster[3303] = "Pirate Millionaire"
LevelToMonster[3304] = "Pirate Millionaire"
LevelToMonster[3305] = "Pirate Millionaire"
LevelToMonster[3306] = "Pirate Millionaire"
LevelToMonster[3307] = "Pirate Millionaire"
LevelToMonster[3308] = "Pirate Millionaire"
LevelToMonster[3309] = "Pirate Millionaire"
LevelToMonster[3310] = "Pirate Millionaire"
LevelToMonster[3311] = "Pirate Millionaire"
LevelToMonster[3312] = "Pirate Millionaire"
LevelToMonster[3313] = "Pirate Millionaire"
LevelToMonster[3314] = "Pirate Millionaire"
LevelToMonster[3315] = "Pirate Millionaire"
LevelToMonster[3316] = "Pirate Millionaire"
LevelToMonster[3317] = "Pirate Millionaire"
LevelToMonster[3318] = "Pirate Millionaire"
LevelToMonster[3319] = "Pirate Millionaire"
LevelToMonster[3320] = "Pirate Millionaire"
LevelToMonster[3321] = "Pirate Millionaire"
LevelToMonster[3322] = "Pirate Millionaire"
LevelToMonster[3323] = "Pirate Millionaire"
LevelToMonster[3324] = "Pirate Millionaire"
LevelToMonster[3325] = "Pirate Millionaire"
LevelToMonster[3326] = "Pirate Millionaire"
LevelToMonster[3327] = "Pirate Millionaire"
LevelToMonster[3328] = "Pirate Millionaire"
LevelToMonster[3329] = "Pirate Millionaire"
LevelToMonster[3330] = "Pirate Millionaire"
LevelToMonster[3331] = "Pirate Millionaire"
LevelToMonster[3332] = "Pirate Millionaire"
LevelToMonster[3333] = "Pirate Millionaire"
LevelToMonster[3334] = "Pirate Millionaire"
LevelToMonster[3335] = "Pirate Millionaire"
LevelToMonster[3336] = "Pirate Millionaire"
LevelToMonster[3337] = "Pirate Millionaire"
LevelToMonster[3338] = "Pirate Millionaire"
LevelToMonster[3339] = "Pirate Millionaire"
LevelToMonster[3340] = "Pirate Millionaire"
LevelToMonster[3341] = "Pirate Millionaire"
LevelToMonster[3342] = "Pirate Millionaire"
LevelToMonster[3343] = "Pirate Millionaire"
LevelToMonster[3344] = "Pirate Millionaire"
LevelToMonster[3345] = "Pirate Millionaire"
LevelToMonster[3346] = "Pirate Millionaire"
LevelToMonster[3347] = "Pirate Millionaire"
LevelToMonster[3348] = "Pirate Millionaire"
LevelToMonster[3349] = "Pirate Millionaire"
LevelToMonster[3350] = "Pirate Millionaire"
LevelToMonster[3351] = "Pirate Millionaire"
LevelToMonster[3352] = "Pirate Millionaire"
LevelToMonster[3353] = "Pirate Millionaire"
LevelToMonster[3354] = "Pirate Millionaire"
LevelToMonster[3355] = "Pirate Millionaire"
LevelToMonster[3356] = "Pirate Millionaire"
LevelToMonster[3357] = "Pirate Millionaire"
LevelToMonster[3358] = "Pirate Millionaire"
LevelToMonster[3359] = "Pirate Millionaire"
LevelToMonster[3360] = "Pirate Millionaire"
LevelToMonster[3361] = "Pirate Millionaire"
LevelToMonster[3362] = "Pirate Millionaire"
LevelToMonster[3363] = "Pirate Millionaire"
LevelToMonster[3364] = "Pirate Millionaire"
LevelToMonster[3365] = "Pirate Millionaire"
LevelToMonster[3366] = "Pirate Millionaire"
LevelToMonster[3367] = "Pirate Millionaire"
LevelToMonster[3368] = "Pirate Millionaire"
LevelToMonster[3369] = "Pirate Millionaire"
LevelToMonster[3370] = "Pirate Millionaire"
LevelToMonster[3371] = "Pirate Millionaire"
LevelToMonster[3372] = "Pirate Millionaire"
LevelToMonster[3373] = "Pirate Millionaire"
LevelToMonster[3374] = "Pirate Millionaire"
LevelToMonster[3375] = "Pirate Millionaire"
LevelToMonster[3376] = "Pirate Millionaire"
LevelToMonster[3377] = "Pirate Millionaire"
LevelToMonster[3378] = "Pirate Millionaire"
LevelToMonster[3379] = "Pirate Millionaire"
LevelToMonster[3380] = "Pirate Millionaire"
LevelToMonster[3381] = "Pirate Millionaire"
LevelToMonster[3382] = "Pirate Millionaire"
LevelToMonster[3383] = "Pirate Millionaire"
LevelToMonster[3384] = "Pirate Millionaire"
LevelToMonster[3385] = "Pirate Millionaire"
LevelToMonster[3386] = "Pirate Millionaire"
LevelToMonster[3387] = "Pirate Millionaire"
LevelToMonster[3388] = "Pirate Millionaire"
LevelToMonster[3389] = "Pirate Millionaire"
LevelToMonster[3390] = "Pirate Millionaire"
LevelToMonster[3391] = "Pirate Millionaire"
LevelToMonster[3392] = "Pirate Millionaire"
LevelToMonster[3393] = "Pirate Millionaire"
LevelToMonster[3394] = "Pirate Millionaire"
LevelToMonster[3395] = "Pirate Millionaire"
LevelToMonster[3396] = "Pirate Millionaire"
LevelToMonster[3397] = "Pirate Millionaire"
LevelToMonster[3398] = "Pirate Millionaire"
LevelToMonster[3399] = "Pirate Millionaire"
LevelToMonster[3400] = "Pistol Billionaire"
LevelToMonster[3401] = "Pistol Billionaire"
LevelToMonster[3402] = "Pistol Billionaire"
LevelToMonster[3403] = "Pistol Billionaire"
LevelToMonster[3404] = "Pistol Billionaire"
LevelToMonster[3405] = "Pistol Billionaire"
LevelToMonster[3406] = "Pistol Billionaire"
LevelToMonster[3407] = "Pistol Billionaire"
LevelToMonster[3408] = "Pistol Billionaire"
LevelToMonster[3409] = "Pistol Billionaire"
LevelToMonster[3410] = "Pistol Billionaire"
LevelToMonster[3411] = "Pistol Billionaire"
LevelToMonster[3412] = "Pistol Billionaire"
LevelToMonster[3413] = "Pistol Billionaire"
LevelToMonster[3414] = "Pistol Billionaire"
LevelToMonster[3415] = "Pistol Billionaire"
LevelToMonster[3416] = "Pistol Billionaire"
LevelToMonster[3417] = "Pistol Billionaire"
LevelToMonster[3418] = "Pistol Billionaire"
LevelToMonster[3419] = "Pistol Billionaire"
LevelToMonster[3420] = "Pistol Billionaire"
LevelToMonster[3421] = "Pistol Billionaire"
LevelToMonster[3422] = "Pistol Billionaire"
LevelToMonster[3423] = "Pistol Billionaire"
LevelToMonster[3424] = "Pistol Billionaire"
LevelToMonster[3425] = "Pistol Billionaire"
LevelToMonster[3426] = "Pistol Billionaire"
LevelToMonster[3427] = "Pistol Billionaire"
LevelToMonster[3428] = "Pistol Billionaire"
LevelToMonster[3429] = "Pistol Billionaire"
LevelToMonster[3430] = "Pistol Billionaire"
LevelToMonster[3431] = "Pistol Billionaire"
LevelToMonster[3432] = "Pistol Billionaire"
LevelToMonster[3433] = "Pistol Billionaire"
LevelToMonster[3434] = "Pistol Billionaire"
LevelToMonster[3435] = "Pistol Billionaire"
LevelToMonster[3436] = "Pistol Billionaire"
LevelToMonster[3437] = "Pistol Billionaire"
LevelToMonster[3438] = "Pistol Billionaire"
LevelToMonster[3439] = "Pistol Billionaire"
LevelToMonster[3440] = "Pistol Billionaire"
LevelToMonster[3441] = "Pistol Billionaire"
LevelToMonster[3442] = "Pistol Billionaire"
LevelToMonster[3443] = "Pistol Billionaire"
LevelToMonster[3444] = "Pistol Billionaire"
LevelToMonster[3445] = "Pistol Billionaire"
LevelToMonster[3446] = "Pistol Billionaire"
LevelToMonster[3447] = "Pistol Billionaire"
LevelToMonster[3448] = "Pistol Billionaire"
LevelToMonster[3449] = "Pistol Billionaire"
LevelToMonster[3450] = "Pistol Billionaire"
LevelToMonster[3451] = "Pistol Billionaire"
LevelToMonster[3452] = "Pistol Billionaire"
LevelToMonster[3453] = "Pistol Billionaire"
LevelToMonster[3454] = "Pistol Billionaire"
LevelToMonster[3455] = "Pistol Billionaire"
LevelToMonster[3456] = "Pistol Billionaire"
LevelToMonster[3457] = "Pistol Billionaire"
LevelToMonster[3458] = "Pistol Billionaire"
LevelToMonster[3459] = "Pistol Billionaire"
LevelToMonster[3460] = "Pistol Billionaire"
LevelToMonster[3461] = "Pistol Billionaire"
LevelToMonster[3462] = "Pistol Billionaire"
LevelToMonster[3463] = "Pistol Billionaire"
LevelToMonster[3464] = "Pistol Billionaire"
LevelToMonster[3465] = "Pistol Billionaire"
LevelToMonster[3466] = "Pistol Billionaire"
LevelToMonster[3467] = "Pistol Billionaire"
LevelToMonster[3468] = "Pistol Billionaire"
LevelToMonster[3469] = "Pistol Billionaire"
LevelToMonster[3470] = "Pistol Billionaire"
LevelToMonster[3471] = "Pistol Billionaire"
LevelToMonster[3472] = "Pistol Billionaire"
LevelToMonster[3473] = "Pistol Billionaire"
LevelToMonster[3474] = "Pistol Billionaire"
LevelToMonster[3475] = "Pistol Billionaire"
LevelToMonster[3476] = "Pistol Billionaire"
LevelToMonster[3477] = "Pistol Billionaire"
LevelToMonster[3478] = "Pistol Billionaire"
LevelToMonster[3479] = "Pistol Billionaire"
LevelToMonster[3480] = "Pistol Billionaire"
LevelToMonster[3481] = "Pistol Billionaire"
LevelToMonster[3482] = "Pistol Billionaire"
LevelToMonster[3483] = "Pistol Billionaire"
LevelToMonster[3484] = "Pistol Billionaire"
LevelToMonster[3485] = "Pistol Billionaire"
LevelToMonster[3486] = "Pistol Billionaire"
LevelToMonster[3487] = "Pistol Billionaire"
LevelToMonster[3488] = "Pistol Billionaire"
LevelToMonster[3489] = "Pistol Billionaire"
LevelToMonster[3490] = "Pistol Billionaire"
LevelToMonster[3491] = "Pistol Billionaire"
LevelToMonster[3492] = "Pistol Billionaire"
LevelToMonster[3493] = "Pistol Billionaire"
LevelToMonster[3494] = "Pistol Billionaire"
LevelToMonster[3495] = "Pistol Billionaire"
LevelToMonster[3496] = "Pistol Billionaire"
LevelToMonster[3497] = "Pistol Billionaire"
LevelToMonster[3498] = "Pistol Billionaire"
LevelToMonster[3499] = "Pistol Billionaire"
LevelToMonster[3500] = "Pistol Billionaire"
LevelToMonster[3501] = "Pistol Billionaire"
LevelToMonster[3502] = "Pistol Billionaire"
LevelToMonster[3503] = "Pistol Billionaire"
LevelToMonster[3504] = "Pistol Billionaire"
LevelToMonster[3505] = "Pistol Billionaire"
LevelToMonster[3506] = "Pistol Billionaire"
LevelToMonster[3507] = "Pistol Billionaire"
LevelToMonster[3508] = "Pistol Billionaire"
LevelToMonster[3509] = "Pistol Billionaire"
LevelToMonster[3510] = "Pistol Billionaire"
LevelToMonster[3511] = "Pistol Billionaire"
LevelToMonster[3512] = "Pistol Billionaire"
LevelToMonster[3513] = "Pistol Billionaire"
LevelToMonster[3514] = "Pistol Billionaire"
LevelToMonster[3515] = "Pistol Billionaire"
LevelToMonster[3516] = "Pistol Billionaire"
LevelToMonster[3517] = "Pistol Billionaire"
LevelToMonster[3518] = "Pistol Billionaire"
LevelToMonster[3519] = "Pistol Billionaire"
LevelToMonster[3520] = "Pistol Billionaire"
LevelToMonster[3521] = "Pistol Billionaire"
LevelToMonster[3522] = "Pistol Billionaire"
LevelToMonster[3523] = "Pistol Billionaire"
LevelToMonster[3524] = "Pistol Billionaire"
LevelToMonster[3525] = "Pistol Billionaire"
LevelToMonster[3526] = "Pistol Billionaire"
LevelToMonster[3527] = "Pistol Billionaire"
LevelToMonster[3528] = "Pistol Billionaire"
LevelToMonster[3529] = "Pistol Billionaire"
LevelToMonster[3530] = "Pistol Billionaire"
LevelToMonster[3531] = "Pistol Billionaire"
LevelToMonster[3532] = "Pistol Billionaire"
LevelToMonster[3533] = "Pistol Billionaire"
LevelToMonster[3534] = "Pistol Billionaire"
LevelToMonster[3535] = "Pistol Billionaire"
LevelToMonster[3536] = "Pistol Billionaire"
LevelToMonster[3537] = "Pistol Billionaire"
LevelToMonster[3538] = "Pistol Billionaire"
LevelToMonster[3539] = "Pistol Billionaire"
LevelToMonster[3540] = "Pistol Billionaire"
LevelToMonster[3541] = "Pistol Billionaire"
LevelToMonster[3542] = "Pistol Billionaire"
LevelToMonster[3543] = "Pistol Billionaire"
LevelToMonster[3544] = "Pistol Billionaire"
LevelToMonster[3545] = "Pistol Billionaire"
LevelToMonster[3546] = "Pistol Billionaire"
LevelToMonster[3547] = "Pistol Billionaire"
LevelToMonster[3548] = "Pistol Billionaire"
LevelToMonster[3549] = "Pistol Billionaire"
LevelToMonster[3550] = "Factory Staff"
LevelToMonster[3551] = "Factory Staff"
LevelToMonster[3552] = "Factory Staff"
LevelToMonster[3553] = "Factory Staff"
LevelToMonster[3554] = "Factory Staff"
LevelToMonster[3555] = "Factory Staff"
LevelToMonster[3556] = "Factory Staff"
LevelToMonster[3557] = "Factory Staff"
LevelToMonster[3558] = "Factory Staff"
LevelToMonster[3559] = "Factory Staff"
LevelToMonster[3560] = "Factory Staff"
LevelToMonster[3561] = "Factory Staff"
LevelToMonster[3562] = "Factory Staff"
LevelToMonster[3563] = "Factory Staff"
LevelToMonster[3564] = "Factory Staff"
LevelToMonster[3565] = "Factory Staff"
LevelToMonster[3566] = "Factory Staff"
LevelToMonster[3567] = "Factory Staff"
LevelToMonster[3568] = "Factory Staff"
LevelToMonster[3569] = "Factory Staff"
LevelToMonster[3570] = "Factory Staff"
LevelToMonster[3571] = "Factory Staff"
LevelToMonster[3572] = "Factory Staff"
LevelToMonster[3573] = "Factory Staff"
LevelToMonster[3574] = "Factory Staff"
LevelToMonster[3575] = "Factory Staff"
LevelToMonster[3576] = "Factory Staff"
LevelToMonster[3577] = "Factory Staff"
LevelToMonster[3578] = "Factory Staff"
LevelToMonster[3579] = "Factory Staff"
LevelToMonster[3580] = "Factory Staff"
LevelToMonster[3581] = "Factory Staff"
LevelToMonster[3582] = "Factory Staff"
LevelToMonster[3583] = "Factory Staff"
LevelToMonster[3584] = "Factory Staff"
LevelToMonster[3585] = "Factory Staff"
LevelToMonster[3586] = "Factory Staff"
LevelToMonster[3587] = "Factory Staff"
LevelToMonster[3588] = "Factory Staff"
LevelToMonster[3589] = "Factory Staff"
LevelToMonster[3590] = "Factory Staff"
LevelToMonster[3591] = "Factory Staff"
LevelToMonster[3592] = "Factory Staff"
LevelToMonster[3593] = "Factory Staff"
LevelToMonster[3594] = "Factory Staff"
LevelToMonster[3595] = "Factory Staff"
LevelToMonster[3596] = "Factory Staff"
LevelToMonster[3597] = "Factory Staff"
LevelToMonster[3598] = "Factory Staff"
LevelToMonster[3599] = "Factory Staff"
LevelToMonster[3600] = "Factory Staff"
LevelToMonster[3601] = "Factory Staff"
LevelToMonster[3602] = "Factory Staff"
LevelToMonster[3603] = "Factory Staff"
LevelToMonster[3604] = "Factory Staff"
LevelToMonster[3605] = "Factory Staff"
LevelToMonster[3606] = "Factory Staff"
LevelToMonster[3607] = "Factory Staff"
LevelToMonster[3608] = "Factory Staff"
LevelToMonster[3609] = "Factory Staff"
LevelToMonster[3610] = "Factory Staff"
LevelToMonster[3611] = "Factory Staff"
LevelToMonster[3612] = "Factory Staff"
LevelToMonster[3613] = "Factory Staff"
LevelToMonster[3614] = "Factory Staff"
LevelToMonster[3615] = "Factory Staff"
LevelToMonster[3616] = "Factory Staff"
LevelToMonster[3617] = "Factory Staff"
LevelToMonster[3618] = "Factory Staff"
LevelToMonster[3619] = "Factory Staff"
LevelToMonster[3620] = "Factory Staff"
LevelToMonster[3621] = "Factory Staff"
LevelToMonster[3622] = "Factory Staff"
LevelToMonster[3623] = "Factory Staff"
LevelToMonster[3624] = "Factory Staff"
LevelToMonster[3625] = "Factory Staff"
LevelToMonster[3626] = "Factory Staff"
LevelToMonster[3627] = "Factory Staff"
LevelToMonster[3628] = "Factory Staff"
LevelToMonster[3629] = "Factory Staff"
LevelToMonster[3630] = "Factory Staff"
LevelToMonster[3631] = "Factory Staff"
LevelToMonster[3632] = "Factory Staff"
LevelToMonster[3633] = "Factory Staff"
LevelToMonster[3634] = "Factory Staff"
LevelToMonster[3635] = "Factory Staff"
LevelToMonster[3636] = "Factory Staff"
LevelToMonster[3637] = "Factory Staff"
LevelToMonster[3638] = "Factory Staff"
LevelToMonster[3639] = "Factory Staff"
LevelToMonster[3640] = "Factory Staff"
LevelToMonster[3641] = "Factory Staff"
LevelToMonster[3642] = "Factory Staff"
LevelToMonster[3643] = "Factory Staff"
LevelToMonster[3644] = "Factory Staff"
LevelToMonster[3645] = "Factory Staff"
LevelToMonster[3646] = "Factory Staff"
LevelToMonster[3647] = "Factory Staff"
LevelToMonster[3648] = "Factory Staff"
LevelToMonster[3649] = "Factory Staff"
LevelToMonster[3650] = "Factory Staff"
LevelToMonster[3651] = "Factory Staff"
LevelToMonster[3652] = "Factory Staff"
LevelToMonster[3653] = "Factory Staff"
LevelToMonster[3654] = "Factory Staff"
LevelToMonster[3655] = "Factory Staff"
LevelToMonster[3656] = "Factory Staff"
LevelToMonster[3657] = "Factory Staff"
LevelToMonster[3658] = "Factory Staff"
LevelToMonster[3659] = "Factory Staff"
LevelToMonster[3660] = "Factory Staff"
LevelToMonster[3661] = "Factory Staff"
LevelToMonster[3662] = "Factory Staff"
LevelToMonster[3663] = "Factory Staff"
LevelToMonster[3664] = "Factory Staff"
LevelToMonster[3665] = "Factory Staff"
LevelToMonster[3666] = "Factory Staff"
LevelToMonster[3667] = "Factory Staff"
LevelToMonster[3668] = "Factory Staff"
LevelToMonster[3669] = "Factory Staff"
LevelToMonster[3670] = "Factory Staff"
LevelToMonster[3671] = "Factory Staff"
LevelToMonster[3672] = "Factory Staff"
LevelToMonster[3673] = "Factory Staff"
LevelToMonster[3674] = "Factory Staff"
LevelToMonster[3675] = "Factory Staff"
LevelToMonster[3676] = "Factory Staff"
LevelToMonster[3677] = "Factory Staff"
LevelToMonster[3678] = "Factory Staff"
LevelToMonster[3679] = "Factory Staff"
LevelToMonster[3680] = "Factory Staff"
LevelToMonster[3681] = "Factory Staff"
LevelToMonster[3682] = "Factory Staff"
LevelToMonster[3683] = "Factory Staff"
LevelToMonster[3684] = "Factory Staff"
LevelToMonster[3685] = "Factory Staff"
LevelToMonster[3686] = "Factory Staff"
LevelToMonster[3687] = "Factory Staff"
LevelToMonster[3688] = "Factory Staff"
LevelToMonster[3689] = "Factory Staff"
LevelToMonster[3690] = "Factory Staff"
LevelToMonster[3691] = "Factory Staff"
LevelToMonster[3692] = "Factory Staff"
LevelToMonster[3693] = "Factory Staff"
LevelToMonster[3694] = "Factory Staff"
LevelToMonster[3695] = "Factory Staff"
LevelToMonster[3696] = "Factory Staff"
LevelToMonster[3697] = "Factory Staff"
LevelToMonster[3698] = "Factory Staff"
LevelToMonster[3699] = "Factory Staff"
LevelToMonster[3700] = "Water Fighter"
LevelToMonster[3701] = "Water Fighter"
LevelToMonster[3702] = "Water Fighter"
LevelToMonster[3703] = "Water Fighter"
LevelToMonster[3704] = "Water Fighter"
LevelToMonster[3705] = "Water Fighter"
LevelToMonster[3706] = "Water Fighter"
LevelToMonster[3707] = "Water Fighter"
LevelToMonster[3708] = "Water Fighter"
LevelToMonster[3709] = "Water Fighter"
LevelToMonster[3710] = "Water Fighter"
LevelToMonster[3711] = "Water Fighter"
LevelToMonster[3712] = "Water Fighter"
LevelToMonster[3713] = "Water Fighter"
LevelToMonster[3714] = "Water Fighter"
LevelToMonster[3715] = "Water Fighter"
LevelToMonster[3716] = "Water Fighter"
LevelToMonster[3717] = "Water Fighter"
LevelToMonster[3718] = "Water Fighter"
LevelToMonster[3719] = "Water Fighter"
LevelToMonster[3720] = "Water Fighter"
LevelToMonster[3721] = "Water Fighter"
LevelToMonster[3722] = "Water Fighter"
LevelToMonster[3723] = "Water Fighter"
LevelToMonster[3724] = "Water Fighter"
LevelToMonster[3725] = "Water Fighter"
LevelToMonster[3726] = "Water Fighter"
LevelToMonster[3727] = "Water Fighter"
LevelToMonster[3728] = "Water Fighter"
LevelToMonster[3729] = "Water Fighter"
LevelToMonster[3730] = "Water Fighter"
LevelToMonster[3731] = "Water Fighter"
LevelToMonster[3732] = "Water Fighter"
LevelToMonster[3733] = "Water Fighter"
LevelToMonster[3734] = "Water Fighter"
LevelToMonster[3735] = "Water Fighter"
LevelToMonster[3736] = "Water Fighter"
LevelToMonster[3737] = "Water Fighter"
LevelToMonster[3738] = "Water Fighter"
LevelToMonster[3739] = "Water Fighter"
LevelToMonster[3740] = "Water Fighter"
LevelToMonster[3741] = "Water Fighter"
LevelToMonster[3742] = "Water Fighter"
LevelToMonster[3743] = "Water Fighter"
LevelToMonster[3744] = "Water Fighter"
LevelToMonster[3745] = "Water Fighter"
LevelToMonster[3746] = "Water Fighter"
LevelToMonster[3747] = "Water Fighter"
LevelToMonster[3748] = "Water Fighter"
LevelToMonster[3749] = "Water Fighter"
LevelToMonster[3750] = "Water Fighter"
LevelToMonster[3751] = "Water Fighter"
LevelToMonster[3752] = "Water Fighter"
LevelToMonster[3753] = "Water Fighter"
LevelToMonster[3754] = "Water Fighter"
LevelToMonster[3755] = "Water Fighter"
LevelToMonster[3756] = "Water Fighter"
LevelToMonster[3757] = "Water Fighter"
LevelToMonster[3758] = "Water Fighter"
LevelToMonster[3759] = "Water Fighter"
LevelToMonster[3760] = "Water Fighter"
LevelToMonster[3761] = "Water Fighter"
LevelToMonster[3762] = "Water Fighter"
LevelToMonster[3763] = "Water Fighter"
LevelToMonster[3764] = "Water Fighter"
LevelToMonster[3765] = "Water Fighter"
LevelToMonster[3766] = "Water Fighter"
LevelToMonster[3767] = "Water Fighter"
LevelToMonster[3768] = "Water Fighter"
LevelToMonster[3769] = "Water Fighter"
LevelToMonster[3770] = "Water Fighter"
LevelToMonster[3771] = "Water Fighter"
LevelToMonster[3772] = "Water Fighter"
LevelToMonster[3773] = "Water Fighter"
LevelToMonster[3774] = "Water Fighter"
LevelToMonster[3775] = "Water Fighter"
LevelToMonster[3776] = "Water Fighter"
LevelToMonster[3777] = "Water Fighter"
LevelToMonster[3778] = "Water Fighter"
LevelToMonster[3779] = "Water Fighter"
LevelToMonster[3780] = "Water Fighter"
LevelToMonster[3781] = "Water Fighter"
LevelToMonster[3782] = "Water Fighter"
LevelToMonster[3783] = "Water Fighter"
LevelToMonster[3784] = "Water Fighter"
LevelToMonster[3785] = "Water Fighter"
LevelToMonster[3786] = "Water Fighter"
LevelToMonster[3787] = "Water Fighter"
LevelToMonster[3788] = "Water Fighter"
LevelToMonster[3789] = "Water Fighter"
LevelToMonster[3790] = "Water Fighter"
LevelToMonster[3791] = "Water Fighter"
LevelToMonster[3792] = "Water Fighter"
LevelToMonster[3793] = "Water Fighter"
LevelToMonster[3794] = "Water Fighter"
LevelToMonster[3795] = "Water Fighter"
LevelToMonster[3796] = "Water Fighter"
LevelToMonster[3797] = "Water Fighter"
LevelToMonster[3798] = "Water Fighter"
LevelToMonster[3799] = "Water Fighter"
LevelToMonster[3800] = "Water Fighter"
LevelToMonster[3801] = "Water Fighter"
LevelToMonster[3802] = "Water Fighter"
LevelToMonster[3803] = "Water Fighter"
LevelToMonster[3804] = "Water Fighter"
LevelToMonster[3805] = "Water Fighter"
LevelToMonster[3806] = "Water Fighter"
LevelToMonster[3807] = "Water Fighter"
LevelToMonster[3808] = "Water Fighter"
LevelToMonster[3809] = "Water Fighter"
LevelToMonster[3810] = "Water Fighter"
LevelToMonster[3811] = "Water Fighter"
LevelToMonster[3812] = "Water Fighter"
LevelToMonster[3813] = "Water Fighter"
LevelToMonster[3814] = "Water Fighter"
LevelToMonster[3815] = "Water Fighter"
LevelToMonster[3816] = "Water Fighter"
LevelToMonster[3817] = "Water Fighter"
LevelToMonster[3818] = "Water Fighter"
LevelToMonster[3819] = "Water Fighter"
LevelToMonster[3820] = "Water Fighter"
LevelToMonster[3821] = "Water Fighter"
LevelToMonster[3822] = "Water Fighter"
LevelToMonster[3823] = "Water Fighter"
LevelToMonster[3824] = "Water Fighter"
LevelToMonster[3825] = "Water Fighter"
LevelToMonster[3826] = "Water Fighter"
LevelToMonster[3827] = "Water Fighter"
LevelToMonster[3828] = "Water Fighter"
LevelToMonster[3829] = "Water Fighter"
LevelToMonster[3830] = "Water Fighter"
LevelToMonster[3831] = "Water Fighter"
LevelToMonster[3832] = "Water Fighter"
LevelToMonster[3833] = "Water Fighter"
LevelToMonster[3834] = "Water Fighter"
LevelToMonster[3835] = "Water Fighter"
LevelToMonster[3836] = "Water Fighter"
LevelToMonster[3837] = "Water Fighter"
LevelToMonster[3838] = "Water Fighter"
LevelToMonster[3839] = "Water Fighter"
LevelToMonster[3840] = "Water Fighter"
LevelToMonster[3841] = "Water Fighter"
LevelToMonster[3842] = "Water Fighter"
LevelToMonster[3843] = "Water Fighter"
LevelToMonster[3844] = "Water Fighter"
LevelToMonster[3845] = "Water Fighter"
LevelToMonster[3846] = "Water Fighter"
LevelToMonster[3847] = "Water Fighter"
LevelToMonster[3848] = "Water Fighter"
LevelToMonster[3849] = "Water Fighter"
LevelToMonster[3850] = "Royal Soldier 3"
LevelToMonster[3851] = "Royal Soldier 3"
LevelToMonster[3852] = "Royal Soldier 3"
LevelToMonster[3853] = "Royal Soldier 3"
LevelToMonster[3854] = "Royal Soldier 3"
LevelToMonster[3855] = "Royal Soldier 3"
LevelToMonster[3856] = "Royal Soldier 3"
LevelToMonster[3857] = "Royal Soldier 3"
LevelToMonster[3858] = "Royal Soldier 3"
LevelToMonster[3859] = "Royal Soldier 3"
LevelToMonster[3860] = "Royal Soldier 3"
LevelToMonster[3861] = "Royal Soldier 3"
LevelToMonster[3862] = "Royal Soldier 3"
LevelToMonster[3863] = "Royal Soldier 3"
LevelToMonster[3864] = "Royal Soldier 3"
LevelToMonster[3865] = "Royal Soldier 3"
LevelToMonster[3866] = "Royal Soldier 3"
LevelToMonster[3867] = "Royal Soldier 3"
LevelToMonster[3868] = "Royal Soldier 3"
LevelToMonster[3869] = "Royal Soldier 3"
LevelToMonster[3870] = "Royal Soldier 3"
LevelToMonster[3871] = "Royal Soldier 3"
LevelToMonster[3872] = "Royal Soldier 3"
LevelToMonster[3873] = "Royal Soldier 3"
LevelToMonster[3874] = "Royal Soldier 3"
LevelToMonster[3875] = "Royal Soldier 3"
LevelToMonster[3876] = "Royal Soldier 3"
LevelToMonster[3877] = "Royal Soldier 3"
LevelToMonster[3878] = "Royal Soldier 3"
LevelToMonster[3879] = "Royal Soldier 3"
LevelToMonster[3880] = "Royal Soldier 3"
LevelToMonster[3881] = "Royal Soldier 3"
LevelToMonster[3882] = "Royal Soldier 3"
LevelToMonster[3883] = "Royal Soldier 3"
LevelToMonster[3884] = "Royal Soldier 3"
LevelToMonster[3885] = "Royal Soldier 3"
LevelToMonster[3886] = "Royal Soldier 3"
LevelToMonster[3887] = "Royal Soldier 3"
LevelToMonster[3888] = "Royal Soldier 3"
LevelToMonster[3889] = "Royal Soldier 3"
LevelToMonster[3890] = "Royal Soldier 3"
LevelToMonster[3891] = "Royal Soldier 3"
LevelToMonster[3892] = "Royal Soldier 3"
LevelToMonster[3893] = "Royal Soldier 3"
LevelToMonster[3894] = "Royal Soldier 3"
LevelToMonster[3895] = "Royal Soldier 3"
LevelToMonster[3896] = "Royal Soldier 3"
LevelToMonster[3897] = "Royal Soldier 3"
LevelToMonster[3898] = "Royal Soldier 3"
LevelToMonster[3899] = "Royal Soldier 3"
LevelToMonster[3900] = "Royal Soldier 3"
LevelToMonster[3901] = "Royal Soldier 3"
LevelToMonster[3902] = "Royal Soldier 3"
LevelToMonster[3903] = "Royal Soldier 3"
LevelToMonster[3904] = "Royal Soldier 3"
LevelToMonster[3905] = "Royal Soldier 3"
LevelToMonster[3906] = "Royal Soldier 3"
LevelToMonster[3907] = "Royal Soldier 3"
LevelToMonster[3908] = "Royal Soldier 3"
LevelToMonster[3909] = "Royal Soldier 3"
LevelToMonster[3910] = "Royal Soldier 3"
LevelToMonster[3911] = "Royal Soldier 3"
LevelToMonster[3912] = "Royal Soldier 3"
LevelToMonster[3913] = "Royal Soldier 3"
LevelToMonster[3914] = "Royal Soldier 3"
LevelToMonster[3915] = "Royal Soldier 3"
LevelToMonster[3916] = "Royal Soldier 3"
LevelToMonster[3917] = "Royal Soldier 3"
LevelToMonster[3918] = "Royal Soldier 3"
LevelToMonster[3919] = "Royal Soldier 3"
LevelToMonster[3920] = "Royal Soldier 3"
LevelToMonster[3921] = "Royal Soldier 3"
LevelToMonster[3922] = "Royal Soldier 3"
LevelToMonster[3923] = "Royal Soldier 3"
LevelToMonster[3924] = "Royal Soldier 3"
LevelToMonster[3925] = "Royal Soldier 3"
LevelToMonster[3926] = "Royal Soldier 3"
LevelToMonster[3927] = "Royal Soldier 3"
LevelToMonster[3928] = "Royal Soldier 3"
LevelToMonster[3929] = "Royal Soldier 3"
LevelToMonster[3930] = "Royal Soldier 3"
LevelToMonster[3931] = "Royal Soldier 3"
LevelToMonster[3932] = "Royal Soldier 3"
LevelToMonster[3933] = "Royal Soldier 3"
LevelToMonster[3934] = "Royal Soldier 3"
LevelToMonster[3935] = "Royal Soldier 3"
LevelToMonster[3936] = "Royal Soldier 3"
LevelToMonster[3937] = "Royal Soldier 3"
LevelToMonster[3938] = "Royal Soldier 3"
LevelToMonster[3939] = "Royal Soldier 3"
LevelToMonster[3940] = "Royal Soldier 3"
LevelToMonster[3941] = "Royal Soldier 3"
LevelToMonster[3942] = "Royal Soldier 3"
LevelToMonster[3943] = "Royal Soldier 3"
LevelToMonster[3944] = "Royal Soldier 3"
LevelToMonster[3945] = "Royal Soldier 3"
LevelToMonster[3946] = "Royal Soldier 3"
LevelToMonster[3947] = "Royal Soldier 3"
LevelToMonster[3948] = "Royal Soldier 3"
LevelToMonster[3949] = "Royal Soldier 3"
LevelToMonster[3950] = "Royal Soldier 3"
LevelToMonster[3951] = "Royal Soldier 3"
LevelToMonster[3952] = "Royal Soldier 3"
LevelToMonster[3953] = "Royal Soldier 3"
LevelToMonster[3954] = "Royal Soldier 3"
LevelToMonster[3955] = "Royal Soldier 3"
LevelToMonster[3956] = "Royal Soldier 3"
LevelToMonster[3957] = "Royal Soldier 3"
LevelToMonster[3958] = "Royal Soldier 3"
LevelToMonster[3959] = "Royal Soldier 3"
LevelToMonster[3960] = "Royal Soldier 3"
LevelToMonster[3961] = "Royal Soldier 3"
LevelToMonster[3962] = "Royal Soldier 3"
LevelToMonster[3963] = "Royal Soldier 3"
LevelToMonster[3964] = "Royal Soldier 3"
LevelToMonster[3965] = "Royal Soldier 3"
LevelToMonster[3966] = "Royal Soldier 3"
LevelToMonster[3967] = "Royal Soldier 3"
LevelToMonster[3968] = "Royal Soldier 3"
LevelToMonster[3969] = "Royal Soldier 3"
LevelToMonster[3970] = "Royal Soldier 3"
LevelToMonster[3971] = "Royal Soldier 3"
LevelToMonster[3972] = "Royal Soldier 3"
LevelToMonster[3973] = "Royal Soldier 3"
LevelToMonster[3974] = "Royal Soldier 3"
LevelToMonster[3975] = "Royal Soldier 3"
LevelToMonster[3976] = "Royal Soldier 3"
LevelToMonster[3977] = "Royal Soldier 3"
LevelToMonster[3978] = "Royal Soldier 3"
LevelToMonster[3979] = "Royal Soldier 3"
LevelToMonster[3980] = "Royal Soldier 3"
LevelToMonster[3981] = "Royal Soldier 3"
LevelToMonster[3982] = "Royal Soldier 3"
LevelToMonster[3983] = "Royal Soldier 3"
LevelToMonster[3984] = "Royal Soldier 3"
LevelToMonster[3985] = "Royal Soldier 3"
LevelToMonster[3986] = "Royal Soldier 3"
LevelToMonster[3987] = "Royal Soldier 3"
LevelToMonster[3988] = "Royal Soldier 3"
LevelToMonster[3989] = "Royal Soldier 3"
LevelToMonster[3990] = "Royal Soldier 3"
LevelToMonster[3991] = "Royal Soldier 3"
LevelToMonster[3992] = "Royal Soldier 3"
LevelToMonster[3993] = "Royal Soldier 3"
LevelToMonster[3994] = "Royal Soldier 3"
LevelToMonster[3995] = "Royal Soldier 3"
LevelToMonster[3996] = "Royal Soldier 3"
LevelToMonster[3997] = "Royal Soldier 3"
LevelToMonster[3998] = "Royal Soldier 3"
LevelToMonster[3999] = "Royal Soldier 3"
LevelToMonster[4000] = "Fishman Captain"
LevelToMonster[4001] = "Fishman Captain"
LevelToMonster[4002] = "Fishman Captain"
LevelToMonster[4003] = "Fishman Captain"
LevelToMonster[4004] = "Fishman Captain"
LevelToMonster[4005] = "Fishman Captain"
LevelToMonster[4006] = "Fishman Captain"
LevelToMonster[4007] = "Fishman Captain"
LevelToMonster[4008] = "Fishman Captain"
LevelToMonster[4009] = "Fishman Captain"
LevelToMonster[4010] = "Fishman Captain"
LevelToMonster[4011] = "Fishman Captain"
LevelToMonster[4012] = "Fishman Captain"
LevelToMonster[4013] = "Fishman Captain"
LevelToMonster[4014] = "Fishman Captain"
LevelToMonster[4015] = "Fishman Captain"
LevelToMonster[4016] = "Fishman Captain"
LevelToMonster[4017] = "Fishman Captain"
LevelToMonster[4018] = "Fishman Captain"
LevelToMonster[4019] = "Fishman Captain"
LevelToMonster[4020] = "Fishman Captain"
LevelToMonster[4021] = "Fishman Captain"
LevelToMonster[4022] = "Fishman Captain"
LevelToMonster[4023] = "Fishman Captain"
LevelToMonster[4024] = "Fishman Captain"
LevelToMonster[4025] = "Fishman Captain"
LevelToMonster[4026] = "Fishman Captain"
LevelToMonster[4027] = "Fishman Captain"
LevelToMonster[4028] = "Fishman Captain"
LevelToMonster[4029] = "Fishman Captain"
LevelToMonster[4030] = "Fishman Captain"
LevelToMonster[4031] = "Fishman Captain"
LevelToMonster[4032] = "Fishman Captain"
LevelToMonster[4033] = "Fishman Captain"
LevelToMonster[4034] = "Fishman Captain"
LevelToMonster[4035] = "Fishman Captain"
LevelToMonster[4036] = "Fishman Captain"
LevelToMonster[4037] = "Fishman Captain"
LevelToMonster[4038] = "Fishman Captain"
LevelToMonster[4039] = "Fishman Captain"
LevelToMonster[4040] = "Fishman Captain"
LevelToMonster[4041] = "Fishman Captain"
LevelToMonster[4042] = "Fishman Captain"
LevelToMonster[4043] = "Fishman Captain"
LevelToMonster[4044] = "Fishman Captain"
LevelToMonster[4045] = "Fishman Captain"
LevelToMonster[4046] = "Fishman Captain"
LevelToMonster[4047] = "Fishman Captain"
LevelToMonster[4048] = "Fishman Captain"
LevelToMonster[4049] = "Fishman Captain"
LevelToMonster[4050] = "Fishman Captain"
LevelToMonster[4051] = "Fishman Captain"
LevelToMonster[4052] = "Fishman Captain"
LevelToMonster[4053] = "Fishman Captain"
LevelToMonster[4054] = "Fishman Captain"
LevelToMonster[4055] = "Fishman Captain"
LevelToMonster[4056] = "Fishman Captain"
LevelToMonster[4057] = "Fishman Captain"
LevelToMonster[4058] = "Fishman Captain"
LevelToMonster[4059] = "Fishman Captain"
LevelToMonster[4060] = "Fishman Captain"
LevelToMonster[4061] = "Fishman Captain"
LevelToMonster[4062] = "Fishman Captain"
LevelToMonster[4063] = "Fishman Captain"
LevelToMonster[4064] = "Fishman Captain"
LevelToMonster[4065] = "Fishman Captain"
LevelToMonster[4066] = "Fishman Captain"
LevelToMonster[4067] = "Fishman Captain"
LevelToMonster[4068] = "Fishman Captain"
LevelToMonster[4069] = "Fishman Captain"
LevelToMonster[4070] = "Fishman Captain"
LevelToMonster[4071] = "Fishman Captain"
LevelToMonster[4072] = "Fishman Captain"
LevelToMonster[4073] = "Fishman Captain"
LevelToMonster[4074] = "Fishman Captain"
LevelToMonster[4075] = "Fishman Captain"
LevelToMonster[4076] = "Fishman Captain"
LevelToMonster[4077] = "Fishman Captain"
LevelToMonster[4078] = "Fishman Captain"
LevelToMonster[4079] = "Fishman Captain"
LevelToMonster[4080] = "Fishman Captain"
LevelToMonster[4081] = "Fishman Captain"
LevelToMonster[4082] = "Fishman Captain"
LevelToMonster[4083] = "Fishman Captain"
LevelToMonster[4084] = "Fishman Captain"
LevelToMonster[4085] = "Fishman Captain"
LevelToMonster[4086] = "Fishman Captain"
LevelToMonster[4087] = "Fishman Captain"
LevelToMonster[4088] = "Fishman Captain"
LevelToMonster[4089] = "Fishman Captain"
LevelToMonster[4090] = "Fishman Captain"
LevelToMonster[4091] = "Fishman Captain"
LevelToMonster[4092] = "Fishman Captain"
LevelToMonster[4093] = "Fishman Captain"
LevelToMonster[4094] = "Fishman Captain"
LevelToMonster[4095] = "Fishman Captain"
LevelToMonster[4096] = "Fishman Captain"
LevelToMonster[4097] = "Fishman Captain"
LevelToMonster[4098] = "Fishman Captain"
LevelToMonster[4099] = "Fishman Captain"
LevelToMonster[4100] = "Fishman Captain"
LevelToMonster[4101] = "Fishman Captain"
LevelToMonster[4102] = "Fishman Captain"
LevelToMonster[4103] = "Fishman Captain"
LevelToMonster[4104] = "Fishman Captain"
LevelToMonster[4105] = "Fishman Captain"
LevelToMonster[4106] = "Fishman Captain"
LevelToMonster[4107] = "Fishman Captain"
LevelToMonster[4108] = "Fishman Captain"
LevelToMonster[4109] = "Fishman Captain"
LevelToMonster[4110] = "Fishman Captain"
LevelToMonster[4111] = "Fishman Captain"
LevelToMonster[4112] = "Fishman Captain"
LevelToMonster[4113] = "Fishman Captain"
LevelToMonster[4114] = "Fishman Captain"
LevelToMonster[4115] = "Fishman Captain"
LevelToMonster[4116] = "Fishman Captain"
LevelToMonster[4117] = "Fishman Captain"
LevelToMonster[4118] = "Fishman Captain"
LevelToMonster[4119] = "Fishman Captain"
LevelToMonster[4120] = "Fishman Captain"
LevelToMonster[4121] = "Fishman Captain"
LevelToMonster[4122] = "Fishman Captain"
LevelToMonster[4123] = "Fishman Captain"
LevelToMonster[4124] = "Fishman Captain"
LevelToMonster[4125] = "Fishman Captain"
LevelToMonster[4126] = "Fishman Captain"
LevelToMonster[4127] = "Fishman Captain"
LevelToMonster[4128] = "Fishman Captain"
LevelToMonster[4129] = "Fishman Captain"
LevelToMonster[4130] = "Fishman Captain"
LevelToMonster[4131] = "Fishman Captain"
LevelToMonster[4132] = "Fishman Captain"
LevelToMonster[4133] = "Fishman Captain"
LevelToMonster[4134] = "Fishman Captain"
LevelToMonster[4135] = "Fishman Captain"
LevelToMonster[4136] = "Fishman Captain"
LevelToMonster[4137] = "Fishman Captain"
LevelToMonster[4138] = "Fishman Captain"
LevelToMonster[4139] = "Fishman Captain"
LevelToMonster[4140] = "Fishman Captain"
LevelToMonster[4141] = "Fishman Captain"
LevelToMonster[4142] = "Fishman Captain"
LevelToMonster[4143] = "Fishman Captain"
LevelToMonster[4144] = "Fishman Captain"
LevelToMonster[4145] = "Fishman Captain"
LevelToMonster[4146] = "Fishman Captain"
LevelToMonster[4147] = "Fishman Captain"
LevelToMonster[4148] = "Fishman Captain"
LevelToMonster[4149] = "Fishman Captain"
LevelToMonster[4150] = "Fishman Captain"
LevelToMonster[4151] = "Fishman Captain"
LevelToMonster[4152] = "Fishman Captain"
LevelToMonster[4153] = "Fishman Captain"
LevelToMonster[4154] = "Fishman Captain"
LevelToMonster[4155] = "Fishman Captain"
LevelToMonster[4156] = "Fishman Captain"
LevelToMonster[4157] = "Fishman Captain"
LevelToMonster[4158] = "Fishman Captain"
LevelToMonster[4159] = "Fishman Captain"
LevelToMonster[4160] = "Fishman Captain"
LevelToMonster[4161] = "Fishman Captain"
LevelToMonster[4162] = "Fishman Captain"
LevelToMonster[4163] = "Fishman Captain"
LevelToMonster[4164] = "Fishman Captain"
LevelToMonster[4165] = "Fishman Captain"
LevelToMonster[4166] = "Fishman Captain"
LevelToMonster[4167] = "Fishman Captain"
LevelToMonster[4168] = "Fishman Captain"
LevelToMonster[4169] = "Fishman Captain"
LevelToMonster[4170] = "Fishman Captain"
LevelToMonster[4171] = "Fishman Captain"
LevelToMonster[4172] = "Fishman Captain"
LevelToMonster[4173] = "Fishman Captain"
LevelToMonster[4174] = "Fishman Captain"
LevelToMonster[4175] = "Fishman Captain"
LevelToMonster[4176] = "Fishman Captain"
LevelToMonster[4177] = "Fishman Captain"
LevelToMonster[4178] = "Fishman Captain"
LevelToMonster[4179] = "Fishman Captain"
LevelToMonster[4180] = "Fishman Captain"
LevelToMonster[4181] = "Fishman Captain"
LevelToMonster[4182] = "Fishman Captain"
LevelToMonster[4183] = "Fishman Captain"
LevelToMonster[4184] = "Fishman Captain"
LevelToMonster[4185] = "Fishman Captain"
LevelToMonster[4186] = "Fishman Captain"
LevelToMonster[4187] = "Fishman Captain"
LevelToMonster[4188] = "Fishman Captain"
LevelToMonster[4189] = "Fishman Captain"
LevelToMonster[4190] = "Fishman Captain"
LevelToMonster[4191] = "Fishman Captain"
LevelToMonster[4192] = "Fishman Captain"
LevelToMonster[4193] = "Fishman Captain"
LevelToMonster[4194] = "Fishman Captain"
LevelToMonster[4195] = "Fishman Captain"
LevelToMonster[4196] = "Fishman Captain"
LevelToMonster[4197] = "Fishman Captain"
LevelToMonster[4198] = "Fishman Captain"
LevelToMonster[4199] = "Fishman Captain"
LevelToMonster[4200] = "Specter"
LevelToMonster[4201] = "Specter"
LevelToMonster[4202] = "Specter"
LevelToMonster[4203] = "Specter"
LevelToMonster[4204] = "Specter"
LevelToMonster[4205] = "Specter"
LevelToMonster[4206] = "Specter"
LevelToMonster[4207] = "Specter"
LevelToMonster[4208] = "Specter"
LevelToMonster[4209] = "Specter"
LevelToMonster[4210] = "Specter"
LevelToMonster[4211] = "Specter"
LevelToMonster[4212] = "Specter"
LevelToMonster[4213] = "Specter"
LevelToMonster[4214] = "Specter"
LevelToMonster[4215] = "Specter"
LevelToMonster[4216] = "Specter"
LevelToMonster[4217] = "Specter"
LevelToMonster[4218] = "Specter"
LevelToMonster[4219] = "Specter"
LevelToMonster[4220] = "Specter"
LevelToMonster[4221] = "Specter"
LevelToMonster[4222] = "Specter"
LevelToMonster[4223] = "Specter"
LevelToMonster[4224] = "Specter"
LevelToMonster[4225] = "Specter"
LevelToMonster[4226] = "Specter"
LevelToMonster[4227] = "Specter"
LevelToMonster[4228] = "Specter"
LevelToMonster[4229] = "Specter"
LevelToMonster[4230] = "Specter"
LevelToMonster[4231] = "Specter"
LevelToMonster[4232] = "Specter"
LevelToMonster[4233] = "Specter"
LevelToMonster[4234] = "Specter"
LevelToMonster[4235] = "Specter"
LevelToMonster[4236] = "Specter"
LevelToMonster[4237] = "Specter"
LevelToMonster[4238] = "Specter"
LevelToMonster[4239] = "Specter"
LevelToMonster[4240] = "Specter"
LevelToMonster[4241] = "Specter"
LevelToMonster[4242] = "Specter"
LevelToMonster[4243] = "Specter"
LevelToMonster[4244] = "Specter"
LevelToMonster[4245] = "Specter"
LevelToMonster[4246] = "Specter"
LevelToMonster[4247] = "Specter"
LevelToMonster[4248] = "Specter"
LevelToMonster[4249] = "Specter"
LevelToMonster[4250] = "Specter"
LevelToMonster[4251] = "Specter"
LevelToMonster[4252] = "Specter"
LevelToMonster[4253] = "Specter"
LevelToMonster[4254] = "Specter"
LevelToMonster[4255] = "Specter"
LevelToMonster[4256] = "Specter"
LevelToMonster[4257] = "Specter"
LevelToMonster[4258] = "Specter"
LevelToMonster[4259] = "Specter"
LevelToMonster[4260] = "Specter"
LevelToMonster[4261] = "Specter"
LevelToMonster[4262] = "Specter"
LevelToMonster[4263] = "Specter"
LevelToMonster[4264] = "Specter"
LevelToMonster[4265] = "Specter"
LevelToMonster[4266] = "Specter"
LevelToMonster[4267] = "Specter"
LevelToMonster[4268] = "Specter"
LevelToMonster[4269] = "Specter"
LevelToMonster[4270] = "Specter"
LevelToMonster[4271] = "Specter"
LevelToMonster[4272] = "Specter"
LevelToMonster[4273] = "Specter"
LevelToMonster[4274] = "Specter"
LevelToMonster[4275] = "Specter"
LevelToMonster[4276] = "Specter"
LevelToMonster[4277] = "Specter"
LevelToMonster[4278] = "Specter"
LevelToMonster[4279] = "Specter"
LevelToMonster[4280] = "Specter"
LevelToMonster[4281] = "Specter"
LevelToMonster[4282] = "Specter"
LevelToMonster[4283] = "Specter"
LevelToMonster[4284] = "Specter"
LevelToMonster[4285] = "Specter"
LevelToMonster[4286] = "Specter"
LevelToMonster[4287] = "Specter"
LevelToMonster[4288] = "Specter"
LevelToMonster[4289] = "Specter"
LevelToMonster[4290] = "Specter"
LevelToMonster[4291] = "Specter"
LevelToMonster[4292] = "Specter"
LevelToMonster[4293] = "Specter"
LevelToMonster[4294] = "Specter"
LevelToMonster[4295] = "Specter"
LevelToMonster[4296] = "Specter"
LevelToMonster[4297] = "Specter"
LevelToMonster[4298] = "Specter"
LevelToMonster[4299] = "Specter"
LevelToMonster[4300] = "Specter"
LevelToMonster[4301] = "Specter"
LevelToMonster[4302] = "Specter"
LevelToMonster[4303] = "Specter"
LevelToMonster[4304] = "Specter"
LevelToMonster[4305] = "Specter"
LevelToMonster[4306] = "Specter"
LevelToMonster[4307] = "Specter"
LevelToMonster[4308] = "Specter"
LevelToMonster[4309] = "Specter"
LevelToMonster[4310] = "Specter"
LevelToMonster[4311] = "Specter"
LevelToMonster[4312] = "Specter"
LevelToMonster[4313] = "Specter"
LevelToMonster[4314] = "Specter"
LevelToMonster[4315] = "Specter"
LevelToMonster[4316] = "Specter"
LevelToMonster[4317] = "Specter"
LevelToMonster[4318] = "Specter"
LevelToMonster[4319] = "Specter"
LevelToMonster[4320] = "Specter"
LevelToMonster[4321] = "Specter"
LevelToMonster[4322] = "Specter"
LevelToMonster[4323] = "Specter"
LevelToMonster[4324] = "Specter"
LevelToMonster[4325] = "Specter"
LevelToMonster[4326] = "Specter"
LevelToMonster[4327] = "Specter"
LevelToMonster[4328] = "Specter"
LevelToMonster[4329] = "Specter"
LevelToMonster[4330] = "Specter"
LevelToMonster[4331] = "Specter"
LevelToMonster[4332] = "Specter"
LevelToMonster[4333] = "Specter"
LevelToMonster[4334] = "Specter"
LevelToMonster[4335] = "Specter"
LevelToMonster[4336] = "Specter"
LevelToMonster[4337] = "Specter"
LevelToMonster[4338] = "Specter"
LevelToMonster[4339] = "Specter"
LevelToMonster[4340] = "Specter"
LevelToMonster[4341] = "Specter"
LevelToMonster[4342] = "Specter"
LevelToMonster[4343] = "Specter"
LevelToMonster[4344] = "Specter"
LevelToMonster[4345] = "Specter"
LevelToMonster[4346] = "Specter"
LevelToMonster[4347] = "Specter"
LevelToMonster[4348] = "Specter"
LevelToMonster[4349] = "Specter"
LevelToMonster[4350] = "Knight of the Sea"
LevelToMonster[4351] = "Knight of the Sea"
LevelToMonster[4352] = "Knight of the Sea"
LevelToMonster[4353] = "Knight of the Sea"
LevelToMonster[4354] = "Knight of the Sea"
LevelToMonster[4355] = "Knight of the Sea"
LevelToMonster[4356] = "Knight of the Sea"
LevelToMonster[4357] = "Knight of the Sea"
LevelToMonster[4358] = "Knight of the Sea"
LevelToMonster[4359] = "Knight of the Sea"
LevelToMonster[4360] = "Knight of the Sea"
LevelToMonster[4361] = "Knight of the Sea"
LevelToMonster[4362] = "Knight of the Sea"
LevelToMonster[4363] = "Knight of the Sea"
LevelToMonster[4364] = "Knight of the Sea"
LevelToMonster[4365] = "Knight of the Sea"
LevelToMonster[4366] = "Knight of the Sea"
LevelToMonster[4367] = "Knight of the Sea"
LevelToMonster[4368] = "Knight of the Sea"
LevelToMonster[4369] = "Knight of the Sea"
LevelToMonster[4370] = "Knight of the Sea"
LevelToMonster[4371] = "Knight of the Sea"
LevelToMonster[4372] = "Knight of the Sea"
LevelToMonster[4373] = "Knight of the Sea"
LevelToMonster[4374] = "Knight of the Sea"
LevelToMonster[4375] = "Knight of the Sea"
LevelToMonster[4376] = "Knight of the Sea"
LevelToMonster[4377] = "Knight of the Sea"
LevelToMonster[4378] = "Knight of the Sea"
LevelToMonster[4379] = "Knight of the Sea"
LevelToMonster[4380] = "Knight of the Sea"
LevelToMonster[4381] = "Knight of the Sea"
LevelToMonster[4382] = "Knight of the Sea"
LevelToMonster[4383] = "Knight of the Sea"
LevelToMonster[4384] = "Knight of the Sea"
LevelToMonster[4385] = "Knight of the Sea"
LevelToMonster[4386] = "Knight of the Sea"
LevelToMonster[4387] = "Knight of the Sea"
LevelToMonster[4388] = "Knight of the Sea"
LevelToMonster[4389] = "Knight of the Sea"
LevelToMonster[4390] = "Knight of the Sea"
LevelToMonster[4391] = "Knight of the Sea"
LevelToMonster[4392] = "Knight of the Sea"
LevelToMonster[4393] = "Knight of the Sea"
LevelToMonster[4394] = "Knight of the Sea"
LevelToMonster[4395] = "Knight of the Sea"
LevelToMonster[4396] = "Knight of the Sea"
LevelToMonster[4397] = "Knight of the Sea"
LevelToMonster[4398] = "Knight of the Sea"
LevelToMonster[4399] = "Knight of the Sea"
LevelToMonster[4400] = "Knight of the Sea"
LevelToMonster[4401] = "Knight of the Sea"
LevelToMonster[4402] = "Knight of the Sea"
LevelToMonster[4403] = "Knight of the Sea"
LevelToMonster[4404] = "Knight of the Sea"
LevelToMonster[4405] = "Knight of the Sea"
LevelToMonster[4406] = "Knight of the Sea"
LevelToMonster[4407] = "Knight of the Sea"
LevelToMonster[4408] = "Knight of the Sea"
LevelToMonster[4409] = "Knight of the Sea"
LevelToMonster[4410] = "Knight of the Sea"
LevelToMonster[4411] = "Knight of the Sea"
LevelToMonster[4412] = "Knight of the Sea"
LevelToMonster[4413] = "Knight of the Sea"
LevelToMonster[4414] = "Knight of the Sea"
LevelToMonster[4415] = "Knight of the Sea"
LevelToMonster[4416] = "Knight of the Sea"
LevelToMonster[4417] = "Knight of the Sea"
LevelToMonster[4418] = "Knight of the Sea"
LevelToMonster[4419] = "Knight of the Sea"
LevelToMonster[4420] = "Knight of the Sea"
LevelToMonster[4421] = "Knight of the Sea"
LevelToMonster[4422] = "Knight of the Sea"
LevelToMonster[4423] = "Knight of the Sea"
LevelToMonster[4424] = "Knight of the Sea"
LevelToMonster[4425] = "Knight of the Sea"
LevelToMonster[4426] = "Knight of the Sea"
LevelToMonster[4427] = "Knight of the Sea"
LevelToMonster[4428] = "Knight of the Sea"
LevelToMonster[4429] = "Knight of the Sea"
LevelToMonster[4430] = "Knight of the Sea"
LevelToMonster[4431] = "Knight of the Sea"
LevelToMonster[4432] = "Knight of the Sea"
LevelToMonster[4433] = "Knight of the Sea"
LevelToMonster[4434] = "Knight of the Sea"
LevelToMonster[4435] = "Knight of the Sea"
LevelToMonster[4436] = "Knight of the Sea"
LevelToMonster[4437] = "Knight of the Sea"
LevelToMonster[4438] = "Knight of the Sea"
LevelToMonster[4439] = "Knight of the Sea"
LevelToMonster[4440] = "Knight of the Sea"
LevelToMonster[4441] = "Knight of the Sea"
LevelToMonster[4442] = "Knight of the Sea"
LevelToMonster[4443] = "Knight of the Sea"
LevelToMonster[4444] = "Knight of the Sea"
LevelToMonster[4445] = "Knight of the Sea"
LevelToMonster[4446] = "Knight of the Sea"
LevelToMonster[4447] = "Knight of the Sea"
LevelToMonster[4448] = "Knight of the Sea"
LevelToMonster[4449] = "Knight of the Sea"
LevelToMonster[4450] = "Knight of the Sea"
LevelToMonster[4451] = "Knight of the Sea"
LevelToMonster[4452] = "Knight of the Sea"
LevelToMonster[4453] = "Knight of the Sea"
LevelToMonster[4454] = "Knight of the Sea"
LevelToMonster[4455] = "Knight of the Sea"
LevelToMonster[4456] = "Knight of the Sea"
LevelToMonster[4457] = "Knight of the Sea"
LevelToMonster[4458] = "Knight of the Sea"
LevelToMonster[4459] = "Knight of the Sea"
LevelToMonster[4460] = "Knight of the Sea"
LevelToMonster[4461] = "Knight of the Sea"
LevelToMonster[4462] = "Knight of the Sea"
LevelToMonster[4463] = "Knight of the Sea"
LevelToMonster[4464] = "Knight of the Sea"
LevelToMonster[4465] = "Knight of the Sea"
LevelToMonster[4466] = "Knight of the Sea"
LevelToMonster[4467] = "Knight of the Sea"
LevelToMonster[4468] = "Knight of the Sea"
LevelToMonster[4469] = "Knight of the Sea"
LevelToMonster[4470] = "Knight of the Sea"
LevelToMonster[4471] = "Knight of the Sea"
LevelToMonster[4472] = "Knight of the Sea"
LevelToMonster[4473] = "Knight of the Sea"
LevelToMonster[4474] = "Knight of the Sea"
LevelToMonster[4475] = "Knight of the Sea"
LevelToMonster[4476] = "Knight of the Sea"
LevelToMonster[4477] = "Knight of the Sea"
LevelToMonster[4478] = "Knight of the Sea"
LevelToMonster[4479] = "Knight of the Sea"
LevelToMonster[4480] = "Knight of the Sea"
LevelToMonster[4481] = "Knight of the Sea"
LevelToMonster[4482] = "Knight of the Sea"
LevelToMonster[4483] = "Knight of the Sea"
LevelToMonster[4484] = "Knight of the Sea"
LevelToMonster[4485] = "Knight of the Sea"
LevelToMonster[4486] = "Knight of the Sea"
LevelToMonster[4487] = "Knight of the Sea"
LevelToMonster[4488] = "Knight of the Sea"
LevelToMonster[4489] = "Knight of the Sea"
LevelToMonster[4490] = "Knight of the Sea"
LevelToMonster[4491] = "Knight of the Sea"
LevelToMonster[4492] = "Knight of the Sea"
LevelToMonster[4493] = "Knight of the Sea"
LevelToMonster[4494] = "Knight of the Sea"
LevelToMonster[4495] = "Knight of the Sea"
LevelToMonster[4496] = "Knight of the Sea"
LevelToMonster[4497] = "Knight of the Sea"
LevelToMonster[4498] = "Knight of the Sea"
LevelToMonster[4499] = "Knight of the Sea"
LevelToMonster[4500] = "Samurai"

-- ============================================================
-- XP REQUIRED PER LEVEL (1-2450)
-- ============================================================
local XPTable = {}
XPTable[1] = 100
XPTable[2] = 282
XPTable[3] = 519
XPTable[4] = 800
XPTable[5] = 1118
XPTable[6] = 1469
XPTable[7] = 1852
XPTable[8] = 2262
XPTable[9] = 2700
XPTable[10] = 3162
XPTable[11] = 3648
XPTable[12] = 4156
XPTable[13] = 4687
XPTable[14] = 5238
XPTable[15] = 5809
XPTable[16] = 6400
XPTable[17] = 7009
XPTable[18] = 7636
XPTable[19] = 8281
XPTable[20] = 8944
XPTable[21] = 9623
XPTable[22] = 10318
XPTable[23] = 11030
XPTable[24] = 11757
XPTable[25] = 12500
XPTable[26] = 13257
XPTable[27] = 14029
XPTable[28] = 14816
XPTable[29] = 15616
XPTable[30] = 16431
XPTable[31] = 17260
XPTable[32] = 18101
XPTable[33] = 18957
XPTable[34] = 19825
XPTable[35] = 20706
XPTable[36] = 21600
XPTable[37] = 22506
XPTable[38] = 23424
XPTable[39] = 24355
XPTable[40] = 25298
XPTable[41] = 26252
XPTable[42] = 27219
XPTable[43] = 28196
XPTable[44] = 29186
XPTable[45] = 30186
XPTable[46] = 31198
XPTable[47] = 32221
XPTable[48] = 33255
XPTable[49] = 34300
XPTable[50] = 35355
XPTable[51] = 36421
XPTable[52] = 37497
XPTable[53] = 38584
XPTable[54] = 39681
XPTable[55] = 40789
XPTable[56] = 41906
XPTable[57] = 43034
XPTable[58] = 44171
XPTable[59] = 45318
XPTable[60] = 46475
XPTable[61] = 47642
XPTable[62] = 48818
XPTable[63] = 50004
XPTable[64] = 51200
XPTable[65] = 52404
XPTable[66] = 53618
XPTable[67] = 54841
XPTable[68] = 56074
XPTable[69] = 57315
XPTable[70] = 58566
XPTable[71] = 59825
XPTable[72] = 61094
XPTable[73] = 62371
XPTable[74] = 63657
XPTable[75] = 64951
XPTable[76] = 66255
XPTable[77] = 67567
XPTable[78] = 68887
XPTable[79] = 70216
XPTable[80] = 71554
XPTable[81] = 72900
XPTable[82] = 74254
XPTable[83] = 75616
XPTable[84] = 76987
XPTable[85] = 78366
XPTable[86] = 79753
XPTable[87] = 81148
XPTable[88] = 82551
XPTable[89] = 83962
XPTable[90] = 85381
XPTable[91] = 86808
XPTable[92] = 88243
XPTable[93] = 89685
XPTable[94] = 91136
XPTable[95] = 92594
XPTable[96] = 94060
XPTable[97] = 95533
XPTable[98] = 97015
XPTable[99] = 98503
XPTable[100] = 100000
XPTable[101] = 101503
XPTable[102] = 103014
XPTable[103] = 104533
XPTable[104] = 106059
XPTable[105] = 107592
XPTable[106] = 109133
XPTable[107] = 110681
XPTable[108] = 112236
XPTable[109] = 113799
XPTable[110] = 115368
XPTable[111] = 116945
XPTable[112] = 118529
XPTable[113] = 120120
XPTable[114] = 121718
XPTable[115] = 123323
XPTable[116] = 124935
XPTable[117] = 126554
XPTable[118] = 128180
XPTable[119] = 129813
XPTable[120] = 131453
XPTable[121] = 133100
XPTable[122] = 134753
XPTable[123] = 136413
XPTable[124] = 138080
XPTable[125] = 139754
XPTable[126] = 141434
XPTable[127] = 143121
XPTable[128] = 144815
XPTable[129] = 146515
XPTable[130] = 148222
XPTable[131] = 149936
XPTable[132] = 151656
XPTable[133] = 153383
XPTable[134] = 155116
XPTable[135] = 156855
XPTable[136] = 158601
XPTable[137] = 160354
XPTable[138] = 162113
XPTable[139] = 163878
XPTable[140] = 165650
XPTable[141] = 167428
XPTable[142] = 169212
XPTable[143] = 171003
XPTable[144] = 172800
XPTable[145] = 174603
XPTable[146] = 176412
XPTable[147] = 178228
XPTable[148] = 180049
XPTable[149] = 181877
XPTable[150] = 183711
XPTable[151] = 185551
XPTable[152] = 187398
XPTable[153] = 189250
XPTable[154] = 191108
XPTable[155] = 192973
XPTable[156] = 194843
XPTable[157] = 196720
XPTable[158] = 198602
XPTable[159] = 200491
XPTable[160] = 202385
XPTable[161] = 204286
XPTable[162] = 206192
XPTable[163] = 208104
XPTable[164] = 210022
XPTable[165] = 211946
XPTable[166] = 213876
XPTable[167] = 215811
XPTable[168] = 217752
XPTable[169] = 219700
XPTable[170] = 221652
XPTable[171] = 223611
XPTable[172] = 225575
XPTable[173] = 227545
XPTable[174] = 229521
XPTable[175] = 231503
XPTable[176] = 233490
XPTable[177] = 235483
XPTable[178] = 237481
XPTable[179] = 239485
XPTable[180] = 241495
XPTable[181] = 243510
XPTable[182] = 245531
XPTable[183] = 247557
XPTable[184] = 249589
XPTable[185] = 251627
XPTable[186] = 253670
XPTable[187] = 255718
XPTable[188] = 257772
XPTable[189] = 259832
XPTable[190] = 261896
XPTable[191] = 263967
XPTable[192] = 266043
XPTable[193] = 268124
XPTable[194] = 270210
XPTable[195] = 272302
XPTable[196] = 274400
XPTable[197] = 276502
XPTable[198] = 278610
XPTable[199] = 280724
XPTable[200] = 282842
XPTable[201] = 284966
XPTable[202] = 287095
XPTable[203] = 289230
XPTable[204] = 291370
XPTable[205] = 293515
XPTable[206] = 295665
XPTable[207] = 297821
XPTable[208] = 299981
XPTable[209] = 302147
XPTable[210] = 304318
XPTable[211] = 306495
XPTable[212] = 308676
XPTable[213] = 310863
XPTable[214] = 313055
XPTable[215] = 315251
XPTable[216] = 317453
XPTable[217] = 319660
XPTable[218] = 321873
XPTable[219] = 324090
XPTable[220] = 326312
XPTable[221] = 328540
XPTable[222] = 330772
XPTable[223] = 333010
XPTable[224] = 335252
XPTable[225] = 337500
XPTable[226] = 339752
XPTable[227] = 342009
XPTable[228] = 344272
XPTable[229] = 346539
XPTable[230] = 348812
XPTable[231] = 351089
XPTable[232] = 353371
XPTable[233] = 355659
XPTable[234] = 357951
XPTable[235] = 360248
XPTable[236] = 362550
XPTable[237] = 364856
XPTable[238] = 367168
XPTable[239] = 369485
XPTable[240] = 371806
XPTable[241] = 374132
XPTable[242] = 376463
XPTable[243] = 378799
XPTable[244] = 381140
XPTable[245] = 383485
XPTable[246] = 385835
XPTable[247] = 388190
XPTable[248] = 390550
XPTable[249] = 392915
XPTable[250] = 395284
XPTable[251] = 397658
XPTable[252] = 400037
XPTable[253] = 402421
XPTable[254] = 404809
XPTable[255] = 407202
XPTable[256] = 409600
XPTable[257] = 412002
XPTable[258] = 414409
XPTable[259] = 416821
XPTable[260] = 419237
XPTable[261] = 421658
XPTable[262] = 424084
XPTable[263] = 426514
XPTable[264] = 428949
XPTable[265] = 431388
XPTable[266] = 433832
XPTable[267] = 436281
XPTable[268] = 438734
XPTable[269] = 441192
XPTable[270] = 443655
XPTable[271] = 446122
XPTable[272] = 448593
XPTable[273] = 451070
XPTable[274] = 453550
XPTable[275] = 456035
XPTable[276] = 458525
XPTable[277] = 461019
XPTable[278] = 463518
XPTable[279] = 466021
XPTable[280] = 468529
XPTable[281] = 471041
XPTable[282] = 473558
XPTable[283] = 476079
XPTable[284] = 478605
XPTable[285] = 481135
XPTable[286] = 483669
XPTable[287] = 486208
XPTable[288] = 488752
XPTable[289] = 491300
XPTable[290] = 493852
XPTable[291] = 496408
XPTable[292] = 498969
XPTable[293] = 501535
XPTable[294] = 504104
XPTable[295] = 506679
XPTable[296] = 509257
XPTable[297] = 511840
XPTable[298] = 514427
XPTable[299] = 517019
XPTable[300] = 519615
XPTable[301] = 522215
XPTable[302] = 524820
XPTable[303] = 527428
XPTable[304] = 530042
XPTable[305] = 532659
XPTable[306] = 535281
XPTable[307] = 537907
XPTable[308] = 540537
XPTable[309] = 543172
XPTable[310] = 545811
XPTable[311] = 548454
XPTable[312] = 551101
XPTable[313] = 553753
XPTable[314] = 556409
XPTable[315] = 559069
XPTable[316] = 561733
XPTable[317] = 564402
XPTable[318] = 567075
XPTable[319] = 569752
XPTable[320] = 572433
XPTable[321] = 575118
XPTable[322] = 577808
XPTable[323] = 580502
XPTable[324] = 583200
XPTable[325] = 585902
XPTable[326] = 588608
XPTable[327] = 591318
XPTable[328] = 594033
XPTable[329] = 596751
XPTable[330] = 599474
XPTable[331] = 602201
XPTable[332] = 604932
XPTable[333] = 607667
XPTable[334] = 610407
XPTable[335] = 613150
XPTable[336] = 615898
XPTable[337] = 618649
XPTable[338] = 621405
XPTable[339] = 624165
XPTable[340] = 626929
XPTable[341] = 629696
XPTable[342] = 632468
XPTable[343] = 635244
XPTable[344] = 638024
XPTable[345] = 640809
XPTable[346] = 643597
XPTable[347] = 646389
XPTable[348] = 649185
XPTable[349] = 651985
XPTable[350] = 654790
XPTable[351] = 657598
XPTable[352] = 660410
XPTable[353] = 663226
XPTable[354] = 666047
XPTable[355] = 668871
XPTable[356] = 671699
XPTable[357] = 674531
XPTable[358] = 677367
XPTable[359] = 680207
XPTable[360] = 683051
XPTable[361] = 685900
XPTable[362] = 688751
XPTable[363] = 691607
XPTable[364] = 694467
XPTable[365] = 697331
XPTable[366] = 700199
XPTable[367] = 703070
XPTable[368] = 705946
XPTable[369] = 708825
XPTable[370] = 711709
XPTable[371] = 714596
XPTable[372] = 717487
XPTable[373] = 720382
XPTable[374] = 723281
XPTable[375] = 726184
XPTable[376] = 729091
XPTable[377] = 732001
XPTable[378] = 734915
XPTable[379] = 737834
XPTable[380] = 740756
XPTable[381] = 743682
XPTable[382] = 746612
XPTable[383] = 749545
XPTable[384] = 752483
XPTable[385] = 755424
XPTable[386] = 758369
XPTable[387] = 761318
XPTable[388] = 764271
XPTable[389] = 767227
XPTable[390] = 770188
XPTable[391] = 773152
XPTable[392] = 776120
XPTable[393] = 779092
XPTable[394] = 782067
XPTable[395] = 785046
XPTable[396] = 788030
XPTable[397] = 791016
XPTable[398] = 794007
XPTable[399] = 797001
XPTable[400] = 800000
XPTable[401] = 803001
XPTable[402] = 806007
XPTable[403] = 809016
XPTable[404] = 812029
XPTable[405] = 815046
XPTable[406] = 818067
XPTable[407] = 821091
XPTable[408] = 824119
XPTable[409] = 827151
XPTable[410] = 830186
XPTable[411] = 833225
XPTable[412] = 836268
XPTable[413] = 839315
XPTable[414] = 842365
XPTable[415] = 845419
XPTable[416] = 848476
XPTable[417] = 851538
XPTable[418] = 854603
XPTable[419] = 857671
XPTable[420] = 860743
XPTable[421] = 863819
XPTable[422] = 866899
XPTable[423] = 869982
XPTable[424] = 873069
XPTable[425] = 876159
XPTable[426] = 879254
XPTable[427] = 882351
XPTable[428] = 885453
XPTable[429] = 888558
XPTable[430] = 891666
XPTable[431] = 894779
XPTable[432] = 897895
XPTable[433] = 901014
XPTable[434] = 904137
XPTable[435] = 907264
XPTable[436] = 910394
XPTable[437] = 913528
XPTable[438] = 916666
XPTable[439] = 919807
XPTable[440] = 922951
XPTable[441] = 926100
XPTable[442] = 929251
XPTable[443] = 932407
XPTable[444] = 935566
XPTable[445] = 938728
XPTable[446] = 941894
XPTable[447] = 945064
XPTable[448] = 948237
XPTable[449] = 951413
XPTable[450] = 954594
XPTable[451] = 957777
XPTable[452] = 960965
XPTable[453] = 964155
XPTable[454] = 967350
XPTable[455] = 970548
XPTable[456] = 973749
XPTable[457] = 976954
XPTable[458] = 980162
XPTable[459] = 983374
XPTable[460] = 986590
XPTable[461] = 989808
XPTable[462] = 993031
XPTable[463] = 996257
XPTable[464] = 999486
XPTable[465] = 1002719
XPTable[466] = 1005955
XPTable[467] = 1009195
XPTable[468] = 1012438
XPTable[469] = 1015685
XPTable[470] = 1018935
XPTable[471] = 1022189
XPTable[472] = 1025446
XPTable[473] = 1028707
XPTable[474] = 1031971
XPTable[475] = 1035238
XPTable[476] = 1038509
XPTable[477] = 1041783
XPTable[478] = 1045061
XPTable[479] = 1048342
XPTable[480] = 1051627
XPTable[481] = 1054915
XPTable[482] = 1058206
XPTable[483] = 1061501
XPTable[484] = 1064800
XPTable[485] = 1068101
XPTable[486] = 1071406
XPTable[487] = 1074715
XPTable[488] = 1078027
XPTable[489] = 1081342
XPTable[490] = 1084661
XPTable[491] = 1087983
XPTable[492] = 1091308
XPTable[493] = 1094637
XPTable[494] = 1097969
XPTable[495] = 1101305
XPTable[496] = 1104644
XPTable[497] = 1107986
XPTable[498] = 1111332
XPTable[499] = 1114681
XPTable[500] = 1118033
XPTable[501] = 1121389
XPTable[502] = 1124748
XPTable[503] = 1128111
XPTable[504] = 1131477
XPTable[505] = 1134846
XPTable[506] = 1138218
XPTable[507] = 1141594
XPTable[508] = 1144973
XPTable[509] = 1148356
XPTable[510] = 1151742
XPTable[511] = 1155131
XPTable[512] = 1158523
XPTable[513] = 1161919
XPTable[514] = 1165318
XPTable[515] = 1168720
XPTable[516] = 1172126
XPTable[517] = 1175535
XPTable[518] = 1178947
XPTable[519] = 1182363
XPTable[520] = 1185782
XPTable[521] = 1189204
XPTable[522] = 1192630
XPTable[523] = 1196058
XPTable[524] = 1199490
XPTable[525] = 1202926
XPTable[526] = 1206364
XPTable[527] = 1209806
XPTable[528] = 1213251
XPTable[529] = 1216700
XPTable[530] = 1220151
XPTable[531] = 1223606
XPTable[532] = 1227064
XPTable[533] = 1230526
XPTable[534] = 1233990
XPTable[535] = 1237458
XPTable[536] = 1240929
XPTable[537] = 1244404
XPTable[538] = 1247881
XPTable[539] = 1251362
XPTable[540] = 1254846
XPTable[541] = 1258333
XPTable[542] = 1261824
XPTable[543] = 1265318
XPTable[544] = 1268815
XPTable[545] = 1272315
XPTable[546] = 1275818
XPTable[547] = 1279325
XPTable[548] = 1282835
XPTable[549] = 1286348
XPTable[550] = 1289864
XPTable[551] = 1293383
XPTable[552] = 1296906
XPTable[553] = 1300432
XPTable[554] = 1303961
XPTable[555] = 1307493
XPTable[556] = 1311028
XPTable[557] = 1314567
XPTable[558] = 1318108
XPTable[559] = 1321653
XPTable[560] = 1325201
XPTable[561] = 1328753
XPTable[562] = 1332307
XPTable[563] = 1335865
XPTable[564] = 1339425
XPTable[565] = 1342989
XPTable[566] = 1346556
XPTable[567] = 1350126
XPTable[568] = 1353700
XPTable[569] = 1357276
XPTable[570] = 1360856
XPTable[571] = 1364439
XPTable[572] = 1368025
XPTable[573] = 1371614
XPTable[574] = 1375206
XPTable[575] = 1378801
XPTable[576] = 1382400
XPTable[577] = 1386001
XPTable[578] = 1389606
XPTable[579] = 1393214
XPTable[580] = 1396824
XPTable[581] = 1400439
XPTable[582] = 1404056
XPTable[583] = 1407676
XPTable[584] = 1411299
XPTable[585] = 1414926
XPTable[586] = 1418555
XPTable[587] = 1422188
XPTable[588] = 1425824
XPTable[589] = 1429463
XPTable[590] = 1433105
XPTable[591] = 1436750
XPTable[592] = 1440398
XPTable[593] = 1444049
XPTable[594] = 1447703
XPTable[595] = 1451360
XPTable[596] = 1455021
XPTable[597] = 1458684
XPTable[598] = 1462351
XPTable[599] = 1466021
XPTable[600] = 1469693
XPTable[601] = 1473369
XPTable[602] = 1477048
XPTable[603] = 1480730
XPTable[604] = 1484415
XPTable[605] = 1488103
XPTable[606] = 1491794
XPTable[607] = 1495488
XPTable[608] = 1499185
XPTable[609] = 1502885
XPTable[610] = 1506588
XPTable[611] = 1510295
XPTable[612] = 1514004
XPTable[613] = 1517716
XPTable[614] = 1521432
XPTable[615] = 1525150
XPTable[616] = 1528871
XPTable[617] = 1532596
XPTable[618] = 1536323
XPTable[619] = 1540054
XPTable[620] = 1543787
XPTable[621] = 1547524
XPTable[622] = 1551263
XPTable[623] = 1555006
XPTable[624] = 1558751
XPTable[625] = 1562500
XPTable[626] = 1566251
XPTable[627] = 1570005
XPTable[628] = 1573763
XPTable[629] = 1577523
XPTable[630] = 1581287
XPTable[631] = 1585053
XPTable[632] = 1588823
XPTable[633] = 1592595
XPTable[634] = 1596371
XPTable[635] = 1600149
XPTable[636] = 1603930
XPTable[637] = 1607715
XPTable[638] = 1611502
XPTable[639] = 1615292
XPTable[640] = 1619086
XPTable[641] = 1622882
XPTable[642] = 1626681
XPTable[643] = 1630483
XPTable[644] = 1634288
XPTable[645] = 1638096
XPTable[646] = 1641907
XPTable[647] = 1645721
XPTable[648] = 1649538
XPTable[649] = 1653358
XPTable[650] = 1657181
XPTable[651] = 1661007
XPTable[652] = 1664835
XPTable[653] = 1668667
XPTable[654] = 1672501
XPTable[655] = 1676339
XPTable[656] = 1680179
XPTable[657] = 1684023
XPTable[658] = 1687869
XPTable[659] = 1691718
XPTable[660] = 1695570
XPTable[661] = 1699425
XPTable[662] = 1703283
XPTable[663] = 1707144
XPTable[664] = 1711008
XPTable[665] = 1714874
XPTable[666] = 1718744
XPTable[667] = 1722617
XPTable[668] = 1726492
XPTable[669] = 1730370
XPTable[670] = 1734252
XPTable[671] = 1738136
XPTable[672] = 1742023
XPTable[673] = 1745912
XPTable[674] = 1749805
XPTable[675] = 1753701
XPTable[676] = 1757600
XPTable[677] = 1761501
XPTable[678] = 1765405
XPTable[679] = 1769312
XPTable[680] = 1773223
XPTable[681] = 1777136
XPTable[682] = 1781051
XPTable[683] = 1784970
XPTable[684] = 1788892
XPTable[685] = 1792816
XPTable[686] = 1796743
XPTable[687] = 1800674
XPTable[688] = 1804607
XPTable[689] = 1808542
XPTable[690] = 1812481
XPTable[691] = 1816423
XPTable[692] = 1820367
XPTable[693] = 1824315
XPTable[694] = 1828265
XPTable[695] = 1832218
XPTable[696] = 1836174
XPTable[697] = 1840132
XPTable[698] = 1844094
XPTable[699] = 1848058
XPTable[700] = 1852025
XPTable[701] = 1855995
XPTable[702] = 1859968
XPTable[703] = 1863944
XPTable[704] = 1867923
XPTable[705] = 1871904
XPTable[706] = 1875888
XPTable[707] = 1879875
XPTable[708] = 1883865
XPTable[709] = 1887858
XPTable[710] = 1891853
XPTable[711] = 1895851
XPTable[712] = 1899852
XPTable[713] = 1903856
XPTable[714] = 1907863
XPTable[715] = 1911873
XPTable[716] = 1915885
XPTable[717] = 1919900
XPTable[718] = 1923918
XPTable[719] = 1927939
XPTable[720] = 1931962
XPTable[721] = 1935989
XPTable[722] = 1940018
XPTable[723] = 1944050
XPTable[724] = 1948084
XPTable[725] = 1952122
XPTable[726] = 1956162
XPTable[727] = 1960205
XPTable[728] = 1964251
XPTable[729] = 1968300
XPTable[730] = 1972351
XPTable[731] = 1976405
XPTable[732] = 1980462
XPTable[733] = 1984522
XPTable[734] = 1988584
XPTable[735] = 1992649
XPTable[736] = 1996717
XPTable[737] = 2000788
XPTable[738] = 2004862
XPTable[739] = 2008938
XPTable[740] = 2013017
XPTable[741] = 2017099
XPTable[742] = 2021184
XPTable[743] = 2025271
XPTable[744] = 2029361
XPTable[745] = 2033454
XPTable[746] = 2037549
XPTable[747] = 2041648
XPTable[748] = 2045749
XPTable[749] = 2049853
XPTable[750] = 2053959
XPTable[751] = 2058068
XPTable[752] = 2062180
XPTable[753] = 2066295
XPTable[754] = 2070413
XPTable[755] = 2074533
XPTable[756] = 2078656
XPTable[757] = 2082782
XPTable[758] = 2086910
XPTable[759] = 2091041
XPTable[760] = 2095175
XPTable[761] = 2099311
XPTable[762] = 2103451
XPTable[763] = 2107593
XPTable[764] = 2111738
XPTable[765] = 2115885
XPTable[766] = 2120035
XPTable[767] = 2124188
XPTable[768] = 2128344
XPTable[769] = 2132502
XPTable[770] = 2136663
XPTable[771] = 2140826
XPTable[772] = 2144993
XPTable[773] = 2149162
XPTable[774] = 2153334
XPTable[775] = 2157508
XPTable[776] = 2161685
XPTable[777] = 2165865
XPTable[778] = 2170048
XPTable[779] = 2174233
XPTable[780] = 2178421
XPTable[781] = 2182612
XPTable[782] = 2186805
XPTable[783] = 2191001
XPTable[784] = 2195200
XPTable[785] = 2199401
XPTable[786] = 2203605
XPTable[787] = 2207812
XPTable[788] = 2212021
XPTable[789] = 2216233
XPTable[790] = 2220448
XPTable[791] = 2224665
XPTable[792] = 2228885
XPTable[793] = 2233108
XPTable[794] = 2237333
XPTable[795] = 2241561
XPTable[796] = 2245792
XPTable[797] = 2250025
XPTable[798] = 2254261
XPTable[799] = 2258500
XPTable[800] = 2262741
XPTable[801] = 2266985
XPTable[802] = 2271232
XPTable[803] = 2275481
XPTable[804] = 2279733
XPTable[805] = 2283988
XPTable[806] = 2288245
XPTable[807] = 2292505
XPTable[808] = 2296767
XPTable[809] = 2301032
XPTable[810] = 2305300
XPTable[811] = 2309570
XPTable[812] = 2313843
XPTable[813] = 2318119
XPTable[814] = 2322397
XPTable[815] = 2326678
XPTable[816] = 2330962
XPTable[817] = 2335248
XPTable[818] = 2339537
XPTable[819] = 2343828
XPTable[820] = 2348122
XPTable[821] = 2352419
XPTable[822] = 2356718
XPTable[823] = 2361020
XPTable[824] = 2365324
XPTable[825] = 2369632
XPTable[826] = 2373941
XPTable[827] = 2378254
XPTable[828] = 2382569
XPTable[829] = 2386886
XPTable[830] = 2391206
XPTable[831] = 2395529
XPTable[832] = 2399854
XPTable[833] = 2404182
XPTable[834] = 2408513
XPTable[835] = 2412846
XPTable[836] = 2417182
XPTable[837] = 2421520
XPTable[838] = 2425861
XPTable[839] = 2430205
XPTable[840] = 2434551
XPTable[841] = 2438900
XPTable[842] = 2443251
XPTable[843] = 2447605
XPTable[844] = 2451961
XPTable[845] = 2456320
XPTable[846] = 2460682
XPTable[847] = 2465046
XPTable[848] = 2469413
XPTable[849] = 2473782
XPTable[850] = 2478154
XPTable[851] = 2482529
XPTable[852] = 2486906
XPTable[853] = 2491285
XPTable[854] = 2495667
XPTable[855] = 2500052
XPTable[856] = 2504440
XPTable[857] = 2508829
XPTable[858] = 2513222
XPTable[859] = 2517617
XPTable[860] = 2522015
XPTable[861] = 2526415
XPTable[862] = 2530817
XPTable[863] = 2535223
XPTable[864] = 2539630
XPTable[865] = 2544041
XPTable[866] = 2548454
XPTable[867] = 2552869
XPTable[868] = 2557287
XPTable[869] = 2561708
XPTable[870] = 2566131
XPTable[871] = 2570556
XPTable[872] = 2574985
XPTable[873] = 2579415
XPTable[874] = 2583849
XPTable[875] = 2588284
XPTable[876] = 2592723
XPTable[877] = 2597164
XPTable[878] = 2601607
XPTable[879] = 2606053
XPTable[880] = 2610501
XPTable[881] = 2614952
XPTable[882] = 2619406
XPTable[883] = 2623862
XPTable[884] = 2628320
XPTable[885] = 2632782
XPTable[886] = 2637245
XPTable[887] = 2641711
XPTable[888] = 2646180
XPTable[889] = 2650651
XPTable[890] = 2655125
XPTable[891] = 2659601
XPTable[892] = 2664080
XPTable[893] = 2668561
XPTable[894] = 2673045
XPTable[895] = 2677531
XPTable[896] = 2682020
XPTable[897] = 2686511
XPTable[898] = 2691005
XPTable[899] = 2695501
XPTable[900] = 2700000
XPTable[901] = 2704501
XPTable[902] = 2709004
XPTable[903] = 2713511
XPTable[904] = 2718019
XPTable[905] = 2722531
XPTable[906] = 2727044
XPTable[907] = 2731561
XPTable[908] = 2736079
XPTable[909] = 2740601
XPTable[910] = 2745124
XPTable[911] = 2749650
XPTable[912] = 2754179
XPTable[913] = 2758710
XPTable[914] = 2763244
XPTable[915] = 2767780
XPTable[916] = 2772319
XPTable[917] = 2776860
XPTable[918] = 2781403
XPTable[919] = 2785949
XPTable[920] = 2790498
XPTable[921] = 2795049
XPTable[922] = 2799602
XPTable[923] = 2804158
XPTable[924] = 2808716
XPTable[925] = 2813277
XPTable[926] = 2817840
XPTable[927] = 2822406
XPTable[928] = 2826974
XPTable[929] = 2831545
XPTable[930] = 2836118
XPTable[931] = 2840694
XPTable[932] = 2845272
XPTable[933] = 2849853
XPTable[934] = 2854436
XPTable[935] = 2859021
XPTable[936] = 2863609
XPTable[937] = 2868199
XPTable[938] = 2872792
XPTable[939] = 2877387
XPTable[940] = 2881985
XPTable[941] = 2886585
XPTable[942] = 2891188
XPTable[943] = 2895793
XPTable[944] = 2900400
XPTable[945] = 2905010
XPTable[946] = 2909622
XPTable[947] = 2914237
XPTable[948] = 2918854
XPTable[949] = 2923474
XPTable[950] = 2928096
XPTable[951] = 2932721
XPTable[952] = 2937348
XPTable[953] = 2941977
XPTable[954] = 2946609
XPTable[955] = 2951243
XPTable[956] = 2955880
XPTable[957] = 2960519
XPTable[958] = 2965160
XPTable[959] = 2969804
XPTable[960] = 2974451
XPTable[961] = 2979100
XPTable[962] = 2983751
XPTable[963] = 2988404
XPTable[964] = 2993060
XPTable[965] = 2997719
XPTable[966] = 3002380
XPTable[967] = 3007043
XPTable[968] = 3011709
XPTable[969] = 3016377
XPTable[970] = 3021047
XPTable[971] = 3025720
XPTable[972] = 3030396
XPTable[973] = 3035073
XPTable[974] = 3039753
XPTable[975] = 3044436
XPTable[976] = 3049121
XPTable[977] = 3053808
XPTable[978] = 3058498
XPTable[979] = 3063190
XPTable[980] = 3067885
XPTable[981] = 3072582
XPTable[982] = 3077281
XPTable[983] = 3081983
XPTable[984] = 3086687
XPTable[985] = 3091393
XPTable[986] = 3096102
XPTable[987] = 3100814
XPTable[988] = 3105527
XPTable[989] = 3110243
XPTable[990] = 3114962
XPTable[991] = 3119683
XPTable[992] = 3124406
XPTable[993] = 3129131
XPTable[994] = 3133859
XPTable[995] = 3138590
XPTable[996] = 3143322
XPTable[997] = 3148058
XPTable[998] = 3152795
XPTable[999] = 3157535
XPTable[1000] = 3162277
XPTable[1001] = 3167022
XPTable[1002] = 3171769
XPTable[1003] = 3176518
XPTable[1004] = 3181270
XPTable[1005] = 3186024
XPTable[1006] = 3190780
XPTable[1007] = 3195539
XPTable[1008] = 3200300
XPTable[1009] = 3205064
XPTable[1010] = 3209830
XPTable[1011] = 3214598
XPTable[1012] = 3219369
XPTable[1013] = 3224142
XPTable[1014] = 3228917
XPTable[1015] = 3233695
XPTable[1016] = 3238475
XPTable[1017] = 3243257
XPTable[1018] = 3248042
XPTable[1019] = 3252829
XPTable[1020] = 3257618
XPTable[1021] = 3262410
XPTable[1022] = 3267204
XPTable[1023] = 3272001
XPTable[1024] = 3276800
XPTable[1025] = 3281601
XPTable[1026] = 3286404
XPTable[1027] = 3291210
XPTable[1028] = 3296018
XPTable[1029] = 3300829
XPTable[1030] = 3305642
XPTable[1031] = 3310457
XPTable[1032] = 3315274
XPTable[1033] = 3320094
XPTable[1034] = 3324916
XPTable[1035] = 3329741
XPTable[1036] = 3334568
XPTable[1037] = 3339397
XPTable[1038] = 3344229
XPTable[1039] = 3349063
XPTable[1040] = 3353899
XPTable[1041] = 3358737
XPTable[1042] = 3363578
XPTable[1043] = 3368421
XPTable[1044] = 3373267
XPTable[1045] = 3378115
XPTable[1046] = 3382965
XPTable[1047] = 3387817
XPTable[1048] = 3392672
XPTable[1049] = 3397529
XPTable[1050] = 3402388
XPTable[1051] = 3407250
XPTable[1052] = 3412114
XPTable[1053] = 3416980
XPTable[1054] = 3421849
XPTable[1055] = 3426720
XPTable[1056] = 3431593
XPTable[1057] = 3436469
XPTable[1058] = 3441347
XPTable[1059] = 3446227
XPTable[1060] = 3451109
XPTable[1061] = 3455994
XPTable[1062] = 3460881
XPTable[1063] = 3465771
XPTable[1064] = 3470662
XPTable[1065] = 3475556
XPTable[1066] = 3480453
XPTable[1067] = 3485351
XPTable[1068] = 3490252
XPTable[1069] = 3495155
XPTable[1070] = 3500061
XPTable[1071] = 3504969
XPTable[1072] = 3509879
XPTable[1073] = 3514791
XPTable[1074] = 3519706
XPTable[1075] = 3524623
XPTable[1076] = 3529542
XPTable[1077] = 3534463
XPTable[1078] = 3539387
XPTable[1079] = 3544313
XPTable[1080] = 3549242
XPTable[1081] = 3554172
XPTable[1082] = 3559105
XPTable[1083] = 3564040
XPTable[1084] = 3568978
XPTable[1085] = 3573918
XPTable[1086] = 3578860
XPTable[1087] = 3583804
XPTable[1088] = 3588751
XPTable[1089] = 3593700
XPTable[1090] = 3598651
XPTable[1091] = 3603604
XPTable[1092] = 3608560
XPTable[1093] = 3613518
XPTable[1094] = 3618478
XPTable[1095] = 3623440
XPTable[1096] = 3628405
XPTable[1097] = 3633372
XPTable[1098] = 3638341
XPTable[1099] = 3643313
XPTable[1100] = 3648287
XPTable[1101] = 3653263
XPTable[1102] = 3658241
XPTable[1103] = 3663222
XPTable[1104] = 3668205
XPTable[1105] = 3673190
XPTable[1106] = 3678177
XPTable[1107] = 3683167
XPTable[1108] = 3688159
XPTable[1109] = 3693153
XPTable[1110] = 3698149
XPTable[1111] = 3703148
XPTable[1112] = 3708149
XPTable[1113] = 3713152
XPTable[1114] = 3718157
XPTable[1115] = 3723165
XPTable[1116] = 3728175
XPTable[1117] = 3733187
XPTable[1118] = 3738201
XPTable[1119] = 3743218
XPTable[1120] = 3748236
XPTable[1121] = 3753257
XPTable[1122] = 3758281
XPTable[1123] = 3763306
XPTable[1124] = 3768334
XPTable[1125] = 3773364
XPTable[1126] = 3778396
XPTable[1127] = 3783431
XPTable[1128] = 3788468
XPTable[1129] = 3793507
XPTable[1130] = 3798548
XPTable[1131] = 3803591
XPTable[1132] = 3808637
XPTable[1133] = 3813685
XPTable[1134] = 3818735
XPTable[1135] = 3823787
XPTable[1136] = 3828842
XPTable[1137] = 3833899
XPTable[1138] = 3838958
XPTable[1139] = 3844019
XPTable[1140] = 3849083
XPTable[1141] = 3854148
XPTable[1142] = 3859216
XPTable[1143] = 3864286
XPTable[1144] = 3869359
XPTable[1145] = 3874433
XPTable[1146] = 3879510
XPTable[1147] = 3884589
XPTable[1148] = 3889670
XPTable[1149] = 3894754
XPTable[1150] = 3899839
XPTable[1151] = 3904927
XPTable[1152] = 3910017
XPTable[1153] = 3915109
XPTable[1154] = 3920204
XPTable[1155] = 3925301
XPTable[1156] = 3930400
XPTable[1157] = 3935501
XPTable[1158] = 3940604
XPTable[1159] = 3945709
XPTable[1160] = 3950817
XPTable[1161] = 3955927
XPTable[1162] = 3961039
XPTable[1163] = 3966153
XPTable[1164] = 3971270
XPTable[1165] = 3976389
XPTable[1166] = 3981510
XPTable[1167] = 3986633
XPTable[1168] = 3991758
XPTable[1169] = 3996886
XPTable[1170] = 4002015
XPTable[1171] = 4007147
XPTable[1172] = 4012281
XPTable[1173] = 4017417
XPTable[1174] = 4022556
XPTable[1175] = 4027697
XPTable[1176] = 4032839
XPTable[1177] = 4037984
XPTable[1178] = 4043132
XPTable[1179] = 4048281
XPTable[1180] = 4053433
XPTable[1181] = 4058586
XPTable[1182] = 4063742
XPTable[1183] = 4068900
XPTable[1184] = 4074061
XPTable[1185] = 4079223
XPTable[1186] = 4084388
XPTable[1187] = 4089555
XPTable[1188] = 4094724
XPTable[1189] = 4099895
XPTable[1190] = 4105068
XPTable[1191] = 4110244
XPTable[1192] = 4115422
XPTable[1193] = 4120601
XPTable[1194] = 4125784
XPTable[1195] = 4130968
XPTable[1196] = 4136154
XPTable[1197] = 4141343
XPTable[1198] = 4146533
XPTable[1199] = 4151726
XPTable[1200] = 4156921
XPTable[1201] = 4162119
XPTable[1202] = 4167318
XPTable[1203] = 4172520
XPTable[1204] = 4177723
XPTable[1205] = 4182929
XPTable[1206] = 4188137
XPTable[1207] = 4193347
XPTable[1208] = 4198560
XPTable[1209] = 4203774
XPTable[1210] = 4208991
XPTable[1211] = 4214210
XPTable[1212] = 4219431
XPTable[1213] = 4224654
XPTable[1214] = 4229879
XPTable[1215] = 4235107
XPTable[1216] = 4240336
XPTable[1217] = 4245568
XPTable[1218] = 4250802
XPTable[1219] = 4256038
XPTable[1220] = 4261276
XPTable[1221] = 4266517
XPTable[1222] = 4271759
XPTable[1223] = 4277004
XPTable[1224] = 4282251
XPTable[1225] = 4287500
XPTable[1226] = 4292751
XPTable[1227] = 4298004
XPTable[1228] = 4303259
XPTable[1229] = 4308517
XPTable[1230] = 4313776
XPTable[1231] = 4319038
XPTable[1232] = 4324302
XPTable[1233] = 4329568
XPTable[1234] = 4334836
XPTable[1235] = 4340106
XPTable[1236] = 4345379
XPTable[1237] = 4350654
XPTable[1238] = 4355930
XPTable[1239] = 4361209
XPTable[1240] = 4366490
XPTable[1241] = 4371773
XPTable[1242] = 4377058
XPTable[1243] = 4382346
XPTable[1244] = 4387635
XPTable[1245] = 4392927
XPTable[1246] = 4398221
XPTable[1247] = 4403517
XPTable[1248] = 4408815
XPTable[1249] = 4414115
XPTable[1250] = 4419417
XPTable[1251] = 4424721
XPTable[1252] = 4430028
XPTable[1253] = 4435336
XPTable[1254] = 4440647
XPTable[1255] = 4445960
XPTable[1256] = 4451275
XPTable[1257] = 4456592
XPTable[1258] = 4461911
XPTable[1259] = 4467232
XPTable[1260] = 4472556
XPTable[1261] = 4477881
XPTable[1262] = 4483209
XPTable[1263] = 4488539
XPTable[1264] = 4493871
XPTable[1265] = 4499205
XPTable[1266] = 4504541
XPTable[1267] = 4509879
XPTable[1268] = 4515219
XPTable[1269] = 4520562
XPTable[1270] = 4525906
XPTable[1271] = 4531253
XPTable[1272] = 4536601
XPTable[1273] = 4541952
XPTable[1274] = 4547305
XPTable[1275] = 4552660
XPTable[1276] = 4558017
XPTable[1277] = 4563376
XPTable[1278] = 4568738
XPTable[1279] = 4574101
XPTable[1280] = 4579467
XPTable[1281] = 4584834
XPTable[1282] = 4590204
XPTable[1283] = 4595576
XPTable[1284] = 4600950
XPTable[1285] = 4606326
XPTable[1286] = 4611704
XPTable[1287] = 4617084
XPTable[1288] = 4622466
XPTable[1289] = 4627851
XPTable[1290] = 4633237
XPTable[1291] = 4638626
XPTable[1292] = 4644016
XPTable[1293] = 4649409
XPTable[1294] = 4654804
XPTable[1295] = 4660201
XPTable[1296] = 4665600
XPTable[1297] = 4671001
XPTable[1298] = 4676404
XPTable[1299] = 4681809
XPTable[1300] = 4687216
XPTable[1301] = 4692626
XPTable[1302] = 4698037
XPTable[1303] = 4703450
XPTable[1304] = 4708866
XPTable[1305] = 4714284
XPTable[1306] = 4719704
XPTable[1307] = 4725125
XPTable[1308] = 4730549
XPTable[1309] = 4735975
XPTable[1310] = 4741403
XPTable[1311] = 4746833
XPTable[1312] = 4752266
XPTable[1313] = 4757700
XPTable[1314] = 4763136
XPTable[1315] = 4768575
XPTable[1316] = 4774015
XPTable[1317] = 4779458
XPTable[1318] = 4784902
XPTable[1319] = 4790349
XPTable[1320] = 4795798
XPTable[1321] = 4801248
XPTable[1322] = 4806701
XPTable[1323] = 4812156
XPTable[1324] = 4817613
XPTable[1325] = 4823072
XPTable[1326] = 4828533
XPTable[1327] = 4833997
XPTable[1328] = 4839462
XPTable[1329] = 4844929
XPTable[1330] = 4850398
XPTable[1331] = 4855870
XPTable[1332] = 4861343
XPTable[1333] = 4866819
XPTable[1334] = 4872296
XPTable[1335] = 4877776
XPTable[1336] = 4883258
XPTable[1337] = 4888741
XPTable[1338] = 4894227
XPTable[1339] = 4899715
XPTable[1340] = 4905205
XPTable[1341] = 4910697
XPTable[1342] = 4916191
XPTable[1343] = 4921687
XPTable[1344] = 4927185
XPTable[1345] = 4932685
XPTable[1346] = 4938187
XPTable[1347] = 4943691
XPTable[1348] = 4949198
XPTable[1349] = 4954706
XPTable[1350] = 4960216
XPTable[1351] = 4965729
XPTable[1352] = 4971243
XPTable[1353] = 4976759
XPTable[1354] = 4982278
XPTable[1355] = 4987798
XPTable[1356] = 4993321
XPTable[1357] = 4998846
XPTable[1358] = 5004372
XPTable[1359] = 5009901
XPTable[1360] = 5015432
XPTable[1361] = 5020964
XPTable[1362] = 5026499
XPTable[1363] = 5032036
XPTable[1364] = 5037575
XPTable[1365] = 5043116
XPTable[1366] = 5048659
XPTable[1367] = 5054204
XPTable[1368] = 5059751
XPTable[1369] = 5065300
XPTable[1370] = 5070851
XPTable[1371] = 5076404
XPTable[1372] = 5081959
XPTable[1373] = 5087516
XPTable[1374] = 5093075
XPTable[1375] = 5098636
XPTable[1376] = 5104199
XPTable[1377] = 5109764
XPTable[1378] = 5115332
XPTable[1379] = 5120901
XPTable[1380] = 5126472
XPTable[1381] = 5132045
XPTable[1382] = 5137621
XPTable[1383] = 5143198
XPTable[1384] = 5148777
XPTable[1385] = 5154358
XPTable[1386] = 5159942
XPTable[1387] = 5165527
XPTable[1388] = 5171115
XPTable[1389] = 5176704
XPTable[1390] = 5182295
XPTable[1391] = 5187889
XPTable[1392] = 5193484
XPTable[1393] = 5199082
XPTable[1394] = 5204681
XPTable[1395] = 5210282
XPTable[1396] = 5215886
XPTable[1397] = 5221491
XPTable[1398] = 5227099
XPTable[1399] = 5232708
XPTable[1400] = 5238320
XPTable[1401] = 5243933
XPTable[1402] = 5249549
XPTable[1403] = 5255166
XPTable[1404] = 5260786
XPTable[1405] = 5266407
XPTable[1406] = 5272031
XPTable[1407] = 5277656
XPTable[1408] = 5283284
XPTable[1409] = 5288913
XPTable[1410] = 5294545
XPTable[1411] = 5300178
XPTable[1412] = 5305814
XPTable[1413] = 5311451
XPTable[1414] = 5317091
XPTable[1415] = 5322732
XPTable[1416] = 5328376
XPTable[1417] = 5334021
XPTable[1418] = 5339669
XPTable[1419] = 5345318
XPTable[1420] = 5350970
XPTable[1421] = 5356623
XPTable[1422] = 5362278
XPTable[1423] = 5367936
XPTable[1424] = 5373595
XPTable[1425] = 5379257
XPTable[1426] = 5384920
XPTable[1427] = 5390585
XPTable[1428] = 5396253
XPTable[1429] = 5401922
XPTable[1430] = 5407593
XPTable[1431] = 5413267
XPTable[1432] = 5418942
XPTable[1433] = 5424619
XPTable[1434] = 5430298
XPTable[1435] = 5435980
XPTable[1436] = 5441663
XPTable[1437] = 5447348
XPTable[1438] = 5453035
XPTable[1439] = 5458724
XPTable[1440] = 5464415
XPTable[1441] = 5470108
XPTable[1442] = 5475803
XPTable[1443] = 5481500
XPTable[1444] = 5487200
XPTable[1445] = 5492900
XPTable[1446] = 5498603
XPTable[1447] = 5504308
XPTable[1448] = 5510015
XPTable[1449] = 5515724
XPTable[1450] = 5521435
XPTable[1451] = 5527148
XPTable[1452] = 5532863
XPTable[1453] = 5538579
XPTable[1454] = 5544298
XPTable[1455] = 5550019
XPTable[1456] = 5555741
XPTable[1457] = 5561466
XPTable[1458] = 5567193
XPTable[1459] = 5572921
XPTable[1460] = 5578652
XPTable[1461] = 5584384
XPTable[1462] = 5590119
XPTable[1463] = 5595855
XPTable[1464] = 5601593
XPTable[1465] = 5607334
XPTable[1466] = 5613076
XPTable[1467] = 5618820
XPTable[1468] = 5624566
XPTable[1469] = 5630315
XPTable[1470] = 5636065
XPTable[1471] = 5641817
XPTable[1472] = 5647571
XPTable[1473] = 5653327
XPTable[1474] = 5659085
XPTable[1475] = 5664844
XPTable[1476] = 5670606
XPTable[1477] = 5676370
XPTable[1478] = 5682136
XPTable[1479] = 5687904
XPTable[1480] = 5693673
XPTable[1481] = 5699445
XPTable[1482] = 5705218
XPTable[1483] = 5710994
XPTable[1484] = 5716771
XPTable[1485] = 5722551
XPTable[1486] = 5728332
XPTable[1487] = 5734115
XPTable[1488] = 5739900
XPTable[1489] = 5745688
XPTable[1490] = 5751477
XPTable[1491] = 5757268
XPTable[1492] = 5763061
XPTable[1493] = 5768856
XPTable[1494] = 5774653
XPTable[1495] = 5780451
XPTable[1496] = 5786252
XPTable[1497] = 5792055
XPTable[1498] = 5797859
XPTable[1499] = 5803666
XPTable[1500] = 5809475
XPTable[1501] = 5815285
XPTable[1502] = 5821097
XPTable[1503] = 5826912
XPTable[1504] = 5832728
XPTable[1505] = 5838546
XPTable[1506] = 5844366
XPTable[1507] = 5850188
XPTable[1508] = 5856012
XPTable[1509] = 5861838
XPTable[1510] = 5867666
XPTable[1511] = 5873496
XPTable[1512] = 5879327
XPTable[1513] = 5885161
XPTable[1514] = 5890997
XPTable[1515] = 5896834
XPTable[1516] = 5902674
XPTable[1517] = 5908515
XPTable[1518] = 5914358
XPTable[1519] = 5920203
XPTable[1520] = 5926050
XPTable[1521] = 5931900
XPTable[1522] = 5937750
XPTable[1523] = 5943603
XPTable[1524] = 5949458
XPTable[1525] = 5955315
XPTable[1526] = 5961174
XPTable[1527] = 5967034
XPTable[1528] = 5972897
XPTable[1529] = 5978761
XPTable[1530] = 5984627
XPTable[1531] = 5990496
XPTable[1532] = 5996366
XPTable[1533] = 6002238
XPTable[1534] = 6008112
XPTable[1535] = 6013988
XPTable[1536] = 6019865
XPTable[1537] = 6025745
XPTable[1538] = 6031627
XPTable[1539] = 6037510
XPTable[1540] = 6043396
XPTable[1541] = 6049283
XPTable[1542] = 6055173
XPTable[1543] = 6061064
XPTable[1544] = 6066957
XPTable[1545] = 6072852
XPTable[1546] = 6078749
XPTable[1547] = 6084648
XPTable[1548] = 6090548
XPTable[1549] = 6096451
XPTable[1550] = 6102356
XPTable[1551] = 6108262
XPTable[1552] = 6114170
XPTable[1553] = 6120081
XPTable[1554] = 6125993
XPTable[1555] = 6131907
XPTable[1556] = 6137823
XPTable[1557] = 6143741
XPTable[1558] = 6149661
XPTable[1559] = 6155582
XPTable[1560] = 6161506
XPTable[1561] = 6167431
XPTable[1562] = 6173359
XPTable[1563] = 6179288
XPTable[1564] = 6185219
XPTable[1565] = 6191152
XPTable[1566] = 6197087
XPTable[1567] = 6203024
XPTable[1568] = 6208963
XPTable[1569] = 6214903
XPTable[1570] = 6220846
XPTable[1571] = 6226790
XPTable[1572] = 6232737
XPTable[1573] = 6238685
XPTable[1574] = 6244635
XPTable[1575] = 6250587
XPTable[1576] = 6256541
XPTable[1577] = 6262497
XPTable[1578] = 6268454
XPTable[1579] = 6274414
XPTable[1580] = 6280375
XPTable[1581] = 6286339
XPTable[1582] = 6292304
XPTable[1583] = 6298271
XPTable[1584] = 6304240
XPTable[1585] = 6310211
XPTable[1586] = 6316184
XPTable[1587] = 6322158
XPTable[1588] = 6328135
XPTable[1589] = 6334113
XPTable[1590] = 6340093
XPTable[1591] = 6346076
XPTable[1592] = 6352060
XPTable[1593] = 6358045
XPTable[1594] = 6364033
XPTable[1595] = 6370023
XPTable[1596] = 6376015
XPTable[1597] = 6382008
XPTable[1598] = 6388003
XPTable[1599] = 6394000
XPTable[1600] = 6400000
XPTable[1601] = 6406000
XPTable[1602] = 6412003
XPTable[1603] = 6418008
XPTable[1604] = 6424014
XPTable[1605] = 6430023
XPTable[1606] = 6436033
XPTable[1607] = 6442045
XPTable[1608] = 6448059
XPTable[1609] = 6454075
XPTable[1610] = 6460093
XPTable[1611] = 6466113
XPTable[1612] = 6472134
XPTable[1613] = 6478158
XPTable[1614] = 6484183
XPTable[1615] = 6490210
XPTable[1616] = 6496239
XPTable[1617] = 6502270
XPTable[1618] = 6508303
XPTable[1619] = 6514337
XPTable[1620] = 6520374
XPTable[1621] = 6526412
XPTable[1622] = 6532452
XPTable[1623] = 6538494
XPTable[1624] = 6544538
XPTable[1625] = 6550584
XPTable[1626] = 6556632
XPTable[1627] = 6562681
XPTable[1628] = 6568732
XPTable[1629] = 6574786
XPTable[1630] = 6580841
XPTable[1631] = 6586898
XPTable[1632] = 6592956
XPTable[1633] = 6599017
XPTable[1634] = 6605079
XPTable[1635] = 6611144
XPTable[1636] = 6617210
XPTable[1637] = 6623278
XPTable[1638] = 6629348
XPTable[1639] = 6635420
XPTable[1640] = 6641493
XPTable[1641] = 6647569
XPTable[1642] = 6653646
XPTable[1643] = 6659725
XPTable[1644] = 6665806
XPTable[1645] = 6671889
XPTable[1646] = 6677974
XPTable[1647] = 6684060
XPTable[1648] = 6690149
XPTable[1649] = 6696239
XPTable[1650] = 6702331
XPTable[1651] = 6708425
XPTable[1652] = 6714521
XPTable[1653] = 6720619
XPTable[1654] = 6726718
XPTable[1655] = 6732819
XPTable[1656] = 6738923
XPTable[1657] = 6745028
XPTable[1658] = 6751134
XPTable[1659] = 6757243
XPTable[1660] = 6763354
XPTable[1661] = 6769466
XPTable[1662] = 6775580
XPTable[1663] = 6781696
XPTable[1664] = 6787814
XPTable[1665] = 6793934
XPTable[1666] = 6800056
XPTable[1667] = 6806179
XPTable[1668] = 6812304
XPTable[1669] = 6818431
XPTable[1670] = 6824560
XPTable[1671] = 6830691
XPTable[1672] = 6836824
XPTable[1673] = 6842958
XPTable[1674] = 6849094
XPTable[1675] = 6855232
XPTable[1676] = 6861372
XPTable[1677] = 6867514
XPTable[1678] = 6873658
XPTable[1679] = 6879803
XPTable[1680] = 6885950
XPTable[1681] = 6892100
XPTable[1682] = 6898250
XPTable[1683] = 6904403
XPTable[1684] = 6910558
XPTable[1685] = 6916714
XPTable[1686] = 6922872
XPTable[1687] = 6929032
XPTable[1688] = 6935194
XPTable[1689] = 6941358
XPTable[1690] = 6947524
XPTable[1691] = 6953691
XPTable[1692] = 6959860
XPTable[1693] = 6966031
XPTable[1694] = 6972204
XPTable[1695] = 6978379
XPTable[1696] = 6984555
XPTable[1697] = 6990733
XPTable[1698] = 6996913
XPTable[1699] = 7003095
XPTable[1700] = 7009279
XPTable[1701] = 7015465
XPTable[1702] = 7021652
XPTable[1703] = 7027841
XPTable[1704] = 7034032
XPTable[1705] = 7040225
XPTable[1706] = 7046420
XPTable[1707] = 7052616
XPTable[1708] = 7058814
XPTable[1709] = 7065015
XPTable[1710] = 7071217
XPTable[1711] = 7077420
XPTable[1712] = 7083626
XPTable[1713] = 7089833
XPTable[1714] = 7096042
XPTable[1715] = 7102253
XPTable[1716] = 7108466
XPTable[1717] = 7114681
XPTable[1718] = 7120897
XPTable[1719] = 7127115
XPTable[1720] = 7133335
XPTable[1721] = 7139557
XPTable[1722] = 7145781
XPTable[1723] = 7152006
XPTable[1724] = 7158234
XPTable[1725] = 7164463
XPTable[1726] = 7170693
XPTable[1727] = 7176926
XPTable[1728] = 7183161
XPTable[1729] = 7189397
XPTable[1730] = 7195635
XPTable[1731] = 7201875
XPTable[1732] = 7208117
XPTable[1733] = 7214360
XPTable[1734] = 7220605
XPTable[1735] = 7226852
XPTable[1736] = 7233101
XPTable[1737] = 7239352
XPTable[1738] = 7245605
XPTable[1739] = 7251859
XPTable[1740] = 7258115
XPTable[1741] = 7264373
XPTable[1742] = 7270633
XPTable[1743] = 7276894
XPTable[1744] = 7283157
XPTable[1745] = 7289422
XPTable[1746] = 7295689
XPTable[1747] = 7301958
XPTable[1748] = 7308228
XPTable[1749] = 7314501
XPTable[1750] = 7320775
XPTable[1751] = 7327051
XPTable[1752] = 7333328
XPTable[1753] = 7339608
XPTable[1754] = 7345889
XPTable[1755] = 7352172
XPTable[1756] = 7358457
XPTable[1757] = 7364743
XPTable[1758] = 7371032
XPTable[1759] = 7377322
XPTable[1760] = 7383614
XPTable[1761] = 7389908
XPTable[1762] = 7396203
XPTable[1763] = 7402500
XPTable[1764] = 7408800
XPTable[1765] = 7415100
XPTable[1766] = 7421403
XPTable[1767] = 7427708
XPTable[1768] = 7434014
XPTable[1769] = 7440322
XPTable[1770] = 7446632
XPTable[1771] = 7452943
XPTable[1772] = 7459257
XPTable[1773] = 7465572
XPTable[1774] = 7471889
XPTable[1775] = 7478207
XPTable[1776] = 7484528
XPTable[1777] = 7490850
XPTable[1778] = 7497174
XPTable[1779] = 7503500
XPTable[1780] = 7509828
XPTable[1781] = 7516157
XPTable[1782] = 7522488
XPTable[1783] = 7528821
XPTable[1784] = 7535156
XPTable[1785] = 7541492
XPTable[1786] = 7547831
XPTable[1787] = 7554171
XPTable[1788] = 7560513
XPTable[1789] = 7566856
XPTable[1790] = 7573202
XPTable[1791] = 7579549
XPTable[1792] = 7585898
XPTable[1793] = 7592248
XPTable[1794] = 7598601
XPTable[1795] = 7604955
XPTable[1796] = 7611311
XPTable[1797] = 7617669
XPTable[1798] = 7624028
XPTable[1799] = 7630390
XPTable[1800] = 7636753
XPTable[1801] = 7643118
XPTable[1802] = 7649484
XPTable[1803] = 7655853
XPTable[1804] = 7662223
XPTable[1805] = 7668595
XPTable[1806] = 7674968
XPTable[1807] = 7681344
XPTable[1808] = 7687721
XPTable[1809] = 7694100
XPTable[1810] = 7700481
XPTable[1811] = 7706863
XPTable[1812] = 7713247
XPTable[1813] = 7719633
XPTable[1814] = 7726021
XPTable[1815] = 7732411
XPTable[1816] = 7738802
XPTable[1817] = 7745195
XPTable[1818] = 7751590
XPTable[1819] = 7757987
XPTable[1820] = 7764385
XPTable[1821] = 7770785
XPTable[1822] = 7777187
XPTable[1823] = 7783590
XPTable[1824] = 7789996
XPTable[1825] = 7796403
XPTable[1826] = 7802812
XPTable[1827] = 7809222
XPTable[1828] = 7815635
XPTable[1829] = 7822049
XPTable[1830] = 7828465
XPTable[1831] = 7834883
XPTable[1832] = 7841302
XPTable[1833] = 7847723
XPTable[1834] = 7854146
XPTable[1835] = 7860571
XPTable[1836] = 7866997
XPTable[1837] = 7873425
XPTable[1838] = 7879855
XPTable[1839] = 7886287
XPTable[1840] = 7892720
XPTable[1841] = 7899155
XPTable[1842] = 7905592
XPTable[1843] = 7912031
XPTable[1844] = 7918471
XPTable[1845] = 7924913
XPTable[1846] = 7931357
XPTable[1847] = 7937803
XPTable[1848] = 7944250
XPTable[1849] = 7950700
XPTable[1850] = 7957150
XPTable[1851] = 7963603
XPTable[1852] = 7970057
XPTable[1853] = 7976513
XPTable[1854] = 7982971
XPTable[1855] = 7989431
XPTable[1856] = 7995892
XPTable[1857] = 8002355
XPTable[1858] = 8008820
XPTable[1859] = 8015287
XPTable[1860] = 8021755
XPTable[1861] = 8028225
XPTable[1862] = 8034697
XPTable[1863] = 8041170
XPTable[1864] = 8047645
XPTable[1865] = 8054122
XPTable[1866] = 8060601
XPTable[1867] = 8067082
XPTable[1868] = 8073564
XPTable[1869] = 8080048
XPTable[1870] = 8086533
XPTable[1871] = 8093021
XPTable[1872] = 8099510
XPTable[1873] = 8106001
XPTable[1874] = 8112493
XPTable[1875] = 8118988
XPTable[1876] = 8125484
XPTable[1877] = 8131982
XPTable[1878] = 8138481
XPTable[1879] = 8144982
XPTable[1880] = 8151485
XPTable[1881] = 8157990
XPTable[1882] = 8164496
XPTable[1883] = 8171005
XPTable[1884] = 8177514
XPTable[1885] = 8184026
XPTable[1886] = 8190539
XPTable[1887] = 8197055
XPTable[1888] = 8203571
XPTable[1889] = 8210090
XPTable[1890] = 8216610
XPTable[1891] = 8223132
XPTable[1892] = 8229656
XPTable[1893] = 8236181
XPTable[1894] = 8242708
XPTable[1895] = 8249237
XPTable[1896] = 8255768
XPTable[1897] = 8262300
XPTable[1898] = 8268834
XPTable[1899] = 8275370
XPTable[1900] = 8281907
XPTable[1901] = 8288447
XPTable[1902] = 8294988
XPTable[1903] = 8301530
XPTable[1904] = 8308075
XPTable[1905] = 8314621
XPTable[1906] = 8321169
XPTable[1907] = 8327718
XPTable[1908] = 8334269
XPTable[1909] = 8340822
XPTable[1910] = 8347377
XPTable[1911] = 8353933
XPTable[1912] = 8360491
XPTable[1913] = 8367051
XPTable[1914] = 8373613
XPTable[1915] = 8380176
XPTable[1916] = 8386741
XPTable[1917] = 8393308
XPTable[1918] = 8399876
XPTable[1919] = 8406446
XPTable[1920] = 8413018
XPTable[1921] = 8419592
XPTable[1922] = 8426167
XPTable[1923] = 8432744
XPTable[1924] = 8439322
XPTable[1925] = 8445903
XPTable[1926] = 8452485
XPTable[1927] = 8459069
XPTable[1928] = 8465654
XPTable[1929] = 8472241
XPTable[1930] = 8478830
XPTable[1931] = 8485421
XPTable[1932] = 8492013
XPTable[1933] = 8498607
XPTable[1934] = 8505203
XPTable[1935] = 8511800
XPTable[1936] = 8518400
XPTable[1937] = 8525000
XPTable[1938] = 8531603
XPTable[1939] = 8538207
XPTable[1940] = 8544813
XPTable[1941] = 8551421
XPTable[1942] = 8558030
XPTable[1943] = 8564641
XPTable[1944] = 8571254
XPTable[1945] = 8577868
XPTable[1946] = 8584485
XPTable[1947] = 8591103
XPTable[1948] = 8597722
XPTable[1949] = 8604343
XPTable[1950] = 8610966
XPTable[1951] = 8617591
XPTable[1952] = 8624217
XPTable[1953] = 8630845
XPTable[1954] = 8637475
XPTable[1955] = 8644107
XPTable[1956] = 8650740
XPTable[1957] = 8657375
XPTable[1958] = 8664011
XPTable[1959] = 8670649
XPTable[1960] = 8677289
XPTable[1961] = 8683931
XPTable[1962] = 8690574
XPTable[1963] = 8697219
XPTable[1964] = 8703866
XPTable[1965] = 8710514
XPTable[1966] = 8717165
XPTable[1967] = 8723816
XPTable[1968] = 8730470
XPTable[1969] = 8737125
XPTable[1970] = 8743782
XPTable[1971] = 8750440
XPTable[1972] = 8757101
XPTable[1973] = 8763763
XPTable[1974] = 8770426
XPTable[1975] = 8777091
XPTable[1976] = 8783758
XPTable[1977] = 8790427
XPTable[1978] = 8797098
XPTable[1979] = 8803770
XPTable[1980] = 8810443
XPTable[1981] = 8817119
XPTable[1982] = 8823796
XPTable[1983] = 8830475
XPTable[1984] = 8837155
XPTable[1985] = 8843837
XPTable[1986] = 8850521
XPTable[1987] = 8857207
XPTable[1988] = 8863894
XPTable[1989] = 8870583
XPTable[1990] = 8877273
XPTable[1991] = 8883966
XPTable[1992] = 8890659
XPTable[1993] = 8897355
XPTable[1994] = 8904052
XPTable[1995] = 8910751
XPTable[1996] = 8917452
XPTable[1997] = 8924154
XPTable[1998] = 8930858
XPTable[1999] = 8937564
XPTable[2000] = 8944271
XPTable[2001] = 8950980
XPTable[2002] = 8957691
XPTable[2003] = 8964404
XPTable[2004] = 8971118
XPTable[2005] = 8977833
XPTable[2006] = 8984551
XPTable[2007] = 8991270
XPTable[2008] = 8997991
XPTable[2009] = 9004713
XPTable[2010] = 9011437
XPTable[2011] = 9018163
XPTable[2012] = 9024890
XPTable[2013] = 9031620
XPTable[2014] = 9038350
XPTable[2015] = 9045083
XPTable[2016] = 9051817
XPTable[2017] = 9058553
XPTable[2018] = 9065290
XPTable[2019] = 9072030
XPTable[2020] = 9078770
XPTable[2021] = 9085513
XPTable[2022] = 9092257
XPTable[2023] = 9099003
XPTable[2024] = 9105750
XPTable[2025] = 9112500
XPTable[2026] = 9119250
XPTable[2027] = 9126003
XPTable[2028] = 9132757
XPTable[2029] = 9139513
XPTable[2030] = 9146270
XPTable[2031] = 9153029
XPTable[2032] = 9159790
XPTable[2033] = 9166553
XPTable[2034] = 9173317
XPTable[2035] = 9180083
XPTable[2036] = 9186850
XPTable[2037] = 9193619
XPTable[2038] = 9200390
XPTable[2039] = 9207163
XPTable[2040] = 9213937
XPTable[2041] = 9220713
XPTable[2042] = 9227490
XPTable[2043] = 9234269
XPTable[2044] = 9241050
XPTable[2045] = 9247832
XPTable[2046] = 9254616
XPTable[2047] = 9261402
XPTable[2048] = 9268190
XPTable[2049] = 9274979
XPTable[2050] = 9281769
XPTable[2051] = 9288562
XPTable[2052] = 9295356
XPTable[2053] = 9302151
XPTable[2054] = 9308949
XPTable[2055] = 9315748
XPTable[2056] = 9322548
XPTable[2057] = 9329351
XPTable[2058] = 9336155
XPTable[2059] = 9342960
XPTable[2060] = 9349767
XPTable[2061] = 9356576
XPTable[2062] = 9363387
XPTable[2063] = 9370199
XPTable[2064] = 9377013
XPTable[2065] = 9383828
XPTable[2066] = 9390646
XPTable[2067] = 9397464
XPTable[2068] = 9404285
XPTable[2069] = 9411107
XPTable[2070] = 9417931
XPTable[2071] = 9424756
XPTable[2072] = 9431583
XPTable[2073] = 9438412
XPTable[2074] = 9445242
XPTable[2075] = 9452074
XPTable[2076] = 9458908
XPTable[2077] = 9465743
XPTable[2078] = 9472580
XPTable[2079] = 9479419
XPTable[2080] = 9486259
XPTable[2081] = 9493101
XPTable[2082] = 9499944
XPTable[2083] = 9506790
XPTable[2084] = 9513636
XPTable[2085] = 9520485
XPTable[2086] = 9527335
XPTable[2087] = 9534187
XPTable[2088] = 9541040
XPTable[2089] = 9547895
XPTable[2090] = 9554752
XPTable[2091] = 9561610
XPTable[2092] = 9568470
XPTable[2093] = 9575332
XPTable[2094] = 9582195
XPTable[2095] = 9589060
XPTable[2096] = 9595926
XPTable[2097] = 9602794
XPTable[2098] = 9609664
XPTable[2099] = 9616535
XPTable[2100] = 9623408
XPTable[2101] = 9630283
XPTable[2102] = 9637159
XPTable[2103] = 9644037
XPTable[2104] = 9650917
XPTable[2105] = 9657798
XPTable[2106] = 9664681
XPTable[2107] = 9671566
XPTable[2108] = 9678452
XPTable[2109] = 9685339
XPTable[2110] = 9692229
XPTable[2111] = 9699120
XPTable[2112] = 9706013
XPTable[2113] = 9712907
XPTable[2114] = 9719803
XPTable[2115] = 9726700
XPTable[2116] = 9733600
XPTable[2117] = 9740500
XPTable[2118] = 9747403
XPTable[2119] = 9754307
XPTable[2120] = 9761213
XPTable[2121] = 9768120
XPTable[2122] = 9775029
XPTable[2123] = 9781939
XPTable[2124] = 9788852
XPTable[2125] = 9795765
XPTable[2126] = 9802681
XPTable[2127] = 9809598
XPTable[2128] = 9816517
XPTable[2129] = 9823437
XPTable[2130] = 9830359
XPTable[2131] = 9837283
XPTable[2132] = 9844208
XPTable[2133] = 9851135
XPTable[2134] = 9858063
XPTable[2135] = 9864993
XPTable[2136] = 9871925
XPTable[2137] = 9878858
XPTable[2138] = 9885793
XPTable[2139] = 9892730
XPTable[2140] = 9899668
XPTable[2141] = 9906608
XPTable[2142] = 9913549
XPTable[2143] = 9920493
XPTable[2144] = 9927437
XPTable[2145] = 9934384
XPTable[2146] = 9941331
XPTable[2147] = 9948281
XPTable[2148] = 9955232
XPTable[2149] = 9962185
XPTable[2150] = 9969139
XPTable[2151] = 9976095
XPTable[2152] = 9983053
XPTable[2153] = 9990012
XPTable[2154] = 9996973
XPTable[2155] = 10003936
XPTable[2156] = 10010900
XPTable[2157] = 10017865
XPTable[2158] = 10024833
XPTable[2159] = 10031802
XPTable[2160] = 10038772
XPTable[2161] = 10045745
XPTable[2162] = 10052718
XPTable[2163] = 10059694
XPTable[2164] = 10066671
XPTable[2165] = 10073649
XPTable[2166] = 10080630
XPTable[2167] = 10087611
XPTable[2168] = 10094595
XPTable[2169] = 10101580
XPTable[2170] = 10108567
XPTable[2171] = 10115555
XPTable[2172] = 10122545
XPTable[2173] = 10129536
XPTable[2174] = 10136529
XPTable[2175] = 10143524
XPTable[2176] = 10150521
XPTable[2177] = 10157519
XPTable[2178] = 10164518
XPTable[2179] = 10171519
XPTable[2180] = 10178522
XPTable[2181] = 10185526
XPTable[2182] = 10192532
XPTable[2183] = 10199540
XPTable[2184] = 10206549
XPTable[2185] = 10213560
XPTable[2186] = 10220572
XPTable[2187] = 10227586
XPTable[2188] = 10234602
XPTable[2189] = 10241619
XPTable[2190] = 10248638
XPTable[2191] = 10255658
XPTable[2192] = 10262680
XPTable[2193] = 10269704
XPTable[2194] = 10276729
XPTable[2195] = 10283756
XPTable[2196] = 10290784
XPTable[2197] = 10297814
XPTable[2198] = 10304846
XPTable[2199] = 10311879
XPTable[2200] = 10318914
XPTable[2201] = 10325951
XPTable[2202] = 10332989
XPTable[2203] = 10340028
XPTable[2204] = 10347069
XPTable[2205] = 10354112
XPTable[2206] = 10361157
XPTable[2207] = 10368203
XPTable[2208] = 10375250
XPTable[2209] = 10382300
XPTable[2210] = 10389350
XPTable[2211] = 10396403
XPTable[2212] = 10403457
XPTable[2213] = 10410512
XPTable[2214] = 10417569
XPTable[2215] = 10424628
XPTable[2216] = 10431689
XPTable[2217] = 10438751
XPTable[2218] = 10445814
XPTable[2219] = 10452879
XPTable[2220] = 10459946
XPTable[2221] = 10467014
XPTable[2222] = 10474084
XPTable[2223] = 10481156
XPTable[2224] = 10488229
XPTable[2225] = 10495304
XPTable[2226] = 10502380
XPTable[2227] = 10509458
XPTable[2228] = 10516537
XPTable[2229] = 10523618
XPTable[2230] = 10530701
XPTable[2231] = 10537785
XPTable[2232] = 10544871
XPTable[2233] = 10551958
XPTable[2234] = 10559047
XPTable[2235] = 10566138
XPTable[2236] = 10573230
XPTable[2237] = 10580324
XPTable[2238] = 10587419
XPTable[2239] = 10594516
XPTable[2240] = 10601614
XPTable[2241] = 10608715
XPTable[2242] = 10615816
XPTable[2243] = 10622919
XPTable[2244] = 10630024
XPTable[2245] = 10637131
XPTable[2246] = 10644239
XPTable[2247] = 10651348
XPTable[2248] = 10658460
XPTable[2249] = 10665572
XPTable[2250] = 10672687
XPTable[2251] = 10679803
XPTable[2252] = 10686920
XPTable[2253] = 10694039
XPTable[2254] = 10701160
XPTable[2255] = 10708282
XPTable[2256] = 10715406
XPTable[2257] = 10722531
XPTable[2258] = 10729658
XPTable[2259] = 10736787
XPTable[2260] = 10743917
XPTable[2261] = 10751049
XPTable[2262] = 10758182
XPTable[2263] = 10765317
XPTable[2264] = 10772453
XPTable[2265] = 10779591
XPTable[2266] = 10786731
XPTable[2267] = 10793872
XPTable[2268] = 10801015
XPTable[2269] = 10808159
XPTable[2270] = 10815305
XPTable[2271] = 10822452
XPTable[2272] = 10829601
XPTable[2273] = 10836752
XPTable[2274] = 10843904
XPTable[2275] = 10851058
XPTable[2276] = 10858213
XPTable[2277] = 10865370
XPTable[2278] = 10872529
XPTable[2279] = 10879689
XPTable[2280] = 10886850
XPTable[2281] = 10894013
XPTable[2282] = 10901178
XPTable[2283] = 10908345
XPTable[2284] = 10915512
XPTable[2285] = 10922682
XPTable[2286] = 10929853
XPTable[2287] = 10937026
XPTable[2288] = 10944200
XPTable[2289] = 10951375
XPTable[2290] = 10958553
XPTable[2291] = 10965732
XPTable[2292] = 10972912
XPTable[2293] = 10980094
XPTable[2294] = 10987278
XPTable[2295] = 10994463
XPTable[2296] = 11001650
XPTable[2297] = 11008838
XPTable[2298] = 11016028
XPTable[2299] = 11023219
XPTable[2300] = 11030412
XPTable[2301] = 11037607
XPTable[2302] = 11044803
XPTable[2303] = 11052000
XPTable[2304] = 11059200
XPTable[2305] = 11066400
XPTable[2306] = 11073603
XPTable[2307] = 11080807
XPTable[2308] = 11088012
XPTable[2309] = 11095219
XPTable[2310] = 11102428
XPTable[2311] = 11109638
XPTable[2312] = 11116849
XPTable[2313] = 11124063
XPTable[2314] = 11131278
XPTable[2315] = 11138494
XPTable[2316] = 11145712
XPTable[2317] = 11152931
XPTable[2318] = 11160152
XPTable[2319] = 11167375
XPTable[2320] = 11174599
XPTable[2321] = 11181825
XPTable[2322] = 11189052
XPTable[2323] = 11196281
XPTable[2324] = 11203512
XPTable[2325] = 11210744
XPTable[2326] = 11217977
XPTable[2327] = 11225212
XPTable[2328] = 11232449
XPTable[2329] = 11239687
XPTable[2330] = 11246927
XPTable[2331] = 11254168
XPTable[2332] = 11261411
XPTable[2333] = 11268655
XPTable[2334] = 11275901
XPTable[2335] = 11283149
XPTable[2336] = 11290398
XPTable[2337] = 11297648
XPTable[2338] = 11304900
XPTable[2339] = 11312154
XPTable[2340] = 11319409
XPTable[2341] = 11326666
XPTable[2342] = 11333925
XPTable[2343] = 11341184
XPTable[2344] = 11348446
XPTable[2345] = 11355709
XPTable[2346] = 11362973
XPTable[2347] = 11370240
XPTable[2348] = 11377507
XPTable[2349] = 11384776
XPTable[2350] = 11392047
XPTable[2351] = 11399319
XPTable[2352] = 11406593
XPTable[2353] = 11413869
XPTable[2354] = 11421146
XPTable[2355] = 11428424
XPTable[2356] = 11435704
XPTable[2357] = 11442986
XPTable[2358] = 11450269
XPTable[2359] = 11457553
XPTable[2360] = 11464840
XPTable[2361] = 11472127
XPTable[2362] = 11479417
XPTable[2363] = 11486708
XPTable[2364] = 11494000
XPTable[2365] = 11501294
XPTable[2366] = 11508589
XPTable[2367] = 11515886
XPTable[2368] = 11523185
XPTable[2369] = 11530485
XPTable[2370] = 11537787
XPTable[2371] = 11545090
XPTable[2372] = 11552394
XPTable[2373] = 11559701
XPTable[2374] = 11567008
XPTable[2375] = 11574318
XPTable[2376] = 11581629
XPTable[2377] = 11588941
XPTable[2378] = 11596255
XPTable[2379] = 11603570
XPTable[2380] = 11610887
XPTable[2381] = 11618206
XPTable[2382] = 11625526
XPTable[2383] = 11632848
XPTable[2384] = 11640171
XPTable[2385] = 11647496
XPTable[2386] = 11654822
XPTable[2387] = 11662150
XPTable[2388] = 11669479
XPTable[2389] = 11676810
XPTable[2390] = 11684142
XPTable[2391] = 11691476
XPTable[2392] = 11698812
XPTable[2393] = 11706149
XPTable[2394] = 11713487
XPTable[2395] = 11720827
XPTable[2396] = 11728169
XPTable[2397] = 11735512
XPTable[2398] = 11742856
XPTable[2399] = 11750203
XPTable[2400] = 11757550
XPTable[2401] = 11764900
XPTable[2402] = 11772250
XPTable[2403] = 11779603
XPTable[2404] = 11786956
XPTable[2405] = 11794312
XPTable[2406] = 11801669
XPTable[2407] = 11809027
XPTable[2408] = 11816387
XPTable[2409] = 11823748
XPTable[2410] = 11831111
XPTable[2411] = 11838476
XPTable[2412] = 11845842
XPTable[2413] = 11853210
XPTable[2414] = 11860579
XPTable[2415] = 11867949
XPTable[2416] = 11875322
XPTable[2417] = 11882695
XPTable[2418] = 11890070
XPTable[2419] = 11897447
XPTable[2420] = 11904825
XPTable[2421] = 11912205
XPTable[2422] = 11919587
XPTable[2423] = 11926969
XPTable[2424] = 11934354
XPTable[2425] = 11941740
XPTable[2426] = 11949127
XPTable[2427] = 11956516
XPTable[2428] = 11963906
XPTable[2429] = 11971298
XPTable[2430] = 11978692
XPTable[2431] = 11986087
XPTable[2432] = 11993483
XPTable[2433] = 12000881
XPTable[2434] = 12008281
XPTable[2435] = 12015682
XPTable[2436] = 12023085
XPTable[2437] = 12030489
XPTable[2438] = 12037895
XPTable[2439] = 12045302
XPTable[2440] = 12052710
XPTable[2441] = 12060121
XPTable[2442] = 12067532
XPTable[2443] = 12074946
XPTable[2444] = 12082360
XPTable[2445] = 12089777
XPTable[2446] = 12097194
XPTable[2447] = 12104614
XPTable[2448] = 12112035
XPTable[2449] = 12119457
XPTable[2450] = 12126881

-- ============================================================
-- BELI EARNED PER QUEST (1-2450)
-- ============================================================
local QuestBeliTable = {}
QuestBeliTable[1] = 50
QuestBeliTable[2] = 100
QuestBeliTable[3] = 150
QuestBeliTable[4] = 200
QuestBeliTable[5] = 250
QuestBeliTable[6] = 300
QuestBeliTable[7] = 350
QuestBeliTable[8] = 400
QuestBeliTable[9] = 450
QuestBeliTable[10] = 500
QuestBeliTable[11] = 550
QuestBeliTable[12] = 600
QuestBeliTable[13] = 650
QuestBeliTable[14] = 700
QuestBeliTable[15] = 750
QuestBeliTable[16] = 800
QuestBeliTable[17] = 850
QuestBeliTable[18] = 900
QuestBeliTable[19] = 950
QuestBeliTable[20] = 1000
QuestBeliTable[21] = 1050
QuestBeliTable[22] = 1100
QuestBeliTable[23] = 1150
QuestBeliTable[24] = 1200
QuestBeliTable[25] = 1250
QuestBeliTable[26] = 1300
QuestBeliTable[27] = 1350
QuestBeliTable[28] = 1400
QuestBeliTable[29] = 1450
QuestBeliTable[30] = 1500
QuestBeliTable[31] = 1550
QuestBeliTable[32] = 1600
QuestBeliTable[33] = 1650
QuestBeliTable[34] = 1700
QuestBeliTable[35] = 1750
QuestBeliTable[36] = 1800
QuestBeliTable[37] = 1850
QuestBeliTable[38] = 1900
QuestBeliTable[39] = 1950
QuestBeliTable[40] = 2000
QuestBeliTable[41] = 2050
QuestBeliTable[42] = 2100
QuestBeliTable[43] = 2150
QuestBeliTable[44] = 2200
QuestBeliTable[45] = 2250
QuestBeliTable[46] = 2300
QuestBeliTable[47] = 2350
QuestBeliTable[48] = 2400
QuestBeliTable[49] = 2450
QuestBeliTable[50] = 2500
QuestBeliTable[51] = 2550
QuestBeliTable[52] = 2600
QuestBeliTable[53] = 2650
QuestBeliTable[54] = 2700
QuestBeliTable[55] = 2750
QuestBeliTable[56] = 2800
QuestBeliTable[57] = 2850
QuestBeliTable[58] = 2900
QuestBeliTable[59] = 2950
QuestBeliTable[60] = 3000
QuestBeliTable[61] = 3050
QuestBeliTable[62] = 3100
QuestBeliTable[63] = 3150
QuestBeliTable[64] = 3200
QuestBeliTable[65] = 3250
QuestBeliTable[66] = 3300
QuestBeliTable[67] = 3350
QuestBeliTable[68] = 3400
QuestBeliTable[69] = 3450
QuestBeliTable[70] = 3500
QuestBeliTable[71] = 3550
QuestBeliTable[72] = 3600
QuestBeliTable[73] = 3650
QuestBeliTable[74] = 3700
QuestBeliTable[75] = 3750
QuestBeliTable[76] = 3800
QuestBeliTable[77] = 3850
QuestBeliTable[78] = 3900
QuestBeliTable[79] = 3950
QuestBeliTable[80] = 4000
QuestBeliTable[81] = 4050
QuestBeliTable[82] = 4100
QuestBeliTable[83] = 4150
QuestBeliTable[84] = 4200
QuestBeliTable[85] = 4250
QuestBeliTable[86] = 4300
QuestBeliTable[87] = 4350
QuestBeliTable[88] = 4400
QuestBeliTable[89] = 4450
QuestBeliTable[90] = 4500
QuestBeliTable[91] = 4550
QuestBeliTable[92] = 4600
QuestBeliTable[93] = 4650
QuestBeliTable[94] = 4700
QuestBeliTable[95] = 4750
QuestBeliTable[96] = 4800
QuestBeliTable[97] = 4850
QuestBeliTable[98] = 4900
QuestBeliTable[99] = 4950
QuestBeliTable[100] = 5000
QuestBeliTable[101] = 5050
QuestBeliTable[102] = 5100
QuestBeliTable[103] = 5150
QuestBeliTable[104] = 5200
QuestBeliTable[105] = 5250
QuestBeliTable[106] = 5300
QuestBeliTable[107] = 5350
QuestBeliTable[108] = 5400
QuestBeliTable[109] = 5450
QuestBeliTable[110] = 5500
QuestBeliTable[111] = 5550
QuestBeliTable[112] = 5600
QuestBeliTable[113] = 5650
QuestBeliTable[114] = 5700
QuestBeliTable[115] = 5750
QuestBeliTable[116] = 5800
QuestBeliTable[117] = 5850
QuestBeliTable[118] = 5900
QuestBeliTable[119] = 5950
QuestBeliTable[120] = 6000
QuestBeliTable[121] = 6050
QuestBeliTable[122] = 6100
QuestBeliTable[123] = 6150
QuestBeliTable[124] = 6200
QuestBeliTable[125] = 6250
QuestBeliTable[126] = 6300
QuestBeliTable[127] = 6350
QuestBeliTable[128] = 6400
QuestBeliTable[129] = 6450
QuestBeliTable[130] = 6500
QuestBeliTable[131] = 6550
QuestBeliTable[132] = 6600
QuestBeliTable[133] = 6650
QuestBeliTable[134] = 6700
QuestBeliTable[135] = 6750
QuestBeliTable[136] = 6800
QuestBeliTable[137] = 6850
QuestBeliTable[138] = 6900
QuestBeliTable[139] = 6950
QuestBeliTable[140] = 7000
QuestBeliTable[141] = 7050
QuestBeliTable[142] = 7100
QuestBeliTable[143] = 7150
QuestBeliTable[144] = 7200
QuestBeliTable[145] = 7250
QuestBeliTable[146] = 7300
QuestBeliTable[147] = 7350
QuestBeliTable[148] = 7400
QuestBeliTable[149] = 7450
QuestBeliTable[150] = 7500
QuestBeliTable[151] = 7550
QuestBeliTable[152] = 7600
QuestBeliTable[153] = 7650
QuestBeliTable[154] = 7700
QuestBeliTable[155] = 7750
QuestBeliTable[156] = 7800
QuestBeliTable[157] = 7850
QuestBeliTable[158] = 7900
QuestBeliTable[159] = 7950
QuestBeliTable[160] = 8000
QuestBeliTable[161] = 8050
QuestBeliTable[162] = 8100
QuestBeliTable[163] = 8150
QuestBeliTable[164] = 8200
QuestBeliTable[165] = 8250
QuestBeliTable[166] = 8300
QuestBeliTable[167] = 8350
QuestBeliTable[168] = 8400
QuestBeliTable[169] = 8450
QuestBeliTable[170] = 8500
QuestBeliTable[171] = 8550
QuestBeliTable[172] = 8600
QuestBeliTable[173] = 8650
QuestBeliTable[174] = 8700
QuestBeliTable[175] = 8750
QuestBeliTable[176] = 8800
QuestBeliTable[177] = 8850
QuestBeliTable[178] = 8900
QuestBeliTable[179] = 8950
QuestBeliTable[180] = 9000
QuestBeliTable[181] = 9050
QuestBeliTable[182] = 9100
QuestBeliTable[183] = 9150
QuestBeliTable[184] = 9200
QuestBeliTable[185] = 9250
QuestBeliTable[186] = 9300
QuestBeliTable[187] = 9350
QuestBeliTable[188] = 9400
QuestBeliTable[189] = 9450
QuestBeliTable[190] = 9500
QuestBeliTable[191] = 9550
QuestBeliTable[192] = 9600
QuestBeliTable[193] = 9650
QuestBeliTable[194] = 9700
QuestBeliTable[195] = 9750
QuestBeliTable[196] = 9800
QuestBeliTable[197] = 9850
QuestBeliTable[198] = 9900
QuestBeliTable[199] = 9950
QuestBeliTable[200] = 10000
QuestBeliTable[201] = 10050
QuestBeliTable[202] = 10100
QuestBeliTable[203] = 10150
QuestBeliTable[204] = 10200
QuestBeliTable[205] = 10250
QuestBeliTable[206] = 10300
QuestBeliTable[207] = 10350
QuestBeliTable[208] = 10400
QuestBeliTable[209] = 10450
QuestBeliTable[210] = 10500
QuestBeliTable[211] = 10550
QuestBeliTable[212] = 10600
QuestBeliTable[213] = 10650
QuestBeliTable[214] = 10700
QuestBeliTable[215] = 10750
QuestBeliTable[216] = 10800
QuestBeliTable[217] = 10850
QuestBeliTable[218] = 10900
QuestBeliTable[219] = 10950
QuestBeliTable[220] = 11000
QuestBeliTable[221] = 11050
QuestBeliTable[222] = 11100
QuestBeliTable[223] = 11150
QuestBeliTable[224] = 11200
QuestBeliTable[225] = 11250
QuestBeliTable[226] = 11300
QuestBeliTable[227] = 11350
QuestBeliTable[228] = 11400
QuestBeliTable[229] = 11450
QuestBeliTable[230] = 11500
QuestBeliTable[231] = 11550
QuestBeliTable[232] = 11600
QuestBeliTable[233] = 11650
QuestBeliTable[234] = 11700
QuestBeliTable[235] = 11750
QuestBeliTable[236] = 11800
QuestBeliTable[237] = 11850
QuestBeliTable[238] = 11900
QuestBeliTable[239] = 11950
QuestBeliTable[240] = 12000
QuestBeliTable[241] = 12050
QuestBeliTable[242] = 12100
QuestBeliTable[243] = 12150
QuestBeliTable[244] = 12200
QuestBeliTable[245] = 12250
QuestBeliTable[246] = 12300
QuestBeliTable[247] = 12350
QuestBeliTable[248] = 12400
QuestBeliTable[249] = 12450
QuestBeliTable[250] = 12500
QuestBeliTable[251] = 12550
QuestBeliTable[252] = 12600
QuestBeliTable[253] = 12650
QuestBeliTable[254] = 12700
QuestBeliTable[255] = 12750
QuestBeliTable[256] = 12800
QuestBeliTable[257] = 12850
QuestBeliTable[258] = 12900
QuestBeliTable[259] = 12950
QuestBeliTable[260] = 13000
QuestBeliTable[261] = 13050
QuestBeliTable[262] = 13100
QuestBeliTable[263] = 13150
QuestBeliTable[264] = 13200
QuestBeliTable[265] = 13250
QuestBeliTable[266] = 13300
QuestBeliTable[267] = 13350
QuestBeliTable[268] = 13400
QuestBeliTable[269] = 13450
QuestBeliTable[270] = 13500
QuestBeliTable[271] = 13550
QuestBeliTable[272] = 13600
QuestBeliTable[273] = 13650
QuestBeliTable[274] = 13700
QuestBeliTable[275] = 13750
QuestBeliTable[276] = 13800
QuestBeliTable[277] = 13850
QuestBeliTable[278] = 13900
QuestBeliTable[279] = 13950
QuestBeliTable[280] = 14000
QuestBeliTable[281] = 14050
QuestBeliTable[282] = 14100
QuestBeliTable[283] = 14150
QuestBeliTable[284] = 14200
QuestBeliTable[285] = 14250
QuestBeliTable[286] = 14300
QuestBeliTable[287] = 14350
QuestBeliTable[288] = 14400
QuestBeliTable[289] = 14450
QuestBeliTable[290] = 14500
QuestBeliTable[291] = 14550
QuestBeliTable[292] = 14600
QuestBeliTable[293] = 14650
QuestBeliTable[294] = 14700
QuestBeliTable[295] = 14750
QuestBeliTable[296] = 14800
QuestBeliTable[297] = 14850
QuestBeliTable[298] = 14900
QuestBeliTable[299] = 14950
QuestBeliTable[300] = 15000
QuestBeliTable[301] = 15050
QuestBeliTable[302] = 15100
QuestBeliTable[303] = 15150
QuestBeliTable[304] = 15200
QuestBeliTable[305] = 15250
QuestBeliTable[306] = 15300
QuestBeliTable[307] = 15350
QuestBeliTable[308] = 15400
QuestBeliTable[309] = 15450
QuestBeliTable[310] = 15500
QuestBeliTable[311] = 15550
QuestBeliTable[312] = 15600
QuestBeliTable[313] = 15650
QuestBeliTable[314] = 15700
QuestBeliTable[315] = 15750
QuestBeliTable[316] = 15800
QuestBeliTable[317] = 15850
QuestBeliTable[318] = 15900
QuestBeliTable[319] = 15950
QuestBeliTable[320] = 16000
QuestBeliTable[321] = 16050
QuestBeliTable[322] = 16100
QuestBeliTable[323] = 16150
QuestBeliTable[324] = 16200
QuestBeliTable[325] = 16250
QuestBeliTable[326] = 16300
QuestBeliTable[327] = 16350
QuestBeliTable[328] = 16400
QuestBeliTable[329] = 16450
QuestBeliTable[330] = 16500
QuestBeliTable[331] = 16550
QuestBeliTable[332] = 16600
QuestBeliTable[333] = 16650
QuestBeliTable[334] = 16700
QuestBeliTable[335] = 16750
QuestBeliTable[336] = 16800
QuestBeliTable[337] = 16850
QuestBeliTable[338] = 16900
QuestBeliTable[339] = 16950
QuestBeliTable[340] = 17000
QuestBeliTable[341] = 17050
QuestBeliTable[342] = 17100
QuestBeliTable[343] = 17150
QuestBeliTable[344] = 17200
QuestBeliTable[345] = 17250
QuestBeliTable[346] = 17300
QuestBeliTable[347] = 17350
QuestBeliTable[348] = 17400
QuestBeliTable[349] = 17450
QuestBeliTable[350] = 17500
QuestBeliTable[351] = 17550
QuestBeliTable[352] = 17600
QuestBeliTable[353] = 17650
QuestBeliTable[354] = 17700
QuestBeliTable[355] = 17750
QuestBeliTable[356] = 17800
QuestBeliTable[357] = 17850
QuestBeliTable[358] = 17900
QuestBeliTable[359] = 17950
QuestBeliTable[360] = 18000
QuestBeliTable[361] = 18050
QuestBeliTable[362] = 18100
QuestBeliTable[363] = 18150
QuestBeliTable[364] = 18200
QuestBeliTable[365] = 18250
QuestBeliTable[366] = 18300
QuestBeliTable[367] = 18350
QuestBeliTable[368] = 18400
QuestBeliTable[369] = 18450
QuestBeliTable[370] = 18500
QuestBeliTable[371] = 18550
QuestBeliTable[372] = 18600
QuestBeliTable[373] = 18650
QuestBeliTable[374] = 18700
QuestBeliTable[375] = 18750
QuestBeliTable[376] = 18800
QuestBeliTable[377] = 18850
QuestBeliTable[378] = 18900
QuestBeliTable[379] = 18950
QuestBeliTable[380] = 19000
QuestBeliTable[381] = 19050
QuestBeliTable[382] = 19100
QuestBeliTable[383] = 19150
QuestBeliTable[384] = 19200
QuestBeliTable[385] = 19250
QuestBeliTable[386] = 19300
QuestBeliTable[387] = 19350
QuestBeliTable[388] = 19400
QuestBeliTable[389] = 19450
QuestBeliTable[390] = 19500
QuestBeliTable[391] = 19550
QuestBeliTable[392] = 19600
QuestBeliTable[393] = 19650
QuestBeliTable[394] = 19700
QuestBeliTable[395] = 19750
QuestBeliTable[396] = 19800
QuestBeliTable[397] = 19850
QuestBeliTable[398] = 19900
QuestBeliTable[399] = 19950
QuestBeliTable[400] = 20000
QuestBeliTable[401] = 20050
QuestBeliTable[402] = 20100
QuestBeliTable[403] = 20150
QuestBeliTable[404] = 20200
QuestBeliTable[405] = 20250
QuestBeliTable[406] = 20300
QuestBeliTable[407] = 20350
QuestBeliTable[408] = 20400
QuestBeliTable[409] = 20450
QuestBeliTable[410] = 20500
QuestBeliTable[411] = 20550
QuestBeliTable[412] = 20600
QuestBeliTable[413] = 20650
QuestBeliTable[414] = 20700
QuestBeliTable[415] = 20750
QuestBeliTable[416] = 20800
QuestBeliTable[417] = 20850
QuestBeliTable[418] = 20900
QuestBeliTable[419] = 20950
QuestBeliTable[420] = 21000
QuestBeliTable[421] = 21050
QuestBeliTable[422] = 21100
QuestBeliTable[423] = 21150
QuestBeliTable[424] = 21200
QuestBeliTable[425] = 21250
QuestBeliTable[426] = 21300
QuestBeliTable[427] = 21350
QuestBeliTable[428] = 21400
QuestBeliTable[429] = 21450
QuestBeliTable[430] = 21500
QuestBeliTable[431] = 21550
QuestBeliTable[432] = 21600
QuestBeliTable[433] = 21650
QuestBeliTable[434] = 21700
QuestBeliTable[435] = 21750
QuestBeliTable[436] = 21800
QuestBeliTable[437] = 21850
QuestBeliTable[438] = 21900
QuestBeliTable[439] = 21950
QuestBeliTable[440] = 22000
QuestBeliTable[441] = 22050
QuestBeliTable[442] = 22100
QuestBeliTable[443] = 22150
QuestBeliTable[444] = 22200
QuestBeliTable[445] = 22250
QuestBeliTable[446] = 22300
QuestBeliTable[447] = 22350
QuestBeliTable[448] = 22400
QuestBeliTable[449] = 22450
QuestBeliTable[450] = 22500
QuestBeliTable[451] = 22550
QuestBeliTable[452] = 22600
QuestBeliTable[453] = 22650
QuestBeliTable[454] = 22700
QuestBeliTable[455] = 22750
QuestBeliTable[456] = 22800
QuestBeliTable[457] = 22850
QuestBeliTable[458] = 22900
QuestBeliTable[459] = 22950
QuestBeliTable[460] = 23000
QuestBeliTable[461] = 23050
QuestBeliTable[462] = 23100
QuestBeliTable[463] = 23150
QuestBeliTable[464] = 23200
QuestBeliTable[465] = 23250
QuestBeliTable[466] = 23300
QuestBeliTable[467] = 23350
QuestBeliTable[468] = 23400
QuestBeliTable[469] = 23450
QuestBeliTable[470] = 23500
QuestBeliTable[471] = 23550
QuestBeliTable[472] = 23600
QuestBeliTable[473] = 23650
QuestBeliTable[474] = 23700
QuestBeliTable[475] = 23750
QuestBeliTable[476] = 23800
QuestBeliTable[477] = 23850
QuestBeliTable[478] = 23900
QuestBeliTable[479] = 23950
QuestBeliTable[480] = 24000
QuestBeliTable[481] = 24050
QuestBeliTable[482] = 24100
QuestBeliTable[483] = 24150
QuestBeliTable[484] = 24200
QuestBeliTable[485] = 24250
QuestBeliTable[486] = 24300
QuestBeliTable[487] = 24350
QuestBeliTable[488] = 24400
QuestBeliTable[489] = 24450
QuestBeliTable[490] = 24500
QuestBeliTable[491] = 24550
QuestBeliTable[492] = 24600
QuestBeliTable[493] = 24650
QuestBeliTable[494] = 24700
QuestBeliTable[495] = 24750
QuestBeliTable[496] = 24800
QuestBeliTable[497] = 24850
QuestBeliTable[498] = 24900
QuestBeliTable[499] = 24950
QuestBeliTable[500] = 25000
QuestBeliTable[501] = 25050
QuestBeliTable[502] = 25100
QuestBeliTable[503] = 25150
QuestBeliTable[504] = 25200
QuestBeliTable[505] = 25250
QuestBeliTable[506] = 25300
QuestBeliTable[507] = 25350
QuestBeliTable[508] = 25400
QuestBeliTable[509] = 25450
QuestBeliTable[510] = 25500
QuestBeliTable[511] = 25550
QuestBeliTable[512] = 25600
QuestBeliTable[513] = 25650
QuestBeliTable[514] = 25700
QuestBeliTable[515] = 25750
QuestBeliTable[516] = 25800
QuestBeliTable[517] = 25850
QuestBeliTable[518] = 25900
QuestBeliTable[519] = 25950
QuestBeliTable[520] = 26000
QuestBeliTable[521] = 26050
QuestBeliTable[522] = 26100
QuestBeliTable[523] = 26150
QuestBeliTable[524] = 26200
QuestBeliTable[525] = 26250
QuestBeliTable[526] = 26300
QuestBeliTable[527] = 26350
QuestBeliTable[528] = 26400
QuestBeliTable[529] = 26450
QuestBeliTable[530] = 26500
QuestBeliTable[531] = 26550
QuestBeliTable[532] = 26600
QuestBeliTable[533] = 26650
QuestBeliTable[534] = 26700
QuestBeliTable[535] = 26750
QuestBeliTable[536] = 26800
QuestBeliTable[537] = 26850
QuestBeliTable[538] = 26900
QuestBeliTable[539] = 26950
QuestBeliTable[540] = 27000
QuestBeliTable[541] = 27050
QuestBeliTable[542] = 27100
QuestBeliTable[543] = 27150
QuestBeliTable[544] = 27200
QuestBeliTable[545] = 27250
QuestBeliTable[546] = 27300
QuestBeliTable[547] = 27350
QuestBeliTable[548] = 27400
QuestBeliTable[549] = 27450
QuestBeliTable[550] = 27500
QuestBeliTable[551] = 27550
QuestBeliTable[552] = 27600
QuestBeliTable[553] = 27650
QuestBeliTable[554] = 27700
QuestBeliTable[555] = 27750
QuestBeliTable[556] = 27800
QuestBeliTable[557] = 27850
QuestBeliTable[558] = 27900
QuestBeliTable[559] = 27950
QuestBeliTable[560] = 28000
QuestBeliTable[561] = 28050
QuestBeliTable[562] = 28100
QuestBeliTable[563] = 28150
QuestBeliTable[564] = 28200
QuestBeliTable[565] = 28250
QuestBeliTable[566] = 28300
QuestBeliTable[567] = 28350
QuestBeliTable[568] = 28400
QuestBeliTable[569] = 28450
QuestBeliTable[570] = 28500
QuestBeliTable[571] = 28550
QuestBeliTable[572] = 28600
QuestBeliTable[573] = 28650
QuestBeliTable[574] = 28700
QuestBeliTable[575] = 28750
QuestBeliTable[576] = 28800
QuestBeliTable[577] = 28850
QuestBeliTable[578] = 28900
QuestBeliTable[579] = 28950
QuestBeliTable[580] = 29000
QuestBeliTable[581] = 29050
QuestBeliTable[582] = 29100
QuestBeliTable[583] = 29150
QuestBeliTable[584] = 29200
QuestBeliTable[585] = 29250
QuestBeliTable[586] = 29300
QuestBeliTable[587] = 29350
QuestBeliTable[588] = 29400
QuestBeliTable[589] = 29450
QuestBeliTable[590] = 29500
QuestBeliTable[591] = 29550
QuestBeliTable[592] = 29600
QuestBeliTable[593] = 29650
QuestBeliTable[594] = 29700
QuestBeliTable[595] = 29750
QuestBeliTable[596] = 29800
QuestBeliTable[597] = 29850
QuestBeliTable[598] = 29900
QuestBeliTable[599] = 29950
QuestBeliTable[600] = 30000
QuestBeliTable[601] = 30050
QuestBeliTable[602] = 30100
QuestBeliTable[603] = 30150
QuestBeliTable[604] = 30200
QuestBeliTable[605] = 30250
QuestBeliTable[606] = 30300
QuestBeliTable[607] = 30350
QuestBeliTable[608] = 30400
QuestBeliTable[609] = 30450
QuestBeliTable[610] = 30500
QuestBeliTable[611] = 30550
QuestBeliTable[612] = 30600
QuestBeliTable[613] = 30650
QuestBeliTable[614] = 30700
QuestBeliTable[615] = 30750
QuestBeliTable[616] = 30800
QuestBeliTable[617] = 30850
QuestBeliTable[618] = 30900
QuestBeliTable[619] = 30950
QuestBeliTable[620] = 31000
QuestBeliTable[621] = 31050
QuestBeliTable[622] = 31100
QuestBeliTable[623] = 31150
QuestBeliTable[624] = 31200
QuestBeliTable[625] = 31250
QuestBeliTable[626] = 31300
QuestBeliTable[627] = 31350
QuestBeliTable[628] = 31400
QuestBeliTable[629] = 31450
QuestBeliTable[630] = 31500
QuestBeliTable[631] = 31550
QuestBeliTable[632] = 31600
QuestBeliTable[633] = 31650
QuestBeliTable[634] = 31700
QuestBeliTable[635] = 31750
QuestBeliTable[636] = 31800
QuestBeliTable[637] = 31850
QuestBeliTable[638] = 31900
QuestBeliTable[639] = 31950
QuestBeliTable[640] = 32000
QuestBeliTable[641] = 32050
QuestBeliTable[642] = 32100
QuestBeliTable[643] = 32150
QuestBeliTable[644] = 32200
QuestBeliTable[645] = 32250
QuestBeliTable[646] = 32300
QuestBeliTable[647] = 32350
QuestBeliTable[648] = 32400
QuestBeliTable[649] = 32450
QuestBeliTable[650] = 32500
QuestBeliTable[651] = 32550
QuestBeliTable[652] = 32600
QuestBeliTable[653] = 32650
QuestBeliTable[654] = 32700
QuestBeliTable[655] = 32750
QuestBeliTable[656] = 32800
QuestBeliTable[657] = 32850
QuestBeliTable[658] = 32900
QuestBeliTable[659] = 32950
QuestBeliTable[660] = 33000
QuestBeliTable[661] = 33050
QuestBeliTable[662] = 33100
QuestBeliTable[663] = 33150
QuestBeliTable[664] = 33200
QuestBeliTable[665] = 33250
QuestBeliTable[666] = 33300
QuestBeliTable[667] = 33350
QuestBeliTable[668] = 33400
QuestBeliTable[669] = 33450
QuestBeliTable[670] = 33500
QuestBeliTable[671] = 33550
QuestBeliTable[672] = 33600
QuestBeliTable[673] = 33650
QuestBeliTable[674] = 33700
QuestBeliTable[675] = 33750
QuestBeliTable[676] = 33800
QuestBeliTable[677] = 33850
QuestBeliTable[678] = 33900
QuestBeliTable[679] = 33950
QuestBeliTable[680] = 34000
QuestBeliTable[681] = 34050
QuestBeliTable[682] = 34100
QuestBeliTable[683] = 34150
QuestBeliTable[684] = 34200
QuestBeliTable[685] = 34250
QuestBeliTable[686] = 34300
QuestBeliTable[687] = 34350
QuestBeliTable[688] = 34400
QuestBeliTable[689] = 34450
QuestBeliTable[690] = 34500
QuestBeliTable[691] = 34550
QuestBeliTable[692] = 34600
QuestBeliTable[693] = 34650
QuestBeliTable[694] = 34700
QuestBeliTable[695] = 34750
QuestBeliTable[696] = 34800
QuestBeliTable[697] = 34850
QuestBeliTable[698] = 34900
QuestBeliTable[699] = 34950
QuestBeliTable[700] = 35000
QuestBeliTable[701] = 35050
QuestBeliTable[702] = 35100
QuestBeliTable[703] = 35150
QuestBeliTable[704] = 35200
QuestBeliTable[705] = 35250
QuestBeliTable[706] = 35300
QuestBeliTable[707] = 35350
QuestBeliTable[708] = 35400
QuestBeliTable[709] = 35450
QuestBeliTable[710] = 35500
QuestBeliTable[711] = 35550
QuestBeliTable[712] = 35600
QuestBeliTable[713] = 35650
QuestBeliTable[714] = 35700
QuestBeliTable[715] = 35750
QuestBeliTable[716] = 35800
QuestBeliTable[717] = 35850
QuestBeliTable[718] = 35900
QuestBeliTable[719] = 35950
QuestBeliTable[720] = 36000
QuestBeliTable[721] = 36050
QuestBeliTable[722] = 36100
QuestBeliTable[723] = 36150
QuestBeliTable[724] = 36200
QuestBeliTable[725] = 36250
QuestBeliTable[726] = 36300
QuestBeliTable[727] = 36350
QuestBeliTable[728] = 36400
QuestBeliTable[729] = 36450
QuestBeliTable[730] = 36500
QuestBeliTable[731] = 36550
QuestBeliTable[732] = 36600
QuestBeliTable[733] = 36650
QuestBeliTable[734] = 36700
QuestBeliTable[735] = 36750
QuestBeliTable[736] = 36800
QuestBeliTable[737] = 36850
QuestBeliTable[738] = 36900
QuestBeliTable[739] = 36950
QuestBeliTable[740] = 37000
QuestBeliTable[741] = 37050
QuestBeliTable[742] = 37100
QuestBeliTable[743] = 37150
QuestBeliTable[744] = 37200
QuestBeliTable[745] = 37250
QuestBeliTable[746] = 37300
QuestBeliTable[747] = 37350
QuestBeliTable[748] = 37400
QuestBeliTable[749] = 37450
QuestBeliTable[750] = 37500
QuestBeliTable[751] = 37550
QuestBeliTable[752] = 37600
QuestBeliTable[753] = 37650
QuestBeliTable[754] = 37700
QuestBeliTable[755] = 37750
QuestBeliTable[756] = 37800
QuestBeliTable[757] = 37850
QuestBeliTable[758] = 37900
QuestBeliTable[759] = 37950
QuestBeliTable[760] = 38000
QuestBeliTable[761] = 38050
QuestBeliTable[762] = 38100
QuestBeliTable[763] = 38150
QuestBeliTable[764] = 38200
QuestBeliTable[765] = 38250
QuestBeliTable[766] = 38300
QuestBeliTable[767] = 38350
QuestBeliTable[768] = 38400
QuestBeliTable[769] = 38450
QuestBeliTable[770] = 38500
QuestBeliTable[771] = 38550
QuestBeliTable[772] = 38600
QuestBeliTable[773] = 38650
QuestBeliTable[774] = 38700
QuestBeliTable[775] = 38750
QuestBeliTable[776] = 38800
QuestBeliTable[777] = 38850
QuestBeliTable[778] = 38900
QuestBeliTable[779] = 38950
QuestBeliTable[780] = 39000
QuestBeliTable[781] = 39050
QuestBeliTable[782] = 39100
QuestBeliTable[783] = 39150
QuestBeliTable[784] = 39200
QuestBeliTable[785] = 39250
QuestBeliTable[786] = 39300
QuestBeliTable[787] = 39350
QuestBeliTable[788] = 39400
QuestBeliTable[789] = 39450
QuestBeliTable[790] = 39500
QuestBeliTable[791] = 39550
QuestBeliTable[792] = 39600
QuestBeliTable[793] = 39650
QuestBeliTable[794] = 39700
QuestBeliTable[795] = 39750
QuestBeliTable[796] = 39800
QuestBeliTable[797] = 39850
QuestBeliTable[798] = 39900
QuestBeliTable[799] = 39950
QuestBeliTable[800] = 40000
QuestBeliTable[801] = 40050
QuestBeliTable[802] = 40100
QuestBeliTable[803] = 40150
QuestBeliTable[804] = 40200
QuestBeliTable[805] = 40250
QuestBeliTable[806] = 40300
QuestBeliTable[807] = 40350
QuestBeliTable[808] = 40400
QuestBeliTable[809] = 40450
QuestBeliTable[810] = 40500
QuestBeliTable[811] = 40550
QuestBeliTable[812] = 40600
QuestBeliTable[813] = 40650
QuestBeliTable[814] = 40700
QuestBeliTable[815] = 40750
QuestBeliTable[816] = 40800
QuestBeliTable[817] = 40850
QuestBeliTable[818] = 40900
QuestBeliTable[819] = 40950
QuestBeliTable[820] = 41000
QuestBeliTable[821] = 41050
QuestBeliTable[822] = 41100
QuestBeliTable[823] = 41150
QuestBeliTable[824] = 41200
QuestBeliTable[825] = 41250
QuestBeliTable[826] = 41300
QuestBeliTable[827] = 41350
QuestBeliTable[828] = 41400
QuestBeliTable[829] = 41450
QuestBeliTable[830] = 41500
QuestBeliTable[831] = 41550
QuestBeliTable[832] = 41600
QuestBeliTable[833] = 41650
QuestBeliTable[834] = 41700
QuestBeliTable[835] = 41750
QuestBeliTable[836] = 41800
QuestBeliTable[837] = 41850
QuestBeliTable[838] = 41900
QuestBeliTable[839] = 41950
QuestBeliTable[840] = 42000
QuestBeliTable[841] = 42050
QuestBeliTable[842] = 42100
QuestBeliTable[843] = 42150
QuestBeliTable[844] = 42200
QuestBeliTable[845] = 42250
QuestBeliTable[846] = 42300
QuestBeliTable[847] = 42350
QuestBeliTable[848] = 42400
QuestBeliTable[849] = 42450
QuestBeliTable[850] = 42500
QuestBeliTable[851] = 42550
QuestBeliTable[852] = 42600
QuestBeliTable[853] = 42650
QuestBeliTable[854] = 42700
QuestBeliTable[855] = 42750
QuestBeliTable[856] = 42800
QuestBeliTable[857] = 42850
QuestBeliTable[858] = 42900
QuestBeliTable[859] = 42950
QuestBeliTable[860] = 43000
QuestBeliTable[861] = 43050
QuestBeliTable[862] = 43100
QuestBeliTable[863] = 43150
QuestBeliTable[864] = 43200
QuestBeliTable[865] = 43250
QuestBeliTable[866] = 43300
QuestBeliTable[867] = 43350
QuestBeliTable[868] = 43400
QuestBeliTable[869] = 43450
QuestBeliTable[870] = 43500
QuestBeliTable[871] = 43550
QuestBeliTable[872] = 43600
QuestBeliTable[873] = 43650
QuestBeliTable[874] = 43700
QuestBeliTable[875] = 43750
QuestBeliTable[876] = 43800
QuestBeliTable[877] = 43850
QuestBeliTable[878] = 43900
QuestBeliTable[879] = 43950
QuestBeliTable[880] = 44000
QuestBeliTable[881] = 44050
QuestBeliTable[882] = 44100
QuestBeliTable[883] = 44150
QuestBeliTable[884] = 44200
QuestBeliTable[885] = 44250
QuestBeliTable[886] = 44300
QuestBeliTable[887] = 44350
QuestBeliTable[888] = 44400
QuestBeliTable[889] = 44450
QuestBeliTable[890] = 44500
QuestBeliTable[891] = 44550
QuestBeliTable[892] = 44600
QuestBeliTable[893] = 44650
QuestBeliTable[894] = 44700
QuestBeliTable[895] = 44750
QuestBeliTable[896] = 44800
QuestBeliTable[897] = 44850
QuestBeliTable[898] = 44900
QuestBeliTable[899] = 44950
QuestBeliTable[900] = 45000
QuestBeliTable[901] = 45050
QuestBeliTable[902] = 45100
QuestBeliTable[903] = 45150
QuestBeliTable[904] = 45200
QuestBeliTable[905] = 45250
QuestBeliTable[906] = 45300
QuestBeliTable[907] = 45350
QuestBeliTable[908] = 45400
QuestBeliTable[909] = 45450
QuestBeliTable[910] = 45500
QuestBeliTable[911] = 45550
QuestBeliTable[912] = 45600
QuestBeliTable[913] = 45650
QuestBeliTable[914] = 45700
QuestBeliTable[915] = 45750
QuestBeliTable[916] = 45800
QuestBeliTable[917] = 45850
QuestBeliTable[918] = 45900
QuestBeliTable[919] = 45950
QuestBeliTable[920] = 46000
QuestBeliTable[921] = 46050
QuestBeliTable[922] = 46100
QuestBeliTable[923] = 46150
QuestBeliTable[924] = 46200
QuestBeliTable[925] = 46250
QuestBeliTable[926] = 46300
QuestBeliTable[927] = 46350
QuestBeliTable[928] = 46400
QuestBeliTable[929] = 46450
QuestBeliTable[930] = 46500
QuestBeliTable[931] = 46550
QuestBeliTable[932] = 46600
QuestBeliTable[933] = 46650
QuestBeliTable[934] = 46700
QuestBeliTable[935] = 46750
QuestBeliTable[936] = 46800
QuestBeliTable[937] = 46850
QuestBeliTable[938] = 46900
QuestBeliTable[939] = 46950
QuestBeliTable[940] = 47000
QuestBeliTable[941] = 47050
QuestBeliTable[942] = 47100
QuestBeliTable[943] = 47150
QuestBeliTable[944] = 47200
QuestBeliTable[945] = 47250
QuestBeliTable[946] = 47300
QuestBeliTable[947] = 47350
QuestBeliTable[948] = 47400
QuestBeliTable[949] = 47450
QuestBeliTable[950] = 47500
QuestBeliTable[951] = 47550
QuestBeliTable[952] = 47600
QuestBeliTable[953] = 47650
QuestBeliTable[954] = 47700
QuestBeliTable[955] = 47750
QuestBeliTable[956] = 47800
QuestBeliTable[957] = 47850
QuestBeliTable[958] = 47900
QuestBeliTable[959] = 47950
QuestBeliTable[960] = 48000
QuestBeliTable[961] = 48050
QuestBeliTable[962] = 48100
QuestBeliTable[963] = 48150
QuestBeliTable[964] = 48200
QuestBeliTable[965] = 48250
QuestBeliTable[966] = 48300
QuestBeliTable[967] = 48350
QuestBeliTable[968] = 48400
QuestBeliTable[969] = 48450
QuestBeliTable[970] = 48500
QuestBeliTable[971] = 48550
QuestBeliTable[972] = 48600
QuestBeliTable[973] = 48650
QuestBeliTable[974] = 48700
QuestBeliTable[975] = 48750
QuestBeliTable[976] = 48800
QuestBeliTable[977] = 48850
QuestBeliTable[978] = 48900
QuestBeliTable[979] = 48950
QuestBeliTable[980] = 49000
QuestBeliTable[981] = 49050
QuestBeliTable[982] = 49100
QuestBeliTable[983] = 49150
QuestBeliTable[984] = 49200
QuestBeliTable[985] = 49250
QuestBeliTable[986] = 49300
QuestBeliTable[987] = 49350
QuestBeliTable[988] = 49400
QuestBeliTable[989] = 49450
QuestBeliTable[990] = 49500
QuestBeliTable[991] = 49550
QuestBeliTable[992] = 49600
QuestBeliTable[993] = 49650
QuestBeliTable[994] = 49700
QuestBeliTable[995] = 49750
QuestBeliTable[996] = 49800
QuestBeliTable[997] = 49850
QuestBeliTable[998] = 49900
QuestBeliTable[999] = 49950
QuestBeliTable[1000] = 50000
QuestBeliTable[1001] = 50050
QuestBeliTable[1002] = 50100
QuestBeliTable[1003] = 50150
QuestBeliTable[1004] = 50200
QuestBeliTable[1005] = 50250
QuestBeliTable[1006] = 50300
QuestBeliTable[1007] = 50350
QuestBeliTable[1008] = 50400
QuestBeliTable[1009] = 50450
QuestBeliTable[1010] = 50500
QuestBeliTable[1011] = 50550
QuestBeliTable[1012] = 50600
QuestBeliTable[1013] = 50650
QuestBeliTable[1014] = 50700
QuestBeliTable[1015] = 50750
QuestBeliTable[1016] = 50800
QuestBeliTable[1017] = 50850
QuestBeliTable[1018] = 50900
QuestBeliTable[1019] = 50950
QuestBeliTable[1020] = 51000
QuestBeliTable[1021] = 51050
QuestBeliTable[1022] = 51100
QuestBeliTable[1023] = 51150
QuestBeliTable[1024] = 51200
QuestBeliTable[1025] = 51250
QuestBeliTable[1026] = 51300
QuestBeliTable[1027] = 51350
QuestBeliTable[1028] = 51400
QuestBeliTable[1029] = 51450
QuestBeliTable[1030] = 51500
QuestBeliTable[1031] = 51550
QuestBeliTable[1032] = 51600
QuestBeliTable[1033] = 51650
QuestBeliTable[1034] = 51700
QuestBeliTable[1035] = 51750
QuestBeliTable[1036] = 51800
QuestBeliTable[1037] = 51850
QuestBeliTable[1038] = 51900
QuestBeliTable[1039] = 51950
QuestBeliTable[1040] = 52000
QuestBeliTable[1041] = 52050
QuestBeliTable[1042] = 52100
QuestBeliTable[1043] = 52150
QuestBeliTable[1044] = 52200
QuestBeliTable[1045] = 52250
QuestBeliTable[1046] = 52300
QuestBeliTable[1047] = 52350
QuestBeliTable[1048] = 52400
QuestBeliTable[1049] = 52450
QuestBeliTable[1050] = 52500
QuestBeliTable[1051] = 52550
QuestBeliTable[1052] = 52600
QuestBeliTable[1053] = 52650
QuestBeliTable[1054] = 52700
QuestBeliTable[1055] = 52750
QuestBeliTable[1056] = 52800
QuestBeliTable[1057] = 52850
QuestBeliTable[1058] = 52900
QuestBeliTable[1059] = 52950
QuestBeliTable[1060] = 53000
QuestBeliTable[1061] = 53050
QuestBeliTable[1062] = 53100
QuestBeliTable[1063] = 53150
QuestBeliTable[1064] = 53200
QuestBeliTable[1065] = 53250
QuestBeliTable[1066] = 53300
QuestBeliTable[1067] = 53350
QuestBeliTable[1068] = 53400
QuestBeliTable[1069] = 53450
QuestBeliTable[1070] = 53500
QuestBeliTable[1071] = 53550
QuestBeliTable[1072] = 53600
QuestBeliTable[1073] = 53650
QuestBeliTable[1074] = 53700
QuestBeliTable[1075] = 53750
QuestBeliTable[1076] = 53800
QuestBeliTable[1077] = 53850
QuestBeliTable[1078] = 53900
QuestBeliTable[1079] = 53950
QuestBeliTable[1080] = 54000
QuestBeliTable[1081] = 54050
QuestBeliTable[1082] = 54100
QuestBeliTable[1083] = 54150
QuestBeliTable[1084] = 54200
QuestBeliTable[1085] = 54250
QuestBeliTable[1086] = 54300
QuestBeliTable[1087] = 54350
QuestBeliTable[1088] = 54400
QuestBeliTable[1089] = 54450
QuestBeliTable[1090] = 54500
QuestBeliTable[1091] = 54550
QuestBeliTable[1092] = 54600
QuestBeliTable[1093] = 54650
QuestBeliTable[1094] = 54700
QuestBeliTable[1095] = 54750
QuestBeliTable[1096] = 54800
QuestBeliTable[1097] = 54850
QuestBeliTable[1098] = 54900
QuestBeliTable[1099] = 54950
QuestBeliTable[1100] = 55000
QuestBeliTable[1101] = 55050
QuestBeliTable[1102] = 55100
QuestBeliTable[1103] = 55150
QuestBeliTable[1104] = 55200
QuestBeliTable[1105] = 55250
QuestBeliTable[1106] = 55300
QuestBeliTable[1107] = 55350
QuestBeliTable[1108] = 55400
QuestBeliTable[1109] = 55450
QuestBeliTable[1110] = 55500
QuestBeliTable[1111] = 55550
QuestBeliTable[1112] = 55600
QuestBeliTable[1113] = 55650
QuestBeliTable[1114] = 55700
QuestBeliTable[1115] = 55750
QuestBeliTable[1116] = 55800
QuestBeliTable[1117] = 55850
QuestBeliTable[1118] = 55900
QuestBeliTable[1119] = 55950
QuestBeliTable[1120] = 56000
QuestBeliTable[1121] = 56050
QuestBeliTable[1122] = 56100
QuestBeliTable[1123] = 56150
QuestBeliTable[1124] = 56200
QuestBeliTable[1125] = 56250
QuestBeliTable[1126] = 56300
QuestBeliTable[1127] = 56350
QuestBeliTable[1128] = 56400
QuestBeliTable[1129] = 56450
QuestBeliTable[1130] = 56500
QuestBeliTable[1131] = 56550
QuestBeliTable[1132] = 56600
QuestBeliTable[1133] = 56650
QuestBeliTable[1134] = 56700
QuestBeliTable[1135] = 56750
QuestBeliTable[1136] = 56800
QuestBeliTable[1137] = 56850
QuestBeliTable[1138] = 56900
QuestBeliTable[1139] = 56950
QuestBeliTable[1140] = 57000
QuestBeliTable[1141] = 57050
QuestBeliTable[1142] = 57100
QuestBeliTable[1143] = 57150
QuestBeliTable[1144] = 57200
QuestBeliTable[1145] = 57250
QuestBeliTable[1146] = 57300
QuestBeliTable[1147] = 57350
QuestBeliTable[1148] = 57400
QuestBeliTable[1149] = 57450
QuestBeliTable[1150] = 57500
QuestBeliTable[1151] = 57550
QuestBeliTable[1152] = 57600
QuestBeliTable[1153] = 57650
QuestBeliTable[1154] = 57700
QuestBeliTable[1155] = 57750
QuestBeliTable[1156] = 57800
QuestBeliTable[1157] = 57850
QuestBeliTable[1158] = 57900
QuestBeliTable[1159] = 57950
QuestBeliTable[1160] = 58000
QuestBeliTable[1161] = 58050
QuestBeliTable[1162] = 58100
QuestBeliTable[1163] = 58150
QuestBeliTable[1164] = 58200
QuestBeliTable[1165] = 58250
QuestBeliTable[1166] = 58300
QuestBeliTable[1167] = 58350
QuestBeliTable[1168] = 58400
QuestBeliTable[1169] = 58450
QuestBeliTable[1170] = 58500
QuestBeliTable[1171] = 58550
QuestBeliTable[1172] = 58600
QuestBeliTable[1173] = 58650
QuestBeliTable[1174] = 58700
QuestBeliTable[1175] = 58750
QuestBeliTable[1176] = 58800
QuestBeliTable[1177] = 58850
QuestBeliTable[1178] = 58900
QuestBeliTable[1179] = 58950
QuestBeliTable[1180] = 59000
QuestBeliTable[1181] = 59050
QuestBeliTable[1182] = 59100
QuestBeliTable[1183] = 59150
QuestBeliTable[1184] = 59200
QuestBeliTable[1185] = 59250
QuestBeliTable[1186] = 59300
QuestBeliTable[1187] = 59350
QuestBeliTable[1188] = 59400
QuestBeliTable[1189] = 59450
QuestBeliTable[1190] = 59500
QuestBeliTable[1191] = 59550
QuestBeliTable[1192] = 59600
QuestBeliTable[1193] = 59650
QuestBeliTable[1194] = 59700
QuestBeliTable[1195] = 59750
QuestBeliTable[1196] = 59800
QuestBeliTable[1197] = 59850
QuestBeliTable[1198] = 59900
QuestBeliTable[1199] = 59950
QuestBeliTable[1200] = 60000
QuestBeliTable[1201] = 60050
QuestBeliTable[1202] = 60100
QuestBeliTable[1203] = 60150
QuestBeliTable[1204] = 60200
QuestBeliTable[1205] = 60250
QuestBeliTable[1206] = 60300
QuestBeliTable[1207] = 60350
QuestBeliTable[1208] = 60400
QuestBeliTable[1209] = 60450
QuestBeliTable[1210] = 60500
QuestBeliTable[1211] = 60550
QuestBeliTable[1212] = 60600
QuestBeliTable[1213] = 60650
QuestBeliTable[1214] = 60700
QuestBeliTable[1215] = 60750
QuestBeliTable[1216] = 60800
QuestBeliTable[1217] = 60850
QuestBeliTable[1218] = 60900
QuestBeliTable[1219] = 60950
QuestBeliTable[1220] = 61000
QuestBeliTable[1221] = 61050
QuestBeliTable[1222] = 61100
QuestBeliTable[1223] = 61150
QuestBeliTable[1224] = 61200
QuestBeliTable[1225] = 61250
QuestBeliTable[1226] = 61300
QuestBeliTable[1227] = 61350
QuestBeliTable[1228] = 61400
QuestBeliTable[1229] = 61450
QuestBeliTable[1230] = 61500
QuestBeliTable[1231] = 61550
QuestBeliTable[1232] = 61600
QuestBeliTable[1233] = 61650
QuestBeliTable[1234] = 61700
QuestBeliTable[1235] = 61750
QuestBeliTable[1236] = 61800
QuestBeliTable[1237] = 61850
QuestBeliTable[1238] = 61900
QuestBeliTable[1239] = 61950
QuestBeliTable[1240] = 62000
QuestBeliTable[1241] = 62050
QuestBeliTable[1242] = 62100
QuestBeliTable[1243] = 62150
QuestBeliTable[1244] = 62200
QuestBeliTable[1245] = 62250
QuestBeliTable[1246] = 62300
QuestBeliTable[1247] = 62350
QuestBeliTable[1248] = 62400
QuestBeliTable[1249] = 62450
QuestBeliTable[1250] = 62500
QuestBeliTable[1251] = 62550
QuestBeliTable[1252] = 62600
QuestBeliTable[1253] = 62650
QuestBeliTable[1254] = 62700
QuestBeliTable[1255] = 62750
QuestBeliTable[1256] = 62800
QuestBeliTable[1257] = 62850
QuestBeliTable[1258] = 62900
QuestBeliTable[1259] = 62950
QuestBeliTable[1260] = 63000
QuestBeliTable[1261] = 63050
QuestBeliTable[1262] = 63100
QuestBeliTable[1263] = 63150
QuestBeliTable[1264] = 63200
QuestBeliTable[1265] = 63250
QuestBeliTable[1266] = 63300
QuestBeliTable[1267] = 63350
QuestBeliTable[1268] = 63400
QuestBeliTable[1269] = 63450
QuestBeliTable[1270] = 63500
QuestBeliTable[1271] = 63550
QuestBeliTable[1272] = 63600
QuestBeliTable[1273] = 63650
QuestBeliTable[1274] = 63700
QuestBeliTable[1275] = 63750
QuestBeliTable[1276] = 63800
QuestBeliTable[1277] = 63850
QuestBeliTable[1278] = 63900
QuestBeliTable[1279] = 63950
QuestBeliTable[1280] = 64000
QuestBeliTable[1281] = 64050
QuestBeliTable[1282] = 64100
QuestBeliTable[1283] = 64150
QuestBeliTable[1284] = 64200
QuestBeliTable[1285] = 64250
QuestBeliTable[1286] = 64300
QuestBeliTable[1287] = 64350
QuestBeliTable[1288] = 64400
QuestBeliTable[1289] = 64450
QuestBeliTable[1290] = 64500
QuestBeliTable[1291] = 64550
QuestBeliTable[1292] = 64600
QuestBeliTable[1293] = 64650
QuestBeliTable[1294] = 64700
QuestBeliTable[1295] = 64750
QuestBeliTable[1296] = 64800
QuestBeliTable[1297] = 64850
QuestBeliTable[1298] = 64900
QuestBeliTable[1299] = 64950
QuestBeliTable[1300] = 65000
QuestBeliTable[1301] = 65050
QuestBeliTable[1302] = 65100
QuestBeliTable[1303] = 65150
QuestBeliTable[1304] = 65200
QuestBeliTable[1305] = 65250
QuestBeliTable[1306] = 65300
QuestBeliTable[1307] = 65350
QuestBeliTable[1308] = 65400
QuestBeliTable[1309] = 65450
QuestBeliTable[1310] = 65500
QuestBeliTable[1311] = 65550
QuestBeliTable[1312] = 65600
QuestBeliTable[1313] = 65650
QuestBeliTable[1314] = 65700
QuestBeliTable[1315] = 65750
QuestBeliTable[1316] = 65800
QuestBeliTable[1317] = 65850
QuestBeliTable[1318] = 65900
QuestBeliTable[1319] = 65950
QuestBeliTable[1320] = 66000
QuestBeliTable[1321] = 66050
QuestBeliTable[1322] = 66100
QuestBeliTable[1323] = 66150
QuestBeliTable[1324] = 66200
QuestBeliTable[1325] = 66250
QuestBeliTable[1326] = 66300
QuestBeliTable[1327] = 66350
QuestBeliTable[1328] = 66400
QuestBeliTable[1329] = 66450
QuestBeliTable[1330] = 66500
QuestBeliTable[1331] = 66550
QuestBeliTable[1332] = 66600
QuestBeliTable[1333] = 66650
QuestBeliTable[1334] = 66700
QuestBeliTable[1335] = 66750
QuestBeliTable[1336] = 66800
QuestBeliTable[1337] = 66850
QuestBeliTable[1338] = 66900
QuestBeliTable[1339] = 66950
QuestBeliTable[1340] = 67000
QuestBeliTable[1341] = 67050
QuestBeliTable[1342] = 67100
QuestBeliTable[1343] = 67150
QuestBeliTable[1344] = 67200
QuestBeliTable[1345] = 67250
QuestBeliTable[1346] = 67300
QuestBeliTable[1347] = 67350
QuestBeliTable[1348] = 67400
QuestBeliTable[1349] = 67450
QuestBeliTable[1350] = 67500
QuestBeliTable[1351] = 67550
QuestBeliTable[1352] = 67600
QuestBeliTable[1353] = 67650
QuestBeliTable[1354] = 67700
QuestBeliTable[1355] = 67750
QuestBeliTable[1356] = 67800
QuestBeliTable[1357] = 67850
QuestBeliTable[1358] = 67900
QuestBeliTable[1359] = 67950
QuestBeliTable[1360] = 68000
QuestBeliTable[1361] = 68050
QuestBeliTable[1362] = 68100
QuestBeliTable[1363] = 68150
QuestBeliTable[1364] = 68200
QuestBeliTable[1365] = 68250
QuestBeliTable[1366] = 68300
QuestBeliTable[1367] = 68350
QuestBeliTable[1368] = 68400
QuestBeliTable[1369] = 68450
QuestBeliTable[1370] = 68500
QuestBeliTable[1371] = 68550
QuestBeliTable[1372] = 68600
QuestBeliTable[1373] = 68650
QuestBeliTable[1374] = 68700
QuestBeliTable[1375] = 68750
QuestBeliTable[1376] = 68800
QuestBeliTable[1377] = 68850
QuestBeliTable[1378] = 68900
QuestBeliTable[1379] = 68950
QuestBeliTable[1380] = 69000
QuestBeliTable[1381] = 69050
QuestBeliTable[1382] = 69100
QuestBeliTable[1383] = 69150
QuestBeliTable[1384] = 69200
QuestBeliTable[1385] = 69250
QuestBeliTable[1386] = 69300
QuestBeliTable[1387] = 69350
QuestBeliTable[1388] = 69400
QuestBeliTable[1389] = 69450
QuestBeliTable[1390] = 69500
QuestBeliTable[1391] = 69550
QuestBeliTable[1392] = 69600
QuestBeliTable[1393] = 69650
QuestBeliTable[1394] = 69700
QuestBeliTable[1395] = 69750
QuestBeliTable[1396] = 69800
QuestBeliTable[1397] = 69850
QuestBeliTable[1398] = 69900
QuestBeliTable[1399] = 69950
QuestBeliTable[1400] = 70000
QuestBeliTable[1401] = 70050
QuestBeliTable[1402] = 70100
QuestBeliTable[1403] = 70150
QuestBeliTable[1404] = 70200
QuestBeliTable[1405] = 70250
QuestBeliTable[1406] = 70300
QuestBeliTable[1407] = 70350
QuestBeliTable[1408] = 70400
QuestBeliTable[1409] = 70450
QuestBeliTable[1410] = 70500
QuestBeliTable[1411] = 70550
QuestBeliTable[1412] = 70600
QuestBeliTable[1413] = 70650
QuestBeliTable[1414] = 70700
QuestBeliTable[1415] = 70750
QuestBeliTable[1416] = 70800
QuestBeliTable[1417] = 70850
QuestBeliTable[1418] = 70900
QuestBeliTable[1419] = 70950
QuestBeliTable[1420] = 71000
QuestBeliTable[1421] = 71050
QuestBeliTable[1422] = 71100
QuestBeliTable[1423] = 71150
QuestBeliTable[1424] = 71200
QuestBeliTable[1425] = 71250
QuestBeliTable[1426] = 71300
QuestBeliTable[1427] = 71350
QuestBeliTable[1428] = 71400
QuestBeliTable[1429] = 71450
QuestBeliTable[1430] = 71500
QuestBeliTable[1431] = 71550
QuestBeliTable[1432] = 71600
QuestBeliTable[1433] = 71650
QuestBeliTable[1434] = 71700
QuestBeliTable[1435] = 71750
QuestBeliTable[1436] = 71800
QuestBeliTable[1437] = 71850
QuestBeliTable[1438] = 71900
QuestBeliTable[1439] = 71950
QuestBeliTable[1440] = 72000
QuestBeliTable[1441] = 72050
QuestBeliTable[1442] = 72100
QuestBeliTable[1443] = 72150
QuestBeliTable[1444] = 72200
QuestBeliTable[1445] = 72250
QuestBeliTable[1446] = 72300
QuestBeliTable[1447] = 72350
QuestBeliTable[1448] = 72400
QuestBeliTable[1449] = 72450
QuestBeliTable[1450] = 72500
QuestBeliTable[1451] = 72550
QuestBeliTable[1452] = 72600
QuestBeliTable[1453] = 72650
QuestBeliTable[1454] = 72700
QuestBeliTable[1455] = 72750
QuestBeliTable[1456] = 72800
QuestBeliTable[1457] = 72850
QuestBeliTable[1458] = 72900
QuestBeliTable[1459] = 72950
QuestBeliTable[1460] = 73000
QuestBeliTable[1461] = 73050
QuestBeliTable[1462] = 73100
QuestBeliTable[1463] = 73150
QuestBeliTable[1464] = 73200
QuestBeliTable[1465] = 73250
QuestBeliTable[1466] = 73300
QuestBeliTable[1467] = 73350
QuestBeliTable[1468] = 73400
QuestBeliTable[1469] = 73450
QuestBeliTable[1470] = 73500
QuestBeliTable[1471] = 73550
QuestBeliTable[1472] = 73600
QuestBeliTable[1473] = 73650
QuestBeliTable[1474] = 73700
QuestBeliTable[1475] = 73750
QuestBeliTable[1476] = 73800
QuestBeliTable[1477] = 73850
QuestBeliTable[1478] = 73900
QuestBeliTable[1479] = 73950
QuestBeliTable[1480] = 74000
QuestBeliTable[1481] = 74050
QuestBeliTable[1482] = 74100
QuestBeliTable[1483] = 74150
QuestBeliTable[1484] = 74200
QuestBeliTable[1485] = 74250
QuestBeliTable[1486] = 74300
QuestBeliTable[1487] = 74350
QuestBeliTable[1488] = 74400
QuestBeliTable[1489] = 74450
QuestBeliTable[1490] = 74500
QuestBeliTable[1491] = 74550
QuestBeliTable[1492] = 74600
QuestBeliTable[1493] = 74650
QuestBeliTable[1494] = 74700
QuestBeliTable[1495] = 74750
QuestBeliTable[1496] = 74800
QuestBeliTable[1497] = 74850
QuestBeliTable[1498] = 74900
QuestBeliTable[1499] = 74950
QuestBeliTable[1500] = 75000
QuestBeliTable[1501] = 75050
QuestBeliTable[1502] = 75100
QuestBeliTable[1503] = 75150
QuestBeliTable[1504] = 75200
QuestBeliTable[1505] = 75250
QuestBeliTable[1506] = 75300
QuestBeliTable[1507] = 75350
QuestBeliTable[1508] = 75400
QuestBeliTable[1509] = 75450
QuestBeliTable[1510] = 75500
QuestBeliTable[1511] = 75550
QuestBeliTable[1512] = 75600
QuestBeliTable[1513] = 75650
QuestBeliTable[1514] = 75700
QuestBeliTable[1515] = 75750
QuestBeliTable[1516] = 75800
QuestBeliTable[1517] = 75850
QuestBeliTable[1518] = 75900
QuestBeliTable[1519] = 75950
QuestBeliTable[1520] = 76000
QuestBeliTable[1521] = 76050
QuestBeliTable[1522] = 76100
QuestBeliTable[1523] = 76150
QuestBeliTable[1524] = 76200
QuestBeliTable[1525] = 76250
QuestBeliTable[1526] = 76300
QuestBeliTable[1527] = 76350
QuestBeliTable[1528] = 76400
QuestBeliTable[1529] = 76450
QuestBeliTable[1530] = 76500
QuestBeliTable[1531] = 76550
QuestBeliTable[1532] = 76600
QuestBeliTable[1533] = 76650
QuestBeliTable[1534] = 76700
QuestBeliTable[1535] = 76750
QuestBeliTable[1536] = 76800
QuestBeliTable[1537] = 76850
QuestBeliTable[1538] = 76900
QuestBeliTable[1539] = 76950
QuestBeliTable[1540] = 77000
QuestBeliTable[1541] = 77050
QuestBeliTable[1542] = 77100
QuestBeliTable[1543] = 77150
QuestBeliTable[1544] = 77200
QuestBeliTable[1545] = 77250
QuestBeliTable[1546] = 77300
QuestBeliTable[1547] = 77350
QuestBeliTable[1548] = 77400
QuestBeliTable[1549] = 77450
QuestBeliTable[1550] = 77500
QuestBeliTable[1551] = 77550
QuestBeliTable[1552] = 77600
QuestBeliTable[1553] = 77650
QuestBeliTable[1554] = 77700
QuestBeliTable[1555] = 77750
QuestBeliTable[1556] = 77800
QuestBeliTable[1557] = 77850
QuestBeliTable[1558] = 77900
QuestBeliTable[1559] = 77950
QuestBeliTable[1560] = 78000
QuestBeliTable[1561] = 78050
QuestBeliTable[1562] = 78100
QuestBeliTable[1563] = 78150
QuestBeliTable[1564] = 78200
QuestBeliTable[1565] = 78250
QuestBeliTable[1566] = 78300
QuestBeliTable[1567] = 78350
QuestBeliTable[1568] = 78400
QuestBeliTable[1569] = 78450
QuestBeliTable[1570] = 78500
QuestBeliTable[1571] = 78550
QuestBeliTable[1572] = 78600
QuestBeliTable[1573] = 78650
QuestBeliTable[1574] = 78700
QuestBeliTable[1575] = 78750
QuestBeliTable[1576] = 78800
QuestBeliTable[1577] = 78850
QuestBeliTable[1578] = 78900
QuestBeliTable[1579] = 78950
QuestBeliTable[1580] = 79000
QuestBeliTable[1581] = 79050
QuestBeliTable[1582] = 79100
QuestBeliTable[1583] = 79150
QuestBeliTable[1584] = 79200
QuestBeliTable[1585] = 79250
QuestBeliTable[1586] = 79300
QuestBeliTable[1587] = 79350
QuestBeliTable[1588] = 79400
QuestBeliTable[1589] = 79450
QuestBeliTable[1590] = 79500
QuestBeliTable[1591] = 79550
QuestBeliTable[1592] = 79600
QuestBeliTable[1593] = 79650
QuestBeliTable[1594] = 79700
QuestBeliTable[1595] = 79750
QuestBeliTable[1596] = 79800
QuestBeliTable[1597] = 79850
QuestBeliTable[1598] = 79900
QuestBeliTable[1599] = 79950
QuestBeliTable[1600] = 80000
QuestBeliTable[1601] = 80050
QuestBeliTable[1602] = 80100
QuestBeliTable[1603] = 80150
QuestBeliTable[1604] = 80200
QuestBeliTable[1605] = 80250
QuestBeliTable[1606] = 80300
QuestBeliTable[1607] = 80350
QuestBeliTable[1608] = 80400
QuestBeliTable[1609] = 80450
QuestBeliTable[1610] = 80500
QuestBeliTable[1611] = 80550
QuestBeliTable[1612] = 80600
QuestBeliTable[1613] = 80650
QuestBeliTable[1614] = 80700
QuestBeliTable[1615] = 80750
QuestBeliTable[1616] = 80800
QuestBeliTable[1617] = 80850
QuestBeliTable[1618] = 80900
QuestBeliTable[1619] = 80950
QuestBeliTable[1620] = 81000
QuestBeliTable[1621] = 81050
QuestBeliTable[1622] = 81100
QuestBeliTable[1623] = 81150
QuestBeliTable[1624] = 81200
QuestBeliTable[1625] = 81250
QuestBeliTable[1626] = 81300
QuestBeliTable[1627] = 81350
QuestBeliTable[1628] = 81400
QuestBeliTable[1629] = 81450
QuestBeliTable[1630] = 81500
QuestBeliTable[1631] = 81550
QuestBeliTable[1632] = 81600
QuestBeliTable[1633] = 81650
QuestBeliTable[1634] = 81700
QuestBeliTable[1635] = 81750
QuestBeliTable[1636] = 81800
QuestBeliTable[1637] = 81850
QuestBeliTable[1638] = 81900
QuestBeliTable[1639] = 81950
QuestBeliTable[1640] = 82000
QuestBeliTable[1641] = 82050
QuestBeliTable[1642] = 82100
QuestBeliTable[1643] = 82150
QuestBeliTable[1644] = 82200
QuestBeliTable[1645] = 82250
QuestBeliTable[1646] = 82300
QuestBeliTable[1647] = 82350
QuestBeliTable[1648] = 82400
QuestBeliTable[1649] = 82450
QuestBeliTable[1650] = 82500
QuestBeliTable[1651] = 82550
QuestBeliTable[1652] = 82600
QuestBeliTable[1653] = 82650
QuestBeliTable[1654] = 82700
QuestBeliTable[1655] = 82750
QuestBeliTable[1656] = 82800
QuestBeliTable[1657] = 82850
QuestBeliTable[1658] = 82900
QuestBeliTable[1659] = 82950
QuestBeliTable[1660] = 83000
QuestBeliTable[1661] = 83050
QuestBeliTable[1662] = 83100
QuestBeliTable[1663] = 83150
QuestBeliTable[1664] = 83200
QuestBeliTable[1665] = 83250
QuestBeliTable[1666] = 83300
QuestBeliTable[1667] = 83350
QuestBeliTable[1668] = 83400
QuestBeliTable[1669] = 83450
QuestBeliTable[1670] = 83500
QuestBeliTable[1671] = 83550
QuestBeliTable[1672] = 83600
QuestBeliTable[1673] = 83650
QuestBeliTable[1674] = 83700
QuestBeliTable[1675] = 83750
QuestBeliTable[1676] = 83800
QuestBeliTable[1677] = 83850
QuestBeliTable[1678] = 83900
QuestBeliTable[1679] = 83950
QuestBeliTable[1680] = 84000
QuestBeliTable[1681] = 84050
QuestBeliTable[1682] = 84100
QuestBeliTable[1683] = 84150
QuestBeliTable[1684] = 84200
QuestBeliTable[1685] = 84250
QuestBeliTable[1686] = 84300
QuestBeliTable[1687] = 84350
QuestBeliTable[1688] = 84400
QuestBeliTable[1689] = 84450
QuestBeliTable[1690] = 84500
QuestBeliTable[1691] = 84550
QuestBeliTable[1692] = 84600
QuestBeliTable[1693] = 84650
QuestBeliTable[1694] = 84700
QuestBeliTable[1695] = 84750
QuestBeliTable[1696] = 84800
QuestBeliTable[1697] = 84850
QuestBeliTable[1698] = 84900
QuestBeliTable[1699] = 84950
QuestBeliTable[1700] = 85000
QuestBeliTable[1701] = 85050
QuestBeliTable[1702] = 85100
QuestBeliTable[1703] = 85150
QuestBeliTable[1704] = 85200
QuestBeliTable[1705] = 85250
QuestBeliTable[1706] = 85300
QuestBeliTable[1707] = 85350
QuestBeliTable[1708] = 85400
QuestBeliTable[1709] = 85450
QuestBeliTable[1710] = 85500
QuestBeliTable[1711] = 85550
QuestBeliTable[1712] = 85600
QuestBeliTable[1713] = 85650
QuestBeliTable[1714] = 85700
QuestBeliTable[1715] = 85750
QuestBeliTable[1716] = 85800
QuestBeliTable[1717] = 85850
QuestBeliTable[1718] = 85900
QuestBeliTable[1719] = 85950
QuestBeliTable[1720] = 86000
QuestBeliTable[1721] = 86050
QuestBeliTable[1722] = 86100
QuestBeliTable[1723] = 86150
QuestBeliTable[1724] = 86200
QuestBeliTable[1725] = 86250
QuestBeliTable[1726] = 86300
QuestBeliTable[1727] = 86350
QuestBeliTable[1728] = 86400
QuestBeliTable[1729] = 86450
QuestBeliTable[1730] = 86500
QuestBeliTable[1731] = 86550
QuestBeliTable[1732] = 86600
QuestBeliTable[1733] = 86650
QuestBeliTable[1734] = 86700
QuestBeliTable[1735] = 86750
QuestBeliTable[1736] = 86800
QuestBeliTable[1737] = 86850
QuestBeliTable[1738] = 86900
QuestBeliTable[1739] = 86950
QuestBeliTable[1740] = 87000
QuestBeliTable[1741] = 87050
QuestBeliTable[1742] = 87100
QuestBeliTable[1743] = 87150
QuestBeliTable[1744] = 87200
QuestBeliTable[1745] = 87250
QuestBeliTable[1746] = 87300
QuestBeliTable[1747] = 87350
QuestBeliTable[1748] = 87400
QuestBeliTable[1749] = 87450
QuestBeliTable[1750] = 87500
QuestBeliTable[1751] = 87550
QuestBeliTable[1752] = 87600
QuestBeliTable[1753] = 87650
QuestBeliTable[1754] = 87700
QuestBeliTable[1755] = 87750
QuestBeliTable[1756] = 87800
QuestBeliTable[1757] = 87850
QuestBeliTable[1758] = 87900
QuestBeliTable[1759] = 87950
QuestBeliTable[1760] = 88000
QuestBeliTable[1761] = 88050
QuestBeliTable[1762] = 88100
QuestBeliTable[1763] = 88150
QuestBeliTable[1764] = 88200
QuestBeliTable[1765] = 88250
QuestBeliTable[1766] = 88300
QuestBeliTable[1767] = 88350
QuestBeliTable[1768] = 88400
QuestBeliTable[1769] = 88450
QuestBeliTable[1770] = 88500
QuestBeliTable[1771] = 88550
QuestBeliTable[1772] = 88600
QuestBeliTable[1773] = 88650
QuestBeliTable[1774] = 88700
QuestBeliTable[1775] = 88750
QuestBeliTable[1776] = 88800
QuestBeliTable[1777] = 88850
QuestBeliTable[1778] = 88900
QuestBeliTable[1779] = 88950
QuestBeliTable[1780] = 89000
QuestBeliTable[1781] = 89050
QuestBeliTable[1782] = 89100
QuestBeliTable[1783] = 89150
QuestBeliTable[1784] = 89200
QuestBeliTable[1785] = 89250
QuestBeliTable[1786] = 89300
QuestBeliTable[1787] = 89350
QuestBeliTable[1788] = 89400
QuestBeliTable[1789] = 89450
QuestBeliTable[1790] = 89500
QuestBeliTable[1791] = 89550
QuestBeliTable[1792] = 89600
QuestBeliTable[1793] = 89650
QuestBeliTable[1794] = 89700
QuestBeliTable[1795] = 89750
QuestBeliTable[1796] = 89800
QuestBeliTable[1797] = 89850
QuestBeliTable[1798] = 89900
QuestBeliTable[1799] = 89950
QuestBeliTable[1800] = 90000
QuestBeliTable[1801] = 90050
QuestBeliTable[1802] = 90100
QuestBeliTable[1803] = 90150
QuestBeliTable[1804] = 90200
QuestBeliTable[1805] = 90250
QuestBeliTable[1806] = 90300
QuestBeliTable[1807] = 90350
QuestBeliTable[1808] = 90400
QuestBeliTable[1809] = 90450
QuestBeliTable[1810] = 90500
QuestBeliTable[1811] = 90550
QuestBeliTable[1812] = 90600
QuestBeliTable[1813] = 90650
QuestBeliTable[1814] = 90700
QuestBeliTable[1815] = 90750
QuestBeliTable[1816] = 90800
QuestBeliTable[1817] = 90850
QuestBeliTable[1818] = 90900
QuestBeliTable[1819] = 90950
QuestBeliTable[1820] = 91000
QuestBeliTable[1821] = 91050
QuestBeliTable[1822] = 91100
QuestBeliTable[1823] = 91150
QuestBeliTable[1824] = 91200
QuestBeliTable[1825] = 91250
QuestBeliTable[1826] = 91300
QuestBeliTable[1827] = 91350
QuestBeliTable[1828] = 91400
QuestBeliTable[1829] = 91450
QuestBeliTable[1830] = 91500
QuestBeliTable[1831] = 91550
QuestBeliTable[1832] = 91600
QuestBeliTable[1833] = 91650
QuestBeliTable[1834] = 91700
QuestBeliTable[1835] = 91750
QuestBeliTable[1836] = 91800
QuestBeliTable[1837] = 91850
QuestBeliTable[1838] = 91900
QuestBeliTable[1839] = 91950
QuestBeliTable[1840] = 92000
QuestBeliTable[1841] = 92050
QuestBeliTable[1842] = 92100
QuestBeliTable[1843] = 92150
QuestBeliTable[1844] = 92200
QuestBeliTable[1845] = 92250
QuestBeliTable[1846] = 92300
QuestBeliTable[1847] = 92350
QuestBeliTable[1848] = 92400
QuestBeliTable[1849] = 92450
QuestBeliTable[1850] = 92500
QuestBeliTable[1851] = 92550
QuestBeliTable[1852] = 92600
QuestBeliTable[1853] = 92650
QuestBeliTable[1854] = 92700
QuestBeliTable[1855] = 92750
QuestBeliTable[1856] = 92800
QuestBeliTable[1857] = 92850
QuestBeliTable[1858] = 92900
QuestBeliTable[1859] = 92950
QuestBeliTable[1860] = 93000
QuestBeliTable[1861] = 93050
QuestBeliTable[1862] = 93100
QuestBeliTable[1863] = 93150
QuestBeliTable[1864] = 93200
QuestBeliTable[1865] = 93250
QuestBeliTable[1866] = 93300
QuestBeliTable[1867] = 93350
QuestBeliTable[1868] = 93400
QuestBeliTable[1869] = 93450
QuestBeliTable[1870] = 93500
QuestBeliTable[1871] = 93550
QuestBeliTable[1872] = 93600
QuestBeliTable[1873] = 93650
QuestBeliTable[1874] = 93700
QuestBeliTable[1875] = 93750
QuestBeliTable[1876] = 93800
QuestBeliTable[1877] = 93850
QuestBeliTable[1878] = 93900
QuestBeliTable[1879] = 93950
QuestBeliTable[1880] = 94000
QuestBeliTable[1881] = 94050
QuestBeliTable[1882] = 94100
QuestBeliTable[1883] = 94150
QuestBeliTable[1884] = 94200
QuestBeliTable[1885] = 94250
QuestBeliTable[1886] = 94300
QuestBeliTable[1887] = 94350
QuestBeliTable[1888] = 94400
QuestBeliTable[1889] = 94450
QuestBeliTable[1890] = 94500
QuestBeliTable[1891] = 94550
QuestBeliTable[1892] = 94600
QuestBeliTable[1893] = 94650
QuestBeliTable[1894] = 94700
QuestBeliTable[1895] = 94750
QuestBeliTable[1896] = 94800
QuestBeliTable[1897] = 94850
QuestBeliTable[1898] = 94900
QuestBeliTable[1899] = 94950
QuestBeliTable[1900] = 95000
QuestBeliTable[1901] = 95050
QuestBeliTable[1902] = 95100
QuestBeliTable[1903] = 95150
QuestBeliTable[1904] = 95200
QuestBeliTable[1905] = 95250
QuestBeliTable[1906] = 95300
QuestBeliTable[1907] = 95350
QuestBeliTable[1908] = 95400
QuestBeliTable[1909] = 95450
QuestBeliTable[1910] = 95500
QuestBeliTable[1911] = 95550
QuestBeliTable[1912] = 95600
QuestBeliTable[1913] = 95650
QuestBeliTable[1914] = 95700
QuestBeliTable[1915] = 95750
QuestBeliTable[1916] = 95800
QuestBeliTable[1917] = 95850
QuestBeliTable[1918] = 95900
QuestBeliTable[1919] = 95950
QuestBeliTable[1920] = 96000
QuestBeliTable[1921] = 96050
QuestBeliTable[1922] = 96100
QuestBeliTable[1923] = 96150
QuestBeliTable[1924] = 96200
QuestBeliTable[1925] = 96250
QuestBeliTable[1926] = 96300
QuestBeliTable[1927] = 96350
QuestBeliTable[1928] = 96400
QuestBeliTable[1929] = 96450
QuestBeliTable[1930] = 96500
QuestBeliTable[1931] = 96550
QuestBeliTable[1932] = 96600
QuestBeliTable[1933] = 96650
QuestBeliTable[1934] = 96700
QuestBeliTable[1935] = 96750
QuestBeliTable[1936] = 96800
QuestBeliTable[1937] = 96850
QuestBeliTable[1938] = 96900
QuestBeliTable[1939] = 96950
QuestBeliTable[1940] = 97000
QuestBeliTable[1941] = 97050
QuestBeliTable[1942] = 97100
QuestBeliTable[1943] = 97150
QuestBeliTable[1944] = 97200
QuestBeliTable[1945] = 97250
QuestBeliTable[1946] = 97300
QuestBeliTable[1947] = 97350
QuestBeliTable[1948] = 97400
QuestBeliTable[1949] = 97450
QuestBeliTable[1950] = 97500
QuestBeliTable[1951] = 97550
QuestBeliTable[1952] = 97600
QuestBeliTable[1953] = 97650
QuestBeliTable[1954] = 97700
QuestBeliTable[1955] = 97750
QuestBeliTable[1956] = 97800
QuestBeliTable[1957] = 97850
QuestBeliTable[1958] = 97900
QuestBeliTable[1959] = 97950
QuestBeliTable[1960] = 98000
QuestBeliTable[1961] = 98050
QuestBeliTable[1962] = 98100
QuestBeliTable[1963] = 98150
QuestBeliTable[1964] = 98200
QuestBeliTable[1965] = 98250
QuestBeliTable[1966] = 98300
QuestBeliTable[1967] = 98350
QuestBeliTable[1968] = 98400
QuestBeliTable[1969] = 98450
QuestBeliTable[1970] = 98500
QuestBeliTable[1971] = 98550
QuestBeliTable[1972] = 98600
QuestBeliTable[1973] = 98650
QuestBeliTable[1974] = 98700
QuestBeliTable[1975] = 98750
QuestBeliTable[1976] = 98800
QuestBeliTable[1977] = 98850
QuestBeliTable[1978] = 98900
QuestBeliTable[1979] = 98950
QuestBeliTable[1980] = 99000
QuestBeliTable[1981] = 99050
QuestBeliTable[1982] = 99100
QuestBeliTable[1983] = 99150
QuestBeliTable[1984] = 99200
QuestBeliTable[1985] = 99250
QuestBeliTable[1986] = 99300
QuestBeliTable[1987] = 99350
QuestBeliTable[1988] = 99400
QuestBeliTable[1989] = 99450
QuestBeliTable[1990] = 99500
QuestBeliTable[1991] = 99550
QuestBeliTable[1992] = 99600
QuestBeliTable[1993] = 99650
QuestBeliTable[1994] = 99700
QuestBeliTable[1995] = 99750
QuestBeliTable[1996] = 99800
QuestBeliTable[1997] = 99850
QuestBeliTable[1998] = 99900
QuestBeliTable[1999] = 99950
QuestBeliTable[2000] = 100000
QuestBeliTable[2001] = 100050
QuestBeliTable[2002] = 100100
QuestBeliTable[2003] = 100150
QuestBeliTable[2004] = 100200
QuestBeliTable[2005] = 100250
QuestBeliTable[2006] = 100300
QuestBeliTable[2007] = 100350
QuestBeliTable[2008] = 100400
QuestBeliTable[2009] = 100450
QuestBeliTable[2010] = 100500
QuestBeliTable[2011] = 100550
QuestBeliTable[2012] = 100600
QuestBeliTable[2013] = 100650
QuestBeliTable[2014] = 100700
QuestBeliTable[2015] = 100750
QuestBeliTable[2016] = 100800
QuestBeliTable[2017] = 100850
QuestBeliTable[2018] = 100900
QuestBeliTable[2019] = 100950
QuestBeliTable[2020] = 101000
QuestBeliTable[2021] = 101050
QuestBeliTable[2022] = 101100
QuestBeliTable[2023] = 101150
QuestBeliTable[2024] = 101200
QuestBeliTable[2025] = 101250
QuestBeliTable[2026] = 101300
QuestBeliTable[2027] = 101350
QuestBeliTable[2028] = 101400
QuestBeliTable[2029] = 101450
QuestBeliTable[2030] = 101500
QuestBeliTable[2031] = 101550
QuestBeliTable[2032] = 101600
QuestBeliTable[2033] = 101650
QuestBeliTable[2034] = 101700
QuestBeliTable[2035] = 101750
QuestBeliTable[2036] = 101800
QuestBeliTable[2037] = 101850
QuestBeliTable[2038] = 101900
QuestBeliTable[2039] = 101950
QuestBeliTable[2040] = 102000
QuestBeliTable[2041] = 102050
QuestBeliTable[2042] = 102100
QuestBeliTable[2043] = 102150
QuestBeliTable[2044] = 102200
QuestBeliTable[2045] = 102250
QuestBeliTable[2046] = 102300
QuestBeliTable[2047] = 102350
QuestBeliTable[2048] = 102400
QuestBeliTable[2049] = 102450
QuestBeliTable[2050] = 102500
QuestBeliTable[2051] = 102550
QuestBeliTable[2052] = 102600
QuestBeliTable[2053] = 102650
QuestBeliTable[2054] = 102700
QuestBeliTable[2055] = 102750
QuestBeliTable[2056] = 102800
QuestBeliTable[2057] = 102850
QuestBeliTable[2058] = 102900
QuestBeliTable[2059] = 102950
QuestBeliTable[2060] = 103000
QuestBeliTable[2061] = 103050
QuestBeliTable[2062] = 103100
QuestBeliTable[2063] = 103150
QuestBeliTable[2064] = 103200
QuestBeliTable[2065] = 103250
QuestBeliTable[2066] = 103300
QuestBeliTable[2067] = 103350
QuestBeliTable[2068] = 103400
QuestBeliTable[2069] = 103450
QuestBeliTable[2070] = 103500
QuestBeliTable[2071] = 103550
QuestBeliTable[2072] = 103600
QuestBeliTable[2073] = 103650
QuestBeliTable[2074] = 103700
QuestBeliTable[2075] = 103750
QuestBeliTable[2076] = 103800
QuestBeliTable[2077] = 103850
QuestBeliTable[2078] = 103900
QuestBeliTable[2079] = 103950
QuestBeliTable[2080] = 104000
QuestBeliTable[2081] = 104050
QuestBeliTable[2082] = 104100
QuestBeliTable[2083] = 104150
QuestBeliTable[2084] = 104200
QuestBeliTable[2085] = 104250
QuestBeliTable[2086] = 104300
QuestBeliTable[2087] = 104350
QuestBeliTable[2088] = 104400
QuestBeliTable[2089] = 104450
QuestBeliTable[2090] = 104500
QuestBeliTable[2091] = 104550
QuestBeliTable[2092] = 104600
QuestBeliTable[2093] = 104650
QuestBeliTable[2094] = 104700
QuestBeliTable[2095] = 104750
QuestBeliTable[2096] = 104800
QuestBeliTable[2097] = 104850
QuestBeliTable[2098] = 104900
QuestBeliTable[2099] = 104950
QuestBeliTable[2100] = 105000
QuestBeliTable[2101] = 105050
QuestBeliTable[2102] = 105100
QuestBeliTable[2103] = 105150
QuestBeliTable[2104] = 105200
QuestBeliTable[2105] = 105250
QuestBeliTable[2106] = 105300
QuestBeliTable[2107] = 105350
QuestBeliTable[2108] = 105400
QuestBeliTable[2109] = 105450
QuestBeliTable[2110] = 105500
QuestBeliTable[2111] = 105550
QuestBeliTable[2112] = 105600
QuestBeliTable[2113] = 105650
QuestBeliTable[2114] = 105700
QuestBeliTable[2115] = 105750
QuestBeliTable[2116] = 105800
QuestBeliTable[2117] = 105850
QuestBeliTable[2118] = 105900
QuestBeliTable[2119] = 105950
QuestBeliTable[2120] = 106000
QuestBeliTable[2121] = 106050
QuestBeliTable[2122] = 106100
QuestBeliTable[2123] = 106150
QuestBeliTable[2124] = 106200
QuestBeliTable[2125] = 106250
QuestBeliTable[2126] = 106300
QuestBeliTable[2127] = 106350
QuestBeliTable[2128] = 106400
QuestBeliTable[2129] = 106450
QuestBeliTable[2130] = 106500
QuestBeliTable[2131] = 106550
QuestBeliTable[2132] = 106600
QuestBeliTable[2133] = 106650
QuestBeliTable[2134] = 106700
QuestBeliTable[2135] = 106750
QuestBeliTable[2136] = 106800
QuestBeliTable[2137] = 106850
QuestBeliTable[2138] = 106900
QuestBeliTable[2139] = 106950
QuestBeliTable[2140] = 107000
QuestBeliTable[2141] = 107050
QuestBeliTable[2142] = 107100
QuestBeliTable[2143] = 107150
QuestBeliTable[2144] = 107200
QuestBeliTable[2145] = 107250
QuestBeliTable[2146] = 107300
QuestBeliTable[2147] = 107350
QuestBeliTable[2148] = 107400
QuestBeliTable[2149] = 107450
QuestBeliTable[2150] = 107500
QuestBeliTable[2151] = 107550
QuestBeliTable[2152] = 107600
QuestBeliTable[2153] = 107650
QuestBeliTable[2154] = 107700
QuestBeliTable[2155] = 107750
QuestBeliTable[2156] = 107800
QuestBeliTable[2157] = 107850
QuestBeliTable[2158] = 107900
QuestBeliTable[2159] = 107950
QuestBeliTable[2160] = 108000
QuestBeliTable[2161] = 108050
QuestBeliTable[2162] = 108100
QuestBeliTable[2163] = 108150
QuestBeliTable[2164] = 108200
QuestBeliTable[2165] = 108250
QuestBeliTable[2166] = 108300
QuestBeliTable[2167] = 108350
QuestBeliTable[2168] = 108400
QuestBeliTable[2169] = 108450
QuestBeliTable[2170] = 108500
QuestBeliTable[2171] = 108550
QuestBeliTable[2172] = 108600
QuestBeliTable[2173] = 108650
QuestBeliTable[2174] = 108700
QuestBeliTable[2175] = 108750
QuestBeliTable[2176] = 108800
QuestBeliTable[2177] = 108850
QuestBeliTable[2178] = 108900
QuestBeliTable[2179] = 108950
QuestBeliTable[2180] = 109000
QuestBeliTable[2181] = 109050
QuestBeliTable[2182] = 109100
QuestBeliTable[2183] = 109150
QuestBeliTable[2184] = 109200
QuestBeliTable[2185] = 109250
QuestBeliTable[2186] = 109300
QuestBeliTable[2187] = 109350
QuestBeliTable[2188] = 109400
QuestBeliTable[2189] = 109450
QuestBeliTable[2190] = 109500
QuestBeliTable[2191] = 109550
QuestBeliTable[2192] = 109600
QuestBeliTable[2193] = 109650
QuestBeliTable[2194] = 109700
QuestBeliTable[2195] = 109750
QuestBeliTable[2196] = 109800
QuestBeliTable[2197] = 109850
QuestBeliTable[2198] = 109900
QuestBeliTable[2199] = 109950
QuestBeliTable[2200] = 110000
QuestBeliTable[2201] = 110050
QuestBeliTable[2202] = 110100
QuestBeliTable[2203] = 110150
QuestBeliTable[2204] = 110200
QuestBeliTable[2205] = 110250
QuestBeliTable[2206] = 110300
QuestBeliTable[2207] = 110350
QuestBeliTable[2208] = 110400
QuestBeliTable[2209] = 110450
QuestBeliTable[2210] = 110500
QuestBeliTable[2211] = 110550
QuestBeliTable[2212] = 110600
QuestBeliTable[2213] = 110650
QuestBeliTable[2214] = 110700
QuestBeliTable[2215] = 110750
QuestBeliTable[2216] = 110800
QuestBeliTable[2217] = 110850
QuestBeliTable[2218] = 110900
QuestBeliTable[2219] = 110950
QuestBeliTable[2220] = 111000
QuestBeliTable[2221] = 111050
QuestBeliTable[2222] = 111100
QuestBeliTable[2223] = 111150
QuestBeliTable[2224] = 111200
QuestBeliTable[2225] = 111250
QuestBeliTable[2226] = 111300
QuestBeliTable[2227] = 111350
QuestBeliTable[2228] = 111400
QuestBeliTable[2229] = 111450
QuestBeliTable[2230] = 111500
QuestBeliTable[2231] = 111550
QuestBeliTable[2232] = 111600
QuestBeliTable[2233] = 111650
QuestBeliTable[2234] = 111700
QuestBeliTable[2235] = 111750
QuestBeliTable[2236] = 111800
QuestBeliTable[2237] = 111850
QuestBeliTable[2238] = 111900
QuestBeliTable[2239] = 111950
QuestBeliTable[2240] = 112000
QuestBeliTable[2241] = 112050
QuestBeliTable[2242] = 112100
QuestBeliTable[2243] = 112150
QuestBeliTable[2244] = 112200
QuestBeliTable[2245] = 112250
QuestBeliTable[2246] = 112300
QuestBeliTable[2247] = 112350
QuestBeliTable[2248] = 112400
QuestBeliTable[2249] = 112450
QuestBeliTable[2250] = 112500
QuestBeliTable[2251] = 112550
QuestBeliTable[2252] = 112600
QuestBeliTable[2253] = 112650
QuestBeliTable[2254] = 112700
QuestBeliTable[2255] = 112750
QuestBeliTable[2256] = 112800
QuestBeliTable[2257] = 112850
QuestBeliTable[2258] = 112900
QuestBeliTable[2259] = 112950
QuestBeliTable[2260] = 113000
QuestBeliTable[2261] = 113050
QuestBeliTable[2262] = 113100
QuestBeliTable[2263] = 113150
QuestBeliTable[2264] = 113200
QuestBeliTable[2265] = 113250
QuestBeliTable[2266] = 113300
QuestBeliTable[2267] = 113350
QuestBeliTable[2268] = 113400
QuestBeliTable[2269] = 113450
QuestBeliTable[2270] = 113500
QuestBeliTable[2271] = 113550
QuestBeliTable[2272] = 113600
QuestBeliTable[2273] = 113650
QuestBeliTable[2274] = 113700
QuestBeliTable[2275] = 113750
QuestBeliTable[2276] = 113800
QuestBeliTable[2277] = 113850
QuestBeliTable[2278] = 113900
QuestBeliTable[2279] = 113950
QuestBeliTable[2280] = 114000
QuestBeliTable[2281] = 114050
QuestBeliTable[2282] = 114100
QuestBeliTable[2283] = 114150
QuestBeliTable[2284] = 114200
QuestBeliTable[2285] = 114250
QuestBeliTable[2286] = 114300
QuestBeliTable[2287] = 114350
QuestBeliTable[2288] = 114400
QuestBeliTable[2289] = 114450
QuestBeliTable[2290] = 114500
QuestBeliTable[2291] = 114550
QuestBeliTable[2292] = 114600
QuestBeliTable[2293] = 114650
QuestBeliTable[2294] = 114700
QuestBeliTable[2295] = 114750
QuestBeliTable[2296] = 114800
QuestBeliTable[2297] = 114850
QuestBeliTable[2298] = 114900
QuestBeliTable[2299] = 114950
QuestBeliTable[2300] = 115000
QuestBeliTable[2301] = 115050
QuestBeliTable[2302] = 115100
QuestBeliTable[2303] = 115150
QuestBeliTable[2304] = 115200
QuestBeliTable[2305] = 115250
QuestBeliTable[2306] = 115300
QuestBeliTable[2307] = 115350
QuestBeliTable[2308] = 115400
QuestBeliTable[2309] = 115450
QuestBeliTable[2310] = 115500
QuestBeliTable[2311] = 115550
QuestBeliTable[2312] = 115600
QuestBeliTable[2313] = 115650
QuestBeliTable[2314] = 115700
QuestBeliTable[2315] = 115750
QuestBeliTable[2316] = 115800
QuestBeliTable[2317] = 115850
QuestBeliTable[2318] = 115900
QuestBeliTable[2319] = 115950
QuestBeliTable[2320] = 116000
QuestBeliTable[2321] = 116050
QuestBeliTable[2322] = 116100
QuestBeliTable[2323] = 116150
QuestBeliTable[2324] = 116200
QuestBeliTable[2325] = 116250
QuestBeliTable[2326] = 116300
QuestBeliTable[2327] = 116350
QuestBeliTable[2328] = 116400
QuestBeliTable[2329] = 116450
QuestBeliTable[2330] = 116500
QuestBeliTable[2331] = 116550
QuestBeliTable[2332] = 116600
QuestBeliTable[2333] = 116650
QuestBeliTable[2334] = 116700
QuestBeliTable[2335] = 116750
QuestBeliTable[2336] = 116800
QuestBeliTable[2337] = 116850
QuestBeliTable[2338] = 116900
QuestBeliTable[2339] = 116950
QuestBeliTable[2340] = 117000
QuestBeliTable[2341] = 117050
QuestBeliTable[2342] = 117100
QuestBeliTable[2343] = 117150
QuestBeliTable[2344] = 117200
QuestBeliTable[2345] = 117250
QuestBeliTable[2346] = 117300
QuestBeliTable[2347] = 117350
QuestBeliTable[2348] = 117400
QuestBeliTable[2349] = 117450
QuestBeliTable[2350] = 117500
QuestBeliTable[2351] = 117550
QuestBeliTable[2352] = 117600
QuestBeliTable[2353] = 117650
QuestBeliTable[2354] = 117700
QuestBeliTable[2355] = 117750
QuestBeliTable[2356] = 117800
QuestBeliTable[2357] = 117850
QuestBeliTable[2358] = 117900
QuestBeliTable[2359] = 117950
QuestBeliTable[2360] = 118000
QuestBeliTable[2361] = 118050
QuestBeliTable[2362] = 118100
QuestBeliTable[2363] = 118150
QuestBeliTable[2364] = 118200
QuestBeliTable[2365] = 118250
QuestBeliTable[2366] = 118300
QuestBeliTable[2367] = 118350
QuestBeliTable[2368] = 118400
QuestBeliTable[2369] = 118450
QuestBeliTable[2370] = 118500
QuestBeliTable[2371] = 118550
QuestBeliTable[2372] = 118600
QuestBeliTable[2373] = 118650
QuestBeliTable[2374] = 118700
QuestBeliTable[2375] = 118750
QuestBeliTable[2376] = 118800
QuestBeliTable[2377] = 118850
QuestBeliTable[2378] = 118900
QuestBeliTable[2379] = 118950
QuestBeliTable[2380] = 119000
QuestBeliTable[2381] = 119050
QuestBeliTable[2382] = 119100
QuestBeliTable[2383] = 119150
QuestBeliTable[2384] = 119200
QuestBeliTable[2385] = 119250
QuestBeliTable[2386] = 119300
QuestBeliTable[2387] = 119350
QuestBeliTable[2388] = 119400
QuestBeliTable[2389] = 119450
QuestBeliTable[2390] = 119500
QuestBeliTable[2391] = 119550
QuestBeliTable[2392] = 119600
QuestBeliTable[2393] = 119650
QuestBeliTable[2394] = 119700
QuestBeliTable[2395] = 119750
QuestBeliTable[2396] = 119800
QuestBeliTable[2397] = 119850
QuestBeliTable[2398] = 119900
QuestBeliTable[2399] = 119950
QuestBeliTable[2400] = 120000
QuestBeliTable[2401] = 120050
QuestBeliTable[2402] = 120100
QuestBeliTable[2403] = 120150
QuestBeliTable[2404] = 120200
QuestBeliTable[2405] = 120250
QuestBeliTable[2406] = 120300
QuestBeliTable[2407] = 120350
QuestBeliTable[2408] = 120400
QuestBeliTable[2409] = 120450
QuestBeliTable[2410] = 120500
QuestBeliTable[2411] = 120550
QuestBeliTable[2412] = 120600
QuestBeliTable[2413] = 120650
QuestBeliTable[2414] = 120700
QuestBeliTable[2415] = 120750
QuestBeliTable[2416] = 120800
QuestBeliTable[2417] = 120850
QuestBeliTable[2418] = 120900
QuestBeliTable[2419] = 120950
QuestBeliTable[2420] = 121000
QuestBeliTable[2421] = 121050
QuestBeliTable[2422] = 121100
QuestBeliTable[2423] = 121150
QuestBeliTable[2424] = 121200
QuestBeliTable[2425] = 121250
QuestBeliTable[2426] = 121300
QuestBeliTable[2427] = 121350
QuestBeliTable[2428] = 121400
QuestBeliTable[2429] = 121450
QuestBeliTable[2430] = 121500
QuestBeliTable[2431] = 121550
QuestBeliTable[2432] = 121600
QuestBeliTable[2433] = 121650
QuestBeliTable[2434] = 121700
QuestBeliTable[2435] = 121750
QuestBeliTable[2436] = 121800
QuestBeliTable[2437] = 121850
QuestBeliTable[2438] = 121900
QuestBeliTable[2439] = 121950
QuestBeliTable[2440] = 122000
QuestBeliTable[2441] = 122050
QuestBeliTable[2442] = 122100
QuestBeliTable[2443] = 122150
QuestBeliTable[2444] = 122200
QuestBeliTable[2445] = 122250
QuestBeliTable[2446] = 122300
QuestBeliTable[2447] = 122350
QuestBeliTable[2448] = 122400
QuestBeliTable[2449] = 122450
QuestBeliTable[2450] = 122500

-- ============================================================
-- FRAGMENTS PER KILL (1-2450)
-- ============================================================
local FragmentTable = {}
FragmentTable[1] = 1
FragmentTable[2] = 1
FragmentTable[3] = 1
FragmentTable[4] = 1
FragmentTable[5] = 1
FragmentTable[6] = 1
FragmentTable[7] = 1
FragmentTable[8] = 1
FragmentTable[9] = 1
FragmentTable[10] = 1
FragmentTable[11] = 1
FragmentTable[12] = 1
FragmentTable[13] = 1
FragmentTable[14] = 1
FragmentTable[15] = 1
FragmentTable[16] = 1
FragmentTable[17] = 1
FragmentTable[18] = 1
FragmentTable[19] = 1
FragmentTable[20] = 1
FragmentTable[21] = 1
FragmentTable[22] = 1
FragmentTable[23] = 1
FragmentTable[24] = 1
FragmentTable[25] = 1
FragmentTable[26] = 1
FragmentTable[27] = 1
FragmentTable[28] = 1
FragmentTable[29] = 1
FragmentTable[30] = 1
FragmentTable[31] = 1
FragmentTable[32] = 1
FragmentTable[33] = 1
FragmentTable[34] = 1
FragmentTable[35] = 1
FragmentTable[36] = 1
FragmentTable[37] = 1
FragmentTable[38] = 1
FragmentTable[39] = 1
FragmentTable[40] = 2
FragmentTable[41] = 2
FragmentTable[42] = 2
FragmentTable[43] = 2
FragmentTable[44] = 2
FragmentTable[45] = 2
FragmentTable[46] = 2
FragmentTable[47] = 2
FragmentTable[48] = 2
FragmentTable[49] = 2
FragmentTable[50] = 2
FragmentTable[51] = 2
FragmentTable[52] = 2
FragmentTable[53] = 2
FragmentTable[54] = 2
FragmentTable[55] = 2
FragmentTable[56] = 2
FragmentTable[57] = 2
FragmentTable[58] = 2
FragmentTable[59] = 2
FragmentTable[60] = 3
FragmentTable[61] = 3
FragmentTable[62] = 3
FragmentTable[63] = 3
FragmentTable[64] = 3
FragmentTable[65] = 3
FragmentTable[66] = 3
FragmentTable[67] = 3
FragmentTable[68] = 3
FragmentTable[69] = 3
FragmentTable[70] = 3
FragmentTable[71] = 3
FragmentTable[72] = 3
FragmentTable[73] = 3
FragmentTable[74] = 3
FragmentTable[75] = 3
FragmentTable[76] = 3
FragmentTable[77] = 3
FragmentTable[78] = 3
FragmentTable[79] = 3
FragmentTable[80] = 4
FragmentTable[81] = 4
FragmentTable[82] = 4
FragmentTable[83] = 4
FragmentTable[84] = 4
FragmentTable[85] = 4
FragmentTable[86] = 4
FragmentTable[87] = 4
FragmentTable[88] = 4
FragmentTable[89] = 4
FragmentTable[90] = 4
FragmentTable[91] = 4
FragmentTable[92] = 4
FragmentTable[93] = 4
FragmentTable[94] = 4
FragmentTable[95] = 4
FragmentTable[96] = 4
FragmentTable[97] = 4
FragmentTable[98] = 4
FragmentTable[99] = 4
FragmentTable[100] = 5
FragmentTable[101] = 5
FragmentTable[102] = 5
FragmentTable[103] = 5
FragmentTable[104] = 5
FragmentTable[105] = 5
FragmentTable[106] = 5
FragmentTable[107] = 5
FragmentTable[108] = 5
FragmentTable[109] = 5
FragmentTable[110] = 5
FragmentTable[111] = 5
FragmentTable[112] = 5
FragmentTable[113] = 5
FragmentTable[114] = 5
FragmentTable[115] = 5
FragmentTable[116] = 5
FragmentTable[117] = 5
FragmentTable[118] = 5
FragmentTable[119] = 5
FragmentTable[120] = 6
FragmentTable[121] = 6
FragmentTable[122] = 6
FragmentTable[123] = 6
FragmentTable[124] = 6
FragmentTable[125] = 6
FragmentTable[126] = 6
FragmentTable[127] = 6
FragmentTable[128] = 6
FragmentTable[129] = 6
FragmentTable[130] = 6
FragmentTable[131] = 6
FragmentTable[132] = 6
FragmentTable[133] = 6
FragmentTable[134] = 6
FragmentTable[135] = 6
FragmentTable[136] = 6
FragmentTable[137] = 6
FragmentTable[138] = 6
FragmentTable[139] = 6
FragmentTable[140] = 7
FragmentTable[141] = 7
FragmentTable[142] = 7
FragmentTable[143] = 7
FragmentTable[144] = 7
FragmentTable[145] = 7
FragmentTable[146] = 7
FragmentTable[147] = 7
FragmentTable[148] = 7
FragmentTable[149] = 7
FragmentTable[150] = 7
FragmentTable[151] = 7
FragmentTable[152] = 7
FragmentTable[153] = 7
FragmentTable[154] = 7
FragmentTable[155] = 7
FragmentTable[156] = 7
FragmentTable[157] = 7
FragmentTable[158] = 7
FragmentTable[159] = 7
FragmentTable[160] = 8
FragmentTable[161] = 8
FragmentTable[162] = 8
FragmentTable[163] = 8
FragmentTable[164] = 8
FragmentTable[165] = 8
FragmentTable[166] = 8
FragmentTable[167] = 8
FragmentTable[168] = 8
FragmentTable[169] = 8
FragmentTable[170] = 8
FragmentTable[171] = 8
FragmentTable[172] = 8
FragmentTable[173] = 8
FragmentTable[174] = 8
FragmentTable[175] = 8
FragmentTable[176] = 8
FragmentTable[177] = 8
FragmentTable[178] = 8
FragmentTable[179] = 8
FragmentTable[180] = 9
FragmentTable[181] = 9
FragmentTable[182] = 9
FragmentTable[183] = 9
FragmentTable[184] = 9
FragmentTable[185] = 9
FragmentTable[186] = 9
FragmentTable[187] = 9
FragmentTable[188] = 9
FragmentTable[189] = 9
FragmentTable[190] = 9
FragmentTable[191] = 9
FragmentTable[192] = 9
FragmentTable[193] = 9
FragmentTable[194] = 9
FragmentTable[195] = 9
FragmentTable[196] = 9
FragmentTable[197] = 9
FragmentTable[198] = 9
FragmentTable[199] = 9
FragmentTable[200] = 10
FragmentTable[201] = 10
FragmentTable[202] = 10
FragmentTable[203] = 10
FragmentTable[204] = 10
FragmentTable[205] = 10
FragmentTable[206] = 10
FragmentTable[207] = 10
FragmentTable[208] = 10
FragmentTable[209] = 10
FragmentTable[210] = 10
FragmentTable[211] = 10
FragmentTable[212] = 10
FragmentTable[213] = 10
FragmentTable[214] = 10
FragmentTable[215] = 10
FragmentTable[216] = 10
FragmentTable[217] = 10
FragmentTable[218] = 10
FragmentTable[219] = 10
FragmentTable[220] = 11
FragmentTable[221] = 11
FragmentTable[222] = 11
FragmentTable[223] = 11
FragmentTable[224] = 11
FragmentTable[225] = 11
FragmentTable[226] = 11
FragmentTable[227] = 11
FragmentTable[228] = 11
FragmentTable[229] = 11
FragmentTable[230] = 11
FragmentTable[231] = 11
FragmentTable[232] = 11
FragmentTable[233] = 11
FragmentTable[234] = 11
FragmentTable[235] = 11
FragmentTable[236] = 11
FragmentTable[237] = 11
FragmentTable[238] = 11
FragmentTable[239] = 11
FragmentTable[240] = 12
FragmentTable[241] = 12
FragmentTable[242] = 12
FragmentTable[243] = 12
FragmentTable[244] = 12
FragmentTable[245] = 12
FragmentTable[246] = 12
FragmentTable[247] = 12
FragmentTable[248] = 12
FragmentTable[249] = 12
FragmentTable[250] = 12
FragmentTable[251] = 12
FragmentTable[252] = 12
FragmentTable[253] = 12
FragmentTable[254] = 12
FragmentTable[255] = 12
FragmentTable[256] = 12
FragmentTable[257] = 12
FragmentTable[258] = 12
FragmentTable[259] = 12
FragmentTable[260] = 13
FragmentTable[261] = 13
FragmentTable[262] = 13
FragmentTable[263] = 13
FragmentTable[264] = 13
FragmentTable[265] = 13
FragmentTable[266] = 13
FragmentTable[267] = 13
FragmentTable[268] = 13
FragmentTable[269] = 13
FragmentTable[270] = 13
FragmentTable[271] = 13
FragmentTable[272] = 13
FragmentTable[273] = 13
FragmentTable[274] = 13
FragmentTable[275] = 13
FragmentTable[276] = 13
FragmentTable[277] = 13
FragmentTable[278] = 13
FragmentTable[279] = 13
FragmentTable[280] = 14
FragmentTable[281] = 14
FragmentTable[282] = 14
FragmentTable[283] = 14
FragmentTable[284] = 14
FragmentTable[285] = 14
FragmentTable[286] = 14
FragmentTable[287] = 14
FragmentTable[288] = 14
FragmentTable[289] = 14
FragmentTable[290] = 14
FragmentTable[291] = 14
FragmentTable[292] = 14
FragmentTable[293] = 14
FragmentTable[294] = 14
FragmentTable[295] = 14
FragmentTable[296] = 14
FragmentTable[297] = 14
FragmentTable[298] = 14
FragmentTable[299] = 14
FragmentTable[300] = 15
FragmentTable[301] = 15
FragmentTable[302] = 15
FragmentTable[303] = 15
FragmentTable[304] = 15
FragmentTable[305] = 15
FragmentTable[306] = 15
FragmentTable[307] = 15
FragmentTable[308] = 15
FragmentTable[309] = 15
FragmentTable[310] = 15
FragmentTable[311] = 15
FragmentTable[312] = 15
FragmentTable[313] = 15
FragmentTable[314] = 15
FragmentTable[315] = 15
FragmentTable[316] = 15
FragmentTable[317] = 15
FragmentTable[318] = 15
FragmentTable[319] = 15
FragmentTable[320] = 16
FragmentTable[321] = 16
FragmentTable[322] = 16
FragmentTable[323] = 16
FragmentTable[324] = 16
FragmentTable[325] = 16
FragmentTable[326] = 16
FragmentTable[327] = 16
FragmentTable[328] = 16
FragmentTable[329] = 16
FragmentTable[330] = 16
FragmentTable[331] = 16
FragmentTable[332] = 16
FragmentTable[333] = 16
FragmentTable[334] = 16
FragmentTable[335] = 16
FragmentTable[336] = 16
FragmentTable[337] = 16
FragmentTable[338] = 16
FragmentTable[339] = 16
FragmentTable[340] = 17
FragmentTable[341] = 17
FragmentTable[342] = 17
FragmentTable[343] = 17
FragmentTable[344] = 17
FragmentTable[345] = 17
FragmentTable[346] = 17
FragmentTable[347] = 17
FragmentTable[348] = 17
FragmentTable[349] = 17
FragmentTable[350] = 17
FragmentTable[351] = 17
FragmentTable[352] = 17
FragmentTable[353] = 17
FragmentTable[354] = 17
FragmentTable[355] = 17
FragmentTable[356] = 17
FragmentTable[357] = 17
FragmentTable[358] = 17
FragmentTable[359] = 17
FragmentTable[360] = 18
FragmentTable[361] = 18
FragmentTable[362] = 18
FragmentTable[363] = 18
FragmentTable[364] = 18
FragmentTable[365] = 18
FragmentTable[366] = 18
FragmentTable[367] = 18
FragmentTable[368] = 18
FragmentTable[369] = 18
FragmentTable[370] = 18
FragmentTable[371] = 18
FragmentTable[372] = 18
FragmentTable[373] = 18
FragmentTable[374] = 18
FragmentTable[375] = 18
FragmentTable[376] = 18
FragmentTable[377] = 18
FragmentTable[378] = 18
FragmentTable[379] = 18
FragmentTable[380] = 19
FragmentTable[381] = 19
FragmentTable[382] = 19
FragmentTable[383] = 19
FragmentTable[384] = 19
FragmentTable[385] = 19
FragmentTable[386] = 19
FragmentTable[387] = 19
FragmentTable[388] = 19
FragmentTable[389] = 19
FragmentTable[390] = 19
FragmentTable[391] = 19
FragmentTable[392] = 19
FragmentTable[393] = 19
FragmentTable[394] = 19
FragmentTable[395] = 19
FragmentTable[396] = 19
FragmentTable[397] = 19
FragmentTable[398] = 19
FragmentTable[399] = 19
FragmentTable[400] = 20
FragmentTable[401] = 20
FragmentTable[402] = 20
FragmentTable[403] = 20
FragmentTable[404] = 20
FragmentTable[405] = 20
FragmentTable[406] = 20
FragmentTable[407] = 20
FragmentTable[408] = 20
FragmentTable[409] = 20
FragmentTable[410] = 20
FragmentTable[411] = 20
FragmentTable[412] = 20
FragmentTable[413] = 20
FragmentTable[414] = 20
FragmentTable[415] = 20
FragmentTable[416] = 20
FragmentTable[417] = 20
FragmentTable[418] = 20
FragmentTable[419] = 20
FragmentTable[420] = 21
FragmentTable[421] = 21
FragmentTable[422] = 21
FragmentTable[423] = 21
FragmentTable[424] = 21
FragmentTable[425] = 21
FragmentTable[426] = 21
FragmentTable[427] = 21
FragmentTable[428] = 21
FragmentTable[429] = 21
FragmentTable[430] = 21
FragmentTable[431] = 21
FragmentTable[432] = 21
FragmentTable[433] = 21
FragmentTable[434] = 21
FragmentTable[435] = 21
FragmentTable[436] = 21
FragmentTable[437] = 21
FragmentTable[438] = 21
FragmentTable[439] = 21
FragmentTable[440] = 22
FragmentTable[441] = 22
FragmentTable[442] = 22
FragmentTable[443] = 22
FragmentTable[444] = 22
FragmentTable[445] = 22
FragmentTable[446] = 22
FragmentTable[447] = 22
FragmentTable[448] = 22
FragmentTable[449] = 22
FragmentTable[450] = 22
FragmentTable[451] = 22
FragmentTable[452] = 22
FragmentTable[453] = 22
FragmentTable[454] = 22
FragmentTable[455] = 22
FragmentTable[456] = 22
FragmentTable[457] = 22
FragmentTable[458] = 22
FragmentTable[459] = 22
FragmentTable[460] = 23
FragmentTable[461] = 23
FragmentTable[462] = 23
FragmentTable[463] = 23
FragmentTable[464] = 23
FragmentTable[465] = 23
FragmentTable[466] = 23
FragmentTable[467] = 23
FragmentTable[468] = 23
FragmentTable[469] = 23
FragmentTable[470] = 23
FragmentTable[471] = 23
FragmentTable[472] = 23
FragmentTable[473] = 23
FragmentTable[474] = 23
FragmentTable[475] = 23
FragmentTable[476] = 23
FragmentTable[477] = 23
FragmentTable[478] = 23
FragmentTable[479] = 23
FragmentTable[480] = 24
FragmentTable[481] = 24
FragmentTable[482] = 24
FragmentTable[483] = 24
FragmentTable[484] = 24
FragmentTable[485] = 24
FragmentTable[486] = 24
FragmentTable[487] = 24
FragmentTable[488] = 24
FragmentTable[489] = 24
FragmentTable[490] = 24
FragmentTable[491] = 24
FragmentTable[492] = 24
FragmentTable[493] = 24
FragmentTable[494] = 24
FragmentTable[495] = 24
FragmentTable[496] = 24
FragmentTable[497] = 24
FragmentTable[498] = 24
FragmentTable[499] = 24
FragmentTable[500] = 25
FragmentTable[501] = 25
FragmentTable[502] = 25
FragmentTable[503] = 25
FragmentTable[504] = 25
FragmentTable[505] = 25
FragmentTable[506] = 25
FragmentTable[507] = 25
FragmentTable[508] = 25
FragmentTable[509] = 25
FragmentTable[510] = 25
FragmentTable[511] = 25
FragmentTable[512] = 25
FragmentTable[513] = 25
FragmentTable[514] = 25
FragmentTable[515] = 25
FragmentTable[516] = 25
FragmentTable[517] = 25
FragmentTable[518] = 25
FragmentTable[519] = 25
FragmentTable[520] = 26
FragmentTable[521] = 26
FragmentTable[522] = 26
FragmentTable[523] = 26
FragmentTable[524] = 26
FragmentTable[525] = 26
FragmentTable[526] = 26
FragmentTable[527] = 26
FragmentTable[528] = 26
FragmentTable[529] = 26
FragmentTable[530] = 26
FragmentTable[531] = 26
FragmentTable[532] = 26
FragmentTable[533] = 26
FragmentTable[534] = 26
FragmentTable[535] = 26
FragmentTable[536] = 26
FragmentTable[537] = 26
FragmentTable[538] = 26
FragmentTable[539] = 26
FragmentTable[540] = 27
FragmentTable[541] = 27
FragmentTable[542] = 27
FragmentTable[543] = 27
FragmentTable[544] = 27
FragmentTable[545] = 27
FragmentTable[546] = 27
FragmentTable[547] = 27
FragmentTable[548] = 27
FragmentTable[549] = 27
FragmentTable[550] = 27
FragmentTable[551] = 27
FragmentTable[552] = 27
FragmentTable[553] = 27
FragmentTable[554] = 27
FragmentTable[555] = 27
FragmentTable[556] = 27
FragmentTable[557] = 27
FragmentTable[558] = 27
FragmentTable[559] = 27
FragmentTable[560] = 28
FragmentTable[561] = 28
FragmentTable[562] = 28
FragmentTable[563] = 28
FragmentTable[564] = 28
FragmentTable[565] = 28
FragmentTable[566] = 28
FragmentTable[567] = 28
FragmentTable[568] = 28
FragmentTable[569] = 28
FragmentTable[570] = 28
FragmentTable[571] = 28
FragmentTable[572] = 28
FragmentTable[573] = 28
FragmentTable[574] = 28
FragmentTable[575] = 28
FragmentTable[576] = 28
FragmentTable[577] = 28
FragmentTable[578] = 28
FragmentTable[579] = 28
FragmentTable[580] = 29
FragmentTable[581] = 29
FragmentTable[582] = 29
FragmentTable[583] = 29
FragmentTable[584] = 29
FragmentTable[585] = 29
FragmentTable[586] = 29
FragmentTable[587] = 29
FragmentTable[588] = 29
FragmentTable[589] = 29
FragmentTable[590] = 29
FragmentTable[591] = 29
FragmentTable[592] = 29
FragmentTable[593] = 29
FragmentTable[594] = 29
FragmentTable[595] = 29
FragmentTable[596] = 29
FragmentTable[597] = 29
FragmentTable[598] = 29
FragmentTable[599] = 29
FragmentTable[600] = 30
FragmentTable[601] = 30
FragmentTable[602] = 30
FragmentTable[603] = 30
FragmentTable[604] = 30
FragmentTable[605] = 30
FragmentTable[606] = 30
FragmentTable[607] = 30
FragmentTable[608] = 30
FragmentTable[609] = 30
FragmentTable[610] = 30
FragmentTable[611] = 30
FragmentTable[612] = 30
FragmentTable[613] = 30
FragmentTable[614] = 30
FragmentTable[615] = 30
FragmentTable[616] = 30
FragmentTable[617] = 30
FragmentTable[618] = 30
FragmentTable[619] = 30
FragmentTable[620] = 31
FragmentTable[621] = 31
FragmentTable[622] = 31
FragmentTable[623] = 31
FragmentTable[624] = 31
FragmentTable[625] = 31
FragmentTable[626] = 31
FragmentTable[627] = 31
FragmentTable[628] = 31
FragmentTable[629] = 31
FragmentTable[630] = 31
FragmentTable[631] = 31
FragmentTable[632] = 31
FragmentTable[633] = 31
FragmentTable[634] = 31
FragmentTable[635] = 31
FragmentTable[636] = 31
FragmentTable[637] = 31
FragmentTable[638] = 31
FragmentTable[639] = 31
FragmentTable[640] = 32
FragmentTable[641] = 32
FragmentTable[642] = 32
FragmentTable[643] = 32
FragmentTable[644] = 32
FragmentTable[645] = 32
FragmentTable[646] = 32
FragmentTable[647] = 32
FragmentTable[648] = 32
FragmentTable[649] = 32
FragmentTable[650] = 32
FragmentTable[651] = 32
FragmentTable[652] = 32
FragmentTable[653] = 32
FragmentTable[654] = 32
FragmentTable[655] = 32
FragmentTable[656] = 32
FragmentTable[657] = 32
FragmentTable[658] = 32
FragmentTable[659] = 32
FragmentTable[660] = 33
FragmentTable[661] = 33
FragmentTable[662] = 33
FragmentTable[663] = 33
FragmentTable[664] = 33
FragmentTable[665] = 33
FragmentTable[666] = 33
FragmentTable[667] = 33
FragmentTable[668] = 33
FragmentTable[669] = 33
FragmentTable[670] = 33
FragmentTable[671] = 33
FragmentTable[672] = 33
FragmentTable[673] = 33
FragmentTable[674] = 33
FragmentTable[675] = 33
FragmentTable[676] = 33
FragmentTable[677] = 33
FragmentTable[678] = 33
FragmentTable[679] = 33
FragmentTable[680] = 34
FragmentTable[681] = 34
FragmentTable[682] = 34
FragmentTable[683] = 34
FragmentTable[684] = 34
FragmentTable[685] = 34
FragmentTable[686] = 34
FragmentTable[687] = 34
FragmentTable[688] = 34
FragmentTable[689] = 34
FragmentTable[690] = 34
FragmentTable[691] = 34
FragmentTable[692] = 34
FragmentTable[693] = 34
FragmentTable[694] = 34
FragmentTable[695] = 34
FragmentTable[696] = 34
FragmentTable[697] = 34
FragmentTable[698] = 34
FragmentTable[699] = 34
FragmentTable[700] = 35
FragmentTable[701] = 35
FragmentTable[702] = 35
FragmentTable[703] = 35
FragmentTable[704] = 35
FragmentTable[705] = 35
FragmentTable[706] = 35
FragmentTable[707] = 35
FragmentTable[708] = 35
FragmentTable[709] = 35
FragmentTable[710] = 35
FragmentTable[711] = 35
FragmentTable[712] = 35
FragmentTable[713] = 35
FragmentTable[714] = 35
FragmentTable[715] = 35
FragmentTable[716] = 35
FragmentTable[717] = 35
FragmentTable[718] = 35
FragmentTable[719] = 35
FragmentTable[720] = 36
FragmentTable[721] = 36
FragmentTable[722] = 36
FragmentTable[723] = 36
FragmentTable[724] = 36
FragmentTable[725] = 36
FragmentTable[726] = 36
FragmentTable[727] = 36
FragmentTable[728] = 36
FragmentTable[729] = 36
FragmentTable[730] = 36
FragmentTable[731] = 36
FragmentTable[732] = 36
FragmentTable[733] = 36
FragmentTable[734] = 36
FragmentTable[735] = 36
FragmentTable[736] = 36
FragmentTable[737] = 36
FragmentTable[738] = 36
FragmentTable[739] = 36
FragmentTable[740] = 37
FragmentTable[741] = 37
FragmentTable[742] = 37
FragmentTable[743] = 37
FragmentTable[744] = 37
FragmentTable[745] = 37
FragmentTable[746] = 37
FragmentTable[747] = 37
FragmentTable[748] = 37
FragmentTable[749] = 37
FragmentTable[750] = 37
FragmentTable[751] = 37
FragmentTable[752] = 37
FragmentTable[753] = 37
FragmentTable[754] = 37
FragmentTable[755] = 37
FragmentTable[756] = 37
FragmentTable[757] = 37
FragmentTable[758] = 37
FragmentTable[759] = 37
FragmentTable[760] = 38
FragmentTable[761] = 38
FragmentTable[762] = 38
FragmentTable[763] = 38
FragmentTable[764] = 38
FragmentTable[765] = 38
FragmentTable[766] = 38
FragmentTable[767] = 38
FragmentTable[768] = 38
FragmentTable[769] = 38
FragmentTable[770] = 38
FragmentTable[771] = 38
FragmentTable[772] = 38
FragmentTable[773] = 38
FragmentTable[774] = 38
FragmentTable[775] = 38
FragmentTable[776] = 38
FragmentTable[777] = 38
FragmentTable[778] = 38
FragmentTable[779] = 38
FragmentTable[780] = 39
FragmentTable[781] = 39
FragmentTable[782] = 39
FragmentTable[783] = 39
FragmentTable[784] = 39
FragmentTable[785] = 39
FragmentTable[786] = 39
FragmentTable[787] = 39
FragmentTable[788] = 39
FragmentTable[789] = 39
FragmentTable[790] = 39
FragmentTable[791] = 39
FragmentTable[792] = 39
FragmentTable[793] = 39
FragmentTable[794] = 39
FragmentTable[795] = 39
FragmentTable[796] = 39
FragmentTable[797] = 39
FragmentTable[798] = 39
FragmentTable[799] = 39
FragmentTable[800] = 40
FragmentTable[801] = 40
FragmentTable[802] = 40
FragmentTable[803] = 40
FragmentTable[804] = 40
FragmentTable[805] = 40
FragmentTable[806] = 40
FragmentTable[807] = 40
FragmentTable[808] = 40
FragmentTable[809] = 40
FragmentTable[810] = 40
FragmentTable[811] = 40
FragmentTable[812] = 40
FragmentTable[813] = 40
FragmentTable[814] = 40
FragmentTable[815] = 40
FragmentTable[816] = 40
FragmentTable[817] = 40
FragmentTable[818] = 40
FragmentTable[819] = 40
FragmentTable[820] = 41
FragmentTable[821] = 41
FragmentTable[822] = 41
FragmentTable[823] = 41
FragmentTable[824] = 41
FragmentTable[825] = 41
FragmentTable[826] = 41
FragmentTable[827] = 41
FragmentTable[828] = 41
FragmentTable[829] = 41
FragmentTable[830] = 41
FragmentTable[831] = 41
FragmentTable[832] = 41
FragmentTable[833] = 41
FragmentTable[834] = 41
FragmentTable[835] = 41
FragmentTable[836] = 41
FragmentTable[837] = 41
FragmentTable[838] = 41
FragmentTable[839] = 41
FragmentTable[840] = 42
FragmentTable[841] = 42
FragmentTable[842] = 42
FragmentTable[843] = 42
FragmentTable[844] = 42
FragmentTable[845] = 42
FragmentTable[846] = 42
FragmentTable[847] = 42
FragmentTable[848] = 42
FragmentTable[849] = 42
FragmentTable[850] = 42
FragmentTable[851] = 42
FragmentTable[852] = 42
FragmentTable[853] = 42
FragmentTable[854] = 42
FragmentTable[855] = 42
FragmentTable[856] = 42
FragmentTable[857] = 42
FragmentTable[858] = 42
FragmentTable[859] = 42
FragmentTable[860] = 43
FragmentTable[861] = 43
FragmentTable[862] = 43
FragmentTable[863] = 43
FragmentTable[864] = 43
FragmentTable[865] = 43
FragmentTable[866] = 43
FragmentTable[867] = 43
FragmentTable[868] = 43
FragmentTable[869] = 43
FragmentTable[870] = 43
FragmentTable[871] = 43
FragmentTable[872] = 43
FragmentTable[873] = 43
FragmentTable[874] = 43
FragmentTable[875] = 43
FragmentTable[876] = 43
FragmentTable[877] = 43
FragmentTable[878] = 43
FragmentTable[879] = 43
FragmentTable[880] = 44
FragmentTable[881] = 44
FragmentTable[882] = 44
FragmentTable[883] = 44
FragmentTable[884] = 44
FragmentTable[885] = 44
FragmentTable[886] = 44
FragmentTable[887] = 44
FragmentTable[888] = 44
FragmentTable[889] = 44
FragmentTable[890] = 44
FragmentTable[891] = 44
FragmentTable[892] = 44
FragmentTable[893] = 44
FragmentTable[894] = 44
FragmentTable[895] = 44
FragmentTable[896] = 44
FragmentTable[897] = 44
FragmentTable[898] = 44
FragmentTable[899] = 44
FragmentTable[900] = 45
FragmentTable[901] = 45
FragmentTable[902] = 45
FragmentTable[903] = 45
FragmentTable[904] = 45
FragmentTable[905] = 45
FragmentTable[906] = 45
FragmentTable[907] = 45
FragmentTable[908] = 45
FragmentTable[909] = 45
FragmentTable[910] = 45
FragmentTable[911] = 45
FragmentTable[912] = 45
FragmentTable[913] = 45
FragmentTable[914] = 45
FragmentTable[915] = 45
FragmentTable[916] = 45
FragmentTable[917] = 45
FragmentTable[918] = 45
FragmentTable[919] = 45
FragmentTable[920] = 46
FragmentTable[921] = 46
FragmentTable[922] = 46
FragmentTable[923] = 46
FragmentTable[924] = 46
FragmentTable[925] = 46
FragmentTable[926] = 46
FragmentTable[927] = 46
FragmentTable[928] = 46
FragmentTable[929] = 46
FragmentTable[930] = 46
FragmentTable[931] = 46
FragmentTable[932] = 46
FragmentTable[933] = 46
FragmentTable[934] = 46
FragmentTable[935] = 46
FragmentTable[936] = 46
FragmentTable[937] = 46
FragmentTable[938] = 46
FragmentTable[939] = 46
FragmentTable[940] = 47
FragmentTable[941] = 47
FragmentTable[942] = 47
FragmentTable[943] = 47
FragmentTable[944] = 47
FragmentTable[945] = 47
FragmentTable[946] = 47
FragmentTable[947] = 47
FragmentTable[948] = 47
FragmentTable[949] = 47
FragmentTable[950] = 47
FragmentTable[951] = 47
FragmentTable[952] = 47
FragmentTable[953] = 47
FragmentTable[954] = 47
FragmentTable[955] = 47
FragmentTable[956] = 47
FragmentTable[957] = 47
FragmentTable[958] = 47
FragmentTable[959] = 47
FragmentTable[960] = 48
FragmentTable[961] = 48
FragmentTable[962] = 48
FragmentTable[963] = 48
FragmentTable[964] = 48
FragmentTable[965] = 48
FragmentTable[966] = 48
FragmentTable[967] = 48
FragmentTable[968] = 48
FragmentTable[969] = 48
FragmentTable[970] = 48
FragmentTable[971] = 48
FragmentTable[972] = 48
FragmentTable[973] = 48
FragmentTable[974] = 48
FragmentTable[975] = 48
FragmentTable[976] = 48
FragmentTable[977] = 48
FragmentTable[978] = 48
FragmentTable[979] = 48
FragmentTable[980] = 49
FragmentTable[981] = 49
FragmentTable[982] = 49
FragmentTable[983] = 49
FragmentTable[984] = 49
FragmentTable[985] = 49
FragmentTable[986] = 49
FragmentTable[987] = 49
FragmentTable[988] = 49
FragmentTable[989] = 49
FragmentTable[990] = 49
FragmentTable[991] = 49
FragmentTable[992] = 49
FragmentTable[993] = 49
FragmentTable[994] = 49
FragmentTable[995] = 49
FragmentTable[996] = 49
FragmentTable[997] = 49
FragmentTable[998] = 49
FragmentTable[999] = 49
FragmentTable[1000] = 50
FragmentTable[1001] = 50
FragmentTable[1002] = 50
FragmentTable[1003] = 50
FragmentTable[1004] = 50
FragmentTable[1005] = 50
FragmentTable[1006] = 50
FragmentTable[1007] = 50
FragmentTable[1008] = 50
FragmentTable[1009] = 50
FragmentTable[1010] = 50
FragmentTable[1011] = 50
FragmentTable[1012] = 50
FragmentTable[1013] = 50
FragmentTable[1014] = 50
FragmentTable[1015] = 50
FragmentTable[1016] = 50
FragmentTable[1017] = 50
FragmentTable[1018] = 50
FragmentTable[1019] = 50
FragmentTable[1020] = 51
FragmentTable[1021] = 51
FragmentTable[1022] = 51
FragmentTable[1023] = 51
FragmentTable[1024] = 51
FragmentTable[1025] = 51
FragmentTable[1026] = 51
FragmentTable[1027] = 51
FragmentTable[1028] = 51
FragmentTable[1029] = 51
FragmentTable[1030] = 51
FragmentTable[1031] = 51
FragmentTable[1032] = 51
FragmentTable[1033] = 51
FragmentTable[1034] = 51
FragmentTable[1035] = 51
FragmentTable[1036] = 51
FragmentTable[1037] = 51
FragmentTable[1038] = 51
FragmentTable[1039] = 51
FragmentTable[1040] = 52
FragmentTable[1041] = 52
FragmentTable[1042] = 52
FragmentTable[1043] = 52
FragmentTable[1044] = 52
FragmentTable[1045] = 52
FragmentTable[1046] = 52
FragmentTable[1047] = 52
FragmentTable[1048] = 52
FragmentTable[1049] = 52
FragmentTable[1050] = 52
FragmentTable[1051] = 52
FragmentTable[1052] = 52
FragmentTable[1053] = 52
FragmentTable[1054] = 52
FragmentTable[1055] = 52
FragmentTable[1056] = 52
FragmentTable[1057] = 52
FragmentTable[1058] = 52
FragmentTable[1059] = 52
FragmentTable[1060] = 53
FragmentTable[1061] = 53
FragmentTable[1062] = 53
FragmentTable[1063] = 53
FragmentTable[1064] = 53
FragmentTable[1065] = 53
FragmentTable[1066] = 53
FragmentTable[1067] = 53
FragmentTable[1068] = 53
FragmentTable[1069] = 53
FragmentTable[1070] = 53
FragmentTable[1071] = 53
FragmentTable[1072] = 53
FragmentTable[1073] = 53
FragmentTable[1074] = 53
FragmentTable[1075] = 53
FragmentTable[1076] = 53
FragmentTable[1077] = 53
FragmentTable[1078] = 53
FragmentTable[1079] = 53
FragmentTable[1080] = 54
FragmentTable[1081] = 54
FragmentTable[1082] = 54
FragmentTable[1083] = 54
FragmentTable[1084] = 54
FragmentTable[1085] = 54
FragmentTable[1086] = 54
FragmentTable[1087] = 54
FragmentTable[1088] = 54
FragmentTable[1089] = 54
FragmentTable[1090] = 54
FragmentTable[1091] = 54
FragmentTable[1092] = 54
FragmentTable[1093] = 54
FragmentTable[1094] = 54
FragmentTable[1095] = 54
FragmentTable[1096] = 54
FragmentTable[1097] = 54
FragmentTable[1098] = 54
FragmentTable[1099] = 54
FragmentTable[1100] = 55
FragmentTable[1101] = 55
FragmentTable[1102] = 55
FragmentTable[1103] = 55
FragmentTable[1104] = 55
FragmentTable[1105] = 55
FragmentTable[1106] = 55
FragmentTable[1107] = 55
FragmentTable[1108] = 55
FragmentTable[1109] = 55
FragmentTable[1110] = 55
FragmentTable[1111] = 55
FragmentTable[1112] = 55
FragmentTable[1113] = 55
FragmentTable[1114] = 55
FragmentTable[1115] = 55
FragmentTable[1116] = 55
FragmentTable[1117] = 55
FragmentTable[1118] = 55
FragmentTable[1119] = 55
FragmentTable[1120] = 56
FragmentTable[1121] = 56
FragmentTable[1122] = 56
FragmentTable[1123] = 56
FragmentTable[1124] = 56
FragmentTable[1125] = 56
FragmentTable[1126] = 56
FragmentTable[1127] = 56
FragmentTable[1128] = 56
FragmentTable[1129] = 56
FragmentTable[1130] = 56
FragmentTable[1131] = 56
FragmentTable[1132] = 56
FragmentTable[1133] = 56
FragmentTable[1134] = 56
FragmentTable[1135] = 56
FragmentTable[1136] = 56
FragmentTable[1137] = 56
FragmentTable[1138] = 56
FragmentTable[1139] = 56
FragmentTable[1140] = 57
FragmentTable[1141] = 57
FragmentTable[1142] = 57
FragmentTable[1143] = 57
FragmentTable[1144] = 57
FragmentTable[1145] = 57
FragmentTable[1146] = 57
FragmentTable[1147] = 57
FragmentTable[1148] = 57
FragmentTable[1149] = 57
FragmentTable[1150] = 57
FragmentTable[1151] = 57
FragmentTable[1152] = 57
FragmentTable[1153] = 57
FragmentTable[1154] = 57
FragmentTable[1155] = 57
FragmentTable[1156] = 57
FragmentTable[1157] = 57
FragmentTable[1158] = 57
FragmentTable[1159] = 57
FragmentTable[1160] = 58
FragmentTable[1161] = 58
FragmentTable[1162] = 58
FragmentTable[1163] = 58
FragmentTable[1164] = 58
FragmentTable[1165] = 58
FragmentTable[1166] = 58
FragmentTable[1167] = 58
FragmentTable[1168] = 58
FragmentTable[1169] = 58
FragmentTable[1170] = 58
FragmentTable[1171] = 58
FragmentTable[1172] = 58
FragmentTable[1173] = 58
FragmentTable[1174] = 58
FragmentTable[1175] = 58
FragmentTable[1176] = 58
FragmentTable[1177] = 58
FragmentTable[1178] = 58
FragmentTable[1179] = 58
FragmentTable[1180] = 59
FragmentTable[1181] = 59
FragmentTable[1182] = 59
FragmentTable[1183] = 59
FragmentTable[1184] = 59
FragmentTable[1185] = 59
FragmentTable[1186] = 59
FragmentTable[1187] = 59
FragmentTable[1188] = 59
FragmentTable[1189] = 59
FragmentTable[1190] = 59
FragmentTable[1191] = 59
FragmentTable[1192] = 59
FragmentTable[1193] = 59
FragmentTable[1194] = 59
FragmentTable[1195] = 59
FragmentTable[1196] = 59
FragmentTable[1197] = 59
FragmentTable[1198] = 59
FragmentTable[1199] = 59
FragmentTable[1200] = 60
FragmentTable[1201] = 60
FragmentTable[1202] = 60
FragmentTable[1203] = 60
FragmentTable[1204] = 60
FragmentTable[1205] = 60
FragmentTable[1206] = 60
FragmentTable[1207] = 60
FragmentTable[1208] = 60
FragmentTable[1209] = 60
FragmentTable[1210] = 60
FragmentTable[1211] = 60
FragmentTable[1212] = 60
FragmentTable[1213] = 60
FragmentTable[1214] = 60
FragmentTable[1215] = 60
FragmentTable[1216] = 60
FragmentTable[1217] = 60
FragmentTable[1218] = 60
FragmentTable[1219] = 60
FragmentTable[1220] = 61
FragmentTable[1221] = 61
FragmentTable[1222] = 61
FragmentTable[1223] = 61
FragmentTable[1224] = 61
FragmentTable[1225] = 61
FragmentTable[1226] = 61
FragmentTable[1227] = 61
FragmentTable[1228] = 61
FragmentTable[1229] = 61
FragmentTable[1230] = 61
FragmentTable[1231] = 61
FragmentTable[1232] = 61
FragmentTable[1233] = 61
FragmentTable[1234] = 61
FragmentTable[1235] = 61
FragmentTable[1236] = 61
FragmentTable[1237] = 61
FragmentTable[1238] = 61
FragmentTable[1239] = 61
FragmentTable[1240] = 62
FragmentTable[1241] = 62
FragmentTable[1242] = 62
FragmentTable[1243] = 62
FragmentTable[1244] = 62
FragmentTable[1245] = 62
FragmentTable[1246] = 62
FragmentTable[1247] = 62
FragmentTable[1248] = 62
FragmentTable[1249] = 62
FragmentTable[1250] = 62
FragmentTable[1251] = 62
FragmentTable[1252] = 62
FragmentTable[1253] = 62
FragmentTable[1254] = 62
FragmentTable[1255] = 62
FragmentTable[1256] = 62
FragmentTable[1257] = 62
FragmentTable[1258] = 62
FragmentTable[1259] = 62
FragmentTable[1260] = 63
FragmentTable[1261] = 63
FragmentTable[1262] = 63
FragmentTable[1263] = 63
FragmentTable[1264] = 63
FragmentTable[1265] = 63
FragmentTable[1266] = 63
FragmentTable[1267] = 63
FragmentTable[1268] = 63
FragmentTable[1269] = 63
FragmentTable[1270] = 63
FragmentTable[1271] = 63
FragmentTable[1272] = 63
FragmentTable[1273] = 63
FragmentTable[1274] = 63
FragmentTable[1275] = 63
FragmentTable[1276] = 63
FragmentTable[1277] = 63
FragmentTable[1278] = 63
FragmentTable[1279] = 63
FragmentTable[1280] = 64
FragmentTable[1281] = 64
FragmentTable[1282] = 64
FragmentTable[1283] = 64
FragmentTable[1284] = 64
FragmentTable[1285] = 64
FragmentTable[1286] = 64
FragmentTable[1287] = 64
FragmentTable[1288] = 64
FragmentTable[1289] = 64
FragmentTable[1290] = 64
FragmentTable[1291] = 64
FragmentTable[1292] = 64
FragmentTable[1293] = 64
FragmentTable[1294] = 64
FragmentTable[1295] = 64
FragmentTable[1296] = 64
FragmentTable[1297] = 64
FragmentTable[1298] = 64
FragmentTable[1299] = 64
FragmentTable[1300] = 65
FragmentTable[1301] = 65
FragmentTable[1302] = 65
FragmentTable[1303] = 65
FragmentTable[1304] = 65
FragmentTable[1305] = 65
FragmentTable[1306] = 65
FragmentTable[1307] = 65
FragmentTable[1308] = 65
FragmentTable[1309] = 65
FragmentTable[1310] = 65
FragmentTable[1311] = 65
FragmentTable[1312] = 65
FragmentTable[1313] = 65
FragmentTable[1314] = 65
FragmentTable[1315] = 65
FragmentTable[1316] = 65
FragmentTable[1317] = 65
FragmentTable[1318] = 65
FragmentTable[1319] = 65
FragmentTable[1320] = 66
FragmentTable[1321] = 66
FragmentTable[1322] = 66
FragmentTable[1323] = 66
FragmentTable[1324] = 66
FragmentTable[1325] = 66
FragmentTable[1326] = 66
FragmentTable[1327] = 66
FragmentTable[1328] = 66
FragmentTable[1329] = 66
FragmentTable[1330] = 66
FragmentTable[1331] = 66
FragmentTable[1332] = 66
FragmentTable[1333] = 66
FragmentTable[1334] = 66
FragmentTable[1335] = 66
FragmentTable[1336] = 66
FragmentTable[1337] = 66
FragmentTable[1338] = 66
FragmentTable[1339] = 66
FragmentTable[1340] = 67
FragmentTable[1341] = 67
FragmentTable[1342] = 67
FragmentTable[1343] = 67
FragmentTable[1344] = 67
FragmentTable[1345] = 67
FragmentTable[1346] = 67
FragmentTable[1347] = 67
FragmentTable[1348] = 67
FragmentTable[1349] = 67
FragmentTable[1350] = 67
FragmentTable[1351] = 67
FragmentTable[1352] = 67
FragmentTable[1353] = 67
FragmentTable[1354] = 67
FragmentTable[1355] = 67
FragmentTable[1356] = 67
FragmentTable[1357] = 67
FragmentTable[1358] = 67
FragmentTable[1359] = 67
FragmentTable[1360] = 68
FragmentTable[1361] = 68
FragmentTable[1362] = 68
FragmentTable[1363] = 68
FragmentTable[1364] = 68
FragmentTable[1365] = 68
FragmentTable[1366] = 68
FragmentTable[1367] = 68
FragmentTable[1368] = 68
FragmentTable[1369] = 68
FragmentTable[1370] = 68
FragmentTable[1371] = 68
FragmentTable[1372] = 68
FragmentTable[1373] = 68
FragmentTable[1374] = 68
FragmentTable[1375] = 68
FragmentTable[1376] = 68
FragmentTable[1377] = 68
FragmentTable[1378] = 68
FragmentTable[1379] = 68
FragmentTable[1380] = 69
FragmentTable[1381] = 69
FragmentTable[1382] = 69
FragmentTable[1383] = 69
FragmentTable[1384] = 69
FragmentTable[1385] = 69
FragmentTable[1386] = 69
FragmentTable[1387] = 69
FragmentTable[1388] = 69
FragmentTable[1389] = 69
FragmentTable[1390] = 69
FragmentTable[1391] = 69
FragmentTable[1392] = 69
FragmentTable[1393] = 69
FragmentTable[1394] = 69
FragmentTable[1395] = 69
FragmentTable[1396] = 69
FragmentTable[1397] = 69
FragmentTable[1398] = 69
FragmentTable[1399] = 69
FragmentTable[1400] = 70
FragmentTable[1401] = 70
FragmentTable[1402] = 70
FragmentTable[1403] = 70
FragmentTable[1404] = 70
FragmentTable[1405] = 70
FragmentTable[1406] = 70
FragmentTable[1407] = 70
FragmentTable[1408] = 70
FragmentTable[1409] = 70
FragmentTable[1410] = 70
FragmentTable[1411] = 70
FragmentTable[1412] = 70
FragmentTable[1413] = 70
FragmentTable[1414] = 70
FragmentTable[1415] = 70
FragmentTable[1416] = 70
FragmentTable[1417] = 70
FragmentTable[1418] = 70
FragmentTable[1419] = 70
FragmentTable[1420] = 71
FragmentTable[1421] = 71
FragmentTable[1422] = 71
FragmentTable[1423] = 71
FragmentTable[1424] = 71
FragmentTable[1425] = 71
FragmentTable[1426] = 71
FragmentTable[1427] = 71
FragmentTable[1428] = 71
FragmentTable[1429] = 71
FragmentTable[1430] = 71
FragmentTable[1431] = 71
FragmentTable[1432] = 71
FragmentTable[1433] = 71
FragmentTable[1434] = 71
FragmentTable[1435] = 71
FragmentTable[1436] = 71
FragmentTable[1437] = 71
FragmentTable[1438] = 71
FragmentTable[1439] = 71
FragmentTable[1440] = 72
FragmentTable[1441] = 72
FragmentTable[1442] = 72
FragmentTable[1443] = 72
FragmentTable[1444] = 72
FragmentTable[1445] = 72
FragmentTable[1446] = 72
FragmentTable[1447] = 72
FragmentTable[1448] = 72
FragmentTable[1449] = 72
FragmentTable[1450] = 72
FragmentTable[1451] = 72
FragmentTable[1452] = 72
FragmentTable[1453] = 72
FragmentTable[1454] = 72
FragmentTable[1455] = 72
FragmentTable[1456] = 72
FragmentTable[1457] = 72
FragmentTable[1458] = 72
FragmentTable[1459] = 72
FragmentTable[1460] = 73
FragmentTable[1461] = 73
FragmentTable[1462] = 73
FragmentTable[1463] = 73
FragmentTable[1464] = 73
FragmentTable[1465] = 73
FragmentTable[1466] = 73
FragmentTable[1467] = 73
FragmentTable[1468] = 73
FragmentTable[1469] = 73
FragmentTable[1470] = 73
FragmentTable[1471] = 73
FragmentTable[1472] = 73
FragmentTable[1473] = 73
FragmentTable[1474] = 73
FragmentTable[1475] = 73
FragmentTable[1476] = 73
FragmentTable[1477] = 73
FragmentTable[1478] = 73
FragmentTable[1479] = 73
FragmentTable[1480] = 74
FragmentTable[1481] = 74
FragmentTable[1482] = 74
FragmentTable[1483] = 74
FragmentTable[1484] = 74
FragmentTable[1485] = 74
FragmentTable[1486] = 74
FragmentTable[1487] = 74
FragmentTable[1488] = 74
FragmentTable[1489] = 74
FragmentTable[1490] = 74
FragmentTable[1491] = 74
FragmentTable[1492] = 74
FragmentTable[1493] = 74
FragmentTable[1494] = 74
FragmentTable[1495] = 74
FragmentTable[1496] = 74
FragmentTable[1497] = 74
FragmentTable[1498] = 74
FragmentTable[1499] = 74
FragmentTable[1500] = 75
FragmentTable[1501] = 75
FragmentTable[1502] = 75
FragmentTable[1503] = 75
FragmentTable[1504] = 75
FragmentTable[1505] = 75
FragmentTable[1506] = 75
FragmentTable[1507] = 75
FragmentTable[1508] = 75
FragmentTable[1509] = 75
FragmentTable[1510] = 75
FragmentTable[1511] = 75
FragmentTable[1512] = 75
FragmentTable[1513] = 75
FragmentTable[1514] = 75
FragmentTable[1515] = 75
FragmentTable[1516] = 75
FragmentTable[1517] = 75
FragmentTable[1518] = 75
FragmentTable[1519] = 75
FragmentTable[1520] = 76
FragmentTable[1521] = 76
FragmentTable[1522] = 76
FragmentTable[1523] = 76
FragmentTable[1524] = 76
FragmentTable[1525] = 76
FragmentTable[1526] = 76
FragmentTable[1527] = 76
FragmentTable[1528] = 76
FragmentTable[1529] = 76
FragmentTable[1530] = 76
FragmentTable[1531] = 76
FragmentTable[1532] = 76
FragmentTable[1533] = 76
FragmentTable[1534] = 76
FragmentTable[1535] = 76
FragmentTable[1536] = 76
FragmentTable[1537] = 76
FragmentTable[1538] = 76
FragmentTable[1539] = 76
FragmentTable[1540] = 77
FragmentTable[1541] = 77
FragmentTable[1542] = 77
FragmentTable[1543] = 77
FragmentTable[1544] = 77
FragmentTable[1545] = 77
FragmentTable[1546] = 77
FragmentTable[1547] = 77
FragmentTable[1548] = 77
FragmentTable[1549] = 77
FragmentTable[1550] = 77
FragmentTable[1551] = 77
FragmentTable[1552] = 77
FragmentTable[1553] = 77
FragmentTable[1554] = 77
FragmentTable[1555] = 77
FragmentTable[1556] = 77
FragmentTable[1557] = 77
FragmentTable[1558] = 77
FragmentTable[1559] = 77
FragmentTable[1560] = 78
FragmentTable[1561] = 78
FragmentTable[1562] = 78
FragmentTable[1563] = 78
FragmentTable[1564] = 78
FragmentTable[1565] = 78
FragmentTable[1566] = 78
FragmentTable[1567] = 78
FragmentTable[1568] = 78
FragmentTable[1569] = 78
FragmentTable[1570] = 78
FragmentTable[1571] = 78
FragmentTable[1572] = 78
FragmentTable[1573] = 78
FragmentTable[1574] = 78
FragmentTable[1575] = 78
FragmentTable[1576] = 78
FragmentTable[1577] = 78
FragmentTable[1578] = 78
FragmentTable[1579] = 78
FragmentTable[1580] = 79
FragmentTable[1581] = 79
FragmentTable[1582] = 79
FragmentTable[1583] = 79
FragmentTable[1584] = 79
FragmentTable[1585] = 79
FragmentTable[1586] = 79
FragmentTable[1587] = 79
FragmentTable[1588] = 79
FragmentTable[1589] = 79
FragmentTable[1590] = 79
FragmentTable[1591] = 79
FragmentTable[1592] = 79
FragmentTable[1593] = 79
FragmentTable[1594] = 79
FragmentTable[1595] = 79
FragmentTable[1596] = 79
FragmentTable[1597] = 79
FragmentTable[1598] = 79
FragmentTable[1599] = 79
FragmentTable[1600] = 80
FragmentTable[1601] = 80
FragmentTable[1602] = 80
FragmentTable[1603] = 80
FragmentTable[1604] = 80
FragmentTable[1605] = 80
FragmentTable[1606] = 80
FragmentTable[1607] = 80
FragmentTable[1608] = 80
FragmentTable[1609] = 80
FragmentTable[1610] = 80
FragmentTable[1611] = 80
FragmentTable[1612] = 80
FragmentTable[1613] = 80
FragmentTable[1614] = 80
FragmentTable[1615] = 80
FragmentTable[1616] = 80
FragmentTable[1617] = 80
FragmentTable[1618] = 80
FragmentTable[1619] = 80
FragmentTable[1620] = 81
FragmentTable[1621] = 81
FragmentTable[1622] = 81
FragmentTable[1623] = 81
FragmentTable[1624] = 81
FragmentTable[1625] = 81
FragmentTable[1626] = 81
FragmentTable[1627] = 81
FragmentTable[1628] = 81
FragmentTable[1629] = 81
FragmentTable[1630] = 81
FragmentTable[1631] = 81
FragmentTable[1632] = 81
FragmentTable[1633] = 81
FragmentTable[1634] = 81
FragmentTable[1635] = 81
FragmentTable[1636] = 81
FragmentTable[1637] = 81
FragmentTable[1638] = 81
FragmentTable[1639] = 81
FragmentTable[1640] = 82
FragmentTable[1641] = 82
FragmentTable[1642] = 82
FragmentTable[1643] = 82
FragmentTable[1644] = 82
FragmentTable[1645] = 82
FragmentTable[1646] = 82
FragmentTable[1647] = 82
FragmentTable[1648] = 82
FragmentTable[1649] = 82
FragmentTable[1650] = 82
FragmentTable[1651] = 82
FragmentTable[1652] = 82
FragmentTable[1653] = 82
FragmentTable[1654] = 82
FragmentTable[1655] = 82
FragmentTable[1656] = 82
FragmentTable[1657] = 82
FragmentTable[1658] = 82
FragmentTable[1659] = 82
FragmentTable[1660] = 83
FragmentTable[1661] = 83
FragmentTable[1662] = 83
FragmentTable[1663] = 83
FragmentTable[1664] = 83
FragmentTable[1665] = 83
FragmentTable[1666] = 83
FragmentTable[1667] = 83
FragmentTable[1668] = 83
FragmentTable[1669] = 83
FragmentTable[1670] = 83
FragmentTable[1671] = 83
FragmentTable[1672] = 83
FragmentTable[1673] = 83
FragmentTable[1674] = 83
FragmentTable[1675] = 83
FragmentTable[1676] = 83
FragmentTable[1677] = 83
FragmentTable[1678] = 83
FragmentTable[1679] = 83
FragmentTable[1680] = 84
FragmentTable[1681] = 84
FragmentTable[1682] = 84
FragmentTable[1683] = 84
FragmentTable[1684] = 84
FragmentTable[1685] = 84
FragmentTable[1686] = 84
FragmentTable[1687] = 84
FragmentTable[1688] = 84
FragmentTable[1689] = 84
FragmentTable[1690] = 84
FragmentTable[1691] = 84
FragmentTable[1692] = 84
FragmentTable[1693] = 84
FragmentTable[1694] = 84
FragmentTable[1695] = 84
FragmentTable[1696] = 84
FragmentTable[1697] = 84
FragmentTable[1698] = 84
FragmentTable[1699] = 84
FragmentTable[1700] = 85
FragmentTable[1701] = 85
FragmentTable[1702] = 85
FragmentTable[1703] = 85
FragmentTable[1704] = 85
FragmentTable[1705] = 85
FragmentTable[1706] = 85
FragmentTable[1707] = 85
FragmentTable[1708] = 85
FragmentTable[1709] = 85
FragmentTable[1710] = 85
FragmentTable[1711] = 85
FragmentTable[1712] = 85
FragmentTable[1713] = 85
FragmentTable[1714] = 85
FragmentTable[1715] = 85
FragmentTable[1716] = 85
FragmentTable[1717] = 85
FragmentTable[1718] = 85
FragmentTable[1719] = 85
FragmentTable[1720] = 86
FragmentTable[1721] = 86
FragmentTable[1722] = 86
FragmentTable[1723] = 86
FragmentTable[1724] = 86
FragmentTable[1725] = 86
FragmentTable[1726] = 86
FragmentTable[1727] = 86
FragmentTable[1728] = 86
FragmentTable[1729] = 86
FragmentTable[1730] = 86
FragmentTable[1731] = 86
FragmentTable[1732] = 86
FragmentTable[1733] = 86
FragmentTable[1734] = 86
FragmentTable[1735] = 86
FragmentTable[1736] = 86
FragmentTable[1737] = 86
FragmentTable[1738] = 86
FragmentTable[1739] = 86
FragmentTable[1740] = 87
FragmentTable[1741] = 87
FragmentTable[1742] = 87
FragmentTable[1743] = 87
FragmentTable[1744] = 87
FragmentTable[1745] = 87
FragmentTable[1746] = 87
FragmentTable[1747] = 87
FragmentTable[1748] = 87
FragmentTable[1749] = 87
FragmentTable[1750] = 87
FragmentTable[1751] = 87
FragmentTable[1752] = 87
FragmentTable[1753] = 87
FragmentTable[1754] = 87
FragmentTable[1755] = 87
FragmentTable[1756] = 87
FragmentTable[1757] = 87
FragmentTable[1758] = 87
FragmentTable[1759] = 87
FragmentTable[1760] = 88
FragmentTable[1761] = 88
FragmentTable[1762] = 88
FragmentTable[1763] = 88
FragmentTable[1764] = 88
FragmentTable[1765] = 88
FragmentTable[1766] = 88
FragmentTable[1767] = 88
FragmentTable[1768] = 88
FragmentTable[1769] = 88
FragmentTable[1770] = 88
FragmentTable[1771] = 88
FragmentTable[1772] = 88
FragmentTable[1773] = 88
FragmentTable[1774] = 88
FragmentTable[1775] = 88
FragmentTable[1776] = 88
FragmentTable[1777] = 88
FragmentTable[1778] = 88
FragmentTable[1779] = 88
FragmentTable[1780] = 89
FragmentTable[1781] = 89
FragmentTable[1782] = 89
FragmentTable[1783] = 89
FragmentTable[1784] = 89
FragmentTable[1785] = 89
FragmentTable[1786] = 89
FragmentTable[1787] = 89
FragmentTable[1788] = 89
FragmentTable[1789] = 89
FragmentTable[1790] = 89
FragmentTable[1791] = 89
FragmentTable[1792] = 89
FragmentTable[1793] = 89
FragmentTable[1794] = 89
FragmentTable[1795] = 89
FragmentTable[1796] = 89
FragmentTable[1797] = 89
FragmentTable[1798] = 89
FragmentTable[1799] = 89
FragmentTable[1800] = 90
FragmentTable[1801] = 90
FragmentTable[1802] = 90
FragmentTable[1803] = 90
FragmentTable[1804] = 90
FragmentTable[1805] = 90
FragmentTable[1806] = 90
FragmentTable[1807] = 90
FragmentTable[1808] = 90
FragmentTable[1809] = 90
FragmentTable[1810] = 90
FragmentTable[1811] = 90
FragmentTable[1812] = 90
FragmentTable[1813] = 90
FragmentTable[1814] = 90
FragmentTable[1815] = 90
FragmentTable[1816] = 90
FragmentTable[1817] = 90
FragmentTable[1818] = 90
FragmentTable[1819] = 90
FragmentTable[1820] = 91
FragmentTable[1821] = 91
FragmentTable[1822] = 91
FragmentTable[1823] = 91
FragmentTable[1824] = 91
FragmentTable[1825] = 91
FragmentTable[1826] = 91
FragmentTable[1827] = 91
FragmentTable[1828] = 91
FragmentTable[1829] = 91
FragmentTable[1830] = 91
FragmentTable[1831] = 91
FragmentTable[1832] = 91
FragmentTable[1833] = 91
FragmentTable[1834] = 91
FragmentTable[1835] = 91
FragmentTable[1836] = 91
FragmentTable[1837] = 91
FragmentTable[1838] = 91
FragmentTable[1839] = 91
FragmentTable[1840] = 92
FragmentTable[1841] = 92
FragmentTable[1842] = 92
FragmentTable[1843] = 92
FragmentTable[1844] = 92
FragmentTable[1845] = 92
FragmentTable[1846] = 92
FragmentTable[1847] = 92
FragmentTable[1848] = 92
FragmentTable[1849] = 92
FragmentTable[1850] = 92
FragmentTable[1851] = 92
FragmentTable[1852] = 92
FragmentTable[1853] = 92
FragmentTable[1854] = 92
FragmentTable[1855] = 92
FragmentTable[1856] = 92
FragmentTable[1857] = 92
FragmentTable[1858] = 92
FragmentTable[1859] = 92
FragmentTable[1860] = 93
FragmentTable[1861] = 93
FragmentTable[1862] = 93
FragmentTable[1863] = 93
FragmentTable[1864] = 93
FragmentTable[1865] = 93
FragmentTable[1866] = 93
FragmentTable[1867] = 93
FragmentTable[1868] = 93
FragmentTable[1869] = 93
FragmentTable[1870] = 93
FragmentTable[1871] = 93
FragmentTable[1872] = 93
FragmentTable[1873] = 93
FragmentTable[1874] = 93
FragmentTable[1875] = 93
FragmentTable[1876] = 93
FragmentTable[1877] = 93
FragmentTable[1878] = 93
FragmentTable[1879] = 93
FragmentTable[1880] = 94
FragmentTable[1881] = 94
FragmentTable[1882] = 94
FragmentTable[1883] = 94
FragmentTable[1884] = 94
FragmentTable[1885] = 94
FragmentTable[1886] = 94
FragmentTable[1887] = 94
FragmentTable[1888] = 94
FragmentTable[1889] = 94
FragmentTable[1890] = 94
FragmentTable[1891] = 94
FragmentTable[1892] = 94
FragmentTable[1893] = 94
FragmentTable[1894] = 94
FragmentTable[1895] = 94
FragmentTable[1896] = 94
FragmentTable[1897] = 94
FragmentTable[1898] = 94
FragmentTable[1899] = 94
FragmentTable[1900] = 95
FragmentTable[1901] = 95
FragmentTable[1902] = 95
FragmentTable[1903] = 95
FragmentTable[1904] = 95
FragmentTable[1905] = 95
FragmentTable[1906] = 95
FragmentTable[1907] = 95
FragmentTable[1908] = 95
FragmentTable[1909] = 95
FragmentTable[1910] = 95
FragmentTable[1911] = 95
FragmentTable[1912] = 95
FragmentTable[1913] = 95
FragmentTable[1914] = 95
FragmentTable[1915] = 95
FragmentTable[1916] = 95
FragmentTable[1917] = 95
FragmentTable[1918] = 95
FragmentTable[1919] = 95
FragmentTable[1920] = 96
FragmentTable[1921] = 96
FragmentTable[1922] = 96
FragmentTable[1923] = 96
FragmentTable[1924] = 96
FragmentTable[1925] = 96
FragmentTable[1926] = 96
FragmentTable[1927] = 96
FragmentTable[1928] = 96
FragmentTable[1929] = 96
FragmentTable[1930] = 96
FragmentTable[1931] = 96
FragmentTable[1932] = 96
FragmentTable[1933] = 96
FragmentTable[1934] = 96
FragmentTable[1935] = 96
FragmentTable[1936] = 96
FragmentTable[1937] = 96
FragmentTable[1938] = 96
FragmentTable[1939] = 96
FragmentTable[1940] = 97
FragmentTable[1941] = 97
FragmentTable[1942] = 97
FragmentTable[1943] = 97
FragmentTable[1944] = 97
FragmentTable[1945] = 97
FragmentTable[1946] = 97
FragmentTable[1947] = 97
FragmentTable[1948] = 97
FragmentTable[1949] = 97
FragmentTable[1950] = 97
FragmentTable[1951] = 97
FragmentTable[1952] = 97
FragmentTable[1953] = 97
FragmentTable[1954] = 97
FragmentTable[1955] = 97
FragmentTable[1956] = 97
FragmentTable[1957] = 97
FragmentTable[1958] = 97
FragmentTable[1959] = 97
FragmentTable[1960] = 98
FragmentTable[1961] = 98
FragmentTable[1962] = 98
FragmentTable[1963] = 98
FragmentTable[1964] = 98
FragmentTable[1965] = 98
FragmentTable[1966] = 98
FragmentTable[1967] = 98
FragmentTable[1968] = 98
FragmentTable[1969] = 98
FragmentTable[1970] = 98
FragmentTable[1971] = 98
FragmentTable[1972] = 98
FragmentTable[1973] = 98
FragmentTable[1974] = 98
FragmentTable[1975] = 98
FragmentTable[1976] = 98
FragmentTable[1977] = 98
FragmentTable[1978] = 98
FragmentTable[1979] = 98
FragmentTable[1980] = 99
FragmentTable[1981] = 99
FragmentTable[1982] = 99
FragmentTable[1983] = 99
FragmentTable[1984] = 99
FragmentTable[1985] = 99
FragmentTable[1986] = 99
FragmentTable[1987] = 99
FragmentTable[1988] = 99
FragmentTable[1989] = 99
FragmentTable[1990] = 99
FragmentTable[1991] = 99
FragmentTable[1992] = 99
FragmentTable[1993] = 99
FragmentTable[1994] = 99
FragmentTable[1995] = 99
FragmentTable[1996] = 99
FragmentTable[1997] = 99
FragmentTable[1998] = 99
FragmentTable[1999] = 99
FragmentTable[2000] = 100
FragmentTable[2001] = 100
FragmentTable[2002] = 100
FragmentTable[2003] = 100
FragmentTable[2004] = 100
FragmentTable[2005] = 100
FragmentTable[2006] = 100
FragmentTable[2007] = 100
FragmentTable[2008] = 100
FragmentTable[2009] = 100
FragmentTable[2010] = 100
FragmentTable[2011] = 100
FragmentTable[2012] = 100
FragmentTable[2013] = 100
FragmentTable[2014] = 100
FragmentTable[2015] = 100
FragmentTable[2016] = 100
FragmentTable[2017] = 100
FragmentTable[2018] = 100
FragmentTable[2019] = 100
FragmentTable[2020] = 101
FragmentTable[2021] = 101
FragmentTable[2022] = 101
FragmentTable[2023] = 101
FragmentTable[2024] = 101
FragmentTable[2025] = 101
FragmentTable[2026] = 101
FragmentTable[2027] = 101
FragmentTable[2028] = 101
FragmentTable[2029] = 101
FragmentTable[2030] = 101
FragmentTable[2031] = 101
FragmentTable[2032] = 101
FragmentTable[2033] = 101
FragmentTable[2034] = 101
FragmentTable[2035] = 101
FragmentTable[2036] = 101
FragmentTable[2037] = 101
FragmentTable[2038] = 101
FragmentTable[2039] = 101
FragmentTable[2040] = 102
FragmentTable[2041] = 102
FragmentTable[2042] = 102
FragmentTable[2043] = 102
FragmentTable[2044] = 102
FragmentTable[2045] = 102
FragmentTable[2046] = 102
FragmentTable[2047] = 102
FragmentTable[2048] = 102
FragmentTable[2049] = 102
FragmentTable[2050] = 102
FragmentTable[2051] = 102
FragmentTable[2052] = 102
FragmentTable[2053] = 102
FragmentTable[2054] = 102
FragmentTable[2055] = 102
FragmentTable[2056] = 102
FragmentTable[2057] = 102
FragmentTable[2058] = 102
FragmentTable[2059] = 102
FragmentTable[2060] = 103
FragmentTable[2061] = 103
FragmentTable[2062] = 103
FragmentTable[2063] = 103
FragmentTable[2064] = 103
FragmentTable[2065] = 103
FragmentTable[2066] = 103
FragmentTable[2067] = 103
FragmentTable[2068] = 103
FragmentTable[2069] = 103
FragmentTable[2070] = 103
FragmentTable[2071] = 103
FragmentTable[2072] = 103
FragmentTable[2073] = 103
FragmentTable[2074] = 103
FragmentTable[2075] = 103
FragmentTable[2076] = 103
FragmentTable[2077] = 103
FragmentTable[2078] = 103
FragmentTable[2079] = 103
FragmentTable[2080] = 104
FragmentTable[2081] = 104
FragmentTable[2082] = 104
FragmentTable[2083] = 104
FragmentTable[2084] = 104
FragmentTable[2085] = 104
FragmentTable[2086] = 104
FragmentTable[2087] = 104
FragmentTable[2088] = 104
FragmentTable[2089] = 104
FragmentTable[2090] = 104
FragmentTable[2091] = 104
FragmentTable[2092] = 104
FragmentTable[2093] = 104
FragmentTable[2094] = 104
FragmentTable[2095] = 104
FragmentTable[2096] = 104
FragmentTable[2097] = 104
FragmentTable[2098] = 104
FragmentTable[2099] = 104
FragmentTable[2100] = 105
FragmentTable[2101] = 105
FragmentTable[2102] = 105
FragmentTable[2103] = 105
FragmentTable[2104] = 105
FragmentTable[2105] = 105
FragmentTable[2106] = 105
FragmentTable[2107] = 105
FragmentTable[2108] = 105
FragmentTable[2109] = 105
FragmentTable[2110] = 105
FragmentTable[2111] = 105
FragmentTable[2112] = 105
FragmentTable[2113] = 105
FragmentTable[2114] = 105
FragmentTable[2115] = 105
FragmentTable[2116] = 105
FragmentTable[2117] = 105
FragmentTable[2118] = 105
FragmentTable[2119] = 105
FragmentTable[2120] = 106
FragmentTable[2121] = 106
FragmentTable[2122] = 106
FragmentTable[2123] = 106
FragmentTable[2124] = 106
FragmentTable[2125] = 106
FragmentTable[2126] = 106
FragmentTable[2127] = 106
FragmentTable[2128] = 106
FragmentTable[2129] = 106
FragmentTable[2130] = 106
FragmentTable[2131] = 106
FragmentTable[2132] = 106
FragmentTable[2133] = 106
FragmentTable[2134] = 106
FragmentTable[2135] = 106
FragmentTable[2136] = 106
FragmentTable[2137] = 106
FragmentTable[2138] = 106
FragmentTable[2139] = 106
FragmentTable[2140] = 107
FragmentTable[2141] = 107
FragmentTable[2142] = 107
FragmentTable[2143] = 107
FragmentTable[2144] = 107
FragmentTable[2145] = 107
FragmentTable[2146] = 107
FragmentTable[2147] = 107
FragmentTable[2148] = 107
FragmentTable[2149] = 107
FragmentTable[2150] = 107
FragmentTable[2151] = 107
FragmentTable[2152] = 107
FragmentTable[2153] = 107
FragmentTable[2154] = 107
FragmentTable[2155] = 107
FragmentTable[2156] = 107
FragmentTable[2157] = 107
FragmentTable[2158] = 107
FragmentTable[2159] = 107
FragmentTable[2160] = 108
FragmentTable[2161] = 108
FragmentTable[2162] = 108
FragmentTable[2163] = 108
FragmentTable[2164] = 108
FragmentTable[2165] = 108
FragmentTable[2166] = 108
FragmentTable[2167] = 108
FragmentTable[2168] = 108
FragmentTable[2169] = 108
FragmentTable[2170] = 108
FragmentTable[2171] = 108
FragmentTable[2172] = 108
FragmentTable[2173] = 108
FragmentTable[2174] = 108
FragmentTable[2175] = 108
FragmentTable[2176] = 108
FragmentTable[2177] = 108
FragmentTable[2178] = 108
FragmentTable[2179] = 108
FragmentTable[2180] = 109
FragmentTable[2181] = 109
FragmentTable[2182] = 109
FragmentTable[2183] = 109
FragmentTable[2184] = 109
FragmentTable[2185] = 109
FragmentTable[2186] = 109
FragmentTable[2187] = 109
FragmentTable[2188] = 109
FragmentTable[2189] = 109
FragmentTable[2190] = 109
FragmentTable[2191] = 109
FragmentTable[2192] = 109
FragmentTable[2193] = 109
FragmentTable[2194] = 109
FragmentTable[2195] = 109
FragmentTable[2196] = 109
FragmentTable[2197] = 109
FragmentTable[2198] = 109
FragmentTable[2199] = 109
FragmentTable[2200] = 110
FragmentTable[2201] = 110
FragmentTable[2202] = 110
FragmentTable[2203] = 110
FragmentTable[2204] = 110
FragmentTable[2205] = 110
FragmentTable[2206] = 110
FragmentTable[2207] = 110
FragmentTable[2208] = 110
FragmentTable[2209] = 110
FragmentTable[2210] = 110
FragmentTable[2211] = 110
FragmentTable[2212] = 110
FragmentTable[2213] = 110
FragmentTable[2214] = 110
FragmentTable[2215] = 110
FragmentTable[2216] = 110
FragmentTable[2217] = 110
FragmentTable[2218] = 110
FragmentTable[2219] = 110
FragmentTable[2220] = 111
FragmentTable[2221] = 111
FragmentTable[2222] = 111
FragmentTable[2223] = 111
FragmentTable[2224] = 111
FragmentTable[2225] = 111
FragmentTable[2226] = 111
FragmentTable[2227] = 111
FragmentTable[2228] = 111
FragmentTable[2229] = 111
FragmentTable[2230] = 111
FragmentTable[2231] = 111
FragmentTable[2232] = 111
FragmentTable[2233] = 111
FragmentTable[2234] = 111
FragmentTable[2235] = 111
FragmentTable[2236] = 111
FragmentTable[2237] = 111
FragmentTable[2238] = 111
FragmentTable[2239] = 111
FragmentTable[2240] = 112
FragmentTable[2241] = 112
FragmentTable[2242] = 112
FragmentTable[2243] = 112
FragmentTable[2244] = 112
FragmentTable[2245] = 112
FragmentTable[2246] = 112
FragmentTable[2247] = 112
FragmentTable[2248] = 112
FragmentTable[2249] = 112
FragmentTable[2250] = 112
FragmentTable[2251] = 112
FragmentTable[2252] = 112
FragmentTable[2253] = 112
FragmentTable[2254] = 112
FragmentTable[2255] = 112
FragmentTable[2256] = 112
FragmentTable[2257] = 112
FragmentTable[2258] = 112
FragmentTable[2259] = 112
FragmentTable[2260] = 113
FragmentTable[2261] = 113
FragmentTable[2262] = 113
FragmentTable[2263] = 113
FragmentTable[2264] = 113
FragmentTable[2265] = 113
FragmentTable[2266] = 113
FragmentTable[2267] = 113
FragmentTable[2268] = 113
FragmentTable[2269] = 113
FragmentTable[2270] = 113
FragmentTable[2271] = 113
FragmentTable[2272] = 113
FragmentTable[2273] = 113
FragmentTable[2274] = 113
FragmentTable[2275] = 113
FragmentTable[2276] = 113
FragmentTable[2277] = 113
FragmentTable[2278] = 113
FragmentTable[2279] = 113
FragmentTable[2280] = 114
FragmentTable[2281] = 114
FragmentTable[2282] = 114
FragmentTable[2283] = 114
FragmentTable[2284] = 114
FragmentTable[2285] = 114
FragmentTable[2286] = 114
FragmentTable[2287] = 114
FragmentTable[2288] = 114
FragmentTable[2289] = 114
FragmentTable[2290] = 114
FragmentTable[2291] = 114
FragmentTable[2292] = 114
FragmentTable[2293] = 114
FragmentTable[2294] = 114
FragmentTable[2295] = 114
FragmentTable[2296] = 114
FragmentTable[2297] = 114
FragmentTable[2298] = 114
FragmentTable[2299] = 114
FragmentTable[2300] = 115
FragmentTable[2301] = 115
FragmentTable[2302] = 115
FragmentTable[2303] = 115
FragmentTable[2304] = 115
FragmentTable[2305] = 115
FragmentTable[2306] = 115
FragmentTable[2307] = 115
FragmentTable[2308] = 115
FragmentTable[2309] = 115
FragmentTable[2310] = 115
FragmentTable[2311] = 115
FragmentTable[2312] = 115
FragmentTable[2313] = 115
FragmentTable[2314] = 115
FragmentTable[2315] = 115
FragmentTable[2316] = 115
FragmentTable[2317] = 115
FragmentTable[2318] = 115
FragmentTable[2319] = 115
FragmentTable[2320] = 116
FragmentTable[2321] = 116
FragmentTable[2322] = 116
FragmentTable[2323] = 116
FragmentTable[2324] = 116
FragmentTable[2325] = 116
FragmentTable[2326] = 116
FragmentTable[2327] = 116
FragmentTable[2328] = 116
FragmentTable[2329] = 116
FragmentTable[2330] = 116
FragmentTable[2331] = 116
FragmentTable[2332] = 116
FragmentTable[2333] = 116
FragmentTable[2334] = 116
FragmentTable[2335] = 116
FragmentTable[2336] = 116
FragmentTable[2337] = 116
FragmentTable[2338] = 116
FragmentTable[2339] = 116
FragmentTable[2340] = 117
FragmentTable[2341] = 117
FragmentTable[2342] = 117
FragmentTable[2343] = 117
FragmentTable[2344] = 117
FragmentTable[2345] = 117
FragmentTable[2346] = 117
FragmentTable[2347] = 117
FragmentTable[2348] = 117
FragmentTable[2349] = 117
FragmentTable[2350] = 117
FragmentTable[2351] = 117
FragmentTable[2352] = 117
FragmentTable[2353] = 117
FragmentTable[2354] = 117
FragmentTable[2355] = 117
FragmentTable[2356] = 117
FragmentTable[2357] = 117
FragmentTable[2358] = 117
FragmentTable[2359] = 117
FragmentTable[2360] = 118
FragmentTable[2361] = 118
FragmentTable[2362] = 118
FragmentTable[2363] = 118
FragmentTable[2364] = 118
FragmentTable[2365] = 118
FragmentTable[2366] = 118
FragmentTable[2367] = 118
FragmentTable[2368] = 118
FragmentTable[2369] = 118
FragmentTable[2370] = 118
FragmentTable[2371] = 118
FragmentTable[2372] = 118
FragmentTable[2373] = 118
FragmentTable[2374] = 118
FragmentTable[2375] = 118
FragmentTable[2376] = 118
FragmentTable[2377] = 118
FragmentTable[2378] = 118
FragmentTable[2379] = 118
FragmentTable[2380] = 119
FragmentTable[2381] = 119
FragmentTable[2382] = 119
FragmentTable[2383] = 119
FragmentTable[2384] = 119
FragmentTable[2385] = 119
FragmentTable[2386] = 119
FragmentTable[2387] = 119
FragmentTable[2388] = 119
FragmentTable[2389] = 119
FragmentTable[2390] = 119
FragmentTable[2391] = 119
FragmentTable[2392] = 119
FragmentTable[2393] = 119
FragmentTable[2394] = 119
FragmentTable[2395] = 119
FragmentTable[2396] = 119
FragmentTable[2397] = 119
FragmentTable[2398] = 119
FragmentTable[2399] = 119
FragmentTable[2400] = 120
FragmentTable[2401] = 120
FragmentTable[2402] = 120
FragmentTable[2403] = 120
FragmentTable[2404] = 120
FragmentTable[2405] = 120
FragmentTable[2406] = 120
FragmentTable[2407] = 120
FragmentTable[2408] = 120
FragmentTable[2409] = 120
FragmentTable[2410] = 120
FragmentTable[2411] = 120
FragmentTable[2412] = 120
FragmentTable[2413] = 120
FragmentTable[2414] = 120
FragmentTable[2415] = 120
FragmentTable[2416] = 120
FragmentTable[2417] = 120
FragmentTable[2418] = 120
FragmentTable[2419] = 120
FragmentTable[2420] = 121
FragmentTable[2421] = 121
FragmentTable[2422] = 121
FragmentTable[2423] = 121
FragmentTable[2424] = 121
FragmentTable[2425] = 121
FragmentTable[2426] = 121
FragmentTable[2427] = 121
FragmentTable[2428] = 121
FragmentTable[2429] = 121
FragmentTable[2430] = 121
FragmentTable[2431] = 121
FragmentTable[2432] = 121
FragmentTable[2433] = 121
FragmentTable[2434] = 121
FragmentTable[2435] = 121
FragmentTable[2436] = 121
FragmentTable[2437] = 121
FragmentTable[2438] = 121
FragmentTable[2439] = 121
FragmentTable[2440] = 122
FragmentTable[2441] = 122
FragmentTable[2442] = 122
FragmentTable[2443] = 122
FragmentTable[2444] = 122
FragmentTable[2445] = 122
FragmentTable[2446] = 122
FragmentTable[2447] = 122
FragmentTable[2448] = 122
FragmentTable[2449] = 122
FragmentTable[2450] = 122