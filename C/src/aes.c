#include <stdlib.h>

#include "aes.h"

/*
** Defining constants
*/

static const uint8_t sbox[256] = {
0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16 
};

static const uint8_t rsbox[256] = {
0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
};

static const uint8_t rcon[10] = {
0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
};

/*
** Defining static functions 
*/

uint8_t *expand_key(uint8_t *key, uint8_t length);
void gen_key(uint8_t *current, uint8_t *previous, int rcon_n);
void sub_bytes(uint8_t *bytes, int length);
void rsub_bytes(uint8_t *bytes, int length);
void shift_row(uint8_t *state, int row_n, int offset);
void shift_rows(uint8_t *state);
void rshift_rows(uint8_t *state);
uint8_t xtime(uint8_t n);
void mix_column(uint8_t *col);
void rmix_column(uint8_t *col);
void mix_columns(uint8_t *state);
void rmix_columns(uint8_t *state);
void add_round_key(uint8_t *state, uint8_t *round_key);
/*
** Implementing public functions
*/
aes_t init_aes(uint8_t *key) {
	aes_t keys;
	
	keys.key = key;
	keys.length = 10;
	keys.round_keys = expand_key(key, keys.length);
	
	return keys;
}

void clear_aes(aes_t keys) {
	free(keys.round_keys);
}

void encrypt_block(aes_t keys, uint8_t *state) {
	int i;
	add_round_key(state, keys.key);
	
	for(i = 0; i < keys.length - 1; i++) {
		sub_bytes(state, 16);
		shift_rows(state);
		mix_columns(state);
		add_round_key(state, keys.round_keys + 16 * i);
	}
	
	sub_bytes(state, 16);
	shift_rows(state);
	add_round_key(state, keys.round_keys + 16 * i);
}

void decrypt_block(aes_t keys, uint8_t *state) {
	int i = keys.length - 1;
	
	add_round_key(state, keys.round_keys + 16 * i);
	rshift_rows(state);
	rsub_bytes(state, 16);
	
	for(--i; i >= 0; --i) {
		add_round_key(state, keys.round_keys + 16 * i);
		rmix_columns(state);
		rshift_rows(state);
		rsub_bytes(state, 16);
	}
	
	add_round_key(state, keys.key);
}

/*
** Implementing static functions
*/

uint8_t *expand_key(uint8_t *key, uint8_t length) {
	int i;
	size_t key_size = sizeof(uint8_t) * 16;
	uint8_t *keys = (uint8_t *)malloc(key_size * length);
	
	gen_key(keys, key, 0);
	for(i = 1; i < length; ++i) {
		gen_key(keys + key_size * i, keys + key_size * (i-1), i);
	}
	
	return keys;
}

void gen_key(uint8_t *current_key, uint8_t *previous_key, int rcon_n) {
	uint8_t previous_word[4], early_word[4];
	int i, j;
	
	// Apply rotation, and substitution on previous word with rcon xor
	previous_word[0] = previous_key[13];
	previous_word[1] = previous_key[14];
	previous_word[2] = previous_key[15];
	previous_word[3] = previous_key[12];
	sub_bytes(previous_word, 4);
	previous_word[0] ^= rcon[rcon_n];
	
	for(i = 0; i < 4; i++) {
		for(j = 0; j < 4; ++j) {
			if(i != 0) {
				previous_word[j] = current_key[4 * (i-1) + j];
			}
			early_word[j] = previous_key[4 * i + j];
		}
		
		for(j = 0; j < 4; ++j) {
			current_key[4 * i + j] = previous_word[j] ^ early_word[j];
		}
	}
}

void sub_bytes(uint8_t *bytes, int length) {
	int i;
	for(i = 0; i < length; i++) {
		bytes[i] = sbox[bytes[i]];
	}
}

void rsub_bytes(uint8_t *bytes, int length) {
	int i;
	for(i = 0; i < length; i++) {
		bytes[i] = rsbox[bytes[i]];
	}
}

void shift_row(uint8_t *state, int row_n, int offset) {
	uint8_t new_row[4];
	int i;
	for(i = 0; i < 4; ++i) {
		new_row[i] =  state[4 * ((i + offset) % 4) + row_n];
	}
	for(i = 0; i < 4; ++i) {
		state[4 * i + row_n] = new_row[i];
	}
}

void shift_rows(uint8_t *state) {
	int i;
	for(i = 1; i < 4; ++i) {
		shift_row(state, i, i);
	}
}

void rshift_rows(uint8_t *state) {
	int i;
	for(i = 1; i < 4; ++i) {
		shift_row(state, i, 4 - i);
	}
}

/*
** Basically, if upon multiplication with 2 it overflows, then xor it with a constant 
*/
uint8_t xtime(uint8_t n) {
	if(n & 0x80) {
		return (n << 1) ^ 0x1B;
	}
	return (n << 1);
}

/*
** All the mix column part is thanks to  The Design of Rijndael Sex 4.1
*/
void mix_column(uint8_t *col) {
	uint8_t t = col[0] ^ col[1] ^ col[2] ^ col[3];
    uint8_t u = col[0];
    col[0] ^= t ^ xtime(col[0] ^ col[1]);
    col[1] ^= t ^ xtime(col[1] ^ col[2]);
    col[2] ^= t ^ xtime(col[2] ^ col[3]);
    col[3] ^= t ^ xtime(col[3] ^ u);
}

void rmix_column(uint8_t *col) {
	uint8_t u = xtime(xtime(col[0] ^ col[2]));
	uint8_t v = xtime(xtime(col[1] ^ col[3]));
	col[0] = col[0] ^ u;
	col[1] = col[1] ^ v;
	col[2] = col[2] ^ u;
	col[3] = col[3] ^ v;
}

void mix_columns(uint8_t *state) {
	int i;
	for(i = 0; i < 4; ++i) {
		mix_column(state + (4 * i));
	}
}

void rmix_columns(uint8_t *state) {
	int i;
	for(i = 0; i < 4; ++i) {
		rmix_column(state + (4 * i));
		mix_column(state + (4 * i));
	}
}

void add_round_key(uint8_t *state, uint8_t *round_key) {
	int i;
	for(i = 0; i < 16; ++i) {
		state[i] ^= round_key[i];
	}
}
