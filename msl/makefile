#START_XML='start-00.xml'
#START_XML='start-01.xml'
START_XML='start-02.xml'
#START_XML='start-03.xml'
#START_XML='start-04.xml'
test: rose.png
	ocaml -I ../dep/xmlerr-0.08.3c/src/ xmlerr.cmo -I ../src/ magick.cma xmgk.ml $(START_XML)
rose.png:
	convert rose: $@
clean:
	$(RM) rose-2.jpg
	$(RM) rose-3.jpg
	$(RM) rose-4.jpg
	$(RM) rose.png
	$(RM) line-01.png
	$(RM) text-01.png
	$(RM) circle-01.png
