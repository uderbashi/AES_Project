use std::fs::File;
use std::io::Read;
use std::option::Option;
use std::path::Path;

#[derive(Debug)]
pub(crate) struct Args {
	pub key: Vec<u8>,
	pub input: String,
	pub output: String,
	pub op: char,
}
#[derive(Debug)]
struct PreArgs {
	i: Option<String>,
	o: Option<String>,
	e: bool,
	d: bool,
	h: bool,
	f: Option<String>,
	k: Option<String>,
}

impl Args {
	pub fn new(mut key: Vec<u8>, input: String, output: String, op: char) -> Self {
		key.resize(16, 0);

		if !Path::new(&input).is_file() {
			print_err(format!("input file doesn't exist!"));
		}

		if op != 'h' {
			let out = Path::new(&output).parent().unwrap();
			if out != Path::new("") && !out.exists() {
				print_err(format!("output path doesn't exist!"));
			}
		}

		Args {
			key,
			input,
			output,
			op
		}
	}
}

pub(crate) fn parse() -> Args {
	let mut pre_args = PreArgs{i:None, o:None, e:false, d:false, h:false, f:None, k:None};
	let mut iter = std::env::args().skip(1).peekable();
	while let Some(arg) = iter.next() {
		match arg.as_str() {
			"-i" | "--input" => pre_args.i = iter.next(),
			"-o" | "--output" => pre_args.o = iter.next(),
			"-e" | "--encrypt" => pre_args.e = true,
			"-d" | "--decrypt" => pre_args.d = true,
			"-h" | "--hash" => pre_args.h = true,
			"-f" | "--file-key" => pre_args.f = iter.next(),
			"-k" | "--key" => pre_args.k = iter.next(),
			"-?" | "--help" => print_help(),
			_ => print_err(format!("Unrecognised Option \"{arg}\""))
		};
	}
	check_parsed(pre_args)
}

fn check_parsed(pre_args: PreArgs) -> Args {
	let mut flag = 1; // mutual exclusion flag

	flag *= if pre_args.e {2} else {1};
	flag *= if pre_args.d {3} else {1};
	flag *= if pre_args.h {5} else {1};
	let op = match flag {
		2 => 'e',
		3 => 'd',
		5 => 'h',
		_ => {print_err(format!("One OPERATION-OPTION should be chosen")); '!'}
	};

	let key: Vec<u8> = if op == 'h' {
		// the key shall be pi in hex
		vec![0x31, 0x41, 0x59, 0x26, 0x53, 0x58, 0x97, 0x93, 0x23, 0x84, 0x62, 0x64, 0x33, 0x83, 0x27, 0x95]
	} else {
		flag = 1;
		flag *= if pre_args.k != None {2} else {1};
		flag *= if pre_args.f != None {3} else {1};
		match flag {
			2 => pre_args.k.unwrap().into_bytes(),
			3 => {
				let fname = pre_args.f.unwrap();
				let fkey = File::open(&fname);
				if fkey.is_err(){
					print_err(format!("{} is not a file!", fname));
				}
				let mut u8key: [u8; 16] = [0; 16];
				if fkey.unwrap().read(&mut u8key[..]).is_err() {
					print_err(format!("While reading key"))
				};
				u8key.to_vec()
			},
			_ => {print_err(format!("One KEY-OPTION should be assinged")); vec![0]}
		}
	};

	let input = match pre_args.i {
		Some(i) => i,
		None => {print_err(format!("input file missing")); format!("")}
	};


	let output = match pre_args.o {
		Some(o) => o,
		None => {if op != 'h' {print_err(format!("output file missing"));} format!("")}
	};

	Args::new(key, input, output, op)
}

fn print_help() {
	let help = "usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS

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
Report bugs to <usama@derbashi.com>.";
	println!("{}", help);
	std::process::exit(0);
}

fn print_err(error: String) {
	let help = "usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS
Check out the help manual for more information at ./aes128 -?";
	println!("Error: {}", error);
	println!("{}", help);
	std::process::exit(-1);

}
