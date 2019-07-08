# Thesis-LaTeX-Template

<p align="left">
  <a href="https://github.com/fmilthaler/Thesis-LaTeX-Template/releases/latest">
    <img src="https://img.shields.io/badge/version-0.2-brightgreen.svg?style=popout" alt="version">
  </a>
  <a href="https://travis-ci.org/fmilthaler/Thesis-LaTeX-Template">
    <img src="https://travis-ci.org/fmilthaler/Thesis-LaTeX-Template.svg?style=popout?branch=master" alt='travis'>
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/github/license/fmilthaler/Thesis-LaTeX-Template.svg?style=popout" alt="license">
  </a>
</p>

This template aims at students of any degree (Bachelor, Master, PhD) who start writing up their thesis in LaTeX.

The overall layout is pleasant, stylish yet classic and fulfills the layout regulations
at Imperial College London. It is quite generic, thus it is useful for dissertations
at any University with minor adjustments to the layout to conform with your University's
layout regulations.

Knowledge of how to use LaTeX is a prerequisite, while knowledge of Makefiles is
optional.

-------------------------------------------------------------------------

## Table of contents
 - [Features](#Features)
 - [How to use it](#How-to-use-it)
   - [The Makefile](#The-Makefile)
 - [File Structure](#File-Structure)
 - [Questions](#Questions)

-------------------------------------------------------------------------

## Features
- Supports PDFLaTeX, LuaLaTeX
- **Customised Page layouts**, Header and Footer styles
- A Nomenclature with subgroups
- **Examples** of **fancy figures** (using Ti*k*Z/PGFPlots) and **tables** (using PGFPlotsTable), as well as support for very large tables that need to be rotated to fit on a page.
- File structure to separate files of different chapters
- A Bash script automatically includes all your `.bib` files in one file `references/references.tex`, that way you can organise and split your references across several `.bib` files without keeping track of them (without manually updating `\bibliography{...}` in your `.tex` file)
- Besides having a good file structure, this template provides recursive use of Makefiles. The **Makefiles ensure a minimum number of compilations to resolve all changes** in references/citations, thus the Makefiles offer **similar benefits of the tool `latexmk` and they even go beyond**. **This template stands out from others due to the customised Makefiles**. These automate many processes with several checks in place so that **no time is wasted** on recompiling your document if it is not needed. They allow for (please find a more detailled description of the Makefile's targets and how to use it further below):
  - creating your thesis as a pdf,
  - **automatically detecting changes in references** and **automatically re-running** LaTeX on your document again (only if required), until all references (in bibliography or to floating objects) are resolved.
  - automatically detecting changes in the nomenclature (if present) and **building/updating the nomenclature if and only if changes were found**, in order to **ensure minimal compile time**.
  - creating separate image files (e.g. with Ti*k*Z/PGFPlots) stored in subdirectories (in order to **separate compilation of document from result plots** done in PGFPlots; depending on the complexity of your result plots, this has the potential to **drastically reduce the compile time** of your document/thesis),
  - the structure of directories/Makefiles allows you to simply create more Ti*k*Z/PGFPlots graphics by placing their corresponding standalone LaTeX source files in the `images` subdirectories of the *chapter* directories, the `Makefile` hierachy in place automatically finds and compiles those for you,
  - print out **warnings from LaTeX** output files,
  - **spellcheck** your `.tex` files,
  - **search a pattern** in all your `.tex` files (in all subdirectories) to quickly find a certain pattern,
  - perform a **word count** on your document,
  - clean your directory (and subdirectories) from output files

-------------------------------------------------------------------------

## How to use it
1. Use a Linux/Mac OS X system (Windows works, but the Makefiles/bash script won't work there)
2. Make sure you have a LaTeX distribution installed on your system, e.g. TeXLive
3. Download the repository from GitHub
4. In the main directory, execute `make fullthesis` on the command-line (for Linux/Mac OS X users, Windows users are required to compile the files manually, sorry). `fullthesis` will not only compile your document, but will also compile some standalone Ti*k*Z graphics that are then included in your document/thesis.
5. Open `thesis.pdf` with a PDF reader of your choice, e.g. `evince`.
6. Now go in and edit and add files, start with `./preamble/myinformation.tex` and `./thesis.tex`, e.g. set your name, university, title etc.
7. With the first few changes in the text, execute `make` (or `make thesis`) on the command-line. This will not compile the aforementioned graphics in subdirectories, but will only recompile your main document/thesis `thesis.tex`.
8. If you need to adjust some layout settings: you can find/adjust these in `./preamble/preamble.tex`, below the definition of the `documentclass`.

-------------------------------------------------------------------------

### The Makefile
As mentioned above, one of the main features of this template is the comprehensive use of recursive Makefiles.

Each target is executed on the command-line with `make <target-name>`.

The most frequently used - and the ones you should definitely know about - targets are:
- `thesis`: this target compiles your main document `thesis.tex`, it also runs through BibTeX to sort out your bibliography. Moreover, it automatically detects changes in references/labels/citations and recompiles your target if required in order to resolve those changes. It does expect all images included in the document to be present (see target `imagedirs` below). Finally, it automatically detects a nomenclature, and if so, it also detects if changes were made to it. If both criteria are satisfied, the document is automatically updated to reflect the changes in the nomenclature.
- `fullthesis`: in case of you separating the compilation of some plots/graphics from your main document (in order to save compile time), those Ti*k*Z graphics/PGFPlots need to be compiled (*before* you run `make thesis` and obviously every time you make changes to those graphics/plots. `fullthesis` invokes another target called `imagedirs` that takes care of thos graphics/plots. It compiles all standalone `texfiles` resulting in `.pdf` files in subdirectories `images`. Those `pdf` files can then be included in the main document. After that step, `fullthesis` invokes `thesis` to compile the main document.

For those who want to know more, and might want to make some changes to the `Makefile`, here is a more detailled and technical description of all targets:
- `ref`: executes the target `references` in `./references/Makefile`, which in turn executes the bash script `./references/create_bib_list.sh` which collects the names of all `.bib` files in `./references/` and includes them in a newly created file `./references/references.tex`. This can be included in your main LaTeX file (here: `thesis.tex`); example: imagine you have *A.bib*, *B.bib*, *C.bib* in the directory `./references/`, `make ref` creates `./references/references.tex` which has the following LaTeX command in it: `\bibliography{references/A,references/B,references/C}`. **Note:** Do not manually edit `references/references.tex` as it is automatically overwritten by the script every time you compile your thesis.
- `run`: runs LaTeX (by default: `pdflatex`) on `thesis.tex`; all required files, such as image files are required/expected to be in place, otherwise this operation will fail.
- `bib`: first executes `ref`, then: if `thesis.aux` does not exist, it executes `run`, followed by BibTeX (`bibtex thesis`)
- `index`: executes `makeindex ${THESIS}.nlo -s nomencl.ist -o ${THESIS}.nls`, required for building a nomenclature.
- `thesis`: first it executes `run`, `bib` and `nomtest` in that order; then the logfile `thesis.log` is scanned for references of missing/changed citations, multiple/changed labels, and rerun suggestions, and executes `run` at each check of the logfile; finally, after having finished the checks and reruns, it prints out the warnings LaTeX provides in its logfile by executing `make warnings` (see below)
- `imagedirs`: executes the target `all` in each subdirectory defined in `IMAGEDIRS` (this variable is defined in this Makefile); this is useful if some images are done with Ti*k*Z/PGFPlots, thus you can create standalone `pdf` files (which are vector graphics) of your Ti*k*Z/PGFPlots graphics that you then include in your main LaTeX document. This target `imagedirs` allows you to compile all of these graphics to be compiled on the fly. **Note:** This step is beneficial if you are using PGFPlots to read in lots of data points from data files to create a beautiful plot of your results. This process can take some time, hence you do not want this to be processed every time you change the text in your thesis. As the standalone `.pdf` graphic is a vector graphic, you do not loose quality.
- `fullthesis`: executes `allclean`, `imagedirs`, `ref`, `thesis` in that order; basically it removes all previous output files (in this and subdirectories) and builds your thesis from scratch (including graphics, e.g. Ti*k*Z/PGFPlots graphics as explained above)
- `nomtest`: checking if there were changes made on the nomenclature the last time the main document was compiled. If so, it executes `make nomupdate`. **Note**: this target ensures a minimal number of LaTeX compilation neccessary to build/update the nomenclature.
- `nomupdate`: executes `index` and `run` in that order. Gets triggered when `nomtest` found changes in the nomenclature and makes sure the changes are updated in the document.
- `warnings`: scans the LaTeX logfile `thesis.log` for warnings and prints out the warnings on the command-line, certain keywords are printed in red for better visibility.
- `spellcheck`: uses the command-line tool *Gnu Aspell* (`aspell`) to spellcheck all `.tex` files in the subdirectories defined in `TEXDIRS` (this variable is defined in this Makefile); just make sure you keep `TEXDIRS` up to date when you add more subdirectories with `.tex` files, and it will find them; by default, the language is set to English (GB), if you need to adjust this, find the option in the file `./common.mk`
- `texcount`: uses the command-line tool *TeXcount* (`texcount`) as well as *ps2ascii* (`ps2ascii`) followed by a simple `wc -w` to determine the word count in your document. Note: both are not very accurate. 
- `search`: searches for a user defined pattern in all `.tex` files in all subdirectories defined in `TEXDIRS` (this variable is defined in this Makefile); usage: `make search SEARCH=<pattern>`.
- `clean`: removes all output files from the main directory (except for `.pdf` file(s))
- `allclean`: first executes `clean`, then: removes all output files (also `.pdf` files) from all subdirectories defined in `IMAGEDIRS` (this variable is defined in this Makefile);

-------------------------------------------------------------------------

## File Structure
See a list and short description of directories and files in this repository to understand how the files are organised and where to find what.

+ `Makefile` (main Makefile which targets are explained below)
+ `common.mk` (some variable definitions that are used in Makefiles)
+ `thesis.tex` (main `.tex` file of your document that you run through `pdflatex`/`lualatex`, this file consists mainly of `\input{<filename>}` commands to include the content of your thesis).
+ `preamble/` (files that set up the layout of your thesis and include LaTeX packages are in here)
  + `preamble.tex` (contains documentclass, usepackage commands)
  + `layout.tex` (defines overall page/text layout, chapter title layout)
  + `fancyheaders.tex` (defines custom header/footer styles using `fancyhdr`)
  + `loadlistings.tex` (some definitions for printing code)
  + `myinformation.tex` (commands for your name, title, university, etc)
  + `mycommands.tex` (defining custom commands, e.g. mathematical notation)
  + `nomenclature.tex` (defining entries/groups of the nomenclature)
+ `titlepage/` (files for your titlepage)
  + `Makefile`
  + `logo_placeholder.png` (placeholder logo)
  + `titlepage_wo_logo.tex` (titlepage without a logo, this is the default)
  + `titlepage.tex` (titlepage with a logo)
+ `declaration/`
  + `Makefile`
  + `copyright.tex` (copyright declaration)
  + `declaration.tex` (declaration of your work)
+ `abstract/`
  + `Makefile`
  + `abstract.tex` (abstract of your thesis)
  + `acknowledgements.tex` (thanking your supervisors, parents, etc)
  + `quote.tex` (optional: include a quote of your choice)
+ `references/` (.bib files go in here with all the articles/books you like to reference)
  + `Makefile`
  + `create_bib_list.sh` (bash script: automatically generates a `.tex` file that includes all present `.bib` files, just put all your `.bib` files in this directory, rest is done automatically)
  + `books.bib`
  + `futuristic_and_mystical.bib`
  + `Theses.bib`
+ `content/` (this is the main part of your thesis, chapters and supporting data files/plots should go in subdirectories of this one)
  + `introduction/`
    + `Makefile`
    + `introduction.tex` (your introduction)
  + `reschap1/` (1st main/result chapter)
    + `Makefile`
    + `main.tex` (text for this chapter)
    + `images/` (subdirectory that contains files for images/figures)
      + `Makefile`
      + `fem_basis_function_linear_cg.tex` (example of a (standalone) simple Ti*k*Z graphic)
      + `fem_basis_function_constant_dg.tex` (example of a (standalone) simple Ti*k*Z graphic)
      + `rotation_example.tex` (example of a (standalone) fancy Ti*k*Z graphic)
    + `table-data/` (subdirectory for `.csv` files that are used for tables)
      + `scientists.csv` (example data file)
    + `python/`
      + `example_code.py` (python code that is printed as it is)
  + `reschap2/` (2nd main/result chapter)
    + `Makefile`
    + `main.tex` (text for this chapter)
    + `images/` (subdirectory for plots/images/pictures etc.)
      + `Makefile`
      + `2d_flow_past_cylinder_test_combinations.tex` (example of a (standalone) fancy Ti*k*Z graphic)
      + `domain_3d_flow_past_sphere.tex` (example of a (standalone) fancy Ti*k*Z graphic)
      + `velocity-x_interp_0-01.tex` (example of a (standalone) PGFPlots plot)
      + `velocity-x_interp_0-001.tex` (example of a (standalone) PGFPlots plot)
      + `data/` (subdirectory for data files for PGFPlots)
        + `bounded_interp_0-01.csv` (example data file)
        + `bounded_x_0-1_interp_0-0001.csv` (example data file)
        + `boundeddg_interp_0-01.csv` (example data file)
        + `boundeddg_x_0-1_interp_0-0001.csv` (example data file)
        + `void_interp_0-01.csv` (example data file)
        + `voiddg_interp_0-01.csv` (example data file)
    + `table-data/` (subdirectory for `.csv` files that are used for tables)
      + `scientists.csv` (example data file)
  + `reschap3/` (3rd main/result chapter)
    + `Makefile`
    + `main.tex` (text for this chapter)
    + `parallel_efficiency_table.tex` (`.tex` file that includes a PGFPlotsTable, file is called by `main.tex`)
    + `images/` (subdirectory for plots/images/pictures etc.)
      + `Makefile`
      + `pgfplot_texfile_parallel_efficiency.tex` (example of a (standalone) PGFPlots plot)
    + `table-data/` (subdirectory for `.csv` files that are used for tables)
      + `parallel_efficiency_data.pgfdat` (example data file)
      + `pgftablesettings_parallel_efficiency_table.tex` (example file for PGFPlotsTable settings)
  + `conclusion/` (files for the summary, conclusion, future work should go in here)
    + `Makefile`
    + `summary.tex` (text for your summary)
    + `conclusion.tex` (text for your conclusion)
    + `future_work.tex` (text for future work)
  + `appendix/` (if you need one, the appendix is set up in here)
    + `Makefile`
    + `appendix.tex` (text for your appendix)

-------------------------------------------------------------------------

## Questions
Feel free to ask if you have questions. Other than that, good luck!
