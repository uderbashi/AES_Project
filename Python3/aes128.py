from src.args import parse
from src import aes
from src import io

def main():
	args = parse()
	io.load_io(args)

if __name__ == "__main__":
	main()
