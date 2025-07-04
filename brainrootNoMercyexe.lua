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
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.3, 0, 0.5, 0) -- 30% عرض الشاشة، 50% ارتفاع الشاشة
frame.Position = UDim2.new(0.35, 0, 0.25, 0) -- بمركز الشاشة
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "NoMercy Hub 💀"
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 85, 85)
title.Font = Enum.Font.GothamBold
title.BorderSizePixel = 0
title.ClipsDescendants = true

local uiCornerTitle = Instance.new("UICorner", title)
uiCornerTitle.CornerRadius = UDim.new(0, 15)

-- دعم السحب من العنوان فقط
local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- زر فتح الواجهة بصورة البادج القديمة
local open = Instance.new("ImageButton", gui)
open.Size = UDim2.new(0, 70, 0, 70)
open.Position = UDim2.new(0, 15, 0, 15)
open.BackgroundTransparency = 1
open.Visible = false
open.AutoButtonColor = false
local uiCornerOpen = Instance.new("UICorner", open)
uiCornerOpen.CornerRadius = UDim.new(0, 12)

-- استخدم صورة البادج القديم
open.Image = "rbxassetid://4094500112762930"

open.MouseEnter:Connect(function()
	open.ImageColor3 = Color3.fromRGB(255, 150, 150)
end)
open.MouseLeave:Connect(function()
	open.ImageColor3 = Color3.fromRGB(255, 255, 255)
end)

open.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = true
	open.Visible = false
end)

-- زر إغلاق الواجهة
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0.3, 0, 0, 45)
close.Position = UDim2.new(0.65, 0, 0, 10)
close.Text = "Close GUI"
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
close.Font = Enum.Font.GothamSemibold
close.TextSize = 20
close.AutoButtonColor = true
local uiCornerClose = Instance.new("UICorner", close)
uiCornerClose.CornerRadius = UDim.new(0, 10)

close.MouseButton1Click:Connect(function()
	Sound:Play()
	frame.Visible = false
	open.Visible = true
end)

-- باقي الكود وأزرار التفعيل (Auto Steal، ESP، Fly، Speed) كما هو

local function makeToggle(text, y)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 45)
	btn.Position = UDim2.new(0.05, 0, 0, y)
	btn.Text = text
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 20
	btn.AutoButtonColor = true
	local uiCornerBtn = Instance.new("UICorner", btn)
	uiCornerBtn.CornerRadius = UDim.new(0, 10)
	return btn
end

local btnSteal = makeToggle("Toggle Auto Steal", 80)
local btnESP   = makeToggle("Toggle ESP", 140)
local btnFly   = makeToggle("Toggle Fly", 200)
local btnSpeed = makeToggle("Toggle Speed", 260)

-- ... (كود وظائف الأزرار كما في ردودك السابقة) ...

-- مثال تشغيل الأزرار (تقدر تطلب مني أضيف باقي التفاصيل لو تبي)

btnFly.MouseButton1Click:Connect(function()
	Sound:Play()
	runningFly = not runningFly
	if runningFly then
		flyForce = Instance.new("BodyVelocity", HRP)
		flyForce.MaxForce = Vector3.new(9e4,9e4,9e4)
		flyForce.Velocity = Vector3.new(0,0,0)
		coroutine.wrap(function()
			while runningFly and flyForce.Parent do
				flyForce.Velocity = LocalPlayer:GetMouse().Hit.LookVector * 50
				task.wait()
			end
		end)()
	else
		if flyForce then flyForce:Destroy() end
	end
end)

btnSpeed.MouseButton1Click:Connect(function()
	Sound:Play()
	runningSpeed = not runningSpeed
	local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = runningSpeed and 32 or 16 end
end)

btnSteal.MouseButton1Click:Connect(function()
	Sound:Play()
	runningAuto = not runningAuto
	btnSteal.BackgroundColor3 = runningAuto and Color3.fromRGB(50,150,50) or Color3.fromRGB(60,60,60)
end)

btnESP.MouseButton1Click:Connect(function()
	Sound:Play()
	runningESP = not runningESP
	btnESP.BackgroundColor3 = runningESP and Color3.fromRGB(50,150,50) or Color3.fromRGB(60,60,60)
end)

UIS.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.RightControl then
		frame.Visible = not frame.Visible
		open.Visible = not open.Visible
		Sound:Play()
	end
end)
