-- OrionLib-ProgLib Advanced v2.0
local OrionLib = {
    Settings = {
        ConfigVersion = "2.0.0",
        Theme = {
            Default = {
                Main = Color3.fromRGB(25, 25, 25),
                Secondary = Color3.fromRGB(30, 30, 30),
                Accent = Color3.fromRGB(0, 122, 255),
                AccentDark = Color3.fromRGB(0, 98, 204),
                TabBackground = Color3.fromRGB(35, 35, 35),
                ElementBackground = Color3.fromRGB(40, 40, 40),
                Text = Color3.fromRGB(255, 255, 255),
                SubText = Color3.fromRGB(180, 180, 180),
                PlaceholderText = Color3.fromRGB(120, 120, 120),
                Border = Color3.fromRGB(60, 60, 60),
                Hover = Color3.fromRGB(50, 50, 50),
                Error = Color3.fromRGB(255, 64, 64),
                Success = Color3.fromRGB(48, 208, 88)
            },
            Light = {
                Main = Color3.fromRGB(240, 240, 240),
                Secondary = Color3.fromRGB(250, 250, 250),
                Accent = Color3.fromRGB(0, 122, 255),
                AccentDark = Color3.fromRGB(0, 98, 204),
                TabBackground = Color3.fromRGB(245, 245, 245),
                ElementBackground = Color3.fromRGB(255, 255, 255),
                Text = Color3.fromRGB(0, 0, 0),
                SubText = Color3.fromRGB(80, 80, 80),
                PlaceholderText = Color3.fromRGB(120, 120, 120),
                Border = Color3.fromRGB(200, 200, 200),
                Hover = Color3.fromRGB(245, 245, 245),
                Error = Color3.fromRGB(255, 64, 64),
                Success = Color3.fromRGB(48, 208, 88)
            }
        },
        Animation = {
            TweenSpeed = 0.2,
            EasingStyle = Enum.EasingStyle.Quart,
            EasingDirection = Enum.EasingDirection.Out
        },
        Window = {
            Size = Vector2.new(600, 400),
            MinSize = Vector2.new(400, 300),
            Position = UDim2.new(0.5, -300, 0.5, -200),
            Draggable = true,
            Resizable = true
        },
        Storage = {
            UseDataStore = false, -- إذا كان true سيتم استخدام DataStore بدلاً من writefile
            FolderName = "OrionLib",
            FileName = "config.json"
        }
    },
    Elements = {},
    Themes = {},
    Windows = {},
    Connections = {},
    Flags = {},
    ActiveKeybinds = {},
    ToggleKey = Enum.KeyCode.RightShift
}

-- Services
local Services = {
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    HttpService = game:GetService("HttpService"),
    Players = game:GetService("Players"),
    CoreGui = game:GetService("CoreGui"),
    TextService = game:GetService("TextService")
}

-- Local Player
local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Utilities
local Utilities = {}

function Utilities.Create(class, properties, children)
    local instance = Instance.new(class)
    
    for property, value in pairs(properties or {}) do
        if property ~= "Parent" then
            if typeof(value) == "table" and property ~= "Theme" then
                instance[property] = value[1]
                value[1].Changed:Connect(function(newValue)
                    instance[property] = newValue
                end)
            else
                instance[property] = value
            end
        end
    end
    
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    
    return instance
end

function Utilities.Tween(instance, properties, duration, style, direction)
    if not instance or not properties then return end
    
    local tweenInfo = TweenInfo.new(
        duration or OrionLib.Settings.Animation.TweenSpeed,
        style or OrionLib.Settings.Animation.EasingStyle,
        direction or OrionLib.Settings.Animation.EasingDirection
    )
    
    local tween = Services.TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    
    return tween
end

function Utilities.GetTextBounds(text, font, size)
    return Services.TextService:GetTextSize(text, size, font, Vector2.new(math.huge, math.huge))
end

function Utilities.GetMouseLocation()
    return Services.UserInputService:GetMouseLocation()
end

function Utilities.RippleEffect(button, rippleColor)
    spawn(function()
        local ripple = Utilities.Create("Frame", {
            Name = "Ripple",
            Parent = button,
            BackgroundColor3 = rippleColor or Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            ZIndex = button.ZIndex + 1,
            AnchorPoint = Vector2.new(0.5, 0.5)
        })
        
        local mousePos = Utilities.GetMouseLocation()
        local startPos = Vector2.new(
            mousePos.X - button.AbsolutePosition.X,
            mousePos.Y - button.AbsolutePosition.Y
        )
        
        ripple.Position = UDim2.new(0, startPos.X, 0, startPos.Y)
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        local appearTween = Utilities.Tween(ripple, {
            Size = UDim2.new(0, size, 0, size),
            BackgroundTransparency = 1
        }, 0.5)
        
        appearTween.Completed:Wait()
        ripple:Destroy()
    end)
end

