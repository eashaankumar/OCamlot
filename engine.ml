open Graphics
open State

type input = {
    left_mouse_down:bool

}

type properties = {
    num_towers:int
}

exception Init_Failure of string

let init_game prop = 
  {
    towers = [|{id=0;pos=(100,100);twr_sprite=[];twr_troops=10;twr_team=Player}|];
    num_towers = 2;
    player_score = 1;
    enemy_score = 1;
    movements = [];
    player_mana = 100;
    enemy_mana = 100
  }

let get_input () = 
    {left_mouse_down=true}

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
  let prop = {num_towers=5} in
  let init_state = init_game prop in
  let _ = game_loop init_state true in
  (* Print out ending game state if necessary before closing *)
  ()

let () = main ()