-- تشغيل السكربت بعد ثانية
task.spawn(function()
    task.wait(1)
    loadstring(game:HttpGet("https://pastebin.com/raw/abLR46we"))()
end)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local TweenService = game:GetService("TweenService")

-- الفريم
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,150,0,60)
frame.Position = UDim2.new(1,200,0,20) -- يبدأ خارج الشاشة
frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
frame.BackgroundTransparency = 0.25
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,16)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Parent = frame

-- نص الفريمات
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1,0,0.5,0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(0,0,0)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 16
fpsLabel.Text = "فريمات: ..."
fpsLabel.Parent = frame

-- نص البنج
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1,0,0.5,0)
pingLabel.Position = UDim2.new(0,0,0.5,0)
pingLabel.BackgroundTransparency = 1
pingLabel.TextColor3 = Color3.fromRGB(0,0,0)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 16
pingLabel.Text = "بنجك: ..."
pingLabel.Parent = frame

-- أنيميشن دخول
TweenService:Create(
    frame,
    TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Position = UDim2.new(1,-160,0,20)}
):Play()

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- حساب الفريمات
local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fpsLabel.Text = "فريمات: "..frames
        frames = 0
        last = tick()
    end
end)

-- تحديث البنج وتغيير اللون
task.spawn(function()
    while true do
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        pingLabel.Text = "بنجك: "..math.floor(ping)

        if ping < 80 then
            stroke.Color = Color3.fromRGB(0,255,120) -- أخضر
        elseif ping < 150 then
            stroke.Color = Color3.fromRGB(255,200,0) -- أصفر
        else
            stroke.Color = Color3.fromRGB(255,80,80) -- أحمر
        end

        task.wait(1)
    end
end)