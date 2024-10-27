A Weave `Value` is an object that stores any Lua value.

```luau
local health = Value.new(100)

print(health:get()) --> 100
health:set(25)
print(health:get()) --> 25
```

Use `:get()` to receive the current value

Use `:set()` to change it

---

## Usage

Import `Weave.Value` from the Weave module.

```luau linenums="1" hl_lines="2"
local Weave = require(ReplicatedStorage.Weave)
local Value = Weave.Value
```

`Value.new` to instantiate a new object.

You can store any valid Lua variable type including:

- `string`
- `number`
- `boolean`
- `table`
- `Instance`

```luau
local name = Value.new("Bob")

local ammoAmount = Value.new(50)

local sprinting = Value.new(false)

local inventory = Value.new({ "apple", "pear" })

local targetPart = Value.new(Instance.new("BasePart"))
```

`Value` comes with a `RBXScriptSignal` in the `.Changed` property

```luau
health.Changed:Connect(function()
	print(`The new health is: {health:get()}`)
end)
```

---

## `.Changed`

When a `Value` changes, `.Changed` is fired with a `newValue` as the argument.

Or you can just use `health:get()`.

```luau
local health = Value.new(100)

health.Changed:Connect(function(newHealth: number)
	print(`The new health is: {newHealth}`)
end)
```

And don't forget to disconnect

```luau
local connection = health.Changed:Connect(function()
	print(`The new health is: {health:get()}`)
end)

-- Disconnect the above handler after 5 seconds
task.wait(5)
connection:Disconnect()
```

## What Counts As A Change?

You might notice that not all calls to `Value:set()` will cause your observer to
run:

=== "Script code"

    ```luau
    local thing = Value.new("Hello")

    thing.Changed:Connect(function()
    	print("=> Thing changed to", thing:get())
    end)

    print("Setting thing once...")
    thing:set("World")
    print("Setting thing twice...")
    thing:set("World")
    print("Setting thing thrice...")
    thing:set("World")
    ```

=== "Output"

    ```
    Setting thing once...
    => Thing changed to World
    Setting thing twice...
    Setting thing thrice...
    ```

When you set the value, if it's the same as the existing value, an update won't
be sent out.

This means Changed events won't re-run when you set the value multiple times in a row.

![A diagram showing how value objects only send updates if the new value and previous value aren't equal.](Value-Equality-Dark.svg#only-dark)
![A diagram showing how value objects only send updates if the new value and previous value aren't equal.](Value-Equality-Light.svg#only-light)

In most cases, this leads to improved performance because your code runs less
often.

To override this behaviour, `Value:set()` accepts a second argument that can force an update:

=== "Script code"

    ```luau hl_lines="11-12"
    local thing = Value.new("Hello")

    thing.Changed:Connect(function()
    	print("=> Thing changed to", thing:get())
    end)

    print("Setting thing once...")
    thing:set("World")
    print("Setting thing twice...")
    thing:set("World")
    print("Setting thing thrice (update forced)...")
    thing:set("World", true)
    ```

=== "Output"

    ``` hl_lines="4-5"
    Setting thing once...
    => Thing changed to World
    Setting thing twice...
    Setting thing thrice (update forced)...
    => Thing changed to World
    ```

---

## Attribute Values

```luau
local part = Instance.new("Part")

part:SetAttribute("damaged", false)

local count = AttributeValue.new(part, "damaged")

print(damaged:get()) -- false

damaged:set(true)

print(damaged:get()) -- 1
task.wait() -- Weave update cycle applies next frame
print(damaged:GetAttribute("damaged")) -- 1
```
