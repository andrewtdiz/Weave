import { Computed, ForKeys, ForPairs, ForValues, Value } from "../Fusion";
import { Spring, Tween } from "../Fusion";

import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "../Fusion";
import { Hydrate, New } from "../Fusion";
import { cleanup, doNothing } from "../Fusion";
import {
  NetworkValue,
  PlayerValue,
  ProfileValue,
  WeaveRemoteEvent,
  WeaveUnreliableRemoteEvent,
  WeaveRemoteFunction,
  Handle,
  Connect,
  ProfilePlayerValue,
} from "../PubTypes";

declare namespace WeaveServer {
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
  export { NetworkValue, PlayerValue, ProfileValue, ProfilePlayerValue };
}

export = WeaveServer;
