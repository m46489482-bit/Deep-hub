local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local Settings = {
    -- Rage
    AimEnabled = false,
    AimFOV = 200,
    Smoothness = 0.3,
    SilentAimEnabled = false,
    SilentFOV = 100,
    HitboxSize = 5,
    FOVEnabled = false,
    FOVValue = 200,
    FOVTransparency = 0.4,
    
    -- Visual
    ESPEnabled = false,
    MaxDistance = 50,
    SnaplinesEnabled = false,
    SnaplinePosition = "Bottom",
    ShowDistanceEnabled = false,
    FullbrightEnabled = false,
    AmbientColor = "Default",
    CameraFOVValue = 70,
    
    -- Misc
    NoclipEnabled = false,
    SpeedEnabled = false,
    SpeedValue = 50,
    JumpEnabled = false,
    JumpPower = 50,
    InfJumpEnabled = false,
    AntiAFKEnabled = false,
    BhopEnabled = false,
    FastAnimEnabled = false,
    
    -- Settings
    ThemeColor = "Purple",
    SeasonTheme = "None",
    FPSBoostEnabled = false,
    DeleteTexturesEnabled = false,
    GodModeEnabled = false,
}

-- ================= ЦВЕТА =================
local BaseColors = {
    Purple = Color3.fromRGB(130, 70, 255),
    Green = Color3.fromRGB(0, 255, 100),
    Red = Color3.fromRGB(255, 50, 50),
    Blue = Color3.fromRGB(0, 150, 255),
    White = Color3.fromRGB(220, 220, 220),
    Black = Color3.fromRGB(30, 30, 30)
}

local Theme = {
    Bg = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(24, 24, 30),
    Content = Color3.fromRGB(22, 22, 26),
    Accent = BaseColors.Purple,
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 160),
    ElementBg = Color3.fromRGB(32, 32, 40),
    ToggleOff = Color3.fromRGB(50, 50, 60),
    SliderBg = Color3.fromRGB(40, 40, 50),
    Close = Color3.fromRGB(255, 70, 70),
    BtnBg = Color3.fromRGB(30, 30, 35),
    BtnText = Color3.fromRGB(120, 90, 160),
}

-- ================= ГЛАВНЫЙ GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "DeepHubMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Theme.BtnBg 
toggleBtn.Text = "⚡ DEEP HUB"
toggleBtn.TextColor3 = Theme.BtnText 
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.AutoButtonColor = false
toggleBtn.Active = true
toggleBtn.Parent = gui
local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = toggleBtn
local ts = Instance.new("UIStroke"); ts.Color = Theme.BtnText; ts.Thickness = 1; ts.Transparency = 0.8; ts.Parent = toggleBtn

local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true; dragStartBtn = input.Position; startPosBtn = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then draggingBtn = false end
        end)
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInputBtn = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInputBtn and draggingBtn then
        local delta = input.Position - dragStartBtn
        toggleBtn.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
    end
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 280)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
mainFrame.BackgroundColor3 = Theme.Bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui
local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 12); mc.Parent = mainFrame
local ms = Instance.new("UIStroke"); ms.Color = Theme.Accent; ms.Thickness = 1.5; ms.Transparency = 0.7; ms.Parent = mainFrame

-- ================= ДЕКОРАЦИИ =================
local decoFolder = Instance.new("Folder")
decoFolder.Name = "Decorations"
decoFolder.Parent = mainFrame

local spiderWeb = Instance.new("Frame")
spiderWeb.Size = UDim2.new(0, 80, 0, 80)
spiderWeb.Position = UDim2.new(0, -10, 0, 35)
spiderWeb.BackgroundTransparency = 1
spiderWeb.Visible = false
spiderWeb.ZIndex = 5
spiderWeb.Parent = decoFolder
for i = 1, 5 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 80, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.Rotation = i * 15
    line.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    line.BackgroundTransparency = 0.5
    line.ZIndex = 5
    line.Parent = spiderWeb
end
for i = 1, 3 do
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, i*25, 0, i*25)
    circle.Position = UDim2.new(0.5, -i*12.5, 0.5, -i*12.5)
    circle.BackgroundTransparency = 1
    circle.ZIndex = 5
    circle.Parent = spiderWeb
    local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1, 0); cc.Parent = circle
    local cs = Instance.new("UIStroke"); cs.Color = Color3.fromRGB(200, 200, 200); cs.Transparency = 0.5; cs.Thickness = 1; cs.Parent = circle
end

local pumpkin = Instance.new("Frame")
pumpkin.Size = UDim2.new(0, 50, 0, 50)
pumpkin.Position = UDim2.new(1, -65, 1, -65)
pumpkin.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
pumpkin.Visible = false
pumpkin.ZIndex = 5
pumpkin.Parent = decoFolder
local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 20); pCorner.Parent = pumpkin
local eye1 = Instance.new("Frame"); eye1.Size = UDim2.new(0, 10, 0, 8); eye1.Position = UDim2.new(0, 10, 0, 10); eye1.Rotation = 20; eye1.BackgroundColor3 = Color3.fromRGB(50, 50, 50); eye1.ZIndex = 5; eye1.Parent = pumpkin
local eye2 = Instance.new("Frame"); eye2.Size = UDim2.new(0, 10, 0, 8); eye2.Position = UDim2.new(1, -20, 0, 10); eye2.Rotation = -20; eye2.BackgroundColor3 = Color3.fromRGB(50, 50, 50); eye2.ZIndex = 5; eye2.Parent = pumpkin
local mouth = Instance.new("Frame"); mouth.Size = UDim2.new(0, 20, 0, 10); mouth.Position = UDim2.new(0.5, -10, 0, 30); mouth.BackgroundColor3 = Color3.fromRGB(50, 50, 50); mouth.ZIndex = 5; mouth.Parent = pumpkin
local tooth1 = Instance.new("Frame"); tooth1.Size = UDim2.new(0, 4, 0, 4); tooth1.Position = UDim2.new(0, 2, 0, 0); tooth1.BackgroundColor3 = Color3.fromRGB(255, 140, 0); tooth1.ZIndex = 5; tooth1.Parent = mouth
local tooth2 = Instance.new("Frame"); tooth2.Size = UDim2.new(0, 4, 0, 4); tooth2.Position = UDim2.new(0, 10, 0, 6); tooth2.BackgroundColor3 = Color3.fromRGB(255, 140, 0); tooth2.ZIndex = 5; tooth2.Parent = mouth

