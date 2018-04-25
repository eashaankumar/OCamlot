open Types

let tick ui input = 
  Array.map (fun u -> 
    match u with
    | Button (prop, pos, size) -> begin
        (* New button state based on mouse input *)
        let (new_btn_state, sprite_branch)= (
          match input.mouse_state with
          | Pressed -> Clicked,prop.clicked_sprite
          | Released -> Neutral,prop.neutral_sprite
          | Moved -> Neutral,prop.neutral_sprite
        ) in
        (* Reset animation if new state *)
        let sprite_to_draw = begin
          if new_btn_state <> prop.btn_state then
            Sprite.reset_to_first_frame sprite_branch
          else 
            sprite_branch
        end in
        (* Update sprite animation *)
        let new_sprite = Sprite.tick (sprite_to_draw) !Renderer.delta in
        (* Update correct sprite branch *)
        match new_btn_state with
        | Clicked -> Button (
          {btn_state = new_btn_state; 
          clicked_sprite = new_sprite; 
          disabled_sprite = prop.disabled_sprite;
          neutral_sprite = prop.neutral_sprite;}
          , pos, size)
        | Disabled -> Button (
          {btn_state = new_btn_state; 
          clicked_sprite = prop.new_sprite; 
          disabled_sprite = new_sprite;
          neutral_sprite = prop.neutral_sprite;}
          , pos, size)
        
      end
    | Label (label_prop, pos, size) -> begin
        Label (label_prop, pos, size)
      end
    | Panel (sprite, pos, size) -> begin
        let new_sprite = Sprite.tick sprite !Renderer.delta in
        Panel (new_sprite, pos, size)
      end
  ) ui