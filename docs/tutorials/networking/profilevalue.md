Import `Weave.ProfileValue` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ProfileValue = Weave.ProfileValue
```

A Weave `ProfileValue`

- Stores the value for a _specific_ player
- Sync's the value to the player's `ProfileStore`
- Sends the updated value to ALL players

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

<figure markdown="span">
  ![Image title](ProfileValue.png)
  <figcaption><code>ProfileValue</code> updates to a client AND the ProfileStore</figcaption>
</figure>

### ProfileStore

```luau
return {
	Level = 1,
}
```

When the player joins the experience their value is loaded automatically from `ProfileStore` .

✨ `ProfileValue` updates `ProfileStore` _automatically_ ✨

### Server

```luau
local level = ProfileValue.new("Level")

function setLevel(player: Player, level: number)
    playerLevels:getFor(player)   --> 1
    playerLevels:setFor(player, level)
    playerLevels:getFor(player)   --> 2
end)
```

✨ `ProfileValue` updates `ProfileStore` _automatically_ ✨

### ProfileStore

```luau
--Player1 ProfileStore
{
	Level = 2,
}
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

function setLevel(player: Player, level: number)
	PlayerLevels:getFor(player)		--> 1
	PlayerLevels:setFor(player, level)
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
