IDIR = ./inc
SDIR = ./src
ODIR = ./obj

CC = gcc
CFLAGS = -Wall -I$(IDIR)
LFLAGS = -lm

_INCF = args.h aes.h
INCF  = $(patsubst %,$(IDIR)/%,$(_INCF))

_OBJF = args.o aes.o main.o
OBJF  = $(patsubst %,$(ODIR)/%,$(_OBJF))

start: $(ODIR) aes128

$(ODIR):
	mkdir $(ODIR)

aes128: $(OBJF)
	$(CC) -o $@ $^ $(LFLAGS)

$(ODIR)/%.o: $(SDIR)/%.c $(INCF)
	$(CC) -c -o $@ $< $(CFLAGS)

clean:
	rm -rf $(ODIR) aes128
