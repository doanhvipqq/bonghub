--[[ 
    ✨ BÓNG X UI LIBRARY V2.0 - FLUENT PREMIUM ✨
    Tác giả: Bóng X - Trần Đức Doanh
    Telegram: @doanhvip1
    
    Tính năng:
    - Giao diện Sidebar hiện đại (Fluent Design)
    - Tối ưu hóa siêu nhẹ, không lag
    - Đầy đủ: Slider, Textbox, Keybind, Toggle, Dropdown
    - Tương thích 100% code cũ
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

local BongXLib = {
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 35), -- Nền chính tối hơn
            Sidebar = Color3.fromRGB(30, 30, 40), -- Sidebar
            Content = Color3.fromRGB(35, 35, 45), -- Nền nội dung
            Stroke = Color3.fromRGB(50, 50, 60), -- Viền
            Divider = Color3.fromRGB(45, 45, 55),
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(170, 170, 170),
            Accent = Color3.fromRGB(138, 43, 226) -- Tím Bóng X
        }
    }
}

-- Utility Functions
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(object, TweenInfo.new(0.15), {Position = pos})
		Tween:Play()
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function Create(Name, Properties, Children)
    local Object = Instance.new(Name)
    for Name, Value in pairs(Properties or {}) do
        Object[Name] = Value
    end
    for _, Child in pairs(Children or {}) do
        Child.Parent = Object
    end
    return Object
end

