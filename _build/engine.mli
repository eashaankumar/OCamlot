val game_loop: Dom_html.canvasRenderingContext2D Js.t -> bool -> unit

val mouse_pressed : Dom_html.mouseEvent Js.t -> bool Js.t

val mouse_released : Dom_html.mouseEvent Js.t -> bool Js.t

val key_pressed : Dom_html.keyboardEvent Js.t -> bool Js.t

val key_released : Dom_html.keyboardEvent Js.t -> bool Js.t
