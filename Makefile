PREFIX = arm-cortexm3-eabi-
PROJ = -Ptricopter

GNATMAKE = $(PREFIX)gnatmake $(PROJ)
GNATCLEAN = $(PREFIX)gnatclean $(PROJ)
GNATCOMPILE = $(PREFIX)gnat compile $(PROJ)

all: main

main:
	$(GNATMAKE)

clean:
	$(GNATCLEAN)

%.s: %.adb
	$(GNATCOMPILE) -S -o $@ $<

%.s: %.ads
	$(GNATCOMPILE) -S -o $@ $<


.PHONY: all main clean
