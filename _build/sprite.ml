open Types

module Html = Dom_html 
let js = Js.string
let document = Html.document

(****** Helpers ******)
(**
 * [init_sprite sheet_src time_delay] creates an empty sprite animation
 * and loads in an image from [sheet_src] with provided parameters
 * returns: [sprite]
 *)
let init_sprite sheet_src time_delay= 
  let img = Html.createImg document in
  img##src <- js sheet_src;
  {frames=[||];img=img;index=0;time_delay=time_delay;curr_time=Random.float time_delay}

(**
 * [add_animation_frame offset bounds sprite] adds a new frame to [sprite]
 * returns: [sprite] with the new frame.
 *)
let add_animation_frame (x,y) (w,h) sprite = 
  let new_frames = Array.append sprite.frames [|{
    offset = {x = x; y = y};
    bounds = {w = w; h = h};
  }|] in
  {frames = new_frames; 
   img = sprite.img; 
   index = sprite.index; 
   time_delay = sprite.time_delay; 
   curr_time = sprite.curr_time
  }

(* Functions *)
let reset_frame_delay sp = 
  {frames=sp.frames;
  img=sp.img;
  index=sp.index;
  time_delay=sp.time_delay;
  curr_time=0.}

let set_animation_frame i sp = 
  {frames=sp.frames;
  img=sp.img;
  index=i;
  time_delay=sp.time_delay;
  curr_time=sp.curr_time}

let reset_to_first_frame sprite = 
  {
    frames= sprite.frames;
    img= sprite.img;
    index= 0;
    time_delay= sprite.time_delay;
    curr_time= sprite.curr_time;
  }

let tick (sp:sprite) delta = 
  (* switch frames *)
  if sp.curr_time >= sp.time_delay then begin
    (* Wrap around *)
    if sp.index + 1 >= (Array.length sp.frames) then
      {frames=sp.frames;
       img=sp.img;
       index=0;
       time_delay=sp.time_delay;
       curr_time=0.}
    else 
      {frames=sp.frames;
       img=sp.img;
       index=sp.index+1;
       time_delay=sp.time_delay;
       curr_time=0.}
  end
  (* else keep same *)
  else begin
    {frames=sp.frames;
     img=sp.img;
     index=sp.index;
     time_delay=sp.time_delay;
     curr_time=sp.curr_time +. delta}
  end

(* Towers *)
let tower_base = init_sprite "images/ocamlot_sprites.png" 0.5
                  |> add_animation_frame (0.,0.) (72.19,72.19) (* Neutral *)
                  |> add_animation_frame (143.68,0.) (72.19,144.38) (* Player *)
                  |> add_animation_frame (215.87,0.) (72.19,144.38) (* Enemy *)

let tower_type1 = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (0.,0.) (72.19,72.19) (* Neutral*)
                  |> add_animation_frame (72.19,0.) (72.19,72.19) (* Player *)
                  |> add_animation_frame (72.19,72.19) (72.19,72.19) (* Enemy *)

let tower_type2 = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (0.,72.19) (72.19,72.19) (* Neutral*)
                  |> add_animation_frame (288.06,0.) (72.19,72.19) (* Player *)
                  |> add_animation_frame (288.06,72.19) (72.19,72.19) (* Enemy *)

(* Troops *)
let blue_troop1_right = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (0.,144.02) (72.19,71.63)
                  |> add_animation_frame (72.19,144.02) (72.19,71.63)
                  |> add_animation_frame (143.92,144.02) (72.19,71.63)
                  |> add_animation_frame (216.21,144.02) (72.19,71.63)

let blue_troop1_left = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (287.84,144.02) (72.19,71.63)
                  |> add_animation_frame (360.03,144.02) (72.19,71.63)
                  |> add_animation_frame (431.75,144.02) (72.19,71.63)
                  |> add_animation_frame (504.04,144.02) (72.19,71.63)

let blue_troop2_left = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (576.23,144.02) (72.19,71.63)
                  |> add_animation_frame (648.42,144.02) (72.19,71.63)
                  |> add_animation_frame (720.61,144.02) (72.19,71.63)

