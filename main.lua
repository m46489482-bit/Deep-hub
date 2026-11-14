local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local S = {
    Aim = false, AimFOV = 200, Smooth = 0.2, AimDist = 150,
    Silent = false, SilentFOV = 100, Hitbox = 5,
    FOV = false, FOVVal = 200, FOVTrans = 0.4,
    ESP = false, ESPDist = 150, Lines = false, ShowDist = false, LinePos = "Bottom",
    Noclip = false, Speed = false, SpeedVal = 50, Jump = false, JumpPower = 50, InfJump = false,
    God = false, FPS = false, DelTex = false, Fullbright = false,
    AntiAFK = false, Bhop = false, FastAnim = false,
    Fly = false, AntiVoid = false, AntiArrest = false, Crosshair = false, AutoRob = false,
    MenuSize = 100
}

local Binds = {
    Aimbot = Enum.KeyCode.Q,
    ESP = Enum.KeyCode.E,
    Fly = Enum.KeyCode.Z,
    Speed = Enum.KeyCode.X
}
local BindButtons = {}
local listeningFor = nil

local Theme = {
    Bg = Color3.fromRGB(18, 18, 22), Sidebar = Color3.fromRGB(24, 24, 30), Content = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(130, 70, 255), 
    Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(150, 150, 160),
    ElementBg = Color3.fromRGB(32, 32, 40), ToggleOff = Color3.fromRGB(50, 50, 60), SliderBg = Color3.fromRGB(40, 40, 50),
    Close = Color3.fromRGB(60, 60, 70)
}

local gui = Instance.new("ScreenGui")
gui.Name = "DeepHubMenu"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.Parent = CoreGui

local wm = Instance.new("TextLabel")
wm.Size = UDim2.new(0, 300, 0, 25); wm.Position = UDim2.new(1, -310, 0, 10)
wm.BackgroundTransparency = 0.4; wm.BackgroundColor3 = Theme.Bg; wm.TextColor3 = Theme.Accent
wm.Font = Enum.Font.GothamSemibold; wm.TextSize = 12; wm.Text = "DEEP HUB v0.25 Alpha"
wm.Visible = false; wm.ZIndex = 10; wm.Parent = gui

local fps = 0
local frameCount = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = tick()
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if wm.Visible then
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            local players = #Players:GetPlayers()
            wm.Text = string.format("DEEP HUB | FPS: %d | PING: %dms | Players: %d", fps, ping, players)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if wm.Visible then
            TweenService:Create(wm, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.7, BackgroundTransparency = 0.8}):Play()
            task.wait(2)
            TweenService:Create(wm, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0, BackgroundTransparency = 0.4}):Play()
        end
    end
end)

local function ShowNotification(title, state)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 160, 0, 28)
    notif.BackgroundColor3 = Theme.Bg
    notif.BackgroundTransparency = 0.1
    notif.AnchorPoint = Vector2.new(0.5, 0)
    notif.Position = UDim2.new(0.5, 0, 0, -50)
    notif.ZIndex = 100; notif.Parent = gui

    local nc = Instance.new("UICorner"); nc.CornerRadius = UDim.new(1, 0); nc.Parent = notif
    local ns = Instance.new("UIStroke"); ns.Color = state and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50); ns.Thickness = 1.5; ns.Parent = notif

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1
    txt.Text = title .. (state and " : ВКЛ" or " : ВЫКЛ")
    txt.TextColor3 = Color3.fromRGB(190, 150, 255)
    txt.Font = Enum.Font.GothamBold; txt.TextSize = 11; txt.TextXAlignment = Enum.TextXAlignment.Center; txt.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    task.delay(1, function()
        local tw = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -50)})
        tw:Play()
        tw.Completed:Connect(function() notif:Destroy() end)
    end)
end

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45); toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Theme.Bg; toggleBtn.Text = ""; toggleBtn.AutoButtonColor = false
toggleBtn.Active = true; toggleBtn.Visible = false; toggleBtn.ZIndex = 10; toggleBtn.Parent = gui
toggleBtn.BackgroundTransparency = 0.2
local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = toggleBtn
local ts = Instance.new("UIStroke"); ts.Color = Theme.Accent; ts.Thickness = 2; ts.Transparency = 0.5; ts.Parent = toggleBtn

local tDiamond = Instance.new("Frame", toggleBtn)
tDiamond.Size = UDim2.new(0, 22, 0, 22); tDiamond.Position = UDim2.new(0.5, -11, 0.5, -11)
tDiamond.BackgroundColor3 = Theme.Accent; tDiamond.Rotation = 45; tDiamond.ZIndex = 11
local tdc = Instance.new("UICorner", tDiamond); tdc.CornerRadius = UDim.new(0, 3)

local tInner = Instance.new("Frame", tDiamond)
tInner.Size = UDim2.new(0, 14, 0, 14); tInner.Position = UDim2.new(0.5, -7, 0.5, -7)
tInner.BackgroundColor3 = Theme.Bg; tInner.Rotation = 45; tInner.ZIndex = 12
local tic = Instance.new("UICorner", tInner); tic.CornerRadius = UDim.new(0, 2)

local isDraggingToggle = false
task.spawn(function()
    while task.wait(1.2) do
        if not isDraggingToggle and toggleBtn.Visible then
            TweenService:Create(toggleBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 50, 0, 50)}):Play()
            TweenService:Create(ts, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0, Thickness = 3}):Play()
            task.wait(1.2)
            TweenService:Create(toggleBtn, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 45, 0, 45)}):Play()
            TweenService:Create(ts, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Transparency = 0.6, Thickness = 2}):Play()
        end
    end
end)

local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true; isDraggingToggle = true; dragStartBtn = input.Position; startPosBtn = toggleBtn.Position
        toggleBtn.Size = UDim2.new(0, 45, 0, 45)
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingBtn = false; isDraggingToggle = false end end)
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
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 400, 0, 280)
mainFrame.BackgroundColor3 = Theme.Bg; mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0; mainFrame.Active = true; mainFrame.ClipsDescendants = true; mainFrame.Visible = false; mainFrame.Parent = gui

local mainScale = Instance.new("UIScale")
mainScale.Scale = S.MenuSize / 100
mainScale.Parent = mainFrame

local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 12); mc.Parent = mainFrame
local ms = Instance.new("UIStroke"); ms.Color = Theme.Accent; ms.Thickness = 1.5; ms.Transparency = 0.7; ms.Parent = mainFrame

local bgDeco = Instance.new("Frame")
bgDeco.Size = UDim2.new(1, 0, 1, 0)
bgDeco.BackgroundTransparency = 1
bgDeco.ZIndex = 0
bgDeco.Parent = mainFrame

for i = 1, 5 do
    local diamond = Instance.new("Frame")
    diamond.Size = UDim2.new(0, math.random(20, 60), 0, math.random(20, 60))
    diamond.Position = UDim2.new(math.random(10, 90)/100, 0, math.random(10, 90)/100, 0)
    diamond.Rotation = 45
    diamond.BackgroundColor3 = Theme.Accent
    diamond.BackgroundTransparency = math.random(85, 95)/100
    diamond.BorderSizePixel = 0
    diamond.ZIndex = 0
    diamond.Parent = bgDeco
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 5); dc.Parent = diamond
end

local fog = Instance.new("Frame")
fog.Size = UDim2.new(1, 0, 0, 80)
fog.Position = UDim2.new(0, 0, 1, -80)
fog.BackgroundColor3 = Color3.fromRGB(130, 70, 255)
fog.BackgroundTransparency = 0.5
fog.BorderSizePixel = 0
fog.ZIndex = 5
fog.Parent = mainFrame

