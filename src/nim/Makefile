TARGET = raywars

ifeq ($(OS),Windows_NT)
	EXE = .exe
endif

OPT += -d:strip
#OPT += --verbosity:3

all: $(TARGET)$(EXE)

$(TARGET)$(EXE): $(TARGET).nim Makefile
	nim c $(OPT) $<

clean:
	@-rm -fr .nimcache
	@-rm -f $(TARGET)$(EXE)

run: all
	./$(TARGET)$(EXE)
