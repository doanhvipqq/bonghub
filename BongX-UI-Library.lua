--[[ 
    ✨ BÓNG X UI LIBRARY V3.1 - REDZ CORE + FLUENT UI ✨
    Core Logic: Based on RedzHub (Compatibility 100%)
    UI Style: Fluent Design (Bóng X Premium)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- [1] REDZ LIBRARY CORE DATA
local BongXLib = {
    Themes = {
        Darker = {
            ["Color Hub 1"] = Color3.fromRGB(20, 20, 25),
            ["Color Hub 2"] = Color3.fromRGB(25, 25, 30),
            ["Color Stroke"] = Color3.fromRGB(50, 50, 55),
            ["Color Theme"] = Color3.fromRGB(138, 43, 226), -- BongX Purple
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
        },
        Purple = { -- Override Purple to match BongX Style
            ["Color Hub 1"] = Color3.fromRGB(20, 20, 25),
            ["Color Hub 2"] = Color3.fromRGB(25, 25, 30),
            ["Color Stroke"] = Color3.fromRGB(50, 50, 55),
            ["Color Theme"] = Color3.fromRGB(138, 43, 226),
            ["Color Text"] = Color3.fromRGB(240, 240, 240),
            ["Color Dark Text"] = Color3.fromRGB(150, 150, 150)
        } 
    },
    Save = {Theme = "Purple"},
    Icons = {
        ["home"] = "rbxassetid://10709782430",
        ["settings"] = "rbxassetid://10734950309",
        ["sword"] = "rbxassetid://10709769508",
        ["info"] = "rbxassetid://10709791437",
        ["list"] = "rbxassetid://10709791437",
        -- Add more common icons mapped to placeholders to prevent errors
        ["user"] = "rbxassetid://10747822677", 
        ["search"] = "rbxassetid://10709805144",
        ["play"] = "rbxassetid://10709798475",
        ["layers"] = "rbxassetid://10709794837",
        ["code"] = "rbxassetid://10709762692"
    }
}

-- [2] UTILITY FUNCTIONS
local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for K, V in pairs(Properties or {}) do Object[K] = V end
    for _, Child in pairs(Children or {}) do Child.Parent = Object end
    return Object
end

local function MakeDraggable(TopBar, Main)
    local Dragging, DragInput, DragStart, StartPos
    TopBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Main.Position
            Input.Changed:Connect(function() if Input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    TopBar.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Dragging and Input == DragInput then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

-- [3] MAIN WINDOW FUNCTION
function BongXLib:MakeWindow(Config)
    local Title = Config.Title or Config[1] or "Bóng X Hub"
    local SubTitle = Config.SubTitle or Config[2] or "by Trần Đức Doanh"
    local SaveCfg = Config.SaveFolder or Config[3]

    -- Theme Loading
    local Theme = BongXLib.Themes[BongXLib.Save.Theme] or BongXLib.Themes.Purple

    if CoreGui:FindFirstChild("BongX_V3_RedzCore") then CoreGui.BongX_V3_RedzCore:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "BongX_V3_RedzCore", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})

    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme["Color Hub 1"],
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -325, 0.5, -200),
        Size = UDim2.new(0, 650, 0, 400),
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = Theme["Color Stroke"], Thickness = 1})

    -- Draggable Top
    local TopBar = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    })
    MakeDraggable(TopBar, Main)

    -- Sidebar Container (Fluent Style)
    local Sidebar = Create("ScrollingFrame", {
        Parent = Main,
        BackgroundColor3 = Theme["Color Hub 2"],
        BorderSizePixel = 0,
        Size = UDim2.new(0, 170, 1, 0),
        ScrollBarThickness = 0
    })
    
    -- Hub Title
    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -15, 0, 25),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = Theme["Color Text"],
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 40),
        Size = UDim2.new(1, -15, 0, 15),
        Font = Enum.Font.Gotham,
        Text = SubTitle,
        TextColor3 = Theme["Color Dark Text"],
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabContainer = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 70),
        Size = UDim2.new(1, 0, 1, -70)
    })
    Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})
    Create("UIPadding", {Parent = TabContainer, PaddingLeft = UDim.new(0, 10)})

    -- Content Container
    local Content = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 0),
        Size = UDim2.new(1, -170, 1, 0),
        ClipsDescendants = true
    })

    local Window = {Tabs = {}}

    function Window:Minimize(Val)
        ScreenGui.Enabled = not Val
    end
    
    -- [4] TAB FUNCTION
    function Window:MakeTab(Config)
        local TabName = Config.Title or Config[1] or "Tab"
        local TabIcon = Config.Icon or Config[2] or ""
        
        -- Resolve Icon
        if BongXLib.Icons[TabIcon] then TabIcon = BongXLib.Icons[TabIcon]
        elseif not TabIcon:find("rbxassetid") then TabIcon = "" end -- Safety

        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundColor3 = Theme["Color Hub 1"],
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 150, 0, 40),
            Text = "",
            AutoButtonColor = false
        })
        Create("UICorner", {Parent = TabBtn, CornerRadius = UDim.new(0, 6)})
        
        -- Icon
        if TabIcon ~= "" then
            Create("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = TabIcon,
                ImageColor3 = Theme["Color Dark Text"]
            })
        end

        local TabTitle = Create("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, TabIcon ~= "" and 38 or 15, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Theme["Color Dark Text"],
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local Page = Create("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme["Color Theme"]
        })
        Create("UIListLayout", {Parent = Page, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8)})
        Create("UIPadding", {Parent = Page, PaddingTop = UDim.new(0, 15), PaddingLeft = UDim.new(0, 15), PaddingRight = UDim.new(0, 15)})
        
        -- Auto Canvas Resize
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, Page.UIListLayout.AbsoluteContentSize.Y + 30)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                T.Btn.BackgroundTransparency = 1
                T.Btn.Title.TextColor3 = Theme["Color Dark Text"]
                if T.Btn:FindFirstChild("ImageLabel") then T.Btn.ImageLabel.ImageColor3 = Theme["Color Dark Text"] end
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = Theme["Color Theme"]
            TabTitle.TextColor3 = Theme["Color Text"]
            if TabBtn:FindFirstChild("ImageLabel") then TabBtn.ImageLabel.ImageColor3 = Theme["Color Text"] end
        end)

        -- Select first tab
        if #Window.Tabs == 0 then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Theme["Color Theme"]
            TabBtn.BackgroundTransparency = 0
            TabTitle.TextColor3 = Theme["Color Text"]
            if TabBtn:FindFirstChild("ImageLabel") then TabBtn.ImageLabel.ImageColor3 = Theme["Color Text"] end
        end

        table.insert(Window.Tabs, {Btn = TabBtn, Page = Page})
        TabBtn.Name = TabName
        TabTitle.Name = "Title"

        local TabObj = {}

        -- [5] ELEMENTS (Redz Compatible)
        
        function TabObj:AddSection(Config)
            local Text = type(Config) == "table" and (Config.Title or Config[1]) or Config
            local F = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Size = UDim2.new(1,0,0,25)})
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -5, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Text,
                TextColor3 = Theme["Color Text"],
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        end

        function TabObj:AddParagraph(Config)
            local Title = Config.Title or Config[1] or ""
            local Content = Config.Content or Config[2] or ""
            
            local F = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 0), -- Auto Resize
                AutomaticSize = Enum.AutomaticSize.Y
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            Create("UIPadding", {Parent = F, PaddingTop=UDim.new(0,10), PaddingBottom=UDim.new(0,10), PaddingLeft=UDim.new(0,10)})
            
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = Title,
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local D = Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 22),
                Size = UDim2.new(1, -10, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Font = Enum.Font.Gotham,
                Text = Content,
                TextColor3 = Theme["Color Dark Text"],
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })
            
            local P = {}
            function P:Set(v) D.Text = v end
            return P
        end

        function TabObj:AddButton(Config)
            local Name = Config.Name or Config[1]
            local Callback = Config.Callback or Config[2] or function() end
            
            local B = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 35),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = B, CornerRadius = UDim.new(0, 6)})
            
            B.MouseButton1Click:Connect(function()
                TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Theme["Color Stroke"]}):Play()
                task.wait(0.1)
                TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Theme["Color Hub 2"]}):Play()
                pcall(Callback)
            end)
        end

        function TabObj:AddToggle(Config)
            local Name = Config.Name or Config[1]
            local Default = Config.Default or Config[2] or false
            local Callback = Config.Callback or function() end
            
            local F = Create("TextButton", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Switch = Create("Frame", {
                Parent = F,
                BackgroundColor3 = Default and Theme["Color Theme"] or Theme["Color Stroke"],
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Dot = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.new(1, 1, 1),
                Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})
            
            local State = Default
            
            local function Update()
                State = not State
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme["Color Theme"] or Theme["Color Stroke"]}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, State)
            end
            
            F.MouseButton1Click:Connect(Update)
            
            local T = {}
            function T:Set(v) 
                State = v
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme["Color Theme"] or Theme["Color Stroke"]}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, State)
            end
            return T
        end

        function TabObj:AddSlider(Config)
            local Name = Config.Name or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or Min
            local Callback = Config.Callback or function() end
            
            local F = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local ValLbl = Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 5),
                Size = UDim2.new(0, 40, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(Default),
                TextColor3 = Theme["Color Dark Text"],
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })
            
            local Bar = Create("TextButton", {
                Parent = F,
                BackgroundColor3 = Theme["Color Stroke"],
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 6),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1, 0)})
            
            local Fill = Create("Frame", {
                Parent = Bar,
                BackgroundColor3 = Theme["Color Theme"],
                Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})
            
            local function Update(Input)
                local S = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local V = math.floor(Min + ((Max - Min) * S))
                Fill.Size = UDim2.new(S, 0, 1, 0)
                ValLbl.Text = tostring(V)
                pcall(Callback, V)
            end
            
            local Dragging = false
            Bar.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = true Update(I) end end)
            UserInputService.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
            UserInputService.InputChanged:Connect(function(I) if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then Update(I) end end)

            local S = {}
            function S:Set(v)
                local S = math.clamp((v - Min) / (Max - Min), 0, 1)
                Fill.Size = UDim2.new(S, 0, 1, 0)
                ValLbl.Text = tostring(v)
                pcall(Callback, v)
            end
            return S
        end

        function TabObj:AddTextbox(Config)
            local Name = Config.Name or "Textbox"
            local Default = Config.Default or ""
            local Callback = Config.Callback or function() end
            
            local F = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 50)
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Box = Create("TextBox", {
                Parent = F,
                BackgroundColor3 = Theme["Color Hub 1"],
                Position = UDim2.new(0, 10, 0, 28),
                Size = UDim2.new(1, -20, 0, 18),
                Font = Enum.Font.Gotham,
                Text = Default,
                TextColor3 = Theme["Color Text"],
                PlaceholderText = "Type here...",
                TextSize = 12
            })
            Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})
            
            Box.FocusLost:Connect(function() pcall(Callback, Box.Text) end)
            
            local T = {}
            function T:Set(v) Box.Text = v pcall(Callback, v) end
            return T
        end

        function TabObj:AddDropdown(Config)
            local Name = Config.Name or Config[1]
            local Options = Config.Options or Config.Values or Config[2] or {}
            local Default = Config.Default or Options[1]
            local Callback = Config.Callback or function() end
            
            local F = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Theme["Color Hub 2"],
                Size = UDim2.new(1, 0, 0, 40),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            
            local Lbl = Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -40, 0, 40),
                Font = Enum.Font.GothamMedium,
                Text = Name .. ": " .. tostring(Default),
                TextColor3 = Theme["Color Text"],
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local List = Create("Frame", {
                Parent = F,
                BackgroundColor3 = Theme["Color Hub 1"],
                Position = UDim2.new(0, 5, 0, 40),
                Size = UDim2.new(1, -10, 0, 0),
                Visible = false
            })
            Create("UICorner", {Parent = List, CornerRadius = UDim.new(0, 4)})
            Create("UIListLayout", {Parent = List, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})

            local Btn = Create("TextButton", {Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = ""})
            
            local Open = false
            Btn.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    for _, v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _, opt in pairs(Options) do
                        local O = Create("TextButton", {
                            Parent = List,
                            BackgroundColor3 = Theme["Color Hub 2"],
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Gotham,
                            Text = tostring(opt),
                            TextColor3 = Theme["Color Dark Text"],
                            TextSize = 12
                        })
                        Create("UICorner", {Parent = O, CornerRadius = UDim.new(0, 4)})
                        O.MouseButton1Click:Connect(function()
                            Open = false
                            F.Size = UDim2.new(1, 0, 0, 40)
                            List.Visible = false
                            Lbl.Text = Name .. ": " .. tostring(opt)
                            pcall(Callback, opt)
                        end)
                    end
                    F.Size = UDim2.new(1, 0, 0, 45 + (#Options * 27))
                    List.Size = UDim2.new(1, -10, 0, #Options * 27)
                else
                    F.Size = UDim2.new(1, 0, 0, 40)
                    List.Visible = false
                end
            end)
            
            local D = {}
            function D:Set(v) Lbl.Text = Name..": "..tostring(v) pcall(Callback, v) end
            function D:Refresh(O) Options = O end
            return D
        end

        function TabObj:AddDiscordInvite(Config)
            local Code = Config.Invite or Config[1] or ""
            local F = Create("Frame", {
                Parent = Page,
                BackgroundColor3 = Color3.fromRGB(88, 101, 242),
                Size = UDim2.new(1, 0, 0, 40)
            })
            Create("UICorner", {Parent = F, CornerRadius = UDim.new(0, 6)})
            Create("TextLabel", {
                Parent = F,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = "Join Discord",
                TextColor3 = Color3.new(1,1,1),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            local Btn = Create("TextButton", {
                Parent = F,
                BackgroundColor3 = Color3.new(1,1,1),
                Position = UDim2.new(1, -80, 0.5, -12),
                Size = UDim2.new(0, 70, 0, 24),
                Text = "Join",
                Font = Enum.Font.GothamBold,
                TextColor3 = Color3.fromRGB(88, 101, 242),
                TextSize = 12
            })
            Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
            Btn.MouseButton1Click:Connect(function() setclipboard(Code) end)
        end

        return TabObj
    end

    return Window
end

return BongXLib
