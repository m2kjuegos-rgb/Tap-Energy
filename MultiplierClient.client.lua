local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local stats = player:WaitForChild("leaderstats")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyMultiplierEvent")
local Config = require(ReplicatedStorage.Modules:WaitForChild("MultiplierConfig"))

-- UI
local frame = script.Parent.Frame.White.Button
local costLabel = frame.CostLabel
local energyLabel = frame.EnergyLabel
local multiplierLabel = frame.MultiplierLabel
local buyButton = frame.BuyButton
local multiplierlabelgain = frame.Title


local function playSound(id, volume)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. id
	s.Volume = volume or 1
	s.Parent = SoundService
	s:Play()
	game:GetService("Debris"):AddItem(s, 2)
end

local BUY_SOUND = 6026984224
local ERROR_SOUND = 9118823101

local function pulseButton()
	TweenService:Create(buyButton, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
		Size = buyButton.Size + UDim2.fromOffset(6,6)
	}):Play()

	task.delay(0.12, function()
		TweenService:Create(buyButton, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
			Size = buyButton.Size
		}):Play()
	end)
end

local function shakeButton()
	local original = buyButton.Position
	for i = 1, 6 do
		buyButton.Position = original + UDim2.fromOffset(math.random(-4,4),0)
		task.wait(0.03)
	end
	buyButton.Position = original
end

local function updateButtonState()
	local energy = stats.Energy.Value
	local cost = Config.GetCost(stats.Multiplier.Value)

	if energy < cost then
		buyButton.AutoButtonColor = false
		buyButton.BackgroundTransparency = 0.4
	else
		buyButton.AutoButtonColor = true
		buyButton.BackgroundTransparency = 0
	end
end

local function getPowerLevel()
	return player:GetAttribute("MultiplierPowerLevel") or 0
end

local function updateUI()
	local energy = stats.Energy.Value
	local multiplier = stats.Multiplier.Value
	local cost = Config.GetCost(multiplier, getPowerLevel())
	local gain = Config.GetMultiplierGain(getPowerLevel())
	multiplierlabelgain.Text = "Multiplier x" .. gain

	energyLabel.Text = "Energy: " .. energy
	multiplierLabel.Text = "x" .. multiplier
	costLabel.Text = "Cost: " .. cost

	updateButtonState()
end



buyButton.MouseButton1Click:Connect(function()
	BuyEvent:FireServer()
end)

BuyEvent.OnClientEvent:Connect(function(success)
	if success then
		pulseButton()
		playSound(BUY_SOUND, 0.8)
	else
		shakeButton()
		playSound(ERROR_SOUND, 0.7)
	end
	updateUI()
end)

player:GetAttributeChangedSignal("MultiplierPowerLevel"):Connect(updateUI)

stats.Energy:GetPropertyChangedSignal("Value"):Connect(updateUI)
stats.Multiplier:GetPropertyChangedSignal("Value"):Connect(updateUI)

updateUI()
