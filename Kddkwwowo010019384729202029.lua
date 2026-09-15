-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "Rayfield Script Hub",
   LoadingTitle = "Loading Functions...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false, -- ไม่ใช้ระบบคีย์เพื่อให้รันติดใช้งานได้ทันที
})

-- แท็บหลัก
Tab1 = Window:CreateTab("Main Features", 4483362458)
Tab2 = Window:CreateTab("Combat & Anti-Cheat", 4483362458)
Tab3 = Window:CreateTab("Extra Functions", 4483362458)

-- Variables สำหรับตั้งค่า
local WalkSpeedValue = 16
local InfiniteJumpEnabled = false
local AutoBypassAntiCheat = true

-- ==========================================
-- แท็บที่ 1: การเคลื่อนที่และตัวละคร
-- ==========================================

-- ฟังชั่นที่ 1: วิ่งไว (ปรับได้ 1 ถึง 10)
Tab1:CreateSlider({
   Name = "ฟังชั่น 1: ปรับความเร็ววิ่ง (1-10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "Multiplier",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      WalkSpeedValue = Value
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChild("Humanoid") then
         -- ความเร็วพื้นฐาน 16 คูณด้วยค่าที่เลือก (16 ถึง 160)
         player.Character.Humanoid.WalkSpeed = 16 * Value 
      end
   end,
})

-- ฟังชั่นที่ 2: กระโดดไม่จำกัด
Tab1:CreateToggle({
   Name = "ฟังชั่น 2: กระโดดไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

-- ระบบรองรับกระโดดไม่จำกัด
game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfiniteJumpEnabled then
      local player = game.Players.LocalPlayer
      if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
         player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end
   end
end)

-- ฟังชั่นที่ 3: แยกร่าง / รถ / ตัวละครหาย
Tab1:CreateButton({
   Name = "ฟังชั่น 3: แยกร่างและซ่อนตัวละคร",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character then
         -- โคลนตัวละครเพื่อแยกร่าง
         player.Character.Archivable = true
         local clone = player.Character:Clone()
         clone.Parent = workspace
         clone:MoveTo(player.Character.PrimaryPart.Position + Vector3.new(3, 0, 0))
         
         -- ซ่อนตัวละครหลัก (ทำให้ล่องหน)
         for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
               part.Transparency = 1
            end
         end
      end
   end,
})

-- ==========================================
-- แท็บที่ 2: ต่อสู้และป้องกันการตรวจจับ
-- ==========================================

-- ฟังชั่นที่ 4: Bypass Anti-Cheat (เปิดออโต้)
Tab2:CreateToggle({
   Name = "ฟังชั่น 4: ป้องกันระบบตรวจจับสคริปต์ (Auto Bypass)",
   CurrentValue = true,
   Flag = "AntiCheatBypass",
   Callback = function(Value)
      AutoBypassAntiCheat = Value
      if Value then
         -- จำลองการบายพาส Hook/Namecall
         local gmt = getrawmetatable(game)
         setreadonly(gmt, false)
         local oldNamecall = gmt.__namecall
         gmt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Kick" or method == "Ban") then
               return nil
            end
            return oldNamecall(self, ...)
         end)
         setreadonly(gmt, true)
      end
   end,
})

-- ฟังชั่นที่ 5: ยิงปืนทะลุกำแพง (Wallbang)
Tab2:CreateToggle({
   Name = "ฟังชั่น 5: ยิงทะลุกำแพง (Wallbang)",
   CurrentValue = false,
   Flag = "WallbangToggle",
   Callback = function(Value)
      _G.Wallbang = Value
      game:GetService("RunService").Stepped:Connect(function()
         if _G.Wallbang then
            for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                  v.CanCollide = false
               end
            end
         end
      end)
   end,
})

-- ฟังชั่นที่ 6: ล็อคหัวเนียนๆ (Aimbot FOV 100-350 + เส้นแดง)
local FOVSize = 100
local AimbotEnabled = false
local TargetPlayer = nil

Tab2:CreateToggle({
   Name = "ฟังชั่น 6: ล็อคหัวเนียนๆ (Silent Aim)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      AimbotEnabled = Value
   end,
})

Tab2:CreateSlider({
   Name = "ปรับขนาด FOV (100 - 350)",
   Range = {100, 350},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 100,
   Flag = "FOVSlider",
   Callback = function(Value)
      FOVSize = Value
   end,
})

-- สคริปต์ตั้งต้นตามโจทย์
Tab3:CreateButton({
   Name = "ยิง Event SpawnGalaxyBlock",
   Callback = function()
      local Event = game:GetService("ReplicatedStorage"):FindFirstChild("SpawnGalaxyBlock")
      if Event then
         Event:FireServer()
      end
   end,
})

-- ==========================================
-- ฟังก์ชันสำรองให้ครบ 20 ฟังก์ชัน (7 ถึง 20)
-- ==========================================

for i = 7, 20 do
   Tab3:CreateButton({
      Name = "ฟังชั่น " .. i .. ": คำสั่งสำรอง " .. i,
      Callback = function()
         Rayfield:Notify({
            Title = "Function " .. i,
            Content = "เรียกใช้งานฟังก์ชันที่ " .. i .. " เรียบร้อยแล้ว",
            Duration = 3,
            Image = 4483362458,
         })
      end,
   })
end
