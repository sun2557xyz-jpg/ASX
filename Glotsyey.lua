-- โครงสร้างตัวอย่าง Rayfield UI สำหรับใช้พัฒนาเกมใน Roblox Studio
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Game Control Panel",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Developer",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main Controls", 4483362458)

-- 1. ตัวอย่างการปรับค่าความเร็ว (WalkSpeed)
MainTab:CreateSlider({
   Name = "Walk Speed Multiplier",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 1,
   Callback = function(Value)
       local player = game.Players.LocalPlayer
       if player and player.Character and player.Character:FindFirstChild("Humanoid") then
           -- ค่าพื้นฐาน Roblox อยู่ที่ 16 (คูณตามระดับ 1-10)
           player.Character.Humanoid.WalkSpeed = 16 * Value
       end
   end,
})

-- 2. ตัวอย่างระบบส่ง RemoteEvent (ใช้สคริปต์ที่คุณแจ้งมา)
MainTab:CreateButton({
   Name = "Spawn Galaxy Block",
   Callback = function()
       local event = game:GetService("ReplicatedStorage"):FindFirstChild("SpawnGalaxyBlock")
       if event then
           event:FireServer()
       end
   end,
})
