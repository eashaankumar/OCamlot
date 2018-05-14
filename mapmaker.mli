(* This module is responsible for creating new maps and returning them in order 
of difficulty. Engine relies on this module to get the next state. *)

open Types

(**
 * [next_state unit] is responsible for getting the next state for
 * the next match.
 * returns: next [state]
 *)
val next_state : unit -> state

(**
 * [all_states_completed unit] checks if all levels have been completed.
 * This means that the game ends.
 * returns: [true] if all levels have been completed, [false] otherwise
 *)
val all_states_completed : unit -> bool

(**
 * [reset_states_counter unit] reset the the map generation to the first
 * map such that future calls to [next_state] return the first map of the game.
 * returns: [unit]
 *)
val reset_states_counter : unit -> unit

val get_state_index : unit -> int

val get_current_state_ending : unit -> interface

val get_current_map_index : unit -> int