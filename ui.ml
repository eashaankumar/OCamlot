open Types

let find_ui_ref interface id = 
  List.assoc id interface

let get_label_prop label : label_property= 
  match label with
  | Label (prop,pos,size) -> prop
  | _ -> failwith "Label property not found: Not a label"

let tick interface input = 
  (* make updates to interface *)
  List.iter (fun (id,u) -> 
    match !u with
    | Button (prop, pos, size) -> begin
        (* If button is disabled, then ignore it *)
        if prop.btn_state = Disabled then 
          ()
        else begin
          let _ = 
          (* Check if mouse is inside the button *)
          if Physics.point_inside input.mouse_pos pos size then begin
            if input.mouse_state = Pressed then
              prop.btn_state <- Clicked
            else if input.mouse_state = Released then
              prop.btn_state <- Neutral
          else ()
          end in
          u := Button (prop, pos, size);
          ()
        end
      end
    | Label (label_prop, pos, size) -> begin
        u := Label (label_prop, pos, size);
        ()
      end
    | Panel (sprite, pos, size) -> begin
        let new_sprite = Sprite.tick sprite !Renderer.delta in
        u := Panel (new_sprite, pos, size);
        ()
      end
  ) interface;
  (* Update stats *)
  let ref_fps_label = find_ui_ref interface "fps" in
  (get_label_prop !ref_fps_label).text <- string_of_int !Renderer.fps;
  interface

let fps_label = Label ({text="0";color={r=255;g=20;b=147};font_size=20}, 
                       {x=Renderer.width-.30.;y=30.;},
                       {w=30.;h=30.})

let menu_button1 = Button ({btn_state = Neutral; btn_sprite = Sprite.menu_btn_sprite1},
                           {x=100.;y=100.},
                           {w=Sprite.menu_btn_sprite1.frames.(0).bounds.w;
                            h=Sprite.menu_btn_sprite1.frames.(0).bounds.h})
