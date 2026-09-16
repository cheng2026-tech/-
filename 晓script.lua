local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local T=game:GetService("TweenService")
local S=game:GetService("Stats")
local G=game:GetService("StarterGui")
local L=game:GetService("Lighting")
local plr=P.LocalPlayer
local function mt(g)
    if type(gethui)=="function" then local ok=pcall(function() g.Parent=gethui() end) if ok and g.Parent then return end end
    local ok2=pcall(function() g.Parent=game:GetService("CoreGui") end) if ok2 and g.Parent then return end
    pcall(function() g.Parent=plr:WaitForChild("PlayerGui") end)
end

-- 加载动画（60秒，可跳过）
local LG=Instance.new("ScreenGui");LG.Name="加载";LG.ResetOnSpawn=false;LG.IgnoreGuiInset=true;LG.DisplayOrder=9999;mt(LG)
local M=Instance.new("Frame",LG);M.Size=UDim2.new(1,0,1,0);M.BackgroundColor3=Color3.fromRGB(0,0,0);M.BorderSizePixel=0
local Ti=Instance.new("TextLabel",LG);Ti.Size=UDim2.new(1,0,0,70);Ti.Position=UDim2.new(0,0,0.3,0);Ti.BackgroundTransparency=1;Ti.Text="程 程 大 王";Ti.TextColor3=Color3.fromRGB(80,220,80);Ti.TextSize=56;Ti.Font=Enum.Font.Code
local Su=Instance.new("TextLabel",LG);Su.Size=UDim2.new(1,0,0,26);Su.Position=UDim2.new(0,0,0.3,72);Su.BackgroundTransparency=1;Su.Text="SYSTEM DECRYPTION";Su.TextColor3=Color3.fromRGB(80,220,80);Su.TextSize=18;Su.Font=Enum.Font.Code
local BB=Instance.new("Frame",LG);BB.Size=UDim2.new(0,600,0,14);BB.Position=UDim2.new(0.5,-300,0.55,0);BB.BackgroundColor3=Color3.fromRGB(10,10,10);BB.BorderSizePixel=0;Instance.new("UICorner",BB).CornerRadius=UDim.new(1,0)
local BBS=Instance.new("UIStroke",BB);BBS.Color=Color3.fromRGB(80,220,80);BBS.Thickness=2
local BF=Instance.new("Frame",BB);BF.Size=UDim2.new(0,0,1,0);BF.BackgroundColor3=Color3.fromRGB(120,80,220);BF.BorderSizePixel=0;Instance.new("UICorner",BF).CornerRadius=UDim.new(1,0)
local PL2=Instance.new("TextLabel",LG);PL2.Size=UDim2.new(1,0,0,40);PL2.Position=UDim2.new(0,0,0.55,30);PL2.BackgroundTransparency=1;PL2.Text="0%";PL2.TextColor3=Color3.fromRGB(80,220,80);PL2.TextSize=32;PL2.Font=Enum.Font.Code
local RS=Instance.new("TextLabel",LG);RS.Size=UDim2.new(0,400,0,22);RS.Position=UDim2.new(0.5,0,0.55,80);RS.BackgroundTransparency=1;RS.Text="> 正在验证系统完整性...";RS.TextColor3=Color3.fromRGB(80,220,80);RS.TextSize=14;RS.Font=Enum.Font.Code;RS.TextXAlignment=Enum.TextXAlignment.Left
local LF0=Instance.new("Frame",LG);LF0.Size=UDim2.new(0,600,0,200);LF0.Position=UDim2.new(0,30,1,-230);LF0.BackgroundTransparency=1
local LL0=Instance.new("UIListLayout",LF0);LL0.Padding=UDim.new(0,8);LL0.SortOrder=Enum.SortOrder.LayoutOrder
for i,l in ipairs({"> SYS_TEM_INIT: OK","> LOAD_MODULE: FASTFLY()","> LOAD_MODULE: SPEED()","> LOAD_MODULE: INFJUMP()","> LOAD_MODULE: MONITOR()","> LOAD_MODULE: OPTIMIZE()","> LOAD_MODULE: CLICK_DELETE()","> VERIFY_CHECKSUM...","> SYSTEM READY"}) do
    local lbl=Instance.new("TextLabel",LF0);lbl.Size=UDim2.new(1,0,0,18);lbl.BackgroundTransparency=1;lbl.Text="";lbl.TextColor3=Color3.fromRGB(80,220,80);lbl.TextSize=13;lbl.Font=Enum.Font.Code;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.LayoutOrder=i
    task.spawn(function() local s="" for j=1,#l do s=s..string.sub(l,j,j);lbl.Text=s;task.wait(0.04) end end)
    task.wait(0.2)
end
local SkipBtn=Instance.new("TextButton",LG);SkipBtn.Size=UDim2.new(0,80,0,28);SkipBtn.Position=UDim2.new(1,-100,1,-50);SkipBtn.BackgroundColor3=Color3.fromRGB(20,20,20);SkipBtn.Text="[ 跳过 ]";SkipBtn.TextColor3=Color3.fromRGB(80,220,80);SkipBtn.TextSize=13;SkipBtn.Font=Enum.Font.Code;Instance.new("UICorner",SkipBtn).CornerRadius=UDim.new(0,4)
local skipped=false;SkipBtn.Activated:Connect(function() skipped=true end)
local tl={{0,0},{8,10},{16,22},{24,35},{32,48},{40,62},{48,75},{54,88},{60,100}}
local sm={{0,"> 正在验证系统完整性..."},{8,"> 正在解密核心模块..."},{16,"> 正在加载功能接口..."},{24,"> 正在同步服务器数据..."},{32,"> 正在校验安全证书..."},{40,"> 正在注入运行时环境..."},{48,"> 正在初始化UI组件..."},{54,"> 即将完成加载..."}}
local st=tick();local si=1
task.spawn(function()
    while LG.Parent do
        local e=tick()-st;if skipped or e>=60 then break end
        local cp=0
        for i=1,#tl-1 do local t1,p1=tl[i][1],tl[i][2];local t2,p2=tl[i+1][1],tl[i+1][2] if e>=t1 and e<t2 then cp=p1+(p2-p1)*((e-t1)/(t2-t1));break end end
        cp=math.min(cp,100);BF.Size=UDim2.new(cp/100,0,1,0);PL2.Text=string.format("%d%%",cp)
        for i=#sm,1,-1 do if e>=sm[i][1] then if si~=i then si=i;RS.Text=sm[i][2] end;break end end
        task.wait(0.05)
    end
    BF.Size=UDim2.new(1,0,1,0);PL2.Text="100%";RS.Text="> 加载完成！";task.wait(0.4);LG:Destroy()
end)
while LG.Parent do task.wait(0.1) end

-- 主面板
local SG=Instance.new("ScreenGui");SG.Name="程程大王";SG.ResetOnSpawn=false;SG.DisplayOrder=100;mt(SG)
local FBt=Instance.new("TextButton",SG);FBt.Size=UDim2.new(0,52,0,52);FBt.Position=UDim2.new(0,15,0.5,-26);FBt.BackgroundColor3=Color3.fromRGB(20,20,28);FBt.Text="⚙";FBt.TextColor3=Color3.fromRGB(120,200,255);FBt.TextSize=26;FBt.Font=Enum.Font.GothamBold;FBt.ZIndex=100
Instance.new("UICorner",FBt).CornerRadius=UDim.new(1,0)
local FBtS=Instance.new("UIStroke",FBt);FBtS.Color=Color3.fromRGB(120,200,255);FBtS.Thickness=1.5;FBtS.Transparency=0.4
local MF=Instance.new("Frame",SG);MF.Size=UDim2.new(0,520,0,380);MF.Position=UDim2.new(0.5,-260,0.5,-190);MF.BackgroundColor3=Color3.fromRGB(15,15,20);MF.BorderSizePixel=0;MF.Active=true;MF.Draggable=true;MF.ZIndex=10
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)
local MSt=Instance.new("UIStroke",MF);MSt.Color=Color3.fromRGB(100,200,255);MSt.Thickness=1.5;MSt.Transparency=0.4
local TB=Instance.new("Frame",MF);TB.Size=UDim2.new(1,0,0,36);TB.BackgroundColor3=Color3.fromRGB(20,20,28);TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,14)
local TT=Instance.new("TextLabel",TB);TT.Size=UDim2.new(1,-60,1,0);TT.Position=UDim2.new(0,16,0,0);TT.BackgroundTransparency=1;TT.Text="程程大王脚本 · 完整版";TT.TextColor3=Color3.fromRGB(120,200,255);TT.TextSize=13;TT.Font=Enum.Font.GothamBold;TT.TextXAlignment=Enum.TextXAlignment.Left
local XB=Instance.new("TextButton",TB);XB.Size=UDim2.new(0,22,0,22);XB.Position=UDim2.new(1,-30,0,7);XB.BackgroundColor3=Color3.fromRGB(200,50,60);XB.Text="×";XB.TextColor3=Color3.fromRGB(255,255,255);XB.TextSize=14;XB.Font=Enum.Font.GothamBold
Instance.new("UICorner",XB).CornerRadius=UDim.new(1,0)
local SB=Instance.new("Frame",MF);SB.Size=UDim2.new(0,110,1,-50);SB.Position=UDim2.new(0,4,0,40);SB.BackgroundColor3=Color3.fromRGB(18,18,25);SB.BorderSizePixel=0
Instance.new("UICorner",SB).CornerRadius=UDim.new(0,10)
local CB=Instance.new("Frame",MF);CB.Size=UDim2.new(1,-126,1,-50);CB.Position=UDim2.new(0,118,0,40);CB.BackgroundColor3=Color3.fromRGB(18,18,25);CB.BorderSizePixel=0
Instance.new("UICorner",CB).CornerRadius=UDim.new(0,10)
local Tabs={"通用","监控","管理","视觉"}
local TBs={};local TFs={}
local TG=Instance.new("Frame",CB);TG.Size=UDim2.new(1,0,1,0);TG.BackgroundTransparency=1;TFs["通用"]=TG
local FB=Instance.new("TextButton",TG);FB.Size=UDim2.new(0.9,0,0,32);FB.Position=UDim2.new(0.05,0,0,10);FB.BackgroundColor3=Color3.fromRGB(35,35,48);FB.Text="飞行:关";FB.TextColor3=Color3.fromRGB(220,220,220);FB.TextSize=12;FB.Font=Enum.Font.Gotham
Instance.new("UICorner",FB).CornerRadius=UDim.new(0,8)
local FSL=Instance.new("TextLabel",TG);FSL.Size=UDim2.new(0.9,0,0,16);FSL.Position=UDim2.new(0.05,0,0,50);FSL.BackgroundTransparency=1;FSL.Text="飞行速度: 100";FSL.TextColor3=Color3.fromRGB(180,180,200);FSL.TextSize=10;FSL.Font=Enum.Font.Gotham
local FSS=Instance.new("Frame",TG);FSS.Size=UDim2.new(0.9,0,0,8);FSS.Position=UDim2.new(0.05,0,0,68);FSS.BackgroundColor3=Color3.fromRGB(40,40,55);FSS.BorderSizePixel=0
Instance.new("UICorner",FSS).CornerRadius=UDim.new(1,0)
local FSF=Instance.new("Frame",FSS);FSF.Size=UDim2.new(0.05,0,1,0);FSF.BackgroundColor3=Color3.fromRGB(120,80,255);FSF.BorderSizePixel=0
Instance.new("UICorner",FSF).CornerRadius=UDim.new(1,0)
local WL=Instance.new("TextLabel",TG);WL.Size=UDim2.new(0.9,0,0,16);WL.Position=UDim2.new(0.05,0,0,90);WL.BackgroundTransparency=1;WL.Text="跑步速度: 16";WL.TextColor3=Color3.fromRGB(180,180,200);WL.TextSize=10;WL.Font=Enum.Font.Gotham
local WS=Instance.new("Frame",TG);WS.Size=UDim2.new(0.9,0,0,8);WS.Position=UDim2.new(0.05,0,0,108);WS.BackgroundColor3=Color3.fromRGB(40,40,55);WS.BorderSizePixel=0
Instance.new("UICorner",WS).CornerRadius=UDim.new(1,0)
local WF=Instance.new("Frame",WS);WF.Size=UDim2.new(0.05,0,1,0);WF.BackgroundColor3=Color3.fromRGB(120,80,255);WF.BorderSizePixel=0
Instance.new("UICorner",WF).CornerRadius=UDim.new(1,0)
local JB=Instance.new("TextButton",TG);JB.Size=UDim2.new(0.9,0,0,32);JB.Position=UDim2.new(0.05,0,0,130);JB.BackgroundColor3=Color3.fromRGB(35,35,48);JB.Text="无限跳:关";JB.TextColor3=Color3.fromRGB(220,220,220);JB.TextSize=12;JB.Font=Enum.Font.Gotham
Instance.new("UICorner",JB).CornerRadius=UDim.new(0,8)local TM=Instance.new("Frame",CB);TM.Size=UDim2.new(1,0,1,0);TM.BackgroundTransparency=1;TM.Visible=false;TFs["监控"]=TM
local FLL=Instance.new("TextLabel",TM);FLL.Size=UDim2.new(0.9,0,0,20);FLL.Position=UDim2.new(0.05,0,0,20);FLL.BackgroundTransparency=1;FLL.Text="FPS: --";FLL.TextColor3=Color3.fromRGB(82,196,26);FLL.TextSize=14;FLL.Font=Enum.Font.Code;FLL.TextXAlignment=Enum.TextXAlignment.Left
local PLL=Instance.new("TextLabel",TM);PLL.Size=UDim2.new(0.9,0,0,20);PLL.Position=UDim2.new(0.05,0,0,50);PLL.BackgroundTransparency=1;PLL.Text="延迟: --";PLL.TextColor3=Color3.fromRGB(255,193,7);PLL.TextSize=14;PLL.Font=Enum.Font.Code;PLL.TextXAlignment=Enum.TextXAlignment.Left
local MLL=Instance.new("TextLabel",TM);MLL.Size=UDim2.new(0.9,0,0,20);MLL.Position=UDim2.new(0.05,0,0,80);MLL.BackgroundTransparency=1;MLL.Text="内存: --";MLL.TextColor3=Color3.fromRGB(0,150,220);MLL.TextSize=14;MLL.Font=Enum.Font.Code;MLL.TextXAlignment=Enum.TextXAlignment.Left
local OptB=Instance.new("TextButton",TM);OptB.Size=UDim2.new(0.9,0,0,28);OptB.Position=UDim2.new(0.05,0,0,120);OptB.BackgroundColor3=Color3.fromRGB(60,120,60);OptB.Text="⚡ 一键优化+清理";OptB.TextColor3=Color3.fromRGB(255,255,255);OptB.TextSize=11;OptB.Font=Enum.Font.GothamBold
Instance.new("UICorner",OptB).CornerRadius=UDim.new(0,8)
local UndB=Instance.new("TextButton",TM);UndB.Size=UDim2.new(0.9,0,0,24);UndB.Position=UDim2.new(0.05,0,0,155);UndB.BackgroundColor3=Color3.fromRGB(40,40,55);UndB.Text="♻️ 恢复对象";UndB.TextColor3=Color3.fromRGB(200,200,220);UndB.TextSize=11;UndB.Font=Enum.Font.Gotham
Instance.new("UICorner",UndB).CornerRadius=UDim.new(0,8)
local OptL=Instance.new("TextLabel",TM);OptL.Size=UDim2.new(0.9,0,0,40);OptL.Position=UDim2.new(0.05,0,0,185);OptL.BackgroundTransparency=1;OptL.Text="";OptL.TextColor3=Color3.fromRGB(150,220,150);OptL.TextSize=10;OptL.Font=Enum.Font.Code;OptL.TextWrapped=true;OptL.TextXAlignment=Enum.TextXAlignment.Left
task.spawn(function()
    local fps={}
    while MF.Parent do
        local n=tick();table.insert(fps,n)
        while #fps>0 and n-fps[1]>1 do table.remove(fps,1) end
        pcall(function() FLL.Text="FPS: "..#fps end)
        pcall(function() PLL.Text="延迟: "..math.floor(plr:GetNetworkPing()*1000).."ms" end)
        pcall(function() MLL.Text="内存: "..math.floor(S:GetTotalMemoryUsageMb()).."MB" end)
        task.wait(0.5)
    end
end)
local TA=Instance.new("Frame",CB);TA.Size=UDim2.new(1,0,1,0);TA.BackgroundTransparency=1;TA.Visible=false;TFs["管理"]=TA
local ScB=Instance.new("TextButton",TA);ScB.Size=UDim2.new(0.45,0,0,26);ScB.Position=UDim2.new(0.03,0,0,10);ScB.BackgroundColor3=Color3.fromRGB(60,30,100);ScB.Text="🔍 扫描管理员";ScB.TextColor3=Color3.fromRGB(220,180,255);ScB.TextSize=11;ScB.Font=Enum.Font.Gotham
Instance.new("UICorner",ScB).CornerRadius=UDim.new(0,8)
local ClB=Instance.new("TextButton",TA);ClB.Size=UDim2.new(0.45,0,0,26);ClB.Position=UDim2.new(0.52,0,0,10);ClB.BackgroundColor3=Color3.fromRGB(40,40,55);ClB.Text="清空日志";ClB.TextColor3=Color3.fromRGB(200,200,200);ClB.TextSize=11;ClB.Font=Enum.Font.Gotham
Instance.new("UICorner",ClB).CornerRadius=UDim.new(0,8)
local LG2=Instance.new("ScrollingFrame",TA);LG2.Size=UDim2.new(0.94,0,1,-50);LG2.Position=UDim2.new(0.03,0,0,44);LG2.BackgroundColor3=Color3.fromRGB(12,12,18);LG2.BorderSizePixel=0;LG2.ScrollBarThickness=3
LG2.CanvasSize=UDim2.new(0,0,0,0)
Instance.new("UICorner",LG2).CornerRadius=UDim.new(0,6)
local LL=Instance.new("UIListLayout",LG2);LL.Padding=UDim.new(0,2)
local logN=0
local function addLog(t,c)
    logN=logN+1
    local l=Instance.new("TextLabel",LG2);l.Size=UDim2.new(1,-6,0,16);l.BackgroundTransparency=1
    l.Text="["..logN.."] "..t;l.TextColor3=c or Color3.fromRGB(220,220,220);l.TextSize=10;l.Font=Enum.Font.Code;l.TextXAlignment=Enum.TextXAlignment.Left
    LG2.CanvasSize=UDim2.new(0,0,0,LL.AbsoluteContentSize.Y+5);LG2.CanvasPosition=Vector2.new(0,LL.AbsoluteContentSize.Y)
end
ClB.Activated:Connect(function() for _,c in ipairs(LG2:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end;logN=0 end)
local KW={"admin","mod","owner","staff","gm","管理","群主","服主","老大","老板","creator","dev"}
local function isKW(s) local lo=string.lower(s or "") for _,k in ipairs(KW) do if string.find(lo,k) then return true end end return false end
local function checkAdm(p)
    local r={}
    if isKW(p.Name) then table.insert(r,"名字:"..p.Name) end
    if isKW(p.DisplayName or "") then table.insert(r,"昵称:"..p.DisplayName) end
    pcall(function() for _,a in ipairs({"Admin","admin","IsAdmin","Rank","rank","Role"}) do local v=p:GetAttribute(a) if v~=nil then table.insert(r,"属性"..a.."="..tostring(v)) end end end)
    pcall(function() local ls=p:FindFirstChild("leaderstats") if ls then for _,s in ipairs(ls:GetChildren()) do local sn=string.lower(s.Name) if string.find(sn,"rank") or string.find(sn,"admin") or string.find(sn,"role") then table.insert(r,"排行:"..s.Name) end end end end)
    return #r>0,r
end
ScB.Activated:Connect(function()
    addLog("=== 扫描 ===",Color3.fromRGB(255,255,100));local f=false
    for _,o in ipairs(P:GetPlayers()) do if o~=plr then local isA,rr=checkAdm(o) if isA then f=true;addLog("⚠️ "..o.Name,Color3.fromRGB(255,100,100)) for _,x in ipairs(rr) do addLog("  →"..x,Color3.fromRGB(255,180,180)) end end end end
    if not f then addLog("✅ 未发现管理员",Color3.fromRGB(100,255,100)) end
end)
P.PlayerAdded:Connect(function(o)
    if o==plr then return end;task.wait(1.5);local isA,rr=checkAdm(o)
    if isA then addLog("⚠️ 进入:"..o.Name,Color3.fromRGB(255,100,100)) for _,x in ipairs(rr) do addLog("  →"..x,Color3.fromRGB(255,180,180)) end else addLog("进入:"..o.Name,Color3.fromRGB(150,200,255)) end
end)
P.PlayerRemoving:Connect(function(o)
    if o==plr then return end
    if checkAdm(o) then addLog("✅ 离开:"..o.Name,Color3.fromRGB(100,255,100)) else addLog("离开:"..o.Name,Color3.fromRGB(180,180,180)) end
end)
local TV=Instance.new("Frame",CB);TV.Size=UDim2.new(1,0,1,0);TV.BackgroundTransparency=1;TV.Visible=false;TFs["视觉"]=TV
local ClkB=Instance.new("TextButton",TV);ClkB.Size=UDim2.new(0.9,0,0,32);ClkB.Position=UDim2.new(0.05,0,0,10);ClkB.BackgroundColor3=Color3.fromRGB(180,60,30);ClkB.Text="🎯 点击删除:关";ClkB.TextColor3=Color3.fromRGB(255,255,255);ClkB.TextSize=12;ClkB.Font=Enum.Font.Gotham
Instance.new("UICorner",ClkB).CornerRadius=UDim.new(0,8)
local RsB=Instance.new("TextButton",TV);RsB.Size=UDim2.new(0.9,0,0,32);RsB.Position=UDim2.new(0.05,0,0,52);RsB.BackgroundColor3=Color3.fromRGB(40,40,55);RsB.Text="♻️ 恢复全部";RsB.TextColor3=Color3.fromRGB(200,200,200);RsB.TextSize=12;RsB.Font=Enum.Font.Gotham
Instance.new("UICorner",RsB).CornerRadius=UDim.new(0,8)
for i,name in ipairs(Tabs) do
    local btn=Instance.new("TextButton",SB);btn.Size=UDim2.new(0.9,0,0,32);btn.Position=UDim2.new(0.05,0,0,8+(i-1)*40);btn.BackgroundColor3=Color3.fromRGB(25,25,35);btn.Text=name;btn.TextColor3=Color3.fromRGB(180,180,200);btn.TextSize=12;btn.Font=Enum.Font.Gotham
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
    TBs[name]=btn
    btn.Activated:Connect(function()
        for n,b in pairs(TBs) do b.BackgroundColor3=Color3.fromRGB(25,25,35);b.TextColor3=Color3.fromRGB(180,180,200);TFs[n].Visible=false end
        btn.BackgroundColor3=Color3.fromRGB(50,80,140);btn.TextColor3=Color3.fromRGB(150,220,255);TFs[name].Visible=true
    end)
end
TBs["通用"].BackgroundColor3=Color3.fromRGB(50,80,140);TBs["通用"].TextColor3=Color3.fromRGB(150,220,255);TG.Visible=true
local CF=Instance.new("Frame",SG);CF.Size=UDim2.new(0,260,0,120);CF.Position=UDim2.new(0.5,-130,0.5,-60);CF.BackgroundColor3=Color3.fromRGB(20,20,28);CF.BorderSizePixel=0;CF.Visible=false;CF.ZIndex=500
Instance.new("UICorner",CF).CornerRadius=UDim.new(0,12)
local CSt=Instance.new("UIStroke",CF);CSt.Color=Color3.fromRGB(255,100,100);CSt.Thickness=1.5;CSt.ZIndex=501
local CT=Instance.new("TextLabel",CF);CT.Size=UDim2.new(1,0,0,40);CT.Position=UDim2.new(0,0,0,15);CT.BackgroundTransparency=1;CT.Text="⚠️ 确定要关闭脚本吗？";CT.TextColor3=Color3.fromRGB(255,120,120);CT.TextSize=14;CT.Font=Enum.Font.GothamBold;CT.ZIndex=502
local YesB=Instance.new("TextButton",CF);YesB.Size=UDim2.new(0,100,0,32);YesB.Position=UDim2.new(0,15,0,70);YesB.BackgroundColor3=Color3.fromRGB(200,50,60);YesB.Text="确定关闭";YesB.TextColor3=Color3.fromRGB(255,255,255);YesB.TextSize=12;YesB.Font=Enum.Font.GothamBold;YesB.ZIndex=502
Instance.new("UICorner",YesB).CornerRadius=UDim.new(0,8)
local NoB=Instance.new("TextButton",CF);NoB.Size=UDim2.new(0,100,0,32);NoB.Position=UDim2.new(1,-115,0,70);NoB.BackgroundColor3=Color3.fromRGB(40,40,55);NoB.Text="取消";NoB.TextColor3=Color3.fromRGB(200,200,200);NoB.TextSize=12;NoB.Font=Enum.Font.GothamBold;NoB.ZIndex=502
Instance.new("UICorner",NoB).CornerRadius=UDim.new(0,8)
local fOn=false;local fSp=100;local fCn=nil;local fPos=Vector3.new(0,0,0)
local jOn=false;local jCn={}
local cOn=false;local cCn=nil;local del={}
local cleanLog={}
local function gH() local c=plr.Character;return c and c:FindFirstChildOfClass("Humanoid") end
local function gR() local c=plr.Character;return c and c:FindFirstChild("HumanoidRootPart") end
local function stopAll()
    fOn=false;if fCn then fCn:Disconnect();fCn=nil end
    jOn=false;for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    cOn=false;if cCn then cCn:Disconnect();cCn=nil end
    local h=gH();if h then pcall(function() h.WalkSpeed=16;h.JumpPower=50 end) end
end
FBt.Activated:Connect(function() MF.Visible=not MF.Visible if MF.Visible then FBt.Text="⚙";FBt.TextColor3=Color3.fromRGB(120,200,255) else FBt.Text="▶";FBt.TextColor3=Color3.fromRGB(80,220,80) end end)
XB.Activated:Connect(function() CF.Visible=true end)
NoB.Activated:Connect(function() CF.Visible=false end)
YesB.Activated:Connect(function() stopAll();SG:Destroy() end)
local function startFly()
    FB.Text="飞行:开";FB.BackgroundColor3=Color3.fromRGB(80,50,140)
    local r=gR();if not r then return end
    fOn=true;fPos=r.Position
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
end
local function stopFly()
    fOn=false;if fCn then fCn:Disconnect();fCn=nil end
    FB.Text="飞行:关";FB.BackgroundColor3=Color3.fromRGB(35,35,48)
end
FB.Activated:Connect(function() if fOn then stopFly() else startFly() end end)
plr.CharacterAdded:Connect(function() if fOn then stopFly() end end)
FSS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp end end)
FSS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp end end)
local function updW(x)
    local p=math.clamp((x-WS.AbsolutePosition.X)/WS.AbsoluteSize.X,0,1)
    WF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WL.Text="跑步速度: "..t
    local h=gH() if h then task.spawn(function() local cur=h.WalkSpeed local st=0 while math.abs(cur-t)>1 and st<60 do st=st+1;cur=cur+(t>cur and 3 or -3);pcall(function() h.WalkSpeed=cur end);task.wait(0.08) end pcall(function() h.WalkSpeed=t end) end) end
