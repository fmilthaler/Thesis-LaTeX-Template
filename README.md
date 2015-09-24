# PhDThesisTemplateICL
This is a LaTeX template for PhD theses at Imperial College London.

## Who is it for
This aims at PhD students at Imperial College London who start writing up their work in LaTeX.

## How is it organised
See a list and short description of directories and files in this repository. Forgive me for using good ol' non-formatted ASCII text...
```
Directory structure:
  + Makefile
  + common.mk
  + phd_thesis.tex (main tex-file that you run through pdflatex/lualatex)
  + preamble/
    + preamble.tex (contains documentclass, usepackage commands and defines page layout)
    + fancyheaders.tex (defines custom header/footer styles using "fancyhdr")
    + laodlistings.tex (some definitions for printing code)
    + mycommands.tex (defining custom commands)
  + titlepage/
    + Makefile
    + icl_crest.png (Traditional IC logo, you are not supposed to use this for official prints)
    + titlepage_wo_logo.tex (title page without the logo, this is the default)
    + titlepage.tex (title page with the logo, do NOT use this for official prints!)
  + declaration/
    + Makefile
    + copyright.tex
    + declaration.tex
  + abstract/
    + Makefile
    + abstract.tex
    + acknowledgements.tex
    + quote.tex
  + references/
    + Makefile
    + books.bib
    + Theses.bib
    + parallel-algorithms.bib
    + create_bib_list.sh (bash script: automatically generates a .tex file that includes all present .bib files,
                          just put all your .bib files in this directory, rest is done automatically)
  + content/
    + intro/
      + Makefile
      + intro.tex (your introduction)
    + reschap1/ (1st main/result chapter)
      + Makefile
      + main.tex (text for this chapter)
      + images/
        + Makefile
        + fem_basis_function_linear_cg.tex
        + ... (sub-directory for plots/images/pictures etc.)
      + python/
        + example_code.py (python code that is printed as it is)
    + reschap2/ (2nd main/result chapter)
      + Makefile
      + main.tex
      + images/
        + ... (sub-directory for plots/images/pictures etc.)
    + reschap3/ (3rd main/result chapter)
      + Makefile
      + main.tex
      + images/
        + ... (sub-directory for plots/images/pictures etc.)
```
