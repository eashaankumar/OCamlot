module Html = Dom_html

type vector2d = {
  x:float;
  y:float
}

type bounds = {
  w:float;
  h:float
}

type animation_frame = {
  offset:vector2d;
  bounds:bounds;
}

(**
 * [sprite] represents an animation sequence for an entity. It contains all
 * information necessary for identifying the correct animation image.
 *)
type sprite = {
  frames: animation_frame array;
  img: Html.imageElement Js.t;
  index: int;
  time_delay: float;
  curr_time: float;
}

(* [allegiance] denotes which side owns troop movements and towers.
   There are two categories in allegiance, one for each side
*)
type allegiance =
  | Player
  | Enemy
  | Neutral

(* [tower] contains information about its id, positiion, sprite image,
   number of troops, and current allegiance/team.
*)
type tower = {
  twr_id : int ;
  twr_pos : vector2d;
  twr_size : bounds ;
  twr_sprite : sprite;
  twr_troops : float ;
  twr_troops_max : float;
  twr_troops_regen_speed : float;
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

type mouse_state =
  | Pressed
  | Released
  | Moved

type input = {
  mouse_pos : vector2d;
  mouse_state : mouse_state;
}

 (* UI *)
type color = {r:int;g:int;b:int}

type button_state =
  | Disabled (* 2 *)
  | Neutral (* 0 *)
  | Clicked (* 1 *)


type button_property = {
  btn_state: button_state;
  btn_sprite: sprite;
}

type label_property = {
  text : string;
  color : color;
  font_size : int;
}
(** [ui_element] represents user interface elements
 * that the player can interact with using the mouse.
 *)
type ui_element = 
 | Button of button_property * vector2d * bounds
 | Label of label_property * vector2d * bounds
 | Panel of sprite * vector2d * bounds

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
  enemy_mana : int;
}

type interface = (string * ui_element) list

type scene = {
  mutable state : state ;
  mutable interface : interface;
  mutable input : input;
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
