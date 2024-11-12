/**
 * Constructs and returns objects which can be used to model independent
 * reactive state.
 */
export declare class ReadOnlyValue<T> {
  type: "State";
  kind: "Value";
  constructor(initialValue: T);
  /**
   * Returns the value currently stored in this State object.
   * The state object will be registered as a dependency unless `asDependency` is
   * false.
   */
  get(asDependency?: boolean): T;
  /**
   * Adds a Change listener. When the watched state changes value, the listener
   * will be fired.
   *
   * Returns a RBXBindableEvent which can disconnect the change listener.
   * As long as there is at least one active change listener, this Event
   * will be held in memory, preventing GC, so disconnecting is important.
   */
  Changed: BindableEvent<(t: T) => void>;
}
