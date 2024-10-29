A Weave `PlayerProfileValue` is an object which stores a Weave `PlayerValue` and synchronizes the player's value with the ProfileService.

From the server you read them with `:getFor(player: Player)`, and write to them with `:setFor(player: Player)`.

From the client can read from them with `:get()`.

###  ProfileService
```luau
return {
	Gems = 0,
}
```

###  Server
```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")
local player = Players:GetPlayers()[1]

print(playerGems:getFor(player)) 		--> 0
playerGems:setFor(player, 100)
print(playerGems:getFor(player)) 		--> 100
```

###  Client
```luau
local playerGems = PlayerProfileValue.new("PlayerGems", "Gems")
local localPlayer = Players.LocalPlayer

print(playerGems:get()) 				--> 100
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
local player = Players:GetPlayers()[1]

print(PlayerLevels:getFor(player))		--> 1
PlayerLevels:setFor(player, 2)
print(PlayerLevels:getFor(player)) 		--> 2
```

### Client
```luau
local PlayerLevels = require(ReplicatedStorage.PlayerProfileValues.PlayerLevels)
print(PlayerLevels:get()) 				--> 2
```
