-- โหลด Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้าง Window หลัก
local Window = Rayfield:CreateWindow({
   Name = "Custom Hub | Main Menu",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "By Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   KeySystem = false
})

-- สร้าง Tab หลัก
local MainTab = Window:CreateTab("Main Functions", 4483362458)

-- ==========================================
-- สร้างปุ่มเปิด-ปิด UI หน้าจอ (Floating Button)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "RayfieldToggleButtonGui"

ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "UI"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18.000
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- สามารถลากปุ่มไปวางตำแหน่งอื่นได้

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.K, false, game)
end)

-- ==========================================
-- ฟังก์ชันที่ 1: วิ่งไว ปรับได้ 1 ถึง 10
-- ==========================================
MainTab:CreateSlider({
   Name = "ปรับความเร็วการวิ่ง (Speed Boost)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
       local character = game.Players.LocalPlayer.Character
       if character and character:FindFirstChild("Humanoid") then
           -- ความเร็วปกติของ Roblox คือ 16 คูณด้วยค่าที่เลือก (1 ถึง 10)
           character.Humanoid.WalkSpeed = 16 * Value
       end
   end,
})

-- ==========================================
-- ฟังก์ชันที่ 2: กระโดดไม่จำกัด (Infinite Jump)
-- ==========================================
local InfiniteJumpEnabled = false

MainTab:CreateToggle({
   Name = "กระโดดไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpToggle",
   Callback = function(Value)
       InfiniteJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)

-- ==========================================
-- ฟังก์ชันที่ 3: แยกร่างรถ (ตัวละครซ่อน + สปอว์นรถ)
-- ==========================================
MainTab:CreateButton({
   Name = "แยกร่างรถ (Invisible Character + Spawn Block/Car)",
   Callback = function()
       local player = game.Players.LocalPlayer
       local character = player.Character
       
       -- 1. ซ่อนตัวละคร (ทำ Transparency = 1 ทุกชิ้นส่วน)
       if character then
           for _, part in pairs(character:GetDescendants()) do
               if part:IsA("BasePart") or part:IsA("Decal") then
                   part.Transparency = 1
               end
           end
       end
       
       -- 2. ยิง Event สปอว์นบล็อก/รถ ตามที่คุณกำหนด
       local success, err = pcall(function()
           game:GetService("ReplicatedStorage").SpawnGalaxyBlockEvent:FireServer()
       end)
       
       if not success then
           warn("ไม่สามารถส่ง Event ได้:", err)
       end
   end,
})

-- ปรับปรุงการคงค่า WalkSpeed เวลาตัวละคร Respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    Rayfield:SetFolder("RayfieldConfigs")
end)
