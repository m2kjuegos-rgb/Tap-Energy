--========================================
-- Sistema: UpgradeSystem (UNIFICADO)
-- Ubicación: ServerScriptService/Systems
--========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyUpgradeEvent")
local UpdateUI = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateUpgradeUI")

--========================================
-- CONFIGURACIÓN DE UPGRADES
--========================================

local UPGRADES = {

	-- =====================
	-- UPGRADES POR ATRIBUTO
	-- =====================

	PackageChance = {
		Type = "Attribute",
		Attribute = "PackageChanceLevel",
		MaxLevel = 45,
		BasePrice = 150,
		PriceMultiplier = 1.1,
	},

	MoveSpeed = {
		Type = "Attribute",
		Attribute = "MoveSpeedLevel",
		MaxLevel = 20,
		BasePrice = 200,
		PriceMultiplier = 1.35,
	},

	JumpPower = {
		Type = "Attribute",
		Attribute = "JumpPowerLevel",
		MaxLevel = 20,
		BasePrice = 180,
		PriceMultiplier = 1.33,
	},

	MultiplierPower = {
		Type = "Attribute",
		Attribute = "MultiplierPowerLevel",
		MaxLevel = 100,
		BasePrice = 300,
		PriceMultiplier = 1.28,
	},

	TapCooldown = {
		Type = "Cooldown",
		MaxLevel = 20,
		BasePrice = 100,
		PriceMultiplier = 1.28,

		BaseCooldown = 1,
		CooldownReduction = 0.04,
		MinCooldown = 0.2,
	}
}

--========================================
-- FUNCIONES BASE
--========================================

local function getPrice(config, level)
	return math.floor(config.BasePrice * (config.PriceMultiplier ^ level))
end

local function sendUI(player, name, level)
	local config = UPGRADES[name]
	if not config then return end

	UpdateUI:FireClient(
		player,
		name,
		level,
		config.MaxLevel,
		getPrice(config, level)
	)
end

--========================================
-- PLAYER JOIN
--========================================

Players.PlayerAdded:Connect(function(player)

	-- Folder privado para datos NO leaderstats
	local data = Instance.new("Folder")
	data.Name = "PlayerData"
	data.Parent = player

	for name, config in pairs(UPGRADES) do

		if config.Type == "Attribute" then
			if player:GetAttribute(config.Attribute) == nil then
				player:SetAttribute(config.Attribute, 0)
			end
			sendUI(player, name, player:GetAttribute(config.Attribute))

		elseif config.Type == "Cooldown" then
			-- Nivel
			local level = Instance.new("IntValue")
			level.Name = "CooldownLevel"
			level.Value = 0
			level.Parent = data

			-- Cooldown real
			local cooldown = Instance.new("NumberValue")
			cooldown.Name = "TapCooldown"
			cooldown.Value = config.BaseCooldown
			cooldown.Parent = data

			sendUI(player, name, 0)
		end
	end
end)

--========================================
-- COMPRA DE UPGRADES
--========================================

BuyEvent.OnServerEvent:Connect(function(player, upgradeName)
	local config = UPGRADES[upgradeName]
	if not config then return end

	local stats = player:FindFirstChild("leaderstats")
	local coins = stats and stats:FindFirstChild("Coins")
	if not coins then return end

	-- =====================
	-- UPGRADES POR ATRIBUTO
	-- =====================
	if config.Type == "Attribute" then
		local level = player:GetAttribute(config.Attribute) or 0
		if level >= config.MaxLevel then return end

		local price = getPrice(config, level)
		if coins.Value < price then return end

		coins.Value -= price
		player:SetAttribute(config.Attribute, level + 1)

		sendUI(player, upgradeName, level + 1)
	end

	-- =====================
	-- TAP COOLDOWN
	-- =====================
	if config.Type == "Cooldown" then
		local data = player:FindFirstChild("PlayerData")
		if not data then return end

		local level = data:FindFirstChild("CooldownLevel")
		local cooldown = data:FindFirstChild("TapCooldown")
		if not level or not cooldown then return end

		if level.Value >= config.MaxLevel then return end

		local price = getPrice(config, level.Value)
		if coins.Value < price then return end

		coins.Value -= price
		level.Value += 1

		cooldown.Value = math.max(
			config.MinCooldown,
			config.BaseCooldown - (level.Value * config.CooldownReduction)
		)

		sendUI(player, upgradeName, level.Value)
	end
end)
