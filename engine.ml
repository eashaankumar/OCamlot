type input = int

type properties = int

exception Init_Failure of string

let init_game prop = 
    []

let get_input () = 
    1

let update ste inpt = 
    []
    
val render : State.state -> unit
val game_loop : State.state -> bool -> State.state