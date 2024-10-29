A Weave `ProfileValue` is an object which stores a Weave `Value` for each player, replicates all players' values to all clients and synchronizes a specific player's value with the ProfileService.

From the server you can read a player's value with `:getFor(player: Player)`, and write to them with `:setFor(player: Player)`.

On the client you can read from all player's values with `:get()` or the specific player's value with `:get()[player]`.

###  ProfileService
```luau
return {
	Level = 1,
}
```

###  Server
```luau
local playerLevels = ProfileValue.new("PlayerLevels", "Level")
local player = Players:GetPlayers()[1]

print(playerLevels:getFor(player)) 		--> 1
playerLevels:setFor(player, 2)
print(playerLevels:getFor(player)) 		--> 2
```

###  Client
```luau
local playerLevels = ProfileValue.new("PlayerLevels", "Level")
local localPlayer = Players.LocalPlayer

print(playerLevels:get()) 				--> { [localPlayer] = 2 }
print(playerLevels:get()[localPlayer]) 	--> 2
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

print(PlayerLevels:getFor(player))		--> 1
PlayerLevels:setFor(player, 2)
print(PlayerLevels:getFor(player)) 		--> 2
```

### Client
```luau
local PlayerLevels = require(ReplicatedStorage.ProfileValues.PlayerLevels)
local localPlayer = Players.LocalPlayer

print(PlayerLevels:get()) 				--> { [localPlayer] = 2 }
print(PlayerLevels:get()[localPlayer]) 	--> 2
```
