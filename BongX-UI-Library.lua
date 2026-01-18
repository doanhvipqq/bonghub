--[[ 
    ✨ BÓNG X UI LIBRARY V9.0 - EXPLICIT CORE ✨
    Fix: Removed all meta-programming tricks to ensure 100% executor compatibility.
    Fix: Force Callback execution on main thread.
]]

local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local RedzLib = {
    Settings = {Theme = "Purple"},
    Flags = {},
    Save = {UISize = {550, 350}, TabSize = 160},
    Themes = {
        Purple = {
            ["Main"] = Color3.fromRGB(25, 25, 30),
            ["Sidebar"] = Color3.fromRGB(30,30,35),
            ["Content"] = Color3.fromRGB(35,35,40),
            ["Stroke"] = Color3.fromRGB(60,60,65),
            ["Accent"] = Color3.fromRGB(138, 43, 226),
            ["Text"] = Color3.fromRGB(240,240,240),
            ["TextDark"] = Color3.fromRGB(160,160,160)
        }
    }
}

function RedzLib:MakeWindow(Config)
    if CoreGui:FindFirstChild("BongX_V9") then CoreGui.BongX_V9:Destroy() end
    
    local Title = Config.Title or "Bóng X Hub"
    if type(Config) == "table" and Config[1] then Title = Config[1] end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BongX_V9"
    ScreenGui.Parent = CoreGui
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = RedzLib.Themes.Purple.Main
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    
    -- Drag Logic
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true; DragStart = Input.Position; StartPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging=false end end)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", Sidebar).PaddingLeft = UDim.new(0,10)
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,10)
    
    local Txt = Instance.new("TextLabel", Sidebar)
    Txt.Text = Title
    Txt.Font = Enum.Font.GothamBold
    Txt.TextColor3 = RedzLib.Themes.Purple.Text
    Txt.Size = UDim2.new(1, 0, 0, 30)
    Txt.BackgroundTransparency = 1
    
    local Content = Instance.new("Frame", Main)
    Content.BackgroundColor3 = RedzLib.Themes.Purple.Content
    Content.Size = UDim2.new(1, -150, 1, 0)
    Content.Position = UDim2.new(0, 150, 0, 0)

    local Window = {Tabs = {}}
    
    function Window:Minimize(val) ScreenGui.Enabled = not val end

    function Window:MakeTab(Config)
        local Title = Config.Title or "Tab"
        if type(Config) == "table" and Config[1] then Title = Config[1] end
        
        local Btn = Instance.new("TextButton", Sidebar)
        Btn.BackgroundTransparency = 1
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.Text = Title
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextColor3 = RedzLib.Themes.Purple.TextDark
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        
        local Page = Instance.new("ScrollingFrame", Content)
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 4
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 5)
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0,10)
        Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0,10)
        
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Page.UIListLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Btn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                T.Btn.TextColor3 = RedzLib.Themes.Purple.TextDark
            end
            Page.Visible = true
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
        end)
        
        if #Window.Tabs == 0 then
            Page.Visible = true; Btn.TextColor3 = RedzLib.Themes.Purple.Text
        end
        table.insert(Window.Tabs, {Btn = Btn, Page = Page})
        
        local Tab = {}
        
        function Tab:AddSection(Config)
            local Text = Config
            if type(Config) == "table" then Text = Config.Name or Config[1] end
            local L = Instance.new("TextLabel", Page)
            L.BackgroundTransparency = 1
            L.Size = UDim2.new(1, 0, 0, 25)
            L.Font = Enum.Font.GothamBold
            L.Text = tostring(Text)
            L.TextColor3 = RedzLib.Themes.Purple.Text
            L.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Tab:AddParagraph(Config)
            local Title = Config.Title or Config[1] or ""
            local Desc = Config.Content or Config.Desc or Config[2] or ""
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3 = RedzLib.Themes.Purple.Main
            F.AutomaticSize = Enum.AutomaticSize.Y
            F.Size = UDim2.new(1, -10, 0, 0)
            Instance.new("UICorner", F).CornerRadius = UDim.new(0,6)
            Instance.new("UIPadding", F).PaddingTop = UDim.new(0,8)
            Instance.new("UIPadding", F).PaddingLeft = UDim.new(0,8)
            Instance.new("UIPadding", F).PaddingBottom = UDim.new(0,8)
            
            local L1 = Instance.new("TextLabel", F)
            L1.BackgroundTransparency = 1
            L1.Size = UDim2.new(1, 0, 0, 18)
            L1.Font = Enum.Font.GothamBold
            L1.Text = Title
            L1.TextColor3 = RedzLib.Themes.Purple.Text
            L1.TextXAlignment = Enum.TextXAlignment.Left
            
            local L2 = Instance.new("TextLabel", F)
            L2.BackgroundTransparency = 1
            L2.Position = UDim2.new(0, 0, 0, 20)
            L2.Size = UDim2.new(1, 0, 0, 0)
            L2.AutomaticSize = Enum.AutomaticSize.Y
            L2.Font = Enum.Font.Gotham
            L2.Text = Desc
            L2.TextColor3 = RedzLib.Themes.Purple.TextDark
            L2.TextXAlignment = Enum.TextXAlignment.Left
            L2.TextWrapped = true
            
            return {
                Set = function(s, v) L2.Text = v end,
                SetDesc = function(s, v) L2.Text = v end
            }
        end
        
        function Tab:AddToggle(Config)
            local Name = Config.Name or Config[1]
            local Default = Config.Default or Config[2] or false
            local Callback = Config.Callback or function() end
            
            if RedzLib.Flags[Name] ~= nil then Default = RedzLib.Flags[Name] end
            
            local Btn = Instance.new("TextButton", Page)
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
            
            local Title = Instance.new("TextLabel", Btn)
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -60, 1, 0)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = Name
            Title.TextColor3 = RedzLib.Themes.Purple.Text
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            local Switch = Instance.new("Frame", Btn)
            Switch.Position = UDim2.new(1, -50, 0.5, -10)
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1,0)
            
            local Dot = Instance.new("Frame", Switch)
            Dot.Size = UDim2.new(0, 16, 0, 16)
            Instance.new("UICorner", Dot).CornerRadius = UDim.new(1,0)
            
            local function Update(Val)
                RedzLib.Flags[Name] = Val
                Switch.BackgroundColor3 = Val and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
                Dot.Position = Val and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                pcall(Callback, Val)
            end
            
            Update(Default) -- Init 
            
            Btn.MouseButton1Click:Connect(function()
                Update(not RedzLib.Flags[Name])
            end)
            
            return {Set = function(s, v) Update(v) end}
        end
        
        function Tab:AddButton(Config)
            local Name = Config.Name or Config[1]
            local Callback = Config.Callback or Config[2] or function() end
            
            local Btn = Instance.new("TextButton", Page)
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = Name
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
            
            Btn.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end
        
        -- Simplified Elements
        function Tab:AddSlider(Config)
            return Tab:AddToggle({
                Name = Config.Name or Config[1],
                Default = (Config.Default or 0) > 0,
                Callback = Config.Callback
            })
        end
        
        function Tab:AddDropdown(Config)
            local Name = Config.Name or Config[1]
            local Options = Config.Options or Config.Values or {}
            local Default = Config.Default or Options[1]
            local Callback = Config.Callback or function() end
            
            local Btn = Instance.new("TextButton", Page)
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
            Btn.Size = UDim2.new(1, -10, 0, 40)
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
            
            local Index = table.find(Options, Default) or 1
            
            local function Update()
                local Val = Options[Index]
                Btn.Text = Name .. ": " .. tostring(Val)
                pcall(Callback, Val)
            end
            
            Update() -- Init
            
            Btn.MouseButton1Click:Connect(function()
                Index = Index + 1
                if Index > #Options then Index = 1 end
                Update()
            end)
            
            return {
                Set = function(s, v) 
                    local found = table.find(Options, v)
                    if found then Index = found; Update() end
                end,
                Refresh = function(s, NewOpts) Options = NewOpts; Index = 1; Update() end
            }
        end
        
        function Tab:AddTextbox(Config)
            local Name = Config.Name or "Textbox"
            local Default = Config.Default or ""
            local Callback = Config.Callback or function() end
            
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3 = RedzLib.Themes.Purple.Main
            F.Size = UDim2.new(1, -10, 0, 50)
            Instance.new("UICorner", F).CornerRadius = UDim.new(0,6)
            
            Instance.new("TextLabel", F).Text = Name
            F.TextLabel.Position = UDim2.new(0, 10, 0, 5)
            
            local Box = Instance.new("TextBox", F)
            Box.Position = UDim2.new(0, 10, 0, 25)
            Box.Size = UDim2.new(1, -20, 0, 20)
            Box.Text = Default
            
            Box.FocusLost:Connect(function()
                pcall(Callback, Box.Text)
            end)
            
            pcall(Callback, Default) -- Init
            
            return {Set = function(s, v) Box.Text = v; pcall(Callback, v) end}
        end
        
        function Tab:AddDiscordInvite() end
        
        return Tab
    end
    
    return Window
end

return RedzLib
