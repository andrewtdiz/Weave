`Computed` values can be used to calculate new values.

Pass in a function that does the calculation. 

Then, `:get()` the updated value.

```Lua
local jumpPower = Value.new(7)
local boost = Value.new(3)

local totalJumpPower = Computed.new(function()
    return jumpPower:get() + boost:get()
end)

print(totalHealth:get()) --> 10
```

The `Computed` value updates when _either_ dependency changes.

```Lua
jumpPower:set(8)
boost:set(4)

print(totalJumpPower:get()) --> 12
```

---

## Usage

Import `Weave.Computed` from the Weave module.

```Lua linenums="1" hl_lines="2"
local Weave = require(ReplicatedStorage.Weave)
local Computed = Weave.Computed
```

`Computed.new` to instantiate a new object.

```Lua
local number = Value.new(2)
local double = Computed.new(function()
    return number:get() * 2
end)
```

You can get the computed's current value using `:get()`:

```Lua
print(double:get()) --> 4
```

`Computed` values are recalculated when any of its dependencies change.

Computed function will be re-run and the value will update:

```Lua
number:set(10)
print(double:get()) --> 20
```

```Lua
number:set(-5)
print(double:get()) -->  -10
```

Putting it all together:

```Lua
local number = Value.new(2)
local double = Computed.new(function()
    return number:get() * 2
end)

print(double:get()) --> 4

number:set(10)
print(double:get()) --> 20

number:set(-5)
print(double:get()) -->  -10
```

---

## When To Use This

`Computed` values make it easier to calculate new state from existing state.

Derived values show up a lot in games. 

For example, you might want to insert a death counter into a string.

Therefore, the contents of the string are derived from the death counter:

![Diagram showing how the message depends on the death counter.](Derived-Value-Dark.svg#only-dark)
![Diagram showing how the message depends on the death counter.](Derived-Value-Light.svg#only-light)

While you can do this with values and changed listeners alone, it could get messy.

??? Don't use task.delay() in computed callbacks"

    One small caveat of computeds is that you must return the value immediately.
    
    
    If you need to send a request to the server or perform a long-running
    calculation, you shouldn't use computeds.

    The reason for this is consistency between variables. 

    If a delay is introduced, then inconsistencies and nonsense values could
    quickly appear:

    ```Lua hl_lines="3 17"
    local numCoins = Value.new(50)
    local isEnoughCoins = Computed.new(function()
        task.wait(5) -- Don't do this! This is just for the example
        return numCoins:get() > 25
    end)

    local message = Computed.new(function()
        if isEnoughCoins:get() then
            return `{numCoins:get()} is enough coins.`
        else
            return `{numCoins:get()} is NOT enough coins.`
        end
    end)

    print(message:get()) --> 50 is enough coins.
    numCoins:set(2)
    print(message:get()) --> 2 is enough coins.
    ```

    For this reason, yielding in computed callbacks is disallowed.

    If you have to introduce a delay, for example when invoking a
    RemoteFunction, consider using values and connecting to the Changed event.

    ```Lua hl_lines="3-10 13-14 24-26"
    local numCoins = Value.new(50)

    local isEnoughCoins = Value.new(nil)
    local function updateIsEnoughCoins()
        isEnoughCoins:set(nil) -- indicate that we're calculating the value
        task.wait(5) -- this is now ok
        isEnoughCoins:set(numCoins:get() > 25)
    end
    task.spawn(updateIsEnoughCoins)
    numCoins.Changed:Connect(updateIsEnoughCoins)

    local message = Computed.new(function()
        if isEnoughCoins:get() == nil then
            return "Loading..."
        elseif isEnoughCoins:get() then
            return numCoins:get() .. " is enough coins."
        else
            return numCoins:get() .. " is NOT enough coins."
        end
    end)

    print(message:get()) --> 50 is enough coins.
    numCoins:set(2)
    print(message:get()) --> Loading...
    task.wait(5)
    print(message:get()) --> 2 is NOT enough coins.
    ```
