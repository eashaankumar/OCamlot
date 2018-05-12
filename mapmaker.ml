open Types

let map_index = ref (-1)

(* Base values *)
let troop_regen_speed = 1.

(* Troops *)
let troop_foot_soldier = {
  trp_type = Foot;
  trp_damage = 1.;
  trp_speed = 50.;
}

let troop_cavalry = {
  trp_type = Cavalry;
  trp_damage = 2.;
  trp_speed = 100.;
}

(* Intialize tower types *)
(**
 * [base_tower id team pos] generates a base tower with given arguments
 * returns: [tower]
 *)
let base_tower id team pos = 
  {
  twr_id = id;
  twr_pos = pos;
  twr_size = {w=72.;h=136.} ;
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = 1.;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = team;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = 
    begin
      match team with
      | Player -> {x = 10.; y = 5.}
      | Enemy -> {x = 0.; y = (-1.) *. 10.}
      | _ -> {x=0.;y=0.}
    end;
  is_disabled = false
  }

(**
 * [tower_mini id pos] creates a tower of 20 foot soldiers.
 * returns: [tower]
 *)
let tower_mini id pos = 
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=56.;h=56.} ;
    twr_sprite = Sprite.tower_type1 ;
    twr_troop_info = troop_foot_soldier;
    twr_troops = 0. ;
    twr_troops_max = 20.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = Neutral;
    selector_offset = {x=0.;y=40.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(**
 * [tower_medium id pos] creates a tower of 30 foot soldiers.
 * returns: [tower]
 *)
let tower_medium id pos = 
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=72.;h=72.} ;
    twr_sprite = Sprite.tower_type1 ;
    twr_troop_info = troop_foot_soldier;
    twr_troops = 0. ;
    twr_troops_max = 30.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = Neutral;
    selector_offset = {x=0.;y=50.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(**
 * [tower_medium id pos] creates a tower of 15 cavalry soldiers.
 * returns: [tower]
 *)
let tower_cavalry id pos = 
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=72.;h=72.} ;
    twr_sprite = Sprite.tower_type2 ;
    twr_troop_info = troop_cavalry;
    twr_troops = 0. ;
    twr_troops_max = 15.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = Neutral;
    selector_offset = {x=0.;y=50.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(* Initialize states *)
let maps = [|
(* MAP 1*)
{
  towers = [| 
    base_tower 0 Player {x=0.;y=50.}; 
    base_tower 1 Enemy {x= Renderer.width -.72.;y= Renderer.height -. 136.};
    tower_mini 2 {x=300.;y=200.};
    tower_mini 3 {x=Renderer.width-.300.;y=Renderer.height-.200.};
    tower_medium 4 {x=600.;y=200.};
    tower_medium 5 {x=Renderer.width-.600.;y=Renderer.height-.200.};
    tower_cavalry 6 {x=700.;y=100.};
    tower_cavalry 7 {x=Renderer.width-.700.;y=Renderer.height-.100.};
  |] ;
  num_towers = 8 ;
  player_score = 1 ;
  enemy_score = 1 ;
  movements = [] ;
  player_skill = None ;
  enemy_skill = None ;
  player_mana = 0. ;
  enemy_mana = 0. ;
};
(* MAP 2 *)
{
  towers = [| 
    base_tower 0 Player {x=0.;y=136.}; 
    base_tower 0 Enemy {x= Renderer.width -.72.;y= Renderer.height -. 136.};
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=50.;h=85.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_foot_soldier;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
  |] ;
  num_towers = 0 ;
  player_score = 1 ;
  enemy_score = 1 ;
  movements = [] ;
  player_skill = None ;
  enemy_skill = None;
  player_mana = 0. ;
  enemy_mana = 0. ;
};
|]

let next_state () =
  map_index := !map_index + 1;
  maps.(!map_index)

let all_states_completed () =
  !map_index >= (Array.length maps) - 1

let reset_states_counter () =
  map_index := -1
