local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyUpgradeEvent")
local UpdateUI = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateUpgradeUI")

-- =========================
-- CONFIG MEJORAS
-- =========================

local UPGRADES = {

	PackageChance = {
		MaxLevel = 45,
		BasePrice = 150,
		PriceMultiplier = 1.1,
		Attribute = "PackageChanceLevel"
	},
	
	MoveSpeed = {
		MaxLevel = 20,
		BasePrice = 200,
		PriceMultiplier = 1.35,
		Attribute = "MoveSpeedLevel"
	},
	JumpPower = {
		MaxLevel = 20,
		BasePrice = 180,
		PriceMultiplier = 1.33,
		Attribute = "JumpPowerLevel"
	},
	MultiplierPower = {
		MaxLevel = 100,
		BasePrice = 300,
		PriceMultiplier = 1.28,
		Attribute = "MultiplierPowerLevel"
	}
}


-- =========================
-- FUNCIONES
-- =========================

local function getPrice(upgrade, level)
	return math.floor(upgrade.BasePrice * (upgrade.PriceMultiplier ^ level))
end

local function sendUI(player, name)
	local upgrade = UPGRADES[name]
	if not upgrade then return end

	local level = player:GetAttribute(upgrade.Attribute) or 0
	local price = getPrice(upgrade, level)

	UpdateUI:FireClient(
		player,
		name,
		level,
		upgrade.MaxLevel,
		price
	)
end

-- =========================
-- COMPRA
-- =========================

BuyEvent.OnServerEvent:Connect(function(player, upgradeName)
	local upgrade = UPGRADES[upgradeName]
	if not upgrade then return end

	local level = player:GetAttribute(upgrade.Attribute) or 0
	if level >= upgrade.MaxLevel then return end

	local price = getPrice(upgrade, level)

	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	if not coins or coins.Value < price then return end

	coins.Value -= price
	player:SetAttribute(upgrade.Attribute, level + 1)

	sendUI(player, upgradeName)
end)


-- =========================
-- PLAYER JOIN
-- =========================

Players.PlayerAdded:Connect(function(player)
	for name, upgrade in pairs(UPGRADES) do
		if player:GetAttribute(upgrade.Attribute) == nil then
			player:SetAttribute(upgrade.Attribute, 0)
		end
		sendUI(player, name)
	end
end)
