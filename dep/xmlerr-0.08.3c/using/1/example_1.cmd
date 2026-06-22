cat example_1_data.html | \
  ocaml -I ../../src/ -I ../../addons/ \
  ../../commands/htmluxtr  example_1.utmpl  example_1.tmpl
