--[[ Orion-prog Pro Library v3.0 ]]
local OrionPro = {
    Version = "3.0.0",
    Windows = {},
    Cache = {},
    Config = {
        Theme = {
            Main = Color3.fromRGB(20, 20, 20),
            Secondary = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(0, 150, 255),
            AccentDark = Color3.fromRGB(0, 120, 205),
            Border = Color3.fromRGB(50, 50, 50),
            Text = Color3.fromRGB(255, 255, 255),
            TextDark = Color3.fromRGB(175, 175, 175),
            Error = Color3.fromRGB(255, 50, 50),
            Success = Color3.fromRGB(50, 255, 100)
        },
        Effects = {
            BlurSize = 12,
            Transparency = 0.98,
            AnimationDuration = 0.2,
            AnimationEasing = Enum.EasingStyle.Quad
        },
        Keybind = Enum.KeyCode.RightControl,
        AutoSave = true,
        SaveFolder = "OrionPro",
        UseBlur = true,
        CustomFont = nil
    }
}

-- Services
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    TextService = game:GetService("TextService"),
    HttpService = game:GetService("HttpService"),
    CoreGui = game:GetService("CoreGui"),
    Lighting = game:GetService("Lighting")
}

-- Localization
local LocalPlayer = Services.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local ViewportSize = Camera.ViewportSize

-- Utilities
local Util = {}

-- Tween System
function Util.Tween(object, properties, duration, style, direction, repeatCount, reverses, delay)
    if not object or typeof(properties) ~= "table" then return end
    
    local tweenInfo = TweenInfo.new(
        duration or OrionPro.Config.Effects.AnimationDuration,
        style or OrionPro.Config.Effects.AnimationEasing,
        direction or Enum.EasingDirection.Out,
        repeatCount or 0,
        reverses or false,
        delay or 0
    )
    
    local tween = Services.TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Enhanced Dragging System
function Util.Draggable(frame, handle)
    local dragToggle, dragInput, dragStart, startPos, updatePosition
    
    handle = handle or frame
    
    local function update(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        
        Util.Tween(frame, {Position = position}, 0.1)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            update(input)
        end
    end)
end

-- Ripple Effect
function Util.CreateRipple(parent, config)
    config = config or {}
    local ripple = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = config.Color or Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = config.StartTransparency or 0.7
    ripple.BorderSizePixel = 0
    ripple.Position = UDim2.fromOffset(Mouse.X - parent.AbsolutePosition.X, Mouse.Y - parent.AbsolutePosition.Y)
    ripple.Size = UDim2.fromOffset(0, 0)
    ripple.Parent = parent
    ripple.ZIndex = parent.ZIndex + 1
    
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ripple
    
    local targetSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    local sizeTween = Services.TweenService:Create(ripple, tweenInfo, {
        Size = UDim2.fromOffset(targetSize, targetSize),
        Position = UDim2.fromOffset(Mouse.X - parent.AbsolutePosition.X - targetSize/2, 
                                  Mouse.Y - parent.AbsolutePosition.Y - targetSize/2),
        BackgroundTransparency = 1
    })
    
    sizeTween:Play()
    sizeTween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- Enhanced Window Creation System
