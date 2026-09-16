local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local S=game:GetService("Stats")
local L=game:GetService("Lighting")
local G=game:GetService("StarterGui")
local plr=P.LocalPlayer

local function mt(g)
    if type(gethui)=="function" then local ok=pcall(function() g.Parent=gethui() end) if ok and g.Parent then return end end
    local ok2=pcall(function() g.Parent=game:GetService("CoreGui") end) if ok2 and g.Parent then return end
    pcall(function() g.Parent=plr:WaitForChild("PlayerGui") end)
end

-- 加载动画
local LG=Instance.new("ScreenGui");LG.Name="加载";LG.ResetOnSpawn=false;LG.IgnoreGuiInset=true;mt(LG)
local LBF=Instance.new("Frame",LG);LBF.Size=UDim2.new(0,300,0,4);LBF.Position=UDim2.new(0.5,-150,0.5);LBF.BackgroundColor3=Color3.fromRGB(30,30,35);LBF.BorderSizePixel=0
Instance.new("UICorner",LBF).CornerRadius=UDim.new(1,0)
local LBF2=Instance.new("Frame",LBF);LBF2.Size=UDim2.new(0,0,1,0);LBF2.BackgroundColor3=Color3.fromRGB(120,80,255);LBF2.BorderSizePixel=0
Instance.new("UICorner",LBF2).CornerRadius=UDim.new(1,0)
task.spawn(function()
    for i=1,10 do task.wait(0.1); LBF2.Size=UDim2.new(i/10,0,1,0) end
    LG:Destroy()
end)

-- 主面板
local SG=Instance.new("ScreenGui");SG.Name="黑洞";SG.ResetOnSpawn=false;mt(SG)
local MF=Instance.new("Frame",SG)
MF.Size=UDim2.new(0,560,0,400);MF.Position=UDim2.new(0.5,-280,0.5,-200)
MF.BackgroundColor3=Color3.fromRGB(18,18,22);MF.BorderSizePixel=0;MF.Active=true;MF.Draggable=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
Instance.new("UIStroke",MF).Color=Color3.fromRGB(50,50,60)

local FBt=Instance.new("ImageButton",SG);FBt.Size=UDim2.new(0,52,0,52);FBt.Position=UDim2.new(0,10,0.5,-26)
FBt.BackgroundColor3=Color3.fromRGB(20,20,28);FBt.Image="rbxassetid://10479022679";FBt.ScaleType=Enum.ScaleType.Fit
Instance.new("UICorner",FBt).CornerRadius=UDim.new(1,0);Instance.new("UIStroke",FBt).Color=Color3.fromRGB(120,200,255)
FBt.Activated:Connect(function() MF.Visible=not MF.Visible end)

local TB=Instance.new("Frame",MF);TB.Size=UDim2.new(1,0,0,36);TB.BackgroundColor3=Color3.fromRGB(24,24,30);TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,12)
local TT=Instance.new("TextLabel",TB);TT.Size=UDim2.new(0.5,0,1,0);TT.Position=UDim2.new(0,15,0,0);TT.BackgroundTransparency=1;TT.Text="黑洞";TT.TextColor3=Color3.fromRGB(200,200,220);TT.TextSize=13;TT.Font=Enum.Font.GothamBold;TT.TextXAlignment=Enum.TextXAlignment.Left
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

local SB=Instance.new("Frame",MF);SB.Size=UDim2.new(0,130,1,-42);SB.Position=UDim2.new(0,6,0,42);SB.BackgroundColor3=Color3.fromRGB(22,22,28);SB.BorderSizePixel=0
Instance.new("UICorner",SB).CornerRadius=UDim.new(0,8)
local CB=Instance.new("Frame",MF);CB.Size=UDim2.new(1,-148,1,-42);CB.Position=UDim2.new(0,142,0,42);CB.BackgroundColor3=Color3.fromRGB(22,22,28);CB.BorderSizePixel=0
Instance.new("UICorner",CB).CornerRadius=UDim.new(0,8)

