-- Import PROG-404 Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PROG-404/really/refs/heads/main/PORG-404-LY.lua"))()

-- Create PROG-404 GUI
local PROG404 = {}

-- Create GUI
function PROG404:Create(title, theme)
    self.GUI = Library:CreateGUI({
        Title = title or "PROG-404 GUI",
        Theme = theme or "Dark" -- Can change theme color
    })
    self.Tabs = {}  -- Store tabs by their ID
    return self
end

-- Add a new Tab with an easy ID
function PROG404:AddTab(tabID, name)
    local tab = self.GUI:AddTab({
        Title = name or "New Tab"
    })
    self.Tabs[tabID] = tab
    return tab
end

-- Add Button to a Tab with simple parameters
function PROG404:AddButton(tabID, text, callback)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddButton({
        Text = text or "Button",
        Callback = callback or function() print("Button clicked!") end
    })
end

-- Add Toggle to a Tab with simple parameters
function PROG404:AddToggle(tabID, text, default, callback)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddToggle({
        Text = text or "Toggle",
        Default = default or false,
        Callback = callback or function(state) print("Toggle state:", state) end
    })
end

-- Add Slider to a Tab with simple parameters
function PROG404:AddSlider(tabID, text, min, max, default, callback)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddSlider({
        Text = text or "Slider",
        Min = min or 0,
        Max = max or 100,
        Default = default or min,
        Callback = callback or function(value) print("Slider value:", value) end
    })
end

-- Add Dropdown to a Tab with simple parameters
function PROG404:AddDropdown(tabID, text, options, callback)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddDropdown({
        Text = text or "Dropdown",
        Options = options or {"Option 1", "Option 2", "Option 3"},
        Callback = callback or function(selected) print("Selected option:", selected) end
    })
end

-- Add Textbox to a Tab with simple parameters
function PROG404:AddTextbox(tabID, text, default, callback)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddTextbox({
        Text = text or "Textbox",
        Default = default or "",
        Callback = callback or function(input) print("Textbox input:", input) end
    })
end

-- Show Loading Message with simple usage
function PROG404:ShowLoading(message, duration)
    local loading = self.GUI:ShowLoading({
        Message = message or "Loading, please wait..."
    })
    task.wait(duration or 3)
    loading:Close()
end

-- Show Notification with simple usage
function PROG404:ShowNotification(message, duration)
    self.GUI:ShowNotification({
        Message = message or "New Notification!",
        Duration = duration or 3
    })
end

-- Add Image to a Tab with simple usage
function PROG404:AddImage(tabID, imageUrl, size, position)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    
    tab:AddImage({
        Image = imageUrl or "rbxassetid://1234567890",
        Size = size or UDim2.new(0, 50, 0, 50),
        Position = position or UDim2.new(0, 10, 0, 10)
    })
end

-- Change Tab Name or ID easily
function PROG404:ChangeTabName(tabID, newName)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    tab:SetTitle(newName or "Updated Tab")
end

return PROG404
