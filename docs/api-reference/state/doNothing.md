<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">State</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-code-24:</span>
	<span class="weavedoc-api-name">doNothing</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">function</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

No-op function - does nothing at all, and returns nothing at all. Intended for
use as a destructor when no destruction is needed.

```luau
(...any) -> ()
```

---

## Parameters

- `...` - Any objects.

---

## Example Usage

```luau
local foo = Computed(function()
	return workspace.Part
end, Weave.doNothing)
```
