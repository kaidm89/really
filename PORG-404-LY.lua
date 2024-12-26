local Library = {}

function Library:CreateGUI()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")

    -- العناصر الأساسية
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local header = Instance.new("Frame")
    local titleLabel = Instance.new("TextLabel")
    local minimizeButton = Instance.new("TextButton")
    local closeButton = Instance.new("TextButton")
    local tabsFrame = Instance.new("Frame")
    local contentFrame = Instance.new("Frame")
    local notificationsFrame = Instance.new("Frame")
    local profileFrame = Instance.new("Frame")
    local profileImage = Instance.new("ImageLabel")
    local profileName = Instance.new("TextLabel")
    local tabButtons = {}
    local activeTab = nil
    local isDragging = false
    local dragStart = nil
    local startPos = nil

    -- إعداد ScreenGui
    screenGui.Name = "PROG-404"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- إعداد Main Frame
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = false
    mainFrame.Parent = screenGui

    -- إعداد Header
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    header.Parent = mainFrame

    -- إعداد Title Label
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Text = "PROG-404"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = header

    -- إعداد زر التصغير
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -60, 0, 0)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeButton.Parent = header

    -- إعداد زر الإغلاق
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeButton.Parent = header

    -- إعداد Tabs Frame
    tabsFrame.Size = UDim2.new(0, 150, 1, -30)
    tabsFrame.Position = UDim2.new(0, 0, 0, 30)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabsFrame.Parent = mainFrame

    -- إعداد Content Frame
    contentFrame.Size = UDim2.new(1, -150, 1, -30)
    contentFrame.Position = UDim2.new(0, 150, 0, 30)
    contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    contentFrame.Parent = mainFrame

    -- إعداد Notifications Frame
    notificationsFrame.Size = UDim2.new(0, 300, 0, 50)
    notificationsFrame.Position = UDim2.new(0.5, -150, 0, -60)
    notificationsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    notificationsFrame.Visible = false
    notificationsFrame.Parent = screenGui

    local notificationLabel = Instance.new("TextLabel")
    notificationLabel.Size = UDim2.new(1, -20, 1, -10)
    notificationLabel.Position = UDim2.new(0, 10, 0, 5)
    notificationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    notificationLabel.BackgroundTransparency = 1
    notificationLabel.Text = ""
    notificationLabel.Parent = notificationsFrame

    -- إعداد Profile Frame
    profileFrame.Size = UDim2.new(1, 0, 0, 80)
    profileFrame.Position = UDim2.new(0, 0, 1, -80)
    profileFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    profileFrame.Parent = tabsFrame

    profileImage.Size = UDim2.new(0, 50, 0, 50)
    profileImage.Position = UDim2.new(0, 10, 0.5, -25)
    profileImage.Image = "rbxassetid://0" -- صورة افتراضية (GitHub)
    profileImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    profileImage.Parent = profileFrame

    profileName.Size = UDim2.new(1, -70, 1, 0)
    profileName.Position = UDim2.new(0, 70, 0, 0)
    profileName.Text = "User Name"
    profileName.TextColor3 = Color3.fromRGB(255, 255, 255)
    profileName.BackgroundTransparency = 1
    profileName.Parent = profileFrame

    -- وظيفة الإشعارات
    function Library:Notify(message)
        notificationLabel.Text = message
        notificationsFrame.Visible = true
        wait(3)
        notificationsFrame.Visible = false
    end

    -- وظيفة السحب والإفلات
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    header.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

    -- وظيفة التصغير
    minimizeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- وظيفة الإغلاق
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- إضافة Tabs
    function Library:AddTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.Parent = tabsFrame

        tabButton.MouseButton1Click:Connect(function()
            for _, button in pairs(tabButtons) do
                button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            activeTab = tabName
        end)

        table.insert(tabButtons, tabButton)
    end

    return screenGui
end

return Library
