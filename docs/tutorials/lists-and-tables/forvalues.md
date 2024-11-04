Import `Weave.ForValues` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local ForValues = Weave.ForValues
```

`ForValues` transforms each values from a table into an `Instance`

```luau
local screenGui = PlayerGui.ScreenGui

local playerNames = Value.new({ "Kreekcraft", "Sleitnick" })

ForValues(playerNames, function(name)
	return Attach(TextLabel:Clone()) {
		Text = name,
		Parent = screenGui
	}
end)
```

---

## Usage

`ForValues` functions takes

1. A Weave `Computed` or `Value` *table*.

2. A function that returns an `Instance`

```luau
local playerNames = Value.new({"Elttob", "boatbomber", "thisfall", "AxisAngles"})

local textLabels = ForValues(playerNames, someFunction)
```

Where `someFunction`:

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

By default, the `Instance` is *destroyed*, if a `name` is removed from the table.

---

## Advanced Part 2: Optimisations

!!! help "Optional"
You don't have to memorise these optimisations to use `ForValues`, but it
can be helpful if you have a performance problem.

Rather than creating a new output table from scratch every time the input table
is changed, `ForValues` will try and reuse as much as possible to improve
performance.

For example, let's say we're measuring the lengths of an array of words:

```luau
local words = Value.new({"Orange", "Red", "Magenta"})
ForValues(words, function(word)
	return #word
end)

print(lengths:get()) --> {6, 3, 7}
```

The word lengths don't depend on the position of the word in the array. This
means that rearranging the words in the input array will just rearrange the
lengths in the output array:

![A diagram visualising how the values move around.](Optimisation-Reordering-Dark.svg#only-dark)
![A diagram visualising how the values move around.](Optimisation-Reordering-Light.svg#only-light)

`ForValues` takes advantage of this - when input values move around, the output
values will move around too, instead of being recalculated.

Note that values are only reused once. For example, if you added another
occurence of 'Orange', your calculation would have to run again for the second
'Orange':

![A diagram visualising how values aren't reused when duplicates appear.](Optimisation-Duplicates-Dark.svg#only-dark)
![A diagram visualising how values aren't reused when duplicates appear.](Optimisation-Duplicates-Light.svg#only-light)
