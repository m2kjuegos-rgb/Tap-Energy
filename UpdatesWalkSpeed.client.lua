local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyUpgradeEvent")
local UpdateUI = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateUpgradeUI")

local upgradeGui = gui:WaitForChild("Upgrade")
local shop = upgradeGui:WaitForChild("UpgradeShop")
local white = shop:WaitForChild("White")
local button = white:WaitForChild("MoveSpeed")

button.MouseButton1Click:Connect(function()
	if not button.Active then return end
	BuyEvent:FireServer("MoveSpeed")
end)

UpdateUI.OnClientEvent:Connect(function(name, level, max, price)
	if name ~= "MoveSpeed" then return end

	button.Updates.Text = level .. "/" .. max

	if level >= max then
		button.Price.Text = "MAX UPGRADE"
		button.Active = false
		button.AutoButtonColor = false
		button.BackgroundTransparency = 0.3
	else
		button.Price.Text = price .. " Coins"
		button.Active = true
		button.AutoButtonColor = true
		button.BackgroundTransparency = 0
	end
end)