local Pages={};local TabButtons={}
local function AddTab(name,icon)
    local btn=Instance.new("TextButton",SB);btn.Size=UDim2.new(1,-8,0,32);btn.Position=UDim2.new(0,4,0,4+(#TabButtons*36))
    btn.BackgroundColor3=Color3.fromRGB(30,30,38);btn.Text=icon.." "..name;btn.TextColor3=Color3.fromRGB(180,180,200);btn.TextSize=12;btn.Font=Enum.Font.Gotham;btn.TextXAlignment=Enum.TextXAlignment.Left
    btn.Parent=SB;Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
    local page=Instance.new("Frame",CB);page.Size=UDim2.new(1,-12,1,-12);page.Position=UDim2.new(0,6,0,6);page.BackgroundTransparency=1;page.Visible=false
    Pages[name]=page;table.insert(TabButtons,{btn=btn,page=page,name=name})
    btn.Activated:Connect(function()
        for _,v in ipairs(TabButtons) do v.btn.BackgroundColor3=Color3.fromRGB(30,30,38);v.btn.TextColor3=Color3.fromRGB(180,180,200);v.page.Visible=false end
        btn.BackgroundColor3=Color3.fromRGB(45,45,60);btn.TextColor3=Color3.fromRGB(120,200,255);page.Visible=true
    end)
end
AddTab("通用","🏠");AddTab("监控","📊");AddTab("视觉","👁️");AddTab("天气","☁️");AddTab("音乐","🎵");AddTab("关于","ℹ️")
TabButtons[1].btn.BackgroundColor3=Color3.fromRGB(45,45,60);TabButtons[1].btn.TextColor3=Color3.fromRGB(120,200,255);TabButtons[1].page.Visible=true

-- 通用页
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
local FSF=Instance.new("Frame",FSS);FSF.Size=UDim2.new(0.05,0,1,0);FSF.BackgroundColor3=Color3.fromRGB(120,80,255);FSF.BorderSizePixel=0
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

-- 监控页
local FLL=Instance.new("TextLabel",Pages["监控"]);FLL.Size=UDim2.new(1,-20,0,20);FLL.Position=UDim2.new(0,10,0,10);FLL.BackgroundTransparency=1;FLL.Text="FPS: --";FLL.TextColor3=Color3.fromRGB(82,196,26);FLL.TextSize=14;FLL.Font=Enum.Font.Code;FLL.TextXAlignment=Enum.TextXAlignment.Left
local PLL=Instance.new("TextLabel",Pages["监控"]);PLL.Size=UDim2.new(1,-20,0,20);PLL.Position=UDim2.new(0,10,0,40);PLL.BackgroundTransparency=1;PLL.Text="延迟: --";PLL.TextColor3=Color3.fromRGB(255,193,7);PLL.TextSize=14;PLL.Font=Enum.Font.Code;PLL.TextXAlignment=Enum.TextXAlignment.Left
local MLL=Instance.new("TextLabel",Pages["监控"]);MLL.Size=UDim2.new(1,-20,0,20);MLL.Position=UDim2.new(0,10,0,70);MLL.BackgroundTransparency=1;MLL.Text="内存: --";MLL.TextColor3=Color3.fromRGB(0,150,220);MLL.TextSize=14;MLL.Font=Enum.Font.Code;MLL.TextXAlignment=Enum.TextXAlignment.Left
local OptB=Instance.new("TextButton",Pages["监控"]);OptB.Size=UDim2.new(0,150,0,28);OptB.Position=UDim2.new(0,10,0,110);OptB.BackgroundColor3=Color3.fromRGB(60,120,60);OptB.Text="⚡ 一键优化+清理";OptB.TextColor3=Color3.fromRGB(255,255,255);OptB.TextSize=11;OptB.Font=Enum.Font.GothamBold
Instance.new("UICorner",OptB).CornerRadius=UDim.new(0,6)
local OptL=Instance.new("TextLabel",Pages["监控"]);OptL.Size=UDim2.new(1,-20,0,40);OptL.Position=UDim2.new(0,10,0,145);OptL.BackgroundTransparency=1;OptL.Text="";OptL.TextColor3=Color3.fromRGB(150,220,150);OptL.TextSize=10;OptL.Font=Enum.Font.Code;OptL.TextWrapped=true;OptL.TextXAlignment=Enum.TextXAlignment.Left
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

-- 视觉页
local ClkB=Instance.new("TextButton",Pages["视觉"]);ClkB.Size=UDim2.new(0,150,0,32);ClkB.Position=UDim2.new(0,10,0,10);ClkB.BackgroundColor3=Color3.fromRGB(180,60,30);ClkB.Text="🎯 点击删除:关";ClkB.TextColor3=Color3.fromRGB(255,255,255);ClkB.TextSize=12;ClkB.Font=Enum.Font.Gotham
Instance.new("UICorner",ClkB).CornerRadius=UDim.new(0,6)
local RsB=Instance.new("TextButton",Pages["视觉"]);RsB.Size=UDim2.new(0,150,0,32);RsB.Position=UDim2.new(0,170,0,10);RsB.BackgroundColor3=Color3.fromRGB(40,40,55);RsB.Text="♻️ 恢复全部";RsB.TextColor3=Color3.fromRGB(200,200,200);RsB.TextSize=12;RsB.Font=Enum.Font.Gotham
Instance.new("UICorner",RsB).CornerRadius=UDim.new(0,6)
local NoclipB=Instance.new("TextButton",Pages["视觉"]);NoclipB.Size=UDim2.new(0,150,0,32);NoclipB.Position=UDim2.new(0,10,0,52);NoclipB.BackgroundColor3=Color3.fromRGB(45,45,60);NoclipB.Text="🚪 穿墙:关";NoclipB.TextColor3=Color3.fromRGB(220,220,220);NoclipB.TextSize=12;NoclipB.Font=Enum.Font.Gotham
Instance.new("UICorner",NoclipB).CornerRadius=UDim.new(0,6)
local AntiAFK=Instance.new("TextButton",Pages["视觉"]);AntiAFK.Size=UDim2.new(0,150,0,32);AntiAFK.Position=UDim2.new(0,170,0,52);AntiAFK.BackgroundColor3=Color3.fromRGB(45,45,60);AntiAFK.Text="💤 防挂机:关";AntiAFK.TextColor3=Color3.fromRGB(220,220,220);AntiAFK.TextSize=12;AntiAFK.Font=Enum.Font.Gotham
Instance.new("UICorner",AntiAFK).CornerRadius=UDim.new(0,6)
local ScaleSlider=Instance.new("TextLabel",Pages["视觉"]);ScaleSlider.Size=UDim2.new(1,-20,0,15);ScaleSlider.Position=UDim2.new(0,10,0,100);ScaleSlider.BackgroundTransparency=1;ScaleSlider.Text="人物大小: 1.0x";ScaleSlider.TextColor3=Color3.fromRGB(180,180,200);ScaleSlider.TextSize=11;ScaleSlider.Font=Enum.Font.Gotham;ScaleSlider.TextXAlignment=Enum.TextXAlignment.Left
local SSF=Instance.new("Frame",Pages["视觉"]);SSF.Size=UDim2.new(1,-20,0,8);SSF.Position=UDim2.new(0,10,0,120);SSF.BackgroundColor3=Color3.fromRGB(40,40,55);SSF.BorderSizePixel=0
Instance.new("UICorner",SSF).CornerRadius=UDim.new(1,0)
local SSFF=Instance.new("Frame",SSF);SSFF.Size=UDim2.new(0.05,0,1,0);SSFF.BackgroundColor3=Color3.fromRGB(120,80,255);SSFF.BorderSizePixel=0
Instance.new("UICorner",SSFF).CornerRadius=UDim.new(1,0)

-- 天气页
local WeatherB=Instance.new("TextButton",Pages["天气"]);WeatherB.Size=UDim2.new(0,150,0,32);WeatherB.Position=UDim2.new(0,10,0,10);WeatherB.BackgroundColor3=Color3.fromRGB(50,100,150);WeatherB.Text="☀️ 晴天";WeatherB.TextColor3=Color3.fromRGB(255,255,255);WeatherB.TextSize=12;WeatherB.Font=Enum.Font.Gotham
Instance.new("UICorner",WeatherB).CornerRadius=UDim.new(0,6)
local TimeB=Instance.new("TextButton",Pages["天气"]);TimeB.Size=UDim2.new(0,150,0,32);TimeB.Position=UDim2.new(0,170,0,10);TimeB.BackgroundColor3=Color3.fromRGB(50,100,150);TimeB.Text="☀️ 正午";TimeB.TextColor3=Color3.fromRGB(255,255,255);TimeB.TextSize=12;TimeB.Font=Enum.Font.Gotham
Instance.new("UICorner",TimeB).CornerRadius=UDim.new(0,6)
local ThunderB=Instance.new("TextButton",Pages["天气"]);ThunderB.Size=UDim2.new(0,150,0,32);ThunderB.Position=UDim2.new(0,10,0,52);ThunderB.BackgroundColor3=Color3.fromRGB(60,50,100);ThunderB.Text="⛈️ 打雷";ThunderB.TextColor3=Color3.fromRGB(255,255,255);ThunderB.TextSize=12;ThunderB.Font=Enum.Font.Gotham
Instance.new("UICorner",ThunderB).CornerRadius=UDim.new(0,6)
local SnowB=Instance.new("TextButton",Pages["天气"]);SnowB.Size=UDim2.new(0,150,0,32);SnowB.Position=UDim2.new(0,170,0,52);SnowB.BackgroundColor3=Color3.fromRGB(120,150,200);SnowB.Text="❄️ 下雪";SnowB.TextColor3=Color3.fromRGB(255,255,255);SnowB.TextSize=12;SnowB.Font=Enum.Font.Gotham
Instance.new("UICorner",SnowB).CornerRadius=UDim.new(0,6)

-- 音乐页
local musicIdBox=Instance.new("TextBox",Pages["音乐"]);musicIdBox.Size=UDim2.new(1,-20,0,30);musicIdBox.Position=UDim2.new(0,10,0,10);musicIdBox.BackgroundColor3=Color3.fromRGB(30,30,38);musicIdBox.BorderSizePixel=0;musicIdBox.Text="";musicIdBox.PlaceholderText="输入 Roblox 音频 ID（纯数字）";musicIdBox.TextColor3=Color3.fromRGB(220,220,220);musicIdBox.PlaceholderColor3=Color3.fromRGB(120,120,140);musicIdBox.TextSize=12;musicIdBox.Font=Enum.Font.Gotham
Instance.new("UICorner",musicIdBox).CornerRadius=UDim.new(0,6)
local playB=Instance.new("TextButton",Pages["音乐"]);playB.Size=UDim2.new(0,100,0,30);playB.Position=UDim2.new(0,10,0,50);playB.BackgroundColor3=Color3.fromRGB(60,120,60);playB.Text="▶️ 播放";playB.TextColor3=Color3.fromRGB(255,255,255);playB.TextSize=12;playB.Font=Enum.Font.GothamBold
Instance.new("UICorner",playB).CornerRadius=UDim.new(0,6)
local stopB=Instance.new("TextButton",Pages["音乐"]);stopB.Size=UDim2.new(0,100,0,30);stopB.Position=UDim2.new(0,120,0,50);stopB.BackgroundColor3=Color3.fromRGB(150,60,60);stopB.Text="⏹️ 停止";stopB.TextColor3=Color3.fromRGB(255,255,255);stopB.TextSize=12;stopB.Font=Enum.Font.GothamBold
Instance.new("UICorner",stopB).CornerRadius=UDim.new(0,6)
local volLabel=Instance.new("TextLabel",Pages["音乐"]);volLabel.Size=UDim2.new(1,-20,0,15);volLabel.Position=UDim2.new(0,10,0,95);volLabel.BackgroundTransparency=1;volLabel.Text="音量: 50%";volLabel.TextColor3=Color3.fromRGB(180,180,200);volLabel.TextSize=11;volLabel.Font=Enum.Font.Gotham;volLabel.TextXAlignment=Enum.TextXAlignment.Left
local volSlider=Instance.new("Frame",Pages["音乐"]);volSlider.Size=UDim2.new(1,-20,0,8);volSlider.Position=UDim2.new(0,10,0,115);volSlider.BackgroundColor3=Color3.fromRGB(40,40,55);volSlider.BorderSizePixel=0
Instance.new("UICorner",volSlider).CornerRadius=UDim.new(1,0)
local volFill=Instance.new("Frame",volSlider);volFill.Size=UDim2.new(0.5,0,1,0);volFill.BackgroundColor3=Color3.fromRGB(120,80,255);volFill.BorderSizePixel=0
Instance.new("UICorner",volFill).CornerRadius=UDim.new(1,0)
local musicStatus=Instance.new("TextLabel",Pages["音乐"]);musicStatus.Size=UDim2.new(1,-20,0,20);musicStatus.Position=UDim2.new(0,10,0,140);musicStatus.BackgroundTransparency=1;musicStatus.Text="";musicStatus.TextColor3=Color3.fromRGB(150,220,150);musicStatus.TextSize=10;musicStatus.Font=Enum.Font.Code;musicStatus.TextXAlignment=Enum.TextXAlignment.Left

-- 关于页
local AboutT=Instance.new("TextLabel",Pages["关于"]);AboutT.Size=UDim2.new(1,-20,0,30);AboutT.Position=UDim2.new(0,10,0,20);AboutT.BackgroundTransparency=1;AboutT.Text="黑洞";AboutT.TextColor3=Color3.fromRGB(200,200,220);AboutT.TextSize=18;AboutT.Font=Enum.Font.GothamBold;AboutT.TextXAlignment=Enum.TextXAlignment.Left
local AboutD=Instance.new("TextLabel",Pages["关于"]);AboutD.Size=UDim2.new(1,-20,0,20);AboutD.Position=UDim2.new(0,10,0,55);AboutD.BackgroundTransparency=1;AboutD.Text="版本号: 812";AboutD.TextColor3=Color3.fromRGB(180,180,200);AboutD.TextSize=13;AboutD.Font=Enum.Font.Gotham;AboutD.TextXAlignment=Enum.TextXAlignment.Left
local AboutD2=Instance.new("TextLabel",Pages["关于"]);AboutD2.Size=UDim2.new(1,-20,0,20);AboutD2.Position=UDim2.new(0,10,0,80);AboutD2.BackgroundTransparency=1;AboutD2.Text="作者: 陈晓雨牛逼";AboutD2.TextColor3=Color3.fromRGB(180,180,200);AboutD2.TextSize=13;AboutD2.Font=Enum.Font.Gotham;AboutD2.TextXAlignment=Enum.TextXAlignment.Left
local ThemeB=Instance.new("TextButton",Pages["关于"]);ThemeB.Size=UDim2.new(0,150,0,32);ThemeB.Position=UDim2.new(0,10,0,120);ThemeB.BackgroundColor3=Color3.fromRGB(120,80,255);ThemeB.Text="🎨 切换主题:暗黑";ThemeB.TextColor3=Color3.fromRGB(255,255,255);ThemeB.TextSize=12;ThemeB.Font=Enum.Font.Gotham
Instance.new("UICorner",ThemeB).CornerRadius=UDim.new(0,6)

-- ================= 逻辑 =================
local fOn=false;local fSp=100;local fCn=nil;local fPos=Vector3.new(0,0,0)
local jOn=false;local jCn={}
local cOn=false;local cCn=nil;local del={}
local noclipOn=false;local noclipCn=nil
local antiAFKOn=false;local afkCn=nil
local cleanLog={}
local thunderConn=nil
local snowPart=nil
local musicSound=nil
local isDark=true
local function gH() local c=plr.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function gR() local c=plr.Character return c and c:FindFirstChild("HumanoidRootPart") end

FB.Activated:Connect(function()
    fOn=not fOn
    if fOn then
        local r=gR();if not r then return end
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
FSS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FS.Text="飞行速度: "..fSp end end)
FSS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FS.Text="飞行速度: "..fSp end end)
WSS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-WSS.AbsolutePosition.X)/WSS.AbsoluteSize.X,0,1) WSF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WS.Text="跑步速度: "..t;local h=gH() if h then pcall(function() h.WalkSpeed=t end) end end end)
WSS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-WSS.AbsolutePosition.X)/WSS.AbsoluteSize.X,0,1) WSF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WS.Text="跑步速度: "..t;local h=gH() if h then pcall(function() h.WalkSpeed=t end) end end end)
JPS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-JPS.AbsolutePosition.X)/JPS.AbsoluteSize.X,0,1) JPF.Size=UDim2.new(p,0,1,0);local t=math.floor(50+p*300);JumpPowerL.Text="跳跃力: "..t;local h=gH() if h then pcall(function() h.JumpPower=t end) end end end)
JPS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-JPS.AbsolutePosition.X)/JPS.AbsoluteSize.X,0,1) JPF.Size=UDim2.new(p,0,1,0);local t=math.floor(50+p*300);JumpPowerL.Text="跳跃力: "..t;local h=gH() if h then pcall(function() h.JumpPower=t end) end end end)
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

