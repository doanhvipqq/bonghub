--[[ 
    ✨ BÓNG X UI LIBRARY V5.0 - SURGICAL FIX ✨
    Fix: Logic mismatch with Gravity Script (AddParagraph Desc key, SetDesc alias)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local RedzLib = {
    Settings = {Theme = "Purple"},
    Themes = {
        Purple = {
            ["Main"] = Color3.fromRGB(25, 25, 30),
            ["Sidebar"] = Color3.fromRGB(30,30,35),
            ["Content"] = Color3.fromRGB(35,35,40),
            ["Stroke"] = Color3.fromRGB(60,60,65),
            ["Accent"] = Color3.fromRGB(138, 43, 226),
            ["Text"] = Color3.fromRGB(255,255,255),
            ["TextDark"] = Color3.fromRGB(170,170,170)
        }
    }
}

function RedzLib:MakeWindow(Config)
    if CoreGui:FindFirstChild("BongX_V5") then CoreGui.BongX_V5:Destroy() end
    
    local Title = Config.Title or Config[1] or "Bóng X Hub"
    local SubTitle = Config.SubTitle or Config[2] or "by BongX"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BongX_V5"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = RedzLib.Themes.Purple.Main
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = RedzLib.Themes.Purple.Stroke
    Stroke.Thickness = 1
    
    -- Drag
    local Dragging, DragInput, StartPos, DragStart
    Main.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging, DragStart, StartPos = true, Input.Position, Main.Position
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
    UserInputService.InputEnded:Connect(function(Input) 
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end 
    end)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    local SideLayout = Instance.new("UIListLayout", Sidebar)
    SideLayout.Padding = UDim.new(0, 5)
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", Sidebar).PaddingLeft = UDim.new(0,10)
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,10)
    
    -- Title
    local TitleL = Instance.new("TextLabel", Sidebar)
    TitleL.BackgroundTransparency = 1
    TitleL.Size = UDim2.new(1,-10,0,25)
    TitleL.Font = Enum.Font.GothamBold
    TitleL.Text = Title
    TitleL.TextColor3 = RedzLib.Themes.Purple.Text
    TitleL.TextSize = 18
    TitleL.TextXAlignment = Enum.TextXAlignment.Left
    
    local SubL = Instance.new("TextLabel", Sidebar)
    SubL.BackgroundTransparency = 1
    SubL.Size = UDim2.new(1,-10,0,20)
    SubL.Font = Enum.Font.Gotham
    SubL.Text = SubTitle
    SubL.TextColor3 = RedzLib.Themes.Purple.TextDark
    SubL.TextSize = 12
    SubL.TextXAlignment = Enum.TextXAlignment.Left
    
    Instance.new("Frame", Sidebar).BackgroundTransparency = 1 -- Spacer
    Sidebar.Frame.Size = UDim2.new(1,0,0,20)

    -- Content
    local Content = Instance.new("Frame", Main)
    Content.BackgroundColor3 = RedzLib.Themes.Purple.Content
    Content.Size = UDim2.new(1, -160, 1, 0)
    Content.Position = UDim2.new(0, 160, 0, 0)
    Content.BorderSizePixel = 0

    local Window = {Tabs = {}}

    function Window:Minimize(val)
        ScreenGui.Enabled = not val
    end

    function Window:MakeTab(Config)
        local Title = Config.Title or Config[1] or "Tab"
        
        local Btn = Instance.new("TextButton", Sidebar)
        Btn.BackgroundColor3 = RedzLib.Themes.Purple.Main
        Btn.BackgroundTransparency = 1
        Btn.Size = UDim2.new(0, 140, 0, 35)
        Btn.Font = Enum.Font.GothamMedium
        Btn.Text = Title
        Btn.TextColor3 = RedzLib.Themes.Purple.TextDark
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,6)
        Instance.new("UIPadding", Btn).PaddingLeft = UDim.new(0,10)
        
        local Page = Instance.new("ScrollingFrame", Content)
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1,0,1,0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.Padding = UDim.new(0, 5)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local PPad = Instance.new("UIPadding", Page)
        PPad.PaddingTop = UDim.new(0,10)
        PPad.PaddingLeft = UDim.new(0,10)
        PPad.PaddingRight = UDim.new(0,10)
        
        PLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0, PLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Btn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do
                T.Page.Visible = false
                T.Btn.BackgroundTransparency = 1
                T.Btn.TextColor3 = RedzLib.Themes.Purple.TextDark
            end
            Page.Visible = true
            Btn.BackgroundTransparency = 0
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Accent
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
        end)
        
        if #Window.Tabs == 0 then
            Page.Visible = true
            Btn.BackgroundTransparency = 0
            Btn.BackgroundColor3 = RedzLib.Themes.Purple.Accent
            Btn.TextColor3 = RedzLib.Themes.Purple.Text
        end
        
        table.insert(Window.Tabs, {Btn=Btn, Page=Page})
        
        local Tab = {}
        
        function Tab:AddSection(Name)
            local T = type(Name)=="table" and Name.Name or Name
            local L = Instance.new("TextLabel", Page)
            L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,25); L.Font=Enum.Font.GothamBold; L.Text=T; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=14; L.TextXAlignment=Enum.TextXAlignment.Left
        end
        
        -- FIX: Support Desc and SetDesc
        function Tab:AddParagraph(Config)
            local T = Config.Title or Config[1] or ""
            local C = Config.Content or Config.Desc or Config[2] or ""
            
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3 = RedzLib.Themes.Purple.Main
            F.AutomaticSize = Enum.AutomaticSize.Y
            F.Size = UDim2.new(1,0,0,0)
            Instance.new("UICorner", F).CornerRadius = UDim.new(0,6)
            Instance.new("UIPadding", F).PaddingTop=UDim.new(0,8); Instance.new("UIPadding",F).PaddingLeft=UDim.new(0,10); Instance.new("UIPadding",F).PaddingBottom=UDim.new(0,8)
            
            local T1 = Instance.new("TextLabel", F)
            T1.BackgroundTransparency=1; T1.Size=UDim2.new(1,-10,0,18); T1.Font=Enum.Font.GothamBold; T1.Text=T; T1.TextColor3=RedzLib.Themes.Purple.Text; T1.TextSize=13; T1.TextXAlignment=Enum.TextXAlignment.Left
            
            local T2 = Instance.new("TextLabel", F)
            T2.BackgroundTransparency=1; T2.Position=UDim2.new(0,0,0,20); T2.Size=UDim2.new(1,-10,0,0); T2.AutomaticSize=Enum.AutomaticSize.Y
            T2.Font=Enum.Font.Gotham; T2.Text=C; T2.TextColor3=RedzLib.Themes.Purple.TextDark; T2.TextSize=12; T2.TextXAlignment=Enum.TextXAlignment.Left; T2.TextWrapped=true
            
            local R = {}
            function R:Set(v) T2.Text = v end
            function R:SetDesc(v) T2.Text = v end -- Alias fix
            return R
        end
        
        function Tab:AddToggle(Config)
            local N = Config.Name or Config[1]
            local D = Config.Default or Config[2] or false
            local Call = Config.Callback or function() end
            
            local B = Instance.new("TextButton", Page)
            B.BackgroundColor3 = RedzLib.Themes.Purple.Main
            B.Size = UDim2.new(1,0,0,40)
            B.Text = ""
            B.AutoButtonColor = false
            Instance.new("UICorner", B).CornerRadius = UDim.new(0,6)
            
            local L = Instance.new("TextLabel", B)
            L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,0); L.Size=UDim2.new(1,-60,1,0); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            
            local S = Instance.new("Frame", B)
            S.Position=UDim2.new(1,-50,0.5,-10); S.Size=UDim2.new(0,40,0,20)
            S.BackgroundColor3 = D and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
            Instance.new("UICorner", S).CornerRadius=UDim.new(1,0)
            
            local Dot = Instance.new("Frame", S)
            Dot.Position = D and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8); Dot.Size=UDim2.new(0,16,0,16); Dot.BackgroundColor3=Color3.new(1,1,1)
            Instance.new("UICorner", Dot).CornerRadius=UDim.new(1,0)
            
            local State = D
            local function Upd()
                State = not State
                S.BackgroundColor3 = State and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
                Dot.Position = State and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
                pcall(Call, State)
            end
            B.MouseButton1Click:Connect(Upd)
            local R = {}
            function R:Set(v) State = not v Upd() end -- toggle to target
            return R
        end
        
        function Tab:AddButton(Config)
            local N = Config.Name or Config[1]
            local C = Config.Callback or Config[2] or function() end
            
            local B = Instance.new("TextButton", Page)
            B.BackgroundColor3 = RedzLib.Themes.Purple.Main
            B.Size = UDim2.new(1,0,0,35)
            B.Font = Enum.Font.GothamMedium; B.Text=N; B.TextColor3=RedzLib.Themes.Purple.Text; B.TextSize=13; B.AutoButtonColor=false
            Instance.new("UICorner", B).CornerRadius=UDim.new(0,6)
            
            B.MouseButton1Click:Connect(function()
                B.BackgroundColor3 = RedzLib.Themes.Purple.Stroke
                task.wait(0.1)
                B.BackgroundColor3 = RedzLib.Themes.Purple.Main
                pcall(C)
            end)
        end
        
        function Tab:AddSlider(Config)
            local N = Config.Name or "Slider"
            local Min, Max = Config.Min or 0, Config.Max or 100
            local Def = Config.Default or Min
            local Call = Config.Callback or function() end
            
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3 = RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,50); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            
            local L = Instance.new("TextLabel", F)
            L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,5); L.Size=UDim2.new(1,-20,0,20); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            
            local VL = Instance.new("TextLabel", F)
            VL.BackgroundTransparency=1; VL.Position=UDim2.new(1,-50,0,5); VL.Size=UDim2.new(0,40,0,20); VL.Font=Enum.Font.Gotham; VL.Text=tostring(Def); VL.TextColor3=RedzLib.Themes.Purple.TextDark; VL.TextSize=12
            
            local Bar = Instance.new("TextButton", F)
            Bar.BackgroundColor3=RedzLib.Themes.Purple.Stroke; Bar.Position=UDim2.new(0,10,0,30); Bar.Size=UDim2.new(1,-20,0,6); Bar.Text=""; Bar.AutoButtonColor=false; Instance.new("UICorner",Bar).CornerRadius=UDim.new(1,0)
            
            local Fill = Instance.new("Frame", Bar)
            Fill.BackgroundColor3=RedzLib.Themes.Purple.Accent; Fill.Size=UDim2.new((Def-Min)/(Max-Min),0,1,0); Fill.BorderSizePixel=0; Instance.new("UICorner",Fill).CornerRadius=UDim.new(1,0)
            
            local function Upd(In)
                local S = math.clamp((In.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
                local V = math.floor(Min + ((Max-Min)*S))
                Fill.Size = UDim2.new(S,0,1,0)
                VL.Text = tostring(V)
                pcall(Call, V)
            end
            
            local Drag = false
            Bar.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Drag=true Upd(I) end end)
            UserInputService.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Drag=false end end)
            UserInputService.InputChanged:Connect(function(I) if Drag and I.UserInputType==Enum.UserInputType.MouseMovement then Upd(I) end end)
            
            local R={}
            function R:Set(v)
                local S = math.clamp((v - Min) / (Max - Min), 0, 1)
                Fill.Size = UDim2.new(S, 0, 1, 0)
                VL.Text = tostring(v)
                pcall(Call, v)
            end
            return R
        end
        
        function Tab:AddTextbox(Config)
            local N = Config.Name or "Textbox"
            local D = Config.Default or ""
            local Call = Config.Callback or function() end
            
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,50); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            
            local L = Instance.new("TextLabel", F)
            L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,5); L.Size=UDim2.new(1,-20,0,20); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            
            local Box = Instance.new("TextBox", F)
            Box.BackgroundColor3=RedzLib.Themes.Purple.Sidebar; Box.Position=UDim2.new(0,10,0,25); Box.Size=UDim2.new(1,-20,0,20); Box.Font=Enum.Font.Gotham; Box.Text=D; Box.TextColor3=RedzLib.Themes.Purple.Text; Box.TextSize=12; Instance.new("UICorner",Box).CornerRadius=UDim.new(0,4)
            
            Box.FocusLost:Connect(function() pcall(Call, Box.Text) end)
            local R={}
            function R:Set(v) Box.Text=v pcall(Call, v) end
            return R
        end
        
        function Tab:AddDropdown(Config)
            local N = Config.Name or Config[1]
            local Opts = Config.Options or Config.Values or Config[2] or {}
            local Def = Config.Default or Opts[1]
            local Call = Config.Callback or function() end
            
            local F = Instance.new("Frame", Page)
            F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,40); F.ClipsDescendants=true; Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            
            local L = Instance.new("TextLabel", F)
            L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,0); L.Size=UDim2.new(1,-30,0,40); L.Font=Enum.Font.GothamMedium; L.Text=N..": "..tostring(Def); L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            
            local List = Instance.new("Frame", F)
            List.Visible=false; List.BackgroundColor3=RedzLib.Themes.Purple.Sidebar; List.Position=UDim2.new(0,5,0,40); List.Size=UDim2.new(1,-10,0,0); Instance.new("UICorner",List).CornerRadius=UDim.new(0,4); Instance.new("UIListLayout",List).Padding=UDim.new(0,2)
            
            local Btn = Instance.new("TextButton", F)
            Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,0,1,0); Btn.Text=""
            
            local Open = false
            Btn.MouseButton1Click:Connect(function()
                Open=not Open
                if Open then
                    List.Visible=true
                    for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
                    for _,o in pairs(Opts) do
                        local B = Instance.new("TextButton", List)
                        B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,30); B.Font=Enum.Font.Gotham; B.Text=tostring(o); B.TextColor3=RedzLib.Themes.Purple.TextDark; B.TextSize=12; Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                        B.MouseButton1Click:Connect(function()
                            Open=false; F.Size=UDim2.new(1,0,0,40); List.Visible=false; L.Text=N..": "..tostring(o); pcall(Call, o)
                        end)
                    end
                    F.Size=UDim2.new(1,0,0,45+(#Opts*32)); List.Size=UDim2.new(1,-10,0,#Opts*32)
                else
                    F.Size=UDim2.new(1,0,0,40); List.Visible=false
                end
            end)
            
            local R={}
            function R:Set(v) L.Text=N..": "..tostring(v) pcall(Call, v) end
            function R:Refresh(O) Opts=O end
            return R
        end
        
        return Tab
    end
    return Window
end
return RedzLib
