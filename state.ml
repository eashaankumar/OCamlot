open Types
open Sprite

type to_from = {
  to_tower : int option;
  from_tower : int option;
}

let destination = ref {to_tower = None; from_tower = None}

let new_movement ts_index te_index troops sprite side = {
  start_tower = ts_index;
  end_tower  = te_index;
  mvmt_troops = troops;
  mvmt_sprite = sprite;
  mvmt_team = side;
  progress = 0.
}

(*[update_movement] takes in a movement, [mvmt], a
  time step, [delta], and a state [st], and progresses the movement according
  to the speed of the troops and the distance from one tower
  to the next*)
let update_movement mvmt delta st =
  let ts_index = mvmt.start_tower in
  let te_index = mvmt.end_tower in
  let ts = st.towers.(ts_index) in
  let te = st.towers.(te_index) in
  let start_vector = ts.twr_pos in
  let end_vector = te.twr_pos in
  let distance = sqrt ((start_vector.x -. end_vector.x)**2. +.
                       (start_vector.y -. end_vector.y)**2.) in
  (*TODO make velocity not hard-coded*)
  let velocity = 100. in
  {mvmt with progress = mvmt.progress +. (velocity *. delta)/.distance}

(****** Helpers ******)

let possible_commands st side =
  failwith "Not implemented"

