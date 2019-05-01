from timeit import default_timer as timer
from datetime import timedelta
import hashlib

DATA = open('test-data.html').read().encode()

def proof_of_work(nonce):
    sha = hashlib.sha256(DATA + str(nonce).encode())

    dsha = hashlib.sha256()
    sha.hexdigest()
    dsha.update(sha.digest())
    return dsha.hexdigest()

if __name__ == "__main__":
    start = timer()

    target = 0x0000FFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
    nonce = 0
    final_hash = proof_of_work(nonce)
    while (int(final_hash, 16) > int(target)):
        nonce += 1
        final_hash = proof_of_work(nonce)

    end = timer()
    print(final_hash)
    print(timedelta(seconds=end-start))
