OPT += --release=fast

all:
	zig build $(OPT)

run:
	zig build $(OPT) run

clean:
	@-rm -fr .zig-cache zig-out
	@-rm -fr libzig/raylib/.zig-cache
	@-rm -fr libzig/raylib/zig-out
