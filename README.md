# Thesis-LaTeX-Template
This template aims at students of any degree (Bachelor, Master, PhD) who start writing up their thesis in LaTeX, especially useful for students at Imperial College London, as some of the page layout is set according to the requirements (please double check), but generic enough to be useful at any University. Knowledge of how to use LaTeX (and ideally Unix/Linux) is a prerequisite.

## Features
- Supports PDFLaTeX, LuaLaTeX
- Customised Page layouts, Header and Footer styles
- Examples for fancy figures (using tikz) and Tables (using pgfplotstable), as well as support for very large tables that need to be rotated to fit on a page.
- File structure to separate files of different chapters
- A Bash script automatically includes all your `.bib` files in one file `references/references.tex`, that way you can organise and split your references across several `.bib` files without keeping track of them (without manually updating `\bibliography{...}` in your `.tex` file)
- Besides having a good file structure, this template provides recursive use of Makefiles. The **Makefiles ensure a minimum number of compilations to resolve all changes** in references/citations, thus the Makefiles offer **similar benefits of the tool `latexmk` and they even go beyond**. **This template stands out from others due to the customised Makefiles**. They allow for (please find a more detailled description further below):
 - creating your thesis as a pdf,
 - automatically detecting changes in references and automatically running LaTeX on your document again (only if required), until all references (in bibliography or to floating objects) are resolved.
 - creating separate image files (e.g. with tikz) stored in subdirectories,
 - print out warnings from LaTeX output files,
 - spellcheck your `.tex` files,
 - search a pattern in all your `.tex` files (in all subdirectories) to quickly find a certain pattern,
 - perform a word count on your document,
 - clean your directory (and subdirectories) from output files

## How it is organised
See a list and short description of directories and files in this repository to understand how the files are organised and where to find what.

+ `Makefile` (main Makefile which targets are explained below)
+ `common.mk` (some variable definitions that are used in Makefiles)
+ `thesis.tex` (main `.tex` file that you run through `pdflatex`/`lualatex`)
+ `preamble/`
  + `preamble.tex` (contains documentclass, usepackage commands and defines page layout)
  + `fancyheaders.tex` (defines custom header/footer styles using "fancyhdr")
  + `loadlistings.tex` (some definitions for printing code)
  + `myinformation.tex` (commands for your name, title, university, etc)
  + `mycommands.tex` (defining custom commands, e.g. mathematical notation)
+ `titlepage/`
  + `Makefile`
  + `logo-placeholder.png` (placeholder logo)
  + `titlepage_wo_logo.tex` (title page without a logo, this is the default)
  + `titlepage.tex` (title page with a logo)
+ `declaration/`
  + `Makefile`
  + `copyright.tex`
  + `declaration.tex`
+ `abstract/`
  + `Makefile`
  + `abstract.tex`
  + `acknowledgements.tex`
  + `quote.tex`
+ `references/`
  + `Makefile`
  + `books.bib`
  + `Theses.bib`
  + `futuristic-and-mystical.bib`
  + `create_bib_list.sh` (bash script: automatically generates a `.tex` file that includes all present `.bib` files, just put all your `.bib` files in this directory, rest is done automatically)
+ `content/`
  + `intro/`
    + `Makefile`
    + `intro.tex` (your introduction)
  + `reschap1/` (1st main/result chapter)
    + `Makefile`
    + `main.tex` (text for this chapter)
    + `images/` (subdirectory that contains files for images/figures)
      + `Makefile`
      + `fem_basis_function_linear_cg.tex`
      + `fem_basis_function_constant_dg.tex`
      + `1way_coupling_prescribed_rotation.tex`
    + `tabledata/` (sub-directory for `.csv` files that are used for tables)
    + `python/`
      + `example_code.py` (python code that is printed as it is)
  + `reschap2/` (2nd main/result chapter)
    + `Makefile`
    + `main.tex`
    + `images/` (sub-directory for plots/images/pictures etc.)
    + `tabledata/` (sub-directory for `.csv` files that are used for tables)
      + `scientists.csv`
  + `reschap3/` (3rd main/result chapter)
    + `Makefile`
    + `main.tex`
    + `images/` (sub-directory for plots/images/pictures etc.)
    + `tabledata/` (sub-directory for `.csv` files that are used for tables)
      + `pgfplotstable.example1.dat`
  + `conclusion/`
    + `Makefile`
    + `summary.tex`
    + `conclusion.tex`
    + `future_work.tex`
  + `appendix/`
    + `Makefile`
    + `appendix.tex`

