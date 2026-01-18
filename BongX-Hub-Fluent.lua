local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Global Variables cho Auto Farm
_G.Settings = {
    AutoFarm = false,
    SelectedWeapon = "Melee",
    AttackDistance = 50,
    AutoStats = false,
    SelectedStats = {},
    Aimbot = false,
    ESP = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkSpeed = 16,
    JumpPower = 50
}

-- ════════════════════════════════════════════════════════════
-- LOAD FLUENT UI LIBRARY
-- ════════════════════════════════════════════════════════════

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ════════════════════════════════════════════════════════════
-- CREATE MAIN WINDOW
-- ════════════════════════════════════════════════════════════

local Window = Fluent:CreateWindow({
    Title = "Bóng X Hub",
    SubTitle = "Dev by Bóng X - Trần Đức Doanh | v3.0 Premium",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Hiệu ứng mờ phía sau
    Theme = "Dark", -- Dark Theme
    MinimizeKey = Enum.KeyCode.LeftControl -- Ctrl để minimize
})

-- Notification chào mừng
Fluent:Notify({
    Title = "Bóng X Hub",
    Content = "Script đã load thành công! Chào mừng " .. Player.Name,
    Duration = 5,
    Icon = "check-circle"
})

-- ════════════════════════════════════════════════════════════
-- TAB 1: DASHBOARD
-- ════════════════════════════════════════════════════════════

local DashboardTab = Window:AddTab({
    Title = "Dashboard",
    Icon = "home"
})

-- User Info Section
DashboardTab:AddParagraph({
    Title = "👤 User Information",
    Content = string.format(
        "Username: %s\nDisplay Name: %s\nUser ID: %d\nAccount Age: %d days",
        Player.Name,
        Player.DisplayName,
        Player.UserId,
        Player.AccountAge
    )
})

-- Server Stats (Cập nhật real-time)
local ServerStatsParagraph = DashboardTab:AddParagraph({
    Title = "📊 Server Statistics",
    Content = "Loading..."
})

-- Cập nhật Server Stats mỗi giây
task.spawn(function()
    while task.wait(1) do
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local playerCount = #Players:GetPlayers()
        
        ServerStatsParagraph:SetDesc(string.format(
            "🌐 Ping: %s\n🎮 FPS: %d\n👥 Players: %d/%d\n⏱️ Time: %s",
            ping,
            fps,
            playerCount,
            Players.MaxPlayers,
            os.date("%H:%M:%S")
        ))
    end
end)

-- Telegram Button với hiệu ứng gradient
DashboardTab:AddButton({
    Title = "📱 Join Telegram Channel",
    Description = "Click để copy link Telegram vào clipboard",
    Callback = function()
        setclipboard("https://t.me/doanhvip1")
        Fluent:Notify({
            Title = "✅ Telegram",
            Content = "Đã copy link Telegram vào clipboard!\n@doanhvip1",
            Duration = 4,
            Icon = "send"
        })
    end
})

-- ════════════════════════════════════════════════════════════
-- TAB 2: AUTO FARM
-- ════════════════════════════════════════════════════════════

local AutoFarmTab = Window:AddTab({
    Title = "Auto Farm",
    Icon = "sword"
})

-- Main Farming Section
AutoFarmTab:AddSection("Main Farming")

-- Weapon Dropdown
local WeaponList = {"Melee", "Sword", "Gun", "Blox Fruit"}
local WeaponDropdown = AutoFarmTab:AddDropdown("WeaponDropdown", {
    Title = "Select Weapon",
    Description = "Chọn vũ khí để farm",
    Values = WeaponList,
    Multi = false,
    Default = "Melee",
})

WeaponDropdown:OnChanged(function(Value)
    _G.Settings.SelectedWeapon = Value
    Fluent:Notify({
        Title = "Weapon Changed",
        Content = "Đã chọn vũ khí: " .. Value,
        Duration = 2,
        Icon = "sword"
    })
end)

-- Auto Farm Toggle
local AutoFarmToggle = AutoFarmTab:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm Level",
    Description = "Tự động farm level",
    Default = false
})

