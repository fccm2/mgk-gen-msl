#!/bin/bash

XMLERR_DIR="../../"

#for I in `seq 0 860`
for I in `seq 600 640`
do
    URL="http://caml.inria.fr/cgi-bin/hump.en.cgi?contrib=$I"
    echo "; $I"
    wget --quiet -O - $URL | ocaml -I $XMLERR_DIR xmlerr.cma hump.ml
done
