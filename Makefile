include common.mk

TEXDIRS=titlepage \
abstract \
declaration \
content/introduction \
content/reschap1 \
content/reschap2 \
content/reschap3 \
content/conclusion \
content/appendix
# add more directories here, e.g. directories for result chapters...

IMAGEDIRS=content/reschap1/images \
content/reschap2/images \
content/reschap3/images

CLEANDIRS = $(IMAGEDIRS:%=clean-%)

THESIS=thesis

SEARCH=

.PHONY: texdirs $(TEXDIRS)
.PHONY: imagedirs $(IMAGEDIRS)
.PHONY: cleandirs $(CLEANDIRS)
.PHONY: fullthesis
.PHONY: thesis
.PHONY: run
.PHONY: bib
.PHONY: ref
.PHONY: spellcheck
.PHONY: clean
.PHONY: allclean

default: thesis

imagedirs: $(IMAGEDIRS)
$(IMAGEDIRS):
	@$(MAKE) -C $@ all

fullthesis: allclean imagedirs ref thesis

thesis:run bib nomtest
	# check for missing/changed citations/labels:
	@if fgrep ${LATEXMISSCITATION} ${THESIS}.log; then make run; fi
	@if fgrep ${LATEXCITATIONCHG} ${THESIS}.log; then make run; fi
	@if fgrep ${LATEXRERUN} ${THESIS}.log; then make run; fi
	@if fgrep ${LATEXMULTIPLELABEL} ${THESIS}.log; then make run; fi
	@if fgrep ${LATEXLABELCHG} ${THESIS}.log; then make run; fi
	@make warnings

run:
	@${LATEX} ${LATEXOPT} ${THESIS}

bib:ref
	test -s ${THESIS}.aux || { echo "${THESIS}.aux not found. Running LaTeX on ${THESIS}.tex ..."; make run; }
	@${BIBTEX} ${THESIS}

ref:
	@$(MAKE) -C references all

index:
	makeindex ${THESIS}.nlo -s nomencl.ist -o ${THESIS}.nls

nomtest:
	@echo "checking if nomenclature is present and if so, if it needs to be update"
	@-if test -s $(THESIS).nlo; then \
	  if test -s $(THESIS).nlo-old; then \
	    diff -u $(THESIS).nlo $(THESIS).nlo-old > $(THESIS).nlo-diff; \
	    if test -s $(THESIS).nlo-diff; then \
	      echo "diff in nomenclature found"; \
	      make nomupdate; \
	    fi \
	  else \
	    echo "$(THESIS).nlo-old not found (or empty)"; \
	    make nomupdate; \
	  fi \
	fi
	# removing thesis.nlo-diff if it exists
	test -f $(THESIS).nlo-diff && rm $(THESIS).nlo-diff

nomupdate:index run
	@cp -p ${THESIS}.nlo ${THESIS}.nlo-old
	@echo "------------------------------------------"
	@echo "changes in the Nomenclature were found"
	@echo "Nomenclature was updated"
	@echo "------------------------------------------"

warnings:
	@if fgrep ${LATEXWARNING} ${THESIS}.log > /dev/null; then echo "+++ The following warnings were found +++"; ${FGREP} ${LATEXWARNING} ${THESIS}.log; else echo "+++ No warnings found +++"; fi
	@if fgrep ${LATEXOFULL} ${THESIS}.log > /dev/null; then echo "+++ The following OVERFULL boxes were found +++"; ${FGREP} -B 1 ${LATEXOFULL} ${THESIS}.log; else echo "+++ No overfull boxes found +++"; fi
	@if fgrep ${LATEXUFULL} ${THESIS}.log > /dev/null; then echo "+++ The following UNDERFULL boxes were found +++"; ${FGREP} -B 1 ${LATEXUFULL} ${THESIS}.log; else echo "+++ No underfull boxes found +++"; fi
	@if fgrep ${LATEXBADNESS} ${THESIS}.log > /dev/null; then echo "+++ The following BADNESS warnings were found +++"; ${FGREP} -B 1 ${LATEXBADNESS} ${THESIS}.log; else echo "+++ No badness warnings found +++"; fi
	@if fgrep ${LATEXMULTIPLELABEL} ${THESIS}.log > /dev/null; then echo "+++ FIX YOUR LABELS! Exiting +++"; ${GREP} ${LATEXMULTIPLYLABELS} ${THESIS}.log; ${FGREP} ${LATEXMULTIPLELABEL} ${THESIS}.log; fi
	@if fgrep ${LATEXMISSCITATION} ${THESIS}.log > /dev/null; then echo "+++ STILL MISSING CITATIONS, FIX YOUR BIB-FILES +++"; ${FGREP} ${LATEXMISSCITATION} ${THESIS}.log; fi
	@if fgrep ${LATEXRERUN} ${THESIS}.log > /dev/null; then echo "+++ Rerun ${LATEX} to get rid of some warnings +++"; fi

spellcheck: texdirs
	@echo "spell check on ${THESIS}.tex"
	sleep 3
	@${ASPELL} $(ASPELLOPT) ${THESIS}.tex

texdirs: $(TEXDIRS)
$(TEXDIRS):
	@$(MAKE) -C $@ spellcheck

texcount:
	@${TEXCOUNT} ${TEXCOUNTOPT} ${THESIS}.tex
	@echo "and pdftops ... ps2ascii: "
	pdftops ${THESIS}.pdf; ps2ascii ${THESIS}.ps | wc -w

clean:
	@-rm *.aux *.log *.blg *.bbl *.lof *.lot *.toc *.fff *.out *.ps *nls *ilg *.nlo *nlo-old *~

allclean: clean $(CLEANDIRS)
$(CLEANDIRS): 
	@echo "cleaning directory $(@:clean-%=%):"
	@$(MAKE) -C $(@:clean-%=%) allclean

search:
	@echo "searching all texfiles for $(SEARCH):"
	@find . -name "*.tex" | xargs grep -i --color=auto $(SEARCH)

