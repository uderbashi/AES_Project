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

local function hash()

end

local function encrypt()

end

local function decrypt()

end
-- return statement
return {
	hash = hash,
	encrypt = encrypt,
	decrypt = decrypt
}
