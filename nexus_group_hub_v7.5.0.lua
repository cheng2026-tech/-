--!strict
-- ============================================================
-- NEXUS · HUB - ULTIMATE EDITION v7.5.0
-- 宋代计划 · 移动功能完全体
-- ============================================================
local VERSION = "7.5.0"

local CONFIG = {
    UI_WIDTH = 680, UI_HEIGHT = 500, SIDEBAR_W = 200,
    FLY_SPEED_TIERS = {100, 200, 350, 500},
    LIFT_SPEED = 150,
    ESP_RANGE = 80, ESP_REFRESH = 0.2, ESP_VISIBLE_ONLY_DEFAULT = false,
    TOGGLE_KEY = Enum.KeyCode.F, RECALL_KEY = Enum.KeyCode.Z,
    HEAD_TAG_ENABLED = true, HEAD_TAG_TEXT = "NEXUS · 用户",
    HEAD_TAG_COLOR = Color3.fromRGB(0, 229, 255),
    TIME_24H = false, TIME_SHOW_SECONDS = true,
    BALL_X = 0.5, BALL_X_OFFSET = -27, BALL_Y = 0, BALL_Y_OFFSET = 20,
    BG_IMAGE = "rbxassetid://117756559340646", BG_TRANSPARENCY = 0.15,
    FLY_LIFT_OFFSET = 3,
    JUMP_POWER = 120, SPRINT_SPEED = 90,
    LOW_GRAV = 50, CLICK_TP_KEY = Enum.KeyCode.T,
    THEME = {
        OVERLAY_TRANSPARENCY = 0.45,
        SIDEBAR_BG = Color3.fromRGB(10, 12, 18),
        SIDEBAR_ACTIVE = Color3.fromRGB(0, 40, 55),
        ACCENT = Color3.fromRGB(0, 180, 220),
        ACCENT_GLOW = Color3.fromRGB(0, 229, 255),
        TEXT = Color3.fromRGB(240, 245, 250),
        TEXT_DIM = Color3.fromRGB(120, 140, 160),
        GREEN = Color3.fromRGB(50, 220, 110),
        CARD_BG = Color3.fromRGB(18, 22, 30),
        CARD_HOVER = Color3.fromRGB(30, 38, 50),
        CARD_ON = Color3.fromRGB(0, 180, 220),
        CORNER = 12,
    },
    L = {
        BRAND = "NEXUS", SUBTITLE = "HUB · v7.5.0",
        FLIGHT = "飞行", ESP = "透视", ESP_VISIBLE = "仅可见", FLY_SPEED = "速度",
        TELEPORT = "传送", INF_JUMP = "无限跳", WATER_WALK = "水上行走", COORDS = "坐标",
        FREECAM = "自由视角", SPEEDBOOST = "速度增强",
        SPAWN_TP = "回出生点", ANTI_FALL = "反掉落", CLICK_TP = "点击传送",
        JUMP_BOOST = "跳跃增强", SPIDER = "蜘蛛侠", SPRINT = "极速冲刺",
        NOCLIP = "穿墙", LOW_GRAV = "低重力", ZERO_GRAV = "零重力",
        ALL_OFF = "重置", SHUTDOWN = "关闭", ON = "开", OFF = "关",
        LOADING = "CORE HUB 加载中",
    },
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

local State = {
    Fly = false, Noclip = false, ESP = false, ESPVisibleOnly = CONFIG.ESP_VISIBLE_ONLY_DEFAULT,
    FlySpeedTier = 2, Visible = true, Page = 1,
    InfJump = false, WaterWalk = false, FreeCam = false, SpeedBoost = 0,
    AntiFall = false, JumpBoost = false, Spider = false, Sprint = false,
    LowGrav = false, ZeroGrav = false, ClickTP = false,
}
local FreeCamData = { OrigType = nil, OrigSubj = nil, Pos = Vector3.new(), Yaw = 0, Pitch = 0 }
local running = true
local ESPHolders = {}
local connections = {}
local navItems = {}
local soundInst = nil
local raycastBlocked = nil
local noclipParts = {}

local function log(...) print("[NEXUS]", ...) end
local function safe(name, fn)
    local ok, e = pcall(fn)
    if not ok then warn("[NEXUS:"..name.."]", e) end
end
local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getRoot() local c = LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c = LP.Character return c and c:FindFirstChild("Humanoid") end

do
    local ok = pcall(function()
        local p = RaycastParams.new(); p.FilterType = Enum.RaycastFilterType.Exclude
        workspace:Raycast(Vector3.new(), Vector3.new(1,0,0), p)
    end)
    if ok then
        raycastBlocked = function(p1, p2, filter)
            local char = getChar(); if not char then return false end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = filter or {char}
            return workspace:Raycast(p1, p2-p1, params) ~= nil
        end
    else
        raycastBlocked = function(p1, p2, filter)
            local dir = p2-p1; if dir.Magnitude == 0 then return false end
            local char = getChar(); if not char then return false end
            return workspace:FindPartOnRayWithIgnoreList(Ray.new(p1, dir), filter or {char}) ~= nil
        end
    end
end

local V3_ZERO = Vector3.new()
local function GetSound()
    if not soundInst then
        soundInst = Instance.new("Sound")
        soundInst.SoundId = "rbxassetid://9115509226"
        soundInst.Volume = 0.2
        soundInst.Parent = SoundService
    end
    return soundInst
end
local function PlayClick() safe("sound", function() GetSound():Play() end) end

-- 前向声明
local Flight_Toggle, ESP_Toggle, ESP_ToggleVisible, Master_AllOff, Master_Shutdown
local InfJump_Toggle, WaterWalk_Toggle, TeleportTo
local FreeCam_Toggle, SpeedBoost_Toggle
local SpawnTP_Action, AntiFall_Toggle, ClickTP_Toggle
local JumpBoost_Toggle, Spider_Toggle, Sprint_Toggle
local Noclip_Toggle, LowGrav_Toggle, ZeroGrav_Toggle

local sg, main, sidebar, content, titleLabel, descLabel, bigBtn, ball
local navScroll, navList, timeLabel, timeCapsule, teleportPanel, teleportList
local coordsPanel, coordsLabel

local function GetTimeString()
    local t = os.date("*t")
    if CONFIG.TIME_24H then
        if CONFIG.TIME_SHOW_SECONDS then return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        else return string.format("%02d:%02d", t.hour, t.min) end
    else
        local h = t.hour % 12; if h == 0 then h = 12 end
        local ap = t.hour < 12 and "上午" or "下午"
        if CONFIG.TIME_SHOW_SECONDS then return string.format("%s %d:%02d:%02d", ap, h, t.min, t.sec)
        else return string.format("%s %d:%02d", ap, h, t.min) end
    end
end

local function GetBallDefaultPos()
    return UDim2.new(CONFIG.BALL_X, CONFIG.BALL_X_OFFSET, CONFIG.BALL_Y, CONFIG.BALL_Y_OFFSET)
end

local function ShowLoadingScreen()
    local loadSg = Instance.new("ScreenGui")
    loadSg.Name = "NexusLoading"; loadSg.ResetOnSpawn = false
    loadSg.DisplayOrder = 10000; loadSg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    loadSg.Parent = LP:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0); bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
    bg.BorderSizePixel = 0; bg.Parent = loadSg

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0,400,0,80); logo.Position = UDim2.new(0.5,-200,0.5,-80)
    logo.BackgroundTransparency = 1; logo.Text = "NEXUS"
    logo.Font = Enum.Font.GothamBold; logo.TextSize = 64
    logo.TextColor3 = CONFIG.THEME.ACCENT_GLOW; logo.TextTransparency = 1; logo.Parent = bg

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(0,400,0,20); sub.Position = UDim2.new(0.5,-200,0.5,10)
    sub.BackgroundTransparency = 1; sub.Text = "CORE HUB · INITIALIZING"
    sub.Font = Enum.Font.Gotham; sub.TextSize = 12
    sub.TextColor3 = CONFIG.THEME.TEXT_DIM; sub.TextTransparency = 1; sub.Parent = bg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0,300,0,3); barBg.Position = UDim2.new(0.5,-150,0.5,60)
    barBg.BackgroundColor3 = Color3.fromRGB(30,40,55); barBg.BorderSizePixel = 0
    barBg.BackgroundTransparency = 1; barBg.Parent = bg
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1,0); c.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0,0,1,0); barFill.BackgroundColor3 = CONFIG.THEME.ACCENT_GLOW
    barFill.BorderSizePixel = 0; barFill.Parent = barBg
    local c2 = Instance.new("UICorner"); c2.CornerRadius = UDim.new(1,0); c2.Parent = barFill

    local lt = Instance.new("TextLabel")
    lt.Size = UDim2.new(0,400,0,16); lt.Position = UDim2.new(0.5,-200,0.5,75)
    lt.BackgroundTransparency = 1; lt.Text = CONFIG.L.LOADING
    lt.Font = Enum.Font.Gotham; lt.TextSize = 11
    lt.TextColor3 = CONFIG.THEME.TEXT_DIM; lt.TextTransparency = 1; lt.Parent = bg

    TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
    TweenService:Create(sub, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(lt, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    TweenService:Create(barFill, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()

    task.delay(1.6, function()
        TweenService:Create(bg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(logo, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(sub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        TweenService:Create(barBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lt, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.45)
        if loadSg and loadSg.Parent then loadSg:Destroy() end
    end)
end

local function StartTimeUpdater()
    task.spawn(function()
        while running do
            if timeLabel then timeLabel.Text = GetTimeString() end
            task.wait(1)
        end
    end)
end

local function UI_Show()
    State.Visible = true
    if main then main.Visible = true end
    if ball then ball.Visible = false end
    if main then
        TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, CONFIG.UI_WIDTH, 0, CONFIG.UI_HEIGHT)}):Play()
    end
end

local function UI_Hide()
    State.Visible = false
    if main then
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Size = UDim2.new(0, CONFIG.UI_WIDTH, 0, 0)}):Play()
    end
    task.delay(0.2, function()
        if not State.Visible then
            if main then main.Visible = false end
            if ball then ball.Position = GetBallDefaultPos(); ball.Visible = true end
        end
    end)
end

local function UI_Toggle() if State.Visible then UI_Hide() else UI_Show() end end

local function SetupDrag()
    local drag = false; local sx, sy, px, py = 0,0,0,0
    local function clampP()
        local sw = Cam.ViewportSize.X; local sh = Cam.ViewportSize.Y
        local x = math.clamp(main.Position.X.Offset, 0, sw - CONFIG.UI_WIDTH)
        local y = math.clamp(main.Position.Y.Offset, 0, sh - CONFIG.UI_HEIGHT)
        main.Position = UDim2.new(0,x,0,y)
    end
    connections.dragBegan = UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
        if not State.Visible then return end
        local pos = i.Position
        local ap = main.AbsolutePosition; local as = main.AbsoluteSize
        if pos.X >= ap.X and pos.X <= ap.X+as.X and pos.Y >= ap.Y and pos.Y <= ap.Y+as.Y then
            local inTop = pos.Y <= ap.Y + 50
            local inSideTop = pos.X <= ap.X + CONFIG.SIDEBAR_W and pos.Y <= ap.Y + 90
            local inContent = pos.X > ap.X + CONFIG.SIDEBAR_W + 180 and pos.Y < ap.Y + as.Y - 120
            if inTop or inSideTop or inContent then
                drag = true; sx, sy = pos.X, pos.Y
                px, py = main.Position.X.Offset, main.Position.Y.Offset
            end
        end
    end)
    connections.dragEnded = UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)
    connections.dragChanged = UIS.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = i.Position
        main.Position = UDim2.new(0, px + (pos.X - sx), 0, py + (pos.Y - sy)); clampP()
    end)
    local bDrag, bsx, bsy, bpx, bpy = false, 0, 0, 0, 0
    connections.ballDragBegan = UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if not ball or not ball.Visible then return end
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = i.Position
        local ap = ball.AbsolutePosition; local as = ball.AbsoluteSize
        if pos.X >= ap.X and pos.X <= ap.X+as.X and pos.Y >= ap.Y and pos.Y <= ap.Y+as.Y then
            bDrag = true; bsx, bsy = pos.X, pos.Y
            bpx, bpy = ball.Position.X.Offset, ball.Position.Y.Offset
        end
    end)
    connections.ballDragEnded = UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then bDrag = false end
    end)
    connections.ballDragChanged = UIS.InputChanged:Connect(function(i)
        if not bDrag then return end
        if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
        local pos = i.Position
        local sw = Cam.ViewportSize.X; local sh = Cam.ViewportSize.Y
        local nx = math.clamp(bpx + (pos.X - bsx), 0, sw - 54)
        local ny = math.clamp(bpy + (pos.Y - bsy), 0, sh - 54)
        ball.Position = UDim2.new(0, nx, 0, ny)
    end)
