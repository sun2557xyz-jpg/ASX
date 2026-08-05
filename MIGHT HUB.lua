-- [[ Rayfield UI Library Setup ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Main Hub | 9 Functions",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Features", 4483362458) -- Title, Image

-- [[ Global Variables & Services ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- [[ Function 1: Speed Adjust (1-10) ]]
local speedMultiplier = 1
local defaultSpeed = 16
MainTab:CreateSlider({
   Name = "ฟังก์ชัน 1: ปรับความเร็ววิ่ง (1-10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      speedMultiplier = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed * speedMultiplier
      end
   end,
})

-- Keep Speed Updated on Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
   char:WaitForChild("Humanoid").WalkSpeed = defaultSpeed * speedMultiplier
end)

-- [[ Function 2: Infinite Jump ]]
local infiniteJumpEnabled = false
MainTab:CreateToggle({
   Name = "ฟังก์ชัน 2: กระโดดไม่จำกัด",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
      infiniteJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
   if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
      LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

-- [[ Function 3: ESP (ดูคนทั้งแมพ) ]]
local espEnabled = false
local espHighlights = {}

local function applyESP(player)
   if player ~= LocalPlayer then
      player.CharacterAdded:Connect(function(char)
         if espEnabled then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = char
         end
      end)
      if player.Character and espEnabled then
         local highlight = Instance.new("Highlight")
         highlight.Name = "ESPHighlight"
         highlight.FillColor = Color3.fromRGB(255, 0, 0)
         highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
         highlight.Parent = player.Character
      end
   end
end

MainTab:CreateToggle({
   Name = "ฟังก์ชัน 3: ดูคนทั้งแมพ (ESP)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      espEnabled = Value
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer and player.Character then
            if espEnabled then
               if not player.Character:FindFirstChild("ESPHighlight") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "ESPHighlight"
                  highlight.FillColor = Color3.fromRGB(255, 0, 0)
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                  highlight.Parent = player.Character
               end
            else
               if player.Character:FindFirstChild("ESPHighlight") then
                  player.Character.ESPHighlight:Destroy()
               end
            end
         end
      end
   end,
})

Players.PlayerAdded:Connect(applyESP)

-- [[ Function 4 & 5: Aimbot Head Only + FOV Adjust (1-350) ]]
local aimbotEnabled = false
local fovRadius = 350
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Filled = false
fovCircle.Transparency = 1

MainTab:CreateToggle({
   Name = "ฟังก์ชัน 4: ล็อคเป้าศัตรู (เฉพาะหัว)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
      aimbotEnabled = Value
      fovCircle.Visible = Value
   end,
})

MainTab:CreateSlider({
   Name = "ฟังก์ชัน 5: ปรับขนาด FOV (1-350)",
   Range = {1, 350},
   Increment = 1,
   Suffix = "px",
   CurrentValue = 350,
   Flag = "FOVSlider",
   Callback = function(Value)
      fovRadius = Value
      fovCircle.Radius = fovRadius
   end,
})

local function getClosestEnemyHead()
   local closestPlayer = nil
   local shortestDistance = fovRadius

   for _, player in pairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
         -- (หมายเหตุ: สามารถเพิ่มเงื่อนไขเช็คทีมตรงนี้ได้หากต้องการแยกฝ่าย)
         local head = player.Character.Head
         local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
         
         if onScreen then
            local mousePos = UserInputService:GetMouseLocation()
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            
            if distance < shortestDistance then
               shortestDistance = distance
               closestPlayer = head
            end
         end
      end
   end
   return closestPlayer
end

RunService.RenderStepped:Connect(function()
   local mousePos = UserInputService:GetMouseLocation()
   fovCircle.Position = mousePos
   fovCircle.Radius = fovRadius

   if aimbotEnabled then
      local targetHead = getClosestEnemyHead()
      if targetHead then
         Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
      end
   end
end)

-- [[ Function 6: Dodge Bullets (Anti-Projectiles) ]]
local dodgeEnabled = false
MainTab:CreateToggle({
   Name = "ฟังก์ชัน 6: หลบกระสุนอัตโนมัติ",
   CurrentValue = false,
   Flag = "DodgeToggle",
   Callback = function(Value)
      dodgeEnabled = Value
   end,
})

Workspace.ChildAdded:Connect(function(child)
   if dodgeEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      -- ตรวจจับวัตถุประเภทกระสุนหรือ Projectile ที่เข้าใกล้ตัว
      if child:IsA("BasePart") and (child.Name:lower():find("bullet") or child.Name:lower():find("projectile")) then
         task.spawn(function()
            while child and child.Parent do
               local hrp = LocalPlayer.Character.HumanoidRootPart
               local distance = (child.Position - hrp.Position).Magnitude
               if distance < 15 then
                  -- วาร์ปหลบข้างซ้าย/ขวาอย่างรวดเร็ว
                  hrp.CFrame = hrp.CFrame * CFrame.new(10, 0, 0)
                  break
               end
               task.wait()
            end
         end)
      end
   end
end)

-- [[ Function 7: Anti-Ban & Anti-Blacklist ]]
local antiBanEnabled = false
MainTab:CreateToggle({
   Name = "ฟังก์ชัน 7: กันแบน / กันดำ (Bypass Anti-Cheat)",
   CurrentValue = false,
   Flag = "AntiBanToggle",
   Callback = function(Value)
      antiBanEnabled = Value
      if Value then
         -- ทำการ Block การส่ง Log ตรวจจับของเกมเข้า Server
         local gmt = getrawmetatable(game)
         setreadonly(gmt, false)
         local oldNamecall = gmt.__namecall
         
         gmt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if antiBanEnabled and (method == "FireServer" or method == "InvokeServer") then
               if tostring(self):lower():find("ban") or tostring(self):lower():find("cheat") or tostring(self):lower():find("detect") then
                  return nil
               end
            end
            return oldNamecall(self, ...)
         end)
      end
   end,
})

-- [[ Function 8: Item Magnet (ดูดของ) ]]
local magnetEnabled = false
MainTab:CreateToggle({
   Name = "ฟังก์ชัน 8: ดูดของเข้าตัว (Item Magnet)",
   CurrentValue = false,
   Flag = "MagnetToggle",
   Callback = function(Value)
      magnetEnabled = Value
   end,
})

RunService.Heartbeat:Connect(function()
   if magnetEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      for _, v in pairs(Workspace:GetChildren()) do
         -- ดึงไอเทมประเภท Dropped Items หรือ Tools เข้าตัว
         if v:IsA("Tool") or v:IsA("Handle") or v.Name:lower():find("item") or v.Name:lower():find("drop") then
            local part = v:IsA("Tool") and (v:FindFirstChild("Handle") or v:FindFirstChildOfClass("Part")) or v
            if part and (part.Position - hrp.Position).Magnitude < 100 then
               part.CFrame = hrp.CFrame
            end
         end
      end
   end
end)

-- [[ Function 9: Underground / Noclip Depth (ดำดิน 1-50 เมตร) ]]
local undergroundEnabled = false
local undergroundDepth = 1

MainTab:CreateToggle({
   Name = "ฟังก์ชัน 9: เปิดใช้งานดำดิน",
   CurrentValue = false,
   Flag = "UndergroundToggle",
   Callback = function(Value)
      undergroundEnabled = Value
   end,
})

MainTab:CreateSlider({
   Name = "ปรับระดับความลึกดำดิน (1-50 เมตร)",
   Range = {1, 50},
   Increment = 1,
   Suffix = "m",
   CurrentValue = 1,
   Flag = "DepthSlider",
   Callback = function(Value)
      undergroundDepth = Value
   end,
})

RunService.Stepped:Connect(function()
   if undergroundEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
      local hrp = LocalPlayer.Character.HumanoidRootPart
      -- ปิดการชนของบล็อกเพื่อกดตัวลงดินได้ (Noclip)
      for _, part in pairs(Local
        
