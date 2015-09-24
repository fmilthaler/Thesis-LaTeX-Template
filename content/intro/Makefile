include ../../common.mk

TEXFILES=./*.tex 

.PHONY: texfiles $(TEXFILES)

spellcheck: $(TEXFILES)
$(TEXFILES):
	@echo "spell check on ${@}"
	@sleep 1
	${ASPELL} $(ASPELLOPT) ${@}

