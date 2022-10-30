public class AESKeys {
	private AESMatrix[] keys;

	public AESKeys(byte[] key) {
		expandKey(key);
	}

	public AESMatrix get(int i) {
		return new AESMatrix(keys[i]);
	}

	private static final byte[] RCON = {
		0x01, (byte)0x02, (byte)0x04, (byte)0x08, (byte)0x10, (byte)0x20, (byte)0x40, (byte)0x80, (byte)0x1b, (byte)0x36
	};

	private void expandKey(byte[] key) {
		keys = new AESMatrix[11];
		keys[0] = new AESMatrix(key);

		for(int i = 0; i < 10; ++i) {
			keys[i+1] = genKey(keys[i], i);
		}
	}

	private AESMatrix genKey(AESMatrix previousKey, int rconN) {
		byte[] previousWord = new byte[4];
		byte[] newKey = new byte[16];

		// Apply rotation, and substitution on previous word with rcon xor
		previousWord[0] = previousKey.get(13);
		previousWord[1] = previousKey.get(14);
		previousWord[2] = previousKey.get(15);
		previousWord[3] = previousKey.get(12);
		AESMatrix.subByteArr(previousWord);
		previousWord[0] ^= RCON[rconN];

		for(int i = 0; i < 4; i++) {
			if(i != 0) {
				System.arraycopy(newKey, 4*(i-1), previousWord, 0, 4);
			}

			for(int j = 0; j < 4; ++j) {
				newKey[4 * i + j] = (byte)(previousWord[j] ^ previousKey.get(4 * i + j));
			}
		}

		return new AESMatrix(newKey);
	}
}
