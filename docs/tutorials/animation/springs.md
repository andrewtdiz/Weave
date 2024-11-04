Import `Weave.Tween` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Spring = Weave.Spring
```

`Spring` values Spring any Weave `Value` or `Computed`

```luau
local value = Value.new(0)
local speed = 25
local damping = 0.5

local springValue = Spring(target, speed, damping)
```

✨ `Spring` values update _automatically_ ✨

```luau
value:set(5)

task.wait(0.5)

springValue:get() -- 1.86
```

Springs use a physical spring simulation.

<figure markdown="span">
  ![Image title](Step-Basic-Dark.png)
  <figcaption>A Spring animation curve.</figcaption>
</figure>

---

## Usage

Call the `Spring` function with a Weave value to move towards:

```luau
local goal = Value.new(0)
local animated = Spring(target)
```

`:get()` its value at any time.

```luau
print(animated:get()) --> 0.26425...
```

Provide `speed` and `damping` values to define how the spring moves.

```luau
local target = Value.new(0)
local speed = 25
local damping = 0.5

local springValue = Spring(target, speed, damping)
```

`Spring` can transition any number-based Luau type:

```luau
local partPosition = Value.new(Vector3.new())

local mousePosition = Value.new(Vector2.new())

local partColor = Value.new(Color3.new(0, 0, 0))

local framePosition = Value.new(UDim2.new(0.5, 0, 0, 0))

local modelPosition = Value.new(CFrame.new())

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad)

local speed = 25
local damping = 0.5

local partTween  = Spring(partPosition, speed, damping)
local mouseTween = Spring(mousePosition, speed, damping)
local colorTween  = Spring(partPosition, speed, damping)
local frameTween = Spring(framePosition, speed, damping)
local modelTween = Spring(modelPosition, speed, damping)
```

---

### Speed

The `speed` defines how fast the spring to moves.

Doubling the `speed` makes it move twice as fast.

![Animation and graph showing speed changes.](Speed-Dark.png#only-dark)
![Animation and graph showing speed changes.](Speed-Light.png#only-light)


### Damping

The `damping` defines the friction of the spring.

This defines how quickly or smoothly it reaches a stop.

![Animation and graph showing zero damping.](Damping-Zero-Dark.png#only-dark)
![Animation and graph showing zero damping.](Damping-Zero-Light.png#only-light)


---

## Advanced: Spring Mechanics

### Zero damping

Zero Damping means no friction, so the spring moves up and down forever.

![Animation and graph showing zero damping.](Damping-Zero-Dark.png#only-dark)
![Animation and graph showing zero damping.](Damping-Zero-Light.png#only-light)

### Underdamping

Underdamping applies some friction, so the spring slows down and eventually stops.

![Animation and graph showing underdamping.](Damping-Under-Dark.png#only-dark)
![Animation and graph showing underdamping.](Damping-Under-Light.png#only-light)

### Critical damping

Critical Damping is just the right amount of friction to stop quickly without extra movement.

![Animation and graph showing critical damping.](Damping-Critical-Dark.png#only-dark)
![Animation and graph showing critical damping.](Damping-Critical-Light.png#only-light)

### Overdamping

Overdamping adds lots of friction, making the spring move slowly, like it’s in honey.

![Animation and graph showing overdamping.](Damping-Over-Dark.png#only-dark)
![Animation and graph showing overdamping.](Damping-Over-Light.png#only-light)

### Interruption

Springs do not share the same interruption problems as tweens. When the goal
changes, springs are guaranteed to preserve both position and velocity, reducing
jank:

![Animation and graph showing a spring getting interrupted.](Interrupted-Dark.png#only-dark)
![Animation and graph showing a spring getting interrupted.](Interrupted-Light.png#only-light)

This also means springs are suitable for following rapidly changing values:

![Animation and graph showing a spring following a moving target.](Following-Dark.png#only-dark)
![Animation and graph showing a spring following a moving target.](Following-Light.png#only-light)
