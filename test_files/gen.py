text = bytes.fromhex('3243 f6a8 885a 308d 3131 98a2 e037 0734')
cipher128 = bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c')
cipher256 = bytes.fromhex('2b7e 1516 28ae d2a6 abf7 1588 09cf 4f3c 84ab 5732 baa3 910e cc87 208a de53 a1d5')

with open("text", "wb") as f:
	f.write(text)
	
with open("cipher128", "wb") as f:
	f.write(cipher128)
	
with open("cipher256", "wb") as f:
	f.write(cipher256)
