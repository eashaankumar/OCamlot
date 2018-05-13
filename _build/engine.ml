open Types
open Ai

module Html = Dom_html
let js = Js.string
let document = Html.document

(* Scene transitions *)
let fade_in = FadeIn (0., 1., 1.)
let fade_out = FadeOut (0., 1., 1.)

(* Generic empty state *)
let empty_state = {
  towers = [||];
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_skill = None;
  enemy_skill = None;
  player_mana = 0.;
  enemy_mana = 0.;
}
(* Initialize input *)
let init_input = {
  mouse_pos = {x=0.;y=0.};
  mouse_state = Moved;
}

(* Skills *)
let lightning_skill = {
  allegiance = Neutral;
  mana_cost = 70 ;
  effect = Kill 15 ;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 5.};
  tower_id = -1;
  sprite = Sprite.sprite_lightning;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 2.};
}

let freeze_skill = {
  allegiance = Neutral;
  mana_cost = 0(*170*);
  effect = Stun 7.;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 0.(*20.*)};
  tower_id = -1;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let health_skill = {
  allegiance = Neutral;
  mana_cost = 200;
  effect = Regen_incr (3.);
  regen_timer = {curr_time = 0.; speed = 1.; limit = 40.};
  tower_id = -1;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

(* Spell Bar *)
let spell_bar = [
  ("lightning_spell", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_lightning_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=0.;y= Renderer.height -. 50.},
              {w=50.;h=50.},
              (* Skill *)
              lightning_skill)
  ));
  ("freeze_spell", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_freeze_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=50.;y= Renderer.height -. 50.},
              {w=50.;h=50.},
              (* Skill *)
              freeze_skill)
  ));
  ("health_spell", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_heart_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=100.;y= Renderer.height -. 50.},
              {w=50.;h=50.},
              (* Skill *)
              health_skill)
  ));
  ("player_mana_label", ref (
    Label (
      {
        text = "mana: ";
        color = {r=255;g=255;b=255;a=1.};
        font_size = 20;
      },
      {x=170.; y = Renderer.height -. 10.},
      {w=160.;h=70.};
    )
  ));
]
(* Initialize scenes *)
let difficulty_selection_scene = {
  name = "Select Difficulty";
  tasks = [];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("difficulty_label", ref (
                 Label (
                   {
                      text = "Choose Difficulty";
                      color = {r=0;g=0;b=0;a=1.};
                      font_size = 40;
                   },
                   {x=Renderer.width /. 2. -. 260.; y = 200.},
                   {w=800.;h=70.};
                 )
               ));
               ("easy",ref (
                 Button (
                   {
                      btn_state = Neutral;
                      btn_sprite = Sprite.menu_btn_sprite1;
                      btn_label = {
                        text = "Easy"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                      }; 
                      btn_label_offset = {x=50.;y=30./.2. +. 70./.2.};
                    },
                    {x=Renderer.width /. 2. -. 100.;y= 300.},
                    {w=200.;h=70.},
                    Some "Game")
               ));
               ("medium",ref (
                 Button (
                   {
                      btn_state = Neutral;
                      btn_sprite = Sprite.menu_btn_sprite1;
                      btn_label = {
                        text = "Medium"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                      }; 
                      btn_label_offset = {x=10.;y=30./.2. +. 70./.2.};
                    },
                    {x=Renderer.width /. 2. -. 100.;y= 400.},
                    {w=200.;h=70.},
                    Some "Game")
               ));
               ("hard",ref (
                 Button (
                   {
                      btn_state = Neutral;
                      btn_sprite = Sprite.menu_btn_sprite1;
                      btn_label = {
                        text = "Hard"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                      }; 
                      btn_label_offset = {x=50.;y=30./.2. +. 70./.2.};
                    },
                    {x=Renderer.width /. 2. -. 100.;y= 500.},
                    {w=200.;h=70.},
                    Some "Game")
               ));
              
              ];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.cracked_background;
}

