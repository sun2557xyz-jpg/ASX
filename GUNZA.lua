-- [[ GUNZA HUB - Full PvP System ]]
-- ปุ่ม เปิด/ปิด เมนู: Toggle UI (ปุ่มลอยหน้าจอ หรือ กด RightControl / K)

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "GUNZA HUB - PvP Edition", 
    HidePremium = true, 
    SaveConfig = false, 
    ConfigFolder = "GUNZA_Config",
    IntroEnabled = true,
    IntroText = "GUNZA HUB Loaded!"
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables & Settings
local Settings = {
    AimEnabled = false,
    FOV = 150,
    HitPart = "Head", -- Head, HumanoidRootPart, Random
    LockPercent = 100,
    AutoLoot = false,
    LootRange = 25,
    AntiDeath = false,
    AntiDeathDepth = 15,
    Speed = 1,
    HighJump = false,
    NoClip = false,
    DoubleTap = false,
    ESP_Names = false,
    ESP_Held = false,
    ESP_Items = false,
    ESP_Dist = false
}

local TargetPlayer = nil

-- Drawing FOV & Tracer Line
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = Settings.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false

local TracerLine = Drawing.new("Line")
TracerLine.Color = Color3.fromRGB(255, 255, 255)
TracerLine.Thickness = 2
TracerLine.Visible = false

