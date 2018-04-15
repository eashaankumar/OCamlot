
let width = 800.
let height = 600.

let x = ref 0.

let render context state =
  print_endline "render";
  context##clearRect (0., 0., width, height);
  (* Draw canvas background *)
  context##fillStyle <- Js.string "#FFFFFF";
  context##fillRect (0., 0., width, height);
  (* Draw entities *)
  context##fillStyle <- Js.string "#000000";
  context##fillRect (!x, 0., 100., 100.);
  x := !x +. 1.;
  ()