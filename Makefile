all: byte
	js_of_ocaml cubes.byte

byte:
	ocamlbuild -use-ocamlfind -pkgs js_of_ocaml-lwt,js_of_ocaml.ppx,lwt.ppx cubes.byte

clean:
	ocamlbuild -clean