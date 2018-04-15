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
  {frames=[||];img=img;index=0;time_delay=time_delay;curr_time=0.}

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

let troop_sprite = init_sprite "images/test_spritesheet.png" 0.5
                   |> add_animation_frame (0.,0.) (225.,250.) 
                   |> add_animation_frame (225.,0.) (225.,250.) 
                   |> add_animation_frame (450.,0.) (225.,250.) 
                   |> add_animation_frame (675.,0.) (225.,250.)
