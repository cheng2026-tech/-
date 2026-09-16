local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local plr=P.LocalPlayer

-- 1. 极简三角洲加载动画（10秒，可跳过）
local LG=Instance.new("ScreenGui");LG.Name="加载";LG.ResetOnSpawn=false;LG.IgnoreGuiInset=true;LG.DisplayOrder=9999
pcall(function() LG.Parent=gethui and gethui() or game:GetService("CoreGui") end)
if not LG.Parent then pcall(function() LG.Parent=plr:WaitForChild("PlayerGui") end) end
local M=Instance.new("Frame",LG);M.Size=UDim2.new(1,0,1,0);M.BackgroundColor3=Color3.fromRGB(0,0,0);M.BorderSizePixel=0
local Ti=Instance.new("TextLabel",LG);Ti.Size=UDim2.new(1,0,0,70);Ti.Position=UDim2.new(0,0,0.3,0);Ti.BackgroundTransparency=1;Ti.Text="程 程 大 王";Ti.TextColor3=Color3.fromRGB(80,220,80);Ti.TextSize=50;Ti.Font=Enum.Font.Code
local Su=Instance.new("TextLabel",LG);Su.Size=UDim2.new(1,0,0,26);Su.Position=UDim2.new(0,0,0.3,72);Su.BackgroundTransparency=1;Su.Text="SYSTEM DECRYPTION";Su.TextColor3=Color3.fromRGB(80,220,80);Su.TextSize=16;Su.Font=Enum.Font.Code
local BB=Instance.new("Frame",LG);BB.Size=UDim2.new(0,400,0,12);BB.Position=UDim2.new(0.5,-200,0.55,0);BB.BackgroundColor3=Color3.fromRGB(10,10,10);BB.BorderSizePixel=0
Instance.new("UICorner",BB).CornerRadius=UDim.new(1,0)
local BF=Instance.new("Frame",BB);BF.Size=UDim2.new(0,0,1,0);BF.BackgroundColor3=Color3.fromRGB(120,80,220);BF.BorderSizePixel=0
Instance.new("UICorner",BF).CornerRadius=UDim.new(1,0)
local PL2=Instance.new("TextLabel",LG);PL2.Size=UDim2.new(1,0,0,40);PL2.Position=UDim2.new(0,0,0.55,25);PL2.BackgroundTransparency=1;PL2.Text="0%";PL2.TextColor3=Color3.fromRGB(80,220,80);PL2.TextSize=28;PL2.Font=Enum.Font.Code
local SkipBtn=Instance.new("TextButton",LG);SkipBtn.Size=UDim2.new(0,70,0,24);SkipBtn.Position=UDim2.new(1,-80,1,-40);SkipBtn.BackgroundColor3=Color3.fromRGB(20,20,20);SkipBtn.Text="[ 跳过 ]";SkipBtn.TextColor3=Color3.fromRGB(80,220,80);SkipBtn.TextSize=12;SkipBtn.Font=Enum.Font.Code
Instance.new("UICorner",SkipBtn).CornerRadius=UDim.new(0,4)
local sk=false;SkipBtn.Activated:Connect(function() sk=true end)
task.spawn(function()
    for i=1,10 do
        task.wait(1)
        if sk or not LG.Parent then break end
        BF.Size=UDim2.new(i/10,0,1,0);PL2.Text=tostring(i*10).."%"
    end
    if LG.Parent then LG:Destroy() end
end)

-- 2. 主面板（纯原生手搓，无需网络）
local SG=Instance.new("ScreenGui");SG.Name="程程大王脚本";SG.ResetOnSpawn=false
pcall(function() SG.Parent=gethui and gethui() or game:GetService("CoreGui") end)
if not SG.Parent then pcall(function() SG.Parent=plr:WaitForChild("PlayerGui") end) end

local MF=Instance.new("Frame",SG)
MF.Size=UDim2.new(0,260,0,220);MF.Position=UDim2.new(0.5,-130,0.5,-110)
MF.BackgroundColor3=Color3.fromRGB(18,18,25);MF.BorderSizePixel=0;MF.Active=true;MF.Draggable=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
Instance.new("UIStroke",MF).Color=Color3.fromRGB(100,200,255)

-- 悬浮球
local FBt=Instance.new("TextButton",SG);FBt.Size=UDim2.new(0,40,0,40);FBt.Position=UDim2.new(0,10,0.5,-20);FBt.BackgroundColor3=Color3.fromRGB(20,20,28);FBt.Text="⚙";FBt.TextColor3=Color3.fromRGB(120,200,255);FBt.TextSize=20;FBt.Font=Enum.Font.GothamBold
Instance.new("UICorner",FBt).CornerRadius=UDim.new(1,0)
FBt.Activated:Connect(function() MF.Visible=not MF.Visible if MF.Visible then FBt.Text="⚙" else FBt.Text="▶" end end)

