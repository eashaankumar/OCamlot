open Types

(* A sprite is a sequence of images that, when looped through every frame,
 * give the appearance that the entity is animated.
 *)

(**
 * [tick s delta] updates the given sprite to its next animation frame. If the
 * sequence has reached the end, then it always restarts.
 * returns: updated [sprite] with the new frame to be rendered
 * effects: Other than updating sprite, none. It should NOT print output,
 *          take input, or render to the screen.
 *)
val tick : sprite -> float -> sprite

(**
 * [troop_sprite] holds information about troop sprite animation
 *)
val tower_base : sprite

val tower_type1 : sprite

val tower_type2 : sprite

val blue_troop1_right : sprite

val blue_troop1_left : sprite

val blue_troop2_right : sprite

val blue_troop2_left : sprite

val red_troop1_right : sprite

val red_troop1_left : sprite

val red_troop2_right : sprite

val red_troop2_left : sprite

val menu_btn_sprite1 : sprite

val grass_background : sprite

val cracked_background : sprite

val tower_highlight : sprite

val tower_troop_count_sprite : sprite

val mvmt_troop_count_sprite : sprite

val spell_btn_sprite : sprite

val sprite_lightning : sprite

val sprite_lightning_icon : sprite

val sprite_freeze : sprite

val sprite_freeze_icon : sprite

val sprite_heart : sprite

val sprite_heart_icon : sprite

(**
 * [reset_to_first_frame sp] sets the animation frame to the
 * starting frame.
 * returns: [sprite] with starting frame as the current frame
 *)
val reset_to_first_frame : sprite -> sprite

(**
 * [set_animation_frame i sp] sets the animation frame of [sp]
 * to the frame located at index [i].
 * returns: [sprite] with updated animation frame
 * requires: [i] is a valid index
 *)
val set_animation_frame : int -> sprite -> sprite

(**
 * [reset_frame_time sp] sets sprite's [curr_time] field
 * to 0.0 seconds, effectively restarting the current frame delay
 * returns: [sprite] with reset delay
 *)
val reset_frame_delay : sprite -> sprite