end
WS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then updW(i.Position.X) end end)
WS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then updW(i.Position.X) end end)
local function doJ() local h=gH() if not h then return end pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
local function startJ()
    jOn=true;JB.Text="无限跳:开";JB.BackgroundColor3=Color3.fromRGB(80,50,140)
    for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    table.insert(jCn,U.InputBegan:Connect(function(i,gp) if gp then return end if not jOn then return end if i.KeyCode==Enum.KeyCode.Space and i.UserInputType==Enum.UserInputType.Keyboard then doJ() end end))
    table.insert(jCn,U.JumpRequest:Connect(function() if jOn then doJ() end end))
end
local function stopJ()
    jOn=false;for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(35,35,48)
end
JB.Activated:Connect(function() if jOn then stopJ() else startJ() end end)
local function isPP(p) for _,x in ipairs(P:GetPlayers()) do if x.Character and p:IsDescendantOf(x.Character) then return true end end return false end
local function startC()
    cOn=true;ClkB.Text="🎯 点击删除:开";ClkB.BackgroundColor3=Color3.fromRGB(120,40,20)
    cCn=U.InputBegan:Connect(function(i,gp)
        if gp or not cOn then return end
        if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
        local cam=workspace.CurrentCamera
        local ray=cam:ScreenPointToRay(i.Position.X,i.Position.Y)
        local pr=RaycastParams.new();pr.FilterType=Enum.RaycastFilterType.Exclude;pr.FilterDescendantsInstances={plr.Character}
        local res=workspace:Raycast(ray.Origin,ray.Direction*500,pr)
        if res and res.Instance and not isPP(res.Instance) then table.insert(del,{o=res.Instance,p=res.Instance.Parent});res.Instance.Parent=nil end
    end)
