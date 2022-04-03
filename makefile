CC = g++

BIN = /usr/local/bin

# Set location of htslib directory:
#
HTSDIR = ../htslib

CMPFLAGS = -DMAXHITS=1000 -DTHREAD -funroll-loops -O3 -m64

CPPFLAGS = -Igzstream -I$(HTSDIR)/htslib
LDFLAGS  = -Lgzstream -lgzstream -lz -L$(HTSDIR) -lhts
THREAD   = -lpthread


SOURCE  = align dbseq main pairs param reads utilities
OBJECTS = $(patsubst %,%.o,$(SOURCE))

all: libgzstream.a bsmap

%.o:%.cpp
	$(CC) $(CMPFLAGS) $(CPPFLAGS) -c $< -o $@

libgzstream.a:	gzstream/gzstream.o
	(cd gzstream; make)

bsmap:	$(OBJECTS)
	$(CC) $(CMPFLAGS)  $^ -o $@ $(THREAD) $(LDFLAGS)
	rm -f *.o


clean:
	rm -f *.o *~ bsmap
	(cd gzstream; make clean)

install:
	install -d $(BIN)
	install ./bsmap $(BIN)
	install ./sam2bam.sh $(BIN)
	install ./methratio.py $(BIN)
