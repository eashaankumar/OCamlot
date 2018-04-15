type vector2 = {
  x:float;
  y:float 
}

type bounds = {
  w:float;
  h:float
}

type sprite = int

type allegiance =
  | Player
  | Enemy
  | Neutral

(*Fill this out later*)
type image = int

type tower = {
  twr_id : int ;
  twr_pos : vector2;
  twr_size : bounds ;
  twr_sprite : image list ;
  twr_troops : int ;
  twr_troops_max : int;
  twr_team: allegiance
}

type movement = {
  start_tower : int ;
  end_tower : int ;
  mvmt_troops : int ;
  mvmt_sprite : image list ;
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

type state = {
  towers : tower array ;
  num_towers : int ;
  player_score : int ;
  enemy_score : int ;
  movements : movement list ;
  player_mana : int ;
  enemy_mana : int
}