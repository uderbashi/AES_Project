#include <stdio.h>
#include <string.h>

#include "aes.h"
#include "args.h"

typedef struct{
	FILE *input;
	FILE *output;
	uint8_t key[16];
	long file_size;
}io_t;

void print_matrix(uint8_t *state);
io_t get_io(arguments_t arguments);
void clear_io(io_t io, arguments_t arguments);
void encrypt(io_t io);
void decrypt(io_t io);
void hash(io_t io);
int read_block(io_t io, uint8_t *state);
int all_zeroes(uint8_t *state, int num);


int main(int argc, char *argv[]){
	arguments_t arguments = argument_parser(argc, argv);
	io_t io = get_io(arguments);
	
	if(arguments.encrypt) {
		encrypt(io);
	} else if(arguments.decrypt) {
		decrypt(io);
	} else {
		hash(io);
	}
	
	clear_io(io, arguments);
    return 0;
}

void print_matrix(uint8_t *state){
	for (int i = 0; i < 4; ++i) {
		for(int j = 0; j < 4; j++){
			printf("%x ", state[j*4+i]);
		}
		printf("\n");
	}
	printf("----------------------\n");
}

io_t get_io(arguments_t arguments) {
	io_t io;
	int i;
	FILE *temp;
	
	io.input = fopen(arguments.input, "r");
	if(io.input == NULL) {
		printf("Error opening input file!\n");
		exit(-1);
	}
	
	if(!arguments.hash) {
		io.output = fopen(arguments.output, "w+");
		if(io.output == NULL) {
			printf("Error opening output file!\n");
			fclose(io.input);
			exit(-1);
		}
		
		if(arguments.key_file) {
			temp = fopen(arguments.key, "r");
			if(temp == NULL) {
				printf("Error opening the key file!\n");
				clear_io(io, arguments);
				exit(-1);
			}
			i = fread(io.key, sizeof(uint8_t), 16, temp);
			fclose(temp);
			if(i < 16) {
				for(; i < 16; ++i) {
					io.key[i] = 0x00;
				}
			}
		} else {
			strncpy((char *)io.key, arguments.key, 16);
		}
	}

	fseek(io.input, 0L, SEEK_END);
	io.file_size = ftell(io.input);
	fseek(io.input, 0L, SEEK_SET);
	return io;
}

void clear_io(io_t io, arguments_t arguments) {
	fclose(io.input);
	if(!arguments.hash) {
		fclose(io.output);
	}
}

void encrypt(io_t io) {
	uint8_t state[16];
	aes_t keys = init_aes(io.key);
	
	while(read_block(io, state)) {
		encrypt_block(keys, state);
		fwrite(state, sizeof(uint8_t), 16, io.output);
	}
	clear_aes(keys);
}

void decrypt(io_t io) {
	int i, flag = 0;
	int blocks = io.file_size / 16;
	uint8_t state[16], temp;
	aes_t keys = init_aes(io.key);
	
	for(i = 0; i < blocks; ++i) {
		if(! read_block(io, state)) {
			printf("Error: soemthing happened seriously wrong\n");
			clear_aes(keys);
			return;
		}
		decrypt_block(keys, state);
		
		if(i+2 < blocks) {
			fwrite(state, sizeof(uint8_t), 16, io.output);
		} else if(i+2 == blocks) { // if it is the one before last block
			if(state[15]) { // if the last byte is not 0x00
				fwrite(state, sizeof(uint8_t), 16, io.output);
			} else {
				flag = 1; // if the next block is all zeroes
				fwrite(state, sizeof(uint8_t), 15, io.output);
			}
		} else { // if it is the last block
			if(flag) { // if there is an unwritten 0x00 byte
				if(state[15] == 17 && all_zeroes(state, 16)) {
					break;
				} else {
					temp = 0x00;
					fwrite(&temp, sizeof(uint8_t), 1, io.output);
				}
			}
			
			if(state[15] < 16 && state[15] > 1 && all_zeroes(state, state[15])) {
				fwrite(state, sizeof(uint8_t), 16 - state[15], io.output);
			} else {
				fwrite(state, sizeof(uint8_t), 16, io.output);
			}
		}
	}
	clear_aes(keys);
}

void hash(io_t io) {
	int i;
	uint8_t state[16], hash[16];
	aes_t keys = init_aes(io.key);
	
	// make sure it is empty
	for(i = 0; i < 16; i++) {
		hash[i] = 0;
	}
	
	while(read_block(io, state)) {
		encrypt_block(keys, state);
		xor_matrix(hash, state);
	}
	
	for(i = 0; i < 16; i++) {
		printf("%02x", hash[i]);
	}
	printf("\n");
	
	clear_aes(keys);
}

int read_block(io_t io, uint8_t *state) {
	int read;
	
	read = fread(state, sizeof(uint8_t), 16, io.input);
	
	if(read == 16) {
		return 1;
	} else if(read != 0 && read < 15) {
		for(; read < 15; ++read) {
			state[read] = 0;
		}
		state[read] = 16 - (io.file_size % 16);
		return 1;
	} else if(read != 0 && read == 15) {
		state[read] = 0;
		return 1;
	} else if(read == 0 && io.file_size % 16 == 15) {
		for(; read < 15; ++read) {
			state[read] = 0;
		}
		state[read] = 17;
		return 1;
	} else {
		return 0;
	}
}

// returns 1 if all the num last digits are 0 else returns 0
int all_zeroes(uint8_t *state, int num) {
	int i;
	
	for(i = 16-num; i < 15; i++) {
		if (i != 0) {
			return 0;
		}
	}
	return 1;
}
