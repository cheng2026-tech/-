--[[
    黑洞 v8 - 最终整合版
    功能：飞行/无限跳/穿墙/连点器/天气/雷达/玩家列表/聊天/防护/特效/工具/娱乐/关于
    注意：部分功能为本地视觉，部分依赖执行器环境（writefile/readfile/gethui）
]]

-- ================= 服务 =================
local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local S=game:GetService("Stats")
local L=game:GetService("Lighting")
local G=game:GetService("StarterGui")
local VU=game:GetService("VirtualUser")
local RS=game:GetService("ReplicatedStorage")
local HS=game:GetService("HttpService")
local plr=P.LocalPlayer

-- ================= 全局变量 =================
local clickerRate = 10
local alertRange = 30
local clickerRandom = false
local clickerRange = 0
local fOn=false;local fSp=100;local fCn=nil;local fPos=Vector3.new(0,0,0)
local jOn=false;local jCn={}
local noclipOn=false;local noclipCn=nil
local antiAFKOn=false;local afkCn=nil
local isDark=true
local createdAtm=nil
local savedPos=nil
local posA,posB=nil,nil
local history={}
local chatHistory={}
local originalName=plr.Name
local miniOn=false
local airWalkOn=false;local airWalkCn=nil
local hoverOn=false;local hoverCn=nil
local pickupOn=false;local pickupCn=nil
local clickerOn=false;local clickerCn=nil
local teleportOn=false;local teleportCn=nil
local followOn=false;local followCn=nil
local lockViewOn=false;local lockViewCn=nil
local invisDetectOn=false;local invisDetectCn=nil
local antiInvisOn=false;local antiInvisCn=nil
local enemyAlertOn=false;local enemyAlertCn=nil
local glowOn=false;local glowLights={}
local trailOn=false;local trailAttach=nil
local currentSky=nil
local currentFilter=nil
local nameFlashOn=false;local nameFlashCn=nil;local nameFlashGui=nil
local spinOn=false;local spinCn=nil
local danceOn=false;local danceAnim=nil
local autoReplyOn=false
local autoMsgOn=false;local autoMsgCn=nil
local shadowOn=false;local shadowFrame=nil
local weatherIdx=1

-- ================= GUI 挂载 =================
local function mt(g)
    if type(gethui)=="function" then
        local ok=pcall(function() g.Parent=gethui() end)
        if ok and g.Parent then return end
    end
    local ok2=pcall(function() g.Parent=game:GetService("CoreGui") end)
    if ok2 and g.Parent then return end
    pcall(function() g.Parent=plr:WaitForChild("PlayerGui") end)
end

-- ================= 加载动画 =================
local LG=Instance.new("ScreenGui");LG.Name="加载";LG.ResetOnSpawn=false;LG.IgnoreGuiInset=true;mt(LG)
local LBF=Instance.new("Frame",LG);LBF.Size=UDim2.new(0,300,0,4);LBF.Position=UDim2.new(0.5,-150,0.5);LBF.BackgroundColor3=Color3.fromRGB(30,30,35);LBF.BorderSizePixel=0
Instance.new("UICorner",LBF).CornerRadius=UDim.new(1,0)
local LBF2=Instance.new("Frame",LBF);LBF2.Size=UDim2.new(0,0,1,0);LBF2.BackgroundColor3=Color3.fromRGB(120,80,255);LBF2.BorderSizePixel=0
Instance.new("UICorner",LBF2).CornerRadius=UDim.new(1,0)
task.spawn(function()
    for i=1,10 do task.wait(0.1); LBF2.Size=UDim2.new(i/10,0,1,0) end
    LG:Destroy()
end)

-- ================= 主面板 =================
local SG=Instance.new("ScreenGui");SG.Name="黑洞";SG.ResetOnSpawn=false;mt(SG)
local MF=Instance.new("Frame",SG)
MF.Size=UDim2.new(0,600,0,420);MF.Position=UDim2.new(0.5,-300,0.5,-210)
MF.BackgroundColor3=Color3.fromRGB(18,18,22);MF.BorderSizePixel=0;MF.Active=true;MF.Draggable=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
Instance.new("UIStroke",MF).Color=Color3.fromRGB(100,200,255)

local FBt=Instance.new("ImageButton",SG);FBt.Size=UDim2.new(0,52,0,52);FBt.Position=UDim2.new(0,10,0.5,-26)
FBt.BackgroundColor3=Color3.fromRGB(20,20,28);FBt.Image="rbxassetid://10479022679";FBt.ScaleType=Enum.ScaleType.Fit
Instance.new("UICorner",FBt).CornerRadius=UDim.new(1,0);Instance.new("UIStroke",FBt).Color=Color3.fromRGB(120,200,255)
FBt.Activated:Connect(function() MF.Visible=not MF.Visible end)

local TB=Instance.new("Frame",MF);TB.Size=UDim2.new(1,0,0,36);TB.BackgroundColor3=Color3.fromRGB(24,24,30);TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,12)
local TT=Instance.new("TextLabel",TB);TT.Size=UDim2.new(0.6,0,1,0);TT.Position=UDim2.new(0,15,0,0);TT.BackgroundTransparency=1;TT.Text="黑洞 v812";TT.TextColor3=Color3.fromRGB(200,200,220);TT.TextSize=13;TT.Font=Enum.Font.GothamBold;TT.TextXAlignment=Enum.TextXAlignment.Left
local XB=Instance.new("TextButton",TB);XB.Size=UDim2.new(0,24,0,24);XB.Position=UDim2.new(1,-34,0,6);XB.BackgroundColor3=Color3.fromRGB(40,40,50);XB.Text="×";XB.TextColor3=Color3.fromRGB(255,255,255);XB.TextSize=14;XB.Font=Enum.Font.GothamBold
Instance.new("UICorner",XB).CornerRadius=UDim.new(0,6)

local CF=Instance.new("Frame",SG);CF.Size=UDim2.new(0,260,0,120);CF.Position=UDim2.new(0.5,-130,0.5,-60);CF.BackgroundColor3=Color3.fromRGB(20,20,28);CF.BorderSizePixel=0;CF.Visible=false;CF.ZIndex=500
Instance.new("UICorner",CF).CornerRadius=UDim.new(0,12)
local CSt=Instance.new("UIStroke",CF);CSt.Color=Color3.fromRGB(255,100,100);CSt.Thickness=1.5;CSt.ZIndex=501
local CT=Instance.new("TextLabel",CF);CT.Size=UDim2.new(1,0,0,40);CT.Position=UDim2.new(0,0,0,15);CT.BackgroundTransparency=1;CT.Text="⚠️ 确定要关闭吗主人？";CT.TextColor3=Color3.fromRGB(255,120,120);CT.TextSize=14;CT.Font=Enum.Font.GothamBold;CT.ZIndex=502
local YesB=Instance.new("TextButton",CF);YesB.Size=UDim2.new(0,100,0,32);YesB.Position=UDim2.new(0,15,0,70);YesB.BackgroundColor3=Color3.fromRGB(200,50,60);YesB.Text="确定关闭";YesB.TextColor3=Color3.fromRGB(255,255,255);YesB.TextSize=12;YesB.Font=Enum.Font.GothamBold;YesB.ZIndex=502
Instance.new("UICorner",YesB).CornerRadius=UDim.new(0,8)
local NoB=Instance.new("TextButton",CF);NoB.Size=UDim2.new(0,100,0,32);NoB.Position=UDim2.new(1,-115,0,70);NoB.BackgroundColor3=Color3.fromRGB(40,40,55);NoB.Text="取消";NoB.TextColor3=Color3.fromRGB(200,200,200);NoB.TextSize=12;NoB.Font=Enum.Font.GothamBold;NoB.ZIndex=502
Instance.new("UICorner",NoB).CornerRadius=UDim.new(0,8)
XB.Activated:Connect(function() CF.Visible=true end)
NoB.Activated:Connect(function() CF.Visible=false end)
YesB.Activated:Connect(function() SG:Destroy() end)

-- ================= 侧边栏 / 内容区 =================
local SB=Instance.new("Frame",MF);SB.Size=UDim2.new(0,130,1,-42);SB.Position=UDim2.new(0,6,0,42);SB.BackgroundColor3=Color3.fromRGB(22,22,28);SB.BorderSizePixel=0
Instance.new("UICorner",SB).CornerRadius=UDim.new(0,8)
local CB=Instance.new("Frame",MF);CB.Size=UDim2.new(1,-148,1,-42);CB.Position=UDim2.new(0,142,0,42);CB.BackgroundColor3=Color3.fromRGB(22,22,28);CB.BorderSizePixel=0
Instance.new("UICorner",CB).CornerRadius=UDim.new(0,8)

