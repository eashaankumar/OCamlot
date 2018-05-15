open Types
open State


(*Node (state, command from parent, win_pctg, times_played,
  daughter_nodes, parent_node, is_max_state)*)
type tree =
  | Leaf of command * float
  | Node of Types.state * command * float * float * ((tree ref) array) *
            tree ref * bool

val delta : float

(**
 * [get_random_command] returns a completely random legal
      move for the team with a given allegiance
   [st] - the state from which to get legal moves
   [allegiance] - the team that's going to move
 *)
  val get_random_command : Types.state -> Types.allegiance -> Types.command

(**
 * [random_playout] is a the result of a random game
      starting from [st] with the first move being a
      max move if [max_bool] is true, else it's a
      min move
   [st'] - the starting state
   [max_bool'] - whether or not the first move is a max node
 *)
  val random_playout : Types.state -> bool -> float

(**
 * [get_value] is the value of the tree [t] used for determining
      which node to be selected next
   [t] - the sub-tree in question
   [is_max] - whether or not the root of [t] is a max node
 *)
  val get_value : tree -> bool -> float

(**
 * [get_extreme_child] is the next node to be chosen based on
      the value of the nodes
   [node] - the node whose children nodes are chosen from
   [is_max] - whether node is a max node
 *)
  val get_extreme_child : tree ref -> bool -> tree ref

(**
 * [update_node] updates the value of [node] depending on the
      results of a random playout [win_loss]
   [node] - the node to update
   [win_loss] - the win-value of the random playout (loss:0,win:1)
 *)
  val update_node : tree ref -> float -> unit

(**
 * [update_tree] recursively updates the current node [node] and
      all parent nodes with a random playout result
   [node] - the bottom node to be updated
   [win_loss] - the win-value of the random playout (loss:0,win:1)
 *)
  val update_tree : tree ref -> float -> unit

(**
 * [new_node] is a new node created after selecting a command
      [cm] from the best available node.
   [node] - the parent node for the new node
   [cm] - the command to go from the old state in [node] to
      the new state in [new_node]
 *)
  val new_node : tree ref -> Types.command -> tree ref

(**
 * [beginning_node] is the root node of the entire tree
   [st] - the beginning state of the tree
 *)
  val beginning_node : Types.state -> tree ref

(**
 * [create_tree] instantiates a new tree starting with state and
      runs [iters] number of [add_path] commands to it to form the tree
   [st] - the starting state of the tree
   [iters] - the number of times to [add_path]
 *)
  val create_tree : Types.state -> int -> tree ref

(**
 * [get_highest_percentage] is the child node with the highest
      win percentage
   [node] - the parent node whose best child node will be returned
 *)
  val get_highest_percentage : tree ref -> tree ref

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
