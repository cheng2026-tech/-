--!strict
-- NEXUS · HUB v8.0.2 - 11 补丁集成版
local VERSION="8.0.2"
local perfCheck={frameCount=0,lastCheck=tick(),avgFPS=60,warned=false}
local CONFIG={UI_WIDTH=700,UI_HEIGHT=560,SIDEBAR_W=210,FLY_SPEED_TIERS={100,200,350,500},LIFT_SPEED=150,ESP_RANGE=80,ESP_REFRESH=0.3,ESP_MAX_PLAYERS=20,TOGGLE_KEY=Enum.KeyCode.F,RECALL_KEY=Enum.KeyCode.Z,HEAD_TAG_ENABLED=true,HEAD_TAG_TEXT="NEXUS · 用户",HEAD_TAG_COLOR=Color3.fromRGB(0,229,255),TIME_24H=false,TIME_SHOW_SECONDS=true,BALL_X=0.5,BALL_X_OFFSET=-27,BALL_Y=0,BALL_Y_OFFSET=20,BG_IMAGE="rbxassetid://117756559340646",BG_TRANSPARENCY=0.15,FLY_LIFT_OFFSET=3,JUMP_POWER=120,SPRINT_SPEED=90,LOW_GRAV=50,CLICK_TP_KEY=Enum.KeyCode.T,FLY_SPEED_UP_KEY=Enum.KeyCode.Q,FLY_SPEED_DOWN_KEY=Enum.KeyCode.E,NIGHT_BRIGHT=3,NIGHT_AMBIENT=Color3.fromRGB(190,190,190),RADAR_SIZE=150,RADAR_RANGE=200,ANTI_AFK_INTERVAL=30,ANTI_AFK_MOVE_AMOUNT=0.5,TRACER_COLOR=Color3.fromRGB(0,229,255),FRIENDLY_COLOR=Color3.fromRGB(50,220,110),ENEMY_COLOR=Color3.fromRGB(255,59,48),RGB_CYCLE_SPEED=0.05,RING_RADIUS=8,VIGNETTE_STRENGTH=0.6,AURA_PARTICLE_COUNT=20,CHAR_SCALE_SIZES={0.5,1,2,3},SCREENBLUR_INTENSITY=20,CURRENT_LANG="zh",THEME={OVERLAY_TRANSPARENCY=0.45,SIDEBAR_BG=Color3.fromRGB(10,12,18),SIDEBAR_ACTIVE=Color3.fromRGB(0,40,55),ACCENT=Color3.fromRGB(0,180,220),ACCENT_GLOW=Color3.fromRGB(0,229,255),TEXT=Color3.fromRGB(240,245,250),TEXT_DIM=Color3.fromRGB(120,140,160),GREEN=Color3.fromRGB(50,220,110),CARD_BG=Color3.fromRGB(18,22,30),CARD_HOVER=Color3.fromRGB(30,38,50),CARD_ON=Color3.fromRGB(0,180,220),CAT_TEXT=Color3.fromRGB(80,130,180),CORNER=12},L={BRAND="NEXUS",SUBTITLE="HUB · v8.0.2",CAT_MOVE="【移动】",CAT_VISION="【视觉】",CAT_UTIL="【辅助】",FLIGHT="飞行",NOCLIP="穿墙",SPEED="速度",SPEEDBOOST="速度增强",SPRINT="极速冲刺",JUMPBOOST="跳跃增强",INFJUMP="无限跳",FREECAM="自由视角",TELEPORT="传送",CLICKTP="点击传送",SPAWNTP="回出生点",WATERWALK="水上行走",SPIDER="蜘蛛侠",LOWGRAV="低重力",ZEROGRAV="零重力",FLYHOTKEY="飞行热键",NIGHTVIS="夜视",HIGHLIGHT="高亮玩家",RADAR="雷达",NOFOG="无雾",TRACER="追踪线",PLAYERINFO="玩家信息",TEAMHL="队友敌人",TRACKARROW="追踪箭头",ESPRANGE="ESP距离",CROSSHAIR="十字准星",RING="距离环",VIGNETTE="暗角",SCANLINE="扫描线",SNOWSCREEN="雪花屏",TARGETBOX="目标锁定",NAMESTROKE="名称描边",SCREENBLUR="屏幕模糊",COLORFILTER="色彩滤镜",FISHEYE="鱼眼",ESP="透视",ESPV="仅可见",AURA="粒子光环",CHARSCALE="角色缩放",TRANSPARENT="透明化",RAINBOW="彩虹",OUTLINE="发光轮廓",CHARROTATE="角色旋转",LIMBSTRETCH="四肢拉长",NOFX="屏蔽特效",SERVERINFO="服务器信息",RGBBALL="RGB球",ANTIAFK="反挂机",ANTIFALL="反掉落",COORDS="坐标",FOV="视角缩放",CLICKPART="点击显示",MAPBOUNDS="地图边界",REJOIN="重新加入",RESET="重置",SHUTDOWN="关闭",ON="开",OFF="关",LOADING="CORE HUB 加载中",LANG_SWITCH="语言切换"},LANG={zh={BRAND="NEXUS",SUBTITLE="HUB · v8.0.2",CAT_MOVE="【移动】",CAT_VISION="【视觉】",CAT_UTIL="【辅助】",FLIGHT="飞行",NOCLIP="穿墙",SPEED="速度",SPEEDBOOST="速度增强",SPRINT="极速冲刺",JUMPBOOST="跳跃增强",INFJUMP="无限跳",FREECAM="自由视角",TELEPORT="传送",CLICKTP="点击传送",SPAWNTP="回出生点",WATERWALK="水上行走",SPIDER="蜘蛛侠",LOWGRAV="低重力",ZEROGRAV="零重力",FLYHOTKEY="飞行热键",NIGHTVIS="夜视",HIGHLIGHT="高亮玩家",RADAR="雷达",NOFOG="无雾",TRACER="追踪线",PLAYERINFO="玩家信息",TEAMHL="队友敌人",TRACKARROW="追踪箭头",ESPRANGE="ESP距离",CROSSHAIR="十字准星",RING="距离环",VIGNETTE="暗角",SCANLINE="扫描线",SNOWSCREEN="雪花屏",TARGETBOX="目标锁定",NAMESTROKE="名称描边",SCREENBLUR="屏幕模糊",COLORFILTER="色彩滤镜",FISHEYE="鱼眼",ESP="透视",ESPV="仅可见",AURA="粒子光环",CHARSCALE="角色缩放",TRANSPARENT="透明化",RAINBOW="彩虹",OUTLINE="发光轮廓",CHARROTATE="角色旋转",LIMBSTRETCH="四肢拉长",NOFX="屏蔽特效",SERVERINFO="服务器信息",RGBBALL="RGB球",ANTIAFK="反挂机",ANTIFALL="反掉落",COORDS="坐标",FOV="视角缩放",CLICKPART="点击显示",MAPBOUNDS="地图边界",REJOIN="重新加入",RESET="重置",SHUTDOWN="关闭",ON="开",OFF="关",LOADING="CORE HUB 加载中",LANG_SWITCH="语言切换"},en={BRAND="NEXUS",SUBTITLE="HUB · v8.0.2",CAT_MOVE="[Move]",CAT_VISION="[Vision]",CAT_UTIL="[Utility]",FLIGHT="Flight",NOCLIP="Noclip",SPEED="Speed",SPEEDBOOST="Speed Boost",SPRINT="Sprint",JUMPBOOST="Jump Boost",INFJUMP="Infinite Jump",FREECAM="Free Cam",TELEPORT="Teleport",CLICKTP="Click TP",SPAWNTP="Spawn TP",WATERWALK="Water Walk",SPIDER="Spider",LOWGRAV="Low Gravity",ZEROGRAV="Zero Gravity",FLYHOTKEY="Fly Hotkey",NIGHTVIS="Night Vision",HIGHLIGHT="Highlight",RADAR="Radar",NOFOG="No Fog",TRACER="Tracer",PLAYERINFO="Player Info",TEAMHL="Team/Enemy",TRACKARROW="Track Arrow",ESPRANGE="ESP Range",CROSSHAIR="Crosshair",RING="Range Ring",VIGNETTE="Vignette",SCANLINE="Scanline",SNOWSCREEN="Snow Screen",TARGETBOX="Target Box",NAMESTROKE="Name Stroke",SCREENBLUR="Screen Blur",COLORFILTER="Color Filter",FISHEYE="Fisheye",ESP="ESP",ESPV="ESP Visible",AURA="Aura",CHARSCALE="Char Scale",TRANSPARENT="Transparent",RAINBOW="Rainbow",OUTLINE="Outline",CHARROTATE="Char Rotate",LIMBSTRETCH="Limb Stretch",NOFX="No FX",SERVERINFO="Server Info",RGBBALL="RGB Ball",ANTIAFK="Anti AFK",ANTIFALL="Anti Fall",COORDS="Coords",FOV="FOV",CLICKPART="Click Part",MAPBOUNDS="Map Bounds",REJOIN="Rejoin",RESET="Reset",SHUTDOWN="Shutdown",ON="ON",OFF="OFF",LOADING="CORE HUB LOADING",LANG_SWITCH="Language"},nl={BRAND="NEXUS",SUBTITLE="HUB · v8.0.2",CAT_MOVE="[Beweging]",CAT_VISION="[Zicht]",CAT_UTIL="[Hulp]",FLIGHT="Vliegen",NOCLIP="Noclip",SPEED="Snelheid",SPEEDBOOST="Snelheid Boost",SPRINT="Sprinten",JUMPBOOST="Springboost",INFJUMP="Oneindig Springen",FREECAM="Vrije Camera",TELEPORT="Teleport",CLICKTP="Klik TP",SPAWNTP="Spawn TP",WATERWALK="Water Lopen",SPIDER="Spider",LOWGRAV="Lage Zwaartekracht",ZEROGRAV="Nul Zwaartekracht",FLYHOTKEY="Vlieg Sneltoets",NIGHTVIS="Nachtzicht",HIGHLIGHT="Markeren",RADAR="Radar",NOFOG="Geen Mist",TRACER="Volglijn",PLAYERINFO="Speler Info",TEAMHL="Team/Vijand",TRACKARROW="Volgpijl",ESPRANGE="ESP Bereik",CROSSHAIR="Vizier",RING="Bereik Ring",VIGNETTE="Vignet",SCANLINE="Scanlijn",SNOWSCREEN="Sneeuw Scherm",TARGETBOX="Doelvak",NAMESTROKE="Naam Rand",SCREENBLUR="Scherm Vervaging",COLORFILTER="Kleurfilter",FISHEYE="Visoog",ESP="ESP",ESPV="ESP Zichtbaar",AURA="Aura",CHARSCALE="Karakter Schaal",TRANSPARENT="Transparant",RAINBOW="Regenboog",OUTLINE="Omtrek",CHARROTATE="Karakter Roteren",LIMBSTRETCH="Ledematen Strekken",NOFX="Geen FX",SERVERINFO="Server Info",RGBBALL="RGB Bal",ANTIAFK="Anti AFK",ANTIFALL="Anti Val",COORDS="Coördinaten",FOV="FOV",CLICKPART="Klik Deel",MAPBOUNDS="Kaart Grenzen",REJOIN="Opnieuw",RESET="Reset",SHUTDOWN="Afsluiten",ON="AAN",OFF="UIT",LOADING="CORE HUB LADEN",LANG_SWITCH="Taal"}}}
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local SoundService=game:GetService("SoundService")
local TweenService=game:GetService("TweenService")
local Lighting=game:GetService("Lighting")
local Stats=game:GetService("Stats")
local TeleportService=game:GetService("TeleportService")
local LP=Players.LocalPlayer
local Cam=workspace.CurrentCamera
local State={Fly=false,Noclip=false,ESP=false,ESPVisibleOnly=false,FlySpeedTier=2,Visible=true,Page=1,InfJump=false,WaterWalk=false,FreeCam=false,SpeedBoost=0,AntiFall=false,JumpBoost=false,Spider=false,Sprint=false,LowGrav=false,ZeroGrav=false,ClickTP=false,NightVision=false,Highlight=false,Radar=false,NoFog=false,NoFX=false,ServerInfo=false,RGBBall=false,AntiAFK=false,Tracer=false,PlayerInfo=false,TeamHL=false,XRay=false,TrackArrow=false,FOV=false,CamMouse=false,ClickPart=false,FlyHotkey=false,MapBounds=false,AllMarked=false,Crosshair=false,HPBar=false,Ring=false,Vignette=false,Scanline=false,SnowScreen=false,TargetBox=false,NameStroke=false,ObjectHL=false,ScreenBlur=false,ColorFilter=false,Fisheye=false,Aura=false,CharScale=1,Transparent=false,Rainbow=false,Outline=false,CharRotate=false,LimbStretch=false}
local FreeCamData={OrigType=nil,OrigSubj=nil,Pos=Vector3.new(),Yaw=0,Pitch=0}
local running=true
local ESPHolders={}
local highlightObjs={}
local tracerObjs={}
local arrowObjs={}
local connections={}
local navItems={}
local soundInst=nil
local raycastBlocked=nil
local noclipParts={}
local rgbHue=0
local origLighting={Brightness=nil,Ambient=nil,OutdoorAmbient=nil,FogEnd=nil,FogStart=nil,FogColor=nil}
local origFOV=nil
local hiddenFX={}
local objectHLs={}
local rainbowIdx=0
local colorFilterIdx=1
local lockBox=nil
local ringPart=nil
local auraEmitter=nil
local blurEffect=nil
local colorCorrection=nil
local crosshairFrame=nil
local vignetteFrame=nil
local scanlineFrame=nil
local snowFrame=nil
local charRotSpeed=3
local ESPRANGE_TIERS={40,80,150,300}
local selectedESPIdx=1

-- ★ 补丁 1：连接清理
local function CleanupConnections()
    for name,conn in pairs(connections) do
        if not conn or typeof(conn)~="RBXScriptConnection" then
            connections[name]=nil
        end
    end
end
task.spawn(function()
    while running do
        task.wait(60)
        pcall(CleanupConnections)
    end
end)

local function log(...) print("[NEXUS]",...) end
-- ★ 补丁 4：错误隔离
local errorCount={}
local function safe(name,fn)
    local ok,e=pcall(fn)
    if not ok then
        errorCount[name]=(errorCount[name] or 0)+1
        if errorCount[name]<=10 then warn("[NEXUS:"..name.."]",e) end
    else errorCount[name]=0 end
