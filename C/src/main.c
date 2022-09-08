#include <stdio.h>

#include "aes.h"
#include "args.h"

void print_matrix(uint8_t *state){
	for (int i = 0; i < 4; ++i) {
		for(int j = 0; j < 4; j++){
			printf("%x ", state[j*4+i]);
		}
		printf("\n");
	}
	printf("----------------------\n");
}

int main(int argc, char *argv[]){
	arguments_t arguments = argument_parser(argc, argv);
	
	uint8_t key[16] = {
		0x2b,0x7e ,0x15,0x16 ,0x28,0xae ,0xd2,0xa6 ,0xab,0xf7 ,0x15,0x88 ,0x09,0xcf ,0x4f,0x3c
	};
	uint8_t state[16] = {
		0x32,0x43 ,0xf6,0xa8 ,0x88,0x5a ,0x30,0x8d ,0x31,0x31 ,0x98,0xa2 ,0xe0,0x37 ,0x07,0x34
	};
	
	aes_t keys = init_aes(key);
	encrypt_block(keys, state);
	print_matrix(state);
	decrypt_block(keys, state);
	print_matrix(state);
	clear_aes(keys);

    return 0;
}
