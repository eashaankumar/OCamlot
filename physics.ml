open Types

let point_inside point pos size = 
  point.x >= pos.x && point.y >= pos.y &&
  point.x <= pos.x +. size.w &&
  point.y <= pos.y +. size.h
