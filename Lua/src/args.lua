local ARGS = {}

local function print_help()
	local out = [[
usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS

This is a 128-bit AES encryptor, decryptor, and hasher implemented in Lua.
This is a part of the AES-Project I created aimed to test the waters with programming languages I want to try, but didn't have any excuse to do so.

optional arguments:
  -?, --help            Prints this help list

One of the following OPERATION-OPTIONS should be selected::
  -e, --encrypt         Encrypt the input file into the output using the key
  -d, --decrypt         Decrypt the input file into the output using the key
  -h, --hash            Hash the input file and output it to the screen (uses pi as a key)

One of the following KEY-OPTIONS should be selected on encryption or decryption::
  -k, --key KEY			Key is text in the terminal
  -f,--file-key KEY		Key is a path to a file

IO-OPTIONS::
  -i, --input FILE 		The input file's path, mandatory for every operation
  -o, --output FILE 	The output file path's, mandatory for encryption and decryption

Mandatory or optional arguments to long options are also mandatory or optional for any corresponding short options.
Report bugs to <usama@derbashi.com>.]]
	print(out)
	os.exit(0)
end

local function print_err(msg)
	local out = [[
usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS
Check out the help manual for more information at ./aes128 -?]]
	print("Error: " .. msg)
	print(out)
	os.exit(-1)
end

local function validate_args()
	local opt = 1 -- encrypt will be a multiple of 2, decrypt 3, and hash 5
	opt = opt * (ARGS["e"] and 2 or 1)
	opt = opt * (ARGS["d"] and 3 or 1)
	opt = opt * (ARGS["h"] and 5 or 1)
	if opt == 2 then ARGS["e"] = nil; ARGS.act = "e"
	elseif opt == 3 then ARGS["d"] = nil; ARGS.act = "d"
	elseif opt == 5 then ARGS["h"] = nil; ARGS.act = "h"
	else print_err("One OPERATION-OPTION should be chosen") end

	if ARGS.act ~= "h" then
		opt = 1 -- key will be a multiple of 2, and file-key 3
		opt = opt * (ARGS["k"] and 2 or 1)
		opt = opt * (ARGS["f"] and 3 or 1)
		if opt == 2 then ARGS.key = "k"
		elseif opt == 3 then ARGS.key = "f"
		else print_err("One KEY-OPTION should be assinged") end
	end

	if not ARGS["i"] then print_err("Input Missing") end

	if not ARGS["o"] and ARGS.act ~= "h" then print_err("Output Missing") end
end

local function parse(args)
	local taken_flag = false

	for i = 1, #args do
		if taken_flag then taken_flag = false else
			local current = args[i]
			if current == "-e" or current == "--encrypt" then ARGS["e"] = true
			elseif current == "-d" or current == "--decrypt" then ARGS["d"] = true
			elseif current == "-h" or current == "--hash" then ARGS["h"] = true
			elseif current == "-k" or current == "--key" then taken_flag = true; ARGS["k"] = args[i+1]
			elseif current == "-f" or current == "--file-key" then taken_flag = true; ARGS["f"] = args[i+1]
			elseif current == "-i" or current == "--input" then taken_flag = true; ARGS["i"] = args[i+1]
			elseif current == "-o" or current == "--output" then taken_flag = true; ARGS["o"] = args[i+1]
			elseif current == "-?" or current == "--help" then print_help()
			else print_err(current .. " is an unknown key") end
		end
	end
	validate_args()
end

return {
	args = ARGS,
	parse = parse
}
