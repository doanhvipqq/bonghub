--[[ 
    ✨ BÓNG X UI LIBRARY V2.1 FIXED - FLUENT STYLE ✨
    Tác giả: Bóng X - Trần Đức Doanh
    Fix: Black Screen, Missing Functions, Logic Errors
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local BongXLib = {
    Connections = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(23, 23, 30),
            Sidebar = Color3.fromRGB(30, 30, 40),
            Content = Color3.fromRGB(35, 35, 45),
            Stroke = Color3.fromRGB(60, 60, 70),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(180, 180, 180),
            Accent = Color3.fromRGB(138, 43, 226) -- Purple
        }
    }
}

-- Safe Create Function
local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for Key, Value in pairs(Properties or {}) do
        Object[Key] = Value
    end
    for _, Child in pairs(Children or {}) do
        Child.Parent = Object
    end
    return Object
end

function BongXLib:MakeWindow(Settings)
    local Title = Settings.Title or "Bóng X Hub"
    local SubTitle = Settings.SubTitle or "by Bóng X"
    
    -- Cleanup Old UI
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "BongX_Fluent_UI" then v:Destroy() end
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "BongX_Fluent_UI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = BongXLib.Themes.Default.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -325, 0.5, -200),
        Size = UDim2.new(0, 650, 0, 400),
        ClipsDescendants = true
    })
    
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    
    -- Draggable
    local Dragging, DragInput, DragStart, StartPos
    Main.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Main.Position
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    -- Sidebar
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = BongXLib.Themes.Default.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 160, 1, 0),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    
    -- Sidebar Title
    local TitleFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60)
    })
    
    Create("TextLabel", {
        Parent = TitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -15, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = BongXLib.Themes.Default.Text,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Create("TextLabel", {
        Parent = TitleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 35),
        Size = UDim2.new(1, -15, 0, 15),
        Font = Enum.Font.Gotham,
        Text = SubTitle,
        TextColor3 = BongXLib.Themes.Default.TextDark,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local SidebarLayout = Create("UIListLayout", {
        Parent = Sidebar,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10)})

    -- Content Area
    local Content = Create("Frame", {
        Name = "Content",
        Parent = Main,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 10),
        Size = UDim2.new(1, -180, 1, -20),
        ClipsDescendants = true
    })

    -- Window Object
    local Window = { Tabs = {} }
    
    function Window:Minimize(Val)
        ScreenGui.Enabled = not Val
    end

    function Window:MakeTab(Config)
        local TabName = Config.Title or Config[1] or "Tab"
        local TabIcon = Config.Icon or ""

        -- Tab Button
        local TabBtn = Create("TextButton", {
            Parent = Sidebar,
            BackgroundColor3 = BongXLib.Themes.Default.Main,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 140, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 8)})
        
        local TabLabel = Create("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -15, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = BongXLib.Themes.Default.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        if TabName == "Bóng X Hub" or TabName == Title then 
            SidebarLayout.Padding = UDim.new(0, 20) -- Spacing after title
            TabBtn.Visible = false -- Hide duplicate title if script adds it
        end

        local Page = Create("ScrollingFrame", {
            Name = TabName .. "_Page",
            Parent = Content,
            BackgroundColor3 = Color3.new(0,0,0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        
        Create("UIListLayout", {
            Parent = Page,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        -- Tab Selection Logic
        TabBtn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                T.Btn.BackgroundTransparency = 1
                T.Btn.TextLabel.TextColor3 = BongXLib.Themes.Default.TextDark
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = BongXLib.Themes.Default.Accent
            TabBtn.TextLabel.TextColor3 = BongXLib.Themes.Default.Text
        end)

        -- Auto Select First Tab
        if #Window.Tabs == 0 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = BongXLib.Themes.Default.Accent
            TabBtn.TextLabel.TextColor3 = BongXLib.Themes.Default.Text
        end

        table.insert(Window.Tabs, {Btn = TabBtn, Page = Page})

        local Tab = {}

        -- Section
        function Tab:AddSection(Name)
            local txt = type(Name) == "table" and Name.Name or Name
            local SecFrame = Create("Frame", {
                Parent = Page,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30)
            })
            Create("TextLabel", {
                Parent = SecFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 10),
                Size = UDim2.new(1, -10, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = txt,
                TextColor3 = BongXLib.Themes.Default.TextDark,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        -- Paragraph
        function Tab:AddParagraph(Config)
            local Title = Config.Title or Config[1] or ""
            local Desc = Config.Content or Config[2] or ""
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            Create("UIPadding", {Parent = Frame, PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10), PaddingLeft=UDim.new(0,10)})

            local T = Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = Title,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local D = Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.new(0, 0, 0, 22),
                Font = Enum.Font.Gotham,
                Text = Desc,
                TextColor3 = BongXLib.Themes.Default.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
            
            local Ret = {}
            function Ret:SetDesc(str) D.Text = str end
            return Ret
        end

        -- Toggle
        function Tab:AddToggle(Config)
            local Name = Config.Name or Config[1]
            local Default = Config.Default or Config[2] or false
            local Callback = Config.Callback or function() end
            
            local Frame = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = Default and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke,
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Dot = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.new(1,1,1),
                Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})
            
            local State = Default
            
            local function Update()
                State = not State
                pcall(Callback, State)
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = State and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            end
            
            Frame.MouseButton1Click:Connect(Update)
            
            local Ret = {}
            function Ret:Set(val) 
                State = val
                -- UI Update logic duplicated for manual set
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = State and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, State) 
            end
            return Ret
        end

        -- Button
        function Tab:AddButton(Config)
            local Name = Config.Name or Config[1]
            local Callback = Config.Callback or Config[2] or function() end
            
            local Btn = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BorderSizePixel = 0,
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BongXLib.Themes.Default.Stroke}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = BongXLib.Themes.Default.Content}):Play()
                pcall(Callback)
            end)
        end

        -- Slider
        function Tab:AddSlider(Config)
            local Name = Config.Name or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or Min
            local Callback = Config.Callback or function() end
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 50),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValLbl = Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -60, 0, 5),
                Size = UDim2.new(0, 50, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(Default),
                TextColor3 = BongXLib.Themes.Default.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local Bar = Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = BongXLib.Themes.Default.Stroke,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 6),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1,0)})
            
            local Fill = Create("Frame", {
                Parent = Bar,
                BackgroundColor3 = BongXLib.Themes.Default.Accent,
                Size = UDim2.new((Default - Min)/(Max - Min), 0, 1, 0),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})
            
            local function Update(Input)
                local SizeX = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local Val = math.floor(Min + ((Max - Min) * SizeX))
                Fill.Size = UDim2.new(SizeX, 0, 1, 0)
                ValLbl.Text = tostring(Val)
                pcall(Callback, Val)
            end
            
            local Dragging = false
            Bar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update(Input)
                end
            end)
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update(Input) end
            end)
        end

        -- Dropdown
        function Tab:AddDropdown(Config)
            local Name = Config.Name or Config[1]
            local Options = Config.Options or Config.Values or Config[2] or {}
            local Default = Config.Default or Options[1]
            local Callback = Config.Callback or function() end
            
            local Frame = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -40, 0, 40),
                Font = Enum.Font.GothamMedium,
                Text = Name .. ": " .. tostring(Default),
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local OpenBtn = Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            
            local ListHas = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = BongXLib.Themes.Default.Main,
                Position = UDim2.new(0, 5, 0, 40),
                Size = UDim2.new(1, -10, 0, 0),
                Visible = false
            })
            Create("UIListLayout", {Parent = ListHas, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
            
            local IsOpen = false
            OpenBtn.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    ListHas.Visible = true
                    for _, v in pairs(ListHas:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, opt in pairs(Options) do
                        local OptBtn = Create("TextButton", {
                            Parent = ListHas,
                            BackgroundColor3 = BongXLib.Themes.Default.Content,
                            Size = UDim2.new(1, 0, 0, 30),
                            Font = Enum.Font.Gotham,
                            Text = tostring(opt),
                            TextColor3 = BongXLib.Themes.Default.TextDark,
                            TextSize = 12
                        })
                        Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 4)})
                        OptBtn.MouseButton1Click:Connect(function()
                            IsOpen = false
                            Frame.Size = UDim2.new(1, 0, 0, 40)
                            ListHas.Visible = false
                            Frame.TextLabel.Text = Name .. ": " .. tostring(opt)
                            pcall(Callback, opt)
                        end)
                    end
                    local h = #Options * 32
                    Frame.Size = UDim2.new(1, 0, 0, 45 + h)
                    ListHas.Size = UDim2.new(1, -10, 0, h)
                else
                    Frame.Size = UDim2.new(1, 0, 0, 40)
                    ListHas.Visible = false
                end
            end)
            
            local Ret = {}
            function Ret:Set(val) Frame.TextLabel.Text = Name .. ": " .. tostring(val) pcall(Callback, val) end
            return Ret
        end
        
        -- Textbox
        function Tab:AddTextbox(Config)
             -- Minimal implementation if needed
        end
        
        -- Discord
        function Tab:AddDiscordInvite(Config)
             -- Minimal implementation if needed
        end

        return Tab
    end
    
    -- Fix for black screen: ensure visible
    ScreenGui.Enabled = true

    return Window
end

return BongXLib