local fogGrad = Instance.new("UIGradient")
fogGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 70, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 90))}
fogGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.7, 0.7), NumberSequenceKeypoint.new(1, 0.3)}
fogGrad.Rotation = 90
fogGrad.Parent = fog
local fogCorner = Instance.new("UICorner"); fogCorner.CornerRadius = UDim.new(0, 12); fogCorner.Parent = fog

local function spawnParticle()
    local p = Instance.new("Frame")
    local size = math.random(3, 6)
    p.Size = UDim2.new(0, size, 0, size)
    p.Position = UDim2.new(math.random(5, 95)/100, 0, 1, -5)
    p.BackgroundColor3 = Color3.fromRGB(220, 190, 255)
    p.BackgroundTransparency = 0.2
    p.BorderSizePixel = 0
    p.ZIndex = 6
    p.Parent = mainFrame
    
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(1, 0); pc.Parent = p
    
    local targetX = p.Position.X.Offset / 100 + math.random(-25, 25) / 100
    local targetY = 1 - (math.random(30, 70) / 100)
    
    local tween = TweenService:Create(p, TweenInfo.new(math.random(15, 30)/10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(targetX, 0, targetY, 0), BackgroundTransparency = 1, Size = UDim2.new(0, 1, 0, 1)})
    tween:Play()
    tween.Completed:Connect(function() p:Destroy() end)
end

task.spawn(function()
    while task.wait(0.1) do
        if mainFrame.Visible then 
            spawnParticle() 
            if math.random(1, 3) == 1 then spawnParticle() end
        end
    end
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35); 
topBar.BackgroundColor3 = Theme.Accent
topBar.BackgroundTransparency = 0.1 
topBar.BorderSizePixel = 0; topBar.Active = true; topBar.ZIndex = 3; topBar.Parent = mainFrame
local tbc = Instance.new("UICorner"); tbc.CornerRadius = UDim.new(0, 12); tbc.Parent = topBar

local headerLogo = Instance.new("Frame")
headerLogo.Size = UDim2.new(0, 18, 0, 18); headerLogo.Position = UDim2.new(0, 12, 0.5, -9)
headerLogo.BackgroundColor3 = Theme.Bg; headerLogo.Rotation = 45; headerLogo.ZIndex = 4; headerLogo.Parent = topBar
local hlc = Instance.new("UICorner"); hlc.CornerRadius = UDim.new(0, 3); hlc.Parent = headerLogo

local hInner = Instance.new("Frame", headerLogo)
hInner.Size = UDim2.new(0, 10, 0, 10); hInner.Position = UDim2.new(0.5, -5, 0.5, -5)
hInner.BackgroundColor3 = Theme.Accent; hInner.Rotation = 45; hInner.ZIndex = 5
local hic = Instance.new("UICorner", hInner); hic.CornerRadius = UDim.new(0, 1)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -100, 1, 0); titleText.Position = UDim2.new(0, 40, 0, 0); titleText.BackgroundTransparency = 1
titleText.Text = "DEEP HUB | PRO v0.25 Alpha"; 
titleText.TextColor3 = Color3.fromRGB(20, 20, 25)
titleText.Font = Enum.Font.GothamBold; titleText.TextSize = 13
titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.ZIndex = 4; titleText.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24); closeBtn.Position = UDim2.new(1, -32, 0, 5); closeBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 13; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 4; closeBtn.Parent = topBar
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = closeBtn

local origCloseColor = closeBtn.BackgroundColor3
local hoverCloseColor = Color3.fromRGB(255, 50, 50)

local function animateClose(enter)
    TweenService:Create(closeBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = enter and hoverCloseColor or origCloseColor, Rotation = enter and 90 or 0}):Play()
end

closeBtn.MouseEnter:Connect(function() animateClose(true) end)
closeBtn.MouseLeave:Connect(function() animateClose(false) end)
closeBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then animateClose(true) end end)
closeBtn.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then animateClose(false) end end)

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = mainFrame.Position end
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

local sidebar = Instance.new("ScrollingFrame")
sidebar.Size = UDim2.new(0, 100, 1, -35); sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Theme.Sidebar; sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.ScrollBarThickness = 0; sidebar.CanvasSize = UDim2.new(0, 0, 0, 0); sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebar.ZIndex = 3; sidebar.Parent = mainFrame
local sideCorner = Instance.new("UICorner"); sideCorner.CornerRadius = UDim.new(0, 12); sideCorner.Parent = sidebar
local sideLayout = Instance.new("UIListLayout"); sideLayout.Padding = UDim.new(0, 4); sideLayout.SortOrder = Enum.SortOrder.LayoutOrder; sideLayout.Parent = sidebar
local sidePad = Instance.new("UIPadding"); sidePad.PaddingTop = UDim.new(0, 8); sidePad.PaddingLeft = UDim.new(0, 8); sidePad.PaddingRight = UDim.new(0, 8); sidePad.Parent = sidebar

local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 84, 0, 84)
avatarFrame.Position = UDim2.new(0.5, -42, 0, 8)
avatarFrame.BackgroundColor3 = Theme.ElementBg; avatarFrame.BackgroundTransparency = 0.2
avatarFrame.ZIndex = 3
avatarFrame.Parent = sidebar
local avCorner = Instance.new("UICorner"); avCorner.CornerRadius = UDim.new(0, 10); avCorner.Parent = avatarFrame
local avStroke = Instance.new("UIStroke"); avStroke.Color = Theme.Accent; avStroke.Thickness = 2; avStroke.Transparency = 0.3; avStroke.Parent = avatarFrame

local avDiamond = Instance.new("Frame")
avDiamond.Size = UDim2.new(0, 40, 0, 40); avDiamond.Position = UDim2.new(0.5, -20, 0.5, -20)
avDiamond.BackgroundColor3 = Theme.Accent; avDiamond.Rotation = 45; avDiamond.ZIndex = 4; avDiamond.Parent = avatarFrame
local adc = Instance.new("UICorner"); adc.CornerRadius = UDim.new(0, 6); adc.Parent = avDiamond

local avInner = Instance.new("Frame")
avInner.Size = UDim2.new(0, 26, 0, 26); avInner.Position = UDim2.new(0.5, -13, 0.5, -13)
avInner.BackgroundColor3 = Theme.Bg; avInner.Rotation = 45; avInner.ZIndex = 5; avInner.Parent = avatarFrame
local aic = Instance.new("UICorner"); aic.CornerRadius = UDim.new(0, 4); aic.Parent = avInner

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -100, 1, -35); contentFrame.Position = UDim2.new(0, 100, 0, 35); contentFrame.BackgroundColor3 = Theme.Content
contentFrame.BackgroundTransparency = 0.2
contentFrame.BorderSizePixel = 0; contentFrame.ClipsDescendants = true; contentFrame.ZIndex = 3; contentFrame.Parent = mainFrame
local contentCorner = Instance.new("UICorner"); contentCorner.CornerRadius = UDim.new(0, 12); contentCorner.Parent = contentFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0); page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 2; page.ScrollBarImageColor3 = Theme.Accent; page.Visible = false; page.ZIndex = 4; page.Parent = contentFrame
    local layout = Instance.new("UIListLayout"); layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Parent = page
    local pad = Instance.new("UIPadding"); pad.PaddingTop = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10); pad.Parent = page
    return page
end

local homePage = createPage(); local ragePage = createPage(); local visualPage = createPage(); local miscPage = createPage(); local settingsPage = createPage(); local helpPage = createPage()