local function isPP(p) for _,x in ipairs(P:GetPlayers()) do if x.Character and p:IsDescendantOf(x.Character) then return true end end return false end
ClkB.Activated:Connect(function()
    cOn=not cOn
    if cOn then
        ClkB.Text="🎯 点击删除:开";ClkB.BackgroundColor3=Color3.fromRGB(120,40,20)
        cCn=U.InputBegan:Connect(function(i,gp)
            if gp or not cOn then return end
            if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
            local cam=workspace.CurrentCamera
            local ray=cam:ScreenPointToRay(i.Position.X,i.Position.Y)
            local pr=RaycastParams.new();pr.FilterType=Enum.RaycastFilterType.Exclude;pr.FilterDescendantsInstances={plr.Character}
            local res=workspace:Raycast(ray.Origin,ray.Direction*500,pr)
            if res and res.Instance and not isPP(res.Instance) then table.insert(del,{o=res.Instance,p=res.Instance.Parent});res.Instance.Parent=nil end
        end)
    else
        ClkB.Text="🎯 点击删除:关";ClkB.BackgroundColor3=Color3.fromRGB(180,60,30)
        if cCn then cCn:Disconnect();cCn=nil end
    end
end)
RsB.Activated:Connect(function() for _,d in ipairs(del) do pcall(function() if d.o and d.p then d.o.Parent=d.p end end) end;del={} end)
AntiAFK.Activated:Connect(function()
    antiAFKOn=not antiAFKOn
    if antiAFKOn then
        AntiAFK.Text="💤 防挂机:开";AntiAFK.BackgroundColor3=Color3.fromRGB(80,50,140)
        afkCn=plr.Idled:Connect(function() pcall(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end) end)
    else
        AntiAFK.Text="💤 防挂机:关";AntiAFK.BackgroundColor3=Color3.fromRGB(45,45,60)
        if afkCn then afkCn:Disconnect();afkCn=nil end
    end
end)
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

