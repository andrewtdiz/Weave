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

Because whenever we change the value, we have to update **everything in the game** that variable relies on.

- And every variable that variable relies on.

- And **everything in the game** _those_ variables rely on

- And so on and so on...

### A Better Way

What if when we set value it updated everywhere _automatically_, like magic ✨

That's what Weave does.

Hence the motto, <em>set it and forget it </em>
