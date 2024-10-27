<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">Animation</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-checklist-24:</span>
	<span class="weavedoc-api-name">Animatable</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">type</span>
		<span class="weavedoc-api-pill-since">since v0.1</span>
	</span>
</h1>

Represents types that can be animated component-wise. If a data type can
reasonably be represented as a fixed-length array of numbers, then it is
animatable.

Any data type present in this type can be animated by Weave.

```luau
number | CFrame | Color3 | ColorSequenceKeypoint | DateTime | NumberRange |
NumberSequenceKeypoint | PhysicalProperties | Ray | Rect | Region3 |
Region3int16 | UDim | UDim2 | Vector2 | Vector2int16 | Vector3 | Vector3int16
```

---

## Example Usage

```luau
local DEFAULT_TWEEN = TweenInfo.new(0.25, Enum.EasingStyle.Quint)

local function withDefaultTween(target: StateObject<Animatable>)
    return Tween(target, DEFAULT_TWEEN)
end
```

---

## Animatability

[Tween](./tween.md) and [Spring](./spring.md) work by animating the individual
components of whatever data they're working with. For example, if you tween a
Vector3, the X, Y and Z components will have the tween individually applied to
each.

This is a very flexible definition of animatability, but it does not cover all
data types. For example, it still doesn't make sense to animate a string, a
boolean, or nil.

By default, Tween and Spring will just snap to the goal value if you try to
smoothly animate something that is not animatable. However, if you want to try
and prevent the use of non-animatable types statically, you can use this type
definition in your own code.
