 -- [[ KAOJAO HUB V19.0 - ORIGINAL 6.3 + VASCAL ]] --
-- เครดิต: ข้าวเจ้า (Kao Jao) | ฐานจาก V6.3 ต้นฉบับ
-- อัปเดต: ยัดสคริปต์ Vascal Hitbox เข้าไปตามสั่ง!

repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- [[ CONFIGURATION (V6.3 ORIGINAL) ]]
local Config = {
    WalkSpeed = 16,
    InfJump = false,
    Noclip = false,
    ESP = false,
    SavedPos = nil,
    TargetName = "",
    InputTranslate = ""
}

-- [[ 1. ESP SYSTEM (V6.3 ORIGINAL) ]]
local function ApplyESP(player)
    local function CreateVisuals(char)
        if player == lp then return end
        if char:FindFirstChild("KaojaoHighlight") then char.KaojaoHighlight:Destroy() end
        if char:FindFirstChild("KaojaoTag") then char.KaojaoTag:Destroy() end
        task.wait(0.5)
        
        local Highlight = Instance.new("Highlight", char)
        Highlight.Name = "KaojaoHighlight"
        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
        Highlight.Enabled = Config.ESP

        local Billboard = Instance.new("BillboardGui", char)
        Billboard.Name = "KaojaoTag"
        Billboard.Size = UDim2.new(0, 200, 0, 50)
        Billboard.AlwaysOnTop = true
        Billboard.Enabled = Config.ESP

        local Label = Instance.new("TextLabel", Billboard)
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.new(1, 1, 1)
        Label.Font = Enum.Font.SourceSansBold

        local connection
        connection = RunService.Heartbeat:Connect(function()
            if not char or not char.Parent then connection:Disconnect() return end
            if Config.ESP and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((lp.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
                Label.Text = string.format("%s\n[%d m]", player.DisplayName or player.Name, dist)
                Billboard.Enabled = true; Highlight.Enabled = true
            else
                Billboard.Enabled = false; Highlight.Enabled = false
            end
        end)
    end
    player.CharacterAdded:Connect(CreateVisuals)
    if player.Character then CreateVisuals(player.Character) end
end
for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

-- [[ 2. UI WINDOW (V6.3 ORIGINAL STYLE) ]]
local Window = WindUI:CreateWindow({
    Title = "KAOJAO HUB V19.0 (ORIGINAL)",
    Icon = "shield-check",
    Author = "by ข้าวเจ้า",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
})

local MainTab = Window:Tab({ Title = "Main", Icon = "user" })
local TPTab = Window:Tab({ Title = "Teleport", Icon = "navigation" })
local TransTab = Window:Tab({ Title = "Translator", Icon = "languages" })
local TrollTab = Window:Tab({ Title = "Special/Troll", Icon = "ghost" })

-- [[ TAB: MAIN - ฟังก์ชันหลัก ]]
MainTab:Section({ Title = "ความสามารถพื้นฐาน" })
MainTab:Toggle({ Title = "เปิดใช้ ESP (เห็นทั้งแมพ)", Value = Config.ESP, Callback = function(v) Config.ESP = v end })
MainTab:Input({ Title = "WalkSpeed", Placeholder = "16", Callback = function(v) Config.WalkSpeed = tonumber(v) or 16 end })
MainTab:Toggle({ Title = "ทะลุกำแพง (Noclip)", Value = Config.Noclip, Callback = function(v) Config.Noclip = v end })
MainTab:Toggle({ Title = "กระโดดรัว (Inf Jump)", Value = Config.InfJump, Callback = function(v) Config.InfJump = v end })

-- [[ TAB: TELEPORT - วาร์ปหาคน ]]
TPTab:Section({ Title = "วาร์ปหาคน (พิมพ์ชื่อ)" })
TPTab:Input({ Title = "พิมพ์ชื่อผู้เล่น", Placeholder = "เช่น ข้าวเจ้า...", Callback = function(v) Config.TargetName = v end })
TPTab:Button({
    Title = "วาร์ปไปหาทันที",
    Callback = function()
        if Config.TargetName ~= "" then
            for _, p in pairs(Players:GetPlayers()) do
                if string.find(string.lower(p.Name), string.lower(Config.TargetName)) and p ~= lp and p.Character then
                    lp.Character:PivotTo(p.Character:GetPivot() * CFrame.new(0, 3, 0))
                end
            end
        end
    end
})

-- [[ TAB: TRANSLATOR - ระบบแปลภาษา ]]
TransTab:Section({ Title = "แปลไทย -> อังกฤษ (Auto Copy)" })
TransTab:Input({ Title = "พิมพ์คำไทย", Placeholder = "เช่น ฉันไม่มีเงิน...", Callback = function(v) Config.InputTranslate = v end })
local ResultBtn = TransTab:Button({ Title = "รอการแปล...", Callback = function() setclipboard(ResultBtn.Title) end })
TransTab:Button({
    Title = "แปลภาษาและคัดลอกทันที",
    Callback = function()
        if Config.InputTranslate ~= "" then
            local res = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=th&tl=en&dt=t&q=" .. game:GetService("HttpService"):UrlEncode(Config.InputTranslate))
            local decoded = game:GetService("HttpService"):JSONDecode(res)[1][1][1]
            ResultBtn:SetTitle(decoded); setclipboard(decoded)
            WindUI:Notify({Title = "สำเร็จ", Content = "คัดลอกลงเครื่องแล้ว!", Duration = 2})
        end
    end
})

-- [[ TAB: TROLL - อมตะ/บิน/แยกร่าง + VASCAL ]]
TrollTab:Section({ Title = "ระบบพิเศษ (ต้นฉบับ)" })
TrollTab:Button({ Title = "GOD MODE (อมตะ)", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/mascaracathub/Test-Script/refs/heads/main/obfuscated_script-1765900058766.lua.txt"))() end })
TrollTab:Button({ Title = "บิน (Fly)", Callback = function() loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")() end })
TrollTab:Button({ Title = "แยกร่าง (MARK)", Callback = function() Config.SavedPos = lp.Character:GetPivot() end })
TrollTab:Button({ Title = "กลับร่าง (TP BACK)", Callback = function() if Config.SavedPos then lp.Character:PivotTo(Config.SavedPos) end end })

-- [[ Aimlock UI + FOV Circle + Target Tracer ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Config ค่าเริ่มต้น
local ScriptEnabled = false
local FOV_RADIUS = 150
local LINE_COLOR = Color3.fromRGB(255, 0, 0)
local FOV_COLOR = Color3.fromRGB(255, 255, 255)
local AIM_PART = "Head"

-- =================================================================
-- 1. สร้างหน้าต่าง GUI
-- =================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimlockGui"
ScreenGui.ResetOnSpawn = false
-- ป้องกัน GUI หลุดถ้าใช้ Executor ทั่วไป
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Frame หลัก
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- ให้ลาก GUI ไปมาได้
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "🎯 AIMLOCK MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- ปุ่ม Toggle เปิด/ปิด
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) -- สีแดง (ปิด)
ToggleBtn.Text = "Status: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner", ToggleBtn)
BtnCorner.CornerRadius = UDim.new(0, 6)

-- ข้อความบอกค่า FOV
local FOVText = Instance.new("TextLabel")
FOVText.Size = UDim2.new(1, 0, 0, 20)
FOVText.Position = UDim2.new(0, 0, 0.52, 0)
FOVText.BackgroundTransparency = 1
FOVText.Text = "FOV Radius: " .. FOV_RADIUS
FOVText.TextColor3 = Color3.fromRGB(200, 200, 200)
FOVText.TextSize = 13
FOVText.Font = Enum.Font.SourceSans
FOVText.Parent = MainFrame

-- Slider FOV (1-800)
local SliderBackground = Instance.new("Frame")
SliderBackground.Size = UDim2.new(0.85, 0, 0, 10)
SliderBackground.Position = UDim2.new(0.075, 0, 0.70, 0)
SliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBackground.BorderSizePixel = 0
SliderBackground.Parent = MainFrame

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((FOV_RADIUS - 1) / 799, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBackground

local SliderCorner = Instance.new("UICorner", SliderBackground)
SliderCorner.CornerRadius = UDim.new(0, 4)
local FillCorner = Instance.new("UICorner", SliderFill)
FillCorner.CornerRadius = UDim.new(0, 4)

-- คำแนะนำด้านล่าง
local TipText = Instance.new("TextLabel")
TipText.Size = UDim2.new(1, 0, 0, 20)
TipText.Position = UDim2.new(0, 0, 0.85, 0)
TipText.BackgroundTransparency = 1
TipText.Text = "กด [ Insert ] เพื่อ ซ่อน/แสดง UI"
TipText.TextColor3 = Color3.fromRGB(120, 120, 120)
TipText.TextSize = 11
TipText.Font = Enum.Font.SourceSansItalic
TipText.Parent = MainFrame

-- =================================================================
-- 2. Drawing Elements (FOV & Line)
-- =================================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 60
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Filled = false
FOVCircle.Visible = ScriptEnabled
FOVCircle.Color = FOV_COLOR

local TargetLine = Drawing.new("Line")
TargetLine.Thickness = 2
TargetLine.Color = LINE_COLOR
TargetLine.Visible = false

-- =================================================================
-- 3. Logic & Events
-- =================================================================

-- การกดปุ่ม เปิด/ปิด ใน UI
ToggleBtn.MouseButton1Click:Connect(function()
    ScriptEnabled = not ScriptEnabled
    if ScriptEnabled then
        ToggleBtn.Text = "Status: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40) -- เปลี่ยนเป็นสีเขียว
    else
        ToggleBtn.Text = "Status: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) -- เปลี่ยนเป็นสีแดง
        TargetLine.Visible = false
    end
    FOVCircle.Visible = ScriptEnabled
end)

-- การลากสไลเดอร์ปรับ FOV (1 - 800)
local isDraggingSlider = false
local function UpdateSlider(input)
    local sliderWidth = SliderBackground.AbsoluteSize.X
    local mouseX = input.Position.X - SliderBackground.AbsolutePosition.X
    local clampedX = 
  
