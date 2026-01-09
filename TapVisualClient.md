--==================================================
-- Tap Visual Client
-- Responsabilidad:
-- - Mostrar +Energy
-- - Efecto de presión
-- - Partículas
-- - Sonido normal / sonido paquete
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local VisualEvent = ReplicatedStorage.RemoteEvents:WaitForChild("TapVisualEvent")

--==============================
-- GUI BASE
--==============================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TapVisualGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

local container = Instance.new("Frame")
container.Size = UDim2.fromScale(1,1)
container.BackgroundTransparency = 1
container.Parent = screenGui

--==============================
-- SONIDOS
--==============================

local function playSound(id, volume)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = volume or 1
	sound.Parent = container
	sound:Play()
	Debris:AddItem(sound, 2)
end

local TAP_SOUND = 1289263994
local PACKAGE_SOUND = 4612378086

--==============================
-- COLORES
--==============================

local COOLDOWN_FLASH_COLOR = Color3.fromRGB(255,255,255)
local PACKAGE_COLOR = Color3.fromRGB(255,200,60)
local NORMAL_COLOR = Color3.fromRGB(240,240,240)

--==============================
-- COOLDOWN FLASH (SUAVE)
--==============================

local function cooldownFlash()
	local flash = Instance.new("Frame")
	flash.Size = UDim2.fromScale(1,1)
	flash.BackgroundColor3 = COOLDOWN_FLASH_COLOR
	flash.BackgroundTransparency = 1
	flash.Active = false
	flash.Parent = container

	TweenService:Create(flash, TweenInfo.new(
		0.15,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
		), {
			BackgroundTransparency = 1
		}):Play()

	Debris:AddItem(flash, 1)
end

--==============================
-- VISUAL TAP
--==============================

local function createTapEffect(mousePos, energy, isPackage)
	local color = isPackage and PACKAGE_COLOR or NORMAL_COLOR

	-- Flash solo tap normal
	if not isPackage then
		cooldownFlash()
	end

	-- ?? EFECTO DE PRESIÓN
	local circle = Instance.new("Frame")
	circle.Size = UDim2.fromOffset(30,30)
	circle.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
	circle.AnchorPoint = Vector2.new(0.5,0.5)
	circle.BackgroundColor3 = color
	circle.BackgroundTransparency = 0.2
	circle.BorderSizePixel = 0
	circle.Parent = container

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1,0)
	corner.Parent = circle

	TweenService:Create(circle, TweenInfo.new(
		isPackage and 1 or 1,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
		), {
			Size = isPackage and UDim2.fromOffset(130,130) or UDim2.fromOffset(90,90),
			BackgroundTransparency = 1
		}):Play()

	Debris:AddItem(circle, 2)

	-- ?? TEXTO +ENERGY
	-- TEXTO +ENERGY
	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromOffset(260,50)
	text.Position = UDim2.fromOffset(mousePos.X, mousePos.Y - 10)
	text.AnchorPoint = Vector2.new(0.5,1)
	text.BackgroundTransparency = 1
	text.Text = "+" .. energy .. " Energy"
	text.Font = Enum.Font.FredokaOne
	text.TextSize = 28
	text.TextColor3 = color
	text.TextTransparency = 0
	text.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(0,0,0)
	stroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	stroke.Thickness = 0.08
	stroke.Transparency = 0
	stroke.Parent = text

	-- FASE 1: subir SIN desaparecer
	TweenService:Create(text, TweenInfo.new(
		1.2,
		Enum.EasingStyle.Quad,
		Enum.EasingDirection.Out
		), {
			Position = text.Position - UDim2.fromOffset(0,70)
		}):Play()

	-- FASE 2: desaparecer DESPUÉS
	task.delay(1, function()
		TweenService:Create(text, TweenInfo.new(
			0.8,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
			), {
				TextTransparency = 1
			}):Play()

		TweenService:Create(stroke, TweenInfo.new(
			0.8,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.Out
			), {
				Transparency = 1
			}):Play()
	end)

	Debris:AddItem(text, 2)


	-- ? PARTÍCULAS
	local particleCount = isPackage and 10 or 5
	for i = 1, particleCount do
		local p = Instance.new("Frame")
		p.Size = UDim2.fromOffset(5,5)
		p.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
		p.AnchorPoint = Vector2.new(0.5,0.5)
		p.BackgroundColor3 = color
		p.BackgroundTransparency = 0
		p.BorderSizePixel = 0
		p.Parent = container

		local pc = Instance.new("UICorner")
		pc.CornerRadius = UDim.new(1,0)
		pc.Parent = p

		local angle = math.random() * math.pi * 2
		local dist = math.random(25,45)

		TweenService:Create(p, TweenInfo.new(
			0.7,
			Enum.EasingStyle.Sine,
			Enum.EasingDirection.Out
			), {
				Position = p.Position + UDim2.fromOffset(
					math.cos(angle)*dist,
					math.sin(angle)*dist
				),
				BackgroundTransparency = 1
			}):Play()

		Debris:AddItem(p, 1)
	end

	-- ?? SONIDO
	if isPackage then
		playSound(PACKAGE_SOUND, 0.9)
	else
		playSound(TAP_SOUND, 0.5)
	end
end

--==============================
-- EVENTO DESDE SERVER
--==============================

VisualEvent.OnClientEvent:Connect(function(totalEnergy, packageEnergy)
	local mousePos = UserInputService:GetMouseLocation()
	local isPackage = packageEnergy and packageEnergy > 0
	createTapEffect(mousePos, totalEnergy, isPackage)
end)
