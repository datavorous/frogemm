CC = gcc
CFLAGS_BASE = -Iinclude
OMPFLAGS ?= -fopenmp
CFLAGS ?= -O3 $(CFLAGS_BASE) $(OMPFLAGS)
LDFLAGS ?= $(OMPFLAGS)
AR = ar
ARFLAGS = rcs
PREFIX ?= /usr/local
BENCH_BIN = bench/bench
LIB_NAME = libfrogemm.a
LIB_OBJ = naive.o tiled.o

.PHONY: all clean lib install uninstall bench-o0 bench-o2 bench-o3 bench-ofast

all: $(BENCH_BIN)

$(BENCH_BIN): bench/bench.c src/naive.c src/tiled.c include/frogemm.h
	$(CC) $(CFLAGS) bench/bench.c src/naive.c src/tiled.c -o $(BENCH_BIN) $(LDFLAGS)

lib: $(LIB_NAME)

$(LIB_NAME): $(LIB_OBJ)
	$(AR) $(ARFLAGS) $@ $^

naive.o: src/naive.c include/frogemm.h
	$(CC) $(CFLAGS) -c src/naive.c -o $@

tiled.o: src/tiled.c include/frogemm.h
	$(CC) $(CFLAGS) -c src/tiled.c -o $@

install: $(LIB_NAME)
	install -d $(PREFIX)/include $(PREFIX)/lib
	install -m 644 include/frogemm.h $(PREFIX)/include/frogemm.h
	install -m 644 $(LIB_NAME) $(PREFIX)/lib/$(LIB_NAME)

uninstall:
	rm -f $(PREFIX)/include/frogemm.h $(PREFIX)/lib/$(LIB_NAME)

bench-o0:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O0 $(CFLAGS_BASE) $(OMPFLAGS)" LDFLAGS="$(OMPFLAGS)" $(BENCH_BIN)

bench-o2:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O2 $(CFLAGS_BASE) $(OMPFLAGS)" LDFLAGS="$(OMPFLAGS)" $(BENCH_BIN)

bench-o3:
	$(MAKE) clean
	$(MAKE) CFLAGS="-O3 $(CFLAGS_BASE) $(OMPFLAGS)" LDFLAGS="$(OMPFLAGS)" $(BENCH_BIN)

bench-ofast:
	$(MAKE) clean
	$(MAKE) CFLAGS="-Ofast -march=native $(CFLAGS_BASE) $(OMPFLAGS)" LDFLAGS="$(OMPFLAGS)" $(BENCH_BIN)

clean:
	rm -f $(BENCH_BIN) $(LIB_NAME) $(LIB_OBJ)
