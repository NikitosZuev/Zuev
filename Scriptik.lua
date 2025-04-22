local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local placeId = game.PlaceId

if placeId == 2753915549 then
    -- Это PlaceId для Blox Fruits (пример)
    print("Blox Fruits detected")
    -- Скрипт для Blox Fruits
    return
elseif placeId == 2809202155 then
    -- Это PlaceId для Your Bizarre Adventure (YBA)
    print("YBA detected")

    -- === Загрузка ключа (ваш оригинальный код, без изменений) ===
    local keyUrl = "https://raw.githubusercontent.com/NikitosZuev/Zuev/main/key.lua"

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

    local correctKey = LoadKey()
    if not correctKey then
        warn("Ключ не загружен, скрипт не будет работать")
        return
    end

    print("Текущий ключ: ", correctKey)

    -- === GUI ===
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainGui"
    screenGui.Parent = game.CoreGui
    screenGui.ResetOnSpawn = false

    -- Фон
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.Parent = screenGui

    -- Ввод ключа
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 400, 0, 180)
    inputFrame.Position = UDim2.new(0.5, -200, 0.5, -90)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    inputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inputFrame.Parent = screenGui

    local inputUICorner = Instance.new("UICorner")
    inputUICorner.CornerRadius = UDim.new(0, 15)
    inputUICorner.Parent = inputFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.Text = "Введите ключ доступа"
    titleLabel.Parent = inputFrame

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.8, 0, 0, 45)
    keyBox.Position = UDim2.new(0.1, 0, 0.45, 0)
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 22
    keyBox.TextColor3 = Color3.fromRGB(100, 100, 100)
    keyBox.BackgroundColor3 = Color3.new(1, 1, 1)
    keyBox.Text = "Введите ключ здесь"
    keyBox.ClearTextOnFocus = false
    keyBox.Parent = inputFrame

    local keyBoxCorner = Instance.new("UICorner")
    keyBoxCorner.CornerRadius = UDim.new(0, 10)
    keyBoxCorner.Parent = keyBox

    local submitButton = Instance.new("TextButton")
    submitButton.Size = UDim2.new(0.8, 0, 0, 45)
    submitButton.Position = UDim2.new(0.1, 0, 0.8, 0)
    submitButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    submitButton.Font = Enum.Font.GothamBold
    submitButton.TextSize = 24
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.Text = "Подтвердить"
    submitButton.Parent = inputFrame

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 10)
    submitCorner.Parent = submitButton

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, 0, 0, 30)
    errorLabel.Position = UDim2.new(0, 0, 1, -40)
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

    -- === Главное меню с вкладками ===
    local mainFrame, tabsFrame, contentFrame

    local function createMainMenu()
        -- Удаляем ввод ключа
        inputFrame:Destroy()
        background.BackgroundTransparency = 0.8

        mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 600, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        mainFrame.Parent = screenGui

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 20)
        mainCorner.Parent = mainFrame

        -- Заголовок
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 28
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Text = "Главное меню"
        title.Parent = mainFrame

        -- Вкладки слева
        tabsFrame = Instance.new("Frame")
        tabsFrame.Size = UDim2.new(0, 150, 1, -50)
        tabsFrame.Position = UDim2.new(0, 0, 0, 50)
        tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabsFrame.Parent = mainFrame

        local tabsCorner = Instance.new("UICorner")
        tabsCorner.CornerRadius = UDim.new(0, 15)
        tabsCorner.Parent = tabsFrame

        -- Контент справа
        contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -150, 1, -50)
        contentFrame.Position = UDim2.new(0, 150, 0, 50)
        contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        contentFrame.Parent = mainFrame

        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 15)
        contentCorner.Parent = contentFrame

        -- Функция для очистки контента
        local function clearContent()
            for _, child in pairs(contentFrame:GetChildren()) do
                if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                    child:Destroy()
                end
            end
        end

        -- Создание кнопок вкладок
        local function createTabButton(text)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -20, 0, 50)
            btn.Position = UDim2.new(0, 10, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 20
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = text
            btn.Parent = tabsFrame

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = btn

            return btn
        end

        -- === Вкладка 1: Основные функции ===
        local tab1 = createTabButton("Основные функции")
        tab1.Position = UDim2.new(0, 10, 0, 10)

        -- === Вкладка 2: Другое ===
        local tab2 = createTabButton("Другое")
        tab2.Position = UDim2.new(0, 10, 0, 70)

        -- === Вкладка 3: Важная информация ===
        local tab3 = createTabButton("Очень важная информация")
        tab3.Position = UDim2.new(0, 10, 0, 130)

        -- === Реализация вкладок ===

        -- --- Вкладка 1: Основные функции ---
        local function setupTab1()
            clearContent()

            -- Заголовок
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 40)
            label.Position = UDim2.new(0, 10, 0, 10)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 22
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Text = "Настройки аима и полёта"
            label.Parent = contentFrame

            -- Аимлок
            local aimLockEnabled = false
            local aimLockKey = Enum.KeyCode.Q -- по умолчанию Q
            local targetPlayer = nil

            -- UI для выбора клавиши аима
            local aimKeyLabel = Instance.new("TextLabel")
            aimKeyLabel.Size = UDim2.new(0, 200, 0, 30)
            aimKeyLabel.Position = UDim2.new(0, 10, 0, 60)
            aimKeyLabel.BackgroundTransparency = 1
            aimKeyLabel.Font = Enum.Font.Gotham
            aimKeyLabel.TextSize = 18
            aimKeyLabel.TextColor3 = Color3.new(1, 1, 1)
            aimKeyLabel.Text = "Клавиша для Aim Lock: Q"
            aimKeyLabel.Parent = contentFrame

            local aimKeyButton = Instance.new("TextButton")
            aimKeyButton.Size = UDim2.new(0, 150, 0, 30)
            aimKeyButton.Position = UDim2.new(0, 220, 0, 60)
            aimKeyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            aimKeyButton.Font = Enum.Font.GothamBold
            aimKeyButton.TextSize = 18
            aimKeyButton.TextColor3 = Color3.new(1, 1, 1)
            aimKeyButton.Text = "Изменить клавишу"
            aimKeyButton.Parent = contentFrame

            local waitingForKeyAim = false
            aimKeyButton.MouseButton1Click:Connect(function()
                if waitingForKeyAim then return end
                waitingForKeyAim = true
                aimKeyLabel.Text = "Нажмите любую клавишу..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                        aimLockKey = input.KeyCode
                        aimKeyLabel.Text = "Клавиша для Aim Lock: " .. tostring(aimLockKey):gsub("Enum.KeyCode.", "")
                        waitingForKeyAim = false
                        conn:Disconnect()
                    end
                end)
            end)

            -- Функции аима из вашего скрипта с небольшими улучшениями
            local function getMiddlePart(character)
                return character and character:FindFirstChild("HumanoidRootPart")
            end

            local function getClosestTarget()
                local closestDistance = math.huge
                local closestPlayer = nil
                if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = player.Character.HumanoidRootPart.Position
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - targetPos).Magnitude
                        if dist < closestDistance then
                            closestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
                return closestPlayer
            end

            local function aimAtTarget(target)
                if not target or not target.Character then return end
                local middlePart = getMiddlePart(target.Character)
                if not middlePart then return end
                local targetPos = middlePart.Position
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            end

            -- Переменные для аима
            local aimLockActive = false
            local aimTarget = nil

            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.KeyCode == aimLockKey then
                    aimLockActive = not aimLockActive
                    if aimLockActive then
                        aimTarget = getClosestTarget()
                        print("Aim Lock Enabled")
                    else
                        aimTarget = nil
                        print("Aim Lock Disabled")
                    end
                end
            end)

            RunService.RenderStepped:Connect(function()
                if aimLockActive and aimTarget then
                    aimAtTarget(aimTarget)
                end
            end)

            -- === Полёт ===
            local flightEnabled = false
            local flightKey = Enum.KeyCode.F -- по умолчанию F

            local flightSpeed = 50
            local flightBodyVelocity = nil
            local flightBodyGyro = nil

            local flightLabel = Instance.new("TextLabel")
            flightLabel.Size = UDim2.new(0, 200, 0, 30)
            flightLabel.Position = UDim2.new(0, 10, 0, 110)
            flightLabel.BackgroundTransparency = 1
            flightLabel.Font = Enum.Font.Gotham
            flightLabel.TextSize = 18
            flightLabel.TextColor3 = Color3.new(1, 1, 1)
            flightLabel.Text = "Клавиша для полёта: F"
            flightLabel.Parent = contentFrame

            local flightKeyButton = Instance.new("TextButton")
            flightKeyButton.Size = UDim2.new(0, 150, 0, 30)
            flightKeyButton.Position = UDim2.new(0, 220, 0, 110)
            flightKeyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
            flightKeyButton.Font = Enum.Font.GothamBold
            flightKeyButton.TextSize = 18
            flightKeyButton.TextColor3 = Color3.new(1, 1, 1)
            flightKeyButton.Text = "Изменить клавишу"
            flightKeyButton.Parent = contentFrame

            local waitingForKeyFlight = false
            flightKeyButton.MouseButton1Click:Connect(function()
                if waitingForKeyFlight then return end
                waitingForKeyFlight = true
                flightLabel.Text = "Нажмите любую клавишу..."
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                        flightKey = input.KeyCode
                        flightLabel.Text = "Клавиша для полёта: " .. tostring(flightKey):gsub("Enum.KeyCode.", "")
                        waitingForKeyFlight = false
                        conn:Disconnect()
                    end
                end)
            end)

            -- Включение/выключение полёта
            UserInputService.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.KeyCode == flightKey then
                    flightEnabled = not flightEnabled
                    if flightEnabled then
                        local character = LocalPlayer.Character
                        if not character then return end
                        local hrp = character:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end

                        flightBodyVelocity = Instance.new("BodyVelocity")
                        flightBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                        flightBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                        flightBodyVelocity.Parent = hrp

                        flightBodyGyro = Instance.new("BodyGyro")
                        flightBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                        flightBodyGyro.CFrame = hrp.CFrame
                        flightBodyGyro.Parent = hrp

                        print("Flight enabled")
                    else
                        if flightBodyVelocity then
                            flightBodyVelocity:Destroy()
                            flightBodyVelocity = nil
                        end
                        if flightBodyGyro then
                            flightBodyGyro:Destroy()
                            flightBodyGyro = nil
                        end
                        print("Flight disabled")
                    end
                end
            end)

            -- Управление полётом в RenderStepped
            RunService.RenderStepped:Connect(function()
                if flightEnabled and flightBodyVelocity and flightBodyGyro then
                    local character = LocalPlayer.Character
                    if not character then return end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    local moveDirection = Vector3.new(0,0,0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        moveDirection = moveDirection + (Camera.CFrame.LookVector)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        moveDirection = moveDirection - (Camera.CFrame.LookVector)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        moveDirection = moveDirection - (Camera.CFrame.RightVector)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        moveDirection = moveDirection + (Camera.CFrame.RightVector)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        moveDirection = moveDirection + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        moveDirection = moveDirection - Vector3.new(0, 1, 0)
                    end
                    flightBodyVelocity.Velocity = moveDirection.Unit * flightSpeed
                    flightBodyGyro.CFrame = hrp.CFrame
                end
            end)
        end

        -- --- Вкладка 2: Другое ---
        local function setupTab2()
            clearContent()

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 40)
            label.Position = UDim2.new(0, 10, 0, 10)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 22
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Text = "Здесь будут другие функции"
            label.Parent = contentFrame
        end

        -- --- Вкладка 3: Важная информация ---
        local function setupTab3()
            clearContent()

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 40)
            label.Position = UDim2.new(0, 10, 0, 10)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.TextSize = 22
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Text = "Очень важная информация будет здесь"
            label.Parent = contentFrame
        end

        -- Назначение функций кнопкам
        tab1.MouseButton1Click:Connect(setupTab1)
        tab2.MouseButton1Click:Connect(setupTab2)
        tab3.MouseButton1Click:Connect(setupTab3)

        -- Показываем первую вкладку по умолчанию
        setupTab1()
    end

    -- Проверка ключа
    submitButton.MouseButton1Click:Connect(function()
        local enteredKey = keyBox.Text
        if enteredKey == correctKey then
            errorLabel.Text = "Ключ верен!"
            errorLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            createMainMenu()
        else
            errorLabel.Text = "Неверный ключ. Попробуйте еще раз."
            errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
else
    print("Игра не поддерживается.")
    -- Обработка, если игра не поддерживается
    return
end
