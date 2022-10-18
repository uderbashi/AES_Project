SDIR = ./src
ODIR = ./class

JC = javac
CFLAGS = --source-path $(SDIR) -Xlint
RFLAGS = -cp $(ODIR)

_OBJF = AES.class Args.class IO.class
OBJF  = $(patsubst %,$(ODIR)/%,$(_OBJF))

start: $(ODIR) aes128

$(ODIR):
	mkdir $(ODIR)

aes128: $(OBJF)

$(ODIR)/%.class: $(SDIR)/%.java
	$(JC) -d $(ODIR) $< $(CFLAGS)

clean:
	rm -rf $(ODIR)

run:
	java $(RFLAGS) AES $(ARGS)
