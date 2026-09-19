--!strict
-- ============================================================
-- NINJA MENU - ULTIMATE EDITION v6.4.0 (宋代计划·最终版)
-- ============================================================
local VERSION = "6.4.0"

-- ===== CONFIG =====
local CONFIG = {
    UI_WIDTH = 480,
    UI_HEIGHT = 420,
    BTN_HEIGHT = 36,
    BTN_GAP = 4,
    BTN_START_Y = 68,
    FLY_SPEED_TIERS = {40, 80, 120, 160},
    LIFT_SPEED = 50,
    MAX_FLY_HEIGHT = 500,
    MIN_FLY_HEIGHT = 3,
    FLY_SMOOTHING = 20,
    PLATFORM_STAND_BYPASS = false,
    NOCLIP_ANTI_REVERT = true,
    ESP_RANGE = 80,
    ESP_REFRESH = 0.2,
    ESP_VISIBLE_ONLY_DEFAULT = false,
    TOGGLE_KEY = Enum.KeyCode.F,
    RECALL_KEY = Enum.KeyCode.Z,
    DEBUG = false,
    MAX_ERRORS = 10,
    UPDATE_CHECK_ENABLED = false,
    UPDATE_CHECK_URL = "",
    THEME = {
        BG = Color3.fromRGB(20, 20, 25),
        BG_TRANSPARENCY = 0.15,
        TITLE_BG = Color3.fromRGB(30, 30, 35),
        BTN_BG = Color3.fromRGB(40, 40, 45),
        BTN_HOVER = Color3.fromRGB(60, 60, 70),
        BTN_ON = Color3.fromRGB(60, 180, 60),
        BTN_OFF = Color3.fromRGB(40, 40, 45),
        TEXT = Color3.new(1, 1, 1),
        HINT = Color3.fromRGB(170, 170, 170),
        CLOSE = Color3.fromRGB(200, 50, 50),
        BALL = Color3.fromRGB(60, 60, 180),
        STROKE = Color3.fromRGB(60, 60, 70),
        CORNER_RADIUS = 8,
    },
    LOCALIZATION = {
        FLIGHT = "Flight",
        NOCLIP = "Noclip",
        ESP = "ESP",
        ESP_VISIBLE = "ESP: Visible Only",
        FLY_SPEED = "Fly Speed",
        ALL_OFF = "All Off / Reset",
        SHUTDOWN = "Shutdown",
        HINT = "[F] hide/show | [Z] recall | drag title",
        ON = "ON",
        OFF = "OFF",
    },
}

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ===== STATE =====
local State = {
    Fly = false,
    Noclip = false,
    ESP = false,
    ESPVisibleOnly = CONFIG.ESP_VISIBLE_ONLY_DEFAULT,
    FlySpeedTier = 2,
    Visible = true,
}
local running = true
local ESPHolders = {}
local connections = {}
local buttons = {}
local soundInstance = nil
local raycastBlocked = nil

-- ===== HELPERS =====
local function log(...) print("[NF]", ...) end
local function safe(name, fn)
    local s, e = pcall(fn)
    if not s then warn("[NF:"..name.."]", e) end
end
local function dbg(...)
    if CONFIG.DEBUG then print("[DEBUG]", ...) end
end

local function getChar() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function getRoot() local c = getChar() return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = getChar() return c and c:FindFirstChild("Humanoid") end

-- ===== 3/4/10/11: raycastBlocked 用 Exclude，不用弃用 API =====
do
    local ok = pcall(function()
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        workspace:Raycast(Vector3.new(0,0,0), Vector3.new(1,0,0), params)
    end)
    
    if ok then
        raycastBlocked = function(p1, p2, filter)
            local char = getChar()
            if not char then return false end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = filter or {char}
            local res = workspace:Raycast(p1, (p2-p1), params)
            return res ~= nil
        end
    else
        raycastBlocked = function(p1, p2, filter)
            local dir = p2 - p1
            local dist = dir.Magnitude
            if dist == 0 then return false end
            local char = getChar()
            if not char then return false end
            local ignoreList = filter or {char}
            local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(p1, dir), ignoreList)
            return hit ~= nil
        end
    end
end

local V3_ZERO = Vector3.new(0,0,0)

