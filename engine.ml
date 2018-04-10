open Graphics

type input = int

type properties = int

exception Init_Failure of string

let init_game prop = 
    []

let get_input () = 
    1

let update ste inpt = 
    []

let render ste = 
    ()

let game_loop ste run =
    ste

(* [main ()] starts the REPL, which prompts for a game to play.
 * You are welcome to improve the user interface, but it must
 * still prompt for a game to play rather than hardcode a game file. *)
let main () =
  (*ANSITerminal.(print_string [red]
    "\n\nWelcome to the 3110 Text Adventure Game engine.\n");
  play_game (file_prompt ())*)
  (* TODO: Obtain properties *)
  (* let prop = blah *)
  let init_state = init_game prop in
  let end_state = game_loop init_state true in
  (* Print out ending game state if necessary before closing *)
  ()

let () = main ()