PREFIX = arm-cortexm3-eabi-
PROJ = -Ptricopter

GNATMAKE = $(PREFIX)gnatmake $(PROJ)
GNATCLEAN = $(PREFIX)gnatclean $(PROJ)
GNATCOMPILE = $(PREFIX)gnat compile $(PROJ)
OBJDUMP = $(PREFIX)objdump

all: main

main:
	$(GNATMAKE)

clean:
	$(GNATCLEAN)
	rm -f *.map

%.s: %.adb
	$(GNATCOMPILE) -S -o $@ $<

%.s: %.ads
	$(GNATCOMPILE) -S -o $@ $<

objdump:
	$(OBJDUMP) -d led_demo.elf

.PHONY: all main clean
