-- [[ Fox Visuals V2 - Core Functions ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local FoxFunctions = {}

-- 1. ЛОКАЛЬНЫЙ KORBLOX (Замена правой ноги)
function FoxFunctions.ApplyKorblox(color)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local rightLeg = char:FindFirstChild("RightLowerLeg") or char:FindFirstChild("Right Leg")
    
    if rightLeg then
        -- Визуально уменьшаем и перекрашиваем ногу
        if rightLeg:IsA("MeshPart") then
            rightLeg.MeshId = "rbxassetid://902942093" -- ID меша палочки Корблокса
            rightLeg.Color = color or Color3.fromRGB(30, 30, 30) -- Настраиваемый цвет (черный/фиолетовый)
        end
    end
end

-- 2. ЛОКАЛЬНОЕ УДАЛЕНИЕ ГОЛОВЫ (Безголовый всадник)
function FoxFunctions.RemoveHead()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        if head:FindFirstChild("Face") then head.Face:Destroy() end
        if head:FindFirstChild("face") then head.face:Destroy() end
    end
end

-- 3. СМЕНА НЕБА (Кастомный скайбокс)
function FoxFunctions.SetSkybox(style)
    local lighting = game:GetService("Lighting")
    -- Удаляем старое небо
    for _, obj in pairs(lighting:GetChildren()) do
        if obj:IsA("Sky") then obj:Destroy() end
    end
    
    local Sky = Instance.new("Sky")
    Sky.Parent = lighting
    
    if style == "Space" then
        Sky.SkyboxBk = "rbxassetid://12064107"
        Sky.SkyboxDn = "rbxassetid://12064152"
        Sky.SkyboxFt = "rbxassetid://12064121"
        Sky.SkyboxLf = "rbxassetid://12064115"
        Sky.SkyboxRt = "rbxassetid://12064127"
        Sky.SkyboxUp = "rbxassetid://12064142"
    end
end

-- 4. АНТИ-ФЛИНГ ЗАЩИТА (Удаляет коллизию при резком вращении чужих персонажей)
local antiFlingConnection
function FoxFunctions.ToggleAntiFling(state)
    if state then
        antiFlingConnection = RunService.Stepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.Velocity = Vector3.new(0,0,0)
                            part.RotVelocity = Vector3.new(0,0,0)
                        end
                    end
                end
            end
        end)
    else
        if antiFlingConnection then antiFlingConnection:Disconnect() end
    end
end

-- 5. ESP НА РОЛИ ДЛЯ MM2
-- Метод сканирует инструменты (нож/пистолет) у игроков и подсвечивает их
function FoxFunctions.CreateMM2Esp()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Проверяем старый ESP и чистим
            if player.Character:FindFirstChild("FoxHighlight") then
                player.Character.FoxHighlight:Destroy()
            end
            
            local roleColor = Color3.fromRGB(150, 150, 150) -- Житель по умолчанию
            
            -- Проверка на Шерифа или Убийцу
            if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                roleColor = Color3.fromRGB(0, 0, 255) -- Синий (Шериф)
            elseif player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                roleColor = Color3.fromRGB(255, 0, 0) -- Красный (Убийца)
            end
            
            -- Создаем обводку (Highlight)
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "FoxHighlight"
            Highlight.FillColor = roleColor
            Highlight.FillTransparency = 0.5
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.Parent = player.Character
        end
    end
end

_G.FoxFunctions = FoxFunctions
return FoxFunctions
