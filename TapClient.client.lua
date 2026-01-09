--[[
	Client: TapClient
	Responsabilidad:
	- Detectar clicks del jugador
	- Avisar al servidor
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local TapEvent = ReplicatedStorage.RemoteEvents:WaitForChild("TapEnergyEvent")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		TapEvent:FireServer()
	end
end)
