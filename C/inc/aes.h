#ifndef _AES_H_
#define _AES_H_

#include <stdint.h>
#include <stdio.h>

typedef struct {
	uint8_t *round_keys;
	uint8_t length;
} aes_t;

aes_t init_aes(uint8_t *key);
void clear_aes(aes_t keys);

void encrypt_block(aes_t keys, uint8_t *state);
void decrypt_block(aes_t keys, uint8_t *state);
//xors m2 into m1 (size 4*4)
void xor_matrix(uint8_t *m1, uint8_t *m2);

#endif
