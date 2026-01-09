local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- CONFIG
local BASE_SPEED = 16
local SPEED_PER_LEVEL = 0.8
local MAX_SPEED = 32

local function applySpeed(character)
	local humanoid = character:WaitForChild("Humanoid")

	local level = player:GetAttribute("MoveSpeedLevel") or 0
	local speed = math.clamp(
		BASE_SPEED + (level * SPEED_PER_LEVEL),
		BASE_SPEED,
		MAX_SPEED
	)

	humanoid.WalkSpeed = speed
end

-- Al aparecer
player.CharacterAdded:Connect(applySpeed)

-- Si mejora mientras está vivo
player:GetAttributeChangedSignal("MoveSpeedLevel"):Connect(function()
	if player.Character then
		applySpeed(player.Character)
	end
end)
