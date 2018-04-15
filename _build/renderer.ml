
let width = 1000.
let height = 800.

let x = ref 0.

let render context state =
  print_endline "render";
  context##clearRect (0., 0., width, height);
  context##fillRect (!x, 0., 100., 100.);
  x := !x +. 1.;
  ()