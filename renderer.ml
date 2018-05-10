open Types

(* Public *)

let width = 1080.
let height = 680.

let time = ref 0.
let fps = ref 0
let delta = ref 0.

(* Private *)
let last_update_time = ref 0.
let frames_count = ref 0
let time_count = ref 0.

let start_tower_highlight_sprite = ref Sprite.tower_highlight

module Html = Dom_html
let js = Js.string
let document = Html.document

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
let color_to_hex {r=r;g=g;b=b;a=a} =

  js ("#"^
  (Printf.sprintf "%02X" r)^
  (Printf.sprintf "%02X" g)^
  (Printf.sprintf "%02X" b)^
  (Printf.sprintf "%02X" (int_of_float (a *. 255.))))

(**
 * [draw_image ctx img_src pos size] draws image from path [img_src] at [pos]
 * with dimensions [size]
 * returns: unit
 * requires: [img_src] is a valid path to an image
 *)
let draw_image ctx img_src pos true_size size =
  let img = Html.createImg document in
  img##src <- js img_src;
  (**ctx##drawImage (img, pos.x, pos.y);*)
  ctx##drawImage_full(img, 0., 0., fst true_size, snd true_size, pos.x, pos.y, size.w, size.h);
  ()

(**
 * [draw_sprite_sheet ctx sprite pos size] draws [sprite] at [pos] with
 * dimensions [size].
 * returns: unit
 *)
let draw_sprite_sheet ctx sprite pos size=
  let frame = sprite.frames.(sprite.index) in
  ctx##drawImage_full (
    sprite.img, frame.offset.x, frame.offset.y, frame.bounds.w, frame.bounds.h,
    pos.x, pos.y, size.w, size.h);
  ()

(**
 * [draw_text ctx text pos color font_size] renders [text] with the
 * given parameters
 * returns: unit
 * requires: [color] is (0-255,0-255,0-255)
 *           [font_size] > 0
 *)
let draw_text ctx text pos (color:color) font_size : unit =
  ctx##fillStyle <- color_to_hex color;
  ctx##font <- js ((string_of_int font_size)^"px Aniron");
  ctx##fillText (js text, pos.x, pos.y);
  ()

(**
 * [draw_entities context state] draws all animate object/beings
 * in the game [state]
 * returns: unit
 *)
let draw_entities context scene =
  (* Draw troops *)
  List.iter (fun mvmt ->
    let size = {w=50.;h=50.} in
    if mvmt.progress > 0.975 || mvmt.progress < 0.025 then () else (
      let vec = Physics.get_movement_coord mvmt scene.state 
                |> Physics.add_vector2d ({x = 0.; y = (-1.) *. size.h/.2.}) in
        (*|> Physics.add_vector2d (scene.state.towers.(mvmt.end_tower).selector_offset)  
        |> Physics.add_vector2d ({x = 0.; y = (-1.) *. size.h/.2.})*)
      let fs = 15. in
      let x = vec.x +. 50./.2. -. (fs) in
      let y = vec.y +. 10. in
      let (color)= {r=0;g=0;b=0;a=1.} in
      draw_sprite_sheet context mvmt.mvmt_sprite vec size;
      draw_sprite_sheet context Sprite.mvmt_troop_count_sprite {x=x;y=y -. 25.} {w=fs *. 2.;h=20.};
      draw_text context (string_of_int mvmt.mvmt_troops) { x=x+.fs/.2.;y=y+.fs-.25.} color (int_of_float fs);
    )
  ) (scene.state.movements);
  (* Draw towers *)
  Array.iter (fun t ->
    (* Add glow *)
    let _ = if List.mem t.twr_id scene.highlight_towers then (
      draw_sprite_sheet context !start_tower_highlight_sprite 
        (t.twr_pos |> Physics.add_vector2d t.selector_offset 
                   |> Physics.add_vector2d {x=(-1.) *. (t.twr_size.w/.2.); y=(-1.) *. 25.}) 
        {w=t.twr_size.w *. 2.;h=t.twr_size.w};
    ) in
    (* Make simple measurements *)
    let fs = 15. in
    let pos = Physics.add_vector2d t.twr_pos t.count_label_offset in
    let (color,index) = begin
      match t.twr_team with
      | Neutral -> {r=100;g=100;b=100;a=1.},0
      | Player -> {r=0; g=0; b=0;a=1.},1
      | Enemy -> {r=0; g=0; b=0;a=1.},2
    end in
    let spr = {t.twr_sprite with index = index} in
    draw_sprite_sheet context spr t.twr_pos t.twr_size;
    if t.twr_team <> Neutral then (
      draw_sprite_sheet context Sprite.tower_troop_count_sprite pos {w=fs *. 2.;h=20.};
      draw_text context (string_of_int ( int_of_float t.twr_troops)) { x=pos.x+.fs/.2.;y=pos.y+.fs} color (int_of_float fs);
    );
  ) (scene.state.towers);
  ()

(**
 * [draw_ui context state] draws all ui elements in [state]
 * while taking into considering their [ui_state]
 * returns: unit
 *)
