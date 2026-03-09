--=========================================================
-- ken HUB 6 took 40 hours :D - OPTIMIZED VERSION FULLY AI
--=========================================================

-- Anti-Skid Protection & Obfuscation (Optimized)
_G._0x4A2B = {[1]="\108\111\99\97\108",[2]="\103\97\109\101",[3]="\71\101\116\83\101\114\118\105\99\101",[4]="\80\108\97\121\101\114\115",[5]="\76\111\99\97\108\80\108\97\121\101\114"}
_G._0x3F8C = function(_0x1A2B) 
    return _G._0x4A2B[_0x1A2B] or ""
end
_G._0x7E9D = _G._0x3F8C(1) .. " " .. _G._0x3F8C(2) .. " = " .. _G._0x3F8C(2) .. ":" .. _G._0x3F8C(3) .. "(" .. _G._0x3F8C(4) .. "):" .. _G._0x3F8C(5) .. "()"

-- Global variable declarations to reduce local variable usage
_G.Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    TeleportService = game:GetService("TeleportService")
}
_G.player = _G.Services.Players.LocalPlayer
pcall(function()
    _G.character = _G.player.Character or _G.player.CharacterAdded:Wait()
    _G.humanoid = _G.character:FindFirstChildOfClass("Humanoid")
    _G.humanoidRootPart = _G.character:FindFirstChild("HumanoidRootPart")
end)

-- Safe execution of obfuscated code
pcall(function()
    loadstring(_G._0x7E9D)()
end)

-- Anti-Debug Protection (Optimized)
_G._0x9B2C = function()
    pcall(function()
        _G._0x5D8E = debug.getinfo
        if _G._0x5D8E then
            _G._0x2F4A = _G._0x5D8E(1, "S")
            if _G._0x2F4A and _G._0x2F4A.source and _G._0x2F4A.source:find("@") then
                game:GetService("Players").LocalPlayer:Kick("stop trying to skid kid")
            end
        end
    end)
end
pcall(_G._0x9B2C)

-- Advanced Anti-Exploit System
if not hookmetamethod then
    warn(
        '[Anti-Exploit] Your exploit does not support hookmetamethod. Exiting.'
    )
    return
end

-- Executor Compatibility Checks
_G.checkExecutorSupport = function()
    _G.compatibility = {
        hookmetamethod = hookmetamethod ~= nil,
        getrawmetatable = getrawmetatable ~= nil,
        setrawmetatable = setrawmetatable ~= nil,
        islclosure = islclosure ~= nil,
        newcclosure = newcclosure ~= nil,
        sethiddenproperty = sethiddenproperty ~= nil,
        gethiddenproperty = gethiddenproperty ~= nil,
        getgenv = getgenv ~= nil,
        getrenv = getrenv ~= nil,
        writefile = writefile ~= nil,
        readfile = readfile ~= nil,
        isfile = isfile ~= nil,
        delfile = delfile ~= nil,
        listfiles = listfiles ~= nil,
        makefolder = makefolder ~= nil,
        isfolder = isfolder ~= nil,
        delfolder = delfolder ~= nil,
        listfolders = listfolders ~= nil,
        gethui = gethui ~= nil,
        get_hidden_ui = get_hidden_ui ~= nil,
        syn = syn ~= nil,
        http_request = http_request ~= nil,
        request = request ~= nil,
        gameHttpGet = game.HttpGet ~= nil
    }
    
    print("🔍 Executor Compatibility Check:")
    for feature, supported in pairs(_G.compatibility) do
        print("  " .. (supported and "✅" or "❌") .. " " .. feature)
    end
    
    return _G.compatibility
end

_G.EXECUTOR_SUPPORT = _G.checkExecutorSupport()

-- Safe File Operations
_G.safeWriteFile = function(path, content)
    if not _G.EXECUTOR_SUPPORT.writefile then
        warn("❌ writefile not supported on this executor")
        return false
    end
    local success, err = pcall(writefile, path, content)
    if not success then
        warn("❌ Failed to write file: " .. tostring(err))
        return false
    end
    return true
end

_G.safeReadFile = function(path)
    if not _G.EXECUTOR_SUPPORT.readfile then
        warn("❌ readfile not supported on this executor")
        return nil
    end
    local success, content = pcall(readfile, path)
    if not success then
        warn("❌ Failed to read file: " .. tostring(content))
        return nil
    end
    return content
end

_G.safeIsFile = function(path)
    if not _G.EXECUTOR_SUPPORT.isfile then
        return false
    end
    local success, exists = pcall(isfile, path)
    return success and exists
end

_G.safeMakeFolder = function(path)
    if not _G.EXECUTOR_SUPPORT.makefolder then
        warn("❌ makefolder not supported on this executor")
        return false
    end
    local success, err = pcall(makefolder, path)
    if not success then
        warn("❌ Failed to create folder: " .. tostring(err))
        return false
    end
    return true
end

-- Safe Hidden Property Operations
_G.safeSetHiddenProperty = function(instance, property, value)
    if not _G.EXECUTOR_SUPPORT.sethiddenproperty then
        warn("❌ sethiddenproperty not supported on this executor")
        return false
    end
    local success, err = pcall(sethiddenproperty, instance, property, value)
    if not success then
        warn("❌ Failed to set hidden property: " .. tostring(err))
        return false
    end
    return true
end

_G.safeGetHiddenProperty = function(instance, property)
    if not _G.EXECUTOR_SUPPORT.gethiddenproperty then
        warn("❌ gethiddenproperty not supported on this executor")
        return nil
    end
    local success, value = pcall(gethiddenproperty, instance, property)
    if not success then
        warn("❌ Failed to get hidden property: " .. tostring(value))
        return nil
    end
    return value
end

-- Safe HTTP Operations
_G.safeHttpGet = function(url)
    if _G.EXECUTOR_SUPPORT.http_request then
        local success, response = pcall(http_request, {
            Url = url,
            Method = "GET"
        })
        if success and response and response.Body then
            return response.Body
        end
    elseif _G.EXECUTOR_SUPPORT.request then
        local success, response = pcall(request, {
            Url = url,
            Method = "GET"
        })
        if success and response and response.Body then
            return response.Body
        end
    elseif _G.EXECUTOR_SUPPORT.gameHttpGet then
        local success, response = pcall(game.HttpGet, game, url)
        if success then
            return response
        end
    else
        warn("❌ No HTTP GET method available on this executor")
    end
    return nil
end

local AE = {
	-- Services: lazy-cache
	S = setmetatable({}, {
		__index = function(t, k)
			local v = game:GetService(k)
			rawset(t, k, v)
			return v
		end,
	}),

	CFG = {
		KickEnabled = true, -- Still kicks but prevents stack overflow
		CrashEnabled = false,
		NotifyEnabled = false, -- Disable notifications to prevent conflicts

		ScanInterval = 2.0, -- Much slower scanning to prevent stack overflow
		ConsecutiveHooksRequired = 3, -- Moderate detection threshold

		SpyTextPhrases = {
			'clear logs',
			'exclude',
			'excludes',
			'ignore remotes',
		},
		BlacklistedPrintPhrases = {
			'blacklisted',
			'remotespy',
			'dex explorer',
		},

		DexStrictNames = {
			['ExplorerSelections'] = true,
			['EditAttributeButton'] = true,
			['Dex'] = true,
			['DEX'] = true,
		},
		DexWatchImages = {
			['rbxassetid://50546636'] = true,
			['rbxassetid://142796792'] = true,
			['rbxassetid://98876709'] = true,
			['rbxassetid://98876966'] = true,
			['rbxassetid://98964725'] = true,
			['rbxassetid://98876969'] = true,
			['rbxassetid://98876962'] = true,
			['http://www.roblox.com/asset/?id=41336962'] = true,
			['rbxassetid://16947680'] = true,
		},
	},

	-- state
	state = {
		original_namecall = nil,
		BASE = { FireServer = nil, InvokeServer = nil },
		dex_hits = 0,
		dex_lastHit = 0,
		consecutive = 0,
	},

	TEXT_CLASSES = { TextLabel = true, TextButton = true, TextBox = true },

	getnamecallmethod = getnamecallmethod or function()
		return ''
	end,
}

--============================== Helpers ==================================--

AE.tolower = function(s)
	local ok, v = pcall(string.lower, s)
	return (ok and type(v) == 'string') and v or ''
end

AE.is_c_closure = function(fn)
	local okIs, isLua = pcall(function()
		if islclosure then
			return islclosure(fn)
		end
		return nil
	end)
	if okIs and isLua ~= nil then
		return not isLua
	end
	local ok, src = pcall(function()
		return debug.info(fn, 's')
	end)
	if ok and type(src) == 'string' then
		return src == '[C]'
	end
	return true
end

AE.notify = function(title, text)
	if not AE.CFG.NotifyEnabled then
		return
	end
	pcall(function()
		AE.S.StarterGui:SetCore('SendNotification', {
			Title = title,
			Text = text or '',
			Duration = 5,
		})
	end)
	print(('[Anti-Exploit] %s - %s'):format(title, text or ''))
end

AE.applyPunishment = function(reason)
	local LP = AE.S.Players.LocalPlayer
	if AE.CFG.KickEnabled then
		pcall(function()
			LP:Kick(reason or 'Skid detected.')
		end)
	end
	if AE.CFG.CrashEnabled then
		task.spawn(function()
			while true do
				pcall(function()
					local a = {}
					for i = 1, 1e8 do
						a[i] = i
					end
				end)
			end
		end)
	end
	if not AE.CFG.KickEnabled and not AE.CFG.CrashEnabled then
		AE.notify(
			'Anti-Exploit Alert',
			tostring(reason or 'Suspicious activity')
		)
	end
end

--========================== Spy Text Detector ============================--

AE.textHasSpyPhrase = function(str)
	if type(str) ~= 'string' or #str == 0 then
		return false
	end
	local s = AE.tolower(str)
	for _, p in ipairs(AE.CFG.SpyTextPhrases) do
		if string.find(s, p, 1, true) then
			return true
		end
	end
	return false
end

AE.checkSpyText = function(inst)
	if not inst or not AE.TEXT_CLASSES[inst.ClassName] then
		return
	end
	local ok, txt = pcall(function()
		return inst.Text
	end)
	if ok and AE.textHasSpyPhrase(txt) then
		AE.applyPunishment('Spying on me is not cool.')
	end
end

AE.bindTextWatcher = function(inst)
	if not inst or not AE.TEXT_CLASSES[inst.ClassName] then
		return
	end
	AE.checkSpyText(inst)
	pcall(function()
		inst:GetPropertyChangedSignal('Text'):Connect(function()
			AE.checkSpyText(inst)
		end)
	end)
end

--======================= Remote Hook Detection ===========================--

AE.captureOriginals = function()
	local ok, mt = pcall(getrawmetatable, game)
	if ok and mt then
		AE.state.original_namecall = rawget(mt, '__namecall')
	end

	local e = Instance.new('RemoteEvent')
	AE.state.BASE.FireServer = e.FireServer
	e:Destroy()

	local f = Instance.new('RemoteFunction')
	AE.state.BASE.InvokeServer = f.InvokeServer
	f:Destroy()
end

AE.namecall_hooked_strict = function()
	local ok, mt = pcall(getrawmetatable, game)
	if not ok or not mt or not AE.state.original_namecall then
		return false
	end
	local cur = rawget(mt, '__namecall')
	if type(cur) ~= 'function' then
		return true
	end
	if cur == AE.state.original_namecall then
		return false
	end
	if not AE.is_c_closure(cur) then
		return true
	end
	return false
end

AE.fireserver_hooked_strict = function()
	if not AE.state.BASE.FireServer then
		return false
	end
	local e = Instance.new('RemoteEvent')
	local cur = e.FireServer
	e:Destroy()
	if type(cur) ~= 'function' then
		return true
	end
	if cur ~= AE.state.BASE.FireServer and not AE.is_c_closure(cur) then
		return true
	end
	return false
end

AE.invokeserver_hooked_strict = function()
	if not AE.state.BASE.InvokeServer then
		return false
	end
	local f = Instance.new('RemoteFunction')
	local cur = f.InvokeServer
	f:Destroy()
	if type(cur) ~= 'function' then
		return true
	end
	if cur ~= AE.state.BASE.InvokeServer and not AE.is_c_closure(cur) then
		return true
	end
	return false
end

AE.startHookScan = function()
	task.spawn(function()
		while true do
			pcall(function() -- Wrap in pcall to prevent crashes
				local hooked = AE.namecall_hooked_strict()
					or AE.fireserver_hooked_strict()
					or AE.invokeserver_hooked_strict()

				if hooked then
					AE.state.consecutive += 1
					if AE.state.consecutive >= AE.CFG.ConsecutiveHooksRequired then
						AE.applyPunishment('skid detected.')
						return
					end
				else
					AE.state.consecutive = 0
				end
			end)
			task.wait(AE.CFG.ScanInterval)
		end
	end)
end

--========================== Dex / Explorer Hunter ========================--

AE.wordHasBareDex = function(s)
	s = string.lower(s or '')
	if
		s:find('[^%a]dex[^%a]')
		or s:find('^dex[^%a]')
		or s:find('[^%a]dex$')
		or s == 'dex'
	then
		if not (s:find('index') or s:find('codex') or s:find('dexterity')) then
			return true
		end
	end
	return false
end

AE.looksLikeDexStrict = function(inst)
	if not inst then
		return false
	end

	if AE.CFG.DexStrictNames[inst.Name] then
		return true
	end

	if inst:IsA('ImageLabel') then
		local ok, img = pcall(function()
			return inst.Image
		end)
		if ok and img and AE.CFG.DexWatchImages[img] then
			return true
		end
	end

	if inst.Name == 'ExplorerSelections' then
		local p = inst.Parent
		if p and p.Name == 'RobloxGui' then
			return true
		end
	end

	if inst:IsA('ScreenGui') or inst:IsA('Frame') then
		if AE.wordHasBareDex(inst.Name) then
			local hasTypicalChild = false
			for _, d in ipairs(inst:GetDescendants()) do
				local n = d.Name
				if
					n == 'Explorer'
					or n == 'Properties'
					or n == 'TopBar'
					or n == 'RightPanel'
				then
					hasTypicalChild = true
					break
				end
			end
			if hasTypicalChild then
				return true
			end
		end
	end
	return false
end

AE.dexHit = function()
	local now = os.clock()
	if now - AE.state.dex_lastHit > 3.0 then -- Moderate time window
		AE.state.dex_hits = 0
	end
	AE.state.dex_lastHit = now
	AE.state.dex_hits += 1
	if AE.state.dex_hits >= 3 then -- Moderate threshold for kicking
		AE.applyPunishment(
			'skid detected.'
		)
	end
end

AE.checkDex = function(inst)
	local ok, res = pcall(AE.looksLikeDexStrict, inst)
	if ok and res then
		AE.dexHit()
	end
end

AE.bindNameWatcher = function(inst)
	if not inst or not inst.GetPropertyChangedSignal then
		return
	end
	pcall(function()
		inst:GetPropertyChangedSignal('Name'):Connect(function()
			AE.checkDex(inst)
		end)
	end)
end

--============================= Safe Print Hook ===========================--

AE.installPrintHook = function()
	-- Safe print hook that prevents stack overflow
	AE.oldPrint = print
	local hookActive = false
	
	local newPrint = function(...)
		if hookActive then
			return AE.oldPrint(...) -- Prevent recursion
		end
		
		hookActive = true
		local n = select('#', ...)
		for i = 1, n do
			local arg = select(i, ...)
			if type(arg) == 'string' then
				local s = AE.tolower(arg)
				for _, p in ipairs(AE.CFG.BlacklistedPrintPhrases) do
					if string.find(s, p, 1, true) then
						hookActive = false
						AE.applyPunishment('skid detected.')
						return -- block
					end
				end
			end
		end
		hookActive = false
		return AE.oldPrint(...)
	end

	-- Only hook if safe to do so
	pcall(function()
		if getgenv then
			getgenv().print = newPrint
		else
			_G.print = newPrint
		end
	end)
end

--=============================== Bootstrap ===============================--

do
	-- Reduced monitoring to prevent performance issues
	-- Only monitor new descendants, not existing ones
	AE.S.CoreGui.DescendantAdded:Connect(function(d)
		-- Only check for obvious threats, not everything
		pcall(function()
			AE.checkDex(d)
		end)
	end)

	-- Remote baseline + scanner (less aggressive)
	pcall(function()
		AE.captureOriginals()
		AE.startHookScan()
	end)

	-- Print hook (simplified)
	AE.installPrintHook()
end

-- String Obfuscation Helper (Optimized)
_G._0x8E3F = function(str)
    if not str then return "" end
    local result = ""
    for i = 1, #str do
        result = result .. string.char(string.byte(str, i) + 1)
    end
    return result
end

-- Function Name Scrambling (safe)
pcall(function()
    _G._0x1A2B = _G._0x8E3F("createProtectedScreenGui")
    _G._0x2B3C = _G._0x8E3F("createMobileCompatibleGui")
    _G._0x3C4D = _G._0x8E3F("detectExecutor")
end)

-- Mobile Executor Detection & Compatibility
_G.detectExecutor = function()
    _G.executor = "unknown"
    if getgenv and getgenv().executor then
        _G.executor = getgenv().executor
    elseif syn and syn.request then
        _G.executor = "synapse"
    elseif krnl and krnl.request then
        _G.executor = "krnl"
    elseif fluxus and fluxus.request then
        _G.executor = "fluxus"
    elseif is_sirhurt_closure then
        _G.executor = "sirhurt"
    elseif identifyexecutor then
        _G.executor = identifyexecutor()
    end
    return _G.executor
end

_G.executor = _G.detectExecutor()
_G.isMobile = _G.executor:find("mobile") or _G.executor:find("android") or _G.executor:find("ios")

-- Enhanced UI Creation for Mobile Compatibility
_G.createMobileCompatibleGui = function(name)
    _G.gui = nil
    
    -- Executor-specific optimizations
    if _G.isMobile then
        -- Mobile-specific methods
        _G.mobileMethods = {
            function()
                if syn and syn.protect_gui then
                    _G.gui = Instance.new("ScreenGui")
                    _G.gui.Name = name
                    _G.gui.ResetOnSpawn = false
                    _G.gui.Parent = game:GetService("CoreGui")
                    syn.protect_gui(_G.gui)
                    _G.gui.IgnoreGuiInset = true
                    return _G.gui
                end
            end,
            function()
                if gethui then
                    _G.gui = Instance.new("ScreenGui")
                    _G.gui.Name = name
                    _G.gui.ResetOnSpawn = false
                    _G.gui.Parent = gethui()
                    _G.gui.IgnoreGuiInset = true
                    return _G.gui
                end
            end,
            function()
                _G.gui = Instance.new("ScreenGui")
                _G.gui.Name = name
                _G.gui.ResetOnSpawn = false
                _G.gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                _G.gui.IgnoreGuiInset = true
                return _G.gui
            end
        }
        
        for i, method in ipairs(_G.mobileMethods) do
            _G.success, _G.result = pcall(method)
            if _G.success and _G.result then
                return _G.result
            end
        end
    else
        -- PC-specific methods
        _G.pcMethods = {
            function() 
                if syn and syn.protect_gui then
                    _G.gui = Instance.new("ScreenGui")
                    _G.gui.Name = name
                    _G.gui.ResetOnSpawn = false
                    _G.gui.Parent = game:GetService("CoreGui")
                    syn.protect_gui(_G.gui)
                    return _G.gui
                end
            end,
            function()
                if gethui then
                    _G.gui = Instance.new("ScreenGui")
                    _G.gui.Name = name
                    _G.gui.ResetOnSpawn = false
                    _G.gui.Parent = gethui()
                    return _G.gui
                end
            end,
            function()
                if get_hidden_ui then
                    _G.gui = Instance.new("ScreenGui")
                    _G.gui.Name = name
                    _G.gui.ResetOnSpawn = false
                    _G.gui.Parent = get_hidden_ui()
                    return _G.gui
                end
            end,
            function()
                _G.gui = Instance.new("ScreenGui")
                _G.gui.Name = name
                _G.gui.ResetOnSpawn = false
                _G.gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                return _G.gui
            end
        }
        
        for i, method in ipairs(_G.pcMethods) do
            _G.success, _G.result = pcall(method)
            if _G.success and _G.result then
                return _G.result
            end
        end
    end
    
    return nil
end

-- Mobile Touch Optimization
_G.optimizeForMobile = function(gui)
    if _G.isMobile then
        pcall(function()
            gui.IgnoreGuiInset = true
            gui.ResetOnSpawn = false
            gui.DisplayOrder = 999999999
            
            -- Mobile-specific attributes
            if gui.SetAttribute then
                gui:SetAttribute("MobileOptimized", true)
                gui:SetAttribute("TouchEnabled", true)
            end
        end)
    end
end

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local username = player.Name


