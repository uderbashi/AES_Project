local AESMatrix = require("src/aes_matrix")

AESKeys = {
	keys = {},
	RCON = {
		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36
	};
}

function AESKeys:new()
	local new = {keys = {}}
	setmetatable(new, self)
	self.__index = self
	return new
end

function AESKeys:__tostring()
	local out = "\n======= START KEYS =======\n"
	for _, v in ipairs(self.keys) do
		out = out .. v:__tostring()
	end
	out = out .. "======== END KEYS ========\n"
	return out
end

function AESKeys:from_bytes(bytes)
	self.keys[1] = AESMatrix:new()
	self.keys[1]:from_bytes(bytes)

	for i, v in ipairs(self.RCON) do
		self:gen_key(i, v)
	end
end

function AESKeys:gen_key(key_i, rcon_v)
	local prev_key = self:get(key_i)
	local prev_word = {}
	local new_key = AESMatrix:new()

	-- copy rotated
	prev_word[1] = prev_key:get(14)
	prev_word[2] = prev_key:get(15)
	prev_word[3] = prev_key:get(16)
	prev_word[4] = prev_key:get(13)

	AESMatrix.sub_byte_arr(prev_word)
	prev_word[1] = prev_word[1] ~ rcon_v

	for i = 0, 3 do
		if i ~= 0 then
			for j = 0, 3 do
				prev_word[j+1] = new_key:get((i-1)*4+j+1)
			end
		end

		for j = 0, 3 do
			new_key:set(i*4+j+1, prev_word[j+1] ~ prev_key:get(i*4+j+1))
		end
	end

	self.keys[key_i + 1] = new_key
end

function AESKeys:get(n)
	return self.keys[n]
end


-- return statement
return AESKeys
