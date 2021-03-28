#!/usr/bin/env python

song_names = {
	0x0f: [
		"Nothing0F",
		"RedField",
		"CatchEmRed",
		"HurryUpRed",
		"Pokedex",
		"GastlyInTheGraveyard",
		"HaunterInTheGraveyard",
		"GengarInTheGraveyard",
	],
	0x10: [
		"Nothing10",
		"BlueField",
		"CatchEmBlue",
		"HurryUpBlue",
		"HiScore",
		"GameOver",
	],
	0x11: [
		"Nothing11",
		"WhackTheDiglett",
		"WhackTheDugtrio",
		"SeelStage",
		"Title",
	],
	0x12: [
		"Nothing12",
		"MewtwoStage",
		"Options",
		"FieldSelect",
		"MeowthStage",
	],
	0x13: [
		"Nothing13",
		"EndCredits",
		"NameEntry",
	],
}

cry_names = [
	"00",
	"01",
	"02",
	"03",
	"04",
	"05",
	"06",
	"07",
	"08",
	"09",
	"0A",
	"0B",
	"0C",
	"0D",
	"0E",
	"0F",
	"10",
	"11",
	"12",
	"13",
	"14",
	"15",
	"16",
	"17",
	"18",
	"19",
	"1A",
	"1B",
	"1C",
	"1D",
	"1E",
	"1F",
	"20",
	"21",
	"22",
	"23",
	"24",
	"25",
]

sfx_names = [
	"SoundEffect0",
	"SoundEffect1",
	"SoundEffect2",
	"SoundEffect3",
	"SoundEffect4",
	"SoundEffect5",
	"SoundEffect6",
	"SoundEffect7",
	"SoundEffect8",
	"SoundEffect9",
	"SoundEffect10",
	"SoundEffect11",
	"SoundEffect12",
	"SoundEffect13",
	"SoundEffect14",
	"SoundEffect15",
	"SoundEffect16",
	"SoundEffect17",
	"SoundEffect18",
	"SoundEffect19",
	"SoundEffect20",
	"SoundEffect21",
	"SoundEffect22",
	"SoundEffect23",
	"SoundEffect24",
	"SoundEffect25",
	"SoundEffect26",
	"SoundEffect27",
	"SoundEffect28",
	"SoundEffect29",
	"SoundEffect30",
	"SoundEffect31",
	"SoundEffect32",
	"SoundEffect33",
	"SoundEffect34",
	"SoundEffect35",
	"SoundEffect36",
	"SoundEffect37",
	"SoundEffect38",
	"SoundEffect39",
	"SoundEffect40",
	"SoundEffect41",
	"SoundEffect42",
	"SoundEffect43",
	"SoundEffect44",
	"SoundEffect45",
	"SoundEffect46",
	"SoundEffect47",
	"SoundEffect48",
	"SoundEffect49",
	"SoundEffect50",
	"SoundEffect51",
	"SoundEffect52",
	"SoundEffect53",
	"SoundEffect54",
	"SoundEffect55",
	"SoundEffect56",
	"SoundEffect57",
	"SoundEffect58",
	"SoundEffect59",
	"SoundEffect60",
	"SoundEffect61",
	"SoundEffect62",
	"SoundEffect63",
	"SoundEffect64",
	"SoundEffect65",
	"SoundEffect66",
	"SoundEffect67",
	"SoundEffect68",
	"SoundEffect69",
	"SoundEffect70",
	"SoundEffect71",
	"SoundEffect72",
	"SoundEffect73",
	"SoundEffect74",
	"SoundEffect75",
	"SoundEffect76",
	"SoundEffect77",
]

drum_names = [
	"Drum00",
	"Drum01",
	"Drum02",
	"Drum03",
	"Drum04",
	"Drum05",
	"Drum06",
	"Drum07",
	"Drum08",
	"Drum09",
	"Drum10",
	"Drum11",
	"Drum12",
	"Drum00",
	"Drum00",
	"Drum00",

	"Drum00",
	"Drum06",
	"Drum02",
	"Drum03",
	"Drum04",
	"Drum13",
	"Drum14",
	"Drum15",
	"Drum16",
	"Drum17",
	"Drum18",
	"Drum11",
	"Drum19",
	"Drum00",
	"Drum00",
	"Drum00",

	"Drum00",
	"Drum10",
	"Drum11",
	"Drum03",
	"Drum04",
	"Drum20",
	"Drum21",
	"Drum22",
	"Drum08",
	"Drum09",
	"Drum23",
	"Drum24",
	"Drum25",
	"Drum00",
	"Drum00",
	"Drum00",
]

