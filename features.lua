local workspace = game:GetService("Workspace")

local rareAnimals = {
    "ترلاليلو", "ترلالا", "برتقالة", "أودين دين دون", "لا فاسكا"
}

local ESP_Highlights = {}

local function enableESP()
    for _, obj in pairs(workspace:GetChildren()) do
        if table.find(rareAnimals, obj.Name) and obj:FindFirstChild("HumanoidRootPart") then
            local h = Instance.new("Highlight", obj)
            h.Name = "NoMercyESP"
            h.FillColor = Color3.fromRGB(255, 100, 100)
            h.OutlineColor = Color3.fromRGB(255, 0, 0)
            table.insert(ESP_Highlights, h)
        end
    end
end

local function disableESP()
    for _, h in ipairs(ESP_Highlights) do
        h:Destroy()
    end
    ESP_Highlights = {}
end

local function superJump(enable)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if enable then
            char.Humanoid.JumpPower = 150
        else
            char.Humanoid.JumpPower = 50
        end
    end
end

local function setSpeed(value)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end

local function tpSky()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 300, 0)
    end
end

local function tpDown()
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = hrp.CFrame - Vector3.new(0, 300, 0)
    end
end

return {
    enableESP = enableESP,
    disableESP = disableESP,
    superJump = superJump,
    setSpeed = setSpeed,
    tpSky = tpSky,
    tpDown = tpDown
}
