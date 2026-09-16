local P=game:GetService("Players")
local R=game:GetService("RunService")
local U=game:GetService("UserInputService")
local plr=P.LocalPlayer
local function mt(g)
    if type(gethui)=="function" then local ok=pcall(function() g.Parent=gethui() end) if ok and g.Parent then return end end
    local ok2=pcall(function() g.Parent=game:GetService("CoreGui") end) if ok2 and g.Parent then return end
    pcall(function() g.Parent=plr:WaitForChild("PlayerGui") end)
end

-- 加载动画（30秒）
local LG=Instance.new("ScreenGui");LG.Name="加载";LG.ResetOnSpawn=false;LG.IgnoreGuiInset=true;LG.DisplayOrder=9999;mt(LG)
local M=Instance.new("Frame",LG);M.Size=UDim2.new(1,0,1,0);M.BackgroundColor3=Color3.fromRGB(0,0,0);M.BorderSizePixel=0
local Ti=Instance.new("TextLabel",LG);Ti.Size=UDim2.new(1,0,0,70);Ti.Position=UDim2.new(0,0,0.3,0);Ti.BackgroundTransparency=1;Ti.Text="程 程 大 王";Ti.TextColor3=Color3.fromRGB(80,220,80);Ti.TextSize=56;Ti.Font=Enum.Font.Code
local Su=Instance.new("TextLabel",LG);Su.Size=UDim2.new(1,0,0,26);Su.Position=UDim2.new(0,0,0.3,72);Su.BackgroundTransparency=1;Su.Text="SYSTEM DECRYPTION";Su.TextColor3=Color3.fromRGB(80,220,80);Su.TextSize=18;Su.Font=Enum.Font.Code
local BB=Instance.new("Frame",LG);BB.Size=UDim2.new(0,500,0,14);BB.Position=UDim2.new(0.5,-250,0.55,0);BB.BackgroundColor3=Color3.fromRGB(10,10,10);BB.BorderSizePixel=0
Instance.new("UICorner",BB).CornerRadius=UDim.new(1,0)
local BF=Instance.new("Frame",BB);BF.Size=UDim2.new(0,0,1,0);BF.BackgroundColor3=Color3.fromRGB(120,80,220);BF.BorderSizePixel=0
Instance.new("UICorner",BF).CornerRadius=UDim.new(1,0)
local PL2=Instance.new("TextLabel",LG);PL2.Size=UDim2.new(1,0,0,40);PL2.Position=UDim2.new(0,0,0.55,25);PL2.BackgroundTransparency=1;PL2.Text="0%";PL2.TextColor3=Color3.fromRGB(80,220,80);PL2.TextSize=28;PL2.Font=Enum.Font.Code
local SkipBtn=Instance.new("TextButton",LG);SkipBtn.Size=UDim2.new(0,70,0,24);SkipBtn.Position=UDim2.new(1,-80,1,-40);SkipBtn.BackgroundColor3=Color3.fromRGB(20,20,20);SkipBtn.Text="[ 跳过 ]";SkipBtn.TextColor3=Color3.fromRGB(80,220,80);SkipBtn.TextSize=12;SkipBtn.Font=Enum.Font.Code
Instance.new("UICorner",SkipBtn).CornerRadius=UDim.new(0,4)
local sk=false;SkipBtn.Activated:Connect(function() sk=true end)
local tl={{0,0},{6,20},{13.5,45},{18,60},{23.4,78},{27,90},{30,100}}
local st=tick()
task.spawn(function()
    while LG.Parent do
        local e=tick()-st;if sk or e>=30 then break end
        local cp=0
        for i=1,#tl-1 do local t1,p1=tl[i][1],tl[i][2];local t2,p2=tl[i+1][1],tl[i+1][2] if e>=t1 and e<t2 then cp=p1+(p2-p1)*((e-t1)/(t2-t1));break end end
        cp=math.min(cp,100);BF.Size=UDim2.new(cp/100,0,1,0);PL2.Text=string.format("%d%%",cp);task.wait(0.05)
    end
    task.wait(0.3);LG:Destroy()
end)
while LG.Parent do task.wait(0.1) end