local CONFIG = {
    Colors = {
        Background = Color3.fromRGB(18, 18, 18),
        Sidebar = Color3.fromRGB(22, 22, 22),
        Panel = Color3.fromRGB(28, 28, 28),
        Stroke = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(240, 240, 240),
        SubText = Color3.fromRGB(160, 160, 160),
        Accent = Color3.fromRGB(14, 144, 210),
        Hover = Color3.fromRGB(40, 40, 40),
        Danger = Color3.fromRGB(220, 70, 70),
        SwitchOff = Color3.fromRGB(70, 70, 70),
        SwitchOn = Color3.fromRGB(14, 144, 210),
        SectionHeader = Color3.fromRGB(38, 38, 38),
        ESPHighlight = Color3.fromRGB(255, 0, 0),
        PlotESPHighlight = Color3.fromRGB(0, 255, 0),
        BrainrotESPHighlight = Color3.fromRGB(0, 0, 255), -- New color for Brainrot ESP
    },
    UI = {
        CornerRadius = UDim.new(0, 10),
        AnimationSpeed = 0.2,
        FrameSize = UDim2.new(0, 580, 0, 380),
        SidebarWidth = 140,
        MinimizedSize = UDim2.new(0, 580, 0, 40),
        SettingsFrameSize = UDim2.new(0, 400, 0, 300),
        TextSize = 14,
        TitleTextSize = 18,
        HeaderTextSize = 15,
        ButtonTextSize = 14,
        -- UI State Persistence
        IsMinimized = false,
        SettingsOpen = false,
        CurrentTab = "Movement",
        InputTextSize = 14,
        Font = Enum.Font.Gotham,
        TitleFont = Enum.Font.GothamBold,
        HeaderFont = Enum.Font.GothamBold,
        ButtonFont = Enum.Font.GothamMedium,
        InputFont = Enum.Font.Gotham,
        Transparency = 0,
        BackgroundTransparency = 0,
        StrokeTransparency = 0.4,
        HoverTransparency = 0.1,
        ActiveTransparency = 0.2,
    },
    ESP = {
        UpdateInterval = 0.1,
        PlayerESP = {
            ShowDistance = true,
            ShowItems = true,
            TextSize = 18,
            DistanceTextSize = 14,
            ItemTextSize = 12,
            UsernameColor = Color3.fromRGB(255, 255, 255),
            DistanceColor = Color3.fromRGB(255, 255, 255),
            ItemColor = Color3.fromRGB(255, 255, 255),
            HighlightColor = Color3.fromRGB(255, 0, 0),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            OutlineTransparency = 0.4,
            FillTransparency = 1,
        },
        PlotESP = {
            ShowDistance = true,
            ShowOwner = true,
            ShowTime = true,
            TextSize = 16,
            DistanceTextSize = 14,
            OwnerTextSize = 16,
            TimeTextSize = 14,
            OwnerColor = Color3.fromRGB(255, 255, 255),
            DistanceColor = Color3.fromRGB(255, 255, 255),
            TimeColor = Color3.fromRGB(160, 160, 160),
            HighlightColor = Color3.fromRGB(0, 255, 0),
            OutlineColor = Color3.fromRGB(0, 0, 0),
            OutlineTransparency = 0.4,
            FillTransparency = 1,
        },
    },
    Movement = {
        Speed = 43,
        MaxSpeed = 45,
        JumpPower = 73.5,
        Rise = {
            Enabled = false,
            Speed = 5,
            MaxHeight = 500,
        },
        Unhittable = {
            IntermediateSize = { X = 2, Y = 20, Z = 1 },
            TallSize = { X = 2, Y = 40, Z = 1 },
        },
        Resize = {
            TargetSize = { X = 2, Y = 10, Z = 1 },
		},
		Float = {
			Enabled = false,
			DescentSpeed = 2.5, -- Downward speed (2.5 = gentle; adjust: 1 = slower, 4 = faster)
			VelocityBlend = 1, -- Slight randomization to avoid anti-cheat detection
        },
        Helicopter = {
            Enabled = false,
            RotationSpeed = 20, -- How fast to rotate
        },
        GrappleFlight = {
            Enabled = false,
            Speed = 150, -- Flight speed
        },
        InfiniteJump = {
            Enabled = false,
            JumpPower = 42, -- Jump velocity
            Cooldown = 0.2, -- Cooldown between jumps
        },
        BrainrotESP = {
            Enabled = false,
            TextSize = 20,
            DistanceTextSize = 16,
            UsernameColor = Color3.fromRGB(255, 215, 0), -- Gold color
            DistanceColor = Color3.fromRGB(255, 255, 255),
            HighlightColor = Color3.fromRGB(0, 0, 255), -- Blue highlight for brainrot
            OutlineColor = Color3.fromRGB(0, 0, 0),
            FillTransparency = 0.5,
		},
    },
    DiscordLink = "https://discord.gg/MxtDGmvkCd",
}

_G.OpenCircularToggles = {}  -- Sigma Table

-- Settings file path
local SETTINGS_FILE = "Ken_HUB_Settings.json"

_G.saveSettings = function()
    pcall(function()
        local settings = {
            ESP = {
                PlayerESP = CONFIG.ESP.PlayerESP,
                PlotESP = CONFIG.ESP.PlotESP,
                BrainrotESP = CONFIG.ESP.BrainrotESP,
            },
            Movement = {
                Speed = CONFIG.Movement.Speed,
                MaxSpeed = CONFIG.Movement.MaxSpeed,
                JumpPower = CONFIG.Movement.JumpPower,
                Float = CONFIG.Movement.Float,
                Rise = CONFIG.Movement.Rise,
                Helicopter = CONFIG.Movement.Helicopter,
                GrappleFlight = CONFIG.Movement.GrappleFlight,
                InfiniteJump = CONFIG.Movement.InfiniteJump,
            },
            UI = CONFIG.UI,
            Colors = CONFIG.Colors,
            AntiKick = CONFIG.AntiKick,
            OpenCircularToggles = {},  -- Save open draggable toggle positions
            ToggleStates = _G.SavedToggleStates or {}  -- Save toggle states
        }
        -- Serialize OpenCircularToggles (UDim2 to table)
        for name, pos in pairs(_G.OpenCircularToggles) do
            settings.OpenCircularToggles[name] = {
                XScale = pos.X.Scale,
                XOffset = pos.X.Offset,
                YScale = pos.Y.Scale,
                YOffset = pos.Y.Offset
            }
        end
        local json = HttpService:JSONEncode(settings)
        if _G.safeWriteFile(SETTINGS_FILE, json) then
        print("💾 Settings saved successfully")
        else
            print("❌ Failed to save settings - using memory only")
        end
    end)
end

_G.loadSettings = function()
    pcall(function()
        if _G.safeIsFile("Ken_HUB_Settings.json") then
            print("📁 Loading settings from file...")
            local fileContent = _G.safeReadFile("Ken_HUB_Settings.json")
            if not fileContent then
                print("❌ Failed to read settings file - using defaults")
                return
            end
            local settings = HttpService:JSONDecode(fileContent)
            
            -- Load CONFIG values (safely, only if not nil)
            if settings.Movement then
                for key, value in pairs(settings.Movement) do
                    if CONFIG.Movement[key] and value ~= nil then
                        CONFIG.Movement[key] = value
                    end
                end
                -- Explicitly load Rise sub-properties with defaults
                if settings.Movement.Rise then
                    CONFIG.Movement.Rise.Enabled = settings.Movement.Rise.Enabled or false
                    CONFIG.Movement.Rise.Speed = settings.Movement.Rise.Speed or 5
                    CONFIG.Movement.Rise.MaxHeight = settings.Movement.Rise.MaxHeight or 500
                end
            end
            if settings.ESP then
                for key, value in pairs(settings.ESP) do
                    if CONFIG.ESP[key] and value ~= nil then
                        CONFIG.ESP[key] = value
                    end
                end
            end
            if settings.Colors then
                for key, value in pairs(settings.Colors) do
                    if CONFIG.Colors[key] and value ~= nil then
                        CONFIG.Colors[key] = value
                    end
                end
            end
            if settings.UI then
                for key, value in pairs(settings.UI) do
                    if value ~= nil then
                        CONFIG.UI[key] = value
                    end
                end
            end
            if settings.AntiKick and settings.AntiKick ~= nil then
                CONFIG.AntiKick = settings.AntiKick
            end
            
            -- Load OpenCircularToggles (deserialize to UDim2)
            if settings.OpenCircularToggles then
                _G.OpenCircularToggles = {}
                for name, posTable in pairs(settings.OpenCircularToggles) do
                    _G.OpenCircularToggles[name] = UDim2.new(posTable.XScale, posTable.XOffset, posTable.YScale, posTable.YOffset)
                end
            end
            
            -- Restore toggle states
            if settings.ToggleStates then
                _G.ESP_Enabled = settings.ToggleStates.PlayerESP or false
                _G.PlotESP_Enabled = settings.ToggleStates.PlotESP or false
                _G.PlotTimeESP_Enabled = settings.ToggleStates.PlotTimeESP or true
                _G.ServerHopActive = settings.ToggleStates.ServerHop or false
                CONFIG.Movement.Float.Enabled = settings.ToggleStates.Float or false
                CONFIG.Movement.Helicopter.Enabled = settings.ToggleStates.Helicopter or false
                if not CONFIG.AntiKick then CONFIG.AntiKick = {Enabled = false} end
                CONFIG.AntiKick.Enabled = settings.ToggleStates.AntiKick or false
                
                -- Store ALL toggle states for later restoration after UI creation (optimized)
                _G.SavedToggleStates = {
                    PlayerESP = settings.ToggleStates.PlayerESP or false,
                    PlotESP = settings.ToggleStates.PlotESP or false,
                    PlotTimeESP = settings.ToggleStates.PlotTimeESP or true,
                    BrainrotESP = settings.ToggleStates.BrainrotESP or false,
                    Invisibility = settings.ToggleStates.Invisibility or false,
                    Rise = settings.ToggleStates.Rise or false,
                    ServerHop = settings.ToggleStates.ServerHop or false,
                    Jump = settings.ToggleStates.Jump or false,
                    Speed = settings.ToggleStates.Speed or false,
                    HeightBypass = settings.ToggleStates.HeightBypass or false,
                    TallMode = settings.ToggleStates.TallMode or false,
                    Fling = settings.ToggleStates.Fling or false,
                    Helicopter = settings.ToggleStates.Helicopter or false,
                    Float = settings.ToggleStates.Float or false,
                    LaserCape = settings.ToggleStates.LaserCape or false,
                    AntiKick = settings.ToggleStates.AntiKick or false,
                    RagdollDesync = settings.ToggleStates.RagdollDesync or false
                }
            end
            print("✅ Settings loaded successfully!")
        else
            print("📁 No settings file found, using defaults")
        end
    end)
end

-- Comprehensive CONFIG validation and initialization
local function validateCONFIG()
    -- Ensure Colors table exists and has all required values
    if not CONFIG.Colors then CONFIG.Colors = {} end
    CONFIG.Colors.Background = CONFIG.Colors.Background or Color3.fromRGB(18, 18, 18)
    CONFIG.Colors.Sidebar = CONFIG.Colors.Sidebar or Color3.fromRGB(22, 22, 22)
    CONFIG.Colors.Panel = CONFIG.Colors.Panel or Color3.fromRGB(28, 28, 28)
    CONFIG.Colors.Stroke = CONFIG.Colors.Stroke or Color3.fromRGB(50, 50, 50)
    CONFIG.Colors.Text = CONFIG.Colors.Text or Color3.fromRGB(240, 240, 240)
    CONFIG.Colors.SubText = CONFIG.Colors.SubText or Color3.fromRGB(160, 160, 160)
    CONFIG.Colors.Accent = CONFIG.Colors.Accent or Color3.fromRGB(14, 144, 210)
    CONFIG.Colors.Hover = CONFIG.Colors.Hover or Color3.fromRGB(40, 40, 40)
    CONFIG.Colors.Danger = CONFIG.Colors.Danger or Color3.fromRGB(220, 70, 70)
    CONFIG.Colors.SwitchOff = CONFIG.Colors.SwitchOff or Color3.fromRGB(70, 70, 70)
    CONFIG.Colors.SwitchOn = CONFIG.Colors.SwitchOn or Color3.fromRGB(14, 144, 210)
    CONFIG.Colors.SectionHeader = CONFIG.Colors.SectionHeader or Color3.fromRGB(38, 38, 38)
    CONFIG.Colors.ESPHighlight = CONFIG.Colors.ESPHighlight or Color3.fromRGB(255, 0, 0)
    CONFIG.Colors.PlotESPHighlight = CONFIG.Colors.PlotESPHighlight or Color3.fromRGB(0, 255, 0)
    CONFIG.Colors.BrainrotESPHighlight = CONFIG.Colors.BrainrotESPHighlight or Color3.fromRGB(0, 0, 255)
    
    -- Ensure UI table exists and has all required values
    if not CONFIG.UI then CONFIG.UI = {} end
    CONFIG.UI.CornerRadius = CONFIG.UI.CornerRadius or UDim.new(0, 10)
    CONFIG.UI.AnimationSpeed = CONFIG.UI.AnimationSpeed or 0.2
    CONFIG.UI.FrameSize = CONFIG.UI.FrameSize or UDim2.new(0, 580, 0, 380)
    CONFIG.UI.SidebarWidth = CONFIG.UI.SidebarWidth or 140
    CONFIG.UI.MinimizedSize = CONFIG.UI.MinimizedSize or UDim2.new(0, 580, 0, 40)
    CONFIG.UI.SettingsFrameSize = CONFIG.UI.SettingsFrameSize or UDim2.new(0, 400, 0, 300)
    CONFIG.UI.TextSize = CONFIG.UI.TextSize or 14
    CONFIG.UI.TitleTextSize = CONFIG.UI.TitleTextSize or 18
    CONFIG.UI.HeaderTextSize = CONFIG.UI.HeaderTextSize or 15
    CONFIG.UI.ButtonTextSize = CONFIG.UI.ButtonTextSize or 14
    CONFIG.UI.IsMinimized = CONFIG.UI.IsMinimized or false
    CONFIG.UI.SettingsOpen = CONFIG.UI.SettingsOpen or false
    CONFIG.UI.CurrentTab = CONFIG.UI.CurrentTab or "Movement"
    CONFIG.UI.InputTextSize = CONFIG.UI.InputTextSize or 14
    CONFIG.UI.Font = CONFIG.UI.Font or Enum.Font.Gotham
    CONFIG.UI.TitleFont = CONFIG.UI.TitleFont or Enum.Font.GothamBold
    CONFIG.UI.HeaderFont = CONFIG.UI.HeaderFont or Enum.Font.GothamBold
    CONFIG.UI.ButtonFont = CONFIG.UI.ButtonFont or Enum.Font.GothamMedium
    CONFIG.UI.InputFont = CONFIG.UI.InputFont or Enum.Font.Gotham
    CONFIG.UI.Transparency = CONFIG.UI.Transparency or 0
    CONFIG.UI.BackgroundTransparency = CONFIG.UI.BackgroundTransparency or 0
    CONFIG.UI.StrokeTransparency = CONFIG.UI.StrokeTransparency or 0.4
    CONFIG.UI.HoverTransparency = CONFIG.UI.HoverTransparency or 0.1
    CONFIG.UI.ActiveTransparency = CONFIG.UI.ActiveTransparency or 0.2
    
    -- Ensure ESP table exists and has all required values
    if not CONFIG.ESP then CONFIG.ESP = {} end
    if not CONFIG.ESP.PlayerESP then CONFIG.ESP.PlayerESP = {} end
    CONFIG.ESP.PlayerESP.HighlightColor = CONFIG.ESP.PlayerESP.HighlightColor or Color3.fromRGB(255, 0, 0)
    CONFIG.ESP.PlayerESP.UsernameColor = CONFIG.ESP.PlayerESP.UsernameColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.PlayerESP.DistanceColor = CONFIG.ESP.PlayerESP.DistanceColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.PlayerESP.ItemColor = CONFIG.ESP.PlayerESP.ItemColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.PlayerESP.OutlineColor = CONFIG.ESP.PlayerESP.OutlineColor or Color3.fromRGB(0, 0, 0)
    CONFIG.ESP.PlayerESP.OutlineTransparency = CONFIG.ESP.PlayerESP.OutlineTransparency or 0.4
    CONFIG.ESP.PlayerESP.FillTransparency = CONFIG.ESP.PlayerESP.FillTransparency or 1
    
    if not CONFIG.ESP.PlotESP then CONFIG.ESP.PlotESP = {} end
    CONFIG.ESP.PlotESP.HighlightColor = CONFIG.ESP.PlotESP.HighlightColor or Color3.fromRGB(0, 255, 0)
    CONFIG.ESP.PlotESP.OwnerColor = CONFIG.ESP.PlotESP.OwnerColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.PlotESP.DistanceColor = CONFIG.ESP.PlotESP.DistanceColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.PlotESP.TimeColor = CONFIG.ESP.PlotESP.TimeColor or Color3.fromRGB(160, 160, 160)
    CONFIG.ESP.PlotESP.OutlineColor = CONFIG.ESP.PlotESP.OutlineColor or Color3.fromRGB(0, 0, 0)
    CONFIG.ESP.PlotESP.OutlineTransparency = CONFIG.ESP.PlotESP.OutlineTransparency or 0.4
    CONFIG.ESP.PlotESP.FillTransparency = CONFIG.ESP.PlotESP.FillTransparency or 1
    
    if not CONFIG.ESP.BrainrotESP then CONFIG.ESP.BrainrotESP = {} end
    CONFIG.ESP.BrainrotESP.Enabled = CONFIG.ESP.BrainrotESP.Enabled or false
    CONFIG.ESP.BrainrotESP.TextSize = CONFIG.ESP.BrainrotESP.TextSize or 20
    CONFIG.ESP.BrainrotESP.DistanceTextSize = CONFIG.ESP.BrainrotESP.DistanceTextSize or 16
    CONFIG.ESP.BrainrotESP.UsernameColor = CONFIG.ESP.BrainrotESP.UsernameColor or Color3.fromRGB(255, 215, 0)
    CONFIG.ESP.BrainrotESP.DistanceColor = CONFIG.ESP.BrainrotESP.DistanceColor or Color3.fromRGB(255, 255, 255)
    CONFIG.ESP.BrainrotESP.HighlightColor = CONFIG.ESP.BrainrotESP.HighlightColor or Color3.fromRGB(0, 0, 255)
    CONFIG.ESP.BrainrotESP.OutlineColor = CONFIG.ESP.BrainrotESP.OutlineColor or Color3.fromRGB(0, 0, 0)
    CONFIG.ESP.BrainrotESP.FillTransparency = CONFIG.ESP.BrainrotESP.FillTransparency or 0.5
    
    -- Ensure Movement table exists and has all required values
    if not CONFIG.Movement then CONFIG.Movement = {} end
    if not CONFIG.Movement.Float then CONFIG.Movement.Float = {} end
    CONFIG.Movement.Float.Enabled = CONFIG.Movement.Float.Enabled or false
    CONFIG.Movement.Float.DescentSpeed = CONFIG.Movement.Float.DescentSpeed or 4
    CONFIG.Movement.Float.VelocityBlend = CONFIG.Movement.Float.VelocityBlend or 1
    
    if not CONFIG.Movement.Helicopter then CONFIG.Movement.Helicopter = {} end
    CONFIG.Movement.Helicopter.Enabled = CONFIG.Movement.Helicopter.Enabled or false
    CONFIG.Movement.Helicopter.RotationSpeed = CONFIG.Movement.Helicopter.RotationSpeed or 50
    
    if not CONFIG.Movement.GrappleFlight then CONFIG.Movement.GrappleFlight = {} end
    CONFIG.Movement.GrappleFlight.Enabled = CONFIG.Movement.GrappleFlight.Enabled or false
    CONFIG.Movement.GrappleFlight.Speed = CONFIG.Movement.GrappleFlight.Speed or 150
    
    if not CONFIG.Movement.InfiniteJump then CONFIG.Movement.InfiniteJump = {} end
    CONFIG.Movement.InfiniteJump.Enabled = CONFIG.Movement.InfiniteJump.Enabled or false
    CONFIG.Movement.InfiniteJump.JumpPower = CONFIG.Movement.InfiniteJump.JumpPower or 42
    CONFIG.Movement.InfiniteJump.Cooldown = CONFIG.Movement.InfiniteJump.Cooldown or 0.2
    
    if not CONFIG.Movement.Rise then CONFIG.Movement.Rise = {} end
    CONFIG.Movement.Rise.Enabled = CONFIG.Movement.Rise.Enabled or false
    CONFIG.Movement.Rise.Speed = CONFIG.Movement.Rise.Speed or 5
    CONFIG.Movement.Rise.MaxHeight = CONFIG.Movement.Rise.MaxHeight or 500
    
end

-- Initialize CONFIG defaults before loading
validateCONFIG()

-- Load settings on startup
_G.loadSettings()

-- Re-validate CONFIG after loading to ensure no corruption
validateCONFIG()