rom = bytearray(open("baserom.gbc", "rb").read())

# music command names and parameter lists
music_commands = {
	0x00: { "name": "rest",                 "params": [ "lower_nibble_off_by_one" ] },
	0x10: { "name": "note",                 "params": [ "note", "lower_nibble_off_by_one" ] },
	0xb0: { "name": "drum_note",            "params": [ "upper_nibble", "lower_nibble_off_by_one" ] },
	0xd0: { "name": "octave",               "params": [ "octave" ] },
	0xd7: { "name": "drum_speed",           "params": [ "byte" ] },
	0xd8: { "name": "note_type",            "params": [ "byte", "nibbles_unsigned_signed" ] },
	0xda: { "name": "tempo",                "params": [ "word_big_endian" ] },
	0xdb: { "name": "duty_cycle",           "params": [ "byte" ] },
	0xde: { "name": "duty_cycle_pattern",   "params": [ "crumbs" ] },
	0xe0: { "name": "pitch_slide",          "params": [ "byte_off_by_one", "nibbles_octave_note" ] },
	0xe1: { "name": "vibrato",              "params": [ "byte", "nibbles" ] },
	0xe5: { "name": "volume",               "params": [ "nibbles" ] },
	0xef: { "name": "stereo_panning",       "params": [ "nibbles_boolean" ] },
	0xfd: { "name": "sound_loop",           "params": [ "byte", "label" ] },
	0xfe: { "name": "sound_call",           "params": [ "label" ] },
	0xff: { "name": "sound_ret",            "params": [] },

	0xd9: { "name": "transpose",            "params": [ "nibbles" ] },
	0xdc: { "name": "volume_envelope",      "params": [ "nibbles_unsigned_signed" ] },
	0xe3: { "name": "toggle_noise",         "params": [ "byte" ] },
	0xe4: { "name": "force_stereo_panning", "params": [ "nibbles_boolean" ] },
	0xe6: { "name": "pitch_offset",         "params": [ "word_big_endian" ] },
	0xfc: { "name": "sound_jump",           "params": [ "label" ] },

	0x01: { "name": "square_note",          "params": [ "command_byte", "nibbles_unsigned_signed", "word" ] },
	0x02: { "name": "noise_note",           "params": [ "command_byte", "nibbles_unsigned_signed", "byte" ] },
	0xdd: { "name": "pitch_sweep",          "params": [ "nibbles_unsigned_signed" ] },
	0xdf: { "name": "toggle_sfx",           "params": [] },
	0xec: { "name": "sfx_priority_on",      "params": [] },
	0xed: { "name": "sfx_priority_off",     "params": [] },
	0xf0: { "name": "sfx_toggle_noise",     "params": [ "byte" ] },
}

# length in bytes of each type of parameter
param_lengths = {
	"command_byte":            0,
	"note":                    0,
	"upper_nibble":            0,
	"lower_nibble":            0,
	"lower_nibble_off_by_one": 0,
	"octave":                  0,
	"crumbs":                  1,
	"nibbles":                 1,
	"nibbles_boolean":         1,
	"nibbles_binary":          1,
	"nibbles_unsigned_signed": 1,
	"nibbles_octave_note":     1,
	"byte":                    1,
	"byte_off_by_one":         1,
	"word":                    2,
	"word_big_endian":         2,
	"label":                   2,
}

# constants used for note commands
music_notes = {
	0x0: "B_",
	0x1: "C_",
	0x2: "C#",
	0x3: "D_",
	0x4: "D#",
	0x5: "E_",
	0x6: "F_",
	0x7: "F#",
	0x8: "G_",
	0x9: "G#",
	0xa: "A_",
	0xb: "A#",
	0xc: "B_",
}

def get_base_command_id(command_id, channel=1, is_sfx=False):
	# noise
	if command_id < 0xd0 and is_sfx and (channel == 4 or channel == 8):
		return 0x02
	# sound
	elif command_id < 0xd0 and is_sfx:
		return 0x01
	# rest
	elif command_id < 0x10:
		return 0x00
	# drum_note
	elif command_id < 0xd0 and channel == 4:
		return 0xb0
	# note
	elif command_id < 0xd0:
		return 0x10
	# octave
	elif command_id < 0xd8:
		return 0xd0
	# drum_speed
	elif command_id == 0xd8 and (channel == 4 or channel == 8):
		return 0xd7
	else:
		return command_id

