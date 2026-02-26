CC = gcc
CFLAGS_BASE = -Iinclude
CFLAGS ?= -O3 $(CFLAGS_BASE)
BENCH_BIN = bench/bench

.PHONY: all clean bench-o0 bench-o2 bench-o3 bench-ofast

all: $(BENCH_BIN)

$(BENCH_BIN): bench/bench.c src/naive.c src/tiled.c include/frogemm.h
	$(CC) $(CFLAGS) bench/bench.c src/naive.c src/tiled.c -o $(BENCH_BIN)

bench-o0:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O0 $(CFLAGS_BASE)" $(BENCH_BIN)

bench-o2:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O2 $(CFLAGS_BASE)" $(BENCH_BIN)

bench-o3:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O3 $(CFLAGS_BASE)" $(BENCH_BIN)

bench-ofast:
	$(MAKE) clean
	$(MAKE) CFLAGS="-Ofast -march=native $(CFLAGS_BASE)" $(BENCH_BIN)

clean:
	rm -f $(BENCH_BIN)
