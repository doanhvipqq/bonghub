--[[ 
    ✨ BÓNG X UI LIBRARY V8.1 - AUTO-INIT FIX ✨
    Fix: Critical bug where default values were not applied to script logic (causing weak/no attacks).
    Fix: Dropdown/Slider auto-fire callback on create.
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
            Duration = 5
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
    
    -- Draggable
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
    
    Instance.new("TextLabel", Sidebar).Text = Title; Sidebar.TextLabel.Font=Enum.Font.GothamBold; Sidebar.TextLabel.TextColor3=RedzLib.Themes.Purple.Text; Sidebar.TextLabel.Size=UDim2.new(1,0,0,20); Sidebar.TextLabel.BackgroundTransparency=1
    
    local Content = Instance.new("Frame", Main); Content.BackgroundColor3=RedzLib.Themes.Purple.Content; Content.Size=UDim2.new(1,-150,1,0); Content.Position=UDim2.new(0,150,0,0); Content.BorderSizePixel=0

    local Window = {Tabs = {}}

    function Window:Minimize(val) ScreenGui.Enabled = not val end

    function Window:MakeTab(C)
        local Title = type(C)=="table" and (C.Title or C[1]) or C or "Tab"
        
        local Btn = Instance.new("TextButton", Sidebar); Btn.BackgroundTransparency=1; Btn.Size=UDim2.new(1,-10,0,35); Btn.Font=Enum.Font.GothamMedium; Btn.Text=Title; Btn.TextColor3=RedzLib.Themes.Purple.TextDark; Btn.TextSize=13; Btn.TextXAlignment=Enum.TextXAlignment.Left; Instance.new("UICorner",Btn).CornerRadius=UDim.new(0,6)
        local Page = Instance.new("ScrollingFrame", Content); Page.BackgroundTransparency=1; Page.Size=UDim2.new(1,0,1,0); Page.Visible=false; Page.ScrollBarThickness=2
        Instance.new("UIListLayout", Page).Padding=UDim.new(0,5); Instance.new("UIPadding", Page).PaddingTop = UDim.new(0,10); Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0,10)
        Page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0,Page.UIListLayout.AbsoluteContentSize.Y+20) end)
        
        Btn.MouseButton1Click:Connect(function()
            for _, T in pairs(Window.Tabs) do T.Page.Visible=false; T.Btn.TextColor3=RedzLib.Themes.Purple.TextDark end
            Page.Visible=true; Btn.TextColor3=RedzLib.Themes.Purple.Text
        end)
        
        if #Window.Tabs == 0 then Page.Visible=true; Btn.TextColor3=RedzLib.Themes.Purple.Text end
        table.insert(Window.Tabs, {Btn=Btn, Page=Page})
        
        local Tab = {}
        
        function Tab:AddSection(C)
            local T = type(C)=="table" and (C.Name or C[1]) or C or ""
            local L = Instance.new("TextLabel", Page); L.BackgroundTransparency=1; L.Size=UDim2.new(1,0,0,25); L.Font=Enum.Font.GothamBold; L.Text=tostring(T); L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=14; L.TextXAlignment=Enum.TextXAlignment.Left
        end
        
        function Tab:AddParagraph(C)
            local T = C.Title or C[1] or ""; local D = C.Content or C.Desc or C[2] or ""
            local F = Instance.new("Frame", Page); F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.AutomaticSize=Enum.AutomaticSize.Y; F.Size=UDim2.new(1,0,0,0); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            local L2 = Instance.new("TextLabel",F); L2.BackgroundTransparency=1; L2.Position=UDim2.new(0,10,0,20); L2.Size=UDim2.new(1,-20,0,0); L2.AutomaticSize=Enum.AutomaticSize.Y; L2.Font=Enum.Font.Gotham; L2.Text=D; L2.TextColor3=RedzLib.Themes.Purple.TextDark; L2.TextSize=12; L2.TextXAlignment=Enum.TextXAlignment.Left; L2.TextWrapped=true
            Instance.new("TextLabel",F).Text=T; F.TextLabel.Position=UDim2.new(0,10,0,5); F.TextLabel.TextColor3=RedzLib.Themes.Purple.Text
            Instance.new("UIPadding",F).PaddingBottom=UDim.new(0,10)
            local R={}; function R:Set(v) L2.Text=v end; function R:SetDesc(v) L2.Text=v end; return R
        end
        
        function Tab:AddToggle(C)
            local N = C.Name or C[1]; local D = C.Default or C[2] or false; local CB = C.Callback or function() end
            if RedzLib.Flags[N] ~= nil then D = RedzLib.Flags[N] end
            
            local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,40); B.Text=""; B.AutoButtonColor=false; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
            local L = Instance.new("TextLabel",B); L.BackgroundTransparency=1; L.Position=UDim2.new(0,10,0,0); L.Size=UDim2.new(1,-60,1,0); L.Font=Enum.Font.GothamMedium; L.Text=N; L.TextColor3=RedzLib.Themes.Purple.Text; L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left
            local S=Instance.new("Frame",B); S.Position=UDim2.new(1,-50,0.5,-10); S.Size=UDim2.new(0,40,0,20); S.BackgroundColor3=D and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke; Instance.new("UICorner",S).CornerRadius=UDim.new(1,0)
            
            local function Tgl(V)
                RedzLib.Flags[N] = V
                S.BackgroundColor3 = V and RedzLib.Themes.Purple.Accent or RedzLib.Themes.Purple.Stroke
                pcall(CB, V)
            end
            
            B.MouseButton1Click:Connect(function() Tgl(not RedzLib.Flags[N]) end)
            
            -- IMPORTANT: Init Call
            RedzLib.Flags[N] = D
            task.spawn(function() pcall(CB, D) end) -- Non-blocking init
            
            local R={}; function R:Set(v) Tgl(v) end; return R
        end
        
        function Tab:AddButton(C)
            local N, CB = C.Name or C[1], C.Callback or C[2] or function() end
            local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,35); B.Font=Enum.Font.GothamMedium; B.Text=N; B.TextColor3=RedzLib.Themes.Purple.Text; B.TextSize=13; B.AutoButtonColor=false; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
            B.MouseButton1Click:Connect(function() pcall(CB) end)
        end
        
        function Tab:AddSlider(C)
             local N, Min, Max, D, CB = C.Name or C[1], C.Min or 0, C.Max or 100, C.Default or 0, C.Callback or function() end
             -- Init Call
             task.spawn(function() pcall(CB, D) end)
             return Tab:AddToggle({Name=N, Description="Slider (Use Checkbox logic)", Callback=CB, Default=(D>0)})
        end
        
        function Tab:AddDropdown(C)
             local N, O, D, CB = C.Name or C[1], C.Options or C.Values or {}, C.Default, C.Callback or function() end
             if not D then D=O[1] end
             local B = Instance.new("TextButton", Page); B.BackgroundColor3=RedzLib.Themes.Purple.Main; B.Size=UDim2.new(1,0,0,40); B.Text=N..": "..tostring(D); B.TextColor3=RedzLib.Themes.Purple.Text; Instance.new("UICorner",B).CornerRadius=UDim.new(0,6)
             local idx = table.find(O, D) or 1
             
             B.MouseButton1Click:Connect(function() idx=idx+1; if idx>#O then idx=1 end; local val=O[idx]; B.Text=N..": "..tostring(val); pcall(CB, val) end)
             
             -- IMPORTANT: Init Call
             task.spawn(function() pcall(CB, D) end)
             
             local R={}; function R:Set(v) B.Text=N..": "..tostring(v); pcall(CB, v) end; function R:Refresh(NO) O=NO; idx=1 end; return R
        end
        
        function Tab:AddTextbox(C)
            local N, D, CB = C.Name, C.Default or "", C.Callback or function() end
            local F = Instance.new("Frame", Page); F.BackgroundColor3=RedzLib.Themes.Purple.Main; F.Size=UDim2.new(1,0,0,50); Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
            local B = Instance.new("TextBox", F); B.Position=UDim2.new(0,10,0,25); B.Size=UDim2.new(1,-20,0,20); B.Text=D
            Instance.new("TextLabel",F).Text=N
            B.FocusLost:Connect(function() pcall(CB, B.Text) end)
            
            -- Init call
            task.spawn(function() pcall(CB, D) end)
            
            local R={}; function R:Set(v) B.Text=v pcall(CB, v) end; return R
        end
        
        function Tab:AddDiscordInvite(C) end
        return Tab
    end
    RedzLib:Notification("Bóng X Hub", "V8.1 Loaded - Variables Initialized")
    return Window
end

return RedzLib
