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

(**
 * [add_vector2d p1 p2] adds x and y coordinates of [p1] and [p2]
 * returns: sum of [p1] and [p2]
 *)
val add_vector2d : vector2d -> vector2d -> vector2d

(* TODO: Add any physics calculations... *)

(**
 * [get_movement_coord mvmt st] is a vector2d that corresponds
 * to the location of that troop movement on the game map with
 * state [st].
 *)
val get_movement_coord : movement -> state -> vector2d

val scalar_mult_vector2d : float -> vector2d -> vector2d

val scalar_mult_bounds : float -> bounds -> bounds

val set_min_bounds : float * float -> bounds -> bounds

val set_max_bounds : float * float -> bounds -> bounds