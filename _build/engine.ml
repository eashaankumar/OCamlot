open State
 
type input = {
    left_mouse_down:bool
}

type properties = {
    twrs_neutral: (int * int) list;
    twr_player: (int * int);
    twr_enemy: (int * int);
    twr_neutral_size: (int * int);
    twr_base_size: (int * int);
    width:int;
    height:int
}

exception Init_Failure of string

let init_game prop : state = 
  print_endline "Starting game!";
  Graphics.set_window_title "Ocamlot";
  Graphics.open_graph "";
  Graphics.resize_window (prop.width) (prop.height);
  let tower_id = ref 0 in
  (* Create Neutral Towers *)
  let neutral_twr_array = begin
    List.fold_left (fun arr pos -> 
      let new_tower = {id = !tower_id;
                      pos = pos;
                      size = prop.twr_neutral_size;
                      twr_sprite = [];
                      twr_troops = 0;
                      twr_troops_max = 20;
                      twr_team = Neutral} in
      tower_id := !tower_id + 1;
      Array.append arr ([|new_tower|])
    ) [||] (prop.twrs_neutral)
  end in
  (* Create Enemy and Player towers *)
  let base_twr_array = [|{id = !tower_id;
                          pos = prop.twr_enemy;
                          size = prop.twr_base_size;
                          twr_sprite = [];
                          twr_troops = 0;
                          twr_troops_max = 50;
                          twr_team = Enemy};
                         {id = !tower_id + 1;
                          pos = prop.twr_player;
                          size = prop.twr_base_size;
                          twr_sprite = [];
                          twr_troops = 0;
                          twr_troops_max = 50;
                          twr_team = Player}|] in
  tower_id := !tower_id + 2;
  (* Create Init State *)
  {
    towers = Array.append neutral_twr_array base_twr_array;
    num_towers = !tower_id;
    player_score = 1;
    enemy_score = 1;
    movements = [];
    player_mana = 100;
    enemy_mana = 100
  }

let get_input () = 
  {left_mouse_down=Graphics.button_down ()}

let update ste inpt = 
  if inpt.left_mouse_down then (ste,false) else ste,true

let render st = 
  Graphics.auto_synchronize false;
  Graphics.clear_graph ();
  (* Render *)
  Array.iter (fun tower -> 
    let x_pos = (fst (tower.pos)) in
    let y_pos = (snd (tower.pos)) in
    let x_size = (fst (tower.size)) in
    let y_size = (snd (tower.size)) in
    let tc = begin
      match (tower.twr_team) with 
      | Player ->  [|0; 0; 255|]
      | Enemy -> [|255; 0; 0|]
      | Neutral -> [|100; 100; 100|]
    end in
    Graphics.set_color (Graphics.rgb tc.(0) tc.(1) tc.(2));
    Graphics.fill_rect x_pos y_pos x_size y_size;
  ) st.towers;
  (**********)
  Graphics.auto_synchronize true;
  ()

let rec game_loop ste run =
  if not run then ste 
  else begin
    let (new_ste, should_run) = update ste (get_input ()) in
    render ste;
    Unix.sleepf 0.01;
    game_loop new_ste should_run;
  end
  
let close_game ste = 
  Graphics.close_graph ();
  print_endline "Closing Game!";

;;

(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
let main () =
  let prop = {
    twrs_neutral=[(100,100);
            (200,200);
            (500,500);
            (550,550)];
    twr_player=(0, 0);
    twr_enemy=(750,550);
    twr_neutral_size = (16,16);
    twr_base_size = (20,20);
    width=800;
    height=600
  } in
  let init_state = init_game prop in
  let end_state = game_loop init_state true in
  close_game end_state;
;;

let () = main ()