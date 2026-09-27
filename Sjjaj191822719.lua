---------------------------------------------------------
-- [ VARIABLES - เธ•เธฑเธงเนเธเธฃเธเธงเธเธเธธเธกเธฃเธฐเธเธเธ—เธฑเนเธเธซเธกเธ” ] --
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
    WallbangAim = false,      -- 1. เธเธงเธฒเธกเธเธฅเธญเธ”เธ เธฑเธขเนเธกเนเนเธซเนเน€เธเธกเธ•เธฃเธงเธเธเธฑเธเธฃเธฐเธเธเนเธเธฅเธเธเธฅเธญเธกเธเธฑเธเธเนเธเธฑเธเธฅเนเธญเธเธซเธฑเธง
        FOV_Size = 100,           -- 2. เธเธเธฒเธ” FOV (1-360)
            ShowFOV = false,
                InfiniteJump = false,     -- 3. เนเธ”เธ”เธชเธนเธ/เนเธ”เธ”เนเธกเนเธเธณเธเธฑเธ”
                    AntiLockSpin = false,     -- 5. Airlock
                        ESP_Box = false,          -- 6. ESP เธ”เธนเธเธทเนเธญ/เน€เธฅเธทเธญเธ”/เธเธญเธ
                            ESP_Tracer = false,       -- 13. เธ”เธนเธเธเน€เธเนเธเน€เธชเนเธเน€เธซเธเธทเธญเธซเธฑเธง
                                ESP_Items = false,        -- 11. เธ”เธนเธเธญเธเธ—เธตเนเธ•เธเนเธ”เน
                                    ItemMagnet = false,       -- 7. เธ”เธนเธ”เธเธญเธ/เธ”เธณเธ”เธดเธ
                                        MagnetDistance = 10,      -- 7. เธฃเธฐเธขเธฐเธ”เธนเธ”เธเธญเธ (1-100m)
                                            FlySpinAir = false,       -- 8. เธฅเนเธกเธเธดเธเธเธถเนเธเธเนเธฒเธซเธกเธธเธเธ•เธฑเธงเนเธง
                                                WalkSpeedVal = 16,        -- 9. เธเธงเธฒเธกเน€เธฃเนเธงเธงเธดเนเธ (1-40)
                                                    JumpPowerVal = 50,        -- 10. เธเธงเธฒเธกเธชเธนเธเนเธ”เธ” (1-10)
                                                        FastGun = false,          -- 12. เธขเธดเธเนเธง
                                                            FastSell = false,         -- 14. เธเธฒเธขเธเธญเธเนเธง
                                                                FastGacha = false,        -- 15. เธชเธธเนเธกเธเธญเธเนเธง
                                                                    FarmHuntCombo = false,    -- 16. PvP-Farm
                                                                        FarmSpeed = 50,           -- 17. เธเธงเธฒเธกเนเธงเธเธฒเธฃเนเธก (10-300)
                                                                            AutoDeposit = false,      -- 18. เธญเธญเนเธ•เนเธเธฒเธเน€เธเธดเธ
                                                                                DepositAmount = 1000,
                                                                                    AutoWork = false,         -- 19, 25. เธ—เธณเธเธฒเธ/เธเธฅเธนเธเธเธฑเธ-เน€เธเนเธเน€เธเธตเนเธขเธงเธญเธฑเธ•เนเธเธกเธฑเธ•เธด
                                                                                        NoVehicleFarm = false,    -- 21. เธเธฒเธฃเนเธกเนเธเธเนเธกเนเนเธเนเธฃเธ–เนเธ”เน
                                                                                            AutoEscapeKnock = false,  -- 22, 24. เนเธ”เธเธ•เธตเธฅเนเธกเนเธฅเนเธงเธงเธฒเธฃเนเธเธซเธกเธธเธเธเธถเนเธเธเนเธฒ/เธฅเธเธ”เธดเธ
                                                                                                EscapeSpeed = 20,         -- 24. เธเธงเธฒเธกเน€เธฃเนเธงเธเธฒเธฃเธซเธกเธธเธ (10-50)
                                                                                                    FastAirDrop = false       -- 23. เน€เธเนเธเนเธญเธฃเนเธ”เธฃเนเธญเธเนเธง
                                                                                                    }

                                                                                                    ---------------------------------------------------------
                                                                                                    -- [ CIRCLE FOV - เธงเธเธเธฅเธก FOV ] --
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
                                                                                                                -- [ MAIN LOOPS & FUNCTIONS - เธฃเธฐเธเธเธเธณเธเธงเธ“เธซเธฅเธฑเธ ] --
                                                                                                                ---------------------------------------------------------

                                                                                                                -- 3. Infinite Jump (เนเธ”เธ”เนเธกเนเธเธณเธเธฑเธ”)
                                                                                                                game:GetService("UserInputService").JumpRequest:Connect(function()
                                                                                                                    if Config.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                                                                                                                            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                                                                                                                                end
                                                                                                                                end)

                                                                                                                                -- Loop เธซเธฅเธฑเธเธชเธณเธซเธฃเธฑเธเธเธฑเธ”เธเธฒเธฃ Speed / Anti-Lock Spin / Anti-Knock Escape
                                                                                                                                RunService.Stepped:Connect(function()
                                                                                                                                    pcall(function()
                                                                                                                                            local char = LocalPlayer.Character
                                                                                                                                                    if not char then return end
                                                                                                                                                            local hum = char:FindFirstChildOfClass("Humanoid")
                                                                                                                                                                    local root = char:FindFirstChild("HumanoidRootPart")

                                                                                                                                                                            -- 9. เธเธฃเธฑเธเธเธงเธฒเธกเน€เธฃเนเธงเธงเธดเนเธ & 10. เนเธ”เธ”เธชเธนเธ
                                                                                                                                                                                    if hum then
                                                                                                                                                                                                hum.WalkSpeed = Config.WalkSpeedVal
                                                                                                                                                                                                            hum.JumpPower = Config.JumpPowerVal * 10
                                                                                                                                                                                                                    end

                                                                                                                                                                                                                            -- 5. เธเธฑเธเธฅเนเธญเธเธซเธกเธธเธ 360ยฐ
                                                                                                                                                                                                                                    if Config.AntiLockSpin and root then
                                                                                                                                                                                                                                                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0)
                                                                                                                                                                                                                                                        end

                                                                                                                                                                                                                                                                -- 8 & 22 & 24. เนเธ”เธเธ•เธตเธฅเนเธก / เธงเธฒเธฃเนเธเธซเธกเธธเธเธเธถเนเธเธเนเธฒเธซเธฃเธทเธญเธฅเธเธ”เธดเธ
                                                                                                                                                                                                                                                                        if (Config.FlySpinAir or Config.AutoEscapeKnock) and root then
                                                                                                                                                                                                                                                                                    -- เน€เธเนเธเธงเนเธฒเธ•เธฑเธงเธฅเธฐเธเธฃเธฅเนเธกเธซเธฃเธทเธญเนเธ”เธเธชเธ–เธฒเธเธฐ Knock
                                                                                                                                                                                                                                                                                                if hum and hum:GetState() == Enum.HumanoidStateType.Physics or hum.Health < 15 then
                                                                                                                                                                                                                                                                                                                root.CFrame = root.CFrame * CFrame.new(0, 50, 0) * CFrame.Angles(0, math.rad(Config.EscapeSpeed), 0)
                                                                                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                                                                                                    end
                                                                                                                                                                                                                                                                                                                                        end)
                                                                                                                                                                                                                                                                                                                                        end)

                                                                                                                                                                                                                                                                                                                                        -- 12. Fast Gun (เธขเธดเธเนเธง)
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                -- 7. เธ”เธนเธ”เธเธญเธ / เธ”เธณเธ”เธดเธ (Magnet)
                                                                                                                                                            
