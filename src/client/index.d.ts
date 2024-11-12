import { ReadOnlyValue } from "../ReadOnlyValue";

declare namespace WeaveClient {
  // networking variables
  export {
    ReadOnlyValue as NetworkValue,
    ReadOnlyValue as PlayerValue,
    ReadOnlyValue as ProfileValue,
    ReadOnlyValue as ProfilePlayerValue,
  };
}

export = WeaveClient;
