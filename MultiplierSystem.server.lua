local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyMultiplierEvent")
local Config = require(ReplicatedStorage.Modules:WaitForChild("MultiplierConfig"))

BuyEvent.OnServerEvent:Connect(function(player)
	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local energy = stats:FindFirstChild("Energy")
	local multiplier = stats:FindFirstChild("Multiplier")
	if not energy or not multiplier then return end

	-- Nivel del upgrade MultiplierPower
	local powerLevel = player:GetAttribute("MultiplierPowerLevel") or 0

	local cost = Config.GetCost(multiplier.Value, powerLevel)
	local gain = Config.GetMultiplierGain(powerLevel)

	if energy.Value < cost then
		BuyEvent:FireClient(player, false)
		return
	end

	-- COMPRA
	energy.Value = 0
	multiplier.Value += gain

	BuyEvent:FireClient(player, true, gain)
end)
