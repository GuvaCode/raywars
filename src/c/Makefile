TARGET = raywars

CC = gcc
#CC = zig cc
#CC = clang

CFLAGS += -O2

STATIC_LINK_RAYLIB = true

ifeq ($(STATIC_LINK_RAYLIB),true)
	LIB_RAYLIB = -lraylib
else
	LIB_RAYLIB = -lraylibdll
endif

LIBS_DIR = ../../../libs
LDFLAGS += -L$(LIBS_DIR)/$(PLATFORM)/raylib/lib

# Strip debug info
LDFLAGS += -Wl,-s

ifeq ($(STATIC_LINK_RAYLIB),true)
	LDFLAGS += -static
endif

ifeq ($(OS),Windows_NT)
	EXE = .exe
	# Hide conlosle
	#LDFLAGS += -mwindows
	LDFLAGS += $(LIB_RAYLIB) -lopengl32 -lgdi32 -lwinmm
	PLATFORM = win
else
	PLATFORM = linux
	LDFLAGS += $(LIB_RAYLIB)
endif

CFLAGS  += -I$(LIBS_DIR)/$(PLATFORM)/raylib/include

all: $(TARGET)$(EXE)

$(TARGET)$(EXE): $(TARGET).c Makefile
	$(CC) $(CFLAGS) $(TARGET).c -o $(TARGET)$(EXE) $(LDFLAGS)
ifneq ($(STATIC_LINK_RAYLIB),true)
ifeq ($(PLATFORM),win)
	cp -f $(LIBS_DIR)/win/raylib/lib/raylib.dll .
endif
endif

run: all
	./$(TARGET)$(EXE)

clean:
	@-rm -f $(TARGET)$(EXE)
ifeq ($(PLATFORM),win)
	@-rm -f raylib.dll
endif

fmt:
	clang-format -i $(TARGET).c