-- 人物大小（修复版）
local function applyScale(s)
    local c=plr.Character if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid") if not h then return end
    pcall(function()
        local bh=h:FindFirstChild("BodyHeightScale")
        local bw=h:FindFirstChild("BodyWidthScale")
        local bd=h:FindFirstChild("BodyDepthScale")
        local hs=h:FindFirstChild("HeadScale")
        if bh then bh.Value=s end
        if bw then bw.Value=s end
        if bd then bd.Value=s end
        if hs then hs.Value=s end
    end)
end
SSF.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-SSF.AbsolutePosition.X)/SSF.AbsoluteSize.X,0,1) SSFF.Size=UDim2.new(p,0,1,0);local s=0.5+p*4.5;ScaleSlider.Text="人物大小: "..string.format("%.1f",s).."x";applyScale(s) end end)
SSF.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-SSF.AbsolutePosition.X)/SSF.AbsoluteSize.X,0,1) SSFF.Size=UDim2.new(p,0,1,0);local s=0.5+p*4.5;ScaleSlider.Text="人物大小: "..string.format("%.1f",s).."x";applyScale(s) end end)

-- 天气系统（升级版：6种天气循环）
local weatherIdx=1
local createdAtm=nil
local oldAmbient,oldOutdoor,oldBright,oldClock
pcall(function() oldAmbient=L.Ambient;oldOutdoor=L.OutdoorAmbient;oldBright=L.Brightness;oldClock=L.ClockTime end)
local function clearWeather()
    if createdAtm then createdAtm:Destroy();createdAtm=nil end
    for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=true end end
    if oldAmbient then L.Ambient=oldAmbient end
    if oldOutdoor then L.OutdoorAmbient=oldOutdoor end
    if oldBright then L.Brightness=oldBright end
    if oldClock then L.ClockTime=oldClock end
    if thunderConn then thunderConn:Disconnect();thunderConn=nil end
    if snowPart then snowPart:Destroy();snowPart=nil end
