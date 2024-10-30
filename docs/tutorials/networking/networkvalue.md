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

On the Server, this returns a `NetworkValue` object that you can `:set()`.

```luau
local redScore = require(ReplicatedStorage.NetworkValues.RedScore)

redScore:set(1)

```

#### Client

On the Client this returns a Weave `Value` object.

The `NetworkValue` updates _automatically_ on each client.

```luau
local redScore = require(ReplicatedStorage.NetworkValues.RedScore)


Attach(ScreenGui.RedScore.Text) {
    Text = redScore
}
```
