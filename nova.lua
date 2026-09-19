--!strict
-- APEX · HUB v8.3.1
local V="8.3.1"
local CFG={W=700,H=560,SB=210,FS={100,200,350,500},LS=150,ER=80,ERef=.3,EMP=20,TK=Enum.KeyCode.F,RK=Enum.KeyCode.Z,HTE=true,HTT="APEX · 用户",HTC=Color3.fromRGB(0,229,255),H24=false,HSS=true,BX=.5,BXO=-27,BY=0,BYO=20,BGI="rbxassetid://117756559340646",BGT=.15,FLO=3,JP=120,SS=90,LG=50,CTK=Enum.KeyCode.T,FUK=Enum.KeyCode.Q,FDK=Enum.KeyCode.E,NB=3,NA=Color3.fromRGB(190,190,190),RS=150,RR=200,AAI=30,AAM=.5,TC=Color3.fromRGB(0,229,255),FC=Color3.fromRGB(50,220,110),EC=Color3.fromRGB(255,59,48),RCS=.05,RRad=8,VS=.6,APC=20,CSS={.5,1,2,3},SBI=20,TH={OT=.45,SB=Color3.fromRGB(10,12,18),SA=Color3.fromRGB(0,40,55),AC=Color3.fromRGB(0,180,220),AG=Color3.fromRGB(0,229,255),TX=Color3.fromRGB(240,245,250),TD=Color3.fromRGB(120,140,160),GR=Color3.fromRGB(50,220,110),CB=Color3.fromRGB(18,22,30),CH=Color3.fromRGB(30,38,50),CO=Color3.fromRGB(0,180,220),CT=Color3.fromRGB(80,130,180),CR=12},L={BR="APEX",ST="HUB · v8.3.1",CM="【移动】",CV="【视觉】",CU="【辅助】",FL="飞行",NC="穿墙",SP="速度",SPB="速度增强",SR="极速冲刺",JB="跳跃增强",IJ="无限跳",FCM="自由视角",TP="传送",CTP="点击传送",STP="回出生点",WW="水上行走",SPD="蜘蛛侠",LGV="低重力",ZGV="零重力",FH="飞行热键",NV="夜视",HL="高亮玩家",RDR="雷达",NF="无雾",TRC="追踪线",PI="玩家信息",THL="队友敌人",TA="追踪箭头",ERg="ESP距离",CH="十字准星",RG="距离环",VG="暗角",SC="扫描线",SS="雪花屏",TB="目标锁定",NS="名称描边",SB="屏幕模糊",CFl="色彩滤镜",FE="鱼眼",ES="透视",ESV="仅可见",AU="粒子光环",CS="角色缩放",TR="透明化",RB="彩虹",OL="发光轮廓",CRt="角色旋转",LS2="四肢拉长",NFX="屏蔽特效",SI="服务器信息",RGB="RGB球",AFK="反挂机",AF="反掉落",CRD="坐标",FV="视角缩放",CP="点击显示",MB="地图边界",RJ="重新加入",RS2="重置",SD="关闭",ON="开",OFF="关",LD="APEX LOADING"}}
local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local SSvc=game:GetService("SoundService")
local TW=game:GetService("TweenService")
local LG=game:GetService("Lighting")
local ST=game:GetService("Stats")
local TS=game:GetService("TeleportService")
local LP=P.LocalPlayer
local CM=workspace.CurrentCamera
local S={FL=false,NC=false,ES=false,ESV=false,FST=2,VS=true,PG=1,IJ=false,WW=false,FCM=false,SPB=0,AF=false,JB=false,SPD=false,SR=false,LGV=false,ZGV=false,CTP=false,NV=false,HL=false,RDR=false,NF=false,NFX=false,SI=false,RGB=false,AFK=false,TRC=false,PI=false,THL=false,TA=false,FV=false,CP=false,FH=false,MB=false,CH=false,RG=false,VG=false,SC=false,SS=false,TB=false,NS=false,SB=false,CFl=false,FE=false,AU=false,CS=1,TR=false,RB=false,OL=false,CRt=false,LS2=false}
local FCam={OT=nil,OS=nil,Pos=Vector3.new(),Y=0,Pt=0}
local RUN=true
local EH={}
local HLO={}
local TRS={}
local ARR={}
local CN={}
local NIT={}
local SI_=nil
local RB2=nil
local NCP={}
local Hue=0
local OL2={B=nil,A=nil,OA=nil,FE=nil,FS=nil,FC=nil}
local OFOV=nil
local HFX={}
local OHLS={}
local RIdx=0
local CFIdx=1
local LB=nil
local RNG=nil
local AUE=nil
local BLE=nil
local CCE=nil
local CRF=nil
local VGF=nil
local SCF=nil
local SNF=nil
local CRS=3
local ERT={40,80,150,300}
local ESI=1
local Prf={FC=0,LC=tick(),FPS=60,Warned=false}

local function LOG(...) print("[APEX]",...) end
local EC_={}
local function SAFE(n,f) local ok,e=pcall(f); if not ok then EC_[n]=(EC_[n] or 0)+1; if EC_[n]<=10 then warn("[APEX:"..n.."]",e) end else EC_[n]=0 end end
local function GC() return LP.Character or LP.CharacterAdded:Wait() end
local function GR() local c=LP.Character return c and c:FindFirstChild("HumanoidRootPart") end
local function GH() local c=LP.Character return c and c:FindFirstChild("Humanoid") end

-- BindClick: input.Position 精准
local BC
do
    local BDS={}
    local LC=0
    BC=function(b,f) if not b then return end BDS[b]=f end
    U.InputBegan:Connect(function(i,p)
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        local n=tick()
        if n-LC<.15 then return end
        LC=n
        local pos=Vector2.new(i.Position.X,i.Position.Y)
        for b,f in pairs(BDS) do
            if b and b.Parent and b.Visible then
                local v=true
                local pp=b.Parent
                while pp and pp~=game do
                    if pp:IsA("GuiObject") and not pp.Visible then v=false break end
                    pp=pp.Parent
                end
                if v then
                    local ap=b.AbsolutePosition
                    local as=b.AbsoluteSize
                    if as.X>0 and as.Y>0 and pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then
                        pcall(f)
                        return
                    end
                end
            end
        end
    end)
end

do
    local ok=pcall(function() local p=RaycastParams.new() p.FilterType=Enum.RaycastFilterType.Exclude workspace:Raycast(Vector3.new(),Vector3.new(1,0,0),p) end)
    if ok then
        RB2=function(a,b,f)
            local c=GC() if not c then return false end
            local p=RaycastParams.new()
            p.FilterType=Enum.RaycastFilterType.Exclude
            p.FilterDescendantsInstances=f or {c}
            return workspace:Raycast(a,b-a,p)~=nil
        end
    else
        RB2=function(a,b,f)
            local d=b-a if d.Magnitude==0 then return false end
            local c=GC() if not c then return false end
            return workspace:FindPartOnRayWithIgnoreList(Ray.new(a,d),f or {c})~=nil
        end
    end
end
local VZ=Vector3.new()
local function GS()
    if not SI_ then
        SI_=Instance.new("Sound")
        SI_.SoundId="rbxassetid://9115509226"
        SI_.Volume=.2
        SI_.Parent=SSvc
    end
    return SI_
end
local function PC() SAFE("s",function() GS():Play() end) end

local SG,Main,SB,CT,TL,DL,BB,Ball
local NS_,NL,TLbl,TCap
local TPP,TPL,CP2,CL2
local RF,RD,SIL,FVL,MBB

local function GTS()
    local t=os.date("*t")
    if CFG.H24 then
        if CFG.HSS then return string.format("%02d:%02d:%02d",t.hour,t.min,t.sec) else return string.format("%02d:%02d",t.hour,t.min) end
    else
        local h=t.hour%12 if h==0 then h=12 end
        local ap=t.hour<12 and "上午" or "下午"
        if CFG.HSS then return string.format("%s %d:%02d:%02d",ap,h,t.min,t.sec) else return string.format("%s %d:%02d",ap,h,t.min) end
    end
end
local function GBDP() return UDim2.new(CFG.BX,CFG.BXO,CFG.BY,CFG.BYO) end

local function SLS()
    local ls=Instance.new("ScreenGui")
    ls.Name="ApexLoading" ls.ResetOnSpawn=false ls.DisplayOrder=10000 ls.Parent=LP:WaitForChild("PlayerGui")
    local bg=Instance.new("Frame") bg.Size=UDim2.new(1,0,1,0) bg.BackgroundColor3=Color3.fromRGB(0,0,0) bg.Parent=ls
    local lg=Instance.new("TextLabel") lg.Size=UDim2.new(0,400,0,80) lg.Position=UDim2.new(.5,-200,.5,-80) lg.BackgroundTransparency=1 lg.Text="APEX" lg.Font=Enum.Font.GothamBold lg.TextSize=64 lg.TextColor3=CFG.TH.AG lg.TextTransparency=1 lg.Parent=bg
    local sb=Instance.new("TextLabel") sb.Size=UDim2.new(0,400,0,20) sb.Position=UDim2.new(.5,-200,.5,10) sb.BackgroundTransparency=1 sb.Text="HUB · INITIALIZING" sb.Font=Enum.Font.Gotham sb.TextSize=12 sb.TextColor3=CFG.TH.TD sb.TextTransparency=1 sb.Parent=bg
    local bb=Instance.new("Frame") bb.Size=UDim2.new(0,300,0,3) bb.Position=UDim2.new(.5,-150,.5,60) bb.BackgroundColor3=Color3.fromRGB(30,40,55) bb.BackgroundTransparency=1 bb.Parent=bg
    local c=Instance.new("UICorner") c.CornerRadius=UDim.new(1,0) c.Parent=bb
    local bf=Instance.new("Frame") bf.Size=UDim2.new(0,0,1,0) bf.BackgroundColor3=CFG.TH.AG bf.Parent=bb
    local c2=Instance.new("UICorner") c2.CornerRadius=UDim.new(1,0) c2.Parent=bf
    local lt=Instance.new("TextLabel") lt.Size=UDim2.new(0,400,0,16) lt.Position=UDim2.new(.5,-200,.5,75) lt.BackgroundTransparency=1 lt.Text=CFG.L.LD lt.Font=Enum.Font.Gotham lt.TextSize=11 lt.TextColor3=CFG.TH.TD lt.TextTransparency=1 lt.Parent=bg
    TW:Create(lg,TweenInfo.new(.4),{TextTransparency=0}):Play()
    TW:Create(sb,TweenInfo.new(.5),{TextTransparency=0}):Play()
    TW:Create(bb,TweenInfo.new(.5),{BackgroundTransparency=0}):Play()
    TW:Create(lt,TweenInfo.new(.5),{TextTransparency=0}):Play()
    TW:Create(bf,TweenInfo.new(1.4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,1,0)}):Play()
    task.delay(1.6,function()
        TW:Create(bg,TweenInfo.new(.4),{BackgroundTransparency=1}):Play()
        TW:Create(lg,TweenInfo.new(.4),{TextTransparency=1}):Play()
        TW:Create(sb,TweenInfo.new(.4),{TextTransparency=1}):Play()
        TW:Create(bb,TweenInfo.new(.4),{BackgroundTransparency=1}):Play()
        TW:Create(lt,TweenInfo.new(.4),{TextTransparency=1}):Play()
        task.wait(.45)
        if ls and ls.Parent then ls:Destroy() end
    end)
