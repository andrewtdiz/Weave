A Weave `NetworkValue` is an object that stores any Weave `Value` and makes it available to all clients.

You can read from them with `:get()`, and write to them ONLY on the SERVER with `:set()`.

###  Server
```luau
local blueScore = NetworkValue.new("BlueScore", 0)

print(blueScore:get()) --> 0
blueScore:set(1)
print(blueScore:get()) --> 1
```

###  Client
```luau
local blueScore = NetworkValue.new("BlueScore")
print(blueScore:get()) --> 1
```

## Recommended Usage

The recommended way to use `NetworkValue` is to create a module script in ReplicatedStorage that exports a `NetworkValue` object. This way you can require the `NetworkValue` object from any script on the client or server. On the client this would return a Weave `Value` object, on the server it would return a `NetworkValue` object that can update all clients Weave `Value` objects.

### ReplicatedStorage
```luau 
local Weave = require(ReplicatedStorage.Weave)
local NetworkValue = Weave.NetworkValue
return NetworkValue.new("RedScore", 0)
```

### Server
```luau
local RedScore = require(ReplicatedStorage.NetworkValues.RedScore)
print(RedScore:get()) --> 0
RedScore:set(1)
print(RedScore:get()) --> 1
```

### Client
```luau
local RedScore = require(ReplicatedStorage.NetworkValues.RedScore)
print(RedScore:get()) --> 1
```

