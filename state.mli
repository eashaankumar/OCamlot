open Types

(* [possible] moves is a list of [move] instances which
   denotes all of the moves that a player with a given
   allegiance can make at the time of the function call.
   Requires: Inputs include [state] and [allegiance].
*)
val possible_moves : state -> allegiance-> move list

(*
[new_state]
*)
val new_state : state -> command -> state

val update : state -> state