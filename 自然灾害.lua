--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
    KHENZ // Billboard 500K Loop — Anti-Lag Edition
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

_G.ANTI_PURCHASE = false
_G.FPS_GUARD = true
_G.AUTO_UNSPAM = true

local THEME = {
    bg      = Color3.fromRGB(15, 15, 20),
    bg_card = Color3.fromRGB(24, 24, 32),
    bg_input= Color3.fromRGB(34, 34, 44),
    accent  = Color3.fromRGB(0, 220, 180),
    purple  = Color3.fromRGB(140, 100, 255),
    danger  = Color3.fromRGB(240, 70, 90),
    gold    = Color3.fromRGB(255, 200, 60),
    warn    = Color3.fromRGB(255, 180, 60),
    text    = Color3.fromRGB(235, 235, 245),
}

-- FIX 500K (TURUN DARI 1M) + RADIUS AUTO
local FIXED_LOOP = 500000
local FIXED_BATCH = 2500
local CLICK_RADIUS = 5000

local State = {
    spamEnabled = false,
    loopCount = FIXED_LOOP,
    batchSize = FIXED_BATCH,
    successCount = 0,
    blockedCount = 0,
    detectors = {},
    fps = 60,
    fpsHistory = {},
    normalFpsCounter = 0,
    unspamActive = false,
}

local function log(msg)
    print("[KHENZ] " .. msg)
end

-- ============ FPS TRACKER ============
local frameCount = 0
local lastFpsUpdate = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastFpsUpdate >= 0.5 then
        local elapsed = now - lastFpsUpdate
        local currentFPS = math.floor(frameCount / elapsed)
        State.fps = currentFPS
        table.insert(State.fpsHistory, currentFPS)
        if #State.fpsHistory > 6 then table.remove(State.fpsHistory, 1) end
        frameCount = 0
        lastFpsUpdate = now
    end
end)

local function avgFPS()
    if #State.fpsHistory == 0 then return State.fps end
    local sum = 0
    for _, v in ipairs(State.fpsHistory) do sum = sum + v end
    return math.floor(sum / #State.fpsHistory)
end

-- ============ AUTO UNSPAM ============
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AUTO_UNSPAM and State.spamEnabled then
            local fps = avgFPS()
            if fps > 50 then
                State.normalFpsCounter = State.normalFpsCounter + 1
                if State.normalFpsCounter >= 5 then
                    State.unspamActive = true
                    log("AUTO UNSPAM: 5s")
                    task.wait(5)
                    State.unspamActive = false
                    State.normalFpsCounter = 0
                    log("AUTO UNSPAM: done")
                end
            else
                State.normalFpsCounter = 0
            end
        end
    end
end)

-- ============ AUTO-SCAN BILLBOARD ============
local function detectBillboardDetectors()
    local detectors = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("billboard") then
            local board = obj:FindFirstChild("Board")
            if board then
                local cd = board:FindFirstChild("ClickDetector")
                if cd and cd:IsA("ClickDetector") then
                    table.insert(detectors, cd)
                end
            end
            for _, v in ipairs(obj:GetDescendants()) do
                if v:IsA("ClickDetector") then
                    table.insert(detectors, v)
                end
            end
        end
    end
    if #detectors == 0 then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ClickDetector") and v.Parent then
                local p = v.Parent
                local gp = p.Parent
                if p.Name:lower():find("board")
                   or (gp and gp.Name:lower():find("board"))
                   or (gp and gp.Name:lower():find("billboard")) then
                    table.insert(detectors, v)
                end
            end
        end
    end
    return detectors
end

task.spawn(function()
    while true do
        State.detectors = detectBillboardDetectors()
        task.wait(2)
    end
end)