local witchHat = Instance.new("Frame")
witchHat.Size = UDim2.new(0, 40, 0, 30)
witchHat.Position = UDim2.new(0, 60, 0, 5)
witchHat.BackgroundTransparency = 1
witchHat.Visible = false
witchHat.ZIndex = 5
witchHat.Parent = decoFolder
local hatBase = Instance.new("Frame"); hatBase.Size = UDim2.new(0, 30, 0, 5); hatBase.Position = UDim2.new(0.5, -15, 0, 20); hatBase.BackgroundColor3 = Color3.fromRGB(30, 20, 40); hatBase.ZIndex = 5; hatBase.Parent = witchHat
local hatTop = Instance.new("Frame"); hatTop.Size = UDim2.new(0, 20, 0, 20); hatTop.Position = UDim2.new(0.5, -10, 0, 5); hatTop.Rotation = 10; hatTop.BackgroundColor3 = Color3.fromRGB(30, 20, 40); hatTop.ZIndex = 5; hatTop.Parent = witchHat
local hatCorner = Instance.new("UICorner"); hatCorner.CornerRadius = UDim.new(0, 5); hatCorner.Parent = hatTop

local snowflake1 = Instance.new("Frame")
snowflake1.Size = UDim2.new(0, 30, 0, 30)
snowflake1.Position = UDim2.new(0, 10, 0, 40)
snowflake1.BackgroundTransparency = 1
snowflake1.Visible = false
snowflake1.ZIndex = 5
snowflake1.Parent = decoFolder
for i = 1, 6 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 30, 0, 2)
    line.Position = UDim2.new(0.5, -15, 0.5, -1)
    line.Rotation = i * 30
    line.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    line.ZIndex = 5
    line.Parent = snowflake1
end

local snowflake2 = Instance.new("Frame")
snowflake2.Size = UDim2.new(0, 40, 0, 40)
snowflake2.Position = UDim2.new(1, -55, 1, -65)
snowflake2.BackgroundTransparency = 1
snowflake2.Visible = false
snowflake2.ZIndex = 5
snowflake2.Parent = decoFolder
for i = 1, 6 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 40, 0, 2)
    line.Position = UDim2.new(0.5, -20, 0.5, -1)
    line.Rotation = i * 30
    line.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    line.ZIndex = 5
    line.Parent = snowflake2
end

local santaHat = Instance.new("Frame")
santaHat.Size = UDim2.new(0, 50, 0, 30)
santaHat.Position = UDim2.new(0, 60, 0, 0)
santaHat.BackgroundTransparency = 1
santaHat.Visible = false
santaHat.ZIndex = 5
santaHat.Parent = decoFolder
local sBase = Instance.new("Frame"); sBase.Size = UDim2.new(0, 40, 0, 10); sBase.Position = UDim2.new(0.5, -20, 0, 15); sBase.BackgroundColor3 = Color3.fromRGB(255, 255, 255); sBase.ZIndex = 5; sBase.Parent = santaHat; Instance.new("UICorner", sBase).CornerRadius = UDim.new(0, 5)
local sCone = Instance.new("Frame"); sCone.Size = UDim2.new(0, 30, 0, 20); sCone.Position = UDim2.new(0.5, -15, 0, 0); sCone.BackgroundColor3 = Color3.fromRGB(200, 30, 30); sCone.ZIndex = 5; sCone.Parent = santaHat; Instance.new("UICorner", sCone).CornerRadius = UDim.new(0, 10)
local sPom = Instance.new("Frame"); sPom.Size = UDim2.new(0, 10, 0, 10); sPom.Position = UDim2.new(0.5, -5, 0, -5); sPom.BackgroundColor3 = Color3.fromRGB(255, 255, 255); sPom.ZIndex = 5; sPom.Parent = santaHat; Instance.new("UICorner", sPom).CornerRadius = UDim.new(1, 0)

-- ================= ВЕРХНЯЯ ПАНЕЛЬ =================
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Theme.Sidebar
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.ZIndex = 2
topBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DEEP HUB | MULTI-TOOL"
titleText.TextColor3 = Theme.Accent
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.ZIndex = 2
titleText.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -32, 0, 5)
closeBtn.BackgroundColor3 = Theme.Close
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 2
closeBtn.Parent = topBar
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = closeBtn

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
topBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ================= БОКОВАЯ ПАНЕЛЬ =================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Theme.Sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = mainFrame

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar
local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 8)
sidePad.PaddingLeft = UDim.new(0, 8)
sidePad.PaddingRight = UDim.new(0, 8)
sidePad.Parent = sidebar

-- ================= КОНТЕНТ =================
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -100, 1, -35)
contentFrame.Position = UDim2.new(0, 100, 0, 35)
contentFrame.BackgroundColor3 = Theme.Content
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.ZIndex = 2
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
    page.ZIndex = 3
    page.Parent = contentFrame
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Parent = page
    local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10); pad.Parent = page
    return page
