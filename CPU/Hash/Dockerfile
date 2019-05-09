FROM python:3.7

ADD requirements.txt /
ADD repeat_hash.py /
ADD data.txt /
ADD hash_crypto.py /

RUN pip install -r requirements.txt

CMD [ "python", "/hash_crypto.py"]