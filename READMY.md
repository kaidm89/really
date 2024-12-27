 These are the PROG-404 library codes for programming scripts
Under update: 🟡
Not available: ⚫
Suitable for use: 🟢
He has problems:🔴
Trial version: 🟠

# Library condition:


# Lyabrary 
```lua
 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PROG-404/really/refs/heads/main/Prog.lua"))() 
```
# Add WINDOW 
```lua

local window = Library:CreateWindow({
    Name = "My Custom Window",
    BackgroundColor = Color3.fromRGB(0, 0, 0),
    WaitingText = "Loading..."
})

window:SetName("New Window Name")
window:SetBackgroundColor(Color3.fromRGB(255, 0, 0))
window:SetWaitingText("Please Wait...")
```
# Add TAB
```lua
local Tab = window:CreateTab({
    Name = "Tab Name",
    ID = "tab1",
    BackgroundColor = Color3.fromRGB(50, 50, 50)
})

Tab:SetName("New Tab Name")
Tab:SetBackgroundColor(Color3.fromRGB(0, 255, 0))
```
# Add section

```lua

local Section = Tab:CreateSection({
    Name = "Section Name",
    ID = "section1",
    BackgroundColor = Color3.fromRGB(60, 60, 60)
})

Section:SetName("New Section Name")
Section:SetBackgroundColor(Color3.fromRGB(255, 0, 0))

```
# Add SLIDR 

```lua
local Slider = Section:CreateSlider({
    Name = "Slider Name",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Slider Value: " .. value)
    end
})

```
# Add BUTTON 

```lua
local Button = Section:CreateButton({
    Name = "Button Name",
    Callback = function()
        print("Button Pressed!")
    end
})

```

# Add TOGGLES

```lua
local Toggle = Section:CreateToggle({
    Name = "Toggle Name",
    Default = false,
    Callback = function(state)
        print("Toggle State: " .. tostring(state))
    end
})
```
# Add  dropbwon 
```lua
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

```

# Add Text box 

``` lua
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
```

# Add Show Loading 
```lua
-- Show Loading Message with simple usage
function PROG404:ShowLoading(message, duration)
    local loading = self.GUI:ShowLoading({
        Message = message or "Loading, please wait..."
    })
    task.wait(duration or 3)
    loading:Close()
end
```
# Add Notification 

```lua
-- Show Notification with simple usage
function PROG404:ShowNotification(message, duration)
    self.GUI:ShowNotification({
        Message = message or "New Notification!",
        Duration = duration or 3
    })
end
```
# Add Image to Tab

```lua
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
```
# Add Tab Name 
```lua
-- Change Tab Name or ID easily
function PROG404:ChangeTabName(tabID, newName)
    local tab = self.Tabs[tabID]
    if not tab then
        error("Tab not found!")
    end
    tab:SetTitle(newName or "Updated Tab")
end
```
# Destroying the Interface
```lua
PROG404:Destroy()
```

