local success, error_msg = pcall(function()
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local Lighting = game:GetService("Lighting")

    local player = Players.LocalPlayer
    local camera = Workspace.CurrentCamera

    -- НАСТРОЙКИ
    local S = {
        Aim = false, AimFOV = 200, AimDist = 150, Smooth = 0.2,
        AimPly = true, AimCop = true, AimGuard = true, AimCit = true,
        FOV = false, FOVTrans = 0.4,
        ESP = false, ESPDist = 150, Fullbright = false, FPSBoost = false,
        Noclip = false, Speed = false, SpeedVal = 50, Fly = false,
        MenuSize = 100
    }

    local Theme = {
        Bg = Color3.fromRGB(18, 18, 22), Sidebar = Color3.fromRGB(24, 24, 30), Content = Color3.fromRGB(22, 22, 26),
        Accent = Color3.fromRGB(130, 70, 255), 
        Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(150, 150, 160),
        ElementBg = Color3.fromRGB(32, 32, 40), ToggleOff = Color3.fromRGB(50, 50, 60),
        Close = Color3.fromRGB(60, 60, 70)
    }

    -- ОСНОВНОЙ GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "DeepHubMenu"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.Parent = CoreGui

    -- Кнопка
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 45); toggleBtn.Position = UDim2.new(0, 20, 0, 100)
    toggleBtn.BackgroundColor3 = Theme.Bg; toggleBtn.Text = ""; toggleBtn.AutoButtonColor = false
    toggleBtn.Active = true; toggleBtn.Visible = false; toggleBtn.ZIndex = 10; toggleBtn.Parent = gui
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = toggleBtn
    local ts = Instance.new("UIStroke"); ts.Color = Theme.Accent; ts.Thickness = 2; ts.Parent = toggleBtn

    local tDiamond = Instance.new("Frame", toggleBtn)
    tDiamond.Size = UDim2.new(0, 22, 0, 22); tDiamond.Position = UDim2.new(0.5, -11, 0.5, -11)
    tDiamond.BackgroundColor3 = Theme.Accent; tDiamond.Rotation = 45; tDiamond.ZIndex = 11
    local tdc = Instance.new("UICorner", tDiamond); tdc.CornerRadius = UDim.new(0, 3)

    -- Круг FOV
    local fovCircle = Instance.new("Frame", gui)
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Visible = false
    fovCircle.ZIndex = 10
    local fovCorner = Instance.new("UICorner", fovCircle); fovCorner.CornerRadius = UDim.new(1, 0)
    local fovStroke = Instance.new("UIStroke", fovCircle); fovStroke.Color = Theme.Accent; fovStroke.Thickness = 1

    -- Перетаскивание кнопки
    local draggingBtn, dragInputBtn, dragStartBtn, startPosBtn
    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBtn = true; dragStartBtn = input.Position; startPosBtn = toggleBtn.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then draggingBtn = false end end)
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
    mainFrame.ZIndex = 1

    local mainScale = Instance.new("UIScale"); mainScale.Scale = S.MenuSize / 100; mainScale.Parent = mainFrame
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 12); mc.Parent = mainFrame
    local ms = Instance.new("UIStroke"); ms.Color = Theme.Accent; ms.Thickness = 1.5; ms.Transparency = 0.7; ms.Parent = mainFrame

    -- ТУМАН
    local fog = Instance.new("Frame", mainFrame)
    fog.Size = UDim2.new(1, 0, 0, 100); fog.Position = UDim2.new(0, 0, 1, -100)
    fog.BackgroundColor3 = Theme.Accent; fog.BackgroundTransparency = 0.5; fog.BorderSizePixel = 0; fog.ZIndex = 3
    local fogGrad = Instance.new("UIGradient", fog)
    fogGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme.Accent), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 90))}
    fogGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.7, 0.7), NumberSequenceKeypoint.new(1, 0.3)}
    fogGrad.Rotation = 90
    local fogCorner = Instance.new("UICorner", fog); fogCorner.CornerRadius = UDim.new(0, 12)

    -- ЧАСТИЦЫ
    local particlePool = {}
    for i = 1, 15 do
        local p = Instance.new("Frame", mainFrame)
        p.Size = UDim2.new(0, 4, 0, 4); p.BackgroundColor3 = Color3.fromRGB(220, 190, 255)
        p.BorderSizePixel = 0; p.ZIndex = 4; p.Visible = false
        local pc = Instance.new("UICorner", p); pc.CornerRadius = UDim.new(1, 0)
        table.insert(particlePool, p)
    end

    task.spawn(function()
        while task.wait(0.15) do
            if mainFrame.Visible then
                local p = particlePool[math.random(1, #particlePool)]
                if not p.Visible then
                    p.Visible = true
                    p.Position = UDim2.new(math.random(5, 95)/100, 0, 1, -5)
                    p.BackgroundTransparency = 0.2
                    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
                    
                    local targetX = p.Position.X.Offset / 100 + math.random(-25, 25) / 100
                    local targetY = 1 - (math.random(30, 70) / 100)
                    
                    local tween = TweenService:Create(p, TweenInfo.new(math.random(15, 25)/10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Position = UDim2.new(targetX, 0, targetY, 0), BackgroundTransparency = 1, Size = UDim2.new(0, 1, 0, 1)
                    })
                    tween:Play()
                    tween.Completed:Connect(function() p.Visible = false end)
                end
            end
        end
    end)

    -- ШАПКА
    local topBar = Instance.new("Frame", mainFrame)
    topBar.Size = UDim2.new(1, 0, 0, 35); topBar.BackgroundColor3 = Theme.Accent; topBar.BorderSizePixel = 0; topBar.Active = true; topBar.ZIndex = 5
    local tbc = Instance.new("UICorner", topBar); tbc.CornerRadius = UDim.new(0, 12)

    local headerLogo = Instance.new("Frame", topBar)
    headerLogo.Size = UDim2.new(0, 18, 0, 18); headerLogo.Position = UDim2.new(0, 12, 0.5, -9)
    headerLogo.BackgroundColor3 = Theme.Bg; headerLogo.Rotation = 45; headerLogo.ZIndex = 6
    local hlc = Instance.new("UICorner", headerLogo); hlc.CornerRadius = UDim.new(0, 3)
    local hInner = Instance.new("Frame", headerLogo); hInner.Size = UDim2.new(0, 10, 0, 10); hInner.Position = UDim2.new(0.5, -5, 0.5, -5); hInner.BackgroundColor3 = Theme.Accent; hInner.Rotation = 45; hInner.ZIndex = 7
    local hic = Instance.new("UICorner", hInner); hic.CornerRadius = UDim.new(0, 1)

    local titleText = Instance.new("TextLabel", topBar)
    titleText.Size = UDim2.new(1, -100, 1, 0); titleText.Position = UDim2.new(0, 40, 0, 0); titleText.BackgroundTransparency = 1
    titleText.Text = "DEEP HUB | PRO v1.0"; titleText.TextColor3 = Theme.Bg; titleText.Font = Enum.Font.GothamBold; titleText.TextSize = 13
    titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.ZIndex = 6

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0, 24, 0, 24); closeBtn.Position = UDim2.new(1, -32, 0, 5); closeBtn.BackgroundColor3 = Theme.Close
    closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 13; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 6
    local cc = Instance.new("UICorner", closeBtn); cc.CornerRadius = UDim.new(0, 6)

    -- Перетаскивание меню
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
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

    -- САЙДБАР
    local sidebar = Instance.new("ScrollingFrame", mainFrame)
    sidebar.Size = UDim2.new(0, 110, 1, -35); sidebar.Position = UDim2.new(0, 0, 0, 35)
    sidebar.BackgroundColor3 = Theme.Sidebar; sidebar.BorderSizePixel = 0; sidebar.ScrollBarThickness = 0; sidebar.ZIndex = 2
    local sideCorner = Instance.new("UICorner", sidebar); sideCorner.CornerRadius = UDim.new(0, 12)
    local sideLayout = Instance.new("UIListLayout", sidebar); sideLayout.Padding = UDim.new(0, 4); sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local sidePad = Instance.new("UIPadding", sidebar); sidePad.PaddingTop = UDim.new(0, 8); sidePad.PaddingLeft = UDim.new(0, 8); sidePad.PaddingRight = UDim.new(0, 8)

    local avatarFrame = Instance.new("Frame", sidebar)
    avatarFrame.Size = UDim2.new(0, 84, 0, 84); avatarFrame.LayoutOrder = 0
    avatarFrame.BackgroundColor3 = Theme.ElementBg; avatarFrame.BackgroundTransparency = 0.2
    avatarFrame.ZIndex = 6
    local avCorner = Instance.new("UICorner", avatarFrame); avCorner.CornerRadius = UDim.new(0, 10)
    local avStroke = Instance.new("UIStroke", avatarFrame); avStroke.Color = Theme.Accent; avStroke.Thickness = 2; avStroke.Transparency = 0.3

    local avDiamond = Instance.new("Frame", avatarFrame)
    avDiamond.Size = UDim2.new(0, 40, 0, 40); avDiamond.Position = UDim2.new(0.5, -20, 0.5, -20)
    avDiamond.BackgroundColor3 = Theme.Accent; avDiamond.Rotation = 45; avDiamond.ZIndex = 7
    local adc = Instance.new("UICorner", avDiamond); adc.CornerRadius = UDim.new(0, 6)

    local avInner = Instance.new("Frame", avatarFrame)
    avInner.Size = UDim2.new(0, 26, 0, 26); avInner.Position = UDim2.new(0.5, -13, 0.5, -13)
    avInner.BackgroundColor3 = Theme.Bg; avInner.Rotation = 45; avInner.ZIndex = 8
    local aic = Instance.new("UICorner", avInner); aic.CornerRadius = UDim.new(0, 4)

    -- КОНТЕНТ
    local contentFrame = Instance.new("Frame", mainFrame)
    contentFrame.Size = UDim2.new(1, -110, 1, -35); contentFrame.Position = UDim2.new(0, 110, 0, 35); contentFrame.BackgroundColor3 = Theme.Content; contentFrame.BorderSizePixel = 0; contentFrame.ClipsDescendants = true; contentFrame.ZIndex = 2
    local contentCorner = Instance.new("UICorner", contentFrame); contentCorner.CornerRadius = UDim.new(0, 12)

    local function createPage()
        local page = Instance.new("ScrollingFrame", contentFrame)
        page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.BorderSizePixel = 0; page.ScrollBarThickness = 2; page.ScrollBarImageColor3 = Theme.Accent; page.Visible = false; page.ZIndex = 6
        local layout = Instance.new("UIListLayout", page); layout.Padding = UDim.new(0, 8)
        local pad = Instance.new("UIPadding", page); pad.PaddingTop = UDim.new(0, 10); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10)
        return page
    end

    local homePage = createPage(); local ragePage = createPage(); local visualPage = createPage(); local miscPage = createPage(); local settingsPage = createPage(); local helpPage = createPage()

    -- ФУНКЦИЯ ВКЛАДОК (ИСПРАВЛЕННЫЙ ШРИФТ И ЦВЕТА)
    local function createTabButton(text, layoutOrder, pageToShow)
        local btn = Instance.new("TextButton", sidebar)
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Theme.Bg
        btn.BackgroundTransparency = 0.3
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(180, 180, 180) -- Мягкий серый для неактивных
        btn.Font = Enum.Font.Gotham -- Обычный (тонкий) шрифт
        btn.TextSize = 11
        btn.LayoutOrder = layoutOrder
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        
        local bc = Instance.new("UICorner", btn); bc.CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", btn); btnStroke.Color = Theme.Accent; btnStroke.Thickness = 1; btnStroke.Transparency = 1
        
        btn.MouseButton1Click:Connect(function()
            for _, child in ipairs(sidebar:GetChildren()) do 
                if child:IsA("TextButton") then 
                    TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundColor3 = Theme.Bg, 
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                        BackgroundTransparency = 0.3
                    }):Play()
                    if child:FindFirstChildOfClass("UIStroke") then
                        TweenService:Create(child.UIStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
                    end
                end 
            end
            
            for _, page in ipairs(contentFrame:GetChildren()) do 
                if page:IsA("ScrollingFrame") then page.Visible = false end 
            end
            
            -- Активная вкладка: фиолетовый фон, БЕЛЫЙ тонкий текст
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Theme.Accent, 
                TextColor3 = Color3.new(1, 1, 1), -- Белый текст для читаемости
                BackgroundTransparency = 0.1
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            
            pageToShow.Visible = true
            pageToShow.Position = UDim2.new(0, 15, 0, 0)
            TweenService:Create(pageToShow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end)
        return btn
    end

    local homeTab = createTabButton("HOME", 1, homePage); local rageTab = createTabButton("RAGE", 2, ragePage); local visualTab = createTabButton("VISUAL", 3, visualPage); local miscTab = createTabButton("MISC", 4, miscPage); local settingsTab = createTabButton("SETTINGS", 5, settingsPage); local helpTab = createTabButton("HELP", 6, helpPage)
    
    homeTab.BackgroundColor3 = Theme.Accent; homeTab.TextColor3 = Color3.new(1,1,1); homeTab.BackgroundTransparency = 0.1; homePage.Visible = true
    if homeTab:FindFirstChildOfClass("UIStroke") then homeTab.UIStroke.Transparency = 1 end

    -- ТУМБЛЕР
    local function createToggle(parent, text, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 32); container.BackgroundColor3 = Theme.ElementBg; container.ZIndex = 6
        local c = Instance.new("UICorner", container); c.CornerRadius = UDim.new(0, 6)
        local lbl = Instance.new("TextLabel", container); lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.Text; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 7
        local switch = Instance.new("Frame", container); switch.Size = UDim2.new(0, 32, 0, 18); switch.Position = UDim2.new(1, -42, 0.5, -9); switch.BackgroundColor3 = Theme.ToggleOff; switch.ZIndex = 7
        local sc = Instance.new("UICorner", switch); sc.CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", switch); dot.Size = UDim2.new(0, 12, 0, 12); dot.Position = UDim2.new(0, 3, 0.5, -6); dot.BackgroundColor3 = Color3.new(1, 1, 1); dot.ZIndex = 8
        local dc = Instance.new("UICorner", dot); dc.CornerRadius = UDim.new(1, 0)
        local state = false
        
        switch.InputBegan:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                if state then switch.BackgroundColor3 = Theme.Accent; dot.Position = UDim2.new(1, -15, 0.5, -6) 
                else switch.BackgroundColor3 = Theme.ToggleOff; dot.Position = UDim2.new(0, 3, 0.5, -6) end
                callback(state)
            end
        end)
    end

    -- ПОЛЗУНОК
    local function createSlider(parent, text, min, max, default, callback)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(1, 0, 0, 42); container.BackgroundColor3 = Theme.ElementBg; container.ZIndex = 6
        local c = Instance.new("UICorner", container); c.CornerRadius = UDim.new(0, 6)
        local lbl = Instance.new("TextLabel", container); lbl.Size = UDim2.new(1, -60, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Theme.SubText; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 7
        local valLbl = Instance.new("TextLabel", container); valLbl.Size = UDim2.new(0, 50, 0, 20); valLbl.Position = UDim2.new(1, -60, 0, 5); valLbl.BackgroundTransparency = 1; valLbl.Text = tostring(math.floor(default)); valLbl.TextColor3 = Theme.Accent; valLbl.Font = Enum.Font.GothamBold; valLbl.TextSize = 11; valLbl.TextXAlignment = Enum.TextXAlignment.Right; valLbl.ZIndex = 7
        
        local barBg = Instance.new("Frame", container); barBg.Size = UDim2.new(1, -20, 0, 4); barBg.Position = UDim2.new(0, 10, 1, -12); barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50); barBg.ZIndex = 7
        local bgc = Instance.new("UICorner", barBg); bgc.CornerRadius = UDim.new(1, 0)
        
        local fill = Instance.new("Frame", barBg); fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; fill.ZIndex = 7
        local fc = Instance.new("UICorner", fill); fc.CornerRadius = UDim.new(1, 0)

        local dragging = false
        barBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
        UserInputService.InputChanged:Connect(function(input) 
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                if math.abs(input.Delta.X) > math.abs(input.Delta.Y) or input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    valLbl.Text = tostring(val); callback(val)
                end
            end 
        end)
        UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
        callback(default)
    end

    -- НАПОЛНЕНИЕ: HOME
    local welcome = Instance.new("TextLabel", homePage); welcome.Size = UDim2.new(1, 0, 0, 30); welcome.BackgroundTransparency = 1; welcome.Text = "DEEP HUB | PRO"; welcome.TextColor3 = Theme.Accent; welcome.Font = Enum.Font.GothamBold; welcome.TextSize = 18; welcome.ZIndex = 7; welcome.LayoutOrder = 1

    local statusFrame = Instance.new("Frame", homePage); statusFrame.Size = UDim2.new(1, 0, 0, 70); statusFrame.BackgroundColor3 = Theme.ElementBg; statusFrame.ZIndex = 7; statusFrame.LayoutOrder = 2
    local stc = Instance.new("UICorner", statusFrame); stc.CornerRadius = UDim.new(0, 6)
    local statusTitle = Instance.new("TextLabel", statusFrame); statusTitle.Size = UDim2.new(1, -20, 0, 20); statusTitle.Position = UDim2.new(0, 10, 0, 10); statusTitle.BackgroundTransparency = 1; statusTitle.Text = "Статус:"; statusTitle.TextColor3 = Theme.SubText; statusTitle.Font = Enum.Font.GothamSemibold; statusTitle.TextSize = 12; statusTitle.TextXAlignment = Enum.TextXAlignment.Left; statusTitle.ZIndex = 8
    local statusText = Instance.new("TextLabel", statusFrame); statusText.Size = UDim2.new(1, -20, 0, 20); statusText.Position = UDim2.new(0, 10, 0, 30); statusText.BackgroundTransparency = 1; statusText.Text = "🟢 Работает (Undetected) | v1.0"; statusText.TextColor3 = Color3.fromRGB(0, 255, 100); statusText.Font = Enum.Font.GothamSemibold; statusText.TextSize = 14; statusText.TextXAlignment = Enum.TextXAlignment.Left; statusText.ZIndex = 8

    local credits = Instance.new("TextLabel", homePage); credits.Size = UDim2.new(1, 0, 0, 60); credits.BackgroundTransparency = 1; credits.Text = "Авторы:\n• hoptek\n• DeepSeek\n\nВерсия: v1.0"; credits.TextColor3 = Theme.Text; credits.Font = Enum.Font.Gotham; credits.TextSize = 13; credits.TextXAlignment = Enum.TextXAlignment.Left; credits.ZIndex = 7; credits.LayoutOrder = 3

    -- НАПОЛНЕНИЕ: RAGE
    createToggle(ragePage, "Aimbot", function(v) S.Aim = v end)
    createSlider(ragePage, "Aimbot FOV", 30, 800, S.AimFOV, function(v) S.AimFOV = v end)
    createSlider(ragePage, "Smoothness x100", 1, 100, S.Smooth * 100, function(v) S.Smooth = v / 100 end)
    createSlider(ragePage, "Aim Distance", 10, 500, S.AimDist, function(v) S.AimDist = v end)
    createToggle(ragePage, "Aimbot Players", function(v) S.AimPly = v end)
    createToggle(ragePage, "Aimbot Police", function(v) S.AimCop = v end)
    createToggle(ragePage, "Aimbot Guards", function(v) S.AimGuard = v end)
    createToggle(ragePage, "Aimbot Citizens", function(v) S.AimCit = v end)

    -- НАПОЛНЕНИЕ: VISUAL
    createToggle(visualPage, "Enable ESP (Ники и HP)", function(v) S.ESP = v end)
    createSlider(visualPage, "ESP Distance", 10, 500, S.ESPDist, function(v) S.ESPDist = v end)
    createToggle(visualPage, "Show FOV Circle", function(v) S.FOV = v end)
    createSlider(visualPage, "FOV Transparency", 1, 100, S.FOVTrans * 100, function(v) S.FOVTrans = v / 100 end)
    createToggle(visualPage, "Fullbright", function(v) 
        S.Fullbright = v 
        if v then Lighting.Ambient = Color3.fromRGB(255, 255, 255); Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255); Lighting.Brightness = 3; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
        else Lighting.Ambient = Color3.fromRGB(0, 0, 0); Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128); Lighting.Brightness = 1; Lighting.FogEnd = 10000; Lighting.GlobalShadows = true end
    end)

    -- НАПОЛНЕНИЕ: MISC
    createToggle(miscPage, "Speedhack", function(v) S.Speed = v end)
    createSlider(miscPage, "Speed Value", 16, 200, S.SpeedVal, function(v) S.SpeedVal = v end)
    createToggle(miscPage, "Fly (Полет)", function(v) S.Fly = v end)
    createToggle(miscPage, "Noclip", function(v) S.Noclip = v end)
    
    createToggle(miscPage, "🔥 HARD FPS Boost", function(v) 
        S.FPSBoost = v 
        if v then pcall(function() 
            settings().Rendering.QualityLevel = 1
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, obj in ipairs(Lighting:GetDescendants()) do 
                if obj:IsA("PostEffect") or obj:IsA("Atmosphere") or obj:IsA("Sky") then obj.Enabled = false end 
            end
            for _, obj in ipairs(Workspace:GetDescendants()) do 
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then obj.Enabled = false end 
            end
        end) else pcall(function() 
            settings().Rendering.QualityLevel = 10
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 10000
        end) end
    end)

    -- НАПОЛНЕНИЕ: SETTINGS (Цвета)
    local themeTitle = Instance.new("TextLabel", settingsPage); themeTitle.Size = UDim2.new(1, 0, 0, 20); themeTitle.BackgroundTransparency = 1; themeTitle.Text = "🎨 Цвет меню:"; themeTitle.TextColor3 = Theme.Accent; themeTitle.Font = Enum.Font.GothamSemibold; themeTitle.TextSize = 12; themeTitle.TextXAlignment = Enum.TextXAlignment.Left; themeTitle.ZIndex = 7

    local colorContainer = Instance.new("Frame", settingsPage); colorContainer.Size = UDim2.new(1, 0, 0, 30); colorContainer.BackgroundTransparency = 1; colorContainer.ZIndex = 7
    local colorLayout = Instance.new("UIListLayout", colorContainer); colorLayout.FillDirection = Enum.FillDirection.Horizontal; colorLayout.Padding = UDim.new(0, 10)

    local function updateThemeColor(newColor)
        Theme.Accent = newColor
        TweenService:Create(topBar, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(ms, TweenInfo.new(0.3), {Color = newColor}):Play()
        TweenService:Create(tDiamond, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(ts, TweenInfo.new(0.3), {Color = newColor}):Play()
        TweenService:Create(fog, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        fogGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, newColor), ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 10, 90))}
        
        TweenService:Create(avDiamond, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(avStroke, TweenInfo.new(0.3), {Color = newColor}):Play()
        TweenService:Create(hInner, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play()
        TweenService:Create(fovStroke, TweenInfo.new(0.3), {Color = newColor}):Play()
        
        homeTab.TextColor3 = newColor; rageTab.TextColor3 = newColor; visualTab.TextColor3 = newColor; miscTab.TextColor3 = newColor; settingsTab.TextColor3 = newColor; helpTab.TextColor3 = newColor
    end

    local colors = {
        {Name="Purple", Color=Color3.fromRGB(130, 70, 255)},
        {Name="Blue", Color=Color3.fromRGB(0, 150, 255)},
        {Name="Red", Color=Color3.fromRGB(255, 50, 50)},
        {Name="Green", Color=Color3.fromRGB(0, 255, 100)}
    }

    for _, cData in ipairs(colors) do
        local cBtn = Instance.new("TextButton", colorContainer)
        cBtn.Size = UDim2.new(0, 30, 0, 30); cBtn.BackgroundColor3 = cData.Color; cBtn.Text = ""; cBtn.ZIndex = 8
        local cCorner = Instance.new("UICorner", cBtn); cCorner.CornerRadius = UDim.new(1, 0)
        cBtn.MouseButton1Click:Connect(function() updateThemeColor(cData.Color) end)
    end

    -- НАПОЛНЕНИЕ: HELP
    local helpTitle = Instance.new("TextLabel", helpPage); helpTitle.Size = UDim2.new(1, 0, 0, 30); helpTitle.BackgroundTransparency = 1; helpTitle.Text = "📖 Термины"; helpTitle.TextColor3 = Theme.Accent; helpTitle.Font = Enum.Font.GothamSemibold; helpTitle.TextSize = 16; helpTitle.TextXAlignment = Enum.TextXAlignment.Left; helpTitle.ZIndex = 7
    local function createHelpElement(title, desc)
        local frame = Instance.new("Frame", helpPage); frame.Size = UDim2.new(1, 0, 0, 55); frame.BackgroundColor3 = Theme.ElementBg; frame.ZIndex = 7
        local c = Instance.new("UICorner", frame); c.CornerRadius = UDim.new(0, 6)
        local t = Instance.new("TextLabel", frame); t.Size = UDim2.new(1, -10, 0, 20); t.Position = UDim2.new(0, 5, 0, 5); t.BackgroundTransparency = 1; t.Text = title; t.TextColor3 = Theme.Accent; t.Font = Enum.Font.GothamSemibold; t.TextSize = 12; t.TextXAlignment = Enum.TextXAlignment.Left; t.ZIndex = 8
        local d = Instance.new("TextLabel", frame); d.Size = UDim2.new(1, -10, 0, 30); d.Position = UDim2.new(0, 5, 0, 22); d.BackgroundTransparency = 1; d.Text = desc; d.TextColor3 = Theme.SubText; d.Font = Enum.Font.Gotham; d.TextSize = 10; d.TextWrapped = true; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextYAlignment = Enum.TextYAlignment.Top; d.ZIndex = 8
    end
    createHelpElement("Aimbot", "Наводится на ближайшего к вам противника (включите нужные фильтры в RAGE).")
    createHelpElement("FOV Circle", "Круг, показывающий радиус работы Аимбота. Можно включить в VISUAL.")
    createHelpElement("ESP", "Подсвечивает противников сквозь стены и показывает их ник и здоровье.")
    createHelpElement("Fly", "Летишь в направлении камеры. Смотри вверх и жми вперёд.")
    createHelpElement("Noclip", "Позволяет проходить сквозь стены.")

    -- ОТКРЫТИЕ/ЗАКРЫТИЕ
    local function setVis(v)
        if v then 
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
        else 
            local tw = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function() mainFrame.Visible = false end) 
        end
    end
    closeBtn.MouseButton1Click:Connect(function() setVis(false) end)
    toggleBtn.MouseButton1Click:Connect(function() if mainFrame.Visible then setVis(false) else setVis(true) end end)

    -- ЛОГИКА АИМБОТА
    local function getTarget()
        local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
        local center = camera.ViewportSize / 2
        local closestDist = math.huge
        local bestTarget = nil
        
        for _, model in pairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model ~= player.Character and model:FindFirstChild("Head") and model:FindFirstChild("Humanoid") and model.Humanoid.Health > 0 then
                local isPly = Players:GetPlayerFromCharacter(model)
                local name = string.lower(model.Name)
                local isCop = string.find(name, "police") or string.find(name, "cop") or string.find(name, "officer") or string.find(name, "guard") or string.find(name, "security")
                local isGuard = string.find(name, "guard") or string.find(name, "security")
                local isCit = not isPly and not isCop

                local shouldAim = false
                if isPly and S.AimPly then shouldAim = true end
                if isCop and S.AimCop then shouldAim = true end
                if isGuard and S.AimGuard then shouldAim = true end
                if isCit and S.AimCit then shouldAim = true end

                if shouldAim then
                    local pos, onScreen = camera:WorldToViewportPoint(model.Head.Position)
                    local crosshairDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    
                    if onScreen and pos.Z > 0 and crosshairDist < S.AimFOV then
                        local distToPlayer = (model.Head.Position - myPos).Magnitude
                        if distToPlayer <= S.AimDist then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {player.Character, model}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local ray = Workspace:Raycast(camera.CFrame.Position, model.Head.Position - camera.CFrame.Position, rayParams)

                            if not ray then
                                if distToPlayer < closestDist then
                                    closestDist = distToPlayer
                                    bestTarget = model.Head
                                end
                            end
                        end
                    end
                end
            end
        end
        return bestTarget
    end

    RunService.RenderStepped:Connect(function()
        if S.FOV then
            fovCircle.Visible = true
            fovCircle.Size = UDim2.new(0, S.AimFOV * 2, 0, S.AimFOV * 2)
            fovStroke.Transparency = S.FOVTrans
        else
            fovCircle.Visible = false
        end

        if not S.Aim then return end
        local t = getTarget()
        if t then
            local targetPos = t.Position; local currentPos = camera.CFrame.Position
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(currentPos, targetPos), S.Smooth)
        end
    end)

    -- ЛОГИКА ESP & MISC
    local espCache = {}
    local flyBV = nil

    task.spawn(function()
        while task.wait(0.5) do
            if S.ESP then
                local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or camera.CFrame.Position
                local cur = {}
                
                for _, p in pairs(Workspace:GetDescendants()) do
                    if p:IsA("Model") and p ~= player.Character and p:FindFirstChild("Head") and p:FindFirstChild("Humanoid") and p.Humanoid.Health > 0 then
                        local h = p.Head
                        if (h.Position - myPos).Magnitude <= S.ESPDist then
                            cur[p] = true
                            if not espCache[p] then
                                local hl = Instance.new("Highlight", p)
                                hl.FillColor = Color3.fromRGB(255, 255, 255); hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.5; hl.Adornee = p
                                
                                local bb = Instance.new("BillboardGui", h)
                                bb.Size = UDim2.new(0, 100, 0, 35); bb.StudsOffset = Vector3.new(0, 1.2, 0); bb.AlwaysOnTop = true; bb.Adornee = h
                                
                                local nameLbl = Instance.new("TextLabel", bb); nameLbl.Size = UDim2.new(1, 0, 0.5, 0); nameLbl.BackgroundTransparency = 1; nameLbl.Text = p.Name; nameLbl.TextColor3 = Color3.new(1,1,1); nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 10; nameLbl.TextStrokeTransparency = 0
                                local hpLbl = Instance.new("TextLabel", bb); hpLbl.Size = UDim2.new(1, 0, 0.5, 0); hpLbl.Position = UDim2.new(0, 0, 0.5, 0); hpLbl.BackgroundTransparency = 1; hpLbl.Font = Enum.Font.GothamSemibold; hpLbl.TextSize = 10; hpLbl.TextStrokeTransparency = 0
                                
                                espCache[p] = {hl = hl, bb = bb, name = nameLbl, hp = hpLbl}
                            end
                            
                            local cache = espCache[p]
                            local hum = p:FindFirstChildOfClass("Humanoid")
                            if hum then
                                cache.name.Text = p.Name
                                cache.hp.Text = math.floor(hum.Health) .. " HP"
                                cache.hp.TextColor3 = Color3.fromRGB(0, 255, 100)
                            end
                        end
                    end
                end
                for char, data in pairs(espCache) do if not cur[char] then data.hl:Destroy(); data.bb:Destroy(); espCache[char] = nil end end
            else
                for char, data in pairs(espCache) do data.hl:Destroy(); data.bb:Destroy() end; espCache = {}
            end
        end
    end)

    RunService.Stepped:Connect(function()
        if player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if h and not S.Fly then
                h.WalkSpeed = S.Speed and S.SpeedVal or 16
            end
            
            if S.Fly and h and hrp then
                h.PlatformStand = true
                for _, part in ipairs(player.Character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + camera.CFrame.LookVector)
                if not flyBV then flyBV = Instance.new("BodyVelocity", hrp); flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
                local moveDir = h.MoveDirection; local vel = Vector3.new(0,0,0)
                if moveDir.Magnitude > 0.1 then vel = camera.CFrame.LookVector * (S.SpeedVal * 0.5) end
                flyBV.Velocity = vel
            else
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if h and h.PlatformStand then h.PlatformStand = false end
            end
            
            if S.Noclip then for _, p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
        end
    end)

    -- ================= АНИМАЦИЯ ЗАГРУЗКИ =================
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "IntroAnim"; introGui.ResetOnSpawn = false; introGui.IgnoreGuiInset = true; introGui.Parent = CoreGui

    local introText = Instance.new("TextLabel", introGui)
    introText.Size = UDim2.new(1, 0, 1, 0)
    introText.BackgroundTransparency = 1
    introText.Text = "DEEP HUB"
    introText.TextColor3 = Theme.Accent
    introText.Font = Enum.Font.GothamBold
    introText.TextSize = 50
    introText.TextTransparency = 1

    task.spawn(function()
        task.wait(0.3)
        TweenService:Create(introText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        task.wait(1.5)
        TweenService:Create(introText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
        task.wait(1)
        introGui:Destroy()
        
        -- КНОПКА И МЕНЮ ПОЯВЛЯЮТСЯ ОДНОВРЕМЕННО
        toggleBtn.Visible = true
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 400, 0, 280)}):Play()
    end)

end)

if not success then
    local errorGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local errLbl = Instance.new("TextLabel", errorGui)
    errLbl.Size = UDim2.new(1, 0, 1, 0); errLbl.BackgroundColor3 = Color3.new(0,0,0); errLbl.BackgroundTransparency = 0.5
    errLbl.Text = "DEEP HUB ERROR:\n" .. tostring(error_msg); errLbl.TextColor3 = Color3.new(1, 0, 0); errLbl.Font = Enum.Font.GothamBold; errLbl.TextSize = 14; errLbl.TextWrapped = true
end
