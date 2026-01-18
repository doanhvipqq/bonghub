--[[ 
    ✨ BÓNG X UI LIBRARY V4.0 - REDZ RESKIN ✨
    Core: Original RedzHub Logic (100% Stability for Farming)
    Skin: Bóng X Purple Theme
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local RedzLib = {
    Settings = {
        Theme = "Purple",
        Folder = "BongXConfig"
    },
    Themes = {
        Purple = {
            ["Main"] = Color3.fromRGB(20, 20, 25),
            ["Sidebar"] = Color3.fromRGB(25, 25, 30),
            ["Content"] = Color3.fromRGB(30, 30, 35),
            ["Stroke"] = Color3.fromRGB(60, 60, 65),
            ["Accent"] = Color3.fromRGB(138, 43, 226), -- BongX Purple
            ["Text"] = Color3.fromRGB(255, 255, 255),
            ["TextDark"] = Color3.fromRGB(170, 170, 170)
        }
    }
}

function RedzLib:MakeWindow(Config)
    local Title = Config.Title or "Bóng X Hub"
    local SubTitle = Config.SubTitle or "by Bóng X"
    
    if CoreGui:FindFirstChild("RedzLib_Reskin") then CoreGui.RedzLib_Reskin:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RedzLib_Reskin"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = RedzLib.Themes.Purple.Main
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = RedzLib.Themes.Purple.Stroke
    UIStroke.Thickness = 1
    UIStroke.Parent = Main

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BorderSizePixel = 0
    
    local MainTitle = Instance.new("TextLabel")
    MainTitle.Parent = Header
    MainTitle.BackgroundTransparency = 1
    MainTitle.Position = UDim2.new(0, 15, 0, 0)
    MainTitle.Size = UDim2.new(1, -50, 1, 0)
    MainTitle.Font = Enum.Font.GothamBold
    MainTitle.Text = Title .. " <font color='#AAAAAA' size='12'>" .. SubTitle .. "</font>"
    MainTitle.TextColor3 = RedzLib.Themes.Purple.Text
    MainTitle.TextSize = 16
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.RichText = true

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Header
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = RedzLib.Themes.Purple.TextDark
    CloseBtn.TextSize = 14
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Container
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.ScrollBarThickness = 0
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)
    
    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.Parent = Sidebar
    SidebarPad.PaddingTop = UDim.new(0, 10)
    SidebarPad.PaddingLeft = UDim.new(0, 10)

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Parent = Main
    Content.BackgroundColor3 = RedzLib.Themes.Purple.Content
    Content.BorderSizePixel = 0
    Content.Position = UDim2.new(0, 150, 0, 40)
    Content.Size = UDim2.new(1, -150, 1, -40)

    -- Draggable
    local Dragging, DragInput, StartPos, DragStart
    Header.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Main.Position
        end
    end)
    Header.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
    end)
    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)

    local Window = {Tabs = {}}

    function Window:MakeTab(Config)
        local TabName = Config.Title or Config[1] or "Tab"
        local TabIcon = Config.Icon or ""

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 130, 0, 35)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = TabName
        TabBtn.TextColor3 = RedzLib.Themes.Purple.TextDark
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabBtnC = Instance.new("UICorner")
        TabBtnC.CornerRadius = UDim.new(0, 6)
        TabBtnC.Parent = TabBtn
        
        local TabBtnP = Instance.new("UIPadding")
        TabBtnP.PaddingLeft = UDim.new(0, 10)
        TabBtnP.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Parent = Content
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = RedzLib.Themes.Purple.Accent
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = Page
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 5)
        
        local PagePad = Instance.new("UIPadding")
        PagePad.Parent = Page
        PagePad.PaddingTop = UDim.new(0, 10)
        PagePad.PaddingLeft = UDim.new(0, 10)
        PagePad.PaddingRight = UDim.new(0, 10)
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                T.Btn.BackgroundTransparency = 1
                T.Btn.TextColor3 = RedzLib.Themes.Purple.TextDark
            end
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = RedzLib.Themes.Purple.Accent
            TabBtn.TextColor3 = RedzLib.Themes.Purple.Text
        end)

        -- Auto Select
        if #Window.Tabs == 0 then
            Page.Visible = true
            TabBtn.BackgroundTransparency = 0
            TabBtn.BackgroundColor3 = RedzLib.Themes.Purple.Accent
            TabBtn.TextColor3 = RedzLib.Themes.Purple.Text
        end

        table.insert(Window.Tabs, {Btn = TabBtn, Page = Page})

        local Tab = {}

        function Tab:AddSection(Name)
            local Txt = type(Name) == "table" and Name.Name or Name
            local Lbl = Instance.new("TextLabel")
            Lbl.Parent = Page
            Lbl.BackgroundTransparency = 1
            Lbl.Size = UDim2.new(1, 0, 0, 30)
            Lbl.Font = Enum.Font.GothamBold
            Lbl.Text = Txt
            Lbl.TextColor3 = RedzLib.Themes.Purple.Text
            Lbl.TextSize = 14
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:AddParagraph(Config)
            local T = Config.Title or Config[1] or ""
            local C = Config.Content or Config[2] or ""
            local F = Instance.new("Frame")
            F.Parent = Page
            F.BackgroundColor3 = RedzLib.Themes.Purple.Main
            F.Size = UDim2.new(1, 0, 0, 0)
            F.AutomaticSize = Enum.AutomaticSize.Y
            
            local C1 = Instance.new("UICorner"); C1.Parent = F; C1.CornerRadius = UDim.new(0, 6)
            local P1 = Instance.new("UIPadding"); P1.Parent = F; P1.PaddingTop=UDim.new(0,10); P1.PaddingBottom=UDim.new(0,10); P1.PaddingLeft=UDim.new(0,10)
            
            local L1 = Instance.new("TextLabel"); L1.Parent = F
            L1.BackgroundTransparency = 1; L1.Size = UDim2.new(1, -10, 0, 20)
            L1.Font = Enum.Font.GothamBold; L1.Text = T; L1.TextColor3 = RedzLib.Themes.Purple.Text; L1.TextSize = 13; L1.TextXAlignment = Enum.TextXAlignment.Left
            
            local L2 = Instance.new("TextLabel"); L2.Parent = F
            L2.BackgroundTransparency = 1; L2.Position = UDim2.new(0,0,0,22); L2.Size = UDim2.new(1,-10,0,0); L2.AutomaticSize = Enum.AutomaticSize.Y
            L2.Font = Enum.Font.Gotham; L2.Text = C; L2.TextColor3 = RedzLib.Themes.Purple.TextDark; L2.TextSize = 12; L2.TextXAlignment = Enum.TextXAlignment.Left; L2.TextWrapped = true
            
            local R = {}
            function R:Set(v) L2.Text = v end
            return R
        end

        function Tab:AddToggle(Config)
            local Name = Config.Name or Config[1]
            local Default = Config.Default or Config[2] or false
            local Callback = Config.Callback or function() end
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
            Btn.Size = UDim2.new(1, 0, 0, 40)
            Btn.Text = ""
            Btn.AutoButtonColor = false
            
            local C = Instance.new("UICorner"); C.Parent = Btn; C.CornerRadius = UDim.new(0, 6)
            
            local L = Instance.new("TextLabel"); L.Parent = Btn
            L.BackgroundTransparency = 1; L.Position = UDim2.new(0, 10, 0, 0); L.Size = UDim2.new(1, -60, 1, 0)
            L.Font = Enum.Font.GothamMedium; L.Text = Name; L.TextColor3 = RedzLib.Themes.Purple.Text; L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left
            
            local S = Instance.new("Frame"); S.Parent = Btn
            S.BackgroundColor3 = Default and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
            S.Position = UDim2.new(1, -50, 0.5, -10); S.Size = UDim2.new(0, 40, 0, 20)
            local SC = Instance.new("UICorner"); SC.Parent = S; SC.CornerRadius = UDim.new(1, 0)
            
            local D = Instance.new("Frame"); D.Parent = S
            D.BackgroundColor3 = Color3.new(1,1,1)
            D.Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); D.Size = UDim2.new(0, 16, 0, 16)
            local DC = Instance.new("UICorner"); DC.Parent = D; DC.CornerRadius = UDim.new(1, 0)
            
            local State = Default
            local function Toggle(Val)
                State = Val
                TweenService:Create(S, TweenInfo.new(0.2), {BackgroundColor3 = State and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke}):Play()
                TweenService:Create(D, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                pcall(Callback, State)
            end
            
            Btn.MouseButton1Click:Connect(function() Toggle(not State) end)
            
            local R = {}
            function R:Set(v) Toggle(v) end
            return R
        end
        
        function Tab:AddButton(Config)
            local Name = Config.Name or Config[1]
            local Callback = Config.Callback or Config[2] or function() end
            
            local Btn = Instance.new("TextButton")
            Btn.Parent = Page
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.Font = Enum.Font.GothamMedium
            Btn.Text = Name
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
            Btn.TextSize = 13
            Btn.AutoButtonColor = false
            
            local C = Instance.new("UICorner"); C.Parent = Btn; C.CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = RedzLib.Themes.Purple.Stroke}):Play()
                task.wait(0.1)
                TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = RedzLib.Themes.Purple.Main}):Play()
                pcall(Callback)
            end)
        end
        
        -- Minimal Slider/Dropdown/Textbox to prevent crashes if missing
        function Tab:AddSlider(Config)
            local Name = Config.Name or "Slider"
            local Min, Max = Config.Min or 0, Config.Max or 100
            local Default = Config.Default or Min
            local Callback = Config.Callback or function() end
            
            local F = Instance.new("Frame"); F.Parent = Page; F.BackgroundColor3 = RedzLib.Themes.Purple.Main; F.Size = UDim2.new(1,0,0,50)
            local C = Instance.new("UICorner"); C.Parent = F; C.CornerRadius = UDim.new(0,6)
            local L = Instance.new("TextLabel"); L.Parent = F; L.BackgroundTransparency = 1; L.Position = UDim2.new(0,10,0,5); L.Size = UDim2.new(1,-20,0,20); L.Font = Enum.Font.GothamMedium; L.Text = Name; L.TextColor3 = RedzLib.Themes.Purple.Text; L.TextSize = 13; L.TextXAlignment = Enum.TextXAlignment.Left
            local VL = Instance.new("TextLabel"); VL.Parent = F; VL.BackgroundTransparency = 1; VL.Position = UDim2.new(1,-50,0,5); VL.Size = UDim2.new(0,40,0,20); VL.Font = Enum.Font.Gotham; VL.Text = tostring(Default); VL.TextColor3 = RedzLib.Themes.Purple.TextDark; VL.TextSize = 12
            
            local Bar = Instance.new("TextButton"); Bar.Parent = F; Bar.BackgroundColor3 = RedzLib.Themes.Purple.Stroke; Bar.Position = UDim2.new(0,10,0,30); Bar.Size = UDim2.new(1,-20,0,6); Bar.Text = ""; Bar.AutoButtonColor = false
            local BC = Instance.new("UICorner"); BC.Parent = Bar; BC.CornerRadius = UDim.new(1,0)
            local Fill = Instance.new("Frame"); Fill.Parent = Bar; Fill.BackgroundColor3 = RedzLib.Themes.Purple.Accent; Fill.Size = UDim2.new((Default-Min)/(Max-Min),0,1,0); Fill.BorderSizePixel = 0
            local FC = Instance.new("UICorner"); FC.Parent = Fill; FC.CornerRadius = UDim.new(1,0)
            
            local function Update(Input)
                local S = math.clamp((Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local V = math.floor(Min + ((Max - Min) * S))
                Fill.Size = UDim2.new(S, 0, 1, 0)
                VL.Text = tostring(V)
                pcall(Callback, V)
            end
            
            local Drag = false
            Bar.InputBegan:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Drag = true Update(I) end end)
            UserInputService.InputEnded:Connect(function(I) if I.UserInputType == Enum.UserInputType.MouseButton1 then Drag = false end end)
            UserInputService.InputChanged:Connect(function(I) if Drag and I.UserInputType == Enum.UserInputType.MouseMovement then Update(I) end end)
            
            local R = {}
            function R:Set(v)
                local S = math.clamp((v - Min) / (Max - Min), 0, 1)
                Fill.Size = UDim2.new(S, 0, 1, 0)
                VL.Text = tostring(v)
                pcall(Callback, v)
            end
            return R
        end
        
        function Tab:AddTextbox(Config)
            local Name = Config.Name or "Textbox"
            local Default = Config.Default or ""
            local Callback = Config.Callback or function() end
            local F = Instance.new("Frame"); F.Parent = Page; F.BackgroundColor3 = RedzLib.Themes.Purple.Main; F.Size = UDim2.new(1,0,0,50); Instance.new("UICorner", F).CornerRadius = UDim.new(0,6)
            local L = Instance.new("TextLabel"); L.Parent = F; L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,5); L.Size=UDim2.new(1,-20,0,20); L.Font=Enum.Font.GothamMedium; L.Text=Name; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            local B = Instance.new("TextBox"); B.Parent=F; B.BackgroundColor3=RedzLib.Themes.Purple.Sidebar; B.Position=UDim2.new(0,10,0,25); B.Size=UDim2.new(1,-20,0,20); B.Font=Enum.Font.Gotham; B.Text=Default; B.TextColor3=RedzLib.Themes.Purple.Text; B.TextSize=12; Instance.new("UICorner", B).CornerRadius=UDim.new(0,4)
            B.FocusLost:Connect(function() pcall(Callback, B.Text) end)
            local R = {}
            function R:Set(v) B.Text=v pcall(Callback, v) end
            return R
        end
        
        function Tab:AddDropdown(Config)
            local Name = Config.Name or Config[1]
            local Opts = Config.Options or Config.Values or Config[2] or {}
            local Def = Config.Default or Opts[1]
            local Call = Config.Callback or function() end
            local F = Instance.new("Frame"); F.Parent=Page; F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,40); F.ClipsDescendants=true; Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            local L = Instance.new("TextLabel"); L.Parent=F; L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,0); L.Size=UDim2.new(1,-30,0,40); L.Font=Enum.Font.GothamMedium; L.Text=Name..": "..tostring(Def); L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            local Btn = Instance.new("TextButton"); Btn.Parent=F; Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,0,1,0); Btn.Text=""
            local List = Instance.new("Frame"); List.Parent=F; List.Visible=false; List.BackgroundColor3=RedzLib.Themes.Purple.Sidebar; List.Position=UDim2.new(0,5,0,40); List.Size=UDim2.new(1,-10,0,0); Instance.new("UICorner",List).CornerRadius=UDim.new(0,4); Instance.new("UIListLayout",List).Padding=UDim.new(0,2)
            
            local Open = false
            Btn.MouseButton1Click:Connect(function()
                Open = not Open
                if Open then
                    List.Visible = true
                    for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _,o in pairs(Opts) do
                        local B = Instance.new("TextButton"); B.Parent=List; B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,30); B.Font=Enum.Font.Gotham; B.Text=tostring(o); B.TextColor3=RedzLib.Themes.Purple.TextDark; B.TextSize=12; Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                        B.MouseButton1Click:Connect(function()
                            Open = false; F.Size=UDim2.new(1,0,0,40); List.Visible=false; L.Text=Name..": "..tostring(o); pcall(Call, o)
                        end)
                    end
                    F.Size=UDim2.new(1,0,0,45+(#Opts*32)); List.Size=UDim2.new(1,-10,0,#Opts*32)
                else
                    F.Size=UDim2.new(1,0,0,40); List.Visible=false
                end
            end)
            local R = {}
            function R:Set(v) L.Text=Name..": "..tostring(v) pcall(Call, v) end
            function R:Refresh(O) Opts=O end
            return R
        end
        
        function Tab:AddDiscordInvite(Config)
             -- Minimal
        end

        return Tab
    end

    return Window
end

return RedzLib
