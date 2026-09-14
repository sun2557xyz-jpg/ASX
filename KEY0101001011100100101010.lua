-- โหลด Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("PvP Utility UI", "DarkTheme")

-- สร้าง Tab และ Section
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Functions")

-- ปุ่มเรียกใช้ RemoteEvent
MainSection:NewButton("Spawn Galaxy Block", "Fires the SpawnGalaxyBlock RemoteEvent", function()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local event = replicatedStorage:FindFirstChild("SpawnGalaxyBlock")
    if event then
        event:FireServer()
    end
end)

-- ปุ่มตั้งค่าเปิด-ปิด (Toggle)
MainSection:NewToggle("Enable Feature 1", "Toggle feature state", function(state)
    if state then
        print("Feature Enabled")
    else
        print("Feature Disabled")
    end
end)

-- แถบปรับระดับ (Slider)
MainSection:NewSlider("FOV Radius", "Adjust FOV Size", 1600, 150, function(value)
    print("FOV set to:", value)
end)

-- ตั้งค่าปุ่มซ่อน/แสดง UI (Toggle Keybind)
MainTab:NewSection("Settings"):NewKeybind("Toggle UI", "Keybind to open/close UI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)
