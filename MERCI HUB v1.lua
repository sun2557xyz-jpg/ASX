-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง หน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "Galaxy Block Hub",
   LoadingTitle = "กำลังโหลดสคริปต์...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- สร้าง แท็บหลัก
local MainTab = Window:CreateTab("ฟังก์ชันหลัก", 4483362458)

----------------------------------------------------------------
-- ตัวแปรควบคุมระบบ (Variables)
----------------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Function 1: WalkSpeed
local walkSpeedValue = 16
local walkSpeedEnabled = false

-- Function 2: Infinite Jump
local infiniteJumpEnabled = false

-- Function 3: ESP
local espEnabled = false
local espDrawings = {}

-- Function 4 & 5: Aimbot & FOV
local fovEnabled = false
local fovRadius = 350
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Visible = false

----------------------------------------------------------------
-- Logic ระบบต่างๆ (Backend Logic)
----------------------------------------------------------------

-- 1. วิ่งไว
RunService.Stepped:Connect(function()
    if walkSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeedValue
    end
end)

-- 2. กระโดดไม่จำกัด
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.
      
