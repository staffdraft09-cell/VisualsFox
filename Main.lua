-- [[ Fox Visuals V2 - Main Loader ]] --
local Players = game:Service("Players")
local UserInputService = game:Service("UserInputService")
local RunService = game:Service("RunService")
local Stats = game:Service("Stats")

local LocalPlayer = Players.LocalPlayer

-- 1. ОПРЕДЕЛЕНИЕ ИНЖЕКТОРА
local function getExecutor()
    if identifyexecutor then
        local name, version = identifyexecutor()
        return tostring(name) .. (version and (" " .. tostring(version)) or "")
    elseif textexecutor then
        return "Text Executor"
    elseif checkclosure then
        -- Если явной функции нет, проверяем по косвенным признакам (зависит от xeno/solara)
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

-- 3. СБОР СТАТИСТИКИ (ПРИМЕРНЫЙ ФПС И ПИНГ)
local fps = 0
RunService.RenderStepped:Connect(function(deltaTime)
    fps = math.floor(1 / deltaTime)
end)

local function getPing()
    return math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
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

-- [[ ССЫЛКА НА ТВОЙ ФАЙЛ GUI НА GITНUB ]]
-- Замени URL ниже на прямую (RAW) ссылку твоего gui.lua, когда загрузишь его на GitHub!
local gui_url = "https://githubusercontent.com"

local success, err = pcall(function()
    loadstring(game:HttpGet(gui_url))()
end)

if not success then
    warn("[Fox Visuals Error]: Не удалось загрузить GUI: " .. tostring(err))
end
