import java.util.HashMap;

public class AES {
	public static void main(String cli_args[]) {
		HashMap<String, String> args = Args.parse(cli_args);
		System.out.println(args);
		HashMap<String, Object> io = IO.load_io(args);
		System.out.println(io);
		IO.unload_io(io);
	};
}