let blue_troop2_right = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (792.80,144.02) (72.19,71.63)
                  |> add_animation_frame (864.99,144.02) (72.19,71.63)
                  |> add_animation_frame (937.18,144.02) (72.19,71.63)

let red_troop1_right = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (0.,215.65) (72.19,71.63)
                  |> add_animation_frame (72.19,215.65) (72.19,71.63)
                  |> add_animation_frame (143.92,215.65) (72.19,71.63)
                  |> add_animation_frame (216.21,215.65) (72.19,71.63)

let red_troop1_left = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (287.84,215.65) (72.19,71.63)
                  |> add_animation_frame (360.03,215.65) (72.19,71.63)
                  |> add_animation_frame (431.75,215.65) (72.19,71.63)
                  |> add_animation_frame (504.04,215.65) (72.19,71.63)


let red_troop2_left = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (576.23,215.65) (72.19,71.63)
                  |> add_animation_frame (648.42,215.65) (72.19,71.63)
                  |> add_animation_frame (720.61,215.65) (72.19,71.63)

let red_troop2_right = init_sprite "images/ocamlot_sprites.png" 0.08
                  |> add_animation_frame (792.80,215.65) (72.19,71.63)
                  |> add_animation_frame (864.99,215.65) (72.19,71.63)
                  |> add_animation_frame (937.18,215.65) (72.19,71.63)

(* Backgrounds *)
let grass_background = init_sprite "images/bkgs/grass_field.jpg" 0.
                  |> add_animation_frame (0.,0.) (540.,340.)
let cracked_background = init_sprite "images/bkgs/cracked_wall.png" 0.
                  |> add_animation_frame (0.,0.) (540.,340.)

(* UI *)
let tower_highlight = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (0.,575.74) (143.92,104.46)


let tower_troop_count_sprite = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (143.92,647.97) (71.96, 32.03)

let mvmt_troop_count_sprite = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (143.92,575.74) (71.96, 71.63)


let menu_btn_sprite1 = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (0.,503.79) (143.92,71.96)
                  |> add_animation_frame (143.76,503.79) (143.92,71.96)
                  |> add_animation_frame (0.,503.79) (143.92,71.96)

let spell_btn_sprite = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (215.01,575.74) (71.96, 71.63) (*Neutral*)
                  |> add_animation_frame (288.2,575.74) (71.96, 71.63) (*Selected*)
                  |> add_animation_frame (360.19,575.74) (71.96, 71.63) (*Regenerating*)
                  |> add_animation_frame (432.15,575.74) (71.96, 71.63) (*Disable*)

(* Spells *)
let sprite_lightning = init_sprite "images/lightning.png" 0.05
                  |> add_animation_frame (0., 0.) (74.5, 127.)
                  |> add_animation_frame (74.5, 0.) (74.5, 127.)
                  |> add_animation_frame (149., 0.) (74.5, 127.)
                  |> add_animation_frame (223.5, 0.) (74.5, 127.)
                  |> add_animation_frame (298., 0.) (74.5, 127.)
                  |> add_animation_frame (372.5, 0.) (74.5, 127.)

let sprite_lightning_icon = init_sprite "images/ocamlot_sprites.png" 0.
                  |> add_animation_frame (504.11, 575.74) (71.96, 71.63)

let sprite_freeze = init_sprite "images/ocamlot_sprites.png" 0.18
                  |> add_animation_frame (0., 431.98) (71.96, 71.96)
                  |> add_animation_frame (71.96, 431.98) (71.96, 71.96)
                  |> add_animation_frame (143.92, 431.98) (71.96, 71.96)
                  |> add_animation_frame (216.88, 431.98) (71.96, 71.96)
                  |> add_animation_frame (288.84, 431.98) (71.96, 71.96)


let sprite_freeze_icon = init_sprite "images/ocamlot_sprites.png" 0.05
                  |> add_animation_frame (576.07, 575.74) (71.96, 71.63)

let sprite_heart = init_sprite "images/freeze_spell.png" 0.05
                  |> add_animation_frame (648.03, 575.74) (71.96, 71.63)

let sprite_heart_icon = init_sprite "images/ocamlot_sprites.png" 0.05
                  |> add_animation_frame (648.03, 575.74) (71.96, 71.63)