-- Сохранение и загрузка конфигурации
function OrionLib:SaveConfig(name)
    local config = {
        Version = self.Settings.ConfigVersion,
        Flags = {},
        Window = {
            Position = self.MainWindow and {
                X = self.MainWindow.Position.X.Scale,
                Y = self.MainWindow.Position.Y.Scale,
                OffsetX = self.MainWindow.Position.X.Offset,
                OffsetY = self.MainWindow.Position.Y.Offset
            }
        }
    }
    
    for flag, value in pairs(self.Flags) do
        if type(value) == "table" and value.Save ~= false then
            config.Flags[flag] = value.Value
        end
    end
    
    local success, encoded = pcall(function()
        return Services.HttpService:JSONEncode(config)
    end)
    
    if success then
        if self.Settings.Storage.UseDataStore then
            -- حفظ في DataStore
        else
            -- حفظ في ملف
            local path = self.Settings.Storage.FolderName .. "/" .. (name or self.Settings.Storage.FileName)
            writefile(path, encoded)
        end
        return true
    end
    return false
end

function OrionLib:LoadConfig(name)
    local config
    local success, content = pcall(function()
        if self.Settings.Storage.UseDataStore then
            -- قراءة من DataStore
            return nil
        else
            -- قراءة من ملف
            local path = self.Settings.Storage.FolderName .. "/" .. (name or self.Settings.Storage.FileName)
            return readfile(path)
        end
    end)
    
    if success and content then
        success, config = pcall(function()
            return Services.HttpService:JSONDecode(content)
        end)
        
        if success and config then
            if config.Version == self.Settings.ConfigVersion then
                -- تحديث الإعدادات
                for flag, value in pairs(config.Flags) do
                    if self.Flags[flag] then
                        self.Flags[flag]:Set(value)
                    end
                end
                
                -- تحديث موقع النافذة
                if config.Window and config.Window.Position and self.MainWindow then
                    self.MainWindow.Position = UDim2.new(
                        config.Window.Position.X,
                        config.Window.Position.OffsetX,
                        config.Window.Position.Y,
                        config.Window.Position.OffsetY
                    )
                end
                
                return true
            end
        end
    end
    return false
end

-- إنشاء نافذة جديدة
function OrionLib:CreateWindow(config)
    config = config or {}
    local Window = {
        Tabs = {},
        TabCount = 0,
        ActiveTab = nil,
        Minimized = false,
        Dragging = false
    }
    
    -- الواجهة الرئيسية
    Window.Main = Utilities.Create("Frame", {
        Name = "OrionLibWindow",
        Parent = Services.CoreGui:FindFirstChild("OrionLib") or Utilities.Create("ScreenGui", {
            Name = "OrionLib",
            Parent = Services.CoreGui
        }),
        Size = UDim2.new(0, self.Settings.Window.Size.X, 0, self.Settings.Window.Size.Y),
        Position = self.Settings.Window.Position,
        BackgroundColor3 = self.Settings.Theme.Default.Main,
        BorderSizePixel = 0,
        Active = true,
        ClipsDescendants = true
    }, {
        -- الإطار العلوي
        Utilities.Create("Frame", {
            Name = "TopBar",
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = self.Settings.Theme.Default.Secondary,
            BorderSizePixel = 0
        }, {
            -- عنوان النافذة
            Utilities.Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = config.Title or "Orion Library",
                TextColor3 = self.Settings.Theme.Default.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            -- أزرار التحكم
            Utilities.Create("Frame", {
                Name = "Controls",
                Size = UDim2.new(0, 90, 1, 0),
                Position = UDim2.new(1, -90, 0, 0),
                BackgroundTransparency = 1
            }, {
                -- زر التصغير
                Utilities.Create("TextButton", {
                    Name = "Minimize",
                    Size = UDim2.new(0, 30, 0, 30),
                    BackgroundTransparency = 1,
                    Text = "-",
                    TextColor3 = self.Settings.Theme.Default.Text,
                    TextSize = 20,
                    Font = Enum.Font.GothamBold
                }),
                -- زر الإغلاق
                Utilities.Create("TextButton", {
                    Name = "Close",
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -30, 0, 0),
                    BackgroundTransparency = 1,
                    Text = "×",
                    TextColor3 = self.Settings.Theme.Default.Text,
                    TextSize = 20,
                    Font = Enum.Font.GothamBold
                })
            })
        }),
        -- حاوية التبويبات
        Utilities.Create("Frame", {
            Name = "TabContainer",
            Size = UDim2.new(0, 150, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundColor3 = self.Settings.Theme.Default.TabBackground,
            BorderSizePixel = 0
        }, {
            -- قائمة التبويبات
            Utilities.Create("ScrollingFrame", {
                Name = "TabList",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = self.Settings.Theme.Default.Border,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, {
                Utilities.Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 5)
                })
            })
        }),
        -- حاوية المحتوى
        Utilities.Create("Frame", {
            Name = "ContentContainer",
            Size = UDim2.new(1, -160, 1, -40),
            Position = UDim2.new(0, 155, 0, 35),
            BackgroundTransparency = 1,
            ClipsDescendants = true
        })
    })
    
    -- تفعيل السحب
    if self.Settings.Window.Draggable then
        local dragging, dragInput, dragStart, startPos
        
        Window.Main.TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = Window.Main.Position
                Window.Dragging = true
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        Window.Dragging = false
                    end
                end)
            end
        end)
        
        Window.Main.TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)
        
        Services.UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