end

local homePage = createPage()
local ragePage = createPage()
local visualPage = createPage()
local miscPage = createPage()
local settingsPage = createPage()

-- ================= ИКОНКИ =================
local function drawIcon(iconType, parent)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 16, 0, 16)
    container.Position = UDim2.new(0, 8, 0.5, -8)
    container.BackgroundTransparency = 1
    container.ZIndex = 3
    container.Parent = parent

    if iconType == "Home" then
        local roof = Instance.new("Frame"); roof.Size = UDim2.new(0, 10, 0, 10); roof.Position = UDim2.new(0.5, -5, 0.5, -6); roof.Rotation = 45; roof.BackgroundColor3 = Theme.SubText; roof.ZIndex = 3; roof.Parent = container; Instance.new("UICorner", roof).CornerRadius = UDim.new(0, 1)
        local base = Instance.new("Frame"); base.Size = UDim2.new(0, 10, 0, 7); base.Position = UDim2.new(0.5, -5, 0.5, -1); base.BackgroundColor3 = Theme.SubText; base.ZIndex = 3; base.Parent = container; Instance.new("UICorner", base).CornerRadius = UDim.new(0, 1)
    elseif iconType == "Rage" then
        local c = Instance.new("Frame"); c.Size = UDim2.new(0, 10, 0, 10); c.Position = UDim2.new(0.5, -5, 0.5, -5); c.BackgroundTransparency = 1; c.ZIndex = 3; c.Parent = container; Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0); local s = Instance.new("UIStroke", c); s.Color = Theme.SubText; s.Thickness = 2
        local t = Instance.new("Frame"); t.Size = UDim2.new(0, 2, 0, 6); t.Position = UDim2.new(0.5, -1, -4, 0); t.BackgroundColor3 = Theme.SubText; t.ZIndex = 3; t.Parent = container; Instance.new("UICorner", t).CornerRadius = UDim.new(1, 0)
        local b = Instance.new("Frame"); b.Size = UDim2.new(0, 2, 0, 6); b.Position = UDim2.new(0.5, -1, 1, -6); b.BackgroundColor3 = Theme.SubText; b.ZIndex = 3; b.Parent = container; Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("Frame"); l.Size = UDim2.new(0, 6, 0, 2); l.Position = UDim2.new(-4, 0, 0.5, -1); l.BackgroundColor3 = Theme.SubText; l.ZIndex = 3; l.Parent = container; Instance.new("UICorner", l).CornerRadius = UDim.new(1, 0)
        local r = Instance.new("Frame"); r.Size = UDim2.new(0, 6, 0, 2); r.Position = UDim2.new(1, -6, 0.5, -1); r.BackgroundColor3 = Theme.SubText; r.ZIndex = 3; r.Parent = container; Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Visual" then
        local eyeBase = Instance.new("Frame"); eyeBase.Size = UDim2.new(0, 16, 0, 10); eyeBase.Position = UDim2.new(0.5, -8, 0.5, -5); eyeBase.BackgroundTransparency = 1; eyeBase.ZIndex = 3; eyeBase.Parent = container; Instance.new("UICorner", eyeBase).CornerRadius = UDim.new(1, 0); local s = Instance.new("UIStroke", eyeBase); s.Color = Theme.SubText; s.Thickness = 1.5
        local pupil = Instance.new("Frame"); pupil.Size = UDim2.new(0, 6, 0, 6); pupil.Position = UDim2.new(0.5, -3, 0.5, -3); pupil.BackgroundTransparency = 1; pupil.ZIndex = 3; pupil.Parent = container; Instance.new("UICorner", pupil).CornerRadius = UDim.new(1, 0); local ps = Instance.new("UIStroke", pupil); ps.Color = Theme.SubText; ps.Thickness = 1.5
        local dot = Instance.new("Frame"); dot.Size = UDim2.new(0, 3, 0, 3); dot.Position = UDim2.new(0.5, -1.5, 0.5, -1.5); dot.BackgroundColor3 = Theme.SubText; dot.ZIndex = 3; dot.Parent = container; Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Misc" then
        local head = Instance.new("Frame"); head.Size = UDim2.new(0, 5, 0, 5); head.Position = UDim2.new(0.5, -2.5, 0, 2); head.BackgroundColor3 = Theme.SubText; head.ZIndex = 3; head.Parent = container; Instance.new("UICorner", head).CornerRadius = UDim.new(1, 0)
        local body = Instance.new("Frame"); body.Size = UDim2.new(0, 7, 0, 7); body.Position = UDim2.new(0.5, -3.5, 0, 8); body.BackgroundColor3 = Theme.SubText; body.ZIndex = 3; body.Parent = container; Instance.new("UICorner", body).CornerRadius = UDim.new(0, 1)
        local armL = Instance.new("Frame"); armL.Size = UDim2.new(0, 6, 0, 2); armL.Position = UDim2.new(0, 1, 0, 8); armL.BackgroundColor3 = Theme.SubText; armL.ZIndex = 3; armL.Parent = container; Instance.new("UICorner", armL).CornerRadius = UDim.new(1, 0)
        local armR = Instance.new("Frame"); armR.Size = UDim2.new(0, 6, 0, 2); armR.Position = UDim2.new(1, -7, 0, 8); armR.BackgroundColor3 = Theme.SubText; armR.ZIndex = 3; armR.Parent = container; Instance.new("UICorner", armR).CornerRadius = UDim.new(1, 0)
    elseif iconType == "Settings" then
        local gear = Instance.new("Frame"); gear.Size = UDim2.new(0, 10, 0, 10); gear.Position = UDim2.new(0.5, -5, 0.5, -5); gear.BackgroundTransparency = 1; gear.ZIndex = 3; gear.Parent = container; Instance.new("UICorner", gear).CornerRadius = UDim.new(1, 0); local gs = Instance.new("UIStroke", gear); gs.Color = Theme.SubText; gs.Thickness = 2
        local t1 = Instance.new("Frame"); t1.Size = UDim2.new(0, 2, 0, 14); t1.Position = UDim2.new(0.5, -1, 0.5, -7); t1.BackgroundColor3 = Theme.SubText; t1.ZIndex = 3; t1.Parent = container; Instance.new("UICorner", t1).CornerRadius = UDim.new(1, 0)
        local t2 = Instance.new("Frame"); t2.Size = UDim2.new(0, 14, 0, 2); t2.Position = UDim2.new(0.5, -7, 0.5, -1); t2.BackgroundColor3 = Theme.SubText; t2.ZIndex = 3; t2.Parent = container; Instance.new("UICorner", t2).CornerRadius = UDim.new(1, 0)
        local hole = Instance.new("Frame"); hole.Size = UDim2.new(0, 4, 0, 4); hole.Position = UDim2.new(0.5, -2, 0.5, -2); hole.BackgroundColor3 = Theme.Bg; hole.ZIndex = 3; hole.Parent = container; Instance.new("UICorner", hole).CornerRadius = UDim.new(1, 0)
    end
    return container
