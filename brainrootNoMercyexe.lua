-- NoMercy Hub 💀 - مع زر Open صورة البادج وزر Close عادي
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HRP = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")

local runningAuto, runningESP, runningFly, runningSpeed = false, false, false, false
local flyForce

local Sound = Instance.new("Sound", HRP)
Sound.SoundId = "rbxassetid://12222105"
Sound.Volume = 1

local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 350)
frame.Position = UDim2.new(0, 200, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true -- للسحب
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "NoMercy Hub 💀"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.Font = Enum.Font.GothamBold

-- زر Open GUI صورة بادج
local open = Instance.new("ImageButton", gui)
open.Size = UDim2.new(0, 60, 0, 60)
open.Position = UDim2.new(0, 10, 0, 10)
open.Image = "rbxassetid://4094500112762930"
open.BackgroundTransparency = 1
open.Visible = false -- يبدأ مخفي لأن الواجهة مفتوحة أولاً

-- زر Close GUI داخل الواجهة
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 100, 0, 40)
close.Position = UDim2.new(1, -110, 0, 10)
close.Text = "Close GUI"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Font = Enum.Font.GothamSemibold
close.TextSize = 20

close.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = false
	open.Visible = true
end)

open.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = true
	open.Visible = false
end)

-- أزرار التفعيل
local function makeToggle(text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 260, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	return btn
end

local btnSteal = makeToggle("Toggle Auto Steal", 70)
local btnESP   = makeToggle("Toggle ESP", 120)
local btnFly   = makeToggle("Toggle Fly", 170)
local btnSpeed = makeToggle("Toggle Speed", 220)

-- باقي الكود بدون تغيير (Auto Steal, ESP, Fly, Speed)...

local function getClosestBrain()
	local closest, dist = nil, math.huge
	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name=="StealHitbox" and v:IsA("Part") then
			local d = (HRP.Position - v.Position).Magnitude
			if d < dist then
				closest, dist = v, d
			end
		end
	end
	return closest
end

local function getMyBase()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("TouchTransmitter") and v.Parent:IsA("Part") and v.Parent.Name:lower():find("score") then
			return v.Parent
		end
	end
	return nil
end

local function goTo(part)
	if not part then return end
	for i=1,50 do
		HRP.CFrame = HRP.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0,3,0)), 0.1)
		task.wait(0.01)
	end
end

coroutine.wrap(function()
	while task.wait(1) do
		if runningAuto then
			local b = getClosestBrain()
			if b then
				goTo(b)
				firetouchinterest(HRP, b, 0)
				firetouchinterest(HRP, b, 1)
				task.wait(
