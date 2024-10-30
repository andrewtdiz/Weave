A Weave `PlayerValue` stores a value and updates for a specific player.

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

From the client can read from them with `:get()`.

### Server

```luau
local playerCash = PlayerValue.new("PlayerCash", 0)

Players.PlayerAdded:Connect(function(player: Player)
    playerCash:getFor(player1)   --> 0
    playerCash:setFor(player1, 1)
    playerCash:getFor(player1)   --> 1
end)
```

✨ `PlayerValue` updates to the client _automatically_ ✨

### Client

```luau
local playerCash = PlayerValue.new("PlayerCash")
playerCash:get()     --> 1
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

Players.PlayerAdded:Connect(function(player: Player)
    playerCash:getFor(player1)   --> 0
    playerCash:setFor(player1, 1)
    playerCash:getFor(player1)   --> 1
end)
```

### Client

```luau
local playerCash = require(ReplicatedStorage.PlayerValues.PlayerCash)
playerCash:get()        --> 1
```
