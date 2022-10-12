import argparse
import sys

def not_hash():
	return {'-h', '--hash'}.isdisjoint(set(sys.argv))

def parse():
	des = """This is a 128-bit AES encryptor, decryptor, and hasher implemented in Python3.
	This is a part of the AES-Project I created aimed to test the waters with programming languages I want to try, but didn't have any excuse to do so."""

	epi = """Mandatory or optional arguments to long options are also mandatory or optional for any corresponding short options.
	Report bugs to <usama@derbashi.com>."""

	parser = argparse.ArgumentParser(description=des, epilog=epi, add_help=False)

	o_group = parser.add_argument_group('One of the following OPERATION-OPTIONS should be selcted:')
	o_mutex = o_group.add_mutually_exclusive_group(required=True)
	o_mutex.add_argument('-e', '--encrypt', action='store_true', help="Encrypt the input file into the output using the key")
	o_mutex.add_argument('-d', '--decrypt', action='store_true', help="Decrypt the input file into the output using the key")
	o_mutex.add_argument('-h', '--hash', action='store_true', help="Hash the input file and output it to the screen (uses pi as a key)")

	k_group = parser.add_argument_group('One of the following KEY-OPTIONS should be selected on encryption or decryption:')
	k_mutex = k_group.add_mutually_exclusive_group(required=not_hash())
	k_mutex.add_argument('-k', '--key', type=str, help='Key given in the terminal')
	k_mutex.add_argument('-f', '--file-key', type=str, help='Key is given as a file')

	io_group = parser.add_argument_group('IO-OPTIONS:')
	io_group.add_argument('-i', metavar='input', required=True, type=str, help="The input file's path, mandatory for every operation")
	io_group.add_argument('-o', metavar='output', required=not_hash(), type=str, help="The output file path's, mandatory for encryption and decryption")

	parser.add_argument('-?', '--help', action='help', help='Give this help list')
	return parser.parse_args()