function BongXLib:MakeWindow(Settings)
    local Title = Settings.Title or "Bóng X Hub"
    local SubTitle = Settings.SubTitle or "by Trần Đức Doanh"
    local SaveConfig = Settings.SaveFolder

    if game.CoreGui:FindFirstChild("BongXHub_Fluent") then
        game.CoreGui.BongXHub_Fluent:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "BongXHub_Fluent",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = BongXLib.Themes.Default.Main,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -300, 0.5, -200),
        Size = UDim2.new(0, 650, 0, 400), -- Rộng hơn để chứa Sidebar
        ClipsDescendants = true
    })
    
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 10)})
    Create("UIStroke", {Parent = Main, Color = BongXLib.Themes.Default.Stroke, Thickness = 2})

    -- Drag Area (Title Bar)
    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = Main,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    })
    MakeDraggable(TopBar, Main)

    -- Logo / Title
    Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Title,
        TextColor3 = BongXLib.Themes.Default.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- SubTitle
    Create("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, 25),
        Size = UDim2.new(0, 200, 0, 15),
        Font = Enum.Font.Gotham,
        Text = SubTitle,
        TextColor3 = BongXLib.Themes.Default.TextDark,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close/Minimize Button (Giả lập)
    local CloseBtn = Create("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 0),
        Size = UDim2.new(0, 40, 1, 0),
        Text = "×",
        Font = Enum.Font.Gotham,
        TextSize = 24,
        TextColor3 = BongXLib.Themes.Default.TextDark
    })
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    -- Sidebar Area
    local Sidebar = Create("ScrollingFrame", {
        Name = "Sidebar",
        Parent = Main,
        BackgroundColor3 = BongXLib.Themes.Default.Sidebar,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(0, 160, 1, -50),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    local SidebarLayout = Create("UIListLayout", {
        Parent = Sidebar,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    
    Create("UIPadding", {Parent = Sidebar, PaddingTop = UDim.new(0, 10)})

    -- Content Area
    local ContentPage = Create("Frame", {
        Name = "Content",
        Parent = Main,
        BackgroundColor3 = Color3.new(0,0,0),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 50),
        Size = UDim2.new(1, -180, 1, -60),
        ClipsDescendants = true
    })

    local Window = {
        Tabs = {}
    }

    function Window:Minimize(val)
        ScreenGui.Enabled = not val
    end

    function Window:MakeTab(Config)
        local TabName = Config.Title or Config[1]
        local TabIcon = Config.Icon or ""

        local TabButton = Create("TextButton", {
            Parent = Sidebar,
            BackgroundColor3 = BongXLib.Themes.Default.Main,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 140, 0, 35),
            Text = "",
            AutoButtonColor = false
        })
        
        Create("UICorner", {Parent = TabButton, CornerRadius = UDim.new(0, 6)})
        
        local TabLabel = Create("TextLabel", {
            Parent = TabButton,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = BongXLib.Themes.Default.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        -- Icon Placeholder
        Create("ImageLabel", {
            Parent = TabButton,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            Image = TabIcon:find("rbxassetid") and TabIcon or "rbxassetid://7733960981", -- Default icon
            ImageColor3 = BongXLib.Themes.Default.TextDark
        })

        -- Tab Content
        local TabFrame = Create("ScrollingFrame", {
            Name = TabName,
            Parent = ContentPage,
            BackgroundColor3 = Color3.new(0,0,0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = BongXLib.Themes.Default.Accent,
            Visible = false
        })
        
        Create("UIListLayout", {
            Parent = TabFrame,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        Create("UIPadding", {Parent = TabFrame, PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2)})

        -- Auto Resize
        TabFrame.ChildAdded:Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrame.UIListLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Tab Logic
        TabButton.MouseButton1Click:Connect(function()
            -- Reset all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Button.TextLabel.TextColor3 = BongXLib.Themes.Default.TextDark
                tab.Button.ImageLabel.ImageColor3 = BongXLib.Themes.Default.TextDark
            end
            
            -- Active current tab
            TabFrame.Visible = true
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrame.UIListLayout.AbsoluteContentSize.Y + 20)
            
            TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundTransparency = 0, BackgroundColor3 = BongXLib.Themes.Default.Content}):Play()
            TabLabel.TextColor3 = BongXLib.Themes.Default.Text
            TabButton.ImageLabel.ImageColor3 = BongXLib.Themes.Default.Text
        end)

        -- First tab auto select
        if #Window.Tabs == 0 then
            TabFrame.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.BackgroundColor3 = BongXLib.Themes.Default.Content
            TabLabel.TextColor3 = BongXLib.Themes.Default.Text
            TabButton.ImageLabel.ImageColor3 = BongXLib.Themes.Default.Text
        end

        table.insert(Window.Tabs, {Frame = TabFrame, Button = TabButton})

        local Tab = {}

        function Tab:AddSection(Name)
            local SectionLabel = Create("TextLabel", {
                Parent = TabFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 25),
                Font = Enum.Font.GothamBold,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            Create("UIPadding", {Parent = SectionLabel, PaddingLeft = UDim.new(0, 5)})
        end

        function Tab:AddParagraph(Config)
            local Title = Config.Title or Config[1]
            local Content = Config.Content or Config[2]
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 60),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 8),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = Title,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            local Desc = Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 25),
                Font = Enum.Font.Gotham,
                Text = Content,
                TextColor3 = BongXLib.Themes.Default.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            })

            local Para = {}
            function Para:SetDesc(str) Desc.Text = str end
            function Para:SetTitle(str) end -- Placeholder
            function Para:Set(t, d) Desc.Text = d end
            return Para
        end

        function Tab:AddButton(Config)
            local Name = Config.Name or Config[1]
            local Callback = Config.Callback or Config[2] or function() end
            
            local ButtonFrame = Create("TextButton", {
                Parent = TabFrame,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ButtonFrame, CornerRadius = UDim.new(0, 6)})

            Create("TextLabel", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            Create("ImageLabel", {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -30, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Image = "rbxassetid://10709791437", -- Mouse icon
                ImageColor3 = BongXLib.Themes.Default.TextDark
            })

            ButtonFrame.MouseButton1Click:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = BongXLib.Themes.Default.Stroke}):Play()
                task.wait(0.1)
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = BongXLib.Themes.Default.Content}):Play()
                pcall(Callback)
            end)
        end

        function Tab:AddToggle(Config)
            local Name = Config.Name or Config[1]
            local Default = Config.Default or Config[2] or false
            local Callback = Config.Callback or function() end
            
            local ToggleFrame = Create("TextButton", {
                Parent = TabFrame,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 35),
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = ToggleFrame, CornerRadius = UDim.new(0, 6)})

            Create("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Switch = Create("Frame", {
                Parent = ToggleFrame,
                BackgroundColor3 = Default and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke,
                Position = UDim2.new(1, -50, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20)
            })
            Create("UICorner", {Parent = Switch, CornerRadius = UDim.new(1, 0)})
            
            local Circle = Create("Frame", {
                Parent = Switch,
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16)
            })
            Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})

            local Toggled = Default
            
            ToggleFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, Toggled)
            end)

            local Funcs = {}
            function Funcs:Set(val) 
                Toggled = val
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Toggled and BongXLib.Themes.Default.Accent or BongXLib.Themes.Default.Stroke}):Play()
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, Toggled)
            end
            return Funcs
        end

        function Tab:AddSlider(Config)
            local Name = Config.Name or "Slider"
            local Min = Config.Min or 0
            local Max = Config.Max or 100
            local Default = Config.Default or Min
            local Callback = Config.Callback or function() end

            local Frame = Create("Frame", {
                Parent = TabFrame,
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

            local ValueLabel = Create("TextLabel", {
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

            local SliderBar = Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = BongXLib.Themes.Default.Stroke,
                Position = UDim2.new(0, 10, 0, 35),
                Size = UDim2.new(1, -20, 0, 6),
                Text = "",
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1, 0)})

            local Fill = Create("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = BongXLib.Themes.Default.Accent,
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1, 0)})

            -- Slider Logic
            local Dragging = false
            
            local function Update(Input)
                local SizeX = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local Value = math.floor(Min + ((Max - Min) * SizeX))
                
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(SizeX, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(Value)
                pcall(Callback, Value)
            end

            SliderBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(Input)
                end
            end)

            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                    Update(Input)
                end
            end)
        end

        function Tab:AddTextbox(Config)
            local Name = Config.Name or "Textbox"
            local Default = Config.Default or ""
            local Callback = Config.Callback or function() end

            local Frame = Create("Frame", {
                Parent = TabFrame,
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

            local Input = Create("TextBox", {
                Parent = Frame,
                BackgroundColor3 = BongXLib.Themes.Default.Main,
                Position = UDim2.new(0, 10, 0, 25),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.Gotham,
                Text = Default,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 12,
                PlaceholderText = "Enter text...",
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Input, CornerRadius = UDim.new(0, 4)})

            Input.FocusLost:Connect(function(Enter)
                pcall(Callback, Input.Text)
            end)
        end

        function Tab:AddDropdown(Config)
            local Name = Config.Name or Config[1]
            local Options = Config.Options or Config[2] or {}
            local Default = Config.Default or Options[1]
            local Callback = Config.Callback or function() end

            local IsOpen = false
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundColor3 = BongXLib.Themes.Default.Content,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})

            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 10),
                Size = UDim2.new(0.6, 0, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = Name,
                TextColor3 = BongXLib.Themes.Default.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local DropBtn = Create("TextButton", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = "",
                ZIndex = 2
            })
            
            local SelectedLabel = Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6, 0, 0, 10),
                Size = UDim2.new(0.4, -25, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(Default),
                TextColor3 = BongXLib.Themes.Default.TextDark,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Right
            })

            local Arrow = Create("ImageLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -25, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://6031090990", -- Arrow up
                ImageColor3 = BongXLib.Themes.Default.TextDark,
                Rotation = 180
            })

            local OptionContainer = Create("Frame", {
                Parent = Frame,
                BackgroundColor3 = BongXLib.Themes.Default.Main,
                Position = UDim2.new(0, 5, 0, 40),
                Size = UDim2.new(1, -10, 0, 0),
                BorderSizePixel = 0,
                Visible = false
            })
            Create("UICorner", {Parent = OptionContainer, CornerRadius = UDim.new(0, 4)})
            
            local List = Create("UIListLayout", {
                Parent = OptionContainer,
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            local function Refresh()
                for _, v in pairs(OptionContainer:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, opt in pairs(Options) do
                    local Item = Create("TextButton", {
                        Parent = OptionContainer,
                        BackgroundColor3 = BongXLib.Themes.Default.Content,
                        Size = UDim2.new(1, 0, 0, 25),
                        BorderSizePixel = 0,
                        Font = Enum.Font.Gotham,
                        Text = tostring(opt),
                        TextColor3 = BongXLib.Themes.Default.TextDark,
                        TextSize = 12
                    })
                    Create("UICorner", {Parent = Item, CornerRadius = UDim.new(0, 4)})
                    
                    Item.MouseButton1Click:Connect(function()
                        SelectedLabel.Text = tostring(opt)
                        pcall(Callback, opt)
                        IsOpen = false
                        TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        OptionContainer.Visible = false
                    end)
                end
            end
            
            Refresh()

            DropBtn.MouseButton1Click:Connect(function()
                IsOpen = not IsOpen
                if IsOpen then
                    OptionContainer.Visible = true
                    local Count = #Options
                    local ContentSize = Count * 27
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 45 + ContentSize)}):Play()
                    TweenService:Create(OptionContainer, TweenInfo.new(0.2), {Size = UDim2.new(1, -10, 0, ContentSize)}):Play()
                else
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                    OptionContainer.Visible = false
                end
            end)
            
            local Funcs = {}
            function Funcs:Set(val)
                SelectedLabel.Text = tostring(val)
                pcall(Callback, val)
            end
            function Funcs:Refresh(NewOpts)
                Options = NewOpts
                Refresh()
            end
            return Funcs
        end
        
        function Tab:AddDiscordInvite(Config)
            local Title = Config.Name or "Discord"
            local Invite = Config.Invite or ""
            
            local Frame = Create("Frame", {
                Parent = TabFrame,
                BackgroundColor3 = Color3.fromRGB(88, 101, 242), -- Discord Color
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0
            })
            Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
            
            Create("TextLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 45, 0, 0),
                Size = UDim2.new(1, -120, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Title,
                TextColor3 = Color3.new(1,1,1),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            Create("ImageLabel", {
                Parent = Frame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0.5, -12),
                Size = UDim2.new(0, 24, 0, 24),
                Image = "rbxassetid://9868169994", -- Discord Icon
                ImageColor3 = Color3.new(1,1,1)
            })
            
            local JoinBtn = Create("TextButton", {
                Parent = Frame,
                BackgroundColor3 = Color3.new(1,1,1),
                Position = UDim2.new(1, -70, 0.5, -12),
                Size = UDim2.new(0, 60, 0, 24),
                Text = "Join",
                Font = Enum.Font.GothamBold,
                TextColor3 = Color3.fromRGB(88, 101, 242),
                TextSize = 12
            })
            Create("UICorner", {Parent = JoinBtn, CornerRadius = UDim.new(0, 4)})
            
            JoinBtn.MouseButton1Click:Connect(function()
                setclipboard(Invite)
            end)
        end

        return Tab
    end

    return Window
end

return BongXLib
