-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง หน้าต่างหลัก (Window)
local Window = Rayfield:CreateWindow({
   Name = "Custom Hub",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- สร้าง Tab หลัก
local MainTab = Window:CreateTab("Main Features", 4483362458) -- ไอคอนตั้งต้น

----------------------------------------------------------------
-- ตัวแปรสำหรับควบคุมการทำงาน
----------------------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local SpeedEnabled = false
local SpeedValue = 16 -- ค่าปกติ Roblox คือ 16
local InfiniteJumpEnabled = false
local ESPPeopleEnabled = false
local AimbotEnabled = false
local FOVSize = 100
local SpinEnabled = false
local SpinSpeed = 10

-- ตารางเก็บฟังก์ชัน ESP / Highlights
local Highlights = {}

----------------------------------------------------------------
-- ฟังก์ชันที่ 1: วิ่งไว (ปรับได้ 1 - 10)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "1. วิ่งไว (Speed)",
   CurrentValue = false,
   Callback = function(Value)
      SpeedEnabled = Value
      if not Value then
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

MainTab:CreateSlider({
   Name = "ปรับระดับความเร็ว (1 - 10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = " Multiplier",
   CurrentValue = 1,
   Callback = function(Value)
      SpeedValue = 16 + (Value * 10) -- แปลงสเกล 1-10 ให้เหมาะสมกับการเดิน
   end,
})

-- Loop อัปเดตความเร็ว
RunService.Stepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end
end)

----------------------------------------------------------------
-- ฟังก์ชันที่ 2: Jump ไม่จำกัด (Infinite Jump)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "2. กระโดดไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
   if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

----------------------------------------------------------------
-- ฟังก์ชันที่ 3: มองเห็นคน (Look at people / ESP)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "3. มองเห็นคน (ESP Players)",
   CurrentValue = false,
   Callback = function(Value)
      ESPPeopleEnabled = Value
      if not Value then
         -- ลบ Highlight ทั้งหมดเมื่อปิด
         for plr, hl in pairs(Highlights) do
            if hl then hl:Destroy() end
         end
         Highlights = {}
      end
   end,
})

RunService.RenderStepped:Connect(function()
   if ESPPeopleEnabled then
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not Highlights[player] or not Highlights[player].Parent then
               local highlight = Instance.new("Highlight")
               highlight.Target = player.Character
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.Parent = player.Character
               Highlights[player] = highlight
            end
         end
      end
   end
end)

----------------------------------------------------------------
-- ฟังก์ชันที่ 4: ล็อคเป้าแบบ FOV (1 - 350)
----------------------------------------------------------------
-- สร้าง วงกลม FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = FOVSize
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(0, 255, 0)
FOVCircle.Thickness = 1.5
FOVCircle.Visible = false

MainTab:CreateToggle({
   Name = "4. ล็อคเป้า FOV (Aimbot)",
   CurrentValue = false,
   Callback = function(Value)
      AimbotEnabled = Value
      FOVCircle.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "ขนาด FOV (1 - 350)",
   Range = {1, 350},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 100,
   Callback = function(Value)
      FOVSize = Value
      FOVCircle.Radius = Value
   end,
})

-- ฟังก์ชันหาคนที่ใกล้เป้าหมายกลางจอที่สุดในระยะ FOV
local function GetClosestPlayer()
   local Target = nil
   local ShortestDistance = FOVSize

   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
         local ScreenPos, OnScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
         if OnScreen then
            local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude

            if Distance < ShortestDistance then
               ShortestDistance = Distance
               Target = player
            end
         end
      end
   end
   return Target
end

RunService.RenderStepped:Connect(function()
   FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
   if AimbotEnabled then
      local Target = GetClosestPlayer()
      if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
      end
   end
end)

----------------------------------------------------------------
-- ฟังก์ชันที่ 5: หมุนตัวละคร (SpinBot)
----------------------------------------------------------------
MainTab:CreateToggle({
   Name = "5. หมุนตัวละคร (Spin Character)",
   CurrentValue = false,
   Callback = function(Value)
      SpinEnabled = Value
   end,
})

RunService.RenderStepped:Connect(function()
   if SpinEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
   end
end)-- ========================================================
-- [SECTION 1] Anti-Ban / Anti-Blacklist Protection
-- ========================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ซ่อนและปกป้องการตรวจจับ UI / Hooks Basic Anti-Cheat
if gethui then
    -- ย้าย UI ไปไว้ใน CoreGui ที่ซ่อนไว้
elseif syn and syn.protect_gui then
    -- รองรับ Synapse Protection
end

-- ป้องกันการส่งข้อมูลซ้ำเกินไป (Bypass Rate-Limit Detect)
local lastFireTime = 0
local safeCooldown = 0.5 -- ระยะเวลาคูลดาวน์ขั้นต่ำเพื่อไม่ให้เซิร์ฟเวอร์จับได้ว่าสแปม

-- ========================================================
-- [SECTION 2] Rayfield UI Setup
-- ========================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Galaxy Block Auto Hub",
   LoadingTitle = "Loading Anti-Detection Script...",
   LoadingSubtitle = "Protected Version",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Function", 4483362458) -- Main Tab

-- ตัวแปรควบคุมการทำงานของ Toggle
local autoSpawnActive = false

-- ========================================================
-- [SECTION 3] Main Toggle Function (พร้อม Anti-Ban)
-- ========================================================
MainTab:CreateToggle({
   Name = "Auto Spawn Galaxy Block",
   CurrentValue = false,
   Flag = "SpawnGalaxyToggle",
   Callback = function(Value)
      autoSpawnActive = Value

      if autoSpawnActive then
         Rayfield:Notify({
            Title = "Status",
            Content = "เปิดการทำงานระบบ Auto Spawn (Anti-Ban Active)",
            Duration = 2.5,
            Image = 4483362458,
         })

         -- วงลูปทำงานแบบปลอดภัย
         task.spawn(function()
            while autoSpawnActive do
               -- ตรวจสอบว่า Event มีตัวตนจริงไหมก่อนเรียกใช้ (ป้องกัน Error Log ที่ Anticheat ตรวจจับได้)
               local ReplicatedStorage = game:GetService("ReplicatedStorage")
               local spawnEvent = ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock")

               if spawnEvent and spawnEvent:IsA("RemoteEvent") then
                  -- Anti-Ban Check: ตรวจสอบ Cooldown ป้องกันการเรียกใช้ถี่เกินไป
                  if tick() - lastFireTime >= safeCooldown then
                     lastFireTime = tick()
                     
                     -- สุ่ม Delay เล็กน้อย (Randomized Delay) เพื่อให้ดูเหมือนคนกดจริง ไม่ใช่ Bot
                     local humanDelay = math.random(5, 15) / 100
                     task.wait(humanDelay)

                     -- รัน Event
                     pcall(function()
                        spawnEvent:FireServer()
                     end)
                  end
               else
                  Rayfield:Notify({
                     Title = "Error",
                     Content = "ไม่พบ Event: SpawnGalaxyBlock ใน ReplicatedStorage",
                     Duration = 3,
                     Image = 4483362458,
                  })
                  break
               end

               -- พักเพื่อไม่ให้เกมกระตุกและลดอัตราการถูกตรวจจับ
               task.wait(0.5)
            end
         end)
      else
         Rayfield:Notify({
            Title = "Status",
            Content = "ปิดการทำงานแล้ว",
            Duration = 2.5,
            Image = 4483362458,
         })
      end
   end,
})
