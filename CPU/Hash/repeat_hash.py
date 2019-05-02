import timeit
from time import time
from hashlib import md5
import mmh3     # http://pypi.python.org/pypi/mmh3/2.0
import smhasher # http://pypi.python.org/pypi/smhasher
import pyhash   # http://code.google.com/p/pyfasthash/
                # need to install previously sudo apt-get install libboost-python-dev

data = open("test-data.html").read().encode()
num = 4000000
repeat_n=1
setup_c="""
from hashlib import md5
import mmh3
import smhasher
#import pyhash
data=open('test-data.html').read().encode()
"""

print("*"*40)
print("md5:",  timeit.repeat(stmt="md5(data).digest()", setup=setup_c, repeat=repeat_n, number=num))
print("mmh3:", timeit.repeat(stmt="mmh3.hash_bytes(data)", setup=setup_c, repeat=repeat_n, number=num))
print("smhasher",  timeit.repeat(stmt="smhasher.murmur3_x64_128(data)", setup=setup_c, repeat=2, number=num))
