-- ========================================================
-- 1. Load Fluent UI Library
-- ========================================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "Game Hub - Special Script",
    SubTitle = "by AI Assistant",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab({ Title = "Main Features", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Services & Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera

-- Global Feature States
local WalkSpeedMultiplier = 1
local InfiniteJumpEnabled = false
local ESPEnabled = false
local LockFOV350Enabled = false
local CustomFOVValue = 70
local AntiLockEnabled = false
local AntiBanEnabled = false
local EventLoopEnabled = false

-- ========================================================
-- 2. Local Event System (SpawnGalaxyBlock)
-- ========================================================
Tabs.Main:AddSection("Event System")

local EventToggle = Tabs.Main:AddToggle("SpawnGalaxyEvent", {
    Title = "เปิด/ปิด Auto Spawn Galaxy Block",
    Default = false
})

EventToggle:OnChanged(function(Value)
    EventLoopEnabled = Value
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if EventLoopEnabled then
            pcall(function()
                local event = ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock")
                if event and event:IsA("RemoteEvent") then
                    event:FireServer()
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Functions Options")

-- ========================================================
-- ฟังก์ชันที่ 1: วิ่งไว ปรับได้ 1 ถึง 10
-- ========================================================
local SpeedSlider = Tabs.Main:AddSlider("WalkSpeedSlider", {
    Title = "1. วิ่งไว (Speed Multiplier)",
    Description = "ปรับความเร็วตั้งแต่ 1 ถึง 10 เท่า",
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1
})

SpeedSlider:OnChanged(function(Value)
    WalkSpeedMultiplier = Value
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            -- Base Speed standard is 16
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 * WalkSpeedMultiplier
        end
    end)
end)

-- ========================================================
-- ฟังก์ชันที่ 2: กระโดดไม่จำกัด (Infinite Jump)
-- ========================================================
local JumpToggle = Tabs.Main:AddToggle("InfJump", {
    Title = "2. กระโดดไม่จำกัด (Infinite Jump)",
    Default = false
})

JumpToggle:OnChanged(function(Value)
    InfiniteJumpEnabled = Value
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ========================================================
-- ฟังก์ชันที่ 3: ดูคนทั้งแมพ (ESP Name & Highlight)
-- ========================================================
local ESPToggle = Tabs.Main:AddToggle("PlayerESP", {
    Title = "3. ดูคนทั้งแมพ (ESP All Players)",
    Default = false
})

ESPToggle:OnChanged(function(Value)
    ESPEnabled = Value
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("ESPHighlight")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "ESPHighlight"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

-- ========================================================
-- ฟังก์ชันที่ 4: ล็อค FOV 350 ล็อคแค่ศัตรู (Aimlock / Cam Target)
-- ========================================================
local LockFOVToggle = Tabs.Main:AddToggle("LockFOV350", {
    Title = "4. ล็อค FOV 350 (ล็อคแค่ศัตรู)",
    Default = false
})

LockFOVToggle:OnChanged(function(Value)
    LockFOV350Enabled = Value
end)

local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = 350 -- FOV Distance Radius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- เช็ค Team (ถ้าเกมไม่มีระบบทีม ทุกคนจะถูกมองเป็นศัตรู)
            if player.Team == nil or player.Team ~= LocalPlayer.Team then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if LockFOV350Enabled then
        local target = GetClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ========================================================
-- ฟังก์ชันที่ 5: FOV ปรับได้ 1 ถึง 350
-- ========================================================
local FOVSlider = Tabs.Main:AddSlider("CustomFOVSlider", {
    Title = "5. FOV กล้อง (ปรับได้ 1 - 350)",
    Description = "ปรับระยะซูม Field of View",
    Default = 70,
    Min = 1,
    Max = 350,
    Rounding = 0
})

FOVSlider:OnChanged(function(Value)
    CustomFOVValue = Value
end)

RunService.RenderStepped:Connect(function()
    if not LockFOV350Enabled then
        Camera.FieldOfView = CustomFOVValue
    end
end)

-- ========================================================
-- ฟังก์ชันที่ 6: กันล็อค หมุนตัวละคร (Anti-Lock / Desync Spin)
-- ========================================================
local AntiLockToggle = Tabs.Main:AddToggle("AntiLockSpin", {
    Title = "6. กันล็อคทุกอย่าง (หมุนตัวละคร 360° หลบกระสุน)",
    Default = false
})

AntiLockToggle:OnChanged(function(Value)
    AntiLockEnabled = Value
end)

local spinAngle = 0
RunService.Heartbeat:Connect(function()
    if AntiLockEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        spinAngle = (spinAngle + 50) % 360
        -- หมุน CFrame อย่างรวดเร็ว ทำให้วิถีกระสุนและสคริปต์ล็อคพิกัดพลาดเป้า
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spinAngle), 0)
    end
end)

-- ========================================================
-- ฟังก์ชันที่ 7: กันแบน กันดำ (Anti-Ban / Anti-Kick Hook)
-- ========================================================
local AntiBanToggle = Tabs.Main:AddToggle("AntiBanSystem", {
    Title = "7. กันแบน / กันจอดำ (Anti-Ban Bypass)",
    Default = false
})

AntiBanToggle:OnChanged(function(Value)
    AntiBanEnabled = Value
    if AntiBanEnabled then
        -- Hooking Kick function to prevent client-side ban/kick
        local rawMetatable = getrawmetatable(game)
        if setreadonly then setreadonly(rawMetatable, false) end
        
        local oldNamecall = rawMetatable.__namecall
        rawMetatable.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if AntiBanEnabled and (method == "Kick" or method == "kick") then
                Fluent:Notify({
                    Title = "Anti-Ban Protection",
                    Content = "บล็อกการเตะออกจากเซิร์ฟเวอร์เรียบร้อย!",
                    Duration = 3
                })
                return nil
            end
            return oldNamecall(self, ...)
        end)
        
        if setreadonly then setreadonly(rawMetatable, true) end
    end
end)

-- Setup Config Save Systems
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Loaded Success!",
    Content = "สคริปต์พร้อมใช้งานแล้ว กด Left-Control เพื่อเปิด/ปิด GUI",
    Duration = 5
})
