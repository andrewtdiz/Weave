`OnEvent` is a function that returns keys to use when hydrating or creating an
instance. Those keys let you connect functions to events on the instance.

```luau
local button = New "TextButton" {
    [OnEvent "Activated"] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}
```

---

## Usage

To use `OnEvent` in your code, you first need to import it from the Fusion
module, so that you can refer to it by name:

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local OnEvent = Weave.OnEvent
```

When you call `OnEvent` with an event name, it will return a special key:

```luau
local key = OnEvent("Activated")
```

When that key is used in a property table, you can pass in a handler and it will
be connected to the event for you:

```luau
local button = New "TextButton" {
    [OnEvent("Activated")] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}
```

If you're using quotes `'' ""` for the event name, the extra parentheses `()`
are optional:

```luau
local button = New "TextButton" {
    [OnEvent "Activated"] = function(_, numClicks)
        print("The button was pressed", numClicks, "time(s)!")
    end
}
```
