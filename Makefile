%.pdf: %.md
	pandoc -tpdf --variable=documentclass:datainlogistics $< > $@