-- Function to save UI state and ALL toggle states
_G.saveUIState = function()
    pcall(function()
        -- Initialize SavedToggleStates if not exists
        if not _G.SavedToggleStates then
            _G.SavedToggleStates = {}
        end
        
        -- Save ALL toggle states (optimized with table lookup to reduce local variables)
        local switchMap = {
            PlayerESP = playerESPSwitch,
            PlotESP = plotESPSwitch,
            BrainrotESP = brainrotESPSwitch,
            Invisibility = invisibilitySwitch,
            Jump = jumpSwitch,
            Speed = speedSwitch,
            HeightBypass = unhittableSwitchInstance,
            TallMode = resizeSwitchInstance,
            Fling = flingSwitchInstance,
            Helicopter = helicopterSwitch,
            GrappleFlight = grappleFlightSwitch,
            InfiniteJump = infiniteJumpSwitch,
            Float = floatSwitch,
            Rise = platformSwitch,
            AntiKick = antiKickSwitch,
            LaserCape = originalLaserCapeSwitch,
            RagdollDesync = ragdollDesyncSwitch,
            ServerHop = serverHopSwitch
        }
        
        -- Global ESP switches (override local ones if they exist)
        if _G.playerESPSwitch and _G.playerESPSwitch.get then
            switchMap.PlayerESP = _G.playerESPSwitch
        end
        if _G.plotESPSwitch and _G.plotESPSwitch.get then
            switchMap.PlotESP = _G.plotESPSwitch
        end
        
        for stateName, switch in pairs(switchMap) do
            if switch and switch.get then
                _G.SavedToggleStates[stateName] = switch.get()
                if stateName == "Rise" then
                    print("💾 Saving Platform state:", switch.get())
                end
            elseif stateName == "Rise" then
            print("⚠️ Platform switch not found for saving")
        end
        end
        
        -- Save UI state
        if mainFrame then
            CONFIG.UI.IsMinimized = isMinimized or false
        end
        if settingsFrame then
            CONFIG.UI.SettingsOpen = settingsFrame.Visible or false
        end
        CONFIG.UI.CurrentTab = activeSection or "Movement"
        
        _G.saveSettings()
    end)
end
-- Duplicate function removed - using the second createCircularToggleUI function

_G.applyLoadedToggleStates = function()
    pcall(function()
        -- Add a short delay to ensure all switches are initialized (fix for re-execute timing)
        task.wait(0.5)
        
        print("🔄 Restoring toggle states...")
        print("📁 SavedToggleStates exists:", _G.SavedToggleStates ~= nil)
        
            -- Map toggle names to their actual get/set handlers so reopened toggles still function correctly
            local function resolveToggleHandlers(name)
                if name == "Speed" then
                    return function() return speedSwitch and speedSwitch.get and speedSwitch.get() or false end,
                           function(state) if speedSwitch and speedSwitch.set then speedSwitch.set(state) end end
                elseif name == "Jump" then
                    return function() return jumpSwitch and jumpSwitch.get and jumpSwitch.get() or false end,
                           function(state) if jumpSwitch and jumpSwitch.set then jumpSwitch.set(state) end end
                elseif name == "Float" then
                    return function() return CONFIG.Movement.Float.Enabled end,
                           function(state) CONFIG.Movement.Float.Enabled = state; _G.saveSettings(); if state and player.Character then enableFloat(player.Character) end end
            elseif name == "Rise" or name == "Platform" then
                    return function() return CONFIG.Movement.Rise.Enabled end,
                       function(state) CONFIG.Movement.Rise.Enabled = state; _G.saveSettings(); if state and player.Character then enablePlatform(player.Character) end end
                elseif name == "Helicopter" then
                    return function() return CONFIG.Movement.Helicopter.Enabled end,
                           function(state) CONFIG.Movement.Helicopter.Enabled = state; _G.saveSettings(); if state and player.Character then enableHelicopter(player.Character) end end
                elseif name == "Invisibility" then
                    return function() return invisibilitySwitch and invisibilitySwitch.get and invisibilitySwitch.get() or false end,
                           function(state) if invisibilitySwitch and invisibilitySwitch.set then invisibilitySwitch.set(state) end end
                elseif name == "Player ESP" then
                    return function() return _G.ESP_Enabled end,
                           function(state) if state then enableESP() else disableESP() end end
                elseif name == "Plot ESP" then
                    return function() return _G.PlotESP_Enabled end,
                           function(state) if state then enablePlotESP() else disablePlotESP() end end
                elseif name == "Grapple Flight" then
                    return function() return CONFIG.Movement.GrappleFlight.Enabled end,
                           function(state) CONFIG.Movement.GrappleFlight.Enabled = state; _G.saveSettings(); if state and player.Character then enableGrappleFlight(player.Character) end end
                elseif name == "Infinite Jump" then
                    return function() return CONFIG.Movement.InfiniteJump.Enabled end,
                           function(state) CONFIG.Movement.InfiniteJump.Enabled = state; _G.saveSettings(); if state and player.Character then enableInfiniteJump(player.Character) end end
                elseif name == "Brainrot ESP" then
                    return function() return CONFIG.ESP.BrainrotESP.Enabled end,
                           function(state) CONFIG.ESP.BrainrotESP.Enabled = state; _G.saveSettings(); if state then enableBrainrotESP() else disableBrainrotESP() end end
                elseif name == "Mobile Desync" then
                    return function() return _G.mobileDesyncEnabled end,
                           function(state) _G.mobileDesyncEnabled = state end
                end
                -- Default no-op handlers
                return function() return false end, function(_) end
            end

        if _G.SavedToggleStates then
            print("📁 Found saved toggle states:", _G.SavedToggleStates)
            
            -- Optimized toggle restoration with table lookup
            local restoreMap = {
                PlayerESP = {switch = playerESPSwitch, name = "Player ESP"},
                PlotESP = {switch = plotESPSwitch, name = "Plot ESP"},
                BrainrotESP = {switch = brainrotESPSwitch, name = "Brainrot ESP"},
                Invisibility = {switch = invisibilitySwitch, name = "Invisibility"},
                Jump = {switch = jumpSwitch, name = "Jump"},
                Speed = {switch = speedSwitch, name = "Speed"},
                HeightBypass = {switch = unhittableSwitchInstance, name = "Height Bypass"},
                TallMode = {switch = resizeSwitchInstance, name = "Tall Mode"},
                Fling = {switch = flingSwitchInstance, name = "Fling"},
                Rise = {switch = platformSwitch, name = "Platform"},
                Helicopter = {switch = helicopterSwitch, name = "Helicopter"},
                GrappleFlight = {switch = grappleFlightSwitch, name = "Grapple Flight"},
                InfiniteJump = {switch = infiniteJumpSwitch, name = "Infinite Jump"},
                Float = {switch = floatSwitch, name = "Float"},
                AntiKick = {switch = antiKickSwitch, name = "Anti-Kick"},
                LaserCape = {switch = originalLaserCapeSwitch, name = "Laser Cape"},
                RagdollDesync = {switch = ragdollDesyncSwitch, name = "Ragdoll Desync"},
                ServerHop = {switch = serverHopSwitch, name = "Server Hop"}
            }
            
            -- Global ESP switches (override local ones if they exist)
            if _G.playerESPSwitch and _G.playerESPSwitch.set then
                restoreMap.PlayerESP = {switch = _G.playerESPSwitch, name = "Player ESP"}
            end
            if _G.plotESPSwitch and _G.plotESPSwitch.set then
                restoreMap.PlotESP = {switch = _G.plotESPSwitch, name = "Plot ESP"}
            end
            
            -- Set switches to their saved states AND create side toggles
            for stateName, data in pairs(restoreMap) do
                if data.switch and data.switch.set and _G.SavedToggleStates[stateName] then
                    print("✅ Setting " .. data.name .. " to enabled")
                    data.switch.set(true)
                    
                    -- Create side toggle for enabled switches
                    local getHandler, setHandler = resolveToggleHandlers(data.name)
                    if getHandler and setHandler then
                        pcall(function()
                            _G.createCircularToggleUI(data.name, getHandler, setHandler)
                            print("🎯 Created side toggle for: " .. data.name)
                        end)
                    end
                end
            end
        else
            print("❌ No saved toggle states found")
        end
        print("✅ Toggle restoration complete!")
        
        -- Restore UI state
        if CONFIG.UI.IsMinimized and mainFrame then
            mainFrame.Size = CONFIG.UI.MinimizedSize
            isMinimized = true
        end
        if CONFIG.UI.SettingsOpen and settingsFrame then
            settingsFrame.Visible = true
        end
        if CONFIG.UI.CurrentTab and sections[CONFIG.UI.CurrentTab] then
            activeSection = CONFIG.UI.CurrentTab
            for name, section in pairs(sections) do
                section.Visible = (name == CONFIG.UI.CurrentTab)
            end
            -- Update sidebar button colors
            for _, button in pairs(sidebar:GetChildren()) do
                if button:IsA("TextButton") and button.Name:match("Button$") then
                    local sectionName = button.Name:gsub("Button", "")
                    if sectionName == CONFIG.UI.CurrentTab then
                        button.BackgroundColor3 = CONFIG.Colors.Accent
                    else
                        button.BackgroundColor3 = CONFIG.Colors.Sidebar
                    end
                end
                end
            end

            -- Initialize other features after toggles are recreated. Wrap in pcalls to avoid aborting this thread.
        task.delay(2.0, function() -- Increased delay to ensure character is fully ready
            print("🔄 Reinitializing enabled features...")
            
            -- Wait for character to be fully loaded
            if not player.Character then
                print("⏳ Waiting for character to spawn...")
                player.CharacterAdded:Wait()
            end
            
            task.wait(1.0) -- Additional wait for character to be ready
            
            pcall(function()
                if _G.ESP_Enabled then 
                    print("🔄 Reinitializing Player ESP...")
                    enableESP() 
                    
                    -- Refresh Player ESP colors
                    task.wait(0.5)
                    for plr, data in pairs(_G.ESP_Data) do
                        if typeof(plr) == "Instance" and data.highlight and plr.Character then
                            pcall(function() 
                                data.highlight.FillColor = CONFIG.ESP.PlayerESP.HighlightColor
                                data.highlight.OutlineColor = CONFIG.ESP.PlayerESP.HighlightColor
                                print("🎨 Refreshed Player ESP color for: " .. plr.Name)
                            end)
                        end
                    end
                end
            end)
            
            pcall(function()
                if _G.PlotESP_Enabled then 
                    print("🔄 Reinitializing Plot ESP...")
                    enablePlotESP() 
                end
            end)
            
            pcall(function()
                if _G.PlotTimeESP_Enabled then 
                    print("🔄 Reinitializing Plot Time ESP...")
                    enablePlotTimeESP() 
                end
            end)
            
            pcall(function()
                if CONFIG.ESP.BrainrotESP.Enabled then 
                    print("🔄 Reinitializing Brainrot ESP...")
                    enableBrainrotESP() 
                end
            end)
            
            pcall(function()
                if _G.ServerHopActive then 
                    print("🔄 Reinitializing Server Hop...")
                    _G.toggleServerHop(true) 
                end
            end)
            
            pcall(function()
                if CONFIG.Movement.Float.Enabled and player.Character then 
                    print("🔄 Reinitializing Float...")
                    enableFloat(player.Character) 
                end
            end)
            
            pcall(function()
                if CONFIG.Movement.Helicopter.Enabled and player.Character then 
                    print("🔄 Reinitializing Helicopter...")
                    enableHelicopter(player.Character) 
                end
            end)
            
            pcall(function()
                if CONFIG.AntiKick.Enabled then 
                    print("🔄 Reinitializing Anti-Kick...")
                    enableAntiKick() 
                end
            end)
            
            pcall(function()
                if _G.mobileDesyncEnabled then 
                    print("🔄 Reinitializing Mobile Desync...")
                    enableMobileDesync() 
                end
            end)
            
                -- Re-enable movement features
            pcall(function()
                if _G.SavedToggleStates.Rise and player.Character then 
                    print("🔄 Reinitializing Platform...")
                    enablePlatform(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.Jump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    print("🔄 Reinitializing Jump Power...")
                    local hum = player.Character:FindFirstChildOfClass("Humanoid")
                    hum.UseJumpPower = true
                    hum.JumpPower = CONFIG.Movement.JumpPower
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.Speed and player.Character then 
                    print("🔄 Reinitializing Speed...")
                    enableSpeed(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.Invisibility and player.Character then 
                    print("🔄 Reinitializing Invisibility...")
                    task.wait(0.5) -- Wait for character to be ready
                    setInvisibility(true) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.HeightBypass and player.Character then 
                    print("🔄 Reinitializing Height Bypass...")
                    enableHeightBypass(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.TallMode and player.Character then 
                    print("🔄 Reinitializing Tall Mode...")
                    enableTallMode(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.Fling and player.Character then 
                    print("🔄 Reinitializing Fling...")
                    enableFling(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.GrappleFlight and player.Character then 
                    print("🔄 Reinitializing Grapple Flight...")
                    enableGrappleFlight(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.InfiniteJump and player.Character then 
                    print("🔄 Reinitializing Infinite Jump...")
                    enableInfiniteJump(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.LaserCape and player.Character then 
                    print("🔄 Reinitializing Laser Cape...")
                    enableLaserCape(player.Character) 
                end
            end)
            
            pcall(function()
                if _G.SavedToggleStates.RagdollDesync and player.Character then 
                    print("🔄 Reinitializing Ragdoll Desync...")
                    enableRagdollDesync(player.Character) 
                end
            end)
            
            print("✅ Feature reinitialization complete!")
        end)
        end)
end

--=========================================================
-- Safe UI Parent
--=========================================================
local function getSafeUiParent()
    local ok, hidden = pcall(function()
        if _G.EXECUTOR_SUPPORT.gethui then
            return gethui()
        elseif _G.EXECUTOR_SUPPORT.get_hidden_ui then
            return get_hidden_ui()
        elseif _G.EXECUTOR_SUPPORT.syn and syn.protect_gui then
            return function(gui) return gui end
        end
        return nil
    end)
    if ok and hidden then 
        return hidden 
    end
    
    -- Fallback to CoreGui if no safe UI is available
    print("⚠️ Using CoreGui as UI parent - may be visible to others")
    return CoreGui
end
local safeui = getSafeUiParent()

-- Helper function to create protected ScreenGui
local function createProtectedScreenGui(name, displayOrder)
    -- Use mobile-compatible GUI creation first
    _G.screenGui = _G.createMobileCompatibleGui(name)
    if _G.screenGui then
        _G.screenGui.DisplayOrder = displayOrder or 2^31-1
        -- Apply mobile optimizations
        _G.optimizeForMobile(_G.screenGui)
        -- Apply additional safety measures
        pcall(function()
            _G.screenGui.IgnoreGuiInset = true
            _G.screenGui.ResetOnSpawn = false
            if _G.screenGui.SetAttribute then
                _G.screenGui:SetAttribute("Hidden", true)
                _G.screenGui:SetAttribute("Executor", _G.executor)
            end
        end)
        return _G.screenGui
    end
    
    -- Fallback to original method
    _G.screenGui = Instance.new("ScreenGui")
    _G.screenGui.Name = name
    _G.screenGui.DisplayOrder = displayOrder or 2^31-1
    _G.screenGui.Parent = safeui
    _G.screenGui.ResetOnSpawn = false
    
    -- Apply GUI protection if available
    if syn and syn.protect_gui then
        syn.protect_gui(_G.screenGui)
    end
    
    -- Apply mobile optimizations
    _G.optimizeForMobile(_G.screenGui)
    
    -- Additional safety measures
    pcall(function()
        -- Make GUI less detectable
        _G.screenGui.IgnoreGuiInset = true
        _G.screenGui.ResetOnSpawn = false
        
        -- Hide from CoreGui detection if possible
        if _G.screenGui.SetAttribute then
            _G.screenGui:SetAttribute("Hidden", true)
            _G.screenGui:SetAttribute("Executor", _G.executor)
        end
    end)
    
    return _G.screenGui
end

-- Helper function to protect individual GUI elements
local function protectGuiElement(element)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(element)
        end
        
        -- Additional protection measures
        if element.SetAttribute then
            element:SetAttribute("Protected", true)
        end
    end)
end

--=========================================================
-- UI Configuration
--=========================================================
local namePrefix = "KenHub_"

--=========================================================
-- Character Essentials
--=========================================================
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character and character:WaitForChild("Humanoid", 5)
local humanoidRootPart = character and character:WaitForChild("HumanoidRootPart", 5)

-- Packages and Events
local UseItemEvent
local success, result = pcall(function()
    local packages = ReplicatedStorage:WaitForChild("Packages", 5)
    if packages then
        UseItemEvent = packages:FindFirstChild("Net") and packages.Net:FindFirstChild("RE/UseItem")
    end
    return UseItemEvent
end)
if not success or not result then
    warn("Failed to load packages or UseItemEvent: unsupported or missing")
end

--=========================================================
-- Helper Functions
--=========================================================
local function findPlayerPlot()
    local success, plot = pcall(function()
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder then return nil end
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            local plotSign = plot:FindFirstChild("PlotSign")
            if plotSign then
                local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
                local textLabel = frame and frame:FindFirstChild("TextLabel")
                if textLabel and textLabel:IsA("TextLabel") and string.find(textLabel.Text, username) then
                    return plot
                end
            end
        end
        return nil
    end)
    if not success or not plot then
        warn("Could not find player plot: unsupported or error occurred")
        return nil
    end
    return plot
end
local playerPlot = findPlayerPlot()

local function getPlotOwner(plot)
    local success, owner = pcall(function()
        local plotSign = plot:FindFirstChild("PlotSign")
        if not plotSign then return nil end
        local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
        local frame = surfaceGui and surfaceGui:FindFirstChild("Frame")
        local textLabel = frame and frame:FindFirstChild("TextLabel")
        if textLabel and textLabel:IsA("TextLabel") then
            return textLabel.Text
        end
        return nil
    end)
    if not success then
        return nil
    end
    return owner
end

local function getRemainingTime(plot)
    local success, timeText = pcall(function()
        -- Try the original path first
        local purchases = plot:FindFirstChild("Purchases")
        if purchases then
            local plotBlock = purchases:FindFirstChild("PlotBlock")
            if plotBlock then
                local main = plotBlock:FindFirstChild("Main")
                if main then
                    local billboardGui = main:FindFirstChild("BillboardGui")
                    if billboardGui then
                        local remainingTime = billboardGui:FindFirstChild("RemainingTime")
                        if remainingTime and remainingTime:IsA("TextLabel") then
                            return remainingTime.Text
                        end
                    end
                end
            end
        end

        -- Fallback: Search for BillboardGui in other locations
        local billboardGui = plot:FindFirstChild("BillboardGui", true) -- Recursive search
        if billboardGui then
            local remainingTime = billboardGui:FindFirstChild("RemainingTime")
            if remainingTime and remainingTime:IsA("TextLabel") then
                return remainingTime.Text
            end
        end

        -- Fallback: Check for time in StringValue or IntValue
        for _, obj in ipairs(plot:GetDescendants()) do
            if obj:IsA("StringValue") and obj.Name:lower():match("time") then
                return obj.Value
            elseif obj:IsA("IntValue") and obj.Name:lower():match("time") then
                return tostring(obj.Value) .. "s"
            end
        end

        -- If nothing is found, return a clear message
        return "Time: Unavailable"
    end)
    
    if not success then
        warn("Failed to get remaining time for plot: " .. plot.Name .. " - Error: " .. tostring(timeText))
        return "Time: Error"
    end
    
    return timeText or "Time: Unavailable"
end

local function setInvisibility(on)
    local success, _ = pcall(function()
        local currentCharacter = player.Character or character
        if not currentCharacter or not currentCharacter:FindFirstChild("Humanoid") then 
            print("❌ No character found for invisibility")
            return 
        end
        
        print("🔄 " .. (on and "Enabling" or "Disabling") .. " invisibility for character: " .. currentCharacter.Name)
        
        if on then
            for _, v in pairs(currentCharacter:GetChildren()) do
                if v:IsA("BasePart") then
                    _G.safeSetHiddenProperty(v, "NetworkIsSleeping", true)
                end
            end
            _G.safeSetHiddenProperty(currentCharacter.Humanoid, "OverrideDefaultCollisions", true)
            replicatesignal(currentCharacter.Humanoid.ServerBreakJoints)
            
            -- Add visual feedback
            for _, part in pairs(currentCharacter:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0.5 -- Make slightly transparent for visual feedback
                end
            end
            
            print("✅ Invisibility enabled - player should be transparent")
        else
            for _, v in pairs(currentCharacter:GetChildren()) do
                if v:IsA("BasePart") then
                    _G.safeSetHiddenProperty(v, "NetworkIsSleeping", false)
                end
            end
            _G.safeSetHiddenProperty(currentCharacter.Humanoid, "OverrideDefaultCollisions", false)
            
            -- Remove visual feedback
            for _, part in pairs(currentCharacter:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0 -- Make fully visible
                end
            end
            
            print("❌ Invisibility disabled - player should be visible")
        end
    end)
    if not success then
        warn("Failed to " .. (on and "enable" or "disable") .. " invisibility")
    end
end


--=========================================================
-- UI Setup: Cleaner Tabbed Navigation with Sidebar
--=========================================================


-- Circular Toggle UI System
_G.circularToggleGui = createProtectedScreenGui("CircularToggleUI")
protectGuiElement(_G.circularToggleGui)

-- Function to create toggle UI (rectangular with switch)
_G.createCircularToggleUI = function(toggleName, getState, setState)
    -- Check if toggle already exists and destroy it
    local existingToggle = _G.circularToggleGui:FindFirstChild(toggleName .. "ToggleUI")
    if existingToggle then
        existingToggle:Destroy()
    end
    
    -- Optimized toggle data structure to reduce local variables
    local toggleData = {
        frame = Instance.new("TextButton"),
        dragging = false,
        dragStart = nil,
        startPos = nil
    }
    
    -- Setup main frame
    toggleData.frame.Name = toggleName .. "ToggleUI"
    toggleData.frame.Size = UDim2.new(0, 220, 0, 70)
    -- Use saved position if available, otherwise position on right side
    local savedPosition = _G.OpenCircularToggles[toggleName]
    if not savedPosition then
        -- Calculate position on right side, stacked vertically
        local toggleCount = 0
        for name, _ in pairs(_G.OpenCircularToggles) do
            toggleCount = toggleCount + 1
        end
        savedPosition = UDim2.new(1, -230, 0, 10 + (toggleCount * 80))
    end
    toggleData.frame.Position = savedPosition
    toggleData.frame.BackgroundColor3 = CONFIG.Colors.Panel
    toggleData.frame.Text = ""
    toggleData.frame.AutoButtonColor = false
    toggleData.frame.Parent = _G.circularToggleGui
    Instance.new("UICorner", toggleData.frame).CornerRadius = UDim.new(0, 10)
    
    local stroke = Instance.new("UIStroke", toggleData.frame)
    stroke.Thickness = 2
    stroke.Color = CONFIG.Colors.Stroke
    stroke.Transparency = 0.2
    
    -- Create UI elements
    local elements = {
        dragHandle = Instance.new("TextButton"),
        closeBtn = Instance.new("TextButton"),
        titleLabel = Instance.new("TextLabel"),
        switchFrame = Instance.new("TextButton"),
        knob = Instance.new("Frame")
    }
    
    -- Setup drag handle
    elements.dragHandle.Size = UDim2.new(1, -70, 1, 0)
    elements.dragHandle.Position = UDim2.new(0, 0, 0, 0)
    elements.dragHandle.BackgroundTransparency = 1
    elements.dragHandle.Text = ""
    elements.dragHandle.AutoButtonColor = false
    elements.dragHandle.Parent = toggleData.frame
    
    -- Setup close button
    elements.closeBtn.Size = UDim2.new(0, 30, 0, 30)
    elements.closeBtn.Position = UDim2.new(1, -35, 0, 5)
    elements.closeBtn.BackgroundColor3 = CONFIG.Colors.Danger
    elements.closeBtn.Text = "x"
    elements.closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    elements.closeBtn.TextSize = 16
    elements.closeBtn.Font = Enum.Font.GothamBold
    elements.closeBtn.AutoButtonColor = false
    elements.closeBtn.Parent = toggleData.frame
    elements.closeBtn.ZIndex = 10
    Instance.new("UICorner", elements.closeBtn).CornerRadius = UDim.new(0, 15)
    
    -- Setup title label
    elements.titleLabel.Size = UDim2.new(1, -180, 0, 25)
    elements.titleLabel.Position = UDim2.new(0, 12, 0, 8)
    elements.titleLabel.BackgroundTransparency = 1
    elements.titleLabel.Text = toggleName
    elements.titleLabel.TextColor3 = CONFIG.Colors.Text
    elements.titleLabel.TextSize = 16
    elements.titleLabel.Font = Enum.Font.GothamBold
    elements.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    elements.titleLabel.Parent = toggleData.frame
    
    -- Setup toggle switch
    elements.switchFrame.Size = UDim2.new(0, 60, 0, 30)
    elements.switchFrame.Position = UDim2.new(0, 100, 0.5, -15)
    elements.switchFrame.BackgroundColor3 = getState() and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff
    elements.switchFrame.Text = ""
    elements.switchFrame.AutoButtonColor = false
    elements.switchFrame.Parent = toggleData.frame
    Instance.new("UICorner", elements.switchFrame).CornerRadius = UDim.new(0, 15)
    
    -- Setup knob
    elements.knob.Size = UDim2.new(0, 24, 0, 24)
    elements.knob.Position = UDim2.new(0, getState() and 30 or 3, 0, 3)
    elements.knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    elements.knob.Parent = elements.switchFrame
    Instance.new("UICorner", elements.knob).CornerRadius = UDim.new(0, 12)
    
    -- Optimized dragging functionality
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local inputPos = input.Position
            
            -- Check if clicking on close button or toggle switch (optimized collision detection)
            local closeBtnPos = elements.closeBtn.AbsolutePosition
            local closeBtnSize = elements.closeBtn.AbsoluteSize
            local switchPos = elements.switchFrame.AbsolutePosition
            local switchSize = elements.switchFrame.AbsoluteSize
            
            if (inputPos.X >= closeBtnPos.X and inputPos.X <= closeBtnPos.X + closeBtnSize.X and
                inputPos.Y >= closeBtnPos.Y and inputPos.Y <= closeBtnPos.Y + closeBtnSize.Y) or
               (inputPos.X >= switchPos.X and inputPos.X <= switchPos.X + switchSize.X and
                inputPos.Y >= switchPos.Y and inputPos.Y <= switchPos.Y + switchSize.Y) then
                return -- Don't start drag if clicking close button or toggle switch
            end
            
            -- Start drag
            toggleData.dragging = true
            toggleData.dragStart = input.Position
            toggleData.startPos = toggleData.frame.Position
            stroke.Transparency = 0 -- Visual feedback
        end
    end
    
    local function updateDrag(input)
        if toggleData.dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - toggleData.dragStart
            toggleData.frame.Position = UDim2.new(toggleData.startPos.X.Scale, toggleData.startPos.X.Offset + delta.X, toggleData.startPos.Y.Scale, toggleData.startPos.Y.Offset + delta.Y)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            toggleData.dragging = false
            stroke.Transparency = 0.2 -- Reset visual feedback
            _G.OpenCircularToggles[toggleName] = toggleData.frame.Position
            _G.saveSettings() -- Save position
        end
    end
    
    -- Connect drag events
    elements.dragHandle.InputBegan:Connect(startDrag)
    elements.dragHandle.InputChanged:Connect(updateDrag)
    elements.dragHandle.InputEnded:Connect(endDrag)
    
    -- Optimized switch functions
    local function updateSwitch()
        local currentState = getState()
        elements.switchFrame.BackgroundColor3 = currentState and CONFIG.Colors.SwitchOn or CONFIG.Colors.SwitchOff
        elements.knob.Position = UDim2.new(0, currentState and 30 or 3, 0, 3)
    end
    
    local function toggleSwitch()
        local newState = not getState()
        setState(newState)
        updateSwitch()
    end
    
    local function closeToggle()
        _G.OpenCircularToggles[toggleName] = nil
        _G.saveSettings()
        toggleData.frame:Destroy()
    end
    
    -- Connect switch events
    elements.switchFrame.MouseButton1Click:Connect(toggleSwitch)
    elements.switchFrame.TouchTap:Connect(toggleSwitch)
    elements.switchFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            toggleSwitch()
        end
    end)
    
    -- Connect close button events
    elements.closeBtn.MouseButton1Click:Connect(closeToggle)
    elements.closeBtn.TouchTap:Connect(closeToggle)
    
    -- Additional mobile support with InputBegan
    elements.closeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            closeToggle()
        end
    end)
    
    -- Save the initial position when toggle is created (only if not already saved)
    if not _G.OpenCircularToggles[toggleName] then
        _G.OpenCircularToggles[toggleName] = toggleData.frame.Position
        _G.saveSettings()
    end
    
    return toggleData.frame
end


--=============================================================
--  KEN HUB × AXL PREMIUM  |  واجهة عربية كاملة من الصفر
--=============================================================

------------ ثيم الألوان (أسود × ذهبي) ---------------------
local C = {
    BG        = Color3.fromRGB(7,   7,   7),
    PANEL     = Color3.fromRGB(14,  14,  14),
    ROW       = Color3.fromRGB(20,  20,  20),
    SIDEBAR   = Color3.fromRGB(11,  11,  11),
    GOLD      = Color3.fromRGB(255, 200,  40),
    GOLD2     = Color3.fromRGB(160, 118,  18),
    GOLD3     = Color3.fromRGB(55,  38,   3),
    WHITE     = Color3.fromRGB(238, 238, 238),
    SUB       = Color3.fromRGB(120, 120, 120),
    STROKE    = Color3.fromRGB(45,  34,   4),
    GREEN     = Color3.fromRGB(38,  200,  85),
    RED       = Color3.fromRGB(210,  45,  45),
    SWON      = Color3.fromRGB(255, 185,  28),
    SWOFF     = Color3.fromRGB(42,  42,  42),
    HBTN      = Color3.fromRGB(28,  21,   2),
}

------------ إنشاء الـ ScreenGui الرئيسي ---------------------
local screenGui      = createProtectedScreenGui((namePrefix or '')..'KenHUB_AXL_GUI')
local circularGui    = createProtectedScreenGui("KenHUB_FloatToggles")
protectGuiElement(circularGui)

------------ الإطار الرئيسي ----------------------------------
local mainFrame = Instance.new("Frame")
mainFrame.Name           = "Main"
mainFrame.Size           = UDim2.new(0, 630, 0, 410)
mainFrame.Position       = UDim2.new(0.5,-315, 0.5,-205)
mainFrame.BackgroundColor3 = C.BG
mainFrame.Active         = true
mainFrame.Draggable      = true
mainFrame.ClipsDescendants = true
mainFrame.Parent         = screenGui
protectGuiElement(mainFrame)
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local _mStroke = Instance.new("UIStroke", mainFrame)
_mStroke.Thickness = 1.5 ; _mStroke.Color = C.GOLD2 ; _mStroke.Transparency = 0.25
-- خط ذهبي تزييني في الأعلى
local _topLine = Instance.new("Frame", mainFrame)
_topLine.Size = UDim2.new(1,0,0,2) ; _topLine.BackgroundColor3 = C.GOLD
_topLine.BorderSizePixel = 0 ; _topLine.ZIndex = 5

------------ شريط العنوان (TopBar) ---------------------------
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1,0,0,46)
topBar.BackgroundColor3 = Color3.fromRGB(10,10,10)
topBar.BorderSizePixel = 0
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,14)
-- خط فاصل أسفل TopBar
local _tbLine = Instance.new("Frame", topBar)
_tbLine.Size = UDim2.new(1,0,0,1)
_tbLine.Position = UDim2.new(0,0,1,-1)
_tbLine.BackgroundColor3 = C.GOLD2
_tbLine.BackgroundTransparency = 0.35
_tbLine.BorderSizePixel = 0

-- لوقو K
local _logo = Instance.new("Frame", topBar)
_logo.Size = UDim2.new(0,32,0,32)
_logo.Position = UDim2.new(0,10,0.5,-16)
_logo.BackgroundColor3 = C.GOLD3
Instance.new("UICorner", _logo).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", _logo).Color = C.GOLD
local _logoL = Instance.new("TextLabel", _logo)
_logoL.Size = UDim2.new(1,0,1,0) ; _logoL.BackgroundTransparency = 1
_logoL.Text = "K" ; _logoL.Font = Enum.Font.GothamBlack
_logoL.TextSize = 17 ; _logoL.TextColor3 = C.GOLD

-- عنوان
local _titleL = Instance.new("TextLabel", topBar)
_titleL.Position = UDim2.new(0,50,0,4)
_titleL.Size = UDim2.new(0,280,0,22)
_titleL.BackgroundTransparency = 1
_titleL.Text = "كن هاب  ×  AXL PREMIUM"
_titleL.Font = Enum.Font.GothamBlack
_titleL.TextSize = 15
_titleL.TextColor3 = C.GOLD
_titleL.TextXAlignment = Enum.TextXAlignment.Left

local _subL = Instance.new("TextLabel", topBar)
_subL.Position = UDim2.new(0,50,0,26)
_subL.Size = UDim2.new(0,260,0,14)
_subL.BackgroundTransparency = 1
_subL.Text = "v1.67  |  الكل مدمج بالعربي"
_subL.Font = Enum.Font.Gotham
_subL.TextSize = 10
_subL.TextColor3 = C.GOLD2
_subL.TextXAlignment = Enum.TextXAlignment.Left

-- helper: زر في TopBar
local function mkTopBtn(sym, xOff, bgCol)
    local b = Instance.new("TextButton", topBar)
    b.Size = UDim2.new(0,30,0,30)
    b.Position = UDim2.new(1, xOff, 0.5,-15)
    b.BackgroundColor3 = bgCol or C.ROW
    b.Text = sym ; b.TextColor3 = C.WHITE
    b.Font = Enum.Font.GothamBold ; b.TextSize = 18
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", b).Color = C.STROKE
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.1),{BackgroundColor3=C.HBTN}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.1),{BackgroundColor3=bgCol or C.ROW}):Play() end)
    return b