local Pages={};local TabButtons={}
local function AddTab(name,icon)
    local btn=Instance.new("TextButton",SB);btn.Size=UDim2.new(1,-8,0,32);btn.Position=UDim2.new(0,4,0,4+(#TabButtons*36))
    btn.BackgroundColor3=Color3.fromRGB(30,30,38);btn.Text=icon.." "..name;btn.TextColor3=Color3.fromRGB(180,180,200);btn.TextSize=12;btn.Font=Enum.Font.Gotham;btn.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    local page=Instance.new("Frame",CB);page.Size=UDim2.new(1,-12,1,-12);page.Position=UDim2.new(0,6,0,6);page.BackgroundTransparency=1;page.Visible=false
    Pages[name]=page;table.insert(TabButtons,{btn=btn,page=page,name=name})
    btn.Activated:Connect(function()
        for _,v in ipairs(TabButtons) do v.btn.BackgroundColor3=Color3.fromRGB(30,30,38);v.btn.TextColor3=Color3.fromRGB(180,180,200);v.page.Visible=false end
        btn.BackgroundColor3=Color3.fromRGB(45,45,60);btn.TextColor3=Color3.fromRGB(120,200,255);page.Visible=true
    end)
end
AddTab("通用","🏠");AddTab("监控","📊");AddTab("视觉","👁️");AddTab("天气","☁️");AddTab("高级","🚀");AddTab("社交","👥");AddTab("防护","🛡");AddTab("特效","🎨");AddTab("工具","🔧");AddTab("娱乐","🌟");AddTab("关于","ℹ️")
TabButtons[1].btn.BackgroundColor3=Color3.fromRGB(45,45,60);TabButtons[1].btn.TextColor3=Color3.fromRGB(120,200,255);TabButtons[1].page.Visible=true

-- ================= 通用页 =================
local H=Instance.new("Frame",Pages["通用"]);H.Size=UDim2.new(1,0,0,60);H.BackgroundColor3=Color3.fromRGB(30,30,38);H.BorderSizePixel=0
Instance.new("UICorner",H).CornerRadius=UDim.new(0,8)
local HT=Instance.new("TextLabel",H);HT.Size=UDim2.new(1,0,0,30);HT.Position=UDim2.new(0,10,0,5);HT.BackgroundTransparency=1;HT.Text="基础功能";HT.TextColor3=Color3.fromRGB(200,200,220);HT.TextSize=14;HT.Font=Enum.Font.GothamBold;HT.TextXAlignment=Enum.TextXAlignment.Left
local FB=Instance.new("TextButton",H);FB.Size=UDim2.new(0,150,0,24);FB.Position=UDim2.new(0,10,0,32);FB.BackgroundColor3=Color3.fromRGB(45,45,60);FB.Text="飞行:关";FB.TextColor3=Color3.fromRGB(220,220,220);FB.TextSize=12;FB.Font=Enum.Font.Gotham
Instance.new("UICorner",FB).CornerRadius=UDim.new(0,6)
local JB=Instance.new("TextButton",H);JB.Size=UDim2.new(0,150,0,24);JB.Position=UDim2.new(0,170,0,32);JB.BackgroundColor3=Color3.fromRGB(45,45,60);JB.Text="无限跳:关";JB.TextColor3=Color3.fromRGB(220,220,220);JB.TextSize=12;JB.Font=Enum.Font.Gotham
Instance.new("UICorner",JB).CornerRadius=UDim.new(0,6)

local FS=Instance.new("TextLabel",Pages["通用"]);FS.Size=UDim2.new(1,-20,0,15);FS.Position=UDim2.new(0,10,0,70);FS.BackgroundTransparency=1;FS.Text="飞行速度: 100";FS.TextColor3=Color3.fromRGB(180,180,200);FS.TextSize=11;FS.Font=Enum.Font.Gotham;FS.TextXAlignment=Enum.TextXAlignment.Left
local FSS=Instance.new("Frame",Pages["通用"]);FSS.Size=UDim2.new(1,-20,0,8);FSS.Position=UDim2.new(0,10,0,90);FSS.BackgroundColor3=Color3.fromRGB(40,40,55);FSS.BorderSizePixel=0
Instance.new("UICorner",FSS).CornerRadius=UDim.new(1,0)
local FSF=Instance.new("Frame",FSS);FSF.Size=UDim2.new(0.1,0,1,0);FSF.BackgroundColor3=Color3.fromRGB(120,80,255);FSF.BorderSizePixel=0
Instance.new("UICorner",FSF).CornerRadius=UDim.new(1,0)

local WS=Instance.new("TextLabel",Pages["通用"]);WS.Size=UDim2.new(1,-20,0,15);WS.Position=UDim2.new(0,10,0,110);WS.BackgroundTransparency=1;WS.Text="跑步速度: 16";WS.TextColor3=Color3.fromRGB(180,180,200);WS.TextSize=11;WS.Font=Enum.Font.Gotham;WS.TextXAlignment=Enum.TextXAlignment.Left
local WSS=Instance.new("Frame",Pages["通用"]);WSS.Size=UDim2.new(1,-20,0,8);WSS.Position=UDim2.new(0,10,0,130);WSS.BackgroundColor3=Color3.fromRGB(40,40,55);WSS.BorderSizePixel=0
Instance.new("UICorner",WSS).CornerRadius=UDim.new(1,0)
local WSF=Instance.new("Frame",WSS);WSF.Size=UDim2.new(0.05,0,1,0);WSF.BackgroundColor3=Color3.fromRGB(120,80,255);WSF.BorderSizePixel=0
Instance.new("UICorner",WSF).CornerRadius=UDim.new(1,0)

local JumpPowerL=Instance.new("TextLabel",Pages["通用"]);JumpPowerL.Size=UDim2.new(1,-20,0,15);JumpPowerL.Position=UDim2.new(0,10,0,150);JumpPowerL.BackgroundTransparency=1;JumpPowerL.Text="跳跃力: 50";JumpPowerL.TextColor3=Color3.fromRGB(180,180,200);JumpPowerL.TextSize=11;JumpPowerL.Font=Enum.Font.Gotham;JumpPowerL.TextXAlignment=Enum.TextXAlignment.Left
local JPS=Instance.new("Frame",Pages["通用"]);JPS.Size=UDim2.new(1,-20,0,8);JPS.Position=UDim2.new(0,10,0,170);JPS.BackgroundColor3=Color3.fromRGB(40,40,55);JPS.BorderSizePixel=0
Instance.new("UICorner",JPS).CornerRadius=UDim.new(1,0)
local JPF=Instance.new("Frame",JPS);JPF.Size=UDim2.new(0.05,0,1,0);JPF.BackgroundColor3=Color3.fromRGB(120,80,255);JPF.BorderSizePixel=0
Instance.new("UICorner",JPF).CornerRadius=UDim.new(1,0)

local AutoJumpB=Instance.new("TextButton",Pages["通用"]);AutoJumpB.Size=UDim2.new(0,150,0,32);AutoJumpB.Position=UDim2.new(0,10,0,200);AutoJumpB.BackgroundColor3=Color3.fromRGB(45,45,60);AutoJumpB.Text="⏫ 跳跃";AutoJumpB.TextColor3=Color3.fromRGB(220,220,220);AutoJumpB.TextSize=12;AutoJumpB.Font=Enum.Font.Gotham
Instance.new("UICorner",AutoJumpB).CornerRadius=UDim.new(0,6)
local AirWalkB=Instance.new("TextButton",Pages["通用"]);AirWalkB.Size=UDim2.new(0,150,0,32);AirWalkB.Position=UDim2.new(0,170,0,200);AirWalkB.BackgroundColor3=Color3.fromRGB(45,45,60);AirWalkB.Text="🪂 空中行走:关";AirWalkB.TextColor3=Color3.fromRGB(220,220,220);AirWalkB.TextSize=12;AirWalkB.Font=Enum.Font.Gotham
Instance.new("UICorner",AirWalkB).CornerRadius=UDim.new(0,6)
local SavePosB=Instance.new("TextButton",Pages["通用"]);SavePosB.Size=UDim2.new(0,150,0,32);SavePosB.Position=UDim2.new(0,10,0,240);SavePosB.BackgroundColor3=Color3.fromRGB(60,80,150);SavePosB.Text="📍 保存当前位置";SavePosB.TextColor3=Color3.fromRGB(255,255,255);SavePosB.TextSize=12;SavePosB.Font=Enum.Font.Gotham
Instance.new("UICorner",SavePosB).CornerRadius=UDim.new(0,6)
local TeleBackB=Instance.new("TextButton",Pages["通用"]);TeleBackB.Size=UDim2.new(0,150,0,32);TeleBackB.Position=UDim2.new(0,170,0,240);TeleBackB.BackgroundColor3=Color3.fromRGB(150,80,60);TeleBackB.Text="🔙 传送回保存点";TeleBackB.TextColor3=Color3.fromRGB(255,255,255);TeleBackB.TextSize=12;TeleBackB.Font=Enum.Font.Gotham
Instance.new("UICorner",TeleBackB).CornerRadius=UDim.new(0,6)
local SuperJumpB=Instance.new("TextButton",Pages["通用"]);SuperJumpB.Size=UDim2.new(0,150,0,32);SuperJumpB.Position=UDim2.new(0,10,0,280);SuperJumpB.BackgroundColor3=Color3.fromRGB(80,50,140);SuperJumpB.Text="🦘 超级跳";SuperJumpB.TextColor3=Color3.fromRGB(255,255,255);SuperJumpB.TextSize=12;SuperJumpB.Font=Enum.Font.Gotham
Instance.new("UICorner",SuperJumpB).CornerRadius=UDim.new(0,6)
local TeleportB=Instance.new("TextButton",Pages["通用"]);TeleportB.Size=UDim2.new(0,150,0,32);TeleportB.Position=UDim2.new(0,170,0,280);TeleportB.BackgroundColor3=Color3.fromRGB(80,50,140);TeleportB.Text="✈️ 瞬移到鼠标点";TeleportB.TextColor3=Color3.fromRGB(255,255,255);TeleportB.TextSize=12;TeleportB.Font=Enum.Font.Gotham
Instance.new("UICorner",TeleportB).CornerRadius=UDim.new(0,6)

-- ================= 监控页 =================
local FLL=Instance.new("TextLabel",Pages["监控"]);FLL.Size=UDim2.new(1,-20,0,20);FLL.Position=UDim2.new(0,10,0,10);FLL.BackgroundTransparency=1;FLL.Text="FPS: --";FLL.TextColor3=Color3.fromRGB(82,196,26);FLL.TextSize=14;FLL.Font=Enum.Font.Code;FLL.TextXAlignment=Enum.TextXAlignment.Left
local PLL=Instance.new("TextLabel",Pages["监控"]);PLL.Size=UDim2.new(1,-20,0,20);PLL.Position=UDim2.new(0,10,0,40);PLL.BackgroundTransparency=1;PLL.Text="延迟: --";PLL.TextColor3=Color3.fromRGB(255,193,7);PLL.TextSize=14;PLL.Font=Enum.Font.Code;PLL.TextXAlignment=Enum.TextXAlignment.Left
local MLL=Instance.new("TextLabel",Pages["监控"]);MLL.Size=UDim2.new(1,-20,0,20);MLL.Position=UDim2.new(0,10,0,70);MLL.BackgroundTransparency=1;MLL.Text="内存: --";MLL.TextColor3=Color3.fromRGB(0,150,220);MLL.TextSize=14;MLL.Font=Enum.Font.Code;MLL.TextXAlignment=Enum.TextXAlignment.Left
local COORD=Instance.new("TextLabel",Pages["监控"]);COORD.Size=UDim2.new(1,-20,0,20);COORD.Position=UDim2.new(0,10,0,100);COORD.BackgroundTransparency=1;COORD.Text="坐标: --";COORD.TextColor3=Color3.fromRGB(150,220,255);COORD.TextSize=14;COORD.Font=Enum.Font.Code;COORD.TextXAlignment=Enum.TextXAlignment.Left
local OptB=Instance.new("TextButton",Pages["监控"]);OptB.Size=UDim2.new(0,150,0,28);OptB.Position=UDim2.new(0,10,0,140);OptB.BackgroundColor3=Color3.fromRGB(60,120,60);OptB.Text="⚡ 一键优化+清理";OptB.TextColor3=Color3.fromRGB(255,255,255);OptB.TextSize=11;OptB.Font=Enum.Font.GothamBold
Instance.new("UICorner",OptB).CornerRadius=UDim.new(0,6)
local OptL=Instance.new("TextLabel",Pages["监控"]);OptL.Size=UDim2.new(1,-20,0,40);OptL.Position=UDim2.new(0,10,0,175);OptL.BackgroundTransparency=1;OptL.Text="";OptL.TextColor3=Color3.fromRGB(150,220,150);OptL.TextSize=10;OptL.Font=Enum.Font.Code;OptL.TextWrapped=true;OptL.TextXAlignment=Enum.TextXAlignment.Left
local ServerInfoL=Instance.new("TextLabel",Pages["监控"]);ServerInfoL.Size=UDim2.new(1,-20,0,60);ServerInfoL.Position=UDim2.new(0,10,0,215);ServerInfoL.BackgroundTransparency=1;ServerInfoL.Text="服务器: --";ServerInfoL.TextColor3=Color3.fromRGB(200,220,255);ServerInfoL.TextSize=11;ServerInfoL.Font=Enum.Font.Code;ServerInfoL.TextWrapped=true;ServerInfoL.TextXAlignment=Enum.TextXAlignment.Left
local RadarTitle=Instance.new("TextLabel",Pages["监控"]);RadarTitle.Size=UDim2.new(1,-20,0,15);RadarTitle.Position=UDim2.new(0,10,0,280);RadarTitle.BackgroundTransparency=1;RadarTitle.Text="雷达 - 周围玩家";RadarTitle.TextColor3=Color3.fromRGB(120,200,255);RadarTitle.TextSize=11;RadarTitle.Font=Enum.Font.GothamBold;RadarTitle.TextXAlignment=Enum.TextXAlignment.Left
local RadarFrame=Instance.new("Frame",Pages["监控"]);RadarFrame.Size=UDim2.new(1,-20,0,100);RadarFrame.Position=UDim2.new(0,10,0,300);RadarFrame.BackgroundColor3=Color3.fromRGB(15,15,22);RadarFrame.BorderSizePixel=0
Instance.new("UICorner",RadarFrame).CornerRadius=UDim.new(0,6)
local RadarStroke=Instance.new("UIStroke",RadarFrame)
RadarStroke.Color=Color3.fromRGB(50,50,60)
RadarStroke.Thickness=1

-- 雷达图形化
local RadarCanvas=Instance.new("Frame",RadarFrame)
RadarCanvas.Size=UDim2.new(1,-10,1,-10)
RadarCanvas.Position=UDim2.new(0,5,0,5)
RadarCanvas.BackgroundTransparency=1
local RadarCenter=Instance.new("Frame",RadarCanvas)
RadarCenter.Size=UDim2.new(0,6,0,6)
RadarCenter.Position=UDim2.new(0.5,-3,0.5,-3)
RadarCenter.BackgroundColor3=Color3.fromRGB(120,200,255)
RadarCenter.BorderSizePixel=0
Instance.new("UICorner",RadarCenter).CornerRadius=UDim.new(1,0)
local radarDots={}
local function updateRadar()
    local myR=gR()
    if not myR then return end
    local myPos=myR.Position
    local cam=workspace.CurrentCamera
    if not cam then return end
    local myLook=cam.CFrame.LookVector
    local myRight=cam.CFrame.RightVector
    local maxDist=200
    for _,d in ipairs(radarDots) do d:Destroy() end
    radarDots={}
    for _,other in ipairs(P:GetPlayers()) do
        if other~=plr then
            local oc=other.Character
            local ohrp=oc and oc:FindFirstChild("HumanoidRootPart")
            if ohrp then
                local rel=ohrp.Position-myPos
                local dist=rel.Magnitude
                if dist<=maxDist then
                    local x=rel:Dot(myRight)
                    local z=rel:Dot(myLook)
                    local px=math.clamp(x/maxDist,-1,1)
                    local pz=math.clamp(z/maxDist,-1,1)
                    local dot=Instance.new("Frame",RadarCanvas)
                    dot.Size=UDim2.new(0,6,0,6)
                    dot.Position=UDim2.new(0.5+px*0.5,-3,0.5-pz*0.5,-3)
                    dot.BackgroundColor3=Color3.fromRGB(255,80,80)
                    dot.BorderSizePixel=0
                    dot.ZIndex=10
                    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
                    table.insert(radarDots,dot)
                end
            end
        end
    end
end

-- ================= 视觉页 =================
local GetDelToolB=Instance.new("TextButton",Pages["视觉"]);GetDelToolB.Size=UDim2.new(0,180,0,32);GetDelToolB.Position=UDim2.new(0,10,0,10);GetDelToolB.BackgroundColor3=Color3.fromRGB(200,60,60);GetDelToolB.Text="🗑️ 获取删除工具";GetDelToolB.TextColor3=Color3.fromRGB(255,255,255);GetDelToolB.TextSize=12;GetDelToolB.Font=Enum.Font.Gotham
Instance.new("UICorner",GetDelToolB).CornerRadius=UDim.new(0,6)
local RsB=Instance.new("TextButton",Pages["视觉"]);RsB.Size=UDim2.new(0,150,0,32);RsB.Position=UDim2.new(0,200,0,10);RsB.BackgroundColor3=Color3.fromRGB(40,40,55);RsB.Text="♻️ 恢复全部";RsB.TextColor3=Color3.fromRGB(200,200,200);RsB.TextSize=12;RsB.Font=Enum.Font.Gotham
Instance.new("UICorner",RsB).CornerRadius=UDim.new(0,6)
local NoclipB=Instance.new("TextButton",Pages["视觉"]);NoclipB.Size=UDim2.new(0,150,0,32);NoclipB.Position=UDim2.new(0,10,0,52);NoclipB.BackgroundColor3=Color3.fromRGB(45,45,60);NoclipB.Text="🚪 穿墙:关";NoclipB.TextColor3=Color3.fromRGB(220,220,220);NoclipB.TextSize=12;NoclipB.Font=Enum.Font.Gotham
Instance.new("UICorner",NoclipB).CornerRadius=UDim.new(0,6)
local AntiAFK=Instance.new("TextButton",Pages["视觉"]);AntiAFK.Size=UDim2.new(0,150,0,32);AntiAFK.Position=UDim2.new(0,170,0,52);AntiAFK.BackgroundColor3=Color3.fromRGB(45,45,60);AntiAFK.Text="💤 防挂机:关";AntiAFK.TextColor3=Color3.fromRGB(220,220,220);AntiAFK.TextSize=12;AntiAFK.Font=Enum.Font.Gotham
Instance.new("UICorner",AntiAFK).CornerRadius=UDim.new(0,6)
local HoverB=Instance.new("TextButton",Pages["视觉"]);HoverB.Size=UDim2.new(0,150,0,32);HoverB.Position=UDim2.new(0,10,0,94);HoverB.BackgroundColor3=Color3.fromRGB(60,80,150);HoverB.Text="🪁 悬停工具:关";HoverB.TextColor3=Color3.fromRGB(255,255,255);HoverB.TextSize=12;HoverB.Font=Enum.Font.Gotham
Instance.new("UICorner",HoverB).CornerRadius=UDim.new(0,6)
local PickupB=Instance.new("TextButton",Pages["视觉"]);PickupB.Size=UDim2.new(0,150,0,32);PickupB.Position=UDim2.new(0,170,0,94);PickupB.BackgroundColor3=Color3.fromRGB(60,120,60);PickupB.Text="🧲 自动拾取:关";PickupB.TextColor3=Color3.fromRGB(255,255,255);PickupB.TextSize=12;PickupB.Font=Enum.Font.Gotham
Instance.new("UICorner",PickupB).CornerRadius=UDim.new(0,6)
local ClickerB=Instance.new("TextButton",Pages["视觉"]);ClickerB.Size=UDim2.new(0,150,0,32);ClickerB.Position=UDim2.new(0,10,0,136);ClickerB.BackgroundColor3=Color3.fromRGB(45,45,60);ClickerB.Text="🖱️ 连点器:关";ClickerB.TextColor3=Color3.fromRGB(220,220,220);ClickerB.TextSize=12;ClickerB.Font=Enum.Font.Gotham
Instance.new("UICorner",ClickerB).CornerRadius=UDim.new(0,6)
local ClickSpdL=Instance.new("TextLabel",Pages["视觉"]);ClickSpdL.Size=UDim2.new(1,-20,0,15);ClickSpdL.Position=UDim2.new(0,10,0,176);ClickSpdL.BackgroundTransparency=1;ClickSpdL.Text="连点速度: 10 次/秒";ClickSpdL.TextColor3=Color3.fromRGB(180,180,200);ClickSpdL.TextSize=11;ClickSpdL.Font=Enum.Font.Gotham;ClickSpdL.TextXAlignment=Enum.TextXAlignment.Left
local ClickSpdS=Instance.new("Frame",Pages["视觉"]);ClickSpdS.Size=UDim2.new(1,-20,0,8);ClickSpdS.Position=UDim2.new(0,10,0,196);ClickSpdS.BackgroundColor3=Color3.fromRGB(40,40,55);ClickSpdS.BorderSizePixel=0
Instance.new("UICorner",ClickSpdS).CornerRadius=UDim.new(1,0)
local ClickSpdF=Instance.new("Frame",ClickSpdS);ClickSpdF.Size=UDim2.new(0.1,0,1,0);ClickSpdF.BackgroundColor3=Color3.fromRGB(120,80,255);ClickSpdF.BorderSizePixel=0
Instance.new("UICorner",ClickSpdF).CornerRadius=UDim.new(1,0)

-- ================= 天气页 =================
local WeatherB=Instance.new("TextButton",Pages["天气"]);WeatherB.Size=UDim2.new(0,150,0,32);WeatherB.Position=UDim2.new(0,10,0,10);WeatherB.BackgroundColor3=Color3.fromRGB(50,100,150);WeatherB.Text="☀️ 晴天";WeatherB.TextColor3=Color3.fromRGB(255,255,255);WeatherB.TextSize=12;WeatherB.Font=Enum.Font.Gotham
Instance.new("UICorner",WeatherB).CornerRadius=UDim.new(0,6)
local TimeB=Instance.new("TextButton",Pages["天气"]);TimeB.Size=UDim2.new(0,150,0,32);TimeB.Position=UDim2.new(0,170,0,10);TimeB.BackgroundColor3=Color3.fromRGB(50,100,150);TimeB.Text="☀️ 正午";TimeB.TextColor3=Color3.fromRGB(255,255,255);TimeB.TextSize=12;TimeB.Font=Enum.Font.Gotham
Instance.new("UICorner",TimeB).CornerRadius=UDim.new(0,6)

-- ================= 高级页 =================
local TeleToPlayerL=Instance.new("TextLabel",Pages["高级"]);TeleToPlayerL.Size=UDim2.new(1,-20,0,15);TeleToPlayerL.Position=UDim2.new(0,10,0,10);TeleToPlayerL.BackgroundTransparency=1;TeleToPlayerL.Text="传送到指定玩家";TeleToPlayerL.TextColor3=Color3.fromRGB(180,180,200);TeleToPlayerL.TextSize=11;TeleToPlayerL.Font=Enum.Font.Gotham;TeleToPlayerL.TextXAlignment=Enum.TextXAlignment.Left
local TelePlayerBox=Instance.new("TextBox",Pages["高级"]);TelePlayerBox.Size=UDim2.new(0.6,0,0,30);TelePlayerBox.Position=UDim2.new(0,10,0,30);TelePlayerBox.BackgroundColor3=Color3.fromRGB(30,30,38);TelePlayerBox.BorderSizePixel=0;TelePlayerBox.Text="";TelePlayerBox.PlaceholderText="输入玩家名字";TelePlayerBox.TextColor3=Color3.fromRGB(220,220,220);TelePlayerBox.PlaceholderColor3=Color3.fromRGB(120,120,140);TelePlayerBox.TextSize=12;TelePlayerBox.Font=Enum.Font.Gotham
Instance.new("UICorner",TelePlayerBox).CornerRadius=UDim.new(0,6)
local TelePlayerB=Instance.new("TextButton",Pages["高级"]);TelePlayerB.Size=UDim2.new(0.3,0,0,30);TelePlayerB.Position=UDim2.new(0.65,0,0,30);TelePlayerB.BackgroundColor3=Color3.fromRGB(60,80,150);TelePlayerB.Text="传送到";TelePlayerB.TextColor3=Color3.fromRGB(255,255,255);TelePlayerB.TextSize=12;TelePlayerB.Font=Enum.Font.Gotham
Instance.new("UICorner",TelePlayerB).CornerRadius=UDim.new(0,6)
local FollowB=Instance.new("TextButton",Pages["高级"]);FollowB.Size=UDim2.new(0,180,0,30);FollowB.Position=UDim2.new(0,10,0,70);FollowB.BackgroundColor3=Color3.fromRGB(45,45,60);FollowB.Text="🚶 自动跟随:关";FollowB.TextColor3=Color3.fromRGB(220,220,220);FollowB.TextSize=12;FollowB.Font=Enum.Font.Gotham
Instance.new("UICorner",FollowB).CornerRadius=UDim.new(0,6)
local FollowNameBox=Instance.new("TextBox",Pages["高级"]);FollowNameBox.Size=UDim2.new(0.4,0,0,30);FollowNameBox.Position=UDim2.new(0.55,0,0,70);FollowNameBox.BackgroundColor3=Color3.fromRGB(30,30,38);FollowNameBox.BorderSizePixel=0;FollowNameBox.Text="";FollowNameBox.PlaceholderText="要跟随的玩家名";FollowNameBox.TextColor3=Color3.fromRGB(220,220,220);FollowNameBox.PlaceholderColor3=Color3.fromRGB(120,120,140);FollowNameBox.TextSize=12;FollowNameBox.Font=Enum.Font.Gotham
Instance.new("UICorner",FollowNameBox).CornerRadius=UDim.new(0,6)
local LockViewB=Instance.new("TextButton",Pages["高级"]);LockViewB.Size=UDim2.new(0,180,0,30);LockViewB.Position=UDim2.new(0,10,0,110);LockViewB.BackgroundColor3=Color3.fromRGB(45,45,60);LockViewB.Text="👁️ 锁定视角:关";LockViewB.TextColor3=Color3.fromRGB(220,220,220);LockViewB.TextSize=12;LockViewB.Font=Enum.Font.Gotham
Instance.new("UICorner",LockViewB).CornerRadius=UDim.new(0,6)
local LockViewBox=Instance.new("TextBox",Pages["高级"]);LockViewBox.Size=UDim2.new(0.4,0,0,30);LockViewBox.Position=UDim2.new(0.55,0,0,110);LockViewBox.BackgroundColor3=Color3.fromRGB(30,30,38);LockViewBox.BorderSizePixel=0;LockViewBox.Text="";LockViewBox.PlaceholderText="要看的玩家名";LockViewBox.TextColor3=Color3.fromRGB(220,220,220);LockViewBox.PlaceholderColor3=Color3.fromRGB(120,120,140);LockViewBox.TextSize=12;LockViewBox.Font=Enum.Font.Gotham
Instance.new("UICorner",LockViewBox).CornerRadius=UDim.new(0,6)
local MarkAB=Instance.new("TextButton",Pages["高级"]);MarkAB.Size=UDim2.new(0,90,0,30);MarkAB.Position=UDim2.new(0,10,0,150);MarkAB.BackgroundColor3=Color3.fromRGB(60,80,150);MarkAB.Text="🅰️ 标记A";MarkAB.TextColor3=Color3.fromRGB(255,255,255);MarkAB.TextSize=12;MarkAB.Font=Enum.Font.Gotham
Instance.new("UICorner",MarkAB).CornerRadius=UDim.new(0,6)
local TeleAB=Instance.new("TextButton",Pages["高级"]);TeleAB.Size=UDim2.new(0,90,0,30);TeleAB.Position=UDim2.new(0,105,0,150);TeleAB.BackgroundColor3=Color3.fromRGB(60,120,60);TeleAB.Text="➡️ 去A";TeleAB.TextColor3=Color3.fromRGB(255,255,255);TeleAB.TextSize=12;TeleAB.Font=Enum.Font.Gotham
Instance.new("UICorner",TeleAB).CornerRadius=UDim.new(0,6)
local MarkBB=Instance.new("TextButton",Pages["高级"]);MarkBB.Size=UDim2.new(0,90,0,30);MarkBB.Position=UDim2.new(0,200,0,150);MarkBB.BackgroundColor3=Color3.fromRGB(60,80,150);MarkBB.Text="🅱️ 标记B";MarkBB.TextColor3=Color3.fromRGB(255,255,255);MarkBB.TextSize=12;MarkBB.Font=Enum.Font.Gotham
Instance.new("UICorner",MarkBB).CornerRadius=UDim.new(0,6)
local TeleBB=Instance.new("TextButton",Pages["高级"]);TeleBB.Size=UDim2.new(0,90,0,30);TeleBB.Position=UDim2.new(0,295,0,150);TeleBB.BackgroundColor3=Color3.fromRGB(60,120,60);TeleBB.Text="➡️ 去B";TeleBB.TextColor3=Color3.fromRGB(255,255,255);TeleBB.TextSize=12;TeleBB.Font=Enum.Font.Gotham
Instance.new("UICorner",TeleBB).CornerRadius=UDim.new(0,6)
local HistTitle=Instance.new("TextLabel",Pages["高级"]);HistTitle.Size=UDim2.new(1,-20,0,15);HistTitle.Position=UDim2.new(0,10,0,190);HistTitle.BackgroundTransparency=1;HistTitle.Text="传送历史（最近5个）";HistTitle.TextColor3=Color3.fromRGB(180,180,200);HistTitle.TextSize=11;HistTitle.Font=Enum.Font.Gotham;HistTitle.TextXAlignment=Enum.TextXAlignment.Left
local HistList=Instance.new("ScrollingFrame",Pages["高级"]);HistList.Size=UDim2.new(1,-20,0,120);HistList.Position=UDim2.new(0,10,0,210);HistList.BackgroundColor3=Color3.fromRGB(15,15,22);HistList.BorderSizePixel=0;HistList.ScrollBarThickness=3;HistList.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",HistList).CornerRadius=UDim.new(0,6)
local HistLayout=Instance.new("UIListLayout",HistList);HistLayout.Padding=UDim.new(0,2)

-- ================= 社交页 =================
local PlayerListTitle=Instance.new("TextLabel",Pages["社交"]);PlayerListTitle.Size=UDim2.new(1,-20,0,18);PlayerListTitle.Position=UDim2.new(0,10,0,10);PlayerListTitle.BackgroundTransparency=1;PlayerListTitle.Text="玩家列表";PlayerListTitle.TextColor3=Color3.fromRGB(180,180,200);PlayerListTitle.TextSize=12;PlayerListTitle.Font=Enum.Font.GothamBold;PlayerListTitle.TextXAlignment=Enum.TextXAlignment.Left
local PlayerListFrame=Instance.new("ScrollingFrame",Pages["社交"]);PlayerListFrame.Size=UDim2.new(1,-20,0,130);PlayerListFrame.Position=UDim2.new(0,10,0,32);PlayerListFrame.BackgroundColor3=Color3.fromRGB(15,15,22);PlayerListFrame.BorderSizePixel=0;PlayerListFrame.ScrollBarThickness=3;PlayerListFrame.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",PlayerListFrame).CornerRadius=UDim.new(0,6)
local PlayerListLayout=Instance.new("UIListLayout",PlayerListFrame);PlayerListLayout.Padding=UDim.new(0,2)
local MyHpLabel=Instance.new("TextLabel",Pages["社交"]);MyHpLabel.Size=UDim2.new(1,-20,0,18);MyHpLabel.Position=UDim2.new(0,10,0,170);MyHpLabel.BackgroundTransparency=1;MyHpLabel.Text="我的血量: --";MyHpLabel.TextColor3=Color3.fromRGB(255,100,100);MyHpLabel.TextSize=12;MyHpLabel.Font=Enum.Font.Gotham;MyHpLabel.TextXAlignment=Enum.TextXAlignment.Left
local PlayerInfoTitle=Instance.new("TextLabel",Pages["社交"]);PlayerInfoTitle.Size=UDim2.new(1,-20,0,18);PlayerInfoTitle.Position=UDim2.new(0,10,0,195);PlayerInfoTitle.BackgroundTransparency=1;PlayerInfoTitle.Text="查看玩家属性";PlayerInfoTitle.TextColor3=Color3.fromRGB(180,180,200);PlayerInfoTitle.TextSize=12;PlayerInfoTitle.Font=Enum.Font.GothamBold;PlayerInfoTitle.TextXAlignment=Enum.TextXAlignment.Left
local PlayerInfoBox=Instance.new("TextBox",Pages["社交"]);PlayerInfoBox.Size=UDim2.new(0.6,0,0,28);PlayerInfoBox.Position=UDim2.new(0,10,0,215);PlayerInfoBox.BackgroundColor3=Color3.fromRGB(30,30,38);PlayerInfoBox.BorderSizePixel=0;PlayerInfoBox.Text="";PlayerInfoBox.PlaceholderText="输入玩家名字";PlayerInfoBox.TextColor3=Color3.fromRGB(220,220,220);PlayerInfoBox.PlaceholderColor3=Color3.fromRGB(120,120,140);PlayerInfoBox.TextSize=12;PlayerInfoBox.Font=Enum.Font.Gotham
Instance.new("UICorner",PlayerInfoBox).CornerRadius=UDim.new(0,6)
local PlayerInfoB=Instance.new("TextButton",Pages["社交"]);PlayerInfoB.Size=UDim2.new(0.3,0,0,28);PlayerInfoB.Position=UDim2.new(0.65,0,0,215);PlayerInfoB.BackgroundColor3=Color3.fromRGB(60,80,150);PlayerInfoB.Text="查看";PlayerInfoB.TextColor3=Color3.fromRGB(255,255,255);PlayerInfoB.TextSize=12;PlayerInfoB.Font=Enum.Font.Gotham
Instance.new("UICorner",PlayerInfoB).CornerRadius=UDim.new(0,6)
local PlayerInfoResult=Instance.new("TextLabel",Pages["社交"]);PlayerInfoResult.Size=UDim2.new(1,-20,0,80);PlayerInfoResult.Position=UDim2.new(0,10,0,250);PlayerInfoResult.BackgroundTransparency=1;PlayerInfoResult.Text="";PlayerInfoResult.TextColor3=Color3.fromRGB(220,220,220);PlayerInfoResult.TextSize=11;PlayerInfoResult.Font=Enum.Font.Code;PlayerInfoResult.TextWrapped=true;PlayerInfoResult.TextXAlignment=Enum.TextXAlignment.Left;PlayerInfoResult.TextYAlignment=Enum.TextYAlignment.Top
local ChatLogTitle=Instance.new("TextLabel",Pages["社交"]);ChatLogTitle.Size=UDim2.new(1,-20,0,18);ChatLogTitle.Position=UDim2.new(0,10,0,340);ChatLogTitle.BackgroundTransparency=1;ChatLogTitle.Text="聊天记录（最多 50 条）";ChatLogTitle.TextColor3=Color3.fromRGB(180,180,200);ChatLogTitle.TextSize=12;ChatLogTitle.Font=Enum.Font.GothamBold;ChatLogTitle.TextXAlignment=Enum.TextXAlignment.Left
local ChatLogFrame=Instance.new("ScrollingFrame",Pages["社交"]);ChatLogFrame.Size=UDim2.new(1,-20,0,100);ChatLogFrame.Position=UDim2.new(0,10,0,362);ChatLogFrame.BackgroundColor3=Color3.fromRGB(15,15,22);ChatLogFrame.BorderSizePixel=0;ChatLogFrame.ScrollBarThickness=3;ChatLogFrame.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",ChatLogFrame).CornerRadius=UDim.new(0,6)
local ChatLogLayout=Instance.new("UIListLayout",ChatLogFrame);ChatLogLayout.Padding=UDim.new(0,2)
local AutoReplyBox=Instance.new("TextBox",Pages["社交"]);AutoReplyBox.Size=UDim2.new(0.6,0,0,28);AutoReplyBox.Position=UDim2.new(0,10,0,470);AutoReplyBox.BackgroundColor3=Color3.fromRGB(30,30,38);AutoReplyBox.BorderSizePixel=0;AutoReplyBox.Text="";AutoReplyBox.PlaceholderText="自动回复内容（留空=关闭）";AutoReplyBox.TextColor3=Color3.fromRGB(220,220,220);AutoReplyBox.PlaceholderColor3=Color3.fromRGB(120,120,140);AutoReplyBox.TextSize=12;AutoReplyBox.Font=Enum.Font.Gotham
Instance.new("UICorner",AutoReplyBox).CornerRadius=UDim.new(0,6)
local AutoReplyB=Instance.new("TextButton",Pages["社交"]);AutoReplyB.Size=UDim2.new(0.3,0,0,28);AutoReplyB.Position=UDim2.new(0.65,0,0,470);AutoReplyB.BackgroundColor3=Color3.fromRGB(60,120,60);AutoReplyB.Text="开启回复";AutoReplyB.TextColor3=Color3.fromRGB(255,255,255);AutoReplyB.TextSize=12;AutoReplyB.Font=Enum.Font.Gotham
Instance.new("UICorner",AutoReplyB).CornerRadius=UDim.new(0,6)

-- 聊天发送框
local ChatSendBox=Instance.new("TextBox",Pages["社交"])
ChatSendBox.Size=UDim2.new(0.6,0,0,28)
ChatSendBox.Position=UDim2.new(0,10,0,510)
ChatSendBox.BackgroundColor3=Color3.fromRGB(30,30,38)
ChatSendBox.BorderSizePixel=0
ChatSendBox.Text=""
ChatSendBox.PlaceholderText="输入要发送的消息"
ChatSendBox.TextColor3=Color3.fromRGB(220,220,220)
ChatSendBox.PlaceholderColor3=Color3.fromRGB(120,120,140)
ChatSendBox.TextSize=12
ChatSendBox.Font=Enum.Font.Gotham
Instance.new("UICorner",ChatSendBox).CornerRadius=UDim.new(0,6)
local ChatSendB=Instance.new("TextButton",Pages["社交"])
ChatSendB.Size=UDim2.new(0.3,0,0,28)
ChatSendB.Position=UDim2.new(0.65,0,0,510)
ChatSendB.BackgroundColor3=Color3.fromRGB(60,120,60)
ChatSendB.Text="发送"
ChatSendB.TextColor3=Color3.fromRGB(255,255,255)
ChatSendB.TextSize=12
ChatSendB.Font=Enum.Font.Gotham
Instance.new("UICorner",ChatSendB).CornerRadius=UDim.new(0,6)

-- ================= 防护页 =================
local AdminCheckT=Instance.new("TextLabel",Pages["防护"]);AdminCheckT.Size=UDim2.new(1,-20,0,18);AdminCheckT.Position=UDim2.new(0,10,0,10);AdminCheckT.BackgroundTransparency=1;AdminCheckT.Text="管理员检测记录";AdminCheckT.TextColor3=Color3.fromRGB(180,180,200);AdminCheckT.TextSize=12;AdminCheckT.Font=Enum.Font.GothamBold;AdminCheckT.TextXAlignment=Enum.TextXAlignment.Left
local AdminCheckF=Instance.new("ScrollingFrame",Pages["防护"]);AdminCheckF.Size=UDim2.new(1,-20,0,120);AdminCheckF.Position=UDim2.new(0,10,0,32);AdminCheckF.BackgroundColor3=Color3.fromRGB(15,15,22);AdminCheckF.BorderSizePixel=0;AdminCheckF.ScrollBarThickness=3;AdminCheckF.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",AdminCheckF).CornerRadius=UDim.new(0,6)
Instance.new("UIListLayout",AdminCheckF).Padding=UDim.new(0,2)
local InvisDetectB=Instance.new("TextButton",Pages["防护"]);InvisDetectB.Size=UDim2.new(0,180,0,30);InvisDetectB.Position=UDim2.new(0,10,0,160);InvisDetectB.BackgroundColor3=Color3.fromRGB(45,45,60);InvisDetectB.Text="👻 隐身检测:关";InvisDetectB.TextColor3=Color3.fromRGB(220,220,220);InvisDetectB.TextSize=12;InvisDetectB.Font=Enum.Font.Gotham
Instance.new("UICorner",InvisDetectB).CornerRadius=UDim.new(0,6)
local AntiInvisB=Instance.new("TextButton",Pages["防护"]);AntiInvisB.Size=UDim2.new(0,180,0,30);AntiInvisB.Position=UDim2.new(0,200,0,160);AntiInvisB.BackgroundColor3=Color3.fromRGB(45,45,60);AntiInvisB.Text="👀 反隐身:关";AntiInvisB.TextColor3=Color3.fromRGB(220,220,220);AntiInvisB.TextSize=12;AntiInvisB.Font=Enum.Font.Gotham
Instance.new("UICorner",AntiInvisB).CornerRadius=UDim.new(0,6)
local EnemyAlertB=Instance.new("TextButton",Pages["防护"]);EnemyAlertB.Size=UDim2.new(0,180,0,30);EnemyAlertB.Position=UDim2.new(0,10,0,200);EnemyAlertB.BackgroundColor3=Color3.fromRGB(45,45,60);EnemyAlertB.Text="🚨 敌人接近警报:关";EnemyAlertB.TextColor3=Color3.fromRGB(220,220,220);EnemyAlertB.TextSize=12;EnemyAlertB.Font=Enum.Font.Gotham
Instance.new("UICorner",EnemyAlertB).CornerRadius=UDim.new(0,6)
local AlertRangeL=Instance.new("TextLabel",Pages["防护"]);AlertRangeL.Size=UDim2.new(1,-20,0,15);AlertRangeL.Position=UDim2.new(0,10,0,240);AlertRangeL.BackgroundTransparency=1;AlertRangeL.Text="警报距离: 30 米";AlertRangeL.TextColor3=Color3.fromRGB(180,180,200);AlertRangeL.TextSize=11;AlertRangeL.Font=Enum.Font.Gotham;AlertRangeL.TextXAlignment=Enum.TextXAlignment.Left
local AlertRangeS=Instance.new("Frame",Pages["防护"]);AlertRangeS.Size=UDim2.new(1,-20,0,8);AlertRangeS.Position=UDim2.new(0,10,0,258);AlertRangeS.BackgroundColor3=Color3.fromRGB(40,40,55);AlertRangeS.BorderSizePixel=0
Instance.new("UICorner",AlertRangeS).CornerRadius=UDim.new(1,0)
local AlertRangeF=Instance.new("Frame",AlertRangeS);AlertRangeF.Size=UDim2.new(0.3,0,1,0);AlertRangeF.BackgroundColor3=Color3.fromRGB(200,60,60);AlertRangeF.BorderSizePixel=0
Instance.new("UICorner",AlertRangeF).CornerRadius=UDim.new(1,0)

-- ================= 特效页 =================
local SkyT=Instance.new("TextLabel",Pages["特效"]);SkyT.Size=UDim2.new(1,-20,0,18);SkyT.Position=UDim2.new(0,10,0,10);SkyT.BackgroundTransparency=1;SkyT.Text="天空盒";SkyT.TextColor3=Color3.fromRGB(180,180,200);SkyT.TextSize=12;SkyT.Font=Enum.Font.GothamBold;SkyT.TextXAlignment=Enum.TextXAlignment.Left
local Sky1B=Instance.new("TextButton",Pages["特效"]);Sky1B.Size=UDim2.new(0,110,0,30);Sky1B.Position=UDim2.new(0,10,0,30);Sky1B.BackgroundColor3=Color3.fromRGB(60,80,150);Sky1B.Text="⭐ 星空";Sky1B.TextColor3=Color3.fromRGB(255,255,255);Sky1B.TextSize=11;Sky1B.Font=Enum.Font.Gotham
Instance.new("UICorner",Sky1B).CornerRadius=UDim.new(0,6)
local Sky2B=Instance.new("TextButton",Pages["特效"]);Sky2B.Size=UDim2.new(0,110,0,30);Sky2B.Position=UDim2.new(0,125,0,30);Sky2B.BackgroundColor3=Color3.fromRGB(150,80,60);Sky2B.Text="🌅 日落";Sky2B.TextColor3=Color3.fromRGB(255,255,255);Sky2B.TextSize=11;Sky2B.Font=Enum.Font.Gotham
Instance.new("UICorner",Sky2B).CornerRadius=UDim.new(0,6)
local Sky3B=Instance.new("TextButton",Pages["特效"]);Sky3B.Size=UDim2.new(0,110,0,30);Sky3B.Position=UDim2.new(0,240,0,30);Sky3B.BackgroundColor3=Color3.fromRGB(150,60,150);Sky3B.Text="🌈 赛博朋克";Sky3B.TextColor3=Color3.fromRGB(255,255,255);Sky3B.TextSize=11;Sky3B.Font=Enum.Font.Gotham
Instance.new("UICorner",Sky3B).CornerRadius=UDim.new(0,6)
local GlowB=Instance.new("TextButton",Pages["特效"]);GlowB.Size=UDim2.new(0,150,0,30);GlowB.Position=UDim2.new(0,10,0,70);GlowB.BackgroundColor3=Color3.fromRGB(45,45,60);GlowB.Text="✨ 角色发光:关";GlowB.TextColor3=Color3.fromRGB(220,220,220);GlowB.TextSize=12;GlowB.Font=Enum.Font.Gotham
Instance.new("UICorner",GlowB).CornerRadius=UDim.new(0,6)
local TrailB=Instance.new("TextButton",Pages["特效"]);TrailB.Size=UDim2.new(0,150,0,30);TrailB.Position=UDim2.new(0,170,0,70);TrailB.BackgroundColor3=Color3.fromRGB(45,45,60);TrailB.Text="🌈 角色拖尾:关";TrailB.TextColor3=Color3.fromRGB(220,220,220);TrailB.TextSize=12;TrailB.Font=Enum.Font.Gotham
Instance.new("UICorner",TrailB).CornerRadius=UDim.new(0,6)
local FovL=Instance.new("TextLabel",Pages["特效"]);FovL.Size=UDim2.new(1,-20,0,15);FovL.Position=UDim2.new(0,10,0,110);FovL.BackgroundTransparency=1;FovL.Text="视野 FOV: 70";FovL.TextColor3=Color3.fromRGB(180,180,200);FovL.TextSize=11;FovL.Font=Enum.Font.Gotham;FovL.TextXAlignment=Enum.TextXAlignment.Left
local FovS=Instance.new("Frame",Pages["特效"]);FovS.Size=UDim2.new(1,-20,0,8);FovS.Position=UDim2.new(0,10,0,128);FovS.BackgroundColor3=Color3.fromRGB(40,40,55);FovS.BorderSizePixel=0
Instance.new("UICorner",FovS).CornerRadius=UDim.new(1,0)
local FovF=Instance.new("Frame",FovS);FovF.Size=UDim2.new(0.5,0,1,0);FovF.BackgroundColor3=Color3.fromRGB(120,80,255);FovF.BorderSizePixel=0
Instance.new("UICorner",FovF).CornerRadius=UDim.new(1,0)
local FilterRB=Instance.new("TextButton",Pages["特效"]);FilterRB.Size=UDim2.new(0,100,0,30);FilterRB.Position=UDim2.new(0,10,0,150);FilterRB.BackgroundColor3=Color3.fromRGB(150,60,60);FilterRB.Text="🔴 红色滤镜";FilterRB.TextColor3=Color3.fromRGB(255,255,255);FilterRB.TextSize=11;FilterRB.Font=Enum.Font.Gotham
Instance.new("UICorner",FilterRB).CornerRadius=UDim.new(0,6)
local FilterBB=Instance.new("TextButton",Pages["特效"]);FilterBB.Size=UDim2.new(0,100,0,30);FilterBB.Position=UDim2.new(0,115,0,150);FilterBB.BackgroundColor3=Color3.fromRGB(60,60,150);FilterBB.Text="🔵 蓝色滤镜";FilterBB.TextColor3=Color3.fromRGB(255,255,255);FilterBB.TextSize=11;FilterBB.Font=Enum.Font.Gotham
Instance.new("UICorner",FilterBB).CornerRadius=UDim.new(0,6)
local FilterWB=Instance.new("TextButton",Pages["特效"]);FilterWB.Size=UDim2.new(0,100,0,30);FilterWB.Position=UDim2.new(0,220,0,150);FilterWB.BackgroundColor3=Color3.fromRGB(60,60,60);FilterWB.Text="⚫ 黑白滤镜";FilterWB.TextColor3=Color3.fromRGB(255,255,255);FilterWB.TextSize=11;FilterWB.Font=Enum.Font.Gotham
Instance.new("UICorner",FilterWB).CornerRadius=UDim.new(0,6)
local FilterOffB=Instance.new("TextButton",Pages["特效"]);FilterOffB.Size=UDim2.new(0,100,0,30);FilterOffB.Position=UDim2.new(0,325,0,150);FilterOffB.BackgroundColor3=Color3.fromRGB(60,120,60);FilterOffB.Text="✅ 关闭滤镜";FilterOffB.TextColor3=Color3.fromRGB(255,255,255);FilterOffB.TextSize=11;FilterOffB.Font=Enum.Font.Gotham
Instance.new("UICorner",FilterOffB).CornerRadius=UDim.new(0,6)

-- 角色缩放
local ScaleL=Instance.new("TextLabel",Pages["特效"])
ScaleL.Size=UDim2.new(1,-20,0,15)
ScaleL.Position=UDim2.new(0,10,0,200)
ScaleL.BackgroundTransparency=1
ScaleL.Text="角色大小: 1.0x"
ScaleL.TextColor3=Color3.fromRGB(180,180,200)
ScaleL.TextSize=11
ScaleL.Font=Enum.Font.Gotham
ScaleL.TextXAlignment=Enum.TextXAlignment.Left
local ScaleS=Instance.new("Frame",Pages["特效"])
ScaleS.Size=UDim2.new(1,-20,0,8)
ScaleS.Position=UDim2.new(0,10,0,218)
ScaleS.BackgroundColor3=Color3.fromRGB(40,40,55)
ScaleS.BorderSizePixel=0
Instance.new("UICorner",ScaleS).CornerRadius=UDim.new(1,0)
local ScaleF=Instance.new("Frame",ScaleS)
ScaleF.Size=UDim2.new(0.5,0,1,0)
ScaleF.BackgroundColor3=Color3.fromRGB(120,80,255)
ScaleF.BorderSizePixel=0
Instance.new("UICorner",ScaleF).CornerRadius=UDim.new(1,0)

-- ================= 工具页 =================
local HotkeyTitle=Instance.new("TextLabel",Pages["工具"]);HotkeyTitle.Size=UDim2.new(1,-20,0,18);HotkeyTitle.Position=UDim2.new(0,10,0,10);HotkeyTitle.BackgroundTransparency=1;HotkeyTitle.Text="自定义热键";HotkeyTitle.TextColor3=Color3.fromRGB(180,180,200);HotkeyTitle.TextSize=12;HotkeyTitle.Font=Enum.Font.GothamBold;HotkeyTitle.TextXAlignment=Enum.TextXAlignment.Left
local HotkeyFlyB=Instance.new("TextButton",Pages["工具"]);HotkeyFlyB.Size=UDim2.new(0,180,0,30);HotkeyFlyB.Position=UDim2.new(0,10,0,32);HotkeyFlyB.BackgroundColor3=Color3.fromRGB(45,45,60);HotkeyFlyB.Text="F1 → 飞行开关:关";HotkeyFlyB.TextColor3=Color3.fromRGB(220,220,220);HotkeyFlyB.TextSize=12;HotkeyFlyB.Font=Enum.Font.Gotham
Instance.new("UICorner",HotkeyFlyB).CornerRadius=UDim.new(0,6)
local HotkeyClickerB=Instance.new("TextButton",Pages["工具"]);HotkeyClickerB.Size=UDim2.new(0,180,0,30);HotkeyClickerB.Position=UDim2.new(0,200,0,32);HotkeyClickerB.BackgroundColor3=Color3.fromRGB(45,45,60);HotkeyClickerB.Text="F2 → 连点器:关";HotkeyClickerB.TextColor3=Color3.fromRGB(220,220,220);HotkeyClickerB.TextSize=12;HotkeyClickerB.Font=Enum.Font.Gotham
Instance.new("UICorner",HotkeyClickerB).CornerRadius=UDim.new(0,6)
local HotkeyTeleB=Instance.new("TextButton",Pages["工具"]);HotkeyTeleB.Size=UDim2.new(0,180,0,30);HotkeyTeleB.Position=UDim2.new(0,10,0,70);HotkeyTeleB.BackgroundColor3=Color3.fromRGB(45,45,60);HotkeyTeleB.Text="F3 → 瞬移开关:关";HotkeyTeleB.TextColor3=Color3.fromRGB(220,220,220);HotkeyTeleB.TextSize=12;HotkeyTeleB.Font=Enum.Font.Gotham
Instance.new("UICorner",HotkeyTeleB).CornerRadius=UDim.new(0,6)
local HotkeyNoclipB=Instance.new("TextButton",Pages["工具"]);HotkeyNoclipB.Size=UDim2.new(0,180,0,30);HotkeyNoclipB.Position=UDim2.new(0,200,0,70);HotkeyNoclipB.BackgroundColor3=Color3.fromRGB(45,45,60);HotkeyNoclipB.Text="F4 → 穿墙开关:关";HotkeyNoclipB.TextColor3=Color3.fromRGB(220,220,220);HotkeyNoclipB.TextSize=12;HotkeyNoclipB.Font=Enum.Font.Gotham
Instance.new("UICorner",HotkeyNoclipB).CornerRadius=UDim.new(0,6)
local HotkeyPanelTitle=Instance.new("TextLabel",Pages["工具"]);HotkeyPanelTitle.Size=UDim2.new(1,-20,0,18);HotkeyPanelTitle.Position=UDim2.new(0,10,0,115);HotkeyPanelTitle.BackgroundTransparency=1;HotkeyPanelTitle.Text="快捷键一览";HotkeyPanelTitle.TextColor3=Color3.fromRGB(180,180,200);HotkeyPanelTitle.TextSize=12;HotkeyPanelTitle.Font=Enum.Font.GothamBold;HotkeyPanelTitle.TextXAlignment=Enum.TextXAlignment.Left
local HotkeyPanel=Instance.new("TextLabel",Pages["工具"]);HotkeyPanel.Size=UDim2.new(1,-20,0,80);HotkeyPanel.Position=UDim2.new(0,10,0,135);HotkeyPanel.BackgroundColor3=Color3.fromRGB(15,15,22);HotkeyPanel.BorderSizePixel=0;HotkeyPanel.Text="F1 - 飞行开关\nF2 - 连点器开关\nF3 - 瞬移开关\nF4 - 穿墙开关\n(必须先在右边按钮上开启)";HotkeyPanel.TextColor3=Color3.fromRGB(200,220,255);HotkeyPanel.TextSize=11;HotkeyPanel.Font=Enum.Font.Code;HotkeyPanel.TextXAlignment=Enum.TextXAlignment.Left;HotkeyPanel.TextYAlignment=Enum.TextYAlignment.Top
Instance.new("UICorner",HotkeyPanel).CornerRadius=UDim.new(0,6)
local NotifTitle=Instance.new("TextLabel",Pages["工具"]);NotifTitle.Size=UDim2.new(1,-20,0,18);NotifTitle.Position=UDim2.new(0,10,0,225);NotifTitle.BackgroundTransparency=1;NotifTitle.Text="消息通知中心";NotifTitle.TextColor3=Color3.fromRGB(180,180,200);NotifTitle.TextSize=12;NotifTitle.Font=Enum.Font.GothamBold;NotifTitle.TextXAlignment=Enum.TextXAlignment.Left
local NotifFrame=Instance.new("ScrollingFrame",Pages["工具"]);NotifFrame.Size=UDim2.new(1,-20,0,100);NotifFrame.Position=UDim2.new(0,10,0,245);NotifFrame.BackgroundColor3=Color3.fromRGB(15,15,22);NotifFrame.BorderSizePixel=0;NotifFrame.ScrollBarThickness=3;NotifFrame.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",NotifFrame).CornerRadius=UDim.new(0,6)
Instance.new("UIListLayout",NotifFrame).Padding=UDim.new(0,2)

-- 传送所有玩家
local TeleAllB=Instance.new("TextButton",Pages["工具"])
TeleAllB.Size=UDim2.new(0,180,0,30)
TeleAllB.Position=UDim2.new(0,10,0,360)
TeleAllB.BackgroundColor3=Color3.fromRGB(80,50,140)
TeleAllB.Text="✈️ 传送所有玩家到我"
TeleAllB.TextColor3=Color3.fromRGB(255,255,255)
TeleAllB.TextSize=12
TeleAllB.Font=Enum.Font.Gotham
Instance.new("UICorner",TeleAllB).CornerRadius=UDim.new(0,6)

-- ================= 娱乐页 =================
local AutoMsgBox=Instance.new("TextBox",Pages["娱乐"]);AutoMsgBox.Size=UDim2.new(0.6,0,0,30);AutoMsgBox.Position=UDim2.new(0,10,0,10);AutoMsgBox.BackgroundColor3=Color3.fromRGB(30,30,38);AutoMsgBox.BorderSizePixel=0;AutoMsgBox.Text="";AutoMsgBox.PlaceholderText="要自动发送的消息";AutoMsgBox.TextColor3=Color3.fromRGB(220,220,220);AutoMsgBox.PlaceholderColor3=Color3.fromRGB(120,120,140);AutoMsgBox.TextSize=12;AutoMsgBox.Font=Enum.Font.Gotham
Instance.new("UICorner",AutoMsgBox).CornerRadius=UDim.new(0,6)
local AutoMsgB=Instance.new("TextButton",Pages["娱乐"]);AutoMsgB.Size=UDim2.new(0.3,0,0,30);AutoMsgB.Position=UDim2.new(0.65,0,0,10);AutoMsgB.BackgroundColor3=Color3.fromRGB(60,120,60);AutoMsgB.Text="开始发送";AutoMsgB.TextColor3=Color3.fromRGB(255,255,255);AutoMsgB.TextSize=12;AutoMsgB.Font=Enum.Font.Gotham
Instance.new("UICorner",AutoMsgB).CornerRadius=UDim.new(0,6)
local NameFlashB=Instance.new("TextButton",Pages["娱乐"]);NameFlashB.Size=UDim2.new(0,180,0,30);NameFlashB.Position=UDim2.new(0,10,0,50);NameFlashB.BackgroundColor3=Color3.fromRGB(45,45,60);NameFlashB.Text="💫 名字闪动:关";NameFlashB.TextColor3=Color3.fromRGB(220,220,220);NameFlashB.TextSize=12;NameFlashB.Font=Enum.Font.Gotham
Instance.new("UICorner",NameFlashB).CornerRadius=UDim.new(0,6)
local SpinB=Instance.new("TextButton",Pages["娱乐"]);SpinB.Size=UDim2.new(0,180,0,30);SpinB.Position=UDim2.new(0,200,0,50);SpinB.BackgroundColor3=Color3.fromRGB(45,45,60);SpinB.Text="🔄 角色旋转:关";SpinB.TextColor3=Color3.fromRGB(220,220,220);SpinB.TextSize=12;SpinB.Font=Enum.Font.Gotham
Instance.new("UICorner",SpinB).CornerRadius=UDim.new(0,6)
local DanceB=Instance.new("TextButton",Pages["娱乐"]);DanceB.Size=UDim2.new(0,180,0,30);DanceB.Position=UDim2.new(0,10,0,90);DanceB.BackgroundColor3=Color3.fromRGB(45,45,60);DanceB.Text="💃 角色跳舞:关";DanceB.TextColor3=Color3.fromRGB(220,220,220);DanceB.TextSize=12;DanceB.Font=Enum.Font.Gotham
Instance.new("UICorner",DanceB).CornerRadius=UDim.new(0,6)

-- ================= 关于页 =================
local AboutT=Instance.new("TextLabel",Pages["关于"]);AboutT.Size=UDim2.new(1,-20,0,30);AboutT.Position=UDim2.new(0,10,0,20);AboutT.BackgroundTransparency=1;AboutT.Text="黑洞";AboutT.TextColor3=Color3.fromRGB(200,200,220);AboutT.TextSize=18;AboutT.Font=Enum.Font.GothamBold;AboutT.TextXAlignment=Enum.TextXAlignment.Left
local AboutD=Instance.new("TextLabel",Pages["关于"]);AboutD.Size=UDim2.new(1,-20,0,20);AboutD.Position=UDim2.new(0,10,0,55);AboutD.BackgroundTransparency=1;AboutD.Text="版本号: 812";AboutD.TextColor3=Color3.fromRGB(180,180,200);AboutD.TextSize=13;AboutD.Font=Enum.Font.Gotham;AboutD.TextXAlignment=Enum.TextXAlignment.Left
local AboutD2=Instance.new("TextLabel",Pages["关于"]);AboutD2.Size=UDim2.new(1,-20,0,20);AboutD2.Position=UDim2.new(0,10,0,80);AboutD2.BackgroundTransparency=1;AboutD2.Text="作者: 陈晓雨牛逼";AboutD2.TextColor3=Color3.fromRGB(180,180,200);AboutD2.TextSize=13;AboutD2.Font=Enum.Font.Gotham;AboutD2.TextXAlignment=Enum.TextXAlignment.Left
local ThemeB=Instance.new("TextButton",Pages["关于"]);ThemeB.Size=UDim2.new(0,150,0,32);ThemeB.Position=UDim2.new(0,10,0,120);ThemeB.BackgroundColor3=Color3.fromRGB(120,80,255);ThemeB.Text="🎨 切换主题:暗黑";ThemeB.TextColor3=Color3.fromRGB(255,255,255);ThemeB.TextSize=12;ThemeB.Font=Enum.Font.Gotham
Instance.new("UICorner",ThemeB).CornerRadius=UDim.new(0,6)
local OpacityL=Instance.new("TextLabel",Pages["关于"]);OpacityL.Size=UDim2.new(1,-20,0,15);OpacityL.Position=UDim2.new(0,10,0,160);OpacityL.BackgroundTransparency=1;OpacityL.Text="面板透明度: 0%";OpacityL.TextColor3=Color3.fromRGB(180,180,200);OpacityL.TextSize=11;OpacityL.Font=Enum.Font.Gotham;OpacityL.TextXAlignment=Enum.TextXAlignment.Left
local OpacityS=Instance.new("Frame",Pages["关于"]);OpacityS.Size=UDim2.new(1,-20,0,8);OpacityS.Position=UDim2.new(0,10,0,180);OpacityS.BackgroundColor3=Color3.fromRGB(40,40,55);OpacityS.BorderSizePixel=0
Instance.new("UICorner",OpacityS).CornerRadius=UDim.new(1,0)
local OpacityF=Instance.new("Frame",OpacityS);OpacityF.Size=UDim2.new(0,0,1,0);OpacityF.BackgroundColor3=Color3.fromRGB(120,80,255);OpacityF.BorderSizePixel=0
Instance.new("UICorner",OpacityF).CornerRadius=UDim.new(1,0)
local MiniB=Instance.new("TextButton",Pages["关于"]);MiniB.Size=UDim2.new(0,150,0,32);MiniB.Position=UDim2.new(0,10,0,200);MiniB.BackgroundColor3=Color3.fromRGB(80,50,140);MiniB.Text="📱 迷你模式:关";MiniB.TextColor3=Color3.fromRGB(255,255,255);MiniB.TextSize=12;MiniB.Font=Enum.Font.Gotham
Instance.new("UICorner",MiniB).CornerRadius=UDim.new(0,6)
local ShadowB=Instance.new("TextButton",Pages["关于"]);ShadowB.Size=UDim2.new(0,150,0,32);ShadowB.Position=UDim2.new(0,170,0,200);ShadowB.BackgroundColor3=Color3.fromRGB(80,50,140);ShadowB.Text="🌑 面板阴影:关";ShadowB.TextColor3=Color3.fromRGB(255,255,255);ShadowB.TextSize=12;ShadowB.Font=Enum.Font.Gotham
Instance.new("UICorner",ShadowB).CornerRadius=UDim.new(0,6)
local BallImgBox=Instance.new("TextBox",Pages["关于"]);BallImgBox.Size=UDim2.new(1,-20,0,30);BallImgBox.Position=UDim2.new(0,10,0,240);BallImgBox.BackgroundColor3=Color3.fromRGB(30,30,38);BallImgBox.BorderSizePixel=0;BallImgBox.Text="";BallImgBox.PlaceholderText="悬浮球图片 ID（纯数字，或留空还原）";BallImgBox.TextColor3=Color3.fromRGB(220,220,220);BallImgBox.PlaceholderColor3=Color3.fromRGB(120,120,140);BallImgBox.TextSize=12;BallImgBox.Font=Enum.Font.Gotham
Instance.new("UICorner",BallImgBox).CornerRadius=UDim.new(0,6)
local ApplyBallB=Instance.new("TextButton",Pages["关于"]);ApplyBallB.Size=UDim2.new(0,150,0,30);ApplyBallB.Position=UDim2.new(0,10,0,280);ApplyBallB.BackgroundColor3=Color3.fromRGB(60,120,60);ApplyBallB.Text="🖼️ 应用悬浮球";ApplyBallB.TextColor3=Color3.fromRGB(255,255,255);ApplyBallB.TextSize=12;ApplyBallB.Font=Enum.Font.Gotham
Instance.new("UICorner",ApplyBallB).CornerRadius=UDim.new(0,6)
local ResetBallB=Instance.new("TextButton",Pages["关于"]);ResetBallB.Size=UDim2.new(0,150,0,30);ResetBallB.Position=UDim2.new(0,170,0,280);ResetBallB.BackgroundColor3=Color3.fromRGB(150,80,80);ResetBallB.Text="↩️ 还原默认";ResetBallB.TextColor3=Color3.fromRGB(255,255,255);ResetBallB.TextSize=12;ResetBallB.Font=Enum.Font.Gotham
Instance.new("UICorner",ResetBallB).CornerRadius=UDim.new(0,6)
local RenameBox=Instance.new("TextBox",Pages["关于"]);RenameBox.Size=UDim2.new(1,-20,0,30);RenameBox.Position=UDim2.new(0,10,0,320);RenameBox.BackgroundColor3=Color3.fromRGB(30,30,38);RenameBox.BorderSizePixel=0;RenameBox.Text="";RenameBox.PlaceholderText="输入新名字（本地显示）";RenameBox.TextColor3=Color3.fromRGB(220,220,220);RenameBox.PlaceholderColor3=Color3.fromRGB(120,120,140);RenameBox.TextSize=12;RenameBox.Font=Enum.Font.Gotham
Instance.new("UICorner",RenameBox).CornerRadius=UDim.new(0,6)
local ApplyNameB=Instance.new("TextButton",Pages["关于"]);ApplyNameB.Size=UDim2.new(0,150,0,30);ApplyNameB.Position=UDim2.new(0,10,0,360);ApplyNameB.BackgroundColor3=Color3.fromRGB(60,120,60);ApplyNameB.Text="✏️ 应用改名";ApplyNameB.TextColor3=Color3.fromRGB(255,255,255);ApplyNameB.TextSize=12;ApplyNameB.Font=Enum.Font.Gotham
Instance.new("UICorner",ApplyNameB).CornerRadius=UDim.new(0,6)
local ResetNameB=Instance.new("TextButton",Pages["关于"]);ResetNameB.Size=UDim2.new(0,150,0,30);ResetNameB.Position=UDim2.new(0,170,0,360);ResetNameB.BackgroundColor3=Color3.fromRGB(150,80,80);ResetNameB.Text="↩️ 还原名字";ResetNameB.TextColor3=Color3.fromRGB(255,255,255);ResetNameB.TextSize=12;ResetNameB.Font=Enum.Font.Gotham
Instance.new("UICorner",ResetNameB).CornerRadius=UDim.new(0,6)

-- 配置保存/加载
local SaveCfgB=Instance.new("TextButton",Pages["关于"])
SaveCfgB.Size=UDim2.new(0,150,0,30)
SaveCfgB.Position=UDim2.new(0,10,0,400)
SaveCfgB.BackgroundColor3=Color3.fromRGB(60,120,60)
SaveCfgB.Text="💾 保存配置"
SaveCfgB.TextColor3=Color3.fromRGB(255,255,255)
SaveCfgB.TextSize=12
SaveCfgB.Font=Enum.Font.Gotham
Instance.new("UICorner",SaveCfgB).CornerRadius=UDim.new(0,6)
local LoadCfgB=Instance.new("TextButton",Pages["关于"])
LoadCfgB.Size=UDim2.new(0,150,0,30)
LoadCfgB.Position=UDim2.new(0,170,0,400)
LoadCfgB.BackgroundColor3=Color3.fromRGB(60,80,150)
LoadCfgB.Text="📂 加载配置"
LoadCfgB.TextColor3=Color3.fromRGB(255,255,255)
LoadCfgB.TextSize=12
LoadCfgB.Font=Enum.Font.Gotham
Instance.new("UICorner",LoadCfgB).CornerRadius=UDim.new(0,6)

-- ================= 工具函数 =================
local function gH() local c=plr.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function gR() local c=plr.Character return c and c:FindFirstChild("HumanoidRootPart") end

local function bindSlider(sliderFrame,fillFrame,minVal,maxVal,onChange)
    local dragging=false
    local function updateFromX(x)
        local p=math.clamp((x-sliderFrame.AbsolutePosition.X)/sliderFrame.AbsoluteSize.X,0,1)
        fillFrame.Size=UDim2.new(p,0,1,0)
        local v=math.floor(minVal+p*(maxVal-minVal))
        onChange(v,p)
    end
    sliderFrame.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            updateFromX(i.Position.X)
        end
    end)
    U.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    sliderFrame.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
            updateFromX(i.Position.X)
        end
    end)
