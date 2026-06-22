for pkg in `cat pkg.list`
do
    STATS=`curl -s https://opam.ocaml.org/packages/$pkg/ | ocaml -I ../../minibot unix.cma http.cmo ../../htmlxtr stats.tmpl -`
    printf "%30s\t%s\n" $pkg $STATS
done

