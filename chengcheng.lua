--[[
    程程大王脚本中心 V_1.2.2 (修复优化完整版)
    仓库使用说明:
    1. 保存此文件为 main.lua 上传到你的 GitHub 仓库
    2. 在 Roblox 执行器里运行:
       loadstring(game:HttpGet("https://raw.githubusercontent.com/你的用户名/你的仓库名/main/main.lua"))()
    
    修复内容:
    - 删除末尾致命语法错误
    - 修复 game.RunService -> game:GetService("RunService")
    - 修复 Accessoy 拼写错误
    - 修复 main.Frame 引用错误
    - 修复 getParent 未定义
    - 所有 Character/Humanoid 访问加判空
    - 所有 Textbox 加 tonumber 校验
    - 替换过时 API (:connect -> :Connect, wait -> task.wait)
    - 移除全局变量污染
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local StarterGui  = game:GetService("StarterGui")
local CoreGui     = game:GetService("CoreGui")
local Lighting    = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LP          = Players.LocalPlayer

-- ============ 工具函数 ============
local U = {}
function U.getChar() local c = LP.Character if c and c:FindFirstChildOfClass("Humanoid") then return c end end
function U.getHum()  local c = U.getChar() if c then return c:FindFirstChildOfClass("Humanoid") end end
function U.getHRP()  local c = U.getChar() if c then return c:FindFirstChild("HumanoidRootPart") end end
function U.toNum(v, d) local n = tonumber(v) if n == nil then return d end return n end
function U.load(url, silent)
    local ok, err = pcall(function() loadstring(game:HttpGet(url, true))() end)
    if not ok and not silent then warn("[程程大王] 加载失败: " .. url .. "\n" .. tostring(err)) end
    return ok
end
function U.notify(t, x, d)
    pcall(function() StarterGui:SetCore("SendNotification", {Title=t, Text=x, Duration=d or 4}) end)
end

U.notify("成功注入！", "正在加载脚本...", 4)

-- ============ OrionLib ============
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/FUEx0f3G"))()

-- ============ FPS/时间标签 ============
local LBLG = Instance.new("ScreenGui")
LBLG.Name = "CC_LBLG"
LBLG.Parent = CoreGui
LBLG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LBLG.ResetOnSpawn = false

local LBL = Instance.new("TextLabel")
LBL.Parent = LBLG
LBL.BackgroundTransparency = 1
LBL.Position = UDim2.new(0.75, 0, 0.010, 0)
LBL.Size = UDim2.new(0, 133, 0, 30)
LBL.Font = Enum.Font.GothamSemibold
LBL.TextColor3 = Color3.new(1,1,1)
LBL.TextScaled = true
LBL.TextSize = 14
LBL.TextWrapped = true

RunService.Heartbeat:Connect(function()
    LBL.Text = ("北京时间:%s时%s分%s秒"):format(os.date("%H"), os.date("%M"), os.date("%S"))
end)

U.notify("程程大王脚本中心", "加载成功, 请享受!", 4)

-- ============ 主窗口 ============
local Window = OrionLib:MakeWindow({
    Name = "程程大王脚本中心 V_1.2.2",
    HidePremium = false,
    SaveConfig = true,
    IntroText = "程程大王制作",
    ConfigFolder = "程程大王制作"
})

U.notify("Yungengxin制作", "Yungengxin制作", 4)

-- ========================================================
-- Tab: Yungengxin出品
-- ========================================================
local tAbout = Window:MakeTab({Name="Yungengxin出品", Icon="rbxassetid://3106633104", PremiumOnly=false})
tAbout:AddParagraph("脚本为付费功能")
tAbout:AddParagraph("程程大王永远的神")

-- ========================================================
-- Tab: 公告
-- ========================================================
local tGG = Window:MakeTab({Name="公告", Icon="rbxassetid://3106633104", PremiumOnly=false})
tGG:AddButton({Name="复制作者QQ", Callback=function() setclipboard("3106633104") end})
tGG:AddButton({Name="复制程程大王脚本交流群QQ", Callback=function() setclipboard("819503470") end})

OrionLib:MakeNotification({
    Name="程程大王脚本中心",
    Content="欢迎使用程程大王脚本中心",
    Image="rbxassetid://4483345998",
    Time=2
})

-- ========================================================
-- Tab: 通用---修改玩家数据
-- ========================================================
local tGen = Window:MakeTab({Name="通用---修改玩家数据", Icon="rbxassetid://4483345998", PremiumOnly=false})
tGen:AddSection({Name="Yungengxin制作"})

tGen:AddSlider({
    Name="速度", Min=16, Max=200, Default=16,
    Color=Color3.fromRGB(255,255,255), Increment=1, ValueName="数值",
    Callback=function(v) local h=U.getHum() if h then h.WalkSpeed=U.toNum(v,16) end end
})
tGen:AddSlider({
    Name="跳跃高度", Min=50, Max=200, Default=50,
    Color=Color3.fromRGB(255,255,255), Increment=1, ValueName="数值",
    Callback=function(v) local h=U.getHum() if h then h.JumpPower=U.toNum(v,50) end end
})
tGen:AddTextbox({Name="跳跃高度设置", Default="", TextDisappear=true, Callback=function(v)
    local n=tonumber(v) local h=U.getHum() if n and h then h.JumpPower=n end
end})
tGen:AddTextbox({Name="移动速度设置", Default="", TextDisappear=true, Callback=function(v)
    local n=tonumber(v) local h=U.getHum() if n and h then h.WalkSpeed=n end
end})
tGen:AddTextbox({Name="重力设置", Default="", TextDisappear=true, Callback=function(v)
    local n=tonumber(v) if n then workspace.Gravity=n end
end})
tGen:AddToggle({Name="夜视", Default=false, Callback=function(v)
    Lighting.Ambient = v and Color3.new(1,1,1) or Color3.new(0,0,0)
end})

-- -------- 飞行V3 --------
tGen:AddButton({
    Name="飞行V3（隐藏）",
    Callback=function()
        local main=Instance.new("ScreenGui")
        local F=Instance.new("Frame")
        local up=Instance.new("TextButton")
        local down=Instance.new("TextButton")
        local onof=Instance.new("TextButton")
        local TL=Instance.new("TextLabel")
        local plus=Instance.new("TextButton")
        local spd=Instance.new("TextLabel")
        local mine=Instance.new("TextButton")
        local closeb=Instance.new("TextButton")
        local mini=Instance.new("TextButton")
        local mini2=Instance.new("TextButton")

        main.Name="CC_FlyV3"
        main.Parent=LP:WaitForChild("PlayerGui")
        main.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        main.ResetOnSpawn=false

        F.Parent=main
        F.BackgroundColor3=Color3.fromRGB(163,255,137)
        F.BorderColor3=Color3.fromRGB(103,221,213)
        F.Position=UDim2.new(0.1,0,0.38,0)
        F.Size=UDim2.new(0,190,0,57)

        up.Parent=F; up.BackgroundColor3=Color3.fromRGB(79,255,152)
        up.Size=UDim2.new(0,44,0,28); up.Font=Enum.Font.SourceSans
        up.Text="UP"; up.TextColor3=Color3.new(0,0,0); up.TextSize=14

        down.Parent=F; down.BackgroundColor3=Color3.fromRGB(215,255,121)
        down.Position=UDim2.new(0,0,0.491,0)
        down.Size=UDim2.new(0,44,0,28); down.Font=Enum.Font.SourceSans
        down.Text="DOWN"; down.TextColor3=Color3.new(0,0,0); down.TextSize=14

        onof.Parent=F; onof.BackgroundColor3=Color3.fromRGB(255,249,74)
        onof.Position=UDim2.new(0.702,0,0.491,0)
        onof.Size=UDim2.new(0,56,0,28); onof.Font=Enum.Font.SourceSans
        onof.Text="fly"; onof.TextColor3=Color3.new(0,0,0); onof.TextSize=14

        TL.Parent=F; TL.BackgroundColor3=Color3.fromRGB(242,60,255)
        TL.Position=UDim2.new(0.469,0,0,0)
        TL.Size=UDim2.new(0,100,0,28); TL.Font=Enum.Font.SourceSans
        TL.Text="Fly GUI V3"; TL.TextColor3=Color3.new(0,0,0)
        TL.TextScaled=true; TL.TextSize=14

        plus.Parent=F; plus.BackgroundColor3=Color3.fromRGB(133,145,255)
        plus.Position=UDim2.new(0.231,0,0,0)
        plus.Size=UDim2.new(0,45,0,28); plus.Font=Enum.Font.SourceSans
        plus.Text="+"; plus.TextColor3=Color3.new(0,0,0); plus.TextScaled=true

        spd.Parent=F; spd.BackgroundColor3=Color3.fromRGB(255,85,0)
        spd.Position=UDim2.new(0.468,0,0.491,0)
        spd.Size=UDim2.new(0,44,0,28); spd.Font=Enum.Font.SourceSans
        spd.Text="1"; spd.TextColor3=Color3.new(0,0,0); spd.TextScaled=true

        mine.Parent=F; mine.BackgroundColor3=Color3.fromRGB(123,255,247)
        mine.Position=UDim2.new(0.231,0,0.491,0)
        mine.Size=UDim2.new(0,45,0,29); mine.Font=Enum.Font.SourceSans
        mine.Text="-"; mine.TextColor3=Color3.new(0,0,0); mine.TextScaled=true

        closeb.Parent=F; closeb.BackgroundColor3=Color3.fromRGB(225,25,0)
        closeb.Font=Enum.Font.SourceSans; closeb.Size=UDim2.new(0,45,0,28)
        closeb.Text="X"; closeb.TextSize=30
        closeb.Position=UDim2.new(0,0,-1,27)

        mini.Parent=F; mini.BackgroundColor3=Color3.fromRGB(192,150,230)
        mini.Font=Enum.Font.SourceSans; mini.Size=UDim2.new(0,45,0,28)
        mini.Text="-"; mini.TextSize=40
        mini.Position=UDim2.new(0,44,-1,27)

        mini2.Parent=F; mini2.BackgroundColor3=Color3.fromRGB(192,150,230)
        mini2.Font=Enum.Font.SourceSans; mini2.Size=UDim2.new(0,45,0,28)
        mini2.Text="+"; mini2.TextSize=40
        mini2.Position=UDim2.new(0,44,-1,57)
        mini2.Visible=false

        local speeds=1
        local nowe=false

        F.Active=true
        F.Draggable=true

        local kd,ku
        onof.MouseButton1Down:Connect(function()
            local char=U.getChar()
            local hum=U.getHum()
            if not (char and hum) then return end

            if nowe then
                nowe=false
                for _,s in ipairs({
                    Enum.HumanoidStateType.Climbing,Enum.HumanoidStateType.FallingDown,
                    Enum.HumanoidStateType.Flying,Enum.HumanoidStateType.Freefall,
                    Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
                    Enum.HumanoidStateType.Landed,Enum.HumanoidStateType.Physics,
                    Enum.HumanoidStateType.PlatformStanding,Enum.HumanoidStateType.Ragdoll,
                    Enum.HumanoidStateType.Running,Enum.HumanoidStateType.RunningNoPhysics,
                    Enum.HumanoidStateType.Seated,Enum.HumanoidStateType.StrafingNoPhysics,
                    Enum.HumanoidStateType.Swimming
                }) do pcall(function() hum:SetStateEnabled(s,true) end) end
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            else
                nowe=true
                for _=1,speeds do
                    task.spawn(function()
                        local hb=RunService.Heartbeat
                        while nowe and hb:Wait() and char.Parent and hum.Parent do
                            if hum.MoveDirection.Magnitude>0 then
                                pcall(function() char:TranslateBy(hum.MoveDirection) end)
                            end
                        end
                    end)
                end
                pcall(function() char.Animate.Disabled=true end)
                for _,v in next,hum:GetPlayingAnimationTracks() do
                    pcall(function() v:AdjustSpeed(0) end)
                end
                for _,s in ipairs({
                    Enum.HumanoidStateType.Climbing,Enum.HumanoidStateType.FallingDown,
                    Enum.HumanoidStateType.Flying,Enum.HumanoidStateType.Freefall,
                    Enum.HumanoidStateType.GettingUp,Enum.HumanoidStateType.Jumping,
                    Enum.HumanoidStateType.Landed,Enum.HumanoidStateType.Physics,
                    Enum.HumanoidStateType.PlatformStanding,Enum.HumanoidStateType.Ragdoll,
                    Enum.HumanoidStateType.Running,Enum.HumanoidStateType.RunningNoPhysics,
                    Enum.HumanoidStateType.Seated,Enum.HumanoidStateType.StrafingNoPhysics,
                    Enum.HumanoidStateType.Swimming
                }) do pcall(function() hum:SetStateEnabled(s,false) end) end
                hum:ChangeState(Enum.HumanoidStateType.Swimming)
            end

            local T = hum.RigType==Enum.HumanoidRigType.R6 and char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if not T then return end

            local ctrl={f=0,b=0,l=0,r=0}
            local last={f=0,b=0,l=0,r=0}
            local max=50
            local cur=0

            local bg=Instance.new("BodyGyro",T)
            bg.P=9e4; bg.maxTorque=Vector3.new(9e9,9e9,9e9); bg.cframe=T.CFrame

            local bv=Instance.new("BodyVelocity",T)
            bv.velocity=Vector3.new(0,0.1,0); bv.maxForce=Vector3.new(9e9,9e9,9e9)

            if nowe then pcall(function() hum.PlatformStand=true end) end

            if kd then kd:Disconnect() end
            if ku then ku:Disconnect() end

            local mouse=LP:GetMouse()
            kd=mouse.KeyDown:Connect(function(k)
                k=k:lower()
                if k=="w" then ctrl.f=1
                elseif k=="s" then ctrl.b=-1
                elseif k=="a" then ctrl.l=-1
                elseif k=="d" then ctrl.r=1 end
            end)
            ku=mouse.KeyUp:Connect(function(k)
                k=k:lower()
                if k=="w" then ctrl.f=0
                elseif k=="s" then ctrl.b=0
                elseif k=="a" then ctrl.l=0
                elseif k=="d" then ctrl.r=0 end
            end)

            task.spawn(function()
                while nowe and char.Parent and hum.Health>0 do
                    RunService.RenderStepped:Wait()
                    if ctrl.l+ctrl.r~=0 or ctrl.f+ctrl.b~=0 then
                        cur=cur+0.5+cur/max
                        if cur>max then cur=max end
                    elseif cur~=0 then
                        cur=cur-1
                        if cur<0 then cur=0 end
                    end
                    if (ctrl.l+ctrl.r)~=0 or (ctrl.f+ctrl.b)~=0 then
                        bv.velocity=((workspace.CurrentCamera.CFrame.lookVector*(ctrl.f+ctrl.b))+
                            ((workspace.CurrentCamera.CFrame*CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*0.2,0).p)-
                            workspace.CurrentCamera.CFrame.p))*cur
                        last={f=ctrl.f,b=ctrl.b,l=ctrl.l,r=ctrl.r}
                    elseif cur~=0 then
                        bv.velocity=((workspace.CurrentCamera.CFrame.lookVector*(last.f+last.b))+
                            ((workspace.CurrentCamera.CFrame*CFrame.new(last.l+last.r,(last.f+last.b)*0.2,0).p)-
                            workspace.CurrentCamera.CFrame.p))*cur
                    else
                        bv.velocity=Vector3.new(0,0,0)
                    end
                    bg.cframe=workspace.CurrentCamera.CFrame*CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*cur/max),0,0)
                end
                bg:Destroy(); bv:Destroy()
                if hum then hum.PlatformStand=false end
                if char then pcall(function() char.Animate.Disabled=false end) end
                if kd then kd:Disconnect() end
                if ku then ku:Disconnect() end
            end)
        end)

        local upC
        up.MouseButton1Down:Connect(function()
            upC=up.MouseEnter:Connect(function()
                while upC do
                    task.wait()
                    local h=U.getHRP()
                    if h then h.CFrame=h.CFrame*CFrame.new(0,1,0) end
                end
            end)
        end)
        up.MouseLeave:Connect(function() if upC then upC:Disconnect(); upC=nil end end)

        local dnC
        down.MouseButton1Down:Connect(function()
            dnC=down.MouseEnter:Connect(function()
                while dnC do
                    task.wait()
                    local h=U.getHRP()
                    if h then h.CFrame=h.CFrame*CFrame.new(0,-1,0) end
                end
            end)
        end)
        down.MouseLeave:Connect(function() if dnC then dnC:Disconnect(); dnC=nil end end)

        LP.CharacterAdded:Connect(function(c)
            task.wait(0.7)
            local h=c:FindFirstChildOfClass("Humanoid")
            if h then h.PlatformStand=false end
            pcall(function() c.Animate.Disabled=false end)
        end)

        plus.MouseButton1Down:Connect(function()
            speeds=speeds+1; spd.Text=tostring(speeds)
        end)
        mine.MouseButton1Down:Connect(function()
            if speeds<=1 then
                spd.Text="cannot be less than 1"
                task.wait(1)
                spd.Text=tostring(speeds)
            else
                speeds=speeds-1; spd.Text=tostring(speeds)
            end
        end)
        closeb.MouseButton1Click:Connect(function() main:Destroy() end)
        mini.MouseButton1Click:Connect(function()
            up.Visible=false; down.Visible=false; onof.Visible=false
            plus.Visible=false; spd.Visible=false; mine.Visible=false
            mini.Visible=false; mini2.Visible=true
            F.BackgroundTransparency=1
            closeb.Position=UDim2.new(0,0,-1,57)
        end)
        mini2.MouseButton1Click:Connect(function()
            up.Visible=true; down.Visible=true; onof.Visible=true
            plus.Visible=true; spd.Visible=true; mine.Visible=true
            mini.Visible=true; mini2.Visible=false
            F.BackgroundTransparency=0
            closeb.Position=UDim2.new(0,0,-1,27)
        end)
    end
})

