local RunService = game:GetService("RunService")

local Fusion = script:WaitForChild("Fusion")

local Types = require(script.Fusion.Types)

type CanBeState = Types.CanBeState

local Weave = {
	NetworkValue = require(script.NetworkValue),
	PlayerValue = require(script.PlayerValue),
	ProfileValue = require(script.ProfileValue),
	ProfilePlayerValue = require(script.ProfilePlayerValue),

	ZapPlayerValue = require(script.ZapPlayerValue),
	ProfileZapValue = require(script.ProfileZapValue),

	New = require(Fusion.Instances.New),
	Attach = require(Fusion.Instances.Attach),
	Ref = require(Fusion.Instances.Ref),
	Out = require(Fusion.Instances.Out),
	Cleanup = require(Fusion.Instances.Cleanup),
	Children = require(Fusion.Instances.Children),
	OnEvent = require(Fusion.Instances.OnEvent),
	OnChange = require(Fusion.Instances.OnChange),

	Value = require(Fusion.State.Value),
	AttributeValue = require(Fusion.State.AttributeValue),
	Computed = require(Fusion.State.Computed),
	ForPairs = require(Fusion.State.ForPairs),
	ForKeys = require(Fusion.State.ForKeys),
	ForValues = require(Fusion.State.ForValues),

	Tween = require(Fusion.Animation.Tween),
	Spring = require(Fusion.Animation.Spring),

	cleanup = require(Fusion.Utility.cleanup),
	doNothing = require(Fusion.Utility.doNothing),
}

local WPubTypes = require(script.WPubTypes)
local PubTypes = require(script.Fusion.PubTypes)
local WeaveUtils = require(script.WeaveUtils)

type Weave = {
	NetworkValue: { new: <T>(eventName: string, initialValue: T) -> WPubTypes.NetworkValue<T> },
	PlayerValue: { new: <T>(eventName: string, initialValue: T) -> WPubTypes.PlayerValue<T> },
	ProfileValue: { new: <T>(profileServiceKey: string) -> WPubTypes.ProfileValue<T> },
	ProfilePlayerValue: { new: <T>(profileServiceKey: string) -> WPubTypes.ProfilePlayerValue<T> },

	ZapPlayerValue: { new: <T>(eventName: string, zapEventName: string, initialValue: any) -> ZapPlayerValue<T> },
	ProfileZapValue: { new: <T>(valueName: string, zapEventName: string, profileServiceKey: string) -> PlayerValue<T> },

	RemoteEvent: (Weave: Weave, name: string) -> RemoteEvent | nil,
	RemoteFunction: (Weave: Weave, name: string) -> RemoteFunction | nil,
	UnreliableRemoteEvent: (Weave: Weave, name: string) -> UnreliableRemoteEvent | nil,
	Connect: (Weave: Weave, name: string, handler: (...any) -> ()) -> RBXScriptConnection,
	ConnectUnreliable: (Weave: Weave, name: string, handler: (...any) -> ()) -> RBXScriptConnection,
	Handle: (Weave: Weave, name: string, handler: (player: Player, ...any) -> ...any) -> RBXScriptConnection,
	Invoke: (Weave: Weave, name: string, ...any) -> ...any,
	Clean: () -> (),

	New: (className: string) -> (propertyTable: PubTypes.PropertyTable) -> Instance,
	Ref: PubTypes.SpecialKey,
	Cleanup: PubTypes.SpecialKey,
	Children: PubTypes.SpecialKey,
	Out: PubTypes.SpecialKey,
	OnEvent: (eventName: string) -> PubTypes.SpecialKey,
	OnChange: (propertyName: string) -> PubTypes.SpecialKey,

	Value: { new: <T>(v: T) -> WPubTypes.WeaveValue<T> },
	Computed: { new: <T>(callback: () -> T, destructor: (T) -> ()?) -> WPubTypes.Computed<T> },

	Attach: (target: Instance) -> (propertyTable: PubTypes.PropertyTable) -> Instance,
	AttributeValue: {
		new: <T>(instance: Instance, attributeName: string, initialValue: T?) -> WPubTypes.AttributeValue<T>,
	},
	ForPairs: <KI, VI, KO, VO, M>(
		inputTable: CanBeState<{ [KI]: VI }>,
		processor: (KI, VI) -> (KO, VO, M?),
		destructor: (KO, VO, M?) -> ()?
	) -> PubTypes.ForPairs<KO, VO>,
	ForKeys: <KI, KO, M>(
		inputTable: CanBeState<{ [KI]: any }>,
		processor: (KI) -> (KO, M?),
		destructor: (KO, M?) -> ()?
	) -> PubTypes.ForKeys<KO, any>,
	ForValues: <VI, VO, M>(
		inputTable: CanBeState<{ [any]: VI }>,
		processor: (VI) -> (VO, M?),
		destructor: (VO, M?) -> ()?
	) -> PubTypes.ForValues<any, VO>,

	Tween: <T>(goalState: StateObject<T>, tweenInfo: TweenInfo?) -> PubTypes.Tween<T>,
	Spring: <T>(goalState: StateObject<T>, speed: number?, damping: number?) -> PubTypes.Spring<T>,

	cleanup: (...any) -> (),
	doNothing: (...any) -> (),
}
--[=[
Remote Events and functions were inspired by the legend himself Sleitnick
https://github.com/Sleitnick/RbxUtil/tree/main/modules/net
]=]

