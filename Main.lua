-- [[ Fox Visuals V2 - Main Loader ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer

-- 1. ОПРЕДЕЛЕНИЕ ИНЖЕКТОРА
local function getExecutor()
    if identifyexecutor then
        local name, version = identifyexecutor()
        return tostring(name) .. (version and (" " .. tostring(version)) or "")
    elseif textexecutor then
        return "Text Executor"
    elseif checkclosure then
        return "Unknown (Supported)"
    else
        return "Solara/Xeno or Similar"
    end
end

-- 2. ОПРЕДЕЛЕНИЕ УСТРОЙСТВА
local function getPlatform()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile/Tablet"
    elseif UserInputService.KeyboardEnabled then
        return "PC / Laptop"
    elseif UserInputService.GamepadEnabled then
        return "Console"
    else
        return "Unknown Device"
    end
end

-- 3. СБОР СТАТИСТИКИ (ФПС И ПИНГ)
local fps = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fps = math.floor(1 / deltaTime)
end)

local function getPing()
    local s, v = pcall(function() return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    return s and v or 0
end

-- Сборка данных в глобальную таблицу, чтобы gui.lua мог их прочитать
_G.FoxVisualsData = {
    Version = "V2",
    Name = "Visual_FoxV1",
    Executor = getExecutor(),
    Platform = getPlatform(),
    GetFPS = function() return fps end,
    GetPing = function() return getPing() end
}

print("[Fox Visuals]: Данные успешно собраны! Запуск интерфейса...")

-- ТВОИ RAW-ССЫЛКИ С GITНUB
local functions_url = "https://raw.githubusercontent.com/staffdraft09-cell/VisualsFox/refs/heads/main/functions.lua"
local gui_url = "https://raw.githubusercontent.com/staffdraft09-cell/VisualsFox/refs/heads/main/gui.lua"

-- Загружаем логику, а затем сам GUI
pcall(function() loadstring(game:HttpGet(functions_url))() end)
pcall(function() loadstring(game:HttpGet(gui_url))() end)
