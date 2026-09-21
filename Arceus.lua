--[[
    内容创作者大亨服务器 - Arceus X 高级整合版
    特性：
    1. 高级加载器：自动读取仓库里的 Obsidian.lua，如果找不到则尝试联网下载。
    2. 防踢防卡：只抓身边 35 格内的红圈，绝不乱改属性。
    3. 智能过滤：自动跳过“上传/发布/Upload/Publish”相关的红圈。
    4. 功能全面：自动互动、速度修改、过检测、一键开关。
--]]

print("===== [高级版] 启动中 =====")

-- ============================================================
-- 第一步：高级 UI 加载器 (适配 Arceus X)
-- ============================================================
local function LoadObsidian()
    -- 优先尝试从仓库（本地文件）读取
    local paths = {"Obsidian.lua", "Arceus X/Workspace/Obsidian.lua", "Scripts/Obsidian.lua"}
    for _, path in ipairs(paths) do
        if isfile and isfile(path) then
            local ok, code = pcall(readfile, path)
            if ok and code then
                local success, lib = pcall(loadstring(code))
                if success and lib then
                    print("[加载器] 成功从仓库读取: " .. path)
                    return lib
                end
            end
        end
    end

    -- 如果仓库没有，尝试联网下载并保存到仓库
    print("[加载器] 仓库未找到 UI，尝试联网下载...")
    local url = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Obsidian.lua"
    local ok, code = pcall(game.HttpGet, game, url)
    if ok and code then
        if writefile then pcall(writefile, "Obsidian.lua", code) end
        local success, lib = pcall(loadstring(code))
        if success and lib then
            print("[加载器] 联网下载并加载成功！")
            return lib
        end
    end

    -- 彻底失败
    return nil
end

local Library = LoadObsidian()
if not Library then
    warn("致命错误：无法加载黑曜石UI，请检查网络或文件！")
    return
end

-- ============================================================
-- 第二步：初始化窗口 (使用高级防护)
-- ============================================================
-- Arceus X 专用防隐藏父级
local parent = gethui and gethui() or game:GetService("CoreGui")
if not pcall(function() local t = parent.Name end) then
    parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local Window = Library:CreateWindow({
    Title = "创作大亨 工具",
    Footer = "Arceus X 高级版",
    Icon = "gamepad-2",
    NotifySide = "Right",
    ToggleKeybind = Enum.KeyCode.F, -- 按 F 键开关界面
})

local MainTab = Window:AddTab("自动互动", "home")
local MainGroup = MainTab:AddLeftGroupbox("自动录制 (跳过上传)")

-- ============================================================
-- 第三步：核心逻辑（只抓身边能抓的 + 跳过上传）
-- ============================================================
getgenv().AutoFarm_Running = false
getgenv().SkipUploadPoints = true
local RANGE = 35
local COOLDOWN = 2
local lastTrigger = {}

-- 智能识别上传点
local function isUploadPoint(obj)
    local text = string.lower(obj.ActionText .. " " .. obj.ObjectText)
    return string.find(text, "上传") or string.find(text, "upload") 
        or string.find(text, "发布") or string.find(text, "publish")
end

-- 安全触发主循环
task.spawn(function()
    while true do
        if getgenv().AutoFarm_Running then
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            if root then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not getgenv().AutoFarm_Running then break end
                    
                    if obj:IsA("ProximityPrompt") and obj.Enabled then
                        -- 核心过滤：跳过上传点
                        if getgenv().SkipUploadPoints and isUploadPoint(obj) then
                            continue
                        end

                        -- 计算距离
                        local part = obj.Parent
                        local pos = nil
                        if part:IsA("BasePart") then pos = part.Position
                        elseif part:IsA("Attachment") then pos = part.WorldPosition
                        elseif part:IsA("Model") then pos = part:GetPivot().Position end

                        if pos and (root.Position - pos).Magnitude <= RANGE then
                            local now = tick()
                            if now - (lastTrigger[obj] or 0) > COOLDOWN then
                                -- 只模拟按键，不改任何游戏属性
                                pcall(fireproximityprompt, obj)
                                lastTrigger[obj] = now
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================================
-- 第四步：UI 控件绑定
-- ============================================================

-- 开关：自动互动
MainGroup:AddToggle("autoFarmToggle", {
    Text = "开启自动互动 (只抓身边)",
    Default = false,
    Callback = function(state)
        getgenv().AutoFarm_Running = state
        Library:Notify({ Title = "自动互动", Description = state and "已开启，只抓身边红圈" or "已关闭", Time = 3 })
    end,
})

-- 开关：跳过上传点
MainGroup:AddToggle("skipUploadToggle", {
    Text = "跳过上传点 (防误触)",
    Default = true,
    Callback = function(state)
        getgenv().SkipUploadPoints = state
    end,
})

-- 滑块：范围调整
MainGroup:AddSlider("rangeSlider", {
    Text = "触发范围",
    Default = 35,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Suffix = " 格",
    Callback = function(val) RANGE = val end,
})

-- 滑块：冷却调整
MainGroup:AddSlider("cooldownSlider", {
    Text = "触发冷却",
    Default = 2,
    Min = 0.5,
    Max = 5,
    Rounding = 1,
    Suffix = " 秒",
    Callback = function(val) COOLDOWN = val end,
})

-- 右侧分组：角色属性
local PlayerGroup = MainTab:AddRightGroupbox("角色属性")
PlayerGroup:AddSlider("speedSlider", {
    Text = "跑步速度",
    Default = 200,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(val)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end,
})

-- 右侧分组：防作弊
local AcGroup = MainTab:AddRightGroupbox("防作弊")
AcGroup:AddButton("antiCheat", {
    Text = "执行过检测",
    Func = function()
        if not getconnections or not hookfunction then
            Library:Notify({ Title = "过检测", Description = "执行器不支持", Time = 3 })
            return
        end
        local SC = game:GetService("ScriptContext")
        local LS = game:GetService("LogService")
        local lp = game.Players.LocalPlayer

        -- 清理泄露执行器痕迹的监听器
        local function killCore(ev)
            local ok, cons = pcall(getconnections, ev)
            if not ok then return end
            for _, con in ipairs(cons) do
                local okf, fn = pcall(function() return con.Function end)
                if okf and fn then
                    local okI, info = pcall(debug.getinfo, fn)
                    local src = info and info.source or ""
                    if src:find("Framework.Core", 1, true) or src:find("GoogleAnalyticsHelper", 1, true) then
                        pcall(function() con:Disconnect() end)
                    end
                end
            end
        end
        killCore(SC.Error)
        killCore(LS.MessageOut)

        -- 拦截踢出事件
        pcall(function()
            hookfunction(lp.Kick, newcclosure(function() return end))
        end)
        
        Library:Notify({ Title = "过检测", Description = "执行完成，已拦截踢出", Time = 3 })
    end,
})

print("===== [高级版] 加载完毕，按 F 键呼出界面 =====")