end

-- ★ 补丁 3：自动检测语言
local function AutoDetectLanguage()
    local ok,loc=pcall(function() return game:GetService("LocalizationService").RobloxLocaleId end)
    if not ok or not loc then return "en" end
    loc=loc:lower()
    if loc:find("zh") or loc:find("cn") then return "zh" end
    if loc:find("nl") then return "nl" end
    return "en"
end
local function ApplyLanguage(code)
    local lang=CONFIG.LANG[code]
    if not lang then return end
    CONFIG.CURRENT_LANG=code
    for k,v in pairs(lang) do CONFIG.L[k]=v end
end
CONFIG.CURRENT_LANG=AutoDetectLanguage()
ApplyLanguage(CONFIG.CURRENT_LANG)

local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getRoot() local c=LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=LP.Character return c and c:FindFirstChild("Humanoid") end

do
    local ok=pcall(function()
        local p=RaycastParams.new(); p.FilterType=Enum.RaycastFilterType.Exclude
        workspace:Raycast(Vector3.new(),Vector3.new(1,0,0),p)
    end)
    if ok then
        raycastBlocked=function(p1,p2,filter)
            local char=getChar(); if not char then return false end
            local params=RaycastParams.new()
            params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances=filter or {char}
            return workspace:Raycast(p1,p2-p1,params)~=nil
        end
    else
        raycastBlocked=function(p1,p2,filter)
            local dir=p2-p1; if dir.Magnitude==0 then return false end
            local char=getChar(); if not char then return false end
            return workspace:FindPartOnRayWithIgnoreList(Ray.new(p1,dir),filter or {char})~=nil
        end
    end
end
local V3_ZERO=Vector3.new()
local function GetSound()
    if not soundInst then
        soundInst=Instance.new("Sound")
        soundInst.SoundId="rbxassetid://9115509226"
        soundInst.Volume=0.2; soundInst.Parent=SoundService
    end
    return soundInst
end
local function PlayClick() safe("sound",function() GetSound():Play() end) end

-- ★ 补丁 6：BindClick 触摸优化
local function BindClick(btn,fn)
    if not btn then return end
    local last=0
    local function h()
        local n=tick()
        if n-last<0.2 then return end
        last=n
        pcall(fn)
    end
    pcall(function() btn.MouseButton1Click:Connect(h) end)
    pcall(function() btn.Activated:Connect(h) end)
    pcall(function() btn.TouchTap:Connect(h) end)
    pcall(function() btn.MouseButton1Down:Connect(function() task.wait(0.05); h() end) end)
    pcall(function() btn.MouseButton2Click:Connect(h) end)
end

local sg,main,sidebar,content,titleLabel,descLabel,bigBtn,ball
local navScroll,navList,timeLabel,timeCapsule
local teleportPanel,teleportList,coordsPanel,coordsLabel
local radarFrame,radarCanvas,serverInfoLabel,fovLabel,mapBoundsBox

local function GetTimeString()
    local t=os.date("*t")
    if CONFIG.TIME_24H then
        if CONFIG.TIME_SHOW_SECONDS then return string.format("%02d:%02d:%02d",t.hour,t.min,t.sec)
        else return string.format("%02d:%02d",t.hour,t.min) end
    else
        local h=t.hour%12; if h==0 then h=12 end
        local ap=t.hour<12 and "上午" or "下午"
        if CONFIG.TIME_SHOW_SECONDS then return string.format("%s %d:%02d:%02d",ap,h,t.min,t.sec)
        else return string.format("%s %d:%02d",ap,h,t.min) end
    end
end
local function GetBallDefaultPos() return UDim2.new(CONFIG.BALL_X,CONFIG.BALL_X_OFFSET,CONFIG.BALL_Y,CONFIG.BALL_Y_OFFSET) end

local function ShowLoadingScreen()
    local loadSg=Instance.new("ScreenGui")
    loadSg.Name="NexusLoading"; loadSg.ResetOnSpawn=false
    loadSg.DisplayOrder=10000; loadSg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    loadSg.Parent=LP:WaitForChild("PlayerGui")
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Color3.fromRGB(0,0,0)
    bg.BorderSizePixel=0; bg.Parent=loadSg
    local logo=Instance.new("TextLabel")
    logo.Size=UDim2.new(0,400,0,80); logo.Position=UDim2.new(0.5,-200,0.5,-80)
    logo.BackgroundTransparency=1; logo.Text="NEXUS"
    logo.Font=Enum.Font.GothamBold; logo.TextSize=64
    logo.TextColor3=CONFIG.THEME.ACCENT_GLOW; logo.TextTransparency=1; logo.Parent=bg
    local sub=Instance.new("TextLabel")
    sub.Size=UDim2.new(0,400,0,20); sub.Position=UDim2.new(0.5,-200,0.5,10)
    sub.BackgroundTransparency=1; sub.Text="CORE HUB · INITIALIZING"
    sub.Font=Enum.Font.Gotham; sub.TextSize=12
    sub.TextColor3=CONFIG.THEME.TEXT_DIM; sub.TextTransparency=1; sub.Parent=bg
    local barBg=Instance.new("Frame")
    barBg.Size=UDim2.new(0,300,0,3); barBg.Position=UDim2.new(0.5,-150,0.5,60)
    barBg.BackgroundColor3=Color3.fromRGB(30,40,55); barBg.BorderSizePixel=0
    barBg.BackgroundTransparency=1; barBg.Parent=bg
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(1,0); c.Parent=barBg
    local barFill=Instance.new("Frame")
    barFill.Size=UDim2.new(0,0,1,0); barFill.BackgroundColor3=CONFIG.THEME.ACCENT_GLOW
    barFill.BorderSizePixel=0; barFill.Parent=barBg
    local c2=Instance.new("UICorner"); c2.CornerRadius=UDim.new(1,0); c2.Parent=barFill
    local lt=Instance.new("TextLabel")
    lt.Size=UDim2.new(0,400,0,16); lt.Position=UDim2.new(0.5,-200,0.5,75)
    lt.BackgroundTransparency=1; lt.Text=CONFIG.L.LOADING
    lt.Font=Enum.Font.Gotham; lt.TextSize=11
    lt.TextColor3=CONFIG.THEME.TEXT_DIM; lt.TextTransparency=1; lt.Parent=bg
    TweenService:Create(logo,TweenInfo.new(0.4),{TextTransparency=0}):Play()
    TweenService:Create(sub,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(barBg,TweenInfo.new(0.5),{BackgroundTransparency=0}):Play()
    TweenService:Create(lt,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    TweenService:Create(barFill,TweenInfo.new(1.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
    task.delay(1.6,function()
        TweenService:Create(bg,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        TweenService:Create(logo,TweenInfo.new(0.4),{TextTransparency=1}):Play()
        TweenService:Create(sub,TweenInfo.new(0.4),{TextTransparency=1}):Play()
        TweenService:Create(barBg,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        TweenService:Create(lt,TweenInfo.new(0.4),{TextTransparency=1}):Play()
        task.wait(0.45)
        if loadSg and loadSg.Parent then loadSg:Destroy() end
    end)
end

local function StartTimeUpdater()
    task.spawn(function()
        while running do
            if timeLabel then timeLabel.Text=GetTimeString() end
            task.wait(1)
        end
    end)
end
local function UI_Show()
    State.Visible=true
    if main then main.Visible=true end
    if ball then ball.Visible=false end
    if main then TweenService:Create(main,TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,CONFIG.UI_WIDTH,0,CONFIG.UI_HEIGHT)}):Play() end
end
local function UI_Hide()
    State.Visible=false
    if main then TweenService:Create(main,TweenInfo.new(0.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,CONFIG.UI_WIDTH,0,0)}):Play() end
    task.delay(0.2,function()
        if not State.Visible then
            if main then main.Visible=false end
            if ball then ball.Position=GetBallDefaultPos(); ball.Visible=true end
        end
    end)
end
local function UI_Toggle() if State.Visible then UI_Hide() else UI_Show() end end

local function SetupDrag()
    local drag=false; local sx,sy,px,py=0,0,0,0
    local function clampP()
        local sw=Cam.ViewportSize.X; local sh=Cam.ViewportSize.Y
        local x=math.clamp(main.Position.X.Offset,0,sw-CONFIG.UI_WIDTH)
        local y=math.clamp(main.Position.Y.Offset,0,sh-CONFIG.UI_HEIGHT)
        main.Position=UDim2.new(0,x,0,y)
    end
    connections.dragBegan=UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        if not State.Visible then return end
        local pos=i.Position
        local ap=main.AbsolutePosition; local as=main.AbsoluteSize
        if pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then
            if pos.Y<=ap.Y+50 or (pos.X<=ap.X+CONFIG.SIDEBAR_W and pos.Y<=ap.Y+90) or (pos.X>ap.X+CONFIG.SIDEBAR_W+180 and pos.Y<ap.Y+as.Y-120) then
                drag=true; sx,sy=pos.X,pos.Y; px,py=main.Position.X.Offset,main.Position.Y.Offset
            end
        end
    end)
    connections.dragEnded=UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=false end
    end)
    connections.dragChanged=UIS.InputChanged:Connect(function(i)
        if not drag then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position
        main.Position=UDim2.new(0,px+(pos.X-sx),0,py+(pos.Y-sy)); clampP()
    end)
    local bDrag,bsx,bsy,bpx,bpy=false,0,0,0,0
    connections.ballDragBegan=UIS.InputBegan:Connect(function(i,gp)
        if gp then return end
        if not ball or not ball.Visible then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position; local ap=ball.AbsolutePosition; local as=ball.AbsoluteSize
        if pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then
            bDrag=true; bsx,bsy=pos.X,pos.Y; bpx,bpy=ball.Position.X.Offset,ball.Position.Y.Offset
        end
    end)
    connections.ballDragEnded=UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then bDrag=false end
    end)
    connections.ballDragChanged=UIS.InputChanged:Connect(function(i)
        if not bDrag then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position; local sw=Cam.ViewportSize.X; local sh=Cam.ViewportSize.Y
        local nx=math.clamp(bpx+(pos.X-bsx),0,sw-54); local ny=math.clamp(bpy+(pos.Y-bsy),0,sh-54)
        ball.Position=UDim2.new(0,nx,0,ny)
    end)
end

local PAGES={
    {cat=CONFIG.L.CAT_MOVE},
    {key="Fly",icon="✈",title=CONFIG.L.FLIGHT,desc="自由飞行 + 自动穿墙"},
    {key="Noclip",icon="⬜",title=CONFIG.L.NOCLIP,desc="独立穿墙模式"},
    {key="Speed",icon="⚡",title=CONFIG.L.SPEED,desc="切换飞行速度档位"},
    {key="SpeedBoost",icon="»",title=CONFIG.L.SPEEDBOOST,desc="提高行走速度"},
    {key="Sprint",icon="≡",title=CONFIG.L.SPRINT,desc="按住左Shift冲刺"},
    {key="JumpBoost",icon="⇧",title=CONFIG.L.JUMPBOOST,desc="跳跃高度提升"},
    {key="InfJump",icon="↑",title=CONFIG.L.INFJUMP,desc="空中可连续跳跃"},
    {key="FreeCam",icon="◐",title=CONFIG.L.FREECAM,desc="相机脱开角色自由看"},
    {key="Teleport",icon="➤",title=CONFIG.L.TELEPORT,desc="点击玩家名传送"},
    {key="ClickTP",icon="⌖",title=CONFIG.L.CLICKTP,desc="按 T 传送到鼠标处"},
    {key="SpawnTP",icon="⌂",title=CONFIG.L.SPAWNTP,desc="一键回出生点"},
    {key="WaterWalk",icon="≈",title=CONFIG.L.WATERWALK,desc="水面像平地行走"},
    {key="Spider",icon="❋",title=CONFIG.L.SPIDER,desc="空中贴墙悬停"},
    {key="LowGrav",icon="☾",title=CONFIG.L.LOWGRAV,desc="重力调低"},
    {key="ZeroGrav",icon="✦",title=CONFIG.L.ZEROGRAV,desc="完全失重"},
    {key="FlyHotkey",icon="⎋",title=CONFIG.L.FLYHOTKEY,desc="按 Q/E 调飞行速度"},
    {cat=CONFIG.L.CAT_VISION},
    {key="NightVis",icon="☀",title=CONFIG.L.NIGHTVIS,desc="提亮地图"},
    {key="Highlight",icon="◆",title=CONFIG.L.HIGHLIGHT,desc="玩家全身发光"},
    {key="Radar",icon="◯",title=CONFIG.L.RADAR,desc="右上角玩家方位圆盘"},
    {key="NoFog",icon="◌",title=CONFIG.L.NOFOG,desc="移除地图雾气"},
    {key="Tracer",icon="╱",title=CONFIG.L.TRACER,desc="玩家头顶引线指向你"},
    {key="PlayerInfo",icon="ⓘ",title=CONFIG.L.PLAYERINFO,desc="显示血量/距离/队伍"},
    {key="TeamHL",icon="✚",title=CONFIG.L.TEAMHL,desc="队友绿/敌人红"},
    {key="TrackArrow",icon="➨",title=CONFIG.L.TRACKARROW,desc="屏幕边缘箭头指向"},
    {key="ESPRange",icon="⇔",title=CONFIG.L.ESPRANGE,desc="切换 ESP 范围"},
    {key="Crosshair",icon="✛",title=CONFIG.L.CROSSHAIR,desc="屏幕中心十字准星"},
    {key="Ring",icon="◎",title=CONFIG.L.RING,desc="脚下霓虹距离环"},
    {key="Vignette",icon="◐",title=CONFIG.L.VIGNETTE,desc="屏幕四周变暗"},
    {key="Scanline",icon="≡",title=CONFIG.L.SCANLINE,desc="CRT 扫描线特效"},
    {key="SnowScreen",icon="❄",title=CONFIG.L.SNOWSCREEN,desc="老电视雪花屏"},
    {key="TargetBox",icon="⬜",title=CONFIG.L.TARGETBOX,desc="锁定最近玩家方框"},
    {key="NameStroke",icon="❖",title=CONFIG.L.NAMESTROKE,desc="玩家名字加粗描边"},
    {key="ScreenBlur",icon="▤",title=CONFIG.L.SCREENBLUR,desc="全屏模糊"},
    {key="ColorFilter",icon="◈",title=CONFIG.L.COLORFILTER,desc="全屏色调调整"},
    {key="Fisheye",icon="◉",title=CONFIG.L.FISHEYE,desc="超广角鱼眼"},
    {cat=CONFIG.L.CAT_UTIL},
    {key="ESP",icon="◉",title=CONFIG.L.ESP,desc="透视其他玩家"},
    {key="ESPV",icon="◎",title=CONFIG.L.ESPV,desc="仅可见玩家"},
    {key="Aura",icon="❂",title=CONFIG.L.AURA,desc="角色周围粒子光环"},
    {key="CharScale",icon="⬛",title=CONFIG.L.CHARSCALE,desc="切换角色大小"},
    {key="Transparent",icon="◌",title=CONFIG.L.TRANSPARENT,desc="自己角色半透明"},
    {key="Rainbow",icon="🌈",title=CONFIG.L.RAINBOW,desc="全身循环变色"},
    {key="Outline",icon="◇",title=CONFIG.L.OUTLINE,desc="全身发光轮廓"},
    {key="CharRotate",icon="↻",title=CONFIG.L.CHARROTATE,desc="角色原地旋转"},
    {key="LimbStretch",icon="⟺",title=CONFIG.L.LIMBSTRETCH,desc="四肢拉长"},
    {key="NoFX",icon="✧",title=CONFIG.L.NOFX,desc="关闭粒子特效"},
    {key="ServerInfo",icon="ℹ",title=CONFIG.L.SERVERINFO,desc="显示延迟/玩家数"},
    {key="RGBBall",icon="◈",title=CONFIG.L.RGBBALL,desc="悬浮球循环变色"},
    {key="AntiAFK",icon="⏰",title=CONFIG.L.ANTIAFK,desc="防挂机被踢"},
    {key="AntiFall",icon="⤴",title=CONFIG.L.ANTIFALL,desc="掉出地图自动拉回"},
    {key="Coords",icon="◇",title=CONFIG.L.COORDS,desc="显示实时坐标"},
    {key="FOV",icon="◯",title=CONFIG.L.FOV,desc="调整视距"},
    {key="ClickPart",icon="✜",title=CONFIG.L.CLICKPART,desc="点击显示物块信息"},
    {key="MapBounds",icon="▣",title=CONFIG.L.MAPBOUNDS,desc="显示地图边界"},
    {key="Rejoin",icon="↻",title=CONFIG.L.REJOIN,desc="重新加入服务器"},
    -- ★ 补丁 8：语言切换
    {key="LangSwitch",icon="🌐",title=CONFIG.L.LANG_SWITCH,desc="点击切换：中文 → English → Nederlands"},
    {key="Reset",icon="↺",title=CONFIG.L.RESET,desc="关闭所有功能"},
    {key="Shutdown",icon="✕",title=CONFIG.L.SHUTDOWN,desc="彻底关闭脚本"},
}
local function GetPageIndex(key) for i,p in ipairs(PAGES) do if p.key==key then return i end end return nil end

