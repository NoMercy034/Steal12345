-- SpeedHub-like UI for Steal a Brainroot
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local autoSteal = false
local espEnabled = false
local flyEnabled = false
local speedValue = 16
local flyVelocity

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedHubStealBrainroot"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 450)
frame.Position = UDim2.new(0.5, -175, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "SpeedHub - Steal a Brainroot"
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
closeBtn.BackgroundTransparency = 1
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 10)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
	screenGui.Enabled = false
	openBtn.Visible = true
end)

-- Open Button (image button)
local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0, 20, 0, 20)
openBtn.Image = "rbxassetid://4094500112762930" -- صورة البادج القديمة
openBtn.BackgroundTransparency = 1
openBtn.Visible = false
openBtn.Parent = game.CoreGui

openBtn.MouseButton1Click:Connect(function()
	screenGui.Enabled = true
	openBtn.Visible = false
end)

-- Function to create toggles
local function createToggle(name, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 300, 0, 45)
	btn.Position = UDim2.new(0, 25, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 20
	btn.Text = name .. ": OFF"
	btn.Parent = frame

	local enabled = false

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = name .. (enabled and ": ON" or ": OFF")
		btn.BackgroundColor3 = enabled and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(50, 50, 50)
		if name == "Auto Steal" then
			autoSteal = enabled
		elseif name == "ESP" then
			espEnabled = enabled
			if not enabled then
				-- إزالة ESP من اللاعبين
				for _, p in pairs(Players:GetPlayers()) do
					if p ~= player and p.Character then
						local adorn = p.Character:FindFirstChild("ESPBox")
						if adorn then adorn:Destroy() end
					end
				end
			end
		elseif name == "Fly" then
			flyEnabled = enabled
			if flyEnabled then
				flyVelocity = Instance.new("BodyVelocity")
				flyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
				flyVelocity.Parent = HRP
			else
				if flyVelocity then
					flyVelocity:Destroy()
				end
			end
		end
	end)

	return btn
end

local autoStealBtn = createToggle("Auto Steal", 90)
local espBtn = createToggle("ESP", 150)
local flyBtn = createToggle("Fly", 210)

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0, 25, 0, 270)
speedLabel.Size = UDim2.new(0, 300, 0, 30)
speedLabel.Font = Enum.Font.GothamSemibold
speedLabel.TextSize = 20
speedLabel.Parent = frame

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0, 300, 0, 10)
speedSlider.Position = UDim2.new(0, 25, 0, 310)
speedSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedSlider.Parent = frame
local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 48, 0, 10) -- 16/32 * 300 تقريباً
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
sliderFill.Parent = speedSlider

local draggingSlider = false

speedSlider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = true
	end
end)

speedSlider.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

speedSlider.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
		local pos = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
		sliderFill.Size = UDim2.new(0, pos, 0, 10)
		speedValue = math.floor((pos / speedSlider.AbsoluteSize.X) * 32)
		if speedValue < 16 then speedValue = 16 end
		speedLabel.Text = "Speed: " .. speedValue
		if humanoid then humanoid.WalkSpeed = speedValue end
	end
end)

-- وظائف autoSteal (سرقة Brainroot والرجوع للقاعدة الخاصة)

local function getClosestBrainroot()
	local closest = nil
	local dist = math.huge
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == "StealHitbox" and obj:IsA("BasePart") then
			local d = (HRP.Position - obj.Position).Magnitude
			if d < dist then
				closest = obj
				dist = d
			end
		end
	end
	return closest
end

local function getMyBase()
	-- لو لعبتك تحدد قاعدة اللاعب بطريقة خاصة، عدل هذه الدالة
	-- مثال: القاعدة تكون جزء في workspace اسمه PlayerBases ويحوي أجزاء لكل لاعب باسمهم
	-- هنا مجرد مثال افتراضي:
	local basesFolder = workspace:FindFirstChild("PlayerBases")
	if basesFolder then
		for _, basePart in pairs(basesFolder:GetChildren()) do
			if basePart.Name == player.Name then
				return basePart
			end
		end
	end
	-- إذا ما فيه طريقة محددة، ترجع nil أو جزء ثابت باللعبة
	return nil
end

local function teleportTo(part)
	if not part then return end
	for i = 1, 50 do
		HRP.CFrame = HRP.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)), 0.1)
		task.wait(0.01)
	end
end

spawn(function()
	while task.wait(1) do
		if autoSteal then
			local brain = getClosestBrainroot()
			if brain then
				teleportTo(brain)
				firetouchinterest(HRP, brain, 0)
				firetouchinterest(HRP, brain, 1)
				task.wait(0.5)
				local base = getMyBase()
				if base then
					teleportTo(base)
					firetouchinterest(HRP, base, 0)
					firetouchinterest(HRP, base, 1)
				end
			end
		end
	end
end)

-- ESP loop
RunService.Heartbeat:Connect(function()
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				if not p.Character:FindFirstChild("ESPBox") then
					local box = Instance.new("BoxHandleAdornment")
					box.Name = "ESPBox"
					box.Adornee = p.Character.HumanoidRootPart
					box.Size = Vector3.new(4, 5, 2)
					box.Color3 = Color3.fromRGB(0, 255, 0)
					box.Transparency = 0.5
					box.AlwaysOnTop = true
					box.Parent = p.Character
				end
			end
		end
	else
		for _, p in pairs(Players:GetPlayers()) do
			if p.Character then
				local box = p.Character:FindFirstChild("ESPBox")
				if box then box:Destroy() end
			end
		end
	end
end)

-- Fly update loop
RunService.Heartbeat:Connect(function()
	if flyEnabled and flyVelocity then
		local mouse = player:GetMouse()
		flyVelocity.Velocity = mouse.Hit.LookVector * 50
	end
end)

-- اختصار لوحة مفاتيح لفتح/إغلاق الواجهة
UIS.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightControl then
		screenGui.Enabled = not screenGui.Enabled
		openBtn.Visible = not screenGui.Enabled
		Sound:Play()
	end
end)

-- تعيين سرعة المشي الافتراضية
humanoid.WalkSpeed = speedValue
