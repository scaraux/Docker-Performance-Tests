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
    sha = hashlib.sha256(DATA + str(nonce).encode())

    dsha = hashlib.sha256()
    sha.hexdigest()
    dsha.update(sha.digest())
    return dsha.hexdigest()

if __name__ == "__main__":
    start = timer()

    target = 0x0000FFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
    # target = 0x0000112FFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
    nonce = 0
    final_hash = proof_of_work(nonce)

    stop_threads = False
    thread = Thread(target = cpu_usage, args =(lambda : stop_threads, ))
    thread.start()

    while (int(final_hash, 16) > int(target)):
        nonce += 1
        final_hash = proof_of_work(nonce)

    end = timer()
    stop_threads = True
    print('Final hash:', final_hash)
    print('Time elapsed:', timedelta(seconds=end-start))