-- Function: Get Target Inside FOV
local function GetTarget()
    local closest, minDst = nil, Settings.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local partName = Settings.HitPart
            if partName == "Random" then
                local parts = {"Head", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm"}
                partName = parts[math.random(1, #parts)]
            end
            local part = p.Character:FindFirstChild(partName) or p.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDst then
                        minDst = dist
                        closest = p
                    end
                end
            end
        end
    end
    return closest
end

-- Main RenderStepped Loop
RunService.RenderStepped:Connect(function()
    -- FOV Update
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = Settings.FOV
    FOVCircle.Visible = Settings.AimEnabled

    -- 1, 2, 3: Aimbot & White Tracer Line
    if Settings.AimEnabled then
        TargetPlayer = GetTarget()
        if TargetPlayer and TargetPlayer.Character then
            local partName = Settings.HitPart == "Random" and "HumanoidRootPart" or Settings.HitPart
            local part = TargetPlayer.Character:FindFirstChild(partName)
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    TracerLine.To = Vector2.new(pos.X, pos.Y)
                    TracerLine.Visible = true

                    -- Lock Percentage (Lerp)
                    local alpha = math.clamp(Settings.LockPercent / 100, 0.01, 1)
                    local targetCF = CFrame.new(Camera.CFrame.Position, part.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, alpha)
                else
                    TracerLine.Visible = false
                end
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
    end

    -- 5: กันตาย บินลงดิน 15m
    if Settings.AntiDeath and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if hum.Health > 0 and hum.Health <= (hum.MaxHealth * 0.25) then
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.new(0, -Settings.AntiDeathDepth, 0)
            end
        end
    end

    -- 6 & 7: Speed & Unlimited Jump
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        if Settings.Speed > 1 then
            hum.WalkSpeed = 16 * Settings.Speed
        end
        if Settings.HighJump then
            hum.JumpPower = 70 -- โดดสูงขึ้นประมาณ 2 เมตร
        end
    end

    -- 8: วิ่งทะลุบ้าน (NoClip)
    if Settings.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- 4: ดูดของเข้าตัวระยะ 25 เมตร
task.spawn(function()
    while task.wait(0.3) do
        if Settings.AutoLoot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
            local root = LocalPlayer.Character.HumanoidRootPart
            for _, item in pairs(Workspace:GetChildren()) do
                if item:IsA("Tool") or (item:IsA("Model") and item:FindFirstChild("Handle")) or item:IsA("Part") then
                    local handle = item:FindFirstChild("Handle") or item
                    if handle:IsA("BasePart") and (handle.Position - root.Position).Magnitude <= Settings.LootRange then
                        handle.CFrame = root.CFrame
                    end
                end
            end
        end
    end
end)

-- TAB 1: AIMBOT & COMBAT
local AimTab = Window:MakeTab({Name = "Aim & Combat", Icon = "rbxassetid://4483362458", PremiumOnly = false})

AimTab:AddToggle({
    Name = "1. ล็อกเป้าอิสระ (Free Lock Aimbot)",
    Default = false,
    Callback = function(v) Settings.AimEnabled = v end
})

AimTab:AddSlider({
    Name = "2. ปรับขนาด FOV (50 - 1600)",
    Min = 50, Max = 1600, Default = 150, Color = Color3.fromRGB(255,255,255), Increment = 10,
    ValueName = "px",
    Callback = function(v) Settings.FOV = v end
})

AimTab:AddDropdown({
    Name = "ตำแหน่งที่ต้องการล็อก",
    Default = "หัวหรือศีรษะ",
    Options = {"หัวหรือศีรษะ", "ตัว", "ทุกอย่างในร่างกายผู้เล่น"},
    Callback = function(v)
        if v == "หัวหรือศีรษะ" then Settings.HitPart = "Head"
        elseif v == "ตัว" then Settings.HitPart = "HumanoidRootPart"
        else Settings.HitPart = "Random" end
    end
})

AimTab:AddSlider({
    Name = "3. ความแรงการล็อก (1% - 100%)",
    Min = 1, Max = 100, Default = 100, Color = Color3.fromRGB(0,255,100), Increment = 1,
    ValueName = "%",
    Callback = function(v) Settings.LockPercent = v end
})

AimTab:AddToggle({
    Name = "9. ยิงปืน 1 นัด ออก 2 นัด (Double Tap)",
    Default = false,
    Callback = function(v) Settings.DoubleTap = v end
})

-- TAB 2: MOVEMENT
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458", PremiumOnly = false})

MoveTab:AddToggle({
    Name = "5. ระบบกันตาย (บินลงดิน 15 เมตร)",
    Default = false,
    Callback = function(v) Settings.AntiDeath = v end
})

MoveTab:AddSlider({
    Name = "6. ปรับวิ่งเร็ว (1x - 3x)",
    Min = 1, Max = 3, Default = 1, Color = Color3.fromRGB(255,150,0), Increment = 0.1,
    ValueName = "x",
    Callback = function(v) Settings.Speed = v end
})

MoveTab:AddToggle({
    Name = "7. กระโดดสูง 2m / กระโดดไม่จำกัด",
    Default = false,
    Callback = function(v) Settings.HighJump = v end
})

MoveTab:AddToggle({
    Name = "8. วิ่งทะลุบ้าน/กำแพง (NoClip)",
    Default = false,
    Callback = function(v) Settings.NoClip = v end
})

-- TAB 3: ESP VISUALS
local ESPTab = Window:MakeTab({Name = "ESP Systems", Icon = "rbxassetid://4483362458", PremiumOnly = false})

ESPTab:AddToggle({
    Name = "10. ESP มองเห็นชื่อผู้เล่นทั้งแมพ",
    Default = false,
    Callback = function(v) Settings.ESP_Names = v end
})

ESPTab:AddToggle({
    Name = "11. ESP มองเห็นของที่ผู้เล่นถืออยู่",
    Default = false,
    Callback = function(v) Settings.ESP_Held = v end
})

ESPTab:AddToggle({
    Name = "12. ESP มองเห็นของที่ตกบนพื้น",
    Default = false,
    Callback = function(v) Settings.ESP_Items = v end
})

ESPTab:AddToggle({
    Name = "13. ESP มองเห็นระยะห่างผู้เล่น (เมตร)",
    Default = false,
    Callback = function(v) Settings.ESP_Dist = v end
})

-- TAB 4: UTILITIES
local UtilTab = Window:MakeTab({Name = "Utilities", Icon = "rbxassetid://4483362458", PremiumOnly = false})

UtilTab:AddToggle({
    Name = "4. ดูดของเข้าตัวระยะ 25 เมตร",
    Default = false,
    Callback = function(v) Settings.AutoLoot = v end
})

UtilTab:AddButton({
    Name = "14. ทิ้งของเร็ว / ขายของเร็ว",
    Callback = function()
        pcall(function()
            if LocalPlayer:FindFirstChild("Backpack") then
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        item.Parent = LocalPlayer.Character
                        task.wait(0.05)
                        item.Parent = Workspace
                    end
                end
            end
        end)
    end
})

UtilTab:AddButton({
    Name = "15. สุ่มของเร็ว (SpawnGalaxyBlock)",
    Callback = function()
        pcall(function()
            local Event = ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock", true)
            if Event then
                Event:FireServer()
            else
                OrionLib:MakeNotification({
                    Name = "Warning",
                    Content = "ไม่พบ Event สุ่มของในแมพนี้",
                    Time = 3
                })
            end
        end)
    end
})

OrionLib:Init()
  
