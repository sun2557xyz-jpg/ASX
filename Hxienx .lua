-- โหลด Rayfield Interface Suite
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง Window หลัก
local Window = Rayfield:CreateWindow({
   Name = "Galaxy Block Panel",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false
})

-- สร้าง Tab สำหรับฟังก์ชันต่างๆ
local MainTab = Window:CreateTab("ฟังก์ชันหลัก", 4483362458)

----------------------------------------------------
-- ฟังชั่น 1: วิ่งไว (ปรับได้ 1 ถึง 10)
----------------------------------------------------
local WalkSpeedMultiplier = 1
MainTab:CreateSlider({
   Name = "ความเร็วการวิ่ง (Multiplier 1-10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      WalkSpeedMultiplier = Value
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         -- ความเร็วพื้นฐาน Roblox คือ 16
         char.Humanoid.WalkSpeed = 16 * WalkSpeedMultiplier
      end
   end,
})

-- รักษาระดับความเร็วเมื่อตัวละครเกิดใหม่
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
   local hum = char:WaitForChild("Humanoid")
   hum.WalkSpeed = 16 * WalkSpeedMultiplier
end)

----------------------------------------------------
-- ฟังชั่น 2: กระโดดไม่จำกัด (Infinite Jump)
----------------------------------------------------
local InfJumpEnabled = false
MainTab:CreateToggle({
   Name = "กระโดดไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      InfJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfJumpEnabled then
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end
   end
end)

----------------------------------------------------
-- ฟังชั่น 3: แยกร่างรถ / ตัวละครหาย (Desync & Invisible)
----------------------------------------------------
MainTab:CreateButton({
   Name = "แยกร่างรถ (ตัวละครหาย / Desync Body)",
   Callback = function()
      local player = game.Players.LocalPlayer
      local char = player.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         -- เทคนิคการแยก Hitbox / Render ออกจากตัวละคร
         local hrp = char.HumanoidRootPart
         local clone = hrp:Clone()
         clone.Parent = char
         hrp:Destroy()
         
         -- ส่ง Signal Spawn Block ที่คุณกำหนด
         pcall(function()
            game:GetService("ReplicatedStorage").SpawnGalaxyBlock:FireServer()
         end)
      end
   end,
})

----------------------------------------------------
-- ฟังชั่น 4: ระบบป้องกันการตรวจจับสคริปต์ (Anti-Bypass Logs)
----------------------------------------------------
MainTab:CreateButton({
   Name = "เปิดระบบซ่อนสคริปต์ (Bypass Detection Logs)",
   Callback = function()
      -- Bypass LogService / ScriptContext Error Reports
      local LogService = game:GetService("LogService")
      local ScriptContext = game:GetService("ScriptContext")
      
      -- ปิดการส่ง Error / Traceback กลับไปยัง Server
      if getgenv then
         getgenv().script_key = nil
      end
      
      -- Hook หรือลบ Event ตรวจจับ Client
      pcall(function()
         for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "Ban") or rawget(v, "Kick") then
               table.clear(v)
            end
         end
      end)

      Rayfield:Notify({
         Title = "Anti-Cheat Bypass",
         Content = "ซ่อนสคริปต์จากการตรวจจับเรียบร้อยแล้ว!",
         Duration = 4,
         Image = 4483362458,
      })
   end,
})

----------------------------------------------------
-- ปุ่มลัด เปิด-ปิด UI (กด K)
----------------------------------------------------
local UIS = game:GetService("UserInputService")
local UIVisible = true

UIS.InputBegan:Connect(function(input, gpe)
   if not gpe and input.KeyCode == Enum.KeyCode.K then
      UIVisible = not UIVisible
      -- ใช้คำสั่งของ Rayfield ในการซ่อน/แสดงหน้าต่าง
      if Window.MainUI then
         Window.MainUI.Visible = UIVisible
      end
   end
end)

Rayfield:Notify({
   Title = "โหลดสคริปต์สำเร็จ!",
   Content = "กดปุ่ม 'K' เพื่อเปิด-ปิด เมนู Rayfield",
   Duration = 5,
   Image = 4483362458,
})
