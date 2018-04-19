module Html = Dom_html
let js = Js.string
let document = Html.document

let main () = 
  print_endline "starting main";
  let main_gui = Engine.get_html_element "main"  in
  (*help_gui##style##cssText <- js "font-family:Aniron font-size";*)
  (*let canvas = Html.createCanvas document in*)
  let canvas = !Engine.canvas in
  canvas##width <- int_of_float Renderer.width;
  canvas##height <- int_of_float Renderer.height;
  canvas##id <- js "canvas";
  (****************)
  Dom.appendChild main_gui canvas;
  let context = canvas##getContext (Html._2d_) in
  (* Add mouse event listeners *)
  let _ = Html.addEventListener 
    document (Html.Event.mousedown) (Html.handler Engine.mouse_pressed)
    Js._true in
  let _ = Html.addEventListener
    document (Html.Event.mouseup) (Html.handler Engine.mouse_released)
    Js._true in
  let _ = Html.addEventListener
    document (Html.Event.mousemove) (Html.handler Engine.mouse_move)
    Js._true in
  let _ = Html.addEventListener
    document Html.Event.keydown (Html.handler Engine.key_pressed)
    Js._true in
  let _ = Html.addEventListener
    document Html.Event.keydown (Html.handler Engine.key_released)
    Js._true in
  (* Testing *)
  Engine.game_loop context true
let _ = main ()
  