local function createTabButton(text, layoutOrder, pageToShow)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Theme.Bg
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.LayoutOrder = layoutOrder
    btn.AutoButtonColor = false
    btn.ZIndex = 4
    btn.Parent = sidebar
    
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(sidebar:GetChildren()) do 
            if child:IsA("TextButton") then 
                TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.Bg, TextColor3 = Theme.SubText, BackgroundTransparency = 0.3}):Play()
            end 
        end
        for _, page in ipairs(contentFrame:GetChildren()) do 
            if page:IsA("ScrollingFrame") then page.Visible = false end 
        end
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Theme.ElementBg, TextColor3 = Theme.Accent, BackgroundTransparency = 0.1}):Play()
        pageToShow.Visible = true
        pageToShow.Position = UDim2.new(0, 20, 0, 0)
        TweenService:Create(pageToShow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
    return btn
end

local homeTab = createTabButton("HOME", 1, homePage); local rageTab = createTabButton("RAGE", 2, ragePage); local visualTab = createTabButton("VISUAL", 3, visualPage); local miscTab = createTabButton("MISC", 4, miscPage); local settingsTab = createTabButton("SETTINGS", 5, settingsPage); local helpTab = createTabButton("HELP", 6, helpPage)
homeTab.BackgroundColor3 = Theme.ElementBg; homeTab.TextColor3 = Theme.Accent; homeTab.BackgroundTransparency = 0.1; homePage.Visible = true

local function createToggle(parent, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32); container.BackgroundColor3 = Theme.ElementBg; container.BackgroundTransparency = 0.2; container.BorderSizePixel = 0; container.ZIndex = 4; container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4; lbl.Parent = container
    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 18); switch.Position = UDim2.new(1, -42, 0.5, -9); switch.BackgroundColor3 = Theme.ToggleOff; switch.ZIndex = 4; switch.Parent = container
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = switch
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12); dot.Position = UDim2.new(0, 3, 0.5, -6); dot.BackgroundColor3 = Color3.new(1, 1, 1); dot.ZIndex = 4; dot.Parent = switch
    local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = dot
    local state = false
    local isDragging = false
    local startPos = nil
    container.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true; startPos = input.Position end end)
    container.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then if (input.Position - startPos).Magnitude > 10 then isDragging = false end end end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            if (input.Position - startPos).Magnitude <= 10 then
                state = not state
                if state then TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play(); TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(1, -15, 0.5, -6)}):Play()
                else TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ToggleOff}):Play(); TweenService:Create(dot, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -6)}):Play() end
                callback(state); ShowNotification(text, state)
            end
            isDragging = false
        end
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 42); container.BackgroundColor3 = Theme.ElementBg; container.BackgroundTransparency = 0.2; container.BorderSizePixel = 0; container.ZIndex = 4; container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.SubText; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4; lbl.Parent = container
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 50, 0, 20); valLbl.Position = UDim2.new(1, -60, 0, 5); valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(math.floor(default)); valLbl.TextColor3 = Theme.Accent; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.ZIndex = 4; valLbl.Parent = container
    
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 4); barBg.Position = UDim2.new(0, 10, 1, -12); barBg.BackgroundColor3 = Theme.SliderBg; barBg.ZIndex = 4; barBg.Parent = container
    local bgc = Instance.new("UICorner"); bgc.CornerRadius = UDim.new(1, 0); bgc.Parent = barBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; fill.ZIndex = 4; fill.Parent = barBg
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1, 0); fc.Parent = fill

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 10, 0, 10)
    thumb.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    thumb.BackgroundColor3 = Theme.Accent
    thumb.ZIndex = 4; thumb.Parent = barBg
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = thumb
    local tStroke = Instance.new("UIStroke"); tStroke.Color = Theme.Bg; tStroke.Thickness = 1.5; tStroke.Parent = thumb

    thumb.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then TweenService:Create(thumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 14, 0, 14)}):Play() end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then TweenService:Create(thumb, TweenInfo.new(0.2), {Size = UDim2.new(0, 10, 0, 10)}):Play() end end)

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        TweenService:Create(fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
        TweenService:Create(thumb, TweenInfo.new(0.1), {Position = UDim2.new(rel, -5, 0.5, -7)}):Play()
        valLbl.Text = tostring(val); callback(val)
    end

    local function startDrag(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end
    barBg.InputBegan:Connect(startDrag)
    thumb.InputBegan:Connect(startDrag)

    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    callback(default)
end

local function createDropdown(parent, text, options, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32); container.BackgroundColor3 = Theme.ElementBg; container.BackgroundTransparency = 0.2; container.ClipsDescendants = true; container.ZIndex = 4; container.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = container
    local header = Instance.new("TextButton"); header.Size = UDim2.new(1, 0, 0, 32); header.BackgroundTransparency = 1; header.Text = ""; header.ZIndex = 4; header.Parent = container
    local lbl = Instance.new("TextLabel"); lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4; lbl.Parent = header
    local valLbl = Instance.new("TextLabel"); valLbl.Size = UDim2.new(0, 50, 1, 0); valLbl.Position = UDim2.new(1, -60, 0, 0); valLbl.BackgroundTransparency = 1; valLbl.Text = options[1]; valLbl.TextColor3 = Theme.Accent; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 12; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.ZIndex = 4; valLbl.Parent = header
    local arrow = Instance.new("TextLabel"); arrow.Size = UDim2.new(0, 20, 1, 0); arrow.Position = UDim2.new(1, -20, 0, 0); arrow.BackgroundTransparency = 1; arrow.Text = "▼"; arrow.TextColor3 = Theme.SubText; arrow.Font = Enum.Font.GothamBold; arrow.TextSize = 10; arrow.ZIndex = 4; arrow.Parent = header
    local list = Instance.new("Frame"); list.Size = UDim2.new(1, 0, 0, #options * 25); list.Position = UDim2.new(0, 0, 0, 32); list.BackgroundTransparency = 1; list.ZIndex = 5; list.Parent = container
    local listLayout = Instance.new("UIListLayout"); listLayout.Parent = list
    local isOpen = false
    header.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32 + #options * 25)}):Play(); arrow.Text = "▲"
        else TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play(); arrow.Text = "▼" end
    end)
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton"); optBtn.Size = UDim2.new(1, 0, 0, 25); optBtn.BackgroundColor3 = Theme.Bg; optBtn.BackgroundTransparency = 0.1; optBtn.Text = opt; optBtn.TextColor3 = Theme.SubText; optBtn.Font = Enum.Font.Gotham; optBtn.TextSize = 11; optBtn.AutoButtonColor = false; optBtn.ZIndex = 5; optBtn.Parent = list
        optBtn.MouseButton1Click:Connect(function()
            valLbl.Text = opt; isOpen = false; TweenService:Create(container, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 32)}):Play(); arrow.Text = "▼"; callback(opt)
        end)
    end
end

local welcome = Instance.new("TextLabel"); welcome.Size = UDim2.new(1, 0, 0, 30); welcome.BackgroundTransparency = 1; welcome.Text = "DEEP HUB | PRO"; welcome.TextColor3 = Theme.Accent; welcome.Font = Enum.Font.GothamSemibold; welcome.TextSize = 18; welcome.ZIndex = 4; welcome.LayoutOrder = 1; welcome.Parent = homePage

