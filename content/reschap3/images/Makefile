include ../../../common.mk

TEXFILES=$(wildcard *.tex)

.PHONY: all
.PHONY: clean
.PHONY: texfiles $(TEXFILES)

all: texfiles

texfiles: $(TEXFILES)
$(TEXFILES):
	@echo "running ${@}.tex"
	${LATEX} ${LATEXOPT} ${@}
	if fgrep ${LATEXLABELCHG} ${@:.tex=.log}; then make $@; fi

clean:
	-rm *.aux *.log *.pdf

allclean: clean