-- 主面板
local SG=Instance.new("ScreenGui");SG.Name="程程大王";SG.ResetOnSpawn=false;SG.DisplayOrder=100;mt(SG)
local FBt=Instance.new("TextButton",SG);FBt.Size=UDim2.new(0,40,0,40);FBt.Position=UDim2.new(0,10,0.5,-20);FBt.BackgroundColor3=Color3.fromRGB(20,20,28);FBt.Text="⚙";FBt.TextColor3=Color3.fromRGB(120,200,255);FBt.TextSize=20;FBt.Font=Enum.Font.GothamBold
Instance.new("UICorner",FBt).CornerRadius=UDim.new(1,0)
local MF=Instance.new("Frame",SG);MF.Size=UDim2.new(0,220,0,280);MF.Position=UDim2.new(0.5,-110,0.5,-140);MF.BackgroundColor3=Color3.fromRGB(15,15,20);MF.BorderSizePixel=0;MF.Active=true;MF.Draggable=true;MF.ZIndex=10
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,10)
local MSt=Instance.new("UIStroke",MF);MSt.Color=Color3.fromRGB(100,200,255);MSt.Thickness=1.5;MSt.Transparency=0.4
local XB=Instance.new("TextButton",MF);XB.Size=UDim2.new(0,20,0,20);XB.Position=UDim2.new(1,-25,0,5);XB.BackgroundColor3=Color3.fromRGB(200,50,60);XB.Text="×";XB.TextColor3=Color3.fromRGB(255,255,255);XB.TextSize=12;XB.Font=Enum.Font.GothamBold
Instance.new("UICorner",XB).CornerRadius=UDim.new(1,0)
local FB=Instance.new("TextButton",MF);FB.Size=UDim2.new(0.9,0,0,30);FB.Position=UDim2.new(0.05,0,0,30);FB.BackgroundColor3=Color3.fromRGB(35,35,48);FB.Text="飞行:关";FB.TextColor3=Color3.fromRGB(220,220,220);FB.TextSize=12;FB.Font=Enum.Font.Gotham
Instance.new("UICorner",FB).CornerRadius=UDim.new(0,6)
local FSL=Instance.new("TextLabel",MF);FSL.Size=UDim2.new(0.9,0,0,15);FSL.Position=UDim2.new(0.05,0,0,65);FSL.BackgroundTransparency=1;FSL.Text="飞行速度: 100";FSL.TextColor3=Color3.fromRGB(200,200,200);FSL.TextSize=10;FSL.Font=Enum.Font.Gotham
local FSS=Instance.new("Frame",MF);FSS.Size=UDim2.new(0.9,0,0,6);FSS.Position=UDim2.new(0.05,0,0,85);FSS.BackgroundColor3=Color3.fromRGB(40,40,55);FSS.BorderSizePixel=0
Instance.new("UICorner",FSS).CornerRadius=UDim.new(1,0)
local FSF=Instance.new("Frame",FSS);FSF.Size=UDim2.new(0.05,0,1,0);FSF.BackgroundColor3=Color3.fromRGB(120,80,255);FSF.BorderSizePixel=0
Instance.new("UICorner",FSF).CornerRadius=UDim.new(1,0)
local WL=Instance.new("TextLabel",MF);WL.Size=UDim2.new(0.9,0,0,15);WL.Position=UDim2.new(0.05,0,0,95);WL.BackgroundTransparency=1;WL.Text="跑步速度: 16";WL.TextColor3=Color3.fromRGB(200,200,200);WL.TextSize=10;WL.Font=Enum.Font.Gotham
local WS=Instance.new("Frame",MF);WS.Size=UDim2.new(0.9,0,0,6);WS.Position=UDim2.new(0.05,0,0,115);WS.BackgroundColor3=Color3.fromRGB(40,40,55);WS.BorderSizePixel=0
Instance.new("UICorner",WS).CornerRadius=UDim.new(1,0)
local WF=Instance.new("Frame",WS);WF.Size=UDim2.new(0.05,0,1,0);WF.BackgroundColor3=Color3.fromRGB(120,80,255);WF.BorderSizePixel=0
Instance.new("UICorner",WF).CornerRadius=UDim.new(1,0)
local JB=Instance.new("TextButton",MF);JB.Size=UDim2.new(0.9,0,0,30);JB.Position=UDim2.new(0.05,0,0,130);JB.BackgroundColor3=Color3.fromRGB(35,35,48);JB.Text="无限跳:关";JB.TextColor3=Color3.fromRGB(220,220,220);JB.TextSize=12;JB.Font=Enum.Font.Gotham
Instance.new("UICorner",JB).CornerRadius=UDim.new(0,6)

local fOn=false;local fSp=100;local fCn=nil;local fPos=Vector3.new(0,0,0)
local jOn=false;local jCn={}
local function gH() local c=plr.Character;return c and c:FindFirstChildOfClass("Humanoid") end
local function gR() local c=plr.Character;return c and c:FindFirstChild("HumanoidRootPart") end

FBt.Activated:Connect(function() MF.Visible=not MF.Visible if MF.Visible then FBt.Text="⚙" else FBt.Text="▶" end end)
XB.Activated:Connect(function() SG:Destroy() end)

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

FSS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
    local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1)
    FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp
end end)
FSS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
    local p=math.clamp((i.Position.X-FSS.AbsolutePosition.X)/FSS.AbsoluteSize.X,0,1)
    FSF.Size=UDim2.new(p,0,1,0);fSp=math.floor(50+p*450);FSL.Text="飞行速度: "..fSp
end end)

local function updW(x)
    local p=math.clamp((x-WS.AbsolutePosition.X)/WS.AbsoluteSize.X,0,1)
    WF.Size=UDim2.new(p,0,1,0);local t=math.floor(16+p*184);WL.Text="跑步速度: "..t
    local h=gH()
    if h then
        task.spawn(function()
            local cur=h.WalkSpeed
            while math.abs(cur-t)>1 do cur=cur+(t>cur and 3 or -3);pcall(function() h.WalkSpeed=cur end);task.wait(0.08) end
            pcall(function() h.WalkSpeed=t end)
        end)
    end
end
WS.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then updW(i.Position.X) end end)
WS.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then updW(i.Position.X) end end)

JB.Activated:Connect(function()
    if jOn then
        jOn=false;for _,c in ipairs(jCn) do pcall(function() c:Disconnect() end) end;jCn={}
        JB.Text="无限跳:关";JB.BackgroundColor3=Color3.fromRGB(35,35,48)
    else
        jOn=true;JB.Text="无限跳:开";JB.BackgroundColor3=Color3.fromRGB(80,50,140)
        table.insert(jCn,U.InputBegan:Connect(function(i,gp) if gp or not jOn then return end if i.KeyCode==Enum.KeyCode.Space and i.UserInputType==Enum.UserInputType.Keyboard then local h=gH() if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end end))
        table.insert(jCn,U.JumpRequest:Connect(function() if jOn then local h=gH() if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end end end))
    end
end)
