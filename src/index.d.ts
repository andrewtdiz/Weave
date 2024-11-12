import WeaveClient from "./client";
import WeaveServer from "./server";

declare namespace Weave {
  export { WeaveClient as client };
  export { WeaveServer as server };
}

export = Weave;
