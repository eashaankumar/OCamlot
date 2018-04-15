module Html = Dom_html
let js = Js.string
let document = Html.document

let main () = 
  print_endline "starting main";
  let main_gui = (
    Js.Opt.get (Html.document##getElementById (js "main")) 
               (fun _ -> assert false)
  ) in
  (*help_gui##style##cssText <- js "font-family:Aniron font-size";*)
  let canvas = Html.createCanvas document in
  canvas##width <- int_of_float Renderer.width;
  canvas##height <- int_of_float Renderer.height;
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
    document Html.Event.keydown (Html.handler Engine.key_pressed)
    Js._true in
  let _ = Html.addEventListener
    document Html.Event.keydown (Html.handler Engine.key_released)
    Js._true in
  Engine.game_loop context true
 
let _ = main ()
  