DATE = $(shell date --iso)

all: \
  opdlpub.$(DATE).log \
  opstats.$(DATE).log \
  #EOL

pkg.list:
	sh opxtr.sh > $@

opstats.$(DATE).log: pkg.list
	sh opstats.sh > $@

opdlpub.$(DATE).log:
	sh opuxtr.sh > $@

clean:
	$(RM) pkg.list *.log
