import { Computed, ForKeys, ForPairs, ForValues, Value } from "../Fusion";
import { Spring, Tween } from "../Fusion";
import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "../Fusion";
import { Hydrate, New } from "../Fusion";
import { cleanup, doNothing } from "../Fusion";
import {
  Connect,
  Handle,
  ReadOnlyValue,
  RemoteEvent,
  RemoteFunction,
  UnreliableRemoteEvent,
} from "../PubTypes";

type FunctionToConstructor<T extends (...args: any[]) => any> = {
  new (...args: Parameters<T>): ReturnType<T>;
};

type ClientValue<T> = FunctionToConstructor<
  <T>(name: string) => ReadOnlyValue<T>
>;

type NetworkValue<T> = ClientValue<T>;
type PlayerValue<T> = ClientValue<T>;
type ProfileValue<T> = ClientValue<T>;
type ProfilePlayerValue<T> = ClientValue<T>;

declare namespace WeaveClient {
  // State
  export { Computed, ForKeys, ForPairs, ForValues, Value };
  // Animation
  export { Spring, Tween };
  // Default SpecialKeys
  export { Children, Cleanup, OnChange, OnEvent, Out, Ref };
  // Instances
  export { Hydrate, New };
  // Destructors
  export { cleanup, doNothing };
  // networking events
  export {
    RemoteEvent,
    UnreliableRemoteEvent,
    RemoteFunction,
    Handle,
    Connect,
  };
  // networking variables
  export { NetworkValue, PlayerValue, ProfileValue, ProfilePlayerValue };
}

export = WeaveClient;
