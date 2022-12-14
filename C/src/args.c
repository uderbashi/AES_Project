#include "args.h"

/* Argp constants */
const char *argp_program_version = "aes128 V1.0";
const char *argp_program_bug_address = "<usama@derbashi.com>";

/* Parse a single option. */
error_t parse_opt(int key, char *arg, struct argp_state *state) {
	arguments_t *arguments = state->input;

	switch(key) {
		case 'e':
			arguments->encrypt = 1;
			break;

		case 'd':
			arguments->decrypt = 1;
			break;

		case 'h':
			arguments->hash = 1;
			break;

		case 'k':
			arguments->key_file = 0;
			arguments->key = arg;
			break;

		case 'f':
			arguments->key_file = 1;
			arguments->key = arg;
			break;

		case 'i':
			arguments->io_opt *= -1;
			arguments->input = arg;
			break;

		case 'o':
			arguments->io_opt *= 2;
			arguments->output = arg;
			break;

		default:
			return ARGP_ERR_UNKNOWN;
	}
	return 0;
}

arguments_t argument_parser(int argc, char **argv) {

	/* Program documentation. */
	static char doc[] =
	"This is a 128-bit AES encryptor, decryptor, and hasher implemented in C.\n\
This is a part of the AES-Project I created aimed to test the waters with programming languages I want to try, but didn't have any excuse to do so.\n\
";
//\v and lets see where this one comes";

	/* A description of the arguments we accept. */
	static char args_doc[] = "[KEY-OPTIONS...] [IO-OPTIONS...]";

	/* The options we understand. */
	static struct argp_option options[] = {
		{0,0,0,0, "One of the following OPERATION-OPTIONS should be selcted:"},
		{"encrypt", 'e', 0, 0, "Encrypt the input file into the output using the key"},
		{"decrypt", 'd', 0, 0, "Decrypt the input file into the output using the key"},
		{"hash", 'h', 0, 0, "Hash the input file and output it to the screen (uses pi as a key)"},

		{0,0,0,0, "One of the following KEY-OPTIONS should be selected on encryption or decryption:"},
		{"key", 'k', "STRING", 0, "Key given in the terminal"},
		{"file-key", 'f', "FILE", 0, "Key is given as a file"},

		{0,0,0,0, "IO-OPTIONS:"},
		{"input", 'i', "FILE", 0, "The input file's path, mandatory for every operation"},
		{"output", 'o', "FILE", 0, "The output file path's, mandatory for encryption and decryption"},

		{ 0 }// removes the text from being an opt
	};

	/* Our argp parser. */
	static struct argp argp = { options, parse_opt, args_doc, doc };

	arguments_t arguments;

	/* Default values. */
	arguments.encrypt = 0;
	arguments.decrypt = 0;
	arguments.hash = 0;
	arguments.key_file = -1;
	arguments.io_opt = -1;

	/* Parse our arguments; every option seen by parse_opt will be
	reflected in arguments. */
	argp_parse(&argp, argc, argv, 0, 0, &arguments);

	if(arguments.decrypt + arguments.encrypt + arguments.hash != 1) {
		printf("Error: use one and only one operation option.\nUse --help for usage\n");
		exit(-1);
	}

	if(arguments.key_file == -1 && arguments.hash == 0) {
		printf("Error: use a key or key file for encryption and decryption.\nUse --help for usage\n");
		exit(-1);
	}

	if(arguments.io_opt < 0) {
		printf("Error: indicate the input file.\nUse --help for usage\n");
		exit(-1);
	}

	if(arguments.io_opt % 2 != 0 && arguments.hash == 0) {
		printf("Error: indicate an output file for encryption and decryption.\nUse --help for usage\n");
		exit(-1);
	}

	return arguments;
}
