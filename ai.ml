open Types
open State

module MiniMax_AI = struct

  let delta = 0.1
  let max_depth = 3

  let heuristic st side =
    0.0
      (*Make a good enemy state positive*)

  let swap_allegiance side =
    match side with
    | Player -> Enemy
    | Enemy -> Player
    | Neutral -> Neutral

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