end

local function sendChat(txt)
    local ev=RS:FindFirstChild("DefaultChatSystemChatEvents")
    if ev then
        local req=ev:FindFirstChild("SayMessageRequest")
        if req then pcall(function() req:FireServer(txt,"All") end) end
    end
end

-- ================= 滑块绑定 =================
bindSlider(FSS,FSF,50,500,function(v) fSp=v;FS.Text="飞行速度: "..v end)
bindSlider(WSS,WSF,16,200,function(v) WS.Text="跑步速度: "..v;local h=gH() if h then pcall(function() h.WalkSpeed=v end) end end)
bindSlider(JPS,JPF,50,350,function(v) JumpPowerL.Text="跳跃力: "..v;local h=gH() if h then pcall(function() h.JumpPower=v end) end end)
bindSlider(AlertRangeS,AlertRangeF,10,200,function(v) alertRange=v;AlertRangeL.Text="警报距离: "..v.." 米" end)
bindSlider(FovS,FovF,30,120,function(v) FovL.Text="视野 FOV: "..v;pcall(function() workspace.CurrentCamera.FieldOfView=v end) end)
bindSlider(OpacityS,OpacityF,0,100,function(v,p) OpacityL.Text="面板透明度: "..v.."%";pcall(function() MF.BackgroundTransparency=p;TB.BackgroundTransparency=p;SB.BackgroundTransparency=p;CB.BackgroundTransparency=p end) end)
bindSlider(ClickSpdS,ClickSpdF,1,50,function(v) clickerRate=v;ClickSpdL.Text="连点速度: "..v.." 次/秒" end)
bindSlider(ScaleS,ScaleF,10,300,function(v)
    local scale=v/100
    ScaleL.Text=string.format("角色大小: %.1fx",scale)
    local c=plr.Character
    if c then
        local h=c:FindFirstChildOfClass("Humanoid")
        if h then
            pcall(function()
                local bodyDepth=h:FindFirstChild("BodyDepthScale")
                local bodyWidth=h:FindFirstChild("BodyWidthScale")
                local bodyHeight=h:FindFirstChild("BodyHeightScale")
                local headScale=h:FindFirstChild("HeadScale")
                if bodyDepth then bodyDepth.Value=scale end
                if bodyWidth then bodyWidth.Value=scale end
                if bodyHeight then bodyHeight.Value=scale end
                if headScale then headScale.Value=scale end
            end)
        end
    end
end)

