Import `Weave.ForKeys` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ForKeys = Weave.ForKeys
```

`ForKeys` transforms each key from a table into an `Instance`

```luau
local data = Value.new({Red = "foo", Blue = "bar"})
local screenGui = PlayerGui.ScreenGui

ForKeys(names, function(name)
	return Attach(TextLabel:Clone()) {
		Text = name,
		Parent = screenGui
	}
end)
```

---

## Usage

`ForKeys` functions takes

1. A Weave `Computed` or `Value` *table*.

2. A function that returns an `Instance`

```luau
local playerNames = Value.new({Red = "foo", Blue = "bar"})

ForKeys(playerNames, someFunction)
```

Where `someFunction`:

- Receives a value from the table

- Returns an `Instance`

```luau
ForKeys(playerNames, function(name)
    local textLabel = TextLabel:Clone()

    return Attach(textLabel) {
        Text = playerName,
        Parent = ScreenGui
    }
end)
```

---

## Advanced: Optimisations

!!! help "Optional"
You don't have to memorise these optimisations to use `ForKeys`, but it
can be helpful if you have a performance problem.

`ForKeys` will try and reuse as much as possible to improve performance.

Rather than creating a new output table from scratch every time the input table
is changed.

For example, let's say we're converting an array to a dictionary:

```luau
local array = Value.new({ Nevermore = true, Knit = false, Matter = false})
ForKeys(array, function(index)
	return "Framework: " .. index
end)

print(dict:get()) --> { "Framework: Nevermore", "Framework: Knit", "Framework: Matter"}
```

Keys are only added or removed as needed:

```luau
local array = Value.new({ Nevermore = true, Knit = false, Matter = false})
ForKeys(array, function(index)
	return "Framework: " .. index
end)

print(dict:get()) --> { "Framework: Nevermore", "Framework: Knit", "Framework: Matter"}

array:set({ Roact = true })
print(dict:get()) --> { "Framework: Roact" }
```

`ForKeys` takes advantage of this - when a value changes, it's copied into the
output table without recalculating the key. Keys are only calculated when a
value is assigned to a new key.