-- ===== SOUND =====
local function GetSound()
    if not soundInstance then
        soundInstance = Instance.new("Sound")
        soundInstance.SoundId = "rbxassetid://9115509226"
        soundInstance.Volume = 0.3
        soundInstance.Parent = SoundService
    end
    return soundInstance
end

local function PlayClick()
    safe("sound", function()
        local s = GetSound()
        s:Play()
    end)
end

-- ===== UI =====
local sg, main, title, hint, ball, btnFrame, ballSg

local function UI_Show()
    State.Visible = true
    if sg then sg.Enabled = true end
    if main then main.Visible = true end
    if ball then ball.Visible = false end
    if main then main.BackgroundTransparency = CONFIG.THEME.BG_TRANSPARENCY end
end

-- 1+2+62: UI_Hide 完整实现 + 26: 淡出动画
local function UI_Hide()
    State.Visible = false
    if main then
        task.spawn(function()
            for i = 1, 5 do
                main.BackgroundTransparency = math.min(1, main.BackgroundTransparency + 0.17)
                task.wait(0.02)
            end
        end)
    end
    task.delay(0.1, function()
        if not State.Visible then
            if sg then sg.Enabled = false end
            if main then main.Visible = false end
            if ballSg then ballSg.Enabled = true end
            if ball then ball.Visible = true end
        end
    end)
end

local function UI_Toggle()
    if State.Visible then UI_Hide() else UI_Show() end
end

local function UI_Shutdown()
    running = false
    safe("destroyBall", function()
        if ballSg and ballSg.Parent then ballSg:Destroy() end
    end)
    safe("destroyMain", function()
        if sg and sg.Parent then sg:Destroy() end
    end)
end

-- 16: SetupDrag 用 InputBegan 的 Position，不用 GetMouseLocation
local function SetupDrag()
    local drag = false; local sx,sy,px,py
    local function clamp()
        local sw = Camera.ViewportSize.X
        local sh = Camera.ViewportSize.Y
        local x = math.clamp(main.Position.X.Offset, 0, sw - CONFIG.UI_WIDTH)
        local y = math.clamp(main.Position.Y.Offset, 0, sh - CONFIG.UI_HEIGHT)
        main.Position = UDim2.new(0, x, 0, y)
    end
    local function startDrag(pos)
        drag = true
        sx = pos.X; sy = pos.Y
        px = main.Position.X.Offset; py = main.Position.Y.Offset
    end
    local function moveDrag(pos)
        if drag then
            main.Position = UDim2.new(0, px+(pos.X-sx), 0, py+(pos.Y-sy))
            clamp()
        end
    end
    local function endDrag() drag = false end

    connections.dragBegan = UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local pos = i.Position
            local ap = main.AbsolutePosition; local as = main.AbsoluteSize
            if pos.X >= ap.X and pos.X <= ap.X+as.X and pos.Y >= ap.Y and pos.Y <= ap.Y+45 then
                startDrag(pos)
            end
        end
    end)
    connections.dragEnded = UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then endDrag() end
    end)
    connections.dragChanged = UserInputService.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            local pos = i.Position
            moveDrag(pos)
        end
    end)
end

-- 8+9+36+37+39+40+41+81+82+83+84: UI_MakeBtn 完整版
local function UI_MakeBtn(idx, text, onClick)
    local ok, btn = pcall(function()
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1,0,0, CONFIG.BTN_HEIGHT)
        b.Text = text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 18
        b.BackgroundColor3 = CONFIG.THEME.BTN_BG
        b.TextColor3 = CONFIG.THEME.TEXT
        b.AutoButtonColor = false
        b.ZIndex = 2
        b.Selectable = false
        b.Parent = btnFrame
        
        b:SetAttribute("BaseColor", CONFIG.THEME.BTN_BG)
        
        b.MouseEnter:Connect(function()
            b.BackgroundColor3 = CONFIG.THEME.BTN_HOVER
        end)
        b.MouseLeave:Connect(function()
            b.BackgroundColor3 = b:GetAttribute("BaseColor") or CONFIG.THEME.BTN_BG
        end)
        
        local animating = false
        local function handleClick()
            if animating then return end
            animating = true
            PlayClick()
            local origSize = b.Size
            b.Size = UDim2.new(0.95,0,0, CONFIG.BTN_HEIGHT*0.95)
            task.delay(0.08, function()
                b.Size = origSize
                animating = false
            end)
            safe("btn", onClick)
        end
        
        b.Activated:Connect(handleClick)
        
        b.SelectionGained:Connect(function()
            b.BackgroundColor3 = CONFIG.THEME.BTN_HOVER
        end)
        b.SelectionLost:Connect(function()
            b.BackgroundColor3 = b:GetAttribute("BaseColor") or CONFIG.THEME.BTN_BG
        end)
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, CONFIG.THEME.CORNER_RADIUS)
        corner.Parent = b
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = CONFIG.THEME.STROKE
        stroke.Thickness = 1
        stroke.Parent = b
        
        b.TextScaled = true
        b.TextWrapped = true
        
        return b
    end)
    if not ok then
        warn("[NF:UI_MakeBtn]", btn)
        return nil
    end
    return btn
