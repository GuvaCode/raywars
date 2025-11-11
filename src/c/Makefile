TARGET = raywars

ifeq ($(OS),Windows_NT)
	EXE = .exe
	# Hide conlosle
	#LDFLAGS += -mwindows
	LDFLAGS += -lopengl32 -lgdi32 -lwinmm -lraylibdll
	PLATFORM = win
else
	PLATFORM = linux
	LDFLAGS += -lraylib
endif

CFLAGS  += -I../../libs/$(PLATFORM)/raylib/include
LDFLAGS += -L../../libs/$(PLATFORM)/raylib/lib

all:
	gcc -O2 $(CFLAGS) $(TARGET).c -o $(TARGET)$(EXE) $(LDFLAGS)
ifeq ($(OS),Windows_NT)
	cp -f ../../libs/win/raylib/lib/raylib.dll .
endif

run: all
	./$(TARGET)$(EXE)

clean:
	@-rm $(TARGET)$(EXE)