end

-- ================= ФУНКЦИИ UI =================
local function createToggle(parent, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundColor3 = Theme.ElementBg
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = container

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 18)
    switch.Position = UDim2.new(1, -42, 0.5, -9)
    switch.BackgroundColor3 = Theme.ToggleOff
    switch.ZIndex = 3
    switch.Parent = container
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = switch

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.ZIndex = 3
    dot.Parent = switch
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = dot

    local state = false
    local isDragging = false
    local startPos = nil
    
    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            startPos = input.Position
        end
    end)
    
    container.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if (input.Position - startPos).Magnitude > 10 then
                isDragging = false
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            if (input.Position - startPos).Magnitude <= 10 then
                state = not state
                if state then
                    TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                    TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -15, 0.5, -6)}):Play()
                else
                    TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOff}):Play()
                    TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -6)}):Play()
                end
                callback(state)
            end
            isDragging = false
        end
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42)
    container.BackgroundColor3 = Theme.ElementBg
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.SubText
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = container

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 20)
    valLbl.Position = UDim2.new(1, -60, 0, 5)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(math.floor(default))
    valLbl.TextColor3 = Theme.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 11
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 3
    valLbl.Parent = container

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 4)
    barBg.Position = UDim2.new(0, 10, 1, -12)
    barBg.BackgroundColor3 = Theme.SliderBg
    barBg.ZIndex = 3
    barBg.Parent = container
    local bgc = Instance.new("UICorner"); bgc.CornerRadius = UDim.new(1, 0); bgc.Parent = barBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
    fill.ZIndex = 3
    fill.Parent = barBg
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1, 0); fc.Parent = fill

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
        valLbl.Text = tostring(val)
        callback(val)
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            update(input) 
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)
    callback(default)
end

local function createDropdown(parent, text, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundColor3 = Theme.ElementBg
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.ZIndex = 3
    container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container

    local header = Instance.new("TextButton")
    header.Size = UDim2.new(1, 0, 0, 32)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.ZIndex = 3
    header.Parent = container

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = header

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 1, 0)
    valLbl.Position = UDim2.new(1, -60, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = options[1]
    valLbl.TextColor3 = Theme.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 12
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 3
    valLbl.Parent = header

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Theme.SubText
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 10
    arrow.ZIndex = 3
    arrow.Parent = header

    local list = Instance.new("Frame")
    list.Size = UDim2.new(1, 0, 0, #options * 25)
    list.Position = UDim2.new(0, 0, 0, 32)
    list.BackgroundTransparency = 1
    list.ZIndex = 4
    list.Parent = container
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = list

    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32 + #options * 25)}):Play()
            arrow.Text = "▲"
        else
            TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
            arrow.Text = "▼"
        end
    end)

    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 25)
        optBtn.BackgroundColor3 = Theme.Bg
        optBtn.Text = opt
        optBtn.TextColor3 = Theme.SubText
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 11
        optBtn.AutoButtonColor = false
        optBtn.ZIndex = 4
        optBtn.Parent = list
        
        optBtn.MouseEnter:Connect(function() optBtn.BackgroundColor3 = Theme.Sidebar end)
        optBtn.MouseLeave:Connect(function() optBtn.BackgroundColor3 = Theme.Bg end)
        
        optBtn.MouseButton1Click:Connect(function()
            valLbl.Text = opt
            isOpen = false
            TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play()
            arrow.Text = "▼"
            callback(opt)
        end)
    end
end

-- ================= ЛОГИКА СМЕНЫ ТЕМ =================
local function applyColorTheme(colorName)
    local newAccent = BaseColors[colorName] or BaseColors.Purple
    Theme.Accent = newAccent
    Theme.BtnText = newAccent
    
    ms.Color = newAccent
    titleText.TextColor3 = newAccent
    toggleBtn.TextColor3 = newAccent
    ts.Color = newAccent
    
    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            local lbl = child:FindFirstChildOfClass("TextLabel")
            if lbl and child.BackgroundColor3 ~= Theme.Bg then
                lbl.TextColor3 = newAccent
                for _, obj in ipairs(child:GetDescendants()) do
                    if obj:IsA("Frame") and obj.BackgroundColor3 ~= Theme.Bg and obj.BackgroundTransparency == 0 then 
                        obj.BackgroundColor3 = newAccent 
                    end
                    if obj:IsA("UIStroke") then obj.Color = newAccent end
                end
            end
        end
    end