-- ================= 逻辑：飞行 =================
FB.Activated:Connect(function()
    fOn=not fOn
    if fOn then
        local r=gR();if not r then fOn=false;return end
        fPos=r.Position;FB.Text="飞行:开";FB.BackgroundColor3=Color3.fromRGB(80,50,140)
        fCn=R.RenderStepped:Connect(function(dt)
            if not fOn then return end
            local c=plr.Character;if not c then return end
            local root=c:FindFirstChild("HumanoidRootPart");if not root then return end
            local cam=workspace.CurrentCamera;if not cam then return end
            local md=Vector3.new()
            for _,k in pairs(U:GetKeysPressed()) do
                if k.KeyCode==Enum.KeyCode.W then md=md+cam.CFrame.LookVector end
                if k.KeyCode==Enum.KeyCode.S then md=md-cam.CFrame.LookVector end
                if k.KeyCode==Enum.KeyCode.A then md=md-cam.CFrame.RightVector end
                if k.KeyCode==Enum.KeyCode.D then md=md+cam.CFrame.RightVector end
                if k.KeyCode==Enum.KeyCode.Space then md=md+Vector3.new(0,1,0) end
                if k.KeyCode==Enum.KeyCode.LeftControl then md=md-Vector3.new(0,1,0) end
            end
            if md.Magnitude>0 then fPos=fPos+md.Unit*fSp*dt end
            pcall(function() root.CFrame=CFrame.new(fPos,fPos+cam.CFrame.LookVector);root.Velocity=Vector3.new(0,0,0);root.RotVelocity=Vector3.new(0,0,0) end)
        end)
    else
        if fCn then fCn:Disconnect();fCn=nil end
        FB.Text="飞行:关";FB.BackgroundColor3=Color3.fromRGB(45,45,60)
    end
end)

