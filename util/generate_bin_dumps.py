# Scan for all .bin dumps in the given files and generate the .bin
# dump files from baserom.gbc.

import os
import re
import sys


# Scan the input filepath for INCBINs of the following format:
#    INCBIN "foo/bar/{start}_{end}.bin"
# Example:
#    INCBIN "bin/10000_13fff.bin"
# Then, create that .bin dump by reading from baserom.gbc.
def scan_and_dump(filepath):
	with open(filepath, 'r') as f:
		file_contents = f.read()
	with open('baserom.gbc', 'rb') as rom:
		for match in re.findall(r'INCBIN\s+"(.+)/(.+)_(.+).bin"', file_contents):
			bin_dump_folder, start_addr, end_addr = match
			# Construct output filepath.
			output_filepath = os.path.join(bin_dump_folder, '%s_%s.bin' % (start_addr, end_addr))
			# Convert addresses to integers.
			start_addr = int(start_addr, 16)
			end_addr = int(end_addr, 16)
			# Read the contents from baserom.gbc.
			rom.seek(start_addr)
			bin_contents = rom.read(end_addr - start_addr + 1)
			# Write the .bin contents.
			if not os.path.exists(bin_dump_folder):
				os.makedirs(bin_dump_folder)
			with open(output_filepath, 'w+b') as bin_file:
				bin_file.write(bin_contents)

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print 'Must provide filepath as argument!'
		print 'Example: python generate_bin_dumps.py main.asm'
		sys.exit(1)

	scan_and_dump(sys.argv[1])
