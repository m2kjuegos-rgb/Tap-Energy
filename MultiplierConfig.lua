local MultiplierConfig = {}

MultiplierConfig.BaseCost = 50
MultiplierConfig.CostMultiplier = 1.6

-- costo extra por nivel de mejora
MultiplierConfig.PowerCostMultiplier = 1.15

-- cuánto sube el multiplier por compra
function MultiplierConfig.GetMultiplierGain(powerLevel)
	return 1 + powerLevel
end

function MultiplierConfig.GetCost(currentMultiplier, powerLevel)
	powerLevel = powerLevel or 0

	local base =
		MultiplierConfig.BaseCost *
		(MultiplierConfig.CostMultiplier ^ (currentMultiplier - 1))

	local powerExtra =
		MultiplierConfig.PowerCostMultiplier ^ powerLevel

	return math.floor(base * powerExtra)
end

return MultiplierConfig
