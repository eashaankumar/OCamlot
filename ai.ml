open Types
open State

module MiniMax_AI = struct

  let delta = 0.1
  let max_depth = 3

  let heuristic st side =
    0.0
      (*Make a good enemy state positive*)

(**
 * Returns: [swap_allegiance] is the opposite allegiance of
 *          [side]. In the case of Neutral, Neutral is returned.
 * Parameters: [side] is of type allegiance
 *)
  let swap_allegiance side =
    match side with
    | Player -> Enemy
    | Enemy -> Player
    | Neutral -> Neutral

  (**
   * Returns: [minimax_value] runs the minimax algorithm starting
   *          at [st] with the other standard minimax parameters.
   * Parameters: [st] is the beginning state for the algorithm
   *              [depth] is the number of moves deep to search
   *              [minV]/[maxV] are float values for alpha-beta pruning
   *              [side] is an allegiance that determines whether this
   *                    is a max or a min state
   *              [original_side] is the side that is to be maximized
   *)
  let rec minimax_value st depth minV maxV side original_side=
    if (State.gameover st) || depth = 0 then
  		heuristic st side
  	else
  	if (side = original_side) (*If it's a max state*) then
      let value = minV in
      let moves = State.possible_moves st side in

  		let rec loop m loop_max v =
  			let this_move = Array.get moves m in
  			let new_st = State.new_state_plus_delta st this_move delta in
        let v_prime =
          minimax_value new_st (depth-1) v maxV (swap_allegiance side) original_side in
  			if v_prime > v then
          let v = v_prime in
          if v>maxV then
            maxV
          else
          if (m+1) < loop_max then
    				loop (m+1) loop_max v
    			else
    				v

        else
    			if v>maxV then
            maxV
          else
          if (m+1) < loop_max then
    				loop (m+1) loop_max v
    			else
  				  v in

  		loop 0 (Array.length moves) value

  	else (*If it's a min state*)
  		let value = maxV in
  		let moves = State.possible_moves st side in
  		let rec loop m loop_max v=
  			let this_move = Array.get moves m in
  			let new_st = State.new_state_plus_delta st this_move delta in
        let v_prime =
          minimax_value new_st (depth-1) minV v (swap_allegiance side) original_side in
        if v_prime < v then
          let v = v_prime in
          if v<minV then
            minV
          else
          if (m+1) < loop_max then
    				loop (m+1) loop_max v
    			else
    				v

        else
    			if v<minV then
            minV
          else
          if (m+1) < loop_max then
    				loop (m+1) loop_max v
    			else
  				  v in

  		loop 0 (Array.length moves) value


  let get_move st =
    let best_move = ref Rest in
    let best_score = ref (0.0 -. max_float) in
    let moves = State.possible_moves st Enemy in
    let num_moves = Array.length moves in
    for move=0 to (num_moves-1) do
      let this_move = (Array.get moves move) in
      let st2 = State.new_state_plus_delta st this_move delta in
      let move_score = minimax_value st2 max_depth (0.0 -. max_float) max_float Player Enemy in
      if move_score > !best_score then
        best_score := move_score;
        best_move := this_move;
    done;
    !best_move


end

module MCTS_AI = struct
  (*Time-step*)
  let delta = 0.1
  (*Constant in front of the MTCS value function*)
  let c = sqrt 2.0
  (*Number of times to run the algorithm*)
  let iterations = 100

  (* fraction of wins, number of times played, daughter nodes,
   * commands that got here, possible commands from here*)

  (*Node (state, command from parent, win_pctg, times_played,
  daughter_nodes, parent_node, is_max_state)*)
  type tree =
    | Leaf of command * float
    | Node of Types.state * command * float * float * ((tree ref) array) * tree ref * bool


  let to_allegiance max_bool =
    if max_bool then Enemy else Player

  let get_random_command st allegiance =
    let commands = possible_moves st allegiance in
    let range = Array.length commands in
    let index = Random.int range in
    Array.get commands index

  let rec random_playout st max_bool =
    if State.gameover st then
      if st.player_score > st.enemy_score then
        0.0
      else
        1.0
    else
      if max_bool then
        let cm = get_random_command st Enemy in
        let new_state = new_state_plus_delta st cm delta in
        random_playout new_state false
      else
        let cm = get_random_command st Player in
        let new_state = new_state_plus_delta st cm delta in
        random_playout new_state true

  let get_times_sampled t =
    match t with
    | Node(st,cm,v,n,children,parent,_) -> n
    | Leaf _ -> 1.0 (*so that when log doesn't blow up*)

  let get_value t is_max =
    match t with
    | Leaf (_,v)-> 10000.0
    | Node(st,cm,v,n,children,parent,_) -> begin
        if is_max then
          v +. c *. sqrt (log (get_times_sampled !parent))/.n
        else
          (1.0-.v) +. c *.sqrt (log (get_times_sampled !parent))/.n
      end

  let create_children st allegiance =
    let moves = possible_moves st allegiance in
    Array.map (fun cm -> ref (Leaf (cm,10000.0))) moves

  let get_extreme_child node is_max =
    let func = if is_max then (>) else (<) in
    let children,is_max =
      match !node with
      | Node(_,_,_,_,chldrn,_,is_max_bool) -> chldrn,is_max_bool
      | Leaf _ -> [||],true in
    Array.fold_left
      (fun acc child -> if (func (get_value !child is_max) (get_value !acc is_max)) then child else acc)
      (Array.get children 0) children

  let update_node node win_loss =
    match !node with
    | Node(st,cm,v,n,children,parent,is_max) -> begin
        node := Node(st,cm,v +. (win_loss-.v)/.(n+.1.0),n+.1.0,children,parent,is_max);
      end
    | Leaf _ -> ()

  let rec update_tree node win_loss =
    match !node with
    | Node(st,cm,v,n,children,parent,is_max) -> begin
        update_node node win_loss;
        update_tree parent win_loss
      end
    | Leaf _ -> ()

  let new_node node cm =
    match !node with
    | Node(st,cm,v,n,children,parent,is_max) ->
      let new_st = new_state_plus_delta st cm delta in
      let rand_play = random_playout new_st is_max in
      update_tree parent rand_play;
      ref (Node(new_st, cm, rand_play, 0.0,
                create_children st (to_allegiance (not is_max)), node, not is_max))
    | Leaf _ -> node

  let beginning_node st =
    let children = create_children st Enemy in
    ref (Node(st,Rest,0.0,0.0,children,ref (Leaf(Rest,1.0)),true))

  let rec add_path t = begin
    match !t with
    | Node(st,cm,v,n,children,parent,is_max) -> begin
        let ex_child = get_extreme_child t is_max in
        match !ex_child with
        | Node _ -> add_path ex_child
        | Leaf (cm,_) -> ex_child := !(new_node t cm)
      end
    | Leaf _ -> ()
  end

  let create_tree st iters =
    let root = beginning_node st in
    let counter = ref 0 in
    while !counter < iters do
      add_path root;
    done;
    root

  let win_pctg node =
    match !node with
    | Node(st,cm,v,n,children,parent,is_max) -> v
    | Leaf _ -> 0.0

  let get_highest_percentage node =
    let func = (>) in
    let children =
      match !node with
      | Node(_,_,_,_,chldrn,_,_) -> chldrn
      | Leaf _ -> [||] in
    Array.fold_left
      (fun acc child -> if (func (win_pctg child) (win_pctg acc)) then child else acc)
      (Array.get children 0) children

  let get_move st =
    let t = create_tree st iterations in
    let child = get_highest_percentage t in
    match !child with
    | Node(_,cm,_,_,_,_,_) -> cm
    | Leaf(cm,_) -> cm


end
