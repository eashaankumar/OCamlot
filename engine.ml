
open Js_of_ocaml
open Js_of_ocaml_lwt

(* type definitions *)

(* fixed vars *)
let n = 12

let h = 20.
let w = floor (h *. sqrt 3. /. 2. +. 0.5)

(* vars *)
let x = ref 0.


let update () =
  print_endline "blah";
  x := !x +. 1.;

(****)

module Html = Dom_html

let top = Js.string "#a8a8f6"
let left = Js.string "#d9d9d9"
let right = Js.string "#767676"
let edge = Js.string "#000000"

let create_canvas () =
  let d = Html.window##.document in
  let c = Html.createCanvas d in
  c##.width := 1000;
  c##.height := 800;
  c

let render ctx canvas =
  let c = canvas##getContext (Html._2d_) in
  (* Clear Screen *)
  c##setTransform 1. 0. 0. 1. 0. 0.;
  c##clearRect 0. 0. (float canvas##.width) (float canvas##.height);
  (*c##setTransform 1. 0. 0. 1. 0.5 0.5;*)
  c##.globalCompositeOperation := Js.string "lighter";
  c##.fillStyle := Js.string "#0000FF";
  c##fillRect !x 0. 100. 100.;
  ctx##drawImage_fromCanvas canvas 0. 0.
  
let (>>=) = Lwt.bind

let rec main_loop c c' =
  Lwt_js.sleep 0.01 >>= fun () ->
  (*let need_redraw = ref false in
  for _i = 0 to 99 do
    need_redraw := update || !need_redraw
  done;
  if !need_redraw then render c c';*)
  update ();
  render c c';
  main_loop c c'

let start _ =
  let c = create_canvas () in
  let c' = create_canvas () in
  Dom.appendChild Html.window##.document##.body c;
  let c = c##getContext Html._2d_ in
  c##.globalCompositeOperation := Js.string "copy";
  render c c';
  ignore (main_loop c c');
  Js._false

let _ =
Html.window##.onload := Html.handler start
