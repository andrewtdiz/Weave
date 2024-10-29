![Diagram showing how the message depends on the death counter.](Derived-Value-Dark.svg#only-dark)
![Diagram showing how the message depends on the death counter.](Derived-Value-Light.svg#only-light)

`Computed` values can be used to calculate new values.

Pass in a function that does the calculation.

```luau
local userName = Value.new("Preston")

local welcomeMessage = Computed.new(function()
    return `Welcome, {userName:get()}!`
end)

welcomeMessage:get() --> "Welcome, Preston!"
```

`Computed` values update automatically:

```luau
userName:set("Jandel")

welcomeMessage:get() --> "Welcome, Jandel!"
```

---

## Usage

Import `Weave.Computed` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Computed = Weave.Computed
```

`Computed.new` to make a new object.

```luau
local greeting = Value.new("Welcome")
local userName = Value.new("Preston")

local combinedMessage = Computed.new(function()
    return `{greeting:get()}, {userName:get()}!`
end)
```

You can get the computed's current value using `:get()`:

```luau
combinedMessage:get() --> "Welcome, Preston!"
```

The `Computed` function runs again when any of its dependencies change

```luau
greeting:set("Hello")

combinedMessage:get() --> "Hello, Preston!"
```

```luau
userName:set("Jandel")

combinedMessage:get() --> "Hello, Jandel!"
```

Putting it all together:

```luau
local greeting = Value.new("Welcome")
local userName = Value.new("Preston")

local combinedMessage = Computed.new(function()
    return `{greeting}, {userName}!`
end)

combinedMessage:get() --> "Welcome, Preston!"

greeting:set("Hello")
combinedMessage:get() --> "Hello, Preston!"

userName:set("Jandel")
combinedMessage:get() --> "Hello, Jandel!"
```

## `.Changed`

Just like `Value`, when `Computed` changes `.Changed` is fired.

```luau
local double = Computed.new(function()
    return number:get() * 2
end)

double.Changed:Connect(onDoubleChanged)
```

Note: You can also use `:get()` to get the updated value.

## `:Destroy()`

Call `:Destroy()` just like any Roblox `Instance`

```luau
local double = Computed.new(function()
    return number:get() * 2
end)

double:Destroy()
```

Values that depends on this `Computed` will no longer update.

---

## When To Use This

`Computed` values make it easier to calculate new state from existing state.

Derived values show up a lot in games.

For example, you might want to insert a number into a string to display in the UI.

??? warning "A warning about delays in computed callbacks"

    One small caveat of computeds is that you must return the value immediately.
    If you need to send a request to the server or perform a long-running
    calculation, you shouldn't use computeds.

    The reason for this is consistency between variables. When all computeds run

    immediately (i.e. without yielding), all of your variables will behave
    consistently:

    ```Lua
    local numCoins = Value.new(50)
    local isEnoughCoins = Computed.new(function()
        return numCoins:get() > 25
    end)

    local message = Computed.new(function()
        if isEnoughCoins:get() then
            return numCoins:get() .. " is enough coins."
        else
            return numCoins:get() .. " is NOT enough coins."
        end
    end)

    message:get() --> 50 is enough coins.
    numCoins:set(2)
    message:get() --> 2 is NOT enough coins.
    ```

    If a delay is introduced, then inconsistencies and nonsense values could
    quickly appear:

    ```luau
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

    ```luau hl_lines="3-10 13-14 24-26"
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