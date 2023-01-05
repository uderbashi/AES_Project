local AESKeys = require("src/aes_keys")
local AESMatrix = require("src/aes_matrix")

local function encrypt_matrix(matrix, keys)
	matrix:add_round_key(keys:get(1))
	for i = 2, #keys.keys do
		matrix:sub_bytes()
		matrix:shift_rows()
		if i ~= #keys.keys then matrix:mix_columns() end
		matrix:add_round_key(keys:get(i))
	end
end

local function decrypt_matrix(matrix, keys)
	for i = #keys.keys, 2, -1 do
		matrix:add_round_key(keys:get(i))
		if i ~= #keys.keys then matrix:rmix_columns() end
		matrix:rshift_rows()
		matrix:rsub_bytes()
	end
	matrix:add_round_key(keys:get(1))
end

local function encrypt(aes_io)
	local bytes, len = aes_io.read_block()

	while len > 0 do
		local matrix = AESMatrix:new()
		matrix:from_bytes(bytes)
		encrypt_matrix(matrix, aes_io.io.keys)
		aes_io.io.output:write(matrix:to_bytes())

		if len == 15 then
			bytes = ""
			for i = 1, 15 do bytes = bytes .. string.char(0x00) end
			bytes = bytes .. string.char(0x11) --17
			len = 16
		else
			bytes, len = aes_io.read_block()
		end
	end
end

--[[
	Padding hell explained:
	upon reaching the penultimate block the program sets a flag if the last block is 0
	(in case the padding was 17 long) and doesnt write it till later.
	and it writes the blocks as they go until it gets to the last one.
	It checks the padding pattern using the function and if it held now it has two options:
	one, the padding pattern is 17 (16 zeroes and flag is up), thus it discards it all,
	unless the flag is down then the pattern broke, so it writes all.
	If the pattern was sub 16, and the flag was up, that means the byte was held by mistake so it writes it,
	and then applies the substring adequately.
	Finally if the last block turns out not to be padded we make sure we didn't hold a zero off
	and write the whole thing.
]]
local function decrypt(aes_io)
	local blocks = aes_io.io.input:seek("end") / 16 -- size should be multiple of 16
	aes_io.io.input:seek("set") -- return to start
	local zero_flag = false --gets set when the penultimate block ends with 0

	for i = 1, blocks do
		local bytes, _ = aes_io.read_block()
		local matrix = AESMatrix:new()
		matrix:from_bytes(bytes)
		decrypt_matrix(matrix, aes_io.io.keys)

		-- dealing with padding hell sarts here
		if i == blocks - 1 and matrix.get(16) == 0x00 then
			zero_flag = true
			aes_io.io.output:write(matrix:to_bytes():sub(1,15))

		elseif i ~= blocks then
			aes_io.io.output:write(matrix:to_bytes())

		elseif aes_io.check_pad(matrix) then -- if pad detected
			if matrix.get(16) == 0x11 then
				if not zero_flag then
					aes_io.io.output:write(matrix:to_bytes())
				end -- if the flag was up we would discard the pad
			else
				if zero_flag then aes_io.io.output:write(string.char(0x00)) end
				aes_io.io.output:write(matrix:to_bytes():sub(1, 16 - matrix.get(16)))
			end

		else
			if zero_flag then aes_io.io.output:write(string.char(0x00)) end
			aes_io.io.output:write(matrix:to_bytes())
		end -- end of hell
	end
end

local function hash(aes_io)
	local result = AESMatrix:new()
	local bytes, len = aes_io.read_block()

	while len > 0 do
		local matrix = AESMatrix:new()
		matrix:from_bytes(bytes)
		encrypt_matrix(matrix, aes_io.io.keys)
		result:xor_aes_matrix(matrix)

		if len == 15 then
			bytes = ""
			for i = 1, 15 do bytes = bytes .. string.char(0x00) end
			bytes = bytes .. string.char(0x11) --17
			len = 16
		else
			bytes, len = aes_io.read_block()
		end
	end
	print(result:to_bytes():gsub(".", function(c)
		return string.format("%2x", c:byte())
	end))

end

-- return statement
return {
	hash = hash,
	encrypt = encrypt,
	decrypt = decrypt
}
