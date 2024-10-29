A Weave `PlayerValue` is an object that stores any Weave `Value` for a specific player.

From the server you read them with `:getFor(player: Player)`, and write to them with `:setFor(player: Player)`.

From the client can read from them with `:get()`.

###  Server
```luau
local playerCash = PlayerValue.new("PlayerCash", 0)
local player1 = Players:GetPlayers()[1]
local player2 = Players:GetPlayers()[2]

print(playerCash:getFor(player1)) --> 0
playerCash:setFor(player1, 1)
print(playerCash:getFor(player1)) --> 1

print(playerCash:getFor(player2)) --> 0
```

###  Client
```luau
local playerCash = PlayerValue.new("PlayerCash")
print(playerCash:get()) --> 0
```

## Recommended Usage

The recommended way to use `PlayerValue` is to create a module script in ReplicatedStorage that exports a `PlayerValue` object. This way you can require the `PlayerValue` object from any script on the client or server. On the client this would return a Weave `Value` object, on the server it would return a `PlayerValue` object that can update all clients Weave `Value` objects.

### ReplicatedStorage
```luau 
local Weave = require(ReplicatedStorage.Weave)
local PlayerValue = Weave.PlayerValue
local playerCash = PlayerValue.new("PlayerCash", 0)
```

### Server
```luau
local playerCash = require(ReplicatedStorage.PlayerValues.PlayerCash)
local player1 = Players:GetPlayers()[1]
print(playerCash:getFor(player1)) --> 0
playerCash:setFor(player1, 1)
print(playerCash:getFor(player1)) --> 1
```

### Client
```luau
local playerCash = require(ReplicatedStorage.PlayerValues.PlayerCash)
print(playerCash:get()) --> 1
```

