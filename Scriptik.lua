local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local keyUrl = "https://raw.githubusercontent.com/NikitosZuev/Zuev/main/Scriptik.lua" -- Твой URL

-- Создаём ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

-- Фон для окна ввода ключа
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.5
background.Parent = screenGui

-- Окно ввода ключа
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(0, 350, 0, 150)
inputFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputFrame.Parent = screenGui

local inputUICorner = Instance.new("UICorner", inputFrame)
inputUICorner.CornerRadius = UDim.new(0, 15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Text = "Введите ключ доступа"
titleLabel.Parent = inputFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.8, 0, 0, 40)
keyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 20
keyBox.TextColor3 = Color3.fromRGB(100, 100, 100)
keyBox.BackgroundColor3 = Color3.new(1, 1, 1)
keyBox.Text = "Введите ключ здесь"
keyBox.ClearTextOnFocus = false
keyBox.Parent = inputFrame

local keyBoxCorner = Instance.new("UICorner", keyBox)
keyBoxCorner.CornerRadius = UDim.new(0, 10)

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.8, 0, 0, 40)
submitButton.Position = UDim2.new(0.1, 0, 0.8, 0)
submitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 22
submitButton.TextColor3 = Color3.new(1, 1, 1)
submitButton.Text = "Подтвердить"
submitButton.Parent = inputFrame

local submitCorner = Instance.new("UICorner", submitButton)
submitCorner.CornerRadius = UDim.new(0, 10)

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, 0, 0, 25)
errorLabel.Position = UDim2.new(0, 0, 1, -30)
errorLabel.BackgroundTransparency = 1
errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
errorLabel.Font = Enum.Font.GothamBold
errorLabel.TextSize = 18
errorLabel.Text = ""
errorLabel.TextWrapped = true
errorLabel.Parent = inputFrame

-- Очистка текста при фокусе
keyBox.Focused:Connect(function()
    if keyBox.Text == "Введите ключ здесь" then
        keyBox.Text = ""
        keyBox.TextColor3 = Color3.new(0, 0, 0)
    end
end)

keyBox.FocusLost:Connect(function()
    if keyBox.Text == "" then
        keyBox.Text = "Введите ключ здесь"
        keyBox.TextColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Функция загрузки ключа с GitHub
local function LoadKey()
    local success, response = pcall(function()
        return game:HttpGet(keyUrl .. "?t=" .. tostring(tick()), true)
    end)
    if not success then
        warn("Не удалось загрузить ключ: " .. tostring(response))
        return nil
    end

    local func, err = loadstring(response)
    if not func then
        warn("Ошибка компиляции ключа: " .. tostring(err))
        return nil
    end

    local env = {}
    setfenv(func, env)
    local ok, err2 = pcall(func)
    if not ok then
        warn("Ошибка выполнения ключа: " .. tostring(err2))
        return nil
    end

    return env.Key
end

local currentKey = LoadKey()
if not currentKey then
    errorLabel.Text = "Не удалось загрузить ключ. Попробуйте позже."
end

-- Функция швыряния игроков
local function ThrowPlayers()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Velocity = Vector3.new(0, 100, 0)
        end
    end
    print("Все игроки были швырнуты!")
end

-- Создаём главное меню с кнопкой швыряния
local function createMainMenu()
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 15)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Text = "Главное меню"
    title.Parent = mainFrame

    local throwButton = Instance.new("TextButton")
    throwButton.Size = UDim2.new(0.6, 0, 0, 50)
    throwButton.Position = UDim2.new(0.2, 0, 0.6, 0)
    throwButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    throwButton.Font = Enum.Font.GothamBold
    throwButton.TextSize = 22
    throwButton.TextColor3 = Color3.new(1, 1, 1)
    throwButton.Text = "Швырнуть игроков"
    throwButton.Parent = mainFrame

    local throwCorner = Instance.new("UICorner", throwButton)
    throwCorner.CornerRadius = UDim.new(0, 10)

    throwButton.MouseButton1Click:Connect(function()
        ThrowPlayers()
    end)
end

-- Обработка нажатия кнопки подтверждения ключа
submitButton.MouseButton1Click:Connect(function()
    if not currentKey then
        errorLabel.Text = "Ключ не загружен, попробуйте позже."
        return
    end

    local enteredKey = keyBox.Text
    if enteredKey == currentKey then
        errorLabel.Text = ""
        inputFrame:Destroy()
        background:Destroy()
        createMainMenu()
    else
        errorLabel.Text = "Неверный ключ! Попробуйте ещё раз."
    end
end)
