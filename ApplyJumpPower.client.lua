local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- CONFIG
local BASE_JUMP = 50
local JUMP_PER_LEVEL = 2.5
local MAX_JUMP = 100

local function applyJump(character)
	local humanoid = character:WaitForChild("Humanoid")

	local level = player:GetAttribute("JumpPowerLevel") or 0
	local jump = math.clamp(
		BASE_JUMP + (level * JUMP_PER_LEVEL),
		BASE_JUMP,
		MAX_JUMP
	)

	humanoid.JumpPower = jump
	humanoid.UseJumpPower = true
end

player.CharacterAdded:Connect(applyJump)

player:GetAttributeChangedSignal("JumpPowerLevel"):Connect(function()
	if player.Character then
		applyJump(player.Character)
	end
end)
