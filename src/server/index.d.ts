/**
 * Constructs and returns objects which can be used to model independent
 * reactive state.
 */
declare class NetworkValue<T> {
  type: "State";
  kind: "Value";
  constructor(name: string, initialValue: T);
  /**
   * Returns the value currently stored in this State object.
   * The state object will be registered as a dependency unless `asDependency` is
   * false.
   */
  get(asDependency?: boolean): T;
  /**
   * Updates the value stored in this State object.
   *
   * If `force` is enabled, this will skip equality checks and always update the
   * state object and any dependents - use this with care as this can lead to
   * unnecessary updates.
   */
  set(value: T, force?: boolean): void;
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

/**
 * Constructs and returns objects which can be used to model independent
 * reactive state.
 */
declare class PlayerValue<T> {
  type: "State";
  kind: "Value";
  constructor(name: string, initialValue: T);
  /**
   * Returns the value currently stored in this State object for a player.
   * The state object will be registered as a dependency unless `asDependency` is
   * false.
   */
  getFor(player: Player): T;
  /**
   * Updates the value stored in this State object for a player.
   *
   * If `force` is enabled, this will skip equality checks and always update the
   * state object and any dependents - use this with care as this can lead to
   * unnecessary updates.
   */
  setFor(player: Player, newValue: T, force?: boolean): void;
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

/**
 * Constructs and returns objects which can be used to model independent
 * reactive state.
 */
declare class ProfileValue<T> {
  type: "State";
  kind: "Value";
  constructor(profileKey: string);
  /**
   * Returns the value currently stored in this State object for a player.
   * The state object will be registered as a dependency unless `asDependency` is
   * false.
   */
  getFor(player: Player): T;
  /**
   * Updates the value stored in this State object for a player.
   *
   * If `force` is enabled, this will skip equality checks and always update the
   * state object and any dependents - use this with care as this can lead to
   * unnecessary updates.
   */
  setFor(player: Player, newValue: T, force?: boolean): void;
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

declare namespace WeaveServer {
  // Networking variables
  export {
    NetworkValue,
    PlayerValue,
    ProfileValue,
    ProfileValue as ProfilePlayerValue,
  };
}

export = WeaveServer;
