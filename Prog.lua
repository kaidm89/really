
--[[
    ProgLib Premium v4.0.0
    Created by: Professional Programming Team
    Last Updated: 2024
]]

local ProgLib = {
    Name = "ProgLib",
    Version = "4.0.0",
    Author = "Professional Programming Team",
    License = "MIT",
    
    Settings = {
        Theme = {
            Primary = {
                Main = Color3.fromRGB(25, 25, 30),
                Secondary = Color3.fromRGB(30, 30, 35),
                Accent = Color3.fromRGB(60, 145, 255),
                AccentDark = Color3.fromRGB(40, 125, 235),
                Text = Color3.fromRGB(255, 255, 255),
                SubText = Color3.fromRGB(200, 200, 200),
                Border = Color3.fromRGB(50, 50, 55),
                Background = Color3.fromRGB(20, 20, 25),
                Success = Color3.fromRGB(45, 200, 95),
                Warning = Color3.fromRGB(250, 180, 40),
                Error = Color3.fromRGB(250, 60, 60)
            },
            Dark = {
                Main = Color3.fromRGB(20, 20, 25),
                Secondary = Color3.fromRGB(25, 25, 30),
                Accent = Color3.fromRGB(50, 135, 245),
                AccentDark = Color3.fromRGB(30, 115, 225),
                Text = Color3.fromRGB(255, 255, 255),
                SubText = Color3.fromRGB(190, 190, 190),
                Border = Color3.fromRGB(45, 45, 50),
                Background = Color3.fromRGB(15, 15, 20),
                Success = Color3.fromRGB(35, 190, 85),
                Warning = Color3.fromRGB(240, 170, 30),
                Error = Color3.fromRGB(240, 50, 50)
            }
        },
        
        Animation = {
            TweenInfo = {
                Quick = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                Normal = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                Smooth = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                Long = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            },
            Effects = {
                Ripple = true,
                Spring = true,
                Fade = true
            }
        },
        
        Window = {
            DefaultSize = Vector2.new(650, 450),
            MinSize = Vector2.new(450, 350),
            MaxSize = Vector2.new(850, 650),
            TitleBarHeight = 35,
            TabBarWidth = 150,
            CornerRadius = 8,
            Shadow = true,
            AutoSave = true,
            SaveInterval = 60
        },
        
        Elements = {
            CornerRadius = UDim.new(0, 6),
            ButtonHeight = 32,
            InputHeight = 35,
            DropdownHeight = 32,
            SliderHeight = 35,
            ToggleSize = 24,
            CheckboxSize = 20,
            ScrollBarWidth = 3,
            TabButtonHeight = 36,
            SectionSpacing = 10,
            ElementSpacing = 8
        }
    },
    
    Core = {
        Services = setmetatable({}, {
            __index = function(self, service)
                local success, result = pcall(game.GetService, game, service)
                if success then
                    self[service] = result
                    return result
                end
                warn("[ProgLib] Failed to get service:", service)
                return nil
            end
        }),
        
        Cache = {
            Instances = {},
            Connections = {},
            Threads = {},
            Assets = {}
        },
        
        Debug = {
            Enabled = false,
            LogLevel = 2,
            LogToFile = false,
            LogPath = "ProgLib/logs/"
        }
    },
    
    Utils = {
        Create = function(class, properties, children)
            local instance = Instance.new(class)
            
            for prop, value in pairs(properties or {}) do
                if prop ~= "Parent" then
                    instance[prop] = value
                end
            end
            
            if children then
                for _, child in ipairs(children) do
                    child.Parent = instance
                end
            end
            
            if properties and properties.Parent then
                instance.Parent = properties.Parent
            end
            
            return instance
        end,
        
        Tween = function(instance, properties, tweenType)
            if not instance or not properties then return end
            
            local tweenInfo = ProgLib.Settings.Animation.TweenInfo[tweenType or "Normal"]
            local tween = ProgLib.Core.Services.TweenService:Create(instance, tweenInfo, properties)
            tween:Play()
            
            return tween
        end,
        
        Ripple = function(button, properties)
            if not ProgLib.Settings.Animation.Effects.Ripple then return end
            
            task.spawn(function()
                local ripple = ProgLib.Utils.Create("Frame", {
                    Name = "Ripple",
                    Parent = button,
                    BackgroundColor3 = properties.Color or Color3.new(1, 1, 1),
                    BackgroundTransparency = properties.StartTransparency or 0.7,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = button.ZIndex + 1
                })
                
                local targetSize = UDim2.new(1.5, 0, 1.5, 0)
                
                ProgLib.Utils.Tween(ripple, {
                    Size = targetSize,
                    BackgroundTransparency = 1
                }, "Smooth").Completed:Connect(function()
                    ripple:Destroy()
                end)
            end)
        end,
        
        MakeDraggable = function(window, dragObject)
            local dragging, dragInput, dragStart, startPos
            
            dragObject = dragObject or window.GUI.TitleBar
            
            local function update(input)
                local delta = input.Position - dragStart
                window.GUI.Main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
            
            dragObject.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    dragStart = input.Position
                    startPos = window.GUI.Main.Position
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            
            dragObject.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    dragInput = input
                end
            end)
            
            ProgLib.Core.Services.UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    update(input)
                end
            end)
        end,
        
        MakeResizable = function(window)
            local resizing, resizeType
            local minSize = ProgLib.Settings.Window.MinSize
            local maxSize = ProgLib.Settings.Window.MaxSize
            local resizeArea = 5
            
            local function isInResizeRange(frame, position)
                local framePos = frame.AbsolutePosition
                local frameSize = frame.AbsoluteSize
                
                local right = position.X > framePos.X + frameSize.X - resizeArea
                local bottom = position.Y > framePos.Y + frameSize.Y - resizeArea
                
                return right or bottom, {
                    Right = right,
                    Bottom = bottom
                }
            end
            
            window.GUI.Main.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local inRange, rangeType = isInResizeRange(window.GUI.Main, input.Position)
                    if inRange then
                        resizing = true
                        resizeType = rangeType
                    end
                end
            end)
            
            window.GUI.Main.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    resizing = false
                    resizeType = nil
                end
            end)
            
            ProgLib.Core.Services.UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
                    local delta = input.Position - window.GUI.Main.AbsolutePosition
                    local newSize = Vector2.new(
                        resizeType.Right and math.clamp(delta.X, minSize.X, maxSize.X) or window.GUI.Main.Size.X.Offset,
                        resizeType.Bottom and math.clamp(delta.Y, minSize.Y, maxSize.Y) or window.GUI.Main.Size.Y.Offset
                    )
                    
                    ProgLib.Utils.Tween(window.GUI.Main, {
                        Size = UDim2.new(0, newSize.X, 0, newSize.Y)
                    }, "Quick")
                end
            end)
        end
    }
}

-- Initialize Core Systems
function ProgLib:Initialize()
    -- Create necessary folders
    if self.Settings.Window.AutoSave then
        local function ensureFolder(path)
            if not isfolder(path) then
                makefolder(path)
            end
        end
        
        ensureFolder("ProgLib")
        ensureFolder("ProgLib/configs")
        ensureFolder("ProgLib/logs")
    end
    
    -- Initialize debug logging
    if self.Core.Debug.LogToFile then
        local date = os.date("%Y-%m-%d_%H-%M-%S")
        self.Core.Debug.CurrentLog = "ProgLib/logs/" .. date .. ".log"
        writefile(self.Core.Debug.CurrentLog, "[ProgLib] Session started: " .. date .. "\n")
    end
    
    return self
end

return ProgLib:Initialize()
