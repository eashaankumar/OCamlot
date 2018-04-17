
type vector2 = {
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
  offset:vector2;
  bounds:bounds;
}

type sprite = {
  frames: animation_frame array;
  img: Html.imageElement Js.t;
  index: int;
  time_delay: float;
  curr_time: float;
}

type tower = {
  twr_id : int ;
  twr_pos : vector2;
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
  mouse_pos : vector2;
  mouse_state : mouse_state;
  prev_state : mouse_state;
}

type state = {
  towers : tower array ;
  num_towers : int ;
  player_score : int ;
  enemy_score : int ;
  movements : movement list ;
  player_mana : int ;
  enemy_mana : int;
}