end

-- =============== 21 项导航 ===============
local PAGES = {
    { key = "Fly",       icon = "✈", title = CONFIG.L.FLIGHT,      desc = "自由飞行 + 自动穿墙，WASD 移动，空格上升，左Shift下降" },
    { key = "Noclip",    icon = "⬜", title = CONFIG.L.NOCLIP,      desc = "独立穿墙模式，忽略所有碰撞（不飞行也能穿墙）" },
    { key = "Speed",     icon = "⚡", title = CONFIG.L.FLY_SPEED,  desc = "切换飞行速度档位" },
    { key = "SpeedBoost",icon = "»",  title = CONFIG.L.SPEEDBOOST, desc = "提高行走速度，循环切档（50/100/180/关）" },
    { key = "Sprint",    icon = "≡",  title = CONFIG.L.SPRINT,     desc = "按住左Shift冲刺，速度更快" },
    { key = "JumpBoost", icon = "⇧",  title = CONFIG.L.JUMP_BOOST, desc = "跳跃高度提升（默认 ×2）" },
    { key = "InfJump",   icon = "↑",  title = CONFIG.L.INF_JUMP,   desc = "空中可连续跳跃（长按空格起飞）" },
    { key = "FreeCam",   icon = "◐",  title = CONFIG.L.FREECAM,    desc = "相机脱开角色，WASD + 鼠标移动，空格上升" },
    { key = "Teleport",  icon = "➤",  title = CONFIG.L.TELEPORT,   desc = "点击玩家名传送到他身边" },
    { key = "ClickTP",   icon = "⌖",  title = CONFIG.L.CLICK_TP,   desc = "按 T 键传送到鼠标指向的地面" },
    { key = "SpawnTP",   icon = "⌂",  title = CONFIG.L.SPAWN_TP,   desc = "一键传回出生点（卡住时用）" },
    { key = "Coords",    icon = "◇",  title = CONFIG.L.COORDS,     desc = "显示自己实时坐标，可一键复制" },
    { key = "WaterWalk", icon = "≈",  title = CONFIG.L.WATER_WALK, desc = "水面像平地一样行走" },
    { key = "Spider",    icon = "❋",  title = CONFIG.L.SPIDER,     desc = "空中贴墙可悬停，像蜘蛛侠" },
    { key = "LowGrav",   icon = "☾",  title = CONFIG.L.LOW_GRAV,   desc = "重力调低，飘起来" },
    { key = "ZeroGrav",  icon = "✦",  title = CONFIG.L.ZERO_GRAV,  desc = "完全失重，漂浮" },
    { key = "AntiFall",  icon = "⤴",  title = CONFIG.L.ANTI_FALL,  desc = "掉出地图自动拉回" },
    { key = "ESP",       icon = "◉",  title = CONFIG.L.ESP,        desc = "透视其他玩家，显示名字和距离" },
    { key = "ESPV",      icon = "◎",  title = CONFIG.L.ESP_VISIBLE,desc = "只显示视野内的玩家" },
    { key = "Reset",     icon = "↻",  title = CONFIG.L.ALL_OFF,    desc = "关闭所有功能并恢复默认" },
    { key = "Shutdown",  icon = "✕",  title = CONFIG.L.SHUTDOWN,   desc = "彻底关闭脚本" },
}

