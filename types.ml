
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

type ui_state = 
  | Disabled of sprite
  | Neutral of sprite
  | Clicked of sprite

let get_uistate_sprite ui_state = 
  match ui_state with
  | Disabled (s) -> s
  | Neutral (s) -> s
  | Clicked (s) -> s

type label_property = {
  text : string;
  color : color;
  font_size : float;
}

type ui_element = 
 | Button of ui_state * vector2d * bounds
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
  (* user interface *)
  ui_elements : ui_element array;
}
