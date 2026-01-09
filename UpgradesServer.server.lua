local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyEvent = ReplicatedStorage.RemoteEvents.BuyUpgradeEvent
local UpdateUI = ReplicatedStorage.RemoteEvents.UpdateUpgradeUI

-- CONFIG
local MAX_LEVEL = 20
local BASE_PRICE = 100
local PRICE_MULTIPLIER = 1.28
local BASE_COOLDOWN = 1
local COOLDOWN_REDUCTION = 0.04
local MIN_COOLDOWN = 0.2

local function getPrice(level)
	return math.floor(BASE_PRICE * (PRICE_MULTIPLIER ^ level))
end

Players.PlayerAdded:Connect(function(player)
	-- Folder privado
	local data = Instance.new("Folder")
	data.Name = "PlayerData"
	data.Parent = player

	local level = Instance.new("IntValue")
	level.Name = "CooldownLevel"
	level.Value = 0
	level.Parent = data

	local cooldown = Instance.new("NumberValue")
	cooldown.Name = "TapCooldown"
	cooldown.Value = BASE_COOLDOWN
	cooldown.Parent = data
end)

BuyEvent.OnServerEvent:Connect(function(player, upgradeName)
	if upgradeName ~= "TapCooldown" then return end

	local stats = player:FindFirstChild("leaderstats")
	local data = player:FindFirstChild("PlayerData")
	if not stats or not data then return end

	local coins = stats:FindFirstChild("Coins")
	local level = data:FindFirstChild("CooldownLevel")
	local cooldown = data:FindFirstChild("TapCooldown")
	if not coins or not level or not cooldown then return end

	if level.Value >= MAX_LEVEL then return end

	local price = getPrice(level.Value)
	if coins.Value < price then return end

	-- COMPRA
	coins.Value -= price
	level.Value += 1

	cooldown.Value = math.max(
		MIN_COOLDOWN,
		BASE_COOLDOWN - (level.Value * COOLDOWN_REDUCTION)
	)

	UpdateUI:FireClient(
		player,
		"TapCooldown",
		level.Value,
		MAX_LEVEL,
		getPrice(level.Value)
	)
end)
