A Weave `ProfileValue`:

- Stores the value for a _specific_ player
- Sync's the value to the player's `ProfileService`
- Sends the updated value to ALL players

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

### ProfileService

```luau
return {
	Level = 1,
}
```

When the player joins the experience their value is loaded automatically from `ProfileService` .

✨ `ProfileValue` updates `ProfileService` _automatically_ ✨

### Server

```luau
local playerLevels = ProfileValue.new("Level")

Players.PlayerAdded:Connect(function(player: Player)
    playerLevels:getFor(player1)   --> 1
    playerLevels:setFor(player1, 2)
    playerLevels:getFor(player1)   --> 2
end)
```

✨ `ProfileValue` updates to ALL clients _automatically_ ✨

### Client

```luau
local playerLevels = ProfileValue.new("Level")
local localPlayer = Players.LocalPlayer

playerLevels:get()					--> { [localPlayer] = 2 }
playerLevels:get()[localPlayer] 	--> 2
```

## Recommended Usage

Create a `ProfileValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

On the Server it returns a `ProfileValue`.

On the Client it returns a Weave `Value`.

### ReplicatedStorage

`ReplicatedStorage/Weave/PlayerLevels.luau`

```luau
local Weave = require(ReplicatedStorage.Weave)
local ProfileValue = Weave.ProfileValue

return ProfileValue.new("Level")
```

### Server

```luau
local PlayerLevels = require(ReplicatedStorage.ProfileValues.PlayerLevels)

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevels:getFor(player)		--> 1
	PlayerLevels:setFor(player, 2)
	PlayerLevels:getFor(player)		--> 2
end)
```

### Client

```luau
local PlayerLevels = require(ReplicatedStorage.ProfileValues.PlayerLevels)
local localPlayer = Players.LocalPlayer

PlayerLevels:get()					--> { [localPlayer] = 2 }
PlayerLevels:get()[localPlayer] 	--> 2
```
