 These are the PROG-404 library codes for programming scripts

# Lyabrary 
```lua
 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PROG-404/really/refs/heads/main/PORG-404-LY.lua"))() 
```
# WINDOW 
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
# TAB
```lua
local Tab = window:CreateTab({
    Name = "Tab Name",
    ID = "tab1",
    BackgroundColor = Color3.fromRGB(50, 50, 50)
})

Tab:SetName("New Tab Name")
Tab:SetBackgroundColor(Color3.fromRGB(0, 255, 0))

local button = Tab:CreateButton({
    Name = "Button Name",
    Text = "Click Me",
    BackgroundColor = Color3.fromRGB(100, 100, 100),
    TextColor = Color3.fromRGB(255, 255, 255)
})

button.OnClick = function()
    print("Button Clicked!")
end

```
