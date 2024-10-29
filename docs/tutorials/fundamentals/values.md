A Weave `Value` is an object that stores any Luau value.

```luau
local health = Value.new(100)

health:get() --> 100
```

Use `:get()` to read the value

Use `:set()` to change it

```luau
health:set(25)

health:get() --> 25
```

---

## Usage

Import `Weave.Value` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Value = Weave.Value
```

Use `Value.new` to store any valid Luau variable:

```luau
local name = Value.new("Bob")

local ammoAmount = Value.new(50)

local sprinting = Value.new(false)

local inventory = Value.new({ "apple", "pear" })

local targetPart = Value.new(Instance.new("Part"))
```

---

## `.Changed`

When a `Value` changes, `.Changed` is fired.

```luau
local health = Value.new(100)

health.Changed:Connect(onHealthUpdated)
```

`.Changed` passes the `newValue` as the argument.

```luau
health.Changed:Connect(function(newHealth: number)
	print(`The new health is: {newHealth}`)
end)
```

`.Changed` returns a connection you can `:Disconnect()` from

```luau
local connection = health.Changed:Connect(function()
	print(`The new health is: {health:get()}`)
end)

task.wait(5)

-- Disconnect the above handler after 5 seconds
connection:Disconnect()
```

Note: You can also use `:get()` to get the updated value.

## `:Destroy()`

Call `:Destroy()` just like any Roblox `Instance`

```luau
local health = Value.new(100)

health:Destroy()
```

Values that depends on this `Value` will no longer update.

And `.Changed` will no longer fire.


For advanced users: Yes, this will work with `Trove` and `Maid`
