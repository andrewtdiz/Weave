import { Computed, ForKeys, ForPairs, ForValues, Value } from "../Fusion";
import { Spring, Tween } from "../Fusion";

import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "../Fusion";
import { Hydrate, New } from "../Fusion";
import { cleanup, doNothing } from "../Fusion";
import {
  NetworkValue,
  PlayerValue,
  ProfileValue,
  ProfilePlayerValue,
} from "../PubTypes";

interface Weave {
  Value: typeof Value;
  Computed: typeof Computed;

  Spring: typeof Spring;
  Tween: typeof Tween;
  ForKeys: typeof ForKeys;
  ForValues: typeof ForValues;
  ForPairs: typeof ForPairs;

  Children: typeof Children;
  Cleanup: typeof Cleanup;
  OnChange: typeof OnChange;
  OnEvent: typeof OnEvent;
  Out: typeof Out;
  Ref: typeof Ref;

  Hydrate: typeof Hydrate;
  New: typeof New;

  cleanup: typeof cleanup;
  doNothing: typeof doNothing;

  NetworkValue: typeof NetworkValue;
  PlayerValue: typeof PlayerValue;
  ProfileValue: typeof ProfileValue;
  ProfilePlayerValue: typeof ProfilePlayerValue;
}

declare const WeaveServer: Weave;

export = WeaveServer;
