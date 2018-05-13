open Types
open State
open OUnit2

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

let base_init_troop_count = 10.

let base_max = 100.

let mini_max = 30.

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

let base_player_tower = {
  twr_id = 0;
  twr_pos = {x = 0.; y = 50.};
  twr_size = {w=72.;h=136.};
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = base_init_troop_count;
  twr_troops_max = base_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Player;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 10.; y = 5.};
  is_disabled = false
}

(* A copy used for immutability tests to compare against original *)
let base_player_tower_copy = {
  twr_id = 0;
  twr_pos = {x = 0.; y = 50.};
  twr_size = {w=72.;h=136.};
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = base_init_troop_count;
  twr_troops_max = base_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Player;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 10.; y = 5.};
  is_disabled = false
}

let neutral_mini_cavalry = {
  twr_id = 1;
  twr_pos = {x = 300.; y = 200.};
  twr_size = {w = 56.; h = 56.};
  twr_sprite = Sprite.tower_type1;
  twr_troop_info = troop_cavalry;
  twr_troops = 0.;
  twr_troops_max = mini_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Neutral;
  selector_offset = {x = 0.; y = 40.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
  is_disabled = false
}

(* A copy used for immutability tests *)
let neutral_mini_cavalry_copy = {
  twr_id = 1;
  twr_pos = {x = 300.; y = 200.};
  twr_size = {w = 56.; h = 56.};
  twr_sprite = Sprite.tower_type1;
  twr_troop_info = troop_cavalry;
  twr_troops = 0.;
  twr_troops_max = mini_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Neutral;
  selector_offset = {x = 0.; y = 40.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
  is_disabled = false
}

let base_enemy_tower = {
  twr_id = 2;
  twr_pos = {x= Renderer.width -.72.;y= Renderer.height -. 136.};
  twr_size = {w = 72.; h = 136.};
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = base_init_troop_count;
  twr_troops_max = base_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Enemy;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
  is_disabled = false
}

(* A copy used for immutability tests to compare against original *)
let base_enemy_tower_copy = {
  twr_id = 2;
  twr_pos = {x= Renderer.width -.72.;y= Renderer.height -. 136.};
  twr_size = {w = 72.; h = 136.};
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = base_init_troop_count;
  twr_troops_max = base_max;
  twr_troops_regen_speed = init_troop_regen_speed;
  twr_team = Enemy;
  selector_offset = {x = 0.; y = 100.};
  count_label_offset = {x = 0.; y = (-1.) *. 10.};
  is_disabled = false
}

let init_state : state = {
  towers = [|base_player_tower; neutral_mini_cavalry; base_enemy_tower|];
  num_towers = 3;
  player_score = 1;
  enemy_score = 1;
  movements = [];
  player_skill = None;
  enemy_skill = None;
  player_mana = 0.;
  enemy_mana = 0.;
}

(* A copy used for immutability tests *)
let init_state_copy : state = {
  towers = [|base_player_tower_copy; neutral_mini_cavalry_copy;
             base_enemy_tower_copy|];
  num_towers = 3;
  player_score = 1;
  enemy_score = 1;
  movements = [];
  player_skill = None;
  enemy_skill = None;
  player_mana = 0.;
  enemy_mana = 0.;
}

let init_stun_from_player_valid = {
  allegiance = Player;
  mana_cost = 0;
  effect = Stun 5.;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 7.};
  tower_id = 2;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let init_stun_from_enemy_valid = {
  allegiance = Enemy;
  mana_cost = 0;
  effect = Stun 5.;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 7.};
  tower_id = 0;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let init_kill_from_player_valid = {
  allegiance = Player;
  mana_cost = 0;
  effect = Kill 5;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 5.};
  tower_id = 2;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 2.}
}

let init_kill_from_enemy_valid = {
  allegiance = Enemy;
  mana_cost = 0;
  effect = Kill 5;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 5.};
  tower_id = 0;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 2.}
}

let init_reg_from_player_valid1 = {
  allegiance = Player;
  mana_cost = 0;
  effect = Regen_incr 1.25;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 40.};
  tower_id = 0;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let init_reg_from_enemy_valid1 = {
  allegiance = Enemy;
  mana_cost = 0;
  effect = Regen_incr 1.25;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 40.};
  tower_id = 2;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let init_reg_from_player_valid2 = {
  allegiance = Player;
  mana_cost = 0;
  effect = Regen_incr 0.8;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 40.};
  tower_id = 2;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let init_reg_from_enemy_valid2 = {
  allegiance = Enemy;
  mana_cost = 0;
  effect = Regen_incr 0.8;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 40.};
  tower_id = 0;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

