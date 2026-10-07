-- [[ Fox Visuals V2 - UI Engine ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:Service("UserInputService")
local RunService = game:Service("RunService")

-- Удаляем старую версию, если она была запущена
if CoreGui:FindFirstChild("FoxVisuals_Gui") then
    CoreGui.FoxVisuals_Gui:Destroy()
end

-- Данные из main.lua (защита от вылета, если запускается отдельно)
local Data = _G.FoxVisualsData or {
    Version = "V2", Name = "Visual_FoxV1", Executor = "Unknown", Platform = "PC",
    GetFPS = function() return 60 end, GetPing = function() return 10 end
}

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FoxVisuals_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ЗАГОЛОВОК (Светящийся теплым светом Visual_FoxV1)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.Text = Data.Name
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.6
Title.TextStrokeColor3 = Color3.fromRGB(240, 140, 60) -- Теплое свечение
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- КНОПКА ЗАКРЫТИЯ/СВОРЫВАНИЯ (В правом верхнем углу)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.Text = "—"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame

-- КНОПКА РАЗВЕРТЫВАНИЯ (Сверху экрана по центру)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 240, 0, 32)
OpenBtn.Position = UDim2.new(0.5, -120, 0, -40) -- Прячется за экраном изначально
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
OpenBtn.BackgroundTransparency = 0.2 -- Чуть прозрачная
OpenBtn.Text = "Открыть Fox Visuals V2"
OpenBtn.Font = Enum.Font.GothamSemibold
OpenBtn.TextSize = 14
OpenBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(240, 150, 70) -- Теплая обводка
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

-- ПАНЕЛЬ СТАТИСТИКИ (Рядом с кнопкой открытия)
local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0, 130, 0, 32)
StatsFrame.Position = UDim2.new(0.5, 130, 0, -40)
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
StatsFrame.BackgroundTransparency = 0.3
StatsFrame.Visible = false
StatsFrame.Parent = ScreenGui

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 8)
StatsCorner.Parent = StatsFrame

local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, 0, 1, 0)
StatsText.BackgroundTransparency = 1
StatsText.Font = Enum.Font.Gotham
StatsText.TextSize = 12
StatsText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsText.Text = "FPS: -- | Ping: --"
StatsText.Parent = StatsFrame

-- Обновление FPS и Пинга в реальном времени
RunService.Heartbeat:Connect(function()
    StatsText.Text = string.format("FPS: %d | %dms", Data.GetFPS(), Data.GetPing())
end)

-- ЛОГИКА СВОРЫВАНИЯ И РАЗВЕРТЫВАНИЯ
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenPosition(UDim2.new(0.5, -260, 0.5, -600), "Out", "Quint", 0.5, true)
    task.wait(0.2)
    OpenBtn.Visible = true
    StatsFrame.Visible = true
    OpenBtn:TweenPosition(UDim2.new(0.5, -120, 0, 10), "Out", "Back", 0.4, true)
    StatsFrame:TweenPosition(UDim2.new(0.5, 130, 0, 10), "Out", "Back", 0.4, true)
end)

OpenBtn.MouseButton1Click:Connect(function()
    OpenBtn:TweenPosition(UDim2.new(0.5, -120, 0, -40), "In", "Quint", 0.3, true)
    StatsFrame:TweenPosition(UDim2.new(0.5, 130, 0, -40), "In", "Quint", 0.3, true)
    task.wait(0.1)
    MainFrame:TweenPosition(UDim2.new(0.5, -260, 0.5, -170), "Out", "Quint", 0.5, true)
end)

-- ПЕРЕТАСКИВАНИЕ МЕНЮ (Drag GUI)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- СОЗДАНИЕ ВКЛАДОК (Контейнеры)
local TabButtons = Instance.new("Frame")
TabButtons.Size = UDim2.new(0, 130, 1, -60)
TabButtons.Position = UDim2.new(0, 10, 0, 50)
TabButtons.BackgroundTransparency = 1
TabButtons.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 5)
UIList.Parent = TabButtons

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -160, 1, -60)
Container.Position = UDim2.new(0, 150, 0, 50)
Container.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = Container

-- Функция добавления вкладок
local tabs = {}
local function createTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.Parent = Container
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
    Btn.Text = name
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.Parent = TabButtons
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        for _, p in pairs(tabs) do p.Visible = false end
        Page.Visible = true
    end)
    
    tabs[name] = Page
    return Page
end

-- Создаем 3 вкладки, запрошенные тобой:
local TabPlayer = createTab("Игрок")
local TabVisuals = createTab("Кастомизация")
local TabProtection = createTab("Защита")
tabs["Игрок"].Visible = true -- Открыта по умолчанию

-- ЗАПОЛНЕНИЕ ВКЛАДКИ "ИГРОК" (Информация о системе)
local function addInfoLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "  " .. text
    lbl.Parent = parent
end

addInfoLabel(TabPlayer, "Устройство: " .. Data.Platform)
addInfoLabel(TabPlayer, "Инжектор: " .. Data.Executor)
addInfoLabel(TabPlayer, "Версия скрипта: " .. Data.Version)

print("[Fox Visuals UI]: Интерфейс успешно сгенерирован!")

-- Подгружаем файл функций (Заготовка, свяжем позже)
-- _G.FoxFunctions.Init(TabPlayer, TabVisuals, TabProtection)