local statusFrame = Instance.new("Frame"); statusFrame.Size = UDim2.new(1, 0, 0, 70); statusFrame.BackgroundColor3 = Theme.ElementBg; statusFrame.BackgroundTransparency = 0.2; statusFrame.ZIndex = 4; statusFrame.LayoutOrder = 2; statusFrame.Parent = homePage
local stc = Instance.new("UICorner"); stc.CornerRadius = UDim.new(0, 6); stc.Parent = statusFrame
local statusTitle = Instance.new("TextLabel"); statusTitle.Size = UDim2.new(1, -20, 0, 20); statusTitle.Position = UDim2.new(0, 10, 0, 10); statusTitle.BackgroundTransparency = 1; statusTitle.Text = "Статус:"; statusTitle.TextColor3 = Theme.SubText; statusTitle.Font = Enum.Font.GothamSemibold; statusTitle.TextSize = 12; statusTitle.TextXAlignment = Enum.TextXAlignment.Left; statusTitle.ZIndex = 4; statusTitle.Parent = statusFrame
local statusText = Instance.new("TextLabel"); statusText.Size = UDim2.new(1, -20, 0, 20); statusText.Position = UDim2.new(0, 10, 0, 30); statusText.BackgroundTransparency = 1; statusText.Text = "🟢 Работает (Undetected) | Alpha"; statusText.TextColor3 = Color3.fromRGB(0, 255, 100); statusText.Font = Enum.Font.GothamSemibold; statusText.TextSize = 14; statusText.TextXAlignment = Enum.TextXAlignment.Left; statusText.ZIndex = 4; statusText.Parent = statusFrame

local credits = Instance.new("TextLabel"); credits.Size = UDim2.new(1, 0, 0, 60); credits.BackgroundTransparency = 1; credits.Text = "Авторы:\n• hoptek\n• DeepSeek\n\nВерсия: v0.25 Alpha"; credits.TextColor3 = Theme.Text; credits.Font = Enum.Font.Gotham; credits.TextSize = 13; credits.TextXAlignment = Enum.TextXAlignment.Left; credits.ZIndex = 4; credits.LayoutOrder = 3; credits.Parent = homePage

local changelogFrame = Instance.new("Frame"); changelogFrame.Size = UDim2.new(1, 0, 0, 85); changelogFrame.BackgroundColor3 = Theme.ElementBg; changelogFrame.BackgroundTransparency = 0.2; changelogFrame.ZIndex = 4; changelogFrame.LayoutOrder = 4; changelogFrame.Parent = homePage
local clc = Instance.new("UICorner"); clc.CornerRadius = UDim.new(0, 6); clc.Parent = changelogFrame
local clTitle = Instance.new("TextLabel"); clTitle.Size = UDim2.new(1, -10, 0, 20); clTitle.Position = UDim2.new(0, 5, 0, 5); clTitle.BackgroundTransparency = 1; clTitle.Text = "📝 Что нового:"; clTitle.TextColor3 = Theme.Accent; clTitle.Font = Enum.Font.GothamSemibold; clTitle.TextSize = 12; clTitle.TextXAlignment = Enum.TextXAlignment.Left; clTitle.ZIndex = 4; clTitle.Parent = changelogFrame
local clText = Instance.new("TextLabel"); clText.Size = UDim2.new(1, -10, 0, 55); clText.Position = UDim2.new(0, 5, 0, 25); clText.BackgroundTransparency = 1; clText.Text = "• Настройка размера меню\n• Ники и HP в ESP\n• Новая анимация загрузки\n• Улучшена стабильность"; clText.TextColor3 = Theme.SubText; clText.Font = Enum.Font.Gotham; clText.TextSize = 10; clText.TextXAlignment = Enum.TextXAlignment.Left; clText.TextYAlignment = Enum.TextYAlignment.Top; clText.ZIndex = 4; clText.Parent = changelogFrame

local quickSupportFrame = Instance.new("Frame"); quickSupportFrame.Size = UDim2.new(1, 0, 0, 45); quickSupportFrame.BackgroundColor3 = Theme.ElementBg; quickSupportFrame.BackgroundTransparency = 0.2; quickSupportFrame.ZIndex = 4; quickSupportFrame.LayoutOrder = 5; quickSupportFrame.Parent = homePage
local qsfc = Instance.new("UICorner"); qsfc.CornerRadius = UDim.new(0, 6); qsfc.Parent = quickSupportFrame
local qsTitle = Instance.new("TextLabel"); qsTitle.Size = UDim2.new(1, -120, 1, 0); qsTitle.Position = UDim2.new(0, 10, 0, 0); qsTitle.BackgroundTransparency = 1; qsTitle.Text = "💬 Быстрая поддержка:"; qsTitle.TextColor3 = Theme.SubText; qsTitle.Font = Enum.Font.GothamSemibold; qsTitle.TextSize = 11; qsTitle.TextXAlignment = Enum.TextXAlignment.Left; qsTitle.ZIndex = 4; qsTitle.Parent = quickSupportFrame
local qsBtn = Instance.new("TextButton"); qsBtn.Size = UDim2.new(0, 100, 0, 25); qsBtn.Position = UDim2.new(1, -110, 0.5, -12.5); qsBtn.BackgroundColor3 = Theme.Accent; qsBtn.Text = "@Gripoch"; qsBtn.TextColor3 = Color3.fromRGB(0, 0, 0); qsBtn.Font = Enum.Font.GothamBold; qsBtn.TextSize = 12; qsBtn.AutoButtonColor = false; qsBtn.ZIndex = 4; qsBtn.Parent = quickSupportFrame
local qsbc = Instance.new("UICorner"); qsbc.CornerRadius = UDim.new(0, 4); qsbc.Parent = qsBtn
qsBtn.MouseButton1Click:Connect(function() 
    local success = pcall(function() setclipboard("@Gripoch") end)
    if success then qsBtn.Text = "Скопировано!" else qsBtn.Text = "Ошибка" end
    task.wait(1.5); qsBtn.Text = "@Gripoch"
end)

createToggle(ragePage, "Aimbot", function(v) S.Aim = v end)
createSlider(ragePage, "Aimbot FOV", 30, 600, S.AimFOV, function(v) S.AimFOV = v end)
createSlider(ragePage, "Smoothness x100", 1, 100, S.Smooth * 100, function(v) S.Smooth = v / 100 end)
createSlider(ragePage, "Aim Distance", 10, 500, S.AimDist, function(v) S.AimDist = v end)
createToggle(ragePage, "Silent Aim", function(v) S.Silent = v end)
createSlider(ragePage, "Silent FOV", 30, 300, S.SilentFOV, function(v) S.SilentFOV = v end)
createSlider(ragePage, "Hitbox Size", 1, 20, S.Hitbox, function(v) S.Hitbox = v end)
createToggle(ragePage, "Show FOV", function(v) S.FOV = v end)
createSlider(ragePage, "FOV Size", 30, 600, S.FOVVal, function(v) S.FOVVal = v end)
createSlider(ragePage, "FOV Transparency", 1, 100, S.FOVTrans * 100, function(v) S.FOVTrans = v / 100 end)

createToggle(visualPage, "Enable ESP", function(v) S.ESP = v end)
createSlider(visualPage, "ESP Distance", 10, 500, S.ESPDist, function(v) S.ESPDist = v end)
createToggle(visualPage, "Snaplines", function(v) S.Lines = v end)
createDropdown(visualPage, "Snapline Pos", {"Bottom", "Top", "Center"}, function(val) S.LinePos = val end)
createToggle(visualPage, "Show Distance", function(v) S.ShowDist = v end)
createToggle(visualPage, "Custom Crosshair", function(v) S.Crosshair = v end)
createToggle(visualPage, "Fullbright", function(v) 
    S.Fullbright = v 
    if v then Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 3; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
    else Lighting.Ambient = Color3.fromRGB(0, 0, 0); Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128); Lighting.Brightness = 1; Lighting.FogEnd = 10000; Lighting.GlobalShadows = true end