local function GetPageIndex(key)
    for i, p in ipairs(PAGES) do if p.key == key then return i end end
    return nil
end

local function RefreshTeleportList()
    if not teleportList then return end
    for _, c in ipairs(teleportList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local myRoot = getRoot()
    local myPos = myRoot and myRoot.Position or V3_ZERO
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = math.floor((hrp.Position - myPos).Magnitude)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -8, 0, 34)
                btn.BackgroundColor3 = CONFIG.THEME.CARD_BG
                btn.Text = "  " .. plr.Name .. "    [" .. dist .. "m]"
                btn.Font = Enum.Font.GothamMedium; btn.TextSize = 13
                btn.TextColor3 = CONFIG.THEME.TEXT
                btn.TextXAlignment = Enum.TextXAlignment.Left
                btn.AutoButtonColor = false; btn.ZIndex = 5
                btn.Parent = teleportList
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = btn
                btn.MouseEnter:Connect(function() btn.BackgroundColor3 = CONFIG.THEME.CARD_HOVER end)
                btn.MouseLeave:Connect(function() btn.BackgroundColor3 = CONFIG.THEME.CARD_BG end)
                btn.Activated:Connect(function() PlayClick(); TeleportTo(plr) end)
            end
        end
    end
end

TeleportTo = function(plr)
    local myRoot = getRoot(); if not myRoot then return end
    local tc = plr.Character; if not tc then return end
    local tr = tc:FindFirstChild("HumanoidRootPart"); if not tr then return end
    local pos = tr.Position + tr.CFrame.LookVector * 3
    myRoot.CFrame = CFrame.new(pos, pos + tr.CFrame.LookVector)
end

local function SwitchPage(idx)
    State.Page = idx
    local page = PAGES[idx]; if not page then return end
    for i, item in ipairs(navItems) do
        if i == idx then
            item.BackgroundColor3 = CONFIG.THEME.SIDEBAR_ACTIVE; item.BackgroundTransparency = 0
            local ico = item:FindFirstChild("Icon"); local lbl = item:FindFirstChild("Text")
            if ico then ico.TextColor3 = CONFIG.THEME.ACCENT_GLOW end
            if lbl then lbl.TextColor3 = CONFIG.THEME.TEXT end
        else
            item.BackgroundColor3 = Color3.fromRGB(0,0,0); item.BackgroundTransparency = 1
            local ico = item:FindFirstChild("Icon"); local lbl = item:FindFirstChild("Text")
            if ico then ico.TextColor3 = CONFIG.THEME.TEXT_DIM end
            if lbl then lbl.TextColor3 = CONFIG.THEME.TEXT_DIM end
        end
    end
    if titleLabel then titleLabel.Text = page.title end
    if descLabel then descLabel.Text = page.desc end

    if teleportPanel and teleportList then
        if page.key == "Teleport" then
            teleportPanel.Visible = true
            if coordsPanel then coordsPanel.Visible = false end
            if bigBtn then bigBtn.Visible = false end
            RefreshTeleportList()
        elseif page.key == "Coords" then
            teleportPanel.Visible = false
            if coordsPanel then coordsPanel.Visible = true end
            if bigBtn then bigBtn.Visible = false end
        else
            teleportPanel.Visible = false
            if coordsPanel then coordsPanel.Visible = false end
            if bigBtn then bigBtn.Visible = true end
        end
    end

    if bigBtn then
        local isOn, btnText = false, ""
        local k = page.key
        if k == "Fly" then isOn = State.Fly; btnText = State.Fly and "关闭飞行" or "开启飞行"
        elseif k == "Noclip" then isOn = State.Noclip; btnText = State.Noclip and "关闭穿墙" or "开启穿墙"
        elseif k == "Speed" then isOn = true; btnText = "切换速度 → " .. CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier] .. " 单位/秒"
        elseif k == "SpeedBoost" then isOn = State.SpeedBoost > 0
            btnText = State.SpeedBoost == 0 and "开启速度增强" or ("当前：" .. ({50,100,180})[State.SpeedBoost] .. "  点击切档")
        elseif k == "Sprint" then isOn = State.Sprint; btnText = State.Sprint and "关闭极速冲刺" or "开启极速冲刺"
        elseif k == "JumpBoost" then isOn = State.JumpBoost; btnText = State.JumpBoost and "关闭跳跃增强" or "开启跳跃增强"
        elseif k == "InfJump" then isOn = State.InfJump; btnText = State.InfJump and "关闭无限跳" or "开启无限跳"
        elseif k == "FreeCam" then isOn = State.FreeCam; btnText = State.FreeCam and "关闭自由视角" or "开启自由视角"
        elseif k == "ClickTP" then isOn = State.ClickTP; btnText = State.ClickTP and "关闭点击传送" or "开启点击传送"
        elseif k == "SpawnTP" then isOn = false; btnText = "传回出生点"
        elseif k == "WaterWalk" then isOn = State.WaterWalk; btnText = State.WaterWalk and "关闭水上行走" or "开启水上行走"
        elseif k == "Spider" then isOn = State.Spider; btnText = State.Spider and "关闭蜘蛛侠" or "开启蜘蛛侠"
        elseif k == "LowGrav" then isOn = State.LowGrav; btnText = State.LowGrav and "关闭低重力" or "开启低重力"
        elseif k == "ZeroGrav" then isOn = State.ZeroGrav; btnText = State.ZeroGrav and "关闭零重力" or "开启零重力"
        elseif k == "AntiFall" then isOn = State.AntiFall; btnText = State.AntiFall and "关闭反掉落" or "开启反掉落"
        elseif k == "ESP" then isOn = State.ESP; btnText = State.ESP and "关闭透视" or "开启透视"
        elseif k == "ESPV" then isOn = State.ESPVisibleOnly; btnText = State.ESPVisibleOnly and "关闭仅可见" or "开启仅可见"
        elseif k == "Reset" then isOn = false; btnText = "执行重置"
        elseif k == "Shutdown" then isOn = false; btnText = "确认关闭脚本"
        end
        bigBtn.Text = btnText
        bigBtn.BackgroundColor3 = isOn and CONFIG.THEME.CARD_ON or CONFIG.THEME.CARD_BG
    end
