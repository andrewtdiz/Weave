We've seen how Weave can be used to update things ✨ automatically ✨

Now what if we could update values from Server to Client *automatically*?

<figure markdown="span">
  ![Image title](WeaveNetworking.png)
  <figcaption>Weave can update state from the Server to one or many Clients</figcaption>
</figure>

---

## Options

Networking with Weave can be simplified to two questions:

1. Is the value available to _all clients_ or _only one_?

2. Should the value be saved if the player leaves and comes back later?

<figure markdown="span">
  ![Image title](NetworkingTable.png)
  <figcaption>Weave can update state from the Server to one or many Clients</figcaption>
</figure>

## Advanced: Comparison to ReplicaService

### ReplicaService

From the [Basic Usage](https://madstudioroblox.github.io/ReplicaService/tutorial/basic_usage/) page:

Server

```lua
local ReplicaService = require(game.ServerScriptService.ReplicaService)

local test_replica = ReplicaService.NewReplica({
    ClassToken = ReplicaService.NewClassToken("TestReplica"),
    Data = {Value = 0},
    Replication = "All",
})
```

Client

```lua
local ReplicaController = require(game.ReplicatedStorage.ReplicaController)

ReplicaController.ReplicaOfClassCreated("TestReplica", function(replica)
    -- TestReplica Received

    replica:ListenToChange({"Value"}, function(new_value)
        -- TestReplica Changed
    end)
end)

ReplicaController.RequestData()
```

### Weave

The equivalent in Weave is just:

Server

```luau
local NetworkValue = require(ReplicatedStorage.Weave).NetworkValue

local TestValue = NetworkValue.new("TestValue", 0)
```

Client

```luau
local NetworkValue = require(ReplicatedStorage.Weave).NetworkValue

local TestValue = NetworkValue.new("TestValue")

-- TestValue Received

TestValue.Changed:Connect(function(newValue)
    -- TestValue Changed
end)
```