end)
createSlider(visualPage, "Camera FOV", 70, 120, 70, function(v) camera.FieldOfView = v end)

createToggle(miscPage, "Noclip", function(v) S.Noclip = v end)
createToggle(miscPage, "Speedhack", function(v) S.Speed = v end)
createSlider(miscPage, "Speed Value", 16, 200, S.SpeedVal, function(v) S.SpeedVal = v end)
createToggle(miscPage, "Jump Power", function(v) S.Jump = v end)
createSlider(miscPage, "Jump Value", 50, 300, S.JumpPower, function(v) S.JumpPower = v end)
createToggle(miscPage, "Infinite Jump", function(v) S.InfJump = v end)
createToggle(miscPage, "Fly (Полет)", function(v) 
    S.Fly = v 
    if v then
        if player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = hrp.CFrame + Vector3.new(0, 5, 0) end
        end
    end
end)
createToggle(miscPage, "Anti-Void (Анти-падение)", function(v) S.AntiVoid = v end)
createToggle(miscPage, "Anti-Arrest (Анти-арест)", function(v) S.AntiArrest = v end)
createToggle(miscPage, "Auto-Rob (Авто-ограбление)", function(v) S.AutoRob = v end)
createToggle(miscPage, "Anti-AFK", function(v) S.AntiAFK = v end)
createToggle(miscPage, "Bhop", function(v) S.Bhop = v end)
createToggle(miscPage, "Fast Anim", function(v) S.FastAnim = v end)

local themeTitle = Instance.new("TextLabel"); themeTitle.Size = UDim2.new(1, 0, 0, 20); themeTitle.BackgroundTransparency = 1; themeTitle.Text = "🎨 Цвет меню:"; themeTitle.TextColor3 = Theme.Accent; themeTitle.Font = Enum.Font.GothamSemibold; themeTitle.TextSize = 12; themeTitle.TextXAlignment = Enum.TextXAlignment.Left; themeTitle.Parent = settingsPage

local colorContainer = Instance.new("Frame"); colorContainer.Size = UDim2.new(1, 0, 0, 30); colorContainer.BackgroundTransparency = 1; colorContainer.Parent = settingsPage
local colorLayout = Instance.new("UIListLayout"); colorLayout.FillDirection = Enum.FillDirection.Horizontal; colorLayout.Padding = UDim.new(0, 10); colorLayout.Parent = colorContainer

local function updateThemeColor(newColor)
    Theme.Accent = newColor
    TweenService:Create(topBar, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    TweenService:Create(ms, TweenInfo.new(0.3), {Color = newColor}):Play()
    TweenService:Create(avDiamond, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    TweenService:Create(hInner, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    TweenService:Create(avStroke, TweenInfo.new(0.3), {Color = newColor}):Play()
    TweenService:Create(tDiamond, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
    TweenService:Create(ts, TweenInfo.new(0.3), {Color = newColor}):Play()
    homeTab.TextColor3 = newColor; rageTab.TextColor3 = newColor
end

local colors = {
    {Name="Purple", Color=Color3.fromRGB(130, 70, 255)},
    {Name="Blue", Color=Color3.fromRGB(0, 150, 255)},
    {Name="Red", Color=Color3.fromRGB(255, 50, 50)},
    {Name="Green", Color=Color3.fromRGB(0, 255, 100)}
}

for _, cData in ipairs(colors) do
    local cBtn = Instance.new("TextButton")
    cBtn.Size = UDim2.new(0, 30, 0, 30); cBtn.BackgroundColor3 = cData.Color
    cBtn.Text = ""; cBtn.Parent = colorContainer
    local cCorner = Instance.new("UICorner"); cCorner.CornerRadius = UDim.new(1, 0); cCorner.Parent = cBtn
    cBtn.MouseButton1Click:Connect(function() updateThemeColor(cData.Color) end)
end

local sizeTitle = Instance.new("TextLabel"); sizeTitle.Size = UDim2.new(1, 0, 0, 20); sizeTitle.BackgroundTransparency = 1; sizeTitle.Text = "📏 Размер меню:"; sizeTitle.TextColor3 = Theme.Accent; sizeTitle.Font = Enum.Font.GothamSemibold; sizeTitle.TextSize = 12; sizeTitle.TextXAlignment = Enum.TextXAlignment.Left; sizeTitle.Parent = settingsPage
createSlider(settingsPage, "Menu Scale (%)", 50, 150, S.MenuSize, function(v) 
    S.MenuSize = v
    mainScale.Scale = v / 100
end)

local cfgTitle = Instance.new("TextLabel"); cfgTitle.Size = UDim2.new(1, 0, 0, 20); cfgTitle.BackgroundTransparency = 1; cfgTitle.Text = "💾 Конфигурация:"; cfgTitle.TextColor3 = Theme.Accent; cfgTitle.Font = Enum.Font.GothamSemibold; cfgTitle.TextSize = 12; cfgTitle.TextXAlignment = Enum.TextXAlignment.Left; cfgTitle.Parent = settingsPage

local cfgFrame = Instance.new("Frame"); cfgFrame.Size = UDim2.new(1, 0, 0, 32); cfgFrame.BackgroundTransparency = 1; cfgFrame.Parent = settingsPage
local cfgLayout = Instance.new("UIListLayout"); cfgLayout.FillDirection = Enum.FillDirection.Horizontal; cfgLayout.Padding = UDim.new(0, 10); cfgLayout.Parent = cfgFrame

local saveBtn = Instance.new("TextButton"); saveBtn.Size = UDim2.new(0.5, -5, 1, 0); saveBtn.BackgroundColor3 = Theme.Accent; saveBtn.Text = "СОХРАНИТЬ"; saveBtn.TextColor3 = Theme.Bg; saveBtn.Font = Enum.Font.GothamBold; saveBtn.TextSize = 11; saveBtn.Parent = cfgFrame
local saveC = Instance.new("UICorner", saveBtn); saveC.CornerRadius = UDim.new(0, 4)
local loadBtn = Instance.new("TextButton"); loadBtn.Size = UDim2.new(0.5, -5, 1, 0); loadBtn.BackgroundColor3 = Theme.ElementBg; loadBtn.Text = "ЗАГРУЗИТЬ"; loadBtn.TextColor3 = Theme.Accent; loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 11; loadBtn.Parent = cfgFrame
local loadC = Instance.new("UICorner", loadBtn); loadC.CornerRadius = UDim.new(0, 4)

saveBtn.MouseButton1Click:Connect(function()
    local str = ""
    for k, v in pairs(S) do str = str .. k .. "=" .. tostring(v) .. "\n" end
    local suc = pcall(function() writefile("deephub_cfg.txt", str) end)
    if suc then ShowNotification("Конфиг сохранен", true) else ShowNotification("Ошибка Executor", false) end
end)

loadBtn.MouseButton1Click:Connect(function()
    local suc = pcall(function()
        local str = readfile("deephub_cfg.txt")
        for line in string.gmatch(str, "[^\r\n]+") do
            local k, v = string.match(line, "([^=]+)=([^=]+)")
            if k and v then
                if v == "true" then S[k] = true
                elseif v == "false" then S[k] = false
                else S[k] = tonumber(v) or v end
            end
        end
        mainScale.Scale = S.MenuSize / 100
    end)
    if suc then ShowNotification("Конфиг загружен", true) else ShowNotification("Ошибка загрузки", false) end
end)

local bindTitle = Instance.new("TextLabel"); bindTitle.Size = UDim2.new(1, 0, 0, 20); bindTitle.BackgroundTransparency = 1; bindTitle.Text = "⌨️ Бинды (Keybinds):"; bindTitle.TextColor3 = Theme.Accent; bindTitle.Font = Enum.Font.GothamSemibold; bindTitle.TextSize = 12; bindTitle.TextXAlignment = Enum.TextXAlignment.Left; bindTitle.Parent = settingsPage

local function createBindRow(name, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30); row.BackgroundColor3 = Theme.ElementBg; row.BackgroundTransparency = 0.2; row.Parent = settingsPage
    local rCorner = Instance.new("UICorner"); rCorner.CornerRadius = UDim.new(0, 4); rCorner.Parent = row
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = name; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = row
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 20); btn.Position = UDim2.new(1, -70, 0.5, -10)
    btn.BackgroundColor3 = Theme.Accent; btn.Text = key.Name; btn.TextColor3 = Theme.Bg; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.Parent = row
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 4); bCorner.Parent = btn
    BindButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        listeningFor = name; btn.Text = "Нажми..."
    end)
end

createBindRow("Aimbot", Binds.Aimbot)
createBindRow("ESP", Binds.ESP)
createBindRow("Fly", Binds.Fly)
createBindRow("Speed", Binds.Speed)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if listeningFor then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Binds[listeningFor] = input.KeyCode
            if BindButtons[listeningFor] then BindButtons[listeningFor].Text = input.KeyCode.Name end
            listeningFor = nil; ShowNotification("Бинд изменен", true)
        end
        return
    end
    if input.KeyCode == Binds.Aimbot then S.Aim = not S.Aim; ShowNotification("Aimbot [" .. Binds.Aimbot.Name .. "]", S.Aim)
    elseif input.KeyCode == Binds.ESP then S.ESP = not S.ESP; ShowNotification("ESP [" .. Binds.ESP.Name .. "]", S.ESP)
    elseif input.KeyCode == Binds.Fly then S.Fly = not S.Fly; ShowNotification("Fly [" .. Binds.Fly.Name .. "]", S.Fly)
    elseif input.KeyCode == Binds.Speed then S.Speed = not S.Speed; ShowNotification("Speed [" .. Binds.Speed.Name .. "]", S.Speed) end
end)

