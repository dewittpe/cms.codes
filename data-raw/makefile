SOURCES = $(wildcard *.R)
TARGETS = $(addprefix ../data/, $(addsuffix .rda, $(basename $(SOURCES))))

all : $(TARGETS)

../data/%.rda : %.R
	R CMD BATCH --vanilla $<

clean :
	$(RM) -f *.Rout
