# SRC_OCAML = parse_cli.ml libcsv.ml libunix.ml sum_avg.ml main.ml
# SRC_OCAML = parse_cli.ml libcsv.ml libunix.ml crud_csv.ml mainPersistance.ml
# SRC_OCAML = parse_cli.ml crud_csv.ml
SRC_OCAML = dao.ml file_io.ml crud_operations.ml cli.ml 

SOURCES = $(addprefix src/,$(SRC_OCAML))
PACKS = str
RESULT = crudocaml.exe
#RESULT = persist
all: byte-code

-include OCamlMakefile