(* A fake time delta to produce test cases *)
let delta = 0.1

let helper_tests = [
  "new_mvmt" >:: (fun _ -> assert_equal init_movement12
                     (new_movement 1 2 5 Sprite.blue_troop1_right Player 1. 50.));
]

let state_tests = [
  (* This section of state tests will assert the immutability of a previous
     state after creating a new one from that previous state. *)
  "immtbl_axiom" >:: (fun _ -> assert_equal init_state init_state_copy);
  "pssbl_immtbl1" >:: (fun _ -> assert_equal init_state
          (ignore (possible_commands init_state_copy Player); init_state_copy));
  "pssbl_immtbl2" >:: (fun _ -> assert_equal init_state
          (ignore (possible_commands init_state_copy Enemy); init_state_copy));
  "nst_immtbl1" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy (Move (Player, 0, 1)));
                         init_state_copy));
  "nst_immtbl2" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy (Move (Player, 0, 2)));
                         init_state_copy));
  "nst_immtbl3" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy (Move (Enemy, 2, 1)));
                         init_state_copy));
  "nst_immtbl4" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy (Move (Enemy, 2, 0)));
                         init_state_copy));
  "nst_immtbl5" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_stun_from_player_valid));
                         init_state_copy));
  "nst_immtbl9" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_stun_from_enemy_valid));
                         init_state_copy));
  "nst_immtbl6" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_kill_from_player_valid));
                         init_state_copy));
  "nst_immtbl10" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_kill_from_enemy_valid));
                         init_state_copy));
  "nst_immtbl7" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_reg_from_player_valid1));
                         init_state_copy));
  "nst_immtbl11" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_reg_from_enemy_valid1));
                         init_state_copy));
  "nst_immtbl8" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_reg_from_player_valid2));
                         init_state_copy));
  "nst_immtbl12" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state init_state_copy
                                   (Skill init_reg_from_enemy_valid2));
                         init_state_copy));
  "nspd_immtbl1" >:: (fun _ -> assert_equal init_state
                         (ignore (new_state_plus_delta init_state_copy
                                    (Move (Player, 0, 1)) delta);
                          init_state_copy));
  "nspd_immtbl2" >:: (fun _ -> assert_equal init_state
                         (ignore (new_state_plus_delta init_state_copy
                                    (Move (Player, 0, 2)) delta);
                          init_state_copy));
  "nspd_immtbl3" >:: (fun _ -> assert_equal init_state
                         (ignore (new_state_plus_delta init_state_copy
                                    (Move (Enemy, 2, 1)) delta);
                          init_state_copy));
  "nspd_immtbl4" >:: (fun _ -> assert_equal init_state
                         (ignore (new_state_plus_delta init_state_copy
                                    (Move (Enemy, 2, 0)) delta);
                          init_state_copy));
  "nspd_immtbl5" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_stun_from_player_valid) delta);
                         init_state_copy));
  "nspd_immtbl6" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_kill_from_player_valid) delta);
                         init_state_copy));
  "nspd_immtbl7" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_reg_from_player_valid1) delta);
                         init_state_copy));
  "nspd_immtbl8" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_reg_from_player_valid2) delta);
                         init_state_copy));
  "nspd_immtbl9" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_stun_from_enemy_valid) delta);
                         init_state_copy));
  "nspd_immtbl10" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_kill_from_enemy_valid) delta);
                         init_state_copy));
  "nspd_immtbl11" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_reg_from_enemy_valid1) delta);
                         init_state_copy));
  "nspd_immtbl12" >:: (fun _ -> assert_equal init_state
                        (ignore (new_state_plus_delta init_state_copy
                                   (Skill init_reg_from_enemy_valid2) delta);
                         init_state_copy));

  (* TODO: test_state is not running tests *)
  "testing" >:: (fun _ -> assert_equal   (print_endline ("Hi"); true) false);

]

let tests = List.flatten [
    helper_tests;
    state_tests
  ]

let alltests = "State test suite" >::: tests

let _ = run_test_tt_main alltests
