include ../../../common.mk

TEXFILES=
# add more files if needed

.PHONY: all
.PHONY: clean
.PHONY: texfiles $(TEXFILES)

all: texfiles

texfiles: $(TEXFILES)
$(TEXFILES):
	@echo "running ${@}.tex"
	${LATEX} ${LATEXOPT} ${@}.tex
	if fgrep ${LATEXLABELCHG} ${@}.log; then make $@; fi

clean:
	-rm *.aux *.log *.pdf

allclean: clean
