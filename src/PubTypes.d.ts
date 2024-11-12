import { Value } from "./Fusion";

export { NetworkValue } from "./NetworkValue";
export { PlayerValue } from "./PlayerValue";
export { ProfilePlayerValue } from "./ProfilePlayerValue";
export { ProfileValue } from "./ProfileValue";

export type StateObject<T> = Value<T>;

export type WeaveValue<T> = StateObject<T>;

export declare function WeaveRemoteEvent(name: string): RemoteEvent | undefined;

export declare function WeaveRemoteFunction(
  name: string
): RemoteFunction | undefined;

export declare function WeaveUnreliableRemoteEvent(
  name: string
): UnreliableRemoteEvent | undefined;

export declare function ConnectUnreliable<T>(
  name: string,
  handler: (args: T) => void
): RBXScriptConnection;

export declare function Handle<T>(
  name: string,
  handler: (player: Player, rest: T) => T
): RBXScriptConnection;

export declare function Connect<T>(
  name: string,
  handler: (args: T) => void
): RBXScriptConnection;

export declare function Invoke<T>(name: string, args: T): void;
export declare function Clean(): void;
