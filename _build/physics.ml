open Types

let point_inside point pos size =
  point.x >= pos.x && point.y >= pos.y &&
  point.x <= pos.x +. size.w &&
  point.y <= pos.y +. size.h

let add_vector2d p1 p2 =
  {x = p1.x +. p2.x; y = p1.y +. p2.y}

let scalar_mult_vector2d p c =
  {x = p.x *. c; y = p.y *. c}

let get_movement_coord mvmt st =
  let ts_index = mvmt.start_tower in
  let te_index = mvmt.end_tower in
  let ts = st.towers.(ts_index) in
  let te = st.towers.(te_index) in
  let progress = mvmt.progress in
  let start_vector = ts.twr_pos in
  let end_vector = te.twr_pos in
  add_vector2d (scalar_mult_vector2d start_vector (1.0 -. progress))
    (scalar_mult_vector2d end_vector progress)
