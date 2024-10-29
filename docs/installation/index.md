## Roblox Studio

Download the latest `Weave.rbxm` from <a href="https://github.com/andrewtdiz/Weave/releases/latest" target="_blank">GitHub</a>

![The Assets dropdown opened to reveal downloads, with Weave.rbxm highlighted.](index/weaveAssets.png)

Right-click on `ReplicatedStorage`, and select 'Insert from File...':

![ReplicatedStorage is right-clicked, showing a context menu of items. Insert from File is highlighted.](index/Github-Releases-Guide-3-Dark.png)

Select the `Weave.rbxm` file you just downloaded.

You should see the module script appear in `ReplicatedStorage` - you're ready to go!

## Your First Script

To use Weave:

1. Create a `Script` or `LocalScript`
2. Paste the following code in:

```luau linenums="1"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Weave = require(ReplicatedStorage.Weave)
```

If there are no errors, everything was set up correctly!

??? failure "Still didn't work? (click to expand)"

    Weave is not a valid member of ReplicatedStorage "ReplicatedStorage"
    `

    If you're seeing this error, then your script can't find Weave.

    This code assumes you've installed Weave into `ReplicatedStorage`. If
    you've installed Weave elsewhere, you'll need to tweak the `require()` on
    line 2 to point to the correct location.

    If line 2 looks like it points to the correct location, refer back to
    [the previous section](#installing-Weave) and double-check you've set
    everything up properly. Make sure you have a `ModuleScript` inside
    `ReplicatedStorage` called "Weave".

---

## Wally (advanced)

Coming Soon

---
