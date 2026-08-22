-- ==========================================
-- CONFIGURATION & VARIABLES
-- ==========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- อัปเดตตัวแปร Character เมื่อผู้เล่นตายแล้วเกิดใหม่
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

-- Event สปอนบล็อกที่คุณระบุ
local spawnGalaxyEvent = ReplicatedStorage:WaitForChild("SpawnGalaxyBlock")

-- สถานะการเปิด-ปิด ฟังก์ชันต่างๆ
local Toggles = {
    Speed = false,
    InfJump = false,
    Invisibility = false
}

-- ตั้งค่าความเร็ว (ปรับเพิ่ม-ลดได้ตั้งแต่ 1 ถึง 10)
local speedLevel = 5 -- ค่าเริ่มต้น (1 = ความเร็วปกติ, 10 = เร็วมาก)
local baseSpeed = 16  -- ความเร็วพื้นฐานของ Roblox

-- ==========================================
-- FUNCTION 1: ระบบวิ่งไว (Speed Hack 1-10)
-- ==========================================
local function setSpeedLevel(level)
    speedLevel = math.clamp(level, 1, 10)
end

RunService.RenderStepped:Connect(function()
    if Toggles.Speed and humanoid then
        -- คำนวณความเร็ว: ระดับ 1 = 16, ระดับ 10 = 160
        humanoid.WalkSpeed = baseSpeed * speedLevel
    elseif humanoid and not Toggles.Speed then
        humanoid.WalkSpeed = baseSpeed
    end
end)

-- ==========================================
-- FUNCTION 2: กระโดดไม่จำกัด (Infinite Jump)
-- ==========================================
UserInputService.JumpRequest:Connect(function()
    if Toggles.InfJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==========================================
-- FUNCTION 3: แยกร่าง / รถตัวละครหาย (Invisibility)
-- ==========================================
local function toggleInvisibility(state)
    Toggles.Invisibility = state
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = state and 1 or 0
            end
        elseif part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        end
    end
end

-- ลูปเพื่อให้ตัวละครซ่อนอยู่ตลอดแม้มีการอัปเดตโมเดล
RunService.RenderStepped:Connect(function()
    if Toggles.Invisibility and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = 1
            end
        end
    end
end)

-- ==========================================
-- SYSTEM CONTROLS (ปุ่มคีย์ลัดสำหรับเปิด-ปิด)
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- กด Z : เปิด/ปิด วิ่งไว
    if input.KeyCode == Enum.KeyCode.Z then
        Toggles.Speed = not Toggles.Speed
        print("Speed Toggle:", Toggles.Speed, "| Level:", speedLevel)
        
    -- กด X : เปิด/ปิด กระโดดไม่จำกัด
    elseif input.KeyCode == Enum.KeyCode.X then
        Toggles.InfJump = not Toggles.InfJump
        print("Infinite Jump Toggle:", Toggles.InfJump)

    -- กด C : เปิด/ปิด แยกร่าง (ล่องหน)
    elseif input.KeyCode == Enum.KeyCode.C then
        toggleInvisibility(not Toggles.Invisibility)
        print("Invisibility Toggle:", Toggles.Invisibility)

    -- กด B : เรียกใช้ Event สปอน Galaxy Block
    elseif input.KeyCode == Enum.KeyCode.B then
        if spawnGalaxyEvent then
            spawnGalaxyEvent:FireServer()
            print("Spawn Galaxy Block Event Fired!")
        end
    end
end)

-- ตัวอย่างวิธีเปลี่ยนระดับความเร็วในโค้ด (ปรับเลข 1-10 ตามต้องการ)
setSpeedLevel(5) 
