import { Computed, ForKeys, ForPairs, ForValues, Value } from "../Fusion";
import { Spring, Tween } from "../Fusion";
import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "../Fusion";
import { Hydrate, New } from "../Fusion";
import { cleanup, doNothing } from "../Fusion";
import {
  Connect,
  Handle,
  WeaveRemoteEvent,
  WeaveUnreliableRemoteEvent,
  WeaveRemoteFunction,
} from "../PubTypes";
import { ReadOnlyValue } from "../ReadOnlyValue";

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
    WeaveRemoteEvent as RemoteEvent,
    WeaveUnreliableRemoteEvent as UnreliableRemoteEvent,
    WeaveRemoteFunction as RemoteFunction,
    Handle,
    Connect,
  };
  // networking variables
  export {
    ReadOnlyValue as NetworkValue,
    ReadOnlyValue as PlayerValue,
    ReadOnlyValue as ProfileValue,
    ReadOnlyValue as ProfilePlayerValue,
  };
}

export = WeaveClient;
