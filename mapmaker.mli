(* This module is responsible for creating new maps and returning them in order 
of difficulty. Engine relies on this module to get the next state. *)

open Types

(**
 * [next_state unit] is responsible for getting the next state for
 * the next match.
 * returns: next [state]
 *)
val next_state : unit -> state
