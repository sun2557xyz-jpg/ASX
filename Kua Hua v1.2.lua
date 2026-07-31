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
-- [SECTION 1] Setup & Anti-Ban Configuration
-- ========================================================
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- ตั้งค่าปุ่มกด เปิด/ปิด (สามารถเปลี่ยน Enum.KeyCode.E เป็นปุ่มอื่นได้)
local TOGGLE_KEY = Enum.KeyCode.E 

local isRunning = false
local lastFireTime = 0
local safeCooldown = 0.5 -- คูลดาวน์ขั้นต่ำป้องกันการสแปมจนถูกเตะ/แบน

-- ฟังก์ชันแจ้งเตือนแบบมุมขวาล่างของเกม (ไม่ต้องใช้ UIภายนอก)
local function sendNotification(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 2
        })
    end)
end

-- ========================================================
-- [SECTION 2] Main Logic (พร้อม Anti-Ban)
-- ========================================================
local function startLoop()
    task.spawn(function()
        while isRunning do
            local spawnEvent = ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock")

            if spawnEvent and spawnEvent:IsA("RemoteEvent") then
                -- Anti-Ban Check 1: คุม Cooldown ป้องกัน Rate-Limit Detect
                if tick() - lastFireTime >= safeCooldown then
                    lastFireTime = tick()

                    -- Anti-Ban Check 2: สุ่ม Human Delay ให้เหมือนคนกดเอง
                    local humanDelay = math.random(5, 15) / 100
                    task.wait(humanDelay)

                    -- Anti-Ban Check 3: pcall ซ่อน Error Log จาก Anti-Cheat
                    pcall(function()
                        spawnEvent:FireServer()
                    end)
                end
            else
                sendNotification("Error", "ไม่พบ SpawnGalaxyBlock ใน ReplicatedStorage")
                isRunning = false
                break
            end

            task.wait(0.5)
        end
    end)
end

-- ========================================================
-- [SECTION 3] Keybind Listener
-- ========================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- ถ้ากำลังพิมพ์แชทอยู่จะไม่ทำงาน
    if gameProcessed then return end

    if input.KeyCode == TOGGLE_KEY then
        isRunning = not isRunning

        if isRunning then
            sendNotification("Auto Spawn", "Status: [ ON ] (กด E เพื่อปิด)")
            startLoop()
        else
            sendNotification("Auto Spawn", "Status: [ OFF ]")
        end
    end
end)

sendNotification("Script Loaded", "กดปุ่ม 'E' เพื่อ เปิด/ปิด การทำงาน")