-- 无限跳
JB.Activated:Connect(function()
    jOn=not jOn
    if jOn then
        JB.Text="无限跳:开";JB.BackgroundColor3=Color3.fromRGB(80,50,140)
        for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
        local function doJ() local h=gH() if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end
        table.insert(jCn,U.InputBegan:Connect(function(i,gp) if gp then return end if not jOn then return end if i.KeyCode==Enum.KeyCode.Space and i.UserInputType==Enum.UserInputType.Keyboard then doJ() end end))
        table.insert(jCn,U.JumpRequest:Connect(function() if jOn then doJ() end end))
    else
        JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(45,45,60)
        for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    end
end)

AutoJumpB.Activated:Connect(function()
    local h=gH()
    if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end)

-- 空中行走
AirWalkB.Activated:Connect(function()
    airWalkOn=not airWalkOn
    if airWalkOn then
        AirWalkB.Text="🪂 空中行走:开";AirWalkB.BackgroundColor3=Color3.fromRGB(80,50,140)
        airWalkCn=R.Heartbeat:Connect(function()
            if not airWalkOn then return end
            local c=plr.Character;if not c then return end
            local h=c:FindFirstChildOfClass("Humanoid");if not h then return end
            pcall(function()
                if h.FloorMaterial==Enum.Material.Air then
                    local hrp=c:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Velocity=Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z) end
                end
            end)
        end)
    else
        AirWalkB.Text="🪂 空中行走:关";AirWalkB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if airWalkCn then airWalkCn:Disconnect();airWalkCn=nil end
    end
end)

