local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local BuyEvent = ReplicatedStorage.RemoteEvents:WaitForChild("BuyUpgradeEvent")
local UpdateUI = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateUpgradeUI")

-- Esperar jerarquía completa
local upgradeGui = gui:WaitForChild("Upgrade")
local shop = upgradeGui:WaitForChild("UpgradeShop")
local white = shop:WaitForChild("White")
local button = white:WaitForChild("ClickSpeed")

-- ==========================
-- CLICK BOTÓN
-- ==========================
button.MouseButton1Click:Connect(function()
	if not button.Active then return end
	BuyEvent:FireServer("TapCooldown")
end)

-- ==========================
-- UPDATE UI DESDE SERVER
-- ==========================
UpdateUI.OnClientEvent:Connect(function(name, level, max, price)
	if name ~= "TapCooldown" then return end

	button.Updates.Text = level .. "/" .. max

	-- 🟡 SI YA ES MAX
	if level >= max then
		button.Price.Text = "MAX UPGRADE"
		button.Active = false
		button.AutoButtonColor = false
		button.BackgroundTransparency = 0.3

		-- Opcional: color gris elegante
		button.Price.TextColor3 = Color3.fromRGB(180,180,180)
	else
		button.Price.Text = price
		button.Active = true
		button.AutoButtonColor = true
		button.BackgroundTransparency = 0
		button.Price.TextColor3 = Color3.fromRGB(255,255,255)
	end
end)
