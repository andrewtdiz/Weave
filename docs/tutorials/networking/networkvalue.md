A Weave `NetworkValue` stores a value and updates to ALL clients.

`:get()` and `:set()` its value from the Server.

ONLY `:get()` on the Client.

### Server

```luau
local blueScore = NetworkValue.new("BlueScore", 0)

blueScore:get() --> 0
blueScore:set(1)
blueScore:get() --> 1
```

✨ `NetworkValue` updates to ALL clients _automatically_ ✨

### Client

```luau
local blueScore = NetworkValue.new("BlueScore")
blueScore:get() --> 1

blueScore:set(0) --> ERROR - Cannot set NetworkValue from the Client.
```

## Recommended Usage

Create a `NetworkValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

#### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local NetworkValue = Weave.NetworkValue

return NetworkValue.new("RedScore", 0)
```

#### Server

On the Server, we can `:get()` and `:set()` the `NetworkValue`.

```luau
local redScore = require(ReplicatedStorage.NetworkValues.RedScore)

redScore:set(1)

redScore:get() -- 1
```

#### Client

On the Client, `NetworkValue` is just a Weave `Value`.

When `:set()` on the server, the `Value` is updated on the client.

We can use it like any other `Value`:

```luau
local redScore = require(ReplicatedStorage.NetworkValues.RedScore)

Attach(ScreenGui.ScoreDisplay.TextLabel) {
    Text = redScore
}

redScore.Changed:Connect(function()
    print("RedScore updated by the server: " .. redScore)
end)
```