let game_scene = {
  name = "Game";
  tasks = [];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);               
               ] @ spell_bar;
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let game_over_scene = {
  name = "Game Over";
  tasks = [fade_in];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("game_over",ref Ui.gameover_label)];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.cracked_background;
}

let intro_scene = {
  name = "Intro";
  tasks = [fade_in];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("start",ref (
                 Button (
                   {
                      btn_state = Neutral; 
                      btn_sprite = Sprite.menu_btn_sprite1;
                      btn_label = {
                        text = "Begin"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                      }; 
                      btn_label_offset = {x=50.;y=30./.2. +. 70./.2.};
                    },
                    {x=Renderer.width /. 2. -. 100.;y= 400.},
                    {w=200.;h=70.},
                    Some "Select Difficulty")
               ));
               ("title_label", ref (
                 Label (
                   {
                      text = "OCAMLOT";
                      color = {r=0;g=0;b=0;a=1.};
                      font_size = 75;
                   },
                   {x=Renderer.width /. 2. -. 297.5; y = 200.},
                   {w=525.;h=70.};
                 )
               ));
               ("read_intructions_below", ref (
                 Label (
                   {
                      text = "Read Instructions Below";
                      color = {r=0;g=0;b=0;a=0.7};
                      font_size = 20;
                   },
                   {x=Renderer.width /. 2. -. 175.; y = 600.},
                   {w=460.;h=70.};
                 )
               ));
               ];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.cracked_background;
}

let current_scene = ref intro_scene

(* Pref mouse state *)
let prev_mouse_state = ref Moved

(* TODO: Figure out how to get canvas from document *)
let canvas = ref ( Html.createCanvas document )

(****** Helpers ******)
let print_mouse_input () =
  (*print_string ((string_of_float input.mouse_pos.x)^" "^(string_of_float input.mouse_pos.y)^" ");*)
  let scene = !current_scene in
  match scene.input.mouse_state with
  | Pressed -> "Pressed "
  | Released -> "Released "
  | Moved -> "Moved "^(string_of_float !Renderer.delta)

let calculate_mouse_pos (event:Dom_html.mouseEvent Js.t) =
  let rect = (!canvas)##getBoundingClientRect () in
  let x = event##clientX - int_of_float rect##left in
  let y = event##clientY - int_of_float rect##top in
  {x=float_of_int x;y= float_of_int y}

let enforce_one_frame_mouse () =
  (*print_endline (print_mouse_input ());*)
  let scene = !current_scene in
  let new_mouse_state = begin
    match !prev_mouse_state with
    | Pressed -> begin
      match scene.input.mouse_state with
      | Pressed -> Moved
      | Moved -> Moved
      | Released -> Released
      end
    | Moved -> begin
        match scene.input.mouse_state with
        | Pressed -> Pressed
        | Moved -> Moved
        | Released -> Released
      end
    | Released -> begin
        match scene.input.mouse_state with
        | Pressed -> Pressed
        | Moved -> Moved
        | Released -> Moved
      end
  end in
  prev_mouse_state := scene.input.mouse_state;
  {mouse_pos = scene.input.mouse_pos; mouse_state = new_mouse_state}

(*********************)

let get_html_element id =
  Js.Opt.get (document##getElementById (js id)) (fun _ -> assert false)

(*let key_pressed event =
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" pressed")
  in Js._true

let key_released event =
  let _ = match event##keyCode with
  | key -> print_endline ((string_of_int key)^" released")
  in Js._true*)

let mouse_pressed (event:Dom_html.mouseEvent Js.t) =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Pressed;};
  current_scene := scene;
  Js._true

let mouse_released event =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Released;};
  current_scene := scene;
  Js._true

let mouse_move event =
  let pos = calculate_mouse_pos event in
  let scene = !current_scene in
  scene.input <- {mouse_pos = pos; mouse_state = Moved;};
  current_scene := scene;
  Js._true

let get_scene_from_name name =
  match name with
  | "Intro" -> intro_scene
  | "Game" -> game_scene
  | "Game Over" -> game_over_scene
  | "Select Difficulty" -> difficulty_selection_scene
  | _ -> intro_scene
