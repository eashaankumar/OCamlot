
(* [allegiance] denotes which side owns troop movements and towers.
   There are two categories in allegiance, one for each side
*)
type allegiance

(* [tower] contains information about its id, positiion, sprite image,
   number of troops, and current allegiance/team.
*)
type tower

(* [movement] contains all the information of the following:
   - [sprite]
   - start tower, a [tower]
   - end tower, a [tower]
   - number of troops
   - [allegiance] of the troops
 *)
type movement

(* [state] will contain the following information
   - All towers in the match
   - Number of towers to dominate needed to win the match
   - Some way of keeping track of score for both players
   - Keeps track of all troop movements
*)
type state

(* [move] contains information regarding a move that a player
   can make. Contains two [tower] instances which denote the
   start and end locations of the move
*)
type move

(* [possible_moves] is a list of [move] instances which
   denotes all of the moves that a player with a given
   allegiance can make at the time of the function call.
   Requires: Inputs include [state] and [allegiance].
*)
val possible_moves : state -> allegiance-> move list
