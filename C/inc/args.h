#ifndef _ARGS_H_
#define _ARGS_H_

#include <stdlib.h>
#include <argp.h>

/* Used by main to communicate with parse_opt. */
typedef struct{
	int encrypt;
	int decrypt;
	int hash;
	int key_file; // 1 if key file 0 if terminal
	int io_opt; // starts as -1, flips to positive on input, and doubles on output
	
	char *input;
	char *output;
	char *key;
}arguments_t;

error_t parse_opt(int key, char *arg, struct argp_state *state);
arguments_t argument_parser(int argc, char **argv); 

#endif
