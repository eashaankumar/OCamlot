all: byte
	js_of_ocaml ocamlot.byte

byte:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx ocamlot.byte

clean:
	ocamlbuild -clean