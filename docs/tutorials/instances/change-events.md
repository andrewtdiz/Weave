`OnChange` is a function that returns keys to use when hydrating or creating an
instance. Those keys let you connect functions to property changed events on the
instance.

```luau
local input = New "TextBox" {
    [OnChange "Text"] = function(newText)
        print("You typed:", newText)
    end
}
```

---

## Usage

To use `OnChange` in your code, you first need to import it from the Fusion
module, so that you can refer to it by name:

```luau linenums="1" hl_lines="2"
local Weave = require(ReplicatedStorage.Weave)
local OnChange = Weave.OnChange
```

When you call `OnChange` with a property name, it will return a special key:

```luau
local key = OnEvent("Activated")
```

When used in a property table, you can pass in a handler and it will be run when
that property changes. The new value of the property is passed in:

```luau
local input = New "TextBox" {
    [OnChange("Text")] = function(newText)
        print("You typed:", newText)
    end
}
```

If you're using quotes `'' ""` for the event name, the extra parentheses `()`
are optional:

```luau
local input = New "TextBox" {
    [OnChange "Text"] = function(newText)
        print("You typed:", newText)
    end
}
```

??? warning "A warning about using OnChange with state objects"

    When passing a state object as a property, changes will only affect the property
    on the next frame:

    ```luau
    local text = Value.new("Hello")

    local message = New "Message" {
        Text = text
    }

    print(message.Text) --> Hello

    text:set("World")
    print(message.Text) --> Hello
    task.wait() -- wait for next frame
    print(message.Text) --> World
    ```

    This means `OnChange` for that property will run your handlers *one frame after*
    the state object is changed. This could introduce off-by-one-frame errors.
    For this case, prefer to use an observer on the state object directly for
    zero latency.

---

## Differences from Roblox API

Normally in the Roblox API, when using `:GetPropertyChangedSignal()` on an
instance, the handler callback will not receive any arguments.

It's worth noting that `OnChange` is not identical in that respect. To make
working with change events easier, `OnChange` will pass the new value of the
property to the handler callback.
