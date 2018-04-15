open Types

(* [possible] moves is an array of [move] instances which
   denotes all of the moves that a player with a given
   allegiance can make at the time of the function call.
   Requires: Inputs include [state] and [allegiance].
*)
val possible_moves : state -> allegiance-> move array

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

val update : state -> state