end
local closeBtn    = mkTopBtn("×", -38, Color3.fromRGB(150,25,25))
local minimizeBtn = mkTopBtn("−", -76)
local settingsBtn = mkTopBtn("⚙", -114)

-- وظيفة الإغلاق
local isMinimized = false
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame,TweenInfo.new(.2),{Size=UDim2.new(0,0,0,0)}):Play()
    task.wait(.22) ; screenGui:Destroy()
end)
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(mainFrame,TweenInfo.new(.2),{Size=UDim2.new(0,630,0,46)}):Play()
    else
        TweenService:Create(mainFrame,TweenInfo.new(.2),{Size=UDim2.new(0,630,0,410)}):Play()
    end
end)

------------ الشريط الجانبي (Sidebar) -----------------------
local SIDEBAR_W = 132
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0,SIDEBAR_W,1,-46)
sidebar.Position = UDim2.new(0,0,0,46)
sidebar.BackgroundColor3 = C.SIDEBAR
sidebar.BorderSizePixel = 0
local _sbLine = Instance.new("Frame", sidebar)
_sbLine.Size = UDim2.new(0,1,1,0)
_sbLine.Position = UDim2.new(1,-1,0,0)
_sbLine.BackgroundColor3 = C.GOLD2
_sbLine.BackgroundTransparency = 0.45
_sbLine.BorderSizePixel = 0
local _sbLayout = Instance.new("UIListLayout", sidebar)
_sbLayout.Padding = UDim.new(0,4)
_sbLayout.FillDirection = Enum.FillDirection.Vertical
_sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
_sbLayout.SortOrder = Enum.SortOrder.LayoutOrder
local _sbPad = Instance.new("UIPadding", sidebar)
_sbPad.PaddingTop = UDim.new(0,8)

------------ منطقة المحتوى ----------------------------------
local contentArea = Instance.new("Frame", mainFrame)
contentArea.Size = UDim2.new(1,-SIDEBAR_W,1,-46)
contentArea.Position = UDim2.new(0,SIDEBAR_W,0,46)
contentArea.BackgroundTransparency = 1

------------ نافذة الإعدادات --------------------------------
local settingsFrame = Instance.new("Frame", screenGui)
settingsFrame.Size = UDim2.new(0,430,0,360)
settingsFrame.Position = UDim2.new(0.5,-215,0.5,-180)
settingsFrame.BackgroundColor3 = C.BG
settingsFrame.Active = true
settingsFrame.Draggable = true
settingsFrame.ClipsDescendants = true
settingsFrame.Visible = false
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0,14)
local _sfStroke = Instance.new("UIStroke", settingsFrame)
_sfStroke.Thickness = 1.5 ; _sfStroke.Color = C.GOLD2

local _sfTop = Instance.new("Frame", settingsFrame)
_sfTop.Size = UDim2.new(1,0,0,44)
_sfTop.BackgroundColor3 = C.SIDEBAR
_sfTop.BorderSizePixel = 0
Instance.new("UICorner", _sfTop).CornerRadius = UDim.new(0,14)
local _sfTitle = Instance.new("TextLabel", _sfTop)
_sfTitle.Size = UDim2.new(1,-50,1,0) ; _sfTitle.Position = UDim2.new(0,14,0,0)
_sfTitle.BackgroundTransparency = 1 ; _sfTitle.Text = "⚙  الإعدادات"
_sfTitle.Font = Enum.Font.GothamBold ; _sfTitle.TextSize = 15
_sfTitle.TextColor3 = C.GOLD ; _sfTitle.TextXAlignment = Enum.TextXAlignment.Left
local _sfClose = Instance.new("TextButton", _sfTop)
_sfClose.Size = UDim2.new(0,28,0,28) ; _sfClose.Position = UDim2.new(1,-36,0.5,-14)
_sfClose.BackgroundColor3 = Color3.fromRGB(140,22,22)
_sfClose.Text = "×" ; _sfClose.TextColor3 = C.WHITE
_sfClose.Font = Enum.Font.GothamBold ; _sfClose.TextSize = 16 ; _sfClose.AutoButtonColor = false
Instance.new("UICorner", _sfClose).CornerRadius = UDim.new(0,8)
_sfClose.MouseButton1Click:Connect(function() settingsFrame.Visible = false end)
settingsBtn.MouseButton1Click:Connect(function() settingsFrame.Visible = not settingsFrame.Visible end)

local settingsContent = Instance.new("ScrollingFrame", settingsFrame)
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1,-14,1,-48)
settingsContent.Position = UDim2.new(0,7,0,48)
settingsContent.BackgroundTransparency = 1
settingsContent.CanvasSize = UDim2.new(0,0,0,0)
settingsContent.ScrollBarThickness = 3
settingsContent.ScrollBarImageColor3 = C.GOLD2
local _scLayout = Instance.new("UIListLayout", settingsContent)
_scLayout.Padding = UDim.new(0,7)
_scLayout.FillDirection = Enum.FillDirection.Vertical
_scLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
_scLayout.SortOrder = Enum.SortOrder.LayoutOrder
_scLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    pcall(function() settingsContent.CanvasSize = UDim2.new(0,0,0,_scLayout.AbsoluteContentSize.Y+10) end)
end)

------------ مساعدات الـ UI ----------------------------------
local sections     = {}
local activeSection = nil

-- إنشاء قسم (ScrollingFrame)
local function createSection(name)
    local sf = Instance.new("ScrollingFrame", contentArea)
    sf.Name = name ; sf.BackgroundTransparency = 1
    sf.Size = UDim2.new(1,-12,1,0)
    sf.Position = UDim2.new(0,6,0,0)
    sf.CanvasSize = UDim2.new(0,0,0,0)
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.GOLD2
    sf.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    sf.Visible = false
    local ll = Instance.new("UIListLayout", sf)
    ll.Padding = UDim.new(0,6)
    ll.FillDirection = Enum.FillDirection.Vertical
    ll.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pcall(function() sf.CanvasSize = UDim2.new(0,0,0,ll.AbsoluteContentSize.Y+10) end)
    end)
    sections[name] = sf
    return sf
end

-- إنشاء زر تاب
local tabActivators = {}
local function createTabButton(labelAR, sectionName, icon)
    local btn = Instance.new("TextButton", sidebar)
    btn.Name = sectionName.."TabBtn"
    btn.Size = UDim2.new(1,-10,0,36)
    btn.BackgroundColor3 = C.SIDEBAR
    btn.Text = "" ; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,9)

    local _bar = Instance.new("Frame", btn)
    _bar.Size = UDim2.new(0,3,0.65,0)
    _bar.Position = UDim2.new(0,0,0.175,0)
    _bar.BackgroundColor3 = C.GOLD
    _bar.Visible = false
    Instance.new("UICorner", _bar).CornerRadius = UDim.new(1,0)

    local _ico = Instance.new("TextLabel", btn)
    _ico.Size = UDim2.new(0,22,1,0) ; _ico.Position = UDim2.new(0,8,0,0)
    _ico.BackgroundTransparency = 1 ; _ico.Text = icon or "•"
    _ico.Font = Enum.Font.GothamBold ; _ico.TextSize = 13 ; _ico.TextColor3 = C.GOLD2

    local _lbl = Instance.new("TextLabel", btn)
    _lbl.Size = UDim2.new(1,-34,1,0) ; _lbl.Position = UDim2.new(0,32,0,0)
    _lbl.BackgroundTransparency = 1 ; _lbl.Text = labelAR
    _lbl.Font = Enum.Font.GothamBold ; _lbl.TextSize = 12
    _lbl.TextColor3 = C.SUB ; _lbl.TextXAlignment = Enum.TextXAlignment.Left

    local function activate()
        -- إلغاء تفعيل الزر القديم
        if activeSection then
            local prev = sidebar:FindFirstChild(activeSection.."TabBtn")
            if prev then
                TweenService:Create(prev,TweenInfo.new(.15),{BackgroundColor3=C.SIDEBAR}):Play()
                local pb = prev:FindFirstChild("Frame")
                if pb then pb.Visible = false end
                for _,c in ipairs(prev:GetChildren()) do
                    if c:IsA("TextLabel") then c.TextColor3 = C.SUB end
                end
            end
            sections[activeSection].Visible = false
        end
        -- تفعيل الجديد
        TweenService:Create(btn,TweenInfo.new(.15),{BackgroundColor3=C.HBTN}):Play()
        _bar.Visible = true
        _ico.TextColor3 = C.GOLD ; _lbl.TextColor3 = C.GOLD
        sections[sectionName].Visible = true
        activeSection = sectionName
    end
    btn.MouseButton1Click:Connect(activate)
    btn.TouchTap:Connect(activate)
    tabActivators[sectionName] = activate
    return btn, activate
end

-- رأس قسم
local function createSectionHeader(parent, titleText)
    pcall(function()
        local h = Instance.new("Frame", parent)
        h.Size = UDim2.new(1,0,0,28)
        h.BackgroundColor3 = C.GOLD3
        Instance.new("UICorner", h).CornerRadius = UDim.new(0,8)
        Instance.new("UIStroke", h).Color = Color3.fromRGB(70,50,5)
        local _ac = Instance.new("Frame", h)
        _ac.Size = UDim2.new(0,3,0.6,0) ; _ac.Position = UDim2.new(0,7,0.2,0)
        _ac.BackgroundColor3 = C.GOLD
        Instance.new("UICorner", _ac).CornerRadius = UDim.new(1,0)
        local _hl = Instance.new("TextLabel", h)
        _hl.BackgroundTransparency = 1 ; _hl.Text = titleText
        _hl.Font = Enum.Font.GothamBold ; _hl.TextSize = 13
        _hl.TextColor3 = C.GOLD ; _hl.TextXAlignment = Enum.TextXAlignment.Left
        _hl.Position = UDim2.new(0,17,0,0) ; _hl.Size = UDim2.new(1,-22,1,0)
    end)
