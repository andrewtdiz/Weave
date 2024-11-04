Import `Weave.ForPairs` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ForPairs = Weave.ForPairs
```

`ForPairs` transforms each key _and values_ from a table into an `Instance`

```luau
local itemColors = Value.new({ shoes = Color3.new(0, 0, 0), socks = Color3.new(1, 1, 1) })

ForPairs(itemColors, function(thing, color)
	return thing, Attach(TextLabel:Clone()) {
		Text = thing,
		BackgroundColor3 = color,
		Parent = screenGui
	}
end)

owner:set({ shirt = Color3.new(1, 0, 0) })
```

---

## Usage

`ForPairs` functions takes

1. A Weave `Computed` or `Value` _table_.

2. A function that returns an `Instance`

```luau
local itemColors = Value.new({ shoes = Color3.new(0, 0, 0), socks = Color3.new(1, 1, 1) })

ForPairs(itemColors, makeItemFrame)
```

Where `someFunction`:

- Receives a value from the table

- Returns an `any, Instance`

The `any` is a unique identifier for the `Instance` (usually the key)

```luau
ForPairs(playerNames, function(thing, name)
    local textLabel = TextLabel:Clone()

    return thing, Attach(textLabel) {
        Text = playerName,
        Parent = ScreenGui
    }
end)
```

---

## Advanced: Optimizations

!!! help "Optional"
You don't have to memorise these optimisations to use `ForPairs`, but it
can be helpful if you have a performance problem.

Rather than creating a new output table from scratch every time the input table
is changed, `ForPairs` will try and reuse as much as possible to improve
performance.

Since `ForPairs` has to depend on both keys and values, changing any value in
the input table will cause a recalculation for that key-value pair.

![A diagram showing values of keys changing in a table.](Optimisation-KeyValueChange-Dark.svg#only-dark)
![A diagram showing values of keys changing in a table.](Optimisation-KeyValueChange-Light.svg#only-light)

Inversely, `ForPairs` won't recalculate any key-value pairs that stay the same.
Instead, these will be preserved in the output table.

![A diagram showing values of keys staying the same in a table.](Optimisation-KeyValuePreserve-Dark.svg#only-dark)
![A diagram showing values of keys staying the same in a table.](Optimisation-KeyValuePreserve-Light.svg#only-light)

If you don't need the keys or the values, Fusion can offer better optimisations.
For example, if you're working with an array of values where position doesn't
matter, [ForValues can move values between keys.](./forvalues.md#optimisations)

Alternatively, if you're working with a set of objects stored in keys, and don't
need the values in the table,
[ForPairs will ignore the values for optimal performance.](./ForPairs.md#optimisations)