createToggle(settingsPage, "HARD FPS Boost", function(v) 
    S.FPS = v 
    if v then pcall(function() settings().Rendering.QualityLevel = 1; Lighting.GlobalShadows = false; Lighting.FogEnd = 9e9
        for _, obj in ipairs(Lighting:GetDescendants()) do if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Sky") then obj.Enabled = false end end
        for _, obj in ipairs(Workspace:GetDescendants()) do if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then obj.Enabled = false end end
    end) else pcall(function() settings().Rendering.QualityLevel = 10; Lighting.GlobalShadows = true; Lighting.FogEnd = 10000 end) end
end)
createToggle(settingsPage, "Delete Textures", function(v) 
    S.DelTex = v 
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then if v then obj.Material = Enum.Material.SmoothPlastic; obj.TextureID = "" end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = v and 1 or 0
        elseif obj:IsA("ParticleEmitter") then obj.Enabled = not v end
    end
end)
createToggle(settingsPage, "God Mode", function(v) S.God = v end)

local helpTitle = Instance.new("TextLabel"); helpTitle.Size = UDim2.new(1, 0, 0, 30); helpTitle.BackgroundTransparency = 1; helpTitle.Text = "📖 Термины"; helpTitle.TextColor3 = Theme.Accent; helpTitle.Font = Enum.Font.GothamSemibold; helpTitle.TextSize = 16; helpTitle.TextXAlignment = Enum.TextXAlignment.Left; helpTitle.ZIndex = 4; helpTitle.Parent = helpPage
local function createHelpElement(title, desc)
    local frame = Instance.new("Frame"); frame.Size = UDim2.new(1, 0, 0, 55); frame.BackgroundColor3 = Theme.ElementBg; frame.BackgroundTransparency = 0.2; frame.ZIndex = 4; frame.Parent = helpPage
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = frame
    local t = Instance.new("TextLabel"); t.Size = UDim2.new(1, -10, 0, 20); t.Position = UDim2.new(0, 5, 0, 5); t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = Theme.Accent; t.Font = Enum.Font.GothamSemibold; t.TextSize = 12; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 4; t.Parent = frame
    local d = Instance.new("TextLabel"); d.Size = UDim2.new(1, -10, 0, 30); d.Position = UDim2.new(0, 5, 0, 22); d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = Theme.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 10; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 4; d.Parent = frame
end
createHelpElement("Aimbot", "Автоматически наводит прицел на противника.")
createHelpElement("Silent Aim", "Пули летят точно в голову, даже если ваш прицел смотрит в сторону.")
createHelpElement("ESP", "Подсвечивает противников сквозь стены. Игроки - белые, NPC - цветные.")
createHelpElement("Fly", "Летишь в направлении камеры. Смотри вверх и жми вперёд.")
createHelpElement("Anti-Arrest", "Не дает полиции вас арестовать.")
createHelpElement("Auto-Rob", "Автоматически нажимает кнопки 'Ограбить' и 'Забрать'.")

local supportFrame = Instance.new("Frame"); supportFrame.Size = UDim2.new(1, 0, 0, 60); supportFrame.BackgroundColor3 = Theme.ElementBg; supportFrame.BackgroundTransparency = 0.2; supportFrame.ZIndex = 4; supportFrame.Parent = helpPage
local sfc = Instance.new("UICorner"); sfc.CornerRadius = UDim.new(0, 6); sfc.Parent = supportFrame
local sTitle = Instance.new("TextLabel"); sTitle.Size = UDim2.new(1, -10, 0, 20); sTitle.Position = UDim2.new(0, 5, 0, 5); sTitle.BackgroundTransparency = 1; sTitle.Text = "💬 Поддержка"; sTitle.TextColor3 = Theme.Accent; sTitle.Font = Enum.Font.GothamSemibold; sTitle.TextSize = 12; sTitle.TextXAlignment = Enum.TextXAlignment.Left; sTitle.ZIndex = 4; sTitle.Parent = supportFrame
local sTG = Instance.new("TextLabel"); sTG.Size = UDim2.new(1, -70, 0, 20); sTG.Position = UDim2.new(0, 5, 0, 30); sTG.BackgroundTransparency = 1; sTG.Text = "Telegram: @Gripoch"; sTG.TextColor3 = Theme.Text; sTG.Font = Enum.Font.Gotham; sTG.TextSize = 11; sTG.TextXAlignment = Enum.TextXAlignment.Left; sTG.ZIndex = 4; sTG.Parent = supportFrame
local copyBtn = Instance.new("TextButton"); copyBtn.Size = UDim2.new(0, 60, 0, 25); copyBtn.Position = UDim2.new(1, -65, 0.5, 7); copyBtn.BackgroundColor3 = Theme.Accent; copyBtn.Text = "Копировать"; copyBtn.TextColor3 = Color3.new(0,0,0); copyBtn.Font = Enum.Font.GothamBold; copyBtn.TextSize = 10; copyBtn.ZIndex = 4; copyBtn.Parent = supportFrame
local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 4); cbc.Parent = copyBtn
copyBtn.MouseButton1Click:Connect(function() local success = pcall(function() setclipboard("@Gripoch") end); if success then copyBtn.Text = "Ок!" else copyBtn.Text = "Ошибка" end; task.wait(1.5); copyBtn.Text = "Копировать" end)

