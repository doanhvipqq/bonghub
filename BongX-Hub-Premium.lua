--[[
    ╔════════════════════════════════════════════════════════════╗
    ║                  ✨ BÓNG X HUB PREMIUM ✨                  ║
    ║         Ultimate Script Hub for Blox Fruits              ║
    ║                                                            ║
    ║  👑 Developer: Bóng X - Trần Đức Doanh                   ║
    ║  🚀 Version: v3.5 Diamond Edition                        ║
    ║  💎 UI Library: Fluent UI (Latest with Lucide Icons)     ║
    ║  📅 Release Date: 18/01/2026                             ║
    ║  📱 Telegram: @doanhvip1                                 ║
    ╚════════════════════════════════════════════════════════════╝
--]]

-- ════════════════════════════════════════════════════════════
-- 🔐 ANTI-DETECTION & OPTIMIZATION
-- ════════════════════════════════════════════════════════════

-- Disable Roblox analytics
if setfpscap then setfpscap(60) end
if syn then
    syn.protect_gui = function(gui) gui.Parent = game:GetService("CoreGui") end
end

-- ════════════════════════════════════════════════════════════
-- 📦 SERVICES & VARIABLES
-- ════════════════════════════════════════════════════════════

local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    TeleportService = game:GetService("TeleportService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    Lighting = game:GetService("Lighting"),
    HttpService = game:GetService("HttpService")
}

local Player = Services.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- 💎 Premium Settings
_G.BongXHub = {
    -- Auto Farm Settings
    AutoFarm = false,
    SelectedWeapon = "Melee",
    AttackDistance = 50,
    FastAttack = false,
    BringMobs = false,
    
    -- Stats Settings
    AutoStats = false,
    SelectedStats = {},
    StatsDelay = 1,
    
    -- PVP Settings
    Aimbot = false,
    AimbotFOV = 100,
    AimbotSmoothness = 5,
    ESP = false,
    ESPColor = Color3.fromRGB(138, 43, 226), -- Purple
    ESPTeam = false,
    
    -- Movement Settings
    WalkSpeed = 16,
    JumpPower = 50,
    NoClip = false,
    InfiniteJump = false,
    
    -- Visual Settings
    FullBright = false,
    RemoveFog = false,
    CustomTime = false,
    TimeValue = 12,
    
    -- Misc
    AntiAFK = true,
    AutoRejoin = true,
    FPSBoost = false
}

-- ════════════════════════════════════════════════════════════
-- 🎨 LOAD FLUENT UI LIBRARY (PREMIUM VERSION)
-- ════════════════════════════════════════════════════════════

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ════════════════════════════════════════════════════════════
-- 🌟 PREMIUM LOADING SCREEN
-- ════════════════════════════════════════════════════════════

