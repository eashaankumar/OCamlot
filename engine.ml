open Types
open Ai

module Html = Dom_html
let js = Js.string
let document = Html.document

(* Scene transitions *)
let fade_in = FadeIn (0., 1., 1.)
let fade_out = FadeOut (0., 1., 1.)
let fade_out_alpha_0_5 = FadeOut (0.5, 1., 1.)

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
  mana_cost = 100;
  effect = Stun 10.;
  regen_timer = {curr_time = 0.; speed = 1.; limit = 20.};
  tower_id = -1;
  sprite = Sprite.sprite_freeze;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

let health_skill = {
  allegiance = Neutral;
  mana_cost = 150;
  effect = Regen_incr (3.);
  regen_timer = {curr_time = 0.; speed = 1.; limit = 30.};
  tower_id = -1;
  sprite = Sprite.sprite_heart;
  anim_timer = {curr_time = 0.; speed = 1.; limit = 1.};
}

(* Spell Bar *)
let spell_bar_player = [
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
        text = "player mana: -";
        color = {r=255;g=255;b=255;a=1.};
        font_size = 15;
      },
      {x=170.; y = Renderer.height -. 10.},
      {w=160.;h=70.};
    )
  ));
]

let spell_bar_ai = [
  ("lightning_spell_ai", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_lightning_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=0.;y= -100.},
              {w=50.;h=50.},
              (* Skill *)
              lightning_skill)
  ));
  ("freeze_spell_ai", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_freeze_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=50.;y= -100.},
              {w=50.;h=50.},
              (* Skill *)
              freeze_skill)
  ));
  ("health_spell_ai", ref (
    SpellBox ({spell_box_state = Regenerating; spell_box_sprite = Sprite.spell_btn_sprite;
            spell_box_front_image = Some (Sprite.sprite_heart_icon); spell_box_front_image_offset = {x=0.;y=0.};},
              {x=100.;y= -100.},
              {w=50.;h=50.},
              (* Skill *)
              health_skill)
  ));
  ("enemy_mana_label", ref (
    Label (
      {
        text = "enemy mana: -";
        color = {r=255;g=255;b=255;a=1.};
        font_size = 15;
      },
      {x=170.; y = Renderer.height -. 30.},
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
               ] @ spell_bar_player @ spell_bar_ai;
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
               ("game_over",ref (
                  Label (
                    {
                      text="Game Over";
                      color={r=0;g=0;b=0;a=1.};
                      font_size=40
                    },
                    {x=Renderer.width/.2. -. 170.;y=200.;},
                    {w=160.;h=40.}
                  )
                ));
                ("return", ref (Button (
                  {
                    btn_state = Neutral;
                    btn_sprite = Sprite.menu_btn_sprite1;
                    btn_label = {
                      text = "Home"; color = {r=0; g=0; b=0; a=1.}; font_size = 30
                    };
                    btn_label_offset = {x=40.;y=30./.2. +. 70./.2.};
                  },
                  {x=Renderer.width /. 2. -. 100.;y= 300.},
                  {w=200.;h=70.},
                  Some "Intro")

               ));
               ];
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

  let scene = !current_scene in
  let _ = (
    match scene.input.mouse_state with
    | Pressed ->
      print_endline (("{x="^string_of_float !current_scene.input.mouse_pos.x)^";y="^(string_of_float !current_scene.input.mouse_pos.y)^"}")
    | Released -> ()
    | Moved -> ()
  ) in
  ()

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
          let tasks = (
            if nxt = "Game" && Mapmaker.get_state_index () <> (-1) then (
              [Victory(4.,Mapmaker.get_current_state_ending ());fade_out_alpha_0_5]
            )
            else (
              [fade_out]
            )
          ) in
          current_scene := {!current_scene with tasks = tasks@[SwitchScene(nxt)]};
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
            let next_scene = get_scene_from_name "Intro" in
            current_scene := next_scene;
            current_scene := {!current_scene with tasks = [fade_in]}
          )
          (* Generate new map if more levels remaining *)
          else (
            current_scene := {game_scene with
                              tasks = [fade_in];
                              state = Mapmaker.next_state ();};
          )
        )
        (* Otherwise get the desired scene from tuple list *)
        else (
          Mapmaker.reset_states_counter ();
          let next_scene = get_scene_from_name nxt in
          current_scene := {next_scene with
                            tasks = [fade_in];};
        );
        ()
      end
    | _ -> ()
  )

(* Enemy spells *) 
let next_spell = ref "null"
let current_wait = ref 0.

let cast_ai_health sc health_spell_ref command = 
  print_endline "Trying to cast health spell";
  let mana = sc.state.enemy_mana in
  match !health_spell_ref with
  | SpellBox (spell_box_property, pos, size, lightning_skill) ->
    begin
      (* Check if can run lightning_spell *)
      if spell_box_property.spell_box_state = Neutral then (
        let cost = health_skill.mana_cost in
        if mana > float_of_int cost then (
          let health_index = Array.fold_left (fun min_id t -> 
            if min_id = -1 && t.twr_team = Enemy then 
              t.twr_id
            else if t.twr_team = Enemy && t.twr_troops < sc.state.towers.(min_id).twr_troops then 
              t.twr_id else min_id 
          ) (-1) sc.state.towers in
          print_endline (string_of_int (health_index));
          if health_index <> -1 then (
            (* set skill to regenerate *)
            next_spell := "null";
            print_endline("Ai casting Health spell!!");
            health_spell_ref := SpellBox ({spell_box_property with
                                                spell_box_state = Regenerating
                                              }, pos,size,health_skill);
            command := Skill ({health_skill with
                    tower_id = health_index;
                    allegiance = Enemy})
          )
        )
      )
      end
    | _ -> ()