-- ============ SPAM LOOP — 500K ============
task.spawn(function()
    while true do
        if State.spamEnabled and #State.detectors > 0 and not State.unspamActive then
            local fps = avgFPS()
            local curLoop = FIXED_LOOP
            local curBatch = FIXED_BATCH

            if _G.FPS_GUARD then
                if fps < 15 then
                    task.wait(1)
                    local waitCount = 0
                    while avgFPS() < 20 and waitCount < 10 do
                        task.wait(0.5)
                        waitCount = waitCount + 1
                    end
                elseif fps < 30 then
                    curLoop = 50000
                    curBatch = 250
                elseif fps < 50 then
                    curLoop = 250000
                    curBatch = 1000
                end
            end

            local batch = 0
            for i = 1, curLoop do
                if not State.spamEnabled or State.unspamActive then break end
                if i % 1000 == 0 and _G.FPS_GUARD and avgFPS() < 15 then break end

                for _, cd in ipairs(State.detectors) do
                    pcall(function()
                        fireclickdetector(cd, CLICK_RADIUS, 1)
                    end)
                    State.successCount = State.successCount + 1
                    batch = batch + 1
                end

                if batch >= curBatch then
                    batch = 0
                    task.wait()
                end
            end

            task.wait()
        else
            task.wait(0.05)
        end
    end
end)

-- ============ ANTI PURCHASE ============
local function disablePrompt()
    pcall(function()
        local prompt = CoreGui:FindFirstChild("PurchasePromptApp")
        if prompt and prompt.Enabled then
            prompt.Enabled = false
            State.blockedCount = State.blockedCount + 1
        end
    end)
    pcall(function()
        local overlay = CoreGui:FindFirstChild("FoundationOverlay")
        if overlay and overlay.Enabled then
            overlay.Enabled = false
        end
    end)
end

RunService.RenderStepped:Connect(function()
    if _G.ANTI_PURCHASE then disablePrompt() end
end)

CoreGui.ChildAdded:Connect(function(ins)
    if _G.ANTI_PURCHASE and (ins.Name == "PurchasePromptApp" or ins.Name == "FoundationOverlay") then
        task.wait(0.05)
        pcall(function() ins.Enabled = false end)
    end
end)

CoreGui.DescendantAdded:Connect(function(ins)
    if _G.ANTI_PURCHASE and (ins.Name == "PurchasePromptApp" or ins.Name == "FoundationOverlay") then
        task.wait(0.05)
        pcall(function() ins.Enabled = false end)
    end
end)

-- ============ GUI ============
if CoreGui:FindFirstChild("KHENZ_Billboard") then CoreGui.KHENZ_Billboard:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "KHENZ_Billboard"
gui.ResetOnSpawn = false
gui.DisplayOrder = 9999
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 280)
main.Position = UDim2.new(0, 20, 0.5, -140)
main.BackgroundColor3 = THEME.bg
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local stroke = Instance.new("UIStroke")
stroke.Color = THEME.danger
stroke.Transparency = 0.5
stroke.Thickness = 1.5
stroke.Parent = main

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 28)
topbar.BackgroundColor3 = THEME.bg_card
topbar.BorderSizePixel = 0
topbar.Active = true
topbar.Parent = main
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 10)

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -60, 1, 0)
titleLbl.Position = UDim2.new(0, 10, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "BILLBOARD 500K"
titleLbl.TextColor3 = THEME.danger
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 11
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topbar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
closeBtn.BackgroundColor3 = THEME.bg_input
closeBtn.TextColor3 = THEME.danger
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 11
closeBtn.Text = "X"
closeBtn.Parent = topbar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local dragging, dragStart, startPos
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
    end
end)
topbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                     or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                  startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -12, 1, -36)
body.Position = UDim2.new(0, 6, 0, 32)
body.BackgroundTransparency = 1
body.Parent = main

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 44)
statusLbl.BackgroundColor3 = THEME.bg_card
statusLbl.TextColor3 = THEME.text
statusLbl.Font = Enum.Font.Code
statusLbl.TextSize = 9
statusLbl.TextYAlignment = Enum.TextYAlignment.Top
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Text = "spam: 0 | block: 0\nFPS: 60 | loop: 500K\nradius: 5000"
statusLbl.Parent = body
Instance.new("UICorner", statusLbl).CornerRadius = UDim.new(0, 5)

task.spawn(function()
    while statusLbl.Parent do
        task.wait(0.5)
        local fps = avgFPS()
        local status = ""
        if State.unspamActive then status = " ⏸"
        elseif fps < 30 then status = " ⚠" end

        statusLbl.Text = string.format(
            "spam: %d | block: %d\nFPS: %d | loop: 500K%s\nradius: %d",
            State.successCount, State.blockedCount, fps, status, CLICK_RADIUS
        )
    end
end)

