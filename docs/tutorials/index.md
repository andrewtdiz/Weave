Imagine the state of your game as individual pieces of data.

![An example of a game's UI, with some variables labelled and linked to parts of the UI.](assets/Game-UI-Variables-Dark.png)

<figcaption>Screenshot: Pet Simulator 99</figcaption>

When variables change, you want your game to reflect those changes.

You may try something like this:

```luau
local eggCount = 0
local isQuestComplete = false

local function updateEggCountUI()
	PlayerGui.Quests.FirstQuest.CountText.Text = eggCount
end

local function updateCheckmarkUI()
	PlayerGui.Quests.FirstQuest.Checkmark.Visible = isQuestComplete
end

local function updateQuestComplete()
	isQuestComplete = eggCount >= 10

	updateCheckmarkUI()
end

local function setEggCount(newEggCount)
	eggCount = newEggCount
	-- you need to send out updates to every piece of code using `eggCount` here
	updateQuestComplete()
	updateQuestUI()
	updateEggCountToServer()
end
```

This often gets messy.

Unfortunately, there's no way to listen for those changes in Luau.

- How do we share these updates across scripts?
- What if there's another piece of code using `eggCount` that we've forgotten to update here?

### Building Better Variables

What if we could just change value and it updates everywhere _automatically_, like magic ✨

That's exactly what Weave does.

```luau
local eggCount = Value.new(0)

local isQuestComplete = Computed.new(function()
	return eggCount:get() >= 10
end)
```

```luau
-- Update a UI TextLabel
Attach(CountText) {
	Text = eggCount
}
```

```luau
-- Update the quest complete boolean
Attach(Checkmark) {
	Visible = isQuestComplete
}
```

This is a more concise way of updating variables.

Set the value and Weave updates wherever the value is used.

Hence the Weave motto, _set it and forget it_
