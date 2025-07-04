-- Auto Steal مطور: يسرق ويرجع للقاعدة
-- + GUI + ESP + Fly

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 120, 0, 50)
button.Position = UDim2.new(0.5, -60, 0.2, 0)
button.Text = "Auto Steal"
button.BackgroundColor3 = Color3.fromRGB(70, 130, 180)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 100, 0, 30)
close.Position = UDim2.new(0.5, -50, 0.7, 0)
close.Text = "Close GUI"

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0, 100, 0, 30)
open.Position = UDim2.new(0, 10, 0, 10)
open.Text = "Open GUI"
open.Visible = false

close.MouseButton1Click:Connect(function()
	frame.Visible = false
	open.Visible = true
end)

open.MouseButton1Click:Connect(function()
	frame.Visible = true
	open.Visible = false
end)

-- وظيفة الانتقال التدريجي
local function goTo(part)
	if not part then return end
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local distance = (root.Position - part.Position).Magnitude
	local steps = math.floor(distance / 5)
	for i = 1, steps do
		root.CFrame = root.CFrame:Lerp(CFrame.new(part.Position + Vector3.new(0, 3, 0)), 0.1)
		task.wait(0.01)
	end
end

-- إيجاد أقرب Brainroot
local function getClosestBrain()
	local closest, dist = nil, math.huge
	for _,v in pairs(workspace:GetDescendants()) do
		if v.Name == "StealHitbox" and v:IsA("Part") then
			local d = (HRP.Position - v.Position).Magnitude
			if d < dist then
				closest = v
				dist = d
			end
		end
	end
	return closest
end

-- إيجاد قاعدة اللاعب
local function getMyBase()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("TouchTransmitter") and v.Parent:IsA("Part") and v.Parent.Name:lower():find("score") then
			return v.Parent
		end
	end
	return nil
end

-- المهمة الرئيسية
local function autoSteal()
	while true do
		task.wait(1)
		local brain = getClosestBrain()
		if brain then
			goTo(brain)
			task.wait(0.2)
			firetouchinterest(HRP, brain, 0)
			firetouchinterest(HRP, brain, 1)
			task.wait(0.2)

			local base = getMyBase()
			if base then
				goTo(base)
				firetouchinterest(HRP, base, 0)
				firetouchinterest(HRP, base, 1)
			end
		end
	end
end

-- زر التشغيل
button.MouseButton1Click:Connect(function()
	autoSteal()
end)
