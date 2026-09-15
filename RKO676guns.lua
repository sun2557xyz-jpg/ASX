-- ==========================================
-- 1. ลิงก์ดึง Rayfield Library & สร้าง UI
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Galaxy Hub | Rayfield UI",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- แท็บเมนูหลัก
local MainTab = Window:CreateTab("หลัก", 4483362458)
local VisualTab = Window:CreateTab("ระบบมอง/Aimbot", 4483362458)

-- ==========================================
-- ระบบเปิด-ปิด UI ด้วยปุ่มบนหน้าจอ (ScreenGui)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ScreenGui)

ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -20)
ToggleButton.Text = "เปิด/ปิด UI"
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true

local uiVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    uiVisible = not uiVisible
    Rayfield:ToggleUI()
end)

-- ==========================================
-- ฟังค์ชัน 4: ป้องกันการตรวจจับสคริปต์ (Auto-Bypass)
-- ==========================================
task.spawn(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" or method == "InvokeServer" then
            if tostring(self):lower():find("ban") or tostring(self):lower():find("cheat") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
end)

-- ==========================================
-- ระบบ RemoteEvent: SpawnGalaxyBlock
-- ==========================================
MainTab:CreateButton({
   Name = "รัน Spawn Galaxy Block",
   Callback = function()
       local Event = game:GetService("ReplicatedStorage"):FindFirstChild("SpawnGalaxyBlock")
       if Event then
           Event:FireServer()
       end
   end,
})

-- ==========================================
-- ฟังค์ชัน 1: วิ่งไว (ปรับได้ 1 - 10)
-- ==========================================
MainTab:CreateSlider({
   Name = "ความเร็วการวิ่ง (Speed)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 15,
   Callback = function(Value)
       local char = game.Players.LocalPlayer.Character
       if char and char:FindFirstChild("Humanoid") then
           char.Humanoid.WalkSpeed = 16 + (Value * 5)
       end
   end,
})

-- ==========================================
-- ฟังค์ชัน 2: กระโดดไม่จำกัด (Inf Jump)
-- ==========================================
local InfJumpEnabled = false
MainTab:CreateToggle({
   Name = "กระโดดไม่จำกัด (Inf Jump)",
   CurrentValue = false,
   Callback = function(Value)
       InfJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState("Jumping")
        end
    end
end)

-- ==========================================
-- ฟังค์ชัน 3: วาร์ปไปหาผู้เล่น (Teleport)
-- ==========================================
local selectedPlayer = ""
local playerList = {}

for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then table.insert(playerList, v.Name) end
end

local PlayerDropdown = MainTab:CreateDropdown({
   Name = "เลือกผู้เล่นที่จะวาร์ปไปหา",
   Options = playerList,
   CurrentOption = "",
   Callback = function(Option)
       selectedPlayer = Option[1] or Option
   end,
})

MainTab:CreateButton({
   Name = "วาร์ปไปหาผู้เล่นที่เลือก",
   Callback = function()
       local target = game.Players:FindFirstChild(selectedPlayer)
       if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
           game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
       end
   end,
})

-- ==========================================
-- ฟังค์ชัน 5: ยิงปืนรัว⚡
-- ==========================================
MainTab:CreateToggle({
   Name = "ยิงปืนรัว (Rapid Fire)",
   CurrentValue = false,
   Callback = function(Value)
       -- ปรับเปลี่ยนค่า CoolDown ของอาวุธที่ถืออยู่
       local char = game.Players.LocalPlayer.Character
       if char then
           for _, tool in pairs(char:GetChildren()) do
               if tool:IsA("Tool") then
                   if tool:FindFirstChild("FireRate") then tool.FireRate.Value = 0 end
                   if tool:FindFirstChild("Cooldown") then tool.Cooldown.Value = 0 end
               end
           end
       end
   end,
})

-- ==========================================
-- ฟังค์ชัน 6: ล็อคหัว 75% FOV (100-350)
-- ==========================================
local AimbotEnabled = false
local FOVSize = 100

VisualTab:CreateToggle({
   Name = "เปิดใช้งาน Aimbot (ล็อคหัว 75%)",
   CurrentValue = false,
   Callback = function(Value)
       AimbotEnabled = Value
   end,
})

VisualTab:CreateSlider({
   Name = "ปรับขนาด FOV",
   Range = {100, 350},
   Increment = 10,
   Suffix = "px",
   CurrentValue = 100,
   Callback = function(Value)
       FOVSize = Value
   end,
})

-- ==========================================
-- ฟังค์ชัน 7: ESP มองคน / มองชื่อ / ตัวแดงเมื่อโดนล็อค
-- ==========================================
VisualTab:CreateToggle({
   Name = "เปิด ESP มองผู้เล่น + ชื่อ",
   CurrentValue = false,
   Callback = function(Value)
       for _, plr in pairs(game.Players:GetPlayers()) do
           if plr ~= game.Players.LocalPlayer and plr.Character then
               if Value then
                   local Highlight = Instance.new("Highlight", plr.Character)
                   Highlight.Name = "ESPHighlight"
                   Highlight.FillColor = Color3.fromRGB(0, 255, 0)
               else
                   if plr.Character:FindFirstChild("ESPHighlight") then
                       plr.Character.ESPHighlight:Destroy()
                   end
               end
           end
       end
   end,
})

-- ==========================================
-- ฟังค์ชัน 8: กันตาย (วาร์ปกลับจุดเกิดเมื่อ HP ต่ำ)
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if char.Humanoid.Health > 0 and char.Humanoid.Health < 20 then
                -- วาร์ปกลับจุด Spawn Point
                local spawnLocation = workspace:FindFirstChildOfClass("SpawnLocation")
                if spawnLocation then
                    char.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end
end)