-- 关闭按钮
local XB=Instance.new("TextButton",MF);XB.Size=UDim2.new(0,20,0,20);XB.Position=UDim2.new(1,-25,0,8);XB.BackgroundColor3=Color3.fromRGB(200,50,60);XB.Text="×";XB.TextColor3=Color3.fromRGB(255,255,255);XB.TextSize=12;XB.Font=Enum.Font.GothamBold
Instance.new("UICorner",XB).CornerRadius=UDim.new(1,0)
XB.Activated:Connect(function() SG:Destroy() end)

-- 飞行开关
local FB=Instance.new("TextButton",MF);FB.Size=UDim2.new(0.9,0,0,28);FB.Position=UDim2.new(0.05,0,0,40);FB.BackgroundColor3=Color3.fromRGB(35,35,48);FB.Text="飞行:关";FB.TextColor3=Color3.fromRGB(220,220,220);FB.TextSize=12;FB.Font=Enum.Font.Gotham
Instance.new("UICorner",FB).CornerRadius=UDim.new(0,6)

-- 飞行速度滑块
local FSL=Instance.new("TextLabel",MF);FSL.Size=UDim2.new(0.9,0,0,15);FSL.Position=UDim2.new(0.05,0,0,75);FSL.BackgroundTransparency=1;FSL.Text="飞行速度: 100";FSL.TextColor3=Color3.fromRGB(200,200,200);FSL.TextSize=10;FSL.Font=Enum.Font.Gotham
local FSS=Instance.new("Frame",MF);FSS.Size=UDim2.new(0.9,0,0,6);FSS.Position=UDim2.new(0.05,0,0,95);FSS.BackgroundColor3=Color3.fromRGB(40,40,55);FSS.BorderSizePixel=0
Instance.new("UICorner",FSS).CornerRadius=UDim.new(1,0)
local FSF=Instance.new("Frame",FSS);FSF.Size=UDim2.new(0.05,0,1,0);FSF.BackgroundColor3=Color3.fromRGB(120,80,255);FSF.BorderSizePixel=0
Instance.new("UICorner",FSF).CornerRadius=UDim.new(1,0)

-- 跑步速度滑块
local WL=Instance.new("TextLabel",MF);WL.Size=UDim2.new(0.9,0,0,15);WL.Position=UDim2.new(0.05,0,0,115);WL.BackgroundTransparency=1;WL.Text="跑步速度: 16";WL.TextColor3=Color3.fromRGB(200,200,200);WL.TextSize=10;WL.Font=Enum.Font.Gotham
local WS=Instance.new("Frame",MF);WS.Size=UDim2.new(0.9,0,0,6);WS.Position=UDim2.new(0.05,0,0,135);WS.BackgroundColor3=Color3.fromRGB(40,40,55);WS.BorderSizePixel=0
Instance.new("UICorner",WS).CornerRadius=UDim.new(1,0)
local WF=Instance.new("Frame",WS);WF.Size=UDim2.new(0.05,0,1,0);WF.BackgroundColor3=Color3.fromRGB(120,80,255);WF.BorderSizePixel=0
Instance.new("UICorner",WF).CornerRadius=UDim.new(1,0)

-- 无限跳开关
local JB=Instance.new("TextButton",MF);JB.Size=UDim2.new(0.9,0,0,28);JB.Position=UDim2.new(0.05,0,0,155);JB.BackgroundColor3=Color3.fromRGB(35,35,48);JB.Text="无限跳:关";JB.TextColor3=Color3.fromRGB(220,220,220);JB.TextSize=12;JB.Font=Enum.Font.Gotham
Instance.new("UICorner",JB).CornerRadius=UDim.new(0,6)

-- 3. 功能逻辑
local fOn=false;local fSp=100;local fCn=nil;local fPos=Vector3.new(0,0,0)
local jOn=false;local jCn={}
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
        FB.Text="飞行:关";FB.BackgroundColor3=Color3.fromRGB(35,35,48)
    end
end)

FSS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp end end)
FSS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1) FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp end end)

WS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-WS.AbsolutePosition.X)/WS.AbsoluteSize.X,0,1) WF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WL.Text="跑步速度: "..t;local h=gH() if h then pcall(function() h.WalkSpeed=t end) end end end)
WS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then local p=math.clamp((i.Position.X-WS.AbsolutePosition.X)/WS.AbsoluteSize.X,0,1) WF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WL.Text="跑步速度: "..t;local h=gH() if h then pcall(function() h.WalkSpeed=t end) end end end)

JB.Activated:Connect(function()
    jOn=not jOn
    if jOn then
        JB.Text="无限跳:开";JB.BackgroundColor3=Color3.fromRGB(80,50,140)
        for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
        local function doJ() local h=gH() if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end
        table.insert(jCn,U.InputBegan:Connect(function(i,gp) if gp then return end if not jOn then return end if i.KeyCode==Enum.KeyCode.Space and i.UserInputType==Enum.UserInputType.Keyboard then doJ() end end))
        table.insert(jCn,U.JumpRequest:Connect(function() if jOn then doJ() end end))
    else
        JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(35,35,48)
        for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
    end
end)
