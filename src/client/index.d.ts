import { Computed, ForKeys, ForPairs, ForValues, Value } from "../Fusion";
import { Spring, Tween } from "../Fusion";
import { Children, Cleanup, OnChange, OnEvent, Out, Ref } from "../Fusion";
import { Hydrate, New } from "../Fusion";
import { cleanup, doNothing } from "../Fusion";
import { ReadOnlyValue, RemoteEvent, UnreliableRemoteEvent } from "../PubTypes";

type FunctionToConstructor<T extends (...args: any[]) => any> = {
  new (...args: Parameters<T>): ReturnType<T>;
};

type ClientValue = FunctionToConstructor<<T>(name: string) => ReadOnlyValue<T>>;

type WeaveClientValue = Promise<ClientValue>;

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

  RemoteEvent: RemoteEvent;
  UnreliableRemoteEvent: UnreliableRemoteEvent;

  Hydrate: typeof Hydrate;
  New: typeof New;

  cleanup: typeof cleanup;
  doNothing: typeof doNothing;

  NetworkValue: WeaveClientValue;
  PlayerValue: WeaveClientValue;
  ProfileValue: WeaveClientValue;
  ProfilePlayerValue: WeaveClientValue;
}

declare const WeaveClient: Weave;

export = WeaveClient;