let draw_ui context scene =
  List.iter (fun (id, ui_elmt) ->
    match !ui_elmt with
    | Button (btn_prop, pos, size, _) -> begin
        let sprite_to_draw = (
          match btn_prop.btn_state with
            | Neutral -> btn_prop.btn_sprite |> Sprite.set_animation_frame 0
            | Depressed -> btn_prop.btn_sprite |> Sprite.set_animation_frame 1
            | Disabled -> btn_prop.btn_sprite |> Sprite.set_animation_frame 2
            | Clicked -> btn_prop.btn_sprite |> Sprite.set_animation_frame 0
        ) in
        draw_sprite_sheet context sprite_to_draw pos size;
        draw_text context btn_prop.btn_label.text (Physics.add_vector2d pos btn_prop.btn_label_offset) btn_prop.btn_label.color btn_prop.btn_label.font_size;
        ()
      end
    | Label (prop, pos, size) -> begin
        draw_text context prop.text pos prop.color prop.font_size;
        ()
      end
    | Panel (sprite, pos, size) -> begin
        draw_sprite_sheet context sprite pos size;
        ()
      end
    | SpellBox (btn_prop, pos, size, _) -> begin
        let sprite_to_draw = (
          match btn_prop.btn_state with
            | Neutral -> btn_prop.btn_sprite |> Sprite.set_animation_frame 0
            | Depressed -> btn_prop.btn_sprite |> Sprite.set_animation_frame 1
            | Disabled -> btn_prop.btn_sprite |> Sprite.set_animation_frame 2
            | Clicked -> btn_prop.btn_sprite |> Sprite.set_animation_frame 0
        ) in
        draw_sprite_sheet context sprite_to_draw pos size;
        draw_text context btn_prop.btn_label.text (Physics.add_vector2d pos btn_prop.btn_label_offset) btn_prop.btn_label.color btn_prop.btn_label.font_size;
        ()
      end
    ) scene.interface;
  ()

let render context scene =
  (* House Keeping *)
  update_delta ();
  update_fps ();
  (* Draw canvas background *)
  context##clearRect (0., 0., width, height);
  context##fillStyle <- color_to_hex {r=255;g=255;b=255;a=1.0};
  (* Transition begin *)
  (*context##fillStyle <- color_to_hex {r=0;g=0;b=0;a=0.2 *. !fade_amt};
  context##fillRect (0., 0., width, height);*)
  (* Transition end *)
  (*draw_image context "images/grass.jpg" {x=0.;y=0.} (1280.,720.) {w=width;h=height};*)
  draw_sprite_sheet context scene.background {x=0.;y=0.} {w=width;h=height};
  (* Draw entities *)
  draw_entities context scene;
  (* Draw ui *)
  draw_ui context scene;
  ()

let manage_tasks context scene = 
  (* Tasks *)
  let _ = 
  begin
    match scene.tasks with
    (* All transition tasks have been completed, start updating *)
    | [] -> begin
        print_endline("No more tasks left, updating");
        scene.tasks <- [Update]
      end
    (* Fade in *)
    | FadeIn(cur,lim,amag)::t -> 
      begin
        if (cur >= lim) then (
          scene.tasks <- t
        ) else(
          let cur' = cur +. !delta *. 1. in
          scene.tasks <- (FadeIn(cur',lim,amag)::t);
        )
      end
    | Wait(cur, lim)::t -> begin
      end
    | FadeOut (cur,lim,amag)::t -> 
      begin
        if (cur >= lim) then (
          scene.tasks <- t
        ) else(
          let cur' = cur +. !delta *. 1. in
          scene.tasks <- (FadeOut(cur',lim,amag)::t);
        )      
      end
    | _ -> ()
  end in
  (* draw tasks *)
  let _ = if List.length scene.tasks > 0 then
  begin
    match List.hd scene.tasks with
    | FadeIn (cur, lim, amag) -> 
      begin
        let percent_done = cur /. lim in
        let alpha = ref ((1. -. percent_done) *. amag) in
        if !alpha <= 0. then alpha := 0. else ();
        context##fillStyle <- color_to_hex {r=0;g=0;b=0;a= !alpha};
        context##fillRect (0., 0., width, height);
        ()
      end
    | FadeOut (cur, lim, amag) -> 
      begin
        let percent_done = cur /. lim in
        let alpha = ref ((percent_done) *. amag) in
        if !alpha <= 0. then alpha := 0. else ();
        context##fillStyle <- color_to_hex {r=0;g=0;b=0;a= !alpha};
        context##fillRect (0., 0., width, height);
        ()
      end
      (* TODO: Assumption is that switch sceen will always come between fade in and fade out*)
    | SwitchScene (_) -> 
      begin
        context##fillStyle <- color_to_hex {r=0;g=0;b=0;a=1.};
        context##fillRect (0., 0., width, height);
        ()
      end
    | Wait (cur, lim) -> 
      begin
        ()
      end
    | _ -> ()
  end in
  scene