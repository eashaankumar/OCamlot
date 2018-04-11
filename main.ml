open Engine

(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
let main () =
  let prop = {num_towers=5} in
  let init_state = init_game prop in
  let end_state = game_loop init_state true in
  (*close_game end_state;*)
  

let () = main ()