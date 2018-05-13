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
      tower_medium 4 Neutral {x=325.;y=535.};
      tower_medium 5 Neutral {x=757.;y=527.};
    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 0. ;
    enemy_mana = 0. ;
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
    player_mana = 0. ;
    enemy_mana = 0. ;
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
    player_mana = 0. ;
    enemy_mana = 0. ;
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
    player_mana = 0. ;
    enemy_mana = 0. ;
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
    player_mana = 0. ;
    enemy_mana = 0. ;
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
    player_mana = 0. ;
    enemy_mana = 0. ;
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
      tower_mini 4 Neutral {x=527.;y=126.};
      tower_mini 5 Neutral {x=703.;y=124.};
      tower_mini 6 Neutral {x=855.;y=174.};
      tower_mini 6 Neutral {x=967.;y=281.};
      tower_mini 6 Neutral {x=983.;y=417.};
      tower_mini 6 Neutral {x=912.;y=562.};
      tower_mini 0 Neutral {x=690.;y=628.};
      tower_mini 0 Neutral {x=387.;y=588.};
      tower_medium 0 Player {x=165.;y=351.};
      tower_medium 0 Player {x=346.;y=205.};
      tower_medium 0 Player {x=374.;y=329.};
      tower_medium 0 Enemy {x=839.;y=605.};
      tower_medium 0 Enemy {x=945.;y=501.};
      tower_medium 0 Enemy {x=780.;y=491.};
      tower_cavalry 0 Neutral {x=123.;y=296.};
      tower_cavalry 0 Neutral {x=283.;y=141.};
      tower_cavalry 0 Neutral {x=634.;y=549.};
      tower_cavalry 0 Neutral {x=890.;y=396.};
      tower_cavalry 0 Neutral {x=408.;y=72.};
      tower_cavalry 0 Neutral {x=813.;y=66.};
      tower_cavalry 0 Neutral {x=779.;y=272.};
      tower_cavalry 0 Neutral {x=523.;y=289.};
      tower_cavalry 0 Neutral {x=168.;y=594.};
      tower_cavalry 0 Neutral {x=452.;y=488.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 0. ;
    enemy_mana = 0. ;
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
      tower_mini 4 Neutral {x=151.;y=482.};
      tower_mini 5 Neutral {x=212.;y=404.};
      tower_mini 6 Neutral {x=264.;y=358.};
      tower_cavalry 6 Neutral {x=329.;y=292.};
      tower_mini 6 Neutral {x=363.;y=246.};
      tower_mini 6 Neutral {x=496.;y=125.};
      tower_mini 0 Neutral {x=251.;y=450.};
      tower_mini 0 Neutral {x=477.;y=243.};
      tower_cavalry 2 Neutral {x=928.;y=600.};
      tower_mini 3 Neutral {x=1021.;y=555.};
      tower_mini 4 Neutral {x=716.;y=278.};
      tower_mini 5 Neutral {x=771.;y=486.};
      tower_cavalry 6 Neutral {x=835.;y=494.};
      tower_mini 6 Neutral {x=908.;y=433.};
      tower_mini 6 Neutral {x=963.;y=269.};
      tower_mini 6 Neutral {x=1041.;y=238.};
      tower_cavalry 0 Neutral {x=664.;y=539.};
      tower_mini 0 Neutral {x=902.;y=363.};
      tower_medium 0 Neutral {x=201.;y=559.};
      tower_cavalry 0 Neutral {x=364.;y=540.};
      tower_medium 0 Neutral {x=433.;y=433.};
      tower_medium 0 Neutral {x=529.;y=329.};
      tower_cavalry 0 Neutral {x=688.;y=109.};
      tower_medium 0 Neutral {x=524.;y=600.};
      tower_medium 0 Neutral {x=679.;y=437.};
      tower_cavalry 0 Neutral {x=810.;y=299.};
      tower_medium 0 Neutral {x=920.;y=200.};
      tower_medium 0 Neutral {x=899.;y=98.};

    |] ;
    num_towers = 8 ;
    player_score = 8 ;
    enemy_score = 0 ;
    movements = [] ;
    player_skill = None ;
    enemy_skill = None ;
    player_mana = 0. ;
    enemy_mana = 0. ;
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

let maps = [|
  map8
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