local isOpen = true
local function setVis(v)
    isOpen = v
    if v then 
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
    else 
        local tw = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tw:Play()
        tw.Completed:Connect(function() if not isOpen then mainFrame.Visible = false end end) 
    end
end

closeBtn.MouseButton1Click:Connect(function() setVis(false) end)
toggleBtn.MouseButton1Click:Connect(function() if mainFrame.Visible then setVis(false) else setVis(true) end end)

local ch = Instance.new("Frame", gui); ch.Size = UDim2.new(0, 4, 0, 4); ch.Position = UDim2.new(0.5, -2, 0.5, -2); ch.BackgroundColor3 = Theme.Accent; ch.Visible = false; ch.ZIndex = 10; ch.Parent = gui
local chc = Instance.new("UICorner", ch); chc.CornerRadius = UDim.new(1,0)
RunService.RenderStepped:Connect(function() if S.Crosshair then ch.Visible = true else ch.Visible = false end end)

local fovC = Instance.new("Frame"); fovC.AnchorPoint = Vector2.new(0.5, 0.5); fovC.Position = UDim2.new(0.5, 0, 0.5, 0); fovC.BackgroundTransparency = 1; fovC.Visible = false; fovC.ZIndex = 10; fovC.Parent = gui
local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(1, 0); fovCorner.Parent = fovC
local fovStroke = Instance.new("UIStroke"); fovStroke.Color = Theme.Accent; fovStroke.Thickness = 1; fovStroke.Parent = fovC

local function getNPCs()
    local t = {}
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("Head") then
            if v.Humanoid.Health > 0 and v ~= player.Character and not Players:GetPlayerFromCharacter(v) then
                table.insert(t, v)
            end
        end
    end
    return t
end
local targets = {}
task.spawn(function() while task.wait(1) do targets = getNPCs() end end)

local function getTarget(fov, dist)
    local center = camera.ViewportSize / 2; local best, minD = nil, fov
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
    for _, n in ipairs(targets) do
        local h = n:FindFirstChild("Head")
        if h and h.Parent and (h.Position - myPos).Magnitude <= dist then
            local pos, on = camera:WorldToViewportPoint(h.Position)
            if on then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < minD then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {player.Character, n}; rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local ray = Workspace:Raycast(camera.CFrame.Position, h.Position - camera.CFrame.Position, rayParams)
                    if not ray then minD = d; best = n end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if headerLogo.Visible then headerLogo.Rotation = headerLogo.Rotation + 0.5 end
    if S.FOV then fovC.Visible = true; fovC.Size = UDim2.new(0, S.FOVVal * 2, 0, S.FOVVal * 2); fovStroke.Transparency = S.FOVTrans
    else fovC.Visible = false end
    if not S.Aim or S.Silent then return end
    local t = getTarget(S.AimFOV, S.AimDist)
    if t and t:FindFirstChild("Head") then
        local targetPos = t.Head.Position; local currentPos = camera.CFrame.Position
        camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(currentPos, targetPos), S.Smooth)
    end
end)

RunService.Heartbeat:Connect(function()
    if S.Silent then
        local t = getTarget(S.SilentFOV, S.AimDist)
        for _, n in ipairs(targets) do
            local h = n:FindFirstChild("Head")
            if h and h:IsA("BasePart") then if n == t then h.Size = Vector3.new(S.Hitbox, S.Hitbox, S.Hitbox) elseif h.Size.X > 2 then h.Size = Vector3.new(1,1,1) end end
        end
    else
        for _, n in ipairs(targets) do local h = n:FindFirstChild("Head"); if h and h:IsA("BasePart") and h.Size.X > 2 then h.Size = Vector3.new(1,1,1) end end
    end
end)

local flyBV = nil
RunService.Stepped:Connect(function()
    if player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if h then
            if S.Speed and not S.Fly then h.WalkSpeed = S.SpeedVal elseif not S.Speed and not S.Fly and h.WalkSpeed ~= 16 then h.WalkSpeed = 16 end
            if S.Jump and not S.Fly then h.UseJumpPower = true; h.JumpPower = S.JumpPower elseif not S.Jump and not S.Fly and h.JumpPower ~= 50 then h.JumpPower = 50 end
            if S.FastAnim then local a = h:FindFirstChildOfClass("Animator"); if a then for _, tr in ipairs(a:GetPlayingAnimationTracks()) do tr:AdjustSpeed(2) end end end
            if S.God then h.MaxHealth = 99999; h.Health = 99999 end
        end
        if S.Fly and h and hrp then
            h.PlatformStand = true; h.AutoRotate = false
            for _, part in ipairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + camera.CFrame.LookVector)
            if not flyBV then flyBV = Instance.new("BodyVelocity", hrp); flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
            local camCF = camera.CFrame; local moveDir = h.MoveDirection; local vel = Vector3.new(0,0,0)
            if moveDir.Magnitude > 0.1 then
                local camLookFlat = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
                local camRightFlat = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
                if camLookFlat.Magnitude < 0.1 then camLookFlat = Vector3.new(0, 0, -1); camRightFlat = Vector3.new(1, 0, 0)
                else camLookFlat = camLookFlat.Unit; camRightFlat = camRightFlat.Unit end
                local dotX = moveDir:Dot(camRightFlat); local dotZ = moveDir:Dot(camLookFlat)
                local flyDir = camCF.LookVector * dotZ + camCF.RightVector * dotX
                if flyDir.Magnitude > 0 then flyDir = flyDir.Unit end
                vel = flyDir * S.SpeedVal
            end
            flyBV.Velocity = vel
        else
            if flyBV then flyBV:Destroy(); flyBV = nil end
            if h then if h.PlatformStand then h.PlatformStand = false end; if not h.AutoRotate then h.AutoRotate = true end end
        end
        if S.Noclip and not S.Fly then for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        if hrp then
            if S.AntiVoid and hrp.Position.Y < -50 then hrp.CFrame = CFrame.new(0, 50, 0) end
            if S.AntiArrest then
                for _, npc in pairs(targets) do
                    local lname = string.lower(npc.Name)
                    if string.find(lname, "police") or string.find(lname, "cop") or string.find(lname, "officer") then
                        local nh = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") or npc:FindFirstChild("UpperTorso")
                        if nh and (hrp.Position - nh.Position).Magnitude < 15 then hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-3,3), 2, math.random(-3,3)) end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if S.AutoRob then
            for _, obj in ipairs(CoreGui:GetDescendants()) do
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    local text = string.lower(obj.Text)
                    if text:find("ограбить") or text:find("rob") or text:find("забрать") or text:find("collect") then
                        if obj.Visible then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton1(obj.AbsolutePosition + (obj.AbsoluteSize / 2)) end) end
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function() if S.InfJump then local c = player.Character; if c then local h = c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end end)
task.spawn(function() while task.wait(15) do if S.AntiAFK and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end end)
task.spawn(function() while task.wait(0.1) do if S.Bhop and UserInputService:IsKeyDown(Enum.KeyCode.Space) then if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping) end end end end)

