local AESMatrix = {
	matrix = {
		{0,0,0,0},
		{0,0,0,0},
		{0,0,0,0},
		{0,0,0,0}
	},
	SBOX = {
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
	},
	RSBOX = {
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
	}
}

-- Creation and utility

function AESMatrix:new()
	local new = {
		matrix = { -- reinit matrix to make it as distinct object
			{0,0,0,0},
			{0,0,0,0},
			{0,0,0,0},
			{0,0,0,0}
		}
	}
	setmetatable(new, self)
	self.__index = self
	return new
end

function AESMatrix:__tostring()
	local out = "\n===============\n"
	for i = 1, 4 do
		out = out .. "| "
		for j = 1, 4 do
			out = out .. string.format("%02x ", self.matrix[i][j])
		end
		out = out .. "|\n"
	end
	out = out .. "===============\n"
	return out
end

function AESMatrix:from_bytes(bytes)
	assert(#bytes == 16)
	local i = 1
	local j = 1
	for char in string.gmatch(bytes, ".") do
		self.matrix[i][j] = string.byte(char)
		i = i + 1
		if i > 4 then
			i = 1
			j = j + 1
		end
	end
end

function AESMatrix:to_bytes()
	local out = ""
	for j = 1, 4 do
		for i = 1, 4 do
			out = out .. string.char(self.matrix[i][j])
		end
	end
	return out
end

function AESMatrix:get(n)
	local i = n % 4
	if i == 0 then i = 4 end
	local j = math.ceil(n / 4)
	return self.matrix[i][j]
end

function AESMatrix:set(n, val)
	local i = n % 4
	if i == 0 then i = 4 end
	local j = math.ceil(n / 4)
	self.matrix[i][j] = val
end


-- Sub Bytes

local function sub_byte_arr_with(arr, sub_box)
	for k, v in ipairs(arr) do
		arr[k] = sub_box[v+1]
	end
end

function AESMatrix.sub_byte_arr(arr)
	sub_byte_arr_with(arr, AESMatrix.SBOX)
end

function AESMatrix.rsub_byte_arr(arr)
	sub_byte_arr_with(arr, AESMatrix.RSBOX)
end

function AESMatrix:sub_bytes()
	for i = 1, 4 do
		AESMatrix.sub_byte_arr(self.matrix[i])
	end
end

function AESMatrix:rsub_bytes()
	for i = 1, 4 do
		AESMatrix.rsub_byte_arr(self.matrix[i])
	end
end

-- Shift Rows

-- offset -3, -2, -1, 1, 2, 3
function AESMatrix:shift_row(row, offset)
	local temp_row = {}
	local pos = offset > 0 and offset or 4 + offset
	-- copies the latter part of the row to the 1st position,
	-- and the early part of the row next
	table.move(self.matrix[row], pos+1, 4, 1, temp_row)
	table.move(self.matrix[row], 1, pos, 4-pos+1, temp_row)
	self.matrix[row] = temp_row
end

function AESMatrix:shift_rows()
	self:shift_row(2, 1)
	self:shift_row(3, 2)
	self:shift_row(4, 3)
end

function AESMatrix:rshift_rows()
	self:shift_row(2, -1)
	self:shift_row(3, -2)
	self:shift_row(4, -3)
end

-- Mix columns (The Design of Rijndael - Sec 4.1)
local function xtime(n)
	if n & 0x80 ~= 0x00 then -- so it won't overflow upon shift
		return ((n << 1) ~ 0x1B) & 0xFF -- added the &0xFF to limit it to 8bit
	end
	return n << 1
end

local function mix_column(col)
	local t = col[1] ~ col[2] ~ col[3] ~ col[4]

	local new_col = {}
	new_col[1] = col[1] ~ t ~ xtime(col[1] ~ col[2])
	new_col[2] = col[2] ~ t ~ xtime(col[2] ~ col[3])
	new_col[3] = col[3] ~ t ~ xtime(col[3] ~ col[4])
	new_col[4] = col[4] ~ t ~ xtime(col[4] ~ col[1])

	return new_col
end

local function rmix_column(col)
	local u = xtime(xtime(col[1] ~ col[3]))
	local v = xtime(xtime(col[2] ~ col[4]))

	local new_col = {}
	new_col[1] = col[1] ~ u
	new_col[2] = col[2] ~ v
	new_col[3] = col[3] ~ u
	new_col[4] = col[4] ~ v

	return new_col
end

function AESMatrix:mix_columns()
	for i = 1, 4 do
		local col = {}
		for j = 1, 4 do
			col[j] = self.matrix[j][i]
		end
		col = mix_column(col)
		for j = 1, 4 do
			self.matrix[j][i] = col[j]
		end
	end
end

function AESMatrix:rmix_columns()
	for i = 1, 4 do
		local col = {}
		for j = 1, 4 do
			col[j] = self.matrix[j][i]
		end
		col = rmix_column(col)
		col = mix_column(col)
		for j = 1, 4 do
			self.matrix[j][i] = col[j]
		end
	end
end


-- XOR and round keys

function AESMatrix:xor_matrix(matrix)
	assert(#matrix == 4)
	for i = 1, 4 do assert(#matrix[i] == 4) end

	for i = 1, 4 do
		for j = 1, 4 do
			self.matrix[i][j] = self.matrix[i][j] ~ matrix[i][j]
		end
	end
end

function AESMatrix:xor_aes_matrix(aes_matrix)
	self:xor_matrix(aes_matrix.matrix)
end

function AESMatrix:add_round_key(round_key)
	self:xor_aes_matrix(round_key)
end


-- Return statment
return AESMatrix