local btnHolder = Instance.new("Frame")
btnHolder.Size = UDim2.new(1, 0, 1, -50)
btnHolder.Position = UDim2.new(0, 0, 0, 50)
btnHolder.BackgroundTransparency = 1
btnHolder.Parent = body
local btnList = Instance.new("UIListLayout")
btnList.Padding = UDim.new(0, 4)
btnList.Parent = btnHolder

local function makeBtn(text, color, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = color
    b.TextColor3 = THEME.bg
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = btnHolder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b:SetAttribute("CurrentColor", color)

    b.MouseEnter:Connect(function()
        local c = b:GetAttribute("CurrentColor") or color
        TweenService:Create(b, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.new(math.min(c.R + 0.15, 1),
                                          math.min(c.G + 0.15, 1),
                                          math.min(c.B + 0.15, 1))
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        local c = b:GetAttribute("CurrentColor") or color
        TweenService:Create(b, TweenInfo.new(0.1), { BackgroundColor3 = c }):Play()
    end)
    b.MouseButton1Click:Connect(function() callback(b) end)
    return b
end

local spamBtn = makeBtn("SPAM: OFF", THEME.bg_input, function(btn)
    State.spamEnabled = not State.spamEnabled
    if State.spamEnabled then
        btn.Text = "SPAM: ON (500K)"
        btn.BackgroundColor3 = THEME.danger
        btn.TextColor3 = THEME.bg
        btn:SetAttribute("CurrentColor", THEME.danger)
    else
        btn.Text = "SPAM: OFF"
        btn.BackgroundColor3 = THEME.bg_input
        btn.TextColor3 = THEME.text
        btn:SetAttribute("CurrentColor", THEME.bg_input)
    end
end)
spamBtn.TextColor3 = THEME.text

local antiBtn = makeBtn("ANTI PURCHASE: OFF", THEME.bg_input, function(btn)
    _G.ANTI_PURCHASE = not _G.ANTI_PURCHASE
    if _G.ANTI_PURCHASE then
        btn.Text = "ANTI PURCHASE: ON"
        btn.BackgroundColor3 = THEME.danger
        btn.TextColor3 = THEME.bg
        btn:SetAttribute("CurrentColor", THEME.danger)
        disablePrompt()
    else
        btn.Text = "ANTI PURCHASE: OFF"
        btn.BackgroundColor3 = THEME.bg_input
        btn.TextColor3 = THEME.text
        btn:SetAttribute("CurrentColor", THEME.bg_input)
    end
end)
antiBtn.TextColor3 = THEME.text

local fpsBtn = makeBtn("FPS GUARD: ON", THEME.warn, function(btn)
    _G.FPS_GUARD = not _G.FPS_GUARD
    btn.Text = "FPS GUARD: " .. (_G.FPS_GUARD and "ON" or "OFF")
    btn.BackgroundColor3 = _G.FPS_GUARD and THEME.warn or THEME.bg_input
    btn.TextColor3 = _G.FPS_GUARD and THEME.bg or THEME.text
    btn:SetAttribute("CurrentColor", _G.FPS_GUARD and THEME.warn or THEME.bg_input)
end)
fpsBtn.TextColor3 = THEME.bg

local unspamBtn = makeBtn("AUTO UNSPAM: ON", THEME.accent, function(btn)
    _G.AUTO_UNSPAM = not _G.AUTO_UNSPAM
    btn.Text = "AUTO UNSPAM: " .. (_G.AUTO_UNSPAM and "ON" or "OFF")
    btn.BackgroundColor3 = _G.AUTO_UNSPAM and THEME.accent or THEME.bg_input
    btn.TextColor3 = _G.AUTO_UNSPAM and THEME.bg or THEME.text
    btn:SetAttribute("CurrentColor", _G.AUTO_UNSPAM and THEME.accent or THEME.bg_input)
end)
unspamBtn.TextColor3 = THEME.bg

makeBtn("FORCE UNSPAM 5s", THEME.purple, function()
    task.spawn(function()
        State.unspamActive = true
        log("FORCE UNSPAM: 5s")
        task.wait(5)
        State.unspamActive = false
        log("FORCE UNSPAM: done")
    end)
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("[KHENZ] Billboard 500K loaded. Anti-lag.")