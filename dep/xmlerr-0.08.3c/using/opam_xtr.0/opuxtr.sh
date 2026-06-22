curl -s https://opam.ocaml.org/packages/index-popularity.html | \
  ocaml -I ../../minibot unix.cma http.cmo ../../htmluxtr index.utmpl1 uxtr.rtmpl

curl -s https://opam.ocaml.org/packages/index-popularity.html | \
  ocaml -I ../../minibot unix.cma http.cmo ../../htmluxtr index.utmpl2 uxtr.rtmpl
