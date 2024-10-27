<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">Instances</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-code-24:</span>
	<span class="weavedoc-api-name">OnChange</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">function</span>
		<span class="weavedoc-api-pill-since">since v0.1</span>
	</span>
</h1>

Given a property name, returns a [special key](./specialkey.md) which connects
to that property's change events. It should be used with a handler callback,
which may accept the new value of the property.

```Lua
(propertyName: string) -> SpecialKey
```

---

## Parameters

- `propertyName` - The name of the property to listen for changes to.

---

## Returns

A special key which runs at the `observer` stage. When applied to an instance,
it connects to the property change signal on the instance for the given property.
The handler is run with the property's value after every change.

---

## Example Usage

```Lua
New "TextBox" {
    [OnChange "Text"] = function(newText)
        print("You typed:", newText)
    end
}
```
