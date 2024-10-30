Weave provides an `Attach` function for updating _any_ `Instance` property.

```lua
local ammo = Value.new(36)
```

```luau
Attach(ScreenGui.GunInfo.TextLabel) {
	BackgroundColor3 = Color3.new(0, 0, 1),
}
```

✨ `Value` and `Computed` properties update _automatically_ ✨

```luau
Attach(Gun.SurfaceGui.TextLabel) {
	Text = ammo,
}

ammo:set(30)

-- TextLabel.Text is now 30
```

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

To use `Attach`:

- Call `Attach` with the `Instance` you want to update

```luau
Attach(Frame) -- TODO: Add Properties
```

- Define a table of properties:

```luau
Attach(Frame) {
	Size = UDim2.new(1, 0, 1, 0),
}
```

`Attach` works on _any_ `Instance` type and _any_ Property

```luau
local brickColor = Value.new(BrickColor.Red())

Attach(workspace.Part) {
	BrickColor = brickColor
}

local visible = Value.new(true)

Attach(ScreenGui.Frame) {
	Visible = visible
}

local cameraType = Value.new(Enum.CameraType.Scriptable)

Attach(workspace.CurrentCamera) {
	CameraType = cameraType
}
```

### Instance Reuse

`Attach` returns the `Instance` back to you:

```luau
local textLabel = Attach(PlayerGui.Message) {
	Text = "Loading..."
}

print(textLabel.Text) --> Loading...
```