AutoFarmToggle:OnChanged(function(Value)
    _G.Settings.AutoFarm = Value
    
    Fluent:Notify({
        Title = "Auto Farm",
        Content = Value and "✅ Đã BẬT Auto Farm!" or "❌ Đã TẮT Auto Farm!",
        Duration = 3,
        Icon = Value and "check" or "x"
    })
    
    -- Logic Auto Farm (giữ nguyên logic từ file cũ)
    if Value then
        task.spawn(function()
            while _G.Settings.AutoFarm and task.wait(0.1) do
                pcall(function()
                    -- Equiped weapon
                    local weapon = Player.Backpack:FindFirstChild(_G.Settings.SelectedWeapon) or
                                 Character:FindFirstChild(_G.Settings.SelectedWeapon)
                    if weapon and weapon.Parent == Player.Backpack then
                        Humanoid:EquipTool(weapon)
                    end
                    
                    -- Find nearest enemy
                    local nearestEnemy = nil
                    local nearestDistance = _G.Settings.AttackDistance
                    
                    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            local distance = (RootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestEnemy = enemy
                            end
                        end
                    end
                    
                    -- Attack enemy
                    if nearestEnemy then
                        RootPart.CFrame = nearestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 5)
                        -- Click to attack
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait()
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end)
            end
        end)
    end
end)

-- Attack Distance Slider
local DistanceSlider = AutoFarmTab:AddSlider("AttackDistance", {
    Title = "Attack Distance",
    Description = "Khoảng cách tấn công quái",
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        _G.Settings.AttackDistance = Value
    end
})

-- ════════════════════════════════════════════════════════════
-- TAB 3: STATS & ITEMS
-- ════════════════════════════════════════════════════════════

local StatsTab = Window:AddTab({
    Title = "Stats & Items",
    Icon = "trending-up"
})

-- Auto Stats Toggle
local AutoStatsToggle = StatsTab:AddToggle("AutoStatsToggle", {
    Title = "Auto Stats",
    Description = "Tự động cộng điểm",
    Default = false
})

AutoStatsToggle:OnChanged(function(Value)
    _G.Settings.AutoStats = Value
    
    Fluent:Notify({
        Title = "Auto Stats",
        Content = Value and "✅ Đã BẬT Auto Stats!" or "❌ Đã TẮT Auto Stats!",
        Duration = 3,
        Icon = Value and "check" or "x"
    })
    
    -- Logic Auto Stats
    if Value then
        task.spawn(function()
            while _G.Settings.AutoStats and task.wait(1) do
                pcall(function()
                    for _, stat in pairs(_G.Settings.SelectedStats) do
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
                    end
                end)
            end
        end)
    end
end)

-- Multi-Dropdown Stats
local StatsDropdown = StatsTab:AddDropdown("StatsDropdown", {
    Title = "Select Stats to Upgrade",
    Description = "Chọn các chỉ số để tự động cộng điểm",
    Values = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
    Multi = true,
    Default = {},
})

StatsDropdown:OnChanged(function(Value)
    _G.Settings.SelectedStats = Value
end)

-- ════════════════════════════════════════════════════════════
-- TAB 4: PVP & VISUALS
-- ════════════════════════════════════════════════════════════

local PVPTab = Window:AddTab({
    Title = "PVP & Visuals",
    Icon = "crosshair"
})

-- Aimbot Toggle
local AimbotToggle = PVPTab:AddToggle("AimbotToggle", {
    Title = "Enable Aimbot",
    Description = "Tự động nhắm kẻ địch",
    Default = false
})

AimbotToggle:OnChanged(function(Value)
    _G.Settings.Aimbot = Value
    
    Fluent:Notify({
        Title = "Aimbot",
        Content = Value and "✅ Aimbot đã BẬT!" or "❌ Aimbot đã TẮT!",
        Duration = 3,
        Icon = "crosshair"
    })
end)

-- ESP Player Toggle
local ESPToggle = PVPTab:AddToggle("ESPToggle", {
    Title = "ESP Player",
    Description = "Hiển thị người chơi qua tường",
    Default = false
})

