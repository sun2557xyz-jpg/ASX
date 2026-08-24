-- [[ Kavo UI Script - PvP System with Keybind ]] --
local Kavo = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Kavo.CreateLib("PvP System Script", "Midnight")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Variables & Settings
local Settings = {
    AimbotEnabled = false,
    FOVSize = 150,
    BringKnocked = false,
    RapidFire = false,
    BypassAntiCheat = false
}

-- FOV Circle Visual Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Filled = false
FOVCircle.Visible = false

-- Tracer Line Visual Setup
local TargetLine = Drawing.new("Line")
TargetLine.Color = Color3.fromRGB(255, 255, 255)
TargetLine.Thickness = 1.5
TargetLine.Visible = false

-- Helper Function: Get Closest Target in FOV
local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDistance = Settings.FOVSize

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local head = player.Character.Head
                local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)

                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePos).Magnitude

                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Render Loop for FOV, Aimbot, Line Tracer, and Bring Knocked
RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    
    -- Update FOV Circle
    if Settings.AimbotEnabled then
        FOVCircle.Position = mousePos
        FOVCircle.Radius = Settings.FOVSize
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    -- Process Aimbot & Target Tracking
    local currentTarget = nil
    if Settings.AimbotEnabled then
        currentTarget = GetClosestTarget()
    end

    if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Head") then
        local headPos = currentTarget.Character.Head.Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)

        if onScreen then
            -- Snap Camera to Target Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)

            -- Draw White Tracer Line to Target Head
            TargetLine.From = mousePos
            TargetLine.To = Vector2.new(screenPos.X, screenPos.Y)
            TargetLine.Visible = true
        else
            TargetLine.Visible = false
        end
    else
        TargetLine.Visible = false
    end

    -- Feature 3: Bring Knocked Players to Target FOV
    if Settings.BringKnocked then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                -- Check for common knocked/ragdoll states
                local isKnocked = char:FindFirstChild("BodyEffects") and char.BodyEffects:FindFirstChild("K.O") and char.BodyEffects["K.O"].Value
                                 or (char:FindFirstChild("Humanoid") and char.Humanoid.Health < 15)

                if isKnocked then
                    local targetPoint = Camera:ScreenPointToRay(mousePos.X, mousePos.Y).Origin + (Camera.CFrame.LookVector * 5)
                    char.HumanoidRootPart.CFrame = CFrame.new(targetPoint)
                end
            end
        end
    end
end)

-- Feature 4: Rapid Fire Dual Shot Engine
local OriginalFire = ReplicatedStorage:FindFirstChild("SpawnGalaxyBlock")
if OriginalFire then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.RapidFire then
            OriginalFire:FireServer()
            task.wait(0.02)
            OriginalFire:FireServer()
        end
    end)
end

-- Feature 5: Security & Anti-Cheat Protection (75% Simulation)
local function ActivateBypass()
    if not Settings.BypassAntiCheat then return end

    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Settings.BypassAntiCheat and (method == "Kick" or method == "Ban") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(gmt, true)
end

--------------------------------------------------------------------------------
-- Kavo UI Layout & Controls
--------------------------------------------------------------------------------
local MainTab = Window:NewTab("PvP")
local MainSection = MainTab:NewSection("PvP Controls")
local UIConfigSection = MainTab:NewSection("UI Settings")

-- Feature 1: Aim Lock + White FOV/Line
MainSection:NewToggle("1. Target Lock & Tracer (เล็งหัวสีขาว)", "เปิดระบบล็อคเป้าและแสดงเส้นเล็งสีขาว", function(state)
    Settings.AimbotEnabled = state
end)

-- Feature 2: FOV Radius Slider
MainSection:NewSlider("2. FOV Size", "ปรับขนาดวงกลม FOV (150 - 1600)", 1600, 150, function(value)
    Settings.FOVSize = value
end)

-- Feature 3: Bring Knocked Players
MainSection:NewToggle("3. Bring Knocked (ดึงคนล้มมาเป้า)", "ดึงผู้เล่นที่ล้มมาตำแหน่งเป้าเล็ง", function(state)
    Settings.BringKnocked = state
end)

-- Feature 4: Rapid Fire (Double Shot)
MainSection:NewToggle("4. Rapid Fire (ยิง 1 ออก 2)", "ยิงปืนรั่วยิง 1 นัด ออก 2 นัดผ่าน Event", function(state)
    Settings.RapidFire = state
end)

-- Feature 5: Anti-Cheat Safeguard
MainSection:NewToggle("5. Anti-Cheat Safeguard 75%", "ป้องกันระบบตรวจจับการดัดแปลงในเกม", function(state)
    Settings.BypassAntiCheat = state
    if state then
        ActivateBypass()
    end
end)

-- Keybind Toggle Feature for Kavo UI
UIConfigSection:NewKeybind("Toggle UI Keybind", "ปุ่มเปิด/ปิดหน้าต่าง UI", Enum.KeyCode.RightShift, function()
    Kavo:ToggleUI()
end)
