#test:
	#ocamlbuild -use-ocamlfind state_test.byte && ./state_test.byte

play:
	ocamlbuild -use-ocamlfind -pkg graphics -lib unix engine.byte && ./engine.byte

#check:
#	bash checkenv.sh && bash checktypes.sh

#zip:
#	zip a2src.zip *.ml* *.json
	
#zipcheck:
#	bash checkzip.sh

clean:
	ocamlbuild -clean
	#rm -f checktypes.ml
	#rm -f a2src.zip