end

local function applySeasonTheme(themeName)
    spiderWeb.Visible = false
    pumpkin.Visible = false
    witchHat.Visible = false
    snowflake1.Visible = false
    snowflake2.Visible = false
    santaHat.Visible = false
    
    if themeName == "Halloween" then
        spiderWeb.Visible = true
        pumpkin.Visible = true
        witchHat.Visible = true
        Theme.Accent = Color3.fromRGB(200, 100, 0)
    elseif themeName == "NewYear" then
        snowflake1.Visible = true
        snowflake2.Visible = true
        santaHat.Visible = true
        Theme.Accent = Color3.fromRGB(100, 200, 255)
    else
        Theme.Accent = BaseColors[Settings.ThemeColor] or BaseColors.Purple
    end
    
    ms.Color = Theme.Accent
    titleText.TextColor3 = Theme.Accent
    toggleBtn.TextColor3 = Theme.Accent
    ts.Color = Theme.Accent
    
    for _, child in ipairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            local lbl = child:FindFirstChildOfClass("TextLabel")
            if lbl and child.BackgroundColor3 ~= Theme.Bg then
                lbl.TextColor3 = Theme.Accent
                for _, obj in ipairs(child:GetDescendants()) do
                    if obj:IsA("Frame") and obj.BackgroundColor3 ~= Theme.Bg and obj.BackgroundTransparency == 0 then 
                        obj.BackgroundColor3 = Theme.Accent 
                    end
                    if obj:IsA("UIStroke") then obj.Color = Theme.Accent end
                end
            end
        end
    end
end

-- ================= ЛОГИКА ВКЛАДОК =================
local function createTabButton(text, iconType, layoutOrder, pageToShow)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Theme.Bg
    btn.Text = ""
    btn.LayoutOrder = layoutOrder
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = sidebar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
    local icon = drawIcon(iconType, btn)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -30, 1, 0)
    lbl.Position = UDim2.new(0, 30, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.SubText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 3
    lbl.Parent = btn

    local function setIconColor(color)
        for _, obj in ipairs(icon:GetDescendants()) do
            if obj:IsA("Frame") then
                if obj.BackgroundTransparency == 0 and obj.BackgroundColor3 ~= Theme.Bg then obj.BackgroundColor3 = color end
            elseif obj:IsA("UIStroke") then obj.Color = color end
        end
    end

    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Bg
                local cLbl = child:FindFirstChildOfClass("TextLabel")
                if cLbl then cLbl.TextColor3 = Theme.SubText end
                for _, cIcon in ipairs(child:GetChildren()) do
                    if cIcon:IsA("Frame") and cIcon.BackgroundTransparency == 1 and cIcon ~= cLbl then
                        for _, obj in ipairs(cIcon:GetDescendants()) do
                            if obj:IsA("Frame") and obj.BackgroundTransparency == 0 then 
                                if obj.BackgroundColor3 ~= Theme.Bg then obj.BackgroundColor3 = Theme.SubText end
                            elseif obj:IsA("UIStroke") then obj.Color = Theme.SubText end
                        end
                    end
                end
            end
        end
        for _, page in ipairs(contentFrame:GetChildren()) do
            if page:IsA("ScrollingFrame") then page.Visible = false end
        end
        btn.BackgroundColor3 = Theme.ElementBg
        lbl.TextColor3 = Theme.Accent
        setIconColor(Theme.Accent)
        pageToShow.Visible = true
    end)
    return {Button = btn, Icon = icon, Label = lbl, SetColor = setIconColor}
end

local homeTab = createTabButton("HOME", "Home", 1, homePage)
local rageTab = createTabButton("RAGE", "Rage", 2, ragePage)
local visualTab = createTabButton("VISUAL", "Visual", 3, visualPage)
local miscTab = createTabButton("MISC", "Misc", 4, miscPage)
local settingsTab = createTabButton("SETTINGS", "Settings", 5, settingsPage)

homeTab.Button.BackgroundColor3 = Theme.ElementBg
homeTab.Label.TextColor3 = Theme.Accent
homeTab.SetColor(Theme.Accent)
homePage.Visible = true

-- ================= НАПОЛНЕНИЕ ВКЛАДОК =================
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 30)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Добро пожаловать в DEEP HUB!"
welcomeLabel.TextColor3 = Theme.Accent
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 16
welcomeLabel.ZIndex = 3
welcomeLabel.Parent = homePage

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, 0, 0, 120)
infoFrame.BackgroundColor3 = Theme.ElementBg
infoFrame.ZIndex = 3
infoFrame.Parent = homePage
local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0, 6); ic.Parent = infoFrame

local creditsText = Instance.new("TextLabel")
creditsText.Size = UDim2.new(1, -20, 1, 0)
creditsText.Position = UDim2.new(0, 10, 0, 0)
creditsText.BackgroundTransparency = 1
creditsText.Text = "Авторы:\n• hoptek\n• DeepSeek\n\nПоддержка:\nTG: @Gripoch"
creditsText.TextColor3 = Theme.Text
creditsText.Font = Enum.Font.Gotham
creditsText.TextSize = 13
creditsText.TextXAlignment = Enum.TextXAlignment.Left
creditsText.TextYAlignment = Enum.TextYAlignment.Center
creditsText.ZIndex = 3
creditsText.Parent = infoFrame