--[=[
	Gets a RemoteEvent with the given name.

	On the server, if the RemoteEvent does not exist, then
	it will be created with the given name.

	On the client, if the RemoteEvent does not exist, then
	it will wait until it exists for at least 10 seconds.
	If the RemoteEvent does not exist after 10 seconds, an
	error will be thrown.

	```lua
	local remoteEvent = Weave:RemoteEvent("PointsChanged")
	```
]=]
function Weave:RemoteEvent(name: string)
	return WeaveUtils.RemoteEvent(name)
end

--[=[
	Gets an UnreliableRemoteEvent with the given name.

	On the server, if the UnreliableRemoteEvent does not
	exist, then it will be created with the given name.

	On the client, if the UnreliableRemoteEvent does not
	exist, then it will wait until it exists for at least
	10 seconds. If the UnreliableRemoteEvent does not exist
	after 10 seconds, an error will be thrown.

	```lua
	local unreliableRemoteEvent = Weave:UnreliableRemoteEvent("PositionChanged")
	```
]=]
function Weave:UnreliableRemoteEvent(name: string)
	local unreliableRemoteEvent
	name = `UnreliableRemoteEvents/{name}`
	if RunService:IsServer() then
		unreliableRemoteEvent = script:FindFirstChild(name)
		if unreliableRemoteEvent == nil then
			unreliableRemoteEvent = Instance.new("UnreliableRemoteEvent")
			unreliableRemoteEvent.Name = name
			unreliableRemoteEvent.Parent = script
		end
	else
		unreliableRemoteEvent = script:WaitForChild(name, 10)
		if unreliableRemoteEvent == nil then
			error(`Remote event not found {unreliableRemoteEvent}`)
		end
	end
	return unreliableRemoteEvent
end

--[=[
	Connects a handler function to the given RemoteEvent.

	```lua
	-- Client
	Weave:Connect("PointsChanged", function(points)
		print("Points", points)
	end)

	-- Server
	Weave:Connect("SomeEvent", function(player, ...) end)
	```
]=]
function Weave:Connect(name: string, handler: (...any) -> ()): RBXScriptConnection
	return WeaveUtils.Connect(name, handler)
end

--[=[
	Connects a handler function to the given UnreliableRemoteEvent.

	```lua
	-- Client
	Weave:ConnectUnreliable("PositionChanged", function(position)
		print("Position", position)
	end)

	-- Server
	Weave:ConnectUnreliable("SomeEvent", function(player, ...) end)
	```
]=]
function Weave:ConnectUnreliable(name: string, handler: (...any) -> ()): RBXScriptConnection
	if RunService:IsServer() then
		return self:UnreliableRemoteEvent(name).OnServerEvent:Connect(handler)
	else
		return self:UnreliableRemoteEvent(name).OnClientEvent:Connect(handler)
	end
end

--[=[
	Gets a RemoteFunction with the given name.

	On the server, if the RemoteFunction does not exist, then
	it will be created with the given name.

	On the client, if the RemoteFunction does not exist, then
	it will wait until it exists for at least 10 seconds.
	If the RemoteFunction does not exist after 10 seconds, an
	error will be thrown.

	```lua
	local remoteFunction = Weave:RemoteFunction("GetPoints")
	```
]=]
function Weave:RemoteFunction(name: string): RemoteFunction
	name = `RemoteFunctions/{name}`
	local remoteFunction
	if RunService:IsServer() then
		remoteFunction = script:FindFirstChild(name)
		if not remoteFunction then
			remoteFunction = Instance.new("RemoteFunction")
			remoteFunction.Name = name
			remoteFunction.Parent = script
		end
	else
		remoteFunction = script:WaitForChild(name, 10)
		if not remoteFunction then
			error("Failed to find RemoteFunction: " .. name, 2)
		end
	end
	return remoteFunction
end

--[=[
	@server
	Sets the invocation function for the given RemoteFunction.

	```lua
	Weave:Handle("GetPoints", function(player)
		return 10
	end)
	```
]=]
function Weave:Handle(name: string, handler: (player: Player, ...any) -> ...any)
	self:RemoteFunction(name).OnServerInvoke = handler
end

--[=[
	@client
	Invokes the RemoteFunction with the given arguments.

	```lua
	local points = Weave:Invoke("GetPoints")
	```
]=]
function Weave:Invoke(name: string, ...: any): ...any
	return self:RemoteFunction(name):InvokeServer(...)
end

--[=[
	@server
	Destroys all RemoteEvents and RemoteFunctions. This
	should really only be used in testing environments
	and not during runtime.
]=]
function Weave:Clean()
	script:ClearAllChildren()
end

return Weave :: Weave
