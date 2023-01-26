mod args;

fn main() {
	let a = args::parse();
	println!("{a:?}");
	//println!("{:?}", args::Args::new("hi".to_string(), "../test_files/text".to_string(), "/world".to_string(), '!'));
}
