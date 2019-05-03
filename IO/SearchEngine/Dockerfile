FROM swift:5.0.1

WORKDIR /app

COPY . .

RUN apt-get update && apt-get install curl

RUN curl -Lo corpus.tar.gz https://www.googleapis.com/storage/v1/b/searchengine/o/corpus.tar.gz?alt=media && tar -xzf corpus.tar.gz

RUN swift build -c release -Xswiftc -O -Xswiftc -whole-module-optimization

CMD [".build/x86_64-unknown-linux/release/SearchEngine"]