
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
  mutable twr_troops_regen_speed : float;
  twr_team : allegiance;
  selector_offset : vector2d;
  count_label_offset : vector2d;
  mutable is_disabled : bool
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
  | Stun of float(* An attack *)
  | Regen_incr of float (* A buff if > 1.0, an attack if < 1.0. *)
  | Kill of int

type timer = {
  curr_time : float;
  speed : float;
  limit : float;
}

type skill = {
  allegiance : allegiance;
  mana_cost : int ;
  effect : effect ;
  regen_timer : timer;
  tower_id : int;
  sprite: sprite;
  anim_timer : timer;
}

type move = {
  mv_start : int;
  mv_end : int;
  mv_troops : int
}

type command =
  | Move of allegiance * int * int (* tuple of tower indices*)
  | Skill of skill
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
type color = {r : int; g : int; b : int; a : float}

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

type spell_box_state =
  | Neutral
  | Selected (* Depressed *)
  | Regenerating
  | Disabled

type spell_box_property = {
  mutable spell_box_state : spell_box_state;
  mutable spell_box_sprite : sprite;
  mutable spell_box_front_image : sprite option;
  mutable spell_box_front_image_offset : vector2d;
}

type ui_element =
  | Button of button_property * vector2d * bounds * string option
  | Label of label_property * vector2d * bounds
  | Panel of sprite * vector2d * bounds
  | SpellBox of spell_box_property * vector2d * bounds * skill

type state = {
  towers : tower array;
  num_towers : int;
  player_score : int;
  enemy_score : int;
  movements : movement list;
  player_skill : skill option;
  player_mana : int;
  enemy_mana : int
}

type interface = (string * (ui_element ref)) list

(* Transitions *)
type task =
| Wait of float * float
| FadeIn of float * float * float
| Update
| FadeOut of float * float * float
| SwitchScene of string


type scene = {
  mutable name : string;
  mutable tasks : task list;
  mutable state : state ;
  mutable interface : interface;
  mutable input : input;
  mutable highlight_towers : int list;
  mutable next : string option;
  mutable background : sprite;
}

type difficulty =
  | Easy
  | Medium
  | Hard
