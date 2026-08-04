-- โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Custom Script Hub",
   LoadingTitle = "Rayfield UI System",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false
})

local Tab = Window:CreateTab("Main Features", 4483362458) -- Icon ID

----------------------------------------------------------------
-- ตัวแปรตั้งค่าระบบ (Variables)
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables สำหรับฟังก์ชันต่างๆ
local WalkSpeedValue = 16
local InfiniteJumpEnabled = false
local ESPEnabled = false
local FOVAimbotEnabled = false
local FOVRadius = 350

----------------------------------------------------------------
-- 1. วิ่งไว (WalkSpeed 1-10)
-- หมายเหตุ: ค่าปกติ Roblox คือ 16 หากปรับ 1-10 จะเป็นการเดินช้าลง/วิ่งตามระดับ
----------------------------------------------------------------
Tab:CreateSlider({
   Name = "ความเร็วการเคลื่อนที่ (WalkSpeed)",
   Range = {1, 10},
   Increment = 1,
   Suffix = " Level",
   CurrentValue = 1,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
       WalkSpeedValue = Value
       -- แปลงระดับ 1-10 เป็นความเร็ว (เช่น ระดับ 1 = 16, ระดับ 10 = 100)
       if LocalPlayer.Character and Local
        
