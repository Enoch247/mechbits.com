MDFLAGS =\
 --section-div

# --from markdown_github

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

publish: \
 dumboRat-NewbieFAQ\
 index.html\
 index.css\
 resume.css\
 resume.html\
 *.jpg
	rsync -r -l --delete-excluded $(foreach file,$^,--include="/$(file)")\
	 --exclude '/*' ./ mechbits.com:/var/www/mechbits

#===============================================================================
# recipes:

index.html: | me.jpg

README.html: MDFLAGS += --from markdown_github

me.jpg: questionmark2.jpg
	convert $< -resize 250x250 $@

#resume.html: resume.md resume.tmpl
#	pandoc -s --section-div --template=resume.tmpl -o $@ --css resume.css $<

#-------------------------------------------------------------------------------
# generic recipes:

%.html: %.md %.tmpl | %.css
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl --css $*.css

%.html: %.md %.tmpl | style.css
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl --css style.css

%.html: %.md | %.css
	pandoc $(MDFLAGS) -s -o $@ $< --css $*.css

%.html: %.md | style.css
	pandoc $(MDFLAGS) -s -o $@ $< --css style.css

%.html: %.md %.tmpl
	pandoc $(MDFLAGS) -s -o $@ $< --template=$*.tmpl

%.html: %.md
	pandoc $(MDFLAGS) -s -o $@ $<

%.pdf: %.md
	pandoc -s -o $@ $<

# vim: set noexpandtab :