end
WeatherB.Activated:Connect(function()
    weatherIdx=weatherIdx%6+1
    pcall(function()
        clearWeather()
        if weatherIdx==1 then WeatherB.Text="☀️ 晴天"
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
            WeatherB.Text="⛈️ 打雷"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.4;atm.Color=Color3.fromRGB(50,55,70);createdAtm=atm
            L.Ambient=Color3.fromRGB(40,45,60);L.OutdoorAmbient=Color3.fromRGB(40,45,60);L.Brightness=0.8
            thunderConn=task.spawn(function()
                while thunderConn do
                    task.wait(math.random(2,5))
                    pcall(function() L.Brightness=8 end)
                    task.wait(0.1)
                    pcall(function() L.Brightness=0.8 end)
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
ThunderB.Activated:Connect(function()
    pcall(function()
        if thunderConn then thunderConn:Disconnect();thunderConn=nil;L.Brightness=1;ThunderB.Text="⛈️ 打雷"
        else
            ThunderB.Text="⛈️ 打雷中"
            for _,v in ipairs(L:GetChildren()) do if v:IsA("Atmosphere") then v.Enabled=false end end
            local atm=Instance.new("Atmosphere",L);atm.Density=0.4;atm.Color=Color3.fromRGB(50,55,70);createdAtm=atm
            L.Ambient=Color3.fromRGB(40,45,60);L.OutdoorAmbient=Color3.fromRGB(40,45,60)
            thunderConn=task.spawn(function()
                while thunderConn do
                    task.wait(math.random(2,5))
                    pcall(function() L.Brightness=8 end)
                    task.wait(0.1)
                    pcall(function() L.Brightness=0.8 end)
                end
            end)
        end
    end)
end)
SnowB.Activated:Connect(function()
    pcall(function()
        if snowPart then snowPart:Destroy();snowPart=nil;SnowB.Text="❄️ 下雪"
        else
            SnowB.Text="❄️ 下雪中"
            local char=plr.Character
            local hrp=char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            snowPart=Instance.new("Part");snowPart.Size=Vector3.new(150,1,150);snowPart.Position=hrp.Position+Vector3.new(0,50,0);snowPart.Anchored=true;snowPart.CanCollide=false;snowPart.Transparency=1;snowPart.Parent=workspace
            local emitter=Instance.new("ParticleEmitter",snowPart)
            emitter.Texture="rbxassetid://241876428";emitter.Rate=200;emitter.Lifetime=NumberRange.new(3,5);emitter.Speed=NumberRange.new(5,10);emitter.SpreadAngle=Vector2.new(45,45)
            emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.3),NumberSequenceKeypoint.new(1,0.1)})
            emitter.Transparency=NumberSequence.new(0.2);emitter.Color=ColorSequence.new(Color3.fromRGB(255,255,255));emitter.LightEmission=0.5
            task.spawn(function()
                while snowPart and snowPart.Parent do
                    task.wait(0.5)
                    local c=plr.Character;local h=c and c:FindFirstChild("HumanoidRootPart")
                    if h then snowPart.Position=h.Position+Vector3.new(0,50,0) end
                end
            end)
        end
    end)
end)

