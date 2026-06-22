GET=wget
all: 7.1.1-47.tar.gz
ttf: Generic.ttf
7.1.1-47.tar.gz:
	$(GET) https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.1-47.tar.gz
unar: 7.1.1-47.tar.gz
	tar xzf 7.1.1-47.tar.gz
Generic.ttf:
	cp ImageMagick-7.1.1-47/PerlMagick/t/Generic.ttf ./
clean:
	$(RM) 7.1.1-47.tar.gz
	$(RM) Generic.ttf
