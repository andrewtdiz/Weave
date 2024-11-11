import { Value } from "./Fusion";

export { NetworkValue } from "./NetworkValue";
export { PlayerValue } from "./PlayerValue";
export { ProfilePlayerValue } from "./ProfilePlayerValue";
export { ProfileValue } from "./ProfileValue";

export type StateObject<T> = Value<T>;

export declare type ReadOnlyValue<T> = Omit<Value<T>, 'set'>;

export type WeaveValue<T> = StateObject<T>;

export type RemoteEvent = (name: string) => RemoteEvent | undefined;
export type RemoteFunction = (name: string) => RemoteFunction | undefined;
export type UnreliableRemoteEvent = (
  name: string
) => UnreliableRemoteEvent | undefined;
export type Connect<T> = (
  name: string,
  handler: (args: T) => void
) => RBXScriptConnection;
export type ConnectUnreliable<T> = (
  name: string,
  handler: (args: T) => void
) => RBXScriptConnection;
export type Handle<T> = (
  name: string,
  handler: (player: Player, rest: T) => T
) => RBXScriptConnection;
export type Invoke<T> = (name: string, args: T) => void;
export type Clean = () => void;
