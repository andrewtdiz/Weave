Import `Weave.ForPairs`, `Weave.ForKeys`, or `Weave.ForValues` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ForValues = Weave.ForValues
local ForKeys = Weave.ForKeys
local ForPairs = Weave.ForPairs
```

Weave has functions for turning Weave `Value` or `Computed` into an `Instance`

```luau
local playerNames = Value.new({ "Kreekcraft", "Sleitnick" })

ForValues(playerNames, function(name)
	return Attach(TextLabel:Clone()) {
		Text = name,
		Parent = screenGui
	}
end)
```

✨ `For` function update state _automatically_ ✨

```luau
playerNames.set({ "Sleitnick" }) -- "Kreekcraft" TextLabel is Destroyed
```

`For` functions turn Weave state into UI.

<figure markdown="span">
  ![Image title](ForPairs.png)
  <figcaption>Source: Pet Simulator 99. <code>ForPairs</code> turns state into UI.</figcaption>
</figure>

---

## Usage

`For` functions take

1. A Weave `Computed` or `Value` _table_.

2. A function that returns an `Instance`

```luau
local playerNames = Value.new({"Elttob", "boatbomber", "thisfall", "AxisAngles"})

ForValues(playerNames, someFunction)
```

Where `someFunction`

- Receives a value from the table

- Returns an `Instance`

```luau
ForValues(playerNames, function(name)
    local textLabel = TextLabel:Clone()

    return Attach(textLabel) {
        Text = playerName,
        Parent = ScreenGui
    }
end)
```

Over the next few pages, we'll take a look at three state objects:

- `ForValues`: values in a table.
- `ForKeys`: keys in a table.
- `ForPairs`: keys and values in a table.