end
local function stopC()
    cOn=false;ClkB.Text="🎯 点击删除:关";ClkB.BackgroundColor3=Color3.fromRGB(180,60,30)
    if cCn then cCn:Disconnect();cCn=nil end
end
ClkB.Activated:Connect(function() if cOn then stopC() else startC() end end)
RsB.Activated:Connect(function() for _,d in ipairs(del) do pcall(function() if d.o and d.p then d.o.Parent=d.p end end) end;del={} end)
OptB.Activated:Connect(function()
    local done={}
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01;table.insert(done,"画质降最低") end)
    pcall(function() L.GlobalShadows=false for _,v in ipairs(L:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v.Enabled=false end end table.insert(done,"关阴影/天气") end)
    pcall(function() local c=0 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled=false;c=c+1 end end table.insert(done,"关"..c.."个特效") end)
    pcall(function() local ch=plr.Character;local org=Vector3.new(0,0,0) if ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then org=hrp.Position end end local rm=0 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then local isSelf=false if ch and v:IsDescendantOf(ch) then isSelf=true end for _,p in ipairs(P:GetPlayers()) do if p.Character and v:IsDescendantOf(p.Character) then isSelf=true;break end end if not isSelf then local d=(v.Position-org).Magnitude if d>500 then table.insert(cleanLog,{o=v,p=v.Parent});v.Parent=nil;rm=rm+1 end end end end table.insert(done,"清理"..rm.."个远对象") end)
    OptL.Text=table.concat(done," · ")
    pcall(function() G:SetCore("SendNotification",{Title="⚡ 优化完成",Text="已优化+清理",Duration=3}) end)
end)
UndB.Activated:Connect(function()
    local c=0
    for _,d in ipairs(cleanLog) do pcall(function() if d.o and d.p then d.o.Parent=d.p;c=c+1 end end) end
    cleanLog={}
    OptL.Text="已恢复 "..c.." 个对象"
end)
