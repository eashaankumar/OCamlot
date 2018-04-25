
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
  offset:vector2d;
  bounds:bounds;
}

type sprite = {
  frames: animation_frame array;
  img: Html.imageElement Js.t;
  index: int;
  time_delay: float;
  curr_time: float;
}

(* requires: tower id be position in tower array in state *)
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

type movement = {
  start_tower : int ;
  end_tower : int ;
  mvmt_troops : int ;
  mvmt_sprite : sprite ;
  mvmt_team : allegiance ;
  progress : float
}

type effect

type skill_side =
  | Buff
  | Attack

type skill = {
  mana_cost : int ;
  effect : effect ;
  side : skill_side
}

type move = {
  mv_start : int ;
  mv_end : int ;
  mv_troops : int
}

type command =
  | Move of move
  | Skill of skill * tower

type mouse_state =
  | Pressed
  | Released
  | Moved

type input = {
  mouse_pos : vector2d;
  mouse_state : mouse_state;
}

(* UI *)
type color = {r:float;g:float;b:float}

type button_state =
  | Disabled
  | Neutral
  | Clicked

type button_property = {
  btn_state: button_state;
  btn_sprite: sprite;
}

type label_property = {
  text : string;
  color : color;
  font_size : float;
}

type ui_element = 
  | Button of button_property * vector2d * bounds
  | Label of label_property * vector2d * bounds
  | Panel of sprite * vector2d * bounds

type state = {
  towers : tower array ;
  num_towers : int ;
  player_score : int ;
  enemy_score : int ;
  movements : movement list ;
  player_mana : int ;
  enemy_mana : int;
}

type scene = {
  mutable state : state ;
  mutable ui : ui_element array;
  mutable input : input;
}

