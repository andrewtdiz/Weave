Import `Weave.PlayerValue` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local PlayerValue = Weave.PlayerValue
```

A Weave `PlayerValue` stores a value and updates for a specific player.

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

From the client can read from them with `:get()`.

<figure markdown="span">
  ![Image title](PlayerValue.png)
  <figcaption><code>PlayerValue</code> updates to a client</figcaption>
</figure>

### Server

```luau
local playerCash = PlayerValue.new("PlayerCash", 0)

function updateCash(player: Player, cash: number)
    playerCash:getFor(player)   --> 0
    playerCash:setFor(player, cash)
    playerCash:getFor(player)   --> 1
end)
```

✨ `PlayerValue` updates to the client _automatically_ ✨

### Client

```luau
local playerCash = PlayerValue.new("PlayerCash")
playerCash:get()     --> 1
```

## Recommended Usage

Create a `PlayerValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local PlayerValue = Weave.PlayerValue

return PlayerValue.new("PlayerCash", 0)
```

### Server

On the Server, we can `:get()` and `:set()` the `PlayerValue`.

```luau
local playerCash = require(ReplicatedStorage.PlayerValues.PlayerCash)

function updateCash(player: Player, cash: number)
    playerCash:getFor(player)   --> 0
    playerCash:setFor(player, cash)
    playerCash:getFor(player)   --> 1
end)
```

### Client

On the Client, `PlayerValue` is just a Weave `Value`.

When `:set()` on the server, the `Value` is updated on the client.

We can use it like any other `Value`:

```luau
local playerCash = require(ReplicatedStorage.PlayerValues.PlayerCash)

Attach(ScreenGui.CashDisplay.TextLabel) {
    Text = playerCash
}

playerCash.Changed:Connect(function()
    print("PlayerCash updated by the server: " .. playerCash)
end)
```
