MDFLAGS =\
 --section-div

# -t markdown_github

MD   = $(wildcard *.md)
CSS  = $(wildcard *.css)
HTML = $(patsubst %.md,%.html,$(MD))

#===============================================================================
# convenience items for testing and what not:

.PHONY: all clean publish

all: $(HTML) Makefile

clean:
	rm -f $(patsubst %.md,%.html,$(wildcard *.md))
	rm -f *.html *.bak *~

publish: $(HTML) $(CSS)
	rsync -r --delete-excluded $(foreach file,$^,--include="$(file)")\
	 --exclude '*' ./ mechbits.com:/var/www/mechbits/new

#===============================================================================
# recipes:

#resume.html: resume.md resume.tmpl
#	pandoc -s --section-div --template=resume.tmpl -o $@ --css resume.css $<

#-------------------------------------------------------------------------------
# generic recipes:

%.html: %.md %.tmpl | %.css
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl --css $*

%.html: %.md %.tmpl | style.css
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl --css style.css

%.html: %.md | style.css
	pandoc $(MDFLAGS) -s -o $@ $< --css style.css

%.html: %.md %.tmpl
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl

%.html: %.md
	pandoc $(MDFLAGS) -s -o $@ $<

%.pdf: %.md
	pandoc -s -o $@ $<

# vim: set noexpandtab :
