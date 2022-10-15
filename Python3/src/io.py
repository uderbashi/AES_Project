class io_t:
	'''
	Will include file pointers to input and output and the key
	'''
	pass

def load_io(args):
	io = io_t()
	try:
		io.input = open(args.i, 'rb')
		if not args.hash:
			io.output = open(args.o, 'wb')

		if args.file_key is not None:
			with open(args.file_key, 'rb') as fk:
				key = fk.read(16)
			io.key = [x for x in key]
		else: # if args.key is not None
			io.key = [ord(x) for x in args.key]


	except:
		print("Issues with files")
