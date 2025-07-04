-- NoMercy.exe | SpeedHub X Style
local Players, UIS, RS = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("RunService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Humanoid = Char:WaitForChild("Humanoid")

local autoSteal, flyEnabled, running, currentSpeed = false, false, true, 16
local velocity = Instance.new("BodyVelocity")
velocity.MaxForce = Vector3.new(9e5,9e5,9e5)
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NoMercyGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 420)
frame.Position = UDim2.new(0.5, -175, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active, frame.Draggable = true, true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "NoMercy.exe"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 80, 0, 35)
closeBtn.Position = UDim2.new(1, -90, 0, 10)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", closeBtn)

local openBtn = Instance.new("ImageButton", game.CoreGui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 15, 0.5, -30)
openBtn.Image = "rbxassetid://4094500112762930"
openBtn.BackgroundTransparency = 1
openBtn.Visible = false

closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
	openBtn.Visible = true
end)
openBtn.MouseButton1Click:Connect(function()
	gui.Enabled = true
	openBtn.Visible = false
end)

function makeToggle(text, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 300, 0, 40)
	btn.Position = UDim2.new(0, 25, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 18
	btn.Text = text .. ": OFF"
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. (state and ": ON" or ": OFF")
		btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
		callback(state)
	end)
end

makeToggle("Auto Steal", 60, function(val) autoSteal = val end)
makeToggle("Fly", 120, function(val) flyEnabled = val end)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(0, 300, 0, 40)
speedBtn.Position = UDim2.new(0, 25, 0, 180)
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBtn.Font = Enum.Font.GothamSemibold
speedBtn.TextSize = 18
speedBtn.Text = "Speed: 16"
speedBtn.Parent = frame

local speeds = {16, 50, 100}
local speedIndex = 1

speedBtn.MouseButton1Click:Connect(function()
	speedIndex = speedIndex % #speeds + 1
	currentSpeed = speeds[speedIndex]
	Humanoid.WalkSpeed = currentSpeed
	speedBtn.Text = "Speed: " .. currentSpeed
end)

-- ESP
function addESP(part, text)
	local bb = Instance.new("BillboardGui", part)
	bb.Size = UDim2.new(0,100,0,40)
	bb.Adornee = part
	bb.AlwaysOnTop = true
	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255,255,0)
	label.TextScaled = true
end

for _, p in pairs(Players:GetPlayers()) do
	if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
		addESP(p.Character.Head, p.Name)
	end
end

for _, b in pairs(workspace:GetDescendants()) do
	if b.Name == "StealHitbox" and b:IsA("BasePart") then
		addESP(b, "Brainroot")
	end
end

-- Auto Steal
function findBrainGod()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj.Name == "BrainGod" and obj:IsA("BasePart") then return obj end
	end
	return nil
end

function getClosestBrain()
	local closest, dist = nil, math.huge
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

function getBase()
	local folder = workspace:FindFirstChild("PlayerBases")
	if folder then
		for _, base in pairs(folder:GetChildren()) do
			if base.Name == LP.Name then return base end
		end
	end
	return nil
end

function teleportTo(part)
	for i=1, 50 do
		HRP.CFrame = HRP.CFrame:Lerp(part.CFrame + Vector3.new(0,3,0), 0.2)
		task.wait(0.01)
	end
end

task.spawn(function()
	while running do
		task.wait(0.5)
		if autoSteal and findBrainGod() then
			local brain = getClosestBrain()
			if brain then
				teleportTo(brain)
				firetouchinterest(HRP, brain, 0)
				firetouchinterest(HRP, brain, 1)
				task.wait(0.3)
				local base = getBase()
				if base then
					teleportTo(base)
					firetouchinterest(HRP, base, 0)
					firetouchinterest(HRP, base, 1)
				end
			end
		end
	end
end)

-- Fly
local flying = false
RS.Heartbeat:Connect(function()
	if flyEnabled and not flying then
		velocity.Parent = HRP
		flying = true
	elseif not flyEnabled and flying then
		velocity.Parent = nil
		flying = false
	end
	if flying then
		local dir = Vector3.new()
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
		velocity.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
	end
end)

LP.CharacterRemoving:Connect(function() running = false end)
