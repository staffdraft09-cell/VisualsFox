-- [[ Fox Visuals V2 - UI Engine ]] --
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild("FoxVisuals_Gui") then
    CoreGui.FoxVisuals_Gui:Destroy()
end

local Data = _G.FoxVisualsData or {
    Version = "V2", Name = "Visual_FoxV1", Executor = "Unknown", Platform = "PC",
    GetFPS = function() return 60 end, GetPing = function() return 10 end
}
local FoxFunctions = _G.FoxFunctions or {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FoxVisuals_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 340)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 27)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.Text = Data.Name
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(240, 240, 245)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 0.6
Title.TextStrokeColor3 = Color3.fromRGB(240, 140, 60)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.Text = "—"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = MainFrame

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 240, 0, 32)
OpenBtn.Position = UDim2.new(0.5, -120, 0, -40)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
OpenBtn.BackgroundTransparency = 0.2
OpenBtn.Text = "Открыть Fox Visuals V2"
OpenBtn.Font = Enum.Font.GothamSemibold
OpenBtn.TextSize = 14
OpenBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(240, 150, 70)
OpenStroke.Thickness = 1.5

local StatsFrame = Instance.new("Frame")
StatsFrame.Size = UDim2.new(0, 130, 0, 32)
StatsFrame.Position = UDim2.new(0.5, 130, 0, -40)
StatsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
StatsFrame.BackgroundTransparency = 0.3
StatsFrame.Visible = false
StatsFrame.Parent = ScreenGui
Instance.new("UICorner", StatsFrame).CornerRadius = UDim.new(0, 8)

local StatsText = Instance.new("TextLabel")
StatsText.Size = UDim2.new(1, 0, 1, 0)
StatsText.BackgroundTransparency = 1
StatsText.Font = Enum.Font.Gotham
StatsText.TextSize = 12
StatsText.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsText.Text = "FPS: -- | Ping: --"
StatsText.Parent = StatsFrame

RunService.Heartbeat:Connect(function()
    StatsText.Text = string.format("FPS: %d | %dms", Data.GetFPS(), Data.GetPing())
end)

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
Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

local tabs = {}
local function createTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 400)
    Page.ScrollBarThickness = 3
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

local TabPlayer = createTab("Игрок")
local TabVisuals = createTab("Кастомизация")
local TabProtection = createTab("Защита")
tabs["Игрок"].Visible = true

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
addInfoLabel(TabPlayer, "Версия: " .. Data.Version)

local function createButton(parent, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(230, 230, 235)
    b.Text = text
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(callback)
    return b
end

createButton(TabVisuals, "Надеть Черный Korblox (Визуально)", function()
    if FoxFunctions.ApplyKorblox then FoxFunctions.ApplyKorblox(Color3.fromRGB(15, 15, 15)) end
end)

createButton(TabVisuals, "Надеть Фиолетовый Korblox (Визуально)", function()
    if FoxFunctions.ApplyKorblox then FoxFunctions.ApplyKorblox(Color3.fromRGB(130, 50, 200)) end
end)

createButton(TabVisuals, "Убрать голову (Headless)", function()
    if FoxFunctions.RemoveHead then FoxFunctions.RemoveHead() end
end)

createButton(TabVisuals, "Кастомное Космическое Небо", function()
    if FoxFunctions.SetSkybox then FoxFunctions.SetSkybox("Space") end
end)

createButton(TabVisuals, "Включить ESP на Роли (MM2)", function()
    if FoxFunctions.CreateMM2Esp then 
        task.spawn(function()
            while task.wait(5) do
                FoxFunctions.CreateMM2Esp()
            end
        end)
    end
end)

local flingActive = false
local flingBtn
flingBtn = createButton(TabProtection, "Анти-Флинг: ВЫКЛ", function()
    flingActive = not flingActive
    if flingActive then
        flingBtn.Text = "Анти-Флинг: ВКЛ"
        flingBtn.BackgroundColor3 = Color3.fromRGB(60, 130, 60)
        if FoxFunctions.ToggleAntiFling then FoxFunctions.ToggleAntiFling(true) end
    else
        flingBtn.Text = "Анти-Флинг: ВЫКЛ"
        flingBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
        if FoxFunctions.ToggleAntiFling then FoxFunctions.ToggleAntiFling(false) end
    end
end)

print("[Fox Visuals UI]: Связывание интерфейса и логики успешно завершено!")
