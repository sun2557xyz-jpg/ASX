-- โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง หน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "Custom Hub | 7 Functions",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- สร้าง แท็บหลัก
local MainTab = Window:CreateTab("ฟังก์ชันทั้งหมด", 4483362458)

----------------------------------------------------------------
-- ตัวแปรตั้งค่าระบบ
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local SpeedValue = 16
local SpeedEnabled = false
local InfiniteJumpEnabled = false
local ESPEnabled = false
local AimbotEnabled = false
local TargetFOV = 350
local AntiLockEnabled = false

----------------------------------------------------------------
-- ฟังชั่น 1: ปรับความเร็ววิ่ง (1 ถึง 10)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "เปิด/ปิด วิ่งไว",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
      if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
   end,
})

MainTab:CreateSlider({
   Name = "ความเร็ววิ่ง (ระดับ 1-10)",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 1,
   Callback = function(Value)
      -- แปลงระดับ 1-10 เป็น WalkSpeed (16 ถึง 100)
      SpeedValue = 16 + ((Value - 1) * 9.3)
   end,
})

RunService.RenderStepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = Speed
      
