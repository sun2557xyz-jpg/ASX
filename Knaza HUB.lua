-- [[ Load Maclib UI Library ]] --
local Maclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodline-script/Maclib/main/maclib.lua"))()

-- [[ Services ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ Target Event ]] --
local SpawnGalaxyBlockEvent = ReplicatedStorage:WaitForChild("SpawnGalaxyBlock", 5)

-- [[ State Variables ]] --
local Config = {
    AutoSpawnBlock = false,
    WalkSpeedEnabled = false,
    WalkSpeedValue = 16, -- ค่าปกติ 16 (ปรับได้ 1-10 เท่า หรือ 16-160)
    InfiniteJump = false,
    ESP = false,
    AimbotEnabled = false,
    AimbotFOV = 350,
    ShowFOV = false,
    AntiLock = false,
    AntiBan = false
}

-- [[ FOV Circle Setup ]] --
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Visible = false

-- [[ Main Window Setup ]] --
local Window = Maclib:CreateWindow({
    Name = "Galaxy Hub | Maclib UI",
    LoadingTitle = "Loading Galaxy Hub...",
    LoadingSubtitle = "by Assistant",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main Features")

--------------------------------------------------------------------------------
-- 0. ระบบเปิด-ปิด Local Event (SpawnGalaxyBlock)
--------------------------------------------------------------------------------
Tab:CreateToggle({
    Name = "เปิด-ปิด Auto Spawn Galaxy Block",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoSpawnBlock = Value
    end
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if Config.AutoSpawnBlock and SpawnGalaxyBlockEvent then
            pcall(function()
                SpawnGalaxyBlockEvent:FireServer()
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- 1. ระบบวิ่งไว (ปรับได้ 1 ถึง 10)
--------------------------------------------------------------------------------
Tab:CreateToggle({
    Name = "ฟังค์ชั่น 1: เปิดระบบวิ่งไว",
    CurrentValue = false,
    Callback = function(Value)
        Config.WalkSpeedEnabled = Value
    end
})

Tab:CreateSlider({
    Name = "ปรับระดับความเร็ว (1 - 10 เท่า)",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        Config.WalkSpeedValue = Value * 16 -- คูณด้วยค่ามาตรฐาน 16
    end
})

RunService.RenderStepped:Connect(function()
    if Config.WalkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character
      
