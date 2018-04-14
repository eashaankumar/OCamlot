open State
open Js_of_ocaml
open Js_of_ocaml_lwt

module Html = Dom_html

(* Definitions *)
let (>>=) = Lwt.bind

let active_state = ref {
  towers = [||];
  num_towers = 0;
  player_score = 0;
  enemy_score = 0;
  movements = [];
  player_mana = 0;
  enemy_mana = 0
}

(* Helper Functions *)
(**
 * [create_canvas] creates the game screen
 * returns: [c] canvas
 *)
let create_canvas () =
  let d = Html.window##.document in
  let c = Html.createCanvas d in
  c##.width := 1000;
  c##.height := 800;
  c

(* Functions *)
let init_game () = ()

let update () = ()

let render ctx canvas =
  let c = canvas##getContext (Html._2d_) in
  (* Clear Screen *)
  c##setTransform 1. 0. 0. 1. 0. 0.;
  c##clearRect 0. 0. (float canvas##.width) (float canvas##.height);
  c##.globalCompositeOperation := Js.string "lighter";
  c##.fillStyle := Js.string "#0000FF";
  c##fillRect 0. 0. 100. 100.;
  ctx##drawImage_fromCanvas canvas 0. 0.;
  ()
  

let close_game () = 
  print_endline ("Game Over!")

let rec game_loop c c' = 
  Lwt_js.sleep 0.01 >>= fun () ->
  update ();
  render c c';
  game_loop c c'

(**
 * [main] starts the game creation process
 *)
let main _ =
  let c = create_canvas () in
  let c' = create_canvas () in
  Dom.appendChild Html.window##.document##.body c;
  let c = c##getContext Html._2d_ in
  c##.globalCompositeOperation := Js.string "copy";
  (*render c c';*)
  (* Start Game *)
  init_game ();
  ignore (game_loop c c');
  close_game ();
  Js._false

let _ = Html.window##.onload := Html.handler main 