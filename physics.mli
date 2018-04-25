open Types

(**
 * This module holds functions that perform basic calculations
 * on the [vector2d] and [bounds] type. This is to aviod code
 * duplication.
 *)

(**
 * [point_inside point pos size] determines if given [point]
 * is inside the rectangle of [pos] and [size]
 * returns: [true] if [point] is inside rectangle, [false] otherwise
 *)
val point_inside : vector2d -> vector2d -> bounds -> bool

(* TODO: Add any physics calculations... *)