-- 保存/传送
SavePosB.Activated:Connect(function()
    local r=gR()
    if r then
        savedPos=r.CFrame
        SavePosB.Text="📍 已保存"
        task.wait(2)
        SavePosB.Text="📍 保存当前位置"
    end
end)
TeleBackB.Activated:Connect(function()
    if savedPos then
        local r=gR()
        if r then pcall(function() r.CFrame=savedPos end) end
    end
end)
SuperJumpB.Activated:Connect(function()
    local h=gH()
    if h then pcall(function() h.JumpPower=500 end) end
end)

-- 瞬移
TeleportB.Activated:Connect(function()
    teleportOn=not teleportOn
    if teleportOn then
        TeleportB.Text="✈️ 瞬移:开";TeleportB.BackgroundColor3=Color3.fromRGB(120,80,255)
        teleportCn=U.InputBegan:Connect(function(i,gp)
            if gp or not teleportOn then return end
            if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
            local cam=workspace.CurrentCamera
            local mousePos
            pcall(function() mousePos=U:GetMouseLocation() end)
            if not mousePos then return end
            local ray=cam:ScreenPointToRay(mousePos.X,mousePos.Y)
            local pr=RaycastParams.new();pr.FilterType=Enum.RaycastFilterType.Exclude;pr.FilterDescendantsInstances={plr.Character}
            local res=workspace:Raycast(ray.Origin,ray.Direction*1000,pr)
            if res then
                local r=gR()
                if r then pcall(function() r.CFrame=CFrame.new(res.Position+Vector3.new(0,3,0)) end) end
            end
        end)
    else
        TeleportB.Text="✈️ 瞬移到鼠标点";TeleportB.BackgroundColor3=Color3.fromRGB(80,50,140)
        if teleportCn then teleportCn:Disconnect();teleportCn=nil end
    end
end)

-- 穿墙
NoclipB.Activated:Connect(function()
    noclipOn=not noclipOn
    if noclipOn then
        NoclipB.Text="🚪 穿墙:开";NoclipB.BackgroundColor3=Color3.fromRGB(80,50,140)
        noclipCn=R.Stepped:Connect(function() local c=plr.Character if not c then return end for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end)
    else
        NoclipB.Text="🚪 穿墙:关";NoclipB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if noclipCn then noclipCn:Disconnect();noclipCn=nil end
        local c=plr.Character
        if c then for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=true end end end
    end
end)

-- 防挂机
AntiAFK.Activated:Connect(function()
    antiAFKOn=not antiAFKOn
    if antiAFKOn then
        AntiAFK.Text="💤 防挂机:开";AntiAFK.BackgroundColor3=Color3.fromRGB(80,50,140)
        afkCn=plr.Idled:Connect(function() pcall(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end)
    else
        AntiAFK.Text="💤 防挂机:关";AntiAFK.BackgroundColor3=Color3.fromRGB(45,45,60)
        if afkCn then afkCn:Disconnect();afkCn=nil end
    end
end)

-- 悬停
HoverB.Activated:Connect(function()
    hoverOn=not hoverOn
    if hoverOn then
        HoverB.Text="🪁 悬停工具:开";HoverB.BackgroundColor3=Color3.fromRGB(120,80,255)
        hoverCn=R.Heartbeat:Connect(function()
            if not hoverOn then return end
            local c=plr.Character;if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
            pcall(function() hrp.Velocity=Vector3.new(0,0,0);hrp.RotVelocity=Vector3.new(0,0,0) end)
        end)
    else
        HoverB.Text="🪁 悬停工具:关";HoverB.BackgroundColor3=Color3.fromRGB(60,80,150)
        if hoverCn then hoverCn:Disconnect();hoverCn=nil end
    end
end)

-- 自动拾取
PickupB.Activated:Connect(function()
    pickupOn=not pickupOn
    if pickupOn then
        PickupB.Text="🧲 自动拾取:开";PickupB.BackgroundColor3=Color3.fromRGB(80,50,140)
        pickupCn=R.Heartbeat:Connect(function()
            if not pickupOn then return end
            local c=plr.Character;if not c then return end
            local hrp=c:FindFirstChild("HumanoidRootPart");if not hrp then return end
            for _,v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    local isSelf=false
                    for _,p in ipairs(P:GetPlayers()) do
                        if p.Character and v:IsDescendantOf(p.Character) then isSelf=true;break end
                    end
                    if not isSelf and v.Name~="Baseplate" and v.Name~="Terrain" then
                        pcall(function() v.CFrame=CFrame.new(hrp.Position) end)
                    end
                end
            end
        end)
    else
        PickupB.Text="🧲 自动拾取:关";PickupB.BackgroundColor3=Color3.fromRGB(60,120,60)
        if pickupCn then pickupCn:Disconnect();pickupCn=nil end
    end
end)

-- 连点器增强
ClickerB.Activated:Connect(function()
    clickerOn=not clickerOn
    if clickerOn then
        ClickerB.Text="🖱️ 连点器:开";ClickerB.BackgroundColor3=Color3.fromRGB(80,50,140)
        clickerCn=task.spawn(function()
            while clickerOn do
                pcall(function()
                    VU:CaptureController()
                    local cam=workspace.CurrentCamera
                    local vp=cam.ViewportSize
                    local x=vp.X/2
                    local y=vp.Y/2
                    if clickerRange>0 then
                        x=x+math.random(-clickerRange,clickerRange)
                        y=y+math.random(-clickerRange,clickerRange)
                    end
                    VU:ClickButton1(Vector2.new(x,y))
                end)
                local waitTime=1/clickerRate
                if clickerRandom then
                    waitTime=waitTime*(0.5+math.random())
                end
                task.wait(waitTime)
            end
        end)
    else
        ClickerB.Text="🖱️ 连点器:关";ClickerB.BackgroundColor3=Color3.fromRGB(45,45,60)
        clickerCn=nil
    end
end)

-- 删除工具
local delTool=nil
local delToolConn=nil
local deletedByTool={}
GetDelToolB.Activated:Connect(function()
    if delTool then pcall(function() delTool:Destroy() end);delTool=nil end
    if delToolConn then pcall(function() delToolConn:Disconnect() end);delToolConn=nil end
    local backpack=plr:FindFirstChild("Backpack")
    if not backpack then return end
    delTool=Instance.new("Tool")
    delTool.Name="删除工具"
    delTool.RequiresHandle=false
    delTool.CanBeDropped=false
    delTool.Parent=backpack
    delTool.Equipped:Connect(function()
        if delToolConn then delToolConn:Disconnect() end
        delToolConn=U.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
            local cam=workspace.CurrentCamera
            local mousePos
            pcall(function() mousePos=U:GetMouseLocation() end)
            if not mousePos then return end
            local ray=cam:ScreenPointToRay(mousePos.X,mousePos.Y)
            local pr=RaycastParams.new()
            pr.FilterType=Enum.RaycastFilterType.Exclude
            pr.FilterDescendantsInstances={plr.Character}
            local res=workspace:Raycast(ray.Origin,ray.Direction*1000,pr)
            if res and res.Instance then
                local target=res.Instance
                local isPPart=false
                for _,p in ipairs(P:GetPlayers()) do
                    if p.Character and target:IsDescendantOf(p.Character) then isPPart=true;break end
                end
                if not isPPart then
                    table.insert(deletedByTool,{obj=target,parent=target.Parent})
                    target.Parent=nil
                end
            end
        end)
    end)
    delTool.Unequipped:Connect(function()
        if delToolConn then delToolConn:Disconnect();delToolConn=nil end
    end)
    pcall(function()
        G:SetCore("SendNotification",{Title="🗑️ 删除工具已放入背包",Text="装备后点哪删哪",Duration=4})
    end)
end)
RsB.Activated:Connect(function()
    for _,d in ipairs(deletedByTool) do
        pcall(function() if d.obj and d.parent and d.obj.Parent==nil then d.obj.Parent=d.parent end end)
    end
    deletedByTool={}
end)

-- 天气系统
local oldAmbient,oldOutdoor,oldBright,oldClock
pcall(function() oldAmbient=L.Ambient;oldOutdoor=L.OutdoorAmbient;oldBright=L.Brightness;oldClock=L.ClockTime end)
local function clearWeather()
    if createdAtm then createdAtm:Destroy();createdAtm=nil end
    for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=true end end
    if oldAmbient then L.Ambient=oldAmbient end
    if oldOutdoor then L.OutdoorAmbient=oldOutdoor end
    if oldBright then L.Brightness=oldBright end
    if oldClock then L.ClockTime=oldClock end
end
WeatherB.Activated:Connect(function()
    weatherIdx=weatherIdx%6+1
    pcall(function()
        clearWeather()
        if weatherIdx==1 then
            WeatherB.Text="☀️ 晴天"
        elseif weatherIdx==2 then
            WeatherB.Text="🌧️ 雨天"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.35;atm.Haze=2;atm.Color=Color3.fromRGB(80,90,110);createdAtm=atm
            L.Ambient=Color3.fromRGB(60,70,90);L.OutdoorAmbient=Color3.fromRGB(60,70,90);L.Brightness=1
        elseif weatherIdx==3 then
            WeatherB.Text="🌫️ 雾天"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.75;atm.Haze=20;atm.Color=Color3.fromRGB(200,200,200);createdAtm=atm
            L.Ambient=Color3.fromRGB(180,180,180);L.OutdoorAmbient=Color3.fromRGB(180,180,180);L.Brightness=1.5
        elseif weatherIdx==4 then
            WeatherB.Text="🌅 黄昏"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.3;atm.Color=Color3.fromRGB(255,150,80);createdAtm=atm
            L.Ambient=Color3.fromRGB(255,180,120);L.OutdoorAmbient=Color3.fromRGB(255,160,100);L.Brightness=2;L.ClockTime=18
        elseif weatherIdx==5 then
            WeatherB.Text="🌌 夜晚"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.2;atm.Color=Color3.fromRGB(30,40,80);createdAtm=atm
            L.Ambient=Color3.fromRGB(50,60,100);L.OutdoorAmbient=Color3.fromRGB(40,50,90);L.Brightness=1;L.ClockTime=0
        elseif weatherIdx==6 then
            WeatherB.Text="⛈️ 雷暴"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.6;atm.Haze=10;atm.Color=Color3.fromRGB(40,40,60);createdAtm=atm
            L.Ambient=Color3.fromRGB(30,30,50);L.OutdoorAmbient=Color3.fromRGB(30,30,50);L.Brightness=0.5
            task.spawn(function()
                while weatherIdx==6 and createdAtm do
                    task.wait(math.random(2,5))
                    pcall(function()
                        L.Brightness=3
                        task.wait(0.1)
                        L.Brightness=0.5
                    end)
                end
            end)
        end
    end)
end)
TimeB.Activated:Connect(function()
    if L.ClockTime>=10 and L.ClockTime<=14 then L.ClockTime=0;TimeB.Text="🌙 午夜"
    elseif L.ClockTime>=22 or L.ClockTime<=2 then L.ClockTime=6;TimeB.Text="🌅 清晨"
    else L.ClockTime=12;TimeB.Text="☀️ 正午" end
end)

