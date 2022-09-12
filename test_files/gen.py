test_files = {

	"text" : bytes.fromhex('3243 f6a8 885a 308d 3131 98a2 e037 0734'),
	"cipher128" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c'),

	"Min1.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1'),
	"Add1.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1e4 25'),
	"Add5.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1e4 2566 6969 ea'),

	"FakePad1.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1e4 2500 0069 04'),
	"FakePad2.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1e4 2566 5369 01'),
	
	"Null1.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f00 84ab 5732 baa3 910e cc87 208a de53 a111'),
	"Null2.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f00 84ab 5732 baa3 910e cc87 208a de53 0003'),
	"NullTrick.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f00 0000 0000 0000 0000 0000 0000 0000 0006'),
	
	"Add5Null.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a100 2566 6969 ea'),
	"Min1Null.test" : bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 00'),
}

for name, content in test_files.items():
	with open(name, "wb") as f:
		f.write(content)
