MDFLAGS =\
 --section-div

MD   = $(wildcard *.md)
CSS  = $(wildcard *.css)
HTML = $(patsubst %.md,%.html,$(MD))

#===============================================================================
# convenience items for testing and what not:

.PHONY: all clean publish

all: $(HTML) me.jpg

clean:
	rm -f $(HTML) me.jpg

publish: \
 dumboRat-NewbieFAQ\
 index.html\
 index.css\
 resume.css\
 resume.html\
 me.jpg
	rsync -r -l --delete-excluded $(foreach file,$^,--include="/$(file)")\
	 --exclude '/*' ./ mechbits.com:/var/www/mechbits

#===============================================================================
# recipes:

README.html: MDFLAGS += --from markdown_github --css github-pandoc.css

me.jpg: questionmark2.jpg
	convert $< -resize 250x250 $@

#-------------------------------------------------------------------------------
# generic recipes:

%.html: template.html %.md | %.css
	pandoc $(MDFLAGS) -s -o $@ $(filter %.md,$^)\
	 --template=template.html --css $*.css

%.html: template.html %.md
	pandoc $(MDFLAGS) -s -o $@ $(filter %.md,$^)\
	 --template=template.html

# vim: set noexpandtab :
