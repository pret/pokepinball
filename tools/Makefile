.PHONY: all clean

CC := gcc
CFLAGS := -std=c99 -Wall -Wextra

tools := \
	gfx \
	pcm \
	scan_includes

all: $(tools)
	@:

clean:
	rm -f $(tools)

%: %.c
	$(CC) $(CFLAGS) -o $@ $<