ESPToggle:OnChanged(function(Value)
    _G.Settings.ESP = Value
    
    Fluent:Notify({
        Title = "ESP",
        Content = Value and "✅ ESP đã BẬT!" or "❌ ESP đã TẮT!",
        Duration = 3,
        Icon = "eye"
    })
    
    -- Logic ESP (cơ bản)
    if Value then
        task.spawn(function()
            while _G.Settings.ESP and task.wait(0.5) do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character then
                        local highlight = player.Character:FindFirstChild("ESPHighlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.FillColor = _G.Settings.ESPColor
                            highlight.OutlineColor = _G.Settings.ESPColor
                            highlight.Parent = player.Character
                        end
                    end
                end
            end
        end)
    else
        -- Remove all ESP
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end)

-- ESP Color Picker
local ESPColorPicker = PVPTab:AddColorpicker("ESPColor", {
    Title = "ESP Color",
    Description = "Chọn màu ESP",
    Default = Color3.fromRGB(255, 0, 0)
})

ESPColorPicker:OnChanged(function(Value)
    _G.Settings.ESPColor = Value
    
    -- Update màu ESP hiện tại
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if highlight then
                highlight.FillColor = Value
                highlight.OutlineColor = Value
            end
        end
    end
end)

-- ════════════════════════════════════════════════════════════
-- TAB 5: MISC
-- ════════════════════════════════════════════════════════════

local MiscTab = Window:AddTab({
    Title = "Misc",
    Icon = "package"
})

-- WalkSpeed Slider
local WalkSpeedSlider = MiscTab:AddSlider("WalkSpeed", {
    Title = "WalkSpeed",
    Description = "Tốc độ di chuyển",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        _G.Settings.WalkSpeed = Value
        if Character and Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

-- JumpPower Slider
local JumpPowerSlider = MiscTab:AddSlider("JumpPower", {
    Title = "JumpPower",
    Description = "Lực nhảy",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Callback = function(Value)
        _G.Settings.JumpPower = Value
        if Character and Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

-- Server Hop Button
MiscTab:AddButton({
    Title = "Server Hop",
    Description = "Nhảy sang server khác",
    Callback = function()
        Fluent:Notify({
            Title = "Server Hop",
            Content = "Đang tìm server mới...",
            Duration = 3,
            Icon = "refresh-cw"
        })
        
        task.spawn(function()
            local servers = {}
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local body = game:GetService("HttpService"):JSONDecode(req)
            
            for _, server in pairs(body.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
            
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)])
            end
        end)
    end
})

-- Rejoin Server Button
MiscTab:AddButton({
    Title = "Rejoin Server",
    Description = "Quay lại server này",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
    end
})

-- ════════════════════════════════════════════════════════════
-- TAB 6: SETTINGS
-- ════════════════════════════════════════════════════════════

local SettingsTab = Window:AddTab({
    Title = "Settings",
    Icon = "settings"
})

SettingsTab:AddParagraph({
    Title = "⚙️ Configuration",
    Content = "Quản lý cài đặt, theme và keybind"
})

-- Tích hợp SaveManager
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("BongXHub/configs")
SaveManager:BuildConfigSection(SettingsTab)

-- Tích hợp InterfaceManager
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("BongXHub")
InterfaceManager:BuildInterfaceSection(SettingsTab)

-- ════════════════════════════════════════════════════════════
-- AUTO LOAD CONFIG
-- ════════════════════════════════════════════════════════════

SaveManager:LoadAutoloadConfig()

-- ════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ════════════════════════════════════════════════════════════

task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ════════════════════════════════════════════════════════════
-- FINAL NOTIFICATION
-- ════════════════════════════════════════════════════════════

Fluent:Notify({
    Title = "Bóng X Hub",
    Content = "✅ Tất cả modules đã load thành công!",
    Duration = 5,
    Icon = "check-circle"
})

print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("║  BÓNG X HUB - v3.0 Premium               ║")
print("║  Developer: Bóng X - Trần Đức Doanh     ║")
print("║  Script loaded successfully!             ║")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
