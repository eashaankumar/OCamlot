(* [tower] contains information about its id, positiion, sprite image,
   number of troops, and current allegiance/team.
*)
type tower

(* sprite, start tower, end tower, number of troops in the movement, allegiance,
 *)
type movement

(* [state] will contain the following information
   - All towers in the match
   - Number of towers to dominate needed to win the match
   - Some way of keeping track of score for both players
   - Keeps track of all troop movements
*)
type state
