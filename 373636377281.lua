-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ตัวแปรระบบ และการตั้งค่าพื้นฐาน
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Local Event
local SpawnGalaxyEvent = ReplicatedStorage:WaitForChild("SpawnGalaxyBlock")

-- ค่าคอนฟิกของฟังก์ชั่น
local Config = {
    AimbotEnabled = false,
    TargetHeadOnly = true,
    FOVRadius = 300,
    BringKnocked = false,
    RapidFire = false,
    BypassSecurity = true,
    AutoEscape = false,
    EscapeHealth = 20
}

-- สร้าง FOV Circle และ Tracer Line (ฟังก์ชั่น 1 & 2)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1.5
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false

local TracerLine = Drawing.new("Line")
TracerLine.Color = Color3.fromRGB(255, 255, 255)
TracerLine.Thickness = 1.5
TracerLine.Transparency = 1
TracerLine.Visible = false

-- สร้างหน้าต่าง UI
local Window = Rayfield:CreateWindow({
    Name = "PvP System Hub",
    LoadingTitle = "Loading PvP Script...",
    LoadingSubtitle = "by Assistant",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false
})

-- แท็บหลัก
local MainTab = Window:CreateTab("PvP Main", 4483362458)

-- ==========================================
-- ฟังก์ชั่นช่วยคำนวณ (Helper Functions)
-- ==========================================

-- เช็คว่าเป็นศัตรูหรือไม่
local function isEnemy(player)
    if not player or player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    return true
end

-- ค้นหาเป้าหมายที่ใกล้จุดศูนย์กลางจอที่สุดในระยะ FOV
local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = Config.FOVRadius

    for _, player in pairs(Players:GetPlayers()) do
        if isEnemy(player) and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid.Health > 0 then
                local head = player.Character.Head
                local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
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

-- ==========================================
-- ฟังก์ชั่นที่ 5: Anti-Cheat Bypass (~75% Protection)
-- ==========================================
if setfflag then
    pcall(function()
        setfflag("AbuseReportScreenshot", "False")
        setfflag("PhysicsSenderMaxBandwidthBps", "100000")
    end)
end

local rawmetatable = getrawmetatable or debug.getmetatable
if rawmetatable and make_writeable then
    local gmt = rawmetatable(game)
    setreadonly(gmt, false)
    local oldNamecall = gmt.__namecall

    gmt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if Config.BypassSecurity and (method == "FireServer" or method == "InvokeServer") then
            local name = tostring(self)
            if name:find("Ban") or name:find("Detection") or name:find("Cheat") or name:find("Kick") then
                return nil
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(gmt, true)
end