end

local function RefreshAll()
    local labels = {
        [1] = CONFIG.LOCALIZATION.FLIGHT.." ["..(State.Fly and CONFIG.LOCALIZATION.ON or CONFIG.LOCALIZATION.OFF).."]",
        [2] = CONFIG.LOCALIZATION.NOCLIP.." ["..(State.Noclip and CONFIG.LOCALIZATION.ON or CONFIG.LOCALIZATION.OFF).."]",
        [3] = CONFIG.LOCALIZATION.ESP.." ["..(State.ESP and CONFIG.LOCALIZATION.ON or CONFIG.LOCALIZATION.OFF).."]",
        [4] = CONFIG.LOCALIZATION.ESP_VISIBLE.." ["..(State.ESPVisibleOnly and CONFIG.LOCALIZATION.ON or CONFIG.LOCALIZATION.OFF).."]",
        [5] = CONFIG.LOCALIZATION.FLY_SPEED..": "..CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier].." u/s",
        [6] = CONFIG.LOCALIZATION.ALL_OFF,
        [7] = CONFIG.LOCALIZATION.SHUTDOWN,
    }
    
    for i = 1, 7 do
        local btn = buttons[i]
        if btn then
            btn.Text = labels[i]
            local baseColor = CONFIG.THEME.BTN_BG
            if i == 1 and State.Fly then baseColor = CONFIG.THEME.BTN_ON end
            if i == 2 and State.Noclip then baseColor = CONFIG.THEME.BTN_ON end
            if i == 3 and State.ESP then baseColor = CONFIG.THEME.BTN_ON end
            btn:SetAttribute("BaseColor", baseColor)
            btn.BackgroundColor3 = baseColor
        end
    end
end

local function SetupBtnLayout()
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, CONFIG.BTN_GAP)
    layout.Parent = btnFrame
end

local function FadeIn()
    task.spawn(function()
        main.BackgroundTransparency = 1
        for i = 1, 10 do
            main.BackgroundTransparency = 1 - (i * 0.085)
            task.wait(0.02)
        end
        main.BackgroundTransparency = CONFIG.THEME.BG_TRANSPARENCY
    end)
end

