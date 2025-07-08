-- NoMercy034.exe | سكربت كامل شامل

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- CONFIG SYSTEM --
local configFile = "config.json"
local config = {
    autoload = true,
    selectedConfig = "default",
    configs = {
        default = {
            fly = false,
            speed = 16,
            superJump = false,
            esp = false,
            tpToSky = false
        }
    }
}

-- Load config from file
if readfile and isfile and isfile(configFile) then
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(configFile))
    end)
    if success then config = result end
end

local function saveConfig()
    if writefile then
        writefile(configFile, HttpService:JSONEncode(config))
    end
end

-- VARIABLES --
local flyEnabled = false
local superJumpEnabled = false
local espEnabled = false
local tpToSkyEnabled = false
local currentSpeed = 16

-- Apply loaded config
local selected = config.configs[config.selectedConfig]
if config.autoload and selected then
    flyEnabled = selected.fly or false
    superJumpEnabled = selected.superJump or false
    espEnabled = selected.esp or false
    tpToSkyEnabled = selected.tpToSky or false
    currentSpeed = selected.speed or 16
end

-- GUI --
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NoMercy034"
gui.ResetOnSpawn = false
gui.Enabled = true

-- Toggle button "Nom"
local toggleBtn = Instance.new("TextButton", game.CoreGui)
toggleBtn.Size = UDim2.new(0, 80, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Nom"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Visible = false

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Tabs
local tabNames = {"Home", "Main", "ESP", "Config"}
local tabs = {}
local currentTab

for i, name in ipairs(tabNames) do
    local tabBtn = Instance.new("TextButton", mainFrame)
    tabBtn.Size = UDim2.new(0, 100, 0, 30)
    tabBtn.Position = UDim2.new(0, 10 + ((i - 1) * 110), 0, 10)
    tabBtn.Text = name
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 14
    tabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    local tabFrame = Instance.new("Frame", mainFrame)
    tabFrame.Size = UDim2.new(1, -20, 1, -60)
    tabFrame.Position = UDim2.new(0, 10, 0, 50)
    tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabFrame.Visible = false
    Instance.new("UICorner", tabFrame)

    tabs[name] = tabFrame

    tabBtn.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Visible = false
        end
        currentTab = tabFrame
        currentTab.Visible = true
    end)
end

-- Show Home tab by default
tabs["Home"].Visible = true
currentTab = tabs["Home"]

-- Close Button
local closeBtn = Instance.new("TextButton", mainFrame)
closeBtn.Size = UDim2.new(0, 80, 0, 30)
closeBtn.Position = UDim2.new(1, -90, 0, 10)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

closeBtn.MouseButton1Click:Connect(function()
    gui.Enabled = false
    toggleBtn.Visible = true
end)

toggleBtn.MouseButton1Click:Connect(function()
    gui.Enabled = true
    toggleBtn.Visible = false
end)

-- Make GUI draggable by mouse and touch
do
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Home Tab content
local homeLabel = Instance.new("TextLabel", tabs["Home"])
homeLabel.Size = UDim2.new(1, -20, 1, -20)
homeLabel.Position = UDim2.new(0, 10, 0, 10)
homeLabel.BackgroundTransparency = 1
homeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
homeLabel.TextWrapped = true
homeLabel.Font = Enum.Font.GothamSemibold
homeLabel.TextSize = 18
homeLabel.Text = "NoMercy034.exe\n\nسكربت شامل للتحكم الكامل في Steal a Brainroot\n\nمطور بواسطة سدر"

