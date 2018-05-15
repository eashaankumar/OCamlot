type test = string * (unit -> bool)

val assert_equal : 'a -> 'a -> bool

val (>::) : string -> (unit -> bool) -> test

(* a list of tests against the state interface. *)
val run_tests : test list -> string
