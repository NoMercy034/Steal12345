local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NoMercy034"
gui.ResetOnSpawn = false

-- زر فتح/إغلاق باسم Nom
local toggleBtn = Instance.new("TextButton", game.CoreGui)
toggleBtn.Size = UDim2.new(0, 80, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Nom"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Visible = false

-- الإطار الرئيسي
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

-- افتراضي: إظهار التبويب Home
tabs["Home"].Visible = true
currentTab = tabs["Home"]

-- تفعيل زر Nom بعد إغلاق الواجهة
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
