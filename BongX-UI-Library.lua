--[[
    ╔════════════════════════════════════════════════════════════╗
    ║              🎨 BÓNG X UI LIBRARY v1.0 🎨                 ║
    ║        Compatible with RedzHub API Structure             ║
    ║                                                            ║
    ║  👑 Developer: Bóng X - Trần Đức Doanh                   ║
    ║  🚀 Based on: RedzHub Framework                          ║
    ║  📅 Release: 18/01/2026                                   ║
    ║  📱 Telegram: @doanhvip1                                 ║
    ╚════════════════════════════════════════════════════════════╝
    
    USAGE:
    local Library = loadstring(game:HttpGet("YOUR_GITHUB_RAW_URL"))()
    
    local Window = Library:MakeWindow({
        Title = "Hub Name",
        SubTitle = "by Author",
        SaveFolder = "config.json"
    })
    
    local Tab = Window:MakeTab({
        Title = "Tab Name",
        Icon = "icon_name"
    })
--]]

-- ════════════════════════════════════════════════════════════
-- 🔧 SERVICES
-- ════════════════════════════════════════════════════════════

local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerMouse = Player:GetMouse()

-- ════════════════════════════════════════════════════════════
-- 🎨 BÓNG X UI LIBRARY
-- ════════════════════════════════════════════════════════════

local BongXLib = {
    Themes = {
        Darker = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(25, 25, 25)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32, 32, 32)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(25, 25, 25))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(138, 43, 226), -- Purple (Bóng X signature)
            ["Color Text"] = Color3.fromRGB(243, 243, 243),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        },
        Dark = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 40)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(47, 47, 47)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 40))
            }),
            ["Color Hub 2"] = Color3.fromRGB(45, 45, 45),
            ["Color Stroke"] = Color3.fromRGB(65, 65, 65),
            ["Color Theme"] = Color3.fromRGB(65, 150, 255),
            ["Color Text"] = Color3.fromRGB(245, 245, 245),
            ["Color Dark Text"] = Color3.fromRGB(190, 190, 190)
        },
        Purple = {
            ["Color Hub 1"] = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(27, 25, 30)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(32, 32, 32)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(27, 25, 30))
            }),
            ["Color Hub 2"] = Color3.fromRGB(30, 30, 30),
            ["Color Stroke"] = Color3.fromRGB(40, 40, 40),
            ["Color Theme"] = Color3.fromRGB(150, 0, 255),
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(180, 180, 180)
        }
    },
    Info = {
        Version = "1.0.0 - Bóng X Edition"
    },
    Save = {
        UISize = {550, 380},
        TabSize = 160,
        Theme = "Darker"
    },
    Settings = {},
    Connection = {},
    Instances = {},
    Elements = {},
    Options = {},
    Flags = {},
    Tabs = {},
    Icons = {}
}

-- ════════════════════════════════════════════════════════════
-- 📦 ICON LIBRARY (Lucide Icons)
-- ════════════════════════════════════════════════════════════

BongXLib.Icons = {
    ["home"] = "rbxassetid://10723407389",
    ["info"] = "rbxassetid://10723407389",
    ["settings"] = "rbxassetid://10734950309",
    ["swords"] = "rbxassetid://7733960981",
    ["package"] = "rbxassetid://10709783577",
    ["waves"] = "rbxassetid://10723407389",
    ["tent"] = "rbxassetid://10723407389",
    ["locate"] = "rbxassetid://10723407389",
    ["shield"] = "rbxassetid://10723407389",
    ["zap"] = "rbxassetid://10723407389",
    ["check"] = "rbxassetid://10709790644",
    ["x"] = "rbxassetid://10747372992",
    ["crown"] = "rbxassetid://10723407389",
    ["star"] = "rbxassetid://10723407389",
}

-- ════════════════════════════════════════════════════════════
-- 🛠️ UTILITY FUNCTIONS
-- ════════════════════════════════════════════════════════════

local UIScale = 1

local function Create(ClassName, Parent, Properties)
    local Object = Instance.new(ClassName)
    if Parent then Object.Parent = Parent end
    if Properties then
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
    end
    return Object
end

local function SetProps(Instance, Properties)
    for Property, Value in pairs(Properties) do
        Instance[Property] = Value
    end
    return Instance
end

local function GetStr(val)
    if type(val) == "function" then
        return val()
    end
    return val
end

local function CreateTween(Configs)
    local Instance = Configs[1] or Configs.Instance
    local Prop = Configs[2] or Configs.Prop
    local NewVal = Configs[3] or Configs.NewVal
    local Time = Configs[4] or Configs.Time or 0.5
    local TweenWait = Configs[5] or Configs.wait or false
    local TweenInfo = TweenInfo.new(Time, Enum.EasingStyle.Quint)

    local Tween = TweenService:Create(Instance, TweenInfo, {[Prop] = NewVal})
    Tween:Play()
    if TweenWait then
        Tween.Completed:Wait()
    end
    return Tween
