open Types

module Html = Dom_html 
let js = Js.string
let document = Html.document

(* Intialize state *)
let state = ref {
  towers = [|
    {
      twr_id = 0;
      twr_pos = {x=0.;y=0.};
      twr_size = {w=80.;h=100.} ;
      twr_sprite = Sprite.troop_sprite;
      twr_troops = 0.;
      twr_troops_max = 50.;
      twr_troops_regen_speed = 1.;
      twr_team = Player
    };
    {
      twr_id = 1;
      twr_pos = {x=Renderer.width-.80.;y=Renderer.height-.100.};
      twr_size = {w=80.;h=100.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 50.;
      twr_troops_regen_speed = 1.;
      twr_team = Enemy
    };
    (* Neutral *)
    {
      twr_id = 2;
      twr_pos = {x=300.;y=200.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
    {
      twr_id = 3;
      twr_pos = {x=200.;y=400.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
    {
      twr_id = 3;
      twr_pos = {x=100.;y=500.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
    (*  *)
    {
      twr_id = 2;
      twr_pos = {x=Renderer.width-.300.;y=Renderer.height-.200.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
    {
      twr_id = 3;
      twr_pos = {x=Renderer.width-.200.;y=Renderer.height-.400.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
    {
      twr_id = 3;
      twr_pos = {x=Renderer.width-.100.;y=Renderer.height-.500.};
      twr_size = {w=40.;h=50.} ;
      twr_sprite = Sprite.troop_sprite ;
      twr_troops = 0. ;
      twr_troops_max = 20.;
      twr_troops_regen_speed = 1.;
      twr_team = Neutral
    };
  |] ;
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_mana = 0 ;
  enemy_mana = 0;
}

(* Initialize input *)
let input = ref {
  mouse_pos = {x=0.;y=0.};
  mouse_state = Moved;
  prev_state = Moved;
}

(* TODO: Figure out how to get canvas from document *)
let canvas = ref ( Html.createCanvas document )

(****** Helpers ******)
let calculate_mouse_pos (event:Dom_html.mouseEvent Js.t) = 
  let rect = (!canvas)##getBoundingClientRect () in
  let x = event##clientX - int_of_float rect##left in
  let y = event##clientY - int_of_float rect##top in
  {x=float_of_int x;y= float_of_int y}
(*********************)

let get_html_element id =
  Js.Opt.get (document##getElementById (js id)) (fun _ -> assert false)

let key_pressed event = 
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" pressed")
  in Js._true

let key_released event = 
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" released")
  in Js._true

let mouse_pressed (event:Dom_html.mouseEvent Js.t) = 
  let pos = calculate_mouse_pos event in
  input := {mouse_pos = pos; mouse_state = Pressed; prev_state = !input.mouse_state};
  Js._true

let mouse_released event = 
  let pos = calculate_mouse_pos event in
  input := {mouse_pos = pos; mouse_state = Released; prev_state = !input.mouse_state};
  Js._true

let mouse_move event = 
  let pos = calculate_mouse_pos event in
  input := {mouse_pos = pos; mouse_state = Moved; prev_state = !input.mouse_state};
  Js._true

let game_loop context running = 
  let rec helper () = 
    state := State.update !state !input;
    Renderer.render context !state;
    ignore (
      Html.window##requestAnimationFrame(
        Js.wrap_callback (fun t -> 
          Renderer.time := t /. 1000.;
          helper ()
        )
      )
    ) in
    helper ()
