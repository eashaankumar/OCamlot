open OCamlotUnit2
open Types
open Ai
open State

let troop_regen_speed = 1.

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
let tower_base_player = {
  twr_id = 0;
  twr_pos = {x=0.;y=0.};
  twr_size = {w=72.;h=136.} ;
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = 10.;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Player;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 10.; y = 5.};
  is_disabled = false
}

let tower_base_enemy = {
  twr_id = 1;
  twr_pos = {x=Renderer.width-.80.;y=Renderer.height-.136.};
  twr_size = {w=80.;h=136.} ;
  twr_sprite = Sprite.tower_base ;
  twr_troop_info = troop_foot_soldier;
  twr_troops = 10. ;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Enemy;
  selector_offset = {x=0.;y=100.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
  is_disabled = false
}

let root_state1 =
{
  towers = [| tower_base_player; tower_base_enemy;
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_foot_soldier;
      twr_troops = 10. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Enemy;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
    {
      twr_id = 3;
      twr_pos = {x=Renderer.width-.300.;y=Renderer.height-.200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_foot_soldier;
      twr_troops = 20. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Player;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
    {
      twr_id = 4;
      twr_pos = {x=600.;y=200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_foot_soldier;
      twr_troops = 30. ;
      twr_troops_max = 30.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Enemy;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
    {
      twr_id = 5;
      twr_pos = {x=Renderer.width-.600.;y=Renderer.height-.200.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_foot_soldier;
      twr_troops = 5. ;
      twr_troops_max = 30.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Player;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
    {
      twr_id = 6;
      twr_pos = {x=700.;y=100.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_cavalry;
      twr_troops = 15. ;
      twr_troops_max = 15.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Player;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
    {
      twr_id = 7;
      twr_pos = {x=Renderer.width-.700.;y=Renderer.height-.100.};
      twr_size = {w=72.;h=72.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troop_info = troop_cavalry;
      twr_troops = 0. ;
      twr_troops_max = 15.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
  |] ;
  num_towers = 8 ;
  player_score = 4 ;
  enemy_score = 3 ;
  movements = [] ;
  player_skill = None ;
  enemy_skill = None ;
  player_mana = 100. ;
  enemy_mana = 150. ;
}
let tree1_children = Array.map (fun cm -> 0)
(* let tree1 =  Node (root_state1, Null, 0., 0., [||], ref (Leaf(Null,1.)), true) *)

let ai = Ai.MCTS_AI.get_move

let tests = [
  "test0" >:: (fun _ -> assert_equal (0) (0))
]
