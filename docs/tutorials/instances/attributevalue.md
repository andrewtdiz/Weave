
We can listen to changes to the attribute with `AttributeValue`

```luau
local count = AttributeValue.new(part, "damaged")

print(damaged:get()) -- false

```

`AttributeValue` can update from:

Calling `:set()` on the `AttributeValue`


```luau
damaged:set(true)

damaged:get() -- true

task.wait() -- Weave update cycle applies next frame

print(damaged:GetAttribute("damaged")) -- true
```

Calling `SetAttribute()` on the `Instance`

```luau
part:SetAttribute("damaged", false)

print(damaged:get()) -- false
```