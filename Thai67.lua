---------------------------------------------------------
-- [ VARIABLES - ตัวแปรควบคุมระบบทั้งหมด ] --
---------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Config Values
local Config = {
    WallbangAim = false,      -- 1. ความปลอดภัยไม่ให้เกมตรวจจับระบบแปลกปลอมฟังก์ชันล็อคหัว
        FOV_Size = 100,           -- 2. ขนาด FOV (1-360)
            ShowFOV = false,
                InfiniteJump = false,     -- 3. โดดสูง/โดดไม่จำกัด
                    AntiLockSpin = false,     -- 5. Airlock
                        ESP_Box = false,          -- 6. ESP ดูชื่อ/เลือด/ของ
                            ESP_Tracer = false,       -- 13. ดูคนเป็นเส้นเหนือหัว
                                ESP_Items = false,        -- 11. ดูของที่ตกได้
                                    ItemMagnet = false,       -- 7. ดูดของ/ดำดิน
                                        MagnetDistance = 10,      -- 7. ระยะดูดของ (1-100m)
                                            FlySpinAir = false,       -- 8. ล้มบินขึ้นฟ้าหมุนตัวไว
                                                WalkSpeedVal = 16,        -- 9. ความเร็ววิ่ง (1-40)
                                                    JumpPowerVal = 50,        -- 10. ความสูงโดด (1-10)
                                                        FastGun = false,          -- 12. ยิงไว
                                                            FastSell = false,         -- 14. ขายของไว
                                                                FastGacha = false,        -- 15. สุ่มของไว
                                                                    FarmHuntCombo = false,    -- 16. PvP-Farm
                                                                        FarmSpeed = 50,           -- 17. ความไวฟาร์ม (10-300)
                                                                            AutoDeposit = false,      -- 18. ออโต้ฝากเงิน
                                                                                DepositAmount = 1000,
                                                                                    AutoWork = false,         -- 19, 25. ทำงาน/ปลูกผัก-เก็บเกี่ยวอัตโนมัติ
                                                                                        NoVehicleFarm = false,    -- 21. ฟาร์มแบบไม่ใช้รถได้
                                                                                            AutoEscapeKnock = false,  -- 22, 24. โดนตีล้มแล้ววาร์ปหมุนขึ้นฟ้า/ลงดิน
                                                                                                EscapeSpeed = 20,         -- 24. ความเร็วการหมุน (10-50)
                                                                                                    FastAirDrop = false       -- 23. เก็บแอร์ดร็อปไว
                                                                                                    }

                                                                                                    ---------------------------------------------------------
                                                                                                    -- [ CIRCLE FOV - วงกลม FOV ] --
                                                                                                    ---------------------------------------------------------
                                                                                                    local FOVCircle = Drawing.new("Circle")
                                                                                                    FOVCircle.Color = Color3.fromRGB(255, 0, 0)
                                                                                                    FOVCircle.Thickness = 1.5
                                                                                                    FOVCircle.NumSides = 60
                                                                                                    FOVCircle.Filled = false
                                                                                                    FOVCircle.Visible = false

                                                                                                    RunService.RenderStepped:Connect(function()
                                                                                                        FOVCircle.Radius = Config.FOV_Size
                                                                                                            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                                                                                                                FOVCircle.Visible = Config.ShowFOV
                                                                                                                end)

                                                                                                                ---------------------------------------------------------
                                                                                                                -- [ MAIN LOOPS & FUNCTIONS - ระบบคำนวณหลัก ] --
                                                                                                                ---------------------------------------------------------

                                                                                                                -- 3. Infinite Jump (โดดไม่จำกัด)
                                                                                                                game:GetService("UserInputService").JumpRequest:Connect(function()
                                                                                                                    if Config.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                                                                                                                            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                                                                                                                                end
                                                                                                                                end)

                                                                                                                                -- Loop หลักสำหรับจัดการ Speed / Anti-Lock Spin / Anti-Knock Escape
                                                                                                                                RunService.Stepped:Connect(function()
                                                                                                                                    pcall(function()
                                                                                                                                            local char = LocalPlayer.Character
                                                                                                                                                    if not char then return end
                                                                                                                                                            local hum = char:FindFirstChildOfClass("Humanoid")
                                                                                                                                                                    local root = char:FindFirstChild("HumanoidRootPart")

                                                                                                                                                                            -- 9. ปรับความเร็ววิ่ง & 10. โดดสูง
                                                                                                                                                                                    if hum then
                                                                                                                                                                                                hum.WalkSpeed = Config.WalkSpeedVal
                                                                                                                                                                                                            hum.JumpPower = Config.JumpPowerVal * 10
                                                                                                                                                                                                                    end

                                                                                                                                                                                                                            -- 5. กันล็อกหมุน 360°
                                                                                                                                                                                                                                    if Config.AntiLockSpin and root then
                                                                                                                                                                                                                                                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0)
                                                                                                                                                                                                                                                        end

                                                                                                                                                                                                                                                                -- 8 & 22 & 24. โดนตีล้ม / วาร์ปหมุนขึ้นฟ้าหรือลงดิน
                                                                                                                                                                                                                                                                        if (Config.FlySpinAir or Config.AutoEscapeKnock) and root then
                                                                                                                                                                                                                                                                                    -- เช็คว่าตัวละครล้มหรือโดนสถานะ Knock
                                                                                                                                                                                                                                                                                                if hum and hum:GetState() == Enum.HumanoidStateType.Physics or hum.Health < 15 then
                                                                                                                                                                                                                                                                                                                root.CFrame = root.CFrame * CFrame.new(0, 50, 0) * CFrame.Angles(0, math.rad(Config.EscapeSpeed), 0)
                                                                                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                                                                                                    end
                                                                                                                                                                                                                                                                                                                                        end)
                                                                                                                                                                                                                                                                                                                                        end)

                                                                                                                                                                                                                                                                                                                                        -- 12. Fast Gun (ยิงไว)
                                                                                                                                                                                                                                                                                                                                        task.spawn(function()
                                                                                                                                                                                                                                                                                                                                            while true do
                                                                                                                                                                                                                                                                                                                                                    task.wait(0.02)
                                                                                                                                                                                                                                                                                                                                                            if Config.FastGun then
                                                                                                                                                                                                                                                                                                                                                                        pcall(function()
                                                                                                                                                                                                                                                                                                                                                                                        VirtualUser:CaptureController()
                                                                                                                                                                                                                                                                                                                                                                                                        VirtualUser:Button1Down(Vector2.new(0, 0))
                                                                                                                                                                                                                                                                                                                                                                                                                        VirtualUser:Button1Up(Vector2.new(0, 0))
                                                                                                                                                                                                                                                                                                                                                                                                                                    end)
                                                                                                                                                                                                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                                                                                                                                                                                                                end
                                                                                                                                                                                                                                                                                                                                                                                                                                                end)

                                                                                                                                                                                                                                                                                                                                                                                                                                                -- 7. ดูดของ / ดำดิน (Magnet)
                                                                                                                                                                                                                                                                                                                                                                                                                                                task.spawn(function()
                                                                                                                                                                                                                                                                                                                                                                                                                                                    while true do
                                                                                                                                                                                                                                                                                                             
