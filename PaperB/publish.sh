#!/bin/bash
# pandoc -F /home/frederik/MultiPaper/filters/pandoc-crossref -F pandoc-citeproc -s -o paperB.pdf paperB.md
# pandoc -F ./../filters/pandoc-crossref -F pandoc-citeproc --bibliography references.bib --biblatex -s -o paperB.pdf paperB.md

# pandoc -F ./../filters/pandoc-crossref --bibliography=references.bib --biblatex -s -o paperB.tex paperB.md;
# pdflatex paperB.tex;
# bibtex paperB.tex;
# pdflatex paperB.tex;
# pdflatex paperB.tex;

pandoc -F ./../filters/pandoc-crossref paperB_meta.yaml -s -o paperB.pdf paperB.md
