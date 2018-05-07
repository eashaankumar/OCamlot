open Types

val width : float
val height : float

val time : float ref
val fps : int ref
val delta : float ref

val render : Dom_html.canvasRenderingContext2D Js.t -> scene -> unit

val manage_tasks : Dom_html.canvasRenderingContext2D Js.t -> scene -> scene