local espC, drawC, distC, espTags = {}, {}, {}, {}
local hasDraw = pcall(function() return Drawing.new("Line") end)
local function getColor(n)
    local l = string.lower(n.Name)
    local parentName = n.Parent and string.lower(n.Parent.Name) or ""
    if Players:GetPlayerFromCharacter(n) or n:FindFirstChildOfClass("Player") or string.find(l, "player") then return Color3.fromRGB(255, 255, 255)
    elseif string.find(l, "police") or string.find(l, "cop") or string.find(l, "officer") or string.find(parentName, "police") or string.find(parentName, "cop") then return Color3.fromRGB(0, 100, 255)
    elseif string.find(l, "guard") or string.find(l, "security") or string.find(parentName, "guard") then return Color3.fromRGB(255, 30, 30)
    else return Color3.fromRGB(0, 255, 0) end
end

task.spawn(function()
    while task.wait(0.5) do
        if S.ESP then
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
            local cur = {}
            for _, n in ipairs(targets) do
                local h = n:FindFirstChild("Head")
                if h and (h.Position - myPos).Magnitude <= S.ESPDist then
                    cur[n] = true
                    if not espC[n] then local hl = Instance.new("Highlight", n); hl.FillColor = getColor(n); hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.6; espC[n] = hl end
                    
                    if not espTags[n] then
                        local bb = Instance.new("BillboardGui", h)
                        bb.Size = UDim2.new(0, 100, 0, 35)
                        bb.StudsOffset = Vector3.new(0, 1.2, 0)
                        bb.AlwaysOnTop = true
                        
                        local nameLbl = Instance.new("TextLabel", bb)
                        nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLbl.BackgroundTransparency = 1
                        nameLbl.Text = n.Name
                        nameLbl.TextColor3 = getColor(n)
                        nameLbl.Font = Enum.Font.GothamBold
                        nameLbl.TextSize = 10
                        nameLbl.TextStrokeTransparency = 0
                        
                        local hpLbl = Instance.new("TextLabel", bb)
                        hpLbl.Size = UDim2.new(1, 0, 0.5, 0)
                        hpLbl.Position = UDim2.new(0, 0, 0.5, 0)
                        hpLbl.BackgroundTransparency = 1
                        hpLbl.Font = Enum.Font.GothamSemibold
                        hpLbl.TextSize = 10
                        hpLbl.TextStrokeTransparency = 0
                        
                        espTags[n] = {gui = bb, name = nameLbl, hp = hpLbl}
                    end
                    
                    local tag = espTags[n]
                    if tag then
                        local hum = n:FindFirstChildOfClass("Humanoid")
                        if hum then
                            tag.name.Text = n.Name
                            tag.hp.Text = math.floor(hum.Health) .. " HP"
                            tag.hp.TextColor3 = Color3.fromRGB(0, 255, 100)
                        end
                    end
                end
            end
            for m, hl in pairs(espC) do if not cur[m] then hl:Destroy(); espC[m] = nil end end
            for m, tag in pairs(espTags) do if not cur[m] then tag.gui:Destroy(); espTags[m] = nil end end
        else
            for m, hl in pairs(espC) do hl:Destroy() end; espC = {}
            for m, tag in pairs(espTags) do tag.gui:Destroy() end; espTags = {}
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
    local sw, sh = camera.ViewportSize.X, camera.ViewportSize.Y
    if S.Lines and hasDraw then
        local cur = {}
        for _, n in ipairs(targets) do
            local h = n:FindFirstChild("Head")
            if h and (h.Position - myPos).Magnitude <= S.ESPDist then
                cur[n] = true
                local pos, on = camera:WorldToViewportPoint(h.Position)
                if on then
                    if not drawC[n] then local ln = Drawing.new("Line"); ln.Thickness = 1; ln.Transparency = 0.8; drawC[n] = ln end
                    local startX, startY = sw/2, sh
                    if S.LinePos == "Top" then startY = 0 elseif S.LinePos == "Center" then startY = sh/2 end
                    drawC[n].From = Vector2.new(startX, startY); drawC[n].To = Vector2.new(pos.X, pos.Y); drawC[n].Color = getColor(n); drawC[n].Visible = true
                else if drawC[n] then drawC[n].Visible = false end end
            end
        end
        for m, ln in pairs(drawC) do if not cur[m] then ln:Remove(); drawC[m] = nil end end
    else
        for m, ln in pairs(drawC) do ln:Remove() end; drawC = {}
    end

    if S.ShowDist then
        for _, n in ipairs(targets) do
            local h = n:FindFirstChild("Head")
            if h and (h.Position - myPos).Magnitude <= S.ESPDist then
                local d = math.floor((h.Position - myPos).Magnitude)
                if not distC[n] then
                    local bb = Instance.new("BillboardGui", h); bb.Size = UDim2.new(0, 50, 0, 20); bb.StudsOffset = Vector3.new(0, 0.5, 0); bb.AlwaysOnTop = true; bb.Adornee = h
                    local txt = Instance.new("TextLabel", bb); txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1; txt.TextColor3 = Color3.new(1,1,1); txt.Font = Enum.Font.GothamBold; txt.TextSize = 10; txt.TextStrokeTransparency = 0
                    distC[n] = txt
                end
                distC[n].Text = d .. "m"
            else if distC[n] then distC[n].Parent:Destroy(); distC[n] = nil end end
        end
    else
        for m, t in pairs(distC) do t.Parent:Destroy() end; distC = {}
    end
end)

-- ================= АНИМАЦИЯ ЗАГРУЗКИ =================
local introGui = Instance.new("ScreenGui", CoreGui)
introGui.Name = "IntroAnim"; introGui.ResetOnSpawn = false; introGui.IgnoreGuiInset = true

local introLine = Instance.new("Frame", introGui)
introLine.Size = UDim2.new(0, 2, 0, 0)
introLine.Position = UDim2.new(0.5, 0, 0.5, 0)
introLine.AnchorPoint = Vector2.new(0.5, 0.5)
introLine.BackgroundColor3 = Theme.Accent
introLine.BorderSizePixel = 0

local introText = Instance.new("TextLabel", introGui)
introText.Size = UDim2.new(0, 200, 0, 50)
introText.Position = UDim2.new(0.5, 0, 0.5, 0)
introText.AnchorPoint = Vector2.new(0, 0.5) 
introText.BackgroundTransparency = 1
introText.Text = "DEEP HUB"
introText.TextColor3 = Theme.Accent
introText.Font = Enum.Font.GothamBold
introText.TextSize = 30
introText.TextXAlignment = Enum.TextXAlignment.Left
introText.TextTransparency = 1

task.spawn(function()
    task.wait(0.2)
    -- Палочка появляется
    TweenService:Create(introLine, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 2, 0, 40)}):Play()
    task.wait(0.4)

    -- Буквы вылетают вправо
    introText.Position = UDim2.new(0.5, 5, 0.5, 0)
    TweenService:Create(introText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0, Position = UDim2.new(0.5, 15, 0.5, 0)}):Play()
    task.wait(0.5)

    -- Палочка и текст отъезжают влево (центрирование)
    TweenService:Create(introLine, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -55, 0.5, 0)}):Play()
    TweenService:Create(introText, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -45, 0.5, 0)}):Play()
    
    -- ЖДЕМ РОВНО 2 СЕКУНДЫ
    task.wait(2)

    -- Разрыв и превращение в меню
    local textScale = Instance.new("UIScale", introText)
    TweenService:Create(introText, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -45, 0.5, -80), TextTransparency = 1}):Play()
    TweenService:Create(textScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 1.5}):Play()

    TweenService:Create(introLine, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280), BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    introGui:Destroy()
    
    -- Показываем меню
    toggleBtn.Visible = true; wm.Visible = true; mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
end)