end

local function STU()
    task.spawn(function()
        while RUN do
            pcall(function() if TLbl and TLbl.Parent then TLbl.Text=GTS() end end)
            task.wait(1)
        end
    end)
end
local function US()
    S.VS=true
    if Main then Main.Visible=true end
    if Ball then Ball.Visible=false end
    if Main then TW:Create(Main,TweenInfo.new(.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,CFG.W,0,CFG.H)}):Play() end
end
local function UH()
    S.VS=false
    if Main then TW:Create(Main,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,CFG.W,0,0)}):Play() end
    task.delay(.2,function()
        if not S.VS then
            if Main then Main.Visible=false end
            if Ball then Ball.Position=GBDP() Ball.Visible=true end
        end
    end)
end
local function UT() if S.VS then UH() else US() end end

local function SDR()
    local d=false
    local sx,sy,px,py=0,0,0,0
    local function cP()
        local sw=CM.ViewportSize.X
        local sh=CM.ViewportSize.Y
        local x=math.clamp(Main.Position.X.Offset,0,sw-CFG.W)
        local y=math.clamp(Main.Position.Y.Offset,0,sh-CFG.H)
        Main.Position=UDim2.new(0,x,0,y)
    end
    CN.db=U.InputBegan:Connect(function(i)
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        if not S.VS then return end
        local pos=i.Position
        local ap=Main.AbsolutePosition
        local as=Main.AbsoluteSize
        if pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then
            if pos.Y<=ap.Y+50 or (pos.X<=ap.X+CFG.SB and pos.Y<=ap.Y+90) or (pos.X>ap.X+CFG.SB+180 and pos.Y<ap.Y+as.Y-120) then
                d=true sx,sy=pos.X,pos.Y px,py=Main.Position.X.Offset,Main.Position.Y.Offset
            end
        end
    end)
    CN.de=U.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
    CN.dc=U.InputChanged:Connect(function(i)
        if not d then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position
        Main.Position=UDim2.new(0,px+(pos.X-sx),0,py+(pos.Y-sy))
        cP()
    end)
    local bd,bsx,bsy,bpx,bpy=false,0,0,0,0
    CN.bdb=U.InputBegan:Connect(function(i)
        if not Ball or not Ball.Visible then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position
        local ap=Ball.AbsolutePosition
        local as=Ball.AbsoluteSize
        if pos.X>=ap.X and pos.X<=ap.X+as.X and pos.Y>=ap.Y and pos.Y<=ap.Y+as.Y then
            bd=true bsx,bsy=pos.X,pos.Y bpx,bpy=Ball.Position.X.Offset,Ball.Position.Y.Offset
        end
    end)
    CN.bde=U.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then bd=false end end)
    CN.bdc=U.InputChanged:Connect(function(i)
        if not bd then return end
        if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
        local pos=i.Position
        local sw=CM.ViewportSize.X
        local sh=CM.ViewportSize.Y
        local nx=math.clamp(bpx+(pos.X-bsx),0,sw-54)
        local ny=math.clamp(bpy+(pos.Y-bsy),0,sh-54)
        Ball.Position=UDim2.new(0,nx,0,ny)
    end)
end

local PGS={
    {c=CFG.L.CM},
    {k="Fly",ic="✈",t=CFG.L.FL,d="自由飞行"},
    {k="Noclip",ic="⬜",t=CFG.L.NC,d="穿墙"},
    {k="Speed",ic="⚡",t=CFG.L.SP,d="速度"},
    {k="SpeedBoost",ic="»",t=CFG.L.SPB,d="行走加速"},
    {k="Sprint",ic="≡",t=CFG.L.SR,d="Shift冲刺"},
    {k="JumpBoost",ic="⇧",t=CFG.L.JB,d="跳高"},
    {k="InfJump",ic="↑",t=CFG.L.IJ,d="无限跳"},
    {k="FreeCam",ic="◐",t=CFG.L.FCM,d="自由视角"},
    {k="Teleport",ic="➤",t=CFG.L.TP,d="点击传送"},
    {k="ClickTP",ic="⌖",t=CFG.L.CTP,d="T键传送"},
    {k="SpawnTP",ic="⌂",t=CFG.L.STP,d="回出生点"},
    {k="WaterWalk",ic="≈",t=CFG.L.WW,d="水上行走"},
    {k="Spider",ic="❋",t=CFG.L.SPD,d="蜘蛛侠"},
    {k="LowGrav",ic="☾",t=CFG.L.LGV,d="低重力"},
    {k="ZeroGrav",ic="✦",t=CFG.L.ZGV,d="零重力"},
    {k="FlyHotkey",ic="⎋",t=CFG.L.FH,d="Q/E调速"},
    {c=CFG.L.CV},
    {k="NightVis",ic="☀",t=CFG.L.NV,d="夜视"},
    {k="Highlight",ic="◆",t=CFG.L.HL,d="高亮"},
    {k="Radar",ic="◯",t=CFG.L.RDR,d="雷达"},
    {k="NoFog",ic="◌",t=CFG.L.NF,d="无雾"},
    {k="Tracer",ic="╱",t=CFG.L.TRC,d="追踪线"},
    {k="PlayerInfo",ic="ⓘ",t=CFG.L.PI,d="玩家信息"},
    {k="TeamHL",ic="✚",t=CFG.L.THL,d="队友敌人"},
    {k="TrackArrow",ic="➨",t=CFG.L.TA,d="追踪箭头"},
    {k="ESPRange",ic="⇔",t=CFG.L.ERg,d="ESP距离"},
    {k="Crosshair",ic="✛",t=CFG.L.CH,d="十字准星"},
    {k="Ring",ic="◎",t=CFG.L.RG,d="距离环"},
    {k="Vignette",ic="◐",t=CFG.L.VG,d="暗角"},
    {k="Scanline",ic="≡",t=CFG.L.SC,d="扫描线"},
    {k="SnowScreen",ic="❄",t=CFG.L.SS,d="雪花屏"},
    {k="TargetBox",ic="⬜",t=CFG.L.TB,d="目标锁定"},
    {k="NameStroke",ic="❖",t=CFG.L.NS,d="名称描边"},
    {k="ScreenBlur",ic="▤",t=CFG.L.SB,d="屏幕模糊"},
    {k="ColorFilter",ic="◈",t=CFG.L.CFl,d="色彩滤镜"},
    {k="Fisheye",ic="◉",t=CFG.L.FE,d="鱼眼"},
    {c=CFG.L.CU},
    {k="ESP",ic="◉",t=CFG.L.ES,d="透视"},
    {k="ESPV",ic="◎",t=CFG.L.ESV,d="仅可见"},
    {k="Aura",ic="❂",t=CFG.L.AU,d="粒子光环"},
    {k="CharScale",ic="⬛",t=CFG.L.CS,d="角色缩放"},
    {k="Transparent",ic="◌",t=CFG.L.TR,d="透明化"},
    {k="Rainbow",ic="🌈",t=CFG.L.RB,d="彩虹"},
    {k="Outline",ic="◇",t=CFG.L.OL,d="发光轮廓"},
    {k="CharRotate",ic="↻",t=CFG.L.CRt,d="角色旋转"},
    {k="LimbStretch",ic="⟺",t=CFG.L.LS2,d="四肢拉长"},
    {k="NoFX",ic="✧",t=CFG.L.NFX,d="屏蔽特效"},
    {k="ServerInfo",ic="ℹ",t=CFG.L.SI,d="服务器信息"},
    {k="RGBBall",ic="◈",t=CFG.L.RGB,d="RGB球"},
    {k="AntiAFK",ic="⏰",t=CFG.L.AFK,d="反挂机"},
    {k="AntiFall",ic="⤴",t=CFG.L.AF,d="反掉落"},
    {k="Coords",ic="◇",t=CFG.L.CRD,d="坐标"},
    {k="FOV",ic="◯",t=CFG.L.FV,d="视角缩放"},
    {k="ClickPart",ic="✜",t=CFG.L.CP,d="点击显示"},
    {k="MapBounds",ic="▣",t=CFG.L.MB,d="地图边界"},
    {k="Rejoin",ic="↻",t=CFG.L.RJ,d="重新加入"},
    {k="Reset",ic="↺",t=CFG.L.RS2,d="重置"},
    {k="Shutdown",ic="✕",t=CFG.L.SD,d="关闭"},
}
local function GPI(k) for i,p in ipairs(PGS) do if p.k==k then return i end end return nil end

