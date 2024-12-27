These are the PROG-404 library codes for programming scripts
```txt
Under update: 🟡
Not available: ⚫
Suitable for use: 🟢
He has problems:🔴
Trial version: 🟠
```
# Library condition: 🟡


# Lyabrary 
```lua
 local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PROG-404/really/refs/heads/main/Prog.lua"))() 
```
# Add WINDOW 
```lua
local Window = ProgLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "ProgTest"})
```
# Add TAB
```lua
local Tab = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

```
# Add section

```lua
local Section = Tab:AddSection({
	Name = "Section"
})

```
# Add SLIDR 

```lua
Tab:AddSlider({
	Name = "Slider",
	Min = 0,
	Max = 20,
	Default = 5,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "bananas",
	Callback = function(Value)
		print(Value)
	end    
})

```
# Add BUTTON 

```lua
Tab:AddButton({
	Name = "Button!",
	Callback = function()
      		print("button pressed")
  	end    
})

```

# Add TOGGLES

```lua

Tab:AddToggle({
	Name = "This is a toggle!",
	Default = false,
	Callback = function(Value)
		print(Value)
	end    
})

```
### Changing the value of an existing Toggle
```lua
CoolToggle:Set(true)
```

# Add  dropbwon 
```lua
Tab:AddDropdown({
	Name = "Dropdown",
	Default = "1",
	Options = {"1", "2"},
	Callback = function(Value)
		print(Value)
	end    
})

```
# Adding a set of new Dropdown buttons to an existing menu
```lua
Dropdown:Refresh(List<table>,true)
```
# Selecting a dropdown option
```lua
Dropdown:Set("dropdown option")

```
# Notifying the user
```lua
ProgLib:MakeNotification({
	Name = "Title!",
	Content = "Notification content... what will it say??",
	Image = "rbxassetid://4483345998",
	Time = 5
})

```

# Changing the value of an existing Toggle

```lua
CoolToggle:Set(true)

```
# Creating a Color Picker
```lua
Tab:AddColorpicker({
	Name = "Colorpicker",
	Default = Color3.fromRGB(255, 0, 0),
	Callback = function(Value)
		print(Value)
	end	  
})

```
# Setting the color picker's value

```lua
ColorPicker:Set(Color3.fromRGB(255,255,255))

```

# Change Slider Value
```lua
Slider:Set(2)
```
# Changing the value of an existing label 

```lua
CoolLabel:Set("Label New!")
```

# Creating a Label

```lua
Tab:AddLabel("Label")

```

# Creating a Paragraph

```lua
CoolParagraph:Set("Paragraph New!", "New Paragraph Content!")

```

# Creating an Adaptive Input

```lua
Tab:AddTextbox({
	Name = "Textbox",
	Default = "default box input",
	TextDisappear = true,
	Callback = function(Value)
		print(Value)
	end	  
})

```

# Creating a Keybind

```lua
Tab:AddBind({
	Name = "Bind",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		print("press")
	end    
})

```

# Chaning the value of a bind

```lua
Bind:Set(Enum.KeyCode.E)
```

# Finishing your script (REQUIRED)

```lua
ProgLib:Init()

```

# How flags work

```lua
Tab1:AddToggle({
    Name = "Toggle",
    Default = true,
    Save = true,
    Flag = "toggle"
})

print(ProgLib.Flags["toggle"].Value) -- prints the value of the toggle.

```
# Destroying the Interface

```lua
ProgLib:Destroy()
```
