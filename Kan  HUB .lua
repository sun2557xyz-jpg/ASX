-- [[ KAN HUB V19.0 - ORIGINAL 6.3 + VASCAL ]] --
-- เครดิต: กันครับ (KAN) | ฐานจาก V6.3 ต้นฉบับ
-- อัปเดต: ยัดสคริปต์ Vascal Hitbox เข้าไปตามสั่ง!

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ CONFIGURATION (V6.3 ORIGINAL) ]]
local Config = {
   FOV
   Person
    WalkSpeed = 16,
    InfJump = false,
    Noclip = false,
    ESP = false,Name,Phase,Blood,Watch
    SavedPos = nil,
    TargetName = "",
    InputTranslate = ""
}
ฟังชั่นหลักFOV
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration (ตั้งค่า FOV ตรงนี้)
local FOVSettings = {
    Enabled = true,
    FOVRadius = 1-120,          -- ขนาดของรัศมี FOV (ยิ่งเยอะยิ่งเล็งกว้าง)
    FOVColor = Color3.fromRGB(255, 255, 255), -- สีของเส้นวงกลม (ขาว)
    TargetColor = Color3.fromRGB(255, 0, 0),  เมื่อเจอเป้าหมาย (เล็งไปหาเป้าหมาย)
     
    LockPart = "HumanoidRootPart" -- ชิ้นส่วนที่จะเล็ง ("Head" หรือ "HumanoidRootPart")
}


