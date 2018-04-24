open Types

(* Public *)
let width = 800.
let height = 600.

let time = ref 0.
let fps = ref 0
let delta = ref 0.

(* Private *)
let last_update_time = ref 0. 
let frames_count = ref 0
let time_count = ref 0.

module Html = Dom_html 
let js = Js.string
let document = Html.document

(******************************************************************************)
let draw_sprite_sheet ctx sprite pos size= 
  let frame = sprite.frames.(sprite.index) in
  ctx##drawImage_full (
    sprite.img, frame.offset.x, frame.offset.y, frame.bounds.w, frame.bounds.h, 
    pos.x, pos.y, size.w, size.h);
  ()
(******************************************************************************)

(****** Helpers ******)
(**
 * [update_delta] returns time elapsed between last update call and this one.
 * returns: unit
 * effects: [delta]
 *)
let update_delta () = 
  delta := !time -. !last_update_time;
  last_update_time := !time;
  ()

(**
 * [get_fps] calculates current fps on game.
 * returns: unit
 * effects: [fps], [time_count], [frames_count]
 * requires: [update_fps] should be run every frame in [render]
 *)
let update_fps () = 
  if !time_count > 1. then (
    fps := !frames_count;
    time_count := 0.;
    frames_count := 0;
  ) else (
    time_count := !time_count +. !delta;
    frames_count := !frames_count + 1;
  ) 

(**
 * [color_to_hex color] calculates hexadecimal representation of the 
 * [color].
 * returns: [string] representing hexadecimal color
 * requires: [color] be of form (0-255,0-255,0-255) 
 *)
let color_to_hex (r,g,b) = 
   
  js ("#"^
  (Printf.sprintf "%02X" r)^
  (Printf.sprintf "%02X" g)^
  (Printf.sprintf "%02X" b))

(**
 * [draw_image ctx img_src pos] draws image from path [img_src] at [pos].
 * returns: unit
 * requires: [img_src] is a valid path to an image
 *)
let draw_image ctx img_src pos =
  let img = Html.createImg document in
  img##src <- js img_src;
  ctx##drawImage (img, pos.x, pos.y);
  ()

(**
 * [draw_text ctx text pos color font_size] renders [text] with the 
 * given parameters
 * returns: unit
 * requires: [color] is (0-255,0-255,0-255)
 *           [font_size] > 0
 *)
let draw_text ctx text pos color font_size : unit =
  ctx##fillStyle <- color_to_hex color;
  ctx##font <- js ((string_of_int font_size)^"px Triforce");
  ctx##fillText (js text, pos.x, pos.y);
  ()

(**
 * [draw_entities context state] draws all animate object/beings
 * in the game [state]
 * returns: unit
 *)
let draw_entities context state = 
  Array.iter (fun tower -> 
    draw_sprite_sheet context tower.twr_sprite tower.twr_pos tower.twr_size;
    draw_text 
      context (string_of_int ( int_of_float tower.twr_troops)) 
      {
        x=tower.twr_pos.x +. tower.twr_size.w/.2.;
        y=tower.twr_pos.y +. tower.twr_size.h/.3.
      } 
      (0,0,0) 20;
  ) (state.towers);
  ()

(**
 * [draw_ui context state] draws all ui elements in [state]
 * while taking into considering their [ui_state]
 * returns: unit
 *)
let draw_ui context state = 
  Array.iter (fun ui_elmt ->
    match ui_elmt with
    | Button (ustate, pos, size) -> begin
        ()
      end
    | Label (prop, pos, size) -> begin
        ()
      end
    | Panel (sprite, pos, bounds) -> begin
        ()
      end 
  ) state.ui_elements;
  ()

let render context state =
  (* House Keeping *)
  update_delta ();
  update_fps ();
  (* Draw canvas background *)
  context##clearRect (0., 0., width, height);
  context##fillStyle <- color_to_hex (255,255,255);
  context##fillRect (0., 0., width, height);
  (* Draw entities *)
  draw_entities context state;
  (* Draw ui *)
  draw_ui context state;
  (* Draw fps *)
  draw_text 
    context (string_of_int (!fps)) 
    {
      x=width-.30.;
      y=30.;
    } 
    (255,20,147) 30;
  ()