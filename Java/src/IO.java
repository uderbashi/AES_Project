import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HexFormat;

public class IO {
	public static HashMap<String, Object> load_io(HashMap<String, String> args) {
		HashMap<String, Object> io = new HashMap<String, Object>();

		try {

			io.put("input", new FileInputStream(args.get("i")));
		} catch (FileNotFoundException e) {
			System.out.println("Error: " + args.get("i") + " could not be opened");
			System.exit(-1);
		}

		if(args.get("act") == "h") {
			String pi = "31415926535897932384626433832795";
			io.put("key", HexFormat.of().parseHex(pi));
			//System.out.println(HexFormat.ofDelimiter(" ").formatHex((byte[]) io.get("key")));
			//System.out.println(((byte[]) io.get("key")).length);
		} else {
			try {
				io.put("output", new FileOutputStream(args.get("o")));
			} catch (FileNotFoundException e) {
				System.out.println("Error: " + args.get("o") + " could not be opened");
				System.exit(-1);
			}

			byte[] key = new byte[16];
			if(args.get("key") == "f") {
				try {
					FileInputStream key_reader = new FileInputStream(args.get("f"));
					int read = key_reader.read(key);
					key_reader.close();
				} catch (FileNotFoundException e) {
					System.out.println("Error: " + args.get("f") + " could not be opened");
					System.exit(-1);
				} catch (Exception e) {
					System.out.println("Error: Exception " + e + " caught");
					System.exit(-1);
				}
			} else {
				String key_s = args.get("k");
				key_s = key_s.substring(0, Math.min(key_s.length(), 16));
				try {
					key = key_s.getBytes("US-ASCII");
				} catch (Exception e) { // US ASCI shuls be implemented according to docs, so this shouldnt be an issue
					System.out.println("Error: Exception " + e + " caught");
					System.exit(-1);
				}
				key = Arrays.copyOf(key, 16);
			}
			io.put("key", key);
		}
		io.put("i_size", (new File(args.get("i"))).length());
		return io;
	};

	public static void unload_io(HashMap<String, Object> io) {
		try {
			((FileInputStream) io.get("input")).close();
			((FileOutputStream) io.get("output")).close();
		} catch(Exception e) {
			System.out.println("Error: Exception " + e + " caught");
			System.exit(-1);
		}

	};
}
