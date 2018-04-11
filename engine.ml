open Graphics
open State

type input = {
    left_mouse_down:bool
}

type properties = {
    num_towers:int
}

exception Init_Failure of string

let init_game prop : state = 
  print_endline "Starting game!";
  open_graph "";
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
  ste

let render ste = 
  ()

let game_loop ste run =
  ste
  
let close_game ste = 
  close_graph ();
  print_endline "Closing Game!";
  