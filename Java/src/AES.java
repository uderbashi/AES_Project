import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.HashMap;

public class AES {
	public static void main(String cliArgs[]) {
		HashMap<String, String> args = Args.parse(cliArgs);
		HashMap<String, Object> io = IO.loadIO(args);
		AESKeys keys = new AESKeys((byte[]) io.get("key"));

		switch(args.get("act")) {
			case "e":
				encrypt(io, keys);
				break;
			case "d":
				decrypt(io, keys);
				break;
			case "h":
				hash(io, keys);
				break;
		}
		IO.unloadIO(io);
	};

	/*
	** block functions
	*/
	private static void encryptBlock(AESMatrix matrix, AESKeys keys) {
		matrix.addRoundKey(keys.get(0));

		for(int i = 1; i < 11; i++) {
			matrix.subBytes();
			matrix.shiftRows();
			if(i != 10){
				matrix.mixColumns();
			}
			matrix.addRoundKey(keys.get(i));
		}
	}

	private static void decryptBlock(AESMatrix matrix, AESKeys keys) {
		for(int i = 10; i > 0; i--) {
			matrix.addRoundKey(keys.get(i));
			if(i != 10){
				matrix.rmixColumns();
			}
			matrix.rshiftRows();
			matrix.rsubBytes();
		}

		matrix.addRoundKey(keys.get(0));
	}

	/*
	** Stream functions
	*/
	private static void encrypt(HashMap<String, Object> io, AESKeys keys) {
		byte[] rawMatrix = new byte[16];
		int read = IO.readBlock((FileInputStream) io.get("input"), rawMatrix);

		while(read > 0) {
			AESMatrix matrix = new AESMatrix(rawMatrix);
			encryptBlock(matrix, keys);
			try{
				matrix.writeToDisk((FileOutputStream) io.get("output"));
			} catch(Exception e) {
				System.out.println("Error: could not output the cypher");
				System.exit(-1);
			}
			if(read == 15) {
				rawMatrix = new byte[16]; // make it all zeroes
				rawMatrix[15] = 17;
				read = 16;
				continue;
			}

			read = IO.readBlock((FileInputStream) io.get("input"), rawMatrix);
		}
	}

	private static void decrypt(HashMap<String, Object> io, AESKeys keys) {
		long blocks = (long)io.get("i_size") / 16;
		boolean zeroFlag = false;
		byte[] rawMatrix = new byte[16];
		FileOutputStream output = (FileOutputStream) io.get("output");

		for(int i = 0; i < blocks; ++i) {
			IO.readBlock((FileInputStream) io.get("input"), rawMatrix);
			AESMatrix matrix = new AESMatrix(rawMatrix);
			decryptBlock(matrix, keys);

			try {

				if(i == blocks - 2 && matrix.get(15) == 0) {
					zeroFlag = true;
					matrix.writeToDisk(output, 15);
				} else if(i != blocks - 1) {
					matrix.writeToDisk(output);
				} else if(IO.allZeroes(matrix)) {
					if(matrix.get(15) == 17) {
						if(!zeroFlag) {
							matrix.writeToDisk(output);
						} // else dont write, it's padding
					} else {
						if(zeroFlag) {
							output.write(0x00);
						}
						matrix.writeToDisk(output, 16 - matrix.get(15));
					}
				} else {
					if(zeroFlag) {
						output.write(0x00);
					}
					matrix.writeToDisk(output);
				}

			} catch(Exception e) {
				System.out.println("Error: could not output the plain text");
				System.exit(-1);
			}
		}
	}

	private static void hash(HashMap<String, Object> io, AESKeys keys) {
		AESMatrix out = new AESMatrix();
		byte[] rawMatrix = new byte[16];
		int read = IO.readBlock((FileInputStream) io.get("input"), rawMatrix);

		while(read > 0) {
			AESMatrix matrix = new AESMatrix(rawMatrix);
			encryptBlock(matrix, keys);
			out.addRoundKey(matrix);

			if(read == 15) {
				rawMatrix = new byte[16]; // make it all zeroes
				rawMatrix[15] = 17;
				read = 16;
				continue;
			}

			read = IO.readBlock((FileInputStream) io.get("input"), rawMatrix);
		}

		System.out.println(out.toLineString());
	}
}
