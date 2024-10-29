A Weave `ProfileValue`:
- Stores the value for a *specific* player
- Updates the player's value in `ProfileService`
- Broadcasts updates to a ALL players

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

### ProfileService

```luau
return {
	Level = 1,
}
```

### Server

```luau
local playerLevels = ProfileValue.new("PlayerLevels", "Level")
local player = Players:GetPlayers()[1]

playerLevels:getFor(player) 		--> 1
playerLevels:setFor(player, 2)
playerLevels:getFor(player) 		--> 2
```

### Client

```luau
local playerLevels = ProfileValue.new("PlayerLevels", "Level")
local localPlayer = Players.LocalPlayer

playerLevels:get()					--> { [localPlayer] = 2 }
playerLevels:get()[localPlayer] 	--> 2
```

When the player leaves the experience their value is automatically cleared from the `ProfileValue` object.

When the player joins the experience their value is automatically loaded from the ProfileService into the `ProfileValue` object.

## Recommended Usage

The recommended way to use `ProfileValue` is to create a module script in ReplicatedStorage that exports a `ProfileValue` object. This way you can require the `ProfileValue` object from any script on the client or server. On the client this would return a Weave `Value` object, on the server it would return a `ProfileValue` object that can update all clients Weave `Value` objects.

### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local ProfileValue = Weave.ProfileValue
return ProfileValue.new("PlayerLevels", "Level")
```

### Server

```luau
local PlayerLevels = require(ReplicatedStorage.ProfileValues.PlayerLevels)
local player = Players:GetPlayers()[1]

PlayerLevels:getFor(player)		--> 1
PlayerLevels:setFor(player, 2)
PlayerLevels:getFor(player)		--> 2
```

### Client

```luau
local PlayerLevels = require(ReplicatedStorage.ProfileValues.PlayerLevels)
local localPlayer = Players.LocalPlayer

PlayerLevels:get()					--> { [localPlayer] = 2 }
PlayerLevels:get()[localPlayer] 	--> 2
```
