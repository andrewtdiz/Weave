<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">Instances</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-key-24:</span>
	<span class="weavedoc-api-name">Cleanup</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">special key</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

Cleans up all items given to it when the instance is destroyed, equivalent to
passing the items to `Fusion.cleanup`.

---

## Example Usage

```luau
local example1 = New "Folder" {
	[Cleanup] = function()
		print("I'm in danger!")
	end
}

local example2 = New "Folder" {
	[Cleanup] = example1
}

local example3 = New "Folder" {
	[Cleanup] = {
		RunService.RenderStepped:Connect(print),
		function()
			print("I'm in danger also!")
		end,
		example2
	}
}

example3:Destroy()
```

---

## Technical Details

This special key runs at the `observer` stage.