(* Precondition: the command is correct, i.e.: player is not commanding the enemy.
   Assumes the amount of troops to be sent is positive.
*)
let new_state st (c:command) =
  match c with
  | Move (team,start,finish) -> begin
      let ts = st.towers.(start) in
      let te = st.towers.(finish) in
      let ts_team_original = ts.twr_team in
      let te_team_original = te.twr_team in
      let player_score = ref st.player_score in
      let enemy_score = ref st.enemy_score in
      if ts_team_original = Neutral
      (* this failwith statement will probably exit the game *)
      then st
      else

      let mvmt_troop_count = ref 0 in
      (* Changing the starting tower *)
      let ts' =
        begin
          (*If you're keeping some of the same attributes of
            ts then you don't need to re-assign the values*)
          { ts with
            twr_sprite = ts.twr_sprite;
            twr_troops = begin
              let half = int_of_float (ts.twr_troops/.2.) in
              if half <= 0 then ts.twr_troops else
              let net = ts.twr_troops -. float_of_int half in
              mvmt_troop_count := half;
              net
            end;
          }
        end in

      (* Changing the ending tower *)
      (*let te' =
        begin
          let cur_team = ref te.twr_team in
          {te with
            twr_sprite = te.twr_sprite;
            twr_troops = begin
              match te.twr_team with
              | Neutral -> cur_team := ts_team_original; 0.
              | Player -> begin
                  match ts_team_original with
                  | Neutral -> te.twr_troops
                  | Player -> te.twr_troops +. 0.
                  | Enemy -> begin
                      let net = te.twr_troops -. 0. in
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
                  | Enemy -> te.twr_troops +. 0.
                  | Player -> begin
                      let net = te.twr_troops -. 0. in
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

        end in (* end of te' code *)*)

      (* TODO Sprite is REALLY hard-coded. Change to troop sprite later *)
      let new_mvmt = new_movement
          start finish !mvmt_troop_count Sprite.tower_base ts_team_original in

      { st with
        towers = begin
          let new_towers = Array.copy st.towers in
          new_towers.(start) <- ts';
          new_towers
        end;
        movements = new_mvmt::(st.movements)
      }
    end
  | Skill (team,{mana_cost = mp; effect; side}, tower) -> begin
      let has_enough_mana =
        match team with
        | Neutral -> false (*should fail*)
        | Player -> st.player_mana >= mp
        | Enemy -> st.enemy_mana >= mp in
      if not has_enough_mana then
        st
      else
        let new_towers = Array.copy st.towers in
        let tower_team = new_towers.(tower).twr_team in
        match side with
        | Buff -> begin
            if team <> tower_team then
              st
            else
              match effect with
              | Kill n -> st (*should fail*)
              | Regen_incr f -> st
              | Stun s -> st (*should fail*)
          end
        | Attack -> begin
            if team = tower_team then
              st
            else
              match effect with
              | Kill n -> begin
                  {st with
                   towers = begin
                     let new_troop_count =
                       max 0. st.towers.(tower).twr_troops -. float_of_int n in
                    new_towers.(tower) <-
                      {st.towers.(tower) with
                       twr_troops =
                         new_troop_count;
                      twr_team = begin
                        if new_troop_count = 0. then
                          Neutral
                        else
                          st.towers.(tower).twr_team
                      end};
                    new_towers
                  end
                  }
              end
              | Regen_incr f -> st
              | Stun s -> st
          end
    end
    | Null -> st

let new_state_plus_delta st c d =
  let mvmts = begin
    let rec mvmtlst l acc =
      match l with
      | [] -> acc
      | h::t -> mvmtlst t ((update_movement h !Renderer.delta st)::acc) in
    mvmtlst st.movements []
  end in
  { (new_state st c) with
    (* towers = Array.mapi (fun i t -> ) st.towers *)
    movements = List.filter (fun m -> m.progress < 1.) mvmts;
  }


let gameover st =
  failwith "Not implemented"

(**
 * [update_troop_count tower] updates the troop count in [tower]
 * returns: new troop [count]
 *)
let update_troop_count tower =
  (*let troops = (
    tower.twr_troops +. tower.twr_troops_regen_speed *. !Renderer.delta
  ) in
  if troops > tower.twr_troops_max then tower.twr_troops -. tower.twr_troops_regen_speed *. !Renderer.delta
  else if troops < 0. then 0.
  else troops*)
  let dir = int_of_float tower.twr_troops - int_of_float tower.twr_troops_max in
  if dir = 0 then
    tower.twr_troops_max
  else if tower.twr_troops < tower.twr_troops_max then
    tower.twr_troops +. tower.twr_troops_regen_speed *. !Renderer.delta
  else
    tower.twr_troops -. tower.twr_troops_regen_speed *. !Renderer.delta

let update sc input =
  (* Sprite towers *)
  let updated_twrs = begin
    Array.map (fun t ->
      (* Check if mouse is over this tower and pressed *)
      let _ = begin
        match input.mouse_state with
        (* Tower to be highlighted *)
        | Pressed ->
          begin
            if Physics.point_inside input.mouse_pos t.twr_pos t.twr_size then
              sc.highlight_towers <- t.twr_id::sc.highlight_towers ;
              ()
          end
        (* Remove towers from list *)
        | Released ->
          begin
            if List.mem t.twr_id sc.highlight_towers then
              sc.highlight_towers <- begin
                List.fold_left (fun acc tid ->
                  if tid = t.twr_id then acc
                  else tid::acc
                ) [] sc.highlight_towers
              end;
            ()
          end
        | Moved -> ()
      end in

      let new_twr_sprite = Sprite.tick t.twr_sprite !Renderer.delta in
      let new_troop_count = update_troop_count t in
      {
        twr_id = t.twr_id;
        twr_pos = t.twr_pos;
        twr_size = t.twr_size ;
        twr_sprite = new_twr_sprite;
        twr_troops = new_troop_count ;
        twr_troops_max = t.twr_troops_max;
        twr_troops_regen_speed = t.twr_troops_regen_speed;
        twr_team = t.twr_team;
        selector_offset = t.selector_offset;
      }
    ) sc.state.towers
  end in
  (* TEST: Print out input *)
  (*let _ = print_mouse_input input in*)

  {
    towers = updated_twrs;
    num_towers = sc.state.num_towers;
    player_score = sc.state.player_score;
    enemy_score = sc.state.enemy_mana;
    movements = sc.state.movements;
    player_mana = sc.state.player_mana;
    enemy_mana = sc.state.enemy_mana;
  }
