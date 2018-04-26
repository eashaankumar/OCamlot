open Types

type to_from = {
  to_tower : int option;
  from_tower : int option;
}

let destination = ref {to_tower = None; from_tower = None}

(****** Helpers ******)

let possible_moves st side =
  failwith "Not implemented"

(* Precondition: the command is correct, i.e.: player is not commanding the enemy.
   Assumes the amount of troops to be sent is positive.
*)
let new_state st c =
  match c with
  | Move {mv_start = start; mv_end = finish; mv_troops = amount} -> begin
      let ts = st.towers.(start) in
      let te = st.towers.(finish) in
      let ts_team_original = ts.twr_team in
      let te_team_original = te.twr_team in
      let player_score = ref st.player_score in
      let enemy_score = ref st.enemy_score in
      if ts_team_original = Neutral
      then failwith "Cannot move from a neutral tower!"
      else
      let amount = float_of_int amount in
      let ts' =
        begin
          let cur_team = ref ts.twr_team in
          {
            twr_id = ts.twr_id;
            twr_pos = ts.twr_pos;
            twr_size = ts.twr_size;
            twr_sprite = ts.twr_sprite;
            twr_troops_max = ts.twr_troops_max;
            twr_troops_regen_speed = ts.twr_troops_regen_speed;
            twr_troops = begin
              let net = ts.twr_troops -. amount in
              if net <= 0.
              then let _ = cur_team := Neutral in
                let _ = if ts_team_original = Player
                  then player_score := !player_score - 1
                  else enemy_score := !enemy_score - 1
                in 0.
              else net
            end;
            twr_team = !cur_team
          }
        end in
      let te' =
        begin
          let cur_team = ref te.twr_team in
          {
            twr_id = te.twr_id;
            twr_pos = te.twr_pos;
            twr_size = te.twr_size;
            twr_sprite = te.twr_sprite;
            twr_troops_max = te.twr_troops_max;
            twr_troops_regen_speed = te.twr_troops_regen_speed;
            twr_troops = begin
              match te.twr_team with
              | Neutral -> let _ = cur_team := ts_team_original in amount
              | Player -> begin
                  match ts_team_original with
                  | Neutral -> failwith "Cannot move from neutral tower!"
                  | Player -> te.twr_troops +. amount
                  | Enemy -> begin
                      let net = te.twr_troops -. amount in
                      let _ =
                        if net < 0.
                        then cur_team := Enemy
                        else if net = 0. then cur_team := Neutral
                        else ()
                      in net
                  end
                end
              | Enemy -> begin
                  match ts_team_original with
                  | Neutral -> failwith "Cannot move from a neutral tower!"
                  | Enemy -> te.twr_troops +. amount
                  | Player -> begin
                      let net = te.twr_troops -. amount in
                      let _ =
                        if net < 0.
                        then cur_team := Player
                        else if net = 0. then cur_team := Neutral
                        else ()
                      in net
                    end
                end
            end;
            twr_team = !cur_team
          }
        end in
      {
        towers = begin
          let _ = st.towers.(start) <- ts' in
          let _ = st.towers.(finish) <- te' in
          st.towers
        end;
        num_towers = st.num_towers;
        player_mana = st.player_mana;
        enemy_mana = st.enemy_mana;
        player_score = begin
          if ts_team_original = ts'.twr_team
          then if te
        end;
        enemy_score = begin

        end;
        movements = begin

        end
      }
  end
  | Skill ({mana_cost = mp; effect; side}, tower) ->

let new_state_plus_delta st c d =
  failwith "Not implemented"

let gameover st =
  failwith "Not implemented"

(**
 * [update_troop_count tower] updates the troop count in [tower]
 * returns: new troop [count]
 *)
let update_troop_count tower =
  let troops = (
    tower.twr_troops +. tower.twr_troops_regen_speed *. !Renderer.delta
  ) in
  if troops > tower.twr_troops_max then tower.twr_troops_max
  else if troops < 0. then 0.
  else troops

let update st input =
  (* Sprite towers *)
  let updated_twrs = begin
    Array.map (fun tower ->
      let new_twr_sprite = Sprite.tick tower.twr_sprite !Renderer.delta in
      let new_troop_count = update_troop_count tower in
      {
        twr_id = tower.twr_id;
        twr_pos = tower.twr_pos;
        twr_size = tower.twr_size ;
        twr_sprite = new_twr_sprite;
        twr_troops = new_troop_count ;
        twr_troops_max = tower.twr_troops_max;
        twr_troops_regen_speed = tower.twr_troops_regen_speed;
        twr_team = tower.twr_team
      }
    ) st.towers
  end in
  (* TEST: Print out input *)
  (*let _ = print_mouse_input input in*)

  {
    towers = updated_twrs;
    num_towers = st.num_towers;
    player_score = st.player_score;
    enemy_score = st.enemy_mana;
    movements = st.movements;
    player_mana = st.player_mana;
    enemy_mana = st.enemy_mana;
  }