local function RefreshTeleportList()
    if not teleportList then return end
    for _,c in ipairs(teleportList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local myRoot=getRoot(); local myPos=myRoot and myRoot.Position or V3_ZERO
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist=math.floor((hrp.Position-myPos).Magnitude)
                local btn=Instance.new("TextButton")
                btn.Size=UDim2.new(1,-8,0,34); btn.BackgroundColor3=CONFIG.THEME.CARD_BG
                btn.Text="  "..plr.Name.."    ["..dist.."m]"
                btn.Font=Enum.Font.GothamMedium; btn.TextSize=13
                btn.TextColor3=CONFIG.THEME.TEXT; btn.TextXAlignment=Enum.TextXAlignment.Left
                btn.AutoButtonColor=false; btn.ZIndex=5; btn.Parent=teleportList
                local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,8); c.Parent=btn
                BindClick(btn,function() PlayClick(); TeleportTo(plr) end)
            end
        end
    end
end
local TeleportTo=function(plr)
    local myRoot=getRoot(); if not myRoot then return end
    local tc=plr.Character; if not tc then return end
    local tr=tc:FindFirstChild("HumanoidRootPart"); if not tr then return end
    local pos=tr.Position+tr.CFrame.LookVector*3
    myRoot.CFrame=CFrame.new(pos,pos+tr.CFrame.LookVector)
end

local function SwitchPage(idx)
    State.Page=idx
    local page=PAGES[idx]; if not page or page.cat then return end
    for i,item in ipairs(navItems) do
        if item then
            if i==idx then
                item.BackgroundColor3=CONFIG.THEME.SIDEBAR_ACTIVE; item.BackgroundTransparency=0
                local ico=item:FindFirstChild("Icon"); local lbl=item:FindFirstChild("Text")
                if ico then ico.TextColor3=CONFIG.THEME.ACCENT_GLOW end
                if lbl then lbl.TextColor3=CONFIG.THEME.TEXT end
            else
                item.BackgroundColor3=Color3.fromRGB(0,0,0); item.BackgroundTransparency=1
                local ico=item:FindFirstChild("Icon"); local lbl=item:FindFirstChild("Text")
                if ico then ico.TextColor3=CONFIG.THEME.TEXT_DIM end
                if lbl then lbl.TextColor3=CONFIG.THEME.TEXT_DIM end
            end
        end
    end
    if titleLabel then titleLabel.Text=page.title end
    if descLabel then descLabel.Text=page.desc end
    if teleportPanel and teleportList then
        if page.key=="Teleport" then
            teleportPanel.Visible=true; if coordsPanel then coordsPanel.Visible=false end
            if bigBtn then bigBtn.Visible=false end
            RefreshTeleportList()
        elseif page.key=="Coords" then
            teleportPanel.Visible=false; if coordsPanel then coordsPanel.Visible=true end
            if bigBtn then bigBtn.Visible=false end
        else
            teleportPanel.Visible=false; if coordsPanel then coordsPanel.Visible=false end
            if bigBtn then bigBtn.Visible=true end
        end
    end
    local k=page.key
    local isOn,btnText=false,""
    if k=="Fly" then isOn=State.Fly; btnText=State.Fly and "关闭飞行" or "开启飞行"
    elseif k=="Noclip" then isOn=State.Noclip; btnText=State.Noclip and "关闭穿墙" or "开启穿墙"
    elseif k=="Speed" then isOn=true; btnText="切换速度 → "..CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier]
    elseif k=="SpeedBoost" then isOn=State.SpeedBoost>0; btnText=State.SpeedBoost==0 and "开启" or ("当前："..({50,100,180})[State.SpeedBoost])
    elseif k=="Sprint" then isOn=State.Sprint; btnText=State.Sprint and "关闭" or "开启"
    elseif k=="JumpBoost" then isOn=State.JumpBoost; btnText=State.JumpBoost and "关闭" or "开启"
    elseif k=="InfJump" then isOn=State.InfJump; btnText=State.InfJump and "关闭" or "开启"
    elseif k=="FreeCam" then isOn=State.FreeCam; btnText=State.FreeCam and "关闭" or "开启"
    elseif k=="ClickTP" then isOn=State.ClickTP; btnText=State.ClickTP and "关闭" or "开启"
    elseif k=="SpawnTP" then btnText="传回出生点"
    elseif k=="WaterWalk" then isOn=State.WaterWalk; btnText=State.WaterWalk and "关闭" or "开启"
    elseif k=="Spider" then isOn=State.Spider; btnText=State.Spider and "关闭" or "开启"
    elseif k=="LowGrav" then isOn=State.LowGrav; btnText=State.LowGrav and "关闭" or "开启"
    elseif k=="ZeroGrav" then isOn=State.ZeroGrav; btnText=State.ZeroGrav and "关闭" or "开启"
    elseif k=="FlyHotkey" then isOn=State.FlyHotkey; btnText=State.FlyHotkey and "关闭" or "开启"
    elseif k=="NightVis" then isOn=State.NightVision; btnText=State.NightVision and "关闭" or "开启"
    elseif k=="Highlight" then isOn=State.Highlight; btnText=State.Highlight and "关闭" or "开启"
    elseif k=="Radar" then isOn=State.Radar; btnText=State.Radar and "关闭" or "开启"
    elseif k=="NoFog" then isOn=State.NoFog; btnText=State.NoFog and "关闭" or "开启"
    elseif k=="Tracer" then isOn=State.Tracer; btnText=State.Tracer and "关闭" or "开启"
    elseif k=="PlayerInfo" then isOn=State.PlayerInfo; btnText=State.PlayerInfo and "关闭" or "开启"
    elseif k=="TeamHL" then isOn=State.TeamHL; btnText=State.TeamHL and "关闭" or "开启"
    elseif k=="TrackArrow" then isOn=State.TrackArrow; btnText=State.TrackArrow and "关闭" or "开启"
    elseif k=="ESPRange" then isOn=true; btnText="切换 ESP → "..CONFIG.ESP_RANGE
    elseif k=="Crosshair" then isOn=State.Crosshair; btnText=State.Crosshair and "关闭" or "开启"
    elseif k=="Ring" then isOn=State.Ring; btnText=State.Ring and "关闭" or "开启"
    elseif k=="Vignette" then isOn=State.Vignette; btnText=State.Vignette and "关闭" or "开启"
    elseif k=="Scanline" then isOn=State.Scanline; btnText=State.Scanline and "关闭" or "开启"
    elseif k=="SnowScreen" then isOn=State.SnowScreen; btnText=State.SnowScreen and "关闭" or "开启"
    elseif k=="TargetBox" then isOn=State.TargetBox; btnText=State.TargetBox and "关闭" or "开启"
    elseif k=="NameStroke" then isOn=State.NameStroke; btnText=State.NameStroke and "关闭" or "开启"
    elseif k=="ScreenBlur" then isOn=State.ScreenBlur; btnText=State.ScreenBlur and "关闭" or "开启"
    elseif k=="ColorFilter" then isOn=State.ColorFilter; btnText=State.ColorFilter and "关闭" or "开启"
    elseif k=="Fisheye" then isOn=State.Fisheye; btnText=State.Fisheye and "关闭" or "开启"
    elseif k=="ESP" then isOn=State.ESP; btnText=State.ESP and "关闭透视" or "开启透视"
    elseif k=="ESPV" then isOn=State.ESPVisibleOnly; btnText=State.ESPVisibleOnly and "关闭" or "开启"
    elseif k=="Aura" then isOn=State.Aura; btnText=State.Aura and "关闭" or "开启"
    elseif k=="CharScale" then isOn=State.CharScale~=1; btnText="大小 → "..State.CharScale.."x"
    elseif k=="Transparent" then isOn=State.Transparent; btnText=State.Transparent and "关闭" or "开启"
    elseif k=="Rainbow" then isOn=State.Rainbow; btnText=State.Rainbow and "关闭" or "开启"
    elseif k=="Outline" then isOn=State.Outline; btnText=State.Outline and "关闭" or "开启"
    elseif k=="CharRotate" then isOn=State.CharRotate; btnText=State.CharRotate and "关闭" or "开启"
    elseif k=="LimbStretch" then isOn=State.LimbStretch; btnText=State.LimbStretch and "关闭" or "开启"
    elseif k=="NoFX" then isOn=State.NoFX; btnText=State.NoFX and "关闭" or "开启"
    elseif k=="ServerInfo" then isOn=State.ServerInfo; btnText=State.ServerInfo and "关闭" or "开启"
    elseif k=="RGBBall" then isOn=State.RGBBall; btnText=State.RGBBall and "关闭" or "开启"
    elseif k=="AntiAFK" then isOn=State.AntiAFK; btnText=State.AntiAFK and "关闭" or "开启"
    elseif k=="AntiFall" then isOn=State.AntiFall; btnText=State.AntiFall and "关闭" or "开启"
    elseif k=="FOV" then isOn=State.FOV; btnText=State.FOV and "关闭" or "开启"
    elseif k=="ClickPart" then isOn=State.ClickPart; btnText=State.ClickPart and "关闭" or "开启"
    elseif k=="MapBounds" then isOn=State.MapBounds; btnText=State.MapBounds and "关闭" or "显示"
    elseif k=="Rejoin" then btnText="重新加入服务器"
    -- ★ 补丁 9：语言切换按钮文字
    elseif k=="LangSwitch" then
        local curLang=CONFIG.CURRENT_LANG
        local langName=({zh="中文",en="English",nl="Nederlands"})[curLang] or "中文"
        btnText="当前："..langName.."  → 点击切换"
    elseif k=="Reset" then btnText="执行重置"
    elseif k=="Shutdown" then btnText="确认关闭脚本"
    end
    if bigBtn then
        bigBtn.Text=btnText
        bigBtn.BackgroundColor3=isOn and CONFIG.THEME.CARD_ON or CONFIG.THEME.CARD_BG
    end
end

local Flight_Toggle,Noclip_Toggle,ESP_Toggle,ESP_ToggleVisible,Master_AllOff,Master_Shutdown
local InfJump_Toggle,WaterWalk_Toggle,FreeCam_Toggle,SpeedBoost_Toggle
local SpawnTP_Action,AntiFall_Toggle,ClickTP_Toggle,JumpBoost_Toggle,Spider_Toggle,Sprint_Toggle
local LowGrav_Toggle,ZeroGrav_Toggle,FlyHotkey_Toggle
local NightVision_Toggle,Highlight_Toggle,Radar_Toggle,NoFog_Toggle
local NoFX_Toggle,ServerInfo_Toggle,RGBBall_Toggle,AntiAFK_Toggle
local Tracer_Toggle,PlayerInfo_Toggle,TeamHL_Toggle,TrackArrow_Toggle,ESPRange_Toggle
local Crosshair_Toggle,Ring_Toggle,Vignette_Toggle,Scanline_Toggle,SnowScreen_Toggle
local TargetBox_Toggle,NameStroke_Toggle,ScreenBlur_Toggle,ColorFilter_Toggle,Fisheye_Toggle
local Aura_Toggle,CharScale_Toggle,Transparent_Toggle,Rainbow_Toggle,Outline_Toggle,CharRotate_Toggle,LimbStretch_Toggle
local FOV_Toggle,ClickPart_Toggle,MapBounds_Toggle