-- Main Tab content
local function createToggleButton(parent, pos, text, initialState, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Position = pos
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text .. (initialState and ": ON" or ": OFF")

    btn.MouseButton1Click:Connect(function()
        local newState = not (btn.Text:find("ON") ~= nil)
        btn.Text = text .. (newState and ": ON" or ": OFF")
        callback(newState)
    end)

    return btn
end

-- Super Jump Toggle
local superJumpToggle = createToggleButton(tabs["Main"], UDim2.new(0, 10, 0, 10), "Super Jump", superJumpEnabled, function(state)
    superJumpEnabled = state
    config.configs[config.selectedConfig].superJump = state
    saveConfig()
end)

-- Speed Buttons
local speeds = {16, 50, 100}
local speedIndex = 1
for i, v in ipairs(speeds) do
    if v == currentSpeed then speedIndex = i end
end

local speedBtn = Instance.new("TextButton", tabs["Main"])
speedBtn.Size = UDim2.new(0, 150, 0, 40)
speedBtn.Position = UDim2.new(0, 10, 0, 60)
speedBtn.Font = Enum.Font.GothamBold
speedBtn.TextSize = 16
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Text = "Speed: " .. currentSpeed

speedBtn.MouseButton1Click:Connect(function()
    speedIndex = speedIndex + 1
    if speedIndex > #speeds then speedIndex = 1 end
    currentSpeed = speeds[speedIndex]
    speedBtn.Text = "Speed: " .. currentSpeed
    config.configs[config.selectedConfig].speed = currentSpeed
    saveConfig()
end)

-- TP to Sky Button
local tpSkyBtn = Instance.new("TextButton", tabs["Main"])
tpSkyBtn.Size = UDim2.new(0, 150, 0, 40)
tpSkyBtn.Position = UDim2.new(0, 10, 0, 110)
tpSkyBtn.Font = Enum.Font.GothamBold
tpSkyBtn.TextSize = 16
tpSkyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpSkyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpSkyBtn.Text = "TP to Sky"

tpSkyBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 300, 0) -- يرفع 300 وحدة
    end
end)

-- TP to Ground Button
local tpGroundBtn = Instance.new("TextButton", tabs["Main"])
tpGroundBtn.Size = UDim2.new(0, 150, 0, 40)
tpGroundBtn.Position = UDim2.new(0, 10, 0, 160)
tpGroundBtn.Font = Enum.Font.GothamBold
tpGroundBtn.TextSize = 16
tpGroundBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpGroundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpGroundBtn.Text = "TP to Ground"

tpGroundBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        hrp.CFrame = hrp.CFrame - Vector3.new(0, 300, 0) -- ينزل 300 وحدة
    end
end)

-- ESP Tab content
local espToggle = createToggleButton(tabs["ESP"], UDim2.new(0, 10, 0, 10), "ESP Animals", espEnabled, function(state)
    espEnabled = state
    config.configs[config.selectedConfig].esp = state
    saveConfig()
    -- تفعيل/تعطيل ESP هنا (تحت)
    if espEnabled then
        -- تفعيل ESP
        enableESP()
    else
        -- تعطيل ESP
        disableESP()
    end
end)

-- تعريف ESP الحيوانات النادرة
local rareAnimals = {
    "ترلاليلو", "ترلالا", "برتقالة", "أودين دين دون", "لا فاسكا"
}

local espConnections = {}

function enableESP()
    disableESP() -- نظف ESP القديم
    for _, animalName in pairs(rareAnimals) do
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == animalName and obj:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight", obj)
                highlight.Name = "NoMercyESP"
                highlight.FillColor = Color3.fromRGB(255, 100, 100)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                table.insert(espConnections, highlight)
            end
        end
    end
end

function disableESP()
    for _, highlight in pairs(espConnections) do
        highlight:Destroy()
    end
    espConnections = {}
end

if espEnabled then
    enableESP()
end

-- Config Tab content
local createConfigBtn = Instance.new("TextButton", tabs["Config"])
createConfigBtn.Size = UDim2.new(0, 150, 0, 40)
createConfigBtn.Position = UDim2.new(0, 10, 0, 10)
createConfigBtn.Text = "Create Config"
createConfigBtn.Font = Enum.Font.GothamBold
createConfigBtn.TextSize = 16
createConfigBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
createConfigBtn.Text
