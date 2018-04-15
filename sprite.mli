(* A sprite is a sequence of images that, when looped through every frame,
 * give the appearance that the entity is animated. 
 *)

(**
 * [tick s] updates the given sprite to its next animation frame. If the
 * sequence has reached the end, then it always restarts.
 * returns: updated [sprite] with the new frame to be rendered
 * effects: Other than updating sprite, none. It should NOT print output, 
 *          take input, or render to the screen.
 *)
val tick : sprite -> sprite