--========================================
-- Client: UpgradeClient (UNIFICADO)
-- Ubicación: StarterPlayerScripts/Systems/Upgrade
--========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyUpgradeEvent")
local UpdateUI = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateUpgradeUI")

--========================================
-- JERARQUÍA UI
--========================================

local upgradeGui = gui:WaitForChild("Upgrade")
local shop = upgradeGui:WaitForChild("UpgradeShop")
local white = shop:WaitForChild("White")

--========================================
-- CONFIG BOTONES
--========================================

local BUTTONS = {
	TapCooldown = {
		Button = white:WaitForChild("ClickSpeed"),
		ShowCoins = false
	},

	PackageChance = {
		Button = white:WaitForChild("PackageChance"),
		ShowCoins = false
	},

	JumpPower = {
		Button = white:WaitForChild("JumpPower"),
		ShowCoins = true
	},

	MoveSpeed = {
		Button = white:WaitForChild("MoveSpeed"),
		ShowCoins = true
		
	},
	
	Multiplier = {
		Button = white:WaitForChild("MultiplierUpgrade"),
		ShowCoins = true
	}
}

--========================================
-- CLICK BOTONES
--========================================

for upgradeName, data in pairs(BUTTONS) do
	local button = data.Button

	button.MouseButton1Click:Connect(function()
		if not button.Active then return end
		BuyEvent:FireServer(upgradeName)
	end)
end

--========================================
-- UPDATE UI DESDE SERVER
--========================================

UpdateUI.OnClientEvent:Connect(function(name, level, max, price)
	local data = BUTTONS[name]
	if not data then return end

	local button = data.Button

	-- Texto progreso
	button.Updates.Text = level .. "/" .. max

	-- =====================
	-- MAX UPGRADE
	-- =====================
	if level >= max then
		button.Price.Text = "MAX UPGRADE"
		button.Active = false
		button.AutoButtonColor = false
		button.BackgroundTransparency = 0.3
		button.Price.TextColor3 = Color3.fromRGB(180,180,180)
		return
	end

	-- =====================
	-- NORMAL
	-- =====================
	if data.ShowCoins then
		button.Price.Text = price .. " Coins"
	else
		button.Price.Text = tostring(price)
	end

	button.Active = true
	button.AutoButtonColor = true
	button.BackgroundTransparency = 0
	button.Price.TextColor3 = Color3.fromRGB(255,255,255)
end)