function OrionPro:CreateWindow(config)
    config = config or {}
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        Minimized = false,
        Hidden = false,
        Cache = {}
    }
    
    -- Main UI Creation
    Window.Main = Instance.new("ScreenGui")
    Window.Main.Name = "OrionProUI"
    Window.Main.ResetOnSpawn = false
    
    -- Apply Protection
    if syn and syn.protect_gui then
        syn.protect_gui(Window.Main)
    end
    
    Window.Main.Parent = Services.CoreGui
    
    -- Blur Effect
    if OrionPro.Config.UseBlur then
        local blur = Instance.new("BlurEffect")
        blur.Size = 0
        blur.Parent = Services.Lighting
        Window.Cache.Blur = blur
        
        Util.Tween(blur, {Size = OrionPro.Config.Effects.BlurSize}, 0.5)
    end
    
    -- Main Container
    Window.Container = Instance.new("Frame")
    Window.Container.Name = "MainContainer"
    Window.Container.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Container.BackgroundColor3 = OrionPro.Config.Theme.Main
    Window.Container.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.Container.Size = UDim2.new(0, 600, 0, 400)
    Window.Container.ClipsDescendants = true
    Window.Container.Parent = Window.Main
    
    -- Apply Styles
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = Window.Container
    
    local containerStroke = Instance.new("UIStroke")
    containerStroke.Color = OrionPro.Config.Theme.Border
    containerStroke.Thickness = 1
    containerStroke.Parent = Window.Container
    
    -- TopBar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.BackgroundColor3 = OrionPro.Config.Theme.Secondary
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.Parent = Window.Container
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = UDim.new(0, 8)
    topBarCorner.Parent = topBar
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 15, 0, 0)
    title.Size = UDim2.new(1, -130, 1, 0)
    title.Font = OrionPro.Config.CustomFont or Enum.Font.GothamBold
    title.Text = config.Title or "Orion Pro"
    title.TextColor3 = OrionPro.Config.Theme.Text
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    -- Control Buttons
    local controlButtons = Instance.new("Frame")
    controlButtons.Name = "ControlButtons"
    controlButtons.BackgroundTransparency = 1
    controlButtons.Position = UDim2.new(1, -110, 0, 0)
    controlButtons.Size = UDim2.new(0, 100, 1, 0)
    controlButtons.Parent = topBar
    
    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    buttonLayout.Padding = UDim.new(0, 5)
    buttonLayout.Parent = controlButtons
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.BackgroundColor3 = OrionPro.Config.Theme.Accent
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -95, 0, 5)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = OrionPro.Config.Theme.Text
    minimizeButton.TextSize = 20
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = controlButtons
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = OrionPro.Config.Theme.Error
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.Text = "×"
    closeButton.TextColor3 = OrionPro.Config.Theme.Text
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = controlButtons
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Content Area
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 0, 0, 40)
    content.Size = UDim2.new(1, 0, 1, -40)
    content.Parent = Window.Container
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.BackgroundColor3 = OrionPro.Config.Theme.Secondary
    tabContainer.Position = UDim2.new(0, 10, 0, 10)
    tabContainer.Size = UDim2.new(0, 150, 1, -20)
    tabContainer.Parent = content
    
    local tabContainerCorner = Instance.new("UICorner")
    tabContainerCorner.CornerRadius = UDim.new(0, 6)
    tabContainerCorner.Parent = tabContainer
    
    -- Tab List
    local tabList = Instance.new("ScrollingFrame")
    tabList.Name = "TabList"
    tabList.BackgroundTransparency = 1
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.ScrollBarThickness = 2
    tabList.ScrollBarImageColor3 = OrionPro.Config.Theme.Border
    tabList.Parent = tabContainer
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    tabListLayout.Parent = tabList
    
    -- Tab Content Container
    local tabContent = Instance.new("Frame")
    tabContent.Name = "TabContent"
    tabContent.BackgroundTransparency = 1
    tabContent.Position = UDim2.new(0, 170, 0, 10)
    tabContent.Size = UDim2.new(1, -180, 1, -20)
    tabContent.Parent = content
    
    -- Tab System
    function Window:CreateTab(name, icon)
        local Tab = {
            Elements = {},
            Containers = {}
        }
        
        -- Continue with tab creation...
        
        return Tab
    end
    
    -- Dragging System
    Util.Draggable(Window.Container, topBar)
    
    -- Control Button Events
    minimizeButton.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Util.Tween(Window.Container, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
        else
            Util.Tween(Window.Container, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        Util.Tween(Window.Container, {</antArtifact>
