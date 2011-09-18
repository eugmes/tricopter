PREFIX = arm-cortexm3-eabi-

all: main

main:
	$(PREFIX)gnatmake -Ptricopter

clean:
	$(PREFIX)gnatclean -Ptricopter

.PHONY: all main clean
