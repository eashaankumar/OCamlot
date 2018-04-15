open Types

(****** Helpers ******)

let possible_moves st side =
  failwith "Not implemented"

let new_state st c =
  failwith "Not implemented"

let new_state_plus_delta st c d =
  failwith "Not implemented"

let update st =
  (* Housekeeping *)
  {
    towers = st.towers;
    num_towers = st.num_towers;
    player_score = st.player_score;
    enemy_score = st.enemy_mana;
    movements = st.movements;
    player_mana = st.player_mana;
    enemy_mana = st.enemy_mana;
  }
