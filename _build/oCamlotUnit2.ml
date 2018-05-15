type test = string * (unit -> bool)

let (>::) (s : string) (e : (unit -> bool)) : test = (s, e)

let assert_equal = ( = )

let run_tests (tests: test list) : string = 
  let test_fail = ref None in
  let _ = List.fold_left (fun acc (name,testthunk) -> 
    if acc = false then false
    else (
      if testthunk () then (
        true
      )
      else (
        (* Store the test name *)
        test_fail := Some name;
        false
      )
    )
  ) true tests in
  match !test_fail with
  | None -> "All tests passsed!"
  | Some(name) -> "Failed: "^name
