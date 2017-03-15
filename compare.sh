#!/bin/sh
# Compares baserom.gbc and pokepinball.gbc

# create baserom.txt if necessary

if [ ! -f baserom.txt ]; then
	hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C pokepinball.gbc > pokepinball.txt

diff -u baserom.txt pokepinball.txt | less