def get_bank(address):
	return int(address / 0x4000)

# get absolute pointer stored at an address in the rom
# if bank is None, assumes the pointer refers to the same bank as the bank it is located in
def get_pointer(address, bank=None):
	if bank is None:
		bank = get_bank(address)
	return (rom[address + 1] * 0x100 + rom[address]) % 0x4000 + bank * 0x4000

# return True if the command at address is a loop command
#   and the loop count is 0 (infinite)
#   or if the command is a jump command (effectively the same as infinite loop)
def is_infinite_loop(address):
	return ((rom[address] == 0xfd and rom[address + 1] == 0) or
			(rom[address] == 0xfc))

def make_blob(start, output, end=None, label=None):
	return { "start": start, "output": output, "end": end if end else start, "label": label }

# parse a single channel of a sound
# returns a list of all labels and commands
def dump_channel(start_address, sound_name, channel, prefix="", is_sfx=True, address=None):
	blobs = []
	labels = []
	branches = set()
	if address is None:
		if sound_name == "MewtwoStage" and channel == 2:
			blobs.append(make_blob(0x49052, "; unreferenced\n"))
			branches.add(0x49052)
		blobs.append(make_blob(start_address, "{}{}_Ch{}:\n".format(prefix, sound_name, channel)))
		address = start_address
	while 1:
		if rom[address] == 0xdf:
			is_sfx = not is_sfx
		command_address = address
		command_id = rom[command_address]
		command = music_commands[get_base_command_id(command_id, channel, is_sfx)]
		output = "\t{}".format(command["name"])
		label = None
		address += 1
		# print all params for current command
		for i in range(len(command["params"])):
			param = rom[address]
			param_type = command["params"][i]
			param_length = param_lengths[param_type]
			if param_type == "command_byte":
				output += " {}".format(command_id)
			elif param_type == "note":
				output += " {}".format(music_notes[command_id >> 4])
			elif param_type == "upper_nibble":
				output += " {}".format(command_id >> 4)
			elif param_type == "lower_nibble":
				output += " {}".format(command_id & 0b1111)
			elif param_type == "lower_nibble_off_by_one":
				output += " {}".format((command_id & 0b1111) + 1)
			elif param_type == "octave":
				output += " {}".format(8 - (command_id & 0b1111))
			elif param_type == "crumbs":
				output += " {}, {}, {}, {}".format((param >> 6) & 0b11, (param >> 4) & 0b11, (param >> 2) & 0b11, (param >> 0) & 0b11)
			elif param_type == "nibbles":
				output += " {}, {}".format(param >> 4, param & 0b1111)
			elif param_type == "nibbles_boolean":
				output += " {}, {}".format("TRUE" if param >> 4 else "FALSE", "TRUE" if param & 0b1111 else "FALSE")
			elif param_type == "nibbles_binary":
				output += " %{:04b}, %{:04b}".format(param >> 4, param & 0b1111)
			elif param_type == "nibbles_unsigned_signed":
				output += " {}, {}".format(param >> 4, param & 0b1111 if param & 0b1111 <= 8 else (param & 0b0111) * -1)
			elif param_type == "nibbles_octave_note":
				output += " {}, {}".format(8 - (param >> 4), music_notes[param & 0b1111])
			elif param_type == "byte":
				output += " {}".format(param)
			elif param_type == "byte_off_by_one":
				output += " {}".format(param + 1)
			elif param_type == "word":
				output += " {}".format(param + rom[address + 1] * 0x100)
			elif param_type == "word_big_endian":
				output += " {}".format(param * 0x100 + rom[address + 1])
			elif param_type == "label":
				param = get_pointer(address)
				output += " {:x}".format(param)
				if param == start_address:
					label = "{}{}_Ch{}".format(prefix, sound_name, channel)
				elif sound_name == "HaunterInTheGraveyard":
					label = "{}{}_Ch{}".format(prefix, "GastlyInTheGraveyard", channel)
				else:
					label = "{}{}_branch_{:x}".format(prefix, sound_name, param)
					if command_id == 0xfe and param >= start_address:
						branches.add(param)
					elif param < start_address:
						labels.append({ "address": param, "label": label })
			address += param_length
			if i < len(command["params"]) - 1:
				output += ","
		output += "\n"
		blobs.append(make_blob(command_address, output, address, label))
		if (command_id == 0xff or (is_infinite_loop(command_address) and
			not (is_infinite_loop(address) or rom[address] == 0xff)) or
			(command_id == 0xfe and sound_name == "HaunterInTheGraveyard")):
			blobs.append(make_blob(address, "\n"))
			break
	for branch in branches:
		blobs += dump_channel(start_address, sound_name, channel, prefix, is_sfx, branch)[0]
	return blobs, labels