-- 音乐播放器
playB.Activated:Connect(function()
    pcall(function()
        local id=musicIdBox.Text
        if not id or id=="" then musicStatus.Text="❌ 请输入音频 ID" return end
        if musicSound then musicSound:Destroy();musicSound=nil end
        musicSound=Instance.new("Sound",game:GetService("SoundService"))
        musicSound.SoundId="rbxassetid://"..id
        musicSound.Volume=0.5
        musicSound.Looped=true
        musicSound:Play()
        musicStatus.Text="🎵 正在播放 ID: "..id
    end)
end)
stopB.Activated:Connect(function()
    pcall(function()
        if musicSound then musicSound:Stop();musicSound:Destroy();musicSound=nil end
        musicStatus.Text="⏹️ 已停止"
    end)
end)
volSlider.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-volSlider.AbsolutePosition.X)/volSlider.AbsoluteSize.X,0,1) volFill.Size=UDim2.new(p,0,1,0);volLabel.Text="音量: "..math.floor(p*100).."%";if musicSound then musicSound.Volume=p end end end)
volSlider.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-volSlider.AbsolutePosition.X)/volSlider.AbsoluteSize.X,0,1) volFill.Size=UDim2.new(p,0,1,0);volLabel.Text="音量: "..math.floor(p*100).."%";if musicSound then musicSound.Volume=p end end end)

