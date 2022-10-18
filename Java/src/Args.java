import java.util.HashMap;

public class Args {
	public static HashMap<String, String> parse(String cli_args[]) {
		HashMap<String, String> args = new HashMap<String, String>();

		for(int i = 0; i < cli_args.length; ++i) {
			String current = cli_args[i];
			try{
				switch(current) {
					case "-e":
					case "--encrypt":
						args.put("e", "true");
						break;

					case "-d":
					case "--decrypt":
						args.put("d", "true");
						break;

					case "-h":
					case "--hash":
						args.put("h", "true");
						break;

					case "-k":
					case "--key":
						i++;
						args.put("k", cli_args[i]);
						break;

					case "-f":
					case "--file-key":
						i++;
						args.put("f", cli_args[i]);
						break;

					case "-i":
					case "--input":
						i++;
						args.put("i", cli_args[i]);
						break;

					case "-o":
					case "--output":
						i++;
						args.put("o", cli_args[i]);
						break;

					case "-?":
					case "--help":
						print_help();
						break;
					default:
						print_err(current + " is an unknown key");
				}
			} catch (ArrayIndexOutOfBoundsException e) {
				print_err(cli_args[i-1] + " requires an argument");
			}
		}
		validate_args(args);
		return args;
	};

	private static void print_help() {
		String help = """
		usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS

		This is a 128-bit AES encryptor, decryptor, and hasher implemented in Java.
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
		Report bugs to <usama@derbashi.com>.
		""";

		System.out.println(help);
		System.exit(0);
	};

	private static void print_err(String msg) {
		String help = """
		usage: ./aes128 [-?] OPERATION-OPTION KEY-OPTION KEY IO-OPTIONS
		Check out the help manual for more information at ./aes128 -?
		""";

		System.out.println("Error: " + msg);
		System.out.println(help);
		System.exit(-1);
	};

	private static void validate_args(HashMap<String, String> args) {
		int arg_opt = 1; // encrypt will be a multiple of 2, decrypt 3, and hash 5
		arg_opt *= args.get("e") != null ? 2 : 1;
		arg_opt *= args.get("d") != null ? 3 : 1;
		arg_opt *= args.get("h") != null ? 5 : 1;
		if(arg_opt == 2) {
			args.remove("e");
			args.put("act", "e");
		} else if(arg_opt == 3) {
			args.remove("d");
			args.put("act", "d");
		} else if(arg_opt == 5) {
			args.remove("h");
			args.put("act", "h");
		} else {
			print_err("One OPERATION-OPTION should be chosen");
		}

		arg_opt = 1; // key will be a multiple of 2, and file-key 3
		arg_opt *= args.get("k") != null ? 2 : 1;
		arg_opt *= args.get("f") != null ? 3 : 1;
		if(arg_opt == 2) {
			args.put("key", "k");
		} else if(arg_opt == 3) {
			args.put("key", "f");
		} else if(args.get("act") != "h") {
			print_err("One KEY-OPTIONS should be chosen");
		}

		if(args.get("i") == null) {
			print_err("Input Missing");
		}

		if(args.get("o") == null && args.get("act") != "h") {
			print_err("Output missing");
		}
	};
}
