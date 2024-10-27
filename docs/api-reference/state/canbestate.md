<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">State</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-checklist-24:</span>
	<span class="weavedoc-api-name">CanBeState</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">type</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

A value which may either be a [state object](../stateobject) or a constant.

Provided as a convenient shorthand for indicating that constant-ness is not
important.

```Lua
StateObject<T> | T
```

---

## Example Usage

```Lua
local function printItem(item: CanBeState<string>)
    if typeof(item) == "string" then
        -- constant
        print("Got constant: ", item)
    else
        -- state object
        print("Got state object: ", item:get())
    end
end

local constant = "Hello"
local state = Value("World")

printItem(constant) --> Got constant: Hello
printItem(state) --> Got state object: World
```
