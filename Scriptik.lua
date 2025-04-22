local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local placeId = game.PlaceId

local PLACE_ID_BLOX_FRUITS = 2753915549
local PLACE_ID_YBA = 2809202155

if placeId == PLACE_ID_BLOX_FRUITS then
    -- Blox Fruits: GUI и функционал "Фрукты"
    local screenGuiBF = Instance.new("ScreenGui")
    screenGuiBF.Name = "BloxFruitGui"
    screenGuiBF.Parent = game.CoreGui
    screenGuiBF.ResetOnSpawn = false

    local mainFrameBF = Instance.new("Frame")
    mainFrameBF.Size = UDim2.new(0, 600, 0, 400)
    mainFrameBF.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrameBF.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrameBF.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrameBF.Parent = screenGuiBF
    local UICornerMain = Instance.new("UICorner")
    UICornerMain.CornerRadius = UDim.new(0, 15)
    UICornerMain.Parent = mainFrameBF

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0, 150, 1, 0)
    tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tabsFrame.Parent = mainFrameBF
    local UICornerTabs = Instance.new("UICorner")
    UICornerTabs.CornerRadius = UDim.new(0, 15)
    UICornerTabs.Parent = tabsFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -150, 1, 0)
    contentFrame.Position = UDim2.new(0, 150, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    contentFrame.Parent = mainFrameBF
    local UICornerContent = Instance.new("UICorner")
    UICornerContent.CornerRadius = UDim.new(0, 15)
    UICornerContent.Parent = contentFrame

    local function clearContent()
        for _, child in pairs(contentFrame:GetChildren()) do
            if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
                child:Destroy()
            end
        end
    end

    local function createTabButton(text, yPosition)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, yPosition)
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

    local function teleportToAnotherServer()
        print("Фруктов нет, ищем другой сервер...")
        local servers = {}

        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. PLACE_ID_BLOX_FRUITS .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success then
            local data = HttpService:JSONDecode(response)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        else
            warn("Не удалось получить список серверов")
            return
        end

        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(PLACE_ID_BLOX_FRUITS, randomServer, LocalPlayer)
        else
            warn("Нет доступных серверов для телепорта")
        end
    end

    local function flyToPosition(targetPos)
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local speed = 100
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        while (hrp.Position - targetPos).Magnitude > 3 do
            local direction = (targetPos - hrp.Position).Unit
            bv.Velocity = direction * speed
            bg.CFrame = CFrame.new(hrp.Position, targetPos)
            RunService.Heartbeat:Wait()
        end

        bv:Destroy()
        bg:Destroy()
    end

    local function findFruits()
        local fruitFolder = workspace:FindFirstChild("FruitSpawns") or workspace:FindFirstChild("Fruits") or workspace
        local fruits = {}
        for _, obj in pairs(fruitFolder:GetChildren()) do
            if obj:IsA("Model") and obj.Name:find("Fruit") and obj.PrimaryPart then
                table.insert(fruits, obj)
            end
        end
        return fruits
    end

    local function collectFruit(fruitModel)
        if not fruitModel then return end
        local clickDetector = fruitModel:FindFirstChildWhichIsA("ClickDetector")
        if clickDetector then
            clickDetector:FireClick(LocalPlayer)
            print("Фрукт собран: " .. fruitModel.Name)
        else
            print("ClickDetector не найден у фрукта: " .. fruitModel.Name)
        end
    end

    local function setupFruitsTab()
        clearContent()

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -20, 0, 40)
        titleLabel.Position = UDim2.new(0, 10, 0, 10)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 24
        titleLabel.TextColor3 = Color3.new(1, 1, 1)
        titleLabel.Text = "Авто сбор фруктов"
        titleLabel.Parent = contentFrame

        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, -20, 0, 30)
        infoLabel.Position = UDim2.new(0, 10, 0, 60)
        infoLabel.BackgroundTransparency = 1
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 18
        infoLabel.TextColor3 = Color3.new(1, 1, 1)
        infoLabel.Text = "Нажмите кнопку для поиска фруктов на сервере"
        infoLabel.Parent = contentFrame

        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, -20, 0, 30)
        statusLabel.Position = UDim2.new(0, 10, 0, 100)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.TextSize = 20
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        statusLabel.Text = ""
        statusLabel.Parent = contentFrame

        local searchButton = Instance.new("TextButton")
        searchButton.Size = UDim2.new(0, 200, 0, 50)
        searchButton.Position = UDim2.new(0.5, -100, 0, 140)
        searchButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        searchButton.Font = Enum.Font.GothamBold
        searchButton.TextSize = 22
        searchButton.TextColor3 = Color3.new(1, 1, 1)
        searchButton.Text = "Поиск фруктов"
        searchButton.Parent = contentFrame
        local cornerBtn = Instance.new("UICorner")
        cornerBtn.CornerRadius = UDim.new(0, 12)
        cornerBtn.Parent = searchButton

        local searching = false

        searchButton.MouseButton1Click:Connect(function()
            if searching then return end
            searching = true
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            statusLabel.Text = "Ищу фрукты на сервере..."
            task.spawn(function()
                local fruits = findFruits()
                if #fruits == 0 then
                    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    statusLabel.Text = "Фрукт не найден! Телепортирую на следующий сервер..."
                    wait(2)
                    teleportToAnotherServer()
                else
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    statusLabel.Text = "Фрукт найден! Лечу к фрукту..."
                    for _, fruit in pairs(fruits) do
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            flyToPosition(fruit.PrimaryPart.Position + Vector3.new(0, 3, 0))
                            collectFruit(fruit)
                            wait(1)
                        end
                    end
                    statusLabel.Text = "Все найденные фрукты собраны."
                end
                searching = false
            end)
        end)
    end

    local fruitsTabButton = createTabButton("Фрукты", 10)
    fruitsTabButton.MouseButton1Click:Connect(setupFruitsTab)
    setupFruitsTab()