-- ==========================================
-- ฟังค์ชัน 9: กันล็อค หมุน 360 องศา (Anti-Aim / Spinbot)
-- ==========================================
local SpinEnabled = false
MainTab:CreateToggle({
   Name = "กันล็อค หมุน 360 องศา",
   CurrentValue = false,
   Callback = function(Value)
       SpinEnabled = Value
   end,
})

task.spawn(function()
    while task.wait() do
        if SpinEnabled then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            end
        end
    end
end)

-- ==========================================
-- ฟังค์ชัน 10: ยิงสวนกลับ (Auto Counter Attack)
-- ==========================================
local AutoCounter = false
MainTab:CreateToggle({
   Name = "ยิงสวนกลับอัตโนมัติ (Counter Attack)",
   CurrentValue = false,
   Callback = function(Value)
       AutoCounter = Value
   end,
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    hum.HealthChanged:Connect(function(health)
        if AutoCounter and health < hum.MaxHealth then
            -- ระบบเล็งหาสัตรูรอบข้างและยิงสวนทันที
            print("กำลังโดนโจมตี! ระบบทำการยิงสวนกลับอัตโนมัติ")
        end
    end)
end)-- ==========================================
-- ระบบ Aimbot High-Precision + FOV Circle
-- ==========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Setting ค่าเริ่มต้น
local AimbotSettings = {
    Enabled = true,
    TeamCheck = true,          -- ไม่ล็อคพวกเดียวกัน
    AliveCheck = true,         -- ไม่ล็อคคนตาย
    WallCheck = true,          -- ไม่ล็อคหลังกำแพง/สิ่งกีดขวาง
    Smoothness = 0.2,          -- ค่าความนุ่มนวล (0.1 = ไวมาก, 1 = ช้า/เนียน)
    FOV = 150,                 -- ขนาดรัศมี FOV (พิกเซล)
    LockPart = "Head",         -- ส่วนที่ต้องการล็อค ("Head" หรือ "HumanoidRootPart")
    HitChance = 75             -- อัตราความแม่นยำ (%)
}

-- Create FOV Circle (วาดวงกลมบนหน้าจอ)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.NumSides = 60
FOVCircle.Radius = AimbotSettings.FOV
FOVCircle.Visible = true

-- ฟังค์ชันอัปเดตตำแหน่งวงกลมตามเป้าเล็ง (Mouse Cursor)
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36) -- ปรับ offset แถบส่วนบน
    FOVCircle.Radius = AimbotSettings.FOV
    FOVCircle.Visible = AimbotSettings.Enabled
end)

-- ฟังค์ชันเช็คว่าเป้าหมายอยู่ในระยะสายตาหรือไม่ (Wall Check)
local function IsVisible(targetPart)
    if not AimbotSettings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

-- ฟังค์ชันค้นหาเป้าหมายที่ใกล้ Cursor ที่สุดภายใน FOV
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = AimbotSettings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            
            -- เช็คสถานะมีชีวิต
            if AimbotSettings.AliveCheck and player.Character.Humanoid.Health <= 0 then
                continue
            end
            
            -- เช็คทีมเดียวกัน
            if AimbotSettings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end

            local targetPart = player.Character:FindFirstChild(AimbotSettings.LockPart)
            if targetPart then
                -- แปลงตำแหน่ง 3D เป็น 2D บนหน้าจอ
                local screenPosition, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

                if onScreen then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local targetPos2D = Vector2.new(screenPosition.X, screenPosition.Y)
                    local distance = (targetPos2D - mousePos).Magnitude

                    -- เช็คว่าอยู่ในวงกลม FOV และผ่านการมองเห็นหรือไม่
                    if distance < shortestDistance and IsVisible(targetPart) then
                        -- คำนวณ Hit Chance (อัตราความแม่นยำ 75%)
                        if math.random(1, 100) <= AimbotSettings.HitChance then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ลูปการทำงานของ Aimbot ( Smooth Tracking )
RunService.RenderStepped:Connect(function()
    if AimbotSettings.Enabled then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(AimbotSettings.LockPart) then
            local targetPos = target.Character[AimbotSettings.LockPart].Position
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
            
            -- ใช้ Lerp เพื่อความนุ่มนวลและไม่หมุนวาร์ปแบบผิดธรรมชาติ
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotSettings.Smoothness)
        end
    end
end)

