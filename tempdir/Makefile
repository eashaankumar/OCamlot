build:
	ocamlbuild -use-ocamlfind \
		-plugin-tag "package(js_of_ocaml.ocamlbuild)" \
		-no-links \
		main.d.js
	ocamlbuild -use-ocamlfind oCamlotUnit2.cmo types.cmo physics.cmo renderer.cmo sprite.cmo ui.cmo state.cmo state_test.cmo ai.cmo ai_test.cmo mapmaker.cmo engine.cmo -r

clean:
	ocamlbuild -clean

#test:
#	ocamlbuild -use-ocamlfind helper.cmo types.cmo state.cmo ai.cmo command.cmo gui.cmo -r
#	ocamlbuild -use-ocamlfind -pkg oUnit test_state.cmo test_ai.cmo test_command.cmo -r
#	ocamlbuild -use-ocamlfind test_state.byte && ./test_state.byte
