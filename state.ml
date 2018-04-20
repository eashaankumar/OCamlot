open Types

type to_from = {
  to_tower : int option;
  from_tower : int option;
}

let destination = ref {to_tower = None; from_tower = None}

(****** Helpers ******)

let possible_moves st side =
  failwith "Not implemented"

let new_state st c =
  failwith "Not implemented"

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
