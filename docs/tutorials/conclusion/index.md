As we've seen, Weave updates your game state like magic ✨

```luau
local eggCount = ProfileValue.new("EggCount")

local isQuestComplete = Computed.new(function()
	return eggCount:get() >= 10
end)

Attach(CountText) {
	Text = eggCount
}
Attach(Checkmark) {
	Visible = isQuestComplete
}
```

Hopefully it is clear how this is a more concise way of updating values.

Set the value and Weave does all the work.

Hence the Weave motto, _set it and forget it_
