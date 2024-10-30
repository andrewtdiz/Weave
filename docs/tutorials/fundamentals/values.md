Import `Weave.Value` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Value = Weave.Value
```

A Weave `Value` is an object that stores a Luau value.

```luau
local health = Value.new(100)

health:get() --> 100

health:set(99)
```

---

## Usage

Use `:get()` to read the value

Use `:set()` to change it

```luau
local health = Value.new(100)

health:get() --> 100

health:set(25)

health:get() --> 25
```

`Value` can store any Luau value:

```luau
local name = Value.new("Bob")

local ammoAmount = Value.new(50)

local sprinting = Value.new(false)

local inventory = Value.new({ "apple", "pear" })

local basePlate = Value.new(workspace.Baseplate)
```

---

## `.Changed`

When a `Value` changes, `.Changed` is fired.

```luau
local health = Value.new(100)

health.Changed:Connect(onHealthUpdated)
```

Get the updated value:

```luau
health.Changed:Connect(function(newHealth: number)
	print("The new health is: ", newHealth)
end)
```

`:Disconnect()` when you're done listening to changes

```luau
local connection = health.Changed:Connect(function(newHealth: number)
	print("The new health is: ", newHealth)
end)

-- do some stuff

connection:Disconnect()
```

<!--
## `:Destroy()`

Call `:Destroy()` just like any Roblox `Instance`

```luau
local health = Value.new(100)

health:Destroy()
```

Values that depends on this `Value` will no longer update.

And `.Changed` will no longer fire.

For advanced users: Yes, this will work with `Trove` and `Maid` -->
