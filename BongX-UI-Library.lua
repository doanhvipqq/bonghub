--[[ 
    ✨ BÓNG X UI LIBRARY V8.0 - FLEXIBLE CORE ✨
    Fix: Logic Toggle/Callback (Support check _G)
    Fix: Flexible Arguments for all functions (Table or VarArgs)
    Debug: Screen Notifications
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local RedzLib = {
    Settings = {Theme = "Purple"},
    Flags = {},
    Save = {UISize = {550, 350}, TabSize = 160},
    Themes = {
        Purple = {
            ["Main"] = Color3.fromRGB(20, 20, 25),
            ["Sidebar"] = Color3.fromRGB(25,25,30),
            ["Content"] = Color3.fromRGB(30,30,35),
            ["Stroke"] = Color3.fromRGB(50,50,55),
            ["Accent"] = Color3.fromRGB(138, 43, 226),
            ["Text"] = Color3.fromRGB(255,255,255),
            ["TextDark"] = Color3.fromRGB(150,150,150)
        }
    }
}

function RedzLib:Notification(Title, Desc)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Title,
            Text = Desc,
            Duration = 3
        })
    end)
end

function RedzLib:MakeWindow(Config)
    if CoreGui:FindFirstChild("BongX_V8") then CoreGui.BongX_V8:Destroy() end
    
    local Config = Config or {}
    local Title = Config.Title or "Bóng X Hub"
    local SubTitle = Config.SubTitle or ""

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BongX_V8"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.BackgroundColor3 = RedzLib.Themes.Purple.Main
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = RedzLib.Themes.Purple.Stroke
    Stroke.Thickness = 1
    
    -- Drag
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dragging=true; DragStart=I.Position; StartPos=Main.Position end end)
    UserInputService.InputChanged:Connect(function(I) if Dragging and I.UserInputType==Enum.UserInputType.MouseMovement then local D=I.Position-DragStart; Main.Position=UDim2.new(StartPos.X.Scale,StartPos.X.Offset+D.X,StartPos.Y.Scale,StartPos.Y.Offset+D.Y) end end)
    UserInputService.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dragging=false end end)

    -- Sidebar
    local Sidebar = Instance.new("ScrollingFrame", Main)
    Sidebar.BackgroundColor3 = RedzLib.Themes.Purple.Sidebar
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BorderSizePixel = 0; Sidebar.ScrollBarThickness = 0
    Instance.new("UIListLayout", Sidebar).SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", Sidebar).PaddingLeft = UDim.new(0,10); Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0,10)
    
    local TitleL = Instance.new("TextLabel", Sidebar); TitleL.BackgroundTransparency=1; TitleL.Size=UDim2.new(1,-10,0,25); TitleL.Font=Enum.Font.GothamBold; TitleL.Text=Title; TitleL.TextColor3=RedzLib.Themes.Purple.Text; TitleL.TextSize=16; TitleL.TextXAlignment=Enum.TextXAlignment.Left
    local SubL = Instance.new("TextLabel", Sidebar); SubL.BackgroundTransparency=1; SubL.Size=UDim2.new(1,-10,0,15); SubL.Font=Enum.Font.Gotham; SubL.Text=SubTitle; SubL.TextColor3=RedzLib.Themes.Purple.TextDark; SubL.TextSize=11; SubL.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("Frame", Sidebar).BackgroundTransparency=1; Sidebar.Frame.Size=UDim2.new(1,0,0,10) -- Spacer
    
    local Content = Instance.new("Frame", Main); Content.BackgroundColor3=RedzLib.Themes.Purple.Content; Content.Size=UDim2.new(1,-150,1,0); Content.Position=UDim2.new(0,150,0,0); Content.BorderSizePixel=0

    local Window = {Tabs = {}}

    function Window:Minimize(val) ScreenGui.Enabled = not val end

    function Window:MakeTab(Config)
        local Title = type(Config)=="table" and (Config.Title or Config[1]) or Config or "Tab"
        
        local Btn = Instance.new("TextButton", Sidebar); Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,-10,0,35); Btn.Font=Enum.Font.GothamMedium; Btn.Text=Title; Btn.TextColor3=RedzLib.Themes.Purple.TextDark; Btn.TextSize=13; Btn.TextXAlignment=Enum.TextXAlignment.Left; Instance.new("UICorner",Btn).CornerRadius=UDim.new(0,6); Instance.new("UIPadding",Btn).PaddingLeft=UDim.new(0,8)
        
        local Page = Instance.new("ScrollingFrame", Content); Page.BackgroundTransparency=1; Page.Size=UDim2.new(1,0,1,0); Page.Visible=false; Page.ScrollBarThickness=2
        local PL = Instance.new("UIListLayout", Page); PL.SortOrder=Enum.SortOrder.LayoutOrder; PL.Padding=UDim.new(0,5)
        Instance.new("UIPadding", Page).PaddingTop = UDim.new(0,10); Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0,10); Instance.new("UIPadding", Page).PaddingRight = UDim.new(0,10)
        
        PL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0,PL.AbsoluteContentSize.Y+20) end)
        
        local function Activate()
            for _, T in pairs(Window.Tabs) do T.Page.Visible=false; T.Btn.BackgroundTransparency=1; T.Btn.TextColor3=RedzLib.Themes.Purple.TextDark end
            Page.Visible=true; Btn.BackgroundTransparency=0; Btn.BackgroundColor3=RedzLib.Themes.Purple.Accent; Btn.TextColor3=RedzLib.Themes.Purple.Text
        end
        Btn.MouseButton1Click:Connect(Activate)
        
        if #Window.Tabs == 0 then Activate() end
        table.insert(Window.Tabs, {Btn=Btn, Page=Page})
        
        local Tab = {}
        
        function Tab:AddSection(C)
            local T = type(C)=="table" and (C.Name or C[1]) or C or ""
            local L = Instance.new("TextLabel", Page); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,25); L.Font=Enum.Font.GothamBold; L.Text=tostring(T); L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=14; L.TextXAlignment=Enum.TextXAlignment.Left
        end
        
        function Tab:AddParagraph(C)
            local T = C.Title or C[1] or ""; local D = C.Content or C.Desc or C[2] or ""
            local F = Instance.new("Frame", Page); F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.AutomaticSize=Enum.AutomaticSize.Y; F.Size=UDim2.new(1,0,0,0); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            local L1 = Instance.new("TextLabel",F); L1.BackgroundTransparency=1; L1.Size=UDim2.new(1,-10,0,20); L1.Position=UDim2.new(0,10,0,5); L1.Font=Enum.Font.GothamBold; L1.Text=T; L1.TextColor3=RedzLib.Themes.Purple.Text; L1.TextSize=13; L1.TextXAlignment=Enum.TextXAlignment.Left
            local L2 = Instance.new("TextLabel",F); L2.BackgroundTransparency=1; L2.Position=UDim2.new(0,10,0,25); L2.Size=UDim2.new(1,-20,0,0); L2.AutomaticSize=Enum.AutomaticSize.Y; L2.Font=Enum.Font.Gotham; L2.Text=D; L2.TextColor3=RedzLib.Themes.Purple.TextDark; L2.TextSize=12; L2.TextXAlignment=Enum.TextXAlignment.Left; L2.TextWrapped=true
            Instance.new("UIPadding",F).PaddingBottom=UDim.new(0,10)
            local R={}; function R:Set(v) L2.Text=v end; function R:SetDesc(v) L2.Text=v end; return R
        end
        
        function Tab:AddToggle(C)
            local N = C.Name or C[1]; local D = C.Default or C[2] or false; local CB = C.Callback or function() end
            if RedzLib.Flags[N] ~= nil then D = RedzLib.Flags[N] end
            
            local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,40); B.Text=""; B.AutoButtonColor=false; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
            local L = Instance.new("TextLabel",B); L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,0); L.Size=UDim2.new(1,-60,1,0); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            
            local S=Instance.new("Frame",B); S.Position=UDim2.new(1,-50,0.5,-10); S.Size=UDim2.new(0,40,0,20); S.BackgroundColor3=D and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke; Instance.new("UICorner",S).CornerRadius=UDim.new(1,0)
            local Dot=Instance.new("Frame",S); Dot.Position=D and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8); Dot.Size=UDim2.new(0,16,0,16); Dot.BackgroundColor3=Color3.new(1,1,1); Instance.new("UICorner",Dot).CornerRadius=UDim.new(1,0)
            
            local function Tgl(V)
                RedzLib.Flags[N] = V
                S.BackgroundColor3 = V and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
                Dot.Position = V and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
                pcall(CB, V)
            end
            
            B.MouseButton1Click:Connect(function() Tgl(not RedzLib.Flags[N]) end)
            if C.Default ~= nil then pcall(CB, D) end -- Init callback
            
            local R={}; function R:Set(v) Tgl(v) end; return R
        end
        
        function Tab:AddButton(C)
            local N = C.Name or C[1]; local CB = C.Callback or C[2] or function() end
            local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,35); B.Font=Enum.Font.GothamMedium; B.Text=N; B.TextColor3=RedzLib.Themes.Purple.Text; B.TextSize=13; B.AutoButtonColor=false; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
            B.MouseButton1Click:Connect(function() 
                B.BackgroundColor3=RedzLib.Themes.Purple.Stroke; task.wait(0.1); B.BackgroundColor3=RedzLib.Themes.Purple.Main
                pcall(CB) 
            end)
        end
        
        function Tab:AddSlider(C) -- Simplified as Toggle for safety in V8
             local N, Min, Max, D, CB = C.Name or C[1], C.Min or 0, C.Max or 100, C.Default or 0, C.Callback or function() end
             -- Semi-real slider
             local F = Instance.new("Frame", Page); F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,50); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
             local L = Instance.new("TextLabel", F); L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,5); L.Size=UDim2.new(1,-20,0,20); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
             local VL = Instance.new("TextLabel", F); VL.BackgroundTransparency=1; VL.Position=UDim2.new(1,-50,0,5); VL.Size=UDim2.new(0,40,0,20); VL.Font=Enum.Font.Gotham; VL.Text=tostring(D); VL.TextColor3=RedzLib.Themes.Purple.TextDark; VL.TextSize=12
             local Bar = Instance.new("TextButton",F); Bar.BackgroundColor3=RedzLib.Themes.Purple.Stroke; Bar.Position=UDim2.new(0,10,0,30); Bar.Size=UDim2.new(1,-20,0,6); Bar.Text=""; Bar.AutoButtonColor=false; Instance.new("UICorner",Bar).CornerRadius=UDim.new(1,0)
             local Fill = Instance.new("Frame",Bar); Fill.BackgroundColor3=RedzLib.Themes.Purple.Accent; Fill.Size=UDim2.new((D-Min)/(Max-Min),0,1,0); Fill.BorderSizePixel=0; Instance.new("UICorner",Fill).CornerRadius=UDim.new(1,0)
             
             local function Upd(In)
                local S = math.clamp((In.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
                local V = math.floor(Min + ((Max-Min)*S))
                Fill.Size = UDim2.new(S,0,1,0); VL.Text=tostring(V)
                pcall(CB, V)
             end
             local Dr=false; Bar.InputBegan:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dr=true Upd(I) end end); UserInputService.InputEnded:Connect(function(I) if I.UserInputType==Enum.UserInputType.MouseButton1 then Dr=false end end); UserInputService.InputChanged:Connect(function(I) if Dr and I.UserInputType==Enum.UserInputType.MouseMovement then Upd(I) end end)
             local R={}; function R:Set(v) local S=math.clamp((v-Min)/(Max-Min),0,1); Fill.Size=UDim2.new(S,0,1,0); VL.Text=tostring(v); pcall(CB, v) end; return R
        end
        
        function Tab:AddDropdown(C) -- Simplified
             local N, O, D, CB = C.Name or C[1], C.Options or C.Values or {}, C.Default, C.Callback or function() end
             if not D then D=O[1] end
             local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,40); B.Text=N..": "..tostring(D); B.TextColor3=RedzLib.Themes.Purple.Text; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
             local idx = table.find(O, D) or 1
             B.MouseButton1Click:Connect(function() idx=idx+1; if idx>#O then idx=1 end; local val=O[idx]; B.Text=N..": "..tostring(val); pcall(CB, val) end)
             local R={}; function R:Set(v) B.Text=N..": "..tostring(v); pcall(CB, v) end; function R:Refresh(NO) O=NO; idx=1 end; return R
        end
        
        function Tab:AddTextbox(C)
            local N, D, CB = C.Name or "Textbox", C.Default or "", C.Callback or function() end
            local F = Instance.new("Frame", Page); F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,50); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            local L = Instance.new("TextLabel", F); L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,5); L.Size=UDim2.new(1,-20,0,20); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            local B = Instance.new("TextBox", F); B.BackgroundColor3=RedzLib.Themes.Purple.Sidebar; B.Position=UDim2.new(0,10,0,25); B.Size=UDim2.new(1,-20,0,20); B.Font=Enum.Font.Gotham; B.Text=D; B.TextColor3=RedzLib.Themes.Purple.Text; B.TextSize=12; Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
            B.FocusLost:Connect(function() pcall(CB, B.Text) end)
            local R={}; function R:Set(v) B.Text=v pcall(CB, v) end; return R
        end
        
        function Tab:AddDiscordInvite(C) end
        return Tab
    end
    RedzLib:Notification("Bóng X Hub", "Loaded Successfully!")
    return Window
end

return RedzLib