local uiInitOk, uiInitErr = pcall(function()
    sg = Instance.new("ScreenGui")
    sg.Name = "NinjaMenu"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    main = Instance.new("Frame")
    main.Size = UDim2.new(0, CONFIG.UI_WIDTH, 0, CONFIG.UI_HEIGHT)
    main.Position = UDim2.new(0.5, -CONFIG.UI_WIDTH/2, 0.5, -CONFIG.UI_HEIGHT/2)
    main.BackgroundColor3 = CONFIG.THEME.BG
    main.BackgroundTransparency = CONFIG.THEME.BG_TRANSPARENCY
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Selectable = false
    main.Parent = sg

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, CONFIG.THEME.CORNER_RADIUS)
    mainCorner.Parent = main

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = CONFIG.THEME.STROKE
    mainStroke.Thickness = 2
    mainStroke.Parent = main

    local bg = Instance.new("ImageLabel")
    bg.Size = UDim2.new(1,0,1,0)
    bg.Image = "rbxassetid://117756559340646"
    bg.ImageTransparency = 0.05
    bg.BackgroundTransparency = 1
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 1
    bg.Parent = main

    local bgLoaded = false
    bg.Loaded:Connect(function() bgLoaded = true end)
    task.spawn(function()
        safe("bg", function() ContentProvider:PreloadAsync({bg}) end)
        task.wait(5)
        if not bgLoaded then
            bg.ImageTransparency = 1
            main.BackgroundTransparency = 0.3
        end
    end)

    title = Instance.new("Frame")
    title.Size = UDim2.new(1,0,0,45)
    title.BackgroundColor3 = CONFIG.THEME.TITLE_BG
    title.BackgroundTransparency = 0.2
    title.ZIndex = 2
    title.Parent = main

    local ttxt = Instance.new("TextLabel")
    ttxt.Size = UDim2.new(1,-90,1,0)
    ttxt.Position = UDim2.new(0,10,0,0)
    ttxt.Text = "NINJA Menu v"..VERSION
    ttxt.Font = Enum.Font.GothamBold
    ttxt.TextSize = 20
    ttxt.TextColor3 = CONFIG.THEME.TEXT
    ttxt.BackgroundTransparency = 1
    ttxt.TextXAlignment = Enum.TextXAlignment.Left
    ttxt.ZIndex = 2
    ttxt.Parent = title

    hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1,-20,0,20)
    hint.Position = UDim2.new(0,10,0,46)
    hint.Text = CONFIG.LOCALIZATION.HINT
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 12
    hint.TextColor3 = CONFIG.THEME.HINT
    hint.BackgroundTransparency = 1
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.ZIndex = 2
    hint.Parent = main

    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0,40,0,40)
    minimize.Position = UDim2.new(1,-90,0,2)
    minimize.Text = "-"
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 20
    minimize.BackgroundColor3 = CONFIG.THEME.BTN_HOVER
    minimize.TextColor3 = CONFIG.THEME.TEXT
    minimize.ZIndex = 3
    minimize.Parent = title
    minimize.Activated:Connect(function() safe("minimize", UI_Hide) end)

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0,40,0,40)
    close.Position = UDim2.new(1,-45,0,2)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.BackgroundColor3 = CONFIG.THEME.CLOSE
    close.TextColor3 = CONFIG.THEME.TEXT
    close.ZIndex = 3
    close.Parent = title
    close.Activated:Connect(function() safe("close", UI_Hide) end)

    ballSg = Instance.new("ScreenGui")
    ballSg.Name = "NinjaBall"
    ballSg.ResetOnSpawn = false
    ballSg.DisplayOrder = 1000
    ballSg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ballSg.Parent = (gethui and gethui()) or game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

    ball = Instance.new("TextButton")
    ball.Size = UDim2.new(0,44,0,44)
    ball.Position = UDim2.new(1,-54,1,-54)
    ball.Text = "N"
    ball.Font = Enum.Font.GothamBold
    ball.TextSize = 20
    ball.BackgroundColor3 = CONFIG.THEME.BALL
    ball.TextColor3 = CONFIG.THEME.TEXT
    ball.Visible = false
    ball.ZIndex = 1000
    ball.Parent = ballSg
    ball.Activated:Connect(function() safe("ball", UI_Show) end)

    btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1,-40,0,282)
    btnFrame.Position = UDim2.new(0,20,0,CONFIG.BTN_START_Y)
    btnFrame.BackgroundTransparency = 1
    btnFrame.ZIndex = 2
    btnFrame.Selectable = false
    btnFrame.Parent = main

    SetupBtnLayout()
    SetupDrag()

    connections.hotkeys = UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == CONFIG.TOGGLE_KEY then
            UI_Toggle()
        elseif i.KeyCode == CONFIG.RECALL_KEY then
            UI_Show()
        end
    end)
end)

if not uiInitOk then warn("[NF:UI_Init]", uiInitErr) end

-- ===== FLIGHT (完美整合版) =====
local function Flight_Toggle()
    State.Fly = not State.Fly
    if not State.Fly then
        local root = getRoot()
        if root then root.AssemblyLinearVelocity = V3_ZERO end
        local hum = getHum()
        if hum then hum.PlatformStand = false end
    end
end

