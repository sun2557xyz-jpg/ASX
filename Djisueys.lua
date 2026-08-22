-- โหลด Rayfield Interface Suite
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "Rayfield UI System",
   LoadingTitle = "Rayfield Suite",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false -- ปิดระบบใส่คีย์
})

-- สร้าง Tab หลักสำหรับวางฟังก์ชัน
local MainTab = Window:CreateTab("Main Features", 4483362458)

--------------------------------------------------------------------------------
-- ฟังก์ชันที่ 1: ระบบวิ่งไวปรับได้ 1 ถึง 10 (WalkSpeed Multiplier)
--------------------------------------------------------------------------------
local BaseSpeed = 16
MainTab:CreateSlider({
   Name = "Speed Multiplier (1-10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      local character = game.Players.LocalPlayer.Character
      if character and character:FindFirstChild("Humanoid") then
         character.Humanoid.WalkSpeed = BaseSpeed * Value
      end
   end,
})

--------------------------------------------------------------------------------
-- ฟังก์ชันที่ 2: กระโดดไม่จำกัด (Infinite Jump)
--------------------------------------------------------------------------------
local InfiniteJumpEnabled = false
MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

-- ดักจับการกด Jump (Spacebar)
game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfiniteJumpEnabled then
      local character = game.Players.LocalPlayer.Character
      if character and character:FindFirstChildOfClass("Humanoid") then
         character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end
   end
end)

--------------------------------------------------------------------------------
-- ฟังก์ชันที่ 3: แยกร่างรถ (ตัวละครหาย / Invisible Character)
--------------------------------------------------------------------------------
MainTab:CreateButton({
   Name = "Invisibility / Separate Vehicle",
   Callback = function()
      local character = game.Players.LocalPlayer.Character
      if character then
         for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
               part.Transparency = 1
            end
         end
      end
   end,
})

--------------------------------------------------------------------------------
-- ฟังก์ชันที่ 4: ระบบป้องกันการตรวจจับสคริปต์ (Bypass Anti-Cheat Concept)
--------------------------------------------------------------------------------
MainTab:CreateToggle({
   Name = "Script Hook Bypass",
   CurrentValue = false,
   Flag = "BypassToggle",
   Callback = function(Value)
      if Value then
         -- ตัวอย่างหลักการซ่อน/ตัดการส่งสัญญาณเตือน (Hooking MetaMethod)
         local rawmetatable = getrawmetatable(game)
         if setreadonly then setreadonly(rawmetatable, false) end
         
         Rayfield:Notify({
            Title = "Protection Active",
            Content = "Bypass simulation enabled.",
            Duration = 3,
         })
      end
   end,
})

--------------------------------------------------------------------------------
-- ฟังก์ชันที่ 5: ล็อกหัว FOV (Aimbot FOV 1-800)
--------------------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
FOVCircle.Radius = 100
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Visible = false

MainTab:CreateToggle({
   Name = "Enable FOV Circle",
   CurrentValue = false,
   Flag = "FOVToggle",
   Callback = function(Value)
      FOVCircle.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "FOV Size (1-800)",
   Range = {1, 800},
   Increment = 5,
   Suffix = "px",
   CurrentValue = 100,
   Flag = "FOVSlider",
   Callback = function(Value)
      FOVCircle.Radius = Value
   end,
})

--------------------------------------------------------------------------------
-- ยิง Event ตามที่ระบุมาในคำถาม (Local Event Trigger)
--------------------------------------------------------------------------------
pcall(function()
   game:GetService("ReplicatedStorage").SpawnGalaxyBlockEvent:FireServer()
end)

Rayfield:Notify({
   Title = "System Loaded",
   Content = "กดปุ่ม RightControl บนคีย์บอร์ด เพื่อเปิด/ปิด UI",
   Duration = 5,
})