-- 主题切换
ThemeB.Activated:Connect(function()
    isDark=not isDark
    pcall(function()
        if isDark then
            MF.BackgroundColor3=Color3.fromRGB(18,18,22)
            TB.BackgroundColor3=Color3.fromRGB(24,24,30)
            SB.BackgroundColor3=Color3.fromRGB(22,22,28)
            CB.BackgroundColor3=Color3.fromRGB(22,22,28)
            for _,v in ipairs(TabButtons) do
                if v.page.Visible then v.btn.BackgroundColor3=Color3.fromRGB(45,45,60);v.btn.TextColor3=Color3.fromRGB(120,200,255)
                else v.btn.BackgroundColor3=Color3.fromRGB(30,30,38);v.btn.TextColor3=Color3.fromRGB(180,180,200) end
            end
            TT.TextColor3=Color3.fromRGB(200,200,220)
            ThemeB.Text="🎨 切换主题:暗黑"
            ThemeB.BackgroundColor3=Color3.fromRGB(120,80,255)
        else
            MF.BackgroundColor3=Color3.fromRGB(245,245,250)
            TB.BackgroundColor3=Color3.fromRGB(235,235,245)
            SB.BackgroundColor3=Color3.fromRGB(240,240,248)
            CB.BackgroundColor3=Color3.fromRGB(240,240,248)
            for _,v in ipairs(TabButtons) do
                if v.page.Visible then v.btn.BackgroundColor3=Color3.fromRGB(180,200,240);v.btn.TextColor3=Color3.fromRGB(30,60,120)
                else v.btn.BackgroundColor3=Color3.fromRGB(225,225,235);v.btn.TextColor3=Color3.fromRGB(80,80,100) end
            end
            TT.TextColor3=Color3.fromRGB(30,30,60)
            ThemeB.Text="🎨 切换主题:明亮"
            ThemeB.BackgroundColor3=Color3.fromRGB(100,150,220)
        end
    end)
end)