local function RTL()
    if not TPL then return end
    for _,c in ipairs(TPL:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local mr=GR()
    local mp=mr and mr.Position or VZ
    for _,pl in ipairs(P:GetPlayers()) do
        if pl~=LP and pl.Character then
            local hr=pl.Character:FindFirstChild("HumanoidRootPart")
            if hr then
                local d=math.floor((hr.Position-mp).Magnitude)
                local b=Instance.new("TextButton")
                b.Size=UDim2.new(1,-8,0,34)
                b.BackgroundColor3=CFG.TH.CB
                b.Text="  "..pl.Name.."    ["..d.."m]"
                b.Font=Enum.Font.GothamMedium
                b.TextSize=13
                b.TextColor3=CFG.TH.TX
                b.TextXAlignment=Enum.TextXAlignment.Left
                b.AutoButtonColor=false
                b.Active=true
                b.ZIndex=5
                b.Parent=TPL
                local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=b
                BC(b,function() PC() TT(pl) end)
            end
        end
    end
end
local function TT(pl)
    local mr=GR() if not mr then return end
    local tc=pl.Character if not tc then return end
    local tr=tc:FindFirstChild("HumanoidRootPart") if not tr then return end
    local pos=tr.Position+tr.CFrame.LookVector*3
    mr.CFrame=CFrame.new(pos,pos+tr.CFrame.LookVector)
end

local function SP(i)
    S.PG=i
    local pg=PGS[i] if not pg or pg.c then return end
    for j,it in ipairs(NIT) do
        if it and not it.IC then
            if j==i then
                it.BackgroundColor3=CFG.TH.SA it.BackgroundTransparency=0
                local ic=it:FindFirstChild("Icon") local lb=it:FindFirstChild("Text")
                if ic then ic.TextColor3=CFG.TH.AG end
                if lb then lb.TextColor3=CFG.TH.TX end
            else
                it.BackgroundColor3=Color3.fromRGB(0,0,0) it.BackgroundTransparency=1
                local ic=it:FindFirstChild("Icon") local lb=it:FindFirstChild("Text")
                if ic then ic.TextColor3=CFG.TH.TD end
                if lb then lb.TextColor3=CFG.TH.TD end
            end
        end
    end
    if TL then TL.Text=pg.t end
    if DL then DL.Text=pg.d end
    if TPP and TPL then
        if pg.k=="Teleport" then TPP.Visible=true if CP2 then CP2.Visible=false end if BB then BB.Visible=false end RTL()
        elseif pg.k=="Coords" then TPP.Visible=false if CP2 then CP2.Visible=true end if BB then BB.Visible=false end
        else TPP.Visible=false if CP2 then CP2.Visible=false end if BB then BB.Visible=true end end
    end
    local k=pg.k
    local on,txt=false,""
    if k=="Fly" then on=S.FL txt=S.FL and "关闭飞行" or "开启飞行"
    elseif k=="Noclip" then on=S.NC txt=S.NC and "关闭穿墙" or "开启穿墙"
    elseif k=="Speed" then on=true txt="速度 "..CFG.FS[S.FST]
    elseif k=="SpeedBoost" then on=S.SPB>0 txt=S.SPB==0 and "开启速度增强" or ("当前："..({50,100,180})[S.SPB])
    elseif k=="Sprint" then on=S.SR txt=S.SR and "关闭" or "开启"
    elseif k=="JumpBoost" then on=S.JB txt=S.JB and "关闭" or "开启"
    elseif k=="InfJump" then on=S.IJ txt=S.IJ and "关闭" or "开启"
    elseif k=="FreeCam" then on=S.FCM txt=S.FCM and "关闭" or "开启"
    elseif k=="ClickTP" then on=S.CTP txt=S.CTP and "关闭" or "开启"
    elseif k=="SpawnTP" then txt="传回出生点"
    elseif k=="WaterWalk" then on=S.WW txt=S.WW and "关闭" or "开启"
    elseif k=="Spider" then on=S.SPD txt=S.SPD and "关闭" or "开启"
    elseif k=="LowGrav" then on=S.LGV txt=S.LGV and "关闭" or "开启"
    elseif k=="ZeroGrav" then on=S.ZGV txt=S.ZGV and "关闭" or "开启"
    elseif k=="FlyHotkey" then on=S.FH txt=S.FH and "关闭" or "开启"
    elseif k=="NightVis" then on=S.NV txt=S.NV and "关闭" or "开启"
    elseif k=="Highlight" then on=S.HL txt=S.HL and "关闭" or "开启"
    elseif k=="Radar" then on=S.RDR txt=S.RDR and "关闭" or "开启"
    elseif k=="NoFog" then on=S.NF txt=S.NF and "关闭" or "开启"
    elseif k=="Tracer" then on=S.TRC txt=S.TRC and "关闭" or "开启"
    elseif k=="PlayerInfo" then on=S.PI txt=S.PI and "关闭" or "开启"
    elseif k=="TeamHL" then on=S.THL txt=S.THL and "关闭" or "开启"
    elseif k=="TrackArrow" then on=S.TA txt=S.TA and "关闭" or "开启"
    elseif k=="ESPRange" then on=true txt="ESP "..CFG.ER
    elseif k=="Crosshair" then on=S.CH txt=S.CH and "关闭" or "开启"
    elseif k=="Ring" then on=S.RG txt=S.RG and "关闭" or "开启"
    elseif k=="Vignette" then on=S.VG txt=S.VG and "关闭" or "开启"
    elseif k=="Scanline" then on=S.SC txt=S.SC and "关闭" or "开启"
    elseif k=="SnowScreen" then on=S.SS txt=S.SS and "关闭" or "开启"
    elseif k=="TargetBox" then on=S.TB txt=S.TB and "关闭" or "开启"
    elseif k=="NameStroke" then on=S.NS txt=S.NS and "关闭" or "开启"
    elseif k=="ScreenBlur" then on=S.SB txt=S.SB and "关闭" or "开启"
    elseif k=="ColorFilter" then on=S.CFl txt=S.CFl and "关闭" or "开启"
    elseif k=="Fisheye" then on=S.FE txt=S.FE and "关闭" or "开启"
    elseif k=="ESP" then on=S.ES txt=S.ES and "关闭" or "开启"
    elseif k=="ESPV" then on=S.ESV txt=S.ESV and "关闭" or "开启"
    elseif k=="Aura" then on=S.AU txt=S.AU and "关闭" or "开启"
    elseif k=="CharScale" then on=S.CS~=1 txt="大小 "..S.CS.."x"
    elseif k=="Transparent" then on=S.TR txt=S.TR and "关闭" or "开启"
    elseif k=="Rainbow" then on=S.RB txt=S.RB and "关闭" or "开启"
    elseif k=="Outline" then on=S.OL txt=S.OL and "关闭" or "开启"
    elseif k=="CharRotate" then on=S.CRt txt=S.CRt and "关闭" or "开启"
    elseif k=="LimbStretch" then on=S.LS2 txt=S.LS2 and "关闭" or "开启"
    elseif k=="NoFX" then on=S.NFX txt=S.NFX and "关闭" or "开启"
    elseif k=="ServerInfo" then on=S.SI txt=S.SI and "关闭" or "开启"
    elseif k=="RGBBall" then on=S.RGB txt=S.RGB and "关闭" or "开启"
    elseif k=="AntiAFK" then on=S.AFK txt=S.AFK and "关闭" or "开启"
    elseif k=="AntiFall" then on=S.AF txt=S.AF and "关闭" or "开启"
    elseif k=="FOV" then on=S.FV txt=S.FV and "关闭" or "开启"
    elseif k=="ClickPart" then on=S.CP txt=S.CP and "关闭" or "开启"
    elseif k=="MapBounds" then on=S.MB txt=S.MB and "关闭" or "显示"
    elseif k=="Rejoin" then txt="重新加入服务器"
    elseif k=="Reset" then txt="执行重置"
    elseif k=="Shutdown" then txt="确认关闭脚本"
    end
    if BB then BB.Text=txt BB.BackgroundColor3=on and CFG.TH.CO or CFG.TH.CB end
end

local FLT,NCT,EST,ESVT,MAS,MSD,IJT,WWT,FCT,SPBT
local STPA,AFT,CTPT,JBT,SPDT,SRT,LGT,ZGT,FHT
local NVT,HLT,RDT,NFT,NFXT,SIT,RGBT,AFKT
local TRCT,PIT,THLT,TAT,ERTT
local CHT,RGT,VGT,SCT,SNT,TBT,NST,SB2T,CFT,FET
local AUT,CST,TRT,RBT,OLT,CRT2,LST,FVT,CPT,MBT
local function OBBC()
    local pg=PGS[S.PG] if not pg or pg.c then return end
    PC()
    local k=pg.k
    if k=="Fly" then FLT()
    elseif k=="Noclip" then NCT()
    elseif k=="Speed" then S.FST=(S.FST%#CFG.FS)+1
    elseif k=="SpeedBoost" then SPBT()
    elseif k=="Sprint" then SRT()
    elseif k=="JumpBoost" then JBT()
    elseif k=="InfJump" then IJT()
    elseif k=="FreeCam" then FCT()
    elseif k=="ClickTP" then CTPT()
    elseif k=="SpawnTP" then STPA()
    elseif k=="WaterWalk" then WWT()
    elseif k=="Spider" then SPDT()
    elseif k=="LowGrav" then LGT()
    elseif k=="ZeroGrav" then ZGT()
    elseif k=="FlyHotkey" then FHT()
    elseif k=="NightVis" then NVT()
    elseif k=="Highlight" then HLT()
    elseif k=="Radar" then RDT()
    elseif k=="NoFog" then NFT()
    elseif k=="Tracer" then TRCT()
    elseif k=="PlayerInfo" then PIT()
    elseif k=="TeamHL" then THLT()
    elseif k=="TrackArrow" then TAT()
    elseif k=="ESPRange" then ERTT()
    elseif k=="Crosshair" then CHT()
    elseif k=="Ring" then RGT()
    elseif k=="Vignette" then VGT()
    elseif k=="Scanline" then SCT()
    elseif k=="SnowScreen" then SNT()
    elseif k=="TargetBox" then TBT()
    elseif k=="NameStroke" then NST()
    elseif k=="ScreenBlur" then SB2T()
    elseif k=="ColorFilter" then CFT()
    elseif k=="Fisheye" then FET()
    elseif k=="ESP" then EST()
    elseif k=="ESPV" then ESVT()
    elseif k=="Aura" then AUT()
    elseif k=="CharScale" then CST()
    elseif k=="Transparent" then TRT()
    elseif k=="Rainbow" then RBT()
    elseif k=="Outline" then OLT()
    elseif k=="CharRotate" then CRT2()
    elseif k=="LimbStretch" then LST()
    elseif k=="NoFX" then NFXT()
    elseif k=="ServerInfo" then SIT()
    elseif k=="RGBBall" then RGBT()
    elseif k=="AntiAFK" then AFKT()
    elseif k=="AntiFall" then AFT()
    elseif k=="FOV" then FVT()
    elseif k=="ClickPart" then CPT()
    elseif k=="MapBounds" then MBT()
    elseif k=="Rejoin" then SAFE("rj",function() TS:Teleport(game.PlaceId,LP) end)
    elseif k=="Reset" then MAS()
    elseif k=="Shutdown" then MSD()
    end
    SP(S.PG)
end

local function UII()
    local ok,err=pcall(function()
        SG=Instance.new("ScreenGui")
        SG.Name="ApexHub" SG.ResetOnSpawn=false SG.DisplayOrder=999 SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling SG.Parent=LP:WaitForChild("PlayerGui")
        Main=Instance.new("Frame")
        Main.Size=UDim2.new(0,CFG.W,0,CFG.H)
        Main.Position=UDim2.new(.5,-CFG.W/2,.5,-CFG.H/2)
        Main.BackgroundColor3=Color3.fromRGB(6,8,14) Main.BorderSizePixel=0 Main.ClipsDescendants=true Main.Active=true Main.Parent=SG
        local mc=Instance.new("UICorner") mc.CornerRadius=UDim.new(0,CFG.TH.CR+4) mc.Parent=Main
        local bg=Instance.new("ImageLabel")
        bg.Size=UDim2.new(1,0,1,0) bg.Image=CFG.BGI bg.ImageTransparency=CFG.BGT bg.BackgroundTransparency=1 bg.ScaleType=Enum.ScaleType.Crop bg.ZIndex=1 bg.Parent=Main
        local bc=Instance.new("UICorner") bc.CornerRadius=UDim.new(0,CFG.TH.CR+4) bc.Parent=bg
        local ov=Instance.new("Frame") ov.Size=UDim2.new(1,0,1,0) ov.BackgroundColor3=Color3.fromRGB(0,0,0) ov.BackgroundTransparency=CFG.TH.OT ov.BorderSizePixel=0 ov.ZIndex=2 ov.Parent=Main
        local oc=Instance.new("UICorner") oc.CornerRadius=UDim.new(0,CFG.TH.CR+4) oc.Parent=ov
        local tg=Instance.new("Frame") tg.Size=UDim2.new(1,0,0,2) tg.BackgroundColor3=CFG.TH.AG tg.BorderSizePixel=0 tg.ZIndex=10 tg.Parent=Main
        TCap=Instance.new("Frame") TCap.Size=UDim2.new(0,160,0,30) TCap.Position=UDim2.new(.5,-80,0,12) TCap.BackgroundColor3=Color3.fromRGB(0,0,0) TCap.BackgroundTransparency=.15 TCap.BorderSizePixel=0 TCap.ZIndex=20 TCap.Parent=Main
        local tc=Instance.new("UICorner") tc.CornerRadius=UDim.new(1,0) tc.Parent=TCap
        local ts=Instance.new("UIStroke") ts.Color=CFG.TH.AG ts.Thickness=1 ts.Transparency=.5 ts.Parent=TCap
        local dt=Instance.new("Frame") dt.Size=UDim2.new(0,6,0,6) dt.Position=UDim2.new(0,12,.5,-3) dt.BackgroundColor3=CFG.TH.GR dt.BorderSizePixel=0 dt.ZIndex=21 dt.Parent=TCap
        local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(1,0) dc.Parent=dt
        TLbl=Instance.new("TextLabel") TLbl.Size=UDim2.new(1,-30,1,0) TLbl.Position=UDim2.new(0,24,0,0) TLbl.BackgroundTransparency=1 TLbl.Text=GTS() TLbl.Font=Enum.Font.GothamBold TLbl.TextSize=14 TLbl.TextColor3=CFG.TH.AG TLbl.TextXAlignment=Enum.TextXAlignment.Center TLbl.ZIndex=21 TLbl.Parent=TCap
        SB=Instance.new("Frame") SB.Size=UDim2.new(0,CFG.SB,1,0) SB.BackgroundColor3=CFG.TH.SB SB.BackgroundTransparency=.15 SB.BorderSizePixel=0 SB.ZIndex=3 SB.Parent=Main
        local br=Instance.new("TextLabel") br.Size=UDim2.new(1,0,0,32) br.Position=UDim2.new(0,16,0,14) br.BackgroundTransparency=1 br.Text=CFG.L.BR br.Font=Enum.Font.GothamBold br.TextSize=22 br.TextColor3=CFG.TH.AG br.TextXAlignment=Enum.TextXAlignment.Left br.ZIndex=4 br.Parent=SB
        local sb2=Instance.new("TextLabel") sb2.Size=UDim2.new(1,0,0,14) sb2.Position=UDim2.new(0,16,0,46) sb2.BackgroundTransparency=1 sb2.Text=CFG.L.ST sb2.Font=Enum.Font.Gotham sb2.TextSize=10 sb2.TextColor3=CFG.TH.TD sb2.TextXAlignment=Enum.TextXAlignment.Left sb2.ZIndex=4 sb2.Parent=SB
        NS_=Instance.new("ScrollingFrame") NS_.Size=UDim2.new(1,-8,1,-80) NS_.Position=UDim2.new(0,4,0,70) NS_.BackgroundTransparency=1 NS_.BorderSizePixel=0 NS_.ScrollBarThickness=3 NS_.ScrollBarImageColor3=CFG.TH.AG NS_.CanvasSize=UDim2.new(0,0,0,0) NS_.AutomaticCanvasSize=Enum.AutomaticSize.Y NS_.ScrollingDirection=Enum.ScrollingDirection.Y NS_.ZIndex=4 NS_.Parent=SB
        NL=Instance.new("Frame") NL.Size=UDim2.new(1,0,0,0) NL.BackgroundTransparency=1 NL.AutomaticSize=Enum.AutomaticSize.Y NL.ZIndex=4 NL.Parent=NS_
        local ly=Instance.new("UIListLayout") ly.SortOrder=Enum.SortOrder.LayoutOrder ly.Padding=UDim.new(0,2) ly.Parent=NL
        for i,pg in ipairs(PGS) do
            if pg.c then
                local cf=Instance.new("TextLabel") cf.Size=UDim2.new(1,-6,0,24) cf.BackgroundTransparency=1 cf.Text=pg.c cf.Font=Enum.Font.GothamBold cf.TextSize=11 cf.TextColor3=CFG.TH.CT cf.TextXAlignment=Enum.TextXAlignment.Left cf.LayoutOrder=i cf.ZIndex=5 cf.Parent=NL
                NIT[i]={IC=true,F=cf}
            else
                local it=Instance.new("TextButton") it.Size=UDim2.new(1,-6,0,30) it.BackgroundColor3=Color3.fromRGB(0,0,0) it.BackgroundTransparency=1 it.AutoButtonColor=false it.Text="" it.LayoutOrder=i it.Active=true it.ZIndex=5 it.Parent=NL
                local ic2=Instance.new("UICorner") ic2.CornerRadius=UDim.new(0,8) ic2.Parent=it
                local ico=Instance.new("TextLabel") ico.Name="Icon" ico.Size=UDim2.new(0,24,1,0) ico.Position=UDim2.new(0,10,0,0) ico.BackgroundTransparency=1 ico.Text=pg.ic ico.Font=Enum.Font.GothamBold ico.TextSize=14 ico.TextColor3=CFG.TH.TD ico.TextXAlignment=Enum.TextXAlignment.Center ico.Active=false ico.ZIndex=6 ico.Parent=it
                local lb=Instance.new("TextLabel") lb.Name="Text" lb.Size=UDim2.new(1,-40,1,0) lb.Position=UDim2.new(0,36,0,0) lb.BackgroundTransparency=1 lb.Text=pg.t lb.Font=Enum.Font.GothamMedium lb.TextSize=12 lb.TextColor3=CFG.TH.TD lb.TextXAlignment=Enum.TextXAlignment.Left lb.Active=false lb.ZIndex=6 lb.Parent=it
                BC(it,function() PC() SP(i) end)
                NIT[i]=it
            end
        end
        CT=Instance.new("Frame") CT.Size=UDim2.new(1,-CFG.SB,1,0) CT.Position=UDim2.new(0,CFG.SB,0,0) CT.BackgroundTransparency=1 CT.ZIndex=3 CT.Parent=Main
        TL=Instance.new("TextLabel") TL.Size=UDim2.new(1,-60,0,36) TL.Position=UDim2.new(0,30,0,60) TL.BackgroundTransparency=1 TL.Text=CFG.L.FL TL.Font=Enum.Font.GothamBold TL.TextSize=26 TL.TextColor3=CFG.TH.TX TL.TextXAlignment=Enum.TextXAlignment.Left TL.ZIndex=4 TL.Parent=CT
        DL=Instance.new("TextLabel") DL.Size=UDim2.new(1,-60,0,40) DL.Position=UDim2.new(0,30,0,102) DL.BackgroundTransparency=1 DL.Text="" DL.Font=Enum.Font.Gotham DL.TextSize=12 DL.TextColor3=CFG.TH.TD DL.TextXAlignment=Enum.TextXAlignment.Left DL.TextYAlignment=Enum.TextYAlignment.Top DL.TextWrapped=true DL.ZIndex=4 DL.Parent=CT
        BB=Instance.new("TextButton") BB.Size=UDim2.new(1,-60,0,60) BB.Position=UDim2.new(0,30,1,-100) BB.BackgroundColor3=CFG.TH.CB BB.Text="开启飞行" BB.Font=Enum.Font.GothamBold BB.TextSize=17 BB.TextColor3=CFG.TH.TX BB.AutoButtonColor=false BB.Active=true BB.ZIndex=4 BB.Parent=CT
        local bc2=Instance.new("UICorner") bc2.CornerRadius=UDim.new(0,14) bc2.Parent=BB
        BC(BB,function() SAFE("bb",OBBC) end)
        TPP=Instance.new("Frame") TPP.Size=UDim2.new(1,-60,0,260) TPP.Position=UDim2.new(0,30,0,150) TPP.BackgroundTransparency=1 TPP.ZIndex=4 TPP.Visible=false TPP.Parent=CT
        TPL=Instance.new("ScrollingFrame") TPL.Size=UDim2.new(1,0,1,0) TPL.BackgroundTransparency=1 TPL.BorderSizePixel=0 TPL.ScrollBarThickness=4 TPL.ScrollBarImageColor3=CFG.TH.AG TPL.CanvasSize=UDim2.new(0,0,0,0) TPL.AutomaticCanvasSize=Enum.AutomaticSize.Y TPL.ZIndex=5 TPL.Parent=TPP
        local tl2=Instance.new("UIListLayout") tl2.SortOrder=Enum.SortOrder.LayoutOrder tl2.Padding=UDim.new(0,4) tl2.Parent=TPL
        CP2=Instance.new("Frame") CP2.Size=UDim2.new(1,-60,0,140) CP2.Position=UDim2.new(0,30,0,150) CP2.BackgroundColor3=CFG.TH.CB CP2.BackgroundTransparency=.1 CP2.BorderSizePixel=0 CP2.ZIndex=4 CP2.Visible=false CP2.Parent=CT
        local cc2=Instance.new("UICorner") cc2.CornerRadius=UDim.new(0,12) cc2.Parent=CP2
        CL2=Instance.new("TextLabel") CL2.Size=UDim2.new(1,-40,1,-60) CL2.Position=UDim2.new(0,20,0,10) CL2.BackgroundTransparency=1 CL2.Text="X: 0\nY: 0\nZ: 0" CL2.Font=Enum.Font.Code CL2.TextSize=15 CL2.TextColor3=CFG.TH.AG CL2.TextXAlignment=Enum.TextXAlignment.Left CL2.TextYAlignment=Enum.TextYAlignment.Top CL2.ZIndex=5 CL2.Parent=CP2
        local cb2=Instance.new("TextButton") cb2.Size=UDim2.new(1,-40,0,34) cb2.Position=UDim2.new(0,20,1,-44) cb2.BackgroundColor3=CFG.TH.CO cb2.Text="复制坐标" cb2.Font=Enum.Font.GothamBold cb2.TextSize=14 cb2.TextColor3=CFG.TH.TX cb2.AutoButtonColor=false cb2.Active=true cb2.ZIndex=5 cb2.Parent=CP2
        local cc3=Instance.new("UICorner") cc3.CornerRadius=UDim.new(0,10) cc3.Parent=cb2
        BC(cb2,function()
            PC()
            local r=GR() if not r then return end
            local p=r.Position
            local str=string.format("%.1f, %.1f, %.1f",p.X,p.Y,p.Z)
            pcall(function() if setclipboard then setclipboard(str) elseif toclipboard then toclipboard(str) end end)
            cb2.Text="已复制！ "..str
            task.delay(1.5,function() if cb2 then cb2.Text="复制坐标" end end)
        end)
        SIL=Instance.new("TextLabel") SIL.Size=UDim2.new(0,200,0,90) SIL.Position=UDim2.new(1,-220,1,-110) SIL.BackgroundColor3=Color3.fromRGB(0,0,0) SIL.BackgroundTransparency=.3 SIL.Text="" SIL.Font=Enum.Font.Code SIL.TextSize=12 SIL.TextColor3=CFG.TH.AG SIL.TextXAlignment=Enum.TextXAlignment.Left SIL.TextYAlignment=Enum.TextYAlignment.Top SIL.Visible=false SIL.ZIndex=500 SIL.Parent=SG
        local sic=Instance.new("UICorner") sic.CornerRadius=UDim.new(0,10) sic.Parent=SIL
        FVL=Instance.new("TextLabel") FVL.Size=UDim2.new(0,160,0,30) FVL.Position=UDim2.new(0,20,0,100) FVL.BackgroundColor3=Color3.fromRGB(0,0,0) FVL.BackgroundTransparency=.3 FVL.Text="" FVL.Font=Enum.Font.Code FVL.TextSize=12 FVL.TextColor3=CFG.TH.AG FVL.Visible=false FVL.ZIndex=500 FVL.Parent=SG
        local flc=Instance.new("UICorner") flc.CornerRadius=UDim.new(0,10) flc.Parent=FVL
        Ball=Instance.new("TextButton") Ball.Size=UDim2.new(0,54,0,54) Ball.Position=GBDP() Ball.Text="A" Ball.Font=Enum.Font.GothamBold Ball.TextSize=24 Ball.BackgroundColor3=CFG.TH.CO Ball.TextColor3=Color3.fromRGB(255,255,255) Ball.BorderSizePixel=0 Ball.Visible=false Ball.Active=true Ball.ZIndex=1000 Ball.Parent=SG
        local blc=Instance.new("UICorner") blc.CornerRadius=UDim.new(1,0) blc.Parent=Ball
        BC(Ball,function() SAFE("b",US) end)
        local cb=Instance.new("TextButton") cb.Size=UDim2.new(0,30,0,30) cb.Position=UDim2.new(1,-42,0,14) cb.Text="✕" cb.Font=Enum.Font.GothamBold cb.TextSize=14 cb.BackgroundColor3=CFG.TH.CO cb.TextColor3=CFG.TH.TX cb.BorderSizePixel=0 cb.Active=true cb.ZIndex=20 cb.Parent=Main
        local cbc=Instance.new("UICorner") cbc.CornerRadius=UDim.new(1,0) cbc.Parent=cb
        BC(cb,function() SAFE("c",UH) end)
        CN.hk=U.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.KeyCode==CFG.TK then UT()
            elseif i.KeyCode==CFG.RK then US() end
        end)
        SDR()
        SP(GPI("Fly"))
        task.spawn(function()
            while RUN do
                task.wait(.5)
                if S.PG==GPI("Teleport") and TPP and TPP.Visible then RTL() end
                if S.PG==GPI("Coords") and CL2 then
                    local r=GR()
                    if r then local p=r.Position CL2.Text=string.format("X: %.1f\nY: %.1f\nZ: %.1f",p.X,p.Y,p.Z) end
                end
            end
        end)
    end)
    if not ok then warn("[APEX:UI]",err) end
    return ok
end

-- === 功能实现 ===
local function NGP()
    local c=LP.Character if not c then return {} end
    local t={}
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            local sk=false
            local pr=p.Parent
            while pr and pr~=c do
                if pr:IsA("Tool") or pr:IsA("BackpackItem") then sk=true break end
                pr=pr.Parent
            end
            if not sk then table.insert(t,p) end
        end
    end
    return t
end
local function NRE()
    for _,p in pairs(NCP) do
        if p and p.Parent and p:GetAttribute("NX_Noclip") then
            local o=p:GetAttribute("NX_OrigCollide")
            p.CanCollide=o~=nil and o or true
            p:SetAttribute("NX_Noclip",nil) p:SetAttribute("NX_OrigCollide",nil)
        end
    end
    NCP={}
end
local function NE() NCP=NGP() S.NC=true end
local function ND() NRE() S.NC=false end
local function NI()
    CN.caN=LP.CharacterAdded:Connect(function() if S.NC then NCP=NGP() end end)
    CN.st=R.Stepped:Connect(function()
        if not S.NC then return end
        for _,p in pairs(NCP) do
            if p and p.Parent and p.CanCollide then
                if p:GetAttribute("NX_OrigCollide")==nil then p:SetAttribute("NX_OrigCollide",p.CanCollide) end
                p.CanCollide=false p:SetAttribute("NX_Noclip",true)
            end
        end
    end)
end
NCT=function() if S.NC then ND() else NE() end end

FLT=function()
    S.FL=not S.FL
    local h=GH() local r=GR()
    if h and r then
        if S.FL then h.PlatformStand=true NE() r.CFrame=r.CFrame+Vector3.new(0,CFG.FLO,0)
        else h.PlatformStand=false r.AssemblyLinearVelocity=VZ ND() end
    end
end
local function FI()
    CN.rd=R.RenderStepped:Connect(function(dt)
        if not S.FL then return end
        local r=GR() if not r then return end
        local c=CM
        local sp=CFG.FS[S.FST] or 200
        local lv=CFG.LS
        local mv=VZ
        if U:IsKeyDown(Enum.KeyCode.W) then mv=mv+c.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.S) then mv=mv-c.CFrame.LookVector end
        if U:IsKeyDown(Enum.KeyCode.D) then mv=mv+c.CFrame.RightVector end
        if U:IsKeyDown(Enum.KeyCode.A) then mv=mv-c.CFrame.RightVector end
        if U:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
        if U:IsKeyDown(Enum.KeyCode.LeftShift) then mv=mv-Vector3.new(0,1,0) end
        if mv.Magnitude>0 then
            local h2=Vector3.new(mv.X,0,mv.Z)
            local v2=mv.Y
            local vl=VZ
            if h2.Magnitude>0 then vl=vl+h2.Unit*sp end
            if v2~=0 then vl=vl+Vector3.new(0,v2*lv,0) end
            r.AssemblyLinearVelocity=vl
        else r.AssemblyLinearVelocity=VZ end
    end)
