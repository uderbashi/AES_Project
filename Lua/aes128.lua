#!/usr/bin/env lua
function main ()
	local aes = require("src/aes")
	local aes_io = require("src/aes_io")
	local args = require("src/args")

	args.parse(arg)
	args = args.args
	aes_io.load_io(args)
	if args.act == "e" then aes.encrypt(aes_io)
	elseif args.act == "d" then aes.decrypt(aes_io)
	else aes.hash(aes_io) end

	aes_io.unload_io()

	return 0
end
main()
