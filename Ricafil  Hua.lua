-- =================================================================
-- 1. LOAD VOID UI LIBRARY & INITIALIZE CONFIG
-- =================================================================
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/ui-libraries/main/drawing/void/source.lua"))()

local main = library:Load{
    Name = "Void Hub | Automation",
    SizeX = 600,
    SizeY = 650,
    Theme = "Midnight",
    Extension = "json",
    Folder = "VoidConfig"
}

-- Global Settings Setup
getgenv().AttackConfig = {
    AutoAttackEnabled = false,
    WeaponType = "Melee",
    AttackDelay = 0.03,
    FastAttackSpeed = 5,
    AttackRange = 55,
    TargetDistanceOffset = 8
}

getgenv().ArmorProgression = {
    CurrentTier = 1,
    AutoEquipNextTier = true,
    Tiers = {
        [1] = { ItemName = "Pink Coat", BossName = "Swan" },
        [2] = { ItemName = "Cool Shades", BossName = "Cyborg" },
        [3] = { ItemName = "Black Spike Coat", BossName = "Jeremy" },
        [4] = { ItemName = "Swan Glasses", BossName = "Don Swan" },
        [5] = { ItemName = "Valkyrie Helm", BossName = "rip_indra" }
    }
}

-- =================================================================
-- 2. CORE HELPER FUNCTIONS
-- =================================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Movement (Tween)
local function tweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local info = TweenInfo.new(distance / (speed or 300), Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, info, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- Nearest Target Finder
local function getNearestEnemy()
    local enemyFolder = workspace:FindFirstChild("Enemies")
    if not enemyFolder then return nil end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

    local closest, shortest = nil, math.huge
    for _, enemy in pairs(enemyFolder:GetChildren()) do
        local hum = enemy:FindFirstChild("Humanoid")
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then
            local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = enemy
            end
        end
    end
    return closest
end

-- Weapon Equip & Attack Engine
local function executeConfiguredAttack(target)
    local cfg = getgenv().AttackConfig
    if not cfg.AutoAttackEnabled or not target then return end

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp or (char.HumanoidRootPart.Position - hrp.Position).Magnitude > cfg.AttackRange then return end

    -- Auto-Equip Weapon Type
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local currentTool = char:FindFirstChildOfClass("Tool")
    local isEquipped = currentTool and currentTool:FindFirstChild("ToolTip") and string.find(string.lower(currentTool.ToolTip.Value), string.lower(cfg.WeaponType))

    if not isEquipped and backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("ToolTip") and string.find(string.lower(tool.ToolTip.Value), string.lower(cfg.WeaponType)) then
                char.Humanoid:EquipTool(tool)
                currentTool = tool
                break
            end
        end
    end

    -- Fast Animation Boost
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid:FindFirstChildOfClass("Animator") then
        for _, track in pairs(humanoid.Animator:GetPlayingAnimationTracks()) do
            track:AdjustSpeed(cfg.FastAttackSpeed)
        end
    end

    -- Hit Fire
    if currentTool then
    
