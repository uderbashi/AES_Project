#include <stdio.h>

#include "args.h"

int main(int argc, char *argv[]){
	arguments_t arguments = argument_parser(argc, argv);
		
	printf("encrypt = %d\n", arguments.encrypt);
	printf("decrypt = %d\n", arguments.decrypt);
	printf("hashing = %d\n", arguments.hash);
	printf("kfiling = %d\n", arguments.key_file);
	printf("io_opts = %d\n", arguments.io_opt);
	
	printf("inp = %s\n", arguments.input);
	printf("out = %s\n", arguments.output);
	printf("key = %s\n", arguments.key);
    return 0;
}