-- -------- 光影V4 --------
tGen:AddButton({Name="光影V4", Callback=function()
    U.load("https://raw.githubusercontent.com/MZEEN2424/Graphics/main/Graphics.xml")
end})

-- -------- R15变R6 (完整内嵌) --------
tGen:AddButton({
    Name="R15变R6（全游戏通用）",
    Callback=function()
        -- reanimate by MyWorld#4430
        local v3_net, v3_808 = Vector3.new(0, 25.1, 0), Vector3.new(8, 0, 8)
        local function getNetlessVelocity(realPartVelocity)
            local mag = realPartVelocity.Magnitude
            if mag > 1 then
                local unit = realPartVelocity.Unit
                if (unit.Y > 0.25) or (unit.Y < -0.75) then
                    return unit * (25.1 / unit.Y)
                end
            end
            return v3_net + realPartVelocity * v3_808
        end
        local simradius = "shp"
        local simrad = 1000
        local healthHide = true
        local reclaim = true
        local novoid = true
        local physp = nil
        local noclipAllParts = false
        local antiragdoll = true
        local newanimate = true
        local discharscripts = true
        local R15toR6 = true
        local hatcollide = true
        local humState16 = true
        local addtools = false
        local hedafterneck = true
        local loadtime = Players.RespawnTime + 100000
        local method = 3
        local alignmode = 4
        local flingpart = "HumanoidRootPart"

        local lp = Players.LocalPlayer
        local rs, ws, sg = RunService, workspace, StarterGui
        local stepped, heartbeat, renderstepped = rs.Stepped, rs.Heartbeat, rs.RenderStepped
        local twait, tdelay, rad, inf, abs, clamp = task.wait, task.delay, math.rad, math.huge, math.abs, math.clamp
        local cf, v3, angles = CFrame.new, Vector3.new, CFrame.Angles
        local v3_0, cf_0 = v3(0,0,0), cf(0,0,0)

        local c = lp.Character
        if not (c and c.Parent) then return end

        c:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (c and c.Parent) then c = nil end
        end)

        local clone, destroy, getchildren, getdescendants, isa = c.Clone, c.Destroy, c.GetChildren, c.GetDescendants, c.IsA

        local function gp(parent, name, className)
            if typeof(parent) == "Instance" then
                for i, v in pairs(getchildren(parent)) do
                    if (v.Name == name) and isa(v, className) then return v end
                end
            end
            return nil
        end

        local fenv = getfenv()
        local shp = fenv.sethiddenproperty or fenv.set_hidden_property or fenv.set_hidden_prop or fenv.sethiddenprop
        local ssr = fenv.setsimulationradius or fenv.set_simulation_radius or fenv.set_sim_radius or fenv.setsimradius or fenv.setsimrad or fenv.set_sim_rad

        healthHide = healthHide and ((method == 0) or (method == 2) or (method == 3)) and gp(c, "Head", "BasePart")
        local reclaim, lostpart = reclaim and c.PrimaryPart, nil

        local function align(Part0, Part1)
            local att0 = Instance.new("Attachment")
            att0.Position, att0.Orientation, att0.Name = v3_0, v3_0, "att0_" .. Part0.Name
            local att1 = Instance.new("Attachment")
            att1.Position, att1.Orientation, att1.Name = v3_0, v3_0, "att1_" .. Part1.Name

            if alignmode == 4 then
                local hide = false
                if Part0 == healthHide then
                    healthHide = false
                    tdelay(0, function()
                        while twait(2.9) and Part0 and c do
                            hide = #Part0:GetConnectedParts() == 1
                            twait(0.1)
                            hide = false
                        end
                    end)
                end
                local rot = rad(0.05)
                local con0, con1 = nil, nil
                con0 = stepped:Connect(function()
                    if not (Part0 and Part1) then return con0:Disconnect() and con1:Disconnect() end
                    Part0.RotVelocity = Part1.RotVelocity
                end)
                local lastpos = Part0.Position
                con1 = heartbeat:Connect(function(delta)
                    if not (Part0 and Part1 and att1) then return con0:Disconnect() and con1:Disconnect() end
                    if (not Part0.Anchored) and (Part0.ReceiveAge == 0) then
                        if lostpart == Part0 then lostpart = nil end
                        local newcf = Part1.CFrame * att1.CFrame
                        if Part1.Velocity.Magnitude > 0.1 then
                            Part0.Velocity = getNetlessVelocity(Part1.Velocity)
                        else
                            local vel = (newcf.Position - lastpos) / delta
                            Part0.Velocity = getNetlessVelocity(vel)
                            if vel.Magnitude < 1 then
                                rot = -rot
                                newcf *= angles(0, 0, rot)
                            end
                        end
                        lastpos = newcf.Position
                        if lostpart and (Part0 == reclaim) then
                            newcf = lostpart.CFrame
                        elseif hide then
                            newcf += v3(0, 3000, 0)
                        end
                        if novoid and (newcf.Y < ws.FallenPartsDestroyHeight + 0.1) then
                            newcf += v3(0, ws.FallenPartsDestroyHeight + 0.1 - newcf.Y, 0)
                        end
                        Part0.CFrame = newcf
                    elseif (not Part0.Anchored) and (abs(Part0.Velocity.X) < 45) and (abs(Part0.Velocity.Y) < 25) and (abs(Part0.Velocity.Z) < 45) then
                        lostpart = Part0
                    end
                end)
            end

            att0:GetPropertyChangedSignal("Parent"):Connect(function()
                Part0 = att0.Parent
                if not isa(Part0, "BasePart") then
                    att0 = nil
                    if lostpart == Part0 then lostpart = nil end
                    Part0 = nil
                end
            end)
            att0.Parent = Part0

            att1:GetPropertyChangedSignal("Parent"):Connect(function()
                Part1 = att1.Parent
                if not isa(Part1, "BasePart") then
                    att1 = nil; Part1 = nil
                end
            end)
            att1.Parent = Part1
        end

        local function respawnrequest()
            local ccfr, c = ws.CurrentCamera.CFrame, lp.Character
            lp.Character = nil
            lp.Character = c
            local con = nil
            con = ws.CurrentCamera.Changed:Connect(function(prop)
                if (prop ~= "Parent") and (prop ~= "CFrame") then return end
                ws.CurrentCamera.CFrame = ccfr
                con:Disconnect()
            end)
        end

        local destroyhum = (method == 4) or (method == 5)
        local breakjoints = (method == 0) or (method == 4)
        local antirespawn = (method == 0) or (method == 2) or (method == 3)

        hatcollide = hatcollide and (method == 0)
        addtools = addtools and lp:FindFirstChildOfClass("Backpack")

        if type(simrad) ~= "number" then simrad = 1000 end
        if shp and (simradius == "shp") then
            tdelay(0, function()
                while c do
                    shp(lp, "SimulationRadius", simrad)
                    heartbeat:Wait()
                end
            end)
        end

        if antiragdoll then
            antiragdoll = function(v)
                if isa(v, "HingeConstraint") or isa(v, "BallSocketConstraint") then
                    v.Parent = nil
                end
            end
            for i, v in pairs(getdescendants(c)) do antiragdoll(v) end
            c.DescendantAdded:Connect(antiragdoll)
        end

        if antirespawn then respawnrequest() end

        if method == 0 then
            twait(loadtime)
            if not c then return end
        end

        if discharscripts then
            for i, v in pairs(getdescendants(c)) do
                if isa(v, "LocalScript") then v.Disabled = true end
            end
        elseif newanimate then
            local animate = gp(c, "Animate", "LocalScript")
            if animate and (not animate.Disabled) then
                animate.Disabled = true
            else
                newanimate = false
            end
        end

        if addtools then
            for i, v in pairs(getchildren(addtools)) do
                if isa(v, "Tool") then v.Parent = c end
            end
        end

        pcall(function()
            settings().Physics.AllowSleep = false
            settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        end)

        local OLDscripts = {}
        for i, v in pairs(getdescendants(c)) do
            if v.ClassName == "Script" then OLDscripts[v.Name] = true end
        end

        local scriptNames = {}
        for i, v in pairs(getdescendants(c)) do
            if isa(v, "BasePart") then
                local newName, exists = tostring(i), true
                while exists do
                    exists = OLDscripts[newName]
                    if exists then newName = newName .. "_" end
                end
                table.insert(scriptNames, newName)
                Instance.new("Script", v).Name = newName
            end
        end

        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            for i, v in pairs(hum:GetPlayingAnimationTracks()) do v:Stop() end
        end
        c.Archivable = true
        local cl = clone(c)
        if hum and humState16 then
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            if destroyhum then twait(1.6) end
        end
        if destroyhum then pcall(destroy, hum) end

        if not c then return end

        local head, torso, root = gp(c, "Head", "BasePart"), gp(c, "Torso", "BasePart") or gp(c, "UpperTorso", "BasePart"), gp(c, "HumanoidRootPart", "BasePart")
        if hatcollide then
            pcall(destroy, torso)
            pcall(destroy, root)
            pcall(destroy, c:FindFirstChildOfClass("BodyColors") or gp(c, "Health", "Script"))
        end

        local model = Instance.new("Model", c)
        model:GetPropertyChangedSignal("Parent"):Connect(function()
            if not (model and model.Parent) then model = nil end
        end)

        for i, v in pairs(getchildren(c)) do
            if v ~= model then
                v.Parent = model
            end
        end

        if breakjoints then
            model:BreakJoints()
        else
            if head and torso then
                for i, v in pairs(getdescendants(model)) do
                    if isa(v, "JointInstance") then
                        local save = false
                        if (v.Part0 == torso) and (v.Part1 == head) then save = true end
                        if (v.Part0 == head) and (v.Part1 == torso) then save = true end
                        if save then
                            if hedafterneck then hedafterneck = v end
                        else
                            pcall(destroy, v)
                        end
                    end
                end
            end
            if method == 3 then
                task.delay(loadtime, pcall, model.BreakJoints, model)
            end
        end

        cl.Parent = ws
        for i, v in pairs(getchildren(cl)) do v.Parent = c end
        pcall(destroy, cl)

        local uncollide, noclipcon = nil, nil
        if noclipAllParts then
            uncollide = function()
                if c then
                    for i, v in pairs(getdescendants(c)) do
                        if isa(v, "BasePart") then v.CanCollide = false end
                    end
                else
                    noclipcon:Disconnect()
                end
            end
        else
            uncollide = function()
                if model then
                    for i, v in pairs(getdescendants(model)) do
                        if isa(v, "BasePart") then v.CanCollide = false end
                    end
                else
                    noclipcon:Disconnect()
                end
            end
        end
        noclipcon = stepped:Connect(uncollide)
        uncollide()

        for i, scr in pairs(getdescendants(model)) do
            if (scr.ClassName == "Script") and table.find(scriptNames, scr.Name) then
                local Part0 = scr.Parent
                if isa(Part0, "BasePart") then
                    for i1, scr1 in pairs(getdescendants(c)) do
                        if (scr1.ClassName == "Script") and (scr1.Name == scr.Name) and (not scr1:IsDescendantOf(model)) then
                            local Part1 = scr1.Parent
                            if (Part1.ClassName == Part0.ClassName) and (Part1.Name == Part0.Name) then
                                align(Part0, Part1)
                                pcall(destroy, scr)
                                pcall(destroy, scr1)
                                break
                            end
                        end
                    end
                end
            end
        end

        for i, v in pairs(getdescendants(c)) do
            if v and v.Parent and (not v:IsDescendantOf(model)) then
                if isa(v, "Decal") then
                    v.Transparency = 1
                elseif isa(v, "BasePart") then
                    v.Transparency = 1
                    v.Anchored = false
                elseif isa(v, "ForceField") then
                    v.Visible = false
                elseif isa(v, "Sound") then
                    v.Playing = false
                elseif isa(v, "BillboardGui") or isa(v, "SurfaceGui") or isa(v, "ParticleEmitter") or isa(v, "Fire") or isa(v, "Smoke") or isa(v, "Sparkles") then
                    v.Enabled = false
                end
            end
        end

        if newanimate then
            local animate = gp(c, "Animate", "LocalScript")
            if animate then animate.Disabled = false end
        end

        if addtools then
            for i, v in pairs(getchildren(c)) do
                if isa(v, "Tool") then v.Parent = addtools end
            end
        end

        local hum0, hum1 = model:FindFirstChildOfClass("Humanoid"), c:FindFirstChildOfClass("Humanoid")
        if hum0 then
            hum0:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (hum0 and hum0.Parent) then hum0 = nil end
            end)
        end
        if hum1 then
            hum1:GetPropertyChangedSignal("Parent"):Connect(function()
                if not (hum1 and hum1.Parent) then hum1 = nil end
            end)
            ws.CurrentCamera.CameraSubject = hum1
            local camSubCon = nil
            local function camSubFunc()
                camSubCon:Disconnect()
                if c and hum1 then ws.CurrentCamera.CameraSubject = hum1 end
            end
            camSubCon = renderstepped:Connect(camSubFunc)
            if hum0 then
                hum0:GetPropertyChangedSignal("Jump"):Connect(function()
                    if hum1 then hum1.Jump = hum0.Jump end
                end)
            else
                respawnrequest()
            end
        end

        local rb = Instance.new("BindableEvent", c)
        rb.Event:Connect(function()
            pcall(destroy, rb)
            sg:SetCore("ResetButtonCallback", true)
            if destroyhum then
                if c then c:BreakJoints() end
                return
            end
            if model and hum0 and (hum0.Health > 0) then
                model:BreakJoints()
                hum0.Health = 0
            end
            if antirespawn then respawnrequest() end
        end)
        sg:SetCore("ResetButtonCallback", rb)

        tdelay(0, function()
            while c do
                if hum0 and hum1 then hum1.Jump = hum0.Jump end
                wait()
            end
            sg:SetCore("ResetButtonCallback", true)
        end)

        R15toR6 = R15toR6 and hum1 and (hum1.RigType == Enum.HumanoidRigType.R15)
        if R15toR6 then
            local part = gp(c, "HumanoidRootPart", "BasePart") or gp(c, "UpperTorso", "BasePart") or gp(c, "LowerTorso", "BasePart") or gp(c, "Head", "BasePart") or c:FindFirstChildWhichIsA("BasePart")
            if part then
                local cfr = part.CFrame
                local R6parts = {
                    head = {Name="Head", Size=v3(2,1,1), R15={Head=0}},
                    torso = {Name="Torso", Size=v3(2,2,1), R15={UpperTorso=0.2, LowerTorso=-0.73}},
                    root = {Name="HumanoidRootPart", Size=v3(2,2,1), R15={HumanoidRootPart=0}},
                    leftArm = {Name="Left Arm", Size=v3(1,2,1), R15={LeftHand=-0.73, LeftLowerArm=-0.174, LeftUpperArm=0.415}},
                    rightArm = {Name="Right Arm", Size=v3(1,2,1), R15={RightHand=-0.73, RightLowerArm=-0.174, RightUpperArm=0.415}},
                    leftLeg = {Name="Left Leg", Size=v3(1,2,1), R15={LeftFoot=-0.85, LeftLowerLeg=-0.29, LeftUpperLeg=0.49}},
                    rightLeg = {Name="Right Leg", Size=v3(1,2,1), R15={RightFoot=-0.85, RightLowerLeg=-0.29, RightUpperLeg=0.49}}
                }
                for i, v in pairs(getchildren(c)) do
                    if isa(v, "BasePart") then
                        for i1, v1 in pairs(getchildren(v)) do
                            if isa(v1, "Motor6D") then v1.Part0 = nil end
                        end
                    end
                end
                part.Archivable = true
                for i, v in pairs(R6parts) do
                    local p = clone(part)
                    p:ClearAllChildren()
                    p.Name, p.Size, p.CFrame, p.Anchored, p.Transparency, p.CanCollide = v.Name, v.Size, cfr, false, 1, false
                    for i1, v1 in pairs(v.R15) do
                        local R15part = gp(c, i1, "BasePart")
                        local att = gp(R15part, "att1_" .. i1, "Attachment")
                        if R15part then
                            local weld = Instance.new("Weld")
                            weld.Part0, weld.Part1, weld.C0, weld.C1, weld.Name = p, R15part, cf(0, v1, 0), cf_0, "Weld_" .. i1
                            weld.Parent = R15part
                            R15part.Massless, R15part.Name = true, "R15_" .. i1
                            R15part.Parent = p
                            if att then
                                att.Position = v3(0, v1, 0)
                                att.Parent = p
                            end
                        end
                    end
                    p.Parent = c
                    R6parts[i] = p
                end
                local R6joints = {
                    neck = {Parent=R6parts.torso, Name="Neck", Part0=R6parts.torso, Part1=R6parts.head,
                        C0=cf(0,1,0,-1,0,0,0,0,1,0,1,0), C1=cf(0,-0.5,0,-1,0,0,0,0,1,0,1,0)},
                    rootJoint = {Parent=R6parts.root, Name="RootJoint", Part0=R6parts.root, Part1=R6parts.torso,
                        C0=cf(0,0,0,-1,0,0,0,0,1,0,1,0), C1=cf(0,0,0,-1,0,0,0,0,1,0,1,0)},
                    rightShoulder = {Parent=R6parts.torso, Name="Right Shoulder", Part0=R6parts.torso, Part1=R6parts.rightArm,
                        C0=cf(1,0.5,0,0,0,1,0,1,-0,-1,0,0), C1=cf(-0.5,0.5,0,0,0,1,0,1,-0,-1,0,0)},
                    leftShoulder = {Parent=R6parts.torso, Name="Left Shoulder", Part0=R6parts.torso, Part1=R6parts.leftArm,
                        C0=cf(-1,0.5,0,0,0,-1,0,1,0,1,0,0), C1=cf(0.5,0.5,0,0,0,-1,0,1,0,1,0,0)},
                    rightHip = {Parent=R6parts.torso, Name="Right Hip", Part0=R6parts.torso, Part1=R6parts.rightLeg,
                        C0=cf(1,-1,0,0,0,1,0,1,-0,-1,0,0), C1=cf(0.5,1,0,0,0,1,0,1,-0,-1,0,0)},
                    leftHip = {Parent=R6parts.torso, Name="Left Hip", Part0=R6parts.torso, Part1=R6parts.leftLeg,
                        C0=cf(-1,-1,0,0,0,-1,0,1,0,1,0,0), C1=cf(-0.5,1,0,0,0,-1,0,1,0,1,0,0)}
                }
                for i, v in pairs(R6joints) do
                    local joint = Instance.new("Motor6D")
                    for prop, val in pairs(v) do joint[prop] = val end
                    R6joints[i] = joint
                end
                if hum1 then hum1.RigType, hum1.HipHeight = Enum.HumanoidRigType.R6, 0 end
            end
        end
    end
})

