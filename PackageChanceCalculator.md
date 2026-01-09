local PackageChance = {}

-- CONFIG ECONOMÍA
PackageChance.MAX_LEVEL = 45
PackageChance.BASE_CHANCE = 0.01      -- 1%
PackageChance.MAX_CHANCE = 0.10       -- 10%
PackageChance.PACKAGE_MULTIPLIER = 3  -- x3 energía

-- Calcula probabilidad según nivel
function PackageChance.GetChance(level)
	level = math.clamp(level, 0, PackageChance.MAX_LEVEL)

	local alpha = level / PackageChance.MAX_LEVEL
	return PackageChance.BASE_CHANCE +
		(PackageChance.MAX_CHANCE - PackageChance.BASE_CHANCE) * alpha
end

-- Decide si sale paquete
function PackageChance.Roll(level)
	return math.random() < PackageChance.GetChance(level)
end

-- Energía extra del paquete
function PackageChance.GetPackageEnergy(baseEnergy)
	return math.floor(baseEnergy * PackageChance.PACKAGE_MULTIPLIER)
end

return PackageChance
