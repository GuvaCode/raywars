TARGET = raywars

ifeq ($(OS),Windows_NT)
	EXE = .exe
  OPT += --passL:"-static -L ../../../libs/win/raylib/lib -lraylib -lopengl32 -lgdi32 -lwinmm"
	PLATFORM = win
else
  OPT += --passL:"-L ../../../libs/linux/raylib/lib -lraylib"
	PLATFORM = linux
endif

OPT += -d:strip
#OPT += --verbosity:3
#OPT += --nimcache:.nimcache

all:
	@echo --- Usage ---
ifeq ($(PLATFORM),win)
	@echo -------------------------
	@echo ! Build on MSys console !
	@echo -------------------------
endif
	@echo make nim          --- Compile with Nimony
	@echo make nim NIM=nim --- Compile with Nim

NIM ?= nimony

ifeq ($(NIM),nim)
	OPT += -d:nim_compiler
endif

$(TARGET)$(EXE):
	$(NIM) c -r $(OPT) $<

nim:
	$(NIM) c -r $(OPT) $(TARGET).nim

clean:
	@-rm -fr .nimcache nimcache .nimcache_gen
	@-rm -f $(TARGET)$(EXE)

run: all
	./$(TARGET)$(EXE)

GEN_OPT += -d:useFuthark -d:futharkRebuild --maxLoopIterationsVM:50000000
GEN_OPT += --hint:"User:off"
GEN_OPT += -d:nodeclguards

gen:
	nim c -f -c  $(GEN_OPT) --nimcache:.nimcache_$(notdir $@) raylib.nim

nim:
