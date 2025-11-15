TARGET = raywars

STATIC_LINK_RAYLIB = true
ifeq ($(STATIC_LINK_RAYLIB),true)
	LIB_RAYLIB = -lraylib
else
	LIB_RAYLIB = -lraylibdll
endif

ifeq ($(OS),Windows_NT)
	EXE = .exe
	# Hide conlosle
	#NELUA_LDFLAGS += -mwindows
	NELUA_LDFLAGS += $(LIB_RAYLIB) -lopengl32 -lgdi32 -lwinmm -limm32
	PLATFORM = win
else
	PLATFORM = linux
	NELUA_LDFLAGS += $(LIB_RAYLIB)
endif

RAYLIB_DIR       = ../../../libs
RAYLIB_NELUA_DIR =   $(RAYLIB_DIR)/Raylib.nelua
NELUA_FLAGS     += -L$(RAYLIB_DIR)/Raylib.nelua --cache-dir .neluacache -o $(TARGET)$(EXE)
NELUA_CFLAGS    += -I$(RAYLIB_DIR)/$(PLATFORM)/raylib/include -O2 -Wl,-s
NELUA_LDFLAGS   += -lraylib -L$(RAYLIB_DIR)/$(PLATFORM)/raylib/lib


all: $(TARGET)$(EXE)

clean:
	@-rm -fr .neluacache
	@-rm -f $(TARGET)$(EXE)
	@-rm -f raylib.dll

$(TARGET)$(EXE): $(TARGET).nelua Makefile
	nelua -r $< $(NELUA_FLAGS) --cflags="$(NELUA_CFLAGS)" --ldflags="$(NELUA_LDFLAGS)"
ifeq ($(PLATFORM),win)
ifneq ($(STATIC_LINK_RAYLIB),true)
	cp -f $(RAYLIB_DIR)/win/raylib/lib/raylib.dll .
endif
endif

run: all
	./$(TARGET)$(EXE)
