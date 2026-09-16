-- โหลด Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- สร้างหน้าต่างหลัก
local Window = Rayfield:CreateWindow({
   Name = "Developer Test Menu",
   LoadingTitle = "กำลังโหลดระบบ...",
   LoadingSubtitle = "by Developer",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- สร้าง Tab สำหรับควบคุม
local MainTab = Window:CreateTab("Player Control", 4483362458)
local EventTab = Window:CreateTab("Events", 4483362458)

-- 1. ระบบปรับความเร็วตัวละคร (WalkSpeed 1-10)
MainTab:CreateSlider({
   Name = "ปรับความเร็วการวิ่ง (WalkSpeed)",
   Range = {1, 10},
   Increment = 1,
   Suffix = " Level",
   CurrentValue = 1,
   Flag = "SpeedSlider",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         -- ปรับตามระดับ 1-10 (ความเร็วพื้นฐาน Roblox คือ 16)
         char.Humanoid.WalkSpeed = 16 + (Value * 5)
      end
   end,
})

-- 2. ระบบเลือกชื่อผู้เล่นเพื่อวาร์ปไปหา (Player Teleport)
local playersList = {}
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer then
        table.insert(playersList, player.Name)
    end
end

local SelectedPlayer = ""
MainTab:CreateDropdown({
   Name = "เลือกผู้เล่นที่จะวาร์ปไปหา",
   Options = playersList,
   CurrentOption = "",
   Flag = "PlayerDropdown",
   Callback = function(Option)
      SelectedPlayer = Option[1] or Option
   end,
})

MainTab:CreateButton({
   Name = "วาร์ปไปหาผู้เล่นที่เลือก",
   Callback = function()
      if SelectedPlayer ~= "" then
         local targetPlayer = game.Players:FindFirstChild(SelectedPlayer)
         local localChar = game.Players.LocalPlayer.Character
         if targetPlayer and targetPlayer.Character and localChar and localChar:FindFirstChild("HumanoidRootPart") then
            localChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
         end
      end
   end,
})

-- 3. ระบบส่งสัญญาณ SpawnGalaxyBlock ไปยัง Server
EventTab:CreateButton({
   Name = "รัน Event: SpawnGalaxyBlock",
   Callback = function()
      local replicatedStorage = game:GetService("ReplicatedStorage")
      local event = replicatedStorage:FindFirstChild("SpawnGalaxyBlock")
      if event and event:IsA("RemoteEvent") then
         event:FireServer()
         Rayfield:Notify({
            Title = "สำเร็จ",
            Content = "ส่งสัญญาณ SpawnGalaxyBlock เรียบร้อย",
            Duration = 3,
         })
      else
         Rayfield:Notify({
            Title = "ข้อผิดพลาด",
            Content = "ไม่พบ SpawnGalaxyBlock ใน ReplicatedStorage",
            Duration = 3,
         })
      end
   end,
})
