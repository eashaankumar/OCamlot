open State

module Html = Dom_html 
let js = Js.string
let document = Html.document

(* Intialize state *)
let state = ref {
  towers = [||] ;
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_mana = 0 ;
  enemy_mana = 0
}

let key_pressed event = 
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" pressed")
  in Js._true

let key_released event = 
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" released")
  in Js._true

let mouse_pressed event = 
  (*let _ = match event##mousedown with
  | key -> print_endline ((string_of_int key)^" pressed")
  in*) 
  print_endline "mouse event pressed";  
  Js._true

let mouse_released event = 
  (*let _ = match event##mouseup with
  | key -> print_endline ((string_of_int key)^" released")
  in*) 
  print_endline "mouse event released";  
  Js._true

let game_loop context running = 
  let rec helper () = 
    print_endline "game_loop";
    state := State.update !state;
    Renderer.render context !state;
    ignore (
      Html.window##requestAnimationFrame(
      Js.wrap_callback (fun (t:float) -> helper ())
      )
    ) in
    helper ()
