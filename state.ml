open Types
open Sprite

type to_from = {
  mutable to_tower : int option;
  mutable from_tower : int option;
}

let destination = {to_tower = None; from_tower = None}

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
  {mvmt with
   progress = mvmt.progress +. (velocity *. delta)/.distance;
   mvmt_sprite = Sprite.tick mvmt.mvmt_sprite !Renderer.delta
  }

(**
 * [get_scores st] is a tuple containing the player score
      and the enemy score in that order.
   [st] - a valid state
 *)
let get_scores st =
  Array.fold_left ( fun (acc1,acc2) e ->
      match e.twr_team with
      | Player -> (acc1+1,acc2)
      | Enemy -> (acc1,acc2+1)
      | Neutral -> (acc1,acc2)
    )
    (0,0) st.towers


(****** Helpers ******)

let possible_commands st side =
  failwith "Not implemented"

(* Precondition: the command is correct, i.e.: player is not commanding the enemy.
   Assumes the amount of troops to be sent is positive.
*)
let new_state st (c : command) =
  match c with
  | Move (team,start,finish) -> begin
      let ts = st.towers.(start) in
      let ts_team_original = ts.twr_team in
      if ts_team_original = Neutral then (
        st
      ) else
        begin
          let mvmt_troop_count = ref 0 in
          (* Changing the starting tower *)
          let ts' =
            begin
              (*If you're keeping some of the same attributes of
                ts then you don't need to re-assign the values*)
              {ts with
                twr_troops =
                  begin
                    let half = int_of_float (ts.twr_troops /. 2.) in
                    mvmt_troop_count := half;
                    if half <= 0 then ts.twr_troops else
                    ts.twr_troops -. (float_of_int half)
                  end;
              }
            end in
          (* TODO Sprite is REALLY hard-coded. Change to troop sprite later *)
          let new_mvmt = new_movement
              start finish !mvmt_troop_count Sprite.troops_example_exprite ts_team_original in

          {st with
           towers = begin
             (*let new_towers = Array.copy st.towers in
              new_towers.(start) <- ts';
               new_towers*)
             st.towers.(start) <- ts';
             st.towers
            end;
            movements = new_mvmt::(st.movements)
          }
        end
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
(**)

(**
 * [update_troop_count tower] updates the troop count in [tower]
 * returns: new troop [count]
 *)
let update_troop_count tower =
  match tower.twr_team with
  | Neutral -> 0.
  | _ -> begin
      let dir = int_of_float tower.twr_troops - int_of_float tower.twr_troops_max in
      if dir = 0 then
        tower.twr_troops_max
      else if dir < 0 then
        tower.twr_troops +. tower.twr_troops_regen_speed *. !Renderer.delta
      else
        tower.twr_troops -. tower.twr_troops_regen_speed *. !Renderer.delta *. 2.
    end

let new_state_plus_delta st c d =
  let st' = new_state st c in
  let mvmts = List.map (fun m -> update_movement m d st) st'.movements in
  (* begin
    let rec mvmtlst l acc =
      match l with
      | [] -> acc
      | h::t -> mvmtlst t ((update_movement h d st)::acc) in
    mvmtlst st.movements []
  end in *)
  print_endline (string_of_int (List.length mvmts));
  let temp_state =
    {st' with
      towers = List.fold_left (fun acc e ->
        if e.progress <= 1. then acc
        else
          begin
            let te = acc.(e.end_tower) in
            let _ = (
            (* Updates troop counts and allegiance for completed ending movements *)
            match (e.mvmt_team, te.twr_team) with
            | (Enemy,Player) ->
              begin
                acc.(e.end_tower) <-
                  begin
                    let new_count = te.twr_troops -. float_of_int e.mvmt_troops in
                    let new_team = (
                      if int_of_float new_count = 0 then (Neutral:allegiance)
                      else if new_count < 0. then Enemy
                      else Player
                    ) in
                    {te with
                      twr_troops = if int_of_float new_count = 0 then 0. else
                          abs_float new_count;
                      twr_team = new_team;
                    }
                  end
              end
            | (Player,Enemy) -> begin
                acc.(e.end_tower) <-
                  let new_count = te.twr_troops -. float_of_int e.mvmt_troops in
                  let new_team = (
                    if int_of_float new_count = 0 then (Neutral:allegiance) else
                    if new_count < 0. then Player else Enemy
                  ) in
                  {te with
                  twr_troops = if int_of_float new_count = 0 then 0. else
                      abs_float new_count;
                  twr_team = new_team
                  }
              end
            | (team,_) -> begin
                  acc.(e.end_tower) <-
                    let new_count = te.twr_troops +. float_of_int e.mvmt_troops in
                    {te with
                    twr_troops = new_count;
                    twr_team = team
                    }
                end
            ) in acc
          end
      ) (Array.copy st.towers) mvmts;
    movements = List.filter (fun m -> m.progress < 1.) mvmts;
  } in
  let (pl_score, en_score) = get_scores temp_state in

  {temp_state with
    (* Update score and regenerated troops *)
    towers = begin
      Array.map (fun tower ->
        let new_tcount = update_troop_count tower in
        {tower with twr_troops = new_tcount}
      ) temp_state.towers
    end;
    player_score = pl_score;
    enemy_score = en_score
  }


let gameover st =
  st.player_score >= st.num_towers || st.enemy_score >= st.num_towers

(* Helpers for update *)
let update sc input =
  let command = ref Null in (* Dummy Command *)
  let updated_towers =
    begin
      Array.map (fun t ->
        (* Check if mouse is over this tower and pressed *)
        begin
          match input.mouse_state with
          (* Tower to be highlighted *)
          | Pressed ->
            begin
              if Physics.point_inside input.mouse_pos t.twr_pos t.twr_size then
                destination.from_tower <- Some t.twr_id;
                sc.highlight_towers <- t.twr_id::sc.highlight_towers
            end
          (* Remove towers from list *)
          | Released ->
            begin
              (* unhighlight all towers *)
              sc.highlight_towers <- [];
              (* End tower *)
              if Physics.point_inside input.mouse_pos t.twr_pos t.twr_size then
                destination.to_tower <- Some t.twr_id;
                (* Create new Command *)
                begin
                  match (destination.from_tower, destination.to_tower) with
                  | (Some(a),Some(b)) ->
                    begin
                      command := Move (Player, a,b);
                      (* Reset destination *)
                      destination.from_tower <- None;
                      destination.to_tower <- None
                    end
                  | _ -> ()
                end
            end
          | Moved -> ()
        end;
        (* Update troop sprite *)
        let new_twr_sprite = Sprite.tick t.twr_sprite !Renderer.delta in
        (* Update troop count *)
        (*let new_troop_count = update_troop_count t in*)
        (* Return updated tower *)
        {t with twr_sprite = new_twr_sprite;}
      ) sc.state.towers
    end in

    (* Return new state *)
    let state' = {sc.state with towers = updated_towers} in
    new_state_plus_delta state' !command !Renderer.delta
