import java.util.HashMap;

public class AES {
	public static void main(String cliArgs[]) {
		HashMap<String, String> args = Args.parse(cliArgs);
		System.out.println(args);
		HashMap<String, Object> io = IO.loadIO(args);
		System.out.println(io);
		IO.unloadIO(io);
	};
}
