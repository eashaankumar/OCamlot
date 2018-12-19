(**
 * [game_loop context running] calls all appropriate update and render
 * functions per frame. One iteration of this represents one frame.
 * returns: [unit]
 *)
val game_loop: Dom_html.canvasRenderingContext2D Js.t -> bool -> unit

(**
 * [mouse_pressed context b] runs by js_of_ocaml when a mouse press
 * event takes place.
 * effects: global input reference
 * returns: [Js._true] if event fired successfully, [Js._false] otherwise.
 *)
val mouse_pressed : Dom_html.mouseEvent Js.t -> bool Js.t

(**
 * [mouse_released context b] runs by js_of_ocaml when a mouse release
 * event takes place.
 * effects: global input reference
 * returns: [Js._true] if event fired successfully, [Js._false] otherwise.
 *)
val mouse_released : Dom_html.mouseEvent Js.t -> bool Js.t

(**
 * [mouse_move context b] runs by js_of_ocaml when a mouse move
 * event takes place.
 * effects: global input reference
 * returns: [Js._true] if event fired successfully, [Js._false] otherwise.
 *)
val mouse_move : Dom_html.mouseEvent Js.t -> bool Js.t

(**
 * [get_html_element name context] returns the html element from the webpage.
 * returns: [html element]
 *)
val get_html_element : string -> Dom_html.element Js.t

(**
 * [canvas] represents the drawing screen on which the game is rendered. 
 *)
val canvas : (Dom_html.canvasElement Js.t) ref 