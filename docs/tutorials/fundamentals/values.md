A Weave `Value` is an object that stores any Lua value.

```Lua
local health = Value.new(100)

print(health:get()) --> 100
health:set(25)
print(health:get()) --> 25
```

Use `:get()` to receive the current value

Use `:set()` to change it

---

## Usage

Import `Weave.Value` from the Weave module.

```Lua linenums="1" hl_lines="2"
local Weave = require(ReplicatedStorage.Weave)
local Value = Weave.Value
```

`Value.new` to instantiate a new object.

You can store any valid Lua variable type including:
- `string`
- `number`
- `boolean`
- `table`
- `Instance`

```Lua
local name = Value.new("Bob")

local ammoAmount = Value.new(50)

local sprinting = Value.new(false)

local inventory = Value.new({ "apple", "pear" })

local targetPart = Value.new(Instance.new("BasePart"))
```

---

## Attribute Values

```Lua
local part = Instance.new("Part")

part:SetAttribute("damaged", false)

local count = AttributeValue.new(part, "damaged")

print(damaged:get()) -- false

damaged:set(true)

print(damaged:get()) -- 1
task.wait() -- Weave update cycle applies next frame
print(damaged:GetAttribute("damaged")) -- 1
```
