open Types
open Ai

module Html = Dom_html
let js = Js.string
let document = Html.document

(* Generic empty state *)
let empty_state = {
  towers = [||];
  num_towers = 0 ;
  player_score = 0 ;
  enemy_score = 0 ;
  movements = [] ;
  player_skill = None;
  player_mana = 0 ;
  enemy_mana = 0;
}
(* Initialize input *)
let init_input = {
  mouse_pos = {x=0.;y=0.};
  mouse_state = Moved;
}

(* Skills *)
let lightning_skill = {
  allegiance = Neutral;
  mana_cost = 0 ;
  effect = Kill (10) ;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 2.};
  tower_id = -1;
  sprite = Sprite.sprite_lightning;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 2.};
}

let stun_skill = {
  allegiance = Neutral;
  mana_cost = 0;
  effect = Stun 3.5;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 5.};
  tower_id = -1;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 0.};
}

(* Initialize scenes *)
let game_scene = {
  name = "Game";
  tasks = [];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("lightning_spell", ref (
                 SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
                          spell_box_front_image = Some (Sprite.sprite_lightning_icon); spell_box_front_image_offset = {x=0.;y=0.};},
                           {x=100.;y= Renderer.height -. 75.},
                           {w=50.;h=50.},
                           (* Skill *)
                           lightning_skill)
               ));
               ("freeze_spell", ref (
                 SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
                          spell_box_front_image = Some (Sprite.sprite_lightning_icon); spell_box_front_image_offset = {x=0.;y=0.};},
                           {x=150.;y= Renderer.height -. 75.},
                           {w=50.;h=50.},
                           (* Skill *)
                           stun_skill)
               ))
               ];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let game_over_scene = {
  name = "Game Over";
  tasks = [FadeIn (0., 2., 1.)];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("game_over",ref Ui.gameover_label)];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
}

let intro_scene = {
  name = "Intro";
  tasks = [FadeIn (0., 2., 1.)];
  state = empty_state;
  interface = [("fps",ref Ui.fps_label);
               ("start",ref (
                 Button ({btn_state = Neutral; btn_sprite = Sprite.menu_btn_sprite1;
                          btn_label = {
                            text = "Start"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                          }; btn_label_offset = {x=50.;y=30./.2. +. 70./.2.};
                                                                 },
                           {x=Renderer.width /. 2. -. 100.;y= 300.},
                           {w=200.;h=70.},
                           Some "Game")
               ));];
  input = init_input;
  highlight_towers = [];
  next = None;
  background = Sprite.grass_background;
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
          current_scene := {!current_scene with tasks = [FadeOut(0.,2.,1.);SwitchScene(nxt)]};
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
            current_scene := {!current_scene with tasks = [FadeIn (0.,2., 1.);]}
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
                              tasks = [FadeIn (0.,2., 1.);];
                              state = Mapmaker.next_state ();};
          )
        )
        (* Otherwise get the desired scene from tuple list *)
        else (
          let next_scene = get_scene_from_name nxt in
          current_scene := next_scene;
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
  let ai_difficulty = Easy in
  let last_move_time = ref (Sys.time ()) in
  let base_step_length =
    match ai_difficulty with
    | Easy -> 6.
    | Medium -> 4.
    | Hard -> 2. in
  let next_move_step = ref (base_step_length +. (Random.float 1.)) in

  let rec helper () =

    let new_time = Sys.time () in
    if new_time -. !last_move_time > !next_move_step then
      begin
        last_move_time := new_time;
        next_move_step := (base_step_length +. (Random.float 1.));
      let cm = Ai.MCTS_AI.get_move (!current_scene.state) ai_difficulty in
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