-- 优化清理
OptB.Activated:Connect(function()
    local done={}
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01;table.insert(done,"画质降最低") end)
    pcall(function() L.GlobalShadows=false for _,v in ipairs(L:GetChildren()) do if v:IsA("PostEffect") or v:IsA("Atmosphere") then v.Enabled=false end end table.insert(done,"关阴影/天气") end)
    pcall(function() local c=0 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then v.Enabled=false;c=c+1 end end table.insert(done,"关"..c.."个特效") end)
    pcall(function() local ch=plr.Character;local org=Vector3.new(0,0,0) if ch then local hrp=ch:FindFirstChild("HumanoidRootPart") if hrp then org=hrp.Position end end local rm=0 for _,v in ipairs(workspace:GetDescendants()) do if v:IsA("BasePart") then local isSelf=false if ch and v:IsDescendantOf(ch) then isSelf=true end for _,p in ipairs(P:GetPlayers()) do if p.Character and v:IsDescendantOf(p.Character) then isSelf=true;break end end if not isSelf then local d=(v.Position-org).Magnitude if d>500 then table.insert(cleanLog,{o=v,p=v.Parent});v.Parent=nil;rm=rm+1 end end end end table.insert(done,"清理"..rm.."个远对象") end)
    OptL.Text=table.concat(done," · ")
    pcall(function() G:SetCore("SendNotification",{Title="⚡ 优化完成",Text="已优化+清理",Duration=3}) end)
end)

-- 角色重生时清理状态
plr.CharacterAdded:Connect(function()
    fOn=false;if fCn then fCn:Disconnect();fCn=nil end
    jOn=false;for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    noclipOn=false;if noclipCn then noclipCn:Disconnect();noclipCn=nil end
    if FB then FB.Text="飞行:关";FB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if JB then JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(45,45,60) end
    if NoclipB then NoclipB.Text="🚪 穿墙:关";NoclipB.BackgroundColor3=Color3.fromRGB(45,45,60) end
end)

SG.Destroying:Connect(function()
    if fCn then fCn:Disconnect() end
    for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end
    if cCn then cCn:Disconnect() end
    if noclipCn then noclipCn:Disconnect() end
    if afkCn then afkCn:Disconnect() end
    if thunderConn then thunderConn:Disconnect() end
    if snowPart then snowPart:Destroy() end
    if musicSound then musicSound:Destroy() end
end)
