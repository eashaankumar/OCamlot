open Types

(* [possible_moves st team] is an array of [command] instances denoting
   all of the moves that a player with allegiance [team] can make in state [st].
*)
val possible_commands : state -> allegiance -> command array

(* [new_state st c] returns a state representing the
   instantaneous changes that can be made based on
   command [c] and initializes any commands that require
   time.
 *)
val new_state : state -> command -> state

(*
 * [new_state_plus_delta st c d] is the state that is created by
 * applying command [c] to a state and then waiting [d]
 * seconds. This allows the current movements to progress.
*)
val new_state_plus_delta : state -> command -> float -> state

(**
 * [gameover st] is true iff the game is over in state [st].
*)
val gameover : state -> bool

(* [update sc ipt] take state [st] from [sc] and creates a [st']
   by ticking animation sprites once. It then creates the
   appropriate command [c] based on input [ipt]. The entire result
   is new_state_plus_delta [st' c d] where [d] is from Renderer.
*)
val update : scene -> input -> state