elseif placeId == PLACE_ID_YBA then
    -- Your Bizarre Adventure (YBA): скрипт с ключом и GUI

    local keyUrl = "https://raw.githubusercontent.com/NikitosZuev/Zuev/main/key.lua"

    local function LoadKey()
        local success, response = pcall(function()
            return game:HttpGet(keyUrl .. "?t=" .. tostring(tick()), true)
        end)
        if not success then
            warn("Не удалось загрузить ключ: " .. tostring(response))
            return nil
        end

    -- Checking for empty response
        if not response then
            warn("Ответ сервера пустой!")
            return nil
        end

        local func, err = load(response)
        if not func then
            warn("Ошибка компиляции ключа: " .. tostring(err))
            return nil
        end

        --Local env = {}
        --setmetatable(env, {__index = _G})
        --setfenv(func, env) -- если setfenv не работает, можно заменить на: func = load(response, nil, "t", env)
	    --[[local env = {}
	    setmetatable(env, {__index = _G})
	    _ENV = env
	    func()]]
        local env = {script = script}
        setmetatable(env, {__index = _G})
        local ok, err2 = pcall(function()
            return func()
        end)
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

    -- Далее вставьте ваш полный рабочий GUI и функционал YBA
    -- Для примера ниже — базовый ввод ключа и меню

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainGui"
    screenGui.Parent = game.CoreGui
    screenGui.ResetOnSpawn = false

    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.new(0, 0, 0)
    background.BackgroundTransparency = 0.5
    background.Parent = screenGui

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

    local function createMainMenu()
        inputFrame:Destroy()
        background.BackgroundTransparency = 0.8

        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 600, 0, 400)
        mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
        mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        mainFrame.Parent = screenGui

        local mainCorner = Instance.new("UICorner")
        mainCorner.CornerRadius = UDim.new(0, 20)
        mainCorner.Parent = mainFrame

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.Position = UDim2.new(0, 0, 0, 0)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.TextSize = 28
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Text = "Главное меню"
        title.Parent = mainFrame

        local tabsFrame = Instance.new("Frame")
        tabsFrame.Size = UDim2.new(0, 150, 1, -50)
        tabsFrame.Position = UDim2.new(0, 0, 0, 50)
        tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabsFrame.Parent = mainFrame

        local tabsCorner = Instance.new("UICorner")
        tabsCorner.CornerRadius = UDim.new(0, 15)
        tabsCorner.Parent = tabsFrame

        local contentFrame = Instance.new("Frame")
        contentFrame.Size = UDim2.new(1, -150, 1, -50)
        contentFrame.Position = UDim2.new(0, 150, 0, 50)
        contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        contentFrame.Parent = mainFrame

        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 15)
        contentCorner.Parent = contentFrame

        -- Здесь добавьте ваши вкладки и функционал YBA
    end

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
    warn("Игра не поддерживается этим скриптом.")
end
