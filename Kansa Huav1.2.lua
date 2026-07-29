-- [[ 1. Load Maclib Library ]]
local Maclib = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodline-script/Maclib/main/maclib.lua"))()

-- [[ 2. Create Main Window ]]
local Window = Maclib:CreateWindow({
    Name = "PvP & Utility Hub",
    LoadingTitle = "Loading Script...",
    LoadingSubtitle = "by Assistant",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MaclibSettings",
        FileName = "PvP_Config"
    }
})

-- [[ 3. Create Tabs ]]
local MainTab = Window:Tab({ Name = "ฟังชั่นหลัก (PvP)" })
local SubTab = Window:Tab({ Name = "ฟังชั่นรอง (Utility & Farm)" })

-- ==========================================
-- ⚔️ ฟังชั่นหลัก (PvP)
-- ==========================================
local MainGroup = MainTab:Section({ Name = "ระบบต่อสู้ & เคลื่อนที่" })

-- 1. กระสุนติดตามยิงทะลุกำแพง
local SilentAimToggle = false
MainGroup:Toggle({
    Name = "1. กระสุนติดตาม / ยิงทะลุกำแพง",
    Default = false,
    Callback = function(Value)
        SilentAimToggle = Value
        -- ใส่ Logic Silent Aim / Wallbang ตรงนี้
    end
})

-- 2. FOV ปรับได้ 1 ถึง 360
MainGroup:Slider({
    Name = "2. ปรับขนาด FOV (1-360)",
    Default = 90,
    Min = 1,
    Max = 360,
    Rounding = 0,
    Callback = function(Value)
        -- ใส่ Logic ปรับขนาด FOV Circle
    end
})

-- 3. วิ่งไวโดดสูงแบบไม่จำกัด
local InfiniteMoveToggle = false
MainGroup:Toggle({
    Name = "3. วิ่งไวโดดสูงไม่จำกัด (Inf Jump/Speed)",
    Default = false,
    Callback = function(Value)
        InfiniteMoveToggle = Value
    end
})

-- 4. รีเควศ (Auto Fire Target Block)
MainGroup:Toggle({
    Name = "4. รีเควศ (Spawn Galaxy Block)",
    Default = false,
    Callback = function(Value)
        _G.AutoGalaxy = Value
        task.spawn(function()
          
