
type vector2d = {
  x:float;
  y:float
}

type bounds = {
  w:float;
  h:float
}

type allegiance =
  | Player
  | Enemy
  | Neutral

module Html = Dom_html

type animation_frame = {
  offset : vector2d;
  bounds : bounds
}

type sprite = {
  frames : animation_frame array;
  img : Html.imageElement Js.t;
  index : int;
  time_delay : float;
  curr_time : float
}

(* requires: tower id be position in tower array in state *)
type tower = {
  twr_id : int;
  twr_pos : vector2d;
  twr_size : bounds;
  twr_sprite : sprite;
  twr_troops : float;
  twr_troops_max : float;
  twr_troops_regen_speed : float;
  twr_team : allegiance;
  selector_offset : vector2d;
}

type movement = {
  start_tower : int;
  end_tower : int;
  mvmt_troops : int;
  mvmt_sprite : sprite;
  mvmt_team : allegiance;
  progress : float
}

type effect =
  | Stun of float (* An attack *)
  | Regen_incr of float (* A buff if > 1.0, an attack if < 1.0. *)
  | Kill of int

type skill_side =
  | Buff
  | Attack

type skill = {
  mana_cost : int ;
  effect : effect ;
  side : skill_side
}

type move = {
  mv_start : int;
  mv_end : int;
  mv_troops : int
}

type command =
  | Move of allegiance * int * int (* tuple of tower indices*)
  | Skill of allegiance * skill * int
  | Null

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
  | Disabled
  | Neutral
  | Depressed
  | Clicked



type label_property = {
  mutable text : string;
  mutable color : color;
  mutable font_size : int;
}

type button_property = {
  mutable btn_state: button_state;
  mutable btn_sprite: sprite;
  mutable btn_label: label_property;
  mutable btn_label_offset : vector2d;
}

type ui_element =
  | Button of button_property * vector2d * bounds * string option
  | Label of label_property * vector2d * bounds
  | Panel of sprite * vector2d * bounds

type state = {
  towers : tower array;
  num_towers : int;
  player_score : int;
  enemy_score : int;
  movements : movement list;
  player_mana : int;
  enemy_mana : int
}

type interface = (string * (ui_element ref)) list

type scene = {
  mutable name : string;
  mutable state : state ;
  mutable interface : interface;
  mutable input : input;
  mutable highlight_towers : int list;
  mutable next : string option;
  mutable background : sprite;
}