-- 监控刷新
task.spawn(function()
    local fps={}
    while MF.Parent do
        local n=tick();table.insert(fps,n)
        while #fps>0 and n-fps[1]>1 do table.remove(fps,1) end
        pcall(function() FLL.Text="FPS: "..#fps end)
        pcall(function() PLL.Text="延迟: "..math.floor(plr:GetNetworkPing()*1000).."ms" end)
        pcall(function() MLL.Text="内存: "..math.floor(S:GetTotalMemoryUsageMb()).."MB" end)
        pcall(function()
            local c=plr.Character
            if c then
                local hrp=c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    COORD.Text=string.format("坐标: %.0f, %.0f, %.0f",hrp.Position.X,hrp.Position.Y,hrp.Position.Z)
                end
            end
        end)
        pcall(function()
            local plrCount=#P:GetPlayers()
            local ping=math.floor(plr:GetNetworkPing()*1000)
            ServerInfoL.Text=string.format("服务器在线: %d 人\n你的延迟: %d ms",plrCount,ping)
        end)
        pcall(updateRadar)
        task.wait(0.5)
    end
end)

-- 高级页：传送到玩家
TelePlayerB.Activated:Connect(function()
    local name=TelePlayerBox.Text
    if not name or name=="" then return end
    for _,other in ipairs(P:GetPlayers()) do
        if other.Name:lower()==name:lower() then
            local c=other.Character
            local ohrp=c and c:FindFirstChild("HumanoidRootPart")
            local myR=gR()
            if ohrp and myR then pcall(function() myR.CFrame=CFrame.new(ohrp.Position+Vector3.new(0,3,0)) end) end
            break
        end
    end
end)

-- 高级页：平滑跟随
FollowB.Activated:Connect(function()
    followOn=not followOn
    if followOn then
        FollowB.Text="🚶 自动跟随:开";FollowB.BackgroundColor3=Color3.fromRGB(80,50,140)
        followCn=R.Heartbeat:Connect(function(dt)
            if not followOn then return end
            local tn=FollowNameBox.Text
            if not tn or tn=="" then return end
            local target=nil
            for _,other in ipairs(P:GetPlayers()) do
                if other.Name:lower()==tn:lower() then target=other;break end
            end
            if not target then return end
            local c=target.Character
            local ohrp=c and c:FindFirstChild("HumanoidRootPart")
            local myR=gR()
            if ohrp and myR then
                local targetPos=ohrp.Position
                local myPos=myR.Position
                local dir=(targetPos-myPos)
                local dist=dir.Magnitude
                if dist>5 then
                    local moveDir=dir.Unit
                    local speed=math.min(50,dist*2)
                    myR.CFrame=CFrame.new(myPos+moveDir*speed*dt, myPos+moveDir*speed*dt+workspace.CurrentCamera.CFrame.LookVector)
                    myR.Velocity=Vector3.new(0,0,0)
                end
            end
        end)
    else
        FollowB.Text="🚶 自动跟随:关";FollowB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if followCn then followCn:Disconnect();followCn=nil end
    end
end)

-- 高级页：锁定视角
LockViewB.Activated:Connect(function()
    lockViewOn=not lockViewOn
    if lockViewOn then
        LockViewB.Text="👁️ 锁定视角:开";LockViewB.BackgroundColor3=Color3.fromRGB(80,50,140)
        lockViewCn=R.RenderStepped:Connect(function()
            if not lockViewOn then return end
            local tn=LockViewBox.Text
            if not tn or tn=="" then return end
            local cam=workspace.CurrentCamera
            if not cam then return end
            for _,other in ipairs(P:GetPlayers()) do
                if other.Name:lower()==tn:lower() then
                    local c=other.Character
                    local ohrp=c and c:FindFirstChild("HumanoidRootPart")
                    if ohrp then
                        pcall(function()
                            cam.CameraType=Enum.CameraType.Scriptable
                            cam.CFrame=CFrame.new(cam.CFrame.Position,ohrp.Position)
                        end)
                    end
                    break
                end
            end
        end)
    else
        LockViewB.Text="👁️ 锁定视角:关";LockViewB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if lockViewCn then lockViewCn:Disconnect();lockViewCn=nil end
        pcall(function() workspace.CurrentCamera.CameraType=Enum.CameraType.Custom end)
    end
end)

-- 标记A/B
MarkAB.Activated:Connect(function() local r=gR() if r then posA=r.CFrame end end)
MarkBB.Activated:Connect(function() local r=gR() if r then posB=r.CFrame end end)
TeleAB.Activated:Connect(function() if posA then local r=gR() if r then pcall(function() r.CFrame=posA end) end end end)
TeleBB.Activated:Connect(function() if posB then local r=gR() if r then pcall(function() r.CFrame=posB end) end end end)

-- 传送历史（可删除单条）
local function addHistory()
    local r=gR()
    if not r then return end
    table.insert(history,{cf=r.CFrame})
    if #history>5 then table.remove(history,1) end
    for _,c in ipairs(HistList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    for i,h in ipairs(history) do
        local row=Instance.new("Frame",HistList)
        row.Size=UDim2.new(1,-6,0,20)
        row.BackgroundColor3=Color3.fromRGB(30,30,38)
        row.BorderSizePixel=0
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,4)
        row.LayoutOrder=i
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(1,-24,1,0)
        btn.BackgroundTransparency=1
        btn.Text="位置 "..i.." - "..math.floor(h.cf.Position.X)..","..math.floor(h.cf.Position.Y)..","..math.floor(h.cf.Position.Z)
        btn.TextColor3=Color3.fromRGB(200,200,200)
        btn.TextSize=10
        btn.Font=Enum.Font.Code
        btn.TextXAlignment=Enum.TextXAlignment.Left
        btn.Activated:Connect(function()
            local r2=gR()
            if r2 then pcall(function() r2.CFrame=h.cf end) end
        end)
        local delBtn=Instance.new("TextButton",row)
        delBtn.Size=UDim2.new(0,20,1,0)
        delBtn.Position=UDim2.new(1,-20,0,0)
        delBtn.BackgroundColor3=Color3.fromRGB(150,60,60)
        delBtn.Text="×"
        delBtn.TextColor3=Color3.fromRGB(255,255,255)
        delBtn.TextSize=10
        delBtn.Font=Enum.Font.GothamBold
        Instance.new("UICorner",delBtn).CornerRadius=UDim.new(0,4)
        delBtn.Activated:Connect(function()
            table.remove(history,i)
            addHistory()
        end)
    end
    HistList.CanvasSize=UDim2.new(0,0,0,#history*22+5)
end
task.spawn(function()
    while MF.Parent do task.wait(5); pcall(addHistory) end
end)

-- 社交页：玩家列表（带💬/🚫）
local function refreshPlayerList()
    for _,c in ipairs(PlayerListFrame:GetChildren()) do if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end end
    local myR=gR()
    if not myR then return end
    local myPos=myR.Position
    local count=0
    for _,other in ipairs(P:GetPlayers()) do
        if other~=plr then
            local oc=other.Character
            local ohrp=oc and oc:FindFirstChild("HumanoidRootPart")
            if ohrp then
                local dist=math.floor((ohrp.Position-myPos).Magnitude)
                local hp=0
                local hum=oc:FindFirstChildOfClass("Humanoid")
                if hum then hp=math.floor(hum.Health) end
                local row=Instance.new("Frame",PlayerListFrame)
                row.Size=UDim2.new(1,-6,0,22)
                row.BackgroundColor3=Color3.fromRGB(30,30,38)
                row.BorderSizePixel=0
                Instance.new("UICorner",row).CornerRadius=UDim.new(0,4)
                row.LayoutOrder=count
                local nameBtn=Instance.new("TextButton",row)
                nameBtn.Size=UDim2.new(1,-70,1,0)
                nameBtn.BackgroundTransparency=1
                nameBtn.Text=other.Name.." | "..dist.."m | "..hp.."HP"
                nameBtn.TextColor3=Color3.fromRGB(200,200,200)
                nameBtn.TextSize=10
                nameBtn.Font=Enum.Font.Code
                nameBtn.TextXAlignment=Enum.TextXAlignment.Left
                nameBtn.Activated:Connect(function()
                    local c=other.Character
                    local ohrp2=c and c:FindFirstChild("HumanoidRootPart")
                    if ohrp2 and myR then pcall(function() myR.CFrame=CFrame.new(ohrp2.Position+Vector3.new(0,3,0)) end) end
                end)
                local chatBtn=Instance.new("TextButton",row)
                chatBtn.Size=UDim2.new(0,30,1,0)
                chatBtn.Position=UDim2.new(1,-66,0,0)
                chatBtn.BackgroundColor3=Color3.fromRGB(60,80,150)
                chatBtn.Text="💬"
                chatBtn.TextColor3=Color3.fromRGB(255,255,255)
                chatBtn.TextSize=10
                chatBtn.Font=Enum.Font.GothamBold
                Instance.new("UICorner",chatBtn).CornerRadius=UDim.new(0,4)
                chatBtn.Activated:Connect(function()
                    pcall(function()
                        G:SetCore("ChatBarFocus",true)
                    end)
                end)
                local kickBtn=Instance.new("TextButton",row)
                kickBtn.Size=UDim2.new(0,30,1,0)
                kickBtn.Position=UDim2.new(1,-34,0,0)
                kickBtn.BackgroundColor3=Color3.fromRGB(150,60,60)
                kickBtn.Text="🚫"
                kickBtn.TextColor3=Color3.fromRGB(255,255,255)
                kickBtn.TextSize=10
                kickBtn.Font=Enum.Font.GothamBold
                Instance.new("UICorner",kickBtn).CornerRadius=UDim.new(0,4)
                kickBtn.Activated:Connect(function()
                    pcall(function()
                        G:SetCore("SendNotification",{Title="🚫 无法踢出",Text="客户端无法踢出其他玩家",Duration=2})
                    end)
                end)
                count=count+1
                if count>=20 then break end
            end
        end
    end
    PlayerListFrame.CanvasSize=UDim2.new(0,0,0,count*24+5)
end
task.spawn(function()
    while MF.Parent do
        task.wait(2)
        pcall(refreshPlayerList)
        pcall(function()
            local h=gH()
            if h then MyHpLabel.Text="我的血量: "..math.floor(h.Health).." / "..math.floor(h.MaxHealth) end
        end)
    end
end)

-- 社交页：查看属性
PlayerInfoB.Activated:Connect(function()
    local name=PlayerInfoBox.Text
    if not name or name=="" then return end
    for _,other in ipairs(P:GetPlayers()) do
        if other.Name:lower()==name:lower() then
            local c=other.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                local root=c:FindFirstChild("HumanoidRootPart")
                local txt="玩家: "..other.Name.."\n"
                txt=txt.."显示名: "..other.DisplayName.."\n"
                txt=txt.."用户ID: "..other.UserId.."\n"
                if h then
                    txt=txt.."血量: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth).."\n"
                    txt=txt.."移动速度: "..math.floor(h.WalkSpeed).."\n"
                    txt=txt.."跳跃力: "..math.floor(h.JumpPower).."\n"
                end
                if root then txt=txt.."位置: "..math.floor(root.Position.X)..","..math.floor(root.Position.Y)..","..math.floor(root.Position.Z) end
                PlayerInfoResult.Text=txt
            else
                PlayerInfoResult.Text="该玩家角色未加载"
            end
            break
        end
    end
end)

-- 社交页：聊天记录
local function addChatLog(speaker,msg)
    table.insert(chatHistory,{s=speaker,m=msg})
    if #chatHistory>50 then table.remove(chatHistory,1) end
    for _,c in ipairs(ChatLogFrame:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
    for i,h in ipairs(chatHistory) do
        local lbl=Instance.new("TextLabel",ChatLogFrame)
        lbl.Size=UDim2.new(1,-6,0,16)
        lbl.BackgroundTransparency=1
        lbl.Text=h.s..": "..h.m
        lbl.TextColor3=Color3.fromRGB(200,200,200)
        lbl.TextSize=10
        lbl.Font=Enum.Font.Code
        lbl.TextXAlignment=Enum.TextXAlignment.Left
        lbl.LayoutOrder=i
        ChatLogFrame.CanvasSize=UDim2.new(0,0,0,i*18+5)
    end
    ChatLogFrame.CanvasPosition=Vector2.new(0,ChatLogFrame.CanvasSize.Y.Offset)
end
pcall(function()
    plr.Chatted:Connect(function(msg) addChatLog(plr.Name,msg) end)
    for _,other in ipairs(P:GetPlayers()) do
        if other~=plr then
            pcall(function()
                other.Chatted:Connect(function(msg) addChatLog(other.Name,msg) end)
            end)
        end
    end
    P.PlayerAdded:Connect(function(other)
        task.wait(1)
        pcall(function() other.Chatted:Connect(function(msg) addChatLog(other.Name,msg) end) end)
    end)
end)

-- 自动回复
AutoReplyB.Activated:Connect(function()
    autoReplyOn=not autoReplyOn
    if autoReplyOn then
        if AutoReplyBox.Text=="" then autoReplyOn=false;return end
        AutoReplyB.Text="关闭回复";AutoReplyB.BackgroundColor3=Color3.fromRGB(150,60,60)
    else
        AutoReplyB.Text="开启回复";AutoReplyB.BackgroundColor3=Color3.fromRGB(60,120,60)
    end
end)
pcall(function()
    plr.Chatted:Connect(function(msg)
        if autoReplyOn then
            local txt=AutoReplyBox.Text
            if txt and txt~="" then
                task.wait(1)
                sendChat(txt)
            end
        end
    end)
end)

-- 聊天发送
ChatSendB.Activated:Connect(function()
    local txt=ChatSendBox.Text
    if txt and txt~="" then
        sendChat(txt)
        ChatSendBox.Text=""
    end
end)

-- 防护页：管理员检测
local adminKeywords={"admin","mod","owner","staff","gm","管理","群主","服主","老大","老板","creator","dev"}
local function isAdminName(name)
    local lo=name:lower()
    for _,kw in ipairs(adminKeywords) do if lo:find(kw) then return true end end
    return false
end
local function addAdminLog(text,color)
    local lbl=Instance.new("TextLabel",AdminCheckF)
    lbl.Size=UDim2.new(1,-6,0,18)
    lbl.BackgroundTransparency=1
    lbl.Text=text
    lbl.TextColor3=color or Color3.fromRGB(220,220,220)
    lbl.TextSize=10
    lbl.Font=Enum.Font.Code
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local count=#AdminCheckF:GetChildren()-1
    AdminCheckF.CanvasSize=UDim2.new(0,0,0,count*20+5)
    AdminCheckF.CanvasPosition=Vector2.new(0,AdminCheckF.CanvasSize.Y.Offset)
end
P.PlayerAdded:Connect(function(other)
    if other==plr then return end
    task.wait(1)
    if isAdminName(other.Name) or isAdminName(other.DisplayName or "") then
        addAdminLog("⚠️ 管理员进入: "..other.Name,Color3.fromRGB(255,100,100))
        pcall(function() G:SetCore("SendNotification",{Title="⚠️ 管理员进入",Text=other.Name,Duration=5}) end)
    else
        addAdminLog("玩家进入: "..other.Name,Color3.fromRGB(150,200,255))
    end
end)
P.PlayerRemoving:Connect(function(other)
    if other==plr then return end
    if isAdminName(other.Name) then addAdminLog("✅ 管理员离开: "..other.Name,Color3.fromRGB(100,255,100)) end
end)

-- 防护页：隐身检测 + 反隐身
InvisDetectB.Activated:Connect(function()
    invisDetectOn=not invisDetectOn
    if invisDetectOn then
        InvisDetectB.Text="👻 隐身检测:开";InvisDetectB.BackgroundColor3=Color3.fromRGB(80,50,140)
        invisDetectCn=R.Heartbeat:Connect(function()
            if not invisDetectOn then return end
            for _,other in ipairs(P:GetPlayers()) do
                if other~=plr then
                    local c=other.Character
                    if not c or not c:FindFirstChild("HumanoidRootPart") then
                        pcall(function() G:SetCore("SendNotification",{Title="👻 隐身玩家",Text=other.Name,Duration=1}) end)
                    end
                end
            end
        end)
    else
        InvisDetectB.Text="👻 隐身检测:关";InvisDetectB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if invisDetectCn then invisDetectCn:Disconnect();invisDetectCn=nil end
    end
end)
AntiInvisB.Activated:Connect(function()
    antiInvisOn=not antiInvisOn
    if antiInvisOn then
        AntiInvisB.Text="👀 反隐身:开";AntiInvisB.BackgroundColor3=Color3.fromRGB(80,50,140)
        antiInvisCn=R.Heartbeat:Connect(function()
            if not antiInvisOn then return end
            for _,other in ipairs(P:GetPlayers()) do
                if other~=plr then
                    pcall(function()
                        local c=other.Character
                        if c then
                            for _,v in ipairs(c:GetDescendants()) do
                                if v:IsA("BasePart") and v.Transparency>0.5 then v.Transparency=0 end
                                if v:IsA("Decal") and v.Transparency>0.5 then v.Transparency=0 end
                            end
                        end
                    end)
                end
            end
        end)
    else
        AntiInvisB.Text="👀 反隐身:关";AntiInvisB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if antiInvisCn then antiInvisCn:Disconnect();antiInvisCn=nil end
    end
end)

-- 防护页：敌人接近警报
EnemyAlertB.Activated:Connect(function()
    enemyAlertOn=not enemyAlertOn
    if enemyAlertOn then
        EnemyAlertB.Text="🚨 敌人接近警报:开";EnemyAlertB.BackgroundColor3=Color3.fromRGB(80,50,140)
        enemyAlertCn=R.Heartbeat:Connect(function()
            if not enemyAlertOn then return end
            local myR=gR()
            if not myR then return end
            for _,other in ipairs(P:GetPlayers()) do
                if other~=plr then
                    local oc=other.Character
                    local ohrp=oc and oc:FindFirstChild("HumanoidRootPart")
                    if ohrp then
                        local d=(ohrp.Position-myR.Position).Magnitude
                        if d<=alertRange then
                            pcall(function() G:SetCore("SendNotification",{Title="🚨 敌人接近",Text=other.Name.." "..math.floor(d).."m",Duration=1}) end)
                        end
                    end
                end
            end
        end)
    else
        EnemyAlertB.Text="🚨 敌人接近警报:关";EnemyAlertB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if enemyAlertCn then enemyAlertCn:Disconnect();enemyAlertCn=nil end
    end
end)

-- 特效页：天空盒
local function applySky(id)
    pcall(function()
        if currentSky then currentSky:Destroy() end
        currentSky=Instance.new("Sky",L)
        currentSky.SkyboxBk="rbxassetid://"..id
        currentSky.SkyboxDn="rbxassetid://"..id
        currentSky.SkyboxFt="rbxassetid://"..id
        currentSky.SkyboxLf="rbxassetid://"..id
        currentSky.SkyboxRt="rbxassetid://"..id
        currentSky.SkyboxUp="rbxassetid://"..id
    end)
end
Sky1B.Activated:Connect(function() applySky("159454554") end)
Sky2B.Activated:Connect(function() applySky("159454554") end)
Sky3B.Activated:Connect(function() applySky("159454554") end)

-- 特效页：角色发光
GlowB.Activated:Connect(function()
    glowOn=not glowOn
    if glowOn then
        GlowB.Text="✨ 角色发光:开";GlowB.BackgroundColor3=Color3.fromRGB(80,50,140)
        local c=plr.Character
        if c then
            for _,v in ipairs(c:GetDescendants()) do
                if v:IsA("BasePart") then
                    pcall(function()
                        local light=Instance.new("PointLight",v)
                        light.Color=Color3.fromRGB(255,200,255)
                        light.Range=15
                        light.Brightness=3
                        table.insert(glowLights,light)
                    end)
                end
            end
        end
    else
        GlowB.Text="✨ 角色发光:关";GlowB.BackgroundColor3=Color3.fromRGB(45,45,60)
        for _,l in ipairs(glowLights) do pcall(function() l:Destroy() end) end
        glowLights={}
    end
end)

-- 特效页：角色拖尾
TrailB.Activated:Connect(function()
    trailOn=not trailOn
    if trailOn then
        TrailB.Text="🌈 角色拖尾:开";TrailB.BackgroundColor3=Color3.fromRGB(80,50,140)
        local c=plr.Character
        local hrp=c and c:FindFirstChild("HumanoidRootPart")
        if hrp then
            pcall(function()
                local a0=Instance.new("Attachment",hrp)
                local a1=Instance.new("Attachment",hrp)
                a0.Position=Vector3.new(0,0.5,0)
                a1.Position=Vector3.new(0,-0.5,0)
                trailAttach=Instance.new("Trail",hrp)
                trailAttach.Attachment0=a0
                trailAttach.Attachment1=a1
                trailAttach.Lifetime=0.5
                trailAttach.Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,0,0)),
                    ColorSequenceKeypoint.new(0.25,Color3.fromRGB(255,255,0)),
                    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(0,255,0)),
                    ColorSequenceKeypoint.new(0.75,Color3.fromRGB(0,255,255)),
                    ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,255))
                })
            end)
        end
    else
        TrailB.Text="🌈 角色拖尾:关";TrailB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if trailAttach then trailAttach:Destroy();trailAttach=nil end
    end
end)

-- 特效页：滤镜
local function applyFilter(color,sat)
    if currentFilter then currentFilter:Destroy();currentFilter=nil end
    currentFilter=Instance.new("ColorCorrectionEffect",L)
    currentFilter.TintColor=color
    currentFilter.Saturation=sat or 0
end
FilterRB.Activated:Connect(function() applyFilter(Color3.fromRGB(255,150,150),-0.3) end)
FilterBB.Activated:Connect(function() applyFilter(Color3.fromRGB(150,150,255),-0.3) end)
FilterWB.Activated:Connect(function() applyFilter(Color3.fromRGB(255,255,255),-1) end)
FilterOffB.Activated:Connect(function() if currentFilter then currentFilter:Destroy();currentFilter=nil end end)