local function OnBigBtnClick()
    local page=PAGES[State.Page]; if not page or page.cat then return end
    PlayClick()
    local k=page.key
    if k=="Fly" then Flight_Toggle()
    elseif k=="Noclip" then Noclip_Toggle()
    elseif k=="Speed" then State.FlySpeedTier=(State.FlySpeedTier%#CONFIG.FLY_SPEED_TIERS)+1
    elseif k=="SpeedBoost" then SpeedBoost_Toggle()
    elseif k=="Sprint" then Sprint_Toggle()
    elseif k=="JumpBoost" then JumpBoost_Toggle()
    elseif k=="InfJump" then InfJump_Toggle()
    elseif k=="FreeCam" then FreeCam_Toggle()
    elseif k=="ClickTP" then ClickTP_Toggle()
    elseif k=="SpawnTP" then SpawnTP_Action()
    elseif k=="WaterWalk" then WaterWalk_Toggle()
    elseif k=="Spider" then Spider_Toggle()
    elseif k=="LowGrav" then LowGrav_Toggle()
    elseif k=="ZeroGrav" then ZeroGrav_Toggle()
    elseif k=="FlyHotkey" then FlyHotkey_Toggle()
    elseif k=="NightVis" then NightVision_Toggle()
    elseif k=="Highlight" then Highlight_Toggle()
    elseif k=="Radar" then Radar_Toggle()
    elseif k=="NoFog" then NoFog_Toggle()
    elseif k=="Tracer" then Tracer_Toggle()
    elseif k=="PlayerInfo" then PlayerInfo_Toggle()
    elseif k=="TeamHL" then TeamHL_Toggle()
    elseif k=="TrackArrow" then TrackArrow_Toggle()
    elseif k=="ESPRange" then ESPRange_Toggle()
    elseif k=="Crosshair" then Crosshair_Toggle()
    elseif k=="Ring" then Ring_Toggle()
    elseif k=="Vignette" then Vignette_Toggle()
    elseif k=="Scanline" then Scanline_Toggle()
    elseif k=="SnowScreen" then SnowScreen_Toggle()
    elseif k=="TargetBox" then TargetBox_Toggle()
    elseif k=="NameStroke" then NameStroke_Toggle()
    elseif k=="ScreenBlur" then ScreenBlur_Toggle()
    elseif k=="ColorFilter" then ColorFilter_Toggle()
    elseif k=="Fisheye" then Fisheye_Toggle()
    elseif k=="ESP" then ESP_Toggle()
    elseif k=="ESPV" then ESP_ToggleVisible()
    elseif k=="Aura" then Aura_Toggle()
    elseif k=="CharScale" then CharScale_Toggle()
    elseif k=="Transparent" then Transparent_Toggle()
    elseif k=="Rainbow" then Rainbow_Toggle()
    elseif k=="Outline" then Outline_Toggle()
    elseif k=="CharRotate" then CharRotate_Toggle()
    elseif k=="LimbStretch" then LimbStretch_Toggle()
    elseif k=="NoFX" then NoFX_Toggle()
    elseif k=="ServerInfo" then ServerInfo_Toggle()
    elseif k=="RGBBall" then RGBBall_Toggle()
    elseif k=="AntiAFK" then AntiAFK_Toggle()
    elseif k=="AntiFall" then AntiFall_Toggle()
    elseif k=="FOV" then FOV_Toggle()
    elseif k=="ClickPart" then ClickPart_Toggle()
    elseif k=="MapBounds" then MapBounds_Toggle()
    elseif k=="Rejoin" then safe("rejoin",function() TeleportService:Teleport(game.PlaceId,LP) end)
    -- ★ 补丁 10：语言切换触发
    elseif k=="LangSwitch" then
        local order={"zh","en","nl"}
        local curIdx=1
        for i,c in ipairs(order) do if c==CONFIG.CURRENT_LANG then curIdx=i end end
        local nextLang=order[(curIdx%#order)+1]
        ApplyLanguage(nextLang)
        if sg and sg.Parent then sg:Destroy() end
        task.wait(0.1)
        UI_Init(); StartTimeUpdater()
        return
    elseif k=="Reset" then Master_AllOff()
    elseif k=="Shutdown" then Master_Shutdown()
    end
    SwitchPage(State.Page)
end

local function UI_Init()
    local ok,err=pcall(function()
        sg=Instance.new("ScreenGui")
        sg.Name="NexusHub"; sg.ResetOnSpawn=false
        sg.DisplayOrder=999; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        sg.Parent=LP:WaitForChild("PlayerGui")
        main=Instance.new("Frame")
        main.Size=UDim2.new(0,CONFIG.UI_WIDTH,0,CONFIG.UI_HEIGHT)
        main.Position=UDim2.new(0.5,-CONFIG.UI_WIDTH/2,0.5,-CONFIG.UI_HEIGHT/2)
        main.BackgroundColor3=Color3.fromRGB(6,8,14); main.BorderSizePixel=0
        main.ClipsDescendants=true; main.Active=true; main.Parent=sg
        local mc=Instance.new("UICorner"); mc.CornerRadius=UDim.new(0,CONFIG.THEME.CORNER+4); mc.Parent=main
        local bg=Instance.new("ImageLabel")
        bg.Size=UDim2.new(1,0,1,0); bg.Image=CONFIG.BG_IMAGE
        bg.ImageTransparency=CONFIG.BG_TRANSPARENCY; bg.BackgroundTransparency=1
        bg.ScaleType=Enum.ScaleType.Crop; bg.ZIndex=1; bg.Parent=main
        local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(0,CONFIG.THEME.CORNER+4); bgc.Parent=bg
        local overlay=Instance.new("Frame")
        overlay.Size=UDim2.new(1,0,1,0); overlay.BackgroundColor3=Color3.fromRGB(0,0,0)
        overlay.BackgroundTransparency=CONFIG.THEME.OVERLAY_TRANSPARENCY
        overlay.BorderSizePixel=0; overlay.ZIndex=2; overlay.Parent=main
        local oc=Instance.new("UICorner"); oc.CornerRadius=UDim.new(0,CONFIG.THEME.CORNER+4); oc.Parent=overlay
        local tg=Instance.new("Frame")
        tg.Size=UDim2.new(1,0,0,2); tg.BackgroundColor3=CONFIG.THEME.ACCENT_GLOW
        tg.BorderSizePixel=0; tg.ZIndex=10; tg.Parent=main
        timeCapsule=Instance.new("Frame")
        timeCapsule.Size=UDim2.new(0,160,0,30); timeCapsule.Position=UDim2.new(0.5,-80,0,12)
        timeCapsule.BackgroundColor3=Color3.fromRGB(0,0,0); timeCapsule.BackgroundTransparency=0.15
        timeCapsule.BorderSizePixel=0; timeCapsule.ZIndex=20; timeCapsule.Parent=main
        local tcc=Instance.new("UICorner"); tcc.CornerRadius=UDim.new(1,0); tcc.Parent=timeCapsule
        local tcs=Instance.new("UIStroke"); tcs.Color=CONFIG.THEME.ACCENT_GLOW; tcs.Thickness=1; tcs.Transparency=0.5; tcs.Parent=timeCapsule
        local dot=Instance.new("Frame")
        dot.Size=UDim2.new(0,6,0,6); dot.Position=UDim2.new(0,12,0.5,-3)
        dot.BackgroundColor3=CONFIG.THEME.GREEN; dot.BorderSizePixel=0; dot.ZIndex=21; dot.Parent=timeCapsule
        local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=dot
        timeLabel=Instance.new("TextLabel")
        timeLabel.Size=UDim2.new(1,-30,1,0); timeLabel.Position=UDim2.new(0,24,0,0)
        timeLabel.BackgroundTransparency=1; timeLabel.Text=GetTimeString()
        timeLabel.Font=Enum.Font.GothamBold; timeLabel.TextSize=14
        timeLabel.TextColor3=CONFIG.THEME.ACCENT_GLOW; timeLabel.TextXAlignment=Enum.TextXAlignment.Center
        timeLabel.ZIndex=21; timeLabel.Parent=timeCapsule
        sidebar=Instance.new("Frame")
        sidebar.Size=UDim2.new(0,CONFIG.SIDEBAR_W,1,0); sidebar.BackgroundColor3=CONFIG.THEME.SIDEBAR_BG
        sidebar.BackgroundTransparency=0.15; sidebar.BorderSizePixel=0; sidebar.ZIndex=3; sidebar.Parent=main
        local brand=Instance.new("TextLabel")
        brand.Size=UDim2.new(1,0,0,32); brand.Position=UDim2.new(0,16,0,14)
        brand.BackgroundTransparency=1; brand.Text=CONFIG.L.BRAND
        brand.Font=Enum.Font.GothamBold; brand.TextSize=22
        brand.TextColor3=CONFIG.THEME.ACCENT_GLOW; brand.TextXAlignment=Enum.TextXAlignment.Left
        brand.ZIndex=4; brand.Parent=sidebar
        local sub=Instance.new("TextLabel")
        sub.Size=UDim2.new(1,0,0,14); sub.Position=UDim2.new(0,16,0,46)
        sub.BackgroundTransparency=1; sub.Text=CONFIG.L.SUBTITLE
        sub.Font=Enum.Font.Gotham; sub.TextSize=10
        sub.TextColor3=CONFIG.THEME.TEXT_DIM; sub.TextXAlignment=Enum.TextXAlignment.Left
        sub.ZIndex=4; sub.Parent=sidebar
        navScroll=Instance.new("ScrollingFrame")
        navScroll.Size=UDim2.new(1,-8,1,-80); navScroll.Position=UDim2.new(0,4,0,70)
        navScroll.BackgroundTransparency=1; navScroll.BorderSizePixel=0
        navScroll.ScrollBarThickness=3; navScroll.ScrollBarImageColor3=CONFIG.THEME.ACCENT_GLOW
        navScroll.CanvasSize=UDim2.new(0,0,0,0); navScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
        navScroll.ScrollingDirection=Enum.ScrollingDirection.Y; navScroll.ZIndex=4; navScroll.Parent=sidebar
        navList=Instance.new("Frame")
        navList.Size=UDim2.new(1,0,0,0); navList.BackgroundTransparency=1
        navList.AutomaticSize=Enum.AutomaticSize.Y; navList.ZIndex=4; navList.Parent=navScroll
        local layout=Instance.new("UIListLayout")
        layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,2); layout.Parent=navList
        for i,page in ipairs(PAGES) do
            if page.cat then
                local catFrame=Instance.new("TextLabel")
                catFrame.Size=UDim2.new(1,-6,0,24); catFrame.BackgroundTransparency=1
                catFrame.Text=page.cat; catFrame.Font=Enum.Font.GothamBold
                catFrame.TextSize=11; catFrame.TextColor3=CONFIG.THEME.CAT_TEXT
                catFrame.TextXAlignment=Enum.TextXAlignment.Left
                catFrame.LayoutOrder=i; catFrame.ZIndex=5; catFrame.Parent=navList
                navItems[i]={IsCat=true,Frame=catFrame}
            else
                local item=Instance.new("TextButton")
                item.Size=UDim2.new(1,-6,0,30); item.BackgroundColor3=Color3.fromRGB(0,0,0)
                item.BackgroundTransparency=1; item.AutoButtonColor=false; item.Text=""
                item.LayoutOrder=i; item.ZIndex=5; item.Parent=navList
                local ic=Instance.new("UICorner"); ic.CornerRadius=UDim.new(0,8); ic.Parent=item
                local ico=Instance.new("TextLabel")
                ico.Name="Icon"; ico.Size=UDim2.new(0,24,1,0); ico.Position=UDim2.new(0,10,0,0)
                ico.BackgroundTransparency=1; ico.Text=page.icon
                ico.Font=Enum.Font.GothamBold; ico.TextSize=14
                ico.TextColor3=CONFIG.THEME.TEXT_DIM; ico.TextXAlignment=Enum.TextXAlignment.Center
                ico.ZIndex=6; ico.Parent=item
                local lbl=Instance.new("TextLabel")
                lbl.Name="Text"; lbl.Size=UDim2.new(1,-40,1,0); lbl.Position=UDim2.new(0,36,0,0)
                lbl.BackgroundTransparency=1; lbl.Text=page.title
                lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12
                lbl.TextColor3=CONFIG.THEME.TEXT_DIM; lbl.TextXAlignment=Enum.TextXAlignment.Left
                lbl.ZIndex=6; lbl.Parent=item
                BindClick(item,function() PlayClick(); SwitchPage(i) end)
                navItems[i]=item
            end
        end
        content=Instance.new("Frame")
        content.Size=UDim2.new(1,-CONFIG.SIDEBAR_W,1,0); content.Position=UDim2.new(0,CONFIG.SIDEBAR_W,0,0)
        content.BackgroundTransparency=1; content.ZIndex=3; content.Parent=main
        titleLabel=Instance.new("TextLabel")
        titleLabel.Size=UDim2.new(1,-60,0,36); titleLabel.Position=UDim2.new(0,30,0,60)
        titleLabel.BackgroundTransparency=1; titleLabel.Text=CONFIG.L.FLIGHT
        titleLabel.Font=Enum.Font.GothamBold; titleLabel.TextSize=26
        titleLabel.TextColor3=CONFIG.THEME.TEXT; titleLabel.TextXAlignment=Enum.TextXAlignment.Left
        titleLabel.ZIndex=4; titleLabel.Parent=content
        descLabel=Instance.new("TextLabel")
        descLabel.Size=UDim2.new(1,-60,0,40); descLabel.Position=UDim2.new(0,30,0,102)
        descLabel.BackgroundTransparency=1; descLabel.Text=""
        descLabel.Font=Enum.Font.Gotham; descLabel.TextSize=12
        descLabel.TextColor3=CONFIG.THEME.TEXT_DIM; descLabel.TextXAlignment=Enum.TextXAlignment.Left
        descLabel.TextYAlignment=Enum.TextYAlignment.Top; descLabel.TextWrapped=true
        descLabel.ZIndex=4; descLabel.Parent=content
        bigBtn=Instance.new("TextButton")
        bigBtn.Size=UDim2.new(1,-60,0,60); bigBtn.Position=UDim2.new(0,30,1,-100)
        bigBtn.BackgroundColor3=CONFIG.THEME.CARD_BG; bigBtn.Text="开启飞行"
        bigBtn.Font=Enum.Font.GothamBold; bigBtn.TextSize=17
        bigBtn.TextColor3=CONFIG.THEME.TEXT; bigBtn.AutoButtonColor=false
        bigBtn.ZIndex=4; bigBtn.Parent=content
        local bc=Instance.new("UICorner"); bc.CornerRadius=UDim.new(0,14); bc.Parent=bigBtn
        BindClick(bigBtn,function() safe("bigBtn",OnBigBtnClick) end)
        teleportPanel=Instance.new("Frame")
        teleportPanel.Size=UDim2.new(1,-60,0,260); teleportPanel.Position=UDim2.new(0,30,0,150)
        teleportPanel.BackgroundTransparency=1; teleportPanel.ZIndex=4
        teleportPanel.Visible=false; teleportPanel.Parent=content
        teleportList=Instance.new("ScrollingFrame")
        teleportList.Size=UDim2.new(1,0,1,0); teleportList.BackgroundTransparency=1
        teleportList.BorderSizePixel=0; teleportList.ScrollBarThickness=4
        teleportList.ScrollBarImageColor3=CONFIG.THEME.ACCENT_GLOW
        teleportList.CanvasSize=UDim2.new(0,0,0,0); teleportList.AutomaticCanvasSize=Enum.AutomaticSize.Y
        teleportList.ZIndex=5; teleportList.Parent=teleportPanel
        local tl=Instance.new("UIListLayout")
        tl.SortOrder=Enum.SortOrder.LayoutOrder; tl.Padding=UDim.new(0,4); tl.Parent=teleportList
        coordsPanel=Instance.new("Frame")
        coordsPanel.Size=UDim2.new(1,-60,0,140); coordsPanel.Position=UDim2.new(0,30,0,150)
        coordsPanel.BackgroundColor3=CONFIG.THEME.CARD_BG; coordsPanel.BackgroundTransparency=0.1
        coordsPanel.BorderSizePixel=0; coordsPanel.ZIndex=4
        coordsPanel.Visible=false; coordsPanel.Parent=content
        local cpc=Instance.new("UICorner"); cpc.CornerRadius=UDim.new(0,12); cpc.Parent=coordsPanel
        coordsLabel=Instance.new("TextLabel")
        coordsLabel.Size=UDim2.new(1,-40,1,-60); coordsLabel.Position=UDim2.new(0,20,0,10)
        coordsLabel.BackgroundTransparency=1; coordsLabel.Text="X: 0\nY: 0\nZ: 0"
        coordsLabel.Font=Enum.Font.Code; coordsLabel.TextSize=15
        coordsLabel.TextColor3=CONFIG.THEME.ACCENT_GLOW; coordsLabel.TextXAlignment=Enum.TextXAlignment.Left
        coordsLabel.TextYAlignment=Enum.TextYAlignment.Top; coordsLabel.ZIndex=5; coordsLabel.Parent=coordsPanel
        local copyBtn=Instance.new("TextButton")
        copyBtn.Size=UDim2.new(1,-40,0,34); copyBtn.Position=UDim2.new(0,20,1,-44)
        copyBtn.BackgroundColor3=CONFIG.THEME.CARD_ON; copyBtn.Text="复制坐标"
        copyBtn.Font=Enum.Font.GothamBold; copyBtn.TextSize=14
        copyBtn.TextColor3=CONFIG.THEME.TEXT; copyBtn.AutoButtonColor=false
        copyBtn.ZIndex=5; copyBtn.Parent=coordsPanel
        local cbc=Instance.new("UICorner"); cbc.CornerRadius=UDim.new(0,10); cbc.Parent=copyBtn
        BindClick(copyBtn,function()
            PlayClick()
            local root=getRoot(); if not root then return end
            local p=root.Position
            local str=string.format("%.1f, %.1f, %.1f",p.X,p.Y,p.Z)
            pcall(function()
                if setclipboard then setclipboard(str)
                elseif toclipboard then toclipboard(str) end
            end)
            copyBtn.Text="已复制！ "..str
            task.delay(1.5,function() if copyBtn then copyBtn.Text="复制坐标" end end)
        end)
        serverInfoLabel=Instance.new("TextLabel")
        serverInfoLabel.Size=UDim2.new(0,200,0,90); serverInfoLabel.Position=UDim2.new(1,-220,1,-110)
        serverInfoLabel.BackgroundColor3=Color3.fromRGB(0,0,0); serverInfoLabel.BackgroundTransparency=0.3
        serverInfoLabel.Text=""; serverInfoLabel.Font=Enum.Font.Code; serverInfoLabel.TextSize=12
        serverInfoLabel.TextColor3=CONFIG.THEME.ACCENT_GLOW; serverInfoLabel.TextXAlignment=Enum.TextXAlignment.Left
        serverInfoLabel.TextYAlignment=Enum.TextYAlignment.Top; serverInfoLabel.Visible=false
        serverInfoLabel.ZIndex=500; serverInfoLabel.Parent=sg
        local sic=Instance.new("UICorner"); sic.CornerRadius=UDim.new(0,10); sic.Parent=serverInfoLabel
        local sis=Instance.new("UIStroke"); sis.Color=CONFIG.THEME.ACCENT_GLOW; sis.Thickness=1; sis.Transparency=0.5; sis.Parent=serverInfoLabel
        fovLabel=Instance.new("TextLabel")
        fovLabel.Size=UDim2.new(0,160,0,30); fovLabel.Position=UDim2.new(0,20,0,100)
        fovLabel.BackgroundColor3=Color3.fromRGB(0,0,0); fovLabel.BackgroundTransparency=0.3
        fovLabel.Text=""; fovLabel.Font=Enum.Font.Code; fovLabel.TextSize=12
        fovLabel.TextColor3=CONFIG.THEME.ACCENT_GLOW; fovLabel.Visible=false
        fovLabel.ZIndex=500; fovLabel.Parent=sg
        local flc=Instance.new("UICorner"); flc.CornerRadius=UDim.new(0,10); flc.Parent=fovLabel
        ball=Instance.new("TextButton")
        ball.Size=UDim2.new(0,54,0,54); ball.Position=GetBallDefaultPos(); ball.Text="N"
        ball.Font=Enum.Font.GothamBold; ball.TextSize=24
        ball.BackgroundColor3=CONFIG.THEME.CARD_ON; ball.TextColor3=Color3.fromRGB(255,255,255)
        ball.BorderSizePixel=0; ball.Visible=false; ball.ZIndex=1000; ball.Parent=sg
        local ballc=Instance.new("UICorner"); ballc.CornerRadius=UDim.new(1,0); ballc.Parent=ball
        BindClick(ball,function() safe("ball",UI_Show) end)
        local closeBtn=Instance.new("TextButton")
        closeBtn.Size=UDim2.new(0,30,0,30); closeBtn.Position=UDim2.new(1,-42,0,14)
        closeBtn.Text="✕"; closeBtn.Font=Enum.Font.GothamBold; closeBtn.TextSize=14
        closeBtn.BackgroundColor3=CONFIG.THEME.CARD_ON; closeBtn.TextColor3=CONFIG.THEME.TEXT
        closeBtn.BorderSizePixel=0; closeBtn.ZIndex=20; closeBtn.Parent=main
        local cbc2=Instance.new("UICorner"); cbc2.CornerRadius=UDim.new(1,0); cbc2.Parent=closeBtn
        BindClick(closeBtn,function() safe("close",UI_Hide) end)
        connections.hotkeys=UIS.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.KeyCode==CONFIG.TOGGLE_KEY then UI_Toggle()
            elseif i.KeyCode==CONFIG.RECALL_KEY then UI_Show() end
        end)
        SetupDrag()
        SwitchPage(GetPageIndex("Fly"))
        task.spawn(function()
            while running do
                task.wait(0.5)
                if State.Page==GetPageIndex("Teleport") and teleportPanel and teleportPanel.Visible then RefreshTeleportList() end
                if State.Page==GetPageIndex("Coords") and coordsLabel then
                    local root=getRoot()
                    if root then local p=root.Position
                        coordsLabel.Text=string.format("X: %.1f\nY: %.1f\nZ: %.1f",p.X,p.Y,p.Z)
                    end
                end
            end
        end)
    end)
    if not ok then warn("[NEXUS:UI_Init]",err) end
    return ok
end

local function Noclip_GetParts()
    local char=LP.Character; if not char then return {} end
    local parts={}
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            local skip=false; local par=p.Parent
            while par and par~=char do
                if par:IsA("Tool") or par:IsA("BackpackItem") then skip=true; break end
                par=par.Parent
            end
            if not skip then table.insert(parts,p) end
        end
    end
    return parts
end
local function Noclip_Restore()
    for _,p in pairs(noclipParts) do
        if p and p.Parent and p:GetAttribute("NX_Noclip") then
            local orig=p:GetAttribute("NX_OrigCollide")
            p.CanCollide=orig~=nil and orig or true
            p:SetAttribute("NX_Noclip",nil); p:SetAttribute("NX_OrigCollide",nil)
        end
    end
    noclipParts={}
end
local function Noclip_Enable() noclipParts=Noclip_GetParts(); State.Noclip=true end
local function Noclip_Disable() Noclip_Restore(); State.Noclip=false end
local function Noclip_Init()
    connections.charAddedN=LP.CharacterAdded:Connect(function() if State.Noclip then noclipParts=Noclip_GetParts() end end)
    connections.stepped=RunService.Stepped:Connect(function()
        if not State.Noclip then return end
        for _,p in pairs(noclipParts) do
            if p and p.Parent and p.CanCollide then
                if p:GetAttribute("NX_OrigCollide")==nil then p:SetAttribute("NX_OrigCollide",p.CanCollide) end
                p.CanCollide=false; p:SetAttribute("NX_Noclip",true)
            end
        end
    end)
end
Noclip_Toggle=function() if State.Noclip then Noclip_Disable() else Noclip_Enable() end end

Flight_Toggle=function()
    State.Fly=not State.Fly
    local hum=getHum(); local root=getRoot()
    if hum and root then
        if State.Fly then hum.PlatformStand=true; Noclip_Enable()
            root.CFrame=root.CFrame+Vector3.new(0,CONFIG.FLY_LIFT_OFFSET,0)
        else hum.PlatformStand=false; root.AssemblyLinearVelocity=V3_ZERO; Noclip_Disable() end
    end
end
local function Flight_Init()
    connections.render=RunService.RenderStepped:Connect(function(dt)
        if not State.Fly then return end
        local root=getRoot(); if not root then return end
        local cam=workspace.CurrentCamera
        local speed=CONFIG.FLY_SPEED_TIERS[State.FlySpeedTier] or 200
        local lift=CONFIG.LIFT_SPEED
        local move=Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move=move-Vector3.new(0,1,0) end
        if move.Magnitude>0 then
            local horiz=Vector3.new(move.X,0,move.Z); local vert=move.Y
            local vel=Vector3.new()
            if horiz.Magnitude>0 then vel=vel+horiz.Unit*speed end
            if vert~=0 then vel=vel+Vector3.new(0,vert*lift,0) end
            root.AssemblyLinearVelocity=vel
        else root.AssemblyLinearVelocity=V3_ZERO end
    end)
end

InfJump_Toggle=function() State.InfJump=not State.InfJump end
local function InfJump_Init()
    connections.infJump=UIS.JumpRequest:Connect(function()
        if not State.InfJump then return end
        local hum=getHum(); if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

WaterWalk_Toggle=function() State.WaterWalk=not State.WaterWalk end
local function WaterWalk_Init()
    local counter=0
    connections.waterWalk=RunService.Stepped:Connect(function()
        if not State.WaterWalk then return end
        counter=counter+1; if counter%3~=0 then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local region=Region3.new(hrp.Position-Vector3.new(3,5,3),hrp.Position+Vector3.new(3,0,3)):ExpandToGrid(4)
        local ok,mats=pcall(function() return workspace.Terrain:ReadVoxels(region,4) end)
        if not ok or not mats then return end
        local hasWater=false
        for x=1,mats.Size.X do for y=1,mats.Size.Y do for z=1,mats.Size.Z do
            if mats[x][y][z]==Enum.Material.Water then hasWater=true; break end
        end if hasWater then break end end if hasWater then break end end
        if hasWater then
            local vel=hrp.AssemblyLinearVelocity
            if vel.Y<0 then hrp.AssemblyLinearVelocity=Vector3.new(vel.X,0,vel.Z) end
        end
    end)
end

FreeCam_Toggle=function()
    State.FreeCam=not State.FreeCam
    local cam=workspace.CurrentCamera
    if State.FreeCam then
        FreeCamData.OrigType=cam.CameraType; FreeCamData.OrigSubj=cam.CameraSubject
        FreeCamData.Pos=cam.CFrame.Position
        local look=cam.CFrame.LookVector
        FreeCamData.Yaw=math.atan2(-look.X,-look.Z)
        FreeCamData.Pitch=math.asin(math.clamp(look.Y,-1,1))
        cam.CameraType=Enum.CameraType.Scriptable; UIS.MouseBehavior=Enum.MouseBehavior.LockCenter
    else
        cam.CameraType=FreeCamData.OrigType or Enum.CameraType.Custom
        if FreeCamData.OrigSubj then cam.CameraSubject=FreeCamData.OrigSubj end
        UIS.MouseBehavior=Enum.MouseBehavior.Default
    end
end
local function FreeCam_Init()
    connections.freeCamRender=RunService.RenderStepped:Connect(function(dt)
        if not State.FreeCam then return end
        local cam=workspace.CurrentCamera
        local rot=CFrame.fromEulerAnglesYXZ(FreeCamData.Pitch,FreeCamData.Yaw,0)
        local move=Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-rot.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-rot.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move=move-Vector3.new(0,1,0) end
        if move.Magnitude>0 then FreeCamData.Pos=FreeCamData.Pos+move.Unit*100*dt end
        cam.CFrame=CFrame.new(FreeCamData.Pos)*rot
    end)
    connections.freeCamMouse=UIS.InputChanged:Connect(function(input)
        if not State.FreeCam then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            FreeCamData.Yaw=FreeCamData.Yaw-input.Delta.X*0.005
            FreeCamData.Pitch=math.clamp(FreeCamData.Pitch-input.Delta.Y*0.005,-1.5,1.5)
        end
    end)
end

local SpeedBoostTiers={50,100,180}
SpeedBoost_Toggle=function()
    State.SpeedBoost=(State.SpeedBoost+1)%(#SpeedBoostTiers+1)
    local hum=getHum()
    if hum then
        if State.SpeedBoost==0 then hum.WalkSpeed=16
        else hum.WalkSpeed=SpeedBoostTiers[State.SpeedBoost] end
    end
end

Sprint_Toggle=function() State.Sprint=not State.Sprint end
local function Sprint_Init()
    connections.sprint=RunService.Heartbeat:Connect(function()
        if not State.Sprint then return end
        local hum=getHum(); if not hum then return end
        local current=hum.WalkSpeed
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            if current<CONFIG.SPRINT_SPEED and current>0 then hum.WalkSpeed=CONFIG.SPRINT_SPEED end
        else
            if current==CONFIG.SPRINT_SPEED then
                if State.SpeedBoost>0 then hum.WalkSpeed=SpeedBoostTiers[State.SpeedBoost]
                else hum.WalkSpeed=16 end
            end
        end
    end)
end

JumpBoost_Toggle=function()
    State.JumpBoost=not State.JumpBoost
    local hum=getHum()
    if hum then
        if State.JumpBoost then hum.JumpPower=CONFIG.JUMP_POWER; hum.UseJumpPower=true
        else hum.JumpPower=50; hum.UseJumpPower=false end
    end
end

Spider_Toggle=function() State.Spider=not State.Spider end
local function Spider_Init()
    local counter=0
    connections.spider=RunService.Heartbeat:Connect(function()
        if not State.Spider then return end
        counter=counter+1; if counter%4~=0 then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances={char}
        local dirs={hrp.CFrame.LookVector,-hrp.CFrame.LookVector,hrp.CFrame.RightVector,-hrp.CFrame.RightVector}
        for _,d in ipairs(dirs) do
            local hit=workspace:Raycast(hrp.Position,d*3,params)
            if hit then
                hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X,0,hrp.AssemblyLinearVelocity.Z)
                break
            end
        end
    end)
end

LowGrav_Toggle=function()
    State.LowGrav=not State.LowGrav
    if State.LowGrav then State.ZeroGrav=false; workspace.Gravity=CONFIG.LOW_GRAV
    else workspace.Gravity=196.2 end
end
ZeroGrav_Toggle=function()
    State.ZeroGrav=not State.ZeroGrav
    if State.ZeroGrav then State.LowGrav=false; workspace.Gravity=0
    else workspace.Gravity=196.2 end
end

AntiFall_Toggle=function() State.AntiFall=not State.AntiFall end
local function AntiFall_Init()
    connections.antiFall=RunService.Heartbeat:Connect(function()
        if not State.AntiFall then return end
        local root=getRoot(); if not root then return end
        if root.Position.Y<-100 then
            local spawn=workspace:FindFirstChildOfClass("SpawnLocation")
            if spawn then root.CFrame=spawn.CFrame+Vector3.new(0,5,0)
            else root.CFrame=CFrame.new(0,100,0) end
        end
    end)
end

ClickTP_Toggle=function() State.ClickTP=not State.ClickTP end
local function ClickTP_Init()
    connections.clickTP=UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        if not State.ClickTP then return end
        if input.KeyCode~=CONFIG.CLICK_TP_KEY then return end
        local mouse=LP:GetMouse(); local hit=mouse.Hit
        if hit then local root=getRoot()
            if root then root.CFrame=CFrame.new(hit.Position+Vector3.new(0,3,0)) end
        end
    end)
end
SpawnTP_Action=function()
    local root=getRoot(); if not root then return end
    local spawn=workspace:FindFirstChildOfClass("SpawnLocation")
    if spawn then root.CFrame=spawn.CFrame+Vector3.new(0,5,0)
    else root.CFrame=CFrame.new(0,100,0) end
end

FlyHotkey_Toggle=function() State.FlyHotkey=not State.FlyHotkey end
local function FlyHotkey_Init()
    connections.flyHotkey=UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        if not State.FlyHotkey then return end
        if input.KeyCode==CONFIG.FLY_SPEED_UP_KEY then
            State.FlySpeedTier=math.min(#CONFIG.FLY_SPEED_TIERS,State.FlySpeedTier+1)
        elseif input.KeyCode==CONFIG.FLY_SPEED_DOWN_KEY then
            State.FlySpeedTier=math.max(1,State.FlySpeedTier-1)
        end
    end)
end

NightVision_Toggle=function()
    State.NightVision=not State.NightVision
    if State.NightVision then
        if origLighting.Brightness==nil then
            origLighting.Brightness=Lighting.Brightness
            origLighting.Ambient=Lighting.Ambient
            origLighting.OutdoorAmbient=Lighting.OutdoorAmbient
        end
        Lighting.Brightness=CONFIG.NIGHT_BRIGHT
        Lighting.Ambient=CONFIG.NIGHT_AMBIENT
        Lighting.OutdoorAmbient=CONFIG.NIGHT_AMBIENT
    else
        if origLighting.Brightness then Lighting.Brightness=origLighting.Brightness end
        if origLighting.Ambient then Lighting.Ambient=origLighting.Ambient end
        if origLighting.OutdoorAmbient then Lighting.OutdoorAmbient=origLighting.OutdoorAmbient end
    end
end

local function ClearHighlights()
    for _,h in pairs(highlightObjs) do if h and h.Parent then h:Destroy() end end
    highlightObjs={}
end
local function CreateHighlight(char,color)
    local h=Instance.new("Highlight")
    h.FillColor=color; h.FillTransparency=0.5
    h.OutlineColor=color; h.OutlineTransparency=0
    h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee=char; h.Parent=char
    return h
end
local function RefreshHighlights()
    ClearHighlights()
    if not State.Highlight and not State.TeamHL then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local isTeam=plr.Team and plr.Team==LP.Team
            local color
            if State.TeamHL then color=isTeam and CONFIG.FRIENDLY_COLOR or CONFIG.ENEMY_COLOR
            else color=isTeam and CONFIG.FRIENDLY_COLOR or CONFIG.ACCENT_GLOW end
            table.insert(highlightObjs,CreateHighlight(plr.Character,color))
        end
    end
end
Highlight_Toggle=function() State.Highlight=not State.Highlight; RefreshHighlights() end
TeamHL_Toggle=function() State.TeamHL=not State.TeamHL; RefreshHighlights() end
local function Highlight_Init()
    connections.hlPlayerAdded=Players.PlayerAdded:Connect(function()
        task.wait(1); if State.Highlight or State.TeamHL then RefreshHighlights() end
    end)
    task.spawn(function()
        while running do task.wait(2)
            if State.Highlight or State.TeamHL then RefreshHighlights() end
        end
    end)
end

Radar_Toggle=function() State.Radar=not State.Radar end
local function Radar_Init()
    radarFrame=Instance.new("Frame")
    radarFrame.Size=UDim2.new(0,CONFIG.RADAR_SIZE,0,CONFIG.RADAR_SIZE)
    radarFrame.Position=UDim2.new(1,-CONFIG.RADAR_SIZE-20,0,60)
    radarFrame.BackgroundColor3=Color3.fromRGB(0,0,0); radarFrame.BackgroundTransparency=0.35
    radarFrame.BorderSizePixel=0; radarFrame.Visible=false; radarFrame.ZIndex=500; radarFrame.Parent=sg
    local rc=Instance.new("UICorner"); rc.CornerRadius=UDim.new(1,0); rc.Parent=radarFrame
    local rs=Instance.new("UIStroke"); rs.Color=CONFIG.THEME.ACCENT_GLOW; rs.Thickness=2; rs.Parent=radarFrame
    local center=Instance.new("Frame")
    center.Size=UDim2.new(0,6,0,6); center.Position=UDim2.new(0.5,-3,0.5,-3)
    center.BackgroundColor3=CONFIG.THEME.ACCENT_GLOW; center.BorderSizePixel=0; center.ZIndex=501; center.Parent=radarFrame
    local cc=Instance.new("UICorner"); cc.CornerRadius=UDim.new(1,0); cc.Parent=center
    radarCanvas=Instance.new("Frame")
    radarCanvas.Size=UDim2.new(1,0,1,0); radarCanvas.BackgroundTransparency=1
    radarCanvas.ZIndex=501; radarCanvas.Parent=radarFrame
    task.spawn(function()
        while running do
            task.wait(0.15)
            if State.Radar then
                radarFrame.Visible=true
                for _,c in ipairs(radarCanvas:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
                local myRoot=getRoot()
                if myRoot then
                    local myPos=myRoot.Position
                    local myLook=Cam.CFrame.LookVector
                    local angle=math.atan2(myLook.X,myLook.Z)
                    local cosA,sinA=math.cos(angle),math.sin(angle)
                    for _,plr in ipairs(Players:GetPlayers()) do
                        if plr~=LP and plr.Character then
                            local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local rel=hrp.Position-myPos
                                local relX=rel.X*cosA-rel.Z*sinA
                                local relZ=rel.X*sinA+rel.Z*cosA
                                local dist=math.sqrt(relX*relX+relZ*relZ)
                                if dist<=CONFIG.RADAR_RANGE then
                                    local dot=Instance.new("Frame")
                                    dot.Size=UDim2.new(0,6,0,6)
                                    dot.BackgroundColor3=(plr.Team and plr.Team==LP.Team) and CONFIG.FRIENDLY_COLOR or CONFIG.ENEMY_COLOR
                                    dot.BorderSizePixel=0; dot.ZIndex=502
                                    dot.Position=UDim2.new(0.5+relX/CONFIG.RADAR_RANGE*0.5-0.03,0,0.5+relZ/CONFIG.RADAR_RANGE*0.5-0.03,0)
                                    dot.Parent=radarCanvas
                                    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=dot
                                end
                            end
                        end
                    end
                end
            else radarFrame.Visible=false end
        end
    end)
end

NoFog_Toggle=function()
    State.NoFog=not State.NoFog
    if State.NoFog then
        if origLighting.FogEnd==nil then
            origLighting.FogEnd=Lighting.FogEnd
            origLighting.FogStart=Lighting.FogStart
            origLighting.FogColor=Lighting.FogColor
        end
        Lighting.FogEnd=100000; Lighting.FogStart=100000
    else
        if origLighting.FogEnd then Lighting.FogEnd=origLighting.FogEnd end
        if origLighting.FogStart then Lighting.FogStart=origLighting.FogStart end
        if origLighting.FogColor then Lighting.FogColor=origLighting.FogColor end
    end
end

local function ClearTracers()
    for _,t in pairs(tracerObjs) do if t and t.Parent then t:Destroy() end end
    tracerObjs={}
end
local function CreateTracer(plr,char)
    local head=char:FindFirstChild("Head"); if not head then return end
    local att0=Instance.new("Attachment"); att0.Parent=head
    local att1=Instance.new("Attachment")
    local myHead=LP.Character and LP.Character:FindFirstChild("Head")
    if myHead then att1.Parent=myHead else att1.Parent=head end
    local beam=Instance.new("Beam")
    beam.Attachment0=att0; beam.Attachment1=att1
    beam.FaceCamera=true; beam.Width0=0.15; beam.Width1=0.15
    beam.Color=ColorSequence.new(CONFIG.TRACER_COLOR)
    beam.Transparency=NumberSequence.new(0.3)
    beam.LightEmission=1; beam.Parent=att0
    tracerObjs[beam]={att0=att0,att1=att1,beam=beam}
end
Tracer_Toggle=function()
    State.Tracer=not State.Tracer
    ClearTracers()
    if not State.Tracer then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then CreateTracer(plr,plr.Character) end
    end
end
local function Tracer_Init()
    task.spawn(function()
        while running do
            task.wait(1)
            if State.Tracer then
                local myHead=LP.Character and LP.Character:FindFirstChild("Head")
                if myHead then
                    for beam,data in pairs(tracerObjs) do
                        if beam and beam.Parent and data.att1 then data.att1.Parent=myHead end
                    end
                end
                for _,plr in ipairs(Players:GetPlayers()) do
                    if plr~=LP and plr.Character then
                        local head=plr.Character:FindFirstChild("Head")
                        if head and not head:FindFirstChildOfClass("Attachment") then
                            CreateTracer(plr,plr.Character)
                        end
                    end
                end
            end
        end
    end)
end

PlayerInfo_Toggle=function() State.PlayerInfo=not State.PlayerInfo end

TrackArrow_Toggle=function() State.TrackArrow=not State.TrackArrow end
local function TrackArrow_Init()
    task.spawn(function()
        while running do
            task.wait(0.3)
            if State.TrackArrow then
                for _,a in pairs(arrowObjs) do if a and a.Parent then a:Destroy() end end
                arrowObjs={}
                local myRoot=getRoot()
                if myRoot then
                    for _,plr in ipairs(Players:GetPlayers()) do
                        if plr~=LP and plr.Character then
                            local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local screenPos,onScreen=Cam:WorldToViewportPoint(hrp.Position)
                                if not onScreen then
                                    local arrow=Instance.new("TextLabel")
                                    arrow.Size=UDim2.new(0,30,0,30)
                                    arrow.Position=UDim2.new(0.5,-15,0.5,-15)
                                    arrow.BackgroundTransparency=1; arrow.Text="➨"
                                    arrow.Font=Enum.Font.GothamBold; arrow.TextSize=24
                                    arrow.TextColor3=CONFIG.ACCENT_GLOW; arrow.TextStrokeTransparency=0.3
                                    arrow.ZIndex=500; arrow.Parent=sg
                                    table.insert(arrowObjs,arrow)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

ESPRange_Toggle=function()
    selectedESPIdx=(selectedESPIdx%#ESPRANGE_TIERS)+1
    CONFIG.ESP_RANGE=ESPRANGE_TIERS[selectedESPIdx]
end

Crosshair_Toggle=function()
    State.Crosshair=not State.Crosshair
    if State.Crosshair then
        if not crosshairFrame then
            crosshairFrame=Instance.new("Frame")
            crosshairFrame.Size=UDim2.new(0,30,0,30)
            crosshairFrame.Position=UDim2.new(0.5,-15,0.5,-15)
            crosshairFrame.BackgroundTransparency=1; crosshairFrame.ZIndex=999; crosshairFrame.Parent=sg
            local h=Instance.new("Frame")
            h.Size=UDim2.new(1,0,0,2); h.Position=UDim2.new(0,0,0.5,-1)
            h.BackgroundColor3=CONFIG.THEME.ACCENT_GLOW; h.BorderSizePixel=0; h.Parent=crosshairFrame
            local v=Instance.new("Frame")
            v.Size=UDim2.new(0,2,1,0); v.Position=UDim2.new(0.5,-1,0,0)
            v.BackgroundColor3=CONFIG.THEME.ACCENT_GLOW; v.BorderSizePixel=0; v.Parent=crosshairFrame
        end
        crosshairFrame.Visible=true
    else
        if crosshairFrame then crosshairFrame.Visible=false end
    end
end

Ring_Toggle=function()
    State.Ring=not State.Ring
    if State.Ring then
        if not ringPart then
            ringPart=Instance.new("Part")
            ringPart.Shape=Enum.PartType.Cylinder
            ringPart.Size=Vector3.new(0.2,CONFIG.RING_RADIUS,CONFIG.RING_RADIUS)
            ringPart.Anchored=true; ringPart.CanCollide=false
            ringPart.Transparency=0.4; ringPart.Color=CONFIG.THEME.ACCENT_GLOW
            ringPart.Material=Enum.Material.Neon; ringPart.Parent=workspace
        end
        ringPart.Transparency=0.4
    else
        if ringPart then ringPart.Transparency=1 end
    end
end

Vignette_Toggle=function()
    State.Vignette=not State.Vignette
    if State.Vignette then
        if not vignetteFrame then
            vignetteFrame=Instance.new("Frame")
            vignetteFrame.Size=UDim2.new(1,0,1,0); vignetteFrame.BackgroundTransparency=1
            vignetteFrame.ZIndex=0; vignetteFrame.Parent=sg
            local function makeSide(pos,size,gradRot)
                local f=Instance.new("Frame")
                f.Size=size; f.Position=pos
                f.BackgroundColor3=Color3.fromRGB(0,0,0)
                f.BackgroundTransparency=1-CONFIG.VIGNETTE_STRENGTH
                f.BorderSizePixel=0; f.Parent=vignetteFrame
                local g=Instance.new("UIGradient")
                g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
                g.Rotation=gradRot; g.Parent=f
            end
            makeSide(UDim2.new(0,0,0,0),UDim2.new(1,0,0,80),90)
            makeSide(UDim2.new(0,0,1,-80),UDim2.new(1,0,0,80),-90)
            makeSide(UDim2.new(0,0,0,0),UDim2.new(0,80,1,0),0)
            makeSide(UDim2.new(1,-80,0,0),UDim2.new(0,80,1,0),180)
        end
        vignetteFrame.Visible=true
    else
        if vignetteFrame then vignetteFrame.Visible=false end
    end
end

Scanline_Toggle=function()
    State.Scanline=not State.Scanline
    if State.Scanline then
        if not scanlineFrame then
            scanlineFrame=Instance.new("Frame")
            scanlineFrame.Size=UDim2.new(1,0,1,0); scanlineFrame.BackgroundTransparency=1
            scanlineFrame.ZIndex=998; scanlineFrame.Parent=sg
            for i=0,80 do
                local line=Instance.new("Frame")
                line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,i/80,0)
                line.BackgroundColor3=Color3.fromRGB(0,0,0)
                line.BackgroundTransparency=0.9; line.BorderSizePixel=0
                line.Parent=scanlineFrame
            end
        end
        scanlineFrame.Visible=true
    else
        if scanlineFrame then scanlineFrame.Visible=false end
    end
end

SnowScreen_Toggle=function()
    State.SnowScreen=not State.SnowScreen
    if State.SnowScreen then
        if not snowFrame then
            snowFrame=Instance.new("Frame")
            snowFrame.Size=UDim2.new(1,0,1,0)
            snowFrame.BackgroundColor3=Color3.fromRGB(255,255,255)
            snowFrame.BackgroundTransparency=0.92; snowFrame.BorderSizePixel=0
            snowFrame.ZIndex=997; snowFrame.Parent=sg
            task.spawn(function()
                while State.SnowScreen and snowFrame do
                    snowFrame.BackgroundTransparency=0.88+math.random()*0.08
                    task.wait(0.05)
                end
            end)
        end
        snowFrame.Visible=true
    else
        if snowFrame then snowFrame.Visible=false end
    end
end

TargetBox_Toggle=function()
    State.TargetBox=not State.TargetBox
    if not State.TargetBox and lockBox then lockBox:Destroy(); lockBox=nil end
end
local function TargetBox_Update()
    if not State.TargetBox then return end
    local closest,minDist=nil,math.huge
    local myRoot=getRoot(); if not myRoot then return end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local hrp=plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d=(hrp.Position-myRoot.Position).Magnitude
                if d<minDist then minDist=d; closest=plr end
            end
        end
    end
    if closest and closest.Character then
        local head=closest.Character:FindFirstChild("Head")
        if head then
            if not lockBox then
                lockBox=Instance.new("SelectionBox")
                lockBox.Color3=CONFIG.ACCENT_GLOW; lockBox.LineThickness=0.05
                lockBox.SurfaceTransparency=1; lockBox.Parent=head
            end
            lockBox.Adornee=head; lockBox.Visible=true
        end
    else
        if lockBox then lockBox.Visible=false end
    end
end

NameStroke_Toggle=function()
    State.NameStroke=not State.NameStroke
    if State.ESP then ESP_Clear() end
end

ScreenBlur_Toggle=function()
    State.ScreenBlur=not State.ScreenBlur
    if State.ScreenBlur then
        if not blurEffect then
            blurEffect=Instance.new("BlurEffect")
            blurEffect.Size=CONFIG.SCREENBLUR_INTENSITY
            blurEffect.Parent=Lighting
        end
        blurEffect.Enabled=true
    else
        if blurEffect then blurEffect.Enabled=false end
    end
end

local colorFilters={
    {Color3.fromRGB(255,255,255),0},
    {Color3.fromRGB(255,200,150),0.3},
    {Color3.fromRGB(150,200,255),0.3},
    {Color3.fromRGB(255,150,255),0.3},
    {Color3.fromRGB(150,255,200),0.3},
}
ColorFilter_Toggle=function()
    State.ColorFilter=not State.ColorFilter
    if not State.ColorFilter then
        if colorCorrection then colorCorrection.Enabled=false end
        colorFilterIdx=1; return
    end
    colorFilterIdx=(colorFilterIdx%#colorFilters)+1
    local cf=colorFilters[colorFilterIdx]
    if not colorCorrection then
        colorCorrection=Instance.new("ColorCorrectionEffect")
        colorCorrection.Parent=Lighting
    end
    colorCorrection.TintColor=cf[1]
    colorCorrection.Saturation=cf[2]
    colorCorrection.Enabled=true
end

Fisheye_Toggle=function()
    State.Fisheye=not State.Fisheye
    if State.Fisheye then
        if origFOV==nil then origFOV=Cam.FieldOfView end
        Cam.FieldOfView=140
    else
        if origFOV then Cam.FieldOfView=origFOV end
    end
end

Aura_Toggle=function()
    State.Aura=not State.Aura
    if State.Aura then
        local char=LP.Character
        if char then
            local hrp=char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not auraEmitter then
                    auraEmitter=Instance.new("ParticleEmitter")
                    auraEmitter.Texture="rbxassetid://243660364"
                    auraEmitter.Rate=CONFIG.AURA_PARTICLE_COUNT
                    auraEmitter.Lifetime=NumberRange.new(1,2)
                    auraEmitter.Speed=NumberRange.new(0,2)
                    auraEmitter.SpreadAngle=Vector2.new(180,180)
                    auraEmitter.Size=NumberSequence.new(0.5)
                    auraEmitter.Color=ColorSequence.new(CONFIG.ACCENT_GLOW)
                    auraEmitter.LightEmission=1; auraEmitter.Parent=hrp
                end
                auraEmitter.Enabled=true
            end
        end
    else
        if auraEmitter then auraEmitter.Enabled=false end
    end
end

CharScale_Toggle=function()
    local sizes=CONFIG.CHAR_SCALE_SIZES
    local curIdx=1
    for i,s in ipairs(sizes) do if s==State.CharScale then curIdx=i end end
    curIdx=(curIdx%#sizes)+1
    State.CharScale=sizes[curIdx]
    local char=LP.Character; if not char then return end
    for _,part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
            local origSize=part:GetAttribute("NX_OrigSize")
            if not origSize then part:SetAttribute("NX_OrigSize",part.Size); origSize=part.Size end
            part.Size=origSize*State.CharScale
        end
    end
end

Transparent_Toggle=function()
    State.Transparent=not State.Transparent
    local char=LP.Character
    if char then
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
                part.LocalTransparencyModifier=State.Transparent and 0.5 or 0
            end
        end
    end
end

Rainbow_Toggle=function()
    State.Rainbow=not State.Rainbow
    local char=LP.Character
    if char and not State.Rainbow then
        for _,part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part:GetAttribute("NX_OrigColor") then
                part.Color=part:GetAttribute("NX_OrigColor")
                part:SetAttribute("NX_OrigColor",nil)
            end
        end
    end
end

Outline_Toggle=function()
    State.Outline=not State.Outline
    local char=LP.Character; if not char then return end
    if State.Outline then
        if not char:FindFirstChild("NX_Outline") then
            local h=Instance.new("Highlight")
            h.Name="NX_Outline"; h.FillTransparency=1
            h.OutlineColor=CONFIG.ACCENT_GLOW; h.OutlineTransparency=0
            h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
            h.Adornee=char; h.Parent=char
        end
    else
        local h=char:FindFirstChild("NX_Outline")
        if h then h:Destroy() end
    end
end

CharRotate_Toggle=function() State.CharRotate=not State.CharRotate end

LimbStretch_Toggle=function()
    State.LimbStretch=not State.LimbStretch
    local char=LP.Character; if not char then return end
    local limbNames={"Left Arm","Right Arm","Left Leg","Right Leg",
        "LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm",
        "LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg"}
    for _,part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            for _,name in ipairs(limbNames) do
                if part.Name==name then
                    local origSize=part:GetAttribute("NX_OrigSize")
                    if not origSize then part:SetAttribute("NX_OrigSize",part.Size); origSize=part.Size end
                    if State.LimbStretch then part.Size=origSize+Vector3.new(0,2,0)
                    else part.Size=origSize end
                end
            end
        end
    end
end

NoFX_Toggle=function()
    State.NoFX=not State.NoFX
    if State.NoFX then
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                if obj.Enabled then obj.Enabled=false; table.insert(hiddenFX,obj) end
            end
        end
    else
        for _,obj in ipairs(hiddenFX) do if obj and obj.Parent then obj.Enabled=true end end
        hiddenFX={}
    end
end

ServerInfo_Toggle=function()
    State.ServerInfo=not State.ServerInfo
    if serverInfoLabel then serverInfoLabel.Visible=State.ServerInfo end
end
local function ServerInfo_Init()
    task.spawn(function()
        while running do
            task.wait(1)
            if State.ServerInfo and serverInfoLabel then
                local players=#Players:GetPlayers()
                local ping=0
                local ok,p=pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
                if ok and p then ping=math.floor(p) end
                serverInfoLabel.Text=string.format("服务器信息\n玩家人数: %d\n延迟: %d ms",players,ping)
            end
        end
    end)
end

RGBBall_Toggle=function() State.RGBBall=not State.RGBBall end
local function RGBBall_Init()
    task.spawn(function()
        while running do
            task.wait(CONFIG.RGB_CYCLE_SPEED)
            if State.RGBBall and ball then
                rgbHue=(rgbHue+0.01)%1
                ball.BackgroundColor3=Color3.fromHSV(rgbHue,0.8,1)
            end
        end
    end)
end

AntiAFK_Toggle=function() State.AntiAFK=not State.AntiAFK end
local function AntiAFK_Init()
    task.spawn(function()
        while running do
            task.wait(CONFIG.ANTI_AFK_INTERVAL)
            if State.AntiAFK then
                local char=LP.Character
                if char then
                    local root=char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local origCF=root.CFrame
                        root.CFrame=origCF+Vector3.new(
                            (math.random()-0.5)*CONFIG.ANTI_AFK_MOVE_AMOUNT,0,
                            (math.random()-0.5)*CONFIG.ANTI_AFK_MOVE_AMOUNT)
                        task.wait(0.1)
                        if root and root.Parent then root.CFrame=origCF end
                    end
                end
            end
        end
    end)
end

local function ESP_Clear()
    for bill,_ in pairs(ESPHolders) do if bill and bill.Parent then bill:Destroy() end end
    ESPHolders={}
end
local function ESP_Create(plr,char)
    local head=char:FindFirstChild("Head"); if not head then return end
    local isTeam=plr.Team and plr.Team==LP.Team
    local bill=Instance.new("BillboardGui")
    bill.Name="ESP_NEXUS"; bill.Size=UDim2.new(0,120,0,80)
    bill.StudsOffset=Vector3.new(0,3,0); bill.AlwaysOnTop=true
    bill.Adornee=head; bill.Parent=head
    local nameLbl=Instance.new("TextLabel")
    nameLbl.Name="ESP_Name"; nameLbl.Size=UDim2.new(1,0,0.3,0)
    nameLbl.BackgroundTransparency=1; nameLbl.Text=plr.Name
    nameLbl.TextColor3=isTeam and CONFIG.THEME.GREEN or CONFIG.THEME.ACCENT_GLOW
    nameLbl.TextStrokeTransparency=(State.NameStroke and 0 or 1)
    nameLbl.Font=Enum.Font.GothamBold; nameLbl.TextSize=14; nameLbl.Parent=bill
    local distLbl=Instance.new("TextLabel")
    distLbl.Name="ESP_Dist"; distLbl.Size=UDim2.new(1,0,0.25,0)
    distLbl.Position=UDim2.new(0,0,0.3,0); distLbl.BackgroundTransparency=1
    distLbl.Text="0m"; distLbl.TextColor3=Color3.fromRGB(255,255,255)
    distLbl.Font=Enum.Font.Gotham; distLbl.TextSize=12; distLbl.Parent=bill
    local infoLbl=Instance.new("TextLabel")
    infoLbl.Name="ESP_Info"; infoLbl.Size=UDim2.new(1,0,0.25,0)
    infoLbl.Position=UDim2.new(0,0,0.55,0); infoLbl.BackgroundTransparency=1
    infoLbl.Text=""; infoLbl.TextColor3=Color3.fromRGB(200,220,255)
    infoLbl.Font=Enum.Font.Gotham; infoLbl.TextSize=10; infoLbl.Parent=bill
    ESPHolders[bill]=true
end
local function ESP_IsVisible(head)
    if not State.ESPVisibleOnly then return true end
    local char=getChar(); if not char then return true end
    local delta=head.Position-Cam.CFrame.Position
    local dist=delta.Magnitude
    if dist<0.1 then return true end
    local dir=delta/dist
    return not raycastBlocked(Cam.CFrame.Position,Cam.CFrame.Position+dir*300,{char,head.Parent})
end
ESP_Toggle=function() State.ESP=not State.ESP; if not State.ESP then ESP_Clear() end end
ESP_ToggleVisible=function() State.ESPVisibleOnly=not State.ESPVisibleOnly; if State.ESP then ESP_Clear() end end
local function ESP_Init()
    local function hook(plr)
        if plr==LP then return end
        plr.CharacterAdded:Connect(function(char)
            if not State.ESP then return end
            task.wait(0.1)
            if State.ESP and char.Parent then ESP_Create(plr,char) end
        end)
    end
    for _,p in pairs(Players:GetPlayers()) do hook(p) end
    connections.playerAddedESP=Players.PlayerAdded:Connect(hook)
    connections.playerRemovingESP=Players.PlayerRemoving:Connect(function(plr)
        if plr.Character then
            local head=plr.Character:FindFirstChild("Head")
            if head then
                local bill=head:FindFirstChild("ESP_NEXUS")
                if bill then bill:Destroy(); ESPHolders[bill]=nil end
            end
        end
    end)
    task.spawn(function()
        while running do
            local s=pcall(function()
                if State.ESP then
                    -- ★ 补丁 7：ESP 自适应范围
                    local myRoot2=getRoot()
                    if myRoot2 and myRoot2.Position.Y>100 then
                        CONFIG.ESP_RANGE=math.max(CONFIG.ESP_RANGE,150)
                    end
                    local root=getRoot()
                    if root then
                        local mp=root.Position
                        local toRemove={}
                        for bill,_ in pairs(ESPHolders) do
                            if not bill or not bill.Parent then table.insert(toRemove,bill) end
                        end
                        for _,b in ipairs(toRemove) do ESPHolders[b]=nil end
                        for _,p in pairs(Players:GetPlayers()) do
                            if p~=LP and p.Character then
                                local char=p.Character
                                local head=char:FindFirstChild("Head")
                                local hroot=char:FindFirstChild("HumanoidRootPart")
                                if head and hroot then
                                    local dist=(hroot.Position-mp).Magnitude
                                    if dist<=CONFIG.ESP_RANGE and ESP_IsVisible(head) then
                                        local bill=head:FindFirstChild("ESP_NEXUS")
                                        if not bill then ESP_Create(p,char)
                                        else
                                            local d=bill:FindFirstChild("ESP_Dist")
                                            if d then d.Text=math.floor(dist).."m" end
                                            if State.PlayerInfo then
                                                local info=bill:FindFirstChild("ESP_Info")
                                                if info then
                                                    local hum=char:FindFirstChildOfClass("Humanoid")
                                                    local hp=hum and math.floor(hum.Health) or 0
                                                    local team=p.Team and p.Team.Name or "无"
                                                    info.Text="HP: "..hp.." | "..team
                                                end
                                            end
                                        end
                                    else
                                        local bill=head:FindFirstChild("ESP_NEXUS")
                                        if bill then bill:Destroy(); ESPHolders[bill]=nil end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if not s then task.wait(2) end
            -- ★ 补丁 2：ESP 节流
            local pCount=#Players:GetPlayers()
            task.wait(pCount>CONFIG.ESP_MAX_PLAYERS and CONFIG.ESP_REFRESH*2 or CONFIG.ESP_REFRESH)
        end
    end)
end

local function AttachHeadTag()
    if not CONFIG.HEAD_TAG_ENABLED then return end
    local char=LP.Character; if not char then return end
    local head=char:FindFirstChild("Head")
    if not head or head:FindFirstChild("NEXUS_Tag") then return end
    local bill=Instance.new("BillboardGui")
    bill.Name="NEXUS_Tag"; bill.Size=UDim2.new(0,220,0,30)
    bill.StudsOffset=Vector3.new(0,3,0); bill.AlwaysOnTop=true
    bill.Adornee=head; bill.Parent=head
    local lbl=Instance.new("TextLabel")
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.Text=CONFIG.HEAD_TAG_TEXT; lbl.TextColor3=CONFIG.HEAD_TAG_COLOR
    lbl.TextStrokeTransparency=0.2; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=18; lbl.Parent=bill
end
local function StartHeadTag()
    if not CONFIG.HEAD_TAG_ENABLED then return end
    AttachHeadTag()
    connections.headTag=LP.CharacterAdded:Connect(function()
        task.wait(1); AttachHeadTag()
    end)
end

-- ★ 补丁 5：角色重生恢复
local function OnCharacterRespawn()
    task.wait(1.5)
    local hum=getHum(); local char=LP.Character
    if not hum or not char then return end
    if State.SpeedBoost>0 then
        local t={50,100,180}
        hum.WalkSpeed=t[State.SpeedBoost] or 16
    end
    if State.JumpBoost then hum.JumpPower=CONFIG.JUMP_POWER; hum.UseJumpPower=true end
    if State.Transparent then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                p.LocalTransparencyModifier=0.5
            end
        end
    end
    if State.Outline and not char:FindFirstChild("NX_Outline") then
        local h=Instance.new("Highlight")
        h.Name="NX_Outline"; h.FillTransparency=1
        h.OutlineColor=CONFIG.ACCENT_GLOW; h.OutlineTransparency=0
        h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee=char; h.Parent=char
    end
    if State.Noclip then noclipParts=Noclip_GetParts() end
end
connections.respawn=LP.CharacterAdded:Connect(OnCharacterRespawn)

FOV_Toggle=function()
    State.FOV=not State.FOV
    if State.FOV then
        if origFOV==nil then origFOV=Cam.FieldOfView end
        Cam.FieldOfView=100
        if fovLabel then fovLabel.Visible=true; fovLabel.Text="FOV: 100" end
    else
        if origFOV then Cam.FieldOfView=origFOV end
        if fovLabel then fovLabel.Visible=false end
    end
end
ClickPart_Toggle=function() State.ClickPart=not State.ClickPart end
local function ClickPart_Init()
    connections.clickPart=UIS.InputBegan:Connect(function(input,gp)
        if gp then return end
        if not State.ClickPart then return end
        if input.UserInputType~=Enum.UserInputType.MouseButton1 then return end
        local mouse=LP:GetMouse(); local target=mouse.Target
        if target then
            print("[NEXUS] 部件名:",target.Name,"| 类:",target.ClassName)
            if target.Material then print("[NEXUS] 材质:",target.Material.Name) end
        end
    end)
end
MapBounds_Toggle=function()
    State.MapBounds=not State.MapBounds
    if State.MapBounds then
        if not mapBoundsBox then
            mapBoundsBox=Instance.new("SelectionBox")
            mapBoundsBox.Color3=CONFIG.ACCENT_GLOW; mapBoundsBox.LineThickness=0.1
            mapBoundsBox.SurfaceTransparency=1
            local bounds=Instance.new("Part")
            bounds.Size=Vector3.new(2048,2048,2048); bounds.Anchored=true
            bounds.CanCollide=false; bounds.Transparency=1
            bounds.Position=Vector3.new(0,0,0); bounds.Parent=workspace
            mapBoundsBox.Adornee=bounds; mapBoundsBox.Parent=bounds
        end
        mapBoundsBox.Visible=true
    else
        if mapBoundsBox then mapBoundsBox.Visible=false end
    end
end

local function FirstWave_Update()
    if State.Ring and ringPart then
        local root=getRoot()
        if root then ringPart.CFrame=CFrame.new(root.Position-Vector3.new(0,3,0))*CFrame.Angles(0,0,math.rad(90)) end
    end
    if State.Rainbow then
        rainbowIdx=(rainbowIdx+0.005)%1
        local color=Color3.fromHSV(rainbowIdx,0.8,1)
        local char=LP.Character
        if char then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
                    if not part:GetAttribute("NX_OrigColor") then part:SetAttribute("NX_OrigColor",part.Color) end
                    part.Color=color
                end
            end
        end
    end
    if State.CharRotate then
        local root=getRoot()
        if root then root.CFrame=root.CFrame*CFrame.Angles(0,math.rad(charRotSpeed),0) end
    end
    if State.TargetBox then TargetBox_Update() end
end
local function FirstWave_Init()
    connections.firstWave=RunService.Heartbeat:Connect(FirstWave_Update)
end

Master_AllOff=function()
    State.Fly=false; State.Noclip=false; State.ESP=false
    State.FlySpeedTier=2; State.ESPVisibleOnly=false
    State.InfJump=false; State.WaterWalk=false
    State.SpeedBoost=0; State.Sprint=false; State.JumpBoost=false
    State.Spider=false; State.LowGrav=false; State.ZeroGrav=false
    State.AntiFall=false; State.ClickTP=false
    State.NightVision=false; State.Highlight=false; State.Radar=false
    State.NoFog=false; State.NoFX=false; State.ServerInfo=false; State.RGBBall=false
    State.Tracer=false; State.PlayerInfo=false; State.TeamHL=false
    State.TrackArrow=false; State.FOV=false; State.ClickPart=false; State.FlyHotkey=false
    State.MapBounds=false; State.AntiAFK=false
    State.Crosshair=false; State.Ring=false; State.Vignette=false
    State.Scanline=false; State.SnowScreen=false; State.TargetBox=false; State.NameStroke=false
    State.ScreenBlur=false; State.ColorFilter=false; State.Fisheye=false
    State.Aura=false; State.CharScale=1; State.Transparent=false
    State.Rainbow=false; State.Outline=false; State.CharRotate=false; State.LimbStretch=false
    if State.FreeCam then FreeCam_Toggle() end
    local hum=getHum()
    if hum then hum.PlatformStand=false; hum.WalkSpeed=16; hum.JumpPower=50; hum.UseJumpPower=false end
    local root=getRoot()
    if root then root.AssemblyLinearVelocity=V3_ZERO end
    workspace.Gravity=196.2
    if origLighting.Brightness then Lighting.Brightness=origLighting.Brightness end
    if origLighting.Ambient then Lighting.Ambient=origLighting.Ambient end
    if origLighting.OutdoorAmbient then Lighting.OutdoorAmbient=origLighting.OutdoorAmbient end
    if origLighting.FogEnd then Lighting.FogEnd=origLighting.FogEnd end
    if origLighting.FogStart then Lighting.FogStart=origLighting.FogStart end
    if origFOV then Cam.FieldOfView=origFOV end
    Noclip_Restore(); ESP_Clear(); ClearHighlights(); ClearTracers()
    for _,obj in ipairs(hiddenFX) do if obj and obj.Parent then obj.Enabled=true end end
    hiddenFX={}
    if serverInfoLabel then serverInfoLabel.Visible=false end
    if radarFrame then radarFrame.Visible=false end
    if fovLabel then fovLabel.Visible=false end
    for _,a in pairs(arrowObjs) do if a and a.Parent then a:Destroy() end end
    arrowObjs={}
    if mapBoundsBox then mapBoundsBox.Visible=false end
    if crosshairFrame then crosshairFrame.Visible=false end
    if vignetteFrame then vignetteFrame.Visible=false end
    if scanlineFrame then scanlineFrame.Visible=false end
    if snowFrame then snowFrame.Visible=false end
    if ringPart then ringPart.Transparency=1 end
    if auraEmitter then auraEmitter.Enabled=false end
    if blurEffect then blurEffect.Enabled=false end
    if colorCorrection then colorCorrection.Enabled=false end
    if lockBox then lockBox:Destroy(); lockBox=nil end
    if LP.Character then
        local outline=LP.Character:FindFirstChild("NX_Outline")
        if outline then outline:Destroy() end
        for _,part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                local origSize=part:GetAttribute("NX_OrigSize")
                if origSize then part.Size=origSize; part:SetAttribute("NX_OrigSize",nil) end
                part.LocalTransparencyModifier=0
                local origColor=part:GetAttribute("NX_OrigColor")
                if origColor then part.Color=origColor; part:SetAttribute("NX_OrigColor",nil) end
            end
        end
    end
    SwitchPage(State.Page)
end

Master_Shutdown=function()
    running=false
    for k,c in pairs(connections) do
        safe("disconnect:"..k,function() c:Disconnect() end)
    end
    connections={}
    safe("destroyUI",function() if sg and sg.Parent then sg:Destroy() end end)
    safe("soundCleanup",function() if soundInst then soundInst:Destroy(); soundInst=nil end end)
    log("shutdown complete")
end

-- ★ 补丁 11：场景保护 + 自动降级
local lastPlaceId=game.PlaceId
task.spawn(function()
    while running do
        task.wait(2)
        if game.PlaceId~=lastPlaceId then
            lastPlaceId=game.PlaceId
            safe("sceneReset",function()
                if State.Fly then Flight_Toggle() end
                if State.Noclip then Noclip_Disable() end
                ESP_Clear()
            end)
        end
    end
end)

task.spawn(function()
    while running do
        RunService.Heartbeat:Wait()
        perfCheck.frameCount=perfCheck.frameCount+1
        local now=tick()
        if now-perfCheck.lastCheck>=1 then
            perfCheck.avgFPS=perfCheck.frameCount/(now-perfCheck.lastCheck)
            perfCheck.frameCount=0
            perfCheck.lastCheck=now
            if perfCheck.avgFPS<20 and not perfCheck.warned then
                perfCheck.warned=true
                warn("[NEXUS] 低帧率，建议关闭 ESP / 追踪线 / 雷达")
                task.delay(30,function() perfCheck.warned=false end)
            end
        end
    end
end)

ShowLoadingScreen()
task.wait(2.1)

local initList={
    Flight_Init,Noclip_Init,ESP_Init,InfJump_Init,WaterWalk_Init,
    FreeCam_Init,SpeedBoost_Init,Sprint_Init,JumpBoost_Init,
    Spider_Init,AntiFall_Init,ClickTP_Init,FlyHotkey_Init,
    Highlight_Init,Radar_Init,ServerInfo_Init,RGBBall_Init,
    AntiAFK_Init,Tracer_Init,TrackArrow_Init,ClickPart_Init,
    FirstWave_Init,StartHeadTag,
}

if UI_Init() then
    for _,f in ipairs(initList) do pcall(f) end
    StartTimeUpdater()
else
    for _,f in ipairs(initList) do pcall(f) end
end

log("NEXUS v"..VERSION.." loaded - Core Hub Ready")
