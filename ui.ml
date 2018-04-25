open Types

let tick interface input = 
  List.map (fun (id,u) -> 
    match u with
    | Button (prop, pos, size) -> begin
        id,Button (prop, pos, size)
      end
    | Label (label_prop, pos, size) -> begin
        id,Label (label_prop, pos, size)
      end
    | Panel (sprite, pos, size) -> begin
        let new_sprite = Sprite.tick sprite !Renderer.delta in
        id,Panel (new_sprite, pos, size)
      end
  ) interface