end

local function OnBigBtnClick()
    local page = PAGES[State.Page]; if not page then return end
    PlayClick()
    local k = page.key
    if k == "Fly" then Flight_Toggle()
    elseif k == "Noclip" then Noclip_Toggle()
    elseif k == "Speed" then State.FlySpeedTier = (State.FlySpeedTier % #CONFIG.FLY_SPEED_TIERS) + 1
    elseif k == "SpeedBoost" then SpeedBoost_Toggle()
    elseif k == "Sprint" then Sprint_Toggle()
    elseif k == "JumpBoost" then JumpBoost_Toggle()
    elseif k == "InfJump" then InfJump_Toggle()
    elseif k == "FreeCam" then FreeCam_Toggle()
    elseif k == "ClickTP" then ClickTP_Toggle()
    elseif k == "SpawnTP" then SpawnTP_Action()
    elseif k == "WaterWalk" then WaterWalk_Toggle()
    elseif k == "Spider" then Spider_Toggle()
    elseif k == "LowGrav" then LowGrav_Toggle()
    elseif k == "ZeroGrav" then ZeroGrav_Toggle()
    elseif k == "AntiFall" then AntiFall_Toggle()
    elseif k == "ESP" then ESP_Toggle()
    elseif k == "ESPV" then ESP_ToggleVisible()
    elseif k == "Reset" then Master_AllOff()
    elseif k == "Shutdown" then Master_Shutdown()
    end
    SwitchPage(State.Page)
end

-- =============== UI 构建 ===============
local function UI_Init()
    local ok, err = pcall(function()
        sg = Instance.new("ScreenGui")
        sg.Name = "NexusHub"; sg.ResetOnSpawn = false
        sg.DisplayOrder = 999; sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.Parent = LP:WaitForChild("PlayerGui")

        main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(0, CONFIG.UI_WIDTH, 0, CONFIG.UI_HEIGHT)
        main.Position = UDim2.new(0.5, -CONFIG.UI_WIDTH/2, 0.5, -CONFIG.UI_HEIGHT/2)
        main.BackgroundColor3 = Color3.fromRGB(6,8,14)
        main.BorderSizePixel = 0; main.ClipsDescendants = true; main.Active = true
        main.Parent = sg
        local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, CONFIG.THEME.CORNER+4); mc.Parent = main

        local bg = Instance.new("ImageLabel")
        bg.Name = "Background"; bg.Size = UDim2.new(1,0,1,0)
        bg.Image = CONFIG.BG_IMAGE; bg.ImageTransparency = CONFIG.BG_TRANSPARENCY
        bg.BackgroundTransparency = 1; bg.ScaleType = Enum.ScaleType.Crop
        bg.ZIndex = 1; bg.Parent = main
        local bgc = Instance.new("UICorner"); bgc.CornerRadius = UDim.new(0, CONFIG.THEME.CORNER+4); bgc.Parent = bg

        local overlay = Instance.new("Frame")
        overlay.Name = "Overlay"; overlay.Size = UDim2.new(1,0,1,0)
        overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency = CONFIG.THEME.OVERLAY_TRANSPARENCY
        overlay.BorderSizePixel = 0; overlay.ZIndex = 2; overlay.Parent = main
        local oc = Instance.new("UICorner"); oc.CornerRadius = UDim.new(0, CONFIG.THEME.CORNER+4); oc.Parent = overlay

        local tg = Instance.new("Frame")
        tg.Size = UDim2.new(1,0,0,2); tg.BackgroundColor3 = CONFIG.THEME.ACCENT_GLOW
        tg.BorderSizePixel = 0; tg.ZIndex = 10; tg.Parent = main

        -- 时间胶囊
        timeCapsule = Instance.new("Frame")
        timeCapsule.Size = UDim2.new(0,160,0,30); timeCapsule.Position = UDim2.new(0.5,-80,0,12)
        timeCapsule.BackgroundColor3 = Color3.fromRGB(0,0,0); timeCapsule.BackgroundTransparency = 0.15
        timeCapsule.BorderSizePixel = 0; timeCapsule.ZIndex = 20; timeCapsule.Parent = main
        local tcc = Instance.new("UICorner"); tcc.CornerRadius = UDim.new(1,0); tcc.Parent = timeCapsule
        local tcs = Instance.new("UIStroke"); tcs.Color = CONFIG.THEME.ACCENT_GLOW; tcs.Thickness = 1; tcs.Transparency = 0.5; tcs.Parent = timeCapsule

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0,6,0,6); dot.Position = UDim2.new(0,12,0.5,-3)
        dot.BackgroundColor3 = CONFIG.THEME.GREEN; dot.BorderSizePixel = 0; dot.ZIndex = 21; dot.Parent = timeCapsule
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1,0); dc.Parent = dot

        timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(1,-30,1,0); timeLabel.Position = UDim2.new(0,24,0,0)
        timeLabel.BackgroundTransparency = 1; timeLabel.Text = GetTimeString()
        timeLabel.Font = Enum.Font.GothamBold; timeLabel.TextSize = 14
        timeLabel.TextColor3 = CONFIG.THEME.ACCENT_GLOW; timeLabel.TextXAlignment = Enum.TextXAlignment.Center
        timeLabel.ZIndex = 21; timeLabel.Parent = timeCapsule

        -- 侧边栏
        sidebar = Instance.new("Frame")
        sidebar.Name = "Sidebar"; sidebar.Size = UDim2.new(0, CONFIG.SIDEBAR_W, 1, 0)
        sidebar.BackgroundColor3 = CONFIG.THEME.SIDEBAR_BG; sidebar.BackgroundTransparency = 0.15
        sidebar.BorderSizePixel = 0; sidebar.ZIndex = 3; sidebar.Parent = main

        local brand = Instance.new("TextLabel")
        brand.Size = UDim2.new(1,0,0,32); brand.Position = UDim2.new(0,16,0,14)
        brand.BackgroundTransparency = 1; brand.Text = CONFIG.L.BRAND
        brand.Font = Enum.Font.GothamBold; brand.TextSize = 22
        brand.TextColor3 = CONFIG.THEME.ACCENT_GLOW; brand.TextXAlignment = Enum.TextXAlignment.Left
        brand.ZIndex = 4; brand.Parent = sidebar

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1,0,0,14); sub.Position = UDim2.new(0,16,0,46)
        sub.BackgroundTransparency = 1; sub.Text = CONFIG.L.SUBTITLE
        sub.Font = Enum.Font.Gotham; sub.TextSize = 10
        sub.TextColor3 = CONFIG.THEME.TEXT_DIM; sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.ZIndex = 4; sub.Parent = sidebar

        -- ★ 滚动容器
        navScroll = Instance.new("ScrollingFrame")
        navScroll.Name = "NavScroll"
        navScroll.Size = UDim2.new(1, -8, 1, -80)
        navScroll.Position = UDim2.new(0, 4, 0, 70)
        navScroll.BackgroundTransparency = 1
        navScroll.BorderSizePixel = 0
        navScroll.ScrollBarThickness = 3
        navScroll.ScrollBarImageColor3 = CONFIG.THEME.ACCENT_GLOW
        navScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        navScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        navScroll.ScrollingDirection = Enum.ScrollingDirection.Y
        navScroll.ZIndex = 4
        navScroll.Parent = sidebar

        navList = Instance.new("Frame")
        navList.Name = "NavList"
        navList.Size = UDim2.new(1, 0, 0, 0)
        navList.BackgroundTransparency = 1
        navList.AutomaticSize = Enum.AutomaticSize.Y
        navList.ZIndex = 4
        navList.Parent = navScroll

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 2)
        layout.Parent = navList

        for i, page in ipairs(PAGES) do
            local item = Instance.new("TextButton")
            item.Name = "Nav" .. i
            item.Size = UDim2.new(1, -6, 0, 34)
            item.BackgroundColor3 = Color3.fromRGB(0,0,0)
            item.BackgroundTransparency = 1
            item.AutoButtonColor = false; item.Text = ""
            item.LayoutOrder = i; item.ZIndex = 5
            item.Parent = navList
            local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,8); ic.Parent = item

            local ico = Instance.new("TextLabel")
            ico.Name = "Icon"; ico.Size = UDim2.new(0,24,1,0)
            ico.Position = UDim2.new(0,10,0,0); ico.BackgroundTransparency = 1
            ico.Text = page.icon; ico.Font = Enum.Font.GothamBold
            ico.TextSize = 15; ico.TextColor3 = CONFIG.THEME.TEXT_DIM
            ico.TextXAlignment = Enum.TextXAlignment.Center; ico.ZIndex = 6
            ico.Parent = item

            local lbl = Instance.new("TextLabel")
            lbl.Name = "Text"; lbl.Size = UDim2.new(1, -40, 1, 0)
            lbl.Position = UDim2.new(0, 36, 0, 0); lbl.BackgroundTransparency = 1
            lbl.Text = page.title; lbl.Font = Enum.Font.GothamMedium
            lbl.TextSize = 12; lbl.TextColor3 = CONFIG.THEME.TEXT_DIM
            lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 6
            lbl.Parent = item

            item.MouseEnter:Connect(function()
                if State.Page ~= i then
                    item.BackgroundColor3 = CONFIG.THEME.CARD_HOVER
                    item.BackgroundTransparency = 0.3
                end
            end)
            item.MouseLeave:Connect(function()
                if State.Page ~= i then
                    item.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    item.BackgroundTransparency = 1
                end
            end)
            item.Activated:Connect(function() PlayClick(); SwitchPage(i) end)
            navItems[i] = item
        end

        -- 内容区
        content = Instance.new("Frame")
        content.Name = "Content"
        content.Size = UDim2.new(1, -CONFIG.SIDEBAR_W, 1, 0)
        content.Position = UDim2.new(0, CONFIG.SIDEBAR_W, 0, 0)
        content.BackgroundTransparency = 1; content.ZIndex = 3
        content.Parent = main

        titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -60, 0, 36)
        titleLabel.Position = UDim2.new(0, 30, 0, 60)
        titleLabel.BackgroundTransparency = 1; titleLabel.Text = CONFIG.L.FLIGHT
        titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextSize = 26
        titleLabel.TextColor3 = CONFIG.THEME.TEXT; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 4; titleLabel.Parent = content

        descLabel = Instance.new("TextLabel")
        descLabel.Name = "Desc"
        descLabel.Size = UDim2.new(1, -60, 0, 40)
        descLabel.Position = UDim2.new(0, 30, 0, 102)
        descLabel.BackgroundTransparency = 1; descLabel.Text = ""
        descLabel.Font = Enum.Font.Gotham; descLabel.TextSize = 12
        descLabel.TextColor3 = CONFIG.THEME.TEXT_DIM
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        descLabel.TextWrapped = true; descLabel.ZIndex = 4
        descLabel.Parent = content

        bigBtn = Instance.new("TextButton")
        bigBtn.Name = "BigBtn"
        bigBtn.Size = UDim2.new(1, -60, 0, 60)
        bigBtn.Position = UDim2.new(0, 30, 1, -100)
        bigBtn.BackgroundColor3 = CONFIG.THEME.CARD_BG
        bigBtn.Text = "开启飞行"; bigBtn.Font = Enum.Font.GothamBold
        bigBtn.TextSize = 17; bigBtn.TextColor3 = CONFIG.THEME.TEXT
        bigBtn.AutoButtonColor = false; bigBtn.ZIndex = 4; bigBtn.Parent = content
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,14); bc.Parent = bigBtn
        bigBtn.MouseEnter:Connect(function() bigBtn.BackgroundColor3 = CONFIG.THEME.CARD_HOVER end)
        bigBtn.MouseLeave:Connect(function() SwitchPage(State.Page) end)
        bigBtn.Activated:Connect(function() safe("bigBtn", OnBigBtnClick) end)

        -- 传送面板
        teleportPanel = Instance.new("Frame")
        teleportPanel.Name = "TeleportPanel"
        teleportPanel.Size = UDim2.new(1, -60, 0, 260)
        teleportPanel.Position = UDim2.new(0, 30, 0, 150)
        teleportPanel.BackgroundTransparency = 1
        teleportPanel.ZIndex = 4; teleportPanel.Visible = false
        teleportPanel.Parent = content
        teleportList = Instance.new("ScrollingFrame")
        teleportList.Size = UDim2.new(1, 0, 1, 0)
        teleportList.BackgroundTransparency = 1; teleportList.BorderSizePixel = 0
        teleportList.ScrollBarThickness = 4
        teleportList.ScrollBarImageColor3 = CONFIG.THEME.ACCENT_GLOW
        teleportList.CanvasSize = UDim2.new(0,0,0,0)
        teleportList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        teleportList.ZIndex = 5; teleportList.Parent = teleportPanel
        local tl = Instance.new("UIListLayout")
        tl.SortOrder = Enum.SortOrder.LayoutOrder; tl.Padding = UDim.new(0,4); tl.Parent = teleportList

        -- 坐标面板
        coordsPanel = Instance.new("Frame")
        coordsPanel.Name = "CoordsPanel"
        coordsPanel.Size = UDim2.new(1, -60, 0, 140)
        coordsPanel.Position = UDim2.new(0, 30, 0, 150)
        coordsPanel.BackgroundColor3 = CONFIG.THEME.CARD_BG
        coordsPanel.BackgroundTransparency = 0.1
        coordsPanel.BorderSizePixel = 0; coordsPanel.ZIndex = 4
        coordsPanel.Visible = false; coordsPanel.Parent = content
        local cpc = Instance.new("UICorner"); cpc.CornerRadius = UDim.new(0,12); cpc.Parent = coordsPanel

        coordsLabel = Instance.new("TextLabel")
        coordsLabel.Size = UDim2.new(1, -40, 1, -60)
        coordsLabel.Position = UDim2.new(0, 20, 0, 10)
        coordsLabel.BackgroundTransparency = 1
        coordsLabel.Text = "X: 0\nY: 0\nZ: 0"
        coordsLabel.Font = Enum.Font.Code; coordsLabel.TextSize = 15
        coordsLabel.TextColor3 = CONFIG.THEME.ACCENT_GLOW
        coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
        coordsLabel.TextYAlignment = Enum.TextYAlignment.Top
        coordsLabel.ZIndex = 5; coordsLabel.Parent = coordsPanel

        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(1, -40, 0, 34)
        copyBtn.Position = UDim2.new(0, 20, 1, -44)
        copyBtn.BackgroundColor3 = CONFIG.THEME.CARD_ON
        copyBtn.Text = "复制坐标"; copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = 14; copyBtn.TextColor3 = CONFIG.THEME.TEXT
        copyBtn.AutoButtonColor = false; copyBtn.ZIndex = 5
        copyBtn.Parent = coordsPanel
        local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0,10); cbc.Parent = copyBtn
        copyBtn.Activated:Connect(function()
            PlayClick()
            local root = getRoot(); if not root then return end
            local p = root.Position
            local str = string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)
            local ok = pcall(function()
                if setclipboard then setclipboard(str)
                elseif toclipboard then toclipboard(str) end
            end)
            if ok then
                copyBtn.Text = "已复制！ " .. str
                task.delay(1.5, function() if copyBtn then copyBtn.Text = "复制坐标" end end)
            else
                copyBtn.Text = "复制失败（执行器不支持）"
                task.delay(1.5, function() if copyBtn then copyBtn.Text = "复制坐标" end end)
            end
        end)

        -- 悬浮球
        ball = Instance.new("TextButton")
        ball.Name = "Ball"; ball.Size = UDim2.new(0,54,0,54)
        ball.Position = GetBallDefaultPos(); ball.Text = "N"
        ball.Font = Enum.Font.GothamBold; ball.TextSize = 24
        ball.BackgroundColor3 = CONFIG.THEME.CARD_ON
        ball.TextColor3 = Color3.fromRGB(255,255,255)
        ball.BorderSizePixel = 0; ball.Visible = false; ball.ZIndex = 1000
        ball.Parent = sg
        local ballc = Instance.new("UICorner"); ballc.CornerRadius = UDim.new(1,0); ballc.Parent = ball
        ball.Activated:Connect(function() safe("ball", UI_Show) end)

        -- 关闭按钮
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0,30,0,30)
        closeBtn.Position = UDim2.new(1,-42,0,14)
        closeBtn.Text = "✕"; closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 14; closeBtn.BackgroundColor3 = CONFIG.THEME.CARD_ON
        closeBtn.TextColor3 = CONFIG.THEME.TEXT; closeBtn.BorderSizePixel = 0
        closeBtn.ZIndex = 20; closeBtn.Parent = main
        local cbc2 = Instance.new("UICorner"); cbc2.CornerRadius = UDim.new(1,0); cbc2.Parent = closeBtn
        closeBtn.Activated:Connect(function() safe("close", UI_Hide) end)

        connections.hotkeys = UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == CONFIG.TOGGLE_KEY then UI_Toggle()
            elseif i.KeyCode == CONFIG.RECALL_KEY then UI_Show() end
        end)

        SetupDrag()
        SwitchPage(1)

        -- 传送列表刷新
        task.spawn(function()
            while running do
                task.wait(1)
                if State.Page == GetPageIndex("Teleport") and teleportPanel and teleportPanel.Visible then
                    RefreshTeleportList()
                end
            end
        end)

        -- 坐标刷新
        task.spawn(function()
            while running do
                task.wait(0.2)
                if State.Page == GetPageIndex("Coords") and coordsLabel then
                    local root = getRoot()
                    if root then
                        local p = root.Position
                        coordsLabel.Text = string.format("X: %.1f\nY: %.1f\nZ: %.1f", p.X, p.Y, p.Z)
                    end
                end
            end
        end)
    end)
    if not ok then warn("[NEXUS:UI_Init]", err) end
    return ok
