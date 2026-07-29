-- โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Custom Hub | 5 Functions",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Features", 4483362458)

----------------------------------------------------------------
-- ตัวแปรระบบ (Services & Variables)
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables สำหรับฟังก์ชันต่างๆ
local walkSpeedValue = 16 -- ค่าเริ่มต้น
local walkSpeedEnabled = false

local infiniteJumpEnabled = false

local playerEspEnabled = false
local itemEspEnabled = false
local espDrawings = {}

local aimbotEnabled = false
local fovRadius = 100
local lockChance = 35 -- ล็อค 35%
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Thickness = 1.5
fovCircle.NumSides = 60
fovCircle.Filled = false
fovCircle.Visible = false

local spinEnabled = false
local spinSpeed = 20

----------------------------------------------------------------
-- ฟังก์ชันที่ 1: วิ่งไว (ปรับได้ 1-10)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "1. Speed Hack (เปิด/ปิด)",
   CurrentValue = false,
   Callback = function(Value)
      walkSpeedEnabled = Value
      if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = 16
      end
   end,
})

MainTab:
