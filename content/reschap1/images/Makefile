include ../../../common.mk

TEXFILES=./1way_coupling_prescribed_rotation \
./fem_basis_function_linear_cg \
./fem_basis_function_constant_dg
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
