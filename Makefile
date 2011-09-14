all: main

main:
	gnatmake -Ptricopter

clean:
	gnatclean -Ptricopter

.PHONY: all main clean
