wget https://opam.ocaml.org/ > opam.html

echo "News"
cat opam.html | ./htmlxtr opam-news.tmpl - > news.txt
cat news.txt


echo "Num"
cat opam.html | ./htmlxtr opam-num-pkg.tmpl - > num.txt
cat num.txt


