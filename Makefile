# This needs to be at the top, before any other makefile is loaded.
thismkfile:=$(lastword $(MAKEFILE_LIST))
thismkdir:=$(dir $(thismkfile))

%.pdf: %.md
# Set TEXINPUTS to ensure latex will load class and pdf template from
# the directory this Makefile is in
	export TEXINPUTS="$(thismkdir)/:"
	pandoc -s -fmarkdown+yaml_metadata_block -tpdf --include-in-header "$(thismkdir)/use_dil_package.tex" $< -o $@

# PDF files depend on images if the markdown files includes images, so
# we want to regenerate PDFs if their images are updated.
#
# This rule creates a *.d makefile describing the images found in the
# *.md markdown file. See the GNU Make manual page on "Generating
# Prerequisites Automatically".
# https://www.gnu.org/software/make/manual/html_node/Automatic-Prerequisites.html
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