let cast_ai_freeze sc freeze_spell_ref command = 
  print_endline "Trying to cast freeze spell";
  let mana = sc.state.enemy_mana in
  match !freeze_spell_ref with
  | SpellBox (spell_box_property, pos, size, lightning_skill) ->
    begin
      (* Check if can run lightning_spell *)
      if spell_box_property.spell_box_state = Neutral then (
        let cost = lightning_skill.mana_cost in
        if mana > float_of_int cost then (
          let freeze_index = Array.fold_left (fun max_id t -> 
            if t.twr_team = Player && t.twr_troops > sc.state.towers.(max_id).twr_troops then t.twr_id else max_id 
          ) 0 sc.state.towers in
          if freeze_index <> -1 then (
            (* set skill to regenerate *)
            next_spell := "null";
            print_endline("Ai casting Freeze spell!!");
            freeze_spell_ref := SpellBox ({spell_box_property with
                                                spell_box_state = Regenerating
                                              }, pos,size,freeze_skill);

            command := Skill ({freeze_skill with
                    tower_id = freeze_index;
                    allegiance = Enemy})
          )
        )
      )
      end
    | _ -> ()
let cast_ai_lightning sc lightning_spell_ref command = 
  print_endline "Trying to cast lightning spell";
  let mana = sc.state.enemy_mana in
  match !lightning_spell_ref with
  | SpellBox (spell_box_property, pos, size, lightning_skill) ->
    begin
      (* Check if can run lightning_spell *)
      if spell_box_property.spell_box_state = Neutral then (
        let kill_cost = lightning_skill.mana_cost in
        if mana > float_of_int kill_cost then (
          (* get kill amount *)
          let kill_n = (
            match lightning_skill.effect with
            | Kill n -> float_of_int n
            | _ -> 0.
          ) in
          let kill_index = Array.fold_left
              (fun acc e -> if (e.twr_troops +. 4. < kill_n) && e.twr_team = Player
                then e.twr_id else acc)
              (-1)
              sc.state.towers in
          if kill_index <> -1 then (
            (* set skill to regenerate *)
            next_spell := "null";
            print_endline("Ai casting Lightning spell!!");
            lightning_spell_ref := SpellBox ({spell_box_property with
                                                spell_box_state = Regenerating
                                              }, pos,size,lightning_skill);

            command := Skill ({lightning_skill with
                    tower_id = kill_index;
                    allegiance = Enemy})
          )
        )
      )
      end
    | _ -> ()
let get_enemy_spell sc =
  let wait_time = (
    match !State.difficulty_level with
    | Easy -> 20.
    | Medium -> 10.
    | Hard -> 1.
  ) in
  if sc.name <> "Game" then (
    Null
  )
  else (
    if (!current_wait < wait_time) then (
      print_endline ("Waiting to cast spell");
      current_wait := !current_wait +. !Renderer.delta;
      Null
    )
    else (
      print_endline ("Next spell to cast: "^(!next_spell));
      let lightning_spell_ref = List.assoc "lightning_spell_ai" sc.interface in
      let freeze_spell_ref = List.assoc "freeze_spell_ai" sc.interface in
      let health_spell_ref = List.assoc "health_spell_ai" sc.interface in

      let command = ref Null in

      let _ = (
        match !next_spell with
        | "null" -> 
          begin
            (* schedule next spell *)
            let spell_type = Random.float 1. in
            print_endline (string_of_float spell_type);
            if spell_type < 0.333 then (
              next_spell := "lightning_spell_ai";
            )
            else if spell_type < 0.667 then (
              next_spell := "freeze_spell_ai";

            )
            else (
              next_spell := "health_spell_ai";
            )
          end
        | "lightning_spell_ai" -> 
          begin 
            cast_ai_lightning sc lightning_spell_ref command;
          end
        | "freeze_spell_ai" -> 
          begin 
            cast_ai_freeze sc freeze_spell_ref command;
          end
        | "health_spell_ai" -> 
          begin
            cast_ai_health sc health_spell_ref command;
          end
        | _ -> () (* Should never happen *)
      ) in
      !command
    )
  )

let game_loop context running =
  Random.init (3110);
  print_endline ("State tests suite: "^OCamlotUnit2.run_tests State_test.tests);
  print_endline ("Ai tests suite: "^OCamlotUnit2.run_tests Ai_test.tests);
  let last_move_time = ref (Sys.time ()) in
  let base_step_length =
    match !State.difficulty_level with
    | Easy -> 7.
    | Medium -> 4.
    | Hard -> 1. in
  let next_move_step = ref (base_step_length +. (Random.float 0.4)) in

  let rec helper () =
    let new_time = Sys.time () in
    if new_time -. !last_move_time > !next_move_step then
      begin
        last_move_time := new_time;
        next_move_step := (base_step_length +. (Random.float 1.));
      let cm = Ai.get_move (!current_scene.state) !State.difficulty_level in
      current_scene :=
        {!current_scene with
         state = State.new_state_plus_delta
             !current_scene.state cm !Renderer.delta}
      end;
    let spell_cm = get_enemy_spell (!current_scene) in
    current_scene :=
      {!current_scene with
       state = State.new_state_plus_delta
           !current_scene.state spell_cm 0.};

    !current_scene.input <- enforce_one_frame_mouse ();
    print_mouse_input ();
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
