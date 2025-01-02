--[[
    ProgLib Premium v4.0.0
    Created by: Professional Programming Team
    Last Updated: 2025
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


-- Window System
ProgLib.Window = {
    Create = function(config)
        local window = {
            Title = config.Title or "ProgLib Window",
            Size = config.Size or ProgLib.Settings.Window.DefaultSize,
            Theme = config.Theme or "Primary",
            Position = config.Position or ProgLib.Settings.Window.Position,
            GUI = {},
            Tabs = {},
            ActiveTab = nil
        }

        -- Main GUI
        window.GUI.Main = ProgLib.Utils.Create("Frame", {
            Name = "ProgLibWindow",
            Parent = ProgLib.Utils.Create("ScreenGui", {
                Name = "ProgLib_Interface",
                Parent = ProgLib.Core.Services.CoreGui,
                ResetOnSpawn = false,
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            }),
            Size = UDim2.new(0, window.Size.X, 0, window.Size.Y),
            Position = window.Position,
            BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].Main,
            BorderSizePixel = 0,
            ClipsDescendants = true
        }, {
            ProgLib.Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, ProgLib.Settings.Window.CornerRadius)
            })
        })

        -- Title Bar
        window.GUI.TitleBar = ProgLib.Utils.Create("Frame", {
            Name = "TitleBar",
            Parent = window.GUI.Main,
            Size = UDim2.new(1, 0, 0, ProgLib.Settings.Window.TitleBarHeight),
            BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].Secondary,
            BorderSizePixel = 0
        }, {
            -- Title
            ProgLib.Utils.Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = window.Title,
                TextColor3 = ProgLib.Settings.Theme[window.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            
            -- Controls Container
            ProgLib.Utils.Create("Frame", {
                Name = "Controls",
                Size = UDim2.new(0, 90, 1, 0),
                Position = UDim2.new(1, -90, 0, 0),
                BackgroundTransparency = 1
            })
        })

        -- Content Area
        window.GUI.Content = ProgLib.Utils.Create("Frame", {
            Name = "Content",
            Parent = window.GUI.Main,
            Size = UDim2.new(1, 0, 1, -ProgLib.Settings.Window.TitleBarHeight),
            Position = UDim2.new(0, 0, 0, ProgLib.Settings.Window.TitleBarHeight),
            BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].Background,
            BorderSizePixel = 0,
            ClipsDescendants = true
        })

        -- Tab Container
        window.GUI.TabContainer = ProgLib.Utils.Create("Frame", {
            Name = "TabContainer",
            Parent = window.GUI.Content,
            Size = UDim2.new(0, ProgLib.Settings.Window.TabBarWidth, 1, 0),
            BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].Secondary,
            BorderSizePixel = 0
        }, {
            ProgLib.Utils.Create("ScrollingFrame", {
                Name = "TabList",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ScrollBarThickness = ProgLib.Settings.Elements.ScrollBarWidth,
                ScrollBarImageColor3 = ProgLib.Settings.Theme[window.Theme].Border,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }, {
                ProgLib.Utils.Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, ProgLib.Settings.Elements.ElementSpacing)
                })
            })
        })

        -- Tab Content Area
        window.GUI.TabContent = ProgLib.Utils.Create("Frame", {
            Name = "TabContent",
            Parent = window.GUI.Content,
            Size = UDim2.new(1, -ProgLib.Settings.Window.TabBarWidth, 1, 0),
            Position = UDim2.new(0, ProgLib.Settings.Window.TabBarWidth, 0, 0),
            BackgroundTransparency = 1
        })

        -- Control Buttons
        local function CreateControlButton(name, symbol, color)
            return ProgLib.Utils.Create("TextButton", {
                Name = name,
                Parent = window.GUI.TitleBar.Controls,
                Size = UDim2.new(0, 30, 1, 0),
                Position = name == "Close" and UDim2.new(1, -30, 0, 0) or 
                          name == "Minimize" and UDim2.new(0, 0, 0, 0) or 
                          UDim2.new(0.5, -15, 0, 0),
                BackgroundTransparency = 1,
                Text = symbol,
                TextColor3 = ProgLib.Settings.Theme[window.Theme].SubText,
                TextSize = 20,
                Font = Enum.Font.GothamBold
            })
        end

        -- Add Control Buttons
        local closeButton = CreateControlButton("Close", "×", ProgLib.Settings.Theme[window.Theme].Error)
        local minimizeButton = CreateControlButton("Minimize", "−")
        local settingsButton = CreateControlButton("Settings", "⚙")

        -- Window Functions
        function window:AddTab(tabConfig)
            return ProgLib.Tab.Create(self, tabConfig)
        end

        function window:Minimize()
            local minSize = ProgLib.Settings.Window.TitleBarHeight
            local isMinimized = window.GUI.Main.Size.Y.Offset <= minSize
            local targetSize = isMinimized and window.Size or UDim2.new(0, window.Size.X, 0, minSize)
            
            ProgLib.Utils.Tween(window.GUI.Main, {
                Size = targetSize
            }, "Smooth")
        end

        -- Button Events
        closeButton.MouseButton1Click:Connect(function()
            ProgLib.Utils.Tween(window.GUI.Main, {
                Size = UDim2.new(0, window.Size.X, 0, 0),
                BackgroundTransparency = 1
            }, "Smooth").Completed:Connect(function()
                window.GUI.Main.Parent:Destroy()
            end)
        end)

        minimizeButton.MouseButton1Click:Connect(function()
            window:Minimize()
        end)

        -- Make Window Draggable
        ProgLib.Utils.MakeDraggable(window)

        return window
    end
}

