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

index.html resume.html: MDFLAGS += --css $*.css

README.html: MDFLAGS += --from markdown_github --css github-pandoc.css

me.jpg: questionmark2.jpg
	convert $< -resize 250x250 $@

#-------------------------------------------------------------------------------
# generic recipes:

# make foo.html from template.html, foo.md, and any other markdown files
%.html: template.html %.md
	pandoc $(MDFLAGS) --template=template.html -s -o $@ $(filter %.md,$^)

# vim: set noexpandtab :
