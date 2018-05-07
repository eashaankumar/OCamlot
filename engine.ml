open Types
open Ai

module Html = Dom_html
let js = Js.string
let document = Html.document

(* Intialize tower types *)
let tower_base_player = {
  twr_id = 0;
  twr_pos = {x=0.;y=0.};
  twr_size = {w=80.;h=136.} ;
  twr_sprite = Sprite.tower_base;
  twr_troops = 20.;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Player;
  selector_offset = {x = 0.; y = 80.};
}

let tower_base_enemy = {
  twr_id = 1;
  twr_pos = {x=Renderer.width-.80.;y=Renderer.height-.136.};
  twr_size = {w=80.;h=136.} ;
  twr_sprite = Sprite.tower_base ;
  twr_troops = 30. ;
  twr_troops_max = 50.;
  twr_troops_regen_speed = 1.;
  twr_team = Enemy;
  selector_offset = {x=0.;y=80.};
}

(* Initialize states *)
let init_state = {
  towers = [| tower_base_player; tower_base_enemy;
    (* Neutral *)
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=50.;h=85.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
    };
    (*  *)
    {
      twr_id = 3;
      twr_pos = {x=Renderer.width-.300.;y=Renderer.height-.200.};
      twr_size = {w=50.;h=85.} ;
      twr_sprite = Sprite.tower_type1 ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral;
      selector_offset = {x=0.;y=50.};
    };
  |] ;
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_mana = 0 ;
  enemy_mana = 0;
}

(* Generic empty state *)
let empty_state = {
  towers = [||];
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_mana = 0 ;
  enemy_mana = 0;
}

(* Initialize input *)
let init_input = {
  mouse_pos = {x=0.;y=0.};
  mouse_state = Moved;
}

(* Initialize scenes *)
let game_scene = {
  name = "Game";
  state = init_state;
  interface = [("fps",ref Ui.fps_label);
               ];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let game_over_scene = {
  name = "Game Over";
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("game_over",ref Ui.gameover_label)];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let intro_scene = {
  name = "Intro";
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("start",ref (
                 Button ({btn_state = Neutral; btn_sprite = Sprite.menu_btn_sprite1; 
                          btn_label = {
                            text = "Start"; color = {r=0; g=0; b=0}; font_size = 30
                          }; btn_label_offset = {x=50.;y=30./.2. +. 70./.2.};
                                                                 },
                           {x=Renderer.width /. 2. -. 100.;y= 300.},
                           {w=200.;h=70.},
                           Some "Game")
               ));];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let scene_dict = [
  (intro_scene.name, intro_scene);
  (game_scene.name, game_scene);
  (game_over_scene.name, game_over_scene);
]

let current_scene = ref intro_scene

(* Pref mouse state *)
let prev_mouse_state = ref Moved

(* TODO: Figure out how to get canvas from document *)
let canvas = ref ( Html.createCanvas document )

(****** Helpers ******)
let print_mouse_input () =
  (*print_string ((string_of_float input.mouse_pos.x)^" "^(string_of_float input.mouse_pos.y)^" ");*)
  let scene = !current_scene in
  match scene.input.mouse_state with
  | Pressed -> "Pressed "
  | Released -> "Released "
  | Moved -> "Moved "^(string_of_float !Renderer.delta)

let calculate_mouse_pos (event:Dom_html.mouseEvent Js.t) =
  let rect = (!canvas)##getBoundingClientRect () in
  let x = event##clientX - int_of_float rect##left in
  let y = event##clientY - int_of_float rect##top in
  {x=float_of_int x;y= float_of_int y}

let enforce_one_frame_mouse () =
  print_endline (print_mouse_input ());
  let scene = !current_scene in
  let new_mouse_state = begin
    match !prev_mouse_state with
    | Pressed -> begin
      match scene.input.mouse_state with
      | Pressed -> Moved
      | Moved -> Moved
      | Released -> Released
      end
    | Moved -> begin
        match scene.input.mouse_state with
        | Pressed -> Pressed
        | Moved -> Moved
        | Released -> Released
      end
    | Released -> begin
        match scene.input.mouse_state with
        | Pressed -> Pressed
        | Moved -> Moved
        | Released -> Moved
      end
  end in
  prev_mouse_state := scene.input.mouse_state;
  {mouse_pos = scene.input.mouse_pos; mouse_state = new_mouse_state}

(*********************)

let get_html_element id =
  Js.Opt.get (document##getElementById (js id)) (fun _ -> assert false)

(*let key_pressed event =
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" pressed")
  in Js._true

let key_released event =
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" released")
  in Js._true*)

let mouse_pressed (event:Dom_html.mouseEvent Js.t) =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Pressed;};
  current_scene := scene;
  Js._true

let mouse_released event =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Released;};
  current_scene := scene;
  Js._true

let mouse_move event =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Moved;};
  current_scene := scene;
  Js._true

(**
 * [scene_transition scid] transitions [current_scene] to [next] scene.
 * returns: [unit]
 * effects: [current_scene]
 *)
let scene_transition scid =
  let _ =
    begin
      match scid with
      | None -> ()
      | Some(nxt) ->
        begin
          let next_scene = List.assoc nxt scene_dict in
          current_scene := next_scene;
          ()
        end
    end in
  ()

let game_loop context running =
  let start = Sys.time () in
  let cm = Ai.MCTS_AI.get_move (!current_scene.state) in
  let finish = Sys.time () in
  print_endline (string_of_float (finish -. start));
  let (b,c) =
    match cm with
    | Move (x,y,z) -> (y,z)
    | _ -> (-1,-1) in
  print_endline ("Start: "^(string_of_int b));
  current_scene :=
    {!current_scene with
     state = State.new_state_plus_delta
         !current_scene.state cm !Renderer.delta};
  let rec helper () =
    let scene = !current_scene in
    scene.input <- enforce_one_frame_mouse ();
    scene.interface <- Ui.tick scene.interface scene.input;
    scene.state <- State.update scene scene.input;
    Renderer.render context scene;
    let next_scene_id = State.next_scene scene in
    scene_transition (next_scene_id);
    ignore (
      Html.window##requestAnimationFrame(
        Js.wrap_callback (fun t ->
          Renderer.time := t /. 1000.;
          helper ()
        )
      )
    ) in
    helper ()
