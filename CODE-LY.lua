-- استيراد مكتبة PROG-404
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/PROG-404/really/refs/heads/main/PORG-404-LY.lua"))()

-- إنشاء واجهة PROG-404
local PROG404 = {}

-- إنشاء واجهة GUI
function PROG404:Create(title, theme)
    self.GUI = Library:CreateGUI({
        Title = title or "PROG-404 واجهة",
        Theme = theme or "Dark" -- يمكن تغيير اللون
    })
    self.Sections = {}
    return self
end

-- إضافة قسم جديد
function PROG404:AddSection(name)
    local section = self.GUI:AddSection({
        Title = name or "قسم جديد"
    })
    table.insert(self.Sections, section)
    return section
end

-- إضافة زر (Button)
function PROG404:AddButton(section, text, callback)
    section:AddButton({
        Text = text or "زر جديد",
        Callback = callback or function() print("تم الضغط على الزر!") end
    })
end

-- إضافة تبديل (Toggle)
function PROG404:AddToggle(section, text, default, callback)
    section:AddToggle({
        Text = text or "تبديل جديد",
        Default = default or false,
        Callback = callback or function(state) print("حالة التبديل:", state) end
    })
end

-- إضافة شريط تمرير (Slider)
function PROG404:AddSlider(section, text, min, max, default, callback)
    section:AddSlider({
        Text = text or "شريط تمرير جديد",
        Min = min or 0,
        Max = max or 100,
        Default = default or min,
        Callback = callback or function(value) print("القيمة المختارة:", value) end
    })
end

-- إضافة قائمة منسدلة (Dropdown)
function PROG404:AddDropdown(section, text, options, callback)
    section:AddDropdown({
        Text = text or "قائمة جديدة",
        Options = options or {"خيار 1", "خيار 2", "خيار 3"},
        Callback = callback or function(selected) print("الخيار المختار:", selected) end
    })
end

-- إضافة مربع نص (Textbox)
function PROG404:AddTextbox(section, text, default, callback)
    section:AddTextbox({
        Text = text or "مربع نص جديد",
        Default = default or "",
        Callback = callback or function(input) print("النص المدخل:", input) end
    })
end

-- عرض شاشة تحميل (Loading Screen)
function PROG404:ShowLoading(message, duration)
    local loading = self.GUI:ShowLoading({
        Message = message or "الرجاء الانتظار..."
    })
    task.wait(duration or 3)
    loading:Close()
end

-- عرض إشعار (Notification)
function PROG404:ShowNotification(message, duration)
    self.GUI:ShowNotification({
        Message = message or "إشعار جديد!",
        Duration = duration or 3
    })
end

-- إضافة صورة (Image)
function PROG404:AddImage(section, imageUrl, size, position)
    section:AddImage({
        Image = imageUrl or "rbxassetid://1234567890",
        Size = size or UDim2.new(0, 50, 0, 50),
        Position = position or UDim2.new(0, 10, 0, 10)
    })
end

return PROG404
