<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">State</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-code-24:</span>
	<span class="weavedoc-api-name">cleanup</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">function</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

Attempts to destroy all destructible objects passed to it.

```luau
(...any) -> ()
```

---

## Parameters

- `...` - Any objects that need to be destroyed.

---

## Example Usage

```luau
Fusion.cleanup(
	workspace.Part1,
	RunService.RenderStepped:Connect(print),
	function()
		print("I will be run!")
	end
)
```

---

## Destruction Behaviour

Destruction behaviour varies by type:

- if `Instance`, `:Destroy()` is called
- ...else if `RBXScriptConnection`, `:Disconnect()` is called
- ...else if `function`, it is called
- ...else if `{destroy: (self) -> ()}`, `:destroy()` is called
- ...else if `{Destroy: (self) -> ()}`, `:Destroy()` is called
- ...else if `{any}`, `Fusion.cleanup` is called on all members
- ...else nothing occurs.