end

-- =============== 穿墙 ===============
local function Noclip_GetParts()
    local char = LP.Character; if not char then return {} end
    local parts = {}
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local skip = false
            local par = p.Parent
            while par and par ~= char do
                if par:IsA("Tool") or par:IsA("BackpackItem") then skip = true; break end
                par = par.Parent
            end
            if not skip then table.insert(parts, p) end
        end
    end
    return parts
end
local function Noclip_Restore()
    for _, p in pairs(noclipParts) do
        if p and p.Parent and p:GetAttribute("NX_Noclip") then
            local orig = p:GetAttribute("NX_OrigCollide")
            p.CanCollide = orig ~= nil and orig or true
            p:SetAttribute("NX_Noclip", nil); p:SetAttribute("NX_OrigCollide", nil)
        end
    end
    noclipParts = {}
end
local function Noclip_Enable() noclipParts = Noclip_GetParts(); State.Noclip = true end
local function Noclip_Disable() Noclip_Restore(); State.Noclip = false end

local function Noclip_Init()
    connections.charAdded = LP.CharacterAdded:Connect(function()
        if State.Noclip then noclipParts = Noclip_GetParts() end
    end)
    connections.stepped = RunService.Stepped:Connect(function()
        if not State.Noclip then return end
        for _, p in pairs(noclipParts) do
            if p and p.Parent and p.CanCollide then
                if p:GetAttribute("NX_OrigCollide") == nil then
                    p:SetAttribute("NX_OrigCollide", p.CanCollide)
                end
                p.CanCollide = false; p:SetAttribute("NX_Noclip", true)
            end
        end
    end)