end
IJT=function() S.IJ=not S.IJ end
local function IJI()
    CN.ij=U.JumpRequest:Connect(function()
        if not S.IJ then return end
        local h=GH() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
WWT=function() S.WW=not S.WW end
local function WWI()
    local cnt=0
    CN.ww=R.Stepped:Connect(function()
        if not S.WW then return end
        cnt=cnt+1 if cnt%3~=0 then return end
        local c=LP.Character if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart") if not h then return end
        local rg=Region3.new(h.Position-Vector3.new(3,5,3),h.Position+Vector3.new(3,0,3)):ExpandToGrid(4)
        local ok,m=pcall(function() return workspace.Terrain:ReadVoxels(rg,4) end)
        if not ok or not m then return end
        local hw=false
        for x=1,m.Size.X do for y=1,m.Size.Y do for z=1,m.Size.Z do if m[x][y][z]==Enum.Material.Water then hw=true break end end if hw then break end end if hw then break end end
        if hw then
            local v=h.AssemblyLinearVelocity
            if v.Y<0 then h.AssemblyLinearVelocity=Vector3.new(v.X,0,v.Z) end
        end
    end)
end
FCT=function()
    S.FCM=not S.FCM
    local c=CM
    if S.FCM then
        FCam.OT=c.CameraType FCam.OS=c.CameraSubject FCam.Pos=c.CFrame.Position
        local lk=c.CFrame.LookVector
        FCam.Y=math.atan2(-lk.X,-lk.Z) FCam.Pt=math.asin(math.clamp(lk.Y,-1,1))
        c.CameraType=Enum.CameraType.Scriptable
        U.MouseBehavior=Enum.MouseBehavior.LockCenter
    else
        c.CameraType=FCam.OT or Enum.CameraType.Custom
        if FCam.OS then c.CameraSubject=FCam.OS end
        U.MouseBehavior=Enum.MouseBehavior.Default
    end
end
local function FCI()
    CN.fcr=R.RenderStepped:Connect(function(dt)
        if not S.FCM then return end
        local c=CM
        local rt=CFrame.fromEulerAnglesYXZ(FCam.Pt,FCam.Y,0)
        local mv=VZ
        if U:IsKeyDown(Enum.KeyCode.W) then mv=mv+rt.LookVector end
        if U:IsKeyDown(Enum.KeyCode.S) then mv=mv-rt.LookVector end
        if U:IsKeyDown(Enum.KeyCode.D) then mv=mv+rt.RightVector end
        if U:IsKeyDown(Enum.KeyCode.A) then mv=mv-rt.RightVector end
        if U:IsKeyDown(Enum.KeyCode.Space) then mv=mv+Vector3.new(0,1,0) end
        if U:IsKeyDown(Enum.KeyCode.LeftShift) then mv=mv-Vector3.new(0,1,0) end
        if mv.Magnitude>0 then FCam.Pos=FCam.Pos+mv.Unit*100*dt end
        c.CFrame=CFrame.new(FCam.Pos)*rt
    end)
    CN.fcm=U.InputChanged:Connect(function(i)
        if not S.FCM then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement then
            FCam.Y=FCam.Y-i.Delta.X*.005
            FCam.Pt=math.clamp(FCam.Pt-i.Delta.Y*.005,-1.5,1.5)
        end
    end)
end
local SBT={50,100,180}
SPBT=function()
    S.SPB=(S.SPB+1)%(#SBT+1)
    local h=GH()
    if h then
        if S.SPB==0 then h.WalkSpeed=16 else h.WalkSpeed=SBT[S.SPB] end
    end
end
SRT=function() S.SR=not S.SR end
local function SRI()
    CN.sr=R.Heartbeat:Connect(function()
        if not S.SR then return end
        local h=GH() if not h then return end
        local c=h.WalkSpeed
        if U:IsKeyDown(Enum.KeyCode.LeftShift) then
            if c<CFG.SS and c>0 then h.WalkSpeed=CFG.SS end
        else
            if c==CFG.SS then
                if S.SPB>0 then h.WalkSpeed=SBT[S.SPB] else h.WalkSpeed=16 end
            end
        end
    end)
end
JBT=function()
    S.JB=not S.JB
    local h=GH()
    if h then
        if S.JB then h.JumpPower=CFG.JP h.UseJumpPower=true
        else h.JumpPower=50 h.UseJumpPower=false end
    end
end
SPDT=function() S.SPD=not S.SPD end
local function SPDI()
    local cnt=0
    CN.spd=R.Heartbeat:Connect(function()
        if not S.SPD then return end
        cnt=cnt+1 if cnt%4~=0 then return end
        local c=LP.Character if not c then return end
        local h=c:FindFirstChild("HumanoidRootPart") if not h then return end
        local p=RaycastParams.new() p.FilterType=Enum.RaycastFilterType.Exclude p.FilterDescendantsInstances={c}
        local dr={h.CFrame.LookVector,-h.CFrame.LookVector,h.CFrame.RightVector,-h.CFrame.RightVector}
        for _,d in ipairs(dr) do
            local ht=workspace:Raycast(h.Position,d*3,p)
            if ht then h.AssemblyLinearVelocity=Vector3.new(h.AssemblyLinearVelocity.X,0,h.AssemblyLinearVelocity.Z) break end
        end
    end)
end
LGT=function()
    S.LGV=not S.LGV
    if S.LGV then S.ZGV=false workspace.Gravity=CFG.LG else workspace.Gravity=196.2 end
end
ZGT=function()
    S.ZGV=not S.ZGV
    if S.ZGV then S.LGV=false workspace.Gravity=0 else workspace.Gravity=196.2 end
end
AFT=function() S.AF=not S.AF end
local function AFI()
    CN.af=R.Heartbeat:Connect(function()
        if not S.AF then return end
        local r=GR() if not r then return end
        if r.Position.Y<-100 then
            local s=workspace:FindFirstChildOfClass("SpawnLocation")
            if s then r.CFrame=s.CFrame+Vector3.new(0,5,0) else r.CFrame=CFrame.new(0,100,0) end
        end
    end)
end
CTPT=function() S.CTP=not S.CTP end
local function CTPI()
    CN.ctp=U.InputBegan:Connect(function(i,gp)
        if gp then return end
        if not S.CTP then return end
        if i.KeyCode~=CFG.CTK then return end
        local m=LP:GetMouse()
        local h=m.Hit
        if h then local r=GR() if r then r.CFrame=CFrame.new(h.Position+Vector3.new(0,3,0)) end end
    end)
end
STPA=function()
    local r=GR() if not r then return end
    local s=workspace:FindFirstChildOfClass("SpawnLocation")
    if s then r.CFrame=s.CFrame+Vector3.new(0,5,0) else r.CFrame=CFrame.new(0,100,0) end
end
FHT=function() S.FH=not S.FH end
local function FHI()
    CN.fh=U.InputBegan:Connect(function(i,gp)
        if gp then return end
        if not S.FH then return end
        if i.KeyCode==CFG.FUK then S.FST=math.min(#CFG.FS,S.FST+1)
        elseif i.KeyCode==CFG.FDK then S.FST=math.max(1,S.FST-1) end
    end)
end
NVT=function()
    S.NV=not S.NV
    if S.NV then
        if OL2.B==nil then OL2.B=LG.Brightness OL2.A=LG.Ambient OL2.OA=LG.OutdoorAmbient end
        LG.Brightness=CFG.NB LG.Ambient=CFG.NA LG.OutdoorAmbient=CFG.NA
    else
        if OL2.B then LG.Brightness=OL2.B end
        if OL2.A then LG.Ambient=OL2.A end
        if OL2.OA then LG.OutdoorAmbient=OL2.OA end
    end
end
local function CHL()
    for _,h in pairs(HLO) do if h and h.Parent then h:Destroy() end end
    HLO={}
end
local function MKHL(c,col)
    local h=Instance.new("Highlight")
    h.FillColor=col h.FillTransparency=.5 h.OutlineColor=col h.OutlineTransparency=0 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop h.Adornee=c h.Parent=c
    return h
end
local function RHL()
    CHL()
    if not S.HL and not S.THL then return end
    for _,pl in ipairs(P:GetPlayers()) do
        if pl~=LP and pl.Character then
            local tm=pl.Team and pl.Team==LP.Team
            local col
            if S.THL then col=tm and CFG.FC or CFG.EC else col=tm and CFG.FC or CFG.TH.AG end
            table.insert(HLO,MKHL(pl.Character,col))
        end
    end
end
HLT=function() S.HL=not S.HL RHL() end
THLT=function() S.THL=not S.THL RHL() end
local function HLI()
    CN.hlpa=P.PlayerAdded:Connect(function() task.wait(1) if S.HL or S.THL then RHL() end end)
    task.spawn(function() while RUN do task.wait(2) if S.HL or S.THL then RHL() end end end)
end
RDT=function() S.RDR=not S.RDR end
local function RDI()
    RF=Instance.new("Frame") RF.Size=UDim2.new(0,CFG.RS,0,CFG.RS) RF.Position=UDim2.new(1,-CFG.RS-20,0,60) RF.BackgroundColor3=Color3.fromRGB(0,0,0) RF.BackgroundTransparency=.35 RF.BorderSizePixel=0 RF.Visible=false RF.ZIndex=500 RF.Parent=SG
    local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(1,0) rc.Parent=RF
    local rs=Instance.new("UIStroke") rs.Color=CFG.TH.AG rs.Thickness=2 rs.Parent=RF
    local cn=Instance.new("Frame") cn.Size=UDim2.new(0,6,0,6) cn.Position=UDim2.new(.5,-3,.5,-3) cn.BackgroundColor3=CFG.TH.AG cn.BorderSizePixel=0 cn.ZIndex=501 cn.Parent=RF
    local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(1,0) cc.Parent=cn
    RD=Instance.new("Frame") RD.Size=UDim2.new(1,0,1,0) RD.BackgroundTransparency=1 RD.ZIndex=501 RD.Parent=RF
    task.spawn(function()
        while RUN do
            task.wait(.15)
            if S.RDR then
                RF.Visible=true
                for _,c in ipairs(RD:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
                local mr=GR()
                if mr then
                    local mp=mr.Position
                    local ml=CM.CFrame.LookVector
                    local ag=math.atan2(ml.X,ml.Z)
                    local ca,sa=math.cos(ag),math.sin(ag)
                    for _,pl in ipairs(P:GetPlayers()) do
                        if pl~=LP and pl.Character then
                            local hr=pl.Character:FindFirstChild("HumanoidRootPart")
                            if hr then
                                local rl=hr.Position-mp
                                local rx=rl.X*ca-rl.Z*sa
                                local rz=rl.X*sa+rl.Z*ca
                                local d=math.sqrt(rx*rx+rz*rz)
                                if d<=CFG.RR then
                                    local dt=Instance.new("Frame") dt.Size=UDim2.new(0,6,0,6)
                                    dt.BackgroundColor3=(pl.Team and pl.Team==LP.Team) and CFG.FC or CFG.EC
                                    dt.BorderSizePixel=0 dt.ZIndex=502
                                    dt.Position=UDim2.new(.5+rx/CFG.RR*.5-.03,0,.5+rz/CFG.RR*.5-.03,0)
                                    dt.Parent=RD
                                    local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(1,0) dc.Parent=dt
                                end
                            end
                        end
                    end
                end
            else RF.Visible=false end
        end
    end)
end
NFT=function()
    S.NF=not S.NF
    if S.NF then
        if OL2.FE==nil then OL2.FE=LG.FogEnd OL2.FS=LG.FogStart OL2.FC=LG.FogColor end
        LG.FogEnd=100000 LG.FogStart=100000
    else
        if OL2.FE then LG.FogEnd=OL2.FE end
        if OL2.FS then LG.FogStart=OL2.FS end
        if OL2.FC then LG.FogColor=OL2.FC end
    end
end
local function CTR()
    for _,t in pairs(TRS) do if t and t.Parent then t:Destroy() end end
    TRS={}
end
local function MKT(pl,c)
    local hd=c:FindFirstChild("Head") if not hd then return end
    local a0=Instance.new("Attachment") a0.Parent=hd
    local a1=Instance.new("Attachment")
    local mh=LP.Character and LP.Character:FindFirstChild("Head")
    if mh then a1.Parent=mh else a1.Parent=hd end
    local bm=Instance.new("Beam")
    bm.Attachment0=a0 bm.Attachment1=a1 bm.FaceCamera=true
    bm.Width0=.15 bm.Width1=.15
    bm.Color=ColorSequence.new(CFG.TC)
    bm.Transparency=NumberSequence.new(.3)
    bm.LightEmission=1 bm.Parent=a0
    TRS[bm]={a0=a0,a1=a1,bm=bm}
end
TRCT=function()
    S.TRC=not S.TRC
    CTR()
    if not S.TRC then return end
    for _,pl in ipairs(P:GetPlayers()) do
        if pl~=LP and pl.Character then MKT(pl,pl.Character) end
    end
end
local function TRCI()
    task.spawn(function()
        while RUN do
            task.wait(1)
            if S.TRC then
                local mh=LP.Character and LP.Character:FindFirstChild("Head")
                if mh then
                    for bm,d in pairs(TRS) do if bm and bm.Parent and d.a1 then d.a1.Parent=mh end end
                end
                for _,pl in ipairs(P:GetPlayers()) do
                    if pl~=LP and pl.Character then
                        local hd=pl.Character:FindFirstChild("Head")
                        if hd and not hd:FindFirstChildOfClass("Attachment") then MKT(pl,pl.Character) end
                    end
                end
            end
        end
    end)
end
PIT=function() S.PI=not S.PI end
TAT=function() S.TA=not S.TA end
local function TAI()
    task.spawn(function()
        while RUN do
            task.wait(.3)
            if S.TA then
                for _,a in pairs(ARR) do if a and a.Parent then a:Destroy() end end
                ARR={}
                local mr=GR()
                if mr then
                    for _,pl in ipairs(P:GetPlayers()) do
                        if pl~=LP and pl.Character then
                            local hr=pl.Character:FindFirstChild("HumanoidRootPart")
                            if hr then
                                local _,os=CM:WorldToViewportPoint(hr.Position)
                                if not os then
                                    local ar=Instance.new("TextLabel") ar.Size=UDim2.new(0,30,0,30) ar.Position=UDim2.new(.5,-15,.5,-15) ar.BackgroundTransparency=1 ar.Text="➨" ar.Font=Enum.Font.GothamBold ar.TextSize=24 ar.TextColor3=CFG.TH.AG ar.TextStrokeTransparency=.3 ar.ZIndex=500 ar.Parent=SG
                                    table.insert(ARR,ar)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end
ERTT=function()
    ESI=(ESI%#ERT)+1
    CFG.ER=ERT[ESI]
end
CHT=function()
    S.CH=not S.CH
    if S.CH then
        if not CRF then
            CRF=Instance.new("Frame") CRF.Size=UDim2.new(0,30,0,30) CRF.Position=UDim2.new(.5,-15,.5,-15) CRF.BackgroundTransparency=1 CRF.ZIndex=999 CRF.Parent=SG
            local h=Instance.new("Frame") h.Size=UDim2.new(1,0,0,2) h.Position=UDim2.new(0,0,.5,-1) h.BackgroundColor3=CFG.TH.AG h.BorderSizePixel=0 h.Parent=CRF
            local v=Instance.new("Frame") v.Size=UDim2.new(0,2,1,0) v.Position=UDim2.new(.5,-1,0,0) v.BackgroundColor3=CFG.TH.AG v.BorderSizePixel=0 v.Parent=CRF
        end
        CRF.Visible=true
    else if CRF then CRF.Visible=false end end
end
RGT=function()
    S.RG=not S.RG
    if S.RG then
        if not RNG then
            RNG=Instance.new("Part") RNG.Shape=Enum.PartType.Cylinder RNG.Size=Vector3.new(.2,CFG.RRad,CFG.RRad) RNG.Anchored=true RNG.CanCollide=false RNG.Transparency=.4 RNG.Color=CFG.TH.AG RNG.Material=Enum.Material.Neon RNG.Parent=workspace
        end
        RNG.Transparency=.4
    else if RNG then RNG.Transparency=1 end end
end
VGT=function()
    S.VG=not S.VG
    if S.VG then
        if not VGF then
            VGF=Instance.new("Frame") VGF.Size=UDim2.new(1,0,1,0) VGF.BackgroundTransparency=1 VGF.ZIndex=0 VGF.Parent=SG
            local function mk(p,s,r)
                local f=Instance.new("Frame") f.Size=s f.Position=p f.BackgroundColor3=Color3.fromRGB(0,0,0) f.BackgroundTransparency=1-CFG.VS f.BorderSizePixel=0 f.Parent=VGF
                local g=Instance.new("UIGradient") g.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)}) g.Rotation=r g.Parent=f
            end
            mk(UDim2.new(0,0,0,0),UDim2.new(1,0,0,80),90)
            mk(UDim2.new(0,0,1,-80),UDim2.new(1,0,0,80),-90)
            mk(UDim2.new(0,0,0,0),UDim2.new(0,80,1,0),0)
            mk(UDim2.new(1,-80,0,0),UDim2.new(0,80,1,0),180)
        end
        VGF.Visible=true
    else if VGF then VGF.Visible=false end end
end
SCT=function()
    S.SC=not S.SC
    if S.SC then
        if not SCF then
            SCF=Instance.new("Frame") SCF.Size=UDim2.new(1,0,1,0) SCF.BackgroundTransparency=1 SCF.ZIndex=998 SCF.Parent=SG
            for i=0,80 do
                local l=Instance.new("Frame") l.Size=UDim2.new(1,0,0,1) l.Position=UDim2.new(0,0,i/80,0) l.BackgroundColor3=Color3.fromRGB(0,0,0) l.BackgroundTransparency=.9 l.BorderSizePixel=0 l.Parent=SCF
            end
        end
        SCF.Visible=true
    else if SCF then SCF.Visible=false end end
end
SNT=function()
    S.SS=not S.SS
    if S.SS then
        if not SNF then
            SNF=Instance.new("Frame") SNF.Size=UDim2.new(1,0,1,0) SNF.BackgroundColor3=Color3.fromRGB(255,255,255) SNF.BackgroundTransparency=.92 SNF.BorderSizePixel=0 SNF.ZIndex=997 SNF.Parent=SG
            task.spawn(function() while S.SS and SNF do SNF.BackgroundTransparency=.88+math.random()*.08 task.wait(.05) end end)
        end
        SNF.Visible=true
    else if SNF then SNF.Visible=false end end
end
TBT=function()
    S.TB=not S.TB
    if not S.TB and LB then LB:Destroy() LB=nil end
end
local function TBU()
    if not S.TB then return end
    local cl,md=nil,math.huge
    local mr=GR() if not mr then return end
    for _,pl in ipairs(P:GetPlayers()) do
        if pl~=LP and pl.Character then
            local hr=pl.Character:FindFirstChild("HumanoidRootPart")
            if hr then
                local d=(hr.Position-mr.Position).Magnitude
                if d<md then md=d cl=pl end
            end
        end
    end
    if cl and cl.Character then
        local hd=cl.Character:FindFirstChild("Head")
        if hd then
            if not LB then
                LB=Instance.new("SelectionBox") LB.Color3=CFG.TH.AG LB.LineThickness=.05 LB.SurfaceTransparency=1 LB.Parent=hd
            end
            LB.Adornee=hd LB.Visible=true
        end
    else if LB then LB.Visible=false end end
end
NST=function()
    S.NS=not S.NS
    if S.ES then EC_() end
end
SB2T=function()
    S.SB=not S.SB
    if S.SB then
        if not BLE then BLE=Instance.new("BlurEffect") BLE.Size=CFG.SBI BLE.Parent=LG end
        BLE.Enabled=true
    else if BLE then BLE.Enabled=false end end
end
local CFS={{Color3.fromRGB(255,255,255),0},{Color3.fromRGB(255,200,150),.3},{Color3.fromRGB(150,200,255),.3},{Color3.fromRGB(255,150,255),.3},{Color3.fromRGB(150,255,200),.3}}
CFT=function()
    S.CFl=not S.CFl
    if not S.CFl then
        if CCE then CCE.Enabled=false end
        CFIdx=1 return
    end
    CFIdx=(CFIdx%#CFS)+1
    local cf=CFS[CFIdx]
    if not CCE then CCE=Instance.new("ColorCorrectionEffect") CCE.Parent=LG end
    CCE.TintColor=cf[1] CCE.Saturation=cf[2] CCE.Enabled=true
end
FET=function()
    S.FE=not S.FE
    if S.FE then
        if OFOV==nil then OFOV=CM.FieldOfView end
        CM.FieldOfView=140
    else if OFOV then CM.FieldOfView=OFOV end end
end
AUT=function()
    S.AU=not S.AU
    if S.AU then
        local c=LP.Character
        if c then
            local h=c:FindFirstChild("HumanoidRootPart")
            if h then
                if not AUE then
                    AUE=Instance.new("ParticleEmitter") AUE.Texture="rbxassetid://243660364" AUE.Rate=CFG.APC AUE.Lifetime=NumberRange.new(1,2) AUE.Speed=NumberRange.new(0,2) AUE.SpreadAngle=Vector2.new(180,180) AUE.Size=NumberSequence.new(.5) AUE.Color=ColorSequence.new(CFG.TH.AG) AUE.LightEmission=1 AUE.Parent=h
                end
                AUE.Enabled=true
            end
        end
    else if AUE then AUE.Enabled=false end end
end
CST=function()
    local sz=CFG.CSS
    local ci=1
    for i,s in ipairs(sz) do if s==S.CS then ci=i end end
    ci=(ci%#sz)+1
    S.CS=sz[ci]
    local c=LP.Character if not c then return end
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
            local o=p:GetAttribute("NX_OrigSize")
            if not o then p:SetAttribute("NX_OrigSize",p.Size) o=p.Size end
            p.Size=o*S.CS
        end
    end
end
TRT=function()
    S.TR=not S.TR
    local c=LP.Character
    if c then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                p.LocalTransparencyModifier=S.TR and .5 or 0
            end
        end
    end
end
RBT=function()
    S.RB=not S.RB
    local c=LP.Character
    if c and not S.RB then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p:GetAttribute("NX_OrigColor") then
                p.Color=p:GetAttribute("NX_OrigColor") p:SetAttribute("NX_OrigColor",nil)
            end
        end
    end
end
OLT=function()
    S.OL=not S.OL
    local c=LP.Character if not c then return end
    if S.OL then
        if not c:FindFirstChild("NX_Outline") then
            local h=Instance.new("Highlight") h.Name="NX_Outline" h.FillTransparency=1 h.OutlineColor=CFG.TH.AG h.OutlineTransparency=0 h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop h.Adornee=c h.Parent=c
        end
    else
        local h=c:FindFirstChild("NX_Outline") if h then h:Destroy() end
    end
end
CRT2=function() S.CRt=not S.CRt end
LST=function()
    S.LS2=not S.LS2
    local c=LP.Character if not c then return end
    local ln={"Left Arm","Right Arm","Left Leg","Right Leg","LeftUpperArm","RightUpperArm","LeftLowerArm","RightLowerArm","LeftUpperLeg","RightUpperLeg","LeftLowerLeg","RightLowerLeg"}
    for _,p in pairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            for _,n in ipairs(ln) do
                if p.Name==n then
                    local o=p:GetAttribute("NX_OrigSize")
                    if not o then p:SetAttribute("NX_OrigSize",p.Size) o=p.Size end
                    if S.LS2 then p.Size=o+Vector3.new(0,2,0) else p.Size=o end
                end
            end
        end
    end
end
NFXT=function()
    S.NFX=not S.NFX
    if S.NFX then
        for _,o in ipairs(workspace:GetDescendants()) do
            if o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then
                if o.Enabled then o.Enabled=false table.insert(HFX,o) end
            end
        end
    else
        for _,o in ipairs(HFX) do if o and o.Parent then o.Enabled=true end end
        HFX={}
    end
end
SIT=function()
    S.SI=not S.SI
    if SIL then SIL.Visible=S.SI end
end
local function SII()
    task.spawn(function()
        while RUN do
            task.wait(1)
            if S.SI and SIL then
                local pc=#P:GetPlayers()
                local pn=0
                local ok,p=pcall(function() return ST.Network.ServerStatsItem["Data Ping"]:GetValue() end)
                if ok and p then pn=math.floor(p) end
                SIL.Text=string.format("服务器信息\n玩家人数: %d\n延迟: %d ms",pc,pn)
            end
        end
    end)
end
RGBT=function() S.RGB=not S.RGB end
local function RGBI()
    task.spawn(function()
        while RUN do
            task.wait(CFG.RCS)
            if S.RGB and Ball then
                Hue=(Hue+.01)%1
                Ball.BackgroundColor3=Color3.fromHSV(Hue,.8,1)
            end
        end
    end)
end
AFKT=function() S.AFK=not S.AFK end
local function AFKI()
    task.spawn(function()
        while RUN do
            task.wait(CFG.AAI)
            if S.AFK then
                local c=LP.Character
                if c then
                    local r=c:FindFirstChild("HumanoidRootPart")
                    if r then
                        local o=r.CFrame
                        r.CFrame=o+Vector3.new((math.random()-.5)*CFG.AAM,0,(math.random()-.5)*CFG.AAM)
                        task.wait(.1)
                        if r and r.Parent then r.CFrame=o end
                    end
                end
            end
        end
    end)
end
local function EC_() 
    for b,_ in pairs(EH) do if b and b.Parent then b:Destroy() end end
    EH={}
end
local function MKE(pl,c)
    local hd=c:FindFirstChild("Head") if not hd then return end
    local tm=pl.Team and pl.Team==LP.Team
    local b=Instance.new("BillboardGui") b.Name="ESP_APEX" b.Size=UDim2.new(0,120,0,80) b.StudsOffset=Vector3.new(0,3,0) b.AlwaysOnTop=true b.Adornee=hd b.Parent=hd
    local nl=Instance.new("TextLabel") nl.Name="ESP_Name" nl.Size=UDim2.new(1,0,.3,0) nl.BackgroundTransparency=1 nl.Text=pl.Name nl.TextColor3=tm and CFG.TH.GR or CFG.TH.AG nl.TextStrokeTransparency=(S.NS and 0 or 1) nl.Font=Enum.Font.GothamBold nl.TextSize=14 nl.Parent=b
    local dl=Instance.new("TextLabel") dl.Name="ESP_Dist" dl.Size=UDim2.new(1,0,.25,0) dl.Position=UDim2.new(0,0,.3,0) dl.BackgroundTransparency=1 dl.Text="0m" dl.TextColor3=Color3.fromRGB(255,255,255) dl.Font=Enum.Font.Gotham dl.TextSize=12 dl.Parent=b
    local il=Instance.new("TextLabel") il.Name="ESP_Info" il.Size=UDim2.new(1,0,.25,0) il.Position=UDim2.new(0,0,.55,0) il.BackgroundTransparency=1 il.Text="" il.TextColor3=Color3.fromRGB(200,220,255) il.Font=Enum.Font.Gotham il.TextSize=10 il.Parent=b
    EH[b]=true
end
local function EIV(hd)
    if not S.ESV then return true end
    local c=GC() if not c then return true end
    local d=hd.Position-CM.CFrame.Position
    local ds=d.Magnitude
    if ds<.1 then return true end
    local dr=d/ds
    return not RB2(CM.CFrame.Position,CM.CFrame.Position+dr*300,{c,hd.Parent})
end
EST=function() S.ES=not S.ES if not S.ES then EC_() end end
ESVT=function() S.ESV=not S.ESV if S.ES then EC_() end end
local function ESI_()
    local function hk(pl)
        if pl==LP then return end
        pl.CharacterAdded:Connect(function(c)
            if not S.ES then return end
            task.wait(.1)
            if S.ES and c.Parent then MKE(pl,c) end
        end)
    end
    for _,p in pairs(P:GetPlayers()) do hk(p) end
    CN.pae=P.PlayerAdded:Connect(hk)
    CN.pre=P.PlayerRemoving:Connect(function(pl)
        if pl.Character then
            local hd=pl.Character:FindFirstChild("Head")
            if hd then
                local b=hd:FindFirstChild("ESP_APEX")
                if b then b:Destroy() EH[b]=nil end
            end
        end
    end)
    task.spawn(function()
        while RUN do
            local s=pcall(function()
                if S.ES then
                    local mr=getRoot and GR()
                    if mr and mr.Position.Y>100 then CFG.ER=math.max(CFG.ER,150) end
                    local r=GR()
                    if r then
                        local mp=r.Position
                        local tr={}
                        for b,_ in pairs(EH) do if not b or not b.Parent then table.insert(tr,b) end end
                        for _,b in ipairs(tr) do EH[b]=nil end
                        for _,pl in ipairs(P:GetPlayers()) do
                            if pl~=LP and pl.Character then
                                local c=pl.Character
                                local hd=c:FindFirstChild("Head")
                                local hr=c:FindFirstChild("HumanoidRootPart")
                                if hd and hr then
                                    local d=(hr.Position-mp).Magnitude
                                    if d<=CFG.ER and EIV(hd) then
                                        local b=hd:FindFirstChild("ESP_APEX")
                                        if not b then MKE(pl,c)
                                        else
                                            local dl=b:FindFirstChild("ESP_Dist")
                                            if dl then dl.Text=math.floor(d).."m" end
                                            if S.PI then
                                                local il=b:FindFirstChild("ESP_Info")
                                                if il then
                                                    local h=c:FindFirstChildOfClass("Humanoid")
                                                    local hp=h and math.floor(h.Health) or 0
                                                    local tm=pl.Team and pl.Team.Name or "无"
                                                    il.Text="HP: "..hp.." | "..tm
                                                end
                                            end
                                        end
                                    else
                                        local b=hd:FindFirstChild("ESP_APEX")
                                        if b then b:Destroy() EH[b]=nil end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if not s then task.wait(2) end
            local pc=#P:GetPlayers()
            task.wait(pc>CFG.EMP and CFG.ERef*2 or CFG.ERef)
        end
    end)
end
local function AHT()
    if not CFG.HTE then return end
    local c=LP.Character if not c then return end
    local hd=c:FindFirstChild("Head")
    if not hd or hd:FindFirstChild("APEX_Tag") then return end
    local b=Instance.new("BillboardGui") b.Name="APEX_Tag" b.Size=UDim2.new(0,220,0,30) b.StudsOffset=Vector3.new(0,3,0) b.AlwaysOnTop=true b.Adornee=hd b.Parent=hd
    local l=Instance.new("TextLabel") l.Size=UDim2.new(1,0,1,0) l.BackgroundTransparency=1 l.Text=CFG.HTT l.TextColor3=CFG.HTC l.TextStrokeTransparency=.2 l.Font=Enum.Font.GothamBold l.TextSize=18 l.Parent=b
end
local function SHT()
    if not CFG.HTE then return end
    AHT()
    CN.ht=LP.CharacterAdded:Connect(function() task.wait(1) AHT() end)
end
local function OCR()
    task.wait(1.5)
    local h=GH() local c=LP.Character
    if not h or not c then return end
    if S.SPB>0 then local t={50,100,180} h.WalkSpeed=t[S.SPB] or 16 end
    if S.JB then h.JumpPower=CFG.JP h.UseJumpPower=true end
    if S.TR then
        for _,p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.LocalTransparencyModifier=.5 end
        end
    end
    if S.OL and not c:FindFirstChild("NX_Outline") then
        local hl=Instance.new("Highlight") hl.Name="NX_Outline" hl.FillTransparency=1 hl.OutlineColor=CFG.TH.AG hl.OutlineTransparency=0 hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop hl.Adornee=c hl.Parent=c
    end
    if S.NC then NCP=NGP() end
end
FVT=function()
    S.FV=not S.FV
    if S.FV then
        if OFOV==nil then OFOV=CM.FieldOfView end
        CM.FieldOfView=100
        if FVL then FVL.Visible=true FVL.Text="FOV: 100" end
    else
        if OFOV then CM.FieldOfView=OFOV end
        if FVL then FVL.Visible=false end
    end
end
CPT=function() S.CP=not S.CP end
local function CPI()
    CN.cp=U.InputBegan:Connect(function(i,gp)
        if gp then return end
        if not S.CP then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 then return end
        local m=LP:GetMouse()
        local t=m.Target
        if t then print("[APEX] 部件:",t.Name,"类:",t.ClassName) end
    end)
end
MBT=function()
    S.MB=not S.MB
    if S.MB then
        if not MBB then
            MBB=Instance.new("SelectionBox") MBB.Color3=CFG.TH.AG MBB.LineThickness=.1 MBB.SurfaceTransparency=1
            local b=Instance.new("Part") b.Size=Vector3.new(2048,2048,2048) b.Anchored=true b.CanCollide=false b.Transparency=1 b.Position=Vector3.new(0,0,0) b.Parent=workspace
            MBB.Adornee=b MBB.Parent=b
        end
        MBB.Visible=true
    else if MBB then MBB.Visible=false end end
end
local function FWU()
    if S.RG and RNG then
        local r=GR()
        if r then RNG.CFrame=CFrame.new(r.Position-Vector3.new(0,3,0))*CFrame.Angles(0,0,math.rad(90)) end
    end
    if S.RB then
        RIdx=(RIdx+.005)%1
        local col=Color3.fromHSV(RIdx,.8,1)
        local c=LP.Character
        if c then
            for _,p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then
                    if not p:GetAttribute("NX_OrigColor") then p:SetAttribute("NX_OrigColor",p.Color) end
                    p.Color=col
                end
            end
        end
    end
    if S.CRt then
        local r=GR()
        if r then r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(CRS),0) end
    end
    if S.TB then TBU() end
end
local function FWI()
    CN.fw=R.Heartbeat:Connect(FWU)
end
MAS=function()
    S.FL=false S.NC=false S.ES=false S.FST=2 S.ESV=false
    S.IJ=false S.WW=false S.SPB=0 S.SR=false S.JB=false
    S.SPD=false S.LGV=false S.ZGV=false S.AF=false S.CTP=false
    S.NV=false S.HL=false S.RDR=false S.NF=false S.NFX=false S.SI=false S.RGB=false
    S.TRC=false S.PI=false S.THL=false S.TA=false S.FV=false S.CP=false S.FH=false
    S.MB=false S.AFK=false S.CH=false S.RG=false S.VG=false S.SC=false S.SS=false S.TB=false S.NS=false
    S.SB=false S.CFl=false S.FE=false S.AU=false S.CS=1 S.TR=false
    S.RB=false S.OL=false S.CRt=false S.LS2=false
    if S.FCM then FCT() end
    local h=GH()
    if h then h.PlatformStand=false h.WalkSpeed=16 h.JumpPower=50 h.UseJumpPower=false end
    local r=GR() if r then r.AssemblyLinearVelocity=VZ end
    workspace.Gravity=196.2
    if OL2.B then LG.Brightness=OL2.B end
    if OL2.A then LG.Ambient=OL2.A end
    if OL2.OA then LG.OutdoorAmbient=OL2.OA end
    if OL2.FE then LG.FogEnd=OL2.FE end
    if OL2.FS then LG.FogStart=OL2.FS end
    if OFOV then CM.FieldOfView=OFOV end
    NRE() EC_() CHL() CTR()
    for _,o in ipairs(HFX) do if o and o.Parent then o.Enabled=true end end
    HFX={}
    if SIL then SIL.Visible=false end
    if RF then RF.Visible=false end
    if FVL then FVL.Visible=false end
    for _,a in pairs(ARR) do if a and a.Parent then a:Destroy() end end
    ARR={}
    if MBB then MBB.Visible=false end
    if CRF then CRF.Visible=false end
    if VGF then VGF.Visible=false end
    if SCF then SCF.Visible=false end
    if SNF then SNF.Visible=false end
    if RNG then RNG.Transparency=1 end
    if AUE then AUE.Enabled=false end
    if BLE then BLE.Enabled=false end
    if CCE then CCE.Enabled=false end
    if LB then LB:Destroy() LB=nil end
    if LP.Character then
        local ol=LP.Character:FindFirstChild("NX_Outline") if ol then ol:Destroy() end
        for _,p in pairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then
                local o=p:GetAttribute("NX_OrigSize")
                if o then p.Size=o p:SetAttribute("NX_OrigSize",nil) end
                p.LocalTransparencyModifier=0
                local oc=p:GetAttribute("NX_OrigColor")
                if oc then p.Color=oc p:SetAttribute("NX_OrigColor",nil) end
            end
        end
    end
    SP(S.PG)
end
MSD=function()
    RUN=false
    for k,c in pairs(CN) do SAFE("d"..k,function() c:Disconnect() end) end
    CN={}
    SAFE("du",function() if SG and SG.Parent then SG:Destroy() end end)
    SAFE("sc",function() if SI_ then SI_:Destroy() SI_=nil end end)
    LOG("shutdown complete")
end
local LPI=game.PlaceId
task.spawn(function()
    while RUN do
        task.wait(2)
        if game.PlaceId~=LPI then
            LPI=game.PlaceId
            SAFE("sr",function()
                if S.FL then FLT() end
                if S.NC then ND() end
                EC_()
            end)
        end
    end
end)
SLS()
task.wait(2.1)
local IL={FI,NI,ESI_,IJI,WWI,FCI,SRI,SPDI,AFI,CTPI,FHI,HLI,RDI,SII,RGBI,AFKI,TRCI,TAI,CPI,FWI,SHT}
if UII() then
    for _,f in ipairs(IL) do pcall(f) end
    STU()
else
    for _,f in ipairs(IL) do pcall(f) end
end
LOG("APEX v"..V.." loaded - Core Hub Ready")