-- RAGE
createToggle(ragePage, "Aimbot (Наведение)", function(v) Settings.AimEnabled = v end)
createSlider(ragePage, "Aimbot FOV", 30, 600, Settings.AimFOV, function(v) Settings.AimFOV = v end)
createSlider(ragePage, "Плавность x100", 1, 100, Settings.Smoothness * 100, function(v) Settings.Smoothness = v / 100 end)
createToggle(ragePage, "Silent Aim (Hitbox)", function(v) Settings.SilentAimEnabled = v end)
createSlider(ragePage, "Silent FOV", 30, 300, Settings.SilentFOV, function(v) Settings.SilentFOV = v end)
createSlider(ragePage, "Hitbox (Размер головы)", 1, 20, Settings.HitboxSize, function(v) Settings.HitboxSize = v end)
createToggle(ragePage, "Show FOV (Показ круга)", function(v) Settings.FOVEnabled = v end)
createSlider(ragePage, "FOV Размер (Круг)", 30, 600, Settings.FOVValue, function(v) Settings.FOVValue = v end)
createSlider(ragePage, "Прозрачность FOV x100", 1, 100, Settings.FOVTransparency * 100, function(v) Settings.FOVTransparency = v / 100 end)
createSlider(ragePage, "Дистанция (м)", 5, 300, Settings.MaxDistance, function(v) Settings.MaxDistance = v end)

-- VISUAL
createToggle(visualPage, "Включить ESP (Подсветка)", function(v) Settings.ESPEnabled = v end)
createToggle(visualPage, "ESP Lines (Snaplines)", function(v) Settings.SnaplinesEnabled = v end)
createDropdown(visualPage, "Позиция линий", {"Bottom", "Top", "Center"}, function(val) Settings.SnaplinePosition = val end)
createToggle(visualPage, "Show Distance (Дистанция)", function(v) Settings.ShowDistanceEnabled = v end)

-- НОВЫЕ ВИЗУАЛЬНЫЕ ФУНКЦИИ
createToggle(visualPage, "Fullbright (Ночное зрение)", function(v) 
    Settings.FullbrightEnabled = v 
    if v then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)
createDropdown(visualPage, "Цвет освещения", {"Default", "Red", "Green", "Blue", "Purple"}, function(val) 
    Settings.AmbientColor = val 
    if val == "Default" then Lighting.Ambient = Color3.fromRGB(0,0,0)
    elseif val == "Red" then Lighting.Ambient = Color3.fromRGB(255,0,0)
    elseif val == "Green" then Lighting.Ambient = Color3.fromRGB(0,255,0)
    elseif val == "Blue" then Lighting.Ambient = Color3.fromRGB(0,0,255)
    elseif val == "Purple" then Lighting.Ambient = Color3.fromRGB(130,70,255)
    end
end)
createSlider(visualPage, "Camera FOV", 70, 120, Settings.CameraFOVValue, function(v) Settings.CameraFOVValue = v end)

local visInfo = Instance.new("Frame")
visInfo.Size = UDim2.new(1, 0, 0, 55)
visInfo.BackgroundColor3 = Theme.ElementBg
visInfo.ZIndex = 3
visInfo.Parent = visualPage
local vic = Instance.new("UICorner"); vic.CornerRadius = UDim.new(0, 6); vic.Parent = visInfo
local visText = Instance.new("TextLabel")
visText.Size = UDim2.new(1, -15, 1, 0)
visText.Position = UDim2.new(0, 8, 0, 0)
visText.BackgroundTransparency = 1
visText.Text = "🟢 Житель | 🔴 Охрана | 🔵 Коп"
visText.TextColor3 = Theme.SubText
visText.Font = Enum.Font.Gotham
visText.TextSize = 11
visText.TextXAlignment = Enum.TextXAlignment.Left
visText.ZIndex = 3
visText.Parent = visInfo

-- MISC
createToggle(miscPage, "Noclip (Сквозь стены)", function(v) Settings.NoclipEnabled = v end)
createToggle(miscPage, "Speedhack (Ускорение)", function(v) Settings.SpeedEnabled = v end)
createSlider(miscPage, "Скорость (Speed)", 16, 200, Settings.SpeedValue, function(v) Settings.SpeedValue = v end)
createToggle(miscPage, "Jump Power (Высота прыжка)", function(v) Settings.JumpEnabled = v end)
createSlider(miscPage, "Сила прыжка", 50, 300, Settings.JumpPower, function(v) Settings.JumpPower = v end)
createToggle(miscPage, "Infinite Jump (Беск. прыжок)", function(v) Settings.InfJumpEnabled = v end)

