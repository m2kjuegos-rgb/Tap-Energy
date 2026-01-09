--[[
	Sistema: PlayerStats
	Ubicación: ServerScriptService/Core

	Responsabilidad:
	- Crear leaderstats del jugador
	- Definir stats base del simulador
	- NO maneja guardado
	- NO maneja gameplay
]]

local Players = game:GetService("Players")

-- Stats base del simulador
local DEFAULT_STATS = {
	Energy = 0,
	Multiplier = 1,
	Coins = 100000000,
	Rebirths = 0
}

local function createLeaderstats(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	for statName, defaultValue in pairs(DEFAULT_STATS) do
		local stat = Instance.new("NumberValue")
		stat.Name = statName
		stat.Value = defaultValue
		stat.Parent = leaderstats
	end
end

Players.PlayerAdded:Connect(createLeaderstats)
