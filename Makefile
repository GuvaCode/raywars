all:
	$(MAKE) -C src/c
	$(MAKE) -C src/nim
	$(MAKE) -C src/zig
	$(MAKE) -C src/nelua

clean:
	@$(MAKE) -C src/c $@
	@$(MAKE) -C src/nim $@
	@$(MAKE) -C src/zig $@
	@$(MAKE) -C src/nelua $@



MAKEFLAGS += --no-print-directory
