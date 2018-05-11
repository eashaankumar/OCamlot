open Types


(*An [AI] is a module that can be used to determine the best
next move during a game for either side.*)
module type AI = sig

  (**
   * [get_move] is the command that is deemed as best
        by the AI given an initial state. It assumes the
        team to be Enemy.
     [st] - the state from which the AI will choose a legal
        command
     [difficulty] - the level of the computer player.
        ( Easy, Medium, or Hard)
   *)
  val get_move : Types.state -> Types.difficulty -> Types.command

end

module MCTS_AI : AI

module MiniMax_AI : AI
