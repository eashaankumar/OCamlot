open Types

let width = 800.
let height = 600.

module Html = Dom_html 
let js = Js.string
let document = Html.document

(**
 * [color_to_hex color] calculates hexadecimal representation of the 
 * [color].
 * returns: [string] representing hexadecimal color
 * requires: [color] be of form (0-255,0-255,0-255) 
 *)
let color_to_hex (r,g,b) = 
  js ("#"^
  (Printf.sprintf "%X" r)^
  (Printf.sprintf "%X" g)^
  (Printf.sprintf "%X" g))

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

let render context state =
  print_endline "render";
  context##clearRect (0., 0., width, height);
  (* Draw canvas background *)
  context##fillStyle <- color_to_hex (0,0,0);
  context##fillRect (0., 0., width, height);
  (* Draw entities *)
  Array.iter (fun tower -> 
    match tower.twr_team with
    | Player -> context##fillStyle <- color_to_hex (0,255,0);
    | Enemy -> context##fillStyle <- color_to_hex (255,0,0)
    | Neutral -> context##fillStyle <- color_to_hex (100,100,100);
    context##fillRect (tower.twr_pos.x, tower.twr_pos.y, tower.twr_size.w, tower.twr_size.h);
  ) (state.towers);
  ()