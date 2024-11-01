Weave provides an `Attach` function for updating _any_ `Instance` property.

```luau
Attach(ScreenGui.CoinDisplay.TextLabel) {
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0,
}
```

✨ `Value` and `Computed` properties update _automatically_ ✨

```luau
local coins = Value.new(1100000)

local coinDisplay = Computed.new(function()
    return styleNumber(coins:get())
end)


Attach(ScreenGui.CoinDisplay.TextLabel) {
	Text = coinDisplay,
}

coins:set(756000)

-- TextLabel.Text is now "75.6k"
```

<figure markdown="span">
  ![Image title](Attach.png)
  <figcaption>Source: Pet Simulator 99. <code>Attach</code> updates <code>Instance</code> properties automatically</figcaption>
</figure>

---

<!-- ## Explained

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

--- -->

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
local textLabel = Attach(ScreenGui.TextLabel) {
	Text = "Loading..."
}

print(textLabel.Text) --> Loading...
```
