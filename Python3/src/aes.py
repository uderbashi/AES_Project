'''
Constants of AES algorithm
'''
sbox = [
0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b, 0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
]

rsbox = [
0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38, 0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87, 0x34, 0x8e, 0x43, 0x44, 0xc4, 0xde, 0xe9, 0xcb,
0x54, 0x7b, 0x94, 0x32, 0xa6, 0xc2, 0x23, 0x3d, 0xee, 0x4c, 0x95, 0x0b, 0x42, 0xfa, 0xc3, 0x4e,
0x08, 0x2e, 0xa1, 0x66, 0x28, 0xd9, 0x24, 0xb2, 0x76, 0x5b, 0xa2, 0x49, 0x6d, 0x8b, 0xd1, 0x25,
0x72, 0xf8, 0xf6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xd4, 0xa4, 0x5c, 0xcc, 0x5d, 0x65, 0xb6, 0x92,
0x6c, 0x70, 0x48, 0x50, 0xfd, 0xed, 0xb9, 0xda, 0x5e, 0x15, 0x46, 0x57, 0xa7, 0x8d, 0x9d, 0x84,
0x90, 0xd8, 0xab, 0x00, 0x8c, 0xbc, 0xd3, 0x0a, 0xf7, 0xe4, 0x58, 0x05, 0xb8, 0xb3, 0x45, 0x06,
0xd0, 0x2c, 0x1e, 0x8f, 0xca, 0x3f, 0x0f, 0x02, 0xc1, 0xaf, 0xbd, 0x03, 0x01, 0x13, 0x8a, 0x6b,
0x3a, 0x91, 0x11, 0x41, 0x4f, 0x67, 0xdc, 0xea, 0x97, 0xf2, 0xcf, 0xce, 0xf0, 0xb4, 0xe6, 0x73,
0x96, 0xac, 0x74, 0x22, 0xe7, 0xad, 0x35, 0x85, 0xe2, 0xf9, 0x37, 0xe8, 0x1c, 0x75, 0xdf, 0x6e,
0x47, 0xf1, 0x1a, 0x71, 0x1d, 0x29, 0xc5, 0x89, 0x6f, 0xb7, 0x62, 0x0e, 0xaa, 0x18, 0xbe, 0x1b,
0xfc, 0x56, 0x3e, 0x4b, 0xc6, 0xd2, 0x79, 0x20, 0x9a, 0xdb, 0xc0, 0xfe, 0x78, 0xcd, 0x5a, 0xf4,
0x1f, 0xdd, 0xa8, 0x33, 0x88, 0x07, 0xc7, 0x31, 0xb1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xec, 0x5f,
0x60, 0x51, 0x7f, 0xa9, 0x19, 0xb5, 0x4a, 0x0d, 0x2d, 0xe5, 0x7a, 0x9f, 0x93, 0xc9, 0x9c, 0xef,
0xa0, 0xe0, 0x3b, 0x4d, 0xae, 0x2a, 0xf5, 0xb0, 0xc8, 0xeb, 0xbb, 0x3c, 0x83, 0x53, 0x99, 0x61,
0x17, 0x2b, 0x04, 0x7e, 0xba, 0x77, 0xd6, 0x26, 0xe1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0c, 0x7d
]

rcon = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36]

'''
Utility functions
NOTE: an aes matrix is a 16 uint8 array
'''
def xor_lists(m1, m2):
	'''
	XORs two aes matrices
	'''
	return [x1 ^ x2 for x1, x2 in zip(m1, m2)]

def add_round_key(matrix, round_key):
	return xor_lists(matrix, round_key)

def shift_row(matrix, row_n, offset):
	'''
	recieves an aes matrix and shifts its row_n by offset
	'''
	matrix[row_n], matrix[4+row_n], matrix[8+row_n], matrix[12+row_n] =\
		matrix[4*offset+row_n], matrix[4*((1+offset)%4)+row_n], matrix[4*((2+offset)%4)+row_n], matrix[4*((3+offset)%4)+row_n]

def xtime(n):
	if n & 0x80:
		return ((n << 1) ^ 0x1B) & 0xFF # added the &0xFF to limit it to 8bit
	return n << 1

'''
Key generation functions
'''
def init_keys(key):
	'''
	gets a key as an uint8 array, converts it to an array of ints and expands it
	'''
	if len(key) < 16:
		zeroes = [0 for i in range(16 - len(key))]
		key += zeroes
	elif len(key) > 16:
		key = key[:16]

	keys = [key]
	for rcon_b in rcon:
		keys.append(get_key(keys[-1], rcon_b))

	return keys

def get_key(previous_key, rcon_b):
	'''
	takes the previous key and the rcon byte to generate the next scheduled key
	'''
	new_key = []
	previous_word = previous_key[13:] + [previous_key[12]] #rotation
	previous_word = sub_bytes(previous_word)
	previous_word[0] ^= rcon_b

	for i in range(4):
		if i != 0:
			previous_word = new_key[-4:]
		early_word = previous_key[i*4 : (i+1)*4]

		new_word = [x1 ^ x2 for x1, x2 in zip(previous_word, early_word)]
		new_key += new_word

	return new_key

'''
Encryption functions
'''
def encrypt_block(matrix, keys):
	matrix = add_round_key(matrix, keys[0])

	for i in range(1, len(keys) - 1):
		matrix = sub_bytes(matrix)
		shift_rows(matrix)
		mix_columns(matrix)
		matrix = add_round_key(matrix, keys[i])

	matrix = sub_bytes(matrix)
	shift_rows(matrix)
	return add_round_key(matrix, keys[-1])

def sub_bytes(matrix):
	return [sbox[x] for x in matrix]

def shift_rows(matrix):
	for i in range(1,4):
		shift_row(matrix, i, i)

def mix_column(col):
	'''
	All the mix column part is thanks to The Design of Rijndael - Sec 4.1
	'''
	t = col[0] ^ col[1] ^ col[2] ^ col[3]

	new_col = []
	new_col.append(col[0] ^ t ^ xtime(col[0] ^ col[1]))
	new_col.append(col[1] ^ t ^ xtime(col[1] ^ col[2]))
	new_col.append(col[2] ^ t ^ xtime(col[2] ^ col[3]))
	new_col.append(col[3] ^ t ^ xtime(col[3] ^ col[0]))

	return new_col

def mix_columns(matrix):
	for i in range(4):
		matrix[4*i : 4*(i+1)] = mix_column(matrix[4*i : 4*(i+1)])

'''
Decryption functions
'''
def decrypt_block(matrix, keys):
	matrix = add_round_key(matrix, keys[-1])
	rshift_rows(matrix)
	matrix = rsub_bytes(matrix)

	for i in range(len(keys) - 2, 0, -1):
		matrix = add_round_key(matrix, keys[i])
		rmix_columns(matrix)
		rshift_rows(matrix)
		matrix = rsub_bytes(matrix)

	return add_round_key(matrix, keys[0])

def rsub_bytes(matrix):
	return [rsbox[x] for x in matrix]

def rshift_rows(matrix):
	for i in range(1,4):
		shift_row(matrix, i, 4-i)

def rmix_column(col):
	u = xtime(xtime(col[0] ^ col[2]))
	v = xtime(xtime(col[1] ^ col[3]))

	new_col = []
	new_col.append(col[0] ^ u)
	new_col.append(col[1] ^ v)
	new_col.append(col[2] ^ u)
	new_col.append(col[3] ^ v)

	return new_col

def rmix_columns(matrix):
	for i in range(4):
		matrix[4*i : 4*(i+1)] = mix_column(rmix_column(matrix[4*i : 4*(i+1)]))