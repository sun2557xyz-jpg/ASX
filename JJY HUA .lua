-- [[ Rayfield Interface Suite ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Galaxy Block Hub",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = false,
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main Features", 4483362458) -- Icon ID

-- ==================== [ Function 1: WalkSpeed ] ====================
local SpeedToggle = false
local SpeedValue = 16

MainTab:CreateToggle({
   Name = "ฟังชั่น 1: เพิ่มความเร็วการเดิน (WalkSpeed)",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedToggle = Value
      if not Value then
         if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

MainTab:CreateSlider({
   Name = "ปรับความเร็ว (1 - 10)",
   Range = {1, 10},
   Increment = 1,
   Suffix = "x Speed",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      SpeedValue = 16 + (Value * 5) -- คำนวณระดับความเร็วให้เหมาะสมกับการใช้งาน
   end,
})

-- Loop สำหรับอัปเดตความเร็วตลอดเวลา
task.spawn(function()
   while task.wait(0.1) do
      if SpeedToggle and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
      end
   end
end)

-- ==================== [ Function 2: Infinite Jump ] ====================
local InfiniteJumpEnabled = false

MainTab:CreateToggle({
   Name = "ฟังชั่น 2: กระโดดไม่จำกัด (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfiniteJumpEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:
      
