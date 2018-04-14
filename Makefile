all: byte
	js_of_ocaml engine.byte

byte:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx engine.byte

clean:
	ocamlbuild -clean