Import `Weave.Tween` from the Weave module.

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Tween = Weave.Tween
```

`Tween` values Tween any Weave `Value` or `Computed`

```luau
local value = Value.new(0)
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)

local tweenValue = Tween(value, tweenInfo)
```

✨ `Tween` values update _automatically_ ✨

```luau
value:set(5)

task.wait(0.5) -- wait half the duration

tweenValue:get() -- 2.5
```

Tweens follow the value of Weave state using an animation curve.

<figure markdown="span">
  ![Image title](Step-Basic-Dark.png)
  <figcaption>A Tween animation curve.</figcaption>
</figure>
---

## Usage

Call the `Tween` function with a Weave Value and a `TweenInfo`

```luau
local value = Value.new(0)
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)

local animated = Tween(value, tweenInfo)
```

You can `:get()` its value at any time.

```luau
print(animated:get()) --> 0.26425...
```

`TweenInfo` can _also_ be a Weave `Value` or `Computed`

```luau
local goal = Value.new(0)
local tweenInfo = Value.new(TweenInfo.new(0.5, Enum.EasingStyle.Quad))

local animated = Tween(target, tweenInfo)
```

`Tween` can transition any number-based Luau type:

```luau
local partPosition = Value.new(Vector3.new())

local mousePosition = Value.new(Vector2.new())

local partColor = Value.new(Color3.new(0, 0, 0))

local framePosition = Value.new(UDim2.new(0.5, 0, 0, 0))

local modelPosition = Value.new(CFrame.new())

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad)

local partTween  = Tween(partPosition, tweenInfo)
local mouseTween = Tween(mousePosition, tweenInfo)
local colorTween  = Tween(partPosition, tweenInfo)
local frameTween = Tween(framePosition, tweenInfo)
local modelTween = Tween(modelPosition, tweenInfo)
```

---

## TweenInfo

### Time

The first parameter of `TweenInfo` is time in seconds.

This specifies how long it will take to animate.

![Animation and graph showing varying TweenInfo time.](Time-Dark.png#only-dark)
![Animation and graph showing varying TweenInfo time.](Time-Light.png#only-light)

### EasingStyle

The second parameter of `TweenInfo` is easing style.

`Enum.EasingStyle` defines the animation curve.

![Animation and graph showing some easing styles.](Easing-Style-Dark.png#only-dark)
![Animation and graph showing some easing styles.](Easing-Style-Light.png#only-light)

### Easing Direction

The third parameter of `TweenInfo` is `EasingDirection`.

This can be set to:

- `Enum.EasingDirection.Out` animates out smoothly.
- `Enum.EasingDirection.In` animates in smoothly.
- `Enum.EasingDirection.InOut` animates in _and_ out smoothly.

![Animation and graph showing some easing directions.](Easing-Direction-Dark.png#only-dark)
![Animation and graph showing some easing directions.](Easing-Direction-Light.png#only-light)

### Repeats

The fourth parameter of `TweenInfo` is repeat count. 

This can loop the animation a number of times.

Setting the repeat count to a `-1` causes it to loop infinitely.

![Animation and graph showing various repeat counts.](Repeats-Dark.png#only-dark)
![Animation and graph showing various repeat counts.](Repeats-Light.png#only-light)

### Reversing

The fifth parameter of `TweenInfo` is a reversing option. 

When enabled, the animation will return to the starting point.

![Animation and graph toggling reversing on and off.](Reversing-Dark.png#only-dark)
![Animation and graph toggling reversing on and off.](Reversing-Light.png#only-light)

### Delay

The sixth and final parameter of `TweenInfo` is delay. 

Increasing this delay adds time before the beginning of the animation curve.

![Animation and graph showing varying delay values.](Delay-Dark.png#only-dark)
![Animation and graph showing varying delay values.](Delay-Light.png#only-light)

---

## Advanced: Interruption

You should avoid interrupting Tweens before they're finished.

Interrupting a tween halfway through leads to abrupt changes in velocity.

![Animation and graph showing a tween getting interrupted.](Interrupted-Dark.png#only-dark)
![Animation and graph showing a tween getting interrupted.](Interrupted-Light.png#only-light)

Tweens also can't track constantly changing targets very well. 

![Animation and graph showing a tween failing to follow a moving target.](Follow-Failure-Dark.png#only-dark)
![Animation and graph showing a tween failing to follow a moving target.](Follow-Failure-Light.png#only-light)

These issues arise because tweens don't 'remember' their previous velocity.

To retain velocity, consider using springs, since they can preserve momentum.