def dump_sound(header, sound_name, prefix="", is_sfx=True):
	blobs = []
	blobs.append(make_blob(header, "{}{}:\n".format(prefix, sound_name)))
	labels = []
	final_channel = (rom[header] >> 6) + 1
	for i in range(final_channel):
		channel_num = (rom[header] & 0b1111) + 1
		start_address = get_pointer(header + 1)
		if i == 0:
			h = "\tchannel_count {}\n\tchannel {}, {:x}\n".format(final_channel, channel_num, start_address)
		else:
			h = "\tchannel {}, {:x}\n".format(channel_num, start_address)
		label = "{}{}_Ch{}".format(prefix, sound_name, channel_num)
		blobs.append(make_blob(header, h, header + 3, label))
		channel_blobs, channel_labels = dump_channel(start_address, sound_name, channel_num, prefix, is_sfx)
		blobs += channel_blobs
		labels += channel_labels
		header += 3
	blobs.append(make_blob(header, "\n"))
	return blobs, labels

def dump_all_sounds(header_pointer, sound_names, prefix="", is_sfx=True):
	blobs = []
	for sound_name in sound_names:
		header = get_pointer(header_pointer)
		blobs += dump_sound(header, sound_name, prefix, is_sfx)[0]
		header_pointer += 2
	return blobs
 
def fill_gap(start, end):
	output = ""
	for address in range(start, end):
		byte = rom[address]
		if byte == get_base_command_id(byte) and len(music_commands[byte]["params"]) == 0:
			output += "\t{}\n".format(music_commands[byte]["name"])
		else:
			output += "\tdb ${:x}\n".format(rom[address])
	output += "\n"
	return output

def sort_and_filter(blobs, extra_labels=[]):
	blobs.sort(key=lambda b: (b["start"], b["end"], len(b["output"])))
	filtered = []
	added_labels = []
	for label in extra_labels:
		if label["label"] not in added_labels and blobs[0]["start"] <= label["address"] < blobs[-1]["end"]:
			filtered.append(make_blob(label["address"], label["label"] + ":\n"))
			added_labels.append(label["label"])
	for blob, next in zip(blobs, blobs[1:]+[None]):
		if next and blob["start"] == next["start"] and blob["output"] == next["output"]:
			continue
		if blob["label"] is not None:
			label_pos = blob["output"].rfind(" ") + 1
			label_address = int(blob["output"][label_pos:], 16)
			blob["output"] = blob["output"][:label_pos] + blob["label"] + "\n"
			if "_branch_" in blob["label"] and blob["label"] not in added_labels and label_address >= blobs[0]["start"]:
				filtered.append(make_blob(label_address, blob["label"] + ":\n"))
				added_labels.append(blob["label"])
		if next and blob["end"] < next["start"] and get_bank(blob["end"]) == get_bank(next["start"]):
			blob["output"] += fill_gap(blob["end"], next["start"])
		filtered.append(blob)
	filtered.sort(key=lambda b: (b["start"], b["end"], len(b["output"])))
	return filtered

def write_all_sounds_to_file(path, file, blobs):
	import os
	try:
		print("Writing {}...".format(path + file))
		os.makedirs(path, exist_ok=True)
		sound_file = open(path + file, "w")
		for blob in blobs[:-1]:
			sound_file.write(blob["output"])
		sound_file.close()
	except IOError as ex:
		print("Error writing {}".format(path + file))
		print(ex)

def export_all_sounds(path, header_pointer, sound_names, prefix="", is_sfx=True):
	sounds = []
	labels = []
	for sound_name in sound_names:
		header = get_pointer(header_pointer)
		blobs, sound_labels = dump_sound(header, sound_name, prefix, is_sfx)
		sounds.append(blobs)
		labels += sound_labels
		header_pointer += 2
	for blobs, sound_name in zip(sounds, sound_names):
		blobs = sort_and_filter(blobs, labels)
		write_all_sounds_to_file(path, "{}.asm".format(sound_name.lower()), blobs)

def dump_all_songs(bank):
	export_all_sounds("audio/music/", bank * 0x4000 + 0x4ca2 % 0x4000, song_names[bank], "Music_", is_sfx=False)