-- -------- 撸管脚本 --------
tGen:AddButton({Name="撸管脚本（R15）", Callback=function() U.load("https://pastefy.app/YZoglOyJ/raw") end})
tGen:AddButton({Name="撸管脚本（R6）",  Callback=function() U.load("https://pastefy.app/wa3v2Vgm/raw") end})

-- -------- 控制玩家脚本 --------
tGen:AddButton({Name="控制玩家脚本", Callback=function()
    U.load("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end})

-- -------- 点击传送工具 --------
tGen:AddButton({
    Name="点击传送工具",
    Callback=function()
        local mouse=LP:GetMouse()
        local tool=Instance.new("Tool")
        tool.RequiresHandle=false
        tool.Name="[FE] TELEPORT TOOL"
        tool.Activated:Connect(function()
            local hrp=U.getHRP()
            if hrp then
                local pos=mouse.Hit+Vector3.new(0,2.5,0)
                hrp.CFrame=CFrame.new(pos.X,pos.Y,pos.Z)
            end
        end)
        tool.Parent=LP.Backpack
    end
})

-- -------- XC脚本中心 --------
tGen:AddButton({Name="XC脚本中心", Callback=function() U.load("https://pastebin.com/raw/gemxHwA1") end})

-- -------- UNC测试 --------
tGen:AddButton({Name="测试注入器UNC", Callback=function()
    U.load("https://raw.githubusercontent.com/unified-naming-convention/NamingStandard/main/UNCCheckEnv.lua")
end})

-- -------- 无敌 --------
tGen:AddButton({
    Name="无敌",
    Callback=function()
        local char=U.getChar()
        if not char or not char:FindFirstChild("Head") then return end
        char.Archivable=true
        local new=char:Clone()
        new.Parent=workspace
        LP.Character=new
        task.wait(2)
        local oldhum=char:FindFirstChildWhichIsA("Humanoid")
        if not oldhum then return end
        local newhum=oldhum:Clone()
        newhum.Parent=char
        newhum.RequiresNeck=false
        oldhum.Parent=nil
        task.wait(2)
        LP.Character=char
        new:Destroy()
        task.wait(1)
        newhum:GetPropertyChangedSignal("Health"):Connect(function()
            if newhum.Health<=0 then
                oldhum.Parent=LP.Character
                task.wait(1)
                oldhum:Destroy()
            end
        end)
        workspace.CurrentCamera.CameraSubject=char
        if char:FindFirstChild("Animate") then
            char.Animate.Disabled=true
            task.wait(0.1)
            char.Animate.Disabled=false
        end
        local h=LP.Character:FindFirstChild("Head")
        if h then h:Destroy() end
    end
})

-- -------- 甩飞所有人 (修复 Accessoy) --------
tGen:AddButton({
    Name="甩飞所有人",
    Callback=function()
        local Targets={"All"}
        local AllBool=false
        local Player=LP

        local function GetPlayer(Name)
            Name=Name:lower()
            if Name=="all" or Name=="others" then AllBool=true; return end
            if Name=="random" then
                local list=Players:GetPlayers()
                local i=table.find(list,Player)
                if i then table.remove(list,i) end
                return list[math.random(#list)]
            end
            for _,x in next,Players:GetPlayers() do
                if x~=Player then
                    if x.Name:lower():match("^"..Name) then return x
                    elseif x.DisplayName:lower():match("^"..Name) then return x end
                end
            end
        end

        local function Notify(t,x,d)
            StarterGui:SetCore("SendNotification",{Title=t,Text=x,Duration=d})
        end

        local function SkidFling(TP)
            local Char=Player.Character
            local Hum=Char and Char:FindFirstChildOfClass("Humanoid")
            local RP=Hum and Hum.RootPart
            local TChar=TP.Character
            if not TChar then return end
            local THum=TChar:FindFirstChildOfClass("Humanoid")
            local TRP=THum and THum.RootPart
            local THead=TChar:FindFirstChild("Head")
            local Acc=TChar:FindFirstChildOfClass("Accessory")
            local Handle=Acc and Acc:FindFirstChild("Handle")

            if not (Char and Hum and RP) then return end
            if RP.Velocity.Magnitude<50 then getgenv().OldPos=RP.CFrame end
            if THum and THum.Sit and not AllBool then return Notify("Error","Target sitting",5) end
            if THead then workspace.CurrentCamera.CameraSubject=THead
            elseif Handle then workspace.CurrentCamera.CameraSubject=Handle
            elseif THum and TRP then workspace.CurrentCamera.CameraSubject=THum end
            if not TChar:FindFirstChildWhichIsA("BasePart") then return end

            workspace.FallenPartsDestroyHeight=0/0

            local BV=Instance.new("BodyVelocity")
            BV.Name="EpixVel"
            BV.Parent=RP
            BV.Velocity=Vector3.new(9e8,9e8,9e8)
            BV.MaxForce=Vector3.new(1/0,1/0,1/0)
            Hum:SetStateEnabled(Enum.HumanoidStateType.Seated,false)

            local target=TRP or THead or Handle
            if not target then BV:Destroy(); return end

            local t=tick()
            local angle=0
            repeat
                if not (RP and THum) then break end
                angle=angle+100
                RP.CFrame=CFrame.new(target.Position)*CFrame.new(0,1.5,0)*CFrame.Angles(math.rad(angle),0,0)
                Char:SetPrimaryPartCFrame(RP.CFrame)
                RP.Velocity=Vector3.new(9e7,9e8,9e7)
                RP.RotVelocity=Vector3.new(9e8,9e8,9e8)
                task.wait()
            until target.Velocity.Magnitude>500 or target.Parent~=TChar or THum.Sit or Hum.Health<=0 or tick()>t+2

            BV:Destroy()
            Hum:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
            workspace.CurrentCamera.CameraSubject=Hum
        end

        for _,x in next,Targets do GetPlayer(x) end
        if AllBool then
            for _,x in next,Players:GetPlayers() do
                if x~=Player then SkidFling(x) end
            end
        end
        for _,x in next,Targets do
            if x~="All" and x~="others" then
                local T=GetPlayer(x)
                if T and T~=Player then SkidFling(T) end
            end
        end
    end
})

-- -------- 反挂机 --------
tGen:AddButton({
    Name="防止掉线（反挂机）",
    Callback=function()
        LP.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
})

-- -------- 吸取全部玩家 --------
tGen:AddButton({
    Name="吸取全部玩家",
    Callback=function()
        local myChar=U.getChar()
        local myHRP=myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _,v in ipairs(Players:GetChildren()) do
            if v~=LP and v.Character then
                local tHRP=v.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    local R=Instance.new("BallSocketConstraint")
                    R.Parent=myHRP
                    local a1=Instance.new("Attachment",tHRP)
                    local a2=Instance.new("Attachment",myHRP)
                    R.Attachment0=a1
                    R.Attachment1=a2
                    R.Visible=false
                    task.wait(0.1)
                end
            end
        end
    end
})

tGen:AddButton({Name="隐身(E)", Callback=function() end})
tGen:AddButton({Name="飞行（有动作）(E)(别人看得到)", Callback=function()
    U.load("https://pastebin.com/raw/G3GnBCyC")
end})

-- -------- 穿墙2 (修复 game.RunService) --------
local noclipActive=false
local noclipConn
tGen:AddToggle({
    Name="穿墙2", Default=false,
    Callback=function(v)
        if v then
            if noclipConn then noclipConn:Disconnect() end
            noclipActive=true
            noclipConn=RunService.Stepped:Connect(function()
                if not noclipActive then return end
                local c=U.getChar()
                if c then
                    for _,p in ipairs(c:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide=false end
                    end
                end
            end)
        else
            noclipActive=false
            if noclipConn then noclipConn:Disconnect() end
        end
    end
})

-- -------- 踏空（无限跳） --------
tGen:AddButton({
    Name="踏空（无限跳）",
    Callback=function()
        local UIS=game:GetService("UserInputService")
        _G.JumpHeight=50
        UIS.InputBegan:Connect(function(input)
            if input.KeyCode==Enum.KeyCode.Space then
                local c=U.getChar()
                local h=U.getHum()
                if h then
                    local s=h:GetState()
                    if s==Enum.HumanoidStateType.Jumping or s==Enum.HumanoidStateType.Freefall then
                        local hrp=c:FindFirstChild("HumanoidRootPart")
                        if hrp then hrp.Velocity=Vector3.new(0,_G.JumpHeight,0) end
                    end
                end
            end
        end)
    end
})

-- -------- 透视 --------
tGen:AddButton({
    Name="透视",
    Callback=function()
        getgenv().ESP_Toggle=true
        getgenv().ESP_Team=false
        StarterGui:SetCore("SendNotification",{
            Title="透视", Text="Best ESP by.ExluZive",
            Button1="Shut Up", Duration=5
        })
        task.spawn(function()
            while task.wait() do
                if not getgenv().ESP_Toggle then break end
                pcall(function()
                    for _,v in ipairs(Players:GetChildren()) do
                        if v:IsA("Player") and v~=LP and v.Character then
                            local lpChar=LP.Character
                            local vChar=v.Character
                            if lpChar and vChar then
                                local lHRP=lpChar:FindFirstChild("HumanoidRootPart")
                                local vHRP=vChar:FindFirstChild("HumanoidRootPart")
                                if lHRP and vHRP then
                                    local d=math.floor((lHRP.Position-vHRP.Position).magnitude)
                                    if not (getgenv().ESP_Team and v.TeamColor==LP.TeamColor) then
                                        if not vChar:FindFirstChild("CC_ESP") then
                                            local ESP=Instance.new("Highlight",vChar)
                                            ESP.Name="CC_ESP"
                                            ESP.Adornee=vChar
                                            ESP.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                                            ESP.FillColor=v.TeamColor.Color
                                            ESP.FillTransparency=0.5
                                            ESP.OutlineColor=Color3.fromRGB(255,255,255)
                                            local Icon=Instance.new("BillboardGui",vChar)
                                            local Text=Instance.new("TextLabel",Icon)
                                            Icon.Name="CC_Icon"
                                            Icon.AlwaysOnTop=true
                                            Icon.Size=UDim2.new(0,800,0,50)
                                            Icon.ExtentsOffset=Vector3.new(0,1,0)
                                            Text.BackgroundTransparency=1
                                            Text.Size=UDim2.new(0,800,0,50)
                                            Text.Font=Enum.Font.SciFi
                                            Text.TextColor3=v.TeamColor.Color
                                            Text.TextSize=10.8
                                            Text.Text=v.Name.." | 距离: "..d
                                        else
                                            local icon=vChar:FindFirstChild("CC_Icon")
                                            if icon and icon:FindFirstChildWhichIsA("TextLabel") then
                                                icon:FindFirstChildWhichIsA("TextLabel").Text=v.Name.." | 距离: "..d
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

tGen:AddButton({Name="人物旋转", Callback=function()
    U.load("https://raw.githubusercontent.com/JsYb666/TUIXUI_qun-809771141/refs/heads/TUIXUI/fling")
end})

tGen:AddButton({Name="立即死亡", Callback=function()
    local h=U.getHum() if h then h.Health=0 end
end})

tGen:AddButton({Name="黑客脚本", Callback=function()
    U.load("https://raw.githubusercontent.com/BirthScripts/Scripts/main/c00l.lua")
end})

tGen:AddButton({Name="立即回满血（有些服务器不可用）", Callback=function()
    local h=U.getHum() if h then h.Health=10000 end
end})

tGen:AddButton({Name="玩家动作", Callback=function()
    getgenv().she="作者小盛蓝免费请勿倒卖"
    U.load("https://pastebin.com/raw/Zj4NnKs6")
end})

-- -------- FE 滚动的天空 --------
tGen:AddButton({
    Name="FE_滚动的天空",
    Callback=function()
        local UIS=game:GetService("UserInputService")
        local Cam=workspace.CurrentCamera
        local SPEED=30
        local JUMP=60
        local GAP=0.3
        local c=U.getChar()
        if not c then return end
        for _,v in ipairs(c:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
        local ball=c:FindFirstChild("HumanoidRootPart")
        if not ball then return end
        ball.Shape=Enum.PartType.Ball
        ball.Size=Vector3.new(5,5,5)
        local hum=c:WaitForChild("Humanoid")
        local params=RaycastParams.new()
        params.FilterType=Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances={c}
        local conn=RunService.RenderStepped:Connect(function(dt)
            ball.CanCollide=true
            hum.PlatformStand=true
            if UIS:GetFocusedTextBox() then return end
            if UIS:IsKeyDown("W") then ball.RotVelocity-=Cam.CFrame.RightVector*dt*SPEED end
            if UIS:IsKeyDown("A") then ball.RotVelocity-=Cam.CFrame.LookVector*dt*SPEED end
            if UIS:IsKeyDown("S") then ball.RotVelocity+=Cam.CFrame.RightVector*dt*SPEED end
            if UIS:IsKeyDown("D") then ball.RotVelocity+=Cam.CFrame.LookVector*dt*SPEED end
        end)
        UIS.JumpRequest:Connect(function()
            local r=workspace:Raycast(ball.Position,Vector3.new(0,-((ball.Size.Y/2)+GAP),0),params)
            if r then ball.Velocity=ball.Velocity+Vector3.new(0,JUMP,0) end
        end)
        Cam.CameraSubject=ball
        hum.Died:Connect(function() conn:Disconnect() end)
    end
})

-- -------- FE 仿gmod物理枪 --------
tGen:AddButton({Name="FE_仿gmod物理枪", Callback=function()
    U.load("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end})

-- -------- FE 分头行动 --------
tGen:AddButton({
    Name="FE_分头行动",
    Callback=function()
        local c=U.getChar()
        if not c then return end
        for _,v in ipairs(c:GetChildren()) do
            if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then v:Destroy() end
        end
        local hum=c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for _,acc in ipairs(hum:GetAccessories()) do
            local hat=acc.Name
            local hatPart=c:FindFirstChild(hat)
            if hatPart then
                hatPart.Archivable=true
                local fake=hatPart:Clone()
                fake.Parent=c
                local fh=fake:FindFirstChild("Handle")
                if fh then fh.Transparency=1 end
                local hh=hatPart:FindFirstChild("Handle")
                if hh then
                    local w=hh:FindFirstChildOfClass("Weld")
                    if w then w:Destroy() end
                end
                local tool=Instance.new("Tool",LP.Backpack)
                tool.RequiresHandle=true
                tool.CanBeDropped=false
                tool.Name=hat
                local handle=Instance.new("Part",tool)
                handle.Name="Handle"
                handle.Size=Vector3.new(1,1,1)
                handle.Massless=true
                handle.Transparency=1
                local hold=false
                tool.Equipped:Connect(function() hold=true end)
                tool.Unequipped:Connect(function() hold=false end)
                RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local rHat=c:FindFirstChild(hat)
                        local rHandle=rHat and rHat:FindFirstChild("Handle")
                        local fHandle=fake:FindFirstChild("Handle")
                        if rHandle and fHandle then
                            rHandle.Velocity=Vector3.new(30,0,0)
                            rHandle.CFrame=hold and handle.CFrame or fHandle.CFrame
                        end
                    end)
                end)
            end
        end
    end
})

-- -------- Infinite Yield FE --------
tGen:AddButton({Name="Infinite Yield FE", Callback=function()
    U.load("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end})

-- ========================================================
-- Tab: Doors
-- ========================================================
local tDoors = Window:MakeTab({Name="Doors", Icon="rbxassetid://4483345998", PremiumOnly=false})
tDoors:AddSection({Name="推荐使用："})
tDoors:AddButton({Name="BlackKing(教父同款)", Callback=function()
    U.load("https://raw.githubusercontent.com/KINGHUB01/BlackKing/main/Blackking%20Game")
end})
tDoors:AddButton({Name="Doors 酒店专用", Callback=function()
    U.load("https://raw.githubusercontent.com/Sypse/UILibraries/main/BracketV3_Fixed.lua")
end})
tDoors:AddSection({Name="其次："})
tDoors:AddButton({Name="DX夜", Callback=function() U.load("https://raw.githubusercontent.com/DXuwu/test-lol/main/YO.lua") end})
tDoors:AddButton({Name="脚本", Callback=function() U.load("https://raw.githubusercontent.com/GamingScripter/Darkrai-X/main/Games/Doors") end})
tDoors:AddButton({Name="超级脚本", Callback=function() U.load("https://raw.githubusercontent.com/Fazedrab/EntitySpawner/main/doors(orionlib).lua") end})
tDoors:AddButton({Name="修改", Callback=function() U.load("https://raw.githubusercontent.com/sponguss/Doors-Entity-Replicator/main/source.lua") end})
tDoors:AddButton({Name="微山doors", Callback=function() U.load("https://pastebin.com/raw/uHHp8fzS") end})

-- ========================================================
-- 其他游戏分类 (循环生成)
-- ========================================================
local otherCfg = {
    { Name="忍者传奇", Items={
        {Name="忍者传奇", URL="https://pastebin.com/raw/2UjrXwTV"}
    }},
    { Name="极速传奇", Items={
        {Name="青脚本", URL="https://raw.githubusercontent.com/kkaaccnnbb/money/main/fix"},
        {Name="脚本二", URL="https://raw.githubusercontent.com/boyscp/beta/main/%E9%80%9F%E5%BA%A6%E8%B7%91.lua"},
        {Name="脚本三", URL="https://raw.githubusercontent.com/TrixAde/Proxima-Hub/main/Main.lua"},
        {Name="剑客v3", URL="https://raw.githubusercontent.com/jiankeQWQ/jiankeV3/main/jianke_V3"}
    }},
    { Name="鲨口求生2", Items={
        {Name="自动杀鲨鱼🦈", URL="https://raw.githubusercontent.com/Sw1ndlerScripts/RobloxScripts/main/Misc%20Scripts/sharkbite2.lua"}
    }, Dropdown={
        Name="免费船只", Default="1",
        Options={"DuckyBoatBeta","DuckyBoat","BlueCanopyMotorboat","BlueWoodenMotorboat","UnicornBoat","Jetski","RedMarlin","Sloop","TugBoat","SmallDinghyMotorboat","JetskiDonut","Marlin","TubeBoat","FishingBoat","VikingShip","SmallWoodenSailboat","RedCanopyMotorboat","Catamaran","CombatBoat","TourBoat","Duckmarine","PartyBoat","MilitarySubmarine","GingerbreadSteamBoat","Sleigh2022","Snowmobile","CruiseShip"},
        Callback=function(v)
            pcall(function()
                game:GetService("ReplicatedStorage").EventsFolder.BoatSelection.UpdateHostBoat:FireServer(v)
            end)
        end
    }},
    { Name="自然灾害生存", Items={
        {Name="LKB黑洞脚本", URL="https://pastebin.com/raw/wBsi24w3"}
    }},
    { Name="破坏者谜团2", Items={
        {Name="Yungengxin汉化脚本（推荐）", URL="https://pastebin.com/raw/ccrTkysZ"},
        {Name="阿龙汉化--破坏者谜团2", URL="https://pastebin.com/raw/eKvBgRKY"}
    }},
    { Name="一次尘土飞扬的旅行",
      Section="注：此脚本需要卡密，加载时间可能较长（30秒左右）请耐心等待",
      Items={{Name="a dusty trip---v1.1.9", URL="https://raw.githubusercontent.com/artemy133563/Utilities/main/ADustyTrip"}}},
    { Name="力量传奇", Items={
        {Name="Muscle Legend V2", URL="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"}
    }},
    { Name="伐木大亨", Items={
        {Name="Xploit v1.25 ato汉化", URL="https://pastebin.com/raw/4y0XQ3qY"},
        {Name="Shiro's Hub", URL="https://pastebin.com/raw/aKPGpJj5"},
        {Name="伐木---传送UI", URL="https://pastebin.com/raw/Z1B9aq2N"},
        {Name="伐木大亨 宝盒＋", URL="https://pastebin.com/raw/9U79wwvB"}
    }},
    { Name="FPS射击游戏通用", Items={
        {Name="自瞄＋子追", URL="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {Name="自瞄＋各种功能---Bullshit", URL="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
        {Name="Aimbot FPS修改数据（不稳定）", URL="https://raw.githubusercontent.com/Actyrn/Scripts/main/AzureModded"}
    }},
    { Name="Blox Fruit",
      Section="此脚本需要卡密，加载时间较长，请耐心等待。",
      Items={
        {Name="HOHO HUB", URL="https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"},
        {Name="Chiba Hub", URL="https://raw.githubusercontent.com/KindIhave/ChibaHuB/main/Chiba-BF.txt"}
    }},
    { Name="巴掌大战", Items={
        {Name="POG_巴掌", URL="https://gitee.com/POGPOG/pog/raw/master/THE_POG/gameS/lib.lua"}
    }},
    { Name="Fisch",
      Section="此脚本需要卡密，加载时间较长，请耐心等待。",
      Items={
        {Name="Fisch PROJECT", URL="https://raw.githubusercontent.com/xZPUHigh/Project-Spectrum/main/Loader.lua"},
        {Name="Fisch 自动钓鱼＋自动卖鱼", URL="https://github.com/XiaoYunUwU/XiaoYunUwU/raw/main/Script%2FFisch%20CN%20Version"}
    }},
    { Name="恐鬼症", Items={{Name="恐鬼症-脚本", URL="https://raw.githubusercontent.com/wdwahDWGU/DWAHUBUHD/refs/heads/main/MSDUIWQQWD"}}},
    { Name="恶魔学", Items={{Name="恶魔学-脚本", URL="https://raw.githubusercontent.com/wdwahDWGU/DWAHUBUHD/refs/heads/main/WDVHQVEH"}}},
    { Name="逃脱", Items={{Name="逃脱-脚本", URL="https://raw.githubusercontent.com/wdwahDWGU/DWAHUBUHD/refs/heads/main/EvadEDHUWEBA"}}},
    { Name="流亡", Items={{Name="流亡-脚本", URL="https://raw.githubusercontent.com/wdwahDWGU/DWAHUBUHD/refs/heads/main/EXILEDDHUA"}}},
    { Name="妄想办公室", Items={{Name="妄想办公室-脚本", URL="https://raw.githubusercontent.com/wdwahDWGU/DWAHUBUHD/refs/heads/main/DelusionalUWEBGJBD"}}},
    { Name="被遗弃", Items={{Name="被遗弃-脚本", URL="https://raw.githubusercontent.com/SilkScripts/AppleStuff/refs/heads/main/AppleFSKV2"}}}
}

for _, cfg in ipairs(otherCfg) do
    local tab = Window:MakeTab({Name=cfg.Name, Icon="rbxassetid://4483345998", PremiumOnly=false})
    if cfg.Section then tab:AddSection({Name=cfg.Section}) end
    if cfg.Dropdown then tab:AddDropdown(cfg.Dropdown) end
    for _, item in ipairs(cfg.Items) do
        tab:AddButton({
            Name=item.Name,
            Callback=function() U.load(item.URL) end
        })
    end
end

-- ============ 初始化 UI ============
OrionLib:Init()
