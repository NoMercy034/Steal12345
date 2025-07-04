-- NoMercy.exe | Steal a Brainroot Script
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
local flyEnabled = false
local running = true

-- Sound effect
local Sound = Instance.new("Sound", HRP)
Sound.SoundId = "rbxassetid://12222105"
Sound.Volume = 1

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoMercyExeGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 420)
frame.Position = UDim2.new(0.5, -175, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "NoMercy.exe - Steal a Brainroot"
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "Close GUI"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.Size = UDim2.new(0, 110, 0, 45)
closeBtn.Position = UDim2.new(1, -120, 0, 10)
closeBtn.Parent = frame
local closeUicorner = Instance.new("UICorner", closeBtn)
closeUicorner.CornerRadius = UDim.new(0, 10)

-- Open Button (صورة زر فتح الواجهة)
local openBtn = Instance.new("ImageButton")
openBtn.Size = UDim2.new(0, 70, 0, 70)
openBtn.Position = UDim2.new(0, 15, 0, 15)
openBtn.BackgroundTransparency = 1
openBtn.Visible = false
openBtn.Parent = game.CoreGui
local openUicorner = Instance.new("UICorner", openBtn)
openUicorner.CornerRadius = UDim.new(0, 12)
openBtn.Image = "rbxassetid://4094500112762930" -- صورة البادج اللي طلبتها

-- إنشاء أزرار التبديل
local function createToggle(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 300, 0, 45)
	btn.Position = UDim2.new(0, 25, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 20
	btn.Text = text .. ": OFF"
	btn.Parent = frame

	local enabled = false

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.Text = text .. (enabled and ": ON" or ": OFF")
		btn.BackgroundColor3 = enabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
		if text == "Auto Steal" then
			autoSteal = enabled
		elseif text == "Fly" then
			flyEnabled = enabled
		end
	end)

	return btn
end

local btnAutoSteal = createToggle("Auto Steal", 90)
local btnFly = createToggle("Fly", 150)

-- دالة العثور على BrainGod (شرط للسرقة)
local function findBrainGod()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == "BrainGod" and obj:IsA("BasePart") then
			return obj
		end
	end
	return nil
end

-- دالة العثور على أقرب Brainroot
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

-- دالة الحصول على قاعدة اللاعب الخاصة
local function getMyBase()
	local basesFolder = workspace:FindFirstChild("PlayerBases")
	if basesFolder then
		for _, basePart in pairs(basesFolder:GetChildren()) do
			if basePart.Name == player.Name then
				return basePart
			end
		end
	end
	return nil
end

-- دالة النقل بسلاسة إلى جزء معين
local function teleportTo(part)
	if not part then return end
	for i = 1, 50 do
		HRP.CFrame = HRP.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)), 0.2)
		task.wait(0.01)
	end
end

-- حلقة السرقه الأوتوماتيكية مع شرط وجود BrainGod
spawn(function()
	while running do
		task.wait(0.5)
		if autoSteal then
			local brainGod = findBrainGod()
			if brainGod then
				local brainroot = getClosestBrainroot()
				if brainroot then
					teleportTo(brainroot)
					firetouchinterest(HRP, brainroot, 0)
					firetouchinterest(HRP, brainroot, 1)
					task.wait(0.3)
					local base = getMyBase()
					if base then
						teleportTo(base)
						firetouchinterest(HRP, base, 0)
						firetouchinterest(HRP, base, 1)
					end
				end
			end
		end
	end
end)

-- نظام الطيران الحر (WASD + تحريك كاميرا)
local flying = false
local flySpeed = 50
local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
velocity.Velocity = Vector3.new(0,0,0)

local function startFlying()
	if flying then return end
	flying = true
	velocity.Parent = HRP
	RunService:BindToRenderStep("FlyStep", 301, function()
		if flyEnabled and flying then
			local moveDirection = Vector3.new()
			if UIS:IsKeyDown(Enum.KeyCode.W) then
				moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
			end
			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit * flySpeed
			end
			velocity.Velocity = moveDirection
		else
			velocity.Velocity = Vector3.new(0,0,0)
		end
	end)
end

local function stopFlying()
	flying = false
	RunService:UnbindFromRenderStep("FlyStep")
	velocity.Parent = nil
end

-- مراقبة تفعيل الطيران
RunService.Heartbeat:Connect(function()
	if flyEnabled and not flying then
		startFlying()
	elseif not flyEnabled and flying then
		stopFlying()
	end
end)

-- أزرار التحكم
closeBtn.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = true
	openBtn.Visible = false
end)

-- إغلاق السكربت لو خرج اللاعب أو مات
player.CharacterRemoving:Connect(function()
	running = false
end)
