Imagine the state of your game as individual pieces of data.

![An example of a game's UI, with some variables labelled and linked to parts of the UI.](assets/Game-UI-Variables-Light.svg#only-light)
![An example of a game's UI, with some variables labelled and linked to parts of the UI.](assets/Game-UI-Variables-Dark.svg#only-dark)

<figcaption>Screenshot: GameUIDatabase (Halo Infinite)</figcaption>

When variables change, you want your game to reflect those changes.

Unfortunately, there's no way to listen for those changes in Lua.

You may try something like this:

```luau
local ammo = 36
local isOutOfAmmo = false

local function updateHUD()
	PlayerGui.HUD.WeaponFrame.AmmoText.Text = ammo
end

local function updateOutOfAmmoCheck()
	isOutOfAmmo = ammo == 0
end

local function setAmmo(newAmmo)
	ammo = newAmmo
	-- you need to send out updates to every piece of code using `ammo` here
	updateHUD()
	updateOutOfAmmoCheck()
	sendAmmoToServer()
end
```

But often gets messy.

- How do we share these updates across scripts?
- What if there's another piece of code using `ammo` that we've forgotten to update here?

### Building Better Variables

What if we could just change value and it updates everywhere _automatically_, like magic.

That's exactly what Weave does.

```luau
local GunData = {
	ammo = Value.new(36),
	maxAmmo = Value.new(67),
}
```

```luau
-- Update a UI TextLabel
Attach(AmmoText) {
	Text = Weapon.ammo
}
```

```luau
-- Update an out of ammo variable
local isOutOfAmmo = Weave.Computed(function()
	return Weapons.ammo:get() == 0
end)
```

Store state in a `Value` change the object's value using `:set()`.

Then, when it changes, it will update everything that references it.

Hence the Weave motto, _set it and forget it_
