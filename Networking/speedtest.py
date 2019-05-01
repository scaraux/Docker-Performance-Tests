import pyspeedtest

st = pyspeedtest.SpeedTest()

ping = st.ping()
download = st.download()
upload = st.upload()

print('ping: ' + str(ping))
print('download: ' + str(download))
print('upload: ' + str(upload))