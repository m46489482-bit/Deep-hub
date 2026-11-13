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
    AimEnabled = false, AimFOV = 200, Smoothness = 0.3,
    SilentAimEnabled = false, SilentFOV = 100, HitboxSize = 5,
    FOVEnabled = false, FOVValue = 200, FOVTransparency = 0.4,
    ESPEnabled = false, MaxDistance = 50,
    SnaplinesEnabled = false, SnaplinePosition = "Bottom", ShowDistanceEnabled = false,
    NoclipEnabled = false, SpeedEnabled = false, SpeedValue = 50,
    JumpEnabled = false, JumpPower = 50, InfJumpEnabled = false,
    GodModeEnabled = false, FPSBoostEnabled = false, AntiAFKEnabled = false
}

local Theme = {
    Bg = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(24, 24, 30),
    Content = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(130, 70, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(150, 150, 160),
    ElementBg = Color3.fromRGB(32, 32, 40),
    ToggleOff = Color3.fromRGB(50, 50, 60),
    SliderBg = Color3.fromRGB(40, 40, 50),
    Close = Color3.fromRGB(255, 70, 70)
}

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "DeepHubMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 130, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Theme.Bg
toggleBtn.Text = "⚡ DEEP HUB"
toggleBtn.TextColor3 = Theme.Accent
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 15
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = gui
local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = toggleBtn
local ts = Instance.new("UIStroke"); ts.Color = Theme.Accent; ts.Thickness = 1.5; ts.Transparency = 0.5; ts.Parent = toggleBtn

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

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Theme.Sidebar
topBar.BorderSizePixel = 0
topBar.Active = true
topBar.Parent = mainFrame
local tbc = Instance.new("UICorner"); tbc.CornerRadius = UDim.new(0, 12); tbc.Parent = topBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -80, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "DEEP HUB | MULTI-TOOL"
titleText.TextColor3 = Theme.Accent
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 12
titleText.TextXAlignment = Enum.TextXAlignment.Left
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

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 100, 1, -35)
sidebar.Position = UDim2.new(0, 0, 0, 35)
sidebar.BackgroundColor3 = Theme.Sidebar
sidebar.BorderSizePixel = 0
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

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -100, 1, -35)
contentFrame.Position = UDim2.new(0, 100, 0, 35)
contentFrame.BackgroundColor3 = Theme.Content
contentFrame.BorderSizePixel = 0
contentFrame.ClipsDescendants = true
contentFrame.Parent = mainFrame
local contentCorner = Instance.new("UICorner"); contentCorner.CornerRadius = UDim.new(0, 12); contentCorner.Parent = contentFrame

local function createPage()
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Theme.Accent
    page.Visible = false
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

local function createTabButton(text, layoutOrder, pageToShow)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Theme.Bg
    btn.Text = text
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.LayoutOrder = layoutOrder
    btn.AutoButtonColor = false
    btn.Parent = sidebar
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Theme.Bg
                child.TextColor3 = Theme.SubText
            end
        end
        for _, page in ipairs(contentFrame:GetChildren()) do
            if page:IsA("ScrollingFrame") then page.Visible = false end
        end
        btn.BackgroundColor3 = Theme.ElementBg
        btn.TextColor3 = Theme.Accent
        pageToShow.Visible = true
    end)
    return btn
end

local homeTab = createTabButton("HOME", 1, homePage)
local rageTab = createTabButton("RAGE", 2, ragePage)
local visualTab = createTabButton("VISUAL", 3, visualPage)
local miscTab = createTabButton("MISC", 4, miscPage)
local settingsTab = createTabButton("SETTINGS", 5, settingsPage)

homeTab.BackgroundColor3 = Theme.ElementBg
homeTab.TextColor3 = Theme.Accent
homePage.Visible = true

local function createToggle(parent, text, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 32)
    container.BackgroundColor3 = Theme.ElementBg
    container.BorderSizePixel = 0
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
    lbl.Parent = container

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 32, 0, 18)
    switch.Position = UDim2.new(1, -42, 0.5, -9)
    switch.BackgroundColor3 = Theme.ToggleOff
    switch.Parent = container
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = switch

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 3, 0.5, -6)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
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
            if (input.Position - startPos).Magnitude > 10 then isDragging = false end
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
    valLbl.Parent = container

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 4)
    barBg.Position = UDim2.new(0, 10, 1, -12)
    barBg.BackgroundColor3 = Theme.SliderBg
    barBg.Parent = container
    local bgc = Instance.new("UICorner"); bgc.CornerRadius = UDim.new(1, 0); bgc.Parent = barBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Accent
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    callback(default)
end

-- ================= НАПОЛНЕНИЕ =================
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 30)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Добро пожаловать в DEEP HUB!"
welcomeLabel.TextColor3 = Theme.Accent
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextSize = 16
welcomeLabel.Parent = homePage

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
createToggle(visualPage, "Show Distance (Дистанция)", function(v) Settings.ShowDistanceEnabled = v end)

