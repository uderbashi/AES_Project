IDIR = ./inc
SDIR = ./src
ODIR = ./obj

CC = gcc
CFLAGS = -Wall -I$(IDIR)
LFLAGS = -lm

_INCF = args.h
INCF  = $(patsubst %,$(IDIR)/%,$(_INCF))

_OBJF = args.o aes.o
OBJF  = $(patsubst %,$(ODIR)/%,$(_OBJF))

start: $(ODIR) aes256	

$(ODIR):
	mkdir $(ODIR)
	
aes256: $(OBJF)
	gcc -o $@ $^ $(LFLAGS)
	
$(ODIR)/%.o: $(SDIR)/%.c $(INCF)
	$(CC) -c -o $@ $< $(CFLAGS)
	
clean:
	rm -rf $(ODIR) aes256
