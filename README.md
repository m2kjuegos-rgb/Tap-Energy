# Tap-Energy

## 📂 Explorer Structure (Roblox Studio)
ReplicatedStorage
├─ Modules
│ ├─ EnergyCalculator.lua
│ ├─ MultiplierConfig.lua
│ ├─ PackageChanceCalculator.lua
├─ RemoteEvents
│ ├─ BuyMultiplierEvent
│ ├─ BuyUpgradeEvent
│ ├─ EnergyStatUpdateEvent
│ ├─ TapEnergyEvent
│ ├─ TapVisualEvent
│ ├─ UpdateUpgradeUI
│
ServerScriptService
├─ Core
│ ├─ PlayerStats.server.lua
├─ Systems
│ ├─ MultiplierSystem.server.lua
│ ├─ TapEnergy.server.lua
│ ├─ UpgradesSystem.server.lua
│ ├─ UpgradesServer
│
StarterGui
├─ UI
│ ├─ MultiplierClient (ScreenGui)
│ │ ├─ MultiplierClient.client.lua
│
StarterPlayer
├─ StarterPlayerScripts
│ ├─ Systems
│ │ ├─ Tap
│ │ │ ├─ TapClient.client.lua
│ │ │ ├─ TapVisualClient.client.lua
│ │ ├─ ApplyJumpPower.client.lua
│ │ ├─ ApplyWalkSpeed.client.lua
│ │ ├─ UpdatesClient.client.lua
│ │ ├─ UpdatesClientProba.client.lua
│ │ ├─ UpdatesJumpPower.client.lua
│ │ ├─ UpdatesWalkSpeed.client.lua
