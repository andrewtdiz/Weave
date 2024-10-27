`Value` comes with a `RBXScriptSignal` in the `.Changed` property

```Lua
health.Changed:Connect(function()
	print(`The new health is: {health:get()}`)
end)
```

---

## Usage

For some `Value<T>` `.Changed` is called with `(newValue: T) -> void`

Or you can just use `health:get()`.

```Lua
local health = Value.new(100)

health.Changed:Connect(function(newHealth: number)
	print(`The new health is: {newHealth}`)
end)
```

And don't forget to disconnect

```Lua
local connection = health.Changed:Connect(function()
	print("The new value is: ", health:get())
end)

-- Disconnect the above handler after 5 seconds
task.wait(5)
connection:Disconnect()
```


## What Counts As A Change?

You might notice that not all calls to `Value:set()` will cause your observer to
run:

=== "Script code"

    ```Lua
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

    ```Lua hl_lines="11-12"
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
