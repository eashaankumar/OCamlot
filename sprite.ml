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

let tick sp delta = 
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

let tower_base = init_sprite "images/towers/tower1.png" 0.5
                  |> add_animation_frame (0.,0.) (200.,345.) 

let tower_type1 = init_sprite "images/towers/tower2.png" 0.
                  |> add_animation_frame (0.,0.) (200.,320.) 

let menu_btn_sprite1 = init_sprite "images/MenuButtons.jpg" 0.
                  |> add_animation_frame (0.,0.) (242.,70.)
                  |> add_animation_frame (0.,70.) (242.,70.)
                  |> add_animation_frame (0.,140.) (242.,70.)

let stat_board_sprite = init_sprite "images/stat_bar.jpg" 0.
                  |> add_animation_frame (0.,0.) (242.,70.)