import WeaveClient from "./client";
import WeaveServer from "./server";
import { Computed, ForKeys, ForPairs, ForValues, Value } from "./Fusion";
import { Spring, Tween } from "./Fusion";
import { Children, Cleanup, OnChange, Out, Ref } from "./Fusion";
import { Hydrate, New } from "./Fusion";
import { cleanup, doNothing } from "./Fusion";

/**
 * Returns a RemoteEvent defined within Weave.
 */
declare function WeaveRemoteEvent(name: string): RemoteEvent | undefined;

/**
 * Returns a RemoteFunction defined within Weave.
 */
declare function WeaveRemoteFunction(name: string): RemoteFunction | undefined;

/**
 * Returns a UnreliableRemoteEvent defined within Weave.
 */
declare function WeaveUnreliableRemoteEvent(
  name: string
): UnreliableRemoteEvent | undefined;

/**
 * Connects to a UnreliableRemoteEvent defined within Weave.
 */
declare function ConnectUnreliable<T>(
  name: string,
  handler: (args: T) => void
): RBXScriptConnection;

/**
 * Handles a UnreliableRemoteEvent defined within Weave.
 */
declare function Handle<T>(
  name: string,
  handler: (player: Player, rest: T) => T
): RBXScriptConnection;

/**
 * Connects a UnreliableRemoteEvent defined within Weave.
 */
declare function Connect<T>(
  name: string,
  handler: (args: T) => void
): RBXScriptConnection;

declare function Invoke<T>(name: string, args: T): void;
declare function Clean(): void;

declare namespace Weave {
  // State
  export { Value, Computed, ForKeys, ForPairs, ForValues };
  // Animation
  export { Spring, Tween };
  // Default SpecialKeys
  export { Children, Cleanup, OnChange, Out, Ref };
  // Instances
  export { Hydrate, New };
  // Destructors
  export { cleanup, doNothing };
  // Network variables
  export { WeaveClient as client };
  export { WeaveServer as server };
  // networking events
  export {
    WeaveRemoteEvent as RemoteEvent,
    WeaveUnreliableRemoteEvent as UnreliableRemoteEvent,
    WeaveRemoteFunction as RemoteFunction,
    Handle,
    Connect,
    ConnectUnreliable,
  };

  export { Invoke, Clean };
}

export = Weave;
