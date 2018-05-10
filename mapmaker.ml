open Types

let map_index = ref (-1)

(* Base values *)
let troop_regen_speed = 1.

(* Intialize tower types *)
let tower_base_player = {
  twr_id = 0;
  twr_pos = {x=0.;y=0.};
  twr_size = {w=72.;h=136.} ;
  twr_sprite = Sprite.tower_base;
  twr_troops = 1.;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Player;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 10.; y = 5.};
}

let tower_base_enemy = {
  twr_id = 1;
  twr_pos = {x=Renderer.width-.80.;y=Renderer.height-.136.};
  twr_size = {w=80.;h=136.} ;
  twr_sprite = Sprite.tower_base ;
  twr_troops = 10. ;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Enemy;
  selector_offset = {x=0.;y=100.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
}

(* Initialize states *)
let maps = [|
(* MAP 1*)
{
  towers = [| tower_base_player; tower_base_enemy;
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
    };
    {
      twr_id = 3;
      twr_pos = {x=Renderer.width-.300.;y=Renderer.height-.200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
    };
    {
      twr_id = 4;
      twr_pos = {x=600.;y=200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 30.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
    };
    {
      twr_id = 5;
      twr_pos = {x=Renderer.width-.600.;y=Renderer.height-.200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 30.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
    };
  |] ;
  num_towers = 0 ;
  player_score = 1 ;
  enemy_score = 1 ;
  movements = [] ;
  skills = [];
  player_mana = 0 ;
  enemy_mana = 0;
};
(* MAP 2 *)
{
  towers = [| tower_base_player; tower_base_enemy;
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=50.;h=85.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
    };
  |] ;
  num_towers = 0 ;
  player_score = 1 ;
  enemy_score = 1 ;
  movements = [] ;
  skills = [];
  player_mana = 0 ;
  enemy_mana = 0;
};
|]

let next_state () =
  map_index := !map_index + 1;
  maps.(!map_index)

let all_states_completed () =
  !map_index >= (Array.length maps) - 1

let reset_states_counter () =
  map_index := -1