## How to use it
1. Use a Linux/Mac OS X system (Windows works, but the Makefiles/bash script won't work there)
2. Download the repository from GitHub
3. Make sure you have a LaTeX distribution installed on your system, e.g. TeXLive
4. In the main directory, execute `make fullthesis` on the command-line (for Linux/Mac OS X users, Windows users are required to compile the files manually, sorry).
5. Open `thesis.pdf` with a PDF reader of your choice, e.g. `evince`.
6. Now go in and edit and add files, start with `./preamble/myinformation.tex` and `./thesis.tex`.

## The `Makefile`
As mentioned above, one of the main features of this template is the comprehensive use of recursive Makefiles. Please see a list of targets and their description below:
- `ref`: executes the target `references` in `./references/Makefile`, which in turn executes the bash script `./references/create_bib_list.sh` which collects the names of all `.bib` files in `./references/` and includes them in a newly created file `./references/references.tex`. This can be included in your main LaTeX file (here: `thesis.tex`); example: imagine you have *A.bib*, *B.bib*, *C.bib* in the directory `./references/`, `make ref` creates `./references/references.tex` which has the following LaTeX command in it: `\bibliography{references/A,references/B,references/C}`
- `run`: runs LaTeX (by default: `pdflatex`) on `thesis.tex`; all required files, such as image files are required to be in place or this operation will fail
- `bib`: first executes `ref`, then: if `thesis.aux` does not exist, it executes `run`, followed by BibTeX (`bibtex`) on `thesis.tex`
- `thesis`: first it executes `run` and `bib` in that order; then the logfile `thesis.log` is scanned for references of missing/changed citations, multiple/changed labels, and rerun suggestions, and executes `run` at each check of the logfile; finally it prints out the warnings LaTeX provides in its logfile by executing `make warnings` (see below)
- `imagedirs`: executes the target `all` in each subdirectory defined in `IMAGEDIRS` (this variable is defined in this Makefile); this is useful if some images are done with Ti*k*Z, thus you can create standalone pdf files (which are vector graphics) of your Ti*k*Z graphics that you then include in your main LaTeX document. This target `imagedirs` allows you to compile all of these graphics to be compiled on the fly
- `fullthesis`: executes `allclean`, `imagedirs`, `ref`, `thesis` in that order; basically it removes all previous output files (in this and subdirectories) and builds your thesis from scratch (including graphics, e.g. Ti*k*Z graphics as explained above)
- `warnings`: scans the LaTeX logfile `thesis.log` for warnings and prints out the warnings on the command-line, certain keywords are printed in red for easier visibility
- `spellcheck`: uses the command-line tool *Gnu Aspell* (`aspell`) to spellcheck all `.tex` files in the subdirectories defined in `TEXDIRS` (this variable is defined in this Makefile); just make sure you keep `TEXDIRS` up to date when you add more subdirectories with `.tex` files, and it will find them; language is set to English (GB), if you need to adjust this, find the option in the file `./common.mk`
- `texcount`: uses the command-line tool *TeXcount* (`texcount`) as well as *ps2ascii* (`ps2ascii`) followed by a simple `wc -w` to determine the word count in your document. Note: both are not very accurate, but the latter is probably a better guess. 
- `search`: searches for a user defined pattern in all `.tex` files in all subdirectories defined in `TEXDIRS` (this variable is defined in this Makefile); usage: `make search SEARCH=<pattern>`
- `clean`: removes all output files from the main directory (except for .pdf files)
- `allclean`: first executes `clean`, then: removes all output files (also .pdf files) from all subdirectories defined in `IMAGEDIRS` (this variable is defined in this Makefile);

## Questions
Feel free to ask if you have questions. Other than that, good luck!