end

-- مفتاح toggle
local function createSwitch(parent, labelText, defaultState, callback)
    local sd = {state = defaultState or false}
    pcall(function()
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,44)
        row.BackgroundColor3 = C.ROW
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
        local rs = Instance.new("UIStroke", row)
        rs.Color = C.STROKE ; rs.Thickness = 1 ; rs.Transparency = 0.2
        sd.row = row

        local lbl = Instance.new("TextLabel", row)
        lbl.BackgroundTransparency = 1 ; lbl.Text = labelText
        lbl.Font = Enum.Font.GothamMedium ; lbl.TextSize = 13
        lbl.TextColor3 = C.WHITE ; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Position = UDim2.new(0,12,0,0) ; lbl.Size = UDim2.new(1,-78,1,0)

        local swBG = Instance.new("Frame", row)
        swBG.Size = UDim2.new(0,48,0,24)
        swBG.Position = UDim2.new(1,-58,0.5,-12)
        swBG.BackgroundColor3 = defaultState and C.SWON or C.SWOFF
        Instance.new("UICorner", swBG).CornerRadius = UDim.new(0,12)
        sd.swBG = swBG

        local knob = Instance.new("Frame", swBG)
        knob.Size = UDim2.new(0,18,0,18)
        knob.Position = defaultState and UDim2.new(1,-21,0,3) or UDim2.new(0,3,0,3)
        knob.BackgroundColor3 = C.WHITE
        Instance.new("UICorner", knob).CornerRadius = UDim.new(0,9)
        sd.knob = knob

        local hit = Instance.new("TextButton", row)
        hit.Size = UDim2.new(1,0,1,0) ; hit.BackgroundTransparency = 1 ; hit.Text = ""

        sd.setState = function(ns)
            sd.state = ns
            TweenService:Create(swBG,TweenInfo.new(.15),{BackgroundColor3 = ns and C.SWON or C.SWOFF}):Play()
            TweenService:Create(knob,TweenInfo.new(.15),{Position = ns and UDim2.new(1,-21,0,3) or UDim2.new(0,3,0,3)}):Play()
            if ns then
                TweenService:Create(rs,TweenInfo.new(.15),{Color=C.GOLD2,Transparency=0}):Play()
            else
                TweenService:Create(rs,TweenInfo.new(.15),{Color=C.STROKE,Transparency=0.2}):Play()
            end
            if callback then task.spawn(callback, ns) end
        end

        local function doToggle() sd.setState(not sd.state) end
        hit.MouseButton1Click:Connect(doToggle)
        hit.TouchTap:Connect(doToggle)
    end)
    return {row=sd.row, set=sd.setState, get=function() return sd.state end}
end

-- زر عادي
local function createButton(parent, labelText, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,42) ; btn.BackgroundColor3 = C.ROW
    btn.Text = labelText ; btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13 ; btn.TextColor3 = C.WHITE ; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    local bs = Instance.new("UIStroke", btn)
    bs.Color = C.STROKE ; bs.Thickness = 1 ; bs.Transparency = 0.2
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(.1),{BackgroundColor3=C.HBTN}):Play()
        bs.Color = C.GOLD2
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(.1),{BackgroundColor3=C.ROW}):Play()
        bs.Color = C.STROKE
    end)
    btn.MouseButton1Click:Connect(function() if callback then pcall(callback) end end)
    btn.TouchTap:Connect(function() if callback then pcall(callback) end end)
    return btn
end

-- حقل رقمي
local function createNumberInput(parent, labelText, defaultValue, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,44) ; row.BackgroundColor3 = C.ROW
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
    Instance.new("UIStroke", row).Color = C.STROKE
    local lbl = Instance.new("TextLabel", row)
    lbl.BackgroundTransparency = 1 ; lbl.Text = labelText
    lbl.Font = Enum.Font.GothamMedium ; lbl.TextSize = 13 ; lbl.TextColor3 = C.WHITE
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Position = UDim2.new(0,12,0,0) ; lbl.Size = UDim2.new(1,-90,1,0)
    local tb = Instance.new("TextBox", row)
    tb.Size = UDim2.new(0,68,0,28) ; tb.Position = UDim2.new(1,-76,0.5,-14)
    tb.BackgroundColor3 = C.SIDEBAR ; tb.Text = tostring(defaultValue)
    tb.Font = Enum.Font.GothamBold ; tb.TextSize = 13 ; tb.TextColor3 = C.GOLD
    tb.TextXAlignment = Enum.TextXAlignment.Center
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,7)
    local tbs = Instance.new("UIStroke", tb) ; tbs.Color = C.GOLD2 ; tbs.Thickness = 1
    tb.FocusLost:Connect(function()
        local n = tonumber(tb.Text)
        if n then if callback then pcall(callback,n) end
        else tb.Text = tostring(defaultValue) end
    end)
    return {row=row, get=function() return tonumber(tb.Text) or defaultValue end}
end

-- ══════════════════════════════════════════
-- Circular (Float) Toggle System
-- ══════════════════════════════════════════
_G.circularToggleGui = circularGui

_G.createCircularToggleUI = function(toggleName, getState, setState)
    local existing = circularGui:FindFirstChild(toggleName.."ToggleUI")
    if existing then existing:Destroy() end

    local td = {frame=Instance.new("TextButton"), dragging=false}
    td.frame.Name = toggleName.."ToggleUI"
    td.frame.Size = UDim2.new(0,210,0,62)
    local sPos = _G.OpenCircularToggles[toggleName]
    if not sPos then
        local cnt = 0
        for _ in pairs(_G.OpenCircularToggles) do cnt=cnt+1 end
        sPos = UDim2.new(1,-220,0,10+cnt*72)
    end
    td.frame.Position = sPos
    td.frame.BackgroundColor3 = C.PANEL
    td.frame.Text = "" ; td.frame.AutoButtonColor = false
    td.frame.Parent = circularGui
    Instance.new("UICorner", td.frame).CornerRadius = UDim.new(0,12)
    local fStroke = Instance.new("UIStroke", td.frame)
    fStroke.Thickness = 1.5 ; fStroke.Color = C.GOLD2 ; fStroke.Transparency = 0.3

    local dragHit = Instance.new("TextButton", td.frame)
    dragHit.Size = UDim2.new(1,-64,1,0) ; dragHit.BackgroundTransparency = 1 ; dragHit.Text = ""

    local closeB = Instance.new("TextButton", td.frame)
    closeB.Size = UDim2.new(0,26,0,26) ; closeB.Position = UDim2.new(1,-30,0,6)
    closeB.BackgroundColor3 = Color3.fromRGB(130,22,22) ; closeB.Text = "×"
    closeB.TextColor3 = C.WHITE ; closeB.Font = Enum.Font.GothamBold ; closeB.TextSize = 14
    closeB.AutoButtonColor = false ; closeB.ZIndex = 10
    Instance.new("UICorner", closeB).CornerRadius = UDim.new(1,0)

    local titleL = Instance.new("TextLabel", td.frame)
    titleL.Size = UDim2.new(1,-140,0,24) ; titleL.Position = UDim2.new(0,10,0,8)
    titleL.BackgroundTransparency = 1 ; titleL.Text = toggleName
    titleL.TextColor3 = C.GOLD ; titleL.Font = Enum.Font.GothamBold ; titleL.TextSize = 13
    titleL.TextXAlignment = Enum.TextXAlignment.Left

    local swBG = Instance.new("Frame", td.frame)
    swBG.Size = UDim2.new(0,50,0,26) ; swBG.Position = UDim2.new(0,100,0.5,-13)
    swBG.BackgroundColor3 = getState() and C.SWON or C.SWOFF
    Instance.new("UICorner", swBG).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", swBG)
    knob.Size = UDim2.new(0,20,0,20) ; knob.Position = getState() and UDim2.new(1,-23,0,3) or UDim2.new(0,3,0,3)
    knob.BackgroundColor3 = C.WHITE
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local function updSW()
        local on = getState()
        TweenService:Create(swBG,TweenInfo.new(.15),{BackgroundColor3=on and C.SWON or C.SWOFF}):Play()
        TweenService:Create(knob,TweenInfo.new(.15),{Position=on and UDim2.new(1,-23,0,3) or UDim2.new(0,3,0,3)}):Play()
    end
    local swHit = Instance.new("TextButton", swBG)
    swHit.Size=UDim2.new(1,0,1,0) ; swHit.BackgroundTransparency=1 ; swHit.Text=""
    swHit.MouseButton1Click:Connect(function() setState(not getState()); updSW() end)
    swHit.TouchTap:Connect(function() setState(not getState()); updSW() end)

    local function doClose()
        _G.OpenCircularToggles[toggleName] = nil
        _G.saveSettings() ; td.frame:Destroy()
    end
    closeB.MouseButton1Click:Connect(doClose)
    closeB.TouchTap:Connect(doClose)

    local dStart, dPos0
    dragHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            td.dragging=true ; dStart=i.Position ; dPos0=td.frame.Position ; fStroke.Transparency=0
        end
    end)
    dragHit.InputChanged:Connect(function(i)
        if td.dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-dStart
            td.frame.Position=UDim2.new(dPos0.X.Scale,dPos0.X.Offset+d.X,dPos0.Y.Scale,dPos0.Y.Offset+d.Y)
        end
    end)
    dragHit.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            td.dragging=false ; fStroke.Transparency=0.3
            _G.OpenCircularToggles[toggleName]=td.frame.Position ; _G.saveSettings()
        end
    end)
    if not _G.OpenCircularToggles[toggleName] then
        _G.OpenCircularToggles[toggleName]=td.frame.Position ; _G.saveSettings()
    end
    return td.frame
end

-- ══════════════════════════════════════════
-- إنشاء الأقسام والتابات
-- ══════════════════════════════════════════
_G.homeSection      = createSection("الرئيسية")
_G.movementSection  = createSection("الحركة")
_G.visualSection    = createSection("المرئيات")
_G.serverSection    = createSection("السيرفر")
_G.patchedSection   = createSection("المُصلَح")
_G.desyncSection    = createSection("ديسينك")
_G.axlSection       = createSection("AXL")

local _, activateHome = createTabButton("🏠 الرئيسية",  "الرئيسية",  "🏠")
createTabButton("🏃 الحركة",    "الحركة",    "🏃")
createTabButton("👁 المرئيات",  "المرئيات",  "👁")
createTabButton("🔧 المُصلَح",  "المُصلَح",  "🔧")
createTabButton("🌐 السيرفر",   "السيرفر",   "🌐")
createTabButton("⚡ ديسينك",    "ديسينك",    "⚡")
createTabButton("⭐ AXL",       "AXL",       "⭐")

local function getBackpackItems(plr)
    local success, items = pcall(function()
        local result = {}
        if plr.Backpack then
            for _, item in ipairs(plr.Backpack:GetChildren()) do
                if item:IsA("Tool") or item:IsA("HopperBin") then
                    table.insert(result, item)
                end
            end
        end
        if plr.Character then
            for _, item in ipairs(plr.Character:GetChildren()) do
                if item:IsA("Tool") or item:IsA("HopperBin") then
                    table.insert(result, item)
                end
            end
        end
        local inventoryFolder = plr:FindFirstChild("Inventory") or (plr.Character and plr.Character:FindFirstChild("Inventory"))
        if inventoryFolder then
            for _, item in ipairs(inventoryFolder:GetChildren()) do
                if item:IsA("Instance") then
                    table.insert(result, item)
                end
            end
        end
        return result
    end)
    if not success then
        warn("Failed to get backpack items for player: " .. plr.Name)
        return {}
    end
    return items
end

local function createBillboardGui(plr, char)
    local success, billboard, distanceLabel, iconFrame = pcall(function()
        local gui = Instance.new("BillboardGui")
        gui.Name = "ESP_Billboard"
        gui.Adornee = char:FindFirstChild("HumanoidRootPart")
        gui.Size = UDim2.new(0, 200, 0, CONFIG.ESP.PlayerESP.ShowDistance and CONFIG.ESP.PlayerESP.ShowItems and 80 or (CONFIG.ESP.PlayerESP.ShowDistance and 50 or 30))
        gui.SizeOffset = Vector2.new(0, 0)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.AlwaysOnTop = true
        gui.MaxDistance = 10000
        gui.Parent = char

        -- Main container with rounded corners and background
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(1, 0, 1, 0)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BackgroundTransparency = 0.1
        mainFrame.BorderSizePixel = 0
        mainFrame.Parent = gui
        
        -- Rounded corners
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = mainFrame
        
        -- Subtle border
        local border = Instance.new("UIStroke")
        border.Color = Color3.fromRGB(100, 100, 100)
        border.Thickness = 1
        border.Transparency = 0.3
        border.Parent = mainFrame

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -8, 1, -8)
        frame.Position = UDim2.new(0, 4, 0, 4)
        frame.BackgroundTransparency = 1
        frame.Parent = mainFrame

        -- Username with better styling
        local usernameLabel = Instance.new("TextLabel")
        usernameLabel.Size = UDim2.new(1, 0, CONFIG.ESP.PlayerESP.ShowDistance and 0.4 or 1, 0)
        usernameLabel.Position = UDim2.new(0, 0, 0, 0)
        usernameLabel.Text = plr.Name
        usernameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        usernameLabel.BackgroundTransparency = 1
        usernameLabel.TextScaled = true
        usernameLabel.TextSize = CONFIG.ESP.PlayerESP.TextSize
        usernameLabel.Font = Enum.Font.GothamBold
        usernameLabel.TextStrokeTransparency = 0.8
        usernameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        usernameLabel.Parent = frame

        local distLabel
        if CONFIG.ESP.PlayerESP.ShowDistance then
            distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.3, 0)
            distLabel.Position = UDim2.new(0, 0, 0.4, 0)
            distLabel.Text = "Distance: Calculating..."
            distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            distLabel.BackgroundTransparency = 1
            distLabel.TextScaled = true
            distLabel.TextSize = CONFIG.ESP.PlayerESP.DistanceTextSize
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextStrokeTransparency = 0.8
            distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            distLabel.Parent = frame
        end

        local iconFrame = Instance.new("Frame")
        iconFrame.Size = UDim2.new(1, 0, 0.3, 0)
        iconFrame.Position = UDim2.new(0, 0, CONFIG.ESP.PlayerESP.ShowDistance and 0.7 or 0.4, 0)
        iconFrame.BackgroundTransparency = 1
        iconFrame.Visible = CONFIG.ESP.PlayerESP.ShowItems
        iconFrame.Parent = frame

        local uiLayout = Instance.new("UIGridLayout")
        uiLayout.CellSize = UDim2.new(0, 24, 0, 24)
        uiLayout.CellPadding = UDim2.new(0, 3, 0, 3)
        uiLayout.FillDirection = Enum.FillDirection.Horizontal
        uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        uiLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiLayout.Parent = iconFrame

        return gui, distLabel, iconFrame
    end)
    if not success then
        warn("Failed to create billboard GUI for player: " .. plr.Name)
        return nil, nil, nil
    end
    return billboard, distanceLabel, iconFrame
end

local function updateBillboard(plr, data)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not data.billboard or not data.billboard.Adornee then
        return
    end
    local success, _ = pcall(function()
        local localPlayer = Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        local localRoot = localPlayer.Character.HumanoidRootPart
        local targetRoot = data.billboard.Adornee
        if CONFIG.ESP.PlayerESP.ShowDistance and data.distanceLabel then
            local distance = (localRoot.Position - targetRoot.Position).Magnitude
            data.distanceLabel.Text = string.format("📏 %.1f studs", distance)
        end

        if CONFIG.ESP.PlayerESP.ShowItems and data.iconFrame then
            data.iconFrame:ClearAllChildren()
            local uiLayout = Instance.new("UIGridLayout")
            uiLayout.CellSize = UDim2.new(0, 24, 0, 24)
            uiLayout.CellPadding = UDim2.new(0, 3, 0, 3)
            uiLayout.FillDirection = Enum.FillDirection.Horizontal
            uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            uiLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
            uiLayout.Parent = data.iconFrame

            local items = getBackpackItems(plr)
            for _, tool in ipairs(items) do
                local icon = Instance.new("ImageLabel")
                icon.Size = UDim2.new(0, 24, 0, 24)
                icon.BackgroundTransparency = 1
                icon.BorderSizePixel = 0
                local textureId = tool.TextureId
                if textureId == "" then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then
                        local decal = handle:FindFirstChildOfClass("Decal")
                        local mesh = handle:FindFirstChildOfClass("MeshPart") or handle:FindFirstChildOfClass("SpecialMesh")
                        textureId = (decal and decal.Texture) or (mesh and mesh.TextureId) or "rbxasset://textures/ui/GuiImagePlaceholder.png"
                    else
                        textureId = "rbxasset://textures/ui/GuiImagePlaceholder.png"
                    end
                end
                icon.Image = textureId
                icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                icon.Parent = data.iconFrame
                
                -- Rounded corners for icons
                local iconCorner = Instance.new("UICorner")
                iconCorner.CornerRadius = UDim.new(0, 4)
                iconCorner.Parent = icon
                
                local iconStroke = Instance.new("UIStroke", icon)
                iconStroke.Thickness = 0.5
                iconStroke.Color = Color3.fromRGB(0, 0, 0)
                iconStroke.Transparency = 0.3

                local tooltip = Instance.new("TextLabel")
                tooltip.Size = UDim2.new(0, 100, 0, 20)
                tooltip.Position = UDim2.new(0, 0, 1, 2)
                tooltip.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                tooltip.BackgroundTransparency = 0.4
                tooltip.Text = tool.Name
                tooltip.TextColor3 = CONFIG.Colors.Text
                tooltip.TextScaled = true
                tooltip.TextSize = 12
                tooltip.Font = Enum.Font.SourceSans
                tooltip.Visible = false
                tooltip.Parent = icon
                local tooltipStroke = Instance.new("UIStroke", tooltip)
                tooltipStroke.Thickness = 0.8
                tooltipStroke.Color = CONFIG.Colors.Stroke
                icon.MouseEnter:Connect(function()
                    tooltip.Visible = true
                end)
                icon.MouseLeave:Connect(function()
                    tooltip.Visible = false
                end)
            end
        end
    end)
    if not success then
        warn("Failed to update billboard for player: " .. plr.Name)
    end
end

local function attachHighlightToCharacter(plr, char)
     if not _G.ESP_Enabled or not char then return end
    local success, _ = pcall(function()
        local oldHighlight = char:FindFirstChildOfClass("Highlight")
        if oldHighlight then oldHighlight:Destroy() end
        local oldBillboard = char:FindFirstChild("ESP_Billboard")
        if oldBillboard then oldBillboard:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = CONFIG.ESP.PlayerESP.FillTransparency
        highlight.OutlineTransparency = CONFIG.ESP.PlayerESP.OutlineTransparency
        highlight.FillColor = CONFIG.ESP.PlayerESP.HighlightColor
        highlight.OutlineColor = CONFIG.ESP.PlayerESP.HighlightColor
        highlight.Adornee = char
        highlight.Parent = char

        local billboard, distanceLabel, iconFrame = createBillboardGui(plr, char)
        if not billboard then return end

         _G.ESP_Data[plr] = _G.ESP_Data[plr] or {}
         _G.ESP_Data[plr].highlight = highlight
         _G.ESP_Data[plr].billboard = billboard
         _G.ESP_Data[plr].distanceLabel = distanceLabel
         _G.ESP_Data[plr].iconFrame = iconFrame

        local lastUpdate = 0
        _G.ESP_Data[plr].updateConn = RunService.Heartbeat:Connect(function(deltaTime)
            lastUpdate = lastUpdate + deltaTime
            if lastUpdate >= CONFIG.ESP.UpdateInterval then
                updateBillboard(plr, _G.ESP_Data[plr])
                lastUpdate = 0
            end
        end)
    end)
    if not success then
        warn("Failed to attach ESP to character: " .. plr.Name)
    end
end