end

-- =============== 飞行 ===============
Flight_Toggle = function()
    State.Fly = not State.Fly
    local hum = getHum(); local root = getRoot()
    if hum and root then
        if State.Fly then
            hum.PlatformStand = true
            Noclip_Enable()
            root.CFrame = root.CFrame + Vector3.new(0, CONFIG.FLY_LIFT_OFFSET, 0)
        else
            hum.PlatformStand = false
            root.AssemblyLinearVelocity = V3_ZERO
            Noclip_Disable()
        end
    end
end

local function Flight_Init()
    connections.render = RunService.RenderStepped:Connect(function(dt)
        if not State.Fly then return end
        local root = getRoot(); if not root then return end
        local cam = workspace.CurrentCamera
        local speed = CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier] or 200
        local lift = CONFIG.LIFT_SPEED
        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            local horiz = Vector3.new(move.X, 0, move.Z)
            local vert = move.Y
            local vel = Vector3.new()
            if horiz.Magnitude > 0 then vel = vel + horiz.Unit * speed end
            if vert ~= 0 then vel = vel + Vector3.new(0, vert * lift, 0) end
            root.AssemblyLinearVelocity = vel
        else
            root.AssemblyLinearVelocity = V3_ZERO
        end
    end)
end

-- =============== 独立穿墙 ===============
Noclip_Toggle = function()
    if State.Noclip then Noclip_Disable() else Noclip_Enable() end
