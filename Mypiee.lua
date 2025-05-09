local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedwayHub"
ScreenGui.ResetOnSpawn = false

-- Toggle Button (BMW Logo)
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Name = "ToggleButton"
ToggleButton.Position = UDim2.new(1, -70, 0, 20)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = "rbxassetid://3290453459" -- BMW Logo

-- Main Panel
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 360)
MainFrame.Position = UDim2.new(1, -240, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local corner = Instance.new("UICorner", MainFrame)
corner.CornerRadius = UDim.new(0, 16)

-- Layout
local layout = Instance.new("UIListLayout", MainFrame)
layout.Padding = UDim.new(0, 8)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Button creator
local function createButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 180, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	btn.Text = name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Parent = MainFrame
	local uic = Instance.new("UICorner", btn)
	uic.CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
end

-- Noclip
local noclipActive = false
createButton("Toggle Noclip", function()
	noclipActive = not noclipActive
	RunService.Stepped:Connect(function()
		if noclipActive and LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end)

-- Head Lock
local headLock = false
createButton("Toggle Head Lock", function()
	headLock = not headLock
	RunService.RenderStepped:Connect(function()
		if headLock then
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
					LocalPlayer.Character:SetPrimaryPartCFrame(
						CFrame.new(LocalPlayer.Character.PrimaryPart.Position, player.Character.Head.Position)
					)
					break
				end
			end
		end
	end)
end)

-- ESP
local espEnabled = false
createButton("Toggle ESP", function()
	espEnabled = not espEnabled
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if espEnabled and not player.Character:FindFirstChild("ESPHighlight") then
				local hl = Instance.new("Highlight", player.Character)
				hl.Name = "ESPHighlight"
				hl.FillColor = Color3.new(1,1,1)
				hl.OutlineColor = Color3.new(0,0,0)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			elseif not espEnabled and player.Character:FindFirstChild("ESPHighlight") then
				player.Character.ESPHighlight:Destroy()
			end
		end
	end
end)

-- Fly
local flying = false
local flySpeed = 50
createButton("Toggle Fly", function()
	flying = not flying
	local bodyGyro = Instance.new("BodyGyro")
	local bodyVelocity = Instance.new("BodyVelocity")

	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = char:WaitForChild("HumanoidRootPart")
	bodyGyro.P = 9e4
	bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.cframe = root.CFrame
	bodyGyro.Parent = root

	bodyVelocity.velocity = Vector3.new(0, 0, 0)
	bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
	bodyVelocity.Parent = root

	RunService.RenderStepped:Connect(function()
		if flying then
			local moveDir = LocalPlayer:GetMouse().Hit.LookVector
			bodyVelocity.velocity = moveDir * flySpeed
			bodyGyro.cframe = workspace.CurrentCamera.CFrame
		else
			if bodyGyro and bodyGyro.Parent then bodyGyro:Destroy() end
			if bodyVelocity and bodyVelocity.Parent then bodyVelocity:Destroy() end
		end
	end)
end)

-- Delete GUI
createButton("Delete GUI", function()
	ScreenGui:Destroy()
end)

-- Close GUI Button
createButton("Close GUI", function()
	MainFrame.Visible = false
end)

-- Toggle Visibility (BMW Logo)
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)