-- НОВЫЕ MISC ФУНКЦИИ
createToggle(miscPage, "Anti-AFK", function(v) 
    Settings.AntiAFKEnabled = v 
    if v then
        task.spawn(function()
            while Settings.AntiAFKEnabled do
                task.wait(15)
                if Settings.AntiAFKEnabled and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                    player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end
end)
createToggle(miscPage, "Bunny Hop (Bhop)", function(v) 
    Settings.BhopEnabled = v 
    if v then
        task.spawn(function()
            while Settings.BhopEnabled do
                task.wait(0.1)
                if Settings.BhopEnabled and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end)
createToggle(miscPage, "Fast Animation", function(v) Settings.FastAnimEnabled = v end)

-- SETTINGS
createDropdown(settingsPage, "Цвет меню", {"Purple", "Green", "Red", "Blue", "White", "Black"}, function(val) 
    Settings.ThemeColor = val
    if Settings.SeasonTheme == "None" then applyColorTheme(val) end
end)
createDropdown(settingsPage, "Тема (Праздник)", {"None", "Halloween", "NewYear"}, function(val) 
    Settings.SeasonTheme = val
    applySeasonTheme(val)
end)

createToggle(settingsPage, "FPS Boost (Оптимизация)", function(v) 
    Settings.FPSBoostEnabled = v 
    if v then
        pcall(function()
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("Sky") then
                    v.Enabled = false
                end
            end
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
        end)
    end
end)

createToggle(settingsPage, "Delete Textures (Удалить текстуры)", function(v) 
    Settings.DeleteTexturesEnabled = v 
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if v then
                if obj.Material ~= Enum.Material.SmoothPlastic then
                    obj.Material = Enum.Material.SmoothPlastic
                end
                if obj.TextureID ~= "" then
                    obj.TextureID = ""
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = v and 1 or 0
        elseif obj:IsA("ParticleEmitter") then
            obj.Enabled = not v
        end
    end
end)

createToggle(settingsPage, "God Mode (BETA)", function(v) 
    Settings.GodModeEnabled = v 
end)

-- Плашка с версией
local versionFrame = Instance.new("Frame")
versionFrame.Size = UDim2.new(1, 0, 0, 30)
versionFrame.BackgroundColor3 = Theme.ElementBg
versionFrame.ZIndex = 3
versionFrame.Parent = settingsPage
local vc = Instance.new("UICorner"); vc.CornerRadius = UDim.new(0, 6); vc.Parent = versionFrame

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 1, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "Версия: v1.1"
versionText.TextColor3 = Theme.Accent
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 12
versionText.ZIndex = 3
versionText.Parent = versionFrame

-- ================= ЛОГИКА GOD MODE =================
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.GodModeEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = humanoid.MaxHealth
                end
                if humanoid.MaxHealth ~= 99999 then
                    humanoid.MaxHealth = 99999
                    humanoid.Health = 99999
                end
            end
        end
    end
end)

-- ================= ЛОГИКА NOCLIP, SPEED, JUMP, FAST ANIM =================
local originalCollisions = {}

RunService.Stepped:Connect(function()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Settings.SpeedEnabled then humanoid.WalkSpeed = Settings.SpeedValue
            else if humanoid.WalkSpeed ~= 16 then humanoid.WalkSpeed = 16 end end
            
            if Settings.JumpEnabled then
                humanoid.UseJumpPower = true
                humanoid.JumpPower = Settings.JumpPower
            else
                if humanoid.JumpPower ~= 50 then humanoid.JumpPower = 50 end
            end
            
            if Settings.FastAnimEnabled then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    local animTrack = animator:GetPlayingAnimationTracks()
                    for _, track in ipairs(animTrack) do
                        track:AdjustSpeed(2)
                    end
                end
            end
        end

        local parts = player.Character:GetDescendants()
        if Settings.NoclipEnabled then
            for _, part in ipairs(parts) do
                if part:IsA("BasePart") then
                    if originalCollisions[part] == nil then originalCollisions[part] = part.CanCollide end
                    part.CanCollide = false
                end
            end
        else
            for part, originalState in pairs(originalCollisions) do
                if part and part.Parent then part.CanCollide = originalState end
            end
            table.clear(originalCollisions)
        end
    end
end)

-- ================= FOV КАМЕРЫ =================
RunService.RenderStepped:Connect(function()
    if camera then
        camera.FieldOfView = Settings.CameraFOVValue
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJumpEnabled then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

-- ================= ОТКРЫТИЕ / ЗАКРЫТИЕ =================
local isMenuOpen = true
local function setMenuVisible(v)
    isMenuOpen = v
    if v then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function() if not isMenuOpen then mainFrame.Visible = false end end)
    end
end
closeBtn.MouseButton1Click:Connect(function() setMenuVisible(false) end)
toggleBtn.MouseButton1Click:Connect(function() setMenuVisible(not isMenuOpen) end)

-- ================= FOV КРУГ =================
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.ZIndex = 1
fovCircle.Parent = gui
local circleCorner = Instance.new("UICorner"); circleCorner.CornerRadius = UDim.new(1, 0); circleCorner.Parent = fovCircle
local circleStroke = Instance.new("UIStroke"); circleStroke.Color = Theme.Accent; circleStroke.Thickness = 1; circleStroke.Parent = fovCircle

RunService.RenderStepped:Connect(function()
    if Settings.FOVEnabled then
        fovCircle.Visible = true
        fovCircle.Size = UDim2.new(0, Settings.FOVValue * 2, 0, Settings.FOVValue * 2)
        circleStroke.Transparency = Settings.FOVTransparency
        circleStroke.Color = Theme.Accent
    else
        fovCircle.Visible = false
    end
end)

-- ================= ЛОГИКА АИМА =================
local function getAllNPCs()
    local npcs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local humanoid = obj:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 and obj ~= player.Character then
                if not Players:GetPlayerFromCharacter(obj) and obj:FindFirstChild("Head") then
                    table.insert(npcs, obj)
                end
            end
        end
    end
    return npcs
end

local cachedTargets = {}
task.spawn(function()
    while true do
        cachedTargets = getAllNPCs()
        task.wait(1)
    end
end)

local function getClosestTarget(fovValue)
    local center = camera.ViewportSize / 2
    local closestNpc, minDist = nil, fovValue
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position

    for _, npc in ipairs(cachedTargets) do
        local head = npc:FindFirstChild("Head")
        if head and head.Parent then
            local distance3D = (head.Position - myPos).Magnitude
            if distance3D <= Settings.MaxDistance then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < minDist then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {player.Character, npc}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local result = Workspace:Raycast(camera.CFrame.Position, (head.Position - camera.CFrame.Position), rayParams)
                        if not result or result.Instance:IsDescendantOf(npc) then
                            minDist = dist
                            closestNpc = npc
                        end
                    end
                end
            end
        end
    end
    return closestNpc
end

RunService.RenderStepped:Connect(function()
    if not Settings.AimEnabled then return end
    local targetNpc = getClosestTarget(Settings.AimFOV)
    if targetNpc and targetNpc:FindFirstChild("Head") then
        local targetCFrame = CFrame.new(camera.CFrame.Position, targetNpc.Head.Position)
        camera.CFrame = camera.CFrame:Lerp(targetCFrame, Settings.Smoothness)
    end
end)

RunService.Heartbeat:Connect(function()
    if Settings.SilentAimEnabled then
        local targetNpc = getClosestTarget(Settings.SilentFOV)
        for _, npc in ipairs(cachedTargets) do
            local head = npc:FindFirstChild("Head")
            if head and head:IsA("BasePart") and npc ~= targetNpc then
                if head.Size.X > 2 then head.Size = Vector3.new(1, 1, 1) end
            end
        end
        if targetNpc and targetNpc:FindFirstChild("Head") then
            local head = targetNpc.Head
            if head:IsA("BasePart") then
                head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
            end
        end
    else
        for _, npc in ipairs(cachedTargets) do
            local head = npc:FindFirstChild("Head")
            if head and head:IsA("BasePart") and head.Size.X > 2 then
                head.Size = Vector3.new(1, 1, 1)
            end
        end
    end
end)

-- ================= ВИЗУАЛЫ (ESP, LINES, DISTANCE) =================
local espCache = {}
local snaplinesCache = {}
local distanceCache = {}
local hasDrawing = pcall(function() return Drawing.new("Line") end)

local function getColorByName(name)
    local lowerName = string.lower(name)
    if string.find(lowerName, "police") or string.find(lowerName, "cop") or string.find(lowerName, "officer") then
        return Color3.fromRGB(0, 100, 255)
    elseif string.find(lowerName, "guard") or string.find(lowerName, "security") then
        return Color3.fromRGB(255, 30, 30)
    else
        return Color3.fromRGB(0, 255, 0)
    end
end

task.spawn(function()
    while true do
        if Settings.ESPEnabled then
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
            local currentModels = {}
            
            for _, obj in ipairs(cachedTargets) do
                if obj.Parent and obj:FindFirstChild("Head") then
                    local head = obj:FindFirstChild("Head")
                    if (head.Position - myPos).Magnitude <= Settings.MaxDistance then
                        currentModels[obj] = true
                        if not espCache[obj] then
                            local highlight = Instance.new("Highlight")
                            highlight.Adornee = obj
                            highlight.FillColor = getColorByName(obj.Name)
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.FillTransparency = 0.6
                            highlight.OutlineTransparency = 0
                            highlight.Parent = obj
                            espCache[obj] = highlight
                        end
                    end
                end
            end

            for model, hl in pairs(espCache) do
                if not currentModels[model] then hl:Destroy() espCache[model] = nil end
            end
        else
            for model, hl in pairs(espCache) do hl:Destroy() end
            espCache = {}
        end
        task.wait(0.5)
    end
end)

RunService.RenderStepped:Connect(function()
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
    local screenW = camera.ViewportSize.X
    local screenH = camera.ViewportSize.Y

    if Settings.SnaplinesEnabled and hasDrawing then
        local currentModels = {}
        for _, obj in ipairs(cachedTargets) do
            if obj.Parent and obj:FindFirstChild("Head") then
                local head = obj:FindFirstChild("Head")
                if (head.Position - myPos).Magnitude <= Settings.MaxDistance then
                    currentModels[obj] = true
                    local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        local startX, startY
                        if Settings.SnaplinePosition == "Top" then startX, startY = screenW / 2, 0
                        elseif Settings.SnaplinePosition == "Bottom" then startX, startY = screenW / 2, screenH
                        else startX, startY = screenW / 2, screenH / 2 end

                        if not snaplinesCache[obj] then
                            local line = Drawing.new("Line")
                            line.Thickness = 1
                            line.Transparency = 0.8
                            snaplinesCache[obj] = line
                        end
                        
                        local line = snaplinesCache[obj]
                        line.From = Vector2.new(startX, startY)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Color = getColorByName(obj.Name)
                        line.Visible = true
                    else
                        if snaplinesCache[obj] then snaplinesCache[obj].Visible = false end
                    end
                end
            end
        end

        for model, line in pairs(snaplinesCache) do
            if not currentModels[model] then line:Remove() snaplinesCache[model] = nil end
        end
    else
        for model, line in pairs(snaplinesCache) do line:Remove() end
        snaplinesCache = {}
    end

    if Settings.ShowDistanceEnabled then
        for _, obj in ipairs(cachedTargets) do
            if obj.Parent and obj:FindFirstChild("Head") then
                local head = obj:FindFirstChild("Head")
                local distance = math.floor((head.Position - myPos).Magnitude)
                
                if distance <= Settings.MaxDistance then
                    local billboard = distanceCache[obj]
                    
                    if not billboard then
                        billboard = Instance.new("BillboardGui")
                        billboard.Name = "DistESP"
                        billboard.Size = UDim2.new(0, 50, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 0.5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = head
                        billboard.Parent = head
                        
                        local text = Instance.new("TextLabel")
                        text.Name = "DistText"
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.new(1, 1, 1)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 10
                        text.TextStrokeTransparency = 0
                        text.Text = distance .. "m"
                        text.Parent = billboard
                        
                        distanceCache[obj] = billboard
                    else
                        local text = billboard:FindFirstChild("DistText")
                        if text then text.Text = distance .. "m" end
                    end
                else
                    if distanceCache[obj] then
                        distanceCache[obj]:Destroy()
                        distanceCache[obj] = nil
                    end
                end
            end
        end
        
        for model, billboard in pairs(distanceCache) do
            if not model.Parent or not model:FindFirstChild