end

-- =============== 无限跳 ===============
InfJump_Toggle = function() State.InfJump = not State.InfJump end
local function InfJump_Init()
    connections.infJump = UIS.JumpRequest:Connect(function()
        if not State.InfJump then return end
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

-- =============== 水上行走 ===============
WaterWalk_Toggle = function() State.WaterWalk = not State.WaterWalk end
local function WaterWalk_Init()
    local counter = 0
    connections.waterWalk = RunService.Stepped:Connect(function()
        if not State.WaterWalk then return end
        counter = counter + 1
        if counter % 3 ~= 0 then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local minV = hrp.Position - Vector3.new(3,5,3)
        local maxV = hrp.Position + Vector3.new(3,0,3)
        local region = Region3.new(minV, maxV):ExpandToGrid(4)
        local ok, mats = pcall(function() return workspace.Terrain:ReadVoxels(region, 4) end)
        if not ok or not mats then return end
        local hasWater = false
        for x = 1, mats.Size.X do
            for y = 1, mats.Size.Y do
                for z = 1, mats.Size.Z do
                    if mats[x][y][z] == Enum.Material.Water then hasWater = true; break end
                end
                if hasWater then break end
            end
            if hasWater then break end
        end
        if hasWater then
            local vel = hrp.AssemblyLinearVelocity
            if vel.Y < 0 then hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z) end
        end
    end)
end

-- =============== 自由视角 ===============
FreeCam_Toggle = function()
    State.FreeCam = not State.FreeCam
    local cam = workspace.CurrentCamera
    if State.FreeCam then
        FreeCamData.OrigType = cam.CameraType
        FreeCamData.OrigSubj = cam.CameraSubject
        FreeCamData.Pos = cam.CFrame.Position
        local look = cam.CFrame.LookVector
        FreeCamData.Yaw = math.atan2(-look.X, -look.Z)
        FreeCamData.Pitch = math.asin(math.clamp(look.Y, -1, 1))
        cam.CameraType = Enum.CameraType.Scriptable
        UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        cam.CameraType = FreeCamData.OrigType or Enum.CameraType.Custom
        if FreeCamData.OrigSubj then cam.CameraSubject = FreeCamData.OrigSubj end
        UIS.MouseBehavior = Enum.MouseBehavior.Default
    end
end
local function FreeCam_Init()
    connections.freeCamRender = RunService.RenderStepped:Connect(function(dt)
        if not State.FreeCam then return end
        local cam = workspace.CurrentCamera
        local rot = CFrame.fromEulerAnglesYXZ(FreeCamData.Pitch, FreeCamData.Yaw, 0)
        local move = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then FreeCamData.Pos = FreeCamData.Pos + move.Unit * 100 * dt end
        cam.CFrame = CFrame.new(FreeCamData.Pos) * rot
    end)
    connections.freeCamMouse = UIS.InputChanged:Connect(function(input)
        if not State.FreeCam then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            FreeCamData.Yaw = FreeCamData.Yaw - input.Delta.X * 0.005
            FreeCamData.Pitch = math.clamp(FreeCamData.Pitch - input.Delta.Y * 0.005, -1.5, 1.5)
        end
    end)
end

-- =============== 速度增强 ===============
local SpeedBoostTiers = {50, 100, 180}
SpeedBoost_Toggle = function()
    State.SpeedBoost = (State.SpeedBoost + 1) % (#SpeedBoostTiers + 1)
    local hum = getHum()
    if hum then
        if State.SpeedBoost == 0 then hum.WalkSpeed = 16
        else hum.WalkSpeed = SpeedBoostTiers[State.SpeedBoost] end
    end
end
local function SpeedBoost_Init()
    connections.spdCharAdded = LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and State.SpeedBoost > 0 then hum.WalkSpeed = SpeedBoostTiers[State.SpeedBoost] end
    end)
end

-- =============== 极速冲刺 ===============
Sprint_Toggle = function() State.Sprint = not State.Sprint end
local function Sprint_Init()
    connections.sprint = RunService.Heartbeat:Connect(function()
        if not State.Sprint then return end
        local hum = getHum(); if not hum then return end
        local current = hum.WalkSpeed
        -- 只在按住 Shift 时生效
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            if current < CONFIG.SPRINT_SPEED and current > 0 then
                hum.WalkSpeed = CONFIG.SPRINT_SPEED
            end
        else
            -- 松开 Shift 恢复默认
            if current == CONFIG.SPRINT_SPEED then
                if State.SpeedBoost > 0 then hum.WalkSpeed = SpeedBoostTiers[State.SpeedBoost]
                else hum.WalkSpeed = 16 end
            end
        end
    end)
end

-- =============== 跳跃增强 ===============
JumpBoost_Toggle = function()
    State.JumpBoost = not State.JumpBoost
    local hum = getHum()
    if hum then
        if State.JumpBoost then hum.JumpPower = CONFIG.JUMP_POWER; hum.UseJumpPower = true
        else hum.JumpPower = 50; hum.UseJumpPower = false end
    end
end
local function JumpBoost_Init()
    connections.jmpCharAdded = LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and State.JumpBoost then hum.JumpPower = CONFIG.JUMP_POWER; hum.UseJumpPower = true end
    end)
end

-- =============== 蜘蛛侠（贴墙悬停）===============
Spider_Toggle = function() State.Spider = not State.Spider end
local function Spider_Init()
    local counter = 0
    connections.spider = RunService.Heartbeat:Connect(function()
        if not State.Spider then return end
        counter = counter + 1
        if counter % 4 ~= 0 then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        -- 检查四周是否有墙
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        local dirs = {
            hrp.CFrame.LookVector,
            -hrp.CFrame.LookVector,
            hrp.CFrame.RightVector,
            -hrp.CFrame.RightVector,
        }
        for _, d in ipairs(dirs) do
            local hit = workspace:Raycast(hrp.Position, d * 3, params)
            if hit then
                hum.PlatformStand = false
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                break
            end
        end
    end)
end

-- =============== 低重力 ===============
LowGrav_Toggle = function()
    State.LowGrav = not State.LowGrav
    if State.LowGrav then
        State.ZeroGrav = false
        workspace.Gravity = CONFIG.LOW_GRAV
    else
        workspace.Gravity = 196.2
    end
end

-- =============== 零重力 ===============
ZeroGrav_Toggle = function()
    State.ZeroGrav = not State.ZeroGrav
    if State.ZeroGrav then
        State.LowGrav = false
        workspace.Gravity = 0
    else
        workspace.Gravity = 196.2
    end
end

-- =============== 反掉落 ===============
AntiFall_Toggle = function() State.AntiFall = not State.AntiFall end
local function AntiFall_Init()
    connections.antiFall = RunService.Heartbeat:Connect(function()
        if not State.AntiFall then return end
        local root = getRoot(); if not root then return end
        if root.Position.Y < -100 then
            -- 传回出生点
            local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
            if spawn then
                root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            else
                root.CFrame = CFrame.new(0, 100, 0)
            end
        end
    end)
end