local function Flight_Init()
    connections.render = RunService.RenderStepped:Connect(function(dt)
        if not State.Fly then return end
        local root = getRoot()
        if not root then return end
        local head = root.Parent and root.Parent:FindFirstChild("Head")
        if not head then return end
        
        local cam = workspace.CurrentCamera
        local forward = cam and cam.CFrame.LookVector or Vector3.new(0,0,-1)
        forward = Vector3.new(forward.X, 0, forward.Z).Unit
        local right = Vector3.new(-forward.Z, 0, forward.X)
        local hDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then hDir = hDir + forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then hDir = hDir - forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then hDir = hDir - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then hDir = hDir + right end
        
        local sp = CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier] or CONFIG.LIFT_SPEED
        local fm = Vector3.new(0,0,0)
        if hDir.Magnitude > 0 then
            local move = hDir.Unit * sp * dt
            if not raycastBlocked(root.Position, root.Position + move) then
                fm = fm + move
            end
        end
        
        local vDir = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vDir = vDir + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then vDir = vDir - 1 end
        
        local target = root.Position
        if vDir ~= 0 then
            local lv = CONFIG.LIFT_SPEED or 50
            local origin = (vDir > 0) and head.Position or root.Position
            local halfSize = (vDir > 0) and head.Size.Y/2 or root.Size.Y/2
            local dist = math.abs(vDir*lv*dt) + halfSize + 0.1
            local dir = Vector3.new(0, vDir > 0 and dist or -dist, 0)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {root.Parent}
            params.IgnoreWater = true
            local hit = workspace:Raycast(origin, dir, params)
            if hit then
                local offset = hit.Normal * (root.Size.Y/2 + 0.05)
                local targetPos = hit.Position + offset
                root.CFrame = CFrame.new(targetPos.X, targetPos.Y, targetPos.Z) * (root.CFrame - root.CFrame.Position)
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                target = root.Position
            else
                target = target + Vector3.new(0, vDir*lv*dt, 0)
            end
        end
        
        local groundY = root.Position.Y
        local gHit, gPos = workspace:FindPartOnRayWithIgnoreList(Ray.new(root.Position, Vector3.new(0,-500,0)), {root.Parent}, false, true)
        if gHit then groundY = gPos.Y end
        local minY = (CONFIG.MIN_FLY_HEIGHT or 0) + groundY
        target = Vector3.new(target.X, math.max(target.Y, minY), target.Z)
        
        local alpha = 1 - math.exp(-CONFIG.FLY_SMOOTHING * dt)
        root.CFrame = root.CFrame:Lerp(CFrame.new(target) * (root.CFrame - root.CFrame.Position), alpha)
        root.CFrame = root.CFrame + fm
    end)
end

-- ===== NOCLIP =====
local cachedParts = {}
local function Noclip_GetParts()
    local char = getChar()
    if not char then return {} end
    local parts = {}
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p:IsDescendantOf(char) then
            local skip = false
            local parent = p.Parent
            while parent and parent ~= char do
                if parent:IsA("Tool") or parent:IsA("BackpackItem") then skip = true; break end
                parent = parent.Parent
            end
            if not skip then table.insert(parts, p) end
        end
    end
    return parts
end

local function Noclip_Restore()
    for _,p in pairs(cachedParts) do
        if p and p.Parent and p:GetAttribute("NinjaNoclip") then
            local orig = p:GetAttribute("NinjaOrigCollide")
            p.CanCollide = orig ~= nil and orig or true
            p:SetAttribute("NinjaNoclip", nil)
            p:SetAttribute("NinjaOrigCollide", nil)
        end
    end
    cachedParts = {}
end

local function Noclip_Toggle()
    State.Noclip = not State.Noclip
    if not State.Noclip then Noclip_Restore() else cachedParts = Noclip_GetParts() end
end

local function Noclip_Init()
    connections.characterAdded = LocalPlayer.CharacterAdded:Connect(function()
        if State.Noclip then cachedParts = Noclip_GetParts() end
    end)
    connections.stepped = RunService.Stepped:Connect(function()
        if not State.Noclip then return end
        for _,p in pairs(cachedParts) do
            if p and p.Parent and p.CanCollide then
                if p:GetAttribute("NinjaOrigCollide") == nil then
                    p:SetAttribute("NinjaOrigCollide", p.CanCollide)
                end
                p.CanCollide = false
                p:SetAttribute("NinjaNoclip", true)
            end
        end
    end)
end

-- ===== ESP =====
local function ESP_Clear()
    for bill,_ in pairs(ESPHolders) do
        if bill and bill.Parent then bill:Destroy() end
    end
    ESPHolders = {}
