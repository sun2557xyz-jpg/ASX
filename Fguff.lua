-- ผลิตโดย Hypol-X
local Library = loadstring(game:HttpGetAsync("https://pastefy.app/YoX4PJmf/raw"))()

-- // 2. ตั้งค่าผู้ใช้ที่อนุญาตพิเศษสำหรับการเข้าถึงแบบชำระเงิน
Library.WhitelistedUsers = {
    "ชื่อผู้ใช้",
    "ชื่อผู้ใช้1"
    "ชื่อผู้ใช้2"
    "ชื่อผู้ใช้3"
    "Username4" -- รายชื่ออนุญาตไม่จำกัด คุณสามารถเพิ่มชื่อผู้ใช้ได้อีกสองชื่อสำหรับแท็บคุณสมบัติการเข้าถึงแบบชำระเงิน
}

-- // 3. สร้างหน้าต่างหลัก
หน้าต่างภายใน = ไลบรารี:สร้างหน้าต่าง({
    ชื่อเรื่อง = "Yomby Sky"
    คำบรรยายย่อย = "ig @ys8_sky"
    สีคำบรรยายย่อย = Color3.fromRGB(190, 140, 255),
    -- แก้ไขรหัสรูปภาพโลโก้ด้านล่าง (ซึ่งจะแสดงผลภายในแถบด้านบน)
    โลโก้ = "rbxthumb://type=Asset&id=78676953786689&w=150&h=150",
    LogoSize = 32, -- ปรับขนาดโลโก้แถบด้านบนได้ที่นี่โดยอิสระ
    
    -- // การกำหนดค่าการสลับทรงกลม //
    SphereText = false, -- ตั้งค่าเป็น true เพื่อให้ข้อความมีความสำคัญมากกว่ารูปภาพ
    SphereWords = "ZX", -- ข้อความที่กำหนดเองที่จะแสดงหาก SphereText เป็นจริง
    SphereImage = "rbxassetid://82367817676382",
    SphereIconSize = 38 -- ปรับขนาดไอคอนทรงกลมได้ที่นี่โดยอิสระ
})




-- // =========================================== //
-- // แท็บการตั้งค่า
-- // =========================================== //
local SettingsTab = Window:CreateTab("Settings", false, false)

local S_Page1 = SettingsTab:CreatePage("การตั้งค่า")

ท้องถิ่น AppearanceCard = S_Page1:CreateSection("UI ๐Ÿ˜ต•€ ๐Ÿ'z")
AppearanceCard:AddToggle("Transparency Toggle", false, function(state)
    Window:SetTransparency(state and 0.2 or 0)
จบ, {
    ชื่อเรื่อง = "สถาปัตยกรรมกระจก"
    คำอธิบาย = "แทนที่พื้นหลังหน้าต่างหลักด้วยความโปร่งใส 0.2 ที่ดูเรียบหรู"
})

local SavesCard = S_Page1:CreateSection("๐Ÿคฏ")
SavesCard:AddConfigManager("zyronxSavers") -- zyronxSavers นี่คือชื่อไฟล์ ถ้าคุณต้องการสร้างสคริปต์จากไฟล์คอนฟิกนี้ ให้เปลี่ยนชื่อไฟล์เป็น zyronxSavers

-- // =========================================== //
-- // แท็บพรีเมียม (เฉพาะผู้ที่ได้รับอนุญาตเท่านั้น)
-- // =========================================== //
local PremiumTab = Window:CreateTab("Pro Configs", false, true)

local P_Page1 = PremiumTab:CreatePage("Page 1")

ProCard ท้องถิ่น = P_Page1:CreateSection("VPA")
ProCard:AddToggle("Premium Override", false, function(state) print("Override:", state) end, {
    ชื่อเรื่อง = "การอัปเกรดระดับพรีเมียม"
    คำอธิบาย = "คันโยกสวิตช์แบบพิเศษสำหรับปลดล็อกโมดูลระดับพรีเมียม"
    ตัวอย่าง = "เปิดใช้งานเพื่อข้ามการตรวจสอบความปลอดภัยและปลดล็อกเครื่องมือการดำเนินการเพิ่มเติม"
})
ProCard:AddButton("เรียกใช้สคริปต์ตัวอย่าง", function() print("กำลังเรียกใช้สคริปต์...") end, {
    หัวข้อ = "เรียกใช้สคริปต์"
    คำอธิบาย = "ปุ่มตัวอย่างที่ใช้งานได้จริง ซึ่งเรียกใช้โค้ดของนักพัฒนาที่มีสิทธิ์พิเศษ"
    ตัวอย่าง = "การคลิกที่นี่จะเรียกใช้บล็อกสคริปต์แบบกำหนดเองที่ตั้งไว้ล่วงหน้าด้านล่างทันที"
})