-- MISC
createToggle(miscPage, "Noclip (Сквозь стены)", function(v) Settings.NoclipEnabled = v end)
createToggle(miscPage, "Speedhack (Ускорение)", function(v) Settings.SpeedEnabled = v end)
createSlider(miscPage, "Скорость (Speed)", 16, 200, Settings.SpeedValue, function(v) Settings.SpeedValue = v end)
createToggle(miscPage, "Jump Power (Высота прыжка)", function(v) Settings.JumpEnabled = v end)
createSlider(miscPage, "Сила прыжка", 50, 300, Settings.JumpPower, function(v) Settings.JumpPower = v end)
createToggle(miscPage, "Infinite Jump (Беск. прыжок)", function(v) Settings.InfJumpEnabled = v end)
createToggle(miscPage, "Anti-AFK", function(v) Settings.AntiAFKEnabled = v end)

-- SETTINGS
createToggle(settingsPage, "FPS Boost (Оптимизация)", function(v) 
    Settings.FPSBoostEnabled = v 
    if v then
        pcall(function()
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
        end)
    else
        pcall(function()
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
        end)
    end
end)
createToggle(settingsPage, "God Mode (BETA)", function(v) Settings.GodModeEnabled = v end)

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 30)
versionText.BackgroundTransparency = 1
versionText.Text = "Версия: v1.1"
versionText.TextColor3 = Theme.Accent
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 12
versionText.Parent = settingsPage

-- ================= ЛОГИКА =================
task.spawn(function()
    while true do
        task.wait(0.1)
        if Settings.GodModeEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 99999
                humanoid.Health = 99999
            end
        end
    end
end)

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
            else if humanoid.JumpPower ~= 50 then humanoid.JumpPower = 50 end end
        end

        if Settings.NoclipEnabled then
            for _, part in ipairs(player.Character:GetDescendants()) do
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

UserInputService.JumpRequest:Connect(function()
    if Settings.InfJumpEnabled then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(15)
        if Settings.AntiAFKEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

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

local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
local circleCorner = Instance.new("UICorner"); circleCorner.CornerRadius = UDim.new(1, 0); circleCorner.Parent = fovCircle
local circleStroke = Instance.new("UIStroke"); circleStroke.Color = Theme.Accent; circleStroke.Thickness = 1; circleStroke.Parent = fovCircle

RunService.RenderStepped:Connect(function()
    if Settings.FOVEnabled then
        fovCircle.Visible = true
        fovCircle.Size = UDim2.new(0, Settings.FOVValue * 2, 0, Settings.FOVValue * 2)
        circleStroke.Transparency = Settings.FOVTransparency
    else
        fovCircle.Visible = false
    end
end)

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
            if (head.Position - myPos).Magnitude <= Settings.MaxDistance then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closestNpc = npc
                    end
                end
            end
        end
    end
    return closestNpc
end

RunService.RenderStepped:Connect(function()
    if not Settings.AimEnabled or Settings.SilentAimEnabled then return end
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
            if head and head:IsA("BasePart") then
                if npc == targetNpc then
                    head.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                elseif head.Size.X > 2 then
                    head.Size = Vector3.new(1, 1, 1)
                end
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

local espCache = {}
local distanceCache = {}

local function getColorByName(name)
    local lowerName = string.lower(name)
    if string.find(lowerName, "police") or string.find(lowerName, "cop") then return Color3.fromRGB(0, 100, 255)
    elseif string.find(lowerName, "guard") or string.find(lowerName, "security") then return Color3.fromRGB(255, 30, 30)
    else return Color3.fromRGB(0, 255, 0) end
end

task.spawn(function()
    while true do
        if Settings.ESPEnabled then
            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
            local currentModels = {}
            for _, obj in ipairs(cachedTargets) do
                local head = obj:FindFirstChild("Head")
                if head and (head.Position - myPos).Magnitude <= Settings.MaxDistance then
                    currentModels[obj] = true
                    if not espCache[obj] then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = obj
                        highlight.FillColor = getColorByName(obj.Name)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                        highlight.FillTransparency = 0.6
                        highlight.Parent = obj
                        espCache[obj] = highlight
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
    if Settings.ShowDistanceEnabled then
        for _, obj in ipairs(cachedTargets) do
            local head = obj:FindFirstChild("Head")
            if head then
                local distance = math.floor((head.Position - myPos).Magnitude)
                if distance <= Settings.MaxDistance then
                    if not distanceCache[obj] then
                        local billboard = Instance.new("BillboardGui", head)
                        billboard.Size = UDim2.new(0, 50, 0, 20)
                        billboard.StudsOffset = Vector3.new(0, 0.5, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Adornee = head
                        
                        local text = Instance.new("TextLabel", billboard)
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextColor3 = Color3.new(1, 1, 1)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 10
                        text.TextStrokeTransparency = 0
                        text.Text = distance .. "m"
                        distanceCache[obj] = text
                    else
                        distanceCache[obj].Text = distance .. "m"
                    end
                else
                    if distanceCache[obj] then distanceCache[obj].Parent:Destroy() distanceCache[obj] = nil end
                end
            end
        end
    else
        for model, text in pairs(distanceCache) do text.Parent:Destroy() end
        distanceCache = {}
    end
end)
