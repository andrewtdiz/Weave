<nav class="weavedoc-api-breadcrumbs">
	<a href="../..">Weave</a>
	<a href="..">State</a>
</nav>

<h1 class="weavedoc-api-header" markdown>
	<span class="weavedoc-api-icon" markdown>:octicons-checklist-24:</span>
	<span class="weavedoc-api-name">Dependency</span>
	<span class="weavedoc-api-pills">
		<span class="weavedoc-api-pill-type">type</span>
		<span class="weavedoc-api-pill-since">since v0.2</span>
	</span>
</h1>

A graph object which can send updates to [dependents](../dependent) on the
reactive graph.

Most often used with [state objects](../stateobject), though the reactive graph
does not require objects to store state.

```Lua
{
	dependentSet: Set<Dependent>
}
```

---

## Example Usage

```Lua
-- these are examples of objects which are dependencies
local value: Dependency = Value(2)
local computed: Dependency = Computed(function()
	return value:get() * 2
end)

-- dependencies can be used with some internal functions such as updateAll()
updateAll(value)
```

---

## Automatic Dependency Manager

Weave includes an automatic dependency manager which can detect when graph
objects are used in certain contexts and automatically form reactive graphs.

In order to do this, dependencies should signal to the system when they are
being used (for example, during a call to a `:get()` method). This can be done
via the `useDependency()` function internally, which should be called with the
dependency object.

Furthermore, to help assist the dependency manager prevent cycles in the
reactive graph, dependencies should register themselves with the system as soon
as they are created via the `initDependency()` function internally. This is
primarily used to prevent dependencies from being captured when they originate
from within the object which is doing the capturing.