local function enableESP()
     if _G.ESP_Enabled then return end
    local success, _ = pcall(function()
         _G.ESP_Enabled = true
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local charConn = plr.CharacterAdded:Connect(function(c)
                    c:WaitForChild("HumanoidRootPart", 5)
                    attachHighlightToCharacter(plr, c)
                end)
_G.ESP_Data[plr] = _G.ESP_Data[plr] or {}
_G.ESP_Data[plr].charConn = charConn
                if plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Transparency >= 1 then
                            part.LocalTransparencyModifier = 0.5
                        end
                    end
                    attachHighlightToCharacter(plr, plr.Character)
                end
            end
        end
        _G.ESP_Data.playersConn = Players.PlayerAdded:Connect(function(plr)
            if plr == player then return end
            local charConn = plr.CharacterAdded:Connect(function(c)
                c:WaitForChild("HumanoidRootPart", 5)
                attachHighlightToCharacter(plr, c)
            end)
            -- Refresh plot time ESP when players join
            pcall(function()
                if refreshPlotTimeESP then
            refreshPlotTimeESP()
                end
            end)
_G.ESP_Data[plr] = _G.ESP_Data[plr] or {}
_G.ESP_Data[plr].charConn = charConn
            if plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Transparency >= 1 then
                        part.LocalTransparencyModifier = 0.5
                    end
                end
                attachHighlightToCharacter(plr, plr.Character)
            end
        end)
        _G.ESP_Data.leaveConn = Players.PlayerRemoving:Connect(function(plr)
            if _G.ESP_Data[plr] then
                if _G.ESP_Data[plr].charConn then pcall(function() _G.ESP_Data[plr].charConn:Disconnect() end) end
                if _G.ESP_Data[plr].highlight then pcall(function() _G.ESP_Data[plr].highlight:Destroy() end) end
                if _G.ESP_Data[plr].billboard then pcall(function() _G.ESP_Data[plr].billboard:Destroy() end) end
                if _G.ESP_Data[plr].updateConn then pcall(function() _G.ESP_Data[plr].updateConn:Disconnect() end) end
                if plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                        end
                    end
                end
                _G.ESP_Data[plr] = nil
            end
            -- Refresh plot time ESP when players leave
            refreshPlotTimeESP()
        end)
    end)
    if not success then
        warn("Failed to enable ESP")
        _G.ESP_Enabled = false
    end
end

local function disableESP()
    if not _G.ESP_Enabled then return end
    local success, _ = pcall(function()
        _G.ESP_Enabled = false
        if _G.ESP_Data.playersConn then
            pcall(function() _G.ESP_Data.playersConn:Disconnect() end)
            _G.ESP_Data.playersConn = nil
        end
        if _G.ESP_Data.leaveConn then
            pcall(function() _G.ESP_Data.leaveConn:Disconnect() end)
            _G.ESP_Data.leaveConn = nil
        end
        for plr, data in pairs(ESP_Data) do
            if typeof(plr) == "Instance" then
                if data.charConn then pcall(function() data.charConn:Disconnect() end) end
                if data.highlight then pcall(function() data.highlight:Destroy() end) end
                if data.billboard then pcall(function() data.billboard:Destroy() end) end
                if data.updateConn then pcall(function() data.updateConn:Disconnect() end) end
                if plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.LocalTransparencyModifier = 0
                        end
                    end
                end
                _G.ESP_Data[plr] = nil
            end
        end
    end)
    if not success then
        warn("Failed to disable ESP")
    end
end

--=========================================================
-- Plot ESP System
--=========================================================
_G.PlotESP_Enabled = false
_G.PlotESP_Data = {}

local function createPlotBillboardGui(plot)
    local success, billboard, distanceLabel, ownerLabel, timeLabel = pcall(function()
        local spawnPart = plot:FindFirstChild("Spawn")
        if not spawnPart or not spawnPart:IsA("BasePart") then return nil, nil, nil, nil end

        local height = 30
        if CONFIG.ESP.PlotESP.ShowDistance then height = height + 20 end
        if CONFIG.ESP.PlotESP.ShowOwner then height = height + 30 end
        if CONFIG.ESP.PlotESP.ShowTime then height = height + 20 end

        local gui = Instance.new("BillboardGui")
        gui.Name = "PlotESP_Billboard"
        gui.Adornee = spawnPart
        gui.Size = UDim2.new(0, 200, 0, height)
        gui.SizeOffset = Vector2.new(0, 0)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.AlwaysOnTop = true
        gui.MaxDistance = 10000
        gui.Parent = spawnPart

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = gui

        local yOffset = 0
        local ownerLabel
        if CONFIG.ESP.PlotESP.ShowOwner then
            ownerLabel = Instance.new("TextLabel")
            ownerLabel.Size = UDim2.new(1, 0, 0.4, 0)
            ownerLabel.Position = UDim2.new(0, 0, 0, yOffset)
            ownerLabel.Text = "Owner: Loading..."
            ownerLabel.TextColor3 = CONFIG.Colors.Text
            ownerLabel.BackgroundTransparency = 1
            ownerLabel.TextScaled = true
            ownerLabel.TextSize = CONFIG.ESP.PlotESP.OwnerTextSize
            ownerLabel.Font = Enum.Font.SourceSansBold
            ownerLabel.Parent = frame
            local ownerStroke = Instance.new("UIStroke", ownerLabel)
            ownerStroke.Thickness = 0.5
            ownerStroke.Color = Color3.fromRGB(0, 0, 0)
            ownerStroke.Transparency = 0.4
            yOffset = yOffset + 0.4
        end

        local timeLabel
        if CONFIG.ESP.PlotESP.ShowTime then
            timeLabel = Instance.new("TextLabel")
            timeLabel.Size = UDim2.new(1, 0, 0.3, 0)
            timeLabel.Position = UDim2.new(0, 0, yOffset, 0)
            timeLabel.Text = "Time: Loading..."
            timeLabel.TextColor3 = CONFIG.Colors.SubText
            timeLabel.BackgroundTransparency = 1
            timeLabel.TextScaled = true
            timeLabel.TextSize = CONFIG.ESP.PlotESP.TimeTextSize
            timeLabel.Font = Enum.Font.SourceSans
            timeLabel.Parent = frame
            local timeStroke = Instance.new("UIStroke", timeLabel)
            timeStroke.Thickness = 0.5
            timeStroke.Color = Color3.fromRGB(0, 0, 0)
            timeStroke.Transparency = 0.4
            yOffset = yOffset + 0.3
        end

        local distLabel
        if CONFIG.ESP.PlotESP.ShowDistance then
            distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.3, 0)
            distLabel.Position = UDim2.new(0, 0, yOffset, 0)
            distLabel.Text = "Distance: Calculating..."
            distLabel.TextColor3 = CONFIG.Colors.Text
            distLabel.BackgroundTransparency = 1
            distLabel.TextScaled = true
            distLabel.TextSize = 14
            distLabel.Font = Enum.Font.SourceSans
            distLabel.Parent = frame
            local distStroke = Instance.new("UIStroke", distLabel)
            distStroke.Thickness = 0.5
            distStroke.Color = Color3.fromRGB(0, 0, 0)
            distStroke.Transparency = 0.4
        end

        return gui, distLabel, ownerLabel, timeLabel
    end)
    if not success then
        warn("Failed to create billboard GUI for plot: " .. plot.Name)
        return nil, nil, nil, nil
    end
    return billboard, distanceLabel, ownerLabel, timeLabel
end

local function updatePlotBillboard(plot, data)
    if not data.billboard or not data.billboard.Adornee then
        return
    end
    local success, _ = pcall(function()
        local localPlayer = Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        local localRoot = localPlayer.Character.HumanoidRootPart
        local targetPart = data.billboard.Adornee
        if CONFIG.ESP.PlotESP.ShowDistance and data.distanceLabel then
            local distance = (localRoot.Position - targetPart.Position).Magnitude
            data.distanceLabel.Text = string.format("Distance: %.1f studs", distance)
        end

        if CONFIG.ESP.PlotESP.ShowOwner and data.ownerLabel then
            local owner = getPlotOwner(plot)
            data.ownerLabel.Text = owner and ("Owner: " .. owner) or "Owner: Unknown"
        end

        if CONFIG.ESP.PlotESP.ShowTime and data.timeLabel then
            local remainingTime = getRemainingTime(plot)
            data.timeLabel.Text = remainingTime and ("Time: " .. remainingTime) or "Time: N/A"
        end
    end)
    if not success then
        warn("Failed to update plot billboard for plot: " .. plot.Name)
    end
end

local function attachHighlightToPlot(plot)
    if not _G.PlotESP_Enabled or not plot then return end
    local success, _ = pcall(function()
        local oldHighlight = plot:FindFirstChildOfClass("Highlight")
        if oldHighlight then oldHighlight:Destroy() end
        local oldBillboard = plot:FindFirstChild("PlotESP_Billboard", true)
        if oldBillboard then oldBillboard:Destroy() end

        local highlight = Instance.new("Highlight")
        highlight.FillTransparency = CONFIG.ESP.PlotESP.FillTransparency
        highlight.OutlineTransparency = CONFIG.ESP.PlotESP.OutlineTransparency
        highlight.OutlineColor = CONFIG.ESP.PlotESP.HighlightColor
        highlight.Adornee = plot
        highlight.Parent = plot

        local billboard, distanceLabel, ownerLabel, timeLabel = createPlotBillboardGui(plot)
        if not billboard then return end

        _G.PlotESP_Data[plot] = _G.PlotESP_Data[plot] or {}
        _G.PlotESP_Data[plot].highlight = highlight
        _G.PlotESP_Data[plot].billboard = billboard
        _G.PlotESP_Data[plot].distanceLabel = distanceLabel
        _G.PlotESP_Data[plot].ownerLabel = ownerLabel
        _G.PlotESP_Data[plot].timeLabel = timeLabel

        local lastUpdate = 0
        _G.PlotESP_Data[plot].updateConn = RunService.Heartbeat:Connect(function(deltaTime)
            lastUpdate = lastUpdate + deltaTime
            if lastUpdate >= CONFIG.ESP.UpdateInterval then
                updatePlotBillboard(plot, _G.PlotESP_Data[plot])
                lastUpdate = 0
            end
        end)
    end)
    if not success then
        warn("Failed to attach ESP to plot: " .. plot.Name)
    end
end

local function enablePlotESP()
    if _G.PlotESP_Enabled then return end
    local success, _ = pcall(function()
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder then return end

        _G.PlotESP_Enabled = true
        for _, plot in ipairs(plotsFolder:GetChildren()) do
            if plot:IsA("Model") then
                local plotConn = plot.AncestryChanged:Connect(function()
                    if not plot.Parent then
                        if _G.PlotESP_Data[plot] then
                            if _G.PlotESP_Data[plot].updateConn then pcall(function() _G.PlotESP_Data[plot].updateConn:Disconnect() end) end
                            if _G.PlotESP_Data[plot].highlight then pcall(function() _G.PlotESP_Data[plot].highlight:Destroy() end) end
                            if _G.PlotESP_Data[plot].billboard then pcall(function() _G.PlotESP_Data[plot].billboard:Destroy() end) end
                            _G.PlotESP_Data[plot] = nil
                        end
                    end
                end)
                _G.PlotESP_Data[plot] = _G.PlotESP_Data[plot] or {}
                _G.PlotESP_Data[plot].plotConn = plotConn
                attachHighlightToPlot(plot)
            end
        end
        _G.PlotESP_Data.plotsConn = plotsFolder.ChildAdded:Connect(function(plot)
            if plot:IsA("Model") then
                local plotConn = plot.AncestryChanged:Connect(function()
                    if not plot.Parent then
                        if _G.PlotESP_Data[plot] then
                            if _G.PlotESP_Data[plot].updateConn then pcall(function() _G.PlotESP_Data[plot].updateConn:Disconnect() end) end
                            if _G.PlotESP_Data[plot].highlight then pcall(function() _G.PlotESP_Data[plot].highlight:Destroy() end) end
                            if _G.PlotESP_Data[plot].billboard then pcall(function() _G.PlotESP_Data[plot].billboard:Destroy() end) end
                            _G.PlotESP_Data[plot] = nil
                        end
                    end
                end)
                _G.PlotESP_Data[plot] = _G.PlotESP_Data[plot] or {}
                _G.PlotESP_Data[plot].plotConn = plotConn
                task.wait(1) -- Wait for plot to fully load
                attachHighlightToPlot(plot)
            end
        end)
        _G.PlotESP_Data.plotsRemoveConn = plotsFolder.ChildRemoved:Connect(function(plot)
            if _G.PlotESP_Data[plot] then
                if _G.PlotESP_Data[plot].plotConn then pcall(function() _G.PlotESP_Data[plot].plotConn:Disconnect() end) end
                if _G.PlotESP_Data[plot].updateConn then pcall(function() _G.PlotESP_Data[plot].updateConn:Disconnect() end) end
                if _G.PlotESP_Data[plot].highlight then pcall(function() _G.PlotESP_Data[plot].highlight:Destroy() end) end
                if _G.PlotESP_Data[plot].billboard then pcall(function() _G.PlotESP_Data[plot].billboard:Destroy() end) end
                _G.PlotESP_Data[plot] = nil
            end
        end)
    end)
    if not success then
        warn("Failed to enable Plot ESP")
        Plot_G.ESP_Enabled = false
    end
end

local function disablePlotESP()
    if not _G.PlotESP_Enabled then return end
    local success, _ = pcall(function()
        _G.PlotESP_Enabled = false
        if _G.PlotESP_Data.plotsConn then
            pcall(function() _G.PlotESP_Data.plotsConn:Disconnect() end)
            _G.PlotESP_Data.plotsConn = nil
        end
        if _G.PlotESP_Data.plotsRemoveConn then
            pcall(function() _G.PlotESP_Data.plotsRemoveConn:Disconnect() end)
            _G.PlotESP_Data.plotsRemoveConn = nil
        end
        for plot, data in pairs(_G.PlotESP_Data) do
            if typeof(plot) == "Instance" then
                if data.plotConn then pcall(function() data.plotConn:Disconnect() end) end
                if data.updateConn then pcall(function() data.updateConn:Disconnect() end) end
                if data.highlight then pcall(function() data.highlight:Destroy() end) end
                if data.billboard then pcall(function() data.billboard:Destroy() end) end
                _G.PlotESP_Data[plot] = nil
            end
        end
    end)
    if not success then
        warn("Failed to disable Plot ESP")
    end
end

local function enablePlotTimeESP()
    if _G.PlotTimeESP_Enabled then return end
    local success, _ = pcall(function()
        local plotsFolder = workspace:FindFirstChild("Plots")
        if not plotsFolder then
            warn("Plots folder not found")
            return
        end

        _G.PlotTimeESP_Enabled = true
        _G.PlotTimeESP_Data = {} -- Clear existing data to prevent duplicates

        for _, plot in pairs(plotsFolder:GetChildren()) do
            if plot:IsA("Model") and plot:FindFirstChild("Spawn") then
                local billboard, timeLabel = createPlotTimeBillboard(plot)
                if billboard and timeLabel then
                    _G.PlotTimeESP_Data[plot] = {
                        billboard = billboard,
                        timeLabel = timeLabel
                    }
                    local lastUpdate = 0
                    _G.PlotTimeESP_Data[plot].updateConn = RunService.Heartbeat:Connect(function(deltaTime)
                        if not _G.PlotTimeESP_Enabled or not _G.PlotTimeESP_Data[plot] then return end
                        lastUpdate = lastUpdate + deltaTime
                        if lastUpdate >= CONFIG.ESP.UpdateInterval then
                            updatePlotTimeBillboard(plot, _G.PlotTimeESP_Data[plot])
                            lastUpdate = 0
                        end
                    end)
                end
            end
        end

        -- Handle new plots
        _G.PlotTimeESP_Data.plotsConn = plotsFolder.ChildAdded:Connect(function(plot)
            if plot:IsA("Model") then
                task.wait(1) -- Wait for plot to load
                if plot:FindFirstChild("Spawn") then
                    local billboard, timeLabel = createPlotTimeBillboard(plot)
                    if billboard and timeLabel then
                        _G.PlotTimeESP_Data[plot] = {
                            billboard = billboard,
                            timeLabel = timeLabel
                        }
                        local lastUpdate = 0
                        _G.PlotTimeESP_Data[plot].updateConn = RunService.Heartbeat:Connect(function(deltaTime)
                            if not _G.PlotTimeESP_Enabled or not _G.PlotTimeESP_Data[plot] then return end
                            lastUpdate = lastUpdate + deltaTime
                            if lastUpdate >= CONFIG.ESP.UpdateInterval then
                                updatePlotTimeBillboard(plot, _G.PlotTimeESP_Data[plot])
                                lastUpdate = 0
                            end
                        end)
                    end
                end
            end
        end)
        
        -- Handle player events for plot time updates
        _G.PlotTimeESP_Data.playerAddedConn = Players.PlayerAdded:Connect(function(plr)
            -- Update all plot time billboards when a player joins
            for plot, data in pairs(_G.PlotTimeESP_Data) do
                if typeof(plot) == "Instance" and data.billboard and data.timeLabel then
                    updatePlotTimeBillboard(plot, data)
                end
            end
        end)
        
        _G.PlotTimeESP_Data.playerRemovingConn = Players.PlayerRemoving:Connect(function(plr)
            -- Update all plot time billboards when a player leaves
            for plot, data in pairs(_G.PlotTimeESP_Data) do
                if typeof(plot) == "Instance" and data.billboard and data.timeLabel then
                    updatePlotTimeBillboard(plot, data)
                end
            end
        end)

        -- Handle plot removal
        _G.PlotTimeESP_Data.plotsRemoveConn = plotsFolder.ChildRemoved:Connect(function(plot)
            if _G.PlotTimeESP_Data[plot] then
                if _G.PlotTimeESP_Data[plot].updateConn then
                    pcall(function() _G.PlotTimeESP_Data[plot].updateConn:Disconnect() end)
                end
                if _G.PlotTimeESP_Data[plot].billboard then
                    pcall(function() _G.PlotTimeESP_Data[plot].billboard:Destroy() end)
                end
                _G.PlotTimeESP_Data[plot] = nil
            end
        end)
    end)
    if not success then
        warn("Failed to enable Plot Time ESP")
        PlotTime_G.ESP_Enabled = false
    end
end

--=========================================================
-- Server Hop System
--=========================================================
local isServerHopActive = false
local serverHopThread = nil

local function getServerList()
    local success, servers = pcall(function()
        local placeId = game.PlaceId
        local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = _G.safeHttpGet(url)
        if not response then
            warn("❌ Failed to fetch server list")
            return {}
        end
        local parsed = HttpService:JSONDecode(response)
        local result = {}
        if type(parsed) == "table" and type(parsed.data) == "table" then
            for _, server in ipairs(parsed.data) do
                if type(server) == "table" and server.playing and server.maxPlayers and server.id and server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(result, server.id)
                end
            end
        end
        return result
    end)
    if not success then
        warn("Failed to get server list")
        return {}
    end
    return servers
end