(**
 * [schedule_transition scid] transitions [current_scene] to [next] scene.
 * returns: [unit]
 * effects: [current_scene]
 *)
let schedule_transition scid =
  let _ =
    begin
      match scid with
      | None -> ()
      | Some(nxt) ->
        begin
          print_endline("Switching to "^(nxt));
          current_scene := {!current_scene with tasks = [fade_out;SwitchScene(nxt)]};
          ()
        end
    end in
  ()

let scene_transition () =
  if List.length !current_scene.tasks > 0 then (
    match List.hd !current_scene.tasks with
    | SwitchScene(nxt) ->
      begin
        if nxt = "Game" then (
          (* Go back to start screen *)
          if Mapmaker.all_states_completed () then (
            Mapmaker.reset_states_counter ();
            let next_scene = get_scene_from_name "Intro" in
            current_scene := next_scene;
            current_scene := {!current_scene with tasks = [fade_in]}
          )
          (* Generate new map if more levels remaining *)
          else (
            (*current_scene := {
              name = "Game";
              tasks = [FadeIn (0.,2., 1.);];
              state = Mapmaker.next_state ();
              interface = [("fps",ref Ui.fps_label);
                          ];
              input = init_input;
              highlight_towers = [];
              next = None;
              background = Sprite.grass_background;
            };*)
            current_scene := {game_scene with
                              tasks = [fade_in];
                              state = Mapmaker.next_state ();};
          )
        )
        (* Otherwise get the desired scene from tuple list *)
        else (
          let next_scene = get_scene_from_name nxt in
          current_scene := {next_scene with
                            tasks = [fade_in];};
        );
        ()
      end
    | _ -> ()
  )

let game_loop context running =
  (*let start = Sys.time () in
  let cm = Ai.MCTS_AI.get_move (!current_scene.state) in
  let finish = Sys.time () in
  print_endline (string_of_float (finish -. start));
  let (b,c) =
    match cm with
    | Move (x,y,z) -> (y,z)
    | _ -> (-1,-1) in
  print_endline ("Start: "^(string_of_int b));
  current_scene :=
    {!current_scene with
     state = State.new_state_plus_delta
         !current_scene.state cm !Renderer.delta};
  *)
  let last_move_time = ref (Sys.time ()) in
  let base_step_length =
    match !State.difficulty_level with
    | Easy -> 6.
    | Medium -> 4.
    | Hard -> 2. in
  let next_move_step = ref (base_step_length +. (Random.float 1.)) in

  let rec helper () =
    
    (*let _ = (match !State.difficulty_level with
    | Easy -> print_endline "Easy"
    | Medium -> print_endline "Medium"
    | Hard -> print_endline "Hard") in*)
    let new_time = Sys.time () in
    if new_time -. !last_move_time > !next_move_step then
      begin
        last_move_time := new_time;
        next_move_step := (base_step_length +. (Random.float 1.));
      let cm = Ai.MCTS_AI.get_move (!current_scene.state) !State.difficulty_level in
      current_scene :=
        {!current_scene with
         state = State.new_state_plus_delta
             !current_scene.state cm !Renderer.delta}
    end;

    !current_scene.input <- enforce_one_frame_mouse ();
    !current_scene.interface <- Ui.tick !current_scene.interface !current_scene.input;
    (* Only update if task is Update *)
    if (List.length !current_scene.tasks > 0) && List.hd !current_scene.tasks = Update then (
      let next_scene_id = State.next_scene !current_scene in
      schedule_transition (next_scene_id);
      !current_scene.state <- State.update !current_scene !current_scene.input;
    );
    Renderer.render context !current_scene;
    (* Manage tasks *)
    current_scene  := Renderer.manage_tasks context !current_scene;
    scene_transition ();
    ignore (
      Html.window##requestAnimationFrame(
        Js.wrap_callback (fun t ->
          Renderer.time := t /. 1000.;
          helper ()
        )
      )
    ) in
    helper ()
