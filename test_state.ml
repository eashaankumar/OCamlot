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
  speed = 100.;
}

let helper_tests = [
  "@1" >:: (fun _ -> assert_equal [] ([1;2] @ [3; 4]
            |> List.filter (fun v -> v <> 1 && v <> 2 && v <> 3 && v <> 4)));
  "@2" >:: (fun _ -> assert_equal 4 ([1;2]@[3;4] |> List.length));
  "@3" >:: (fun _ -> assert_equal true
               (List.for_all (fun v -> 5 > v && 0 < v) ([1;2]@[3;4])));
  (* "new_mvmt1" >:: (fun _ -> assert_equal ) *)
]

let state_tests = [

]

let tests = List.flatten [
    helper_tests;
    state_tests
]
