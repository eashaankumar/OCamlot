open Types

let map_index = ref (-1)

let get_state_index () =
  !map_index

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
let base_tower id team pos : Types.tower =
  let troop_count =
  match team with
  | Player -> 1.
  | Enemy -> 10.
  | Neutral -> 0. in
  {
  twr_id = id;
  twr_pos = pos;
  twr_size = {w=72.;h=136.} ;
  twr_sprite = Sprite.tower_base;
  twr_troop_info = troop_foot_soldier;
  twr_troops = troop_count;
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
let tower_mini id team pos =
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=56.;h=56.} ;
    twr_sprite = Sprite.tower_type1 ;
    twr_troop_info = troop_foot_soldier;
    twr_troops = 0. ;
    twr_troops_max = 20.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = team;
    selector_offset = {x=0.;y=40.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(**
 * [tower_medium id pos] creates a tower of 30 foot soldiers.
 * returns: [tower]
 *)
let tower_medium id team pos =
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=72.;h=72.} ;
    twr_sprite = Sprite.tower_type1 ;
    twr_troop_info = troop_foot_soldier;
    twr_troops = 0. ;
    twr_troops_max = 30.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = team;
    selector_offset = {x=0.;y=50.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(**
 * [tower_medium id pos] creates a tower of 15 cavalry soldiers.
 * returns: [tower]
 *)
let tower_cavalry id team pos =
  {
    twr_id = id;
    twr_pos = pos;
    twr_size = {w=72.;h=72.} ;
    twr_sprite = Sprite.tower_type2 ;
    twr_troop_info = troop_cavalry;
    twr_troops = 0. ;
    twr_troops_max = 15.;
    twr_troops_regen_speed = troop_regen_speed;
    twr_team = team;
    selector_offset = {x=0.;y=50.};
    count_label_offset = {x = 0.; y = (-1.) *. 10.};
    is_disabled = false
  }

(* Initialize maps *)
let map1 =
  {
    towers = [|
      base_tower 0 Player {x=61.;y=334.};
      base_tower 1 Enemy {x=1015.;y=338.};
      tower_mini 2 Neutral {x=312.;y=204.};
      tower_mini 3 Neutral {x=721.;y=204.};
      tower_mini 4 Neutral {x=325.;y=535.};
      tower_mini 5 Neutral {x=757.;y=527.};
    |] ;
    num_towers = 6 ;
    player_score = 0 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "More ruins to take over";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=332.;y=382.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map2 =
  {
    towers = [|
      base_tower 0 Player {x=49.;y=487.};
      base_tower 1 Enemy {x=989.;y=114.};
      tower_mini 2 Neutral {x=257.;y=259.};
      tower_mini 3 Neutral {x=540.;y=91.};
      tower_mini 4 Neutral {x=395.;y=516.};
      tower_mini 5 Neutral {x=672.;y=505.};
      tower_mini 2 Neutral {x=807.;y=373.};
      tower_mini 3 Neutral {x=661.;y=244.};
      tower_mini 4 Neutral {x=492.;y=320.};
      tower_mini 5 Neutral {x=541.;y=387.};
    |] ;
    num_towers = 6 ;
    player_score = 6 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "Bigger is better";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=422.;y=355.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map3 =
  {
    towers = [|
      base_tower 0 Player {x=996.;y=276.};
      base_tower 1 Enemy {x=76.;y=275.};
      tower_mini 2 Neutral {x=829.;y=141.};
      tower_mini 3 Neutral {x=718.;y=335.};
      tower_mini 4 Neutral {x=883.;y=579.};
      tower_mini 5 Neutral {x=222.;y=169.};
      tower_mini 2 Neutral {x=311.;y=315.};
      tower_mini 3 Neutral {x=263.;y=522.};
      tower_medium 4 Neutral {x=536.;y=289.};
    |] ;
    num_towers = 6 ;
    player_score = 6 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "A powerful ruler defends ALL";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=297.;y=339.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map4 =
  {
    towers = [|
      base_tower 0 Player {x=980.;y=517.};
      base_tower 1 Enemy {x=51.;y=53.};
      tower_medium 2 Neutral {x=236.;y=153.};
      tower_medium 3 Neutral {x=130.;y=323.};
      tower_medium 4 Neutral {x=205.;y=491.};
      tower_medium 5 Neutral {x=380.;y=606.};
      tower_medium 2 Neutral {x=376.;y=336.};
      tower_medium 3 Neutral {x=656.;y=121.};
      tower_medium 4 Neutral {x=770.;y=239.};
      tower_medium 4 Neutral {x=786.;y=415.};
      tower_medium 4 Neutral {x=707.;y=552.};
      tower_medium 4 Neutral {x=568.;y=178.};
    |] ;
    num_towers = 6 ;
    player_score = 6 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "Need more horsepower...";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=350.;y=339.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map5 =
  {
    towers = [|
      base_tower 0 Player {x=0.;y=50.};
      base_tower 1 Enemy {x= Renderer.width -.72.;y= Renderer.height -. 136.};
      tower_mini 2 Neutral {x=300.;y=200.};
      tower_mini 3 Neutral {x=Renderer.width-.300.;y=Renderer.height-.200.};
      tower_medium 4 Neutral {x=600.;y=200.};
      tower_medium 5 Neutral {x=Renderer.width-.600.;y=Renderer.height-.200.};
      tower_cavalry 6 Neutral {x=554.;y=374.};
    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "Rulers are saddled with the lives of their people";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=106.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map6 =
  {
    towers = [|
      base_tower 0 Player {x=435.;y=45.};
      base_tower 1 Enemy {x=450.;y=494.};
      tower_medium 2 Player {x=135.;y=114.};
      tower_medium 3 Player {x=316.;y=192.};
      tower_medium 4 Player {x=565.;y=202.};
      tower_medium 5 Player {x=880.;y=91.};
      tower_medium 6 Enemy {x=108.;y=547.};
      tower_medium 6 Enemy {x=385.;y=486.};
      tower_medium 6 Enemy {x=580.;y=478.};
      tower_medium 6 Enemy {x=857.;y=574.};
      tower_cavalry 0 Neutral {x=169.;y=311.};
      tower_cavalry 0 Neutral {x=365.;y=386.};
      tower_cavalry 0 Neutral {x=655.;y=315.};
      tower_cavalry 0 Neutral {x=868.;y=356.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("difficulty_label", ref
      (
        Label (
          {
            text = "There are many paths to victory";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=270.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map7 =
  {
    towers = [|
      base_tower 0 Player {x=60.;y=55.};
      base_tower 1 Enemy {x=1019.;y=511.};
      tower_mini 2 Neutral {x=73.;y=405.};
      tower_mini 3 Neutral {x=241.;y=227.};
      tower_mini 6 Neutral {x=912.;y=562.};
      tower_mini 0 Neutral {x=690.;y=628.};
      tower_medium 0 Player {x=Renderer.width/.2. -.30.;y=Renderer.height/.2. -. 20.};
      tower_cavalry 0 Neutral {x=283.;y=141.};
      tower_cavalry 0 Neutral {x=634.;y=549.};
      tower_cavalry 0 Neutral {x=890.;y=396.};
      tower_cavalry 0 Neutral {x=408.;y=72.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("", ref
      (
        Label (
          {
            text = "How difficult is it to be a ruler?";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=270.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
    ("", ref
      (
        Label (
          {
            text = "IT'S OVER NINE-THOUSAND";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=290.; y = 477.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map8 =
  {
    towers = [|
      base_tower 0 Enemy {x=67.;y=205.};
      base_tower 1 Player {x=772.;y=538.};
      base_tower 0 Enemy {x=245.;y=41.};
      base_tower 1 Player {x=1000.;y=374.};
      tower_mini 2 Neutral {x=103.;y=157.};
      tower_cavalry 3 Neutral {x=149.;y=115.};
      tower_cavalry 6 Neutral {x=329.;y=292.};
      tower_mini 6 Neutral {x=363.;y=246.};
      tower_cavalry 2 Neutral {x=928.;y=600.};
      tower_cavalry 6 Neutral {x=835.;y=494.};
      tower_mini 6 Neutral {x=908.;y=433.};
      tower_medium 0 Neutral {x=433.;y=433.};
      tower_medium 0 Neutral {x=529.;y=329.};
      tower_cavalry 0 Neutral {x=688.;y=109.};
      tower_medium 0 Neutral {x=524.;y=600.};
    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("", ref
      (
        Label (
          {
            text = "Never give up!";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=423.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map9 =
  {
    towers = [|
      base_tower 0 Player {x=71.;y=87.};
      base_tower 1 Player {x=162.;y=187.};
      base_tower 0 Player {x=112.;y=340.};
      base_tower 0 Enemy {x=915.;y=249.};
      base_tower 1 Enemy {x=970.;y=79.};
      base_tower 1 Enemy {x=835.;y=387.};
      tower_mini 2 Neutral {x=300.;y=287.};
      tower_mini 4 Neutral {x=431.;y=141.};
      tower_mini 5 Neutral {x=632.;y=89.};
      tower_cavalry 0 Neutral {x=492.;y=282.};
      tower_cavalry 0 Neutral {x=711.;y=275.};
      tower_cavalry 0 Neutral {x=488.;y=488.};
      tower_medium 0 Neutral {x=593.;y=344.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("", ref
      (
        Label (
          {
            text = "You will be remembered";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=353.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let map10 =
  {
    towers = [|
      tower_mini 2 Player {x=148.;y=221.};
      tower_mini 5 Neutral {x=312.;y=221.};
      tower_mini 6 Neutral {x=312.;y=332.5};
      tower_mini 6 Neutral {x=230.;y=325.};
      tower_mini 0 Neutral {x=312.;y=414.};
      tower_mini 3 Neutral {x=148.;y=416.};

      tower_mini 5 Neutral {x=444.;y=221.};
      tower_mini 6 Neutral {x=444.;y=332.5};
      tower_mini 0 Neutral {x=444.;y=414.};

      tower_mini 5 Neutral {x=586.;y=221.};
      tower_mini 6 Neutral {x=586.;y=332.5};
      tower_mini 0 Neutral {x=586.;y=414.};

      tower_mini 4 Neutral {x=836.;y=221.};
      tower_mini 6 Neutral {x=748.;y=325.};
      tower_mini 6 Neutral {x=912.;y=325.};
      tower_mini 0 Enemy {x=836.;y=415.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  },
  [
    ("", ref
      (
        Label (
          {
            text = "A Winner is You!";
            color = {r=255;g=255;b=255;a=1.};
            font_size = 25;
          },
          {x=393.; y = 407.},
          {w=800.;h=70.};
        )
      )
    );
  ]

let fix_map (st,int) =
  let total_towers = Array.length st.towers in
  let player_towers = ref 0 in
  let enemy_towers = ref 0 in
  let id = ref (-1) in
  let new_towers =
  Array.fold_left (fun acc t ->
    let _ = (
      match t.twr_team with
      | Neutral -> ()
      | Player -> player_towers := !player_towers + 1;
      | Enemy -> enemy_towers := !enemy_towers + 1;
    ) in
    id := !id + 1;
    Array.append acc [|{t with twr_id = !id}|]
  ) [||] st.towers in
  {
    towers = new_towers;
    num_towers = total_towers;
    player_score = !player_towers;
    enemy_score = !enemy_towers;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 50. ;
    enemy_mana = 50. ;
  }, int

let maps = [|
  fix_map map1;
  fix_map map2;
  fix_map map3;
  fix_map map4;
  fix_map map5;
  fix_map map6;
  fix_map map7;
  fix_map map8;
  fix_map map9;
  fix_map map10;
|]

let next_state () =
  map_index := !map_index + 1;
  fst (maps.(!map_index))

let get_current_state_ending () =
  snd (maps.(!map_index))

let all_states_completed () =
  !map_index >= (Array.length maps) - 1

let reset_states_counter () =
  map_index := -1

let get_current_map_index () =
  !map_index
