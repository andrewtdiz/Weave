local Types = require(script.Parent.Fusion.Types)

type eventData = {
	value: any,
}

export type Computed<T> = {
	Changed: RBXScriptSignal,
	get: (WeaveValue<T>, asDependency: boolean?) -> T,
}

export type AttributeValue<T> = {
	Changed: RBXScriptSignal,
	get: (AttributeValue<T>, asDependency: boolean?) -> T,
	set: (AttributeValue<T>, newValue: T, force: boolean?) -> T,
}

export type WeaveValue<T> = {
	Changed: RBXScriptSignal,
	get: (WeaveValue<T>, asDependency: boolean?) -> T,
	set: (WeaveValue<T>, newValue: T, force: boolean?) -> T,
	update: (WeaveValue<T>, callback: (a: T) -> T) -> (),
}

export type NetworkValue<T> = {
	Changed: RBXScriptSignal,
	getWeaveValue: (NetworkValue<T>) -> Types.State<T>,
	get: (NetworkValue<T>, asDependency: boolean?) -> T,
	set: (NetworkValue<T>, newValue: T, force: boolean?) -> T,
	update: (NetworkValue<T>, cb: (a: any) -> any, force: boolean?) -> nil,
}

export type PlayerValue<T> = {
	Changed: RBXScriptSignal,
	getWeaveValue: (PlayerValue<T>) -> Types.State<T>,
	getFor: (PlayerValue<T>, player: Player) -> T,
	setFor: (PlayerValue<T>, player: Player, newValue: any, force: boolean?) -> nil,
	updateFor: (player: Player, cb: (a: any) -> any, force: boolean?) -> nil,
}

export type ProfileValue<T> = {
	Changed: RBXScriptSignal,
	getWeaveValue: (ProfileValue<T>) -> Types.State<T>,
	get: (ProfileValue<T>, asDependency: boolean?) -> T,
	getFor: (ProfileValue<T>, player: Player) -> T,
	setFor: (ProfileValue<T>, player: Player, newValue: any, force: boolean?) -> nil,
	updateFor: (ProfileValue<T>, player: Player, cb: (a: any) -> any, force: boolean?) -> nil,
}

export type ProfilePlayerValue<T> = {
	Changed: RBXScriptSignal,
	getWeaveValue: (ProfilePlayerValue<T>) -> Types.State<T>,
	getFor: (ProfilePlayerValue<T>, player: Player) -> T,
	setFor: (ProfilePlayerValue<T>, player: Player, newValue: any, force: boolean?) -> nil,
	updateFor: (ProfilePlayerValue<T>, player: Player, cb: (a: any) -> any, force: boolean?) -> nil,
}


return nil