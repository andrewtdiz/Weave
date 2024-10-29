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

### Client

```luau
local blueScore = NetworkValue.new("BlueScore")
blueScore:get() --> 1

blueScore:set(0) --> ERROR - Cannot set NetworkValue from the Client.
```

## Recommended Usage

Create a `NetworkValue` in `ReplicatedStorage`, so you can access it on `Server` and `Client`.

### ReplicatedStorage

```luau
local Weave = require(ReplicatedStorage.Weave)
local NetworkValue = Weave.NetworkValue

return NetworkValue.new("RedScore", 0)
```

### Server

```luau
local RedScore = require(ReplicatedStorage.NetworkValues.RedScore)

RedScore:set(1)

```

On the Server, this returns a `NetworkValue` object that you can `:set()`.

### Client

```luau
local RedScore = require(ReplicatedStorage.NetworkValues.RedScore)

RedScore:get() --> 1
```

On the Client this returns a Weave `Value` object.
