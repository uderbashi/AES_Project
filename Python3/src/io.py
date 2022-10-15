from os.path import getsize
from src.aes import init_keys
from sys import exit

class io_t:
	'''
	Will include file pointers to input and output and the key
	'''
	pass

def load_io(args):
	io = io_t()
	try:
		io.input = open(args.i, 'rb')
		io.input_size = getsize(args.i)
		if args.hash:
			io.output = None
			key = bytearray.fromhex("3141 5926 5358 9793 2384 6264 3383 2795")
			key = [x for x in key]

		else: #if not args.hash
			io.output = open(args.o, 'wb')

			if args.file_key is not None:
				with open(args.file_key, 'rb') as fk:
					key = fk.read(16)
				key = [x for x in key]
			else: # if args.key is not None
				key = [ord(x) for x in args.key]
	except:
		print("Issues with files")
		exit(-1)

	io.keys = init_keys(key)
	return io

def unload_io(io):
	io.input.close()
	if io.output is not None:
		io.output.close()


def read_block(io_file):
	block = [x for x in io_file.read(16)]
	l = len(block)

	if l < 15:
		block += [0 for i in range(16 - l - 1)]
		block += [16 - l]
	elif l == 15:
		block += [0]

	return block, l

def all_zeroes(block):
	pad = block[-1]
	if pad < 16 and pad > 1:
		return all(x == 0 for x in block[-pad:15])

	if pad == 17:
		return all(x == 0 for x in block[:15])

	return False
