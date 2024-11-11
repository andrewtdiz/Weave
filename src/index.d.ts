import { Computed, ForKeys, ForPairs, ForValues, Value } from "./Fusion";
import { Spring, Tween } from "./Fusion";
import { Version } from "./Fusion";
import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "./Fusion";
import { Hydrate, New } from "./Fusion";
import { cleanup, doNothing } from "./Fusion";
import {
  NetworkValue,
  PlayerValue,
  ProfileValue,
  ProfilePlayerValue,
} from "./PubTypes";

declare namespace Weave {
  export { Computed, ForKeys, ForPairs, ForValues, Value };
  export { Spring, Tween };
  export { Children, Cleanup, OnChange, OnEvent, Out, Ref };
  export { Hydrate, New };
  export { cleanup, doNothing };
  export const version: Version;

  export { NetworkValue, PlayerValue, ProfileValue, ProfilePlayerValue };
}

export = Weave;
