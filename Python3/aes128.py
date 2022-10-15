from src.args import parse
from src.aes import encrypt_block, decrypt_block
from src import io as IO

def main():
	args = parse()
	io = IO.load_io(args)

	if args.encrypt:
		encrypt_file(io)
	elif args.decrypt:
		decrypt_file(io)
	else: # args.hash
		hash_file(io)

	IO.unload_io(io)

def encrypt_file(io):
	block, length = IO.read_block(io.input)

	while length > 0:
		block = encrypt_block(block, io.keys)
		io.output.write(bytearray(block))

		if length == 15:
			block = [0 for x in range(15)] + [17]
			length = 16
			continue

		block, length = IO.read_block(io.input)

def decrypt_file(io):
	runs = io.input_size // 16
	flag = False #flag that is raised when the last byte of the penutimate block is 0

	for i in range(runs):
		block, _ = IO.read_block(io.input)
		block = decrypt_block(block, io.keys)

		if i == runs - 2 and block[-1] == 0:
			flag = True
			io.output.write(bytearray(block[:15]))
		elif i != runs - 1:
			io.output.write(bytearray(block))
		elif IO.all_zeroes(block):
			if block[-1] == 17:
				if not flag:
					io.output.write(bytearray(block))
			else:
				if flag:
					io.output.write(bytearray([0]))
				io.output.write(bytearray(block[:-block[-1]]))
		else:
			if flag:
				io.output.write(bytearray([0]))
			io.output.write(bytearray(block))

def hash_file(io):
	out = [0 for x in range(16)]
	block, length = IO.read_block(io.input)

	while length > 0:
		block = encrypt_block(block, io.keys)
		out = [x^y for x,y in zip(out, block)]

		if length == 15:
			block = [0 for x in range(15)] + [17]
			length = 16
			continue

		block, length = IO.read_block(io.input)

	print(bytearray(out).hex())

if __name__ == "__main__":
	main()