-- 工具页：热键
local hotkeyFlyOn=false
local hotkeyClickerOn=false
local hotkeyTeleOn=false
local hotkeyNoclipOn=false
HotkeyFlyB.Activated:Connect(function()
    hotkeyFlyOn=not hotkeyFlyOn
    HotkeyFlyB.Text="F1 → 飞行开关:"..(hotkeyFlyOn and "开" or "关")
    HotkeyFlyB.BackgroundColor3=hotkeyFlyOn and Color3.fromRGB(80,50,140) or Color3.fromRGB(45,45,60)
end)
HotkeyClickerB.Activated:Connect(function()
    hotkeyClickerOn=not hotkeyClickerOn
    HotkeyClickerB.Text="F2 → 连点器:"..(hotkeyClickerOn and "开" or "关")
    HotkeyClickerB.BackgroundColor3=hotkeyClickerOn and Color3.fromRGB(80,50,140) or Color3.fromRGB(45,45,60)
end)
HotkeyTeleB.Activated:Connect(function()
    hotkeyTeleOn=not hotkeyTeleOn
    HotkeyTeleB.Text="F3 → 瞬移开关:"..(hotkeyTeleOn and "开" or "关")
    HotkeyTeleB.BackgroundColor3=hotkeyTeleOn and Color3.fromRGB(80,50,140) or Color3.fromRGB(45,45,60)
end)
HotkeyNoclipB.Activated:Connect(function()
    hotkeyNoclipOn=not hotkeyNoclipOn
    HotkeyNoclipB.Text="F4 → 穿墙开关:"..(hotkeyNoclipOn and "开" or "关")
    HotkeyNoclipB.BackgroundColor3=hotkeyNoclipOn and Color3.fromRGB(80,50,140) or Color3.fromRGB(45,45,60)
end)
U.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.F1 and hotkeyFlyOn then FB.Activated:Fire() end
    if i.KeyCode==Enum.KeyCode.F2 and hotkeyClickerOn then ClickerB.Activated:Fire() end
    if i.KeyCode==Enum.KeyCode.F3 and hotkeyTeleOn then TeleportB.Activated:Fire() end
    if i.KeyCode==Enum.KeyCode.F4 and hotkeyNoclipOn then NoclipB.Activated:Fire() end
end)

-- 工具页：传送所有玩家
TeleAllB.Activated:Connect(function()
    local myR=gR()
    if not myR then return end
    local myPos=myR.Position
    local count=0
    for _,other in ipairs(P:GetPlayers()) do
        if other~=plr then
            local c=other.Character
            local ohrp=c and c:FindFirstChild("HumanoidRootPart")
            if ohrp then
                pcall(function()
                    ohrp.CFrame=CFrame.new(myPos+Vector3.new(math.random(-5,5),3,math.random(-5,5)))
                end)
                count=count+1
            end
        end
    end
    pcall(function()
        G:SetCore("SendNotification",{Title="✈️ 已传送",Text=count.." 名玩家",Duration=2})
    end)
end)

-- 娱乐页：自动发消息
AutoMsgB.Activated:Connect(function()
    autoMsgOn=not autoMsgOn
    if autoMsgOn then
        if AutoMsgBox.Text=="" then autoMsgOn=false;return end
        AutoMsgB.Text="停止发送";AutoMsgB.BackgroundColor3=Color3.fromRGB(150,60,60)
        autoMsgCn=task.spawn(function()
            while autoMsgOn do
                sendChat(AutoMsgBox.Text)
                task.wait(5)
            end
        end)
    else
        AutoMsgB.Text="开始发送";AutoMsgB.BackgroundColor3=Color3.fromRGB(60,120,60)
        autoMsgCn=nil
    end
end)

-- 娱乐页：名字闪动
NameFlashB.Activated:Connect(function()
    nameFlashOn=not nameFlashOn
    if nameFlashOn then
        NameFlashB.Text="💫 名字闪动:开";NameFlashB.BackgroundColor3=Color3.fromRGB(80,50,140)
        pcall(function()
            local c=plr.Character
            local head=c and c:FindFirstChild("Head")
            if head then
                nameFlashGui=Instance.new("BillboardGui",head)
                nameFlashGui.Size=UDim2.new(0,200,0,50)
                nameFlashGui.StudsOffset=Vector3.new(0,3,0)
                nameFlashGui.AlwaysOnTop=true
                local lbl=Instance.new("TextLabel",nameFlashGui)
                lbl.Size=UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency=1
                lbl.Text=plr.DisplayName
                lbl.TextColor3=Color3.fromRGB(255,255,255)
                lbl.TextStrokeTransparency=0
                lbl.TextSize=14
                lbl.Font=Enum.Font.GothamBold
            end
        end)
        nameFlashCn=R.Heartbeat:Connect(function()
            if not nameFlashOn then return end
            local colors={Color3.fromRGB(255,0,0),Color3.fromRGB(255,127,0),Color3.fromRGB(255,255,0),Color3.fromRGB(0,255,0),Color3.fromRGB(0,255,255),Color3.fromRGB(0,0,255),Color3.fromRGB(127,0,255),Color3.fromRGB(255,0,255)}
            local c=colors[math.floor(tick()*5)%#colors+1]
            pcall(function()
                if nameFlashGui then
                    local lbl=nameFlashGui:FindFirstChildOfClass("TextLabel")
                    if lbl then lbl.TextColor3=c end
                end
            end)
        end)
    else
        NameFlashB.Text="💫 名字闪动:关";NameFlashB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if nameFlashCn then nameFlashCn:Disconnect();nameFlashCn=nil end
        if nameFlashGui then nameFlashGui:Destroy();nameFlashGui=nil end
    end
end)

-- 娱乐页：角色旋转
SpinB.Activated:Connect(function()
    spinOn=not spinOn
    if spinOn then
        SpinB.Text="🔄 角色旋转:开";SpinB.BackgroundColor3=Color3.fromRGB(80,50,140)
        spinCn=R.Heartbeat:Connect(function(dt)
            if not spinOn then return end
            local r=gR()
            if r then pcall(function() r.CFrame=r.CFrame*CFrame.Angles(0,dt*3,0) end) end
        end)
    else
        SpinB.Text="🔄 角色旋转:关";SpinB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if spinCn then spinCn:Disconnect();spinCn=nil end
    end
end)

-- 娱乐页：角色跳舞
DanceB.Activated:Connect(function()
    danceOn=not danceOn
    if danceOn then
        DanceB.Text="💃 角色跳舞:开";DanceB.BackgroundColor3=Color3.fromRGB(80,50,140)
        pcall(function()
            local c=plr.Character
            if not c then return end
            local anim=Instance.new("Animation")
            anim.AnimationId="rbxassetid://507771019"
            local h=c:FindFirstChildOfClass("Humanoid")
            local animator=h and h:FindFirstChildOfClass("Animator")
            if animator then
                local track=animator:LoadAnimation(anim)
                track.Looped=true
                track:Play()
                danceAnim=track
            end
        end)
    else
        DanceB.Text="💃 角色跳舞:关";DanceB.BackgroundColor3=Color3.fromRGB(45,45,60)
        if danceAnim then pcall(function() danceAnim:Stop() end);danceAnim=nil end
    end
end)

-- 关于页：主题切换
ThemeB.Activated:Connect(function()
    isDark=not isDark
    pcall(function()
        if isDark then
            MF.BackgroundColor3=Color3.fromRGB(18,18,22)
            TB.BackgroundColor3=Color3.fromRGB(24,24,30)
            SB.BackgroundColor3=Color3.fromRGB(22,22,28)
            CB.BackgroundColor3=Color3.fromRGB(22,22,28)
            TT.TextColor3=Color3.fromRGB(200,200,220)
            ThemeB.Text="🎨 切换主题:暗黑"
            ThemeB.BackgroundColor3=Color3.fromRGB(120,80,255)
        else
            MF.BackgroundColor3=Color3.fromRGB(245,245,250)
            TB.BackgroundColor3=Color3.fromRGB(235,235,245)
            SB.BackgroundColor3=Color3.fromRGB(240,240,248)
            CB.BackgroundColor3=Color3.fromRGB(240,240,248)
            TT.TextColor3=Color3.fromRGB(30,30,60)
            ThemeB.Text="🎨 切换主题:明亮"
            ThemeB.BackgroundColor3=Color3.fromRGB(100,150,220)
        end
        for _,v in ipairs(TabButtons) do
            if v.page.Visible then
                v.btn.BackgroundColor3=isDark and Color3.fromRGB(45,45,60) or Color3.fromRGB(180,200,240)
                v.btn.TextColor3=isDark and Color3.fromRGB(120,200,255) or Color3.fromRGB(30,60,120)
            else
                v.btn.BackgroundColor3=isDark and Color3.fromRGB(30,30,38) or Color3.fromRGB(225,225,235)
                v.btn.TextColor3=isDark and Color3.fromRGB(180,180,200) or Color3.fromRGB(80,80,100)
            end
        end
    end)
end)

-- 关于页：迷你模式
MiniB.Activated:Connect(function()
    miniOn=not miniOn
    if miniOn then
        MiniB.Text="📱 迷你模式:开";MiniB.BackgroundColor3=Color3.fromRGB(120,80,255)
        pcall(function() SB.Visible=false;CB.Size=UDim2.new(1,-12,1,-42);CB.Position=UDim2.new(0,6,0,42) end)
        FBt.Activated:Connect(function()
            if miniOn then
                miniOn=false
                MiniB.Text="📱 迷你模式:关";MiniB.BackgroundColor3=Color3.fromRGB(80,50,140)
                pcall(function() SB.Visible=true;CB.Size=UDim2.new(1,-148,1,-42);CB.Position=UDim2.new(0,142,0,42) end)
            end
        end)
    else
        MiniB.Text="📱 迷你模式:关";MiniB.BackgroundColor3=Color3.fromRGB(80,50,140)
        pcall(function() SB.Visible=true;CB.Size=UDim2.new(1,-148,1,-42);CB.Position=UDim2.new(0,142,0,42) end)
    end
end)

-- 关于页：面板阴影
ShadowB.Activated:Connect(function()
    shadowOn=not shadowOn
    if shadowOn then
        ShadowB.Text="🌑 面板阴影:开";ShadowB.BackgroundColor3=Color3.fromRGB(80,50,120)
        if not shadowFrame then
            shadowFrame=Instance.new("Frame",MF)
            shadowFrame.Size=UDim2.new(1,8,1,8)
            shadowFrame.Position=UDim2.new(0,-4,0,-4)
            shadowFrame.BackgroundColor3=Color3.fromRGB(0,0,0)
            shadowFrame.BackgroundTransparency=0.6
            shadowFrame.BorderSizePixel=0
            shadowFrame.ZIndex=0
            Instance.new("UICorner",shadowFrame).CornerRadius=UDim.new(0,14)
        end
    else
        ShadowB.Text="🌑 面板阴影:关";ShadowB.BackgroundColor3=Color3.fromRGB(80,50,140)
        if shadowFrame then shadowFrame:Destroy();shadowFrame=nil end
    end
end)

-- 关于页：自定义悬浮球
ApplyBallB.Activated:Connect(function()
    local id=BallImgBox.Text
    if id and id~="" then
        pcall(function() FBt.Image="rbxassetid://"..id end)
        pcall(function() G:SetCore("SendNotification",{Title="🖼️ 悬浮球已更换",Text="ID: "..id,Duration=2}) end)
    end
end)
ResetBallB.Activated:Connect(function()
    pcall(function() FBt.Image="rbxassetid://10479022679" end)
    pcall(function() G:SetCore("SendNotification",{Title="↩️ 已还原悬浮球",Duration=2}) end)
end)

-- 关于页：改名
ApplyNameB.Activated:Connect(function()
    local newName=RenameBox.Text
    if newName and newName~="" then
        pcall(function()
            local c=plr.Character
            if c then
                local h=c:FindFirstChildOfClass("Humanoid")
                if h then h.DisplayName=newName end
            end
        end)
        pcall(function() G:SetCore("SendNotification",{Title="✏️ 改名成功",Text="本地显示: "..newName,Duration=2}) end)
    end
end)
ResetNameB.Activated:Connect(function()
    pcall(function()
        local c=plr.Character
        if c then
            local h=c:FindFirstChildOfClass("Humanoid")
            if h then h.DisplayName=originalName end
        end
    end)
    pcall(function() G:SetCore("SendNotification",{Title="↩️ 名字已还原",Duration=2}) end)
end)

-- 关于页：配置保存/加载
local ConfigFile="blackhole_config.json"
SaveCfgB.Activated:Connect(function()
    local cfg={
        fSp=fSp,
        clickerRate=clickerRate,
        alertRange=alertRange,
        isDark=isDark,
        opacity=MF.BackgroundTransparency
    }
    local ok,err=pcall(function()
        if writefile then
            writefile(ConfigFile,HS:JSONEncode(cfg))
        end
    end)
    pcall(function()
        G:SetCore("SendNotification",{Title=ok and "💾 配置已保存" or "❌ 保存失败",Text=ok and "已写入文件" or tostring(err),Duration=2})
    end)
end)
LoadCfgB.Activated:Connect(function()
    local ok,data=pcall(function()
        if readfile and isfile and isfile(ConfigFile) then
            return HS:JSONDecode(readfile(ConfigFile))
        end
    end)
    if ok and data then
        fSp=data.fSp or fSp
        clickerRate=data.clickerRate or clickerRate
        alertRange=data.alertRange or alertRange
        pcall(function()
            G:SetCore("SendNotification",{Title="📂 配置已加载",Duration=2})
        end)
    else
        pcall(function()
            G:SetCore("SendNotification",{Title="❌ 加载失败",Text="没有配置文件",Duration=2})
        end)
    end
end)

-- 一键优化清理（改为隐藏而非删除）
OptB.Activated:Connect(function()
    local done={}
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01;table.insert(done,"画质降最低") end)
    pcall(function() L.GlobalShadows=false for _,v in ipairs(L:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v.Enabled=false end end table.insert(done,"关阴影/天气") end)
    pcall(function() local c=0 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled=false;c=c+1 end end table.insert(done,"关"..c.."个特效") end)
    pcall(function()
        local ch=plr.Character
        local org=Vector3.new(0,0,0)
        if ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then org=hrp.Position end end
        local cnt=0
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local isSelf=false
                if ch and v:IsDescendantOf(ch) then isSelf=true end
                for _,p in ipairs(P:GetPlayers()) do
                    if p.Character and v:IsDescendantOf(p.Character) then isSelf=true;break end
                end
                if not isSelf then
                    local d=(v.Position-org).Magnitude
                    if d>500 then v.Transparency=1;v.CanCollide=false;cnt=cnt+1 end
                end
            end
        end
        table.insert(done,"隐藏"..cnt.."个远对象")
    end)
    OptL.Text=table.concat(done," · ")
    pcall(function() G:SetCore("SendNotification",{Title="⚡ 优化完成",Text="已优化+清理",Duration=3}) end)
end)

-- 角色重生清理
plr.CharacterAdded:Connect(function()
    fOn=false;if fCn then fCn:Disconnect();fCn=nil end
    jOn=false;for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    noclipOn=false;if noclipCn then noclipCn:Disconnect();noclipCn=nil end
    if FB then FB.Text="飞行:关";FB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if JB then JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if NoclipB then NoclipB.Text="🚪 穿墙:关";NoclipB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if airWalkCn then airWalkCn:Disconnect();airWalkCn=nil;airWalkOn=false;AirWalkB.Text="🪂 空中行走:关";AirWalkB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if hoverCn then hoverCn:Disconnect();hoverCn=nil;hoverOn=false;HoverB.Text="🪁 悬停工具:关";HoverB.BackgroundColor3=Color3.fromRGB(60,80,150) end
    if pickupCn then pickupCn:Disconnect();pickupCn=nil;pickupOn=false;PickupB.Text="🧲 自动拾取:关";PickupB.BackgroundColor3=Color3.fromRGB(60,120,60) end
    if clickerCn then clickerCn=nil;clickerOn=false;ClickerB.Text="🖱️ 连点器:关";ClickerB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if spinCn then spinCn:Disconnect();spinCn=nil;spinOn=false;SpinB.Text="🔄 角色旋转:关";SpinB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if danceAnim then pcall(function() danceAnim:Stop() end);danceAnim=nil;danceOn=false;DanceB.Text="💃 角色跳舞:关";DanceB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if nameFlashCn then nameFlashCn:Disconnect();nameFlashCn=nil end
    if nameFlashGui then nameFlashGui:Destroy();nameFlashGui=nil end
    nameFlashOn=false;NameFlashB.Text="💫 名字闪动:关";NameFlashB.BackgroundColor3=Color3.fromRGB(45,45,60)
end)

-- 销毁清理
SG.Destroying:Connect(function()
    if fCn then fCn:Disconnect() end
    for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end
    if noclipCn then noclipCn:Disconnect() end
    if afkCn then afkCn:Disconnect() end
    if hoverCn then hoverCn:Disconnect() end
    if pickupCn then pickupCn:Disconnect() end
    if invisDetectCn then invisDetectCn:Disconnect() end
    if antiInvisCn then antiInvisCn:Disconnect() end
    if enemyAlertCn then enemyAlertCn:Disconnect() end
    if followCn then followCn:Disconnect() end
    if lockViewCn then lockViewCn:Disconnect() end
    if trailAttach then trailAttach:Destroy() end
    for _,l in ipairs(glowLights) do pcall(function() l:Destroy() end) end
    if currentSky then currentSky:Destroy() end
    if currentFilter then currentFilter:Destroy() end
    if nameFlashCn then nameFlashCn:Disconnect() end
    if nameFlashGui then nameFlashGui:Destroy() end
    if spinCn then spinCn:Disconnect() end
    if danceAnim then pcall(function() danceAnim:Stop() end) end
    if clickerCn then clickerCn=nil end
    if autoMsgCn then autoMsgCn=nil end
    if airWalkCn then airWalkCn:Disconnect() end
end)
