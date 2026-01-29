-- AXL Ultimate UI Library
-- iOS Black | Full | Save Data | Wallpaper | Minimize
local AXL = {}
AXL.__index = AXL

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

-- Click Sound
local ClickSound = Instance.new("Sound")
ClickSound.SoundId = "rbxassetid://12221967"
ClickSound.Volume = 1

-- File system
local function SaveFile(path, data)
	if writefile then
		writefile(path, HttpService:JSONEncode(data))
	end
end

local function LoadFile(path)
	if isfile and isfile(path) then
		return HttpService:JSONDecode(readfile(path))
	end
	return {}
end

-- Create Window
function AXL:CreateWindow(cfg)
	local Window = {}
	Window.Flags = {}
	local Folder = cfg.ConfigFolder or "AXL_CONFIG"
	local FilePath = Folder.."/config.json"
	if makefolder and not isfolder(Folder) then makefolder(Folder) end
	local SavedData = LoadFile(FilePath)

	-- ScreenGui
	local Gui = Instance.new("ScreenGui", Player.PlayerGui)
	Gui.Name = "AXL_UI"
	Gui.ResetOnSpawn = false

	-- Main Frame
	local Main = Instance.new("Frame", Gui)
	Main.Size = UDim2.fromScale(0.48,0.6)
	Main.Position = UDim2.fromScale(0.5,0.5)
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.BackgroundColor3 = SavedData.Background or Color3.fromRGB(10,10,10)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = true
	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,20)

	-- Wallpaper
	local Wallpaper = Instance.new("ImageLabel", Main)
	Wallpaper.Size = UDim2.fromScale(1,1)
	Wallpaper.BackgroundTransparency = 1
	Wallpaper.ImageTransparency = 0.9
	Wallpaper.ZIndex = 0
	if SavedData.Wallpaper then Wallpaper.Image = SavedData.Wallpaper end

	-- Title
	local Title = Instance.new("TextLabel", Main)
	Title.Size = UDim2.new(1,0,0,50)
	Title.Text = cfg.Name or "AXL UI"
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextColor3 = Color3.new(1,1,1)
	Title.BackgroundTransparency = 1

	-- Close / Minimize Buttons
	local CloseBtn = Instance.new("TextButton", Main)
	CloseBtn.Size = UDim2.new(0,30,0,30)
	CloseBtn.Position = UDim2.new(1,-35,0,10)
	CloseBtn.Text = "X"
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 14
	CloseBtn.TextColor3 = Color3.new(1,1,1)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

	local MinBtn = Instance.new("TextButton", Main)
	MinBtn.Size = UDim2.new(0,30,0,30)
	MinBtn.Position = UDim2.new(1,-70,0,10)
	MinBtn.Text = "_"
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.TextColor3 = Color3.new(1,1,1)
	MinBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,10)

	local Minimized = false

	-- Minimize Animation
	MinBtn.MouseButton1Click:Connect(function()
		Minimized = not Minimized
		ClickSound:Play()
		if Minimized then
			TweenService:Create(Main,TweenInfo.new(0.3),{Size=UDim2.fromScale(0.48,0.05)}):Play()
		else
			TweenService:Create(Main,TweenInfo.new(0.3),{Size=UDim2.fromScale(0.48,0.6)}):Play()
		end
	end)

	-- Close Animation
	CloseBtn.MouseButton1Click:Connect(function()
		ClickSound:Play()
		TweenService:Create(Main,TweenInfo.new(0.3),{Position=UDim2.new(0.5,0,-1,0)}):Play()
		task.delay(0.3,function()
			Gui:Destroy()
		end)
	end)

	-- Tabs
	local Tabs = Instance.new("Frame", Main)
	Tabs.Position = UDim2.new(0,0,0,50)
	Tabs.Size = UDim2.new(0.25,0,1,-50)
	Tabs.BackgroundColor3 = Color3.fromRGB(15,15,15)
	Instance.new("UICorner", Tabs)
	local Layout = Instance.new("UIListLayout", Tabs)
	Layout.Padding = UDim.new(0,6)

	local Pages = Instance.new("Frame", Main)
	Pages.Position = UDim2.new(0.25,0,0,50)
	Pages.Size = UDim2.new(0.75,0,1,-50)
	Pages.BackgroundTransparency = 1

	local TabsTable = {}

	-- Save
	local function Save()
		SavedData.Background = Main.BackgroundColor3
		SavedData.Wallpaper = Wallpaper.Image
		SaveFile(FilePath,SavedData)
	end

	-- Create Tab
	function Window:CreateTab(name)
		local Tab = {}

		local Page = Instance.new("ScrollingFrame", Pages)
		Page.Size = UDim2.fromScale(1,1)
		Page.CanvasSize = UDim2.new(0,0,0,0)
		Page.ScrollBarImageTransparency = 1
		Page.Visible = false
		local PageLayout = Instance.new("UIListLayout", Page)
		PageLayout.Padding = UDim.new(0,8)
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y + 10)
		end)

		local Btn = Instance.new("TextButton", Tabs)
		Btn.Size = UDim2.new(1,-10,0,42)
		Btn.Text = name
		Btn.Font = Enum.Font.Gotham
		Btn.TextSize = 14
		Btn.TextColor3 = Color3.new(1,1,1)
		Btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
		Instance.new("UICorner", Btn)

		Btn.MouseButton1Click:Connect(function()
			ClickSound:Play()
			for _,v in pairs(TabsTable) do
				v.Page.Visible = false
			end
			Page.Visible = true
		end)

		if #TabsTable == 0 then Page.Visible = true end

		-- Components
		function Tab:AddButton(opt)
			local B = Instance.new("TextButton", Page)
			B.Size = UDim2.new(1,-10,0,40)
			B.Text = opt.Name
			B.BackgroundColor3 = Color3.fromRGB(30,30,30)
			B.TextColor3 = Color3.new(1,1,1)
			B.Font = Enum.Font.Gotham
			B.TextSize = 14
			Instance.new("UICorner", B)
			B.MouseButton1Click:Connect(function()
				ClickSound:Play()
				if opt.Callback then opt.Callback() end
			end)
		end

		function Tab:AddToggle(opt)
			local Flag = opt.Flag or opt.Name
			local State = SavedData[Flag] ~= nil and SavedData[Flag] or opt.Default
			Window.Flags[Flag] = State
			local B = Instance.new("TextButton", Page)
			B.Size = UDim2.new(1,-10,0,45)
			B.Text = opt.Name.." : "..(State and "ON" or "OFF")
			B.BackgroundColor3 = State and Color3.fromRGB(40,40,40) or Color3.fromRGB(25,25,25)
			B.TextColor3 = Color3.new(1,1,1)
			B.Font = Enum.Font.Gotham
			B.TextSize = 14
			Instance.new("UICorner", B)
			B.MouseButton1Click:Connect(function()
				State = not State
				Window.Flags[Flag] = State
				B.Text = opt.Name.." : "..(State and "ON" or "OFF")
				B.BackgroundColor3 = State and Color3.fromRGB(40,40,40) or Color3.fromRGB(25,25,25)
				ClickSound:Play()
				Save()
				if opt.Callback then opt.Callback(State) end
			end)
		end

		function Tab:AddBackgroundColor(opt)
			local Btn = Instance.new("TextButton", Page)
			Btn.Size = UDim2.new(1,-10,0,40)
			Btn.Text = opt.Name
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
			Instance.new("UICorner", Btn)
			Btn.MouseButton1Click:Connect(function()
				Main.BackgroundColor3 = opt.Color
				SavedData.Background = opt.Color
				ClickSound:Play()
				Save()
			end)
		end

		function Tab:AddWallpaper(opt)
			local Btn = Instance.new("TextButton", Page)
			Btn.Size = UDim2.new(1,-10,0,40)
			Btn.Text = opt.Name
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 14
			Btn.TextColor3 = Color3.new(1,1,1)
			Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
			Instance.new("UICorner", Btn)
			Btn.MouseButton1Click:Connect(function()
				Wallpaper.Image = opt.Image
				SavedData.Wallpaper = opt.Image
				ClickSound:Play()
				Save()
			end)
		end

		Tab.Page = Page
		table.insert(TabsTable, Tab)
		return Tab
	end

	return Window
end

return AXL