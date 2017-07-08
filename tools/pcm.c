#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>
#include <stdint.h>

#include "common.h"

static void usage(void) {
	fprintf(stderr, "Usage: pcm [-h] [-s sample_rate] [-o outfile] infile\n");
}

struct Options {
	char *outfile;
	int sample_rate;
	int help;
};

struct Options Options = {
	.sample_rate = 22050
};

struct Riff {
	char tag[5];
	uint32_t size;
	char wave_tag[5];
	uint8_t *data;
};

struct Chunk {
	char tag[5];
	uint32_t size;
	uint8_t *data;
};

struct Wav {
	uint16_t format;
	uint16_t num_channels;
	uint32_t sample_rate;
	uint32_t data_rate;
	uint16_t sample_width;
	uint16_t bits_per_sample;

	// extensions
	uint16_t extension_size;
	uint16_t valid_bits_per_sample;
	uint32_t channel_mask;

	// results
	int samples_size;
	uint8_t *samples;
};

struct Pcm {
	int size;
	uint8_t *data;
};

#define READ_U16(ptr, i) \
	  ptr[i] << 0 \
	| ptr[i+1] << 8

#define READ_U32(ptr, i) \
	  ptr[i] << 0 \
	| ptr[i+1] << 8 \
	| ptr[i+2] << 16 \
	| ptr[i+3] << 24

enum {
	WAVE_FORMAT_PCM = 1,
};

void read_wav(char *filename, struct Wav *wav) {
	int size = 0;
	uint8_t *data = read_u8(filename, &size);

	struct Riff riff = {0};
	int pos = 0;
	memcpy(riff.tag, &data[pos], 4); pos += 4;
	riff.size = READ_U32(data, pos); pos += 4;
	int riff_end = pos + riff.size;
	memcpy(riff.wave_tag, &data[pos], 4); pos += 4;

	if (strcmp(riff.tag, "RIFF")) {
		fprintf(stderr, "'%s': unknown tag '%s' at 0x%x (expected 'RIFF')\n",
			filename, riff.tag, 4);
		exit(1);
	}

	if (strcmp(riff.wave_tag, "WAVE")) {
		fprintf(stderr, "'%s': unknown tag '%s' at 0x%x (expected 'WAVE')\n",
			filename, riff.wave_tag, 8);
		exit(1);
	}

	while (pos < riff_end) {
		struct Chunk chunk = {0};
		memcpy(chunk.tag, &data[pos], 4); pos += 4;
		chunk.size = READ_U32(data, pos); pos += 4;
		int start_pos = pos;

		if (!strcmp(chunk.tag, "fmt ")) {
			wav->format = READ_U16(data, pos); pos += 2;
			wav->num_channels = READ_U16(data, pos); pos += 2;
			wav->sample_rate = READ_U32(data, pos); pos += 4;
			wav->data_rate = READ_U32(data, pos); pos += 4;
			wav->sample_width = READ_U16(data, pos); pos += 2;
			wav->bits_per_sample = READ_U16(data, pos); pos += 2;

			if (wav->format != WAVE_FORMAT_PCM) {
				/*
				wav->extension_size = READ_U16(data, pos); pos += 2;
				wav->valid_bits_per_sample = READ_U16(data, pos); pos += 2;
				wav->channel_mask = READ_U32(data, pos); pos += 4;
				*/

				fprintf(stderr, "unsupported wave format: 0x%04x\n", wav->format);
				exit(1);
			}

		} else if (!strcmp(chunk.tag, "data")) {
			wav->samples = &data[pos];
			wav->samples_size = chunk.size;
			pos += chunk.size;
		} else {
			pos += chunk.size;
		}

		if (pos != start_pos + (int)chunk.size) {
			fprintf(stderr, "BUG: failed to read '%s' chunk at 0x%x (0x%x/0x%x bytes)\n",
				chunk.tag, start_pos, pos - start_pos, chunk.size - start_pos);
			exit(1);
		}
	}

	if (pos > riff_end) {
		fprintf(stderr, "BUG: read past end of 'RIFF' chunk (0x%x/0x%x bytes)\n",
			pos, riff_end);
	}

	if (pos > size) {
		fprintf(stderr, "BUG: read past end of file (0x%x/0x%x bytes)\n",
			pos, size);
	}

	// only use the first channel
	int sample_distance = wav->sample_width * wav->num_channels;

	// approximate the desired sample rate
	float interval = ((float)wav->sample_rate) / Options.sample_rate;
	if (interval == 0) {
		fprintf(stderr, "input sample rate too low or output sample rate too high (in: %dHz, out: %dHz)\n",
			wav->sample_rate, Options.sample_rate);
		exit(1);
	}

	int num_samples = wav->samples_size / sample_distance;

	int new_samples_size = num_samples / interval;
	uint8_t *new_samples = malloc(new_samples_size);

	int new_num_samples = 0;

	float interval_i = 0;
	int i = 0;
	while (i < num_samples) {
		uint8_t sample = 0;
		int index = i * sample_distance;
		if (wav->sample_width == 1) {
			sample = wav->samples[index];
		} else if (wav->sample_width == 2) {
			sample = wav->samples[index] + (wav->samples[index + 1] << 8);
		} else {
			fprintf(stderr, "unsupported sample width: %d\n", wav->sample_width);
			exit(1);
		}

		new_samples[new_num_samples++] = sample;

		interval_i += interval;
		i = (int)interval_i;
	}

	wav->samples = new_samples;
	wav->samples_size = new_num_samples;

	free(data);
}

void wav_to_pcm(struct Wav *wav, struct Pcm *pcm) {
	pcm->size = wav->samples_size / 8;
	pcm->data = calloc(pcm->size, 1);

	long total = 0;
	for (int i = 0; i < wav->samples_size; i++) {
		total += wav->samples[i];
	}
	float average = (double)total / wav->samples_size;

	for (int i = 0; i < wav->samples_size; i++) {
		int bit = 0;
		if (wav->samples[i] >= average) {
			bit = 1;
		}
		pcm->data[i / 8] |= bit << (7 - (i % 8));
	}
}

int main(int argc, char *argv[]) {
	struct option long_options[] = {
		{"help", no_argument, 0, 'h'},
		{"--sample-rate", required_argument, 0, 's'},
		{0}
	};
	while (1) {
		int opt = getopt_long(argc, argv, "ho:", long_options);
		if (opt == -1) {
			break;
		}
		switch (opt) {
		case 'h':
			Options.help = 1;
			break;
		case 'o':
			Options.outfile = optarg;
			break;
		case 's':
			Options.sample_rate = strtoul(optarg, NULL, 0);
			break;
		default:
			usage();
			exit(1);
			break;
		}
	}
	argc -= optind;
	argv += optind;

	if (Options.help) {
		usage();
		return 0;
	}
	if (argc < 1) {
		usage();
		exit(1);
	}
	char *infile = argv[0];
	struct Wav wav = {0};
	struct Pcm pcm = {0};
	read_wav(infile, &wav);
	wav_to_pcm(&wav, &pcm);
	if (Options.outfile) {
		write_u8(Options.outfile, pcm.data, pcm.size);
	}
}
