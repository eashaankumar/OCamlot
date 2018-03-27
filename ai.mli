
module type AI = sig

  val heuristic : State.state -> float

(*[get_move] takes in a [state] module from file state.ml and
  a function that maps a state to a float value that denotes the
  value of that state. It then returns something of type [move]
  from the state file.*)
  val get_move : State.state -> (State.state -> float) -> State.move

end