local function attemptServerHop()
    local success, _ = pcall(function()
        local serverList = getServerList()
        if #serverList > 0 then
            local target = serverList[math.random(1, #serverList)]
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, target, player)
        else
            warn("No available servers found")
        end
    end)
    if not success then
        warn("Server hop attempt failed")
    end
end

local function toggleServerHop(active)
    local success, _ = pcall(function()
        isServerHopActive = active
        if active then
            if not serverHopThread then
                serverHopThread = task.spawn(function()
                    while isServerHopActive do
                        attemptServerHop()
                        task.wait(6)
                    end
                    serverHopThread = nil
                end)
            end
        else
            isServerHopActive = false
        end
    end)
    if not success then
        warn("Failed to toggle server hop")
    end
end

--=========================================================
-- Jump Power Control
--=========================================================
local function setupJumpPowerControl(parent)
    local jumpData = {
        defaultJumpPower = 50,
        isActive = false
    }

    local jumpSwitch = createSwitch(parent, "Jump Bypass", _G.SavedToggleStates and _G.SavedToggleStates.Jump or false, function(on)
        local success, _ = pcall(function()
            jumpData.isActive = on
            if humanoid then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = on and CONFIG.Movement.JumpPower or jumpData.defaultJumpPower
            end
            if on then
                -- Auto-create side toggle when enabled
                _G.createCircularToggleUI("Jump", function() return jumpSwitch.get() end, function(state) jumpSwitch.set(state) end)
            else
                -- Remove side toggle when disabled
                local existingToggle = _G.circularToggleGui:FindFirstChild("JumpToggleUI")
                if existingToggle then
                    _G.OpenCircularToggles["Jump"] = nil
                    existingToggle:Destroy()
                    _G.saveSettings()
                end
            end
        end)
        if not success then
            warn("Failed to toggle jump power")
        end
    end)

    return jumpData.isActive, jumpSwitch
end

--=========================================================
-- Speed Boost Control
--=========================================================
local function setupSpeedControl(parent)
    local speedData = {
        enabled = false,
        connections = {},
        joystickDelta = Vector2.new(0, 0),
        touchId = nil
    }

    local function enableSpeed()
        local success, _ = pcall(function()
            if speedData.enabled then return end
            humanoid, humanoidRootPart = character and character:FindFirstChildOfClass("Humanoid"), character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not humanoidRootPart then return end
            speedData.enabled = true

            if UserInputService.TouchEnabled then
                speedData.connections.touchBegan = UserInputService.TouchStarted:Connect(function(input, gameProcessed)
                    if gameProcessed or speedData.touchId then return end
                    if input.UserInputType == Enum.UserInputType.Touch then
                        speedData.touchId = input.UserInputId
                        speedData.joystickDelta = Vector2.new(0, 0)
                    end
                end)

                speedData.connections.touchMoved = UserInputService.TouchMoved:Connect(function(input, gameProcessed)
                    if gameProcessed or input.UserInputId ~= speedData.touchId then return end
                    local touchPos = input.Position
                    local screenSize = workspace.CurrentCamera.ViewportSize
                    local normalizedPos = Vector2.new(
                        (touchPos.X / screenSize.X - 0.25) * 4,
                        (touchPos.Y / screenSize.Y - 0.5) * 2
                    )
                    speedData.joystickDelta = Vector2.new(
                        math.clamp(normalizedPos.X, -1, 1),
                        math.clamp(normalizedPos.Y, -1, 1)
                    )
                end)

                speedData.connections.touchEnded = UserInputService.TouchEnded:Connect(function(input, gameProcessed)
                    if gameProcessed or input.UserInputId ~= speedData.touchId then return end
                    speedData.touchId = nil
                    speedData.joystickDelta = Vector2.new(0, 0)
                end)
            end

            speedData.connections.move = RunService.Heartbeat:Connect(function()
                if not speedData.enabled or not humanoid or not humanoidRootPart or humanoidRootPart.Parent ~= character then return end

                local moveVector = Vector3.new(0, 0, 0)
                local camCF = workspace.CurrentCamera.CFrame

                if UserInputService.TouchEnabled and speedData.joystickDelta.Magnitude > 0.15 then
                    moveVector = camCF:VectorToWorldSpace(Vector3.new(speedData.joystickDelta.X, 0, -speedData.joystickDelta.Y))
                    moveVector = moveVector.Unit * CONFIG.Movement.Speed
                else
                    local moveX = (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0)
                    local moveZ = (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0)
                    if moveX ~= 0 or moveZ ~= 0 then
                        moveVector = (camCF.RightVector * moveX + camCF.LookVector * moveZ).Unit * CONFIG.Movement.Speed
                    end
                end

                local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
                local newVelocity = Vector3.new(
                    moveVector.X ~= 0 and moveVector.X or currentVelocity.X,
                    currentVelocity.Y,
                    moveVector.Z ~= 0 and moveVector.Z or currentVelocity.Z
                )

                local flatMag = Vector3.new(newVelocity.X, 0, newVelocity.Z).Magnitude
                if flatMag > CONFIG.Movement.MaxSpeed then
                    local ratio = CONFIG.Movement.MaxSpeed / flatMag
                    newVelocity = Vector3.new(newVelocity.X * ratio, newVelocity.Y, newVelocity.Z * ratio)
                end

                humanoidRootPart.AssemblyLinearVelocity = newVelocity
            end)
        end)
        if not success then
            warn("Failed to enable speed boost")
            speedData.enabled = false
        end
    end

    local function disableSpeed()
        local success, _ = pcall(function()
            if not speedData.enabled then return end
            speedData.enabled = false
            for _, conn in pairs(speedData.connections) do
                pcall(function() conn:Disconnect() end)
            end
            speedData.connections = {}
            speedData.touchId = nil
            speedData.joystickDelta = Vector2.new(0, 0)
            if humanoidRootPart then
                humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
            end
        end)
        if not success then
            warn("Failed to disable speed boost")
        end
    end

    local speedSwitch = createSwitch(parent, "Speed Boost", _G.SavedToggleStates and _G.SavedToggleStates.Speed or false, function(on)
        if on then
            enableSpeed()
            -- Auto-create side toggle when enabled
            _G.createCircularToggleUI("Speed", function() return speedSwitch.get() end, function(state) speedSwitch.set(state) end)
        else
            disableSpeed()
            -- Remove side toggle when disabled
            local existingToggle = _G.circularToggleGui:FindFirstChild("SpeedToggleUI")
            if existingToggle then
                _G.OpenCircularToggles["Speed"] = nil
                existingToggle:Destroy()
                _G.saveSettings()
            end
        end
    end)

    return speedData.enabled, speedSwitch
end

-- Setup Movement Controls (moved here after function definitions)
local _, jumpSwitch = setupJumpPowerControl(_G.movementSection)
local _, speedSwitch = setupSpeedControl(_G.movementSection)

--=========================================================
-- Unhittable Control
--=========================================================
local unhittableSwitch -- Global to access in CharacterAdded

local function setupUnhittableControl(parent)
    local defaultSize = Vector3.new(2, 2, 1)
    local isUnhittableActive = false
    local unhittableThread = nil

    unhittableSwitch = createSwitch(parent, "Height Bypass", false, function(on)
        local success, _ = pcall(function()
            isUnhittableActive = on
            if not humanoidRootPart then return end
            if on then
                if not unhittableThread then
                    unhittableThread = task.spawn(function()
                        while isUnhittableActive do
                            if humanoidRootPart then
                                humanoidRootPart.Size = Vector3.new(
                                    CONFIG.Movement.Unhittable.IntermediateSize.X,
                                    CONFIG.Movement.Unhittable.IntermediateSize.Y,
                                    CONFIG.Movement.Unhittable.IntermediateSize.Z
                                )
                                task.wait(0.2)
                                if not isUnhittableActive then break end
                                humanoidRootPart.Size = Vector3.new(
                                    CONFIG.Movement.Unhittable.TallSize.X,
                                    CONFIG.Movement.Unhittable.TallSize.Y,
                                    CONFIG.Movement.Unhittable.TallSize.Z
                                )
                                task.wait(2.1)
                                if not isUnhittableActive then break end
                                humanoidRootPart.Size = defaultSize
                                task.wait(1.5)
                            else
                                task.wait(0.1)
                            end
                        end
                        if humanoidRootPart then
                            humanoidRootPart.Size = defaultSize
                        end
                        unhittableThread = nil
                    end)
                end
            else
                if humanoidRootPart then
                    humanoidRootPart.Size = defaultSize
                end
                if unhittableThread then
                    task.cancel(unhittableThread)
                    unhittableThread = nil
                end
            end
        end)
        if not success then
            warn("Failed to toggle height bypass")
        end
    end)

    return isUnhittableActive, unhittableSwitch
end

--=========================================================
-- Resize Control
--=========================================================
local resizeSwitch -- Global to access in CharacterAdded

local function setupResizeControl(parent)
    local defaultSize = Vector3.new(2, 2, 1)
    local isResizeActive = false

    resizeSwitch = createSwitch(parent, "Tall like Ken", false, function(on)
        local success, _ = pcall(function()
            isResizeActive = on
            if humanoidRootPart then
                humanoidRootPart.Size = on and Vector3.new(
                    CONFIG.Movement.Resize.TargetSize.X,
                    CONFIG.Movement.Resize.TargetSize.Y,
                    CONFIG.Movement.Resize.TargetSize.Z
                ) or defaultSize
            end
        end)
        if not success then
            warn("Failed to toggle tall mode")
        end
    end)

    return isResizeActive, resizeSwitch
end

--=========================================================
-- Fling Control (Fixed Desync Logic)
--=========================================================
local flingSwitch -- Global to access in CharacterAdded

local function setupFlingControl(parent)
    local isFlingActive = false
    local desyncState = {}
    local flingConnection = nil
    local oldIndex = nil

    local function RandomNumberRange(a)
        return math.random(-a * 100, a * 100) / 100
    end

    local function enableFling()
        local success, err = pcall(function()
            if isFlingActive then return end
            -- Ensure character and components exist
            if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
                warn("Cannot enable fling: Character not ready")
                return
            end
            isFlingActive = true

            -- Hook __index to spoof CFrame
            oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
                if isFlingActive and not checkcaller() and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    if key == "CFrame" then
                        if self == player.Character.HumanoidRootPart then
                            return desyncState[1] or CFrame.new()
                        elseif self == player.Character.Head then
                            return desyncState[1] and (desyncState[1] + Vector3.new(0, player.Character.HumanoidRootPart.Size.Y / 2 + 0.5, 0)) or CFrame.new()
                        end
                    end
                end
                return oldIndex(self, key)
            end))

            flingConnection = RunService.Heartbeat:Connect(function()
                if isFlingActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local hrp = player.Character.HumanoidRootPart
                    -- Store original state
                    desyncState[1] = hrp.CFrame
                    desyncState[2] = hrp.AssemblyLinearVelocity

                    -- Spoof CFrame and velocity
                    local spoofCFrame = desyncState[1] * CFrame.new(Vector3.new(0, 0, 0))
                    spoofCFrame = spoofCFrame * CFrame.Angles(math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)), math.rad(RandomNumberRange(180)))
                    hrp.CFrame = spoofCFrame
                    hrp.AssemblyLinearVelocity = Vector3.new(1, 0, 0) * 5000 -- Reduced velocity to prevent physics crashes

                    -- Wait for next frame
                    RunService.RenderStepped:Wait()

                    -- Restore original state only if character is still valid
                    if player.Character and hrp.Parent == player.Character then
                        hrp.CFrame = desyncState[1]
                        hrp.AssemblyLinearVelocity = desyncState[2]
                    end
                end
            end)
        end)
        if not success then
            warn("Failed to enable fling: " .. tostring(err))
            isFlingActive = false
            flingSwitch.set(false) -- Reset UI switch if enabling fails
        end
    end

    local function disableFling()
        local success, err = pcall(function()
            if not isFlingActive then return end
            isFlingActive = false
            if flingConnection then
                flingConnection:Disconnect()
                flingConnection = nil
            end
            if oldIndex then
                -- Restore original __index
                hookmetamethod(game, "__index", function(self, key)
                    return oldIndex(self, key)
                end)
                oldIndex = nil
            end
            desyncState = {}
            -- Ensure character state is reset
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, player.Character.HumanoidRootPart.AssemblyLinearVelocity.Y, 0)
            end
        end)
        if not success then
            warn("Failed to disable fling: " .. tostring(err))
        end
    end

    flingSwitch = createSwitch(parent, "Fling (patched)", false, function(on)
        if on then
            enableFling()
        else
            disableFling()
        end
    end)

    return isFlingActive, flingSwitch
end

--=========================================================
-- UI Sections Setup

-- ══════════════════════════════════════════════════════
-- قسم الرئيسية
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.homeSection, "🏠  مرحباً بك في كن هاب × AXL")

local _welc = Instance.new("TextLabel", _G.homeSection)
_welc.Size = UDim2.new(1,0,0,70)
_welc.BackgroundColor3 = C.GOLD3
Instance.new("UICorner", _welc).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", _welc).Color = C.GOLD2
_welc.Text = "⭐  كن هاب v1.67 × AXL PREMIUM\nجميع الميزات مدموجة | واجهة عربية كاملة\nأسود وذهبي | للديسكورد: discord.gg/MxtDGmvkCd"
_welc.Font = Enum.Font.GothamMedium ; _welc.TextSize = 11
_welc.TextColor3 = C.GOLD ; _welc.TextWrapped = true

createSectionHeader(_G.homeSection, "📊  معلومات اللاعب")
local _infoLabel = Instance.new("TextLabel", _G.homeSection)
_infoLabel.Size = UDim2.new(1,0,0,42)
_infoLabel.BackgroundColor3 = C.ROW
Instance.new("UICorner", _infoLabel).CornerRadius = UDim.new(0,10)
_infoLabel.BackgroundTransparency = 0
_infoLabel.Text = "👤  " .. (player.Name or "؟") .. "  |  🎮  اللعبة: Steal a Brainrot"
_infoLabel.Font = Enum.Font.GothamMedium ; _infoLabel.TextSize = 12
_infoLabel.TextColor3 = C.WHITE

createButton(_G.homeSection, "📋  نسخ الرابط: discord.gg/MxtDGmvkCd", function()
    setclipboard("https://discord.gg/MxtDGmvkCd")
end)

-- ══════════════════════════════════════════════════════
-- قسم الحركة
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.movementSection, "🏃  حركة اللاعب")
local floatSwitch = createSwitch(_G.movementSection, "🌊  طيران بطيء (Float)", CONFIG.Movement.Float.Enabled, function(on)
    if on then
        local char = player.Character or player.CharacterAdded:Wait()
        enableFloat(char)
        _G.createCircularToggleUI("🌊 Float", function() return CONFIG.Movement.Float.Enabled end, function(s) CONFIG.Movement.Float.Enabled=s; if s then enableFloat(player.Character) else disableFloat() end end)
    else disableFloat() end
end)

local platformSwitch = createSwitch(_G.movementSection, "🚀  منصة صاعدة (Platform)", CONFIG.Movement.Rise.Enabled, function(on)
    if on then
        local char = player.Character or player.CharacterAdded:Wait()
        enablePlatform(char)
        _G.createCircularToggleUI("🚀 Platform", function() return CONFIG.Movement.Rise.Enabled end, function(s) CONFIG.Movement.Rise.Enabled=s end)
    else disablePlatform() end
end)

local helicopterSwitch = createSwitch(_G.movementSection, "🚁  هليكوبتر", CONFIG.Movement.Helicopter.Enabled, function(on)
    if on then
        local char = player.Character or player.CharacterAdded:Wait()
        enableHelicopter(char)
        _G.createCircularToggleUI("🚁 Helicopter", function() return CONFIG.Movement.Helicopter.Enabled end, function(s) CONFIG.Movement.Helicopter.Enabled=s end)
    else disableHelicopter() end
end)

local grappleFlightSwitch = createSwitch(_G.movementSection, "⛓  رحلة الجرافل", CONFIG.Movement.GrappleFlight.Enabled, function(on)
    if on then
        local char = player.Character or player.CharacterAdded:Wait()
        enableGrappleFlight(char)
    else disableGrappleFlight() end
end)

local infiniteJumpSwitch = createSwitch(_G.movementSection, "⬆  قفز لانهائي", CONFIG.Movement.InfiniteJump.Enabled, function(on)
    if on then
        local char = player.Character or player.CharacterAdded:Wait()
        enableInfiniteJump(char)
        _G.createCircularToggleUI("⬆ Inf Jump", function() return CONFIG.Movement.InfiniteJump.Enabled end, function(s) CONFIG.Movement.InfiniteJump.Enabled=s end)
    else disableInfiniteJump() end
end)

local _, jumpSwitch = setupJumpPowerControl(_G.movementSection)
local _, speedSwitch = setupSpeedControl(_G.movementSection)
local _, unhittableSwitchInstance = setupUnhittableControl(_G.movementSection)
local _, resizeSwitchInstance     = setupResizeControl(_G.movementSection)

createSectionHeader(_G.movementSection, "⚔  نظام الفلينج")
local flingToggleButton
local playerSelectButton
local _, flingSwitchInstance = setupFlingControl(_G.movementSection)

createSectionHeader(_G.movementSection, "🔫  ليزر كيب")
local originalLaserCapeSwitch = createSwitch(_G.movementSection, "🔫  ليزر كيب أوتو-فاير", false, function(on)
    if on then
        if player.Character then enableLaserCape(player.Character) end
        _G.createCircularToggleUI("🔫 LaserCape", function() return isLaserCapeFiring end, function(s) if s then enableLaserCape(player.Character) else disableLaserCape() end end)
    else disableLaserCape() end
end)

createSectionHeader(_G.movementSection, "🩻  راجدول ديسينك")
local ragdollDesyncSwitch = createSwitch(_G.movementSection, "🩻  راجدول ديسينك", false, function(on)
    if on then
        if player.Character then enableRagdollDesync(player.Character) end
    else disableRagdollDesync() end
end)

-- ══════════════════════════════════════════════════════
-- قسم المرئيات
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.visualSection, "👁  إعدادات ESP")

_G.playerESPSwitch = createSwitch(_G.visualSection, "👤  ESP اللاعبين", _G.SavedToggleStates and _G.SavedToggleStates.PlayerESP or false, function(on)
    if on then
        enableESP()
        _G.createCircularToggleUI("👤 Player ESP", function() return _G.ESP_Enabled end, function(s) if s then enableESP() else disableESP() end end)
    else disableESP() end
end)

_G.plotESPSwitch = createSwitch(_G.visualSection, "🗺  ESP البلوت", _G.SavedToggleStates and _G.SavedToggleStates.PlotESP or false, function(on)
    if on then
        enablePlotESP()
        _G.createCircularToggleUI("🗺 Plot ESP", function() return _G.PlotESP_Enabled end, function(s) if s then enablePlotESP() else disablePlotESP() end end)
    else disablePlotESP() end
end)

local plotTimeESPSwitch = createSwitch(_G.visualSection, "⏱  وقت البلوت ESP", true, function(on)
    if on then enablePlotTimeESP() else disablePlotTimeESP() end
end)
if plotTimeESPSwitch then enablePlotTimeESP() end

_G.brainrotESPSwitch = createSwitch(_G.visualSection, "🧠  ESP البراينروت", CONFIG.ESP.BrainrotESP.Enabled, function(on)
    if on then
        enableBrainrotESP()
        _G.createCircularToggleUI("🧠 Brainrot ESP", function() return CONFIG.ESP.BrainrotESP.Enabled end, function(s) if s then enableBrainrotESP() else disableBrainrotESP() end end)
    else disableBrainrotESP() end
end)

createSectionHeader(_G.visualSection, "🗺  خيارات الخريطة")
createButton(_G.visualSection, "🗑  حذف الحواجز (Borders)", function()
    local b = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Borders")
    if b then b:Destroy() end
end)
createButton(_G.visualSection, "🧱  زيادة الحاجز Z=13", function()
    pcall(function()
        local map = workspace:FindFirstChild("Map")
        if not map then return end
        for _, p in ipairs(map:GetDescendants()) do
            if p:IsA("BasePart") and (p.Name == "Left" or p.Name == "Right" or p.Name == "Front" or p.Name == "Back") then
                p.Size = Vector3.new(p.Size.X, p.Size.Y, 13)
            end
        end
    end)
end)

-- ══════════════════════════════════════════════════════
-- قسم المُصلَح
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.patchedSection, "🔧  ميزات مُصلَحة (Patched)")
local invisibilitySwitch = createSwitch(_G.patchedSection, "👻  إخفاء (مُصلَح)", _G.SavedToggleStates and _G.SavedToggleStates.Invisibility or false, function(on)
    setInvisibility(on)
end)
local _ , _flingInst = setupFlingControl(_G.patchedSection)

-- ══════════════════════════════════════════════════════
-- قسم السيرفر
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.serverSection, "🌐  خيارات السيرفر")
local serverHopSwitch = createSwitch(_G.serverSection, "🔄  تبديل سيرفر تلقائي", false, function(on)
    toggleServerHop(on)
end)
createButton(_G.serverSection, "🔁  إعادة الانضمام",     function() _G.rejoinServer() end)
createButton(_G.serverSection, "🏆  أكبر سيرفر",         function() _G.joinBiggestServer() end)
createButton(_G.serverSection, "🔰  أصغر سيرفر",         function() _G.joinSmallestServer() end)

-- ══════════════════════════════════════════════════════
-- قسم ديسينك
-- ══════════════════════════════════════════════════════
createSectionHeader(_G.desyncSection, "⚡  ديسينك موبايل")
local mobileDesyncSwitch = createSwitch(_G.desyncSection, "📱  ديسينك (موبايل)", false, function(on)
    if on then enableMobileDesync() else disableMobileDesync() end
end)

-- ══════════════════════════════════════════════════════
-- قسم الإعدادات (settingsContent)
-- ══════════════════════════════════════════════════════
createSectionHeader(settingsContent, "👁  إعدادات ESP اللاعبين")
createSwitch(settingsContent, "📏  إظهار المسافة", CONFIG.ESP.PlayerESP.ShowDistance, function(on)
    CONFIG.ESP.PlayerESP.ShowDistance = on ; if _G.ESP_Enabled then disableESP(); enableESP() end
end)
createSwitch(settingsContent, "🎒  إظهار الأدوات", CONFIG.ESP.PlayerESP.ShowItems, function(on)
    CONFIG.ESP.PlayerESP.ShowItems = on ; if _G.ESP_Enabled then disableESP(); enableESP() end
end)
createNumberInput(settingsContent, "📝  حجم خط اللاعب", CONFIG.ESP.PlayerESP.TextSize, function(n)
    CONFIG.ESP.PlayerESP.TextSize = n ; if _G.ESP_Enabled then disableESP(); enableESP() end
end)

createSectionHeader(settingsContent, "🗺  إعدادات ESP البلوت")
createSwitch(settingsContent, "📏  مسافة البلوت", CONFIG.ESP.PlotESP.ShowDistance, function(on)
    CONFIG.ESP.PlotESP.ShowDistance = on ; if _G.PlotESP_Enabled then disablePlotESP(); enablePlotESP() end
end)
createSwitch(settingsContent, "👤  مالك البلوت", CONFIG.ESP.PlotESP.ShowOwner, function(on)
    CONFIG.ESP.PlotESP.ShowOwner = on ; if _G.PlotESP_Enabled then disablePlotESP(); enablePlotESP() end
end)
createSwitch(settingsContent, "⏱  وقت البلوت", CONFIG.ESP.PlotESP.ShowTime, function(on)
    CONFIG.ESP.PlotESP.ShowTime = on ; if _G.PlotESP_Enabled then disablePlotESP(); enablePlotESP() end
end)

createSectionHeader(settingsContent, "🏃  إعدادات الحركة")
createNumberInput(settingsContent, "⚡  سرعة الجري", CONFIG.Movement.Speed, function(n)
    CONFIG.Movement.Speed = n ; _G.saveSettings()
end)
createNumberInput(settingsContent, "⬆  قوة القفز", CONFIG.Movement.JumpPower, function(n)
    CONFIG.Movement.JumpPower = n ; _G.saveSettings()
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower=true; hum.JumpPower=n end
    end
end)

createSectionHeader(settingsContent, "🔄  إعادة التعيين")
createButton(settingsContent, "🔄  إعادة تعيين الإعدادات", function()
    if _G.safeIsFile("Ken_HUB_Settings.json") then pcall(delfile,"Ken_HUB_Settings.json") end
    CONFIG.Movement.Speed = 43 ; CONFIG.Movement.JumpPower = 73.5
    _G.saveSettings()
end)


