%.pdf: %.md
	pandoc -tpdf --variable=documentclass:datainlogistics $< > $@

# PDF files depend on images if the markdown files includes images, so
# we want to regenerate PDFs if their images are updated.
#
# This rule creates a *.d makefile describing the images found in the
# *.md markdown file.
#
# This currently only supports image links in the ![description](path)
# format.
%.d: %.md
	echo $(@:.d=.pdf) " : " `cat $< | grep -o -E '![^]]*([^\)]*)\)' |sed 's/.*(//' |sed 's/)\.*//' | tr '\n' ' '` >$@

sources = $(wildcard *.md)

# Include generated dependency files
include $(sources:.md=.d)

# If we have plantuml sources, they can be used to generate images
%.svg : %.puml
	plantuml -Tsvg $< >$@
