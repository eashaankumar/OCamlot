(* [input] describes keyboard and mouse input for any given frame. *)
type input

val active_state : State.state ref
val avtive_input : input ref

(**
 * [init_game] is initializes the graphics canvas and state. 
 * returns: None
 * effects: [active_state]
 *)
val init_game : unit -> unit

(**
 * [get_input] obtains user input from the keyboard and mouse
 * returns: None
 * effects: [active_input]
 *)
val get_input : unit-> unit

(**
 * [update] updates game state [active_state] using input [active_input] 
 * returns: None
 * effects: [active_state]
 *)
val update : unit -> unit

(**
 * [render] draws all entities in [active_state] on the canvas. 
 * returns: None
 * effects: None
 *)
val render : unit -> unit

(**
 * [close_game] runs at the very end of the game to ensure clean shutdown
 * of the game. 
 * precondition: [active_state] is the state at which game ended
 * returns: None
 * effects: None
 *)
val close_game : unit -> unit

(**
 * [game_loop] is responsible for continuously calling [get_intput], [update],
 * returns: None
 * effects: None
 *)
val game_loop : unit -> unit

