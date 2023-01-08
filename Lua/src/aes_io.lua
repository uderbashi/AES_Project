local AESKeys = require("src/aes_keys")
local IO = {}

local function load_io(args)
	IO.input = assert(io.open(args.i, "rb"), "Error: Invalid input file")
	local key = nil --declaration

	if args.act == "h" then
		-- temp is pi in hex
		local temp = {0x31, 0x41, 0x59, 0x26, 0x53, 0x58, 0x97, 0x93, 0x23, 0x84, 0x62, 0x64, 0x33, 0x83, 0x27, 0x95}
		key = ""
		for _, hex in ipairs(temp) do
			key = key .. string.char(hex)
		end
	else
		IO.output = assert(io.open(args.o, "wb"), "Error: Invalid output file")
		if args.key == "f" then
			local file = assert(io.open(args.f, "rb"))
			key = file:read(16)
			file:close()
		else -- if k
			key = args.k
		end
		if #key ~= 16 then
			for i = #key + 1, 16 do
				key = key .. string.char(0x00)
			end
		end
	end
	IO.keys = AESKeys:new()
	IO.keys:from_bytes(key)
end

local function unload_io()
	IO.input:close()
	if IO.output then IO.output:close() end
end

local function check_pad(matrix)
	local pad = matrix:get(16)
	local start = 0

	if pad > 1 and pad < 16 then
		start = 17 - pad
	elseif pad == 17 then
		start = 1
	else
		return false
	end

	for i = start, 15 do
		if matrix:get(i) ~= 0 then return false end
	end
	return true
end

local function read_block()
	local block = IO.input:read(16)

	if block == nil then return nil, 0 end

	local len = #block --preserve the original length
	if len == 15 then
		block = block .. string.char(0x00)
	elseif len < 15 then
		for i = len, 14 do
			block = block .. string.char(0x00)
		end
		block = block .. string.char(16-len)
	end

	return block, len
end

return {
	io = IO,
	load_io = load_io,
	unload_io = unload_io,
	check_pad = check_pad,
	read_block = read_block
}
