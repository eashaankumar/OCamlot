open Types

val tick : interface -> input -> interface

val fps_label : ui_element 

val find_ui_ref : interface -> string -> (ui_element ref) option

val get_label_prop : ui_element -> label_property
