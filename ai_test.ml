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

let root_state0 =
  {
    towers = [| tower_base_player; tower_base_enemy |] ;
    num_towers = 2 ;
    player_score = 1 ;
    enemy_score = 1 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 100. ;
    enemy_mana = 150. ;
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
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = troop_regen_speed;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
      count_label_offset = {x = 0.; y = (-1.) *. 10.};
      is_disabled = false
    };
  |] ;
  num_towers = 3 ;
  player_score = 1 ;
  enemy_score = 1 ;
  movements = [] ;
  player_skill = None ;
  enemy_skill = None ;
  player_mana = 100. ;
  enemy_mana = 150. ;
}

let root_state2 =
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

let tree0_children = Array.map (fun cm -> ref (Leaf (cm,100.)))
    (State.possible_commands root_state0 Enemy)
let tree0_0 =
  Node (root_state0, Null, 0., 1., tree0_children, ref (Leaf(Null,1.)), true)
let tree0_0_helper =
  Node (root_state0, Null, 0., 1., tree0_children, ref (tree0_0), true)

let tree0_1 =
  Node (root_state0, Null, 0., 17., tree0_children, ref (Leaf(Null,1.)), true)
let tree0_1_helper =
  Node (root_state0, Null, 0.91, 3., tree0_children, ref (tree0_1), true)

let tree0_2 =
  Node (root_state0, Null, 0., 3000., tree0_children, ref (Leaf(Null,1.)), true)
let tree0_2_helper =
  Node (root_state0, Null, 0.672, 1000., tree0_children, ref (tree0_2), true)


let tree1_children = Array.map (fun cm -> ref (Leaf (cm,1.)))
    (State.possible_commands root_state1 Enemy)
let tree1_helper =
  (Node (root_state0, Null, 0., 10000., tree0_children, ref (tree0_0), true))

let tree1_0 =  Node (root_state0, Null, 0.53135, 10000.,
 [|
   ref (Node (root_state0, Null, 0.203, 1000., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.672, 1500., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.358, 2000., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.511, 2500., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.703, 3000., tree0_children, ref (tree1_helper), true));
 |]
, ref (Leaf(Null,1.)), true)

let tree1_1 =  Node (root_state0, Null, 0.44615, 10000.,
 [|
   ref (Node (root_state0, Null, 0.503, 1000., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.112, 1500., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.702, 2000., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.111, 2500., tree0_children, ref (tree1_helper), true));
   ref (Node (root_state0, Null, 0.703, 3000., tree0_children, ref (tree1_helper), true));
 |]
, ref (Leaf(Null,1.)), true)

let tree2_children = Array.map (fun cm -> ref (Leaf (cm,1.)))
    (State.possible_commands root_state2 Enemy)
let tree0 =  Node (root_state0, Null, 0., 0., tree0_children, ref (Leaf(Null,1.)), true)
let tree1 =  Node (root_state1, Null, 0., 0., tree1_children, ref (Leaf(Null,1.)), true)
let tree2 =  Node (root_state2, Null, 0., 0., tree2_children, ref (Leaf(Null,1.)), true)



let tests = [
  "random_moves_0" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state0 Enemy)
      (State.possible_commands root_state0 Enemy)) ;

  "random_moves_1" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state0 Player)
      (State.possible_commands root_state0 Player)) ;

  "random_moves_2" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state1 Enemy)
      (State.possible_commands root_state1 Enemy)) ;

  "random_moves_3" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state1 Player)
      (State.possible_commands root_state1 Player)) ;

  "random_moves_4" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state2 Enemy)
      (State.possible_commands root_state2 Enemy)) ;

  "random_moves_5" >::
  (fun _ -> Array.mem
      (Ai.get_random_command root_state2 Player)
      (State.possible_commands root_state2 Player)) ;

  (***********************************************)

  "random_playout_0" >::
  (fun _ -> (Ai.random_playout root_state0 true) <= 1.0) ;
  "random_playout_1" >::
  (fun _ -> (Ai.random_playout root_state0 false) <= 1.0) ;
  "random_playout_2" >::
  (fun _ -> (Ai.random_playout root_state1 true) <= 1.0) ;
  "random_playout_3" >::
  (fun _ -> (Ai.random_playout root_state1 false) <= 1.0) ;
  "random_playout_4" >::
  (fun _ -> (Ai.random_playout root_state2 true) <= 1.0) ;
  "random_playout_5" >::
  (fun _ -> (Ai.random_playout root_state2 false) <= 1.0) ;

  (*************************************************)

  "get_value_0" >::
  (fun _ -> (Ai.get_value (tree0_0_helper) true) -. (0.) < 0.00001) ;
  "get_value_1" >::
  (fun _ -> (Ai.get_value (tree0_0_helper) false) -. (1.) < 0.00001) ;
  "get_value_2" >::
  (fun _ -> (Ai.get_value (tree0_1_helper) true) -. (1.88180473) < 0.00001) ;
  "get_value_3" >::
  (fun _ -> (Ai.get_value (tree0_1_helper) false) -. (1.0618047) < 0.00001) ;
  "get_value_4" >::
  (fun _ -> (Ai.get_value (tree0_2_helper) true) -. (0.76147830) < 0.00001) ;
  "get_value_5" >::
  (fun _ -> (Ai.get_value (tree0_2_helper) false) -. (0.41747830) < 0.00001) ;

  (**************************************************)

  "get_extreme_child_0" >::
  (fun _ -> ( Ai.get_extreme_child (ref tree1_0) true) =
            (ref (Node (root_state0, Null, 0.703, 3000.,
                        tree0_children, ref (tree1_helper), true)))) ;
  "get_extreme_child_1" >::
  (fun _ -> ( Ai.get_extreme_child (ref tree1_0) false) =
            (ref (Node (root_state0, Null, 0.203, 1000.,
                        tree0_children, ref (tree1_helper), true)))) ;
  "get_extreme_child_2" >::
  (fun _ -> ( Ai.get_extreme_child (ref tree1_1) true) =
            (ref (Node (root_state0, Null, 0.702, 2000.,
                        tree0_children, ref (tree1_helper), true)))) ;
  "get_extreme_child_3" >::
  (fun _ -> ( Ai.get_extreme_child (ref tree1_1) false) =
            (ref (Node (root_state0, Null, 0.112, 1500.,
                        tree0_children, ref (tree1_helper), true)))) ;

  (***************************************************)

  "new_node_0" >::
  (fun _ -> Ai.new_node (ref (Leaf (Null,1.))) Null = ref (Leaf (Null,1.))) ;


  (* "new_node_1" >::
  (fun _ -> Ai.new_node (ref tree0) (Move (Enemy,1,0)) =
            ref (Node (State.new_state_plus_delta root_state0 (Move (Enemy,1,0))
                         Ai.delta, Move(Enemy,1,0), 0., 0., tree0_children, ref (tree0), false))) ; *)

  (***************************************************)

  "update_tree_0" >::
  (fun _ -> (true)) ;

  (***************************************************)

  "beginning_node_0" >::
  (fun _ -> !(Ai.beginning_node root_state0) = tree0) ;
  "beginning_node_1" >::
  (fun _ -> !(Ai.beginning_node root_state1) = tree1) ;
  "beginning_node_2" >::
  (fun _ -> !(Ai.beginning_node root_state2) = tree2) ;

]