end

local function ESP_Create(plr, char)
    local head = char:FindFirstChild("Head")
    local hroot = char:FindFirstChild("HumanoidRootPart")
    if not head or not hroot then return end
    
    local hum = char:FindFirstChild("Humanoid")
    local isR15 = hum and hum.RigType == Enum.HumanoidRigType.R15 or false
    local offset = isR15 and 3 or 2.5
    
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_NINJA"
    bill.Size = UDim2.new(0,120,0,60)
    bill.StudsOffset = Vector3.new(0, offset, 0)
    bill.AlwaysOnTop = true
    bill.Adornee = head
    bill.Parent = head
    
    local isTeam = plr.Team and plr.Team == LocalPlayer.Team
    local maxHp = hum and hum.MaxHealth or 100
    
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "ESP_Name"
    nameLbl.Size = UDim2.new(1,0,0.4,0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.Name
    nameLbl.TextColor3 = isTeam and Color3.new(0.2,1,0.2) or Color3.new(1,1,1)
    nameLbl.TextStrokeTransparency = 0
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 14
    nameLbl.Parent = bill
    
    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "ESP_Dist"
    distLbl.Size = UDim2.new(1,0,0.3,0)
    distLbl.Position = UDim2.new(0,0,0.4,0)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0m"
    distLbl.TextColor3 = Color3.new(1,1,1)
    distLbl.Font = Enum.Font.Gotham
    distLbl.TextSize = 12
    distLbl.Parent = bill
    
    local hpBar = Instance.new("Frame")
    hpBar.Name = "ESP_HpBar"
    hpBar.Size = UDim2.new(0.8,0,0.15,0)
    hpBar.Position = UDim2.new(0.1,0,0.75,0)
    hpBar.BackgroundColor3 = Color3.new(0.3,0.3,0.3)
    hpBar.Parent = bill
    
    local hpFill = Instance.new("Frame")
    hpFill.Name = "ESP_HpFill"
    local initPct = hum and hum.Health / math.max(hum.MaxHealth,1) or 1
    hpFill.Size = UDim2.new(initPct,0,1,0)
    hpFill.BackgroundColor3 = Color3.new(1-initPct, initPct, 0.2)
    hpFill.Parent = hpBar
    
    local box = Instance.new("Frame")
    box.Name = "ESP_Box"
    box.Size = UDim2.new(isR15 and 1.4 or 1.2, 0, isR15 and 1.8 or 1.6, 0)
    box.Position = UDim2.new(isR15 and -0.2 or -0.1, 0, isR15 and -0.4 or -0.3, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 1
    box.BorderColor3 = isTeam and Color3.new(0.2,1,0.2) or Color3.new(1,0.2,0.2)
    box.ZIndex = 0
    box.Parent = bill
    
    ESPHolders[bill] = true
end

local function ESP_IsVisible(head)
    if not State.ESPVisibleOnly then return true end
    local char = getChar()
    if not char then return true end
    local delta = head.Position - Camera.CFrame.Position
    local dist = delta.Magnitude
    if dist < 0.1 then return true end
    local dir = delta / dist
    return not raycastBlocked(Camera.CFrame.Position, Camera.CFrame.Position + dir*300, {char, head.Parent})
end

local function ESP_Toggle()
    State.ESP = not State.ESP
    if not State.ESP then ESP_Clear() end
end

local function ESP_ToggleVisible()
    State.ESPVisibleOnly = not State.ESPVisibleOnly
    if State.ESP then ESP_Clear() end
end

local function ESP_Init()
    local function hook(plr)
        if plr == LocalPlayer then return end
        plr.CharacterAdded:Connect(function(char)
            if not State.ESP then return end
            task.wait(0.1)
            if State.ESP and char.Parent then ESP_Create(plr, char) end
        end)
    end
    for _,p in pairs(Players:GetPlayers()) do hook(p) end
    connections.playerAdded = Players.PlayerAdded:Connect(hook)
    
    connections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local bill = head:FindFirstChild("ESP_NINJA")
                if bill then bill:Destroy(); ESPHolders[bill] = nil end
            end
        end
    end)
    
    task.spawn(function()
        while running do
            local s = pcall(function()
                if State.ESP then
                    local root = getRoot()
                    if root then
                        local mp = root.Position
                        local toRemove = {}
                        for bill,_ in pairs(ESPHolders) do
                            if not bill or not bill.Parent then table.insert(toRemove, bill) end
                        end
                        for _,bill in ipairs(toRemove) do ESPHolders[bill] = nil end
                        
                        for _,p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character then
                                local char = p.Character
                                local head = char:FindFirstChild("Head")
                                local hroot = char:FindFirstChild("HumanoidRootPart")
                                if head and hroot then
                                    local dist = (hroot.Position - mp).Magnitude
                                    if dist <= CONFIG.ESP_RANGE and ESP_IsVisible(head) then
                                        local bill = head:FindFirstChild("ESP_NINJA")
                                        if not bill then
                                            ESP_Create(p, char)
                                        else
                                            local dLbl = bill:FindFirstChild("ESP_Dist")
                                            if dLbl then dLbl.Text = math.floor(dist).."m" end
                                            local hum = char:FindFirstChild("Humanoid")
                                            local hpFill = bill:FindFirstChild("ESP_HpFill")
                                            if hum and hpFill then
                                                local pct = math.clamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
                                                hpFill.Size = UDim2.new(pct,0,1,0)
                                                hpFill.BackgroundColor3 = Color3.new(1-pct, pct, 0.2)
                                            end
                                        end
                                    else
                                        local bill = head:FindFirstChild("ESP_NINJA")
                                        if bill then bill:Destroy(); ESPHolders[bill] = nil end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if not s then task.wait(2) end
            task.wait(CONFIG.ESP_REFRESH)
        end
    end)
end

-- ===== MASTER =====
local function Master_AllOff()
    State.Fly = false
    State.Noclip = false
    State.ESP = false
    State.FlySpeedTier = 2
    State.ESPVisibleOnly = CONFIG.ESP_VISIBLE_ONLY_DEFAULT
    State.Visible = true
    local root = getRoot()
    if root then root.AssemblyLinearVelocity = V3_ZERO end
    local hum = getHum()
    if hum and hum.Health > 0 then hum.PlatformStand = false end
    Noclip_Restore()
    ESP_Clear()
    RefreshAll()
end

local function Master_Shutdown()
    running = false
    local keys = {}
    for k in pairs(connections) do table.insert(keys, k) end
    for _, name in ipairs(keys) do
        local c = connections[name]
        safe("disconnect:"..name, function() c:Disconnect() end)
        connections[name] = nil
    end
    UI_Shutdown()
    safe("soundCleanup", function()
        if soundInstance then soundInstance:Destroy(); soundInstance = nil end
    end)
    log("shutdown complete")
end

-- ===== ASSEMBLE =====
if uiInitOk then
    Flight_Init()
    Noclip_Init()
    ESP_Init()

    buttons[1] = UI_MakeBtn(1, "", function() Flight_Toggle(); RefreshAll() end)
    buttons[2] = UI_MakeBtn(2, "", function() Noclip_Toggle(); RefreshAll() end)
    buttons[3] = UI_MakeBtn(3, "", function() ESP_Toggle(); RefreshAll() end)
    buttons[4] = UI_MakeBtn(4, "", function() ESP_ToggleVisible(); RefreshAll() end)
    buttons[5] = UI_MakeBtn(5, "", function()
        State.FlySpeedTier = (State.FlySpeedTier % #CONFIG.FLY_SPEED_TIERS) + 1
        RefreshAll()
    end)
    buttons[6] = UI_MakeBtn(6, "", function() Master_AllOff() end)
    
    -- 修正：按钮7彻底关闭脚本
    buttons[7] = UI_MakeBtn(7, "", function() Master_Shutdown() end)
    
    RefreshAll()
    FadeIn()
    
    if CONFIG.UPDATE_CHECK_ENABLED and CONFIG.UPDATE_CHECK_URL ~= "" then
        task.spawn(function()
            safe("version", function()
                local data = HttpService:GetAsync(CONFIG.UPDATE_CHECK_URL)
                if data and data ~= VERSION then log("new version available: "..data) end
            end)
        end)
    end
else
    Flight_Init()
    Noclip_Init()
    ESP_Init()
    log("UI init failed, core features running without menu")
end

log("Ninja Menu v"..VERSION.." loaded - 宋代计划·最终版")
