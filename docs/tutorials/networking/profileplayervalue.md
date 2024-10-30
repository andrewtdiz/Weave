A Weave `PlayerProfileValue`:

- Stores a value for a _specific_ player
- Sync's the value to `ProfileService`
- Updates the value to ONE player

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

### ProfileService

```luau
return {
	Gems = 0,
}
```

✨ `PlayerProfileValue` updates `ProfileService` _automatically_ ✨

### Server

```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevels:getFor(player)			--> 1
	PlayerLevels:setFor(player, 2)
	PlayerLevels:getFor(player)	 		--> 2
end)
```

✨ `PlayerProfileValue` updates the client _automatically_ ✨

### Client

```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")
local localPlayer = Players.LocalPlayer

playerGems:get() 				--> 100
```

When the player joins the experience their value is loaded automatically from `ProfileService`

## Recommended Usage

Create a `PlayerProfileValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

On the server it returns a `PlayerProfileValue`.

On the client this returns a Weave `Value`.

### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local PlayerProfileValue = Weave.PlayerProfileValue

return PlayerProfileValue.new("PlayerGems", "Gems")
```

### Server

```luau
local PlayerLevels = require(ReplicatedStorage.PlayerProfileValues.PlayerLevels)

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevels:getFor(player)			--> 1
	PlayerLevels:setFor(player, 2)
	PlayerLevels:getFor(player)	 		--> 2
end)
```

### Client

```luau
local PlayerLevels = require(ReplicatedStorage.PlayerProfileValues.PlayerLevels)
PlayerLevels:get()	 				--> 2
```
