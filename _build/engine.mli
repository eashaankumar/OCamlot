(* [input] describes keyboard and mouse input for any given frame. *)
type input

(* [properties] describes information needed to create the initial game state *)
type properties
(* [Init_Failure s] represents the error raised when an initial game state
 * could not be created successfully. *)
exception Init_Failure of string

(**
 * [init_game p] is the initial game state that is created based on provided
 * properties [p]. 
 * returns: Initial game state
 * exceptions: [Init_Failure s] if [p] is invalid
 *)
val init_game : properties -> State.state

(**
 * [get_input s] obtains user input from the keyboard and mouse and returns
 * an [input] data structure.
 * returns: [input] containing all user input
 *)
val get_input : unit-> input

(**
 * [update s i] updates game state [s] using input [i] without causing
 * any side effects. 
 * returns: updated game [state]
 * effects: [update] is not allowed to print output, get input, or render
 *)
val update : State.state -> input -> State.state

(**
 * [render s] draws all entities in state on the screen. 
 * returns: [unit], ie nothing
 * effects: draws the new frame.
 *)
val render : State.state -> unit

(**
 * [close_game s] runs at the very end of the game to ensure clean shutdown
 * of the game. 
 * precondition: [s] is the state at which game ended
 * returns: nothing
 * effects: nothing
 *)
val close_game : State.state -> unit

(**
 * [game_loop s run] is responsible for continuously updating the game [state]
 * as long as [run] is [true]. 
 * returns: updated [state] for the next iteration
 * effects: changes made to [state] based on functions defined above
 *)
val game_loop : State.state -> bool -> State.state