-- ══════════════════════════════════════════════════════════════
--  ⭐  قسم AXL BRAINROT PREMIUM
-- ══════════════════════════════════════════════════════════════

-- ──── ثيم AXL ────
local AXL = {
    GOLD  = Color3.fromRGB(255,200,45),
    DIM   = Color3.fromRGB(160,118,18),
    DARK  = Color3.fromRGB(55,38,3),
    WHITE = Color3.fromRGB(240,240,240),
    SUB   = Color3.fromRGB(130,130,130),
    GREEN = Color3.fromRGB(40,210,90),
    RED   = Color3.fromRGB(215,45,45),
}

-- ──── حالات AXL ────
local AXL_EN = {BUILD=false, TRANS=true, ESP=true, AFK=true, MOVE=false}

-- ──── Build System v8 ────
local AXL_MAP = "AXL_PREMIUM_MAP"
local function axlClear()
    local ex = workspace:FindFirstChild(AXL_MAP)
    if ex then ex:Destroy() end
end
local function axlLabel(part)
    local bg = Instance.new("BillboardGui", part)
    bg.Size = UDim2.new(0,50,0,20) ; bg.AlwaysOnTop = true ; bg.ExtentsOffset = Vector3.new(0,2,0)
    local lb = Instance.new("TextLabel", bg)
    lb.BackgroundTransparency=1 ; lb.Size=UDim2.new(1,0,1,0)
    lb.Text="درج" ; lb.Font=Enum.Font.GothamBold
    lb.TextColor3=AXL.GOLD ; lb.TextSize=10 ; lb.TextTransparency=0.3
end
local function axlPart(pos, sz, parent, col)
    local p = Instance.new("Part", parent)
    p.Size=sz ; p.Position=pos+Vector3.new(0,10,0)
    p.Anchored=true ; p.Material=Enum.Material.Neon
    p.Color=col or AXL.DARK ; p.Transparency=0.2
    local sb=Instance.new("SelectionBox",p)
    sb.Adornee=p ; sb.Color3=AXL.GOLD ; sb.LineThickness=0.05
    TweenService:Create(p,TweenInfo.new(0.3),{Position=pos}):Play()
    return p
end
local function axlStairs(bPos, bSz, parent)
    local dirs = {
        bPos+Vector3.new( bSz.X/2+4,-1,0),
        bPos+Vector3.new(-(bSz.X/2+4),-1,0),
        bPos+Vector3.new(0,-1, bSz.Z/2+4),
        bPos+Vector3.new(0,-1,-(bSz.Z/2+4))
    }
    for _,d in ipairs(dirs) do
        for i=1,5 do
            local off
            if d.X~=bPos.X then off=Vector3.new((d.X>bPos.X and i*2.5 or -i*2.5),-(i*1.2),0)
            else off=Vector3.new(0,-(i*1.2),(d.Z>bPos.Z and i*2.5 or -i*2.5)) end
            local step=axlPart(d+off,Vector3.new(8,.5,3),parent,AXL.DIM)
            if i==1 then axlLabel(step) end
        end
    end
end
local function axlBuild()
    axlClear()
    local m=Instance.new("Model",workspace) ; m.Name=AXL_MAP
    local data={
        {Vector3.new(-350,-3.5,60),Vector3.new(15,1,350)},
        {Vector3.new(-460,-3.5,60),Vector3.new(15,1,350)},
        {Vector3.new(-405,-3,-20),Vector3.new(125,1,15)},
        {Vector3.new(-405,-3,150),Vector3.new(125,1,15)},
    }
    task.spawn(function()
        for _,info in ipairs(data) do
            axlPart(info[1],info[2],m)
            axlStairs(info[1],info[2],m)
            task.wait(.1)
        end
    end)
end

-- ──── شفافية البلوت ────
local AXL_TPATS = {"Side","Structure","Base","Home"}
local function axlIsTarget(n)
    for _,p in ipairs(AXL_TPATS) do if string.find(n,p) then return true end end
end
local function axlTransModel(model)
    if not model:IsA("Model") then return end
    for _,c in ipairs(model:GetDescendants()) do
        if c:IsA("BasePart") and axlIsTarget(c.Name) then c.Transparency=0.9 end
    end
end
local function axlApplyTrans()
    local ok,pf=pcall(function() return workspace:WaitForChild("Plots",5) end)
    if not ok or not pf then return end
    for _,plot in ipairs(pf:GetChildren()) do axlTransModel(plot) end
    pf.ChildAdded:Connect(function(p) if AXL_EN.TRANS then axlTransModel(p) end end)
end
if AXL_EN.TRANS then task.spawn(axlApplyTrans) end

-- ──── ESP النوادر ────
local AXL_RARE = {
    "Strawberry Elephant","Meowl","Skibidi Toilet","Headless Horseman","Celestial Pegasus",
    "Griffin","Hydra Dragon Cannelloni","Dragon Cannelloni","Dragon Gingerini","Love Love Bear",
    "Los Nooo My Hotspotsitos","Burguro and Fryuro","La Supreme Combinasion","Rosey and Teddy",
    "Cerberus","Capitano Moby","Signore Carapace","La Secret Combinasion","Spaghetti Tualetti",
    "Garama and Madundung","Ketchuru and Musturu","Ketupat Kepat","Los Bros","Tralaledon",
    "Nuclearo Dinosauro","La Grande Combinasion","Chicleteira Bicicleteira","Esok Sekolah",
    "Pot Hotspot","La Sahur Combinasion","Nacho Spyder","Brunito Marsito"
}
local axlDetected,axlESPObj = {},{}
local function axlRemESP(model)
    if axlESPObj[model] then
        for _,o in ipairs(axlESPObj[model]) do pcall(function() o:Destroy() end) end
        axlESPObj[model]=nil
    end
    axlDetected[model]=nil
end
local function axlAddESP(model)
    if axlDetected[model] then return end
    axlDetected[model]=true ; axlESPObj[model]={}
    local hrp=model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end
    local hl=Instance.new("Highlight",model)
    hl.FillColor=AXL.GOLD ; hl.OutlineColor=AXL.WHITE
    hl.FillTransparency=0.5
    table.insert(axlESPObj[model],hl)
    local bill=Instance.new("BillboardGui",hrp)
    bill.Size=UDim2.new(0,200,0,50) ; bill.StudsOffset=Vector3.new(0,6,0) ; bill.AlwaysOnTop=true
    table.insert(axlESPObj[model],bill)
    local fr=Instance.new("Frame",bill)
    fr.Size=UDim2.new(1,0,1,0) ; fr.BackgroundColor3=Color3.fromRGB(8,8,8) ; fr.BackgroundTransparency=0.2
    Instance.new("UICorner",fr).CornerRadius=UDim.new(0,10)
    local st=Instance.new("UIStroke",fr) ; st.Color=AXL.GOLD ; st.Thickness=2
    local lb=Instance.new("TextLabel",fr)
    lb.Size=UDim2.new(1,0,1,0) ; lb.BackgroundTransparency=1
    lb.Text="💎 نادر: "..model.Name
    lb.TextColor3=AXL.WHITE ; lb.Font=Enum.Font.GothamBold ; lb.TextSize=13
    model.AncestryChanged:Connect(function()
        if not model:IsDescendantOf(workspace) then axlRemESP(model) end
    end)
end
local function axlClearESP()
    for m in pairs(axlDetected) do axlRemESP(m) end
end
local _axlTimer=0
RunService.Heartbeat:Connect(function(dt)
    _axlTimer=_axlTimer+dt
    if _axlTimer<2 then return end ; _axlTimer=0
    if not AXL_EN.ESP then return end
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            for _,n in ipairs(AXL_RARE) do
                if v.Name==n then axlAddESP(v); break end
            end
        end
    end
end)

-- ──── Anti-AFK ────
local _axlLast=tick()
UserInputService.InputBegan:Connect(function() _axlLast=tick() end)
task.spawn(function()
    while true do task.wait(2)
        if AXL_EN.AFK and tick()-_axlLast>10 then
            local ch=player.Character ; local hm=ch and ch:FindFirstChildOfClass("Humanoid")
            if hm then hm.Jump=true ; hm:Move(Vector3.new(math.random(-1,1),0,math.random(-1,1)),false) end
            _axlLast=tick()
        end
    end
end)

-- ──── حركة عشوائية PathFinding ────
local _axlMoving=false
local function axlRandomMove()
    if _axlMoving then return end ; _axlMoving=true
    local ch=player.Character
    if not ch then _axlMoving=false; return end
    local hm=ch:FindFirstChildOfClass("Humanoid")
    local root=ch:FindFirstChild("HumanoidRootPart")
    if not hm or not root then _axlMoving=false; return end
    hm.WalkSpeed=math.random(12,22)
    local target=root.Position+Vector3.new(math.random(-200,200),0,math.random(-200,200))
    local pfs=game:GetService("PathfindingService")
    local path=pfs:CreatePath()
    pcall(function() path:ComputeAsync(root.Position,target) end)
    for _,wp in ipairs(path:GetWaypoints()) do
        if not AXL_EN.MOVE then break end
        hm:MoveTo(wp.Position)
        if wp.Action==Enum.PathWaypointAction.Jump then hm.Jump=true end
        hm.MoveToFinished:Wait()
    end
    _axlMoving=false
end
task.spawn(function()
    while true do task.wait(5)
        if AXL_EN.MOVE then task.spawn(axlRandomMove) end
    end
end)

-- ──── UI قسم AXL ────
createSectionHeader(_G.axlSection, "⭐  AXL BRAINROT PREMIUM")

local _axlWelc = Instance.new("TextLabel", _G.axlSection)
_axlWelc.Size = UDim2.new(1,0,0,44)
_axlWelc.BackgroundColor3 = AXL.DARK
Instance.new("UICorner", _axlWelc).CornerRadius = UDim.new(0,10)
Instance.new("UIStroke", _axlWelc).Color = AXL.DIM
_axlWelc.Text = "⭐ أسود × ذهبي | بناء + ESP نوادر + حماية AFK"
_axlWelc.Font = Enum.Font.GothamMedium ; _axlWelc.TextSize = 11
_axlWelc.TextColor3 = AXL.GOLD ; _axlWelc.TextWrapped = true

-- helper toggle row لـ AXL
local function axlToggleRow(parent, label, sub, stateKey, onEn, onDis)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,58)
    row.BackgroundColor3 = Color3.fromRGB(15,15,15)
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)
    local rs = Instance.new("UIStroke", row) ; rs.Color=AXL.DIM ; rs.Thickness=1 ; rs.Transparency=0.4

    local lb = Instance.new("TextLabel", row)
    lb.Size=UDim2.new(0.72,0,0,20) ; lb.Position=UDim2.new(0,10,0,8)
    lb.BackgroundTransparency=1 ; lb.Text=label
    lb.TextColor3=AXL.WHITE ; lb.Font=Enum.Font.GothamBold ; lb.TextSize=12
    lb.TextXAlignment=Enum.TextXAlignment.Left

    local sl = Instance.new("TextLabel", row)
    sl.Size=UDim2.new(0.72,0,0,14) ; sl.Position=UDim2.new(0,10,0,30)
    sl.BackgroundTransparency=1 ; sl.Text=sub
    sl.TextColor3=AXL.SUB ; sl.Font=Enum.Font.Gotham ; sl.TextSize=10
    sl.TextXAlignment=Enum.TextXAlignment.Left

    local swBG = Instance.new("Frame", row)
    swBG.Size=UDim2.new(0,46,0,24) ; swBG.Position=UDim2.new(1,-54,0.5,-12)
    swBG.BackgroundColor3 = AXL_EN[stateKey] and AXL.GOLD or Color3.fromRGB(45,45,45)
    Instance.new("UICorner", swBG).CornerRadius = UDim.new(1,0)
    local knob = Instance.new("Frame", swBG)
    knob.Size=UDim2.new(0,19,0,19)
    knob.Position = AXL_EN[stateKey] and UDim2.new(1,-22,0,2) or UDim2.new(0,2,0,2)
    knob.BackgroundColor3=AXL.WHITE
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local function doT()
        AXL_EN[stateKey]=not AXL_EN[stateKey]
        local on=AXL_EN[stateKey]
        TweenService:Create(swBG,TweenInfo.new(.15),{BackgroundColor3=on and AXL.GOLD or Color3.fromRGB(45,45,45)}):Play()
        TweenService:Create(knob,TweenInfo.new(.15),{Position=on and UDim2.new(1,-22,0,2) or UDim2.new(0,2,0,2)}):Play()
        if on and onEn then pcall(onEn) end
        if not on and onDis then pcall(onDis) end
    end
    local hit=Instance.new("TextButton",row)
    hit.Size=UDim2.new(1,0,1,0) ; hit.BackgroundTransparency=1 ; hit.Text=""
    hit.MouseButton1Click:Connect(doT) ; hit.TouchTap:Connect(doT)
end

-- helper زر AXL
local function axlBtn(parent, txt, col, cb)
    local btn=Instance.new("TextButton", parent)
    btn.Size=UDim2.new(1,0,0,40) ; btn.BackgroundColor3=Color3.fromRGB(15,15,15)
    btn.Text=txt ; btn.TextColor3=col or AXL.GOLD
    btn.Font=Enum.Font.GothamBold ; btn.TextSize=13 ; btn.AutoButtonColor=false
    Instance.new("UICorner", btn).CornerRadius=UDim.new(0,10)
    local bs=Instance.new("UIStroke", btn) ; bs.Color=col or AXL.GOLD ; bs.Thickness=1 ; bs.Transparency=0.35
    btn.MouseButton1Click:Connect(function() if cb then pcall(cb) end end)
    btn.TouchTap:Connect(function() if cb then pcall(cb) end end)
end

createSectionHeader(_G.axlSection, "🔧  تحكم الميزات")

axlToggleRow(_G.axlSection, "🏗️  AXL Build System", "بناء سينمائي 360° بالدرج",
    "BUILD", function() axlBuild() end, function() axlClear() end)
axlToggleRow(_G.axlSection, "🌫️  شفافية البلوت", "إخفاء Side/Base/Home",
    "TRANS", function() task.spawn(axlApplyTrans) end, nil)
axlToggleRow(_G.axlSection, "💎  ESP النوادر الذهبي", "رصد 32 براينروت نادر",
    "ESP", nil, function() axlClearESP() end)
axlToggleRow(_G.axlSection, "🛡️  Anti-AFK", "حماية من الطرد التلقائي",
    "AFK", nil, nil)
axlToggleRow(_G.axlSection, "🤖  حركة عشوائية", "تجول ذكي PathFinding",
    "MOVE", nil, nil)

createSectionHeader(_G.axlSection, "🚀  أوامر سريعة")
axlBtn(_G.axlSection, "🚀  ابنِ الخريطة الآن", AXL.GREEN, axlBuild)
axlBtn(_G.axlSection, "🗑️  احذف الخريطة",      AXL.RED,   axlClear)
axlBtn(_G.axlSection, "👁️  أعد رصد النوادر",   AXL.GOLD,  function()
    axlClearESP() ; axlDetected={} ; axlESPObj={}
end)
axlBtn(_G.axlSection, "🌫️  طبّق الشفافية الآن", AXL.WHITE, function()
    task.spawn(axlApplyTrans)
end)


-- ══════════════════════════════════════════════════════
-- تهيئة الواجهة + نظام الحفظ والاستعادة
-- ══════════════════════════════════════════════════════
local function initialize()
    local success, _ = pcall(function()
        -- فتح قسم الرئيسية افتراضياً
        if tabActivators["الرئيسية"] then
            tabActivators["الرئيسية"]()
        else
            -- fallback
            activeSection = "الرئيسية"
            sections["الرئيسية"].Visible = true
        end

        -- مراقبة البلوت تلقائياً
        task.spawn(function()
            while true do
                if not playerPlot or not playerPlot.Parent then
                    playerPlot = findPlayerPlot()
                end
                task.wait(2)
            end
        end)

        -- حفظ الحالة كل ثانيتين
        task.spawn(function()
            while true do
                _G.saveUIState()
                task.wait(2)
            end
        end)
    end)
    if not success then warn("Failed to initialize UI") end
end

initialize()

-- ══════════════════════════════════════════════════════
-- تنظيف عند إغلاق
-- ══════════════════════════════════════════════════════
game:BindToClose(function()
    pcall(function()
        if _G.ESP_Enabled then disableESP() end
        if _G.PlotESP_Enabled then disablePlotESP() end
        if isServerHopActive then toggleServerHop(false) end
        if jumpSwitch and jumpSwitch.get and jumpSwitch.get() then jumpSwitch.set(false) end
        if speedSwitch and speedSwitch.get and speedSwitch.get() then speedSwitch.set(false) end
        if invisibilitySwitch and invisibilitySwitch.get and invisibilitySwitch.get() then setInvisibility(false) end
        if isLaserCapeFiring then disableLaserCape() end
        if _G.mobileDesyncEnabled then disableMobileDesync() end
        if CONFIG.ESP.BrainrotESP.Enabled then disableBrainrotESP() end
    end)
end)

-- ══════════════════════════════════════════════════════
-- ULTRA-COMPACT ESP (نسخ من الأصلي)
-- ══════════════════════════════════════════════════════
_G.ESP = {suffixes={K=1e3,M=1e6,B=1e9,T=1e12,Qa=1e15,Qi=1e18},current={overhead=nil,modelHighlight=nil,partHighlight=nil,maxVal=-1,owner=nil},playerHighlights={}}

function _G.parseGen(text)
    if not text then return 0 end
    text = text:match("^%$(.+)") or text
    text = text:gsub("/S$",""):gsub(",","")
    local num = tonumber(text:match("^[%d%.]+")) or 0
    local suffix = text:match("[%a]+")
    return suffix and _G.ESP.suffixes[suffix] and num*_G.ESP.suffixes[suffix] or num
end

function _G.clearVisuals()
    if _G.ESP.current.modelHighlight then _G.ESP.current.modelHighlight:Destroy(); _G.ESP.current.modelHighlight=nil end
    if _G.ESP.current.partHighlight then _G.ESP.current.partHighlight:Destroy(); _G.ESP.current.partHighlight=nil end
end

function _G.updateHighest()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    _G.clearVisuals()
    local bestVal,bestOverhead,bestOwner = -1,nil,nil
    for _,plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotBest = -1
            for _,obj in ipairs(plot:GetDescendants()) do
                if obj.Name=="AnimalOverhead" and obj:IsA("BillboardGui") then
                    local gen = obj:FindFirstChild("Generation")
                    if gen and gen:IsA("TextLabel") then
                        local val = _G.parseGen(gen.Text)
                        if val>plotBest then plotBest=val; bestOverhead=obj end
                    end
                end
            end
            if bestOverhead and plotBest>bestVal then
                local sign = plot:FindFirstChild("PlotSign",true)
                local label = sign and sign:FindFirstChildWhichIsA("TextLabel",true)
                local owner = label and label.Text:gsub("[''']s$",""):gsub("%s+$","")
                if owner and string.lower(owner)~=string.lower(player.Name) then
                    bestVal=plotBest; bestOwner=owner
                end
            end
        end
    end
    if not bestOverhead then return end
    _G.ESP.current.overhead=bestOverhead; _G.ESP.current.maxVal=bestVal; _G.ESP.current.owner=bestOwner
    local displayName=bestOverhead:FindFirstChild("DisplayName")
    if not displayName then return end
    local parent=bestOverhead.Parent
    for _=1,4 do parent=parent and parent.Parent end
    local target=nil
    for i=0,2 do
        local candidate=parent
        for _=1,i do candidate=candidate and candidate.Parent end
        if candidate then
            local child=candidate:FindFirstChild(displayName.Text)
            if child then target=child; break end
        end
    end
    if not target then return end
    local highlight=Instance.new("Highlight")
    highlight.Adornee=target; highlight.FillTransparency=0.75; highlight.FillColor=Color3.fromRGB(255,0,0)
    highlight.OutlineTransparency=0; highlight.OutlineColor=Color3.fromRGB(255,0,0)
    highlight.Parent=target
    _G.ESP.current.modelHighlight=highlight
    local part=target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart",true)
    if part then
        local ph=Instance.new("Highlight")
        ph.Adornee=part; ph.FillTransparency=0.75; ph.FillColor=Color3.fromRGB(255,0,0)
        ph.OutlineTransparency=0; ph.OutlineColor=Color3.fromRGB(255,0,0)
        ph.Parent=workspace
        _G.ESP.current.partHighlight=ph
    end
end

task.spawn(function()
    while true do _G.updateHighest(); task.wait(2) end
end)

for _,plr in ipairs(Players:GetPlayers()) do
    if plr~=player and plr.Character then
        local hl=Instance.new("Highlight")
        hl.Adornee=plr.Character; hl.FillColor=Color3.fromRGB(173,216,230)
        hl.FillTransparency=0.75; hl.OutlineTransparency=0
        hl.OutlineColor=Color3.fromRGB(173,216,230); hl.Parent=plr.Character
        _G.ESP.playerHighlights[plr]=hl
    end
end

-- ══════════════════════════════════════════════════════
-- استعادة حالات التوقل عند التشغيل
-- ══════════════════════════════════════════════════════
task.wait(2)
pcall(function() _G.saveUIState() end)

task.spawn(function()
    while true do task.wait(3)
        pcall(function() _G.saveUIState() end)
    end
end)

task.wait(1)
pcall(function() _G.applyLoadedToggleStates() end)

task.wait(0.5)
pcall(function() _G.saveUIState() end)