-- Tab System
ProgLib.Tab = {
    Create = function(window, config)
        local tab = {
            Name = config.Name or "New Tab",
            Icon = config.Icon,
            Window = window,
            Sections = {},
            GUI = {},
            Active = false
        }

        -- Tab Button
        tab.GUI.Button = ProgLib.Utils.Create("TextButton", {
            Name = "Tab_" .. tab.Name,
            Parent = window.GUI.TabContainer.TabList,
            Size = UDim2.new(1, -10, 0, ProgLib.Settings.Elements.TabButtonHeight),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].ElementBackground,
            BorderSizePixel = 0,
            AutoButtonColor = false
        }, {
            ProgLib.Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, ProgLib.Settings.Elements.CornerRadius)
            }),
            
            -- Tab Icon
            tab.Icon and ProgLib.Utils.Create("ImageLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 8, 0.5, -10),
                BackgroundTransparency = 1,
                Image = tab.Icon
            }),
            
            -- Tab Name
            ProgLib.Utils.Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, tab.Icon and -35 or -16, 1, 0),
                Position = UDim2.new(0, tab.Icon and 35 or 8, 0, 0),
                BackgroundTransparency = 1,
                Text = tab.Name,
                TextColor3 = ProgLib.Settings.Theme[window.Theme].SubText,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })

        -- Tab Content
        tab.GUI.Content = ProgLib.Utils.Create("ScrollingFrame", {
            Name = "Content_" .. tab.Name,
            Parent = window.GUI.TabContent,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = ProgLib.Settings.Elements.ScrollBarWidth,
            ScrollBarImageColor3 = ProgLib.Settings.Theme[window.Theme].Border,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        }, {
            ProgLib.Utils.Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, ProgLib.Settings.Elements.SectionSpacing)
            }),
            
            ProgLib.Utils.Create("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10)
            })
        })

        -- Tab Functions
        function tab:Select()
            if tab.Window.ActiveTab then
                tab.Window.ActiveTab:Deselect()
            end
            
            ProgLib.Utils.Tween(tab.GUI.Button, {
                BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].Accent
            })
            tab.GUI.Button.Title.TextColor3 = ProgLib.Settings.Theme[window.Theme].Text
            tab.GUI.Content.Visible = true
            
            tab.Active = true
            tab.Window.ActiveTab = tab
        end

        function tab:Deselect()
            ProgLib.Utils.Tween(tab.GUI.Button, {
                BackgroundColor3 = ProgLib.Settings.Theme[window.Theme].ElementBackground
            })
            tab.GUI.Button.Title.TextColor3 = ProgLib.Settings.Theme[window.Theme].SubText
            tab.GUI.Content.Visible = false
            
            tab.Active = false
        end

        function tab:AddSection(sectionConfig)
            return ProgLib.Section.Create(self, sectionConfig)
        end

        -- Tab Button Events
        tab.GUI.Button.MouseButton1Click:Connect(function()
            if not tab.Active then
                tab:Select()
            end
        end)

        -- Add to window tabs
        window.Tabs[#window.Tabs + 1] = tab

        -- Select first tab
        if #window.Tabs == 1 then
            tab:Select()
        end

        return tab
    end
}

-- Section System
ProgLib.Section = {
    Create = function(tab, config)
        local section = {
            Name = config.Name or "New Section",
            Tab = tab,
            Elements = {},
            GUI = {}
        }

        -- Section Container
        section.GUI.Container = ProgLib.Utils.Create("Frame", {
            Name = "Section_" .. section.Name,
            Parent = tab.GUI.Content,
            Size = UDim2.new(1, 0, 0, 28), -- Initial size, will be updated as elements are added
            BackgroundColor3 = ProgLib.Settings.Theme[tab.Window.Theme].Secondary,
            BorderSizePixel = 0
        }, {
            ProgLib.Utils.Create("UICorner", {
                CornerRadius = UDim.new(0, ProgLib.Settings.Elements.CornerRadius)
            }),
            
            -- Section Title
            ProgLib.Utils.Create("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -16, 0, 28),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = section.Name,
                TextColor3 = ProgLib.Settings.Theme[tab.Window.Theme].Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            
            -- Elements Container
            ProgLib.Utils.Create("Frame", {
                Name = "Elements",
                Size = UDim2.new(1, -20, 1, -36),
                Position = UDim2.new(0, 10, 0, 28),
                BackgroundTransparency = 1
            }, {
                ProgLib.Utils.Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, ProgLib.Settings.Elements.ElementSpacing)
                })
            })
        })

        -- Section Functions
        function section:AddElement(elementType, elementConfig)
            local element = ProgLib.Elements[elementType].Create(self, elementConfig)
            self.Elements[#self.Elements + 1] = element
            
            -- Update section size
            local totalHeight = 28 -- Title height
            for _, elem in ipairs(self.Elements) do
                totalHeight = totalHeight + elem.GUI.Container.Size.Y.Offset + ProgLib.Settings.Elements.ElementSpacing
            end
            
            self.GUI.Container.Size = UDim2.new(1, 0, 0, totalHeight)
            
            return element
        end

        -- Add to tab sections
        tab.Sections[#tab.Sections + 1] = section

        return section
    end
}

-- Elements System
ProgLib.Elements = {
    Button = {
        Create = function(section, config)
            local button = {
                Name = config.Name or "Button",
                Callback = config.Callback or function() end,
                Section = section,
                GUI = {}
            }

            button.GUI.Container = ProgLib.Utils.Create("Frame", {
                Name = "Element_Button",
                Parent = section.GUI.Container.Elements,
                Size = UDim2.new(1, 0, 0, ProgLib.Settings.Elements.ButtonHeight),
                BackgroundTransparency = 1
            })

            button.GUI.Button = ProgLib.Utils.Create("TextButton", {
                Parent = button.GUI.Container,
