open State
 
type input = {
    left_mouse_down:bool
}

type properties = {
    towers: (int * int) list;
    width:int;
    height:int
}

exception Init_Failure of string

let init_game prop : state = 
  print_endline "Starting game!";
  Graphics.set_window_title "Ocamlot";
  Graphics.open_graph "";
  Graphics.resize_window (prop.width) (prop.height);
  (* Create Towers *)
  let tower_array = begin
    List.fold_left (fun arr pos -> 
      let new_tower = {id = Array.length arr;
                      pos = pos;
                      twr_sprite = [];
                      twr_troops = 0;
                      twr_troops_max = 20;
                      twr_team = Neutral} in
      Array.append arr ([|new_tower|])
    ) [||] (prop.towers)
  end in
  (* Create Init State *)
  {
    towers = tower_array;
    num_towers = Array.length tower_array;
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

    match (tower.twr_team) with
    | Player -> Graphics.set_color (Graphics.rgb 0 0 255)
    | Enemy -> Graphics.set_color (Graphics.rgb 255 0 0)
    | Neutral -> Graphics.set_color (Graphics.rgb 100 100 100)
    ;
    Graphics.fill_rect x_pos y_pos 10 10;
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
    towers=[(100,100);
            (200,200);
            (500,500);
            (550,550)];
    width=800;
    height=600
  } in
  let init_state = init_game prop in
  let end_state = game_loop init_state true in
  close_game end_state;
;;

let () = main ()