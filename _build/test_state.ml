open Types
open State
open OUnit2

(* For troop sprite, always use blue1 right or red1 right. *)


(* initial player movement of 5 troops with 100. speed and no progress
   going from tower 1 to tower 2.
*)
let init_movement12 : movement = {
  start_tower = 1;
  end_tower = 2;
  mvmt_troops = 5;
  mvmt_sprite = Sprite.blue_troop1_right;
  mvmt_team = Player;
  progress = 0.;
  damage = 1.;
  speed = 50.;
}

let init_troop_regen_speed = 1.

(* let init_troop *)

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

let base_player = {
  twr_id = 0;
  twr_pos = {x = 0.; y = 50.};
  twr_size = {w=72.;h=136.};
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = 10.;
  twr_troops_max = 100.;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Player;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 10.; y = 5.};
  is_disabled = false
}

let init_state : state = {
  towers = [| |];
  num_towers = 3;
  player_score = 0;
  enemy_score = 0;
  movements = [];
  player_skill = None;
  enemy_skill = None;
  player_mana = 0.;
  enemy_mana = 0.;
}

let helper_tests = [
  "new_mvmt" >:: (fun _ -> assert_equal init_movement12
                     (new_movement 1 2 5 Sprite.blue_troop1_right Player 1. 50.));

]

let state_tests = [

]

let tests = List.flatten [
    helper_tests;
    state_tests
]
