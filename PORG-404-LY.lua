local PROG404 = {}

function PROG404:CreateGUI()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- العناصر الأساسية
    local screenGui = Instance.new("ScreenGui")
    local mainFrame = Instance.new("Frame")
    local header = Instance.new("Frame")
    local minimizeButton = Instance.new("TextButton")
    local closeButton = Instance.new("TextButton")
    local restoreButton = Instance.new("TextButton")
    local userImage = Instance.new("ImageButton")
    local confirmationFrame = Instance.new("Frame")
    local yesButton = Instance.new("TextButton")
    local noButton = Instance.new("TextButton")
    local tabsContainer = Instance.new("Frame")
    local tabsList = Instance.new("ScrollingFrame")
    local tabLine = Instance.new("Frame")
    local userNameLabel = Instance.new("TextLabel")
    local contentFrame = Instance.new("Frame")
    local minimized = false

    -- إعداد ScreenGui
    screenGui.Name = "PROG404_GUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- إعداد Frame الرئيسي
    mainFrame.Size = UDim2.new(0, 800, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.Visible = false
    mainFrame.Parent = screenGui

    -- إعداد Header
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    header.Parent = mainFrame

    -- زر التصغير (-)
    minimizeButton.Size = UDim2.new(0, 40, 1, 0)
    minimizeButton.Position = UDim2.new(1, -120, 0, 0)
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeButton.Parent = header

    -- زر الإغلاق (X)
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeButton.Parent = header

    -- زر الاستعادة (+)
    restoreButton.Size = UDim2.new(0, 40, 1, 0)
    restoreButton.Position = UDim2.new(1, -80, 0, 0)
    restoreButton.Text = "+"
    restoreButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    restoreButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    restoreButton.Visible = false
    restoreButton.Parent = header

    -- إعداد tabsContainer
    tabsContainer.Size = UDim2.new(0.2, 0, 1, -40)
    tabsContainer.Position = UDim2.new(0, 0, 0, 40)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tabsContainer.Parent = mainFrame

    -- إعداد قائمة التبويبات
    tabsList.Size = UDim2.new(1, 0, 1, -40)
    tabsList.CanvasSize = UDim2.new(0, 0, 2, 0)
    tabsList.ScrollBarThickness = 4
    tabsList.BackgroundTransparency = 1
    tabsList.Parent = tabsContainer

    -- خط تحت التبويبات
    tabLine.Size = UDim2.new(1, 0, 0, 2)
    tabLine.Position = UDim2.new(0, 0, 1, -2)
    tabLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabLine.Parent = tabsContainer

    -- إعداد اسم المستخدم
    userNameLabel.Size = UDim2.new(1, 0, 0, 40)
    userNameLabel.Position = UDim2.new(0, 0, 1, -40)
    userNameLabel.Text = LocalPlayer.Name
    userNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    userNameLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    userNameLabel.TextScaled = true
    userNameLabel.Parent = tabsContainer

    -- إعداد صورة المستخدم
    userImage.Size = UDim2.new(0, 50, 0, 50)
    userImage.Position = UDim2.new(0, 10, 0, 10)
    userImage.Image = "rbxassetid://0" -- صورة سوداء افتراضية
    userImage.BackgroundTransparency = 1
    userImage.Parent = screenGui

    -- جعل الصورة دائرية مع ضباب أبيض
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = userImage

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 255, 255)
    uiStroke.Thickness = 2
    uiStroke.Parent = userImage

    -- إعداد نافذة التأكيد
    confirmationFrame.Size = UDim2.new(0, 300, 0, 150)
    confirmationFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    confirmationFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    confirmationFrame.Visible = false
    confirmationFrame.Parent = screenGui

    local confirmationLabel = Instance.new("TextLabel")
    confirmationLabel.Size = UDim2.new(1, 0, 0.6, 0)
    confirmationLabel.Text = "هل أنت متأكد من حذف السكربت؟"
    confirmationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmationLabel.BackgroundTransparency = 1
    confirmationLabel.Parent = confirmationFrame

    yesButton.Size = UDim2.new(0.4, -10, 0.3, 0)
    yesButton.Position = UDim2.new(0, 10, 0.7, 0)
    yesButton.Text = "نعم"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    yesButton.Parent = confirmationFrame

    noButton.Size = UDim2.new(0.4, -10, 0.3, 0)
    noButton.Position = UDim2.new(0.6, 10, 0.7, 0)
    noButton.Text = "لا"
    noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    noButton.Parent = confirmationFrame

    -- إعداد إطار المحتوى
    contentFrame.Size = UDim2.new(0.8, 0, 1, -40)
    contentFrame.Position = UDim2.new(0.2, 0, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    contentFrame.Parent = mainFrame

    -- وظائف الأزرار
    userImage.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    minimizeButton.MouseButton1Click:Connect(function()
        if not minimized then
            mainFrame:TweenSize(UDim2.new(0, 800, 0, 40), "Out", "Sine", 0.5, true)
            minimizeButton.Visible = false
            restoreButton.Visible = true
            minimized = true
        end
    end)

    restoreButton.MouseButton1Click:Connect(function()
        if minimized then
            mainFrame:TweenSize(UDim2.new(0, 800, 0, 600), "Out", "Sine", 0.5, true)
            minimizeButton.Visible = true
            restoreButton.Visible = false
            minimized = false
        end
    end)

    closeButton.MouseButton1Click:Connect(function()
        confirmationFrame.Visible = true
    end)

    yesButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    noButton.MouseButton1Click:Connect(function()
        confirmationFrame.Visible = false
    end)
end

PROG404:CreateGUI()
