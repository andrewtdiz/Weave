Import `Weave.ProfilePlayerValue` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ProfilePlayerValue = Weave.ProfilePlayerValue
```

A Weave `ProfilePlayerValue`:

- Stores a value for a _specific_ player
- Sync's the value to `ProfileStore`
- Updates the value to ONE player

`:getFor(player)` and `:setFor(player, newValue)` from the Server.

ONLY `:get()` on the Client.

<figure markdown="span">
  ![Image title](ProfilePlayerValue.png)
  <figcaption><code>ProfilePlayerValue</code> updates to all clients AND the ProfileStore</figcaption>
</figure>


### ProfileStore

```luau
return {
	Gems = 0,
}
```

✨ `ProfilePlayerValue` updates `ProfileStore` _automatically_ ✨

### Server

```luau
local playerGems = ProfilePlayerValue.new("Gems")

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevels:getFor(player)			--> 1
	PlayerLevels:setFor(player, 2)
	PlayerLevels:getFor(player)	 		--> 2
end)
```

✨ `ProfilePlayerValue` updates the client _automatically_ ✨

### Client

```luau
local playerGems = ProfilePlayerValue.new("Gems")
local localPlayer = Players.LocalPlayer

playerGems:get() 				--> 100
```

When the player joins the experience their value is loaded automatically from `ProfileStore`

## Recommended Usage

Create a `ProfilePlayerValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

On the server it returns a `ProfilePlayerValue`.

On the client this returns a Weave `Value`.

### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local ProfilePlayerValue = Weave.ProfilePlayerValue

return ProfilePlayerValue.new("Gems")
```

### Server

```luau
local PlayerLevel = require(ReplicatedStorage.ProfilePlayerValues.PlayerLevel)

Players.PlayerAdded:Connect(function(player: Player)
	PlayerLevel:getFor(player)			--> 1
	PlayerLevel:setFor(player, 2)
	PlayerLevel:getFor(player)	 		--> 2
end)
```

### Client

```luau
local playerLevel = require(ReplicatedStorage.ProfilePlayerValues.PlayerLevels)

Attach(ScreenGui.LevelDisplay.TextLabel) {
    Text = playerLevel
}

redScore.Changed:Connect(function()
    print("PlayerLevel updated by the server: " .. playerLevel)
end)
```