-- =============== 点击传送 ===============
ClickTP_Toggle = function() State.ClickTP = not State.ClickTP end
local function ClickTP_Init()
    connections.clickTP = UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if not State.ClickTP then return end
        if input.KeyCode ~= CONFIG.CLICK_TP_KEY then return end
        local mouse = LP:GetMouse()
        local hit = mouse.Hit
        if hit then
            local root = getRoot()
            if root then
                root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end)
end

-- =============== 回出生点 ===============
SpawnTP_Action = function()
    local root = getRoot(); if not root then return end
    local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then
        root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
    else
        root.CFrame = CFrame.new(0, 100, 0)
    end
end

-- =============== ESP ===============
local function ESP_Clear()
    for bill,_ in pairs(ESPHolders) do if bill and bill.Parent then bill:Destroy() end end
    ESPHolders = {}
end

local function ESP_Create(plr, char)
    local head = char:FindFirstChild("Head"); if not head then return end
    local isTeam = plr.Team and plr.Team == LP.Team
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_NEXUS"; bill.Size = UDim2.new(0,120,0,60)
    bill.StudsOffset = Vector3.new(0,3,0); bill.AlwaysOnTop = true
    bill.Adornee = head; bill.Parent = head

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Name = "ESP_Name"; nameLbl.Size = UDim2.new(1,0,0.4,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.Text = plr.Name
    nameLbl.TextColor3 = isTeam and CONFIG.THEME.GREEN or CONFIG.THEME.ACCENT_GLOW
    nameLbl.TextStrokeTransparency = 0; nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 14; nameLbl.Parent = bill

    local distLbl = Instance.new("TextLabel")
    distLbl.Name = "ESP_Dist"; distLbl.Size = UDim2.new(1,0,0.3,0)
    distLbl.Position = UDim2.new(0,0,0.4,0); distLbl.BackgroundTransparency = 1
    distLbl.Text = "0m"; distLbl.TextColor3 = Color3.fromRGB(255,255,255)
    distLbl.Font = Enum.Font.Gotham; distLbl.TextSize = 12; distLbl.Parent = bill
    ESPHolders[bill] = true
end

local function ESP_IsVisible(head)
    if not State.ESPVisibleOnly then return true end
    local char = getChar(); if not char then return true end
    local delta = head.Position - Cam.CFrame.Position
    local dist = delta.Magnitude
    if dist < 0.1 then return true end
    local dir = delta / dist
    return not raycastBlocked(Cam.CFrame.Position, Cam.CFrame.Position + dir*300, {char, head.Parent})
end

ESP_Toggle = function()
    State.ESP = not State.ESP
    if not State.ESP then ESP_Clear() end
end
ESP_ToggleVisible = function()
    State.ESPVisibleOnly = not State.ESPVisibleOnly
    if State.ESP then ESP_Clear() end
end

local function ESP_Init()
    local function hook(plr)
        if plr == LP then return end
        plr.CharacterAdded:Connect(function(char)
            if not State.ESP then return end
            task.wait(0.1)
            if State.ESP and char.Parent then ESP_Create(plr, char) end
        end)
    end
    for _, p in pairs(Players:GetPlayers()) do hook(p) end
    connections.playerAdded = Players.PlayerAdded:Connect(hook)
    connections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local bill = head:FindFirstChild("ESP_NEXUS")
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
                        for _, b in ipairs(toRemove) do ESPHolders[b] = nil end
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LP and p.Character then
                                local char = p.Character
                                local head = char:FindFirstChild("Head")
                                local hroot = char:FindFirstChild("HumanoidRootPart")
                                if head and hroot then
                                    local dist = (hroot.Position - mp).Magnitude
                                    if dist <= CONFIG.ESP_RANGE and ESP_IsVisible(head) then
                                        local bill = head:FindFirstChild("ESP_NEXUS")
                                        if not bill then ESP_Create(p, char)
                                        else
                                            local d = bill:FindFirstChild("ESP_Dist")
                                            if d then d.Text = math.floor(dist).."m" end
                                        end
                                    else
                                        local bill = head:FindFirstChild("ESP_NEXUS")
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

-- =============== 头顶标签 ===============
local function AttachHeadTag()
    if not CONFIG.HEAD_TAG_ENABLED then return end
    local char = LP.Character; if not char then return end
    local head = char:FindFirstChild("Head")
    if not head or head:FindFirstChild("NEXUS_Tag") then return end
    local bill = Instance.new("BillboardGui")
    bill.Name = "NEXUS_Tag"; bill.Size = UDim2.new(0, 220, 0, 30)
    bill.StudsOffset = Vector3.new(0,3,0); bill.AlwaysOnTop = true
    bill.Adornee = head; bill.Parent = head
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
    lbl.Text = CONFIG.HEAD_TAG_TEXT; lbl.TextColor3 = CONFIG.HEAD_TAG_COLOR
    lbl.TextStrokeTransparency = 0.2; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 18; lbl.Parent = bill
end
local function StartHeadTag()
    if not CONFIG.HEAD_TAG_ENABLED then return end
    AttachHeadTag()
    connections.headTag = LP.CharacterAdded:Connect(function()
        task.wait(1); AttachHeadTag()
    end)
end

-- =============== MASTER ===============
Master_AllOff = function()
    State.Fly = false; State.Noclip = false; State.ESP = false
    State.FlySpeedTier = 2; State.ESPVisibleOnly = CONFIG.ESP_VISIBLE_ONLY_DEFAULT
    State.InfJump = false; State.WaterWalk = false
    State.SpeedBoost = 0; State.Sprint = false; State.JumpBoost = false
    State.Spider = false; State.LowGrav = false; State.ZeroGrav = false
    State.AntiFall = false; State.ClickTP = false
    if State.FreeCam then FreeCam_Toggle() end
    local hum = getHum()
    if hum then hum.PlatformStand = false; hum.WalkSpeed = 16; hum.JumpPower = 50; hum.UseJumpPower = false end
    local root = getRoot()
    if root then root.AssemblyLinearVelocity = V3_ZERO end
    workspace.Gravity = 196.2
    Noclip_Restore(); ESP_Clear()
    SwitchPage(State.Page)
end

Master_Shutdown = function()
    running = false
    for k, c in pairs(connections) do
        safe("disconnect:"..k, function() c:Disconnect() end)
    end
    connections = {}
    safe("destroyUI", function() if sg and sg.Parent then sg:Destroy() end end)
    safe("soundCleanup", function() if soundInst then soundInst:Destroy(); soundInst = nil end end)
    log("shutdown complete")
end

-- =============== 装配 ===============
ShowLoadingScreen()
task.wait(2.1)

if UI_Init() then
    Flight_Init(); Noclip_Init(); ESP_Init()
    InfJump_Init(); WaterWalk_Init(); FreeCam_Init()
    SpeedBoost_Init(); Sprint_Init(); JumpBoost_Init()
    Spider_Init(); AntiFall_Init(); ClickTP_Init()
    StartHeadTag(); StartTimeUpdater()
else
    Flight_Init(); Noclip_Init(); ESP_Init()
    InfJump_Init(); WaterWalk_Init(); FreeCam_Init()
    SpeedBoost_Init(); Sprint_Init(); JumpBoost_Init()
    Spider_Init(); AntiFall_Init(); ClickTP_Init()
    StartHeadTag()
end

log("NEXUS v"..VERSION.." loaded - Core Hub Ready")
