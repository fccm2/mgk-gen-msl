wget https://opam.ocaml.org/packages/index-date.html > list-by-date.html
cat index-date.html | ./htmlxtr get-list-by-date.tmpl - > get-list-by-date.txt
