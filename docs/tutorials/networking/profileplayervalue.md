A Weave `PlayerProfileValue`:

- Stores the value for a _specific_ player
- Updates the player's value in `ProfileService`
- Broadcasts updates to one player

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

### ProfileService

```luau
return {
	Gems = 0,
}
```

### Server

```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevels:getFor(player)			--> 1
	PlayerLevels:setFor(player, 2)
	PlayerLevels:getFor(player)	 		--> 2
end)
```

### Client

```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")
local localPlayer = Players.LocalPlayer

playerGems:get() 				--> 100
```

When the player leaves the experience their value is automatically cleared from the `PlayerProfileValue` object.

When the player joins the experience their value is automatically loaded from the ProfileService into the `PlayerProfileValue` object.

## Recommended Usage

The recommended way to use `PlayerProfileValue` is to create a module script in ReplicatedStorage that exports a `PlayerProfileValue` object. This way you can require the `PlayerProfileValue` object from any script on the client or server. On the client this would return a Weave `Value` object, on the server it would return a `PlayerProfileValue` object that can update all clients Weave `Value` objects.

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
