from timeit import default_timer as timer
from datetime import timedelta
import hashlib
import psutil
from threading import Thread

DATA = open('data.txt').read().encode()


def cpu_usage(stop):
    i = 0
    total = 0
    while True:
        if stop():
            print('Average CPU use: {0:.2f}%'.format(total / i))
            break
        total += psutil.cpu_percent(interval=1)
        i += 1


def proof_of_work(nonce):
    # Hash the concatenation of the original data and the lucky number
    sha = hashlib.sha256(DATA + str(nonce).encode())
    # Hashing Algorithm
    dsha = hashlib.sha256()
    sha.hexdigest()
    dsha.update(sha.digest())
    # Return the hash value
    return dsha.hexdigest()


if __name__ == "__main__":
    # Start time of the task
    start = timer()
    # Set the value the target (level of difficulty)
    target = 0x0000112FFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
    # Set the "lucky number" to 1
    nonce = 0
    # Hast the data a first time
    final_hash = proof_of_work(nonce)
    # While the hash value is greater than the target's value
    while int(final_hash, 16) > int(target):
        # Increase the lucky number
        nonce += 1
        # Try to find a lower value
        final_hash = proof_of_work(nonce)

    # End time of the task
    end = timer()
    print('Final hash:', final_hash)
    print('Time elapsed:', timedelta(seconds=end-start))
