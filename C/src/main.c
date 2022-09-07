#include <stdio.h>

#include "aes.h"
#include "args.h"

int main(int argc, char *argv[]){
	arguments_t arguments = argument_parser(argc, argv);
	
	uint8_t key[16] = {
		0x2b,0x7e ,0x15,0x16 ,0x28,0xae ,0xd2,0xa6 ,0xab,0xf7 ,0x15,0x88 ,0x09,0xcf ,0x4f,0x3c
	};
	
	aes_t keys = init_aes(key);
	clear_aes(keys);

    return 0;
}
