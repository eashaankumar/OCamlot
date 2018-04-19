open Types

(* [possible] moves is an array of [command] instances which
   denotes all of the moves that a player with a given
   allegiance can make at the time of the function call.
*)
val possible_moves : state -> allegiance -> command array

(*
 * [new_state] is the state that is created by applying
 * a command to a state. The returned state is entirely
 * separate from the input state.
*)
val new_state : state -> command -> state

(*
 * [new_state_plus_delta] is the state that is created by
 * applying a command to a state and then waiting [delta]
 * seconds. This allows the current movements to progress.
*)
val new_state_plus_delta : state -> command -> float -> state

(**
 * [gameover] takes in a state and returns a boolean value
 * denoting whether the game is over or not
*)
val gameover : state -> bool

(* [update st ipt] is [new_state st c] where [c] is the command
   that [ipt] corresponds to.
*)
val update : state -> input -> state
