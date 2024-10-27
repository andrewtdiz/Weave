<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">Instances</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-checklist-24:</span>
	<span class="weavedoc-api-name">Component</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">type</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

The standard type signature for UI components. They accept a property table and
return a [child type](./child.md).

```luau
(props: {[any]: any}) -> Child
```

---

## Example Usage

```luau
-- create a Button component
local function Button(props)
    return New "TextButton" {
        Text = props.Text
    }
end

-- the Button component is compatible with the Component type
local myComponent: Component = Button
```
