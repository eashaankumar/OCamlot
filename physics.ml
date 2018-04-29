open Types

let point_inside point pos size = 
  point.x >= pos.x && point.y >= pos.y &&
  point.x <= pos.x +. size.w &&
  point.y <= pos.y +. size.h

let add_vector2d p1 p2 =
  {x = p1.x +. p2.x; y = p1.y +. p2.y}

