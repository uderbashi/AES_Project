#ifndef _AES_H_
#define _AES_H_

#include <stdint.h>
#include <stdio.h>

typedef struct {
	uint8_t *round_keys;
	uint8_t length;
} aes_t;

aes_t init_aes(uint8_t *key);
void encrypt(aes_t keys, FILE *input, char *out_path);
void decrypt(aes_t keys, FILE *input, char *out_path);
void hash(aes_t keys, FILE *input);

#endif
