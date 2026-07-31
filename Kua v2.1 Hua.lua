-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง Window หลัก
local Window = Rayfield:CreateWindow({
   Name = "Main Menu Hub",
   LoadingTitle = "Rayfield UI System",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- สร้าง Tab หลัก
local MainTab = Window:CreateTab("Main Functions", 4483362458)

-------------------------------------------------
-- ฟังชั่นพิเศษ: ระบบ Spawner (เปิด/ปิด Loop)
-------------------------------------------------
local AutoSpawn = false
MainTab:CreateToggle({
   Name = "Auto Spawn Galaxy Block",
   CurrentValue = false,
   Flag = "AutoSpawnFlag",
   Callback = function(Value)
      AutoSpawn = Value
      task.spawn(function()
         while AutoSpawn do
            local replicatedStorage = game:GetService("ReplicatedStorage")
            local event = replicatedStorage:FindFirstChild("SpawnGalaxyBlock")
            if event then
               event:FireServer()
            end
            task.wait(0.1) -- ปรับเวลาหน่วงตรงนี้ได้ตามต้องการ
         end
      end)
   end,
})

MainTab:CreateSection("Movement & Utilities")

-------------------------------------------------
-- ฟังชั่น 1: วิ่งไว (ปรับได้ 1 ถึง 10)
-------------------------------------------------
MainTab:CreateSlider({
   Name = "WalkSpeed Multiplier (1-10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         -- ค่าปกติ WalkSpeed คือ 16
         player.Character.Humanoid.WalkSpeed = 16 * Value
      end
   end,
})

-------------------------------------------------
-- ฟังชั่น 2: กระโดดไม่จำ
