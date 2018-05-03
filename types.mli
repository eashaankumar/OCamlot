module Html = Dom_html

(* Represents the x-y coordinate plane. *)
type vector2d = {
  x : float;
  y : float
}

(* represents a rectangle denoting the boundary of an entity. *)
type bounds = {
  w : float;
  h : float
}

(* represents the box (or frame) surrounding an animation. *)
type animation_frame = {
  offset : vector2d;
  bounds : bounds
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
  curr_time: float
}

(* [allegiance] denotes which side owns troop movements and towers.
*)
type allegiance =
  | Player
  | Enemy
  | Neutral

(* [tower] contains information about its id, positiion, bounds, sprite image,
   number of troops, maximum number of troops, troop regeneration speed,
   and current allegiance/team.
*)
type tower = {
  twr_id : int ;
  twr_pos : vector2d;
  twr_size : bounds ;
  twr_sprite : sprite;
  twr_troops : float ;
  twr_troops_max : float;
  twr_troops_regen_speed : float;
  twr_team: allegiance;
  selector_offset : vector2d;
}

(* [movement] represents the sending of troops, with some progress towards
   its final destintion.
 *)
  type movement = {
  start_tower : int;
  end_tower : int;
  mvmt_troops : int;
  mvmt_sprite : sprite;
  mvmt_team : allegiance;
  progress : float
  }

(* represents the state of the mouse.
*)
type mouse_state =
  | Pressed
  | Released
  | Moved

(* represents the player's input *)
type input = {
  mouse_pos : vector2d;
  mouse_state : mouse_state;
}

(* represents a digitized display of color basedo n the RGB scheme. *)
type color = {r : int; g : int; b : int}

(* Whether it is clicked, not allowed to be clicked, or waiting to be clicked. *)
type button_state =
  | Disabled (* 2 *)
  | Neutral (* 0 *)
  | Clicked (* 1 *)

(* represents the properties of a button *)
type button_property = {
  mutable btn_state: button_state;
  mutable btn_sprite: sprite;
}

(* represents the properties of a label *)
type label_property = {
  mutable text : string;
  mutable color : color;
  mutable font_size : int;
}

(** [ui_element] represents user interface elements
 * that the player can interact with using the mouse.
 *)
type ui_element =
 | Button of button_property * vector2d * bounds
 | Label of label_property * vector2d * bounds
 | Panel of sprite * vector2d * bounds

(* [state] contains all the information about the game's mechanics.
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

(* A collection of ui_elements *)
type interface = (string * (ui_element ref)) list

(* represents everything representable on the screen, including state
*)
type scene = {
  mutable state : state ;
  mutable interface : interface;
  mutable input : input;
  mutable highlight_towers : int list;
  mutable next : string option;
}

(* represents the effect of a skill *)
type effect =
  | Stun of float (* An attack *)
  | Regen_incr of float (* A buff if > 1.0, an attack if < 1.0. *)
  | Kill of int

(* represents whether the one applying the skill benefits
   directly from the skill (buff) or indirectly by somehow
   harming the opponent (attack)
*)
type skill_side =
  | Buff
  | Attack

(*
[skill] contains information about how much mana a skill
comsumes, what it does, and the type of benefit the skill provides.
*)
type skill = {
  mana_cost : int ;
  effect : effect ;
  side : skill_side
}

(* a command is either applying a skill to a tower or a move from one tower
  to another.
*)
type command =
  | Move of allegiance * int * int
  | Skill of allegiance * skill * int
  | Null
