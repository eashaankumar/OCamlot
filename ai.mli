
(*An [AI] is a module that can be used to determine the best
next move during a game for either side.*)
module type AI = sig

  (*[heuristic] is a function that takes in a [state] module and
    returns a float which denotes the state's "strength".
    [heuristic] with one state's allegiance is the negation
    of [heuristic] with the opposing allegiance*)
  val heuristic : State.state -> State.allegiance-> float

(*[get_move] takes in a [state] module from file state.ml and
  a function that maps a state to a float value that denotes the
  value of that state. It then returns something of type [move]
  from the state file.*)
  val get_move : State.state -> (State.state -> State.allegiance -> float)
    -> State.move

end