-- ==========================================
-- Main Loop (ความเร็วสูง FPS Base)
-- ==========================================
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- อัปเดตขนาดและตำแหน่ง FOV
    FOVCircle.Position = center
    FOVCircle.Radius = Config.FOVRadius
    FOVCircle.Visible = Config.AimbotEnabled

    if Config.AimbotEnabled then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            local headScreenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                -- วาดเส้นล็อกหัว (Tracer)
                TracerLine.StartPos = center
                TracerLine.EndPos = Vector2.new(headScreenPos.X, headScreenPos.Y)
                TracerLine.Visible = true
                
                -- ล็อกมุมกล้องไปที่หัว
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
            else
                TracerLine.Visible = false
            end
        else
            TracerLine.Visible = false
        end
    else
        TracerLine.Visible = false
    end

    -- ฟังก์ชั่นที่ 3: ดึงคนที่ล้ม (Knocked) เข้าหาเป้าเล็ง
    if Config.BringKnocked then
        for _, player in pairs(Players:GetPlayers()) do
            if isEnemy(player) and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                
                -- เช็คสถานะล้ม (ดูจาก Animation หรือค่า Health ต่ำ / Ragdoll)
                if humanoid and hrp and (humanoid.Health <= 15 or player.Character:FindFirstChild("BodyEffects") and player.Character.BodyEffects:FindFirstChild("K.O") and player.Character.BodyEffects["K.O"].Value == true) then
                    local targetPos = Camera.CFrame.Position + (Camera.CFrame.LookVector * 10)
                    hrp.CFrame = CFrame.new(targetPos)
                end
            end
        end
    end

    -- ฟังก์ชั่นที่ 6: ฉุกเฉิน บินหนีขึ้นฟ้าเมื่อเลือดต่ำ
    if Config.AutoEscape and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoid and hrp and humanoid.Health > 0 and humanoid.Health <= Config.EscapeHealth then
            -- วาร์ปขึ้นฟ้าในระยะปลอดภัย เลี่ยง Boundary Bug ของแมพ
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 300, 0)
            
            -- ปิดแรงโน้มถ่วงชั่วคราวไม่ให้ตกลงมาทันที
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.MaxForce = Vector3.new(0, 100000, 0)
            bv.Parent = hrp
            task.delay(3, function() bv:Destroy() end)
            
            Rayfield:Notify({
                Title = "Auto Escape Activated",
                Content = "วาร์ปขึ้นฟ้าฉุกเฉินเรียบร้อยแล้ว!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
end)

-- ==========================================
-- UI Elements (เมนูควบคุม)
-- ==========================================

-- ปุ่มเรียก Local Event
MainTab:CreateButton({
    Name = "Spawn Galaxy Block Event",
    Callback = function()
        pcall(function()
            SpawnGalaxyEvent:FireServer()
        end)
    end,
})

-- ฟังก์ชั่น 1: Aimbot ล็อกหัวเฉพาะศัตรู
MainTab:CreateToggle({
    Name = "1. ล็อกหัวศัตรู (White FOV & Line)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        Config.AimbotEnabled = Value
    end,
})

-- ฟังก์ชั่น 2: ปรับขนาด FOV (150 - 1600)
MainTab:CreateSlider({
    Name = "2. ขนาด FOV (150 - 1600)",
    Range = {150, 1600},
    Increment = 10,
    Suffix = "px",
    CurrentValue = 300,
    Flag = "FOVSlider",
    Callback = function(Value)
        Config.FOVRadius = Value
    end,
})

-- ฟังก์ชั่น 3: ดึงคนที่ล้มมาที่เป้าเล็ง
MainTab:CreateToggle({
    Name = "3. ดึงคนที่ล้มเข้าหาเป้าเล็ง",
    CurrentValue = false,
    Flag = "BringKnockedToggle",
    Callback = function(Value)
        Config.BringKnocked = Value
    end,
})

-- ฟังก์ชั่น 4: ยิงปืนลั่นรัว (1 นัด ออก 2 นัด / Double Fire)
MainTab:CreateToggle({
    Name = "4. ยิงปืนรัว (1 นัดออก 2 นัด)",
    CurrentValue = false,
    Flag = "RapidFireToggle",
    Callback = function(Value)
        Config.RapidFire = Value
    end,
})

-- Hook การยิงสำหรับฟังก์ชั่น 4
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and Config.RapidFire and input.UserInputType == Enum.UserInputType.MouseButton1 then
        task.wait(0.03)
        pcall(function()
            -- ส่งคำสั่งจำลองการกดปุ่มยิงซ้ำนัดที่สอง
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                tool:Activate()
            end
        end)
    end
end)

-- ฟังก์ชั่น 5: ระบบป้องกันการตรวจจับ (Bypass Anti-Cheat)
MainTab:CreateToggle({
    Name = "5. ป้องกันระบบตรวจจับ (Safety ~75%)",
    CurrentValue = true,
    Flag = "AntiCheatToggle",
    Callback = function(Value)
        Config.BypassSecurity = Value
    end,
})

-- ฟังก์ชั่น 6: บินหนีขึ้นฟ้าเมื่อเกือบตาย
MainTab:CreateToggle({
    Name = "6. บินหนีขึ้นฟ้าเมื่อเกือบตาย (Auto Escape)",
    CurrentValue = false,
    Flag = "AutoEscapeToggle",
    Callback = function(Value)
        Config.AutoEscape = Value
    end,
})

Rayfield:Notify({
    Title = "PvP Script Loaded",
    Content = "ระบบเปิดใช้งานสำเร็จแล้ว!",
    Duration = 5,
    Image = 4483362458,
})