def dump_all_cries(bank, address):
	blobs = dump_all_sounds(bank * 0x4000 + address % 0x4000, ["{}_Bank{:X}".format(x, bank) for x in cry_names], "Cry_")
	if bank == 0x0f:
		blobs += dump_channel(0x3f48f, "Unused_BankF", 5, "Cry_")[0]
		blobs += dump_channel(0x3f4aa, "Unused_BankF", 6, "Cry_")[0]
		blobs += dump_channel(0x3f4c5, "Unused_BankF", 8, "Cry_")[0]
	elif bank == 0x10:
		blobs += dump_channel(0x4361c, "Unused_Bank10", 5, "Cry_")[0]
		blobs += dump_channel(0x43637, "Unused_Bank10", 6, "Cry_")[0]
		blobs += dump_channel(0x43652, "Unused_Bank10", 8, "Cry_")[0]
	elif bank == 0x11:
		blobs += dump_channel(0x47394, "Unused_Bank11", 5, "Cry_")[0]
		blobs += dump_channel(0x473af, "Unused_Bank11", 6, "Cry_")[0]
		blobs += dump_channel(0x473ca, "Unused_Bank11", 8, "Cry_")[0]
	elif bank == 0x12:
		blobs += dump_channel(0x4acc5, "Unused_Bank12", 5, "Cry_")[0]
		blobs += dump_channel(0x4ace0, "Unused_Bank12", 6, "Cry_")[0]
		blobs += dump_channel(0x4acfb, "Unused_Bank12", 8, "Cry_")[0]
	elif bank == 0x13:
		blobs += dump_channel(0x4efb5, "Unused_Bank13", 5, "Cry_")[0]
		blobs += dump_channel(0x4efd0, "Unused_Bank13", 6, "Cry_")[0]
		blobs += dump_channel(0x4efeb, "Unused_Bank13", 8, "Cry_")[0]
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "cries_{:02x}.asm".format(bank), blobs)

def dump_all_sfx(bank, address):
	blobs = dump_all_sounds(bank * 0x4000 + address % 0x4000, ["{}_Bank{:X}".format(x, bank) for x in sfx_names], "Sfx_")
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "sfx_{:02x}.asm".format(bank), blobs)

def dump_all_drumkits(bank):
	blobs = []
	pointer_table = "Drumkits_Bank{:X}:\n".format(bank)
	pointer_tables = []
	drumkit_pointer = bank * 0x4000 + 0x4ba2 % 0x4000
	for drumkit in range(3):
		pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
		drumkit_table = "Drumkit{}_Bank{:X}:\n".format(drumkit, bank)
		if drumkit == 2:
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
			pointer_table += "\tdw Drumkit{}_Bank{:X}\n".format(drumkit, bank)
		drum_pointer = get_pointer(drumkit_pointer + drumkit * 2)
		for drum in range(16):
			address = get_pointer(drum_pointer + drum * 2)
			drumkit_table += "\tdw {}_Bank{:X}\n".format(drum_names[drumkit * 16 + drum], bank)
			blobs += dump_channel(address, "{}_Bank{:X}".format(drum_names[drumkit * 16 + drum], bank), 4)[0]
		drumkit_table += "\n"
		pointer_tables.append(drumkit_table)
	output = pointer_table + "\n" + "".join(pointer_tables)
	blobs.append(make_blob(drumkit_pointer, output, blobs[0]["start"]))
	for blob in blobs:
		if blob["output"].endswith("_Ch4:\n"):
			blob["output"] = blob["output"][:-6] + ":\n"
	blobs = sort_and_filter(blobs)
	write_all_sounds_to_file("audio/", "drumkits_{:02x}.asm".format(bank), blobs)

if __name__ == "__main__":
	dump_all_songs(0x0f)
	dump_all_songs(0x10)
	dump_all_songs(0x11)
	dump_all_songs(0x12)
	dump_all_songs(0x13)

	dump_all_cries(0x0f, 0x6f63)
	dump_all_cries(0x10, 0x70f0)
	dump_all_cries(0x11, 0x6e68)
	dump_all_cries(0x12, 0x6799)
	dump_all_cries(0x13, 0x6a89)

	dump_all_sfx(0x0f, 0x63ce)
	dump_all_sfx(0x10, 0x655b)
	dump_all_sfx(0x11, 0x62d3)
	dump_all_sfx(0x12, 0x5c04)
	dump_all_sfx(0x13, 0x5ef4)

	dump_all_drumkits(0x0f)
	dump_all_drumkits(0x10)
	dump_all_drumkits(0x11)
	dump_all_drumkits(0x12)
	dump_all_drumkits(0x13)
