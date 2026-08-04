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
        Highlight.Name = "KANHighlight"
        Highlight.FillColor = Color3.fromRGB(255, 0, 0)
        Highlight.Enabled = Config.ESP

        local Billboard = Instance.new("BillboardGui", char)
        Billboard.Name = "KanTag"
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
    Author = "by กันครับ",
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
            local res = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=th&tl=en&dt=t&q=" .. game:GetService("HttpService"):UrlEncode(Config.
