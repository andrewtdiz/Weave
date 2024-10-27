<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">Instances</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-key-24:</span>
	<span class="weavedoc-api-name">Ref</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">special key</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

When applied to an instance, outputs the instance to a state object. It should
be used with a [value](../state/value.md).

---

## Example Usage

```luau
local myRef = Value()

New "Part" {
    [Ref] = myRef
}

print(myRef:get()) --> Part
```

---

## Technical Details

This special key runs at the `observer` stage.

On cleanup, the state object is reset to nil, in order to avoid potential
memory leaks.