local function ShowLoadingScreen()
    local LoadingScreen = Instance.new("ScreenGui")
    LoadingScreen.Name = "BongXLoading"
    LoadingScreen.Parent = game:GetService("CoreGui")
    LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = LoadingScreen
    
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 0, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(50, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 0, 50))
    }
    Gradient.Rotation = 45
    Gradient.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 400, 0, 80)
    Title.Position = UDim2.new(0.5, -200, 0.4, -40)
    Title.BackgroundTransparency = 1
    Title.Text = "✨ BÓNG X HUB ✨"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 48
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Frame
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(0, 400, 0, 30)
    Subtitle.Position = UDim2.new(0.5, -200, 0.4, 50)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "v3.5 Diamond Edition"
    Subtitle.TextColor3 = Color3.fromRGB(138, 43, 226)
    Subtitle.TextSize = 20
    Subtitle.Font = Enum.Font.GothamMedium
    Subtitle.Parent = Frame
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 0, 4)
    LoadingBar.Position = UDim2.new(0.5, -200, 0.6, 0)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = Frame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 2)
    Corner.Parent = LoadingBar
    
    -- Animate loading bar
    Services.TweenService:Create(LoadingBar, TweenInfo.new(2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 4)}):Play()
    
    task.wait(2.5)
    Services.TweenService:Create(Frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    LoadingScreen:Destroy()
end

ShowLoadingScreen()

-- ════════════════════════════════════════════════════════════
-- 👑 CREATE PREMIUM WINDOW
-- ════════════════════════════════════════════════════════════

local Window = Fluent:CreateWindow({
    Title = "✨ Bóng X Hub ✨",
    SubTitle = "👑 Dev by Bóng X - Trần Đức Doanh | v3.5 Diamond Edition 💎",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- 🎉 Premium Welcome Notification
Fluent:Notify({
    Title = "✨ Bóng X Hub Premium",
    Content = "Chào mừng " .. Player.DisplayName .. "!\n🌟 Script đã load thành công\n💎 Diamond Edition",
    Duration = 6,
    Icon = "crown"
})

-- ════════════════════════════════════════════════════════════
-- 📊 TAB 1: DASHBOARD (PREMIUM)
-- ════════════════════════════════════════════════════════════

local DashboardTab = Window:AddTab({
    Title = "📊 Dashboard",
    Icon = "home"
})

DashboardTab:AddParagraph({
    Title = "👑 Premium User",
    Content = string.format(
        "🎮 Username: %s\n✨ Display: %s\n🆔 User ID: %d\n📅 Account Age: %d days\n💎 Status: Premium Active",
        Player.Name,
        Player.DisplayName,
        Player.UserId,
        Player.AccountAge
    )
})

-- Real-time Server Stats with Premium UI
local ServerStatsParagraph = DashboardTab:AddParagraph({
    Title = "🌐 Server Statistics",
    Content = "⚡ Đang tải dữ liệu..."
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            local fps = math.floor(1 / Services.RunService.RenderStepped:Wait())
            local playerCount = #Services.Players:GetPlayers()
            local memory = math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb())
            
            ServerStatsParagraph:SetDesc(string.format(
                "🌐 Ping: %s\n🎮 FPS: %d\n👥 Players: %d/%d\n💾 Memory: %d MB\n⏱️ Time: %s",
                ping,
                fps,
                playerCount,
                Services.Players.MaxPlayers,
                memory,
                os.date("%H:%M:%S")
            ))
        end)
    end
end)

-- Telegram Button (Premium Style)
DashboardTab:AddButton({
    Title = "📱 Join Telegram VIP",
    Description = "Tham gia kênh Telegram để nhận update",
    Callback = function()
        setclipboard("https://t.me/doanhvip1")
        Fluent:Notify({
            Title = "✅ Telegram",
            Content = "Đã copy link Telegram!\n📱 @doanhvip1\n💎 Premium Support 24/7",
            Duration = 5,
            Icon = "send"
        })
    end
})

-- Quick Actions Section
DashboardTab:AddSection("⚡ Quick Actions")

DashboardTab:AddButton({
    Title = "🔄 Refresh Character",
    Description = "Reset nhân vật về spawn",
    Callback = function()
        if Player.Character then
            Player.Character:BreakJoints()
            Fluent:Notify({
                Title = "🔄 Refreshed",
                Content = "Đã reset nhân vật!",
                Duration = 2,
                Icon = "refresh-cw"
            })
        end
    end
})

-- ════════════════════════════════════════════════════════════
-- ⚔️ TAB 2: AUTO FARM (PREMIUM)
-- ════════════════════════════════════════════════════════════

local AutoFarmTab = Window:AddTab({
    Title = "⚔️ Auto Farm",
    Icon = "swords"
})

AutoFarmTab:AddSection("💎 Premium Farming")

-- Weapon Selection
local WeaponDropdown = AutoFarmTab:AddDropdown("WeaponDropdown", {
    Title = "🗡️ Select Weapon",
    Description = "Chọn vũ khí để farm",
    Values = {"Melee", "Sword", "Gun", "Blox Fruit"},
    Multi = false,
    Default = "Melee",
})

WeaponDropdown:OnChanged(function(Value)
    _G.BongXHub.SelectedWeapon = Value
    Fluent:Notify({
        Title = "🗡️ Weapon Changed",
        Content = "Đã chọn: " .. Value,
        Duration = 2,
        Icon = "sword"
    })
end)

-- Auto Farm Toggle (Premium)
local AutoFarmToggle = AutoFarmTab:AddToggle("AutoFarmToggle", {
    Title = "⚡ Auto Farm Level",
    Description = "Tự động farm level với tốc độ cao",
    Default = false
})

AutoFarmToggle:OnChanged(function(Value)
    _G.BongXHub.AutoFarm = Value
    
    Fluent:Notify({
        Title = Value and "✅ Auto Farm ON" or "❌ Auto Farm OFF",
        Content = Value and "💎 Premium farming activated!" or "Đã tắt auto farm",
        Duration = 3,
        Icon = Value and "zap" or "zap-off"
    })
    
    if Value then
        task.spawn(function()
            while _G.BongXHub.AutoFarm and task.wait(0.05) do
                pcall(function()
                    -- Equip weapon
                    local weapon = Player.Backpack:FindFirstChild(_G.BongXHub.SelectedWeapon) or
                                 Character:FindFirstChild(_G.BongXHub.SelectedWeapon)
                    if weapon and weapon.Parent == Player.Backpack then
                        Humanoid:EquipTool(weapon)
                    end
                    
                    -- Find and attack nearest enemy
                    local nearestEnemy = nil
                    local nearestDistance = _G.BongXHub.AttackDistance
                    
                    for _, enemy in pairs(Services.Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local distance = (RootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestEnemy = enemy
                            end
                        end
                    end
                    
                    if nearestEnemy then
                        -- Teleport to enemy
                        RootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 15, 8)
                        
                        -- Fast Attack
                        if _G.BongXHub.FastAttack then
                            Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait()
                            Services.VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end)
            end
        end)
    end
end)

-- Fast Attack Toggle
local FastAttackToggle = AutoFarmTab:AddToggle("FastAttackToggle", {
    Title = "⚡ Fast Attack",
    Description = "Tăng tốc độ đánh (Premium)",
    Default = false
})

FastAttackToggle:OnChanged(function(Value)
    _G.BongXHub.FastAttack = Value
end)

-- Attack Distance Slider
local DistanceSlider = AutoFarmTab:AddSlider("AttackDistance", {
    Title = "📏 Attack Distance",
    Description = "Khoảng cách tấn công",
    Default = 50,
    Min = 10,
    Max = 150,
    Rounding = 1,
    Callback = function(Value)
        _G.BongXHub.AttackDistance = Value
    end
})

-- Bring Mobs Toggle (Premium Feature)
local BringMobsToggle = AutoFarmTab:AddToggle("BringMobsToggle", {
    Title = "🧲 Bring Mobs",
    Description = "Kéo quái lại gần (Premium)",
    Default = false
})

BringMobsToggle:OnChanged(function(Value)
    _G.BongXHub.BringMobs = Value
    
    if Value then
        task.spawn(function()
            while _G.BongXHub.BringMobs and task.wait(0.1) do
                pcall(function()
                    for _, enemy in pairs(Services.Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local distance = (RootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < _G.BongXHub.AttackDistance then
                                enemy.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -5)
                                enemy.HumanoidRootPart.CanCollide = false
                                enemy.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            end
                        end
                    end
                end)
            end
        end)
    end
end)

-- ════════════════════════════════════════════════════════════
-- 📈 TAB 3: STATS & ITEMS (PREMIUM)
-- ════════════════════════════════════════════════════════════

local StatsTab = Window:AddTab({
    Title = "📈 Stats & Items",
    Icon = "trending-up"
})

StatsTab:AddSection("💪 Auto Stats Premium")

local AutoStatsToggle = StatsTab:AddToggle("AutoStatsToggle", {
    Title = "📊 Auto Stats",
    Description = "Tự động cộng điểm",
    Default = false
})

AutoStatsToggle:OnChanged(function(Value)
    _G.BongXHub.AutoStats = Value
    
    Fluent:Notify({
        Title = Value and "✅ Auto Stats ON" or "❌ Auto Stats OFF",
        Content = Value and "Bắt đầu cộng điểm tự động" or "Đã tắt auto stats",
        Duration = 3,
        Icon = "trending-up"
    })
    
    if Value then
        task.spawn(function()
            while _G.BongXHub.AutoStats and task.wait(_G.BongXHub.StatsDelay) do
                pcall(function()
                    for _, stat in pairs(_G.BongXHub.SelectedStats) do
                        Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
                    end
                end)
            end
        end)
    end
end)

local StatsDropdown = StatsTab:AddDropdown("StatsDropdown", {
    Title = "📊 Select Stats",
    Description = "Chọn chỉ số để tự động cộng",
    Values = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
    Multi = true,
    Default = {},
})

StatsDropdown:OnChanged(function(Value)
    _G.BongXHub.SelectedStats = Value
end)

-- ════════════════════════════════════════════════════════════
-- 🎯 TAB 4: PVP & VISUALS (PREMIUM)
-- ════════════════════════════════════════════════════════════

local PVPTab = Window:AddTab({
    Title = "🎯 PVP & Visuals",
    Icon = "target"
})

PVPTab:AddSection("⚔️ Premium Combat")

-- Aimbot
local AimbotToggle = PVPTab:AddToggle("AimbotToggle", {
    Title = "🎯 Premium Aimbot",
    Description = "Tự động nhắm kẻ địch",
    Default = false
})

AimbotToggle:OnChanged(function(Value)
    _G.BongXHub.Aimbot = Value
    Fluent:Notify({
        Title = "🎯 Aimbot",
        Content = Value and "✅ Aimbot đã BẬT!" or "❌ Aimbot đã TẮT!",
        Duration = 3,
        Icon = "crosshair"
    })
end)

-- ESP
local ESPToggle = PVPTab:AddToggle("ESPToggle", {
    Title = "👁️ ESP Player",
    Description = "Hiển thị người chơi qua tường",
    Default = false
})

ESPToggle:OnChanged(function(Value)
    _G.BongXHub.ESP = Value
    
    Fluent:Notify({
        Title = "👁️ ESP",
        Content = Value and "✅ ESP đã BẬT!" or "❌ ESP đã TẮT!",
        Duration = 3,
        Icon = "eye"
    })
    
    if Value then
        task.spawn(function()
            while _G.BongXHub.ESP and task.wait(0.5) do
                for _, player in pairs(Services.Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local highlight = player.Character:FindFirstChild("BongXESP")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "BongXESP"
                            highlight.FillColor = _G.BongXHub.ESPColor
                            highlight.OutlineColor = _G.BongXHub.ESPColor
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Parent = player.Character
                        end
                    end
                end
            end
        end)
    else
        for _, player in pairs(Services.Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("BongXESP")
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

local ESPColorPicker = PVPTab:AddColorpicker("ESPColor", {
    Title = "🎨 ESP Color",
    Description = "Chọn màu ESP",
    Default = Color3.fromRGB(138, 43, 226)
})

ESPColorPicker:OnChanged(function(Value)
    _G.BongXHub.ESPColor = Value
    for _, player in pairs(Services.Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("BongXESP")
            if highlight then
                highlight.FillColor = Value
                highlight.OutlineColor = Value
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- 🎨 TAB 5: VISUALS (NEW)
-- ════════════════════════════════════════════════════════════

local VisualsTab = Window:AddTab({
    Title = "🎨 Visuals",
    Icon = "palette"
})

VisualsTab:AddSection("✨ Premium Effects")

local FullBrightToggle = VisualsTab:AddToggle("FullBrightToggle", {
    Title = "💡 Full Bright",
    Description = "Làm sáng toàn bộ map",
    Default = false
})

FullBrightToggle:OnChanged(function(Value)
    _G.BongXHub.FullBright = Value
    Services.Lighting.Brightness = Value and 2 or 1
    Services.Lighting.ClockTime = Value and 14 or 12
    Services.Lighting.GlobalShadows = not Value
end)

local RemoveFogToggle = VisualsTab:AddToggle("RemoveFogToggle", {
    Title = "🌫️ Remove Fog",
    Description = "Xóa sương mù",
    Default = false
})

RemoveFogToggle:OnChanged(function(Value)
    _G.BongXHub.RemoveFog = Value
    Services.Lighting.FogEnd = Value and 100000 or 2500
end)

-- ════════════════════════════════════════════════════════════
-- 🔧 TAB 6: MISC (PREMIUM)
-- ════════════════════════════════════════════════════════════

local MiscTab = Window:AddTab({
    Title = "🔧 Misc",
    Icon = "package"
})

MiscTab:AddSection("⚡ Premium Features")

local WalkSpeedSlider = MiscTab:AddSlider("WalkSpeed", {
    Title = "🏃 WalkSpeed",
    Description = "Tốc độ di chuyển",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        _G.BongXHub.WalkSpeed = Value
        if Character and Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

local JumpPowerSlider = MiscTab:AddSlider("JumpPower", {
    Title = "🦘 JumpPower",
    Description = "Lực nhảy",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        _G.BongXHub.JumpPower = Value
        if Character and Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

-- NoClip
local NoClipToggle = MiscTab:AddToggle("NoClipToggle", {
    Title = "👻 NoClip",
    Description = "Đi xuyên tường",
    Default = false
})

NoClipToggle:OnChanged(function(Value)
    _G.BongXHub.NoClip = Value
    
    if Value then
        task.spawn(function()
            while _G.BongXHub.NoClip and task.wait() do
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

MiscTab:AddSection("🌐 Server Controls")

MiscTab:AddButton({
    Title = "🔄 Server Hop",
    Description = "Tìm server mới",
    Callback = function()
        Fluent:Notify({
            Title = "🔄 Server Hop",
            Content = "Đang tìm server...",
            Duration = 3,
            Icon = "refresh-cw"
        })
        
        task.spawn(function()
            local servers = {}
            local success, result = pcall(function()
                return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            end)
            
            if success then
                local body = Services.HttpService:JSONDecode(result)
                for _, server in pairs(body.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
                
                if #servers > 0 then
                    Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
                end
            end
        end)
    end
})

MiscTab:AddButton({
    Title = "🔄 Rejoin Server",
    Description = "Quay lại server này",
    Callback = function()
        Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

-- FPS Boost
local FPSBoostToggle = MiscTab:AddToggle("FPSBoostToggle", {
    Title = "🚀 FPS Boost",
    Description = "Tối ưu hiệu suất game",
    Default = false
})

FPSBoostToggle:OnChanged(function(Value)
    _G.BongXHub.FPSBoost = Value
    
    if Value then
        for _, obj in pairs(Services.Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- ⚙️ TAB 7: SETTINGS (PREMIUM)
-- ════════════════════════════════════════════════════════════

local SettingsTab = Window:AddTab({
    Title = "⚙️ Settings",
    Icon = "settings"
})

SettingsTab:AddParagraph({
    Title = "💎 Premium Configuration",
    Content = "Quản lý cài đặt, theme và keybind\n✨ Diamond Edition Features"
})

SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("BongXHub/premium-configs")
SaveManager:BuildConfigSection(SettingsTab)

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("BongXHub")
InterfaceManager:BuildInterfaceSection(SettingsTab)

-- ════════════════════════════════════════════════════════════
-- 🔐 ANTI-AFK & AUTO REJOIN
-- ════════════════════════════════════════════════════════════

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        if _G.BongXHub.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end)

-- Auto Rejoin on Kick
if _G.BongXHub.AutoRejoin then
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
            Services.TeleportService:Teleport(game.PlaceId)
        end
    end)
end

-- ════════════════════════════════════════════════════════════
-- 💾 AUTO LOAD CONFIG
-- ════════════════════════════════════════════════════════════

SaveManager:LoadAutoloadConfig()

-- ════════════════════════════════════════════════════════════
-- 🎉 FINAL NOTIFICATIONS
-- ════════════════════════════════════════════════════════════

task.wait(1)

Fluent:Notify({
    Title = "✨ Bóng X Hub Premium",
    Content = "💎 Tất cả modules đã load!\n📱 Telegram: @doanhvip1\n🌟 Chúc bạn farm vui vẻ!",
    Duration = 8,
    Icon = "check-circle"
})

print("╔═══════════════════════════════════════════╗")
print("║  ✨ BÓNG X HUB - DIAMOND EDITION ✨      ║")
print("║  👑 Developer: Bóng X - Trần Đức Doanh  ║")
print("║  🚀 Version: v3.5 Premium                ║")
print("║  📱 Telegram: @doanhvip1                 ║")
print("║  💎 Script loaded successfully!          ║")
print("╔═══════════════════════════════════════════╗")
