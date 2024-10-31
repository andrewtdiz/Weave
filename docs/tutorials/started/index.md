Now that you've installed Weave, let's make our first script.

1. Create a new `Script` or `LocalScript`
2. Paste the following code:

```luau linenums="1"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Weave = require(ReplicatedStorage.Weave)
```


??? note "Still didn't work? (click to expand)"

    Weave is not a valid member of ReplicatedStorage "ReplicatedStorage"
    `

    If you're seeing this error, then your script can't find Weave.

    This code assumes you've installed Weave into `ReplicatedStorage`. If
    you've installed Weave elsewhere, you'll need to tweak the `require()` on
    line 2 to point to the correct location.

    If line 2 looks like it points to the correct location, refer back to
    the previous section and double-check you've set
    everything up properly. Make sure you have a `ModuleScript` inside
    `ReplicatedStorage` called "Weave".


If there are no errors, everything was set up correctly!

Let's start using Weave 🚀