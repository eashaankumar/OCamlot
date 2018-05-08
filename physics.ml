open Types

let point_inside point pos size =
  point.x >= pos.x && point.y >= pos.y &&
  point.x <= pos.x +. size.w &&
  point.y <= pos.y +. size.h

let add_vector2d p1 p2 =
  {x = p1.x +. p2.x; y = p1.y +. p2.y}

let scalar_mult_vector2d c p =
  {x = p.x *. c; y = p.y *. c}

let scalar_mult_bounds c s =
  {w = s.w *. c; h = s.h *. c}

let set_min_bounds (w,h) s = 
  {w = if s.w < w then w else s.w; h = if s.h < h then h else s.h}

let set_max_bounds (w,h) s = 
  {w = if s.w < w then s.w else w; h = if s.h < h then s.h else h}

let get_movement_coord mvmt st =
  let ts_index = mvmt.start_tower in
  let te_index = mvmt.end_tower in
  let ts = st.towers.(ts_index) in
  let te = st.towers.(te_index) in
  let progress = mvmt.progress in
  let start_vector = ts.twr_pos in
  let end_vector = te.twr_pos in
  add_vector2d (scalar_mult_vector2d (1.0 -. progress) start_vector)
    (scalar_mult_vector2d progress end_vector)
