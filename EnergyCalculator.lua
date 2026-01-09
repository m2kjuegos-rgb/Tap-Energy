--==================================================
-- MODULE: EnergyCalculator
-- Responsabilidad:
-- - Calcular energía por tap
-- - Cooldown
-- - Paquetes de energía (random)
--==================================================

local EnergyCalculator = {}

--==============================
-- CONFIGURACIÓN BASE
--==============================

local BASE_ENERGY = 1
local BASE_TAP_COOLDOWN = 1

-- Probabilidad base de paquete (5%)
local BASE_PACKAGE_CHANCE = 0.01

--==============================
-- COOLDOWN
--==============================

function EnergyCalculator.GetTapCooldown(player)
	-- Más adelante: reducir con upgrades
	return BASE_TAP_COOLDOWN
end

--==============================
-- ENERGÍA BASE
--==============================

function EnergyCalculator.GetEnergyPerTap(multiplier)
	return BASE_ENERGY * multiplier
end

--==============================
-- PAQUETES DE ENERGÍA
--==============================

local function getPackageByMultiplier(multiplier)
	if multiplier <= 5 then
		return math.random(3, 5)
	elseif multiplier <= 15 then
		return math.random(5, 12)
	else
		return math.random(10, 25)
	end
end

function EnergyCalculator.RollEnergyPackage(player, multiplier)
	local chance = BASE_PACKAGE_CHANCE
	-- Más adelante: chance += upgrades del jugador

	if math.random() < chance then
		return getPackageByMultiplier(multiplier)
	end

	return 0
end

--==============================
-- RESULTADO FINAL POR TAP
--==============================

function EnergyCalculator.CalculateTapEnergy(player, multiplier)
	local energy = EnergyCalculator.GetEnergyPerTap(multiplier)
	local package = EnergyCalculator.RollEnergyPackage(player, multiplier)

	return energy + package, package
end

return EnergyCalculator
