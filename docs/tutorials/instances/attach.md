Weave provides an `Attach` function for updating _any_ `Instance` property.

```lua
local ammo = Value.new(36)
```

```luau hl_lines="3"
Attach(ScreenGui.GunInfo.TextLabel) {
	BackgroundColor3 = Color3.new(0, 0, 1),
	Text = ammo,
}
```

```luau hl_lines="3"
Attach(Gun.SurfaceGui.TextLabel) {
	BackgroundColor3 = Color3.new(1, 1, 1),
	Text = ammo,
}
```

Any Weave `Value` or `Computed` will update the Instance _automatically_.

<figure markdown>
![A diagram showing hydration - an 'ammo' variable is sent from the script and placed inside various UI and game elements.](Hydration-Basic-Dark.svg#only-dark)
![A diagram showing hydration - an 'ammo' variable is sent from the script and placed inside various UI and game elements.](Hydration-Basic-Light.svg#only-light)
<figcaption>Screenshot: GameUIDatabase (Halo Infinite)</figcaption>
</figure>

---

## Explained

`Attach` may look weird, but it is **valid Luau**

```luau
local function someFunction(arg)
	-- do stuff
end

someFunction({ Text = "Some Text", Color3 = Color3.new(1, 1, 1) })
```

Is the _exact same_ as

```luau
someFunction {
	Text = "Some Text",
	Color3 = Color3.new(1, 1, 1)
}
```

Still don't believe it? Run the code in <a href="https://luau.org/demo?share=H4sIAAAAAAAACsvJT07MUUgrzUsuyczPUyjOz011g3I0EovSNbkUFBQUCooy80pAXL2Q1IoSHQUQyzk%2FJ7%2FIWJMrNS%2BFiwtFW7UCSJWCrYJScH5uKpijpKMAUa9gq5BgqKMAQgkKtZqoOhWqFcDWYWg3UtIBSyDMMNBRAKEErlouLi4AkZUuRMQAAAA%3D" target="_blank">luau.org/AttachDemo</a>

---

## Usage

Import the `Attach` module from Weave:

```luau linenums="1"
local Weave = require(ReplicatedStorage.Weave)
local Attach = Weave.Attach
```

The Attach function is called in two parts.

Call `Attach` with the `Instance` you want to update

```luau
Attach(Frame) -- TODO: Add Properties
```

Then, define a table of properties:

```luau
Attach(Frame) {
	Size = UDim2.new(1, 0, 1, 0),
}
```

`Attach` works on **any** Roblox 1Instance1 type and **any** Property

```luau
Attach(workspace.Part) {
	BrickColor = BrickColor.Red()
}

Attach(ScreenGui.Frame) {
	Visible = false
}

Attach(workspace.CurrentCamera) {
	CameraType = Enum.CameraType.Scriptable
}
```

Constant values are applied to the instance directly.

```luau
local message = Value.new("Loading...")

Attach(PlayerGui.Message) {
	Text = message
}

print(PlayerGui.Message.Text) --> Loading...
```

Updates to `Value` and `Computed` values will be applied on the next frame:

```luau
message:set("All done!")

task.wait() -- important: changes are applied on the next frame!

print(PlayerGui.Message.Text) --> All done!
```

### Instance Reuse

`Attach` returns the Instance you provide, so you can re-use it:

```luau
local messageLabel = Attach(PlayerGui.Message) {
	Text = message
}

print(messageLabel.Text) --> Loading...
```
