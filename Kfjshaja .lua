local Window = WindUI:CreateWindow({
    Title = "My Super Hub",
    Icon = "door-open", -- lucide icon
    Author = "by .ftgs and .ftgs",
    Folder = "MySuperHub",
    
    -- ↓ This all is Optional. You can remove it.
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.LeftShift,
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    -- ↓ Optional. You can remove it.
    --[[ You can set 'rbxassetid://' or video to Background.
        'rbxassetid://':
            Background = "rbxassetid://", -- rbxassetid
        Video:
            Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
    --]]
    
    -- ↓ Optional. You can remove it.
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
    
    --       remove this all, 
    -- !  ↓  if you DON'T need the key system
    KeySystem = { 
        -- ↓ Optional. You can remove it.
        Key = { "1234", "5678" },
        
        Note = "Example Key System.",
        
        -- ↓ Optional. You can remove it.
        Thumbnail = {
            Image = "rbxassetid://",
            Title = "Thumbnail",
        },
        
        -- ↓ Optional. You can remove it.
        URL = "YOUR LINK TO GET KEY (Discord, Linkvertise, Pastebin, etc.)",
        
        -- ↓ Optional. You can remove it.
        SaveKey = false, -- automatically save and load the key.
        
        -- ↓ Optional. You can remove it.
        -- API = {} ← Services. Read about it below ↓
    },
})local Window = WindUI:CreateWindow({
    -- ...
    
    KeySystem = {                                                               
        Note = "Example Key System. With platoboost, etc.",                     
        API = {                                                                 
            { -- PlatoBoost
                --[[ Here you can write your title, description, and icon --]]
                Title = "Platoboost",-- optional . you can remove it
                Desc = "Click to copy.", -- optional . you can remove it
                Icon = "rbxassetid://", -- optional . you can remove it
                
                Type = "platoboost", -- type
                ServiceId = 1234, -- service id
                Secret = "platoboost-secret", -- platoboost secret
            },                                                                  
            { -- Panda development
                Type = "pandadevelopment", -- type
                ServiceId = "myServiceId", -- service id
            },                                                                  
        },                                                                      
    },                                                                          
})--              ↓ Change this to your service (like `luarmor`, `platoboost`, `keyguardian`)
WindUI.Services.mysuperservicetogetkey = {
    Name = "My Super Service",
    Icon = "droplet", -- <-- lucide or rbxassetid or raw link to img
    
    Args = { "ServiceId", "SuperId" }, --      <- \
                                       --         |
    New = function(ServiceId, SuperId) -- <------ | Args!!!!!!!!!!!!
        function validateKey(key) -- <--- this too important!!!
            -- your function to validate key
            -- see examples at src/utils/ in WindUI Repo
            
            if not key then
                return false, "Key is invalid!" 
                
            end
            
            return true, "Key is valid!" 
        end
        
        function copyLink()
            return setclipboard("link to key system service.")
        end
        
        return {
            --↓↓ do not change this!!
            Verify = validateKey, -- <-- important!!!
            Copy = copyLink -- <-- important!!!
        }
    end
}local Window = WindUI:CreateWindow({
    -- ...
    
    KeySystem = {
        Note = "...",
        API = {
            {
                Type = "mysuperservicetogetkey",
                ServiceId = 1234",
                SuperId = 1234",
            },
        },
    },
})local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird", -- optional
    Locked = false,
})Tab:Select() -- Select Tablocal Section = Window:Section({
    Title = "Section for the tabs",
    Icon = "bird",
    Opened = true,
})local Dialog = Window:Dialog({
    Icon = "bird",
    Title = "Dialog Title",
    Content = "Content Text",
    Buttons = {
        {
            Title = "Confirm",
            Callback = function()
                print("Confirmed!")
            end,
        },
        {
            Title = "Cancel",
            Callback = function()
                print("Cancelled!")
            end,
      
