#!/bin/bash

# get dirname within the LaTex document structure:
dirname=`echo ${PWD##*/}`
# getting list of bibfiles and adding directory name to each entry:
biblist=`ls *.bib | xargs echo | sed "s\ \,$dirname/\g" | xargs echo | sed 's\.bib\\\g'`
biblist="$dirname/$biblist"
# writing that string to references.tex, and wrapping latex code around it, such that latex know what it has to do:
echo "% loading bibfiles/bibliography (for bibtex):" > references.tex
echo "\\bibliography{$biblist}" >> references.tex
echo "% end of bibliography" >> references.tex
