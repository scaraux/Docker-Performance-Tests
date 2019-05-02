from debian:latest

RUN apt-get update
RUN apt-get -y install python-pip
RUN pip install speedtest-cli

CMD ["speedtest-cli", "--server", " 13654"]