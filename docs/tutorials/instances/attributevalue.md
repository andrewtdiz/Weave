
We can listen to changes to the attribute with `AttributeValue`

```luau
local hitCount = AttributeValue.new(part, "HitCount")

print(hitCount:get()) -- false

```

`AttributeValue` can update from:

Calling `:set()` on the `AttributeValue`


```luau
hitCount:set(0)

hitCount:get() -- 0

task.wait() -- Weave update cycle applies next frame

print(damaged:GetAttribute("HitCount")) -- 0
```

Calling `SetAttribute()` on the `Instance`

```luau
part:SetAttribute("HitCount", 1)

print(hitCount:get()) -- 1
```