type vector2 = {
  x:float;
  y:float 
}

type bounds = {
  w:float;
  h:float
}

(**
 * [sprite] represents an animation sequence for an entity. It contains all
 * information necessary for identifying the correct animation image.
 *)
type sprite = int

(* [allegiance] denotes which side owns troop movements and towers.
   There are two categories in allegiance, one for each side
*)
type allegiance =
  | Player
  | Enemy
  | Neutral
  
(* Fill this out later *)
type image = int

(* [tower] contains information about its id, positiion, sprite image,
   number of troops, and current allegiance/team.
*)
type tower = {
  twr_id : int ;
  twr_pos : vector2;
  twr_size : bounds;
  twr_sprite : image list ;
  twr_troops : int ;
  twr_troops_max : int;
  twr_team: allegiance
}

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
type state = {
  towers : tower array ;
  num_towers : int ;
  player_score : int ;
  enemy_score : int ;
  movements : movement list ;
  player_mana : int ;
  enemy_mana : int
}

(* [move] contains information regarding a move that a player
   can make. Contains two [tower] instances which denote the
   start and end locations of the move
*)
type move

(*
[skill] contains information about how much mana a skill
comsumes and what it does (to be determined later).
It should have whether it's a buff or and attack.
*)
type skill

(*Either applying a skill to a tower or a move*)
type command