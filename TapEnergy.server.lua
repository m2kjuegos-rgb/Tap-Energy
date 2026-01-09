--[[
	Sistema: TapEnergy
	Ubicación: ServerScriptService/Systems

	Responsabilidad:
	- Recibir taps del cliente
	- Aplicar cooldown por jugador
	- Calcular energía ganada
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TapEvent = ReplicatedStorage.RemoteEvents:WaitForChild("TapEnergyEvent")
local EnergyCalculator = require(ReplicatedStorage.Modules:WaitForChild("EnergyCalculator"))
local VisualEvent = ReplicatedStorage.RemoteEvents:WaitForChild("TapVisualEvent")
local PackageChance = require(ReplicatedStorage.Modules:WaitForChild("PackageChanceCalculator"))

-- Tabla de control de cooldown por jugador
local lastTapTime = {}

TapEvent.OnServerEvent:Connect(function(player)
	local currentTime = os.clock()
	local lastTime = lastTapTime[player] or 0

	local data = player:FindFirstChild("PlayerData")
	if not data then return end

	local cooldownValue = data:FindFirstChild("TapCooldown")
	if not cooldownValue then return end

	local cooldown = cooldownValue.Value


	-- Verificación de cooldown
	if currentTime - lastTime < cooldown then
		return -- tap ignorado
	end

	lastTapTime[player] = currentTime

	local stats = player:FindFirstChild("leaderstats")
	if not stats then return end

	local energy = stats:FindFirstChild("Energy")
	local multiplier = stats:FindFirstChild("Multiplier")
	if not energy or not multiplier then return end

	local gainedEnergy = EnergyCalculator.GetEnergyPerTap(multiplier.Value)

	-- Nivel de mejora de paquete (atributo oculto)
	local packageLevel = player:GetAttribute("PackageChanceLevel") or 0

	local isPackage = PackageChance.Roll(packageLevel)
	local packageEnergy = 0

	if isPackage then
		packageEnergy = PackageChance.GetPackageEnergy(gainedEnergy)
	end

	energy.Value += gainedEnergy + packageEnergy

	-- Evento visual
	ReplicatedStorage.RemoteEvents.TapVisualEvent:FireClient(
		player,
		gainedEnergy + packageEnergy,
		packageEnergy
	)
end)

-- Limpieza al salir
game:GetService("Players").PlayerRemoving:Connect(function(player)
	lastTapTime[player] = nil
end)