end

-- ════════════════════════════════════════════════════════════
-- 🎨 MAIN LIBRARY FUNCTIONS
-- ════════════════════════════════════════════════════════════

function BongXLib:MakeWindow(Configs)
    local WindowTitle = Configs.Title or Configs[1] or "Bóng X Hub"
    local WindowSubTitle = Configs.SubTitle or "by Bóng X - Trần Đức Doanh"
    local SaveFolder = Configs.SaveFolder or "BongX_Config.json"
    
    -- Create ScreenGui
    local ScreenGui = Create("ScreenGui", CoreGui, {
        Name = "BongX Library",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Find and remove existing
    local ScreenFind = CoreGui:FindFirstChild(ScreenGui.Name)
    if ScreenFind and ScreenFind ~= ScreenGui then
        ScreenFind:Destroy()
    end
    
    -- Main Window Frame
    local MainFrame = Create("Frame", ScreenGui, {
        Size = UDim2.new(0, BongXLib.Save.UISize[1], 0, BongXLib.Save.UISize[2]),
        Position = UDim2.new(0.5, -BongXLib.Save.UISize[1]/2, 0.5, -BongXLib.Save.UISize[2]/2),
        BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
        BorderSizePixel = 0,
        Active = true,
        Draggable = true
    })
    
    -- Corner
    Create("UICorner", MainFrame, {
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Stroke
    Create("UIStroke", MainFrame, {
        Color = BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"],
        Thickness = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    
    -- Title Bar
    local TitleBar = Create("Frame", MainFrame, {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    })
    
    local TitleLabel = Create("TextLabel", TitleBar, {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowTitle,
        TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SubTitleLabel = Create("TextLabel", TitleBar, {
        Size = UDim2.new(1, -20, 0, 15),
        Position = UDim2.new(0, 10, 0, 25),
        BackgroundTransparency = 1,
        Text = WindowSubTitle,
        TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Tab Container
    local TabContainer = Create("Frame", MainFrame, {
        Size = UDim2.new(0, BongXLib.Save.TabSize, 1, -50),
        Position = UDim2.new(0, 5, 0, 45),
        BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
        BorderSizePixel = 0
    })
    
    Create("UICorner", TabContainer, {CornerRadius = UDim.new(0, 6)})
    
    local TabList = Create("UIListLayout", TabContainer, {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content Container
    local ContentContainer = Create("Frame", MainFrame, {
        Size = UDim2.new(1, -(BongXLib.Save.TabSize + 15), 1, -50),
        Position = UDim2.new(0, BongXLib.Save.TabSize + 10, 0, 45),
        BackgroundTransparency = 1
    })
    
    -- Window Object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Minimized = false
    }
    
    function Window:MakeTab(TabConfigs)
        local TabName = TabConfigs.Title or TabConfigs[1] or "Tab"
        local TabIcon = TabConfigs.Icon or "info"
        
        -- Tab Button
        local TabButton = Create("TextButton", TabContainer, {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false
        })
        
        Create("UICorner", TabButton, {CornerRadius = UDim.new(0, 6)})
        
        local TabLabel = Create("TextLabel", TabButton, {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Tab Content
        local TabContent = Create("ScrollingFrame", ContentContainer, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            BorderSizePixel = 0,
            Visible = false
        })
        
        local ContentList = Create("UIListLayout", TabContent, {
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Object
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Enabled = false
        }
        
        local function SelectTab()
            for _, t in pairs(Window.Tabs) do
                t:Disable()
            end
            Tab:Enable()
        end
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        function Tab:Enable()
            self.Enabled = true
            TabContent.Visible = true
            TabLabel.TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"]
            TabButton.BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"]
            Window.CurrentTab = self
        end
        
        function Tab:Disable()
            self.Enabled = false
            TabContent.Visible = false
            TabLabel.TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"]
            TabButton.BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"]
        end
        
        function Tab:AddSection(SectionName)
            local SectionText = type(SectionName) == "string" and SectionName or SectionName[1] or "Section"
            
            local Section = Create("TextLabel", TabContent, {
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = SectionText,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return Section
        end
        
        function Tab:AddParagraph(Configs)
            local PTitle = Configs.Title or Configs[1] or "Paragraph"
            local PContent = Configs.Content or Configs[2] or ""
            
            local Frame = Create("Frame", TabContent, {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0
            })
            
            Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
            
            local Title = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Text = PTitle,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top
            })
            
            local Desc = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -10, 1, -25),
                Position = UDim2.new(0, 5, 0, 25),
                BackgroundTransparency = 1,
                Text = PContent,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
                TextSize = 11,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true
            })
            
            local Paragraph = {}
            
            function Paragraph:SetTitle(NewTitle)
                Title.Text = GetStr(NewTitle)
            end
            
            function Paragraph:SetDesc(NewDesc)
                Desc.Text = GetStr(NewDesc)
                -- Auto resize
                local textSize = game:GetService("TextService"):GetTextSize(
                    Desc.Text, 
                    Desc.TextSize, 
                    Desc.Font, 
                    Vector2.new(Desc.AbsoluteSize.X, math.huge)
                )
                Frame.Size = UDim2.new(1, 0, 0, math.max(60, textSize.Y + 35))
            end
            
            function Paragraph:Set(NewTitle, NewDesc)
                if NewTitle then self:SetTitle(NewTitle) end
                if NewDesc then self:SetDesc(NewDesc) end
            end
            
            function Paragraph:Destroy()
                Frame:Destroy()
            end
            
            return Paragraph
        end
        
        function Tab:AddToggle(Configs)
            local TName = Configs.Name or Configs[1] or "Toggle"
            local TDesc = Configs.Description or Configs.Desc or ""
            local Default = Configs.Default or Configs[2] or false
            local Callback = Configs.Callback or function() end
            
            local Frame = Create("Frame", TabContent, {
                Size = UDim2.new(1, 0, 0, TDesc ~= "" and 50 or 35),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0
            })
            
            Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
            
            local Title = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = TName,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if TDesc ~= "" then
                Create("TextLabel", Frame, {
                    Size = UDim2.new(1, -60, 0, 15),
                    Position = UDim2.new(0, 10, 0, 25),
                    BackgroundTransparency = 1,
                    Text = TDesc,
                    TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            local ToggleFrame = Create("Frame", Frame, {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -45, 0.5, -10),
                BackgroundColor3 = Default and BongXLib.Themes[BongXLib.Save.Theme]["Color Theme"] or BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"]
            })
            
            Create("UICorner", ToggleFrame, {CornerRadius = UDim.new(1, 0)})
            
            local ToggleButton = Create("TextButton", ToggleFrame, {
                Size = UDim2.new(0, 16, 0, 16),
                Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Text = "",
                AutoButtonColor = false
            })
            
            Create("UICorner", ToggleButton, {CornerRadius = UDim.new(1, 0)})
            
            local Toggled = Default
            
            local Toggle = {}
            
            function Toggle:Set(Value)
                Toggled = Value
                CreateTween({ToggleFrame, "BackgroundColor3", Toggled and BongXLib.Themes[BongXLib.Save.Theme]["Color Theme"] or BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"], 0.3})
                CreateTween({ToggleButton, "Position", Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), 0.3})
                pcall(Callback, Toggled)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                Toggle:Set(not Toggled)
            end)
            
            function Toggle:Destroy()
                Frame:Destroy()
            end
            
            if Default then
                pcall(Callback, Default)
            end
            
            return Toggle
        end
        
        function Tab:AddDropdown(Configs)
            local DName = Configs.Name or Configs[1] or "Dropdown"
            local DDesc = Configs.Description or Configs.Desc or ""
            local Options = Configs.Options or Configs.Values or Configs[2] or {}
            local Default = Configs.Default or Configs[3] or Options[1] or ""
            local Callback = Configs.Callback or function() end
            
            local Frame = Create("Frame", TabContent, {
                Size = UDim2.new(1, 0, 0, DDesc ~= "" and 50 or 35),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0
            })
            
            Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
            
            local Title = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -120, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = DName,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if DDesc ~= "" then
                Create("TextLabel", Frame, {
                    Size = UDim2.new(1, -120, 0, 15),
                    Position = UDim2.new(0, 10, 0, 25),
                    BackgroundTransparency = 1,
                    Text = DDesc,
                    TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            local DropdownButton = Create("TextButton", Frame, {
                Size = UDim2.new(0, 110, 0, 25),
                Position = UDim2.new(1, -115, 0.5, -12.5),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"],
                Text = Default,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 12,
                Font = Enum.Font.Gotham,
                AutoButtonColor = false
            })
            
            Create("UICorner", DropdownButton, {CornerRadius = UDim.new(0, 4)})
            
            local DropdownList = Create("Frame", ScreenGui, {
                Size = UDim2.new(0, 110, 0, 0),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 10
            })
            
            Create("UICorner", DropdownList, {CornerRadius = UDim.new(0, 4)})
            Create("UIListLayout", DropdownList, {Padding = UDim.new(0, 2)})
            
            local Selected = Default
            
            local Dropdown = {}
            
            function Dropdown:Set(Value)
                Selected = Value
                DropdownButton.Text = Value
                pcall(Callback, Value)
            end
            
            function Dropdown:Refresh(NewOptions)
                Options = NewOptions
                for _, child in pairs(DropdownList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                for _, option in pairs(Options) do
                    local OptionButton = Create("TextButton", DropdownList, {
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundTransparency = 1,
                        Text = option,
                        TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                        TextSize = 11,
                        Font = Enum.Font.Gotham
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown:Set(option)
                        DropdownList.Visible = false
                    end)
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                if not DropdownList.Visible then
                    DropdownList.Visible = true
                    local buttonPos = DropdownButton.AbsolutePosition
                    DropdownList.Position = UDim2.new(0, buttonPos.X, 0, buttonPos.Y + 30)
                    DropdownList.Size = UDim2.new(0, 110, 0, #Options * 27)
                else
                    DropdownList.Visible = false
                end
            end)
            
            Dropdown:Refresh(Options)
            
            if Default ~= "" then
                pcall(Callback, Default)
            end
            
            return Dropdown
        end
        
        function Tab:AddButton(Configs)
            local BName = Configs.Name or Configs[1] or "Button"
            local BDesc = Configs.Description or Configs.Desc or ""
            local Callback = Configs.Callback or Configs[2] or function() end
            
            local Frame = Create("TextButton", TabContent, {
                Size = UDim2.new(1, 0, 0, BDesc ~= "" and 50 or 35),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })
            
            Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
            
            local Title = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = BName,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            if BDesc ~= "" then
                Create("TextLabel", Frame, {
                    Size = UDim2.new(1, -10, 0, 15),
                    Position = UDim2.new(0, 10, 0, 25),
                    BackgroundTransparency = 1,
                    Text = BDesc,
                    TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
                    TextSize = 11,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
            end
            
            Frame.MouseButton1Click:Connect(function()
                CreateTween({Frame, "BackgroundColor3", BongXLib.Themes[BongXLib.Save.Theme]["Color Stroke"], 0.1})
                task.wait(0.1)
                CreateTween({Frame, "BackgroundColor3", BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"], 0.1})
                pcall(Callback)
            end)
            
            local Button = {}
            function Button:Destroy()
                Frame:Destroy()
            end
            
            return Button
        end
        
        function Tab:AddDiscordInvite(Configs)
            local Title = Configs.Name or Configs[1] or "Discord"
            local Desc = Configs.Description or Configs.Desc or ""
            local Logo = Configs.Logo or Configs[2] or ""
            local Invite = Configs.Invite or Configs[3] or ""
            
            local Frame = Create("Frame", TabContent, {
                Size = UDim2.new(1, 0, 0, 85),
                BackgroundColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Hub 2"],
                BorderSizePixel = 0
            })
            
            Create("UICorner", Frame, {CornerRadius = UDim.new(0, 6)})
            
            local InviteLabel = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -10, 0, 15),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Text = Invite,
                TextColor3 = Color3.fromRGB(88, 101, 242),
                TextSize = 10,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ImageLabel = Create("ImageLabel", Frame, {
                Size = UDim2.new(0, 30, 0, 30),
                Position = UDim2.new(0, 7, 0, 25),
                Image = Logo,
                BackgroundTransparency = 1
            })
            
            Create("UICorner", ImageLabel, {CornerRadius = UDim.new(0, 4)})
            
            local TitleLabel = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -50, 0, 15),
                Position = UDim2.new(0, 44, 0, 25),
                BackgroundTransparency = 1,
                Text = Title,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Text"],
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local DescLabel = Create("TextLabel", Frame, {
                Size = UDim2.new(1, -50, 0, 12),
                Position = UDim2.new(0, 44, 0, 40),
                BackgroundTransparency = 1,
                Text = Desc,
                TextColor3 = BongXLib.Themes[BongXLib.Save.Theme]["Color Dark Text"],
                TextSize = 9,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
            
            local JoinButton = Create("TextButton", Frame, {
                Size = UDim2.new(1, -14, 0, 18),
                Position = UDim2.new(0.5, 0, 1, -23),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.fromRGB(88, 101, 242),
                Text = "Join",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                AutoButtonColor = false
            })
            
            Create("UICorner", JoinButton, {CornerRadius = UDim.new(0, 4)})
            
            JoinButton.MouseButton1Click:Connect(function()
                setclipboard(Invite)
            end)
            
            return Frame
        end
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            Tab:Enable()
        end
        
        return Tab
    end
    
    function Window:Minimize(State)
        self.Minimized = State
        MainFrame.Visible = not State
    end
    
    return Window
end

return